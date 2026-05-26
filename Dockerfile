FROM nvidia/cuda:12.4.1-cudnn9-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git wget python3 python3-pip \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu124

RUN pip3 install gguf opencv-python-headless scikit-image

RUN git clone https://github.com/comfyanonymous/ComfyUI /ComfyUI && \
    cd /ComfyUI && pip3 install -r requirements.txt && \
    pip3 install sqlalchemy gdown

RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/kijai/ComfyUI-KJNodes && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
