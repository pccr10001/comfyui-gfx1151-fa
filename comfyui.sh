#!/bin/bash

if [ ! -e /opt/ComfyUI/requirements.txt ]; then
   echo "No existing ComfyUI detected, copying new one ..."
   cp -rf /opt/ComfyUI.new/{.,}* /opt/ComfyUI/
fi

cd /opt/ComfyUI
source /opt/.venv/bin/activate
python3 main.py "$@"
