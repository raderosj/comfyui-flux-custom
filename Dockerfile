FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git wget python3 python3-pip \
    libgl1 libglib2.0-0 \
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

RUN echo '#!/bin/bash\njupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token="" --NotebookApp.password="" &\npython3 /ComfyUI/main.py --listen 0.0.0.0 --port 8188' > /start.sh && chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188 8888
CMD ["/start.sh"]
