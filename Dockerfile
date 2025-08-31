# ROCm 250715
FROM ghcr.io/rocm/therock_pytorch_dev_ubuntu_24_04_gfx1151@sha256:c75281ccdcdcb7c41f40509f19580a4e2ef7a7cbf68efa5d039a34cc3e68a44f

ENV WHL_BASE=https://github.com/pccr10001/rocm-pytorch-gfx1151-fa/releases/download/v2.8.0a0/
ENV FLASH_ATTN_WHL=flash_attn-2.0.4-cp312-cp312-linux_x86_64.whl
ENV TORCH_WHL=torch-2.8.0a0+gitba56102-cp312-cp312-linux_x86_64.whl
ENV TORCHAUDIO_WHL=torchaudio-2.8.0a0+6e1c7fe-cp312-cp312-linux_x86_64.whl
ENV TORCHVISION_WHL=torchvision-0.23.0a0+824e8c8-cp312-cp312-linux_x86_64.whl

ADD https://astral.sh/uv/install.sh /uv-installer.sh

RUN apt update && apt install -y --no-install-recommends curl ca-certificates wget git
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"

RUN pip uninstall torch torchvision torchaudio --break-system-packages -y

RUN cd /opt && git clone https://github.com/comfyanonymous/ComfyUI ComfyUI.new
RUN cd /opt && uv venv --python=3.12

RUN bash -c "cd /opt/ComfyUI.new && source /opt/.venv/bin/activate && uv pip install --index-url https://d2awnip2yjpvqn.cloudfront.net/v2/gfx1151/ rocm[libraries,devel]"
RUN echo /opt/.venv/lib/python3.12/site-packages/_rocm_sdk_core/lib >> /etc/ld.so.conf && ldconfig
RUN cd /tmp && \
    wget $WHL_BASE$FLASH_ATTN_WHL && \
    wget $WHL_BASE$TORCH_WHL && \
    wget $WHL_BASE$TORCHAUDIO_WHL && \
    wget $WHL_BASE$TORCHVISION_WHL

RUN cd /tmp && bash -c "source /opt/.venv/bin/activate && \
    uv pip install ./$FLASH_ATTN_WHL ./$TORCH_WHL ./$TORCHAUDIO_WHL ./$TORCHVISION_WHL"

RUN cd /opt/ComfyUI.new && bash -c "source /opt/.venv/bin/activate && \
    uv pip install -r requirements.txt"

ADD comfyui.sh /opt/comfyui.sh
RUN chmod +x /opt/comfyui.sh

EXPOSE 8188

ENTRYPOINT ["/opt/comfyui.sh"]


