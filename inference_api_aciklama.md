# `inference_api.py` — Detaylı Kod Açıklaması

Bu dosya, iki-konteynerli mimarinin **model/çıkarım konteyneri**dir. Mobil uygulamadan
gelen yaprak görüntüsünü alır, **SAM 2.1** ile yaprağı arka plandan ayırır (bölütleme),
ardından **EfficientNet-B3** ile sınıflandırıp sonucu **JSON** olarak döndürür.

**Genel akış:**
Görüntü → (≤1024 px küçült) → SAM 2.1 bölütleme [başarısızsa orijinal] → siyah kare dolgu →
300×300 normalize → EfficientNet-B3 → softmax → (domates leke sınıfı birleştirme) → JSON.

---

## 1. İçe aktarmalar (imports)

```python
from io import BytesIO
import os, sys, uuid
import cv2, numpy as np, timm, torch
import torch.nn.functional as F
import torchvision.transforms as transforms
from fastapi import FastAPI, File, HTTPException, UploadFile
from PIL import Image, ImageOps, UnidentifiedImageError
```

- `cv2` (OpenCV) + `numpy`: görüntü işleme (renk dönüşümü, bağlı bileşen analizi, kırpma).
- `timm`: EfficientNet-B3 modelini oluşturmak için.
- `torch` / `F`: model çıkarımı ve softmax.
- `transforms`: girdi ön-işleme (resize/normalize).
- `fastapi`: HTTP servisi; `UploadFile`/`File` dosya yükleme, `HTTPException` hata yanıtları.
- `PIL`: görüntü açma, kareye doldurma (`ImageOps.pad`), geçersiz görsel yakalama (`UnidentifiedImageError`).

---

## 2. Uygulama + SAM deposu yolu

```python
app = FastAPI(title="Plant Disease Inference API")

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODELLER_DIR = os.path.join(BASE_DIR, "modeller")
SAM2_REPO_DIR = os.path.join(MODELLER_DIR, "sam2_repo")
if SAM2_REPO_DIR not in sys.path:
    sys.path.insert(0, SAM2_REPO_DIR)

from sam2.build_sam import build_sam2
from sam2.sam2_image_predictor import SAM2ImagePredictor
```

- FastAPI uygulamasını başlatır.
- Tüm yolları dosyanın konumuna göre kurar (taşınabilirlik).
- **`sam2_repo`'yu `sys.path`'e ekler** ki `import sam2 ...` çalışsın — bu yüzden `import`
  satırları dosyanın ortasında (yol eklendikten *sonra* import edilmeli).

---

## 3. Cihaz seçimi

```python
DEVICE = ("cuda" if torch.cuda.is_available()
          else "mps" if torch.backends.mps.is_available()
          else "cpu")
```

- Sırayla CUDA (NVIDIA GPU) → MPS (Apple) → **CPU** dener. Cloud Run'da GPU olmadığı için
  pratikte **CPU** seçilir (projenin "CPU-tabanlı" mimarisinin sebebi).

---

## 4. Model yolları ve config

```python
MODEL_PATH = os.path.join(MODELLER_DIR, "best_plant_model_efficientnet_b3.pth")
SAM2_CHECKPOINT = os.path.join(MODELLER_DIR, "sam2.1_hiera_large.pt")
SAM2_MODEL_CFG = "configs/sam2.1/sam2.1_hiera_l.yaml"
SAM_DEBUG_DIR = os.path.join(MODELLER_DIR, "sam_debug_outputs")
```

- Eğitilmiş sınıflandırıcı ağırlıkları (`.pth`), SAM 2.1 büyük model ağırlığı (`hiera_large`)
  ve yapılandırma dosyası. `SAM_DEBUG_DIR`: bölütleme çıktılarının kaydedildiği
  hata-ayıklama klasörü.

---

## 5. Sınıf listesi

```python
CLASS_NAMES = ["Apple___Apple_scab", ..., "Tomato___healthy"]  # 33 sınıf
```

- Modelin çıktı indeksleriyle birebir eşleşen **33 sınıf** (9 bitki türü). Format
  `Bitki___Hastalık`; üç alt çizgi ayraçtır. **Sıra kritik** — modelin softmax indeksi bu
  listeden okunur.

---

## 6. Sınıflandırıcıyı yükle (EfficientNet-B3)

```python
MODEL = timm.create_model("efficientnet_b3", pretrained=False, num_classes=len(CLASS_NAMES))
MODEL.load_state_dict(torch.load(MODEL_PATH, map_location=DEVICE))
MODEL.to(DEVICE); MODEL.eval()
```

- `pretrained=False`: ImageNet ağırlıklarını indirme (kendi eğittiğimiz `.pth` yüklenecek),
  çıkış katmanı 33 sınıfa ayarlı.
- `load_state_dict`: eğitilmiş ağırlıkları yükler. `map_location=DEVICE`: GPU'da eğitilmiş
  ağırlığı CPU'ya güvenle taşır.
- `eval()`: dropout/batchnorm'u çıkarım moduna alır.
- ⚠️ **Modül yüklenirken (global) çalışır** → model konteyner açılışında **bir kez** belleğe
  yüklenir. Bu, "soğuk başlangıç" gecikmesinin (~40–80 sn) ve sonraki isteklerin hızlı
  olmasının (~8–14 sn) sebebidir.

---

## 7. SAM 2.1'i yükle

```python
SAM2_MODEL = build_sam2(SAM2_MODEL_CFG, SAM2_CHECKPOINT, device=DEVICE)
SAM_PREDICTOR = SAM2ImagePredictor(SAM2_MODEL)
```

- SAM 2.1 modelini config + checkpoint'ten kurar ve görüntü-tahmincisine
  (`SAM2ImagePredictor`) sarar. Bu da açılışta bir kez yüklenir.

---

## 8. Ön-işleme zinciri

```python
PREPROCESS = transforms.Compose([
    transforms.Resize((300, 300)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485,0.456,0.406], std=[0.229,0.224,0.225]),
])
```

- **300×300** boyutlandırma (modelin eğitim girdisi), tensöre çevirme ve **ImageNet
  ortalama/std** ile normalizasyon. Eğitimle birebir aynı olması doğruluk için şarttır.

---

## 9. Etiket ayrıştırıcı `_parse_label()`

```python
def _parse_label(raw_label: str) -> tuple[str, str]:
    if "___" not in raw_label:
        return "Unknown", raw_label.replace("_", " ").strip()
    plant_type, disease = raw_label.split("___", maxsplit=1)
    return plant_type.replace("_", " ").strip(), disease.replace("_", " ").strip()
```

- `"Tomato___Early_blight"` → `("Tomato", "Early blight")`. Üç alt çizgiyi ayraç, tek alt
  çizgileri boşluk yapar. `___` yoksa "Unknown" döner (güvenli geri dönüş).

---

## 10. Yaprak bölütleme `_segment_leaf_with_sam()`

İşin kalbi. Adım adım:

```python
def _segment_leaf_with_sam(image_array):
    try:
        h, w = image_array.shape[:2]
        img_rgb = cv2.cvtColor(image_array, cv2.COLOR_BGR2RGB) if len(image_array.shape)==3 else image_array
        SAM_PREDICTOR.set_image(img_rgb)
```
- Görüntüyü RGB'ye çevirip SAM'a yükler (SAM RGB bekler).

```python
        cx, cy = w // 2, h // 2
        offset = min(w, h) // 10
        input_point = np.array([[cx,cy],[cx+offset,cy],[cx-offset,cy],[cx,cy+offset],[cx,cy-offset]], dtype=np.int32)
        input_point[:,0] = np.clip(input_point[:,0], 0, max(0,w-1))
        input_point[:,1] = np.clip(input_point[:,1], 0, max(0,h-1))
        input_label = np.array([1,1,1,1,1])
```
- **5 ipucu noktası** (merkez + 4 yön) verir; hepsi "ön plan" (`label=1`). Varsayım: yaprak
  ortadadır. `clip` ile noktaları görüntü sınırları içinde tutar (taşma güvenliği).

```python
        masks, _, _ = SAM_PREDICTOR.predict(point_coords=input_point, point_labels=input_label, multimask_output=False)
        if masks.size == 0: return None
        binary_mask = masks[0].astype(np.uint8)
```
- Tek maske ister (`multimask_output=False`); maske yoksa `None` (→ çağıran taraf orijinale döner).

```python
        num_labels, labels, stats, _ = cv2.connectedComponentsWithStats(binary_mask, connectivity=8)
        if num_labels > 1:
            areas = stats[1:, cv2.CC_STAT_AREA]
            largest_label = np.argmax(areas) + 1
            clean_binary_mask = np.zeros_like(binary_mask)
            clean_binary_mask[labels == largest_label] = 1
            binary_mask = clean_binary_mask
```
- **Maske temizleme:** Bağlı bileşen analiziyle birden fazla parça varsa **yalnız en büyük
  bölgeyi** (asıl yaprak) tutar, gürültüyü atar.

```python
        segmented_full = np.zeros_like(img_rgb, dtype=np.uint8)
        segmented_full[binary_mask == 1] = img_rgb[binary_mask == 1]   # arka plan siyah
        coords = np.column_stack(np.where(binary_mask > 0))
        if len(coords) > 0:
            y_min,x_min = coords.min(axis=0); y_max,x_max = coords.max(axis=0)
            pad = 20
            y_min=max(0,y_min-pad); x_min=max(0,x_min-pad)
            y_max=min(h,y_max+pad); x_max=min(w,x_max+pad)
            if y_max>y_min and x_max>x_min:
                cropped = segmented_full[y_min:y_max, x_min:x_max]
                if cropped.size>0 and cropped.shape[0]>50 and cropped.shape[1]>50:
                    return cv2.cvtColor(cropped, cv2.COLOR_RGB2BGR)
        return None
    except Exception as exc:
        print(f"SAM 2.1 segmentation error: {exc}"); return None
```
- Maske dışını **siyahlar**, sınırlayıcı kutuyu bulur, **20 px dolgu** ekleyip kırpar. Çok
  küçük (≤50 px) kırpmaları reddeder. Sonuç BGR olarak döner. Herhangi bir hatada `None` →
  **sistem asla çökmez**, orijinal görüntüyle devam eder.

---

## 11. Sağlık ucu `/health`

```python
@app.get("/health")
def health(): return {"status": "ok", "device": DEVICE}
```

- Konteynerin ayakta olup olmadığını ve hangi cihazda çalıştığını söyler (Cloud Run sağlık
  kontrolü / pre-warm için).

---

## 12. Tahmin ucu `/predict` (ana pipeline)

```python
@app.post("/predict")
async def predict(image: UploadFile = File(...)):
    try:
        image_bytes = await image.read()
        if not image_bytes:
            raise HTTPException(status_code=400, detail="Uploaded file is empty.")
        pil_image = Image.open(BytesIO(image_bytes)).convert("RGB")
```
- Yüklenen dosyayı okur; boşsa 400 hatası; PIL ile RGB açar.

```python
        MAX_SIDE = 1024
        if max(pil_image.size) > MAX_SIDE:
            pil_image.thumbnail((MAX_SIDE, MAX_SIDE), Image.LANCZOS)
        img_cv = cv2.cvtColor(np.array(pil_image), cv2.COLOR_RGB2BGR)
```
- **Optimizasyon:** Büyük telefon fotoğraflarını 1024 px'e küçültür — SAM zaten içeride
  1024'e indirip sınıflandırıcı 300×300 olduğundan, yüksek çözünürlük doğruluğa katkısız
  ama gecikmeyi artırır.

```python
        segmented_img = _segment_leaf_with_sam(img_cv)
        if segmented_img is None:
            segmented_img = img_cv
            pil_image = Image.fromarray(cv2.cvtColor(segmented_img, cv2.COLOR_BGR2RGB))
        else:
            pil_image = Image.fromarray(cv2.cvtColor(segmented_img, cv2.COLOR_BGR2RGB))
            try:
                os.makedirs(SAM_DEBUG_DIR, exist_ok=True)
                debug_path = os.path.join(SAM_DEBUG_DIR, f"sam2_{uuid.uuid4().hex}.png")
                pil_image.save(debug_path)
            except Exception as save_err:
                print(f"SAM debug image save failed: {save_err}")
```
- **Güvenli geri dönüş:** Bölütleme başarısızsa (`None`) orijinal görüntüyle devam → her
  koşulda yanıt. Başarılıysa bölütlenen görüntüyü hata-ayıklama için diske kaydeder (kayıt
  hatası işlemi durdurmaz).

```python
        max_size = max(pil_image.size)
        pil_image = ImageOps.pad(pil_image, (max_size, max_size), color=(0, 0, 0))
        input_tensor = PREPROCESS(pil_image).unsqueeze(0).to(DEVICE)
```
- Görüntüyü **siyah dolguyla kareye** tamamlar (en-boy oranını bozmadan), ön-işleyip
  tek-örneklik batch tensörüne çevirir.

```python
        with torch.no_grad():
            outputs = MODEL(input_tensor)
            probabilities = F.softmax(outputs[0], dim=0)
        topk_vals, topk_indices = torch.topk(probabilities, k=3)
        # ... Top-3 loglama ...
        confidence, idx = torch.max(probabilities, dim=0)
        raw_label = CLASS_NAMES[idx.item()]
```
- `no_grad`: gradyan hesaplamaz (hızlı/az bellek). Softmax → 33 sınıf olasılığı. Top-3
  loglanır; en yüksek olasılıklı sınıf ve güven değeri seçilir.

```python
        tomato_spot_group = {"Tomato___Bacterial_spot","Tomato___Early_blight",
                             "Tomato___Target_Spot","Tomato___Septoria_leaf_spot"}
        if raw_label in tomato_spot_group:
            raw_label = "Tomato___Spot_Disease"
        plant_type, disease = _parse_label(raw_label)
        return {"label": raw_label, "plant_type": plant_type,
                "disease": disease, "confidence": float(confidence.item())}
```
- **Sınıf birleştirme (post-processing):** Görsel olarak karışan 4 domates leke hastalığı
  tahmin edildiyse etiket tek bir **`Tomato___Spot_Disease`**'e indirgenir (tedavileri büyük
  ölçüde aynı olduğu için). Model 33 sınıflı kalır; birleştirme sadece çıktıda yapılır
  (geri dönülebilir).
- Sonuç JSON: ham etiket, bitki türü, hastalık ve güven.

```python
    except UnidentifiedImageError as exc:
        raise HTTPException(status_code=400, detail="Uploaded file must be an image.") from exc
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {exc}") from exc
```
- Geçersiz görsel → **400**; kasıtlı `HTTPException`'lar aynen iletilir; beklenmeyen her
  şey → **500** (mesajla birlikte).

---

## Özet akış

**Görüntü → (≤1024 küçült) → SAM 2.1 bölütleme [başarısızsa orijinal] → siyah kare dolgu →
300×300 normalize → EfficientNet-B3 → softmax → (domates leke birleştirme) → JSON.**
