BUILD := build
ISO_ROOT := $(BUILD)/iso
ROOTFS := $(BUILD)/rootfs
KERNEL := $(BUILD)/kernel.elf
ISO := $(BUILD)/mini64.iso
ISO_LIMIT := 134217728

NASM := nasm
CC := gcc
LD := ld

KERNEL_CFLAGS := -std=gnu11 -O2 -Wall -Wextra -Werror \
    -ffreestanding -fno-stack-protector -fno-pic -fno-pie \
    -fno-asynchronous-unwind-tables -fno-unwind-tables \
    -m64 -mno-red-zone -mcmodel=small -ffunction-sections -fdata-sections

.PHONY: all clean iso size-check check run pecheck rootfs

all: $(ISO) $(BUILD)/pecheck

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/boot.o: boot/boot.asm | $(BUILD)
	$(NASM) -f elf64 $< -o $@

$(BUILD)/kernel.o: kernel/kernel.c | $(BUILD)
	$(CC) $(KERNEL_CFLAGS) -c $< -o $@

$(KERNEL): $(BUILD)/boot.o $(BUILD)/kernel.o kernel/linker.ld
	$(LD) -m elf_x86_64 -nostdlib --gc-sections -T kernel/linker.ld \
		-o $@ $(BUILD)/boot.o $(BUILD)/kernel.o

$(BUILD)/pecheck: tools/pecheck.c kernel/pe32plus.h | $(BUILD)
	$(CC) -std=c11 -O2 -Wall -Wextra -Werror -Ikernel $< -o $@

$(BUILD)/rootfs.squashfs: | $(BUILD)
	mkdir -p $(ROOTFS)
	printf '%s\n' 'Mini64 root filesystem placeholder.' > $(ROOTFS)/README.txt
	mksquashfs $(ROOTFS) $@ -noappend -comp xz -b 128K

$(ISO): $(KERNEL) $(BUILD)/rootfs.squashfs boot/grub.cfg
	rm -rf $(ISO_ROOT)
	mkdir -p $(ISO_ROOT)/boot/grub
	cp $(KERNEL) $(ISO_ROOT)/boot/kernel.elf
	cp $(BUILD)/rootfs.squashfs $(ISO_ROOT)/boot/rootfs.squashfs
	cp boot/grub.cfg $(ISO_ROOT)/boot/grub/grub.cfg
	grub-mkrescue -o $@ $(ISO_ROOT)

iso: $(ISO)

size-check: $(ISO)
	@size=$$(stat -c%s $(ISO)); \
	echo "ISO size: $$size bytes (limit: $(ISO_LIMIT))"; \
	test "$$size" -le "$(ISO_LIMIT)"

check: $(ISO) $(BUILD)/pecheck
	grub-file --is-x86-multiboot2 $(KERNEL)
	file $(KERNEL) $(ISO)
	$(MAKE) size-check

run: $(ISO)
	./scripts/run.sh $(ISO)

pecheck: $(BUILD)/pecheck

clean:
	rm -rf $(BUILD)
