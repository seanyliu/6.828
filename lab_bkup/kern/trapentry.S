/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* The TRAPHANDLER macro defines a globally-visible function for handling
 * a trap.  It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 */ 
#define TRAPHANDLER(name, num)						\
        .text;								\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps;							\
        .data;								\
        .long name

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
        .text;								\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps;							\
        .data;								\
        .long name

# vector table
.data
.globl vectors
vectors:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
#define IRQ_OFFSET 32

  TRAPHANDLER_NOEC(handler0, T_DIVIDE); /* DIVIDE is already used */
  TRAPHANDLER_NOEC(handler1, T_DEBUG);
  TRAPHANDLER_NOEC(handler2, T_NMI);
  TRAPHANDLER_NOEC(handler3, T_BRKPT);
  TRAPHANDLER_NOEC(handler4, T_OFLOW);
  TRAPHANDLER_NOEC(handler5, T_BOUND);
  TRAPHANDLER_NOEC(handler6, T_ILLOP);
  TRAPHANDLER_NOEC(handler7, T_DEVICE);
  TRAPHANDLER(handler8, T_DBLFLT);
/* handler9: */
  TRAPHANDLER(handler9, T_DIVIDE); // need for cleanliness of table
  TRAPHANDLER(handler10, T_TSS);
  TRAPHANDLER(handler11, T_SEGNP);
  TRAPHANDLER(handler12, T_STACK);
  TRAPHANDLER(handler13, T_GPFLT);
  TRAPHANDLER(handler14, T_PGFLT);
/*handler15:*/
/*  TRAPHANDLER(RES, T_RES);*/
  TRAPHANDLER(handler15, T_PGFLT); // need for cleanliness of table
  TRAPHANDLER_NOEC(handler16, T_FPERR);
  TRAPHANDLER_NOEC(handler17, T_ALIGN);
  TRAPHANDLER_NOEC(handler18, T_MCHK);
  TRAPHANDLER_NOEC(handler19, T_SIMDERR );

# vector table
.data
.globl irqs
irqs:
.text

  TRAPHANDLER_NOEC(handler32, IRQ_OFFSET + IRQ_TIMER);
  TRAPHANDLER_NOEC(handler33, IRQ_OFFSET + IRQ_KBD);
  TRAPHANDLER_NOEC(handler34, IRQ_OFFSET + 2);
  TRAPHANDLER_NOEC(handler35, IRQ_OFFSET + 3);
  TRAPHANDLER_NOEC(handler36, IRQ_OFFSET + 4);
  TRAPHANDLER_NOEC(handler37, IRQ_OFFSET + 5);
  TRAPHANDLER_NOEC(handler38, IRQ_OFFSET + 6);
  TRAPHANDLER_NOEC(handler39, IRQ_OFFSET + IRQ_SPURIOUS);
  TRAPHANDLER_NOEC(handler40, IRQ_OFFSET + 8);
  TRAPHANDLER_NOEC(handler41, IRQ_OFFSET + 9);
  TRAPHANDLER_NOEC(handler42, IRQ_OFFSET + 10);
  TRAPHANDLER_NOEC(handler43, IRQ_OFFSET + 11);
  TRAPHANDLER_NOEC(handler44, IRQ_OFFSET + 12);
  TRAPHANDLER_NOEC(handler45, IRQ_OFFSET + 13);
  TRAPHANDLER_NOEC(handler46, IRQ_OFFSET + IRQ_IDE);
  TRAPHANDLER_NOEC(handler47, IRQ_OFFSET + 14);


  TRAPHANDLER_NOEC(handler48, T_SYSCALL);
  TRAPHANDLER_NOEC(handler51, IRQ_OFFSET + IRQ_ERROR);
  TRAPHANDLER_NOEC(handler500, T_DEFAULT);

/*
 * Lab 3: Your code here for _alltraps
1. push values to make the stack look like a struct Trapframe
2. load GD_KD into %ds and %es
3. pushl %esp to pass a pointer to the Trapframe as an argument to trap()
4. call trap (can trap ever return?)
 */

_alltraps:
  # reference xv6 :-)

  # 1. push values to make the stack look like a struct Trapframe
  # Build trap frame.
  pushl %ds
  pushl %es
  # pushl %fs # not in JOS
  # pushl %gs # not in JOS
  pushal

  # 2. load GD_KD into %ds and %es
  # movw $(GD_KD<<3), %ax
  movw $(GD_KD), %ax
  movw %ax, %ds
  movw %ax, %es

  # 3. pushl %esp to pass a pointer to the Trapframe as an argument to trap()
  # 4. call trap (can trap ever return?)
  # Call trap(tf), where tf=%esp
  pushl %esp
  call trap
  addl $4, %esp

  # Return falls through to trapret...
  popal
  popl %es
  popl %ds
  addl $0x8, %esp  # trapno and errcode
  iret

