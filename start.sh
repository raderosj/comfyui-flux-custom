#!/bin/bash

mkdir -p /ComfyUI/models/diffusion_models
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae
mkdir -p /ComfyUI/models/controlnet
mkdir -p /ComfyUI/models/loras

# Убираем устаревшую переменную, заменяем на новую для ускорения (Xet)
export HF_XET_HIGH_PERFORMANCE=1

echo "📥 Скачиваем модели Flux..."
python3 -c "
from huggingface_hub import snapshot_download
import os
token = os.environ.get('HF_TOKEN')
snapshot_download(
    repo_id='raderos/comfyui-models-flux',
    local_dir='/ComfyUI/models',
    token=token
)
"

echo "📥 Скачиваем модели Qwen..."
python3 -c "
from huggingface_hub import snapshot_download
import os
token = os.environ.get('HF_TOKEN')
snapshot_download(
    repo_id='raderos/comfyui-models-qwen',
    local_dir='/ComfyUI/models',
    token=token
)
"

echo "✅ Все модели скачаны!"

# Запуск с флагами для экономии VRAM на 24GB GPU
python3 /ComfyUI/main.py --listen 0.0.0.0 --port 8188 --lowvram --disable-smart-memory
