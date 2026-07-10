#!/bin/bash

# Создаём базовые папки
mkdir -p /ComfyUI/models/diffusion_models
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae
mkdir -p /ComfyUI/models/controlnet
mkdir -p /ComfyUI/models/loras
mkdir -p /ComfyUI/models/dwpose
mkdir -p /ComfyUI/models/ultralytics/segm
mkdir -p /ComfyUI/models/sams
mkdir -p /ComfyUI/models/upscale_models

export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
export HF_TOKEN=${HF_TOKEN}

# ===== ИСПОЛЬЗУЕМ ОБЫЧНЫЙ HTTPS (БЕЗ XET) =====
# Не включаем и не отключаем Xet — просто не трогаем
# export HF_XET_HIGH_PERFORMANCE=1  # Закомментировано
# export HF_HUB_DISABLE_XET=1       # Закомментировано
# ===============================================

echo "========================================"
echo "Python:"
python3 --version

echo "huggingface_hub:"
python3 -c "import huggingface_hub; print(huggingface_hub.__version__)"

echo "========================================"
echo "Скачиваем модели Flux..."
echo "========================================"

python3 << 'EOF'
from huggingface_hub import snapshot_download
import os
import time

t0 = time.time()

snapshot_download(
    repo_id="raderos/comfyui-models-flux",
    local_dir="/ComfyUI/models",
    token=os.environ.get("HF_TOKEN"),
    max_workers=4,  # Оптимальное значение для HTTPS
)

print(f"Flux готов. ({time.time()-t0:.1f} сек)")
EOF

echo ""
echo "========================================"
echo "Скачиваем модели Qwen..."
echo "========================================"

python3 << 'EOF'
from huggingface_hub import snapshot_download
import os
import time

t0 = time.time()

snapshot_download(
    repo_id="raderos/qwenpublic",
    local_dir="/ComfyUI/models",
    token=os.environ.get("HF_TOKEN"),
    max_workers=4,  # Оптимальное значение для HTTPS
)

print(f"Qwen готов. ({time.time()-t0:.1f} сек)")
EOF

echo ""
echo "========================================"
echo "Запуск ComfyUI..."
echo "========================================"

python3 /ComfyUI/main.py \
    --listen 0.0.0.0 \
    --port 8188 \
    --lowvram \
    --reserve-vram 2 \
    --use-pytorch-cross-attention
