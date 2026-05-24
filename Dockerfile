FROM runpod/base:0.6.1-cuda12.1.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git wget libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu121

RUN git clone https://github.com/comfyanonymous/ComfyUI /ComfyUI && \
    cd /ComfyUI && pip3 install -r requirements.txt && \
    pip3 install sqlalchemy jupyterlab

RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/kijai/ComfyUI-KJNodes && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux

COPY start.sh /comfyui_start.sh
RUN chmod +x /comfyui_start.sh

WORKDIR /ComfyUI
EXPOSE 8188 8888
CMD ["/comfyui_start.sh"]
