# Huge repo, so clone with depth 1 and use this layer to get sources only
FROM ubuntu:24.04 AS source
RUN apt update && apt install -y git && git clone --depth 1 https://github.com/airockchip/rknn-toolkit2.git /rknn-toolkit2

# Copy the runtime library and headers to the runtime image.
# useful as a base for running c/c++ applications that use the rknn runtime, no need for the python libraries
FROM python:3.11.10-slim-bookworm AS rknn-lite2
COPY --from=source /rknn-toolkit2/rknpu2/runtime/Linux/librknn_api/include/* /usr/include/
COPY --from=source /rknn-toolkit2/rknpu2/runtime/Linux/librknn_api/aarch64/librknnrt.so /usr/lib/
COPY --from=source /rknn-toolkit2/rknn-toolkit-lite2/packages/rknn_toolkit_lite2-2.3.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl /
RUN ldconfig && \
    apt update && apt install -y libgl1 libglib2.0-0 && \
    pip install /rknn_toolkit_lite2-2.3.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl && \
    pip install opencv_contrib_python six fastapi uvicorn python-multipart orjson pillow && \
    rm /rknn_toolkit_lite2-2.3.0-cp311-cp311-manylinux_2_17_aarch64.manylinux2014_aarch64.whl
