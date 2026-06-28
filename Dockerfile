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

# Кастомные ноды
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    cd ComfyUI-Easy-Use && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/alexopus/ComfyUI-Image-Saver.git && \
    cd ComfyUI-Image-Saver && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git && \
    cd comfyui_controlnet_aux && pip3 install -r requirements.txt && \
    # НОВЫЕ НОДЫ:
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git && \
    cd ComfyUI-VideoHelperSuite && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/rgthree/rgthree-comfy.git && \
    cd rgthree-comfy && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/BlenderNeko/ComfyUI_ADV_CLIP_emb.git && \
    git clone https://github.com/bashable/ComfyUI-Image-Filters.git && \
    # SAM3.1 ноды:
    git clone https://github.com/comfyanonymous/ComfyUI-SAM3D.git && \
    cd ComfyUI-SAM3D && pip3 install -r requirements.txt && cd .. && \
    # ADetailer ноды:
    git clone https://github.com/KoyoteScience/ComfyUI-ADetailer.git && \
    cd ComfyUI-ADetailer && pip3 install -r requirements.txt && cd ..

RUN pip3 install mediapipe psutil

# Копируем модели из твоего репозитория (опционально)
# Если хочешь скачать модели при сборке:
# RUN cd /ComfyUI/models && \
#     huggingface-cli download raderos/comfyui-models-flux checkpoints/sam3.1_multiplex_fp16.safetensors --local-dir ./checkpoints && \
#     huggingface-cli download raderos/comfyui-models-flux adetailer/face_yolov8m.pt --local-dir ./adetailer

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
