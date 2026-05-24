FROM runpod/base:0.6.1-cuda12.1.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git wget python3 python3-pip \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu121

RUN git clone https://github.com/comfyanonymous/ComfyUI /ComfyUI && \
    cd /ComfyUI && pip3 install -r requirements.txt

RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/kijai/ComfyUI-KJNodes && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
