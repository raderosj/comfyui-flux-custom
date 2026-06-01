FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git wget python3 python3-pip \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu121

RUN pip3 install gguf opencv-python-headless scikit-image

RUN pip install -U "huggingface-hub[cli]"

# Скачиваем ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI /ComfyUI && \
    cd /ComfyUI && \
    pip3 install -r requirements.txt && \
    pip3 install sqlalchemy gdown

# Установка кастомных нодов
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux && \
    git clone https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    git clone https://github.com/Pixelailabs/paint_editor.git && \
    git clone https://github.com/giriss/comfyui-image-saver.git && \
    git clone https://github.com/ModelSurge/comfyui_mem_utils.git

# ПРИНУДИТЕЛЬНО УДАЛЯЕМ MANAGER, ЕСЛИ ОН ОТКУДА-ТО ПОЯВИЛСЯ
RUN rm -rf /ComfyUI/custom_nodes/comfyui-manager
RUN rm -rf /ComfyUI/custom_nodes/ComfyUI-Manager
RUN rm -rf /ComfyUI/models/custom_nodes/comfyui-manager
RUN find /ComfyUI -maxdepth 3 -type d -iname "*manager*" -exec rm -rf {} + 2>/dev/null || true

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
