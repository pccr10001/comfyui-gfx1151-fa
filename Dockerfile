# ROCm 260109
FROM ghcr.io/rocm/no_rocm_image_ubuntu24_04:main AS builder

USER root

RUN apt update && apt install -y aria2
RUN aria2c -x 16 -s 16 https://therock-nightly-tarball.s3.amazonaws.com/therock-dist-linux-gfx1151-7.11.0a20260109.tar.gz -o therock.tar.gz -d /tmp
RUN mkdir /opt/rocm && tar xvf /tmp/therock.tar.gz -C /opt/rocm

FROM ghcr.io/rocm/no_rocm_image_ubuntu24_04:main

USER root

COPY --from=builder /opt/rocm /opt/rocm

ENV WHL_BASE=https://github.com/pccr10001/rocm-pytorch-gfx1151-fa/releases/download/v2.9.1-ROCm-7.0rc-260109/
ENV FLASH_ATTN_WHL=flash_attn-2.0.4-cp312-cp312-linux_x86_64.whl
ENV TORCH_WHL=torch-2.9.1+git7e1940d-cp312-cp312-linux_x86_64.whl 
ENV TORCHAUDIO_WHL=torchaudio-2.9.1+a224ab2-cp312-cp312-linux_x86_64.whl 
ENV TORCHVISION_WHL=torchvision-0.24.1+d801a34-cp312-cp312-linux_x86_64.whl 

ADD https://astral.sh/uv/install.sh /uv-installer.sh

RUN apt update && apt install -y --no-install-recommends curl ca-certificates wget git
RUN bash -c "UV_INSTALL_DIR=/usr/local/bin sh /uv-installer.sh" && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"
ENV ROCM_PATH="/opt/rocm"

RUN mkdir /opt/whl && cd /opt/whl && \
    wget $WHL_BASE$FLASH_ATTN_WHL && \
    wget $WHL_BASE$TORCH_WHL && \
    wget $WHL_BASE$TORCHAUDIO_WHL && \
    wget $WHL_BASE$TORCHVISION_WHL

RUN echo -n "\n$ROCM_PATH/lib\n$ROCM_PATH/lib64\n$ROCM_PATH/llvm/lib\n$ROCM_PATH/lib/llvm/lib/clang/20/lib/linux\n$ROCM_PATH/lib/rocm_sysdeps/lib\n$ROCM_PATH/lib/host-math/lib" >> /etc/ld.so.conf && ldconfig

ADD comfyui.sh /opt/comfyui.sh
RUN chmod +x /opt/comfyui.sh

EXPOSE 8188

ENTRYPOINT ["/opt/comfyui.sh"]


