``` bash
docker run -it -d --privileged --name rknn-lite2 \
            -v /dev/dri/renderD129:/dev/dri/renderD129 \
            -v /proc/device-tree/compatible:/proc/device-tree/compatible \
            ghcr.io/qy-gopher/rknn-lite2:latest
```
