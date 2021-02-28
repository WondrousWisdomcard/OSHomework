# movetest1.s - Another example of using indexed memory locations
.section .data
	output:
		.asciz "The value is %d\n"
	values: 
		.int 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 
.section .text
.globl _start
_start:
	nop
	movl $0, %ecx
	lea output(%ecx), %rdi 
loop:
	mov values(, %ecx, 4), %rsi 
	
	call printf
	
	inc %ecx
	cmpl $11, %ecx
	jne loop
	movl $0, %ebx
	movl $1, %eax
	int $0x80
	


#as -o movtest3.o movtest3.s
#ld -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o movtest3 movtest3.o
#./movtest3
