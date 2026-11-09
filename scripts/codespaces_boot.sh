#!/bin/bash
echo "======= Checking System Dependencies ======="

if [ ! -f "/workspace/micro_nt_kernel.img" ]; then
    echo "💾 Custom Windows Kernel Image not found locally."
    echo "📥 Downloading compressed NT image to workspace..."
    curl -L -# -o /workspace/micro_nt_kernel.img "https://example.com"
    if [ $? -ne 0 ]; then
        echo "❌ ERROR: Download failed."
        exit 1
    fi
    echo "✅ Download complete!"
fi

echo "======= Starting Custom OS Environment Display Pipeline ======="
Xvfb :1 -screen 0 1280x720x24 &
sleep 2
export DISPLAY=:1

/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 6080 &
sleep 2

echo "======= Booting 64-bit Windows NT Kernel (Software Emulation) ======="

# CHANGED: 
# Forced accel=tcg (Software acceleration) so it works on any GitHub server without crashing.
qemu-system-x86_64 \
    -m 2G \
    -smp cores=2 \
    -vnc :0 \
    -drive file=/workspace/micro_nt_kernel.img,format=raw,bus=0,unit=0,media=disk,if=ide \
    -vga std \
    -device e1000,netdev=net0 \
    -netdev user,id=net0 \
    -machine type=pc,accel=tcg \
    -cpu qemu64,+ssse3,+sse4.1,+sse4.2,+x2apic \
    -rtc base=localtime
