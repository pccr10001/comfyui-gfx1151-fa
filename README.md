ComfyUI for AMD Ryzen AI MAX+ 395 with Flash Attention
---

### Docker
* Edit `docker-compose.yml`
  * Replace `group_add` with `video` and `render` GID.
* Launch with `CUID=$(id -u) CGID=$(id -g) docker compose up -d`

