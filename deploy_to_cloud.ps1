$ErrorActionPreference = "Stop"

$REGION = "europe-west1"
$PROJECT_ID = "planttrack-f9cde"

# ============================================================================
# İki konteynerli dağıtım: önce Model Servisi, sonra API Gateway.
# gcloud builds submit kök dizinde "Dockerfile" adını aradığından, her adımda
# ilgili Dockerfile geçici olarak "Dockerfile" adına kopyalanıp sonra silinir.
# ============================================================================

Write-Host "Adim 1/2: Model Servisi (Inference Container) Google Cloud'a yukleniyor..." -ForegroundColor Green
Write-Host "(Bu adim model boyutlarindan dolayi 5-15 dakika arasi surebilir)" -ForegroundColor Yellow

Copy-Item Dockerfile.model Dockerfile -Force
gcloud builds submit --tag gcr.io/$PROJECT_ID/plant-model-service .
Remove-Item Dockerfile -Force

gcloud run deploy plant-model-service `
    --image gcr.io/$PROJECT_ID/plant-model-service `
    --region $REGION `
    --platform managed `
    --allow-unauthenticated `
    --memory 8Gi `
    --cpu 8 `
    --timeout 300

# Model servisinin olusturulan (ic) URL'ini al
$MODEL_URL = gcloud run services describe plant-model-service --region $REGION --format "value(status.url)"
Write-Host "Model Servisi basariyla yuklendi. Ic URL: $MODEL_URL" -ForegroundColor Cyan
Write-Host ""

Write-Host "Adim 2/2: API Gateway Servisi (Ag Gecidi Container) Google Cloud'a yukleniyor..." -ForegroundColor Green

Copy-Item Dockerfile.gateway Dockerfile -Force
gcloud builds submit --tag gcr.io/$PROJECT_ID/plant-api-gateway .
Remove-Item Dockerfile -Force

gcloud run deploy plant-api-gateway `
    --image gcr.io/$PROJECT_ID/plant-api-gateway `
    --region $REGION `
    --platform managed `
    --allow-unauthenticated `
    --set-env-vars MODEL_SERVICE_URL=$MODEL_URL `
    --memory 1Gi `
    --cpu 1 `
    --timeout 300

Write-Host "Dagitim tamamlandi!" -ForegroundColor Green

$GATEWAY_URL = gcloud run services describe plant-api-gateway --region $REGION --format "value(status.url)"
Write-Host "=========================================================" -ForegroundColor Magenta
Write-Host "Mobil uygulamaniz (Flutter) icin YENI API URL'niz:" -ForegroundColor Magenta
Write-Host "$GATEWAY_URL/predict" -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Magenta
