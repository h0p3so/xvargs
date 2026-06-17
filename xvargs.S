.section .rodata
	._xvargs_fatal_busy_address_msg: .string "xvargs: cannot invoke two instances of xvargs at the same time\n"
	._xvargs_fatal_busy_address_len: .quad   63

.section .bss
	._xvargs_callers_rbp:  .zero 8
	._xvargs_stack_offset: .zero 8
#ifdef XVARG_SAFE
	._xvargs_safe_limit:   .zero 8
	._xvargs_safe_default: .zero 8
#endif

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

._xvargs_fatal_busy_address:
	_xvargs_fatal ._xvargs_fatal_busy_address_msg(%rip), ._xvargs_fatal_busy_address_len(%rip)

.globl xvargs_init
.globl xvargs_next
.globl xvargs_fini

# arguments
# rdi: address of `rbp`		               u64
# rsi: sugguest limit		               u64 only if XVARG_SAFE is present
# rdx: default value if limit is exceeded  any only if XVARG_SAFE is present
xvargs_init:	
	pushq	%rbp
	movq	%rsp, %rbp
	movq	._xvargs_callers_rbp(%rip), %rax
	testq	%rax, %rax
	jnz		._xvargs_fatal_busy_address
	leaq	._xvargs_callers_rbp(%rip), %rax
	movq	%rdi, (%rax)
#ifdef XVARG_SAFE
	je		._xvargs_fatal_busy_address // TODO
	leaq	._xvargs_safe_limit(%rip), %rax
	movq	%rsi, (%rax)
	leaq	._xvargs_safe_default(%rip), %rax
	movq	%rdx, (%rax)
#endif
	leave
	ret

xvargs_next:

xvargs_fini:


#       | rbp
#       | return address
# stack | arg1
#       | arg2
#       | arg3
#       v
