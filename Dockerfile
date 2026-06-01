FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Базовые системные пакеты + ffmpeg для видео-нодов
RUN apt-get update && apt-get install -y \
    git wget python3 python3-pip \
    libgl1 libglib2.0-0 \
    ffmpeg libsm6 libxext6 \
    && rm -rf /var/lib/apt/lists/*

# Установка PyTorch с поддержкой CUDA 12.1
RUN pip3 install torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu121

# Установка вспомогательных Python-пакетов
RUN pip3 install gguf opencv-python-headless scikit-image

# Установка Hugging Face Hub CLI
RUN pip install -U "huggingface-hub[cli]"

# ---- КЛЮЧЕВОЕ ИЗМЕНЕНИЕ: обновляем ComfyUI до более новой, но стабильной версии ----
# Используем коммит, который включает ComfySwitchNode и совместим с Python 3.10
RUN git clone https://github.com/comfyanonymous/ComfyUI /ComfyUI && \
    cd /ComfyUI && \
    git checkout 66459bcc2067d5ef4301048c98d425f66b456a4b && \
    pip3 install -r requirements.txt && \
    pip3 install sqlalchemy gdown

# ---- Установка и обновление всех критически важных кастомных нодов ----
RUN cd /ComfyUI/custom_nodes && \
    # 1. Comfyroll Studio - полезные утилиты
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes && \
    # 2. GGUF Loader - для экономии памяти
    git clone https://github.com/city96/ComfyUI-GGUF && \
    cd /ComfyUI/custom_nodes/ComfyUI-GGUF && \
    pip install --upgrade gguf && \
    cd /ComfyUI/custom_nodes && \
    # 3. ControlNet Aux - мощный набор препроцессоров
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux && \
    pip install -r /ComfyUI/custom_nodes/comfyui_controlnet_aux/requirements.txt && \
    # 4. Управление камерой для Qwen
    git clone https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git && \
    # 5. Easy Use - набор популярных нодов (важен для многих воркфлоу)
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    # 6. KJNodes - добавляем, так как он нужен для некоторых ваших воркфлоу
    git clone https://github.com/kijai/ComfyUI-KJNodes.git && \
    cd /ComfyUI/custom_nodes/ComfyUI-KJNodes && \
    pip install -r requirements.txt

# Копируем и настраиваем скрипт запуска
COPY start.sh /start.sh
RUN chmod +x /start.sh

WORKDIR /ComfyUI
EXPOSE 8188
CMD ["/start.sh"]
