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

# Кастомные ноды (без VAE Tiling)
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    cd ComfyUI-Easy-Use && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/alexopus/ComfyUI-Image-Saver.git && \
    cd ComfyUI-Image-Saver && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git && \
    cd comfyui_controlnet_aux && pip3 install -r requirements.txt

# Impact Pack, Subpack, LayerStyle
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git && \
    cd ComfyUI-Impact-Pack && \
    pip3 install -r requirements.txt && \
    python3 install.py && \
    cd .. && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Subpack.git && \
    cd ComfyUI-Impact-Subpack && \
    pip3 install -r requirements.txt && \
    cd .. && \
    git clone https://github.com/chflame163/ComfyUI_LayerStyle.git && \
    cd ComfyUI_LayerStyle && \
    pip3 install -r requirements.txt

# ComfyUI Essentials (cubiq) - ДОБАВЛЕНО
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/cubiq/ComfyUI_essentials.git && \
    cd ComfyUI_essentials && \
    pip3 install -r requirements.txt

RUN pip3 install mediapipe psutil
RUN pip3 install ultralytics

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
