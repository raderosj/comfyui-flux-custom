#!/bin/bash

mkdir -p /ComfyUI/models/diffusion_models
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae
mkdir -p /ComfyUI/models/controlnet
mkdir -p /ComfyUI/models/loras

pip install -q huggingface_hub hf_transfer

export HF_XET_HIGH_PERFORMANCE=1

echo "📥 Скачиваем модели Flux..."
hf download raderos/comfyui-models-flux \
  --local-dir /ComfyUI/models \
  --token ${HF_TOKEN}

echo "📥 Скачиваем модели Qwen..."
hf download raderos/comfyui-models-qwen \
  --local-dir /ComfyUI/models \
  --token ${HF_TOKEN}

echo "✅ Все модели скачаны!"

python3 /ComfyUI/main.py --listen 0.0.0.0 --port 8188
