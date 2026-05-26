#!/bin/bash

mkdir -p /ComfyUI/models/diffusion_models
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae
mkdir -p /ComfyUI/models/controlnet
mkdir -p /ComfyUI/models/loras

pip install -q huggingface_hub hf_transfer

echo "📥 Скачиваем модели Flux..."
python3 -c "
from huggingface_hub import snapshot_download
snapshot_download(
    repo_id='raderos/comfyui-models-flux',
    local_dir='/ComfyUI/models',
    token='${HF_TOKEN}'
)
"

echo "📥 Скачиваем модели Qwen..."
python3 -c "
from huggingface_hub import snapshot_download
snapshot_download(
    repo_id='raderos/comfyui-models-qwen',
    local_dir='/ComfyUI/models',
    token='${HF_TOKEN}'
)
"

echo "✅ Все модели скачаны!"

python3 /ComfyUI/main.py --listen 0.0.0.0 --port 8188
