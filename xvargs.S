.section .rodata
	.xvargs_err_busy_address_msg: .string "xvargs: cannot invoke two instances of xvargs at the same time\n"
	.xvargs_err_busy_address_len: .quad   63

.section .bss
	.callers_rbp:  .zero 8
	.stack_offset: .zero 8

.section .text

.macro _xvargs_fatal msg, len
	movq	$1, %rax
	movq	$2, %rdi
	leaq	\msg, %rsi
	movq	\len, %rdx
	syscall
	movq	$60, %rax
	movq	$1, %rdi
	syscall
.endm

.globl xvargs_init
.globl xvargs_next
.globl xvargs_fini

# arguments
# rdi: address of `rbp`
xvargs_init:	
	je		.xvargs_err_busy_address
	pushq	%rbp
	movq	%rsp, %rbp
	movq	.callers_rbp(%rip), %rax
	testq	%rax, %rax
	jnz		.xvargs_err_busy_address
	leaq	.callers_rbp(%rip), %rax
	movq	%rdi, (%rax)
	leave
	ret

xvargs_next:

xvargs_fini:

.xvargs_err_busy_address:
	_xvargs_fatal .xvargs_err_busy_address_msg(%rip), .xvargs_err_busy_address_len(%rip)

#       | rbp
#       | return address
# stack | arg1
#       | arg2
#       | arg3
#       v
