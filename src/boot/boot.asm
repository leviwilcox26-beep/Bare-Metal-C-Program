; Multiboot constants
MBALIGN equ 1 << 0		; align loaded modules on page boundries
MEMINFO equ 1 << 1		; provide memory map
FLAGS equ MBALIGN | MEMINFO	; Multiboot flag field
MAGIC equ 0x1BADB002		; Magic number allowing bootloader to find header
CHECKSUM equ -(MAGIC + FLAGS)	; Checksum to validate multiboot header

section .multiboot
align 4
	dd MAGIC
	dd FLAGS
	dd CHECKSUM

; Allocate 16 KiB stack
section .bss
align 16
stack_bottom:
resb 16384 ; 16 KiB
stack_top:

; Entry point
section .text
global _start:function (_start.end - _start)
_start:
	;Initialize stack pointer
	mov esp, stack_top

	; Call our C kernel main function
	extern kernel_main
	call kernel_main
	
	; Halt the CPU if kernel_main ever returns
	cli
.hang:
	hlt
	jmp .hang
.end:
