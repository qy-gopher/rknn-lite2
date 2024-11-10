# Huge repo, so clone with depth 1 and use this layer to get sources only
FROM ubuntu:24.04 AS source
RUN apt update && apt install -y git && git clone --depth 1 https://github.com/airockchip/rknn-toolkit2.git /rknn-toolkit2

# Copy the runtime library and headers to the runtime image.
# useful as a base for running c/c++ applications that use the rknn runtime, no need for the python libraries
FROM python:3.11.10-slim-bookworm AS rknn-lite2
COPY --from=source /rknn-toolkit2/rknpu2/runtime/Linux/librknn_api/include/* /usr/include/
COPY --from=source /rknn-toolkit2/rknpu2/runtime/Linux/librknn_api/aarch64/librknnrt.so /usr/lib/
COPY --from=source /rknn-toolkit2/rknn-toolkit-lite2/packages/rknn_toolkit_lite2-2.2.0-cp311-cp311-linux_aarch64.whl /
RUN ldconfig && \
    pip install --break-system-packages /rknn_toolkit_lite2-2.2.0-cp311-cp311-linux_aarch64.whl && \
    rm /rknn_toolkit_lite2-2.2.0-cp311-cp311-linux_aarch64.whl
