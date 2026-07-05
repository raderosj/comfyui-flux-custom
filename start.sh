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

# ускоряет загрузку если доступен hf_transfer
export HF_HUB_ENABLE_HF_TRANSFER=1

echo "========================================"
echo "Python:"
python3 --version
echo "========================================"

echo "huggingface_hub:"
python3 -c "import huggingface_hub; print(huggingface_hub.__version__)"

echo "========================================"
echo "Начинаем загрузку моделей..."
echo "========================================"

python3 << 'EOF'
from huggingface_hub import snapshot_download
import os
import traceback
import time

token = os.environ.get("HF_TOKEN")

repos = [
    "raderos/comfyui-models-flux",
    "raderos/comfyui-models-qwen",
]

for repo in repos:
    print("")
    print("=" * 70)
    print(f"START DOWNLOAD: {repo}")
    print("=" * 70)

    t0 = time.time()

    try:
        snapshot_download(
            repo_id=repo,
            local_dir="/ComfyUI/models",
            token=token,
            resume_download=True,
            max_workers=2,
        )

        print(f"FINISHED: {repo}")
        print(f"Elapsed: {time.time()-t0:.1f} sec")

    except Exception:
        print(f"ERROR downloading {repo}")
        traceback.print_exc()
        raise

print("")
print("========================================")
print("Все модели успешно скачаны.")
print("========================================")
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
