RUN cd /ComfyUI/custom_nodes && \
    git clone https://github.com/city96/ComfyUI-GGUF && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux && \
    git clone https://github.com/jtydhr88/ComfyUI-qwenmultiangle.git && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use.git && \
    cd ComfyUI-Easy-Use && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/alexopus/ComfyUI-Image-Saver.git && \
    cd ComfyUI-Image-Saver && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/ShmuelRonen/ComfyUI-FreeMemory.git && \
    git clone https://github.com/EricRollei/Eric_Qwen_Edit_Experiments.git && \
    git clone https://github.com/rgthree/rgthree-comfy.git && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git && \
    cd ComfyUI-Impact-Pack && python3 install.py && \
    pip3 install -r requirements.txt && \
    rm -f web/extensions/core/comboBoolMigration.js && cd .. && \
    git clone https://github.com/WASasquatch/was-node-suite-comfyui.git && \
    cd was-node-suite-comfyui && pip3 install -r requirements.txt && cd .. && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git && \
    cd ComfyUI-KJNodes && pip3 install -r requirements.txt
