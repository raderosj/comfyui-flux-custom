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

# ===== Новый высокопроизводительный движок Hugging Face (Xet) =====
export HF_XET_HIGH_PERFORMANCE=1
export HF_XET_RECONSTRUCT_WRITE_SEQUENTIALLY=1

# Если не задано - используем старый репозиторий
export HF_REPOS=${HF_REPOS:-raderos/comfyui-models-flux}

echo "========================================"
echo "Python:"
python3 --version

echo "huggingface_hub:"
python3 -c "import huggingface_hub; print(huggingface_hub.__version__)"

echo "HF_XET_HIGH_PERFORMANCE=$HF_XET_HIGH_PERFORMANCE"

echo "========================================"
echo "Будут скачаны репозитории:"
echo "$HF_REPOS"
echo "========================================"

python3 <<EOF
from huggingface_hub import snapshot_download
import os
import time

total_start = time.time()

workers = min(os.cpu_count() or 4, 8)

print(f"Используем {workers} потоков")
print(f"HF_XET_HIGH_PERFORMANCE = {os.environ.get('HF_XET_HIGH_PERFORMANCE')}")
print("")

repos = os.environ.get("HF_REPOS", "").split(",")

for repo in repos:
    repo = repo.strip()

    if not repo:
        continue

    print("=" * 60)
    print(f"Скачиваем: {repo}")
    print("=" * 60)

    t0 = time.time()

    snapshot_download(
        repo_id=repo,
        local_dir="/ComfyUI/models",
        token=os.environ.get("HF_TOKEN"),
        max_workers=workers,
    )

    print(f"✓ {repo} готов за {time.time()-t0:.1f} сек\n")

print("=" * 60)
print(f"Все модели готовы за {time.time()-total_start:.1f} сек")
print("=" * 60)
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
