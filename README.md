ComfyUI for AMD Ryzen AI MAX+ 395 with Flash Attention
---

### Manual Installation
* Install docker
* Launch container with official ROCm image
```
docker run -it --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
--device=/dev/kfd --device=/dev/dri --group-add video \
-v `pwd`/ComfyUI:/opt/ComfyUI -p 8188:8188 \
--ipc=host --shm-size 8G ghcr.io/rocm/no_rocm_image_ubuntu24_04:main
```
* Grab wheels from [release](https://github.com/pccr10001/rocm-pytorch-gfx1151/releases)
* Install wheels
```
pip install ./torch-2.8.0a0+gitba56102-cp312-cp312-linux_x86_64.whl ./torchaudio-2.8.0a0+6e1c7fe-cp312-cp312-linux_x86_64.whl ./torchvision-0.23.0a0+824e8c8-cp312-cp312-linux_x86_64.whl  ./flash_attn-2.0.4-cp312-cp312-linux_x86_64.whl  --break-system-packages
```
* Install ROCm Python dependences
```
pip install --index-url https://d2awnip2yjpvqn.cloudfront.net/v2/gfx1151/ rocm[libraries,devel] --break-system-packages
```
* Install ComfyUI dependences
```
pip install -r requirements.txt --break-system-packages
```
* Fix ROCm library path
```
echo /usr/local/lib/python3.12/dist-packages/_rocm_sdk_core/lib >> /etc/ld.so.conf
ldconfig
```
* Launch ComfyUI
```
PYTORCH_TUNABLEOP_ENABLED=1 MIOPEN_FIND_MODE=FAST ROCBLAS_USE_HIPBLASLT=1 python3 main.py --listen 0.0.0.0 --use-flash-attention
```
* Happy generating

### Docker
* Execute `id` to get the current user UID and GID, then check `video` and `render` GID.
```
user@gpu395:~/rocm-pytorch-gfx1151-fa$ id
uid=1000(user) gid=1000(user) groups=1000(user),4(adm),24(cdrom),27(sudo),30(dip),44(video),46(plugdev),101(lxd),988(docker),993(render)
```
* Edit `docker-compose.yml`
  * Replace `user` with current UID and GID.
  * Replace `group_add` with `video` and `render` GID.
  * Replace `./ComfyUI` with your root of ComfyUI, you can create an empty directory for this.
* Launch with `docker compose up -d`
