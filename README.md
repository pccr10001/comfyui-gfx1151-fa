ComfyUI for AMD Ryzen AI MAX+ 395 with Flash Attention
---

### Docker
* Edit `docker-compose.yml`
  * Replace `group_add` with `video` and `render` GID.
* Launch with following command:
```bash=
VIDEO_GID="$(getent group video  | cut -d: -f3)" \
RENDER_GID="$(getent group render | cut -d: -f3)" \
CUID=$(id -u) CGID=$(id -g) docker compose up -d
```

