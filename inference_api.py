from io import BytesIO
from typing import Dict, Union
import os
import sys
import uuid

import cv2
import numpy as np
import timm
import torch
import torch.nn.functional as F
import torchvision.transforms as transforms
from fastapi import FastAPI, File, HTTPException, UploadFile
from PIL import Image, ImageOps, UnidentifiedImageError

app = FastAPI(title="Plant Disease Inference API")

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODELLER_DIR = os.path.join(BASE_DIR, "modeller")
SAM2_REPO_DIR = os.path.join(MODELLER_DIR, "sam2_repo")
if SAM2_REPO_DIR not in sys.path:
    sys.path.insert(0, SAM2_REPO_DIR)

from sam2.build_sam import build_sam2
from sam2.sam2_image_predictor import SAM2ImagePredictor

DEVICE = (
    "cuda"
    if torch.cuda.is_available()
    else "mps"
    if torch.backends.mps.is_available()
    else "cpu"
)
MODEL_PATH = os.path.join(MODELLER_DIR, "best_plant_model_efficientnet_b3.pth")

SAM2_CHECKPOINT = os.path.join(MODELLER_DIR, "sam2.1_hiera_large.pt")
SAM2_MODEL_CFG = "configs/sam2.1/sam2.1_hiera_l.yaml"
SAM_DEBUG_DIR = os.path.join(MODELLER_DIR, "sam_debug_outputs")

CLASS_NAMES = [
    "Apple___Apple_scab",
    "Apple___Black_rot",
    "Apple___Cedar_apple_rust",
    "Apple___healthy",
    "Cherry_(including_sour)___Powdery_mildew",
    "Cherry_(including_sour)___healthy",
    "Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot",
    "Corn_(maize)___Common_rust_",
    "Corn_(maize)___Northern_Leaf_Blight",
    "Corn_(maize)___healthy",
    "Grape___Black_rot",
    "Grape___Esca_(Black_Measles)",
    "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)",
    "Grape___healthy",
    "Peach___Bacterial_spot",
    "Peach___healthy",
    "Pepper,_bell___Bacterial_spot",
    "Pepper,_bell___healthy",
    "Potato___Early_blight",
    "Potato___Late_blight",
    "Potato___healthy",
    "Strawberry___Leaf_scorch",
    "Strawberry___healthy",
    "Tomato___Bacterial_spot",
    "Tomato___Early_blight",
    "Tomato___Late_blight",
    "Tomato___Leaf_Mold",
    "Tomato___Septoria_leaf_spot",
    "Tomato___Spider_mites Two-spotted_spider_mite",
    "Tomato___Target_Spot",
    "Tomato___Tomato_Yellow_Leaf_Curl_Virus",
    "Tomato___Tomato_mosaic_virus",
    "Tomato___healthy",
]

MODEL = timm.create_model("efficientnet_b3", pretrained=False, num_classes=len(CLASS_NAMES))
MODEL.load_state_dict(torch.load(MODEL_PATH, map_location=DEVICE))
MODEL.to(DEVICE)
MODEL.eval()

print(f"SAM 2.1 loading ({DEVICE})...")
SAM2_MODEL = build_sam2(SAM2_MODEL_CFG, SAM2_CHECKPOINT, device=DEVICE)
SAM_PREDICTOR = SAM2ImagePredictor(SAM2_MODEL)
print("SAM 2.1 loaded.")

PREPROCESS = transforms.Compose(
    [
        transforms.Resize((300, 300)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
    ]
)


def _parse_label(raw_label: str) -> tuple[str, str]:
    if "___" not in raw_label:
        return "Unknown", raw_label.replace("_", " ").strip()

    plant_type, disease = raw_label.split("___", maxsplit=1)
    plant_type_clean = plant_type.replace("_", " ").strip()
    disease_clean = disease.replace("_", " ").strip()
    return plant_type_clean, disease_clean


def _segment_leaf_with_sam(image_array: np.ndarray) -> Union[np.ndarray, None]:
    try:
        h, w = image_array.shape[:2]
        img_rgb = cv2.cvtColor(image_array, cv2.COLOR_BGR2RGB) if len(image_array.shape) == 3 else image_array

        SAM_PREDICTOR.set_image(img_rgb)

        cx, cy = w // 2, h // 2
        offset = min(w, h) // 10

        input_point = np.array(
            [
                [cx, cy],
                [cx + offset, cy],
                [cx - offset, cy],
                [cx, cy + offset],
                [cx, cy - offset],
            ],
            dtype=np.int32,
        )
        input_point[:, 0] = np.clip(input_point[:, 0], 0, max(0, w - 1))
        input_point[:, 1] = np.clip(input_point[:, 1], 0, max(0, h - 1))

        input_label = np.array([1, 1, 1, 1, 1])

        masks, _, _ = SAM_PREDICTOR.predict(
            point_coords=input_point,
            point_labels=input_label,
            multimask_output=False,
        )

        if masks.size == 0:
            return None

        binary_mask = masks[0].astype(np.uint8)

        num_labels, labels, stats, _ = cv2.connectedComponentsWithStats(binary_mask, connectivity=8)

        if num_labels > 1:
            areas = stats[1:, cv2.CC_STAT_AREA]
            largest_label = np.argmax(areas) + 1
            clean_binary_mask = np.zeros_like(binary_mask)
            clean_binary_mask[labels == largest_label] = 1
            binary_mask = clean_binary_mask

        segmented_full = np.zeros_like(img_rgb, dtype=np.uint8)
        segmented_full[binary_mask == 1] = img_rgb[binary_mask == 1]

        coords = np.column_stack(np.where(binary_mask > 0))
        if len(coords) > 0:
            y_min, x_min = coords.min(axis=0)
            y_max, x_max = coords.max(axis=0)
            pad = 20

            y_min = max(0, int(y_min - pad))
            x_min = max(0, int(x_min - pad))
            y_max = min(h, int(y_max + pad))
            x_max = min(w, int(x_max + pad))

            if y_max > y_min and x_max > x_min:
                cropped = segmented_full[y_min:y_max, x_min:x_max]
                if cropped.size > 0 and cropped.shape[0] > 50 and cropped.shape[1] > 50:
                    return cv2.cvtColor(cropped, cv2.COLOR_RGB2BGR)

        return None
    except Exception as exc:
        print(f"SAM 2.1 segmentation error: {exc}")
        return None


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "device": DEVICE}


@app.post("/predict")
async def predict(image: UploadFile = File(...)) -> Dict[str, Union[float, str]]:
    try:
        image_bytes = await image.read()
        if not image_bytes:
            raise HTTPException(status_code=400, detail="Uploaded file is empty.")

        pil_image = Image.open(BytesIO(image_bytes)).convert("RGB")

        # Büyük telefon fotoğraflarını SAM'a vermeden önce küçült.
        # SAM zaten içeride 1024 px'e indiriyor ve sınıflandırıcı girdisi 300x300,
        # bu yüzden yüksek çözünürlük doğruluğa katkı sağlamadan gecikmeyi artırır.
        MAX_SIDE = 1024
        if max(pil_image.size) > MAX_SIDE:
            pil_image.thumbnail((MAX_SIDE, MAX_SIDE), Image.LANCZOS)

        img_cv = cv2.cvtColor(np.array(pil_image), cv2.COLOR_RGB2BGR)

        segmented_img = _segment_leaf_with_sam(img_cv)
        if segmented_img is None:
            segmented_img = img_cv
            pil_image = Image.fromarray(cv2.cvtColor(segmented_img, cv2.COLOR_BGR2RGB))
        else:
            pil_image = Image.fromarray(cv2.cvtColor(segmented_img, cv2.COLOR_BGR2RGB))

            try:
                os.makedirs(SAM_DEBUG_DIR, exist_ok=True)
                debug_filename = f"sam2_{uuid.uuid4().hex}.png"
                debug_path = os.path.join(SAM_DEBUG_DIR, debug_filename)
                pil_image.save(debug_path)
                print(f"SAM debug image saved: {debug_path}")
            except Exception as save_err:
                print(f"SAM debug image save failed: {save_err}")

        max_size = max(pil_image.size)
        pil_image = ImageOps.pad(pil_image, (max_size, max_size), color=(0, 0, 0))

        input_tensor = PREPROCESS(pil_image).unsqueeze(0).to(DEVICE)

        with torch.no_grad():
            outputs = MODEL(input_tensor)
            probabilities = F.softmax(outputs[0], dim=0)

        topk_vals, topk_indices = torch.topk(probabilities, k=3)
        print("Top-3 predictions:")
        for rank, (prob, cls_idx) in enumerate(zip(topk_vals.tolist(), topk_indices.tolist()), start=1):
            cls_name = CLASS_NAMES[cls_idx]
            print(f"  {rank}. {cls_name} -> {prob * 100:.2f}%")

        confidence, idx = torch.max(probabilities, dim=0)
        raw_label = CLASS_NAMES[idx.item()]
        
        tomato_spot_group = {
            "Tomato___Bacterial_spot",
            "Tomato___Early_blight",
            "Tomato___Target_Spot",
            "Tomato___Septoria_leaf_spot"
        }
        if raw_label in tomato_spot_group:
            raw_label = "Tomato___Spot_Disease"
            
        plant_type, disease = _parse_label(raw_label)

        return {
            "label": raw_label,
            "plant_type": plant_type,
            "disease": disease,
            "confidence": float(confidence.item()),
        }
    except UnidentifiedImageError as exc:
        raise HTTPException(status_code=400, detail="Uploaded file must be an image.") from exc
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {exc}") from exc
