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

# используем hf_transfer только для Flux
export HF_HUB_ENABLE_HF_TRANSFER=1

echo "========================================"
echo "Python:"
python3 --version

echo "huggingface_hub:"
python3 -c "import huggingface_hub; print(huggingface_hub.__version__)"

echo "========================================"
echo "Скачиваем Flux..."
echo "========================================"

python3 << 'EOF'
from huggingface_hub import snapshot_download
import os

snapshot_download(
    repo_id="raderos/comfyui-models-flux",
    local_dir="/ComfyUI/models",
    token=os.environ.get("HF_TOKEN"),
    resume_download=True,
    max_workers=2,
)

print("Flux готов.")
EOF

########################################
# ДЛЯ QWEN НЕ ИСПОЛЬЗУЕМ SNAPSHOT_DOWNLOAD
########################################

export HF_HUB_ENABLE_HF_TRANSFER=0

echo ""
echo "========================================"
echo "Скачиваем Qwen по файлам..."
echo "========================================"

python3 << 'EOF'
from huggingface_hub import hf_hub_download
import shutil
import os

repo = "raderos/comfyui-models-qwen"
token = os.environ.get("HF_TOKEN")

files = [

("diffusion_models/Qwen-Image-Edit-2509_fp8_e4m3fn.safetensors",
"/ComfyUI/models/diffusion_models/Qwen-Image-Edit-2509_fp8_e4m3fn.safetensors"),

("loras/Qwen-Image-Edit-2509-Lightning-4steps-V1.0-bf16.safetensors",
"/ComfyUI/models/loras/Qwen-Image-Edit-2509-Lightning-4steps-V1.0-bf16.safetensors"),

("loras/next-scene_lora-v2-3000.safetensors",
"/ComfyUI/models/loras/next-scene_lora-v2-3000.safetensors"),

("loras/qwen_multiple_angles_lora.safetensors",
"/ComfyUI/models/loras/qwen_multiple_angles_lora.safetensors"),

("text_encoders/Qwen2.5-VL-7B-Instruct-mmproj-bf16.gguf",
"/ComfyUI/models/text_encoders/Qwen2.5-VL-7B-Instruct-mmproj-bf16.gguf"),

("text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors",
"/ComfyUI/models/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"),

("vae/qwen_image_vae.safetensors",
"/ComfyUI/models/vae/qwen_image_vae.safetensors"),

]

for remote, local in files:

    if os.path.exists(local):
        print("Есть:", os.path.basename(local))
        continue

    print("Скачиваем:", remote)

    tmp = hf_hub_download(
        repo_id=repo,
        filename=remote,
        token=token,
    )

    shutil.copy2(tmp, local)

    print("Готово:", os.path.basename(local))

print("Qwen готов.")
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
