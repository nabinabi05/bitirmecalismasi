$ErrorActionPreference = "Stop"

Set-Location $PSScriptRoot

if (-not (Test-Path ".venv")) {
  py -m venv .venv
}

$VENV_PYTHON = ".\.venv\Scripts\python.exe"

& $VENV_PYTHON -m pip install --upgrade pip
& $VENV_PYTHON -m pip install -r requirements_inference.txt
& $VENV_PYTHON -m pip install -e .\modeller\sam2_repo
& $VENV_PYTHON -m uvicorn inference_api:app --host 0.0.0.0 --port 8000 --reload
