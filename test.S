.section .text

.globl _start

.tester:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rbp, %rdi
	call	xvargs_init

	leave
	ret


_start:
	call	.tester
	movq	$60, %rax
	movq	$0, %rdi
	syscall

