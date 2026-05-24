FROM runpod/comfyui:latest

RUN mkdir -p /workspace/ComfyUI/custom_nodes && \
    cd /workspace/ComfyUI/custom_nodes && \
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/kijai/ComfyUI-KJNodes && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux && \
    pip install -r ComfyUI_Comfyroll_CustomNodes/requirements.txt && \
    pip install -r ComfyUI-GGUF/requirements.txt && \
    pip install -r comfyui_controlnet_aux/requirements.txt
