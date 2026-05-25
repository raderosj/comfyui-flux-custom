#!/bin/bash

mkdir -p /ComfyUI/models/checkpoints
mkdir -p /ComfyUI/models/text_encoders
mkdir -p /ComfyUI/models/vae
mkdir -p /ComfyUI/models/controlnet
mkdir -p /ComfyUI/models/loras

pip install gdown -q

echo "📥 Скачиваем модели..."

gdown "1UHHCpgtcZjt1Aj3ouznSuJjuLB6c34dt" -O /ComfyUI/models/checkpoints/flux1-dev-fp8.safetensors
gdown "1glgsmQB0gE2x57srbHMJ72q0h8iYXsIp" -O /ComfyUI/models/checkpoints/qwen_image_edit_2509_fp8.safetensors
gdown "1VuO8pdiFwioAXw4m67OMiSR16RrAGHN_" -O /ComfyUI/models/checkpoints/qwen_image_fp8_e4m3fn.safetensors
gdown "1CU8itTeWAvuWoEstDfPOLaW_drPZFaFx" -O /ComfyUI/models/text_encoders/clip_l.safetensors
gdown "1Oe1OMK6gniuUrB3EGSzOoi60t4f-qpHs" -O /ComfyUI/models/text_encoders/t5xxl_fp8_e4m3fn.safetensors
gdown "1dsRRnyG0svAm9Y7sLeXPZmbulUjTia_Y" -O /ComfyUI/models/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors
gdown "1iiJrfbYj_2hMbRFpPv0SRn9B1K-_hh69" -O /ComfyUI/models/vae/ae.safetensors
gdown "1E_6ZAVSmyW43BWR4K1ulkek1eq6Tmp9R" -O /ComfyUI/models/vae/qwen_image_vae.safetensors
gdown "1_YI8reHsMlAFz9k_rMKtmqaIUAWiMZ55" -O /ComfyUI/models/controlnet/FLUX.1-dev-ControlNet-Union-Pro-2.0-fp8.safetensors
gdown "1j1S4_CbML6wYlvkC9TSwA3uRWmVqm-XY" -O /ComfyUI/models/loras/raderos_epoch_9.safetensors
gdown "1HDuxXcUqLxZKyI8Phil-edZQkmlDuFYq" -O /ComfyUI/models/loras/VanguardVision25_V1.1.safetensors
gdown "1wBwRuqznJjFLXv4NSBIBmBKcIRwozag7" -O /ComfyUI/models/loras/fluxlisimo_cinematic_v2.safetensors

echo "✅ Модели скачаны!"

jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token="" --ServerApp.password="" &

python3 /ComfyUI/main.py --listen 0.0.0.0 --port 8188
