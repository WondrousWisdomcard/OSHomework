# test_long.s Test whether sizes + 8 can get the second long element 2
.section .data
output:
	.asciz "The second element is '%d'\n"
sizes:
	.long 1
.section .text
.global _start
_start:
	movl $0, %eax
	movl $sizes, %edi
	lea output(%rip), %rdi 
	lea sizes(%rip), %rsi
	call printf 
	pushq $0
	call exit
	
