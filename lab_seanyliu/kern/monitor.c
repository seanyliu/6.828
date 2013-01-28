// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>

#include <kern/pmap.h>		// seanyliu import for lab2 challenge

#define CMDBUF_SIZE	80	// enough for one VGA text line


struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },

        // seanyliu: add calls to stack backtrace
	{ "backtrace", "Backtrace on the stack", mon_backtrace },

	// seanyliu: lab 2 challenge
	{ "alloc_page", "Allocate a page", mon_alloc_page },
	{ "page_status", "Check if a page is allocated", mon_page_status },
	{ "free_page", "Free a page", mon_free_page },
	{ "hex_to_int", "Convert a hex number to an integer", mon_hex_to_int },
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

unsigned read_eip();

/***** Implementations of basic kernel monitor commands *****/

// seanyliu
// lab 2 challenge

int
mon_hex_to_int(int argc, char **argv, struct Trapframe *tf)
{
  char* paddr_string = argv[1];
  int disp_int = strtoint(paddr_string);

  if (disp_int == -1) {
    cprintf("Error: invalid hex address.\n");
  } else {
    cprintf("Hex %s = int %d\n", argv[1], disp_int);
  }

  return 0;
}

int
mon_page_status(int argc, char **argv, struct Trapframe *tf)
{
  char* paddr_string = argv[1];
  int paddr = strtoint(paddr_string);
  struct Page *pp;

  // check paddr is valid hex format
  if (paddr == -1) {
    cprintf("Error: invalid hex address.\n");
    return 0;
  }
  pp = pa2page(paddr);

  cprintf("page_status 0x%08x            \n", paddr);

  switch (pp->pp_ref) {
    case 0:
      cprintf("        free\n");
      break;
    default:
      cprintf("        allocated\n");
      break;
  }


  return 0;
}

int
mon_free_page(int argc, char **argv, struct Trapframe *tf)
{
  char* paddr_string = argv[1];
  int paddr = strtoint(paddr_string);
  struct Page *pp;

  // check paddr is valid hex format
  if (paddr == -1) {
    cprintf("Error: invalid hex address.\n");
    return 0;
  }

  cprintf("free_page %s            \n", paddr_string);

  // get out the page
  pp = pa2page(paddr);
  pp->pp_ref = 0;
  page_free(pp);

  return 0;
}

int
mon_alloc_page(int argc, char **argv, struct Trapframe *tf)
{
  struct Page *new_page;
  cprintf("alloc_page    \n");
  page_alloc(&new_page);
  new_page->pp_ref++;
  cprintf("        0x%08x\n", page2pa(new_page));
  return 0;
}




int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		(end-_start+1023)/1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{

	// Your code here.
        // seanyliu - 9/15/2009

        // First, extract the current base pointer, since
        // this gives us a pointer to the base frame. We
        // also should initialize eip.
        int* ebp = (int*)read_ebp();
        int* eip = (int*)read_eip();
        struct Eipdebuginfo info;
        //cprintf("DEBUG: *ebp %08x ; ebp %08x ; &ebp %08x ; (int)ebp %08x ; \n", *ebp, ebp, &ebp, (int)ebp);
        //cprintf("DEBUG: read_ebp() %08x\n", read_ebp());

  	cprintf("Stack backtrace:\n");
        // We could do a while as long as ebp is < the stack.
        // However, in obj/kern/kernel.asm, we see that the ebp
        // is initially nuked to be 0x0.  Therefore, we can
        // use this as a conditional check of when to quit.
        // This is in case there is junk at the top of the stack
        // and the original ebp is not the first line.
        while (ebp != 0x0) {
          //cprintf("DEBUG in while: *ebp %08x ; ebp %08x ; &ebp %08x ; (int)ebp %08x ; \n", *ebp, ebp, &ebp, (int)ebp);
  	  cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
          if (debuginfo_eip((int)eip, &info) == 0) {
            cprintf("         %s:%d: %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, (int)eip - info.eip_fn_addr);
          }
          eip = (int*)ebp[1];
          ebp = (int*)ebp[0]; // see http://unixwiz.net/techtips/win32-callconv-asm.html
        }
  	/*
	cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
        if (debuginfo_eip((int)eip, &info) == 0) {
          cprintf("         %s:%d: %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, (int)eip - info.eip_fn_addr);
        }
	*/
	return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}

// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
	return callerpc;
}
