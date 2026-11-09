#!/bin/bash
echo "======= Checking System Dependencies ======="

if [ ! -f "/workspace/micro_nt_kernel.img" ]; then
    echo "💾 Creating virtual hard drive image in the cloud..."
    qemu-img create -f raw /workspace/micro_nt_kernel.img 10G
    echo "✅ Drive created successfully!"
fi

if [ ! -f "/workspace/bootable_source.iso" ]; then
    echo "📥 Downloading ultra-light 64-bit Windows NT Core baseline..."
    # Direct, reliable link to an open-source 64-bit WinPE kernel image
    curl -L -# -o /workspace/bootable_source.iso "https://github.com/thedoggybrad/WindowsPEBasicEnhanced/releases/download/1.0/WinPEBasicEnhanced.iso"
    echo "✅ Boot system downloaded!"
fi

echo "======= Starting Custom OS Environment Display Pipeline ======="
# Raw process scavenger loop to clear port 6080 constraints dynamically
kill -9 $(pgrep -f "Xvfb|websockify|qemu") 2>/dev/null
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1

Xvfb :1 -screen 0 1280x720x24 &
sleep 2
export DISPLAY=:1

echo "======= Launching Browser Video Stream ======="
python3 -m websockify --web /usr/share/novnc 6080 localhost:5900 &
sleep 2

echo "======= Booting 64-bit Windows NT Kernel ======="
qemu-system-x86_64 \
    -m 2G \
    -smp cores=2 \
    -vnc :0 \
    -drive file=/workspace/micro_nt_kernel.img,format=raw,bus=0,unit=0,media=disk,if=ide \
    -cdrom /workspace/bootable_source.iso \
    -boot d \
    -vga std \
    -device e1000,netdev=net0 \
    -netdev user,id=net0 \
    -machine type=pc,accel=tcg \
    -cpu qemu64,+ssse3,+sse4.1,+sse4.2,+x2apic \
    -rtc base=localtime
