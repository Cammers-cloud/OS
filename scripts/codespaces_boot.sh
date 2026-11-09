#!/bin/bash
echo "======= Starting Custom OS Environment Display Pipeline ======="

# 1. Start a virtual frame buffer (display) in the background
Xvfb :1 -screen 0 1280x720x24 &
sleep 2
export DISPLAY=:1

# 2. Start the web browser video proxy stream engine on Port 6080
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 6080 &
sleep 2

echo "======= Booting Ultra-Stripped 64-bit Windows NT Kernel ======="
echo "Anti-Cheat Obfuscation: Active"

# 3. Launch QEMU with deep hardware virtualization spoofing to bypass Hyperion Anti-Cheat
qemu-system-x86_64 \
    -m 2G \
    -smp cores=2 \
    -vnc :0 \
    -drive file=/workspace/micro_nt_kernel.img,format=raw,index=0,media=disk \
    -bios /usr/share/OVMF/OVMF_CODE.fd \
    -vga std \
    -device e1000,netdev=net0 \
    -netdev user,id=net0 \
    -machine type=q35,accel=kvm:tcg \
    -cpu host,kvm=off,hv_vendor_id=null,hv_time,hv_vapic,hv_relaxed,hv_spinlocks=0x1fff \
    -smbios type=1,manufacturer="ASUSTeK COMPUTER INC.",product="PRIME Z790-P",version="1.0",serial="MT7012345678" \
    -smbios type=2,manufacturer="ASUSTeK COMPUTER INC.",product="PRIME Z790-P",version="REV 1.xx",serial="MB-123456789" \
    -smbios type=3,manufacturer="ASUSTeK COMPUTER INC.",version="Chassis Version",serial="CH-987654"
