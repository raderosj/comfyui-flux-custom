#!/bin/bash

mkdir -p /ComfyUI/models/diffusion_models
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae
mkdir -p /ComfyUI/models/controlnet
mkdir -p /ComfyUI/models/loras
mkdir -p /ComfyUI/models/pulid
mkdir -p /ComfyUI/models/insightface/models

export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
export HF_TOKEN=${HF_TOKEN}

echo "📥 Проверяем версию huggingface_hub..."
python3 -c "import huggingface_hub; print(huggingface_hub.__version__)"

echo "📥 Скачиваем модели..."

python3 << 'EOF'
from huggingface_hub import snapshot_download
import os

token = os.environ.get("HF_TOKEN")

repos = [
    "raderos/comfyui-models-flux",
    "raderos/comfyui-models-qwen",
]

for repo in repos:
    print(f"\n========== {repo} ==========")

    snapshot_download(
        repo_id=repo,
        local_dir="/ComfyUI/models",
        token=token,
        resume_download=True,
        max_workers=1,
    )

print("\n✅ Все модели скачаны!")
EOF

python3 /ComfyUI/main.py \
    --listen 0.0.0.0 \
    --port 8188 \
    --lowvram \
    --reserve-vram 2 \
    --use-pytorch-cross-attention
