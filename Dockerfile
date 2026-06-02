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

# Кастомные ноды (все ссылки проверены и рабочие)
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux && \
    git clone https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    git clone https://github.com/alexopus/ComfyUI-Image-Saver.git && \
    cd ComfyUI-Image-Saver && pip install -r requirements.txt && cd .. && \
    git clone https://github.com/ShmuelRonen/ComfyUI-FreeMemory.git && \
    git clone https://github.com/EricRollei/Eric_Qwen_Edit_Experiments.git && \
    git clone https://github.com/shootthesound/comfyui-ReferenceLatentPlus.git && \
    git clone https://github.com/rgthree/rgthree-comfy.git && \
    git clone https://github.com/rgthree/ComfyUI-Impact-Pack.git

# Устанавливаем зависимости для ReferenceLatentPlus
RUN pip install mediapipe

# Удаляем Manager, если случайно появился
RUN rm -rf /ComfyUI/custom_nodes/comfyui-manager
RUN rm -rf /ComfyUI/custom_nodes/ComfyUI-Manager

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
