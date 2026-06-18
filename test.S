.section .text

.globl _start

.tester:
	pushq	%rbp
	movq	%rsp, %rbp

	movq	%rbp, %rdi
	movq	$2, %rsi
	movq	$96, %rdx
	call	xvargs_init

	call	xvargs_next
	call	xvargs_next
	call	xvargs_next

	leave
	ret


_start:
	pushq	$254
	pushq	$134
	call	.tester
	movq	%rax, %rdi
	movq	$60, %rax
	syscall

