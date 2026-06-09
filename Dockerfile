FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git wget python3 python3-pip \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Ключевое исправление: PyTorch 2.6+ с CUDA 12.4
RUN pip3 install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu124

# Устанавливаем зависимости для Eric_Qwen_Edit_Experiments
RUN pip3 install "transformers>=4.54.0" "accelerate>=1.5.0" && \
    pip3 cache purge

RUN pip3 install gguf opencv-python-headless
RUN pip3 install -U "huggingface-hub[cli]" huggingface_hub

RUN git clone https://github.com/comfyanonymous/ComfyUI /ComfyUI && \
    cd /ComfyUI && \
    pip3 install -r requirements.txt && \
    pip3 install sqlalchemy gdown

# Кастомные ноды
RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux && \
    git clone https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    cd ComfyUI-Easy-Use && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/alexopus/ComfyUI-Image-Saver.git && \
    cd ComfyUI-Image-Saver && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/rgthree/rgthree-comfy.git && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git && \
    cd ComfyUI-Impact-Pack && python3 install.py && \
    pip3 install -r requirements.txt && \
    rm -f web/extensions/core/comboBoolMigration.js && cd .. && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git && \
    cd ComfyUI-KJNodes && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/EricRollei/Eric_Qwen_Edit_Experiments.git

RUN pip3 install mediapipe psutil

COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
