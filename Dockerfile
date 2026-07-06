FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    wget \
    python3 \
    python3-pip \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu124

RUN pip3 install "transformers==4.47.0"
RUN pip3 install gguf opencv-python-headless
RUN pip3 install -U "huggingface-hub[cli]" huggingface_hub

# Установка onnxruntime-gpu
RUN pip3 install onnxruntime-gpu

# ===== ЗАВИСИМОСТИ ДЛЯ PuLID =====
RUN pip3 install \
    insightface \
    facexlib \
    timm \
    einops \
    albumentations \
    accelerate \
    mediapipe \
    psutil

# Основной ComfyUI
RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI /ComfyUI \
    && cd /ComfyUI \
    && pip3 install -r requirements.txt \
    && pip3 install sqlalchemy gdown

# Кастомные ноды
RUN cd /ComfyUI/custom_nodes \
    && git clone --depth 1 https://github.com/city96/ComfyUI-GGUF \
    && git clone --depth 1 https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git \
    && git clone --depth 1 https://github.com/yolain/ComfyUI-Easy-Use.git \
    && cd ComfyUI-Easy-Use && pip3 install -r requirements.txt && cd .. \
    && git clone --depth 1 https://github.com/alexopus/ComfyUI-Image-Saver.git \
    && cd ComfyUI-Image-Saver && pip3 install -r requirements.txt && cd .. \
    && git clone --depth 1 https://github.com/Fannovel16/comfyui_controlnet_aux.git \
    && cd comfyui_controlnet_aux && pip3 install -r requirements.txt

# Ultimate SD Upscale
RUN cd /ComfyUI/custom_nodes \
    && git clone --depth 1 --recursive https://github.com/ssitu/ComfyUI_UltimateSDUpscale \
    && cd ComfyUI_UltimateSDUpscale \
    && pip3 install -r requirements.txt || true

# Inpaint Crop & Stitch
RUN cd /ComfyUI/custom_nodes \
    && git clone --depth 1 https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch

# Impact Pack
RUN cd /ComfyUI/custom_nodes \
    && git clone --depth 1 https://github.com/ltdrdata/ComfyUI-Impact-Pack \
    && cd ComfyUI-Impact-Pack \
    && pip3 install -r requirements.txt \
    && python3 install.py

# Impact Subpack
RUN cd /ComfyUI/custom_nodes \
    && git clone --depth 1 https://github.com/ltdrdata/ComfyUI-Impact-Subpack \
    && cd ComfyUI-Impact-Subpack \
    && pip3 install -r requirements.txt

# KJNodes
RUN cd /ComfyUI/custom_nodes \
    && git clone --depth 1 https://github.com/kijai/ComfyUI-KJNodes.git \
    && cd ComfyUI-KJNodes \
    && pip3 install -r requirements.txt

# Essentials
RUN cd /ComfyUI/custom_nodes \
    && git clone --depth 1 https://github.com/cubiq/ComfyUI_essentials.git \
    && cd ComfyUI_essentials \
    && pip3 install -r requirements.txt || true

# Kontext Inpainting
RUN cd /ComfyUI/custom_nodes \
    && git clone https://github.com/ZenAI-Vietnam/ComfyUI-Kontext-Inpainting.git \
    && cd ComfyUI-Kontext-Inpainting \
    && pip3 install -r requirements.txt || true

# ===== PuLID Flux =====
RUN cd /ComfyUI/custom_nodes \
    && git clone --depth 1 https://github.com/balazik/ComfyUI-PuLID-Flux.git \
    && cd ComfyUI-PuLID-Flux \
    && pip3 install -r requirements.txt || true

# ===== Patch PuLID for ComfyUI 0.27+ =====
RUN python3 - <<'PY'
from pathlib import Path

p = Path("/ComfyUI/custom_nodes/ComfyUI-PuLID-Flux/pulidflux.py")

text = p.read_text()

old = """    guidance: Tensor = None,
    control=None,
) -> Tensor:"""

new = """    guidance: Tensor = None,
    control=None,
    timestep_zero_index=None,
    transformer_options=None,
    attn_mask=None,
    **kwargs,
) -> Tensor:"""

if "timestep_zero_index=None" not in text:
    text = text.replace(old, new)
    p.write_text(text)
    print("PuLID patched successfully.")
else:
    print("PuLID already patched.")
PY

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI

EXPOSE 8188

CMD ["/start.sh"]
