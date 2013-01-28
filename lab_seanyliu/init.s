	.file	"init.c"
	.stabs	"kern/init.c",100,0,0,.Ltext0
	.text
.Ltext0:
	.stabs	"gcc2_compiled.",60,0,0,0
	.stabs	"int:t(0,1)=r(0,1);-2147483648;2147483647;",128,0,0,0
	.stabs	"char:t(0,2)=r(0,2);0;127;",128,0,0,0
	.stabs	"long int:t(0,3)=r(0,3);-2147483648;2147483647;",128,0,0,0
	.stabs	"unsigned int:t(0,4)=r(0,4);0;-1;",128,0,0,0
	.stabs	"long unsigned int:t(0,5)=r(0,5);0;-1;",128,0,0,0
	.stabs	"long long int:t(0,6)=r(0,6);0;-1;",128,0,0,0
	.stabs	"long long unsigned int:t(0,7)=r(0,7);0;-1;",128,0,0,0
	.stabs	"short int:t(0,8)=r(0,8);-32768;32767;",128,0,0,0
	.stabs	"short unsigned int:t(0,9)=r(0,9);0;65535;",128,0,0,0
	.stabs	"signed char:t(0,10)=r(0,10);-128;127;",128,0,0,0
	.stabs	"unsigned char:t(0,11)=r(0,11);0;255;",128,0,0,0
	.stabs	"float:t(0,12)=r(0,1);4;0;",128,0,0,0
	.stabs	"double:t(0,13)=r(0,1);8;0;",128,0,0,0
	.stabs	"long double:t(0,14)=r(0,1);12;0;",128,0,0,0
	.stabs	"complex int:t(0,15)=s8real:(0,1),0,32;imag:(0,1),32,32;;",128,0,0,0
	.stabs	"complex float:t(0,16)=R3;8;0;",128,0,0,0
	.stabs	"complex double:t(0,17)=R3;16;0;",128,0,0,0
	.stabs	"complex long double:t(0,18)=R3;24;0;",128,0,0,0
	.stabs	"void:t(0,19)=(0,19)",128,0,0,0
	.stabs	"__builtin_va_list:t(0,20)=*(0,2)",128,0,0,0
	.stabs	"_Bool:t(0,21)=eFalse:0,True:1,;",128,0,0,0
	.stabs	"./inc/stdio.h",130,0,0,0
	.stabs	"./inc/stdarg.h",130,0,0,0
	.stabs	"va_list:t(2,1)=(0,20)",128,0,0,0
	.stabn	162,0,0,0
	.stabn	162,0,0,0
	.stabs	"./inc/string.h",130,0,0,0
	.stabs	"./inc/types.h",130,0,0,0
	.stabs	"bool:t(4,1)=(0,1)",128,0,0,0
	.stabs	"int8_t:t(4,2)=(0,10)",128,0,0,0
	.stabs	"uint8_t:t(4,3)=(0,11)",128,0,0,0
	.stabs	"int16_t:t(4,4)=(0,8)",128,0,0,0
	.stabs	"uint16_t:t(4,5)=(0,9)",128,0,0,0
	.stabs	"int32_t:t(4,6)=(0,1)",128,0,0,0
	.stabs	"uint32_t:t(4,7)=(0,4)",128,0,0,0
	.stabs	"int64_t:t(4,8)=(0,6)",128,0,0,0
	.stabs	"uint64_t:t(4,9)=(0,7)",128,0,0,0
	.stabs	"intptr_t:t(4,10)=(4,6)",128,0,0,0
	.stabs	"uintptr_t:t(4,11)=(4,7)",128,0,0,0
	.stabs	"physaddr_t:t(4,12)=(4,7)",128,0,0,0
	.stabs	"ppn_t:t(4,13)=(4,7)",128,0,0,0
	.stabs	"size_t:t(4,14)=(4,7)",128,0,0,0
	.stabs	"ssize_t:t(4,15)=(4,6)",128,0,0,0
	.stabs	"off_t:t(4,16)=(4,6)",128,0,0,0
	.stabn	162,0,0,0
	.stabn	162,0,0,0
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"entering test_backtrace %d\n"
.LC1:
	.string	"leaving test_backtrace %d\n"
	.text
	.align 4
	.stabs	"test_backtrace:F(0,19)",36,0,0,test_backtrace
	.stabs	"x:p(0,1)",160,0,0,8
.globl test_backtrace
	.type	test_backtrace, @function
test_backtrace:
	.stabn 68,0,13,.LM1-test_backtrace
.LM1:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$12, %esp
	.stabn 68,0,13,.LM2-test_backtrace
.LM2:
	movl	8(%ebp), %ebx
	.stabn 68,0,14,.LM3-test_backtrace
.LM3:
	pushl	%ebx
	pushl	$.LC0
	call	cprintf
	.stabn 68,0,15,.LM4-test_backtrace
.LM4:
	addl	$16, %esp
	testl	%ebx, %ebx
	jle	.L2
	.stabn 68,0,16,.LM5-test_backtrace
.LM5:
	leal	-1(%ebx), %eax
	subl	$12, %esp
	pushl	%eax
	call	test_backtrace
	.stabn 68,0,18,.LM6-test_backtrace
.LM6:
	popl	%eax
	popl	%edx
	.stabn 68,0,19,.LM7-test_backtrace
.LM7:
	pushl	%ebx
	pushl	$.LC1
	call	cprintf
	movl	-4(%ebp), %ebx
	leave
	ret
	.align 4
.L2:
	.stabn 68,0,18,.LM8-test_backtrace
.LM8:
	pushl	%ecx
	pushl	$0
	pushl	$0
	pushl	$0
	call	mon_backtrace
	popl	%eax
	popl	%edx
	.stabn 68,0,19,.LM9-test_backtrace
.LM9:
	pushl	%ebx
	pushl	$.LC1
	call	cprintf
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	test_backtrace, .-test_backtrace
	.stabs	"x:r(0,1)",64,0,0,3
	.section	.rodata.str1.1
.LC2:
	.string	"6828 decimal is %o octal!\n"
	.text
	.align 4
	.stabs	"i386_init:F(0,19)",36,0,0,i386_init
.globl i386_init
	.type	i386_init, @function
i386_init:
	.stabn 68,0,24,.LM10-i386_init
.LM10:
	pushl	%ebp
	.stabn 68,0,30,.LM11-i386_init
.LM11:
	movl	$end, %eax
	.stabn 68,0,24,.LM12-i386_init
.LM12:
	movl	%esp, %ebp
	.stabn 68,0,30,.LM13-i386_init
.LM13:
	subl	$edata, %eax
	.stabn 68,0,24,.LM14-i386_init
.LM14:
	subl	$12, %esp
	.stabn 68,0,30,.LM15-i386_init
.LM15:
	pushl	%eax
	pushl	$0
	pushl	$edata
	call	memset
	.stabn 68,0,34,.LM16-i386_init
.LM16:
	call	cons_init
	.stabn 68,0,36,.LM17-i386_init
.LM17:
	popl	%eax
	popl	%edx
	pushl	$6828
	pushl	$.LC2
	call	cprintf
	.stabn 68,0,45,.LM18-i386_init
.LM18:
	movl	$5, (%esp)
	call	test_backtrace
	.align 4
.L10:
	.stabn 68,0,49,.LM19-i386_init
.LM19:
	movl	$0, (%esp)
	call	monitor
	jmp	.L10
	.size	i386_init, .-i386_init
	.section	.rodata.str1.1
.LC3:
	.string	"kernel panic at %s:%d: "
.LC4:
	.string	"\n"
	.text
	.align 4
	.stabs	"_panic:F(0,19)",36,0,0,_panic
	.stabs	"file:p(0,22)=*(0,2)",160,0,0,8
	.stabs	"line:p(0,1)",160,0,0,12
	.stabs	"fmt:p(0,22)",160,0,0,16
.globl _panic
	.type	_panic, @function
_panic:
	.stabn 68,0,65,.LM20-_panic
.LM20:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	.stabn 68,0,65,.LM21-_panic
.LM21:
	pushl	%eax
	.stabn 68,0,68,.LM22-_panic
.LM22:
	movl	panicstr, %eax
	testl	%eax, %eax
	jne	.L14
	.stabn 68,0,70,.LM23-_panic
.LM23:
	movl	16(%ebp), %eax
	movl	%eax, panicstr
	.stabn 68,0,73,.LM24-_panic
.LM24:
	pushl	%eax
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	$.LC3
	call	cprintf
	.stabn 68,0,74,.LM25-_panic
.LM25:
	popl	%ecx
	popl	%eax
	.stabn 68,0,72,.LM26-_panic
.LM26:
	leal	20(%ebp), %ebx
	.stabn 68,0,74,.LM27-_panic
.LM27:
	pushl	%ebx
	pushl	16(%ebp)
	call	vcprintf
	.stabn 68,0,75,.LM28-_panic
.LM28:
	movl	$.LC4, (%esp)
	call	cprintf
	.align 4
.L16:
	.stabn 68,0,76,.LM29-_panic
.LM29:
	addl	$16, %esp
.L13:
.L14:
	.stabn 68,0,81,.LM30-_panic
.LM30:
	subl	$12, %esp
	pushl	$0
	call	monitor
	jmp	.L16
	.size	_panic, .-_panic
	.stabs	"ap:r(2,1)",64,0,0,3
	.section	.rodata.str1.1
.LC5:
	.string	"kernel warning at %s:%d: "
	.text
	.align 4
	.stabs	"_warn:F(0,19)",36,0,0,_warn
	.stabs	"file:p(0,22)",160,0,0,8
	.stabs	"line:p(0,1)",160,0,0,12
	.stabs	"fmt:p(0,22)",160,0,0,16
.globl _warn
	.type	_warn, @function
_warn:
	.stabn 68,0,87,.LM31-_warn
.LM31:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$8, %esp
	.stabn 68,0,91,.LM32-_warn
.LM32:
	pushl	12(%ebp)
	pushl	8(%ebp)
	pushl	$.LC5
	call	cprintf
	.stabn 68,0,92,.LM33-_warn
.LM33:
	popl	%eax
	popl	%edx
	.stabn 68,0,90,.LM34-_warn
.LM34:
	leal	20(%ebp), %ebx
	.stabn 68,0,92,.LM35-_warn
.LM35:
	pushl	%ebx
	pushl	16(%ebp)
	call	vcprintf
	.stabn 68,0,93,.LM36-_warn
.LM36:
	movl	$.LC4, (%esp)
	call	cprintf
	.stabn 68,0,94,.LM37-_warn
.LM37:
	movl	-4(%ebp), %ebx
	leave
	ret
	.size	_warn, .-_warn
	.stabs	"ap:r(2,1)",64,0,0,3
	.local	panicstr
	.comm	panicstr,4,4
	.stabs	"panicstr:S(0,22)",40,0,0,panicstr
	.text
	.stabs "",100,0,0,.Letext
.Letext:
	.ident	"GCC: (GNU) 3.4.1"
