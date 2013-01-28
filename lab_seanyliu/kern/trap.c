#include <inc/mmu.h>
#include <inc/x86.h>
#include <inc/assert.h>
//#include <inc/string.h> // include memset

#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/env.h>
#include <kern/syscall.h>
#include <kern/sched.h>
#include <kern/kclock.h>
#include <kern/picirq.h>
#include <kern/time.h>
#include <kern/e100.h>

static struct Taskstate ts;

/* Interrupt descriptor table.  (Must be built at run time because
 * shifted function addresses can't be represented in relocation records.)
 */
struct Gatedesc idt[256] = { { 0 } };
struct Pseudodesc idt_pd = {
	sizeof(idt) - 1, (uint32_t) idt
};


static const char *trapname(int trapno)
{
	static const char * const excnames[] = {
		"Divide error",
		"Debug",
		"Non-Maskable Interrupt",
		"Breakpoint",
		"Overflow",
		"BOUND Range Exceeded",
		"Invalid Opcode",
		"Device Not Available",
		"Double Fault",
		"Coprocessor Segment Overrun",
		"Invalid TSS",
		"Segment Not Present",
		"Stack Fault",
		"General Protection",
		"Page Fault",
		"(unknown trap)",
		"x87 FPU Floating-Point Error",
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
		return "Hardware Interrupt";
	return "(unknown trap)";
}


void
idt_init(void)
{
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.
        // seanyliu
        int idx;
        void *handler_ptr;
        extern int vectors[]; // in trapentry.S
        extern int irqs[]; // in trapentry.S

        for (idx = 0; idx < 19; idx++) {
          SETGATE(idt[idx], 0, GD_KT, vectors[idx], 0);
        }

        extern char handler3;
        handler_ptr = &handler3;
        SETGATE(idt[T_BRKPT], 0, GD_KT, handler_ptr, 3);

        for (idx = 0; idx < 16; idx++) {
          SETGATE(idt[IRQ_OFFSET + idx], 0, GD_KT, irqs[idx], 0);
        }

        extern char handler48;
        handler_ptr = &handler48;
        //SETGATE(idt[T_SYSCALL], 1, GD_KT, handler_ptr, 3);
        SETGATE(idt[T_SYSCALL], 0, GD_KT, handler_ptr, 3);

        extern char handler500;
        handler_ptr = &handler500;
        SETGATE(idt[T_DEFAULT], 0, GD_KT, handler_ptr, 0);

/*
        extern char handler32;
        handler_ptr = &handler32;
        SETGATE(idt[(32 + IRQ_TIMER)], 0, GD_KT, handler_ptr, 0);

        extern char handler33;
        handler_ptr = &handler33;
        SETGATE(idt[(32 + IRQ_KBD)], 0, GD_KT, handler_ptr, 0);

        extern char handler39;
        handler_ptr = &handler39;
        SETGATE(idt[(32 + IRQ_SPURIOUS)], 0, GD_KT, handler_ptr, 0);

        extern char handler46;
        handler_ptr = &handler46;
        SETGATE(idt[(32 + IRQ_IDE)], 0, GD_KT, handler_ptr, 0);
*/

        extern char handler51;
        handler_ptr = &handler51;
        SETGATE(idt[(32 + IRQ_ERROR)], 0, GD_KT, handler_ptr, 0);

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
	ts.ts_ss0 = GD_KD;

	// Initialize the TSS field of the gdt.
	gdt[GD_TSS >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
					sizeof(struct Taskstate), 0);
	gdt[GD_TSS >> 3].sd_s = 0;

	// Load the TSS
	ltr(GD_TSS);

	// Load the IDT
	asm volatile("lidt idt_pd");
}

void
print_trapframe(struct Trapframe *tf)
{
	cprintf("TRAP frame at %p\n", tf);
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
	cprintf("  err  0x%08x\n", tf->tf_err);
	cprintf("  eip  0x%08x\n", tf->tf_eip);
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
	cprintf("  esp  0x%08x\n", tf->tf_esp);
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
}

void
print_regs(struct PushRegs *regs)
{
	cprintf("  edi  0x%08x\n", regs->reg_edi);
	cprintf("  esi  0x%08x\n", regs->reg_esi);
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
	cprintf("  edx  0x%08x\n", regs->reg_edx);
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
	cprintf("  eax  0x%08x\n", regs->reg_eax);
}

static void
trap_dispatch(struct Trapframe *tf)
{
	// Handle processor exceptions.
	// LAB 3: Your code here.
	

        int32_t eax_return;
        struct PushRegs *regs;
        regs = &tf->tf_regs;

        // seanyliu
        switch (tf->tf_trapno) {
          case T_PGFLT:
            return page_fault_handler(tf);
            break;
          case T_BRKPT:
            return monitor(tf);
            break;
          case T_SYSCALL:
            /*
            //DEBUG:
            print_trapframe(tf);
            cprintf("------\n");
	    cprintf("  edi  0x%08x\n", regs->reg_edi);
	    cprintf("  esi  0x%08x\n", regs->reg_esi);
	    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
	    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
	    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
	    cprintf("  edx  0x%08x\n", regs->reg_edx);
	    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
	    cprintf("  eax  0x%08x\n", regs->reg_eax);
            */
            eax_return = syscall(regs->reg_eax, regs->reg_edx, regs->reg_ecx, regs->reg_ebx, regs->reg_edi, regs->reg_esi);
            //if (eax_return < 0) panic("trap.c: syscall returned invalid value %d\n", eax_return);
            // don't panic, because use for -E_IPC_NOT_RECV
            regs->reg_eax = eax_return;
            return;
            break;
          case IRQ_OFFSET + IRQ_TIMER:
	    // Add time tick increment to clock interrupts.
	    // LAB 6: Your code here.
            time_tick();
            sched_yield();
            return;
            break;
        }

	// Handle clock interrupts.
	// LAB 4: Your code here.
        // seanyliu
        // handled in case above

	// Add time tick increment to clock interrupts.
	// LAB 6: Your code here.

	// Handle spurious interupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		cprintf("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
		return;
	}


	// Handle keyboard interrupts.
	// LAB 7: Your code here.

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
	if (tf->tf_cs == GD_KT)
		panic("unhandled trap in kernel");
	else {
		env_destroy(curenv);
		return;
	}
}

void
trap(struct Trapframe *tf)
{
	if ((tf->tf_cs & 3) == 3) {
		// Trapped from user mode.
		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		assert(curenv);
		curenv->env_tf = *tf;
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
	}
	
	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNABLE)
		env_run(curenv);
	else
		sched_yield();
}


void
page_fault_handler(struct Trapframe *tf)
{
	uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	
	// LAB 3: Your code here.
        // seanyliu
	if ((tf->tf_cs & 3) == 0) panic("page_fault_handler: page fault happened in kernel mode.");

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
	//
	// The page fault upcall might cause another page fault, in which case
	// we branch to the page fault upcall recursively, pushing another
	// page fault stack frame on top of the user exception stack.
	//
	// The trap handler needs one word of scratch space at the top of the
	// trap-time stack in order to return.  In the non-recursive case, we
	// don't have to worry about this because the top of the regular user
	// stack is free.  In the recursive case, this means we have to leave
	// an extra word between the current top of the exception stack and
	// the new stack frame because the exception stack _is_ the trap-time
	// stack.
	//
	// If there's no page fault upcall, the environment didn't allocate a
	// page for its exception stack or can't write to it, or the exception
	// stack overflows, then destroy the environment that caused the fault.
	//
	// Hints:
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
        // seanyliu

	// If there's no page fault upcall, the environment didn't allocate a
	// page for its exception stack or can't write to it, or the exception
	// stack overflows, then destroy the environment that caused the fault.
        if (!(curenv->env_pgfault_upcall)) {
	  // Destroy the environment that caused the fault.
	  cprintf("[%08x] user fault va %08x ip %08x\n",
		  curenv->env_id, fault_va, tf->tf_eip);
	  print_trapframe(tf);
	  env_destroy(curenv);
        }

        uint32_t writeloc = UXSTACKTOP - sizeof(struct UTrapframe);
        // check if recursive case or not
        if ((tf->tf_esp >= UXSTACKTOP - PGSIZE) && (tf->tf_esp <= UXSTACKTOP - 1)) {
          writeloc = tf->tf_esp - sizeof(struct UTrapframe) - 4;
        }

        // verify that we can write below UXSTACKTOP
        user_mem_assert(curenv, (void *)writeloc, sizeof(struct UTrapframe), PTE_U);

        // Create the UTrapframe
        struct UTrapframe* utf;
        utf = (struct UTrapframe*) writeloc;
        utf->utf_fault_va = fault_va;
        utf->utf_err = tf->tf_err;
        utf->utf_regs = tf->tf_regs;
        utf->utf_eip = tf->tf_eip;
        utf->utf_eflags = tf->tf_eflags;
        utf->utf_esp = tf->tf_esp;

        // Update the tf->tf_esp
        tf->tf_esp = (uintptr_t)writeloc;

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
        tf->tf_eip = (uintptr_t) curenv->env_pgfault_upcall;
        //curnenv->env_tf = tf;
        env_run(curenv);
}

