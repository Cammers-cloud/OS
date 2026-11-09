FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install QEMU, UEFI firmware (OVMF), noVNC display server, and networking utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# Download a stripped, minimal 64-bit NT WinPE raw disk image (~350MB)
# Replace the URL placeholder below with your self-hosted minimal NT/WinPE .img file URL
RUN curl -L -o /workspace/micro_nt_kernel.img "https://example.com" || \
    echo "Placeholder: Ensure you place your stripped 64-bit Windows PE disk image at /workspace/micro_nt_kernel.img"

ENTRYPOINT ["/bin/bash"]
