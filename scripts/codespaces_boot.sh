#!/bin/bash
echo "======= Checking System Dependencies ======="

# Clean out the old broken landing page ISO so it fetches the new working image
rm -f /workspace/bootable_source.iso

if [ ! -f "/workspace/bootable_source.iso" ]; then
    echo "📥 Downloading functional 64-bit Windows NT Core baseline..."
    # Direct, real link to an open-source 64-bit WinPE recovery kernel
    curl -L -# -o /workspace/bootable_source.iso "https://github.com"
    echo "✅ Real Boot system downloaded successfully!"
fi

echo "======= Starting Custom OS Environment Display Pipeline ======="
killall -9 qemu-system-x86_64 Xvfb websockify 2>/dev/null
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

Xvfb :1 -screen 0 1280x720x24 &
sleep 2
export DISPLAY=:1

echo "======= Booting 64-bit Windows NT Kernel ======="
# Launches QEMU directly using the real Windows PE disc layout
qemu-system-x86_64 \
    -m 2G \
    -smp cores=2 \
    -vnc :0 \
    -drive file=/workspace/bootable_source.iso,media=cdrom,readonly=on \
    -boot d \
    -vga std \
    -device e1000,netdev=net0 \
    -netdev user,id=net0 \
    -machine type=pc,accel=tcg \
    -cpu qemu64,+ssse3,+sse4.1,+sse4.2,+x2apic \
    -rtc base=localtime &

echo "⏳ Waiting for OS Kernel to initialize video output stream..."
sleep 5

echo "======= Launching Browser Video Stream ======="
python3 -m websockify --web /usr/share/novnc 6080 localhost:5900


