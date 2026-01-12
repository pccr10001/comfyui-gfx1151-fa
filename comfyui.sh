#!/bin/bash

export PATH=/root/.local/bin/:$PATH

if [ ! -e /opt/.venv/bin/activate ]; then
    echo "No existing venv detected, making new one ..."
    cd /opt && uv venv -p 3.12 .venv --clear
    source /opt/.venv/bin/activate
    uv pip install /opt/whl/*
else
    source /opt/.venv/bin/activate
fi


if [ ! -e /opt/ComfyUI/requirements.txt ]; then
   echo "No existing ComfyUI detected, cloning new one ..."
   cd /opt/ComfyUI && git clone https://github.com/Comfy-Org/ComfyUI .
fi

export HIPBLASLT_TENSILE_LIBPATH=/opt/rocm/lib/hipblaslt/library
export ROCBLAS_TENSILE_LIBPATH=/opt/rocm/lib/rocblas/library
export HIP_DEVICE_LIB_PATH="/opt/rocm/lib/llvm/amdgcn/bitcode"

cd /opt/ComfyUI
uv pip install -r requirements.txt
python3 main.py "$@"
