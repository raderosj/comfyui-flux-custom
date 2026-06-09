FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git wget python3 python3-pip \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu124

RUN pip3 install "transformers==4.47.0"

RUN pip3 install gguf opencv-python-headless
RUN pip3 install -U "huggingface-hub[cli]" huggingface_hub

RUN git clone https://github.com/comfyanonymous/ComfyUI /ComfyUI && \
    cd /ComfyUI && \
    pip3 install -r requirements.txt && \
    pip3 install sqlalchemy gdown

# Кастомные ноды (все необходимые)
RUN cd /ComfyUI/custom_nodes && \
    # Основные (были)
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    cd ComfyUI-Easy-Use && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/alexopus/ComfyUI-Image-Saver.git && \
    cd ComfyUI-Image-Saver && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git && \
    cd comfyui_controlnet_aux && pip3 install -r requirements.txt && cd .. && \
    # Новые для воркфлоу kontext_hires
    git clone https://github.com/TTPlanetPig/Comfyui_TTP_Toolset.git && \
    git clone https://github.com/chflame163/ComfyUI_LayerStyle.git && \
    git clone https://github.com/cubiq/ComfyUI_essentials.git && \
    git clone https://github.com/rgthree/rgthree-comfy.git && \
    # Ускоритель TeaCache для Flux
    git clone https://github.com/welltop-cn/ComfyUI-TeaCache.git

RUN pip3 install mediapipe psutil

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
