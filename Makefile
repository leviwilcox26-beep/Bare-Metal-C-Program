# Compiler & Toolchain Setup
CC = gcc
AS = nasm
LD = ld

# Flags
CFLAGS = -m32 -std=gnu99 -ffreestanding -O2 -Wall -Wextra -Isrc/include
ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T linker.ld

# Directories
SRC_DIR = src
BUILD_DIR = build

# Object Files
OBJS = $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o

all: $(BUILD_DIR)/mykernel.bin

# Assemble assembly bootloader
$(BUILD_DIR)/boot.o: $(SRC_DIR)/boot/boot.asm | $(BUILD_DIR)
	$(AS) $(ASFLAGS) $(SRC_DIR)/boot/boot.asm -o $(BUILD_DIR)/boot.o

# Compile C kernel
$(BUILD_DIR)/kernel.o: $(SRC_DIR)/kernel/kernel.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $(SRC_DIR)/kernel/kernel.c -o $(BUILD_DIR)/kernel.o

# Link binary image
$(BUILD_DIR)/mykernel.bin: $(OBJS)
	$(LD) $(LDFLAGS) -o $(BUILD_DIR)/mykernel.bin $(OBJS)

# Ensure build directory exists
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Run kernel in QEMU
run: $(BUILD_DIR)/mykernel.bin
	qemu-system-i386 -kernel $(BUILD_DIR)/mykernel.bin

# Clean up built artifacts
clean:
	rm -rf $(BUILD_DIR)
