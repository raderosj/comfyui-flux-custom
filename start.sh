#!/bin/bash

mkdir -p /ComfyUI/models/diffusion_models
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae
mkdir -p /ComfyUI/models/controlnet
mkdir -p /ComfyUI/models/loras

# Ключевая переменная для PyTorch (решает проблему фрагментации памяти)
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True

# Передаём HF_TOKEN (без лишних переменных)
export HF_TOKEN=${HF_TOKEN}

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

# Оптимизированный запуск с флагами для 20 GB GPU
python3 /ComfyUI/main.py \
    --listen 0.0.0.0 \
    --port 8188 \
    --lowvram \
    --reserve-vram 2 \
    --use-pytorch-cross-attention
