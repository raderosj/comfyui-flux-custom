#!/bin/bash
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password='' &
python3 /ComfyUI/main.py --listen 0.0.0.0 --port 8188
