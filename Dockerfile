FROM runpod/comfyui:latest

RUN cd /workspace/ComfyUI/custom_nodes && \
    git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/kijai/ComfyUI-KJNodes && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite && \
    pip install -r ComfyUI_Comfyroll_CustomNodes/requirements.txt && \
    pip install -r ComfyUI-GGUF/requirements.txt
