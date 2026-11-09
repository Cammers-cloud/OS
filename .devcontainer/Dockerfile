FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Added 'git' alongside our emulation and streaming dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    qemu-system-x86 \
    ovmf \
    novnc \
    websockify \
    x11vnc \
    xvfb \
    curl \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

ENTRYPOINT ["/bin/bash"]
