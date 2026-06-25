import os

import httpx
from fastapi import FastAPI, File, UploadFile, HTTPException

app = FastAPI(title="Plant Disease API Gateway")

# Model servisinin URL'i. Cloud Run'da bu değişken hedef (model) servisinin
# URL'i olarak --set-env-vars MODEL_SERVICE_URL=... ile verilir.
# Yerel testte varsayılan olarak model servisinin 8081 portunda çalıştığı varsayılır.
MODEL_SERVICE_URL = os.getenv("MODEL_SERVICE_URL", "http://model_service:8081")


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok", "service": "gateway"}


@app.post("/predict")
async def predict(image: UploadFile = File(...)):
    if not image.filename:
        raise HTTPException(status_code=400, detail="No selected file")

    # Gelen dosyayı oku
    image_bytes = await image.read()
    if not image_bytes:
        raise HTTPException(status_code=400, detail="Uploaded file is empty.")

    # Model servisine isteği yönlendir
    predict_url = f"{MODEL_SERVICE_URL.rstrip('/')}/predict"
    try:
        async with httpx.AsyncClient(timeout=120.0) as client:
            files = {"image": (image.filename, image_bytes, image.content_type)}
            response = await client.post(predict_url, files=files)

            # Model servisinden gelen yanıtı kontrol et
            if response.status_code != 200:
                raise HTTPException(
                    status_code=response.status_code,
                    detail=f"Model service error: {response.text}",
                )
            return response.json()
    except httpx.RequestError as exc:
        raise HTTPException(
            status_code=503,
            detail=f"Error communicating with model service: {exc}",
        )
    except Exception as exc:
        raise HTTPException(status_code=500, detail=f"Gateway error: {exc}")
