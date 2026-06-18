.section .text

.globl _start

.tester:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rbp, %rdi
	call	xvargs_init

	call	xvargs_next
	call	xvargs_next

	leave
	ret


_start:
	pushq	$69
	pushq	$67
	call	.tester
	movq	%rax, %rdi
	movq	$60, %rax
	syscall

