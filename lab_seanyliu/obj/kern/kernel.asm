
obj/kern/kernel:     file format elf32-i386

Disassembly of section .text:

f0100000 <_start-0xc>:
.long CHECKSUM

.globl		_start
_start:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 03 00    	add    0x31bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fb                   	sti    
f0100009:	4f                   	dec    %edi
f010000a:	52                   	push   %edx
f010000b:	e4 66                	in     $0x66,%al

f010000c <_start>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 

	# Establish our own GDT in place of the boot loader's temporary GDT.
	lgdt	RELOC(mygdtdesc)		# load descriptor table
f0100015:	0f 01 15 18 50 12 00 	lgdtl  0x125018

	# Immediately reload all segment registers (including CS!)
	# with segment selectors from the new GDT.
	movl	$DATA_SEL, %eax			# Data segment selector
f010001c:	b8 10 00 00 00       	mov    $0x10,%eax
	movw	%ax,%ds				# -> DS: Data Segment
f0100021:	8e d8                	mov    %eax,%ds
	movw	%ax,%es				# -> ES: Extra Segment
f0100023:	8e c0                	mov    %eax,%es
	movw	%ax,%ss				# -> SS: Stack Segment
f0100025:	8e d0                	mov    %eax,%ss
	ljmp	$CODE_SEL,$relocated		# reload CS by jumping
f0100027:	ea 2e 00 10 f0 08 00 	ljmp   $0x8,$0xf010002e

f010002e <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002e:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Leave a few words on the stack for the user trap frame
	movl	$(bootstacktop-SIZEOF_STRUCT_TRAPFRAME),%esp
f0100033:	bc bc 4f 12 f0       	mov    $0xf0124fbc,%esp

	# now to C code
	call	i386_init
f0100038:	e8 03 00 00 00       	call   f0100040 <i386_init>

f010003d <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003d:	eb fe                	jmp    f010003d <spin>
	...

f0100040 <i386_init>:


void
i386_init(void)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	83 ec 0c             	sub    $0xc,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f0100046:	b8 04 8b 32 f0       	mov    $0xf0328b04,%eax
f010004b:	2d 5d 59 2f f0       	sub    $0xf02f595d,%eax
f0100050:	50                   	push   %eax
f0100051:	6a 00                	push   $0x0
f0100053:	68 5d 59 2f f0       	push   $0xf02f595d
f0100058:	e8 34 4c 00 00       	call   f0104c91 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f010005d:	e8 0a 06 00 00       	call   f010066c <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100062:	83 c4 08             	add    $0x8,%esp
f0100065:	68 ac 1a 00 00       	push   $0x1aac
f010006a:	68 20 5e 10 f0       	push   $0xf0105e20
f010006f:	e8 4e 30 00 00       	call   f01030c2 <cprintf>

	// Lab 2 memory management initialization functions
	i386_detect_memory();
f0100074:	e8 11 0b 00 00       	call   f0100b8a <i386_detect_memory>
	i386_vm_init();
f0100079:	e8 22 0c 00 00       	call   f0100ca0 <i386_vm_init>

	// Lab 3 user environment initialization functions
	env_init();
f010007e:	e8 a8 28 00 00       	call   f010292b <env_init>
	idt_init();
f0100083:	e8 84 30 00 00       	call   f010310c <idt_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f0100088:	e8 0b 2f 00 00       	call   f0102f98 <pic_init>
	kclock_init();
f010008d:	e8 c2 2e 00 00       	call   f0102f54 <kclock_init>

	time_init();
f0100092:	e8 65 5a 00 00       	call   f0105afc <time_init>
	pci_init();
f0100097:	e8 3d 5a 00 00       	call   f0105ad9 <pci_init>

	// Should always have an idle process as first one.
	ENV_CREATE(user_idle);
f010009c:	83 c4 08             	add    $0x8,%esp
f010009f:	68 8e 71 01 00       	push   $0x1718e
f01000a4:	68 21 e9 13 f0       	push   $0xf013e921
f01000a9:	e8 37 2c 00 00       	call   f0102ce5 <env_create>

	// Start fs.
	ENV_CREATE(fs_fs);
f01000ae:	83 c4 08             	add    $0x8,%esp
f01000b1:	68 fd 17 02 00       	push   $0x217fd
f01000b6:	68 7a 06 25 f0       	push   $0xf025067a
f01000bb:	e8 25 2c 00 00       	call   f0102ce5 <env_create>

	// Start ns.
	ENV_CREATE(net_ns);	
f01000c0:	83 c4 08             	add    $0x8,%esp
f01000c3:	68 84 57 05 00       	push   $0x55784
f01000c8:	68 d9 01 2a f0       	push   $0xf02a01d9
f01000cd:	e8 13 2c 00 00       	call   f0102ce5 <env_create>

	// Start init
#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE2(TEST, TESTSIZE);
f01000d2:	83 c4 08             	add    $0x8,%esp
f01000d5:	68 dd 92 01 00       	push   $0x192dd
f01000da:	68 64 03 1a f0       	push   $0xf01a0364
f01000df:	e8 01 2c 00 00       	call   f0102ce5 <env_create>
#else
	// Touch all you want.
	ENV_CREATE(user_icode);
	// ENV_CREATE(user_pipereadeof);
	// ENV_CREATE(user_pipewriteeof);

	// Should not be necessary - drain keyboard because interrupt has given up.
	kbd_intr();


	//ENV_CREATE(user_faultregs);
	//ENV_CREATE(user_testtime);
	// ENV_CREATE(user_echosrv);
	//ENV_CREATE(user_httpd);
	//ENV_CREATE(user_writemotd);
	//ENV_CREATE(user_testfsipc);
	//ENV_CREATE(user_icode);
	//ENV_CREATE(user_primes);
	//ENV_CREATE(user_yield);
	//ENV_CREATE(user_yield);
	//ENV_CREATE(user_dumbfork);
	//ENV_CREATE(user_forktree);
	//ENV_CREATE(user_spin);
	//ENV_CREATE(user_pingpong);
	//ENV_CREATE(user_prfork);
	//ENV_CREATE(user_primes);
#endif

	// Schedule and run the first user environment!
	sched_yield();
f01000e4:	e8 b3 36 00 00       	call   f010379c <sched_yield>

f01000e9 <_panic>:


}


/*
 * Variable panicstr contains argument to first call to panic; used as flag
 * to indicate that the kernel has already called panic.
 */
static const char *panicstr;

/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f01000e9:	55                   	push   %ebp
f01000ea:	89 e5                	mov    %esp,%ebp
f01000ec:	53                   	push   %ebx
f01000ed:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	if (panicstr)
f01000f0:	83 3d 60 59 2f f0 00 	cmpl   $0x0,0xf02f5960
f01000f7:	75 39                	jne    f0100132 <_panic+0x49>
		goto dead;
	panicstr = fmt;
f01000f9:	8b 45 10             	mov    0x10(%ebp),%eax
f01000fc:	a3 60 59 2f f0       	mov    %eax,0xf02f5960

	va_start(ap, fmt);
f0100101:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic at %s:%d: ", file, line);
f0100104:	83 ec 04             	sub    $0x4,%esp
f0100107:	ff 75 0c             	pushl  0xc(%ebp)
f010010a:	ff 75 08             	pushl  0x8(%ebp)
f010010d:	68 3b 5e 10 f0       	push   $0xf0105e3b
f0100112:	e8 ab 2f 00 00       	call   f01030c2 <cprintf>
	vcprintf(fmt, ap);
f0100117:	83 c4 08             	add    $0x8,%esp
f010011a:	53                   	push   %ebx
f010011b:	ff 75 10             	pushl  0x10(%ebp)
f010011e:	e8 79 2f 00 00       	call   f010309c <vcprintf>
	cprintf("\n");
f0100123:	c7 04 24 bd 5f 10 f0 	movl   $0xf0105fbd,(%esp)
f010012a:	e8 93 2f 00 00       	call   f01030c2 <cprintf>
	va_end(ap);
f010012f:	83 c4 10             	add    $0x10,%esp

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100132:	83 ec 0c             	sub    $0xc,%esp
f0100135:	6a 00                	push   $0x0
f0100137:	e8 bc 09 00 00       	call   f0100af8 <monitor>
f010013c:	83 c4 10             	add    $0x10,%esp
f010013f:	eb f1                	jmp    f0100132 <_panic+0x49>

f0100141 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100141:	55                   	push   %ebp
f0100142:	89 e5                	mov    %esp,%ebp
f0100144:	53                   	push   %ebx
f0100145:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0100148:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f010014b:	ff 75 0c             	pushl  0xc(%ebp)
f010014e:	ff 75 08             	pushl  0x8(%ebp)
f0100151:	68 53 5e 10 f0       	push   $0xf0105e53
f0100156:	e8 67 2f 00 00       	call   f01030c2 <cprintf>
	vcprintf(fmt, ap);
f010015b:	83 c4 08             	add    $0x8,%esp
f010015e:	53                   	push   %ebx
f010015f:	ff 75 10             	pushl  0x10(%ebp)
f0100162:	e8 35 2f 00 00       	call   f010309c <vcprintf>
	cprintf("\n");
f0100167:	c7 04 24 bd 5f 10 f0 	movl   $0xf0105fbd,(%esp)
f010016e:	e8 4f 2f 00 00       	call   f01030c2 <cprintf>
	va_end(ap);
}
f0100173:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100176:	c9                   	leave  
f0100177:	c3                   	ret    

f0100178 <delay>:

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f0100178:	55                   	push   %ebp
f0100179:	89 e5                	mov    %esp,%ebp
}

static __inline uint8_t
inb(int port)
{
f010017b:	ba 84 00 00 00       	mov    $0x84,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100180:	ec                   	in     (%dx),%al
f0100181:	ec                   	in     (%dx),%al
f0100182:	ec                   	in     (%dx),%al
f0100183:	ec                   	in     (%dx),%al
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
f0100184:	c9                   	leave  
f0100185:	c3                   	ret    

f0100186 <serial_proc_data>:

/***** Serial I/O code *****/

#define COM1		0x3F8

#define COM_RX		0	// In:	Receive buffer (DLAB=0)
#define COM_TX		0	// Out: Transmit buffer (DLAB=0)
#define COM_DLL		0	// Out: Divisor Latch Low (DLAB=1)
#define COM_DLM		1	// Out: Divisor Latch High (DLAB=1)
#define COM_IER		1	// Out: Interrupt Enable Register
#define   COM_IER_RDI	0x01	//   Enable receiver data interrupt
#define COM_IIR		2	// In:	Interrupt ID Register
#define COM_FCR		2	// Out: FIFO Control Register
#define COM_LCR		3	// Out: Line Control Register
#define	  COM_LCR_DLAB	0x80	//   Divisor latch access bit
#define	  COM_LCR_WLEN8	0x03	//   Wordlength: 8 bits
#define COM_MCR		4	// Out: Modem Control Register
#define	  COM_MCR_RTS	0x02	// RTS complement
#define	  COM_MCR_DTR	0x01	// DTR complement
#define	  COM_MCR_OUT2	0x08	// Out2 complement
#define COM_LSR		5	// In:	Line Status Register
#define   COM_LSR_DATA	0x01	//   Data available
#define   COM_LSR_TXRDY	0x20	//   Transmit buffer avail
#define   COM_LSR_TSRE	0x40	//   Transmitter off

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100186:	55                   	push   %ebp
f0100187:	89 e5                	mov    %esp,%ebp
}

static __inline uint8_t
inb(int port)
{
f0100189:	ba fd 03 00 00       	mov    $0x3fd,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010018e:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
f010018f:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}

static __inline uint8_t
inb(int port)
{
f0100194:	a8 01                	test   $0x1,%al
f0100196:	74 09                	je     f01001a1 <serial_proc_data+0x1b>
f0100198:	ba f8 03 00 00       	mov    $0x3f8,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010019d:	ec                   	in     (%dx),%al
f010019e:	0f b6 d0             	movzbl %al,%edx
	return inb(COM1+COM_RX);
}
f01001a1:	89 d0                	mov    %edx,%eax
f01001a3:	c9                   	leave  
f01001a4:	c3                   	ret    

f01001a5 <serial_intr>:

void
serial_intr(void)
{
f01001a5:	55                   	push   %ebp
f01001a6:	89 e5                	mov    %esp,%ebp
f01001a8:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
f01001ab:	83 3d 84 59 2f f0 00 	cmpl   $0x0,0xf02f5984
f01001b2:	74 10                	je     f01001c4 <serial_intr+0x1f>
		cons_intr(serial_proc_data);
f01001b4:	83 ec 0c             	sub    $0xc,%esp
f01001b7:	68 86 01 10 f0       	push   $0xf0100186
f01001bc:	e8 02 04 00 00       	call   f01005c3 <cons_intr>
f01001c1:	83 c4 10             	add    $0x10,%esp
}
f01001c4:	c9                   	leave  
f01001c5:	c3                   	ret    

f01001c6 <serial_putc>:

static void
serial_putc(int c)
{
f01001c6:	55                   	push   %ebp
f01001c7:	89 e5                	mov    %esp,%ebp
f01001c9:	56                   	push   %esi
f01001ca:	53                   	push   %ebx
	int i;
	
	for (i = 0;
f01001cb:	bb 00 00 00 00       	mov    $0x0,%ebx
}

static __inline uint8_t
inb(int port)
{
f01001d0:	ba fd 03 00 00       	mov    $0x3fd,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01001d5:	ec                   	in     (%dx),%al
f01001d6:	a8 20                	test   $0x20,%al
f01001d8:	75 1a                	jne    f01001f4 <serial_putc+0x2e>
f01001da:	be fd 03 00 00       	mov    $0x3fd,%esi
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
f01001df:	e8 94 ff ff ff       	call   f0100178 <delay>
f01001e4:	43                   	inc    %ebx
static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01001e5:	89 f2                	mov    %esi,%edx
f01001e7:	ec                   	in     (%dx),%al
f01001e8:	a8 20                	test   $0x20,%al
f01001ea:	75 08                	jne    f01001f4 <serial_putc+0x2e>
f01001ec:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f01001f2:	7e eb                	jle    f01001df <serial_putc+0x19>
	return data;
}

static __inline void
insb(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsb"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
}

static __inline uint16_t
inw(int port)
{
	uint16_t data;
	__asm __volatile("inw %w1,%0" : "=a" (data) : "d" (port));
	return data;
}

static __inline void
insw(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsw"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
}

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
	return data;
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
}

static __inline void
outb(int port, uint8_t data)
{
f01001f4:	ba f8 03 00 00       	mov    $0x3f8,%edx
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01001f9:	8a 45 08             	mov    0x8(%ebp),%al
f01001fc:	ee                   	out    %al,(%dx)
	
	outb(COM1 + COM_TX, c);
}
f01001fd:	5b                   	pop    %ebx
f01001fe:	5e                   	pop    %esi
f01001ff:	c9                   	leave  
f0100200:	c3                   	ret    

f0100201 <serial_init>:

static void
serial_init(void)
{
f0100201:	55                   	push   %ebp
f0100202:	89 e5                	mov    %esp,%ebp
f0100204:	53                   	push   %ebx
f0100205:	83 ec 04             	sub    $0x4,%esp
}

static __inline void
outb(int port, uint8_t data)
{
f0100208:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f010020d:	b0 00                	mov    $0x0,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010020f:	89 da                	mov    %ebx,%edx
f0100211:	ee                   	out    %al,(%dx)
f0100212:	b2 fb                	mov    $0xfb,%dl
f0100214:	b0 80                	mov    $0x80,%al
f0100216:	ee                   	out    %al,(%dx)
f0100217:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
f010021c:	b0 0c                	mov    $0xc,%al
f010021e:	89 ca                	mov    %ecx,%edx
f0100220:	ee                   	out    %al,(%dx)
f0100221:	b2 f9                	mov    $0xf9,%dl
f0100223:	b0 00                	mov    $0x0,%al
f0100225:	ee                   	out    %al,(%dx)
f0100226:	b2 fb                	mov    $0xfb,%dl
f0100228:	b0 03                	mov    $0x3,%al
f010022a:	ee                   	out    %al,(%dx)
f010022b:	b2 fc                	mov    $0xfc,%dl
f010022d:	b0 00                	mov    $0x0,%al
f010022f:	ee                   	out    %al,(%dx)
f0100230:	b2 f9                	mov    $0xf9,%dl
f0100232:	b0 01                	mov    $0x1,%al
f0100234:	ee                   	out    %al,(%dx)
f0100235:	b2 fd                	mov    $0xfd,%dl
f0100237:	ec                   	in     (%dx),%al
f0100238:	3c ff                	cmp    $0xff,%al
f010023a:	0f 95 c0             	setne  %al
f010023d:	0f b6 c0             	movzbl %al,%eax
f0100240:	a3 84 59 2f f0       	mov    %eax,0xf02f5984
f0100245:	89 da                	mov    %ebx,%edx
f0100247:	ec                   	in     (%dx),%al
f0100248:	89 ca                	mov    %ecx,%edx
f010024a:	ec                   	in     (%dx),%al
	// Turn off the FIFO
	outb(COM1+COM_FCR, 0);
	
	// Set speed; requires DLAB latch
	outb(COM1+COM_LCR, COM_LCR_DLAB);
	outb(COM1+COM_DLL, (uint8_t) (115200 / 9600));
	outb(COM1+COM_DLM, 0);

	// 8 data bits, 1 stop bit, parity off; turn off DLAB latch
	outb(COM1+COM_LCR, COM_LCR_WLEN8 & ~COM_LCR_DLAB);

	// No modem controls
	outb(COM1+COM_MCR, 0);
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

	// Enable serial interrupts
	if (serial_exists)
f010024b:	83 3d 84 59 2f f0 00 	cmpl   $0x0,0xf02f5984
f0100252:	74 18                	je     f010026c <serial_init+0x6b>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f0100254:	83 ec 0c             	sub    $0xc,%esp
f0100257:	0f b7 05 d8 55 12 f0 	movzwl 0xf01255d8,%eax
f010025e:	25 ef ff 00 00       	and    $0xffef,%eax
f0100263:	50                   	push   %eax
f0100264:	e8 99 2d 00 00       	call   f0103002 <irq_setmask_8259A>
f0100269:	83 c4 10             	add    $0x10,%esp
}
f010026c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f010026f:	c9                   	leave  
f0100270:	c3                   	ret    

f0100271 <lpt_putc>:



/***** Parallel port output code *****/
// For information on PC parallel port programming, see the class References
// page.

static void
lpt_putc(int c)
{
f0100271:	55                   	push   %ebp
f0100272:	89 e5                	mov    %esp,%ebp
f0100274:	56                   	push   %esi
f0100275:	53                   	push   %ebx
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f0100276:	bb 00 00 00 00       	mov    $0x0,%ebx
}

static __inline uint8_t
inb(int port)
{
f010027b:	ba 79 03 00 00       	mov    $0x379,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100280:	ec                   	in     (%dx),%al
f0100281:	84 c0                	test   %al,%al
f0100283:	78 1a                	js     f010029f <lpt_putc+0x2e>
f0100285:	be 79 03 00 00       	mov    $0x379,%esi
		delay();
f010028a:	e8 e9 fe ff ff       	call   f0100178 <delay>
f010028f:	43                   	inc    %ebx
static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100290:	89 f2                	mov    %esi,%edx
f0100292:	ec                   	in     (%dx),%al
f0100293:	84 c0                	test   %al,%al
f0100295:	78 08                	js     f010029f <lpt_putc+0x2e>
f0100297:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f010029d:	7e eb                	jle    f010028a <lpt_putc+0x19>
	return data;
}

static __inline void
insb(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsb"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
}

static __inline uint16_t
inw(int port)
{
	uint16_t data;
	__asm __volatile("inw %w1,%0" : "=a" (data) : "d" (port));
	return data;
}

static __inline void
insw(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsw"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
}

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
	return data;
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
			 "=D" (addr), "=c" (cnt)		:
			 "d" (port), "0" (addr), "1" (cnt)	:
			 "memory", "cc");
}

static __inline void
outb(int port, uint8_t data)
{
f010029f:	ba 78 03 00 00       	mov    $0x378,%edx
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002a4:	8a 45 08             	mov    0x8(%ebp),%al
f01002a7:	ee                   	out    %al,(%dx)
f01002a8:	b2 7a                	mov    $0x7a,%dl
f01002aa:	b0 0d                	mov    $0xd,%al
f01002ac:	ee                   	out    %al,(%dx)
f01002ad:	b0 08                	mov    $0x8,%al
f01002af:	ee                   	out    %al,(%dx)
	outb(0x378+0, c);
	outb(0x378+2, 0x08|0x04|0x01);
	outb(0x378+2, 0x08);
}
f01002b0:	5b                   	pop    %ebx
f01002b1:	5e                   	pop    %esi
f01002b2:	c9                   	leave  
f01002b3:	c3                   	ret    

f01002b4 <cga_init>:




/***** Text-mode CGA/VGA display output *****/

static unsigned addr_6845;
static uint16_t *crt_buf;
static uint16_t crt_pos;

static void
cga_init(void)
{
f01002b4:	55                   	push   %ebp
f01002b5:	89 e5                	mov    %esp,%ebp
f01002b7:	57                   	push   %edi
f01002b8:	56                   	push   %esi
f01002b9:	53                   	push   %ebx
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01002ba:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
	was = *cp;
f01002bf:	66 8b 15 00 80 0b f0 	mov    0xf00b8000,%dx
	*cp = (uint16_t) 0xA55A;
f01002c6:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01002cd:	5a a5 
	if (*cp != 0xA55A) {
f01002cf:	66 a1 00 80 0b f0    	mov    0xf00b8000,%ax
f01002d5:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01002d9:	74 10                	je     f01002eb <cga_init+0x37>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01002db:	66 be 00 00          	mov    $0x0,%si
		addr_6845 = MONO_BASE;
f01002df:	c7 05 88 59 2f f0 b4 	movl   $0x3b4,0xf02f5988
f01002e6:	03 00 00 
f01002e9:	eb 0d                	jmp    f01002f8 <cga_init+0x44>
	} else {
		*cp = was;
f01002eb:	66 89 16             	mov    %dx,(%esi)
		addr_6845 = CGA_BASE;
f01002ee:	c7 05 88 59 2f f0 d4 	movl   $0x3d4,0xf02f5988
f01002f5:	03 00 00 
}

static __inline void
outb(int port, uint8_t data)
{
f01002f8:	8b 0d 88 59 2f f0    	mov    0xf02f5988,%ecx
f01002fe:	b0 0e                	mov    $0xe,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100300:	89 ca                	mov    %ecx,%edx
f0100302:	ee                   	out    %al,(%dx)
f0100303:	8d 79 01             	lea    0x1(%ecx),%edi
f0100306:	89 fa                	mov    %edi,%edx
f0100308:	ec                   	in     (%dx),%al
f0100309:	0f b6 d8             	movzbl %al,%ebx
f010030c:	c1 e3 08             	shl    $0x8,%ebx
f010030f:	b0 0f                	mov    $0xf,%al
f0100311:	89 ca                	mov    %ecx,%edx
f0100313:	ee                   	out    %al,(%dx)
f0100314:	89 fa                	mov    %edi,%edx
f0100316:	ec                   	in     (%dx),%al
f0100317:	0f b6 c0             	movzbl %al,%eax
f010031a:	09 c3                	or     %eax,%ebx
	}
	
	/* Extract cursor location */
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f010031c:	89 35 8c 59 2f f0    	mov    %esi,0xf02f598c
	crt_pos = pos;
f0100322:	66 89 1d 90 59 2f f0 	mov    %bx,0xf02f5990
}
f0100329:	5b                   	pop    %ebx
f010032a:	5e                   	pop    %esi
f010032b:	5f                   	pop    %edi
f010032c:	c9                   	leave  
f010032d:	c3                   	ret    

f010032e <cga_putc>:



static void
cga_putc(int c)
{
f010032e:	55                   	push   %ebp
f010032f:	89 e5                	mov    %esp,%ebp
f0100331:	56                   	push   %esi
f0100332:	53                   	push   %ebx
f0100333:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f0100336:	f7 c1 00 ff ff ff    	test   $0xffffff00,%ecx
f010033c:	75 03                	jne    f0100341 <cga_putc+0x13>
		c |= 0x0700;
f010033e:	80 cd 07             	or     $0x7,%ch

	switch (c & 0xff) {
f0100341:	0f b6 c1             	movzbl %cl,%eax
f0100344:	83 f8 09             	cmp    $0x9,%eax
f0100347:	74 7b                	je     f01003c4 <cga_putc+0x96>
f0100349:	83 f8 09             	cmp    $0x9,%eax
f010034c:	7f 0a                	jg     f0100358 <cga_putc+0x2a>
f010034e:	83 f8 08             	cmp    $0x8,%eax
f0100351:	74 14                	je     f0100367 <cga_putc+0x39>
f0100353:	e9 ab 00 00 00       	jmp    f0100403 <cga_putc+0xd5>
f0100358:	83 f8 0a             	cmp    $0xa,%eax
f010035b:	74 3c                	je     f0100399 <cga_putc+0x6b>
f010035d:	83 f8 0d             	cmp    $0xd,%eax
f0100360:	74 3f                	je     f01003a1 <cga_putc+0x73>
f0100362:	e9 9c 00 00 00       	jmp    f0100403 <cga_putc+0xd5>
	case '\b':
		if (crt_pos > 0) {
f0100367:	66 83 3d 90 59 2f f0 	cmpw   $0x0,0xf02f5990
f010036e:	00 
f010036f:	0f 84 a5 00 00 00    	je     f010041a <cga_putc+0xec>
			crt_pos--;
f0100375:	66 ff 0d 90 59 2f f0 	decw   0xf02f5990
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f010037c:	0f b7 05 90 59 2f f0 	movzwl 0xf02f5990,%eax
f0100383:	89 ca                	mov    %ecx,%edx
f0100385:	b2 00                	mov    $0x0,%dl
f0100387:	83 ca 20             	or     $0x20,%edx
f010038a:	8b 0d 8c 59 2f f0    	mov    0xf02f598c,%ecx
f0100390:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
		}
		break;
f0100394:	e9 81 00 00 00       	jmp    f010041a <cga_putc+0xec>
	case '\n':
		crt_pos += CRT_COLS;
f0100399:	66 83 05 90 59 2f f0 	addw   $0x50,0xf02f5990
f01003a0:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f01003a1:	66 8b 1d 90 59 2f f0 	mov    0xf02f5990,%bx
f01003a8:	b9 50 00 00 00       	mov    $0x50,%ecx
f01003ad:	ba 00 00 00 00       	mov    $0x0,%edx
f01003b2:	89 d8                	mov    %ebx,%eax
f01003b4:	66 f7 f1             	div    %cx
f01003b7:	89 d8                	mov    %ebx,%eax
f01003b9:	66 29 d0             	sub    %dx,%ax
f01003bc:	66 a3 90 59 2f f0    	mov    %ax,0xf02f5990
		break;
f01003c2:	eb 56                	jmp    f010041a <cga_putc+0xec>
	case '\t':
		cons_putc(' ');
f01003c4:	83 ec 0c             	sub    $0xc,%esp
f01003c7:	6a 20                	push   $0x20
f01003c9:	e8 7a 02 00 00       	call   f0100648 <cons_putc>
		cons_putc(' ');
f01003ce:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01003d5:	e8 6e 02 00 00       	call   f0100648 <cons_putc>
		cons_putc(' ');
f01003da:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01003e1:	e8 62 02 00 00       	call   f0100648 <cons_putc>
		cons_putc(' ');
f01003e6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01003ed:	e8 56 02 00 00       	call   f0100648 <cons_putc>
		cons_putc(' ');
f01003f2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01003f9:	e8 4a 02 00 00       	call   f0100648 <cons_putc>
		break;
f01003fe:	83 c4 10             	add    $0x10,%esp
f0100401:	eb 17                	jmp    f010041a <cga_putc+0xec>
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f0100403:	0f b7 15 90 59 2f f0 	movzwl 0xf02f5990,%edx
f010040a:	a1 8c 59 2f f0       	mov    0xf02f598c,%eax
f010040f:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
f0100413:	66 ff 05 90 59 2f f0 	incw   0xf02f5990
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f010041a:	66 81 3d 90 59 2f f0 	cmpw   $0x7cf,0xf02f5990
f0100421:	cf 07 
f0100423:	76 3f                	jbe    f0100464 <cga_putc+0x136>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100425:	83 ec 04             	sub    $0x4,%esp
f0100428:	68 00 0f 00 00       	push   $0xf00
f010042d:	8b 15 8c 59 2f f0    	mov    0xf02f598c,%edx
f0100433:	8d 82 a0 00 00 00    	lea    0xa0(%edx),%eax
f0100439:	50                   	push   %eax
f010043a:	52                   	push   %edx
f010043b:	e8 a4 48 00 00       	call   f0104ce4 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100440:	ba 80 07 00 00       	mov    $0x780,%edx
f0100445:	83 c4 10             	add    $0x10,%esp
			crt_buf[i] = 0x0700 | ' ';
f0100448:	a1 8c 59 2f f0       	mov    0xf02f598c,%eax
f010044d:	66 c7 04 50 20 07    	movw   $0x720,(%eax,%edx,2)
f0100453:	42                   	inc    %edx
f0100454:	81 fa cf 07 00 00    	cmp    $0x7cf,%edx
f010045a:	7e ec                	jle    f0100448 <cga_putc+0x11a>
		crt_pos -= CRT_COLS;
f010045c:	66 83 2d 90 59 2f f0 	subw   $0x50,0xf02f5990
f0100463:	50 
}

static __inline void
outb(int port, uint8_t data)
{
f0100464:	8b 1d 88 59 2f f0    	mov    0xf02f5988,%ebx
f010046a:	b0 0e                	mov    $0xe,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010046c:	89 da                	mov    %ebx,%edx
f010046e:	ee                   	out    %al,(%dx)
f010046f:	8d 73 01             	lea    0x1(%ebx),%esi
f0100472:	66 8b 0d 90 59 2f f0 	mov    0xf02f5990,%cx
f0100479:	89 c8                	mov    %ecx,%eax
f010047b:	66 c1 e8 08          	shr    $0x8,%ax
f010047f:	89 f2                	mov    %esi,%edx
f0100481:	ee                   	out    %al,(%dx)
f0100482:	b0 0f                	mov    $0xf,%al
f0100484:	89 da                	mov    %ebx,%edx
f0100486:	ee                   	out    %al,(%dx)
f0100487:	88 c8                	mov    %cl,%al
f0100489:	89 f2                	mov    %esi,%edx
f010048b:	ee                   	out    %al,(%dx)
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
	outb(addr_6845 + 1, crt_pos >> 8);
	outb(addr_6845, 15);
	outb(addr_6845 + 1, crt_pos);
}
f010048c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f010048f:	5b                   	pop    %ebx
f0100490:	5e                   	pop    %esi
f0100491:	c9                   	leave  
f0100492:	c3                   	ret    

f0100493 <kbd_proc_data>:


/***** Keyboard input code *****/

#define NO		0

#define SHIFT		(1<<0)
#define CTL		(1<<1)
#define ALT		(1<<2)

#define CAPSLOCK	(1<<3)
#define NUMLOCK		(1<<4)
#define SCROLLLOCK	(1<<5)

#define E0ESC		(1<<6)

static uint8_t shiftcode[256] = 
{
	[0x1D] CTL,
	[0x2A] SHIFT,
	[0x36] SHIFT,
	[0x38] ALT,
	[0x9D] CTL,
	[0xB8] ALT
};

static uint8_t togglecode[256] = 
{
	[0x3A] CAPSLOCK,
	[0x45] NUMLOCK,
	[0x46] SCROLLLOCK
};

static uint8_t normalmap[256] =
{
	NO,   0x1B, '1',  '2',  '3',  '4',  '5',  '6',	// 0x00
	'7',  '8',  '9',  '0',  '-',  '=',  '\b', '\t',
	'q',  'w',  'e',  'r',  't',  'y',  'u',  'i',	// 0x10
	'o',  'p',  '[',  ']',  '\n', NO,   'a',  's',
	'd',  'f',  'g',  'h',  'j',  'k',  'l',  ';',	// 0x20
	'\'', '`',  NO,   '\\', 'z',  'x',  'c',  'v',
	'b',  'n',  'm',  ',',  '.',  '/',  NO,   '*',	// 0x30
	NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
	NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',	// 0x40
	'8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
	'2',  '3',  '0',  '.',  NO,   NO,   NO,   NO,	// 0x50
	[0xC7] KEY_HOME,	[0x9C] '\n' /*KP_Enter*/,
	[0xB5] '/' /*KP_Div*/,	[0xC8] KEY_UP,
	[0xC9] KEY_PGUP,	[0xCB] KEY_LF,
	[0xCD] KEY_RT,		[0xCF] KEY_END,
	[0xD0] KEY_DN,		[0xD1] KEY_PGDN,
	[0xD2] KEY_INS,		[0xD3] KEY_DEL
};

static uint8_t shiftmap[256] = 
{
	NO,   033,  '!',  '@',  '#',  '$',  '%',  '^',	// 0x00
	'&',  '*',  '(',  ')',  '_',  '+',  '\b', '\t',
	'Q',  'W',  'E',  'R',  'T',  'Y',  'U',  'I',	// 0x10
	'O',  'P',  '{',  '}',  '\n', NO,   'A',  'S',
	'D',  'F',  'G',  'H',  'J',  'K',  'L',  ':',	// 0x20
	'"',  '~',  NO,   '|',  'Z',  'X',  'C',  'V',
	'B',  'N',  'M',  '<',  '>',  '?',  NO,   '*',	// 0x30
	NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
	NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',	// 0x40
	'8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
	'2',  '3',  '0',  '.',  NO,   NO,   NO,   NO,	// 0x50
	[0xC7] KEY_HOME,	[0x9C] '\n' /*KP_Enter*/,
	[0xB5] '/' /*KP_Div*/,	[0xC8] KEY_UP,
	[0xC9] KEY_PGUP,	[0xCB] KEY_LF,
	[0xCD] KEY_RT,		[0xCF] KEY_END,
	[0xD0] KEY_DN,		[0xD1] KEY_PGDN,
	[0xD2] KEY_INS,		[0xD3] KEY_DEL
};

#define C(x) (x - '@')

static uint8_t ctlmap[256] = 
{
	NO,      NO,      NO,      NO,      NO,      NO,      NO,      NO, 
	NO,      NO,      NO,      NO,      NO,      NO,      NO,      NO, 
	C('Q'),  C('W'),  C('E'),  C('R'),  C('T'),  C('Y'),  C('U'),  C('I'),
	C('O'),  C('P'),  NO,      NO,      '\r',    NO,      C('A'),  C('S'),
	C('D'),  C('F'),  C('G'),  C('H'),  C('J'),  C('K'),  C('L'),  NO, 
	NO,      NO,      NO,      C('\\'), C('Z'),  C('X'),  C('C'),  C('V'),
	C('B'),  C('N'),  C('M'),  NO,      NO,      C('/'),  NO,      NO,
	[0x97] KEY_HOME,
	[0xB5] C('/'),		[0xC8] KEY_UP,
	[0xC9] KEY_PGUP,	[0xCB] KEY_LF,
	[0xCD] KEY_RT,		[0xCF] KEY_END,
	[0xD0] KEY_DN,		[0xD1] KEY_PGDN,
	[0xD2] KEY_INS,		[0xD3] KEY_DEL
};

static uint8_t *charcode[4] = {
	normalmap,
	shiftmap,
	ctlmap,
	ctlmap
};

/*
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f0100493:	55                   	push   %ebp
f0100494:	89 e5                	mov    %esp,%ebp
f0100496:	53                   	push   %ebx
f0100497:	83 ec 04             	sub    $0x4,%esp
}

static __inline uint8_t
inb(int port)
{
f010049a:	ba 64 00 00 00       	mov    $0x64,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010049f:	ec                   	in     (%dx),%al
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
f01004a0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}

static __inline uint8_t
inb(int port)
{
f01004a5:	a8 01                	test   $0x1,%al
f01004a7:	0f 84 db 00 00 00    	je     f0100588 <kbd_proc_data+0xf5>
f01004ad:	ba 60 00 00 00       	mov    $0x60,%edx
f01004b2:	ec                   	in     (%dx),%al
f01004b3:	88 c2                	mov    %al,%dl

	data = inb(KBDATAP);

	if (data == 0xE0) {
f01004b5:	3c e0                	cmp    $0xe0,%al
f01004b7:	75 11                	jne    f01004ca <kbd_proc_data+0x37>
		// E0 escape character
		shift |= E0ESC;
f01004b9:	83 0d 80 59 2f f0 40 	orl    $0x40,0xf02f5980
		return 0;
f01004c0:	ba 00 00 00 00       	mov    $0x0,%edx
f01004c5:	e9 be 00 00 00       	jmp    f0100588 <kbd_proc_data+0xf5>
	} else if (data & 0x80) {
f01004ca:	84 c0                	test   %al,%al
f01004cc:	79 2d                	jns    f01004fb <kbd_proc_data+0x68>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f01004ce:	f6 05 80 59 2f f0 40 	testb  $0x40,0xf02f5980
f01004d5:	75 03                	jne    f01004da <kbd_proc_data+0x47>
f01004d7:	83 e2 7f             	and    $0x7f,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01004da:	0f b6 c2             	movzbl %dl,%eax
f01004dd:	8a 80 20 50 12 f0    	mov    0xf0125020(%eax),%al
f01004e3:	83 c8 40             	or     $0x40,%eax
f01004e6:	0f b6 c0             	movzbl %al,%eax
f01004e9:	f7 d0                	not    %eax
f01004eb:	21 05 80 59 2f f0    	and    %eax,0xf02f5980
		return 0;
f01004f1:	ba 00 00 00 00       	mov    $0x0,%edx
f01004f6:	e9 8d 00 00 00       	jmp    f0100588 <kbd_proc_data+0xf5>
	} else if (shift & E0ESC) {
f01004fb:	a1 80 59 2f f0       	mov    0xf02f5980,%eax
f0100500:	a8 40                	test   $0x40,%al
f0100502:	74 0b                	je     f010050f <kbd_proc_data+0x7c>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f0100504:	83 ca 80             	or     $0xffffff80,%edx
		shift &= ~E0ESC;
f0100507:	83 e0 bf             	and    $0xffffffbf,%eax
f010050a:	a3 80 59 2f f0       	mov    %eax,0xf02f5980
	}

	shift |= shiftcode[data];
f010050f:	0f b6 ca             	movzbl %dl,%ecx
f0100512:	0f b6 81 20 50 12 f0 	movzbl 0xf0125020(%ecx),%eax
f0100519:	0b 05 80 59 2f f0    	or     0xf02f5980,%eax
	shift ^= togglecode[data];
f010051f:	0f b6 91 20 51 12 f0 	movzbl 0xf0125120(%ecx),%edx
f0100526:	31 c2                	xor    %eax,%edx
f0100528:	89 15 80 59 2f f0    	mov    %edx,0xf02f5980

	c = charcode[shift & (CTL | SHIFT)][data];
f010052e:	89 d0                	mov    %edx,%eax
f0100530:	83 e0 03             	and    $0x3,%eax
f0100533:	8b 04 85 20 55 12 f0 	mov    0xf0125520(,%eax,4),%eax
f010053a:	0f b6 1c 08          	movzbl (%eax,%ecx,1),%ebx
	if (shift & CAPSLOCK) {
f010053e:	f6 c2 08             	test   $0x8,%dl
f0100541:	74 18                	je     f010055b <kbd_proc_data+0xc8>
		if ('a' <= c && c <= 'z')
f0100543:	8d 43 9f             	lea    0xffffff9f(%ebx),%eax
f0100546:	83 f8 19             	cmp    $0x19,%eax
f0100549:	77 05                	ja     f0100550 <kbd_proc_data+0xbd>
			c += 'A' - 'a';
f010054b:	83 eb 20             	sub    $0x20,%ebx
f010054e:	eb 0b                	jmp    f010055b <kbd_proc_data+0xc8>
		else if ('A' <= c && c <= 'Z')
f0100550:	8d 43 bf             	lea    0xffffffbf(%ebx),%eax
f0100553:	83 f8 19             	cmp    $0x19,%eax
f0100556:	77 03                	ja     f010055b <kbd_proc_data+0xc8>
			c += 'a' - 'A';
f0100558:	83 c3 20             	add    $0x20,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010055b:	a1 80 59 2f f0       	mov    0xf02f5980,%eax
f0100560:	f7 d0                	not    %eax
f0100562:	a8 06                	test   $0x6,%al
f0100564:	75 20                	jne    f0100586 <kbd_proc_data+0xf3>
f0100566:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f010056c:	75 18                	jne    f0100586 <kbd_proc_data+0xf3>
		cprintf("Rebooting!\n");
f010056e:	83 ec 0c             	sub    $0xc,%esp
f0100571:	68 6d 5e 10 f0       	push   $0xf0105e6d
f0100576:	e8 47 2b 00 00       	call   f01030c2 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
f010057b:	83 c4 10             	add    $0x10,%esp
f010057e:	ba 92 00 00 00       	mov    $0x92,%edx
f0100583:	b0 03                	mov    $0x3,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100585:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f0100586:	89 da                	mov    %ebx,%edx
}
f0100588:	89 d0                	mov    %edx,%eax
f010058a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f010058d:	c9                   	leave  
f010058e:	c3                   	ret    

f010058f <kbd_intr>:

void
kbd_intr(void)
{
f010058f:	55                   	push   %ebp
f0100590:	89 e5                	mov    %esp,%ebp
f0100592:	83 ec 14             	sub    $0x14,%esp
	cons_intr(kbd_proc_data);
f0100595:	68 93 04 10 f0       	push   $0xf0100493
f010059a:	e8 24 00 00 00       	call   f01005c3 <cons_intr>
}
f010059f:	c9                   	leave  
f01005a0:	c3                   	ret    

f01005a1 <kbd_init>:

static void
kbd_init(void)
{
f01005a1:	55                   	push   %ebp
f01005a2:	89 e5                	mov    %esp,%ebp
f01005a4:	83 ec 08             	sub    $0x8,%esp
	// Drain the kbd buffer so that Bochs generates interrupts.
	kbd_intr();
f01005a7:	e8 e3 ff ff ff       	call   f010058f <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f01005ac:	83 ec 0c             	sub    $0xc,%esp
f01005af:	0f b7 05 d8 55 12 f0 	movzwl 0xf01255d8,%eax
f01005b6:	25 fd ff 00 00       	and    $0xfffd,%eax
f01005bb:	50                   	push   %eax
f01005bc:	e8 41 2a 00 00       	call   f0103002 <irq_setmask_8259A>
}
f01005c1:	c9                   	leave  
f01005c2:	c3                   	ret    

f01005c3 <cons_intr>:



/***** General device-independent console code *****/
// Here we manage the console input buffer,
// where we stash characters received from the keyboard or serial port
// whenever the corresponding interrupt occurs.

#define CONSBUFSIZE 512

static struct {
	uint8_t buf[CONSBUFSIZE];
	uint32_t rpos;
	uint32_t wpos;
} cons;

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01005c3:	55                   	push   %ebp
f01005c4:	89 e5                	mov    %esp,%ebp
f01005c6:	53                   	push   %ebx
f01005c7:	83 ec 04             	sub    $0x4,%esp
f01005ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01005cd:	eb 26                	jmp    f01005f5 <cons_intr+0x32>
		if (c == 0)
f01005cf:	85 d2                	test   %edx,%edx
f01005d1:	74 22                	je     f01005f5 <cons_intr+0x32>
			continue;
		cons.buf[cons.wpos++] = c;
f01005d3:	a1 a4 5b 2f f0       	mov    0xf02f5ba4,%eax
f01005d8:	88 90 a0 59 2f f0    	mov    %dl,0xf02f59a0(%eax)
f01005de:	40                   	inc    %eax
f01005df:	a3 a4 5b 2f f0       	mov    %eax,0xf02f5ba4
		if (cons.wpos == CONSBUFSIZE)
f01005e4:	3d 00 02 00 00       	cmp    $0x200,%eax
f01005e9:	75 0a                	jne    f01005f5 <cons_intr+0x32>
			cons.wpos = 0;
f01005eb:	c7 05 a4 5b 2f f0 00 	movl   $0x0,0xf02f5ba4
f01005f2:	00 00 00 
f01005f5:	ff d3                	call   *%ebx
f01005f7:	89 c2                	mov    %eax,%edx
f01005f9:	83 f8 ff             	cmp    $0xffffffff,%eax
f01005fc:	75 d1                	jne    f01005cf <cons_intr+0xc>
	}
}
f01005fe:	83 c4 04             	add    $0x4,%esp
f0100601:	5b                   	pop    %ebx
f0100602:	c9                   	leave  
f0100603:	c3                   	ret    

f0100604 <cons_getc>:

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f0100604:	55                   	push   %ebp
f0100605:	89 e5                	mov    %esp,%ebp
f0100607:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f010060a:	e8 96 fb ff ff       	call   f01001a5 <serial_intr>
	kbd_intr();
f010060f:	e8 7b ff ff ff       	call   f010058f <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f0100614:	a1 a0 5b 2f f0       	mov    0xf02f5ba0,%eax
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
	}
	return 0;
f0100619:	ba 00 00 00 00       	mov    $0x0,%edx
f010061e:	3b 05 a4 5b 2f f0    	cmp    0xf02f5ba4,%eax
f0100624:	74 1e                	je     f0100644 <cons_getc+0x40>
f0100626:	0f b6 90 a0 59 2f f0 	movzbl 0xf02f59a0(%eax),%edx
f010062d:	40                   	inc    %eax
f010062e:	a3 a0 5b 2f f0       	mov    %eax,0xf02f5ba0
f0100633:	3d 00 02 00 00       	cmp    $0x200,%eax
f0100638:	75 0a                	jne    f0100644 <cons_getc+0x40>
f010063a:	c7 05 a0 5b 2f f0 00 	movl   $0x0,0xf02f5ba0
f0100641:	00 00 00 
}
f0100644:	89 d0                	mov    %edx,%eax
f0100646:	c9                   	leave  
f0100647:	c3                   	ret    

f0100648 <cons_putc>:

// output a character to the console
static void
cons_putc(int c)
{
f0100648:	55                   	push   %ebp
f0100649:	89 e5                	mov    %esp,%ebp
f010064b:	53                   	push   %ebx
f010064c:	83 ec 04             	sub    $0x4,%esp
f010064f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	serial_putc(c);
f0100652:	53                   	push   %ebx
f0100653:	e8 6e fb ff ff       	call   f01001c6 <serial_putc>
	lpt_putc(c);
f0100658:	53                   	push   %ebx
f0100659:	e8 13 fc ff ff       	call   f0100271 <lpt_putc>
	cga_putc(c);
f010065e:	83 ec 04             	sub    $0x4,%esp
f0100661:	53                   	push   %ebx
f0100662:	e8 c7 fc ff ff       	call   f010032e <cga_putc>
}
f0100667:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f010066a:	c9                   	leave  
f010066b:	c3                   	ret    

f010066c <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f010066c:	55                   	push   %ebp
f010066d:	89 e5                	mov    %esp,%ebp
f010066f:	83 ec 08             	sub    $0x8,%esp
	cga_init();
f0100672:	e8 3d fc ff ff       	call   f01002b4 <cga_init>
	kbd_init();
f0100677:	e8 25 ff ff ff       	call   f01005a1 <kbd_init>
	serial_init();
f010067c:	e8 80 fb ff ff       	call   f0100201 <serial_init>

	if (!serial_exists)
f0100681:	83 3d 84 59 2f f0 00 	cmpl   $0x0,0xf02f5984
f0100688:	75 10                	jne    f010069a <cons_init+0x2e>
		cprintf("Serial port does not exist!\n");
f010068a:	83 ec 0c             	sub    $0xc,%esp
f010068d:	68 79 5e 10 f0       	push   $0xf0105e79
f0100692:	e8 2b 2a 00 00       	call   f01030c2 <cprintf>
f0100697:	83 c4 10             	add    $0x10,%esp
}
f010069a:	c9                   	leave  
f010069b:	c3                   	ret    

f010069c <cputchar>:


// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f010069c:	55                   	push   %ebp
f010069d:	89 e5                	mov    %esp,%ebp
f010069f:	83 ec 14             	sub    $0x14,%esp
	cons_putc(c);
f01006a2:	ff 75 08             	pushl  0x8(%ebp)
f01006a5:	e8 9e ff ff ff       	call   f0100648 <cons_putc>
}
f01006aa:	c9                   	leave  
f01006ab:	c3                   	ret    

f01006ac <getchar>:

int
getchar(void)
{
f01006ac:	55                   	push   %ebp
f01006ad:	89 e5                	mov    %esp,%ebp
f01006af:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01006b2:	e8 4d ff ff ff       	call   f0100604 <cons_getc>
f01006b7:	85 c0                	test   %eax,%eax
f01006b9:	74 f7                	je     f01006b2 <getchar+0x6>
		/* do nothing */;
	return c;
}
f01006bb:	c9                   	leave  
f01006bc:	c3                   	ret    

f01006bd <iscons>:

int
iscons(int fdnum)
{
f01006bd:	55                   	push   %ebp
f01006be:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01006c0:	b8 01 00 00 00       	mov    $0x1,%eax
f01006c5:	c9                   	leave  
f01006c6:	c3                   	ret    
	...

f01006c8 <mon_hex_to_int>:
// lab 2 challenge

int
mon_hex_to_int(int argc, char **argv, struct Trapframe *tf)
{
f01006c8:	55                   	push   %ebp
f01006c9:	89 e5                	mov    %esp,%ebp
f01006cb:	53                   	push   %ebx
f01006cc:	83 ec 10             	sub    $0x10,%esp
f01006cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char* paddr_string = argv[1];
  int disp_int = strtoint(paddr_string);
f01006d2:	ff 73 04             	pushl  0x4(%ebx)
f01006d5:	e8 52 43 00 00       	call   f0104a2c <strtoint>

  if (disp_int == -1) {
f01006da:	83 c4 10             	add    $0x10,%esp
f01006dd:	83 f8 ff             	cmp    $0xffffffff,%eax
f01006e0:	75 12                	jne    f01006f4 <mon_hex_to_int+0x2c>
    cprintf("Error: invalid hex address.\n");
f01006e2:	83 ec 0c             	sub    $0xc,%esp
f01006e5:	68 48 5f 10 f0       	push   $0xf0105f48
f01006ea:	e8 d3 29 00 00       	call   f01030c2 <cprintf>
f01006ef:	83 c4 10             	add    $0x10,%esp
f01006f2:	eb 14                	jmp    f0100708 <mon_hex_to_int+0x40>
  } else {
    cprintf("Hex %s = int %d\n", argv[1], disp_int);
f01006f4:	83 ec 04             	sub    $0x4,%esp
f01006f7:	50                   	push   %eax
f01006f8:	ff 73 04             	pushl  0x4(%ebx)
f01006fb:	68 65 5f 10 f0       	push   $0xf0105f65
f0100700:	e8 bd 29 00 00       	call   f01030c2 <cprintf>
f0100705:	83 c4 10             	add    $0x10,%esp
  }

  return 0;
}
f0100708:	b8 00 00 00 00       	mov    $0x0,%eax
f010070d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100710:	c9                   	leave  
f0100711:	c3                   	ret    

f0100712 <mon_page_status>:

int
mon_page_status(int argc, char **argv, struct Trapframe *tf)
{
f0100712:	55                   	push   %ebp
f0100713:	89 e5                	mov    %esp,%ebp
f0100715:	53                   	push   %ebx
f0100716:	83 ec 10             	sub    $0x10,%esp
  char* paddr_string = argv[1];
  int paddr = strtoint(paddr_string);
f0100719:	8b 45 0c             	mov    0xc(%ebp),%eax
f010071c:	ff 70 04             	pushl  0x4(%eax)
f010071f:	e8 08 43 00 00       	call   f0104a2c <strtoint>
f0100724:	89 c1                	mov    %eax,%ecx
  struct Page *pp;

  // check paddr is valid hex format
  if (paddr == -1) {
f0100726:	83 c4 10             	add    $0x10,%esp
f0100729:	83 f8 ff             	cmp    $0xffffffff,%eax
f010072c:	75 14                	jne    f0100742 <mon_page_status+0x30>
    cprintf("Error: invalid hex address.\n");
f010072e:	83 ec 0c             	sub    $0xc,%esp
f0100731:	68 48 5f 10 f0       	push   $0xf0105f48
f0100736:	e8 87 29 00 00       	call   f01030c2 <cprintf>
    return 0;
f010073b:	b8 00 00 00 00       	mov    $0x0,%eax
f0100740:	eb 6e                	jmp    f01007b0 <mon_page_status+0x9e>

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f0100742:	c1 e8 0c             	shr    $0xc,%eax
f0100745:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f010074b:	72 14                	jb     f0100761 <mon_page_status+0x4f>
		panic("pa2page called with invalid pa");
f010074d:	83 ec 04             	sub    $0x4,%esp
f0100750:	68 b4 60 10 f0       	push   $0xf01060b4
f0100755:	6a 54                	push   $0x54
f0100757:	68 76 5f 10 f0       	push   $0xf0105f76
f010075c:	e8 88 f9 ff ff       	call   f01000e9 <_panic>
f0100761:	89 cb                	mov    %ecx,%ebx
f0100763:	c1 eb 0c             	shr    $0xc,%ebx
f0100766:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
f0100769:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f010076e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  }
  pp = pa2page(paddr);

  cprintf("page_status 0x%08x            \n", paddr);
f0100771:	83 ec 08             	sub    $0x8,%esp
f0100774:	51                   	push   %ecx
f0100775:	68 d4 60 10 f0       	push   $0xf01060d4
f010077a:	e8 43 29 00 00       	call   f01030c2 <cprintf>

  switch (pp->pp_ref) {
f010077f:	83 c4 10             	add    $0x10,%esp
f0100782:	66 83 7b 08 00       	cmpw   $0x0,0x8(%ebx)
f0100787:	75 12                	jne    f010079b <mon_page_status+0x89>
    case 0:
      cprintf("        free\n");
f0100789:	83 ec 0c             	sub    $0xc,%esp
f010078c:	68 84 5f 10 f0       	push   $0xf0105f84
f0100791:	e8 2c 29 00 00       	call   f01030c2 <cprintf>
      break;
f0100796:	83 c4 10             	add    $0x10,%esp
f0100799:	eb 10                	jmp    f01007ab <mon_page_status+0x99>
    default:
      cprintf("        allocated\n");
f010079b:	83 ec 0c             	sub    $0xc,%esp
f010079e:	68 92 5f 10 f0       	push   $0xf0105f92
f01007a3:	e8 1a 29 00 00       	call   f01030c2 <cprintf>
      break;
f01007a8:	83 c4 10             	add    $0x10,%esp
  }


  return 0;
f01007ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01007b0:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f01007b3:	c9                   	leave  
f01007b4:	c3                   	ret    

f01007b5 <mon_free_page>:

int
mon_free_page(int argc, char **argv, struct Trapframe *tf)
{
f01007b5:	55                   	push   %ebp
f01007b6:	89 e5                	mov    %esp,%ebp
f01007b8:	56                   	push   %esi
f01007b9:	53                   	push   %ebx
  char* paddr_string = argv[1];
f01007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
f01007bd:	8b 58 04             	mov    0x4(%eax),%ebx
  int paddr = strtoint(paddr_string);
f01007c0:	83 ec 0c             	sub    $0xc,%esp
f01007c3:	53                   	push   %ebx
f01007c4:	e8 63 42 00 00       	call   f0104a2c <strtoint>
f01007c9:	89 c6                	mov    %eax,%esi
  struct Page *pp;

  // check paddr is valid hex format
  if (paddr == -1) {
f01007cb:	83 c4 10             	add    $0x10,%esp
f01007ce:	83 f8 ff             	cmp    $0xffffffff,%eax
f01007d1:	75 14                	jne    f01007e7 <mon_free_page+0x32>
    cprintf("Error: invalid hex address.\n");
f01007d3:	83 ec 0c             	sub    $0xc,%esp
f01007d6:	68 48 5f 10 f0       	push   $0xf0105f48
f01007db:	e8 e2 28 00 00       	call   f01030c2 <cprintf>
    return 0;
f01007e0:	b8 00 00 00 00       	mov    $0x0,%eax
f01007e5:	eb 56                	jmp    f010083d <mon_free_page+0x88>
  }

  cprintf("free_page %s            \n", paddr_string);
f01007e7:	83 ec 08             	sub    $0x8,%esp
f01007ea:	53                   	push   %ebx
f01007eb:	68 a5 5f 10 f0       	push   $0xf0105fa5
f01007f0:	e8 cd 28 00 00       	call   f01030c2 <cprintf>
}

static inline struct Page*
pa2page(physaddr_t pa)
{
f01007f5:	83 c4 10             	add    $0x10,%esp
	if (PPN(pa) >= npage)
f01007f8:	89 f0                	mov    %esi,%eax
f01007fa:	c1 e8 0c             	shr    $0xc,%eax
f01007fd:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0100803:	72 14                	jb     f0100819 <mon_free_page+0x64>
		panic("pa2page called with invalid pa");
f0100805:	83 ec 04             	sub    $0x4,%esp
f0100808:	68 b4 60 10 f0       	push   $0xf01060b4
f010080d:	6a 54                	push   $0x54
f010080f:	68 76 5f 10 f0       	push   $0xf0105f76
f0100814:	e8 d0 f8 ff ff       	call   f01000e9 <_panic>
f0100819:	89 f0                	mov    %esi,%eax
f010081b:	c1 e8 0c             	shr    $0xc,%eax
f010081e:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100821:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0100826:	8d 04 90             	lea    (%eax,%edx,4),%eax

  // get out the page
  pp = pa2page(paddr);
  pp->pp_ref = 0;
f0100829:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
  page_free(pp);
f010082f:	83 ec 0c             	sub    $0xc,%esp
f0100832:	50                   	push   %eax
f0100833:	e8 b3 0f 00 00       	call   f01017eb <page_free>

  return 0;
f0100838:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010083d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0100840:	5b                   	pop    %ebx
f0100841:	5e                   	pop    %esi
f0100842:	c9                   	leave  
f0100843:	c3                   	ret    

f0100844 <mon_alloc_page>:

int
mon_alloc_page(int argc, char **argv, struct Trapframe *tf)
{
f0100844:	55                   	push   %ebp
f0100845:	89 e5                	mov    %esp,%ebp
f0100847:	83 ec 14             	sub    $0x14,%esp
  struct Page *new_page;
  cprintf("alloc_page    \n");
f010084a:	68 bf 5f 10 f0       	push   $0xf0105fbf
f010084f:	e8 6e 28 00 00       	call   f01030c2 <cprintf>
  page_alloc(&new_page);
f0100854:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f0100857:	89 04 24             	mov    %eax,(%esp)
f010085a:	e8 47 0f 00 00       	call   f01017a6 <page_alloc>
  new_page->pp_ref++;
f010085f:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f0100862:	66 ff 40 08          	incw   0x8(%eax)
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0100866:	83 c4 08             	add    $0x8,%esp
f0100869:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
f010086c:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0100872:	c1 fa 02             	sar    $0x2,%edx
f0100875:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0100878:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010087b:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010087e:	89 c1                	mov    %eax,%ecx
f0100880:	c1 e1 08             	shl    $0x8,%ecx
f0100883:	01 c8                	add    %ecx,%eax
f0100885:	89 c1                	mov    %eax,%ecx
f0100887:	c1 e1 10             	shl    $0x10,%ecx
f010088a:	01 c8                	add    %ecx,%eax
f010088c:	8d 04 42             	lea    (%edx,%eax,2),%eax
f010088f:	c1 e0 0c             	shl    $0xc,%eax
f0100892:	50                   	push   %eax
f0100893:	68 cf 5f 10 f0       	push   $0xf0105fcf
f0100898:	e8 25 28 00 00       	call   f01030c2 <cprintf>
  cprintf("        0x%08x\n", page2pa(new_page));
  return 0;
}
f010089d:	b8 00 00 00 00       	mov    $0x0,%eax
f01008a2:	c9                   	leave  
f01008a3:	c3                   	ret    

f01008a4 <mon_help>:




int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01008a4:	55                   	push   %ebp
f01008a5:	89 e5                	mov    %esp,%ebp
f01008a7:	53                   	push   %ebx
f01008a8:	83 ec 04             	sub    $0x4,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
f01008ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01008b0:	83 ec 04             	sub    $0x4,%esp
f01008b3:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01008b6:	c1 e0 02             	shl    $0x2,%eax
f01008b9:	ff b0 44 55 12 f0    	pushl  0xf0125544(%eax)
f01008bf:	ff b0 40 55 12 f0    	pushl  0xf0125540(%eax)
f01008c5:	68 df 5f 10 f0       	push   $0xf0105fdf
f01008ca:	e8 f3 27 00 00       	call   f01030c2 <cprintf>
f01008cf:	83 c4 10             	add    $0x10,%esp
f01008d2:	43                   	inc    %ebx
f01008d3:	83 fb 06             	cmp    $0x6,%ebx
f01008d6:	76 d8                	jbe    f01008b0 <mon_help+0xc>
	return 0;
}
f01008d8:	b8 00 00 00 00       	mov    $0x0,%eax
f01008dd:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f01008e0:	c9                   	leave  
f01008e1:	c3                   	ret    

f01008e2 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01008e2:	55                   	push   %ebp
f01008e3:	89 e5                	mov    %esp,%ebp
f01008e5:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01008e8:	68 e8 5f 10 f0       	push   $0xf0105fe8
f01008ed:	e8 d0 27 00 00       	call   f01030c2 <cprintf>
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
f01008f2:	83 c4 0c             	add    $0xc,%esp
f01008f5:	68 0c 00 10 00       	push   $0x10000c
f01008fa:	68 0c 00 10 f0       	push   $0xf010000c
f01008ff:	68 f4 60 10 f0       	push   $0xf01060f4
f0100904:	e8 b9 27 00 00       	call   f01030c2 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100909:	83 c4 0c             	add    $0xc,%esp
f010090c:	68 06 5e 10 00       	push   $0x105e06
f0100911:	68 06 5e 10 f0       	push   $0xf0105e06
f0100916:	68 18 61 10 f0       	push   $0xf0106118
f010091b:	e8 a2 27 00 00       	call   f01030c2 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100920:	83 c4 0c             	add    $0xc,%esp
f0100923:	68 5d 59 2f 00       	push   $0x2f595d
f0100928:	68 5d 59 2f f0       	push   $0xf02f595d
f010092d:	68 3c 61 10 f0       	push   $0xf010613c
f0100932:	e8 8b 27 00 00       	call   f01030c2 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100937:	83 c4 0c             	add    $0xc,%esp
f010093a:	68 04 8b 32 00       	push   $0x328b04
f010093f:	68 04 8b 32 f0       	push   $0xf0328b04
f0100944:	68 60 61 10 f0       	push   $0xf0106160
f0100949:	e8 74 27 00 00       	call   f01030c2 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f010094e:	83 c4 08             	add    $0x8,%esp
f0100951:	b8 0c 00 10 f0       	mov    $0xf010000c,%eax
f0100956:	f7 d8                	neg    %eax
f0100958:	05 03 8f 32 f0       	add    $0xf0328f03,%eax
f010095d:	79 05                	jns    f0100964 <mon_kerninfo+0x82>
f010095f:	05 ff 03 00 00       	add    $0x3ff,%eax
f0100964:	c1 f8 0a             	sar    $0xa,%eax
f0100967:	50                   	push   %eax
f0100968:	68 84 61 10 f0       	push   $0xf0106184
f010096d:	e8 50 27 00 00       	call   f01030c2 <cprintf>
		(end-_start+1023)/1024);
	return 0;
}
f0100972:	b8 00 00 00 00       	mov    $0x0,%eax
f0100977:	c9                   	leave  
f0100978:	c3                   	ret    

f0100979 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100979:	55                   	push   %ebp
f010097a:	89 e5                	mov    %esp,%ebp
f010097c:	56                   	push   %esi
f010097d:	53                   	push   %ebx
f010097e:	83 ec 20             	sub    $0x20,%esp
}

static __inline uint32_t
read_ebp(void)
{
f0100981:	89 eb                	mov    %ebp,%ebx

	// Your code here.
        // seanyliu - 9/15/2009

        // First, extract the current base pointer, since
        // this gives us a pointer to the base frame. We
        // also should initialize eip.
        int* ebp = (int*)read_ebp();
        int* eip = (int*)read_eip();
f0100983:	e8 cd 01 00 00       	call   f0100b55 <read_eip>
f0100988:	89 c6                	mov    %eax,%esi
        struct Eipdebuginfo info;
        //cprintf("DEBUG: *ebp %08x ; ebp %08x ; &ebp %08x ; (int)ebp %08x ; \n", *ebp, ebp, &ebp, (int)ebp);
        //cprintf("DEBUG: read_ebp() %08x\n", read_ebp());

  	cprintf("Stack backtrace:\n");
f010098a:	83 ec 0c             	sub    $0xc,%esp
f010098d:	68 01 60 10 f0       	push   $0xf0106001
f0100992:	e8 2b 27 00 00       	call   f01030c2 <cprintf>
        // We could do a while as long as ebp is < the stack.
        // However, in obj/kern/kernel.asm, we see that the ebp
        // is initially nuked to be 0x0.  Therefore, we can
        // use this as a conditional check of when to quit.
        // This is in case there is junk at the top of the stack
        // and the original ebp is not the first line.
        while (ebp != 0x0) {
f0100997:	83 c4 10             	add    $0x10,%esp
          //cprintf("DEBUG in while: *ebp %08x ; ebp %08x ; &ebp %08x ; (int)ebp %08x ; \n", *ebp, ebp, &ebp, (int)ebp);
  	  cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
          if (debuginfo_eip((int)eip, &info) == 0) {
            cprintf("         %s:%d: %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, (int)eip - info.eip_fn_addr);
          }
          eip = (int*)ebp[1];
          ebp = (int*)ebp[0]; // see http://unixwiz.net/techtips/win32-callconv-asm.html
f010099a:	85 db                	test   %ebx,%ebx
f010099c:	74 5c                	je     f01009fa <mon_backtrace+0x81>
f010099e:	ff 73 18             	pushl  0x18(%ebx)
f01009a1:	ff 73 14             	pushl  0x14(%ebx)
f01009a4:	ff 73 10             	pushl  0x10(%ebx)
f01009a7:	ff 73 0c             	pushl  0xc(%ebx)
f01009aa:	ff 73 08             	pushl  0x8(%ebx)
f01009ad:	ff 73 04             	pushl  0x4(%ebx)
f01009b0:	53                   	push   %ebx
f01009b1:	68 b0 61 10 f0       	push   $0xf01061b0
f01009b6:	e8 07 27 00 00       	call   f01030c2 <cprintf>
f01009bb:	83 c4 18             	add    $0x18,%esp
f01009be:	8d 45 d8             	lea    0xffffffd8(%ebp),%eax
f01009c1:	50                   	push   %eax
f01009c2:	56                   	push   %esi
f01009c3:	e8 26 38 00 00       	call   f01041ee <debuginfo_eip>
f01009c8:	83 c4 10             	add    $0x10,%esp
f01009cb:	85 c0                	test   %eax,%eax
f01009cd:	75 22                	jne    f01009f1 <mon_backtrace+0x78>
f01009cf:	83 ec 08             	sub    $0x8,%esp
f01009d2:	89 f0                	mov    %esi,%eax
f01009d4:	2b 45 e8             	sub    0xffffffe8(%ebp),%eax
f01009d7:	50                   	push   %eax
f01009d8:	ff 75 e0             	pushl  0xffffffe0(%ebp)
f01009db:	ff 75 e4             	pushl  0xffffffe4(%ebp)
f01009de:	ff 75 dc             	pushl  0xffffffdc(%ebp)
f01009e1:	ff 75 d8             	pushl  0xffffffd8(%ebp)
f01009e4:	68 13 60 10 f0       	push   $0xf0106013
f01009e9:	e8 d4 26 00 00       	call   f01030c2 <cprintf>
f01009ee:	83 c4 20             	add    $0x20,%esp
f01009f1:	8b 73 04             	mov    0x4(%ebx),%esi
f01009f4:	8b 1b                	mov    (%ebx),%ebx
f01009f6:	85 db                	test   %ebx,%ebx
f01009f8:	75 a4                	jne    f010099e <mon_backtrace+0x25>
        }
  	/*
	cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
        if (debuginfo_eip((int)eip, &info) == 0) {
          cprintf("         %s:%d: %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, (int)eip - info.eip_fn_addr);
        }
	*/
	return 0;
}
f01009fa:	b8 00 00 00 00       	mov    $0x0,%eax
f01009ff:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0100a02:	5b                   	pop    %ebx
f0100a03:	5e                   	pop    %esi
f0100a04:	c9                   	leave  
f0100a05:	c3                   	ret    

f0100a06 <runcmd>:



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
f0100a06:	55                   	push   %ebp
f0100a07:	89 e5                	mov    %esp,%ebp
f0100a09:	57                   	push   %edi
f0100a0a:	56                   	push   %esi
f0100a0b:	53                   	push   %ebx
f0100a0c:	83 ec 4c             	sub    $0x4c,%esp
f0100a0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0100a12:	bf 00 00 00 00       	mov    $0x0,%edi
	argv[argc] = 0;
f0100a17:	c7 45 a8 00 00 00 00 	movl   $0x0,0xffffffa8(%ebp)
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100a1e:	eb 04                	jmp    f0100a24 <runcmd+0x1e>
			*buf++ = 0;
f0100a20:	c6 03 00             	movb   $0x0,(%ebx)
f0100a23:	43                   	inc    %ebx
f0100a24:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a27:	74 49                	je     f0100a72 <runcmd+0x6c>
f0100a29:	83 ec 08             	sub    $0x8,%esp
f0100a2c:	0f be 03             	movsbl (%ebx),%eax
f0100a2f:	50                   	push   %eax
f0100a30:	68 2c 60 10 f0       	push   $0xf010602c
f0100a35:	e8 1e 42 00 00       	call   f0104c58 <strchr>
f0100a3a:	83 c4 10             	add    $0x10,%esp
f0100a3d:	85 c0                	test   %eax,%eax
f0100a3f:	75 df                	jne    f0100a20 <runcmd+0x1a>
		if (*buf == 0)
f0100a41:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a44:	74 2c                	je     f0100a72 <runcmd+0x6c>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100a46:	83 ff 0f             	cmp    $0xf,%edi
f0100a49:	74 3a                	je     f0100a85 <runcmd+0x7f>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
f0100a4b:	89 5c bd a8          	mov    %ebx,0xffffffa8(%ebp,%edi,4)
f0100a4f:	47                   	inc    %edi
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a50:	eb 01                	jmp    f0100a53 <runcmd+0x4d>
			buf++;
f0100a52:	43                   	inc    %ebx
f0100a53:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a56:	74 1a                	je     f0100a72 <runcmd+0x6c>
f0100a58:	83 ec 08             	sub    $0x8,%esp
f0100a5b:	0f be 03             	movsbl (%ebx),%eax
f0100a5e:	50                   	push   %eax
f0100a5f:	68 2c 60 10 f0       	push   $0xf010602c
f0100a64:	e8 ef 41 00 00       	call   f0104c58 <strchr>
f0100a69:	83 c4 10             	add    $0x10,%esp
f0100a6c:	85 c0                	test   %eax,%eax
f0100a6e:	74 e2                	je     f0100a52 <runcmd+0x4c>
f0100a70:	eb b2                	jmp    f0100a24 <runcmd+0x1e>
	}
	argv[argc] = 0;
f0100a72:	c7 44 bd a8 00 00 00 	movl   $0x0,0xffffffa8(%ebp,%edi,4)
f0100a79:	00 

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
f0100a7a:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a7f:	85 ff                	test   %edi,%edi
f0100a81:	74 6d                	je     f0100af0 <runcmd+0xea>
f0100a83:	eb 29                	jmp    f0100aae <runcmd+0xa8>
f0100a85:	83 ec 08             	sub    $0x8,%esp
f0100a88:	6a 10                	push   $0x10
f0100a8a:	68 31 60 10 f0       	push   $0xf0106031
f0100a8f:	e8 2e 26 00 00       	call   f01030c2 <cprintf>
f0100a94:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a99:	eb 55                	jmp    f0100af0 <runcmd+0xea>
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
f0100a9b:	83 ec 04             	sub    $0x4,%esp
f0100a9e:	ff 75 0c             	pushl  0xc(%ebp)
f0100aa1:	8d 45 a8             	lea    0xffffffa8(%ebp),%eax
f0100aa4:	50                   	push   %eax
f0100aa5:	57                   	push   %edi
f0100aa6:	ff 96 48 55 12 f0    	call   *0xf0125548(%esi)
f0100aac:	eb 42                	jmp    f0100af0 <runcmd+0xea>
f0100aae:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100ab3:	83 ec 08             	sub    $0x8,%esp
f0100ab6:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100ab9:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
f0100ac0:	ff b6 40 55 12 f0    	pushl  0xf0125540(%esi)
f0100ac6:	ff 75 a8             	pushl  0xffffffa8(%ebp)
f0100ac9:	e8 1b 41 00 00       	call   f0104be9 <strcmp>
f0100ace:	83 c4 10             	add    $0x10,%esp
f0100ad1:	85 c0                	test   %eax,%eax
f0100ad3:	74 c6                	je     f0100a9b <runcmd+0x95>
f0100ad5:	43                   	inc    %ebx
f0100ad6:	83 fb 06             	cmp    $0x6,%ebx
f0100ad9:	76 d8                	jbe    f0100ab3 <runcmd+0xad>
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100adb:	83 ec 08             	sub    $0x8,%esp
f0100ade:	ff 75 a8             	pushl  0xffffffa8(%ebp)
f0100ae1:	68 4e 60 10 f0       	push   $0xf010604e
f0100ae6:	e8 d7 25 00 00       	call   f01030c2 <cprintf>
	return 0;
f0100aeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100af0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0100af3:	5b                   	pop    %ebx
f0100af4:	5e                   	pop    %esi
f0100af5:	5f                   	pop    %edi
f0100af6:	c9                   	leave  
f0100af7:	c3                   	ret    

f0100af8 <monitor>:

void
monitor(struct Trapframe *tf)
{
f0100af8:	55                   	push   %ebp
f0100af9:	89 e5                	mov    %esp,%ebp
f0100afb:	53                   	push   %ebx
f0100afc:	83 ec 10             	sub    $0x10,%esp
f0100aff:	8b 5d 08             	mov    0x8(%ebp),%ebx
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100b02:	68 e4 61 10 f0       	push   $0xf01061e4
f0100b07:	e8 b6 25 00 00       	call   f01030c2 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100b0c:	c7 04 24 08 62 10 f0 	movl   $0xf0106208,(%esp)
f0100b13:	e8 aa 25 00 00       	call   f01030c2 <cprintf>

	if (tf != NULL)
f0100b18:	83 c4 10             	add    $0x10,%esp
f0100b1b:	85 db                	test   %ebx,%ebx
f0100b1d:	74 0c                	je     f0100b2b <monitor+0x33>
		print_trapframe(tf);
f0100b1f:	83 ec 0c             	sub    $0xc,%esp
f0100b22:	53                   	push   %ebx
f0100b23:	e8 8c 27 00 00       	call   f01032b4 <print_trapframe>
f0100b28:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100b2b:	83 ec 0c             	sub    $0xc,%esp
f0100b2e:	68 64 60 10 f0       	push   $0xf0106064
f0100b33:	e8 20 3e 00 00       	call   f0104958 <readline>
		if (buf != NULL)
f0100b38:	83 c4 10             	add    $0x10,%esp
f0100b3b:	85 c0                	test   %eax,%eax
f0100b3d:	74 ec                	je     f0100b2b <monitor+0x33>
			if (runcmd(buf, tf) < 0)
f0100b3f:	83 ec 08             	sub    $0x8,%esp
f0100b42:	53                   	push   %ebx
f0100b43:	50                   	push   %eax
f0100b44:	e8 bd fe ff ff       	call   f0100a06 <runcmd>
f0100b49:	83 c4 10             	add    $0x10,%esp
f0100b4c:	85 c0                	test   %eax,%eax
f0100b4e:	79 db                	jns    f0100b2b <monitor+0x33>
				break;
	}
}
f0100b50:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100b53:	c9                   	leave  
f0100b54:	c3                   	ret    

f0100b55 <read_eip>:

// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
f0100b55:	55                   	push   %ebp
f0100b56:	89 e5                	mov    %esp,%ebp
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
f0100b58:	8b 45 04             	mov    0x4(%ebp),%eax
	return callerpc;
}
f0100b5b:	c9                   	leave  
f0100b5c:	c3                   	ret    
f0100b5d:	00 00                	add    %al,(%eax)
	...

f0100b60 <nvram_read>:
};

static int
nvram_read(int r)
{
f0100b60:	55                   	push   %ebp
f0100b61:	89 e5                	mov    %esp,%ebp
f0100b63:	56                   	push   %esi
f0100b64:	53                   	push   %ebx
f0100b65:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100b68:	83 ec 0c             	sub    $0xc,%esp
f0100b6b:	53                   	push   %ebx
f0100b6c:	e8 bb 23 00 00       	call   f0102f2c <mc146818_read>
f0100b71:	89 c6                	mov    %eax,%esi
f0100b73:	43                   	inc    %ebx
f0100b74:	89 1c 24             	mov    %ebx,(%esp)
f0100b77:	e8 b0 23 00 00       	call   f0102f2c <mc146818_read>
f0100b7c:	c1 e0 08             	shl    $0x8,%eax
f0100b7f:	09 c6                	or     %eax,%esi
}
f0100b81:	89 f0                	mov    %esi,%eax
f0100b83:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0100b86:	5b                   	pop    %ebx
f0100b87:	5e                   	pop    %esi
f0100b88:	c9                   	leave  
f0100b89:	c3                   	ret    

f0100b8a <i386_detect_memory>:

void
i386_detect_memory(void)
{
f0100b8a:	55                   	push   %ebp
f0100b8b:	89 e5                	mov    %esp,%ebp
f0100b8d:	83 ec 14             	sub    $0x14,%esp
	// CMOS tells us how many kilobytes there are
	basemem = ROUNDDOWN(nvram_read(NVRAM_BASELO)*1024, PGSIZE);
f0100b90:	6a 15                	push   $0x15
f0100b92:	e8 c9 ff ff ff       	call   f0100b60 <nvram_read>
f0100b97:	c1 e0 0a             	shl    $0xa,%eax
f0100b9a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100b9f:	a3 ac 5b 2f f0       	mov    %eax,0xf02f5bac
	extmem = ROUNDDOWN(nvram_read(NVRAM_EXTLO)*1024, PGSIZE);
f0100ba4:	c7 04 24 17 00 00 00 	movl   $0x17,(%esp)
f0100bab:	e8 b0 ff ff ff       	call   f0100b60 <nvram_read>
f0100bb0:	83 c4 10             	add    $0x10,%esp
f0100bb3:	c1 e0 0a             	shl    $0xa,%eax
f0100bb6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100bbb:	a3 b0 5b 2f f0       	mov    %eax,0xf02f5bb0

	// Calculate the maximum physical address based on whether
	// or not there is any extended memory.  See comment in <inc/mmu.h>.
	if (extmem)
f0100bc0:	85 c0                	test   %eax,%eax
f0100bc2:	74 0c                	je     f0100bd0 <i386_detect_memory+0x46>
		maxpa = EXTPHYSMEM + extmem;
f0100bc4:	05 00 00 10 00       	add    $0x100000,%eax
f0100bc9:	a3 a8 5b 2f f0       	mov    %eax,0xf02f5ba8
f0100bce:	eb 0a                	jmp    f0100bda <i386_detect_memory+0x50>
	else
		maxpa = basemem;
f0100bd0:	a1 ac 5b 2f f0       	mov    0xf02f5bac,%eax
f0100bd5:	a3 a8 5b 2f f0       	mov    %eax,0xf02f5ba8

	npage = maxpa / PGSIZE;
f0100bda:	a1 a8 5b 2f f0       	mov    0xf02f5ba8,%eax
f0100bdf:	89 c2                	mov    %eax,%edx
f0100be1:	c1 ea 0c             	shr    $0xc,%edx
f0100be4:	89 15 70 68 2f f0    	mov    %edx,0xf02f6870

	cprintf("Physical memory: %dK available, ", (int)(maxpa/1024));
f0100bea:	83 ec 08             	sub    $0x8,%esp
f0100bed:	c1 e8 0a             	shr    $0xa,%eax
f0100bf0:	50                   	push   %eax
f0100bf1:	68 30 62 10 f0       	push   $0xf0106230
f0100bf6:	e8 c7 24 00 00       	call   f01030c2 <cprintf>
	cprintf("base = %dK, extended = %dK\n", (int)(basemem/1024), (int)(extmem/1024));
f0100bfb:	83 c4 0c             	add    $0xc,%esp
f0100bfe:	a1 b0 5b 2f f0       	mov    0xf02f5bb0,%eax
f0100c03:	c1 e8 0a             	shr    $0xa,%eax
f0100c06:	50                   	push   %eax
f0100c07:	a1 ac 5b 2f f0       	mov    0xf02f5bac,%eax
f0100c0c:	c1 e8 0a             	shr    $0xa,%eax
f0100c0f:	50                   	push   %eax
f0100c10:	68 06 68 10 f0       	push   $0xf0106806
f0100c15:	e8 a8 24 00 00       	call   f01030c2 <cprintf>
}
f0100c1a:	c9                   	leave  
f0100c1b:	c3                   	ret    

f0100c1c <boot_alloc>:

// --------------------------------------------------------------
// Set up initial memory mappings and turn on MMU.
// --------------------------------------------------------------

static void check_boot_pgdir(void);
static void check_page_alloc();
static void page_check(void);
static void boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, physaddr_t pa, int perm);

//
// A simple physical memory allocator, used only a few times
// in the process of setting up the virtual memory system.
// page_alloc() is the real allocator.
//
// Allocate n bytes of physical memory aligned on an 
// align-byte boundary.  Align must be a power of two.
// Return kernel virtual address.  Returned memory is uninitialized.
//
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list has been set up.
// 
static void*
boot_alloc(uint32_t n, uint32_t align)
{
f0100c1c:	55                   	push   %ebp
f0100c1d:	89 e5                	mov    %esp,%ebp
f0100c1f:	53                   	push   %ebx
f0100c20:	83 ec 04             	sub    $0x4,%esp
f0100c23:	8b 55 0c             	mov    0xc(%ebp),%edx
	extern char end[];
	void *v;

	// Initialize boot_freemem if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment -
	// i.e., the first virtual address that the linker
	// did _not_ assign to any kernel code or global variables.
	if (boot_freemem == 0)
f0100c26:	83 3d b4 5b 2f f0 00 	cmpl   $0x0,0xf02f5bb4
f0100c2d:	75 0a                	jne    f0100c39 <boot_alloc+0x1d>
		boot_freemem = end;
f0100c2f:	c7 05 b4 5b 2f f0 04 	movl   $0xf0328b04,0xf02f5bb4
f0100c36:	8b 32 f0 

        // seanyliu
	// LAB 2: Your code here:

	//	Step 1: round boot_freemem up to be aligned properly

        // Attempt #1
        //uint32_t temp_freemem; // seanyliu
        //temp_freemem = (uint32_t)boot_freemem & (0 - align);
        //if (boot_freemem > temp_freemem) {
        //  boot_freemem = temp_freemem + align;
        //} else {
        //}

        // Attempt #2
        //uint32_t rem = (uint32_t)boot_freemem % align;
        //if (rem != 0) boot_freemem = boot_freemem + align - rem;

        // Attempt #3...turns out there's a ROUNDUP function
	boot_freemem = ROUNDUP(boot_freemem, align);
f0100c39:	89 d3                	mov    %edx,%ebx
f0100c3b:	03 1d b4 5b 2f f0    	add    0xf02f5bb4,%ebx
f0100c41:	4b                   	dec    %ebx
f0100c42:	89 d8                	mov    %ebx,%eax
f0100c44:	89 d1                	mov    %edx,%ecx
f0100c46:	ba 00 00 00 00       	mov    $0x0,%edx
f0100c4b:	f7 f1                	div    %ecx

	//	Step 2: save current value of boot_freemem as allocated chunk
        v = boot_freemem;
f0100c4d:	29 d3                	sub    %edx,%ebx

	//	Step 3: increase boot_freemem to record allocation
        boot_freemem += n;
f0100c4f:	8b 45 08             	mov    0x8(%ebp),%eax
f0100c52:	01 d8                	add    %ebx,%eax
f0100c54:	a3 b4 5b 2f f0       	mov    %eax,0xf02f5bb4
        if (PADDR(boot_freemem) > maxpa) {
f0100c59:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100c5e:	77 15                	ja     f0100c75 <boot_alloc+0x59>
f0100c60:	50                   	push   %eax
f0100c61:	68 54 62 10 f0       	push   $0xf0106254
f0100c66:	68 91 00 00 00       	push   $0x91
f0100c6b:	68 22 68 10 f0       	push   $0xf0106822
f0100c70:	e8 74 f4 ff ff       	call   f01000e9 <_panic>
f0100c75:	05 00 00 00 10       	add    $0x10000000,%eax
f0100c7a:	3b 05 a8 5b 2f f0    	cmp    0xf02f5ba8,%eax
f0100c80:	76 17                	jbe    f0100c99 <boot_alloc+0x7d>
          panic("boot_alloc, allocating beyond our memory capacity");
f0100c82:	83 ec 04             	sub    $0x4,%esp
f0100c85:	68 78 62 10 f0       	push   $0xf0106278
f0100c8a:	68 92 00 00 00       	push   $0x92
f0100c8f:	68 22 68 10 f0       	push   $0xf0106822
f0100c94:	e8 50 f4 ff ff       	call   f01000e9 <_panic>
        }

	//	Step 4: return allocated chunk
        return v;

	//return NULL;
}
f0100c99:	89 d8                	mov    %ebx,%eax
f0100c9b:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100c9e:	c9                   	leave  
f0100c9f:	c3                   	ret    

f0100ca0 <i386_vm_init>:

// Set up a two-level page table:
//    boot_pgdir is its linear (virtual) address of the root
//    boot_cr3 is the physical adresss of the root
// Then turn on paging.  Then effectively turn off segmentation.
// (i.e., the segment base addrs are set to zero).
// 
// This function only sets up the kernel part of the address space
// (ie. addresses >= UTOP).  The user part of the address space
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read (or write). 
void
i386_vm_init(void)
{
f0100ca0:	55                   	push   %ebp
f0100ca1:	89 e5                	mov    %esp,%ebp
f0100ca3:	53                   	push   %ebx
f0100ca4:	83 ec 0c             	sub    $0xc,%esp
	pde_t* pgdir;
	uint32_t cr0;
	size_t n;

	// Delete this line:
        // seanyliu
	//panic("i386_vm_init: This function is not finished\n");

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	pgdir = boot_alloc(PGSIZE, PGSIZE);
f0100ca7:	68 00 10 00 00       	push   $0x1000
f0100cac:	68 00 10 00 00       	push   $0x1000
f0100cb1:	e8 66 ff ff ff       	call   f0100c1c <boot_alloc>
f0100cb6:	89 c3                	mov    %eax,%ebx
	memset(pgdir, 0, PGSIZE);
f0100cb8:	83 c4 0c             	add    $0xc,%esp
f0100cbb:	68 00 10 00 00       	push   $0x1000
f0100cc0:	6a 00                	push   $0x0
f0100cc2:	50                   	push   %eax
f0100cc3:	e8 c9 3f 00 00       	call   f0104c91 <memset>
	boot_pgdir = pgdir;
f0100cc8:	89 1d 78 68 2f f0    	mov    %ebx,0xf02f6878
	boot_cr3 = PADDR(pgdir);
f0100cce:	83 c4 10             	add    $0x10,%esp
f0100cd1:	89 d8                	mov    %ebx,%eax
f0100cd3:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100cd9:	77 15                	ja     f0100cf0 <i386_vm_init+0x50>
f0100cdb:	53                   	push   %ebx
f0100cdc:	68 54 62 10 f0       	push   $0xf0106254
f0100ce1:	68 b7 00 00 00       	push   $0xb7
f0100ce6:	68 22 68 10 f0       	push   $0xf0106822
f0100ceb:	e8 f9 f3 ff ff       	call   f01000e9 <_panic>
f0100cf0:	05 00 00 00 10       	add    $0x10000000,%eax
f0100cf5:	a3 74 68 2f f0       	mov    %eax,0xf02f6874

	//////////////////////////////////////////////////////////////////////
	// Recursively insert PD in itself as a page table, to form
	// a virtual page table at virtual address VPT.
	// (For now, you don't have understand the greater purpose of the
	// following two lines.)

	// Permissions: kernel RW, user NONE
	pgdir[PDX(VPT)] = PADDR(pgdir)|PTE_W|PTE_P;
f0100cfa:	89 d8                	mov    %ebx,%eax
f0100cfc:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100d02:	77 15                	ja     f0100d19 <i386_vm_init+0x79>
f0100d04:	53                   	push   %ebx
f0100d05:	68 54 62 10 f0       	push   $0xf0106254
f0100d0a:	68 c0 00 00 00       	push   $0xc0
f0100d0f:	68 22 68 10 f0       	push   $0xf0106822
f0100d14:	e8 d0 f3 ff ff       	call   f01000e9 <_panic>
f0100d19:	05 00 00 00 10       	add    $0x10000000,%eax
f0100d1e:	83 c8 03             	or     $0x3,%eax
f0100d21:	89 83 fc 0e 00 00    	mov    %eax,0xefc(%ebx)

	// same for UVPT
	// Permissions: kernel R, user R 
	pgdir[PDX(UVPT)] = PADDR(pgdir)|PTE_U|PTE_P;
f0100d27:	89 d8                	mov    %ebx,%eax
f0100d29:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100d2f:	77 15                	ja     f0100d46 <i386_vm_init+0xa6>
f0100d31:	53                   	push   %ebx
f0100d32:	68 54 62 10 f0       	push   $0xf0106254
f0100d37:	68 c4 00 00 00       	push   $0xc4
f0100d3c:	68 22 68 10 f0       	push   $0xf0106822
f0100d41:	e8 a3 f3 ff ff       	call   f01000e9 <_panic>
f0100d46:	05 00 00 00 10       	add    $0x10000000,%eax
f0100d4b:	83 c8 05             	or     $0x5,%eax
f0100d4e:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)

	//////////////////////////////////////////////////////////////////////
	// Make 'pages' point to an array of size 'npage' of 'struct Page'.
	// The kernel uses this structure to keep track of physical pages;
	// 'npage' equals the number of physical pages in memory.  User-level
	// programs will get read-only access to the array as well.
	// You must allocate the array yourself.
	// Your code goes here: 

        // seanyliu
        n = npage * sizeof(struct Page);
f0100d54:	a1 70 68 2f f0       	mov    0xf02f6870,%eax
f0100d59:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100d5c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
        pages = boot_alloc(n, PGSIZE);
f0100d63:	83 ec 08             	sub    $0x8,%esp
f0100d66:	68 00 10 00 00       	push   $0x1000
f0100d6b:	52                   	push   %edx
f0100d6c:	e8 ab fe ff ff       	call   f0100c1c <boot_alloc>
f0100d71:	a3 7c 68 2f f0       	mov    %eax,0xf02f687c

	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
        n = NENV * sizeof(struct Env);
        envs = boot_alloc(n, PGSIZE);
f0100d76:	83 c4 08             	add    $0x8,%esp
f0100d79:	68 00 10 00 00       	push   $0x1000
f0100d7e:	68 00 00 02 00       	push   $0x20000
f0100d83:	e8 94 fe ff ff       	call   f0100c1c <boot_alloc>
f0100d88:	a3 c0 5b 2f f0       	mov    %eax,0xf02f5bc0

	//////////////////////////////////////////////////////////////////////
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_segment or page_insert
	page_init();
f0100d8d:	e8 8a 08 00 00       	call   f010161c <page_init>

        check_page_alloc();
f0100d92:	e8 59 01 00 00       	call   f0100ef0 <check_page_alloc>

	page_check();
f0100d97:	e8 b1 0e 00 00       	call   f0101c4d <page_check>

	//////////////////////////////////////////////////////////////////////
	// Now we set up virtual memory 
	
	//////////////////////////////////////////////////////////////////////
	// Map 'pages' read-only by the user at linear address UPAGES
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
        n = npage * sizeof(struct Page);
f0100d9c:	a1 70 68 2f f0       	mov    0xf02f6870,%eax
f0100da1:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100da4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
        boot_map_segment(pgdir, UPAGES, n, PADDR(pages), PTE_U | PTE_P);
f0100dab:	83 c4 10             	add    $0x10,%esp
f0100dae:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0100db3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100db8:	77 15                	ja     f0100dcf <i386_vm_init+0x12f>
f0100dba:	50                   	push   %eax
f0100dbb:	68 54 62 10 f0       	push   $0xf0106254
f0100dc0:	68 ee 00 00 00       	push   $0xee
f0100dc5:	68 22 68 10 f0       	push   $0xf0106822
f0100dca:	e8 1a f3 ff ff       	call   f01000e9 <_panic>
f0100dcf:	05 00 00 00 10       	add    $0x10000000,%eax
f0100dd4:	83 ec 0c             	sub    $0xc,%esp
f0100dd7:	6a 05                	push   $0x5
f0100dd9:	50                   	push   %eax
f0100dda:	52                   	push   %edx
f0100ddb:	68 00 00 00 ef       	push   $0xef000000
f0100de0:	53                   	push   %ebx
f0100de1:	e8 66 0c 00 00       	call   f0101a4c <boot_map_segment>

	//////////////////////////////////////////////////////////////////////
	// Map the 'envs' array read-only by the user at linear address UENVS
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
        n = NENV * sizeof(struct Env);
f0100de6:	ba 00 00 02 00       	mov    $0x20000,%edx
        boot_map_segment(pgdir, UENVS, n, PADDR(envs), PTE_U | PTE_P);
f0100deb:	83 c4 20             	add    $0x20,%esp
f0100dee:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f0100df3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100df8:	77 15                	ja     f0100e0f <i386_vm_init+0x16f>
f0100dfa:	50                   	push   %eax
f0100dfb:	68 54 62 10 f0       	push   $0xf0106254
f0100e00:	68 f8 00 00 00       	push   $0xf8
f0100e05:	68 22 68 10 f0       	push   $0xf0106822
f0100e0a:	e8 da f2 ff ff       	call   f01000e9 <_panic>
f0100e0f:	05 00 00 00 10       	add    $0x10000000,%eax
f0100e14:	83 ec 0c             	sub    $0xc,%esp
f0100e17:	6a 05                	push   $0x5
f0100e19:	50                   	push   %eax
f0100e1a:	52                   	push   %edx
f0100e1b:	68 00 00 c0 ee       	push   $0xeec00000
f0100e20:	53                   	push   %ebx
f0100e21:	e8 26 0c 00 00       	call   f0101a4c <boot_map_segment>

	//////////////////////////////////////////////////////////////////////
        // Use the physical memory that bootstack refers to as
        // the kernel stack.  The complete VA
	// range of the stack, [KSTACKTOP-PTSIZE, KSTACKTOP), breaks into two
	// pieces:
	//     * [KSTACKTOP-KSTKSIZE, KSTACKTOP) -- backed by physical memory
	//     * [KSTACKTOP-PTSIZE, KSTACKTOP-KSTKSIZE) -- not backed => faults
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
        boot_map_segment(pgdir, KSTACKTOP - KSTKSIZE, KSTKSIZE, PADDR(bootstack), PTE_W | PTE_P);
f0100e26:	83 c4 20             	add    $0x20,%esp
f0100e29:	b8 00 d0 11 f0       	mov    $0xf011d000,%eax
f0100e2e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e33:	77 15                	ja     f0100e4a <i386_vm_init+0x1aa>
f0100e35:	50                   	push   %eax
f0100e36:	68 54 62 10 f0       	push   $0xf0106254
f0100e3b:	68 03 01 00 00       	push   $0x103
f0100e40:	68 22 68 10 f0       	push   $0xf0106822
f0100e45:	e8 9f f2 ff ff       	call   f01000e9 <_panic>
f0100e4a:	05 00 00 00 10       	add    $0x10000000,%eax
f0100e4f:	83 ec 0c             	sub    $0xc,%esp
f0100e52:	6a 03                	push   $0x3
f0100e54:	50                   	push   %eax
f0100e55:	68 00 80 00 00       	push   $0x8000
f0100e5a:	68 00 80 bf ef       	push   $0xefbf8000
f0100e5f:	53                   	push   %ebx
f0100e60:	e8 e7 0b 00 00       	call   f0101a4c <boot_map_segment>
        boot_map_segment(pgdir, KSTACKTOP - PTSIZE, PTSIZE - KSTKSIZE, 0, 0);
f0100e65:	83 c4 14             	add    $0x14,%esp
f0100e68:	6a 00                	push   $0x0
f0100e6a:	6a 00                	push   $0x0
f0100e6c:	68 00 80 3f 00       	push   $0x3f8000
f0100e71:	68 00 00 80 ef       	push   $0xef800000
f0100e76:	53                   	push   %ebx
f0100e77:	e8 d0 0b 00 00       	call   f0101a4c <boot_map_segment>

	//////////////////////////////////////////////////////////////////////
	// Map all of physical memory at KERNBASE. 
	// Ie.  the VA range [KERNBASE, 2^32) should map to
	//      the PA range [0, 2^32 - KERNBASE)
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here: 
        boot_map_segment(pgdir, KERNBASE, ~KERNBASE + 1, 0, PTE_W | PTE_P);
f0100e7c:	83 c4 14             	add    $0x14,%esp
f0100e7f:	6a 03                	push   $0x3
f0100e81:	6a 00                	push   $0x0
f0100e83:	68 00 00 00 10       	push   $0x10000000
f0100e88:	68 00 00 00 f0       	push   $0xf0000000
f0100e8d:	53                   	push   %ebx
f0100e8e:	e8 b9 0b 00 00       	call   f0101a4c <boot_map_segment>

	// Check that the initial page directory has been set up correctly.
	check_boot_pgdir();
f0100e93:	83 c4 20             	add    $0x20,%esp
f0100e96:	e8 9f 04 00 00       	call   f010133a <check_boot_pgdir>

	//////////////////////////////////////////////////////////////////////
	// On x86, segmentation maps a VA to a LA (linear addr) and
	// paging maps the LA to a PA.  I.e. VA => LA => PA.  If paging is
	// turned off the LA is used as the PA.  Note: there is no way to
	// turn off segmentation.  The closest thing is to set the base
	// address to 0, so the VA => LA mapping is the identity.

	// Current mapping: VA KERNBASE+x => PA x.
	//     (segmentation base=-KERNBASE and paging is off)

	// From here on down we must maintain this VA KERNBASE + x => PA x
	// mapping, even though we are turning on paging and reconfiguring
	// segmentation.

	// Map VA 0:4MB same as VA KERNBASE, i.e. to PA 0:4MB.
	// (Limits our kernel to <4MB)
	pgdir[0] = pgdir[PDX(KERNBASE)];
f0100e9b:	8b 83 00 0f 00 00    	mov    0xf00(%ebx),%eax
f0100ea1:	89 03                	mov    %eax,(%ebx)
}

static __inline void
lcr3(uint32_t val)
{
f0100ea3:	a1 74 68 2f f0       	mov    0xf02f6874,%eax
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0100ea8:	0f 22 d8             	mov    %eax,%cr3
f0100eab:	0f 20 c0             	mov    %cr0,%eax

	// Install page table.
	lcr3(boot_cr3);

	// Turn on paging.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_TS|CR0_EM|CR0_MP;
f0100eae:	0d 2f 00 05 80       	or     $0x8005002f,%eax
}

static __inline void
lcr0(uint32_t val)
{
f0100eb3:	83 e0 f3             	and    $0xfffffff3,%eax
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f0100eb6:	0f 22 c0             	mov    %eax,%cr0
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Current mapping: KERNBASE+x => x => x.
	// (x < 4MB so uses paging pgdir[0])

	// Reload all segment registers.
	asm volatile("lgdt gdt_pd");
f0100eb9:	0f 01 15 d0 55 12 f0 	lgdtl  0xf01255d0
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f0100ec0:	b8 23 00 00 00       	mov    $0x23,%eax
f0100ec5:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0100ec7:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0100ec9:	b0 10                	mov    $0x10,%al
f0100ecb:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f0100ecd:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f0100ecf:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));  // reload cs
f0100ed1:	ea d8 0e 10 f0 08 00 	ljmp   $0x8,$0xf0100ed8
	asm volatile("lldt %%ax" :: "a" (0));
f0100ed8:	b0 00                	mov    $0x0,%al
f0100eda:	0f 00 d0             	lldt   %ax

	// Final mapping: KERNBASE+x => KERNBASE+x => x.

	// This mapping was only used after paging was turned on but
	// before the segment registers were reloaded.
	pgdir[0] = 0;
f0100edd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}

static __inline void
lcr3(uint32_t val)
{
f0100ee3:	a1 74 68 2f f0       	mov    0xf02f6874,%eax
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0100ee8:	0f 22 d8             	mov    %eax,%cr3

	// Flush the TLB for good measure, to kill the pgdir[0] mapping.
	lcr3(boot_cr3);
}
f0100eeb:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100eee:	c9                   	leave  
f0100eef:	c3                   	ret    

f0100ef0 <check_page_alloc>:

//
// Check the physical page allocator (page_alloc(), page_free(),
// and page_init()).
//
static void
check_page_alloc()
{
f0100ef0:	55                   	push   %ebp
f0100ef1:	89 e5                	mov    %esp,%ebp
f0100ef3:	53                   	push   %ebx
f0100ef4:	83 ec 14             	sub    $0x14,%esp
	struct Page *pp, *pp0, *pp1, *pp2;
	struct Page_list fl;
	
        // if there's a page that shouldn't be on
        // the free list, try to make sure it
        // eventually causes trouble.
	LIST_FOREACH(pp0, &page_free_list, pp_link)
f0100ef7:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f0100efc:	89 45 f8             	mov    %eax,0xfffffff8(%ebp)
f0100eff:	85 c0                	test   %eax,%eax
f0100f01:	74 72                	je     f0100f75 <check_page_alloc+0x85>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0100f03:	8b 55 f8             	mov    0xfffffff8(%ebp),%edx
f0100f06:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0100f0c:	c1 fa 02             	sar    $0x2,%edx
f0100f0f:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0100f12:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0100f15:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0100f18:	89 c1                	mov    %eax,%ecx
f0100f1a:	c1 e1 08             	shl    $0x8,%ecx
f0100f1d:	01 c8                	add    %ecx,%eax
f0100f1f:	89 c1                	mov    %eax,%ecx
f0100f21:	c1 e1 10             	shl    $0x10,%ecx
f0100f24:	01 c8                	add    %ecx,%eax
f0100f26:	8d 04 42             	lea    (%edx,%eax,2),%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0100f29:	89 c2                	mov    %eax,%edx
f0100f2b:	c1 e2 0c             	shl    $0xc,%edx
	return page2ppn(pp) << PGSHIFT;
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
		panic("pa2page called with invalid pa");
	return &pages[PPN(pa)];
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0100f2e:	89 d0                	mov    %edx,%eax
f0100f30:	c1 e8 0c             	shr    $0xc,%eax
f0100f33:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0100f39:	72 12                	jb     f0100f4d <check_page_alloc+0x5d>
f0100f3b:	52                   	push   %edx
f0100f3c:	68 ac 62 10 f0       	push   $0xf01062ac
f0100f41:	6a 5b                	push   $0x5b
f0100f43:	68 76 5f 10 f0       	push   $0xf0105f76
f0100f48:	e8 9c f1 ff ff       	call   f01000e9 <_panic>
f0100f4d:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f0100f53:	83 ec 04             	sub    $0x4,%esp
f0100f56:	68 80 00 00 00       	push   $0x80
f0100f5b:	68 97 00 00 00       	push   $0x97
f0100f60:	50                   	push   %eax
f0100f61:	e8 2b 3d 00 00       	call   f0104c91 <memset>
f0100f66:	83 c4 10             	add    $0x10,%esp
f0100f69:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
f0100f6c:	8b 00                	mov    (%eax),%eax
f0100f6e:	89 45 f8             	mov    %eax,0xfffffff8(%ebp)
f0100f71:	85 c0                	test   %eax,%eax
f0100f73:	75 8e                	jne    f0100f03 <check_page_alloc+0x13>
		memset(page2kva(pp0), 0x97, 128);

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0100f75:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
f0100f7c:	c7 45 f4 00 00 00 00 	movl   $0x0,0xfffffff4(%ebp)
f0100f83:	c7 45 f8 00 00 00 00 	movl   $0x0,0xfffffff8(%ebp)
	assert(page_alloc(&pp0) == 0);
f0100f8a:	83 ec 0c             	sub    $0xc,%esp
f0100f8d:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
f0100f90:	50                   	push   %eax
f0100f91:	e8 10 08 00 00       	call   f01017a6 <page_alloc>
f0100f96:	83 c4 10             	add    $0x10,%esp
f0100f99:	85 c0                	test   %eax,%eax
f0100f9b:	74 19                	je     f0100fb6 <check_page_alloc+0xc6>
f0100f9d:	68 2e 68 10 f0       	push   $0xf010682e
f0100fa2:	68 44 68 10 f0       	push   $0xf0106844
f0100fa7:	68 57 01 00 00       	push   $0x157
f0100fac:	68 22 68 10 f0       	push   $0xf0106822
f0100fb1:	e8 33 f1 ff ff       	call   f01000e9 <_panic>
	assert(page_alloc(&pp1) == 0);
f0100fb6:	83 ec 0c             	sub    $0xc,%esp
f0100fb9:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f0100fbc:	50                   	push   %eax
f0100fbd:	e8 e4 07 00 00       	call   f01017a6 <page_alloc>
f0100fc2:	83 c4 10             	add    $0x10,%esp
f0100fc5:	85 c0                	test   %eax,%eax
f0100fc7:	74 19                	je     f0100fe2 <check_page_alloc+0xf2>
f0100fc9:	68 59 68 10 f0       	push   $0xf0106859
f0100fce:	68 44 68 10 f0       	push   $0xf0106844
f0100fd3:	68 58 01 00 00       	push   $0x158
f0100fd8:	68 22 68 10 f0       	push   $0xf0106822
f0100fdd:	e8 07 f1 ff ff       	call   f01000e9 <_panic>
	assert(page_alloc(&pp2) == 0);
f0100fe2:	83 ec 0c             	sub    $0xc,%esp
f0100fe5:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0100fe8:	50                   	push   %eax
f0100fe9:	e8 b8 07 00 00       	call   f01017a6 <page_alloc>
f0100fee:	83 c4 10             	add    $0x10,%esp
f0100ff1:	85 c0                	test   %eax,%eax
f0100ff3:	74 19                	je     f010100e <check_page_alloc+0x11e>
f0100ff5:	68 6f 68 10 f0       	push   $0xf010686f
f0100ffa:	68 44 68 10 f0       	push   $0xf0106844
f0100fff:	68 59 01 00 00       	push   $0x159
f0101004:	68 22 68 10 f0       	push   $0xf0106822
f0101009:	e8 db f0 ff ff       	call   f01000e9 <_panic>

	assert(pp0);
f010100e:	83 7d f8 00          	cmpl   $0x0,0xfffffff8(%ebp)
f0101012:	75 19                	jne    f010102d <check_page_alloc+0x13d>
f0101014:	68 93 68 10 f0       	push   $0xf0106893
f0101019:	68 44 68 10 f0       	push   $0xf0106844
f010101e:	68 5b 01 00 00       	push   $0x15b
f0101023:	68 22 68 10 f0       	push   $0xf0106822
f0101028:	e8 bc f0 ff ff       	call   f01000e9 <_panic>
	assert(pp1 && pp1 != pp0);
f010102d:	83 7d f4 00          	cmpl   $0x0,0xfffffff4(%ebp)
f0101031:	74 08                	je     f010103b <check_page_alloc+0x14b>
f0101033:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f0101036:	3b 45 f8             	cmp    0xfffffff8(%ebp),%eax
f0101039:	75 19                	jne    f0101054 <check_page_alloc+0x164>
f010103b:	68 85 68 10 f0       	push   $0xf0106885
f0101040:	68 44 68 10 f0       	push   $0xf0106844
f0101045:	68 5c 01 00 00       	push   $0x15c
f010104a:	68 22 68 10 f0       	push   $0xf0106822
f010104f:	e8 95 f0 ff ff       	call   f01000e9 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101054:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0101058:	74 0d                	je     f0101067 <check_page_alloc+0x177>
f010105a:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f010105d:	3b 45 f4             	cmp    0xfffffff4(%ebp),%eax
f0101060:	74 05                	je     f0101067 <check_page_alloc+0x177>
f0101062:	3b 45 f8             	cmp    0xfffffff8(%ebp),%eax
f0101065:	75 19                	jne    f0101080 <check_page_alloc+0x190>
f0101067:	68 d0 62 10 f0       	push   $0xf01062d0
f010106c:	68 44 68 10 f0       	push   $0xf0106844
f0101071:	68 5d 01 00 00       	push   $0x15d
f0101076:	68 22 68 10 f0       	push   $0xf0106822
f010107b:	e8 69 f0 ff ff       	call   f01000e9 <_panic>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101080:	8b 55 f8             	mov    0xfffffff8(%ebp),%edx
f0101083:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0101089:	c1 fa 02             	sar    $0x2,%edx
f010108c:	8d 04 92             	lea    (%edx,%edx,4),%eax
f010108f:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101092:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101095:	89 c1                	mov    %eax,%ecx
f0101097:	c1 e1 08             	shl    $0x8,%ecx
f010109a:	01 c8                	add    %ecx,%eax
f010109c:	89 c1                	mov    %eax,%ecx
f010109e:	c1 e1 10             	shl    $0x10,%ecx
f01010a1:	01 c8                	add    %ecx,%eax
f01010a3:	8d 04 42             	lea    (%edx,%eax,2),%eax
f01010a6:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01010a9:	8b 15 70 68 2f f0    	mov    0xf02f6870,%edx
f01010af:	c1 e2 0c             	shl    $0xc,%edx
f01010b2:	39 d0                	cmp    %edx,%eax
f01010b4:	72 19                	jb     f01010cf <check_page_alloc+0x1df>
        assert(page2pa(pp0) < npage*PGSIZE);
f01010b6:	68 97 68 10 f0       	push   $0xf0106897
f01010bb:	68 44 68 10 f0       	push   $0xf0106844
f01010c0:	68 5e 01 00 00       	push   $0x15e
f01010c5:	68 22 68 10 f0       	push   $0xf0106822
f01010ca:	e8 1a f0 ff ff       	call   f01000e9 <_panic>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f01010cf:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f01010d2:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f01010d8:	c1 fa 02             	sar    $0x2,%edx
f01010db:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01010de:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01010e1:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01010e4:	89 c1                	mov    %eax,%ecx
f01010e6:	c1 e1 08             	shl    $0x8,%ecx
f01010e9:	01 c8                	add    %ecx,%eax
f01010eb:	89 c1                	mov    %eax,%ecx
f01010ed:	c1 e1 10             	shl    $0x10,%ecx
f01010f0:	01 c8                	add    %ecx,%eax
f01010f2:	8d 04 42             	lea    (%edx,%eax,2),%eax
f01010f5:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01010f8:	8b 15 70 68 2f f0    	mov    0xf02f6870,%edx
f01010fe:	c1 e2 0c             	shl    $0xc,%edx
f0101101:	39 d0                	cmp    %edx,%eax
f0101103:	72 19                	jb     f010111e <check_page_alloc+0x22e>
        assert(page2pa(pp1) < npage*PGSIZE);
f0101105:	68 b3 68 10 f0       	push   $0xf01068b3
f010110a:	68 44 68 10 f0       	push   $0xf0106844
f010110f:	68 5f 01 00 00       	push   $0x15f
f0101114:	68 22 68 10 f0       	push   $0xf0106822
f0101119:	e8 cb ef ff ff       	call   f01000e9 <_panic>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f010111e:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
f0101121:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0101127:	c1 fa 02             	sar    $0x2,%edx
f010112a:	8d 04 92             	lea    (%edx,%edx,4),%eax
f010112d:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101130:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101133:	89 c1                	mov    %eax,%ecx
f0101135:	c1 e1 08             	shl    $0x8,%ecx
f0101138:	01 c8                	add    %ecx,%eax
f010113a:	89 c1                	mov    %eax,%ecx
f010113c:	c1 e1 10             	shl    $0x10,%ecx
f010113f:	01 c8                	add    %ecx,%eax
f0101141:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0101144:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101147:	8b 15 70 68 2f f0    	mov    0xf02f6870,%edx
f010114d:	c1 e2 0c             	shl    $0xc,%edx
f0101150:	39 d0                	cmp    %edx,%eax
f0101152:	72 19                	jb     f010116d <check_page_alloc+0x27d>
        assert(page2pa(pp2) < npage*PGSIZE);
f0101154:	68 cf 68 10 f0       	push   $0xf01068cf
f0101159:	68 44 68 10 f0       	push   $0xf0106844
f010115e:	68 60 01 00 00       	push   $0x160
f0101163:	68 22 68 10 f0       	push   $0xf0106822
f0101168:	e8 7c ef ff ff       	call   f01000e9 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f010116d:	8b 1d b8 5b 2f f0    	mov    0xf02f5bb8,%ebx
	LIST_INIT(&page_free_list);
f0101173:	c7 05 b8 5b 2f f0 00 	movl   $0x0,0xf02f5bb8
f010117a:	00 00 00 

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f010117d:	83 ec 0c             	sub    $0xc,%esp
f0101180:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0101183:	50                   	push   %eax
f0101184:	e8 1d 06 00 00       	call   f01017a6 <page_alloc>
f0101189:	83 c4 10             	add    $0x10,%esp
f010118c:	83 f8 fc             	cmp    $0xfffffffc,%eax
f010118f:	74 19                	je     f01011aa <check_page_alloc+0x2ba>
f0101191:	68 eb 68 10 f0       	push   $0xf01068eb
f0101196:	68 44 68 10 f0       	push   $0xf0106844
f010119b:	68 67 01 00 00       	push   $0x167
f01011a0:	68 22 68 10 f0       	push   $0xf0106822
f01011a5:	e8 3f ef ff ff       	call   f01000e9 <_panic>

        // free and re-allocate?
        page_free(pp0);
f01011aa:	83 ec 0c             	sub    $0xc,%esp
f01011ad:	ff 75 f8             	pushl  0xfffffff8(%ebp)
f01011b0:	e8 36 06 00 00       	call   f01017eb <page_free>
        page_free(pp1);
f01011b5:	83 c4 04             	add    $0x4,%esp
f01011b8:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f01011bb:	e8 2b 06 00 00       	call   f01017eb <page_free>
        page_free(pp2);
f01011c0:	83 c4 04             	add    $0x4,%esp
f01011c3:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f01011c6:	e8 20 06 00 00       	call   f01017eb <page_free>
	pp0 = pp1 = pp2 = 0;
f01011cb:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
f01011d2:	c7 45 f4 00 00 00 00 	movl   $0x0,0xfffffff4(%ebp)
f01011d9:	c7 45 f8 00 00 00 00 	movl   $0x0,0xfffffff8(%ebp)
	assert(page_alloc(&pp0) == 0);
f01011e0:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
f01011e3:	89 04 24             	mov    %eax,(%esp)
f01011e6:	e8 bb 05 00 00       	call   f01017a6 <page_alloc>
f01011eb:	83 c4 10             	add    $0x10,%esp
f01011ee:	85 c0                	test   %eax,%eax
f01011f0:	74 19                	je     f010120b <check_page_alloc+0x31b>
f01011f2:	68 2e 68 10 f0       	push   $0xf010682e
f01011f7:	68 44 68 10 f0       	push   $0xf0106844
f01011fc:	68 6e 01 00 00       	push   $0x16e
f0101201:	68 22 68 10 f0       	push   $0xf0106822
f0101206:	e8 de ee ff ff       	call   f01000e9 <_panic>
	assert(page_alloc(&pp1) == 0);
f010120b:	83 ec 0c             	sub    $0xc,%esp
f010120e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f0101211:	50                   	push   %eax
f0101212:	e8 8f 05 00 00       	call   f01017a6 <page_alloc>
f0101217:	83 c4 10             	add    $0x10,%esp
f010121a:	85 c0                	test   %eax,%eax
f010121c:	74 19                	je     f0101237 <check_page_alloc+0x347>
f010121e:	68 59 68 10 f0       	push   $0xf0106859
f0101223:	68 44 68 10 f0       	push   $0xf0106844
f0101228:	68 6f 01 00 00       	push   $0x16f
f010122d:	68 22 68 10 f0       	push   $0xf0106822
f0101232:	e8 b2 ee ff ff       	call   f01000e9 <_panic>
	assert(page_alloc(&pp2) == 0);
f0101237:	83 ec 0c             	sub    $0xc,%esp
f010123a:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f010123d:	50                   	push   %eax
f010123e:	e8 63 05 00 00       	call   f01017a6 <page_alloc>
f0101243:	83 c4 10             	add    $0x10,%esp
f0101246:	85 c0                	test   %eax,%eax
f0101248:	74 19                	je     f0101263 <check_page_alloc+0x373>
f010124a:	68 6f 68 10 f0       	push   $0xf010686f
f010124f:	68 44 68 10 f0       	push   $0xf0106844
f0101254:	68 70 01 00 00       	push   $0x170
f0101259:	68 22 68 10 f0       	push   $0xf0106822
f010125e:	e8 86 ee ff ff       	call   f01000e9 <_panic>
	assert(pp0);
f0101263:	83 7d f8 00          	cmpl   $0x0,0xfffffff8(%ebp)
f0101267:	75 19                	jne    f0101282 <check_page_alloc+0x392>
f0101269:	68 93 68 10 f0       	push   $0xf0106893
f010126e:	68 44 68 10 f0       	push   $0xf0106844
f0101273:	68 71 01 00 00       	push   $0x171
f0101278:	68 22 68 10 f0       	push   $0xf0106822
f010127d:	e8 67 ee ff ff       	call   f01000e9 <_panic>
	assert(pp1 && pp1 != pp0);
f0101282:	83 7d f4 00          	cmpl   $0x0,0xfffffff4(%ebp)
f0101286:	74 08                	je     f0101290 <check_page_alloc+0x3a0>
f0101288:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f010128b:	3b 45 f8             	cmp    0xfffffff8(%ebp),%eax
f010128e:	75 19                	jne    f01012a9 <check_page_alloc+0x3b9>
f0101290:	68 85 68 10 f0       	push   $0xf0106885
f0101295:	68 44 68 10 f0       	push   $0xf0106844
f010129a:	68 72 01 00 00       	push   $0x172
f010129f:	68 22 68 10 f0       	push   $0xf0106822
f01012a4:	e8 40 ee ff ff       	call   f01000e9 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01012a9:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f01012ad:	74 0d                	je     f01012bc <check_page_alloc+0x3cc>
f01012af:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f01012b2:	3b 45 f4             	cmp    0xfffffff4(%ebp),%eax
f01012b5:	74 05                	je     f01012bc <check_page_alloc+0x3cc>
f01012b7:	3b 45 f8             	cmp    0xfffffff8(%ebp),%eax
f01012ba:	75 19                	jne    f01012d5 <check_page_alloc+0x3e5>
f01012bc:	68 d0 62 10 f0       	push   $0xf01062d0
f01012c1:	68 44 68 10 f0       	push   $0xf0106844
f01012c6:	68 73 01 00 00       	push   $0x173
f01012cb:	68 22 68 10 f0       	push   $0xf0106822
f01012d0:	e8 14 ee ff ff       	call   f01000e9 <_panic>
	assert(page_alloc(&pp) == -E_NO_MEM);
f01012d5:	83 ec 0c             	sub    $0xc,%esp
f01012d8:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f01012db:	50                   	push   %eax
f01012dc:	e8 c5 04 00 00       	call   f01017a6 <page_alloc>
f01012e1:	83 c4 10             	add    $0x10,%esp
f01012e4:	83 f8 fc             	cmp    $0xfffffffc,%eax
f01012e7:	74 19                	je     f0101302 <check_page_alloc+0x412>
f01012e9:	68 eb 68 10 f0       	push   $0xf01068eb
f01012ee:	68 44 68 10 f0       	push   $0xf0106844
f01012f3:	68 74 01 00 00       	push   $0x174
f01012f8:	68 22 68 10 f0       	push   $0xf0106822
f01012fd:	e8 e7 ed ff ff       	call   f01000e9 <_panic>

	// give free list back
	page_free_list = fl;
f0101302:	89 1d b8 5b 2f f0    	mov    %ebx,0xf02f5bb8

	// free the pages we took
	page_free(pp0);
f0101308:	83 ec 0c             	sub    $0xc,%esp
f010130b:	ff 75 f8             	pushl  0xfffffff8(%ebp)
f010130e:	e8 d8 04 00 00       	call   f01017eb <page_free>
	page_free(pp1);
f0101313:	83 c4 04             	add    $0x4,%esp
f0101316:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f0101319:	e8 cd 04 00 00       	call   f01017eb <page_free>
	page_free(pp2);
f010131e:	83 c4 04             	add    $0x4,%esp
f0101321:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0101324:	e8 c2 04 00 00       	call   f01017eb <page_free>

	cprintf("check_page_alloc() succeeded!\n");
f0101329:	c7 04 24 f0 62 10 f0 	movl   $0xf01062f0,(%esp)
f0101330:	e8 8d 1d 00 00       	call   f01030c2 <cprintf>
}
f0101335:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0101338:	c9                   	leave  
f0101339:	c3                   	ret    

f010133a <check_boot_pgdir>:

//
// Checks that the kernel part of virtual address space
// has been setup roughly correctly(by i386_vm_init()).
//
// This function doesn't test every corner case,
// in fact it doesn't test the permission bits at all,
// but it is a pretty good sanity check. 
//
static physaddr_t check_va2pa(pde_t *pgdir, uintptr_t va);

static void
check_boot_pgdir(void)
{
f010133a:	55                   	push   %ebp
f010133b:	89 e5                	mov    %esp,%ebp
f010133d:	57                   	push   %edi
f010133e:	56                   	push   %esi
f010133f:	53                   	push   %ebx
f0101340:	83 ec 0c             	sub    $0xc,%esp
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = boot_pgdir;
f0101343:	8b 35 78 68 2f f0    	mov    0xf02f6878,%esi

	// check pages array
	n = ROUNDUP(npage*sizeof(struct Page), PGSIZE);
f0101349:	a1 70 68 2f f0       	mov    0xf02f6870,%eax
f010134e:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0101351:	8d 04 85 ff 0f 00 00 	lea    0xfff(,%eax,4),%eax
f0101358:	89 c7                	mov    %eax,%edi
f010135a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	for (i = 0; i < n; i += PGSIZE)
f0101360:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101365:	39 fb                	cmp    %edi,%ebx
f0101367:	73 64                	jae    f01013cd <check_boot_pgdir+0x93>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0101369:	83 ec 08             	sub    $0x8,%esp
f010136c:	8d 83 00 00 00 ef    	lea    0xef000000(%ebx),%eax
f0101372:	50                   	push   %eax
f0101373:	56                   	push   %esi
f0101374:	e8 1b 02 00 00       	call   f0101594 <check_va2pa>
f0101379:	89 c2                	mov    %eax,%edx
f010137b:	83 c4 10             	add    $0x10,%esp
f010137e:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0101383:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101388:	77 15                	ja     f010139f <check_boot_pgdir+0x65>
f010138a:	50                   	push   %eax
f010138b:	68 54 62 10 f0       	push   $0xf0106254
f0101390:	68 96 01 00 00       	push   $0x196
f0101395:	68 22 68 10 f0       	push   $0xf0106822
f010139a:	e8 4a ed ff ff       	call   f01000e9 <_panic>
f010139f:	8d 84 18 00 00 00 10 	lea    0x10000000(%eax,%ebx,1),%eax
f01013a6:	39 c2                	cmp    %eax,%edx
f01013a8:	74 19                	je     f01013c3 <check_boot_pgdir+0x89>
f01013aa:	68 10 63 10 f0       	push   $0xf0106310
f01013af:	68 44 68 10 f0       	push   $0xf0106844
f01013b4:	68 96 01 00 00       	push   $0x196
f01013b9:	68 22 68 10 f0       	push   $0xf0106822
f01013be:	e8 26 ed ff ff       	call   f01000e9 <_panic>
f01013c3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01013c9:	39 fb                	cmp    %edi,%ebx
f01013cb:	72 9c                	jb     f0101369 <check_boot_pgdir+0x2f>
	
	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
f01013cd:	bf 00 00 02 00       	mov    $0x20000,%edi
	for (i = 0; i < n; i += PGSIZE)
f01013d2:	bb 00 00 00 00       	mov    $0x0,%ebx
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01013d7:	83 ec 08             	sub    $0x8,%esp
f01013da:	8d 83 00 00 c0 ee    	lea    0xeec00000(%ebx),%eax
f01013e0:	50                   	push   %eax
f01013e1:	56                   	push   %esi
f01013e2:	e8 ad 01 00 00       	call   f0101594 <check_va2pa>
f01013e7:	89 c2                	mov    %eax,%edx
f01013e9:	83 c4 10             	add    $0x10,%esp
f01013ec:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f01013f1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01013f6:	77 15                	ja     f010140d <check_boot_pgdir+0xd3>
f01013f8:	50                   	push   %eax
f01013f9:	68 54 62 10 f0       	push   $0xf0106254
f01013fe:	68 9b 01 00 00       	push   $0x19b
f0101403:	68 22 68 10 f0       	push   $0xf0106822
f0101408:	e8 dc ec ff ff       	call   f01000e9 <_panic>
f010140d:	8d 84 18 00 00 00 10 	lea    0x10000000(%eax,%ebx,1),%eax
f0101414:	39 c2                	cmp    %eax,%edx
f0101416:	74 19                	je     f0101431 <check_boot_pgdir+0xf7>
f0101418:	68 44 63 10 f0       	push   $0xf0106344
f010141d:	68 44 68 10 f0       	push   $0xf0106844
f0101422:	68 9b 01 00 00       	push   $0x19b
f0101427:	68 22 68 10 f0       	push   $0xf0106822
f010142c:	e8 b8 ec ff ff       	call   f01000e9 <_panic>
f0101431:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101437:	39 fb                	cmp    %edi,%ebx
f0101439:	72 9c                	jb     f01013d7 <check_boot_pgdir+0x9d>

	// check phys mem
	for (i = 0; i < npage * PGSIZE; i += PGSIZE)
f010143b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101440:	a1 70 68 2f f0       	mov    0xf02f6870,%eax
f0101445:	c1 e0 0c             	shl    $0xc,%eax
f0101448:	83 f8 00             	cmp    $0x0,%eax
f010144b:	76 42                	jbe    f010148f <check_boot_pgdir+0x155>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f010144d:	83 ec 08             	sub    $0x8,%esp
f0101450:	8d 83 00 00 00 f0    	lea    0xf0000000(%ebx),%eax
f0101456:	50                   	push   %eax
f0101457:	56                   	push   %esi
f0101458:	e8 37 01 00 00       	call   f0101594 <check_va2pa>
f010145d:	83 c4 10             	add    $0x10,%esp
f0101460:	39 d8                	cmp    %ebx,%eax
f0101462:	74 19                	je     f010147d <check_boot_pgdir+0x143>
f0101464:	68 78 63 10 f0       	push   $0xf0106378
f0101469:	68 44 68 10 f0       	push   $0xf0106844
f010146e:	68 9f 01 00 00       	push   $0x19f
f0101473:	68 22 68 10 f0       	push   $0xf0106822
f0101478:	e8 6c ec ff ff       	call   f01000e9 <_panic>
f010147d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101483:	a1 70 68 2f f0       	mov    0xf02f6870,%eax
f0101488:	c1 e0 0c             	shl    $0xc,%eax
f010148b:	39 d8                	cmp    %ebx,%eax
f010148d:	77 be                	ja     f010144d <check_boot_pgdir+0x113>

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f010148f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101494:	bf 00 d0 11 f0       	mov    $0xf011d000,%edi
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f0101499:	83 ec 08             	sub    $0x8,%esp
f010149c:	8d 83 00 80 bf ef    	lea    0xefbf8000(%ebx),%eax
f01014a2:	50                   	push   %eax
f01014a3:	56                   	push   %esi
f01014a4:	e8 eb 00 00 00       	call   f0101594 <check_va2pa>
f01014a9:	89 c2                	mov    %eax,%edx
f01014ab:	83 c4 10             	add    $0x10,%esp
f01014ae:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f01014b4:	77 19                	ja     f01014cf <check_boot_pgdir+0x195>
f01014b6:	68 00 d0 11 f0       	push   $0xf011d000
f01014bb:	68 54 62 10 f0       	push   $0xf0106254
f01014c0:	68 a3 01 00 00       	push   $0x1a3
f01014c5:	68 22 68 10 f0       	push   $0xf0106822
f01014ca:	e8 1a ec ff ff       	call   f01000e9 <_panic>
f01014cf:	8d 84 1f 00 00 00 10 	lea    0x10000000(%edi,%ebx,1),%eax
f01014d6:	39 c2                	cmp    %eax,%edx
f01014d8:	74 19                	je     f01014f3 <check_boot_pgdir+0x1b9>
f01014da:	68 a0 63 10 f0       	push   $0xf01063a0
f01014df:	68 44 68 10 f0       	push   $0xf0106844
f01014e4:	68 a3 01 00 00       	push   $0x1a3
f01014e9:	68 22 68 10 f0       	push   $0xf0106822
f01014ee:	e8 f6 eb ff ff       	call   f01000e9 <_panic>
f01014f3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01014f9:	81 fb ff 7f 00 00    	cmp    $0x7fff,%ebx
f01014ff:	76 98                	jbe    f0101499 <check_boot_pgdir+0x15f>

	// check for zero/non-zero in PDEs
	for (i = 0; i < NPDENTRIES; i++) {
f0101501:	bb 00 00 00 00       	mov    $0x0,%ebx
		switch (i) {
f0101506:	8d 83 45 fc ff ff    	lea    0xfffffc45(%ebx),%eax
f010150c:	83 f8 04             	cmp    $0x4,%eax
f010150f:	77 1f                	ja     f0101530 <check_boot_pgdir+0x1f6>
		case PDX(VPT):
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
			assert(pgdir[i]);
f0101511:	83 3c 9e 00          	cmpl   $0x0,(%esi,%ebx,4)
f0101515:	75 5f                	jne    f0101576 <check_boot_pgdir+0x23c>
f0101517:	68 08 69 10 f0       	push   $0xf0106908
f010151c:	68 44 68 10 f0       	push   $0xf0106844
f0101521:	68 ad 01 00 00       	push   $0x1ad
f0101526:	68 22 68 10 f0       	push   $0xf0106822
f010152b:	e8 b9 eb ff ff       	call   f01000e9 <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE))
f0101530:	81 fb bf 03 00 00    	cmp    $0x3bf,%ebx
f0101536:	76 1f                	jbe    f0101557 <check_boot_pgdir+0x21d>
				assert(pgdir[i]);
f0101538:	83 3c 9e 00          	cmpl   $0x0,(%esi,%ebx,4)
f010153c:	75 38                	jne    f0101576 <check_boot_pgdir+0x23c>
f010153e:	68 08 69 10 f0       	push   $0xf0106908
f0101543:	68 44 68 10 f0       	push   $0xf0106844
f0101548:	68 b1 01 00 00       	push   $0x1b1
f010154d:	68 22 68 10 f0       	push   $0xf0106822
f0101552:	e8 92 eb ff ff       	call   f01000e9 <_panic>
			else
				assert(pgdir[i] == 0);
f0101557:	83 3c 9e 00          	cmpl   $0x0,(%esi,%ebx,4)
f010155b:	74 19                	je     f0101576 <check_boot_pgdir+0x23c>
f010155d:	68 11 69 10 f0       	push   $0xf0106911
f0101562:	68 44 68 10 f0       	push   $0xf0106844
f0101567:	68 b3 01 00 00       	push   $0x1b3
f010156c:	68 22 68 10 f0       	push   $0xf0106822
f0101571:	e8 73 eb ff ff       	call   f01000e9 <_panic>
f0101576:	43                   	inc    %ebx
f0101577:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
f010157d:	76 87                	jbe    f0101506 <check_boot_pgdir+0x1cc>
			break;
		}
	}
	cprintf("check_boot_pgdir() succeeded!\n");
f010157f:	83 ec 0c             	sub    $0xc,%esp
f0101582:	68 e8 63 10 f0       	push   $0xf01063e8
f0101587:	e8 36 1b 00 00       	call   f01030c2 <cprintf>
}
f010158c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f010158f:	5b                   	pop    %ebx
f0101590:	5e                   	pop    %esi
f0101591:	5f                   	pop    %edi
f0101592:	c9                   	leave  
f0101593:	c3                   	ret    

f0101594 <check_va2pa>:

// This function returns the physical address of the page containing 'va',
// defined by the page directory 'pgdir'.  The hardware normally performs
// this functionality for us!  We define our own version to help check
// the check_boot_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0101594:	55                   	push   %ebp
f0101595:	89 e5                	mov    %esp,%ebp
f0101597:	53                   	push   %ebx
f0101598:	83 ec 04             	sub    $0x4,%esp
f010159b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f010159e:	89 d8                	mov    %ebx,%eax
f01015a0:	c1 e8 16             	shr    $0x16,%eax
f01015a3:	c1 e0 02             	shl    $0x2,%eax
f01015a6:	03 45 08             	add    0x8(%ebp),%eax
	if (!(*pgdir & PTE_P))
		return ~0;
f01015a9:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01015ae:	f6 00 01             	testb  $0x1,(%eax)
f01015b1:	74 58                	je     f010160b <check_va2pa+0x77>
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f01015b3:	8b 10                	mov    (%eax),%edx
f01015b5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01015bb:	89 d0                	mov    %edx,%eax
f01015bd:	c1 e8 0c             	shr    $0xc,%eax
f01015c0:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f01015c6:	72 15                	jb     f01015dd <check_va2pa+0x49>
f01015c8:	52                   	push   %edx
f01015c9:	68 ac 62 10 f0       	push   $0xf01062ac
f01015ce:	68 c7 01 00 00       	push   $0x1c7
f01015d3:	68 22 68 10 f0       	push   $0xf0106822
f01015d8:	e8 0c eb ff ff       	call   f01000e9 <_panic>
f01015dd:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	if (!(p[PTX(va)] & PTE_P))
f01015e3:	89 d8                	mov    %ebx,%eax
f01015e5:	c1 e8 0c             	shr    $0xc,%eax
f01015e8:	25 ff 03 00 00       	and    $0x3ff,%eax
		return ~0;
f01015ed:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01015f2:	f6 04 82 01          	testb  $0x1,(%edx,%eax,4)
f01015f6:	74 13                	je     f010160b <check_va2pa+0x77>
	return PTE_ADDR(p[PTX(va)]);
f01015f8:	89 d8                	mov    %ebx,%eax
f01015fa:	c1 e8 0c             	shr    $0xc,%eax
f01015fd:	25 ff 03 00 00       	and    $0x3ff,%eax
f0101602:	8b 0c 82             	mov    (%edx,%eax,4),%ecx
f0101605:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
}
f010160b:	89 c8                	mov    %ecx,%eax
f010160d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0101610:	c9                   	leave  
f0101611:	c3                   	ret    

f0101612 <get_page_status>:
		
// --------------------------------------------------------------
// Tracking of physical pages.
// The 'pages' array has one 'struct Page' entry per physical page.
// Pages are reference counted, and free pages are kept on a linked list.
// --------------------------------------------------------------

//
// Checks if a page has been allocated by looping through the
// page_free_list.  If it's not in the list, it has been allocated.
//
int
get_page_status(int paddr)
{
f0101612:	55                   	push   %ebp
f0101613:	89 e5                	mov    %esp,%ebp
  return 0;
}
f0101615:	b8 00 00 00 00       	mov    $0x0,%eax
f010161a:	c9                   	leave  
f010161b:	c3                   	ret    

f010161c <page_init>:

//  
// Initialize page structure and memory free list.
// After this point, ONLY use the functions below
// to allocate and deallocate physical memory via the page_free_list,
// and NEVER use boot_alloc()
//
void
page_init(void)
{
f010161c:	55                   	push   %ebp
f010161d:	89 e5                	mov    %esp,%ebp
f010161f:	53                   	push   %ebx
f0101620:	83 ec 04             	sub    $0x4,%esp
	// The example code here marks all pages as free.
	// However this is not truly the case.  What memory is free?
	//  1) Mark page 0 as in use.
	//     This way we preserve the real-mode IDT and BIOS structures
	//     in case we ever need them.  (Currently we don't, but...)
	//  2) Mark the rest of base memory as free.
	//  3) Then comes the IO hole [IOPHYSMEM, EXTPHYSMEM).
	//     Mark it as in use so that it can never be allocated.      
	//  4) Then extended memory [EXTPHYSMEM, ...).
	//     Some of it is in use, some is free. Where is the kernel?
	//     Which pages are used for page tables and other data structures?
	//
	// Change the code to reflect this.
	int i;
	LIST_INIT(&page_free_list);
f0101623:	c7 05 b8 5b 2f f0 00 	movl   $0x0,0xf02f5bb8
f010162a:	00 00 00 

        // seanyliu
	// 1) Mark page 0 as in use
        // do this by not adding to page_free_list
	pages[0].pp_ref = 0;
f010162d:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0101632:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)

	// 2) Mark the rest of base memory as free
	for (i = 0; i < PPN(IOPHYSMEM); i++) {
f0101638:	bb 00 00 00 00       	mov    $0x0,%ebx
		pages[i].pp_ref = 0;
f010163d:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0101640:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
f0101647:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f010164c:	66 c7 44 01 08 00 00 	movw   $0x0,0x8(%ecx,%eax,1)
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
f0101653:	8b 15 b8 5b 2f f0    	mov    0xf02f5bb8,%edx
f0101659:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f010165e:	89 14 01             	mov    %edx,(%ecx,%eax,1)
f0101661:	85 d2                	test   %edx,%edx
f0101663:	74 10                	je     f0101675 <page_init+0x59>
f0101665:	89 ca                	mov    %ecx,%edx
f0101667:	03 15 7c 68 2f f0    	add    0xf02f687c,%edx
f010166d:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f0101672:	89 50 04             	mov    %edx,0x4(%eax)
f0101675:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0101678:	c1 e0 02             	shl    $0x2,%eax
f010167b:	8b 0d 7c 68 2f f0    	mov    0xf02f687c,%ecx
f0101681:	8d 14 08             	lea    (%eax,%ecx,1),%edx
f0101684:	89 15 b8 5b 2f f0    	mov    %edx,0xf02f5bb8
f010168a:	c7 44 08 04 b8 5b 2f 	movl   $0xf02f5bb8,0x4(%eax,%ecx,1)
f0101691:	f0 
f0101692:	43                   	inc    %ebx
f0101693:	81 fb 9f 00 00 00    	cmp    $0x9f,%ebx
f0101699:	76 a2                	jbe    f010163d <page_init+0x21>
	}

	// 3) Then comes the IO hole
	for (i = PPN(IOPHYSMEM); i < PPN(EXTPHYSMEM); i++) {
f010169b:	bb a0 00 00 00       	mov    $0xa0,%ebx
        	pages[i].pp_ref = 0;
f01016a0:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
f01016a3:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f01016a8:	66 c7 44 90 08 00 00 	movw   $0x0,0x8(%eax,%edx,4)
f01016af:	43                   	inc    %ebx
f01016b0:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f01016b6:	76 e8                	jbe    f01016a0 <page_init+0x84>
                // DO NOT LIST_INSERT_HEAD
        }

	// 4) Then extended memory
	//cprintf("boot_freemem: %x\n", boot_freemem);
	//cprintf("EXTPHYSMEM: %x\n", EXTPHYSMEM);
	//cprintf("npage (dec): %d\n", npage);
	//cprintf("boot_freemem - KERNBASE: %x\n", boot_freemem - KERNBASE);
	//cprintf("KERNBASE: %x\n", KERNBASE);
	//cprintf("maxpa: %x\n", maxpa);
	for (i = PPN(EXTPHYSMEM); i < PPN(PADDR(boot_freemem)); i++) {
f01016b8:	bb 00 01 00 00       	mov    $0x100,%ebx
f01016bd:	eb 10                	jmp    f01016cf <page_init+0xb3>
        	pages[i].pp_ref = 0;
f01016bf:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
f01016c2:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f01016c7:	66 c7 44 90 08 00 00 	movw   $0x0,0x8(%eax,%edx,4)
f01016ce:	43                   	inc    %ebx
f01016cf:	a1 b4 5b 2f f0       	mov    0xf02f5bb4,%eax
f01016d4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01016d9:	77 15                	ja     f01016f0 <page_init+0xd4>
f01016db:	50                   	push   %eax
f01016dc:	68 54 62 10 f0       	push   $0xf0106254
f01016e1:	68 0e 02 00 00       	push   $0x20e
f01016e6:	68 22 68 10 f0       	push   $0xf0106822
f01016eb:	e8 f9 e9 ff ff       	call   f01000e9 <_panic>
f01016f0:	05 00 00 00 10       	add    $0x10000000,%eax
f01016f5:	c1 e8 0c             	shr    $0xc,%eax
f01016f8:	39 c3                	cmp    %eax,%ebx
f01016fa:	72 c3                	jb     f01016bf <page_init+0xa3>
                // DO NOT LIST_INSERT_HEAD
        }

        for (i = PPN(PADDR(boot_freemem)); i < npage; i++) {
f01016fc:	a1 b4 5b 2f f0       	mov    0xf02f5bb4,%eax
f0101701:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101706:	77 15                	ja     f010171d <page_init+0x101>
f0101708:	50                   	push   %eax
f0101709:	68 54 62 10 f0       	push   $0xf0106254
f010170e:	68 13 02 00 00       	push   $0x213
f0101713:	68 22 68 10 f0       	push   $0xf0106822
f0101718:	e8 cc e9 ff ff       	call   f01000e9 <_panic>
f010171d:	05 00 00 00 10       	add    $0x10000000,%eax
f0101722:	89 c3                	mov    %eax,%ebx
f0101724:	c1 eb 0c             	shr    $0xc,%ebx
f0101727:	3b 1d 70 68 2f f0    	cmp    0xf02f6870,%ebx
f010172d:	73 5e                	jae    f010178d <page_init+0x171>
		pages[i].pp_ref = 0;
f010172f:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0101732:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
f0101739:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f010173e:	66 c7 44 01 08 00 00 	movw   $0x0,0x8(%ecx,%eax,1)
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
f0101745:	8b 15 b8 5b 2f f0    	mov    0xf02f5bb8,%edx
f010174b:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0101750:	89 14 01             	mov    %edx,(%ecx,%eax,1)
f0101753:	85 d2                	test   %edx,%edx
f0101755:	74 10                	je     f0101767 <page_init+0x14b>
f0101757:	89 ca                	mov    %ecx,%edx
f0101759:	03 15 7c 68 2f f0    	add    0xf02f687c,%edx
f010175f:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f0101764:	89 50 04             	mov    %edx,0x4(%eax)
f0101767:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f010176a:	c1 e0 02             	shl    $0x2,%eax
f010176d:	8b 0d 7c 68 2f f0    	mov    0xf02f687c,%ecx
f0101773:	8d 14 08             	lea    (%eax,%ecx,1),%edx
f0101776:	89 15 b8 5b 2f f0    	mov    %edx,0xf02f5bb8
f010177c:	c7 44 08 04 b8 5b 2f 	movl   $0xf02f5bb8,0x4(%eax,%ecx,1)
f0101783:	f0 
f0101784:	43                   	inc    %ebx
f0101785:	3b 1d 70 68 2f f0    	cmp    0xf02f6870,%ebx
f010178b:	72 a2                	jb     f010172f <page_init+0x113>
        }

	// Staff code below:
	//for (i = 0; i < npage; i++) {
	//	pages[i].pp_ref = 0;
	//	LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
	//}
}
f010178d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0101790:	c9                   	leave  
f0101791:	c3                   	ret    

f0101792 <page_initpp>:

//
// Initialize a Page structure.
// The result has null links and 0 refcount.
// Note that the corresponding physical page is NOT initialized!
//
static void
page_initpp(struct Page *pp)
{
f0101792:	55                   	push   %ebp
f0101793:	89 e5                	mov    %esp,%ebp
f0101795:	83 ec 0c             	sub    $0xc,%esp
	memset(pp, 0, sizeof(*pp));
f0101798:	6a 0c                	push   $0xc
f010179a:	6a 00                	push   $0x0
f010179c:	ff 75 08             	pushl  0x8(%ebp)
f010179f:	e8 ed 34 00 00       	call   f0104c91 <memset>
}
f01017a4:	c9                   	leave  
f01017a5:	c3                   	ret    

f01017a6 <page_alloc>:

//
// Allocates a physical page.
// Does NOT set the contents of the physical page to zero -
// the caller must do that if necessary.
//
// *pp_store -- is set to point to the Page struct of the newly allocated
// page
//
// RETURNS 
//   0 -- on success
//   -E_NO_MEM -- otherwise 
//
// Hint: use LIST_FIRST, LIST_REMOVE, and page_initpp
// Hint: pp_ref should not be incremented 
int
page_alloc(struct Page **pp_store)
{
f01017a6:	55                   	push   %ebp
f01017a7:	89 e5                	mov    %esp,%ebp
f01017a9:	83 ec 08             	sub    $0x8,%esp
f01017ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  // Fill this function in
  // seanyliu
  if (LIST_EMPTY(&page_free_list)) {
    return -E_NO_MEM;
f01017af:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01017b4:	83 3d b8 5b 2f f0 00 	cmpl   $0x0,0xf02f5bb8
f01017bb:	74 2c                	je     f01017e9 <page_alloc+0x43>
  }
  *pp_store = LIST_FIRST(&page_free_list);
f01017bd:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f01017c2:	89 01                	mov    %eax,(%ecx)
  LIST_REMOVE(*pp_store, pp_link);
f01017c4:	83 38 00             	cmpl   $0x0,(%eax)
f01017c7:	74 08                	je     f01017d1 <page_alloc+0x2b>
f01017c9:	8b 10                	mov    (%eax),%edx
f01017cb:	8b 40 04             	mov    0x4(%eax),%eax
f01017ce:	89 42 04             	mov    %eax,0x4(%edx)
f01017d1:	8b 01                	mov    (%ecx),%eax
f01017d3:	8b 50 04             	mov    0x4(%eax),%edx
f01017d6:	8b 00                	mov    (%eax),%eax
f01017d8:	89 02                	mov    %eax,(%edx)
  page_initpp(*pp_store);
f01017da:	83 ec 0c             	sub    $0xc,%esp
f01017dd:	ff 31                	pushl  (%ecx)
f01017df:	e8 ae ff ff ff       	call   f0101792 <page_initpp>
  return 0;
f01017e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01017e9:	c9                   	leave  
f01017ea:	c3                   	ret    

f01017eb <page_free>:

//
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct Page *pp)
{
f01017eb:	55                   	push   %ebp
f01017ec:	89 e5                	mov    %esp,%ebp
f01017ee:	8b 55 08             	mov    0x8(%ebp),%edx
  // Fill this function in
  // seanyliu
  LIST_INSERT_HEAD(&page_free_list, pp, pp_link);
f01017f1:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f01017f6:	89 02                	mov    %eax,(%edx)
f01017f8:	85 c0                	test   %eax,%eax
f01017fa:	74 08                	je     f0101804 <page_free+0x19>
f01017fc:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f0101801:	89 50 04             	mov    %edx,0x4(%eax)
f0101804:	89 15 b8 5b 2f f0    	mov    %edx,0xf02f5bb8
f010180a:	c7 42 04 b8 5b 2f f0 	movl   $0xf02f5bb8,0x4(%edx)
}
f0101811:	c9                   	leave  
f0101812:	c3                   	ret    

f0101813 <page_decref>:

//
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct Page* pp)
{
f0101813:	55                   	push   %ebp
f0101814:	89 e5                	mov    %esp,%ebp
f0101816:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f0101819:	66 ff 48 08          	decw   0x8(%eax)
f010181d:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f0101822:	75 09                	jne    f010182d <page_decref+0x1a>
		page_free(pp);
f0101824:	50                   	push   %eax
f0101825:	e8 c1 ff ff ff       	call   f01017eb <page_free>
f010182a:	83 c4 04             	add    $0x4,%esp
}
f010182d:	c9                   	leave  
f010182e:	c3                   	ret    

f010182f <pgdir_walk>:

// Given 'pgdir', a pointer to a page directory, pgdir_walk returns
// a pointer to the page table entry (PTE) for linear address 'va'.
// This requires walking the two-level page table structure.
//
// If the relevant page table doesn't exist in the page directory, then:
//    - If create == 0, pgdir_walk returns NULL.
//    - Otherwise, pgdir_walk tries to allocate a new page table
//	with page_alloc.  If this fails, pgdir_walk returns NULL.
//    - pgdir_walk sets pp_ref to 1 for the new page table.
//    - pgdir_walk clears the new page table.
//    - Finally, pgdir_walk returns a pointer into the new page table.
//
// Hint: you can turn a Page * into the physical address of the
// page it refers to with page2pa() from kern/pmap.h.
//
// Hint 2: the x86 MMU checks permission bits in both the page directory
// and the page table, so it's safe to leave permissions in the page
// more permissive than strictly necessary.
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f010182f:	55                   	push   %ebp
f0101830:	89 e5                	mov    %esp,%ebp
f0101832:	56                   	push   %esi
f0101833:	53                   	push   %ebx
f0101834:	83 ec 10             	sub    $0x10,%esp
f0101837:	8b 75 0c             	mov    0xc(%ebp),%esi

  // Fill this function in
  // return NULL;

  // seanyliu
  uint32_t *pgdir_entry = &pgdir[PDX(va)];
f010183a:	89 f3                	mov    %esi,%ebx
f010183c:	c1 eb 16             	shr    $0x16,%ebx
f010183f:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
f0101846:	89 c3                	mov    %eax,%ebx
f0101848:	03 5d 08             	add    0x8(%ebp),%ebx
  if (!(*pgdir_entry & PTE_P)) {
f010184b:	f6 03 01             	testb  $0x1,(%ebx)
f010184e:	0f 85 c5 00 00 00    	jne    f0101919 <pgdir_walk+0xea>
    if (!create) {
      return NULL;
f0101854:	ba 00 00 00 00       	mov    $0x0,%edx
f0101859:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f010185d:	0f 84 f1 00 00 00    	je     f0101954 <pgdir_walk+0x125>
    }

    struct Page *new_pgtbl;
    if (page_alloc(&new_pgtbl)) {
f0101863:	83 ec 0c             	sub    $0xc,%esp
f0101866:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f0101869:	50                   	push   %eax
f010186a:	e8 37 ff ff ff       	call   f01017a6 <page_alloc>
f010186f:	83 c4 10             	add    $0x10,%esp
      return NULL;
f0101872:	ba 00 00 00 00       	mov    $0x0,%edx
f0101877:	85 c0                	test   %eax,%eax
f0101879:	0f 85 d5 00 00 00    	jne    f0101954 <pgdir_walk+0x125>
    }
    new_pgtbl->pp_ref = 1;
f010187f:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f0101882:	66 c7 40 08 01 00    	movw   $0x1,0x8(%eax)

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101888:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f010188b:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0101891:	c1 fa 02             	sar    $0x2,%edx
f0101894:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101897:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010189a:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010189d:	89 c1                	mov    %eax,%ecx
f010189f:	c1 e1 08             	shl    $0x8,%ecx
f01018a2:	01 c8                	add    %ecx,%eax
f01018a4:	89 c1                	mov    %eax,%ecx
f01018a6:	c1 e1 10             	shl    $0x10,%ecx
f01018a9:	01 c8                	add    %ecx,%eax
f01018ab:	8d 04 42             	lea    (%edx,%eax,2),%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01018ae:	89 c2                	mov    %eax,%edx
f01018b0:	c1 e2 0c             	shl    $0xc,%edx
	return page2ppn(pp) << PGSHIFT;
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
		panic("pa2page called with invalid pa");
	return &pages[PPN(pa)];
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f01018b3:	89 d0                	mov    %edx,%eax
f01018b5:	c1 e8 0c             	shr    $0xc,%eax
f01018b8:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f01018be:	72 12                	jb     f01018d2 <pgdir_walk+0xa3>
f01018c0:	52                   	push   %edx
f01018c1:	68 ac 62 10 f0       	push   $0xf01062ac
f01018c6:	6a 5b                	push   $0x5b
f01018c8:	68 76 5f 10 f0       	push   $0xf0105f76
f01018cd:	e8 17 e8 ff ff       	call   f01000e9 <_panic>
f01018d2:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f01018d8:	83 ec 04             	sub    $0x4,%esp
f01018db:	68 00 10 00 00       	push   $0x1000
f01018e0:	6a 00                	push   $0x0
f01018e2:	50                   	push   %eax
f01018e3:	e8 a9 33 00 00       	call   f0104c91 <memset>
f01018e8:	83 c4 10             	add    $0x10,%esp
f01018eb:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f01018ee:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f01018f4:	c1 fa 02             	sar    $0x2,%edx
f01018f7:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01018fa:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01018fd:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101900:	89 c1                	mov    %eax,%ecx
f0101902:	c1 e1 08             	shl    $0x8,%ecx
f0101905:	01 c8                	add    %ecx,%eax
f0101907:	89 c1                	mov    %eax,%ecx
f0101909:	c1 e1 10             	shl    $0x10,%ecx
f010190c:	01 c8                	add    %ecx,%eax
f010190e:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0101911:	c1 e0 0c             	shl    $0xc,%eax
f0101914:	83 c8 07             	or     $0x7,%eax
f0101917:	89 03                	mov    %eax,(%ebx)
    memset(page2kva(new_pgtbl), 0, PGSIZE);
    *pgdir_entry = page2pa(new_pgtbl) | PTE_P | PTE_W | PTE_U;
  }

  pte_t *pgtbl_entry = KADDR(PTE_ADDR(*pgdir_entry));
f0101919:	8b 13                	mov    (%ebx),%edx
f010191b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101921:	89 d0                	mov    %edx,%eax
f0101923:	c1 e8 0c             	shr    $0xc,%eax
f0101926:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f010192c:	72 15                	jb     f0101943 <pgdir_walk+0x114>
f010192e:	52                   	push   %edx
f010192f:	68 ac 62 10 f0       	push   $0xf01062ac
f0101934:	68 86 02 00 00       	push   $0x286
f0101939:	68 22 68 10 f0       	push   $0xf0106822
f010193e:	e8 a6 e7 ff ff       	call   f01000e9 <_panic>
  return &pgtbl_entry[PTX(va)];
f0101943:	89 f0                	mov    %esi,%eax
f0101945:	c1 e8 0a             	shr    $0xa,%eax
f0101948:	25 fc 0f 00 00       	and    $0xffc,%eax
f010194d:	8d 94 02 00 00 00 f0 	lea    0xf0000000(%edx,%eax,1),%edx
}
f0101954:	89 d0                	mov    %edx,%eax
f0101956:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0101959:	5b                   	pop    %ebx
f010195a:	5e                   	pop    %esi
f010195b:	c9                   	leave  
f010195c:	c3                   	ret    

f010195d <page_insert>:

//
// Map the physical page 'pp' at virtual address 'va'.
// The permissions (the low 12 bits) of the page table
//  entry should be set to 'perm|PTE_P'.
//
// Requirements
//   - If there is already a page mapped at 'va', it should be page_remove()d.
//   - If necessary, on demand, a page table should be allocated and inserted
//     into 'pgdir'.
//   - pp->pp_ref should be incremented if the insertion succeeds.
//   - The TLB must be invalidated if a page was formerly present at 'va'.
//
// Corner-case hint: Make sure to consider what happens when the same 
// pp is re-inserted at the same virtual address in the same pgdir.
//
// RETURNS: 
//   0 on success
//   -E_NO_MEM, if page table couldn't be allocated
//
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct Page *pp, void *va, int perm) 
{
f010195d:	55                   	push   %ebp
f010195e:	89 e5                	mov    %esp,%ebp
f0101960:	57                   	push   %edi
f0101961:	56                   	push   %esi
f0101962:	53                   	push   %ebx
f0101963:	83 ec 10             	sub    $0x10,%esp
  // Fill this function in
  //return 0;

  // seanyliu
  pte_t *pgtbl_entry;
  pgtbl_entry = pgdir_walk(pgdir, va, 1);
f0101966:	6a 01                	push   $0x1
f0101968:	ff 75 10             	pushl  0x10(%ebp)
f010196b:	ff 75 08             	pushl  0x8(%ebp)
f010196e:	e8 bc fe ff ff       	call   f010182f <pgdir_walk>
f0101973:	89 c6                	mov    %eax,%esi
  if (pgtbl_entry == NULL) {
f0101975:	83 c4 10             	add    $0x10,%esp
    return -E_NO_MEM;
f0101978:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010197d:	85 f6                	test   %esi,%esi
f010197f:	0f 84 bf 00 00 00    	je     f0101a44 <page_insert+0xe7>
  }

  if (*pgtbl_entry & PTE_P) {
f0101985:	8b 06                	mov    (%esi),%eax
f0101987:	a8 01                	test   $0x1,%al
f0101989:	74 7c                	je     f0101a07 <page_insert+0xaa>
    if (PTE_ADDR(*pgtbl_entry) == page2pa(pp)) {
f010198b:	89 c3                	mov    %eax,%ebx
f010198d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101993:	8b 3d 7c 68 2f f0    	mov    0xf02f687c,%edi
f0101999:	8b 55 0c             	mov    0xc(%ebp),%edx
f010199c:	29 fa                	sub    %edi,%edx
f010199e:	c1 fa 02             	sar    $0x2,%edx
f01019a1:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01019a4:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01019a7:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01019aa:	89 c1                	mov    %eax,%ecx
f01019ac:	c1 e1 08             	shl    $0x8,%ecx
f01019af:	01 c8                	add    %ecx,%eax
f01019b1:	89 c1                	mov    %eax,%ecx
f01019b3:	c1 e1 10             	shl    $0x10,%ecx
f01019b6:	01 c8                	add    %ecx,%eax
f01019b8:	8d 04 42             	lea    (%edx,%eax,2),%eax
f01019bb:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01019be:	39 c3                	cmp    %eax,%ebx
f01019c0:	75 34                	jne    f01019f6 <page_insert+0x99>
f01019c2:	8b 55 0c             	mov    0xc(%ebp),%edx
f01019c5:	29 fa                	sub    %edi,%edx
f01019c7:	c1 fa 02             	sar    $0x2,%edx
f01019ca:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01019cd:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01019d0:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01019d3:	89 c1                	mov    %eax,%ecx
f01019d5:	c1 e1 08             	shl    $0x8,%ecx
f01019d8:	01 c8                	add    %ecx,%eax
f01019da:	89 c1                	mov    %eax,%ecx
f01019dc:	c1 e1 10             	shl    $0x10,%ecx
f01019df:	01 c8                	add    %ecx,%eax
f01019e1:	8d 04 42             	lea    (%edx,%eax,2),%eax
f01019e4:	c1 e0 0c             	shl    $0xc,%eax
f01019e7:	0b 45 14             	or     0x14(%ebp),%eax
f01019ea:	83 c8 01             	or     $0x1,%eax
f01019ed:	89 06                	mov    %eax,(%esi)
      *pgtbl_entry = page2pa(pp) | perm | PTE_P;
      return 0;
f01019ef:	b8 00 00 00 00       	mov    $0x0,%eax
f01019f4:	eb 4e                	jmp    f0101a44 <page_insert+0xe7>
    }
    page_remove(pgdir, va);
f01019f6:	83 ec 08             	sub    $0x8,%esp
f01019f9:	ff 75 10             	pushl  0x10(%ebp)
f01019fc:	ff 75 08             	pushl  0x8(%ebp)
f01019ff:	e8 20 01 00 00       	call   f0101b24 <page_remove>
f0101a04:	83 c4 10             	add    $0x10,%esp

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101a07:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101a0a:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0101a10:	c1 fa 02             	sar    $0x2,%edx
f0101a13:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101a16:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101a19:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101a1c:	89 c1                	mov    %eax,%ecx
f0101a1e:	c1 e1 08             	shl    $0x8,%ecx
f0101a21:	01 c8                	add    %ecx,%eax
f0101a23:	89 c1                	mov    %eax,%ecx
f0101a25:	c1 e1 10             	shl    $0x10,%ecx
f0101a28:	01 c8                	add    %ecx,%eax
f0101a2a:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0101a2d:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101a30:	0b 45 14             	or     0x14(%ebp),%eax
f0101a33:	83 c8 01             	or     $0x1,%eax
f0101a36:	89 06                	mov    %eax,(%esi)
  }

  *pgtbl_entry = page2pa(pp) | perm | PTE_P;
  pp->pp_ref++;
f0101a38:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101a3b:	66 ff 40 08          	incw   0x8(%eax)

  return 0;
f0101a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101a44:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0101a47:	5b                   	pop    %ebx
f0101a48:	5e                   	pop    %esi
f0101a49:	5f                   	pop    %edi
f0101a4a:	c9                   	leave  
f0101a4b:	c3                   	ret    

f0101a4c <boot_map_segment>:

//
// Map [la, la+size) of linear address space to physical [pa, pa+size)
// in the page table rooted at pgdir.  Size is a multiple of PGSIZE.
// Use permission bits perm|PTE_P for the entries.
//
// This function is only intended to set up the ``static'' mappings
// above UTOP. As such, it should *not* change the pp_ref field on the
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, physaddr_t pa, int perm)
{
f0101a4c:	55                   	push   %ebp
f0101a4d:	89 e5                	mov    %esp,%ebp
f0101a4f:	57                   	push   %edi
f0101a50:	56                   	push   %esi
f0101a51:	53                   	push   %ebx
f0101a52:	83 ec 0c             	sub    $0xc,%esp
f0101a55:	8b 75 10             	mov    0x10(%ebp),%esi
f0101a58:	8b 7d 18             	mov    0x18(%ebp),%edi
  // Fill this function in
  // seanyliu
  pte_t *pgtbl_entry;
  int idx;

  for (idx = 0; idx < size; idx += PGSIZE) {
f0101a5b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101a60:	39 f3                	cmp    %esi,%ebx
f0101a62:	73 49                	jae    f0101aad <boot_map_segment+0x61>
    pgtbl_entry = pgdir_walk(pgdir, (void *)(la + idx), 1);
f0101a64:	83 ec 04             	sub    $0x4,%esp
f0101a67:	6a 01                	push   $0x1
f0101a69:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101a6c:	01 d8                	add    %ebx,%eax
f0101a6e:	50                   	push   %eax
f0101a6f:	ff 75 08             	pushl  0x8(%ebp)
f0101a72:	e8 b8 fd ff ff       	call   f010182f <pgdir_walk>
f0101a77:	89 c2                	mov    %eax,%edx
    if (pgtbl_entry == NULL) {
f0101a79:	83 c4 10             	add    $0x10,%esp
f0101a7c:	85 c0                	test   %eax,%eax
f0101a7e:	75 17                	jne    f0101a97 <boot_map_segment+0x4b>
      panic("boot_map_segment: page table could not be created");
f0101a80:	83 ec 04             	sub    $0x4,%esp
f0101a83:	68 08 64 10 f0       	push   $0xf0106408
f0101a88:	68 d0 02 00 00       	push   $0x2d0
f0101a8d:	68 22 68 10 f0       	push   $0xf0106822
f0101a92:	e8 52 e6 ff ff       	call   f01000e9 <_panic>
    }
    *pgtbl_entry = (pa + idx) | perm | PTE_P;
f0101a97:	8b 45 14             	mov    0x14(%ebp),%eax
f0101a9a:	01 d8                	add    %ebx,%eax
f0101a9c:	09 f8                	or     %edi,%eax
f0101a9e:	83 c8 01             	or     $0x1,%eax
f0101aa1:	89 02                	mov    %eax,(%edx)
f0101aa3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101aa9:	39 f3                	cmp    %esi,%ebx
f0101aab:	72 b7                	jb     f0101a64 <boot_map_segment+0x18>
  }

}
f0101aad:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0101ab0:	5b                   	pop    %ebx
f0101ab1:	5e                   	pop    %esi
f0101ab2:	5f                   	pop    %edi
f0101ab3:	c9                   	leave  
f0101ab4:	c3                   	ret    

f0101ab5 <page_lookup>:

//
// Return the page mapped at virtual address 'va'.
// If pte_store is not zero, then we store in it the address
// of the pte for this page.  This is used by page_remove and
// can be used to verify page permissions for syscall arguments,
// but should not be used by most callers.
//
// Return NULL if there is no page mapped at va.
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct Page *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f0101ab5:	55                   	push   %ebp
f0101ab6:	89 e5                	mov    %esp,%ebp
f0101ab8:	53                   	push   %ebx
f0101ab9:	83 ec 08             	sub    $0x8,%esp
f0101abc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  // Fill this function in
  // return NULL;

  // seanyliu
  pte_t *pgtbl_entry;

  pgtbl_entry = pgdir_walk(pgdir, va, 0);
f0101abf:	6a 00                	push   $0x0
f0101ac1:	ff 75 0c             	pushl  0xc(%ebp)
f0101ac4:	ff 75 08             	pushl  0x8(%ebp)
f0101ac7:	e8 63 fd ff ff       	call   f010182f <pgdir_walk>
  if (pgtbl_entry == NULL || !(*pgtbl_entry & PTE_P)) {
f0101acc:	83 c4 10             	add    $0x10,%esp
f0101acf:	85 c0                	test   %eax,%eax
f0101ad1:	74 05                	je     f0101ad8 <page_lookup+0x23>
f0101ad3:	f6 00 01             	testb  $0x1,(%eax)
f0101ad6:	75 07                	jne    f0101adf <page_lookup+0x2a>
    return NULL;
f0101ad8:	b8 00 00 00 00       	mov    $0x0,%eax
f0101add:	eb 40                	jmp    f0101b1f <page_lookup+0x6a>
  }
  if (pte_store != 0) {
f0101adf:	85 db                	test   %ebx,%ebx
f0101ae1:	74 02                	je     f0101ae5 <page_lookup+0x30>
    *pte_store = pgtbl_entry;
f0101ae3:	89 03                	mov    %eax,(%ebx)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
f0101ae5:	8b 10                	mov    (%eax),%edx
f0101ae7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PPN(pa) >= npage)
f0101aed:	89 d0                	mov    %edx,%eax
f0101aef:	c1 e8 0c             	shr    $0xc,%eax
f0101af2:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0101af8:	72 14                	jb     f0101b0e <page_lookup+0x59>
		panic("pa2page called with invalid pa");
f0101afa:	83 ec 04             	sub    $0x4,%esp
f0101afd:	68 b4 60 10 f0       	push   $0xf01060b4
f0101b02:	6a 54                	push   $0x54
f0101b04:	68 76 5f 10 f0       	push   $0xf0105f76
f0101b09:	e8 db e5 ff ff       	call   f01000e9 <_panic>
f0101b0e:	89 d0                	mov    %edx,%eax
f0101b10:	c1 e8 0c             	shr    $0xc,%eax
f0101b13:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0101b16:	8b 15 7c 68 2f f0    	mov    0xf02f687c,%edx
f0101b1c:	8d 04 82             	lea    (%edx,%eax,4),%eax
  }
  return pa2page(PTE_ADDR(*pgtbl_entry));
}
f0101b1f:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0101b22:	c9                   	leave  
f0101b23:	c3                   	ret    

f0101b24 <page_remove>:

//
// Unmaps the physical page at virtual address 'va'.
// If there is no physical page at that address, silently does nothing.
//
// Details:
//   - The ref count on the physical page should decrement.
//   - The physical page should be freed if the refcount reaches 0.
//   - The pg table entry corresponding to 'va' should be set to 0.
//     (if such a PTE exists)
//   - The TLB must be invalidated if you remove an entry from
//     the pg dir/pg table.
//
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0101b24:	55                   	push   %ebp
f0101b25:	89 e5                	mov    %esp,%ebp
f0101b27:	56                   	push   %esi
f0101b28:	53                   	push   %ebx
f0101b29:	83 ec 14             	sub    $0x14,%esp
f0101b2c:	8b 75 08             	mov    0x8(%ebp),%esi
f0101b2f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  // Fill this function in
  // seanyliu

  struct Page *page;
  pte_t *pgtbl_entry;

  page = page_lookup(pgdir, va, &pgtbl_entry);
f0101b32:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f0101b35:	50                   	push   %eax
f0101b36:	53                   	push   %ebx
f0101b37:	56                   	push   %esi
f0101b38:	e8 78 ff ff ff       	call   f0101ab5 <page_lookup>
  if (page == NULL) {
f0101b3d:	83 c4 10             	add    $0x10,%esp
f0101b40:	85 c0                	test   %eax,%eax
f0101b42:	74 19                	je     f0101b5d <page_remove+0x39>
    return;
  }
  page_decref(page);
f0101b44:	50                   	push   %eax
f0101b45:	e8 c9 fc ff ff       	call   f0101813 <page_decref>
  *pgtbl_entry = 0;
f0101b4a:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f0101b4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  tlb_invalidate(pgdir, va);
f0101b53:	83 ec 04             	sub    $0x4,%esp
f0101b56:	53                   	push   %ebx
f0101b57:	56                   	push   %esi
f0101b58:	e8 07 00 00 00       	call   f0101b64 <tlb_invalidate>

}
f0101b5d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0101b60:	5b                   	pop    %ebx
f0101b61:	5e                   	pop    %esi
f0101b62:	c9                   	leave  
f0101b63:	c3                   	ret    

f0101b64 <tlb_invalidate>:

//
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0101b64:	55                   	push   %ebp
f0101b65:	89 e5                	mov    %esp,%ebp
f0101b67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f0101b6a:	83 3d c4 5b 2f f0 00 	cmpl   $0x0,0xf02f5bc4
f0101b71:	74 0e                	je     f0101b81 <tlb_invalidate+0x1d>
f0101b73:	8b 15 c4 5b 2f f0    	mov    0xf02f5bc4,%edx
f0101b79:	8b 45 08             	mov    0x8(%ebp),%eax
f0101b7c:	39 42 5c             	cmp    %eax,0x5c(%edx)
f0101b7f:	75 03                	jne    f0101b84 <tlb_invalidate+0x20>

static __inline void 
invlpg(void *addr)
{ 
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101b81:	0f 01 39             	invlpg (%ecx)
		invlpg(va);
}
f0101b84:	c9                   	leave  
f0101b85:	c3                   	ret    

f0101b86 <user_mem_check>:

static uintptr_t user_mem_check_addr;

//
// Check that an environment is allowed to access the range of memory
// [va, va+len) with permissions 'perm | PTE_P'.
// Normally 'perm' will contain PTE_U at least, but this is not required.
// 'va' and 'len' need not be page-aligned; you must test every page that
// contains any of that range.  You will test either 'len/PGSIZE',
// 'len/PGSIZE + 1', or 'len/PGSIZE + 2' pages.
//
// A user program can access a virtual address if (1) the address is below
// ULIM, and (2) the page table gives it permission.  These are exactly
// the tests you should implement here.
//
// If there is an error, set the 'user_mem_check_addr' variable to the first
// erroneous virtual address.
//
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f0101b86:	55                   	push   %ebp
f0101b87:	89 e5                	mov    %esp,%ebp
f0101b89:	57                   	push   %edi
f0101b8a:	56                   	push   %esi
f0101b8b:	53                   	push   %ebx
f0101b8c:	83 ec 0c             	sub    $0xc,%esp
f0101b8f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// LAB 3: Your code here. 
        // seanyliu
        int pidx;
	pte_t *ptep;
        const void* va_round = ROUNDDOWN(va, PGSIZE);
        int end = (int)va + len;
f0101b92:	8b 45 10             	mov    0x10(%ebp),%eax
f0101b95:	01 f8                	add    %edi,%eax
f0101b97:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
        for (pidx = (int)va_round; pidx < end; pidx += PGSIZE) {
f0101b9a:	89 fb                	mov    %edi,%ebx
f0101b9c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0101ba2:	39 c3                	cmp    %eax,%ebx
f0101ba4:	7d 50                	jge    f0101bf6 <user_mem_check+0x70>
f0101ba6:	8b 75 14             	mov    0x14(%ebp),%esi
f0101ba9:	83 ce 01             	or     $0x1,%esi
          ptep = pgdir_walk(env->env_pgdir, (void *)va, 0);
f0101bac:	83 ec 04             	sub    $0x4,%esp
f0101baf:	6a 00                	push   $0x0
f0101bb1:	57                   	push   %edi
f0101bb2:	8b 55 08             	mov    0x8(%ebp),%edx
f0101bb5:	ff 72 5c             	pushl  0x5c(%edx)
f0101bb8:	e8 72 fc ff ff       	call   f010182f <pgdir_walk>
          if ((ptep == NULL) || ((int)va >= ULIM) || ((*ptep & (perm | PTE_P)) != (perm | PTE_P))) {
f0101bbd:	83 c4 10             	add    $0x10,%esp
f0101bc0:	85 c0                	test   %eax,%eax
f0101bc2:	74 10                	je     f0101bd4 <user_mem_check+0x4e>
f0101bc4:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0101bca:	77 08                	ja     f0101bd4 <user_mem_check+0x4e>
f0101bcc:	89 f2                	mov    %esi,%edx
f0101bce:	23 10                	and    (%eax),%edx
f0101bd0:	39 f2                	cmp    %esi,%edx
f0101bd2:	74 17                	je     f0101beb <user_mem_check+0x65>
            user_mem_check_addr = (uintptr_t) pidx;
f0101bd4:	89 1d bc 5b 2f f0    	mov    %ebx,0xf02f5bbc

            // account for the rounding on va
            if (user_mem_check_addr < (uintptr_t)va) {
f0101bda:	39 df                	cmp    %ebx,%edi
f0101bdc:	76 06                	jbe    f0101be4 <user_mem_check+0x5e>
              user_mem_check_addr = (uintptr_t)va;
f0101bde:	89 3d bc 5b 2f f0    	mov    %edi,0xf02f5bbc
            }
            return -E_FAULT;
f0101be4:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0101be9:	eb 10                	jmp    f0101bfb <user_mem_check+0x75>
f0101beb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101bf1:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
f0101bf4:	7c b6                	jl     f0101bac <user_mem_check+0x26>
          }
        }


	return 0;
f0101bf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101bfb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0101bfe:	5b                   	pop    %ebx
f0101bff:	5e                   	pop    %esi
f0101c00:	5f                   	pop    %edi
f0101c01:	c9                   	leave  
f0101c02:	c3                   	ret    

f0101c03 <user_mem_assert>:

//
// Checks that environment 'env' is allowed to access the range
// of memory [va, va+len) with permissions 'perm | PTE_U'.
// If it can, then the function simply returns.
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f0101c03:	55                   	push   %ebp
f0101c04:	89 e5                	mov    %esp,%ebp
f0101c06:	53                   	push   %ebx
f0101c07:	83 ec 04             	sub    $0x4,%esp
f0101c0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0101c0d:	8b 45 14             	mov    0x14(%ebp),%eax
f0101c10:	83 c8 04             	or     $0x4,%eax
f0101c13:	50                   	push   %eax
f0101c14:	ff 75 10             	pushl  0x10(%ebp)
f0101c17:	ff 75 0c             	pushl  0xc(%ebp)
f0101c1a:	53                   	push   %ebx
f0101c1b:	e8 66 ff ff ff       	call   f0101b86 <user_mem_check>
f0101c20:	83 c4 10             	add    $0x10,%esp
f0101c23:	85 c0                	test   %eax,%eax
f0101c25:	79 21                	jns    f0101c48 <user_mem_assert+0x45>
		cprintf("[%08x] user_mem_check assertion failure for "
f0101c27:	83 ec 04             	sub    $0x4,%esp
f0101c2a:	ff 35 bc 5b 2f f0    	pushl  0xf02f5bbc
f0101c30:	ff 73 4c             	pushl  0x4c(%ebx)
f0101c33:	68 3c 64 10 f0       	push   $0xf010643c
f0101c38:	e8 85 14 00 00       	call   f01030c2 <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f0101c3d:	89 1c 24             	mov    %ebx,(%esp)
f0101c40:	e8 6d 12 00 00       	call   f0102eb2 <env_destroy>
f0101c45:	83 c4 10             	add    $0x10,%esp
	}
}
f0101c48:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0101c4b:	c9                   	leave  
f0101c4c:	c3                   	ret    

f0101c4d <page_check>:

// check page_insert, page_remove, &c
static void
page_check(void)
{
f0101c4d:	55                   	push   %ebp
f0101c4e:	89 e5                	mov    %esp,%ebp
f0101c50:	56                   	push   %esi
f0101c51:	53                   	push   %ebx
f0101c52:	83 ec 2c             	sub    $0x2c,%esp
	struct Page *pp, *pp0, *pp1, *pp2;
	struct Page_list fl;
	pte_t *ptep, *ptep1;
	void *va;
	int i;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0101c55:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
f0101c5c:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
f0101c63:	c7 45 f4 00 00 00 00 	movl   $0x0,0xfffffff4(%ebp)
	assert(page_alloc(&pp0) == 0);
f0101c6a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f0101c6d:	50                   	push   %eax
f0101c6e:	e8 33 fb ff ff       	call   f01017a6 <page_alloc>
f0101c73:	83 c4 10             	add    $0x10,%esp
f0101c76:	85 c0                	test   %eax,%eax
f0101c78:	74 19                	je     f0101c93 <page_check+0x46>
f0101c7a:	68 2e 68 10 f0       	push   $0xf010682e
f0101c7f:	68 44 68 10 f0       	push   $0xf0106844
f0101c84:	68 6e 03 00 00       	push   $0x36e
f0101c89:	68 22 68 10 f0       	push   $0xf0106822
f0101c8e:	e8 56 e4 ff ff       	call   f01000e9 <_panic>
	assert(page_alloc(&pp1) == 0);
f0101c93:	83 ec 0c             	sub    $0xc,%esp
f0101c96:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0101c99:	50                   	push   %eax
f0101c9a:	e8 07 fb ff ff       	call   f01017a6 <page_alloc>
f0101c9f:	83 c4 10             	add    $0x10,%esp
f0101ca2:	85 c0                	test   %eax,%eax
f0101ca4:	74 19                	je     f0101cbf <page_check+0x72>
f0101ca6:	68 59 68 10 f0       	push   $0xf0106859
f0101cab:	68 44 68 10 f0       	push   $0xf0106844
f0101cb0:	68 6f 03 00 00       	push   $0x36f
f0101cb5:	68 22 68 10 f0       	push   $0xf0106822
f0101cba:	e8 2a e4 ff ff       	call   f01000e9 <_panic>
	assert(page_alloc(&pp2) == 0);
f0101cbf:	83 ec 0c             	sub    $0xc,%esp
f0101cc2:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0101cc5:	50                   	push   %eax
f0101cc6:	e8 db fa ff ff       	call   f01017a6 <page_alloc>
f0101ccb:	83 c4 10             	add    $0x10,%esp
f0101cce:	85 c0                	test   %eax,%eax
f0101cd0:	74 19                	je     f0101ceb <page_check+0x9e>
f0101cd2:	68 6f 68 10 f0       	push   $0xf010686f
f0101cd7:	68 44 68 10 f0       	push   $0xf0106844
f0101cdc:	68 70 03 00 00       	push   $0x370
f0101ce1:	68 22 68 10 f0       	push   $0xf0106822
f0101ce6:	e8 fe e3 ff ff       	call   f01000e9 <_panic>

	assert(pp0);
f0101ceb:	83 7d f4 00          	cmpl   $0x0,0xfffffff4(%ebp)
f0101cef:	75 19                	jne    f0101d0a <page_check+0xbd>
f0101cf1:	68 93 68 10 f0       	push   $0xf0106893
f0101cf6:	68 44 68 10 f0       	push   $0xf0106844
f0101cfb:	68 72 03 00 00       	push   $0x372
f0101d00:	68 22 68 10 f0       	push   $0xf0106822
f0101d05:	e8 df e3 ff ff       	call   f01000e9 <_panic>
	assert(pp1 && pp1 != pp0);
f0101d0a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0101d0e:	74 08                	je     f0101d18 <page_check+0xcb>
f0101d10:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0101d13:	3b 45 f4             	cmp    0xfffffff4(%ebp),%eax
f0101d16:	75 19                	jne    f0101d31 <page_check+0xe4>
f0101d18:	68 85 68 10 f0       	push   $0xf0106885
f0101d1d:	68 44 68 10 f0       	push   $0xf0106844
f0101d22:	68 73 03 00 00       	push   $0x373
f0101d27:	68 22 68 10 f0       	push   $0xf0106822
f0101d2c:	e8 b8 e3 ff ff       	call   f01000e9 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d31:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
f0101d35:	74 0d                	je     f0101d44 <page_check+0xf7>
f0101d37:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0101d3a:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
f0101d3d:	74 05                	je     f0101d44 <page_check+0xf7>
f0101d3f:	3b 45 f4             	cmp    0xfffffff4(%ebp),%eax
f0101d42:	75 19                	jne    f0101d5d <page_check+0x110>
f0101d44:	68 d0 62 10 f0       	push   $0xf01062d0
f0101d49:	68 44 68 10 f0       	push   $0xf0106844
f0101d4e:	68 74 03 00 00       	push   $0x374
f0101d53:	68 22 68 10 f0       	push   $0xf0106822
f0101d58:	e8 8c e3 ff ff       	call   f01000e9 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101d5d:	8b 35 b8 5b 2f f0    	mov    0xf02f5bb8,%esi
	LIST_INIT(&page_free_list);
f0101d63:	c7 05 b8 5b 2f f0 00 	movl   $0x0,0xf02f5bb8
f0101d6a:	00 00 00 

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101d6d:	83 ec 0c             	sub    $0xc,%esp
f0101d70:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0101d73:	50                   	push   %eax
f0101d74:	e8 2d fa ff ff       	call   f01017a6 <page_alloc>
f0101d79:	83 c4 10             	add    $0x10,%esp
f0101d7c:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101d7f:	74 19                	je     f0101d9a <page_check+0x14d>
f0101d81:	68 eb 68 10 f0       	push   $0xf01068eb
f0101d86:	68 44 68 10 f0       	push   $0xf0106844
f0101d8b:	68 7b 03 00 00       	push   $0x37b
f0101d90:	68 22 68 10 f0       	push   $0xf0106822
f0101d95:	e8 4f e3 ff ff       	call   f01000e9 <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(boot_pgdir, (void *) 0x0, &ptep) == NULL);
f0101d9a:	83 ec 04             	sub    $0x4,%esp
f0101d9d:	8d 45 e4             	lea    0xffffffe4(%ebp),%eax
f0101da0:	50                   	push   %eax
f0101da1:	6a 00                	push   $0x0
f0101da3:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101da9:	e8 07 fd ff ff       	call   f0101ab5 <page_lookup>
f0101dae:	83 c4 10             	add    $0x10,%esp
f0101db1:	85 c0                	test   %eax,%eax
f0101db3:	74 19                	je     f0101dce <page_check+0x181>
f0101db5:	68 74 64 10 f0       	push   $0xf0106474
f0101dba:	68 44 68 10 f0       	push   $0xf0106844
f0101dbf:	68 7e 03 00 00       	push   $0x37e
f0101dc4:	68 22 68 10 f0       	push   $0xf0106822
f0101dc9:	e8 1b e3 ff ff       	call   f01000e9 <_panic>

	// there is no free memory, so we can't allocate a page table 
	assert(page_insert(boot_pgdir, pp1, 0x0, 0) < 0);
f0101dce:	6a 00                	push   $0x0
f0101dd0:	6a 00                	push   $0x0
f0101dd2:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0101dd5:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101ddb:	e8 7d fb ff ff       	call   f010195d <page_insert>
f0101de0:	83 c4 10             	add    $0x10,%esp
f0101de3:	85 c0                	test   %eax,%eax
f0101de5:	78 19                	js     f0101e00 <page_check+0x1b3>
f0101de7:	68 ac 64 10 f0       	push   $0xf01064ac
f0101dec:	68 44 68 10 f0       	push   $0xf0106844
f0101df1:	68 81 03 00 00       	push   $0x381
f0101df6:	68 22 68 10 f0       	push   $0xf0106822
f0101dfb:	e8 e9 e2 ff ff       	call   f01000e9 <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101e00:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f0101e03:	e8 e3 f9 ff ff       	call   f01017eb <page_free>
	assert(page_insert(boot_pgdir, pp1, 0x0, 0) == 0);
f0101e08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101e0f:	6a 00                	push   $0x0
f0101e11:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0101e14:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101e1a:	e8 3e fb ff ff       	call   f010195d <page_insert>
f0101e1f:	83 c4 10             	add    $0x10,%esp
f0101e22:	85 c0                	test   %eax,%eax
f0101e24:	74 19                	je     f0101e3f <page_check+0x1f2>
f0101e26:	68 d8 64 10 f0       	push   $0xf01064d8
f0101e2b:	68 44 68 10 f0       	push   $0xf0106844
f0101e30:	68 85 03 00 00       	push   $0x385
f0101e35:	68 22 68 10 f0       	push   $0xf0106822
f0101e3a:	e8 aa e2 ff ff       	call   f01000e9 <_panic>
	assert(PTE_ADDR(boot_pgdir[0]) == page2pa(pp0));
f0101e3f:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f0101e44:	8b 18                	mov    (%eax),%ebx
f0101e46:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101e4c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f0101e4f:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0101e55:	c1 fa 02             	sar    $0x2,%edx
f0101e58:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101e5b:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101e5e:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101e61:	89 c1                	mov    %eax,%ecx
f0101e63:	c1 e1 08             	shl    $0x8,%ecx
f0101e66:	01 c8                	add    %ecx,%eax
f0101e68:	89 c1                	mov    %eax,%ecx
f0101e6a:	c1 e1 10             	shl    $0x10,%ecx
f0101e6d:	01 c8                	add    %ecx,%eax
f0101e6f:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0101e72:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101e75:	39 c3                	cmp    %eax,%ebx
f0101e77:	74 19                	je     f0101e92 <page_check+0x245>
f0101e79:	68 04 65 10 f0       	push   $0xf0106504
f0101e7e:	68 44 68 10 f0       	push   $0xf0106844
f0101e83:	68 86 03 00 00       	push   $0x386
f0101e88:	68 22 68 10 f0       	push   $0xf0106822
f0101e8d:	e8 57 e2 ff ff       	call   f01000e9 <_panic>
	assert(check_va2pa(boot_pgdir, 0x0) == page2pa(pp1));
f0101e92:	83 ec 08             	sub    $0x8,%esp
f0101e95:	6a 00                	push   $0x0
f0101e97:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101e9d:	e8 f2 f6 ff ff       	call   f0101594 <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101ea2:	83 c4 10             	add    $0x10,%esp
f0101ea5:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
f0101ea8:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f0101eae:	c1 f9 02             	sar    $0x2,%ecx
f0101eb1:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f0101eb4:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0101eb7:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0101eba:	89 d3                	mov    %edx,%ebx
f0101ebc:	c1 e3 08             	shl    $0x8,%ebx
f0101ebf:	01 da                	add    %ebx,%edx
f0101ec1:	89 d3                	mov    %edx,%ebx
f0101ec3:	c1 e3 10             	shl    $0x10,%ebx
f0101ec6:	01 da                	add    %ebx,%edx
f0101ec8:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f0101ecb:	c1 e2 0c             	shl    $0xc,%edx
f0101ece:	39 d0                	cmp    %edx,%eax
f0101ed0:	74 19                	je     f0101eeb <page_check+0x29e>
f0101ed2:	68 2c 65 10 f0       	push   $0xf010652c
f0101ed7:	68 44 68 10 f0       	push   $0xf0106844
f0101edc:	68 87 03 00 00       	push   $0x387
f0101ee1:	68 22 68 10 f0       	push   $0xf0106822
f0101ee6:	e8 fe e1 ff ff       	call   f01000e9 <_panic>
	assert(pp1->pp_ref == 1);
f0101eeb:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0101eee:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f0101ef3:	74 19                	je     f0101f0e <page_check+0x2c1>
f0101ef5:	68 1f 69 10 f0       	push   $0xf010691f
f0101efa:	68 44 68 10 f0       	push   $0xf0106844
f0101eff:	68 88 03 00 00       	push   $0x388
f0101f04:	68 22 68 10 f0       	push   $0xf0106822
f0101f09:	e8 db e1 ff ff       	call   f01000e9 <_panic>
	assert(pp0->pp_ref == 1);
f0101f0e:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f0101f11:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f0101f16:	74 19                	je     f0101f31 <page_check+0x2e4>
f0101f18:	68 30 69 10 f0       	push   $0xf0106930
f0101f1d:	68 44 68 10 f0       	push   $0xf0106844
f0101f22:	68 89 03 00 00       	push   $0x389
f0101f27:	68 22 68 10 f0       	push   $0xf0106822
f0101f2c:	e8 b8 e1 ff ff       	call   f01000e9 <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, 0) == 0);
f0101f31:	6a 00                	push   $0x0
f0101f33:	68 00 10 00 00       	push   $0x1000
f0101f38:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0101f3b:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101f41:	e8 17 fa ff ff       	call   f010195d <page_insert>
f0101f46:	83 c4 10             	add    $0x10,%esp
f0101f49:	85 c0                	test   %eax,%eax
f0101f4b:	74 19                	je     f0101f66 <page_check+0x319>
f0101f4d:	68 5c 65 10 f0       	push   $0xf010655c
f0101f52:	68 44 68 10 f0       	push   $0xf0106844
f0101f57:	68 8c 03 00 00       	push   $0x38c
f0101f5c:	68 22 68 10 f0       	push   $0xf0106822
f0101f61:	e8 83 e1 ff ff       	call   f01000e9 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f0101f66:	83 ec 08             	sub    $0x8,%esp
f0101f69:	68 00 10 00 00       	push   $0x1000
f0101f6e:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101f74:	e8 1b f6 ff ff       	call   f0101594 <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101f79:	83 c4 10             	add    $0x10,%esp
f0101f7c:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
f0101f7f:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f0101f85:	c1 f9 02             	sar    $0x2,%ecx
f0101f88:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f0101f8b:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0101f8e:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0101f91:	89 d3                	mov    %edx,%ebx
f0101f93:	c1 e3 08             	shl    $0x8,%ebx
f0101f96:	01 da                	add    %ebx,%edx
f0101f98:	89 d3                	mov    %edx,%ebx
f0101f9a:	c1 e3 10             	shl    $0x10,%ebx
f0101f9d:	01 da                	add    %ebx,%edx
f0101f9f:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f0101fa2:	c1 e2 0c             	shl    $0xc,%edx
f0101fa5:	39 d0                	cmp    %edx,%eax
f0101fa7:	74 19                	je     f0101fc2 <page_check+0x375>
f0101fa9:	68 94 65 10 f0       	push   $0xf0106594
f0101fae:	68 44 68 10 f0       	push   $0xf0106844
f0101fb3:	68 8d 03 00 00       	push   $0x38d
f0101fb8:	68 22 68 10 f0       	push   $0xf0106822
f0101fbd:	e8 27 e1 ff ff       	call   f01000e9 <_panic>
	assert(pp2->pp_ref == 1);
f0101fc2:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0101fc5:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f0101fca:	74 19                	je     f0101fe5 <page_check+0x398>
f0101fcc:	68 41 69 10 f0       	push   $0xf0106941
f0101fd1:	68 44 68 10 f0       	push   $0xf0106844
f0101fd6:	68 8e 03 00 00       	push   $0x38e
f0101fdb:	68 22 68 10 f0       	push   $0xf0106822
f0101fe0:	e8 04 e1 ff ff       	call   f01000e9 <_panic>

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101fe5:	83 ec 0c             	sub    $0xc,%esp
f0101fe8:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0101feb:	50                   	push   %eax
f0101fec:	e8 b5 f7 ff ff       	call   f01017a6 <page_alloc>
f0101ff1:	83 c4 10             	add    $0x10,%esp
f0101ff4:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101ff7:	74 19                	je     f0102012 <page_check+0x3c5>
f0101ff9:	68 eb 68 10 f0       	push   $0xf01068eb
f0101ffe:	68 44 68 10 f0       	push   $0xf0106844
f0102003:	68 91 03 00 00       	push   $0x391
f0102008:	68 22 68 10 f0       	push   $0xf0106822
f010200d:	e8 d7 e0 ff ff       	call   f01000e9 <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, 0) == 0);
f0102012:	6a 00                	push   $0x0
f0102014:	68 00 10 00 00       	push   $0x1000
f0102019:	ff 75 ec             	pushl  0xffffffec(%ebp)
f010201c:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102022:	e8 36 f9 ff ff       	call   f010195d <page_insert>
f0102027:	83 c4 10             	add    $0x10,%esp
f010202a:	85 c0                	test   %eax,%eax
f010202c:	74 19                	je     f0102047 <page_check+0x3fa>
f010202e:	68 5c 65 10 f0       	push   $0xf010655c
f0102033:	68 44 68 10 f0       	push   $0xf0106844
f0102038:	68 94 03 00 00       	push   $0x394
f010203d:	68 22 68 10 f0       	push   $0xf0106822
f0102042:	e8 a2 e0 ff ff       	call   f01000e9 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f0102047:	83 ec 08             	sub    $0x8,%esp
f010204a:	68 00 10 00 00       	push   $0x1000
f010204f:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102055:	e8 3a f5 ff ff       	call   f0101594 <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f010205a:	83 c4 10             	add    $0x10,%esp
f010205d:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
f0102060:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f0102066:	c1 f9 02             	sar    $0x2,%ecx
f0102069:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f010206c:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f010206f:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0102072:	89 d3                	mov    %edx,%ebx
f0102074:	c1 e3 08             	shl    $0x8,%ebx
f0102077:	01 da                	add    %ebx,%edx
f0102079:	89 d3                	mov    %edx,%ebx
f010207b:	c1 e3 10             	shl    $0x10,%ebx
f010207e:	01 da                	add    %ebx,%edx
f0102080:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f0102083:	c1 e2 0c             	shl    $0xc,%edx
f0102086:	39 d0                	cmp    %edx,%eax
f0102088:	74 19                	je     f01020a3 <page_check+0x456>
f010208a:	68 94 65 10 f0       	push   $0xf0106594
f010208f:	68 44 68 10 f0       	push   $0xf0106844
f0102094:	68 95 03 00 00       	push   $0x395
f0102099:	68 22 68 10 f0       	push   $0xf0106822
f010209e:	e8 46 e0 ff ff       	call   f01000e9 <_panic>
	assert(pp2->pp_ref == 1);
f01020a3:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f01020a6:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f01020ab:	74 19                	je     f01020c6 <page_check+0x479>
f01020ad:	68 41 69 10 f0       	push   $0xf0106941
f01020b2:	68 44 68 10 f0       	push   $0xf0106844
f01020b7:	68 96 03 00 00       	push   $0x396
f01020bc:	68 22 68 10 f0       	push   $0xf0106822
f01020c1:	e8 23 e0 ff ff       	call   f01000e9 <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(page_alloc(&pp) == -E_NO_MEM);
f01020c6:	83 ec 0c             	sub    $0xc,%esp
f01020c9:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f01020cc:	50                   	push   %eax
f01020cd:	e8 d4 f6 ff ff       	call   f01017a6 <page_alloc>
f01020d2:	83 c4 10             	add    $0x10,%esp
f01020d5:	83 f8 fc             	cmp    $0xfffffffc,%eax
f01020d8:	74 19                	je     f01020f3 <page_check+0x4a6>
f01020da:	68 eb 68 10 f0       	push   $0xf01068eb
f01020df:	68 44 68 10 f0       	push   $0xf0106844
f01020e4:	68 9a 03 00 00       	push   $0x39a
f01020e9:	68 22 68 10 f0       	push   $0xf0106822
f01020ee:	e8 f6 df ff ff       	call   f01000e9 <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = KADDR(PTE_ADDR(boot_pgdir[PDX(PGSIZE)]));
f01020f3:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f01020f8:	8b 10                	mov    (%eax),%edx
f01020fa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102100:	89 d0                	mov    %edx,%eax
f0102102:	c1 e8 0c             	shr    $0xc,%eax
f0102105:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f010210b:	72 15                	jb     f0102122 <page_check+0x4d5>
f010210d:	52                   	push   %edx
f010210e:	68 ac 62 10 f0       	push   $0xf01062ac
f0102113:	68 9d 03 00 00       	push   $0x39d
f0102118:	68 22 68 10 f0       	push   $0xf0106822
f010211d:	e8 c7 df ff ff       	call   f01000e9 <_panic>
f0102122:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f0102128:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
	assert(pgdir_walk(boot_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f010212b:	83 ec 04             	sub    $0x4,%esp
f010212e:	6a 00                	push   $0x0
f0102130:	68 00 10 00 00       	push   $0x1000
f0102135:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010213b:	e8 ef f6 ff ff       	call   f010182f <pgdir_walk>
f0102140:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
f0102143:	83 c2 04             	add    $0x4,%edx
f0102146:	83 c4 10             	add    $0x10,%esp
f0102149:	39 d0                	cmp    %edx,%eax
f010214b:	74 19                	je     f0102166 <page_check+0x519>
f010214d:	68 c4 65 10 f0       	push   $0xf01065c4
f0102152:	68 44 68 10 f0       	push   $0xf0106844
f0102157:	68 9e 03 00 00       	push   $0x39e
f010215c:	68 22 68 10 f0       	push   $0xf0106822
f0102161:	e8 83 df ff ff       	call   f01000e9 <_panic>

	// should be able to change permissions too.
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, PTE_U) == 0);
f0102166:	6a 04                	push   $0x4
f0102168:	68 00 10 00 00       	push   $0x1000
f010216d:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0102170:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102176:	e8 e2 f7 ff ff       	call   f010195d <page_insert>
f010217b:	83 c4 10             	add    $0x10,%esp
f010217e:	85 c0                	test   %eax,%eax
f0102180:	74 19                	je     f010219b <page_check+0x54e>
f0102182:	68 04 66 10 f0       	push   $0xf0106604
f0102187:	68 44 68 10 f0       	push   $0xf0106844
f010218c:	68 a1 03 00 00       	push   $0x3a1
f0102191:	68 22 68 10 f0       	push   $0xf0106822
f0102196:	e8 4e df ff ff       	call   f01000e9 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f010219b:	83 ec 08             	sub    $0x8,%esp
f010219e:	68 00 10 00 00       	push   $0x1000
f01021a3:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f01021a9:	e8 e6 f3 ff ff       	call   f0101594 <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01021ae:	83 c4 10             	add    $0x10,%esp
f01021b1:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
f01021b4:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f01021ba:	c1 f9 02             	sar    $0x2,%ecx
f01021bd:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f01021c0:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f01021c3:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f01021c6:	89 d3                	mov    %edx,%ebx
f01021c8:	c1 e3 08             	shl    $0x8,%ebx
f01021cb:	01 da                	add    %ebx,%edx
f01021cd:	89 d3                	mov    %edx,%ebx
f01021cf:	c1 e3 10             	shl    $0x10,%ebx
f01021d2:	01 da                	add    %ebx,%edx
f01021d4:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f01021d7:	c1 e2 0c             	shl    $0xc,%edx
f01021da:	39 d0                	cmp    %edx,%eax
f01021dc:	74 19                	je     f01021f7 <page_check+0x5aa>
f01021de:	68 94 65 10 f0       	push   $0xf0106594
f01021e3:	68 44 68 10 f0       	push   $0xf0106844
f01021e8:	68 a2 03 00 00       	push   $0x3a2
f01021ed:	68 22 68 10 f0       	push   $0xf0106822
f01021f2:	e8 f2 de ff ff       	call   f01000e9 <_panic>
	assert(pp2->pp_ref == 1);
f01021f7:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f01021fa:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f01021ff:	74 19                	je     f010221a <page_check+0x5cd>
f0102201:	68 41 69 10 f0       	push   $0xf0106941
f0102206:	68 44 68 10 f0       	push   $0xf0106844
f010220b:	68 a3 03 00 00       	push   $0x3a3
f0102210:	68 22 68 10 f0       	push   $0xf0106822
f0102215:	e8 cf de ff ff       	call   f01000e9 <_panic>
	assert(*pgdir_walk(boot_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010221a:	83 ec 04             	sub    $0x4,%esp
f010221d:	6a 00                	push   $0x0
f010221f:	68 00 10 00 00       	push   $0x1000
f0102224:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010222a:	e8 00 f6 ff ff       	call   f010182f <pgdir_walk>
f010222f:	83 c4 10             	add    $0x10,%esp
f0102232:	f6 00 04             	testb  $0x4,(%eax)
f0102235:	75 19                	jne    f0102250 <page_check+0x603>
f0102237:	68 40 66 10 f0       	push   $0xf0106640
f010223c:	68 44 68 10 f0       	push   $0xf0106844
f0102241:	68 a4 03 00 00       	push   $0x3a4
f0102246:	68 22 68 10 f0       	push   $0xf0106822
f010224b:	e8 99 de ff ff       	call   f01000e9 <_panic>
	assert(boot_pgdir[0] & PTE_U);
f0102250:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f0102255:	f6 00 04             	testb  $0x4,(%eax)
f0102258:	75 19                	jne    f0102273 <page_check+0x626>
f010225a:	68 52 69 10 f0       	push   $0xf0106952
f010225f:	68 44 68 10 f0       	push   $0xf0106844
f0102264:	68 a5 03 00 00       	push   $0x3a5
f0102269:	68 22 68 10 f0       	push   $0xf0106822
f010226e:	e8 76 de ff ff       	call   f01000e9 <_panic>
	
	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(boot_pgdir, pp0, (void*) PTSIZE, 0) < 0);
f0102273:	6a 00                	push   $0x0
f0102275:	68 00 00 40 00       	push   $0x400000
f010227a:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f010227d:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102283:	e8 d5 f6 ff ff       	call   f010195d <page_insert>
f0102288:	83 c4 10             	add    $0x10,%esp
f010228b:	85 c0                	test   %eax,%eax
f010228d:	78 19                	js     f01022a8 <page_check+0x65b>
f010228f:	68 74 66 10 f0       	push   $0xf0106674
f0102294:	68 44 68 10 f0       	push   $0xf0106844
f0102299:	68 a8 03 00 00       	push   $0x3a8
f010229e:	68 22 68 10 f0       	push   $0xf0106822
f01022a3:	e8 41 de ff ff       	call   f01000e9 <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(boot_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01022a8:	6a 00                	push   $0x0
f01022aa:	68 00 10 00 00       	push   $0x1000
f01022af:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f01022b2:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f01022b8:	e8 a0 f6 ff ff       	call   f010195d <page_insert>
f01022bd:	83 c4 10             	add    $0x10,%esp
f01022c0:	85 c0                	test   %eax,%eax
f01022c2:	74 19                	je     f01022dd <page_check+0x690>
f01022c4:	68 a8 66 10 f0       	push   $0xf01066a8
f01022c9:	68 44 68 10 f0       	push   $0xf0106844
f01022ce:	68 ab 03 00 00       	push   $0x3ab
f01022d3:	68 22 68 10 f0       	push   $0xf0106822
f01022d8:	e8 0c de ff ff       	call   f01000e9 <_panic>
	assert(!(*pgdir_walk(boot_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01022dd:	83 ec 04             	sub    $0x4,%esp
f01022e0:	6a 00                	push   $0x0
f01022e2:	68 00 10 00 00       	push   $0x1000
f01022e7:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f01022ed:	e8 3d f5 ff ff       	call   f010182f <pgdir_walk>
f01022f2:	83 c4 10             	add    $0x10,%esp
f01022f5:	f6 00 04             	testb  $0x4,(%eax)
f01022f8:	74 19                	je     f0102313 <page_check+0x6c6>
f01022fa:	68 e0 66 10 f0       	push   $0xf01066e0
f01022ff:	68 44 68 10 f0       	push   $0xf0106844
f0102304:	68 ac 03 00 00       	push   $0x3ac
f0102309:	68 22 68 10 f0       	push   $0xf0106822
f010230e:	e8 d6 dd ff ff       	call   f01000e9 <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(boot_pgdir, 0) == page2pa(pp1));
f0102313:	83 ec 08             	sub    $0x8,%esp
f0102316:	6a 00                	push   $0x0
f0102318:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010231e:	e8 71 f2 ff ff       	call   f0101594 <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0102323:	83 c4 10             	add    $0x10,%esp
f0102326:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
f0102329:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f010232f:	c1 f9 02             	sar    $0x2,%ecx
f0102332:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f0102335:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0102338:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f010233b:	89 d3                	mov    %edx,%ebx
f010233d:	c1 e3 08             	shl    $0x8,%ebx
f0102340:	01 da                	add    %ebx,%edx
f0102342:	89 d3                	mov    %edx,%ebx
f0102344:	c1 e3 10             	shl    $0x10,%ebx
f0102347:	01 da                	add    %ebx,%edx
f0102349:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f010234c:	c1 e2 0c             	shl    $0xc,%edx
f010234f:	39 d0                	cmp    %edx,%eax
f0102351:	74 19                	je     f010236c <page_check+0x71f>
f0102353:	68 18 67 10 f0       	push   $0xf0106718
f0102358:	68 44 68 10 f0       	push   $0xf0106844
f010235d:	68 af 03 00 00       	push   $0x3af
f0102362:	68 22 68 10 f0       	push   $0xf0106822
f0102367:	e8 7d dd ff ff       	call   f01000e9 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp1));
f010236c:	83 ec 08             	sub    $0x8,%esp
f010236f:	68 00 10 00 00       	push   $0x1000
f0102374:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010237a:	e8 15 f2 ff ff       	call   f0101594 <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f010237f:	83 c4 10             	add    $0x10,%esp
f0102382:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
f0102385:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f010238b:	c1 f9 02             	sar    $0x2,%ecx
f010238e:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f0102391:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0102394:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0102397:	89 d3                	mov    %edx,%ebx
f0102399:	c1 e3 08             	shl    $0x8,%ebx
f010239c:	01 da                	add    %ebx,%edx
f010239e:	89 d3                	mov    %edx,%ebx
f01023a0:	c1 e3 10             	shl    $0x10,%ebx
f01023a3:	01 da                	add    %ebx,%edx
f01023a5:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f01023a8:	c1 e2 0c             	shl    $0xc,%edx
f01023ab:	39 d0                	cmp    %edx,%eax
f01023ad:	74 19                	je     f01023c8 <page_check+0x77b>
f01023af:	68 44 67 10 f0       	push   $0xf0106744
f01023b4:	68 44 68 10 f0       	push   $0xf0106844
f01023b9:	68 b0 03 00 00       	push   $0x3b0
f01023be:	68 22 68 10 f0       	push   $0xf0106822
f01023c3:	e8 21 dd ff ff       	call   f01000e9 <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01023c8:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f01023cb:	66 83 78 08 02       	cmpw   $0x2,0x8(%eax)
f01023d0:	74 19                	je     f01023eb <page_check+0x79e>
f01023d2:	68 68 69 10 f0       	push   $0xf0106968
f01023d7:	68 44 68 10 f0       	push   $0xf0106844
f01023dc:	68 b2 03 00 00       	push   $0x3b2
f01023e1:	68 22 68 10 f0       	push   $0xf0106822
f01023e6:	e8 fe dc ff ff       	call   f01000e9 <_panic>
	assert(pp2->pp_ref == 0);
f01023eb:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f01023ee:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f01023f3:	74 19                	je     f010240e <page_check+0x7c1>
f01023f5:	68 79 69 10 f0       	push   $0xf0106979
f01023fa:	68 44 68 10 f0       	push   $0xf0106844
f01023ff:	68 b3 03 00 00       	push   $0x3b3
f0102404:	68 22 68 10 f0       	push   $0xf0106822
f0102409:	e8 db dc ff ff       	call   f01000e9 <_panic>

	// pp2 should be returned by page_alloc
	assert(page_alloc(&pp) == 0 && pp == pp2);
f010240e:	83 ec 0c             	sub    $0xc,%esp
f0102411:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0102414:	50                   	push   %eax
f0102415:	e8 8c f3 ff ff       	call   f01017a6 <page_alloc>
f010241a:	83 c4 10             	add    $0x10,%esp
f010241d:	85 c0                	test   %eax,%eax
f010241f:	75 08                	jne    f0102429 <page_check+0x7dc>
f0102421:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f0102424:	3b 45 ec             	cmp    0xffffffec(%ebp),%eax
f0102427:	74 19                	je     f0102442 <page_check+0x7f5>
f0102429:	68 74 67 10 f0       	push   $0xf0106774
f010242e:	68 44 68 10 f0       	push   $0xf0106844
f0102433:	68 b6 03 00 00       	push   $0x3b6
f0102438:	68 22 68 10 f0       	push   $0xf0106822
f010243d:	e8 a7 dc ff ff       	call   f01000e9 <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(boot_pgdir, 0x0);
f0102442:	83 ec 08             	sub    $0x8,%esp
f0102445:	6a 00                	push   $0x0
f0102447:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010244d:	e8 d2 f6 ff ff       	call   f0101b24 <page_remove>
	assert(check_va2pa(boot_pgdir, 0x0) == ~0);
f0102452:	83 c4 08             	add    $0x8,%esp
f0102455:	6a 00                	push   $0x0
f0102457:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010245d:	e8 32 f1 ff ff       	call   f0101594 <check_va2pa>
f0102462:	83 c4 10             	add    $0x10,%esp
f0102465:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102468:	74 19                	je     f0102483 <page_check+0x836>
f010246a:	68 98 67 10 f0       	push   $0xf0106798
f010246f:	68 44 68 10 f0       	push   $0xf0106844
f0102474:	68 ba 03 00 00       	push   $0x3ba
f0102479:	68 22 68 10 f0       	push   $0xf0106822
f010247e:	e8 66 dc ff ff       	call   f01000e9 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp1));
f0102483:	83 ec 08             	sub    $0x8,%esp
f0102486:	68 00 10 00 00       	push   $0x1000
f010248b:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102491:	e8 fe f0 ff ff       	call   f0101594 <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0102496:	83 c4 10             	add    $0x10,%esp
f0102499:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
f010249c:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f01024a2:	c1 f9 02             	sar    $0x2,%ecx
f01024a5:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f01024a8:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f01024ab:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f01024ae:	89 d3                	mov    %edx,%ebx
f01024b0:	c1 e3 08             	shl    $0x8,%ebx
f01024b3:	01 da                	add    %ebx,%edx
f01024b5:	89 d3                	mov    %edx,%ebx
f01024b7:	c1 e3 10             	shl    $0x10,%ebx
f01024ba:	01 da                	add    %ebx,%edx
f01024bc:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f01024bf:	c1 e2 0c             	shl    $0xc,%edx
f01024c2:	39 d0                	cmp    %edx,%eax
f01024c4:	74 19                	je     f01024df <page_check+0x892>
f01024c6:	68 44 67 10 f0       	push   $0xf0106744
f01024cb:	68 44 68 10 f0       	push   $0xf0106844
f01024d0:	68 bb 03 00 00       	push   $0x3bb
f01024d5:	68 22 68 10 f0       	push   $0xf0106822
f01024da:	e8 0a dc ff ff       	call   f01000e9 <_panic>
	assert(pp1->pp_ref == 1);
f01024df:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f01024e2:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f01024e7:	74 19                	je     f0102502 <page_check+0x8b5>
f01024e9:	68 1f 69 10 f0       	push   $0xf010691f
f01024ee:	68 44 68 10 f0       	push   $0xf0106844
f01024f3:	68 bc 03 00 00       	push   $0x3bc
f01024f8:	68 22 68 10 f0       	push   $0xf0106822
f01024fd:	e8 e7 db ff ff       	call   f01000e9 <_panic>
	assert(pp2->pp_ref == 0);
f0102502:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0102505:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f010250a:	74 19                	je     f0102525 <page_check+0x8d8>
f010250c:	68 79 69 10 f0       	push   $0xf0106979
f0102511:	68 44 68 10 f0       	push   $0xf0106844
f0102516:	68 bd 03 00 00       	push   $0x3bd
f010251b:	68 22 68 10 f0       	push   $0xf0106822
f0102520:	e8 c4 db ff ff       	call   f01000e9 <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(boot_pgdir, (void*) PGSIZE);
f0102525:	83 ec 08             	sub    $0x8,%esp
f0102528:	68 00 10 00 00       	push   $0x1000
f010252d:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102533:	e8 ec f5 ff ff       	call   f0101b24 <page_remove>
	assert(check_va2pa(boot_pgdir, 0x0) == ~0);
f0102538:	83 c4 08             	add    $0x8,%esp
f010253b:	6a 00                	push   $0x0
f010253d:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102543:	e8 4c f0 ff ff       	call   f0101594 <check_va2pa>
f0102548:	83 c4 10             	add    $0x10,%esp
f010254b:	83 f8 ff             	cmp    $0xffffffff,%eax
f010254e:	74 19                	je     f0102569 <page_check+0x91c>
f0102550:	68 98 67 10 f0       	push   $0xf0106798
f0102555:	68 44 68 10 f0       	push   $0xf0106844
f010255a:	68 c1 03 00 00       	push   $0x3c1
f010255f:	68 22 68 10 f0       	push   $0xf0106822
f0102564:	e8 80 db ff ff       	call   f01000e9 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == ~0);
f0102569:	83 ec 08             	sub    $0x8,%esp
f010256c:	68 00 10 00 00       	push   $0x1000
f0102571:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102577:	e8 18 f0 ff ff       	call   f0101594 <check_va2pa>
f010257c:	83 c4 10             	add    $0x10,%esp
f010257f:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102582:	74 19                	je     f010259d <page_check+0x950>
f0102584:	68 bc 67 10 f0       	push   $0xf01067bc
f0102589:	68 44 68 10 f0       	push   $0xf0106844
f010258e:	68 c2 03 00 00       	push   $0x3c2
f0102593:	68 22 68 10 f0       	push   $0xf0106822
f0102598:	e8 4c db ff ff       	call   f01000e9 <_panic>
	assert(pp1->pp_ref == 0);
f010259d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f01025a0:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f01025a5:	74 19                	je     f01025c0 <page_check+0x973>
f01025a7:	68 8a 69 10 f0       	push   $0xf010698a
f01025ac:	68 44 68 10 f0       	push   $0xf0106844
f01025b1:	68 c3 03 00 00       	push   $0x3c3
f01025b6:	68 22 68 10 f0       	push   $0xf0106822
f01025bb:	e8 29 db ff ff       	call   f01000e9 <_panic>
	assert(pp2->pp_ref == 0);
f01025c0:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f01025c3:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f01025c8:	74 19                	je     f01025e3 <page_check+0x996>
f01025ca:	68 79 69 10 f0       	push   $0xf0106979
f01025cf:	68 44 68 10 f0       	push   $0xf0106844
f01025d4:	68 c4 03 00 00       	push   $0x3c4
f01025d9:	68 22 68 10 f0       	push   $0xf0106822
f01025de:	e8 06 db ff ff       	call   f01000e9 <_panic>

	// so it should be returned by page_alloc
	assert(page_alloc(&pp) == 0 && pp == pp1);
f01025e3:	83 ec 0c             	sub    $0xc,%esp
f01025e6:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f01025e9:	50                   	push   %eax
f01025ea:	e8 b7 f1 ff ff       	call   f01017a6 <page_alloc>
f01025ef:	83 c4 10             	add    $0x10,%esp
f01025f2:	85 c0                	test   %eax,%eax
f01025f4:	75 08                	jne    f01025fe <page_check+0x9b1>
f01025f6:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f01025f9:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
f01025fc:	74 19                	je     f0102617 <page_check+0x9ca>
f01025fe:	68 e4 67 10 f0       	push   $0xf01067e4
f0102603:	68 44 68 10 f0       	push   $0xf0106844
f0102608:	68 c7 03 00 00       	push   $0x3c7
f010260d:	68 22 68 10 f0       	push   $0xf0106822
f0102612:	e8 d2 da ff ff       	call   f01000e9 <_panic>

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0102617:	83 ec 0c             	sub    $0xc,%esp
f010261a:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f010261d:	50                   	push   %eax
f010261e:	e8 83 f1 ff ff       	call   f01017a6 <page_alloc>
f0102623:	83 c4 10             	add    $0x10,%esp
f0102626:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0102629:	74 19                	je     f0102644 <page_check+0x9f7>
f010262b:	68 eb 68 10 f0       	push   $0xf01068eb
f0102630:	68 44 68 10 f0       	push   $0xf0106844
f0102635:	68 ca 03 00 00       	push   $0x3ca
f010263a:	68 22 68 10 f0       	push   $0xf0106822
f010263f:	e8 a5 da ff ff       	call   f01000e9 <_panic>
	
#if 0
	// should be able to page_insert to change a page
	// and see the new data immediately.
	memset(page2kva(pp1), 1, PGSIZE);
	memset(page2kva(pp2), 2, PGSIZE);
	page_insert(boot_pgdir, pp1, 0x0, 0);
	assert(pp1->pp_ref == 1);
	assert(*(int*)0 == 0x01010101);
	page_insert(boot_pgdir, pp2, 0x0, 0);
	assert(*(int*)0 == 0x02020202);
	assert(pp2->pp_ref == 1);
	assert(pp1->pp_ref == 0);
	page_remove(boot_pgdir, 0x0);
	assert(pp2->pp_ref == 0);
#endif

	// forcibly take pp0 back
	assert(PTE_ADDR(boot_pgdir[0]) == page2pa(pp0));
f0102644:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f0102649:	8b 18                	mov    (%eax),%ebx
f010264b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0102651:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f0102654:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f010265a:	c1 fa 02             	sar    $0x2,%edx
f010265d:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0102660:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102663:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102666:	89 c1                	mov    %eax,%ecx
f0102668:	c1 e1 08             	shl    $0x8,%ecx
f010266b:	01 c8                	add    %ecx,%eax
f010266d:	89 c1                	mov    %eax,%ecx
f010266f:	c1 e1 10             	shl    $0x10,%ecx
f0102672:	01 c8                	add    %ecx,%eax
f0102674:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0102677:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f010267a:	39 c3                	cmp    %eax,%ebx
f010267c:	74 19                	je     f0102697 <page_check+0xa4a>
f010267e:	68 04 65 10 f0       	push   $0xf0106504
f0102683:	68 44 68 10 f0       	push   $0xf0106844
f0102688:	68 dd 03 00 00       	push   $0x3dd
f010268d:	68 22 68 10 f0       	push   $0xf0106822
f0102692:	e8 52 da ff ff       	call   f01000e9 <_panic>
	boot_pgdir[0] = 0;
f0102697:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f010269c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f01026a2:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f01026a5:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f01026aa:	74 19                	je     f01026c5 <page_check+0xa78>
f01026ac:	68 30 69 10 f0       	push   $0xf0106930
f01026b1:	68 44 68 10 f0       	push   $0xf0106844
f01026b6:	68 df 03 00 00       	push   $0x3df
f01026bb:	68 22 68 10 f0       	push   $0xf0106822
f01026c0:	e8 24 da ff ff       	call   f01000e9 <_panic>
	pp0->pp_ref = 0;
f01026c5:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f01026c8:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
	
	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f01026ce:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f01026d1:	e8 15 f1 ff ff       	call   f01017eb <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
f01026d6:	bb 00 10 40 00       	mov    $0x401000,%ebx
	ptep = pgdir_walk(boot_pgdir, va, 1);
f01026db:	6a 01                	push   $0x1
f01026dd:	68 00 10 40 00       	push   $0x401000
f01026e2:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f01026e8:	e8 42 f1 ff ff       	call   f010182f <pgdir_walk>
f01026ed:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
	ptep1 = KADDR(PTE_ADDR(boot_pgdir[PDX(va)]));
f01026f0:	83 c4 10             	add    $0x10,%esp
f01026f3:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f01026f8:	8b 50 04             	mov    0x4(%eax),%edx
f01026fb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102701:	89 d0                	mov    %edx,%eax
f0102703:	c1 e8 0c             	shr    $0xc,%eax
f0102706:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f010270c:	72 15                	jb     f0102723 <page_check+0xad6>
f010270e:	52                   	push   %edx
f010270f:	68 ac 62 10 f0       	push   $0xf01062ac
f0102714:	68 e6 03 00 00       	push   $0x3e6
f0102719:	68 22 68 10 f0       	push   $0xf0106822
f010271e:	e8 c6 d9 ff ff       	call   f01000e9 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102723:	89 d8                	mov    %ebx,%eax
f0102725:	c1 e8 0a             	shr    $0xa,%eax
f0102728:	83 e0 04             	and    $0x4,%eax
f010272b:	8d 84 02 00 00 00 f0 	lea    0xf0000000(%edx,%eax,1),%eax
f0102732:	3b 45 e4             	cmp    0xffffffe4(%ebp),%eax
f0102735:	74 19                	je     f0102750 <page_check+0xb03>
f0102737:	68 9b 69 10 f0       	push   $0xf010699b
f010273c:	68 44 68 10 f0       	push   $0xf0106844
f0102741:	68 e7 03 00 00       	push   $0x3e7
f0102746:	68 22 68 10 f0       	push   $0xf0106822
f010274b:	e8 99 d9 ff ff       	call   f01000e9 <_panic>
	boot_pgdir[PDX(va)] = 0;
f0102750:	89 da                	mov    %ebx,%edx
f0102752:	c1 ea 16             	shr    $0x16,%edx
f0102755:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f010275a:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
	pp0->pp_ref = 0;
f0102761:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f0102764:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f010276a:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f010276d:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0102773:	c1 fa 02             	sar    $0x2,%edx
f0102776:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0102779:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010277c:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010277f:	89 c1                	mov    %eax,%ecx
f0102781:	c1 e1 08             	shl    $0x8,%ecx
f0102784:	01 c8                	add    %ecx,%eax
f0102786:	89 c1                	mov    %eax,%ecx
f0102788:	c1 e1 10             	shl    $0x10,%ecx
f010278b:	01 c8                	add    %ecx,%eax
f010278d:	8d 04 42             	lea    (%edx,%eax,2),%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0102790:	89 c2                	mov    %eax,%edx
f0102792:	c1 e2 0c             	shl    $0xc,%edx
	return page2ppn(pp) << PGSHIFT;
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
		panic("pa2page called with invalid pa");
	return &pages[PPN(pa)];
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0102795:	89 d0                	mov    %edx,%eax
f0102797:	c1 e8 0c             	shr    $0xc,%eax
f010279a:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f01027a0:	72 12                	jb     f01027b4 <page_check+0xb67>
f01027a2:	52                   	push   %edx
f01027a3:	68 ac 62 10 f0       	push   $0xf01062ac
f01027a8:	6a 5b                	push   $0x5b
f01027aa:	68 76 5f 10 f0       	push   $0xf0105f76
f01027af:	e8 35 d9 ff ff       	call   f01000e9 <_panic>
f01027b4:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f01027ba:	83 ec 04             	sub    $0x4,%esp
f01027bd:	68 00 10 00 00       	push   $0x1000
f01027c2:	68 ff 00 00 00       	push   $0xff
f01027c7:	50                   	push   %eax
f01027c8:	e8 c4 24 00 00       	call   f0104c91 <memset>
	
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
f01027cd:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f01027d0:	e8 16 f0 ff ff       	call   f01017eb <page_free>
	pgdir_walk(boot_pgdir, 0x0, 1);
f01027d5:	6a 01                	push   $0x1
f01027d7:	6a 00                	push   $0x0
f01027d9:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f01027df:	e8 4b f0 ff ff       	call   f010182f <pgdir_walk>
}

static inline void*
page2kva(struct Page *pp)
{
f01027e4:	83 c4 20             	add    $0x20,%esp
f01027e7:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f01027ea:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f01027f0:	c1 fa 02             	sar    $0x2,%edx
f01027f3:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01027f6:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01027f9:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01027fc:	89 c1                	mov    %eax,%ecx
f01027fe:	c1 e1 08             	shl    $0x8,%ecx
f0102801:	01 c8                	add    %ecx,%eax
f0102803:	89 c1                	mov    %eax,%ecx
f0102805:	c1 e1 10             	shl    $0x10,%ecx
f0102808:	01 c8                	add    %ecx,%eax
f010280a:	8d 04 42             	lea    (%edx,%eax,2),%eax
f010280d:	89 c2                	mov    %eax,%edx
f010280f:	c1 e2 0c             	shl    $0xc,%edx
	return KADDR(page2pa(pp));
f0102812:	89 d0                	mov    %edx,%eax
f0102814:	c1 e8 0c             	shr    $0xc,%eax
f0102817:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f010281d:	72 12                	jb     f0102831 <page_check+0xbe4>
f010281f:	52                   	push   %edx
f0102820:	68 ac 62 10 f0       	push   $0xf01062ac
f0102825:	6a 5b                	push   $0x5b
f0102827:	68 76 5f 10 f0       	push   $0xf0105f76
f010282c:	e8 b8 d8 ff ff       	call   f01000e9 <_panic>
f0102831:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f0102837:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
	ptep = page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f010283a:	ba 00 00 00 00       	mov    $0x0,%edx
		assert((ptep[i] & PTE_P) == 0);
f010283f:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f0102842:	f6 04 90 01          	testb  $0x1,(%eax,%edx,4)
f0102846:	74 19                	je     f0102861 <page_check+0xc14>
f0102848:	68 b3 69 10 f0       	push   $0xf01069b3
f010284d:	68 44 68 10 f0       	push   $0xf0106844
f0102852:	68 f1 03 00 00       	push   $0x3f1
f0102857:	68 22 68 10 f0       	push   $0xf0106822
f010285c:	e8 88 d8 ff ff       	call   f01000e9 <_panic>
f0102861:	42                   	inc    %edx
f0102862:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
f0102868:	7e d5                	jle    f010283f <page_check+0xbf2>
	boot_pgdir[0] = 0;
f010286a:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f010286f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102875:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f0102878:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)

	// give free list back
	page_free_list = fl;
f010287e:	89 35 b8 5b 2f f0    	mov    %esi,0xf02f5bb8

	// free the pages we took
	page_free(pp0);
f0102884:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f0102887:	e8 5f ef ff ff       	call   f01017eb <page_free>
	page_free(pp1);
f010288c:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f010288f:	e8 57 ef ff ff       	call   f01017eb <page_free>
	page_free(pp2);
f0102894:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0102897:	e8 4f ef ff ff       	call   f01017eb <page_free>
	
	cprintf("page_check() succeeded!\n");
f010289c:	68 ca 69 10 f0       	push   $0xf01069ca
f01028a1:	e8 1c 08 00 00       	call   f01030c2 <cprintf>
}
f01028a6:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f01028a9:	5b                   	pop    %ebx
f01028aa:	5e                   	pop    %esi
f01028ab:	c9                   	leave  
f01028ac:	c3                   	ret    
f01028ad:	00 00                	add    %al,(%eax)
	...

f01028b0 <envid2env>:
//   On error, sets *penv to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f01028b0:	55                   	push   %ebp
f01028b1:	89 e5                	mov    %esp,%ebp
f01028b3:	53                   	push   %ebx
f01028b4:	8b 55 08             	mov    0x8(%ebp),%edx
f01028b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f01028ba:	85 d2                	test   %edx,%edx
f01028bc:	75 0e                	jne    f01028cc <envid2env+0x1c>
		*env_store = curenv;
f01028be:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f01028c3:	89 03                	mov    %eax,(%ebx)
		return 0;
f01028c5:	b8 00 00 00 00       	mov    $0x0,%eax
f01028ca:	eb 5c                	jmp    f0102928 <envid2env+0x78>
	}

	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f01028cc:	89 d1                	mov    %edx,%ecx
f01028ce:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
f01028d4:	89 c8                	mov    %ecx,%eax
f01028d6:	c1 e0 07             	shl    $0x7,%eax
f01028d9:	89 c1                	mov    %eax,%ecx
f01028db:	03 0d c0 5b 2f f0    	add    0xf02f5bc0,%ecx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f01028e1:	83 79 54 00          	cmpl   $0x0,0x54(%ecx)
f01028e5:	74 05                	je     f01028ec <envid2env+0x3c>
f01028e7:	39 51 4c             	cmp    %edx,0x4c(%ecx)
f01028ea:	74 0d                	je     f01028f9 <envid2env+0x49>
		*env_store = 0;
f01028ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return -E_BAD_ENV;
f01028f2:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01028f7:	eb 2f                	jmp    f0102928 <envid2env+0x78>
	}

	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01028f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01028fd:	74 22                	je     f0102921 <envid2env+0x71>
f01028ff:	3b 0d c4 5b 2f f0    	cmp    0xf02f5bc4,%ecx
f0102905:	74 1a                	je     f0102921 <envid2env+0x71>
f0102907:	8b 51 50             	mov    0x50(%ecx),%edx
f010290a:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f010290f:	3b 50 4c             	cmp    0x4c(%eax),%edx
f0102912:	74 0d                	je     f0102921 <envid2env+0x71>
		*env_store = 0;
f0102914:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return -E_BAD_ENV;
f010291a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010291f:	eb 07                	jmp    f0102928 <envid2env+0x78>
	}

	*env_store = e;
f0102921:	89 0b                	mov    %ecx,(%ebx)
	return 0;
f0102923:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0102928:	5b                   	pop    %ebx
f0102929:	c9                   	leave  
f010292a:	c3                   	ret    

f010292b <env_init>:

//
// Mark all environments in 'envs' as free, set their env_ids to 0,
// and insert them into the env_free_list.
// Insert in reverse order, so that the first call to env_alloc()
// returns envs[0].
//
void
env_init(void)
{
f010292b:	55                   	push   %ebp
f010292c:	89 e5                	mov    %esp,%ebp
f010292e:	53                   	push   %ebx
  // LAB 3: Your code here.
  // seanyliu
  int i;
  LIST_INIT(&env_free_list);
f010292f:	c7 05 c8 5b 2f f0 00 	movl   $0x0,0xf02f5bc8
f0102936:	00 00 00 

  // Insert in reverse order, so that the first call to env_alloc()
  for (i = NENV-1; i >= 0; i--) {
f0102939:	bb ff 03 00 00       	mov    $0x3ff,%ebx
    envs[i].env_status = ENV_FREE;
f010293e:	89 d9                	mov    %ebx,%ecx
f0102940:	c1 e1 07             	shl    $0x7,%ecx
f0102943:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f0102948:	c7 44 01 54 00 00 00 	movl   $0x0,0x54(%ecx,%eax,1)
f010294f:	00 
    envs[i].env_id = 0;
f0102950:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f0102955:	c7 44 01 4c 00 00 00 	movl   $0x0,0x4c(%ecx,%eax,1)
f010295c:	00 
    LIST_INSERT_HEAD(&env_free_list, &envs[i], env_link);
f010295d:	8b 15 c8 5b 2f f0    	mov    0xf02f5bc8,%edx
f0102963:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f0102968:	89 54 01 44          	mov    %edx,0x44(%ecx,%eax,1)
f010296c:	85 d2                	test   %edx,%edx
f010296e:	74 14                	je     f0102984 <env_init+0x59>
f0102970:	89 c8                	mov    %ecx,%eax
f0102972:	03 05 c0 5b 2f f0    	add    0xf02f5bc0,%eax
f0102978:	83 c0 44             	add    $0x44,%eax
f010297b:	8b 15 c8 5b 2f f0    	mov    0xf02f5bc8,%edx
f0102981:	89 42 48             	mov    %eax,0x48(%edx)
f0102984:	89 d9                	mov    %ebx,%ecx
f0102986:	c1 e1 07             	shl    $0x7,%ecx
f0102989:	8b 15 c0 5b 2f f0    	mov    0xf02f5bc0,%edx
f010298f:	8d 04 11             	lea    (%ecx,%edx,1),%eax
f0102992:	a3 c8 5b 2f f0       	mov    %eax,0xf02f5bc8
f0102997:	c7 44 11 48 c8 5b 2f 	movl   $0xf02f5bc8,0x48(%ecx,%edx,1)
f010299e:	f0 
f010299f:	4b                   	dec    %ebx
f01029a0:	79 9c                	jns    f010293e <env_init+0x13>
  }

}
f01029a2:	5b                   	pop    %ebx
f01029a3:	c9                   	leave  
f01029a4:	c3                   	ret    

f01029a5 <env_setup_vm>:

//
// Initialize the kernel virtual memory layout for environment e.
// Allocate a page directory, set e->env_pgdir and e->env_cr3 accordingly,
// and initialize the kernel portion of the new environment's address space.
// Do NOT (yet) map anything into the user portion
// of the environment's virtual address space.
//
// Returns 0 on success, < 0 on error.  Errors include:
//	-E_NO_MEM if page directory or table could not be allocated.
//
static int
env_setup_vm(struct Env *e)
{
f01029a5:	55                   	push   %ebp
f01029a6:	89 e5                	mov    %esp,%ebp
f01029a8:	56                   	push   %esi
f01029a9:	53                   	push   %ebx
f01029aa:	83 ec 1c             	sub    $0x1c,%esp
f01029ad:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;
	struct Page *p = NULL;
f01029b0:	c7 45 f4 00 00 00 00 	movl   $0x0,0xfffffff4(%ebp)

	// Allocate a page for the page directory
	if ((r = page_alloc(&p)) < 0)
f01029b7:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f01029ba:	50                   	push   %eax
f01029bb:	e8 e6 ed ff ff       	call   f01017a6 <page_alloc>
f01029c0:	83 c4 10             	add    $0x10,%esp
		return r;
f01029c3:	89 c2                	mov    %eax,%edx
f01029c5:	85 c0                	test   %eax,%eax
f01029c7:	0f 88 da 00 00 00    	js     f0102aa7 <env_setup_vm+0x102>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f01029cd:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f01029d0:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f01029d6:	c1 fa 02             	sar    $0x2,%edx
f01029d9:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01029dc:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01029df:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01029e2:	89 c1                	mov    %eax,%ecx
f01029e4:	c1 e1 08             	shl    $0x8,%ecx
f01029e7:	01 c8                	add    %ecx,%eax
f01029e9:	89 c1                	mov    %eax,%ecx
f01029eb:	c1 e1 10             	shl    $0x10,%ecx
f01029ee:	01 c8                	add    %ecx,%eax
f01029f0:	8d 04 42             	lea    (%edx,%eax,2),%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01029f3:	89 c2                	mov    %eax,%edx
f01029f5:	c1 e2 0c             	shl    $0xc,%edx
	return page2ppn(pp) << PGSHIFT;
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
		panic("pa2page called with invalid pa");
	return &pages[PPN(pa)];
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f01029f8:	89 d0                	mov    %edx,%eax
f01029fa:	c1 e8 0c             	shr    $0xc,%eax
f01029fd:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102a03:	72 12                	jb     f0102a17 <env_setup_vm+0x72>
f0102a05:	52                   	push   %edx
f0102a06:	68 ac 62 10 f0       	push   $0xf01062ac
f0102a0b:	6a 5b                	push   $0x5b
f0102a0d:	68 76 5f 10 f0       	push   $0xf0105f76
f0102a12:	e8 d2 d6 ff ff       	call   f01000e9 <_panic>
f0102a17:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f0102a1d:	89 46 5c             	mov    %eax,0x5c(%esi)
f0102a20:	8b 5d f4             	mov    0xfffffff4(%ebp),%ebx
f0102a23:	89 da                	mov    %ebx,%edx
f0102a25:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0102a2b:	c1 fa 02             	sar    $0x2,%edx
f0102a2e:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0102a31:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102a34:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102a37:	89 c1                	mov    %eax,%ecx
f0102a39:	c1 e1 08             	shl    $0x8,%ecx
f0102a3c:	01 c8                	add    %ecx,%eax
f0102a3e:	89 c1                	mov    %eax,%ecx
f0102a40:	c1 e1 10             	shl    $0x10,%ecx
f0102a43:	01 c8                	add    %ecx,%eax
f0102a45:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0102a48:	c1 e0 0c             	shl    $0xc,%eax
f0102a4b:	89 46 60             	mov    %eax,0x60(%esi)

	// Now, set e->env_pgdir and e->env_cr3,
	// and initialize the page directory.
	//
	// Hint:
	//    - Remember that page_alloc doesn't zero the page.
	//    - The VA space of all envs is identical above UTOP
	//	(except at VPT and UVPT, which we've set below).
	//	See inc/memlayout.h for permissions and layout.
	//	Can you use boot_pgdir as a template?  Hint: Yes.
	//	(Make sure you got the permissions right in Lab 2.)
	//    - The initial VA below UTOP is empty.
	//    - You do not need to make any more calls to page_alloc.
	//    - Note: In general, pp_ref is not maintained for
	//	physical pages mapped only above UTOP, but env_pgdir
	//	is an exception -- you need to increment env_pgdir's
	//	pp_ref for env_free to work correctly.

	// LAB 3: Your code here.
        // seanyliu
	// Now, set e->env_pgdir and e->env_cr3,
	// and initialize the page directory.
        e->env_pgdir = page2kva(p);
        e->env_cr3 = page2pa(p);

	// is an exception -- you need to increment env_pgdir's
	// pp_ref for env_free to work correctly.
        p->pp_ref++;
f0102a4e:	66 ff 43 08          	incw   0x8(%ebx)

	// The VA space of all envs is identical above UTOP
	// (except at VPT and UVPT, which we've set below).
	// See inc/memlayout.h for permissions and layout.
	// Can you use boot_pgdir as a template?  Hint: Yes.
	// (Make sure you got the permissions right in Lab 2.)
        memset(e->env_pgdir, 0, PGSIZE);
f0102a52:	83 ec 04             	sub    $0x4,%esp
f0102a55:	68 00 10 00 00       	push   $0x1000
f0102a5a:	6a 00                	push   $0x0
f0102a5c:	ff 76 5c             	pushl  0x5c(%esi)
f0102a5f:	e8 2d 22 00 00       	call   f0104c91 <memset>

        // note that you cannot di i=UTOP;i<npaage*PGSIZE;i++ and then PDX(i);
        // PDX indexes into the page dir, whereas npage*pgsize refernces a
        // physical page.
        //for (i = PDX(UTOP); i < npage; i++) {
        for (i = PDX(UTOP); i < NPDENTRIES; i++) { // arkajit hint
f0102a64:	b9 bb 03 00 00       	mov    $0x3bb,%ecx
f0102a69:	83 c4 10             	add    $0x10,%esp
          e->env_pgdir[i] = boot_pgdir[i];
f0102a6c:	8b 46 5c             	mov    0x5c(%esi),%eax
f0102a6f:	8b 15 78 68 2f f0    	mov    0xf02f6878,%edx
f0102a75:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
f0102a78:	89 14 88             	mov    %edx,(%eax,%ecx,4)
f0102a7b:	41                   	inc    %ecx
f0102a7c:	81 f9 ff 03 00 00    	cmp    $0x3ff,%ecx
f0102a82:	7e e8                	jle    f0102a6c <env_setup_vm+0xc7>
        }

	// VPT and UVPT map the env's own page table, with
	// different permissions.
	e->env_pgdir[PDX(VPT)]  = e->env_cr3 | PTE_P | PTE_W;
f0102a84:	8b 56 5c             	mov    0x5c(%esi),%edx
f0102a87:	8b 46 60             	mov    0x60(%esi),%eax
f0102a8a:	83 c8 03             	or     $0x3,%eax
f0102a8d:	89 82 fc 0e 00 00    	mov    %eax,0xefc(%edx)
	e->env_pgdir[PDX(UVPT)] = e->env_cr3 | PTE_P | PTE_U;
f0102a93:	8b 56 5c             	mov    0x5c(%esi),%edx
f0102a96:	8b 46 60             	mov    0x60(%esi),%eax
f0102a99:	83 c8 05             	or     $0x5,%eax
f0102a9c:	89 82 f4 0e 00 00    	mov    %eax,0xef4(%edx)

	return 0;
f0102aa2:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0102aa7:	89 d0                	mov    %edx,%eax
f0102aa9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0102aac:	5b                   	pop    %ebx
f0102aad:	5e                   	pop    %esi
f0102aae:	c9                   	leave  
f0102aaf:	c3                   	ret    

f0102ab0 <env_alloc>:

//
// Allocates and initializes a new environment.
// On success, the new environment is stored in *newenv_store.
//
// Returns 0 on success, < 0 on failure.  Errors include:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0102ab0:	55                   	push   %ebp
f0102ab1:	89 e5                	mov    %esp,%ebp
f0102ab3:	53                   	push   %ebx
f0102ab4:	83 ec 04             	sub    $0x4,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = LIST_FIRST(&env_free_list)))
f0102ab7:	8b 1d c8 5b 2f f0    	mov    0xf02f5bc8,%ebx
		return -E_NO_FREE_ENV;
f0102abd:	ba fb ff ff ff       	mov    $0xfffffffb,%edx
f0102ac2:	85 db                	test   %ebx,%ebx
f0102ac4:	0f 84 cd 00 00 00    	je     f0102b97 <env_alloc+0xe7>

	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
f0102aca:	83 ec 0c             	sub    $0xc,%esp
f0102acd:	53                   	push   %ebx
f0102ace:	e8 d2 fe ff ff       	call   f01029a5 <env_setup_vm>
f0102ad3:	83 c4 10             	add    $0x10,%esp
		return r;
f0102ad6:	89 c2                	mov    %eax,%edx
f0102ad8:	85 c0                	test   %eax,%eax
f0102ada:	0f 88 b7 00 00 00    	js     f0102b97 <env_alloc+0xe7>

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0102ae0:	8b 53 4c             	mov    0x4c(%ebx),%edx
f0102ae3:	81 c2 00 10 00 00    	add    $0x1000,%edx
	if (generation <= 0)	// Don't create a negative env_id.
f0102ae9:	81 e2 00 fc ff ff    	and    $0xfffffc00,%edx
f0102aef:	7f 05                	jg     f0102af6 <env_alloc+0x46>
		generation = 1 << ENVGENSHIFT;
f0102af1:	ba 00 10 00 00       	mov    $0x1000,%edx
	e->env_id = generation | (e - envs);
f0102af6:	89 d8                	mov    %ebx,%eax
f0102af8:	2b 05 c0 5b 2f f0    	sub    0xf02f5bc0,%eax
f0102afe:	c1 f8 07             	sar    $0x7,%eax
f0102b01:	09 d0                	or     %edx,%eax
f0102b03:	89 43 4c             	mov    %eax,0x4c(%ebx)
	
	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0102b06:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102b09:	89 43 50             	mov    %eax,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0102b0c:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
	e->env_runs = 0;
f0102b13:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0102b1a:	83 ec 04             	sub    $0x4,%esp
f0102b1d:	6a 44                	push   $0x44
f0102b1f:	6a 00                	push   $0x0
f0102b21:	53                   	push   %ebx
f0102b22:	e8 6a 21 00 00       	call   f0104c91 <memset>

	// Set up appropriate initial values for the segment registers.
	// GD_UD is the user data segment selector in the GDT, and 
	// GD_UT is the user text segment selector (see inc/memlayout.h).
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.
	e->env_tf.tf_ds = GD_UD | 3;
f0102b27:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0102b2d:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0102b33:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0102b39:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0102b40:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
        e->env_tf.tf_eflags |= FL_IF;
f0102b46:	8b 53 38             	mov    0x38(%ebx),%edx
f0102b49:	89 d0                	mov    %edx,%eax
f0102b4b:	80 cc 02             	or     $0x2,%ah
f0102b4e:	89 43 38             	mov    %eax,0x38(%ebx)

	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0102b51:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0102b58:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

	// If this is the file server (e == &envs[1]) give it I/O privileges.
	// LAB 5: Your code here.
        // seanyliu
        if (e == &envs[1]) {
f0102b5f:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f0102b64:	83 e8 80             	sub    $0xffffff80,%eax
f0102b67:	83 c4 10             	add    $0x10,%esp
f0102b6a:	39 d8                	cmp    %ebx,%eax
f0102b6c:	75 08                	jne    f0102b76 <env_alloc+0xc6>
          e->env_tf.tf_eflags |= FL_IOPL_3;
f0102b6e:	89 d0                	mov    %edx,%eax
f0102b70:	80 cc 32             	or     $0x32,%ah
f0102b73:	89 43 38             	mov    %eax,0x38(%ebx)
        }

	// commit the allocation
	LIST_REMOVE(e, env_link);
f0102b76:	83 7b 44 00          	cmpl   $0x0,0x44(%ebx)
f0102b7a:	74 09                	je     f0102b85 <env_alloc+0xd5>
f0102b7c:	8b 53 44             	mov    0x44(%ebx),%edx
f0102b7f:	8b 43 48             	mov    0x48(%ebx),%eax
f0102b82:	89 42 48             	mov    %eax,0x48(%edx)
f0102b85:	8b 53 48             	mov    0x48(%ebx),%edx
f0102b88:	8b 43 44             	mov    0x44(%ebx),%eax
f0102b8b:	89 02                	mov    %eax,(%edx)
	*newenv_store = e;
f0102b8d:	8b 45 08             	mov    0x8(%ebp),%eax
f0102b90:	89 18                	mov    %ebx,(%eax)

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
f0102b92:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0102b97:	89 d0                	mov    %edx,%eax
f0102b99:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0102b9c:	c9                   	leave  
f0102b9d:	c3                   	ret    

f0102b9e <segment_alloc>:

//
// Allocate len bytes of physical memory for environment env,
// and map it at virtual address va in the environment's address space.
// Does not zero or otherwise initialize the mapped pages in any way.
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
segment_alloc(struct Env *e, void *va, size_t len)
{
f0102b9e:	55                   	push   %ebp
f0102b9f:	89 e5                	mov    %esp,%ebp
f0102ba1:	57                   	push   %edi
f0102ba2:	56                   	push   %esi
f0102ba3:	53                   	push   %ebx
f0102ba4:	83 ec 0c             	sub    $0xc,%esp
f0102ba7:	8b 7d 08             	mov    0x8(%ebp),%edi
f0102baa:	8b 45 0c             	mov    0xc(%ebp),%eax
	// LAB 3: Your code here.
	// (But only if you need it for load_icode.)
	//
	// Hint: It is easier to use segment_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round len up.

        // seanyliu

        // Weird error.  Say VA is below the end of a page.  Len is less than
        // a page, but more than a page boundary.  So we'd only map 1 page, but
        // need 2!

	// Allocate a page for the environment env
        int pidx;
        int r;
        struct Page *pp;
        void* va_round = ROUNDDOWN(va, PGSIZE);
        size_t len_round = ROUNDUP(len, PGSIZE);
        int end = (int)va + len;
f0102bad:	89 c6                	mov    %eax,%esi
f0102baf:	03 75 10             	add    0x10(%ebp),%esi
        for (pidx = (int)va_round; pidx < end; pidx += PGSIZE) {
f0102bb2:	89 c3                	mov    %eax,%ebx
f0102bb4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0102bba:	39 f3                	cmp    %esi,%ebx
f0102bbc:	7d 5c                	jge    f0102c1a <segment_alloc+0x7c>
	  if ((r = page_alloc(&pp)) < 0) {
f0102bbe:	83 ec 0c             	sub    $0xc,%esp
f0102bc1:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0102bc4:	50                   	push   %eax
f0102bc5:	e8 dc eb ff ff       	call   f01017a6 <page_alloc>
f0102bca:	83 c4 10             	add    $0x10,%esp
f0102bcd:	85 c0                	test   %eax,%eax
f0102bcf:	79 15                	jns    f0102be6 <segment_alloc+0x48>
            panic("segment_alloc: %e page_alloc failed", r);
f0102bd1:	50                   	push   %eax
f0102bd2:	68 e4 69 10 f0       	push   $0xf01069e4
f0102bd7:	68 0c 01 00 00       	push   $0x10c
f0102bdc:	68 78 6a 10 f0       	push   $0xf0106a78
f0102be1:	e8 03 d5 ff ff       	call   f01000e9 <_panic>
          } else if ((r = page_insert(e->env_pgdir, pp, (void*)pidx, PTE_W | PTE_U )) != 0) {
f0102be6:	6a 06                	push   $0x6
f0102be8:	53                   	push   %ebx
f0102be9:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0102bec:	ff 77 5c             	pushl  0x5c(%edi)
f0102bef:	e8 69 ed ff ff       	call   f010195d <page_insert>
f0102bf4:	83 c4 10             	add    $0x10,%esp
f0102bf7:	85 c0                	test   %eax,%eax
f0102bf9:	74 15                	je     f0102c10 <segment_alloc+0x72>
            panic("segment_alloc: %e page_insert failed", r);
f0102bfb:	50                   	push   %eax
f0102bfc:	68 08 6a 10 f0       	push   $0xf0106a08
f0102c01:	68 0e 01 00 00       	push   $0x10e
f0102c06:	68 78 6a 10 f0       	push   $0xf0106a78
f0102c0b:	e8 d9 d4 ff ff       	call   f01000e9 <_panic>
f0102c10:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102c16:	39 f3                	cmp    %esi,%ebx
f0102c18:	7c a4                	jl     f0102bbe <segment_alloc+0x20>
          }
        }

}
f0102c1a:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0102c1d:	5b                   	pop    %ebx
f0102c1e:	5e                   	pop    %esi
f0102c1f:	5f                   	pop    %edi
f0102c20:	c9                   	leave  
f0102c21:	c3                   	ret    

f0102c22 <load_icode>:

//
// Set up the initial program binary, stack, and processor flags
// for a user process.
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
//
// This function loads all loadable segments from the ELF binary image
// into the environment's user memory, starting at the appropriate
// virtual addresses indicated in the ELF program header.
// At the same time it clears to zero any portions of these segments
// that are marked in the program header as being mapped
// but not actually present in the ELF file - i.e., the program's bss section.
//
// All this is very similar to what our boot loader does, except the boot
// loader also needs to read the code from disk.  Take a look at
// boot/main.c to get ideas.
//
// Finally, this function maps one page for the program's initial stack.
//
// load_icode panics if it encounters problems.
//  - How might load_icode fail?  What might be wrong with the given input?
//
static void
load_icode(struct Env *e, uint8_t *binary, size_t size)
{
f0102c22:	55                   	push   %ebp
f0102c23:	89 e5                	mov    %esp,%ebp
f0102c25:	57                   	push   %edi
f0102c26:	56                   	push   %esi
f0102c27:	53                   	push   %ebx
f0102c28:	83 ec 0c             	sub    $0xc,%esp
f0102c2b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// Hints: 
	//  Load each program segment into virtual memory
	//  at the address specified in the ELF section header.
	//  You should only load segments with ph->p_type == ELF_PROG_LOAD.
	//  Each segment's virtual address can be found in ph->p_va
	//  and its size in memory can be found in ph->p_memsz.
	//  The ph->p_filesz bytes from the ELF binary, starting at
	//  'binary + ph->p_offset', should be copied to virtual address
	//  ph->p_va.  Any remaining memory bytes should be cleared to zero.
	//  (The ELF header should have ph->p_filesz <= ph->p_memsz.)
	//  Use functions from the previous lab to allocate and map pages.
	//
	//  All page protection bits should be user read/write for now.
	//  ELF segments are not necessarily page-aligned, but you can
	//  assume for this function that no two segments will touch
	//  the same virtual page.
	//
	//  You may find a function like segment_alloc useful.
	//
	//  Loading the segments is much simpler if you can move data
	//  directly into the virtual addresses stored in the ELF binary.
	//  So which page directory should be in force during
	//  this function?
	//
	// Hint:
	//  You must also do something with the program's entry point,
	//  to make sure that the environment starts executing there.
	//  What?  (See env_run() and env_pop_tf() below.)

	// LAB 3: Your code here.

        // seanyliu
        int r;

	//  Load each program segment into virtual memory
	//  at the address specified in the ELF section header.
	//  You should only load segments with ph->p_type == ELF_PROG_LOAD.
	//  Each segment's virtual address can be found in ph->p_va
	//  and its size in memory can be found in ph->p_memsz.
	//  The ph->p_filesz bytes from the ELF binary, starting at
	//  'binary + ph->p_offset', should be copied to virtual address
	//  ph->p_va.  Any remaining memory bytes should be cleared to zero.
	//  (The ELF header should have ph->p_filesz <= ph->p_memsz.)
	//  Use functions from the previous lab to allocate and map pages.
        struct Proghdr *ph, *eph;
        ph = (struct Proghdr *) (binary + ((struct Elf *)binary)->e_phoff);
f0102c2e:	89 fb                	mov    %edi,%ebx
f0102c30:	03 5f 1c             	add    0x1c(%edi),%ebx
        eph = ph + ((struct Elf *)binary)->e_phnum;
f0102c33:	0f b7 77 2c          	movzwl 0x2c(%edi),%esi
f0102c37:	89 f0                	mov    %esi,%eax
f0102c39:	c1 e0 05             	shl    $0x5,%eax
f0102c3c:	8d 34 18             	lea    (%eax,%ebx,1),%esi
}

static __inline void
lcr3(uint32_t val)
{
f0102c3f:	8b 55 08             	mov    0x8(%ebp),%edx
f0102c42:	8b 42 60             	mov    0x60(%edx),%eax
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0102c45:	0f 22 d8             	mov    %eax,%cr3

        // note that we have to copy the ELF header into env's address space
        // but memcpy will default to copying in the current kernel address space.
        // therefore, we should first load in the environment user space.
        // this is okay, because all the environments have the kernel mapped!
        lcr3(e->env_cr3);

        // SEAN ADD: check if ELF_MAGIC ((struct Elf *)binary)->...)
	//  (The ELF header should have ph->p_filesz <= ph->p_memsz.)

        for (; ph < eph; ph++) {
f0102c48:	39 f3                	cmp    %esi,%ebx
f0102c4a:	73 4b                	jae    f0102c97 <load_icode+0x75>
	  //  You should only load segments with ph->p_type == ELF_PROG_LOAD.
          if (ph->p_type == ELF_PROG_LOAD) {
f0102c4c:	83 3b 01             	cmpl   $0x1,(%ebx)
f0102c4f:	75 3f                	jne    f0102c90 <load_icode+0x6e>
            segment_alloc(e, (void *) ph->p_va, ph->p_memsz);
f0102c51:	83 ec 04             	sub    $0x4,%esp
f0102c54:	ff 73 14             	pushl  0x14(%ebx)
f0102c57:	ff 73 08             	pushl  0x8(%ebx)
f0102c5a:	ff 75 08             	pushl  0x8(%ebp)
f0102c5d:	e8 3c ff ff ff       	call   f0102b9e <segment_alloc>
            memmove((void *)ph->p_va, binary + ph->p_offset, ph->p_filesz);
f0102c62:	83 c4 0c             	add    $0xc,%esp
f0102c65:	ff 73 10             	pushl  0x10(%ebx)
f0102c68:	89 f8                	mov    %edi,%eax
f0102c6a:	03 43 04             	add    0x4(%ebx),%eax
f0102c6d:	50                   	push   %eax
f0102c6e:	ff 73 08             	pushl  0x8(%ebx)
f0102c71:	e8 6e 20 00 00       	call   f0104ce4 <memmove>
            memset((void *)ph->p_va + ph->p_filesz, 0, ph->p_memsz - ph->p_filesz);
f0102c76:	83 c4 0c             	add    $0xc,%esp
f0102c79:	8b 53 10             	mov    0x10(%ebx),%edx
f0102c7c:	8b 43 14             	mov    0x14(%ebx),%eax
f0102c7f:	29 d0                	sub    %edx,%eax
f0102c81:	50                   	push   %eax
f0102c82:	6a 00                	push   $0x0
f0102c84:	03 53 08             	add    0x8(%ebx),%edx
f0102c87:	52                   	push   %edx
f0102c88:	e8 04 20 00 00       	call   f0104c91 <memset>
f0102c8d:	83 c4 10             	add    $0x10,%esp
f0102c90:	83 c3 20             	add    $0x20,%ebx
f0102c93:	39 f3                	cmp    %esi,%ebx
f0102c95:	72 b5                	jb     f0102c4c <load_icode+0x2a>
          }
        }

	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.

	// LAB 3: Your code here.
        struct Page *init_stack;
        if ((r = page_alloc(&init_stack)) < 0) panic("load_icode: %e failed to page_alloc", r);
f0102c97:	83 ec 0c             	sub    $0xc,%esp
f0102c9a:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0102c9d:	50                   	push   %eax
f0102c9e:	e8 03 eb ff ff       	call   f01017a6 <page_alloc>
f0102ca3:	83 c4 10             	add    $0x10,%esp
f0102ca6:	85 c0                	test   %eax,%eax
f0102ca8:	79 15                	jns    f0102cbf <load_icode+0x9d>
f0102caa:	50                   	push   %eax
f0102cab:	68 30 6a 10 f0       	push   $0xf0106a30
f0102cb0:	68 74 01 00 00       	push   $0x174
f0102cb5:	68 78 6a 10 f0       	push   $0xf0106a78
f0102cba:	e8 2a d4 ff ff       	call   f01000e9 <_panic>
        page_insert(e->env_pgdir, init_stack, (void *)(USTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P);
f0102cbf:	6a 07                	push   $0x7
f0102cc1:	68 00 d0 bf ee       	push   $0xeebfd000
f0102cc6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0102cc9:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ccc:	ff 70 5c             	pushl  0x5c(%eax)
f0102ccf:	e8 89 ec ff ff       	call   f010195d <page_insert>

        e->env_tf.tf_eip = ((struct Elf *)binary)->e_entry;
f0102cd4:	8b 47 18             	mov    0x18(%edi),%eax
f0102cd7:	8b 55 08             	mov    0x8(%ebp),%edx
f0102cda:	89 42 30             	mov    %eax,0x30(%edx)
}
f0102cdd:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0102ce0:	5b                   	pop    %ebx
f0102ce1:	5e                   	pop    %esi
f0102ce2:	5f                   	pop    %edi
f0102ce3:	c9                   	leave  
f0102ce4:	c3                   	ret    

f0102ce5 <env_create>:

//
// Allocates a new env and loads the named elf binary into it.
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, size_t size)
{
f0102ce5:	55                   	push   %ebp
f0102ce6:	89 e5                	mov    %esp,%ebp
f0102ce8:	83 ec 10             	sub    $0x10,%esp
	// LAB 3: Your code here.
        // seanyliu
        struct Env *e_store;
        int r;
        if ((r = env_alloc(&e_store, 0)) < 0) {
f0102ceb:	6a 00                	push   $0x0
f0102ced:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f0102cf0:	50                   	push   %eax
f0102cf1:	e8 ba fd ff ff       	call   f0102ab0 <env_alloc>
f0102cf6:	83 c4 10             	add    $0x10,%esp
f0102cf9:	85 c0                	test   %eax,%eax
f0102cfb:	79 15                	jns    f0102d12 <env_create+0x2d>
          panic("segment_alloc: %e env_create failed", r);
f0102cfd:	50                   	push   %eax
f0102cfe:	68 54 6a 10 f0       	push   $0xf0106a54
f0102d03:	68 88 01 00 00       	push   $0x188
f0102d08:	68 78 6a 10 f0       	push   $0xf0106a78
f0102d0d:	e8 d7 d3 ff ff       	call   f01000e9 <_panic>
        }

        load_icode(e_store, binary, size);
f0102d12:	83 ec 04             	sub    $0x4,%esp
f0102d15:	ff 75 0c             	pushl  0xc(%ebp)
f0102d18:	ff 75 08             	pushl  0x8(%ebp)
f0102d1b:	ff 75 fc             	pushl  0xfffffffc(%ebp)
f0102d1e:	e8 ff fe ff ff       	call   f0102c22 <load_icode>

        // this is automatically done by env_alloc
        // envs[0] = *e_store;
}
f0102d23:	c9                   	leave  
f0102d24:	c3                   	ret    

f0102d25 <env_free>:

//
// Frees env e and all memory it uses.
// 
void
env_free(struct Env *e)
{
f0102d25:	55                   	push   %ebp
f0102d26:	89 e5                	mov    %esp,%ebp
f0102d28:	57                   	push   %edi
f0102d29:	56                   	push   %esi
f0102d2a:	53                   	push   %ebx
f0102d2b:	83 ec 0c             	sub    $0xc,%esp
	pte_t *pt;
	uint32_t pdeno, pteno;
	physaddr_t pa;
	
	// If freeing the current environment, switch to boot_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0102d2e:	8b 45 08             	mov    0x8(%ebp),%eax
f0102d31:	3b 05 c4 5b 2f f0    	cmp    0xf02f5bc4,%eax
f0102d37:	75 08                	jne    f0102d41 <env_free+0x1c>
}

static __inline void
lcr3(uint32_t val)
{
f0102d39:	a1 74 68 2f f0       	mov    0xf02f6874,%eax
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0102d3e:	0f 22 d8             	mov    %eax,%cr3
		lcr3(boot_cr3);

	// Note the environment's demise.
	// cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0102d41:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0102d48:	8b 55 08             	mov    0x8(%ebp),%edx
f0102d4b:	8b 42 5c             	mov    0x5c(%edx),%eax
f0102d4e:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
f0102d51:	8b 04 90             	mov    (%eax,%edx,4),%eax
f0102d54:	a8 01                	test   $0x1,%al
f0102d56:	0f 84 b3 00 00 00    	je     f0102e0f <env_free+0xea>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0102d5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102d61:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
		pt = (pte_t*) KADDR(pa);
f0102d64:	89 c2                	mov    %eax,%edx
f0102d66:	c1 e8 0c             	shr    $0xc,%eax
f0102d69:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102d6f:	72 15                	jb     f0102d86 <env_free+0x61>
f0102d71:	52                   	push   %edx
f0102d72:	68 ac 62 10 f0       	push   $0xf01062ac
f0102d77:	68 ae 01 00 00       	push   $0x1ae
f0102d7c:	68 78 6a 10 f0       	push   $0xf0106a78
f0102d81:	e8 63 d3 ff ff       	call   f01000e9 <_panic>
f0102d86:	8d b2 00 00 00 f0    	lea    0xf0000000(%edx),%esi

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0102d8c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102d91:	8b 7d f0             	mov    0xfffffff0(%ebp),%edi
f0102d94:	c1 e7 16             	shl    $0x16,%edi
			if (pt[pteno] & PTE_P)
f0102d97:	f6 04 9e 01          	testb  $0x1,(%esi,%ebx,4)
f0102d9b:	74 19                	je     f0102db6 <env_free+0x91>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0102d9d:	83 ec 08             	sub    $0x8,%esp
f0102da0:	89 d8                	mov    %ebx,%eax
f0102da2:	c1 e0 0c             	shl    $0xc,%eax
f0102da5:	09 f8                	or     %edi,%eax
f0102da7:	50                   	push   %eax
f0102da8:	8b 45 08             	mov    0x8(%ebp),%eax
f0102dab:	ff 70 5c             	pushl  0x5c(%eax)
f0102dae:	e8 71 ed ff ff       	call   f0101b24 <page_remove>
f0102db3:	83 c4 10             	add    $0x10,%esp
f0102db6:	43                   	inc    %ebx
f0102db7:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
f0102dbd:	76 d8                	jbe    f0102d97 <env_free+0x72>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0102dbf:	8b 55 08             	mov    0x8(%ebp),%edx
f0102dc2:	8b 42 5c             	mov    0x5c(%edx),%eax
f0102dc5:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
f0102dc8:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
f0102dcf:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
	if (PPN(pa) >= npage)
f0102dd2:	89 d0                	mov    %edx,%eax
f0102dd4:	c1 e8 0c             	shr    $0xc,%eax
f0102dd7:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102ddd:	72 14                	jb     f0102df3 <env_free+0xce>
		panic("pa2page called with invalid pa");
f0102ddf:	83 ec 04             	sub    $0x4,%esp
f0102de2:	68 b4 60 10 f0       	push   $0xf01060b4
f0102de7:	6a 54                	push   $0x54
f0102de9:	68 76 5f 10 f0       	push   $0xf0105f76
f0102dee:	e8 f6 d2 ff ff       	call   f01000e9 <_panic>
f0102df3:	89 d0                	mov    %edx,%eax
f0102df5:	c1 e8 0c             	shr    $0xc,%eax
f0102df8:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0102dfb:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0102e00:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0102e03:	83 ec 0c             	sub    $0xc,%esp
f0102e06:	50                   	push   %eax
f0102e07:	e8 07 ea ff ff       	call   f0101813 <page_decref>
f0102e0c:	83 c4 10             	add    $0x10,%esp
f0102e0f:	ff 45 f0             	incl   0xfffffff0(%ebp)
f0102e12:	81 7d f0 ba 03 00 00 	cmpl   $0x3ba,0xfffffff0(%ebp)
f0102e19:	0f 86 29 ff ff ff    	jbe    f0102d48 <env_free+0x23>
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = e->env_cr3;
f0102e1f:	8b 45 08             	mov    0x8(%ebp),%eax
f0102e22:	8b 40 60             	mov    0x60(%eax),%eax
	e->env_pgdir = 0;
f0102e25:	8b 55 08             	mov    0x8(%ebp),%edx
f0102e28:	c7 42 5c 00 00 00 00 	movl   $0x0,0x5c(%edx)
	e->env_cr3 = 0;
f0102e2f:	c7 42 60 00 00 00 00 	movl   $0x0,0x60(%edx)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
f0102e36:	89 c2                	mov    %eax,%edx
	if (PPN(pa) >= npage)
f0102e38:	c1 e8 0c             	shr    $0xc,%eax
f0102e3b:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102e41:	72 14                	jb     f0102e57 <env_free+0x132>
		panic("pa2page called with invalid pa");
f0102e43:	83 ec 04             	sub    $0x4,%esp
f0102e46:	68 b4 60 10 f0       	push   $0xf01060b4
f0102e4b:	6a 54                	push   $0x54
f0102e4d:	68 76 5f 10 f0       	push   $0xf0105f76
f0102e52:	e8 92 d2 ff ff       	call   f01000e9 <_panic>
f0102e57:	89 d0                	mov    %edx,%eax
f0102e59:	c1 e8 0c             	shr    $0xc,%eax
f0102e5c:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0102e5f:	8b 15 7c 68 2f f0    	mov    0xf02f687c,%edx
f0102e65:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102e68:	83 ec 0c             	sub    $0xc,%esp
f0102e6b:	50                   	push   %eax
f0102e6c:	e8 a2 e9 ff ff       	call   f0101813 <page_decref>
	page_decref(pa2page(pa));

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0102e71:	8b 45 08             	mov    0x8(%ebp),%eax
f0102e74:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	LIST_INSERT_HEAD(&env_free_list, e, env_link);
f0102e7b:	a1 c8 5b 2f f0       	mov    0xf02f5bc8,%eax
f0102e80:	8b 55 08             	mov    0x8(%ebp),%edx
f0102e83:	89 42 44             	mov    %eax,0x44(%edx)
f0102e86:	83 c4 10             	add    $0x10,%esp
f0102e89:	85 c0                	test   %eax,%eax
f0102e8b:	74 0e                	je     f0102e9b <env_free+0x176>
f0102e8d:	8b 55 08             	mov    0x8(%ebp),%edx
f0102e90:	83 c2 44             	add    $0x44,%edx
f0102e93:	a1 c8 5b 2f f0       	mov    0xf02f5bc8,%eax
f0102e98:	89 50 48             	mov    %edx,0x48(%eax)
f0102e9b:	8b 45 08             	mov    0x8(%ebp),%eax
f0102e9e:	a3 c8 5b 2f f0       	mov    %eax,0xf02f5bc8
f0102ea3:	c7 40 48 c8 5b 2f f0 	movl   $0xf02f5bc8,0x48(%eax)
}
f0102eaa:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0102ead:	5b                   	pop    %ebx
f0102eae:	5e                   	pop    %esi
f0102eaf:	5f                   	pop    %edi
f0102eb0:	c9                   	leave  
f0102eb1:	c3                   	ret    

f0102eb2 <env_destroy>:

//
// Frees environment e.
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e) 
{
f0102eb2:	55                   	push   %ebp
f0102eb3:	89 e5                	mov    %esp,%ebp
f0102eb5:	53                   	push   %ebx
f0102eb6:	83 ec 10             	sub    $0x10,%esp
f0102eb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	env_free(e);
f0102ebc:	53                   	push   %ebx
f0102ebd:	e8 63 fe ff ff       	call   f0102d25 <env_free>

	if (curenv == e) {
f0102ec2:	83 c4 10             	add    $0x10,%esp
f0102ec5:	39 1d c4 5b 2f f0    	cmp    %ebx,0xf02f5bc4
f0102ecb:	75 0f                	jne    f0102edc <env_destroy+0x2a>
		curenv = NULL;
f0102ecd:	c7 05 c4 5b 2f f0 00 	movl   $0x0,0xf02f5bc4
f0102ed4:	00 00 00 
		sched_yield();
f0102ed7:	e8 c0 08 00 00       	call   f010379c <sched_yield>
	}
}
f0102edc:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0102edf:	c9                   	leave  
f0102ee0:	c3                   	ret    

f0102ee1 <env_pop_tf>:


//
// Restores the register values in the Trapframe with the 'iret' instruction.
// This exits the kernel and starts executing some environment's code.
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0102ee1:	55                   	push   %ebp
f0102ee2:	89 e5                	mov    %esp,%ebp
f0102ee4:	83 ec 0c             	sub    $0xc,%esp
f0102ee7:	8b 45 08             	mov    0x8(%ebp),%eax
	__asm __volatile("movl %0,%%esp\n"
f0102eea:	89 c4                	mov    %eax,%esp
f0102eec:	61                   	popa   
f0102eed:	07                   	pop    %es
f0102eee:	1f                   	pop    %ds
f0102eef:	83 c4 08             	add    $0x8,%esp
f0102ef2:	cf                   	iret   
		"\tpopal\n"
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0102ef3:	68 83 6a 10 f0       	push   $0xf0106a83
f0102ef8:	68 e6 01 00 00       	push   $0x1e6
f0102efd:	68 78 6a 10 f0       	push   $0xf0106a78
f0102f02:	e8 e2 d1 ff ff       	call   f01000e9 <_panic>

f0102f07 <env_run>:
}

//
// Context switch from curenv to env e.
// Note: if this is the first call to env_run, curenv is NULL.
//  (This function does not return.)
//
void
env_run(struct Env *e)
{
f0102f07:	55                   	push   %ebp
f0102f08:	89 e5                	mov    %esp,%ebp
f0102f0a:	83 ec 14             	sub    $0x14,%esp
f0102f0d:	8b 45 08             	mov    0x8(%ebp),%eax
	// Step 1: If this is a context switch (a new environment is running),
	//	   then set 'curenv' to the new environment,
	//	   update its 'env_runs' counter, and
	//	   and use lcr3() to switch to its address space.
	// Step 2: Use env_pop_tf() to restore the environment's
	//	   registers and drop into user mode in the
	//	   environment.

	// Hint: This function loads the new environment's state from
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.
	
	// LAB 3: Your code here.

        // seanyliu
        // Step 1
        curenv = e;
f0102f10:	a3 c4 5b 2f f0       	mov    %eax,0xf02f5bc4
        curenv->env_runs++;
f0102f15:	ff 40 58             	incl   0x58(%eax)
}

static __inline void
lcr3(uint32_t val)
{
f0102f18:	8b 15 c4 5b 2f f0    	mov    0xf02f5bc4,%edx
f0102f1e:	8b 42 60             	mov    0x60(%edx),%eax
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0102f21:	0f 22 d8             	mov    %eax,%cr3
	lcr3(curenv->env_cr3);

        // Step 2
        env_pop_tf(&(curenv->env_tf));
f0102f24:	52                   	push   %edx
f0102f25:	e8 b7 ff ff ff       	call   f0102ee1 <env_pop_tf>
	...

f0102f2c <mc146818_read>:


unsigned
mc146818_read(unsigned reg)
{
f0102f2c:	55                   	push   %ebp
f0102f2d:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
f0102f2f:	ba 70 00 00 00       	mov    $0x70,%edx
f0102f34:	8a 45 08             	mov    0x8(%ebp),%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0102f37:	ee                   	out    %al,(%dx)
f0102f38:	b2 71                	mov    $0x71,%dl
f0102f3a:	ec                   	in     (%dx),%al
f0102f3b:	0f b6 c0             	movzbl %al,%eax
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
}
f0102f3e:	c9                   	leave  
f0102f3f:	c3                   	ret    

f0102f40 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0102f40:	55                   	push   %ebp
f0102f41:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
f0102f43:	ba 70 00 00 00       	mov    $0x70,%edx
f0102f48:	8a 45 08             	mov    0x8(%ebp),%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0102f4b:	ee                   	out    %al,(%dx)
f0102f4c:	b2 71                	mov    $0x71,%dl
f0102f4e:	8a 45 0c             	mov    0xc(%ebp),%al
f0102f51:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0102f52:	c9                   	leave  
f0102f53:	c3                   	ret    

f0102f54 <kclock_init>:


void
kclock_init(void)
{
f0102f54:	55                   	push   %ebp
f0102f55:	89 e5                	mov    %esp,%ebp
f0102f57:	83 ec 14             	sub    $0x14,%esp
}

static __inline void
outb(int port, uint8_t data)
{
f0102f5a:	ba 43 00 00 00       	mov    $0x43,%edx
f0102f5f:	b0 34                	mov    $0x34,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0102f61:	ee                   	out    %al,(%dx)
f0102f62:	b2 40                	mov    $0x40,%dl
f0102f64:	b0 9c                	mov    $0x9c,%al
f0102f66:	ee                   	out    %al,(%dx)
f0102f67:	b0 2e                	mov    $0x2e,%al
f0102f69:	ee                   	out    %al,(%dx)
	/* initialize 8253 clock to interrupt 100 times/sec */
	outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
	outb(IO_TIMER1, TIMER_DIV(100) % 256);
	outb(IO_TIMER1, TIMER_DIV(100) / 256);
	cprintf("	Setup timer interrupts via 8259A\n");
f0102f6a:	68 90 6a 10 f0       	push   $0xf0106a90
f0102f6f:	e8 4e 01 00 00       	call   f01030c2 <cprintf>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<0));
f0102f74:	0f b7 05 d8 55 12 f0 	movzwl 0xf01255d8,%eax
f0102f7b:	25 fe ff 00 00       	and    $0xfffe,%eax
f0102f80:	89 04 24             	mov    %eax,(%esp)
f0102f83:	e8 7a 00 00 00       	call   f0103002 <irq_setmask_8259A>
	cprintf("	unmasked timer interrupt\n");
f0102f88:	c7 04 24 b3 6a 10 f0 	movl   $0xf0106ab3,(%esp)
f0102f8f:	e8 2e 01 00 00       	call   f01030c2 <cprintf>
}
f0102f94:	c9                   	leave  
f0102f95:	c3                   	ret    
	...

f0102f98 <pic_init>:

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0102f98:	55                   	push   %ebp
f0102f99:	89 e5                	mov    %esp,%ebp
f0102f9b:	83 ec 08             	sub    $0x8,%esp
	didinit = 1;
f0102f9e:	c7 05 cc 5b 2f f0 01 	movl   $0x1,0xf02f5bcc
f0102fa5:	00 00 00 
}

static __inline void
outb(int port, uint8_t data)
{
f0102fa8:	ba 21 00 00 00       	mov    $0x21,%edx
f0102fad:	b0 ff                	mov    $0xff,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0102faf:	ee                   	out    %al,(%dx)
f0102fb0:	b2 a1                	mov    $0xa1,%dl
f0102fb2:	ee                   	out    %al,(%dx)
f0102fb3:	b2 20                	mov    $0x20,%dl
f0102fb5:	b0 11                	mov    $0x11,%al
f0102fb7:	ee                   	out    %al,(%dx)
f0102fb8:	b2 21                	mov    $0x21,%dl
f0102fba:	b0 20                	mov    $0x20,%al
f0102fbc:	ee                   	out    %al,(%dx)
f0102fbd:	b0 04                	mov    $0x4,%al
f0102fbf:	ee                   	out    %al,(%dx)
f0102fc0:	b0 03                	mov    $0x3,%al
f0102fc2:	ee                   	out    %al,(%dx)
f0102fc3:	b2 a0                	mov    $0xa0,%dl
f0102fc5:	b0 11                	mov    $0x11,%al
f0102fc7:	ee                   	out    %al,(%dx)
f0102fc8:	b2 a1                	mov    $0xa1,%dl
f0102fca:	b0 28                	mov    $0x28,%al
f0102fcc:	ee                   	out    %al,(%dx)
f0102fcd:	b0 02                	mov    $0x2,%al
f0102fcf:	ee                   	out    %al,(%dx)
f0102fd0:	b0 01                	mov    $0x1,%al
f0102fd2:	ee                   	out    %al,(%dx)
f0102fd3:	b2 20                	mov    $0x20,%dl
f0102fd5:	b0 68                	mov    $0x68,%al
f0102fd7:	ee                   	out    %al,(%dx)
f0102fd8:	b0 0a                	mov    $0xa,%al
f0102fda:	ee                   	out    %al,(%dx)
f0102fdb:	b2 a0                	mov    $0xa0,%dl
f0102fdd:	b0 68                	mov    $0x68,%al
f0102fdf:	ee                   	out    %al,(%dx)
f0102fe0:	b0 0a                	mov    $0xa,%al
f0102fe2:	ee                   	out    %al,(%dx)

	// mask all interrupts
	outb(IO_PIC1+1, 0xFF);
	outb(IO_PIC2+1, 0xFF);

	// Set up master (8259A-1)

	// ICW1:  0001g0hi
	//    g:  0 = edge triggering, 1 = level triggering
	//    h:  0 = cascaded PICs, 1 = master only
	//    i:  0 = no ICW4, 1 = ICW4 required
	outb(IO_PIC1, 0x11);

	// ICW2:  Vector offset
	outb(IO_PIC1+1, IRQ_OFFSET);

	// ICW3:  bit mask of IR lines connected to slave PICs (master PIC),
	//        3-bit No of IR line at which slave connects to master(slave PIC).
	outb(IO_PIC1+1, 1<<IRQ_SLAVE);

	// ICW4:  000nbmap
	//    n:  1 = special fully nested mode
	//    b:  1 = buffered mode
	//    m:  0 = slave PIC, 1 = master PIC
	//	  (ignored when b is 0, as the master/slave role
	//	  can be hardwired).
	//    a:  1 = Automatic EOI mode
	//    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
	outb(IO_PIC1+1, 0x3);

	// Set up slave (8259A-2)
	outb(IO_PIC2, 0x11);			// ICW1
	outb(IO_PIC2+1, IRQ_OFFSET + 8);	// ICW2
	outb(IO_PIC2+1, IRQ_SLAVE);		// ICW3
	// NB Automatic EOI mode doesn't tend to work on the slave.
	// Linux source code says it's "to be investigated".
	outb(IO_PIC2+1, 0x01);			// ICW4

	// OCW3:  0ef01prs
	//   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
	//    p:  0 = no polling, 1 = polling mode
	//   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
	outb(IO_PIC1, 0x68);             /* clear specific mask */
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f0102fe3:	66 83 3d d8 55 12 f0 	cmpw   $0xffffffff,0xf01255d8
f0102fea:	ff 
f0102feb:	74 13                	je     f0103000 <pic_init+0x68>
		irq_setmask_8259A(irq_mask_8259A);
f0102fed:	83 ec 0c             	sub    $0xc,%esp
f0102ff0:	0f b7 05 d8 55 12 f0 	movzwl 0xf01255d8,%eax
f0102ff7:	50                   	push   %eax
f0102ff8:	e8 05 00 00 00       	call   f0103002 <irq_setmask_8259A>
f0102ffd:	83 c4 10             	add    $0x10,%esp
}
f0103000:	c9                   	leave  
f0103001:	c3                   	ret    

f0103002 <irq_setmask_8259A>:

void
irq_setmask_8259A(uint16_t mask)
{
f0103002:	55                   	push   %ebp
f0103003:	89 e5                	mov    %esp,%ebp
f0103005:	56                   	push   %esi
f0103006:	53                   	push   %ebx
f0103007:	8b 45 08             	mov    0x8(%ebp),%eax
f010300a:	89 c6                	mov    %eax,%esi
	int i;
	irq_mask_8259A = mask;
f010300c:	66 a3 d8 55 12 f0    	mov    %ax,0xf01255d8
	if (!didinit)
f0103012:	83 3d cc 5b 2f f0 00 	cmpl   $0x0,0xf02f5bcc
f0103019:	74 59                	je     f0103074 <irq_setmask_8259A+0x72>
}

static __inline void
outb(int port, uint8_t data)
{
f010301b:	ba 21 00 00 00       	mov    $0x21,%edx
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103020:	ee                   	out    %al,(%dx)
f0103021:	b2 a1                	mov    $0xa1,%dl
f0103023:	89 f0                	mov    %esi,%eax
f0103025:	66 c1 e8 08          	shr    $0x8,%ax
f0103029:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
f010302a:	83 ec 0c             	sub    $0xc,%esp
f010302d:	68 ce 6a 10 f0       	push   $0xf0106ace
f0103032:	e8 8b 00 00 00       	call   f01030c2 <cprintf>
	for (i = 0; i < 16; i++)
f0103037:	bb 00 00 00 00       	mov    $0x0,%ebx
f010303c:	83 c4 10             	add    $0x10,%esp
f010303f:	0f b7 c6             	movzwl %si,%eax
f0103042:	89 c6                	mov    %eax,%esi
f0103044:	f7 d6                	not    %esi
		if (~mask & (1<<i))
f0103046:	89 f0                	mov    %esi,%eax
f0103048:	88 d9                	mov    %bl,%cl
f010304a:	d3 f8                	sar    %cl,%eax
f010304c:	a8 01                	test   $0x1,%al
f010304e:	74 11                	je     f0103061 <irq_setmask_8259A+0x5f>
			cprintf(" %d", i);
f0103050:	83 ec 08             	sub    $0x8,%esp
f0103053:	53                   	push   %ebx
f0103054:	68 0e 70 10 f0       	push   $0xf010700e
f0103059:	e8 64 00 00 00       	call   f01030c2 <cprintf>
f010305e:	83 c4 10             	add    $0x10,%esp
f0103061:	43                   	inc    %ebx
f0103062:	83 fb 0f             	cmp    $0xf,%ebx
f0103065:	7e df                	jle    f0103046 <irq_setmask_8259A+0x44>
	cprintf("\n");
f0103067:	83 ec 0c             	sub    $0xc,%esp
f010306a:	68 bd 5f 10 f0       	push   $0xf0105fbd
f010306f:	e8 4e 00 00 00       	call   f01030c2 <cprintf>
}
f0103074:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0103077:	5b                   	pop    %ebx
f0103078:	5e                   	pop    %esi
f0103079:	c9                   	leave  
f010307a:	c3                   	ret    

f010307b <irq_eoi>:

void
irq_eoi(void)
{
f010307b:	55                   	push   %ebp
f010307c:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
f010307e:	ba 20 00 00 00       	mov    $0x20,%edx
f0103083:	b0 20                	mov    $0x20,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103085:	ee                   	out    %al,(%dx)
f0103086:	b2 a0                	mov    $0xa0,%dl
f0103088:	ee                   	out    %al,(%dx)
	// OCW2: rse00xxx
	//   r: rotate
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0103089:	c9                   	leave  
f010308a:	c3                   	ret    
	...

f010308c <putch>:


static void
putch(int ch, int *cnt)
{
f010308c:	55                   	push   %ebp
f010308d:	89 e5                	mov    %esp,%ebp
f010308f:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0103092:	ff 75 08             	pushl  0x8(%ebp)
f0103095:	e8 02 d6 ff ff       	call   f010069c <cputchar>
	*cnt++;
}
f010309a:	c9                   	leave  
f010309b:	c3                   	ret    

f010309c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010309c:	55                   	push   %ebp
f010309d:	89 e5                	mov    %esp,%ebp
f010309f:	83 ec 08             	sub    $0x8,%esp
	int cnt = 0;
f01030a2:	c7 45 fc 00 00 00 00 	movl   $0x0,0xfffffffc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01030a9:	ff 75 0c             	pushl  0xc(%ebp)
f01030ac:	ff 75 08             	pushl  0x8(%ebp)
f01030af:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f01030b2:	50                   	push   %eax
f01030b3:	68 8c 30 10 f0       	push   $0xf010308c
f01030b8:	e8 05 15 00 00       	call   f01045c2 <vprintfmt>
	return cnt;
f01030bd:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
}
f01030c0:	c9                   	leave  
f01030c1:	c3                   	ret    

f01030c2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01030c2:	55                   	push   %ebp
f01030c3:	89 e5                	mov    %esp,%ebp
f01030c5:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01030c8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f01030cb:	50                   	push   %eax
f01030cc:	ff 75 08             	pushl  0x8(%ebp)
f01030cf:	e8 c8 ff ff ff       	call   f010309c <vcprintf>
	va_end(ap);

	return cnt;
}
f01030d4:	c9                   	leave  
f01030d5:	c3                   	ret    
	...

f01030d8 <trapname>:
};


static const char *trapname(int trapno)
{
f01030d8:	55                   	push   %ebp
f01030d9:	89 e5                	mov    %esp,%ebp
f01030db:	8b 45 08             	mov    0x8(%ebp),%eax
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
f01030de:	83 f8 13             	cmp    $0x13,%eax
f01030e1:	77 09                	ja     f01030ec <trapname+0x14>
		return excnames[trapno];
f01030e3:	8b 14 85 c0 6d 10 f0 	mov    0xf0106dc0(,%eax,4),%edx
f01030ea:	eb 1c                	jmp    f0103108 <trapname+0x30>
	if (trapno == T_SYSCALL)
		return "System call";
f01030ec:	ba 34 6c 10 f0       	mov    $0xf0106c34,%edx
f01030f1:	83 f8 30             	cmp    $0x30,%eax
f01030f4:	74 12                	je     f0103108 <trapname+0x30>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01030f6:	83 e8 20             	sub    $0x20,%eax
		return "Hardware Interrupt";
f01030f9:	ba 40 6c 10 f0       	mov    $0xf0106c40,%edx
f01030fe:	83 f8 0f             	cmp    $0xf,%eax
f0103101:	76 05                	jbe    f0103108 <trapname+0x30>
	return "(unknown trap)";
f0103103:	ba cc 6b 10 f0       	mov    $0xf0106bcc,%edx
}
f0103108:	89 d0                	mov    %edx,%eax
f010310a:	c9                   	leave  
f010310b:	c3                   	ret    

f010310c <idt_init>:


void
idt_init(void)
{
f010310c:	55                   	push   %ebp
f010310d:	89 e5                	mov    %esp,%ebp
f010310f:	53                   	push   %ebx
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.
        // seanyliu
        int idx;
        void *handler_ptr;
        extern int vectors[]; // in trapentry.S
        extern int irqs[]; // in trapentry.S

        for (idx = 0; idx < 19; idx++) {
f0103110:	ba 00 00 00 00       	mov    $0x0,%edx
f0103115:	b9 e0 5b 2f f0       	mov    $0xf02f5be0,%ecx
f010311a:	bb e4 55 12 f0       	mov    $0xf01255e4,%ebx
          SETGATE(idt[idx], 0, GD_KT, vectors[idx], 0);
f010311f:	8b 04 93             	mov    (%ebx,%edx,4),%eax
f0103122:	66 89 04 d1          	mov    %ax,(%ecx,%edx,8)
f0103126:	66 c7 44 d1 02 08 00 	movw   $0x8,0x2(%ecx,%edx,8)
f010312d:	c6 44 d1 04 00       	movb   $0x0,0x4(%ecx,%edx,8)
f0103132:	c6 44 d1 05 8e       	movb   $0x8e,0x5(%ecx,%edx,8)
f0103137:	c1 e8 10             	shr    $0x10,%eax
f010313a:	66 89 44 d1 06       	mov    %ax,0x6(%ecx,%edx,8)
f010313f:	42                   	inc    %edx
f0103140:	83 fa 12             	cmp    $0x12,%edx
f0103143:	7e da                	jle    f010311f <idt_init+0x13>
        }

        extern char handler3;
        handler_ptr = &handler3;
f0103145:	b8 42 36 10 f0       	mov    $0xf0103642,%eax
        SETGATE(idt[T_BRKPT], 0, GD_KT, handler_ptr, 3);
f010314a:	66 a3 f8 5b 2f f0    	mov    %ax,0xf02f5bf8
f0103150:	66 c7 05 fa 5b 2f f0 	movw   $0x8,0xf02f5bfa
f0103157:	08 00 
f0103159:	c6 05 fc 5b 2f f0 00 	movb   $0x0,0xf02f5bfc
f0103160:	c6 05 fd 5b 2f f0 ee 	movb   $0xee,0xf02f5bfd
f0103167:	c1 e8 10             	shr    $0x10,%eax
f010316a:	66 a3 fe 5b 2f f0    	mov    %ax,0xf02f5bfe

        for (idx = 0; idx < 16; idx++) {
f0103170:	ba 00 00 00 00       	mov    $0x0,%edx
f0103175:	b9 e0 5c 2f f0       	mov    $0xf02f5ce0,%ecx
f010317a:	bb 34 56 12 f0       	mov    $0xf0125634,%ebx
          SETGATE(idt[IRQ_OFFSET + idx], 0, GD_KT, irqs[idx], 0);
f010317f:	8b 04 93             	mov    (%ebx,%edx,4),%eax
f0103182:	66 89 04 d1          	mov    %ax,(%ecx,%edx,8)
f0103186:	66 c7 44 d1 02 08 00 	movw   $0x8,0x2(%ecx,%edx,8)
f010318d:	c6 44 d1 04 00       	movb   $0x0,0x4(%ecx,%edx,8)
f0103192:	c6 44 d1 05 8e       	movb   $0x8e,0x5(%ecx,%edx,8)
f0103197:	c1 e8 10             	shr    $0x10,%eax
f010319a:	66 89 44 d1 06       	mov    %ax,0x6(%ecx,%edx,8)
f010319f:	42                   	inc    %edx
f01031a0:	83 fa 0f             	cmp    $0xf,%edx
f01031a3:	7e da                	jle    f010317f <idt_init+0x73>
        }

        extern char handler48;
        handler_ptr = &handler48;
f01031a5:	b8 7c 37 10 f0       	mov    $0xf010377c,%eax
        //SETGATE(idt[T_SYSCALL], 1, GD_KT, handler_ptr, 3);
        SETGATE(idt[T_SYSCALL], 0, GD_KT, handler_ptr, 3);
f01031aa:	66 a3 60 5d 2f f0    	mov    %ax,0xf02f5d60
f01031b0:	66 c7 05 62 5d 2f f0 	movw   $0x8,0xf02f5d62
f01031b7:	08 00 
f01031b9:	c6 05 64 5d 2f f0 00 	movb   $0x0,0xf02f5d64
f01031c0:	c6 05 65 5d 2f f0 ee 	movb   $0xee,0xf02f5d65
f01031c7:	c1 e8 10             	shr    $0x10,%eax
f01031ca:	66 a3 66 5d 2f f0    	mov    %ax,0xf02f5d66

        extern char handler500;
        handler_ptr = &handler500;
f01031d0:	b8 90 37 10 f0       	mov    $0xf0103790,%eax
        SETGATE(idt[T_DEFAULT], 0, GD_KT, handler_ptr, 0);
f01031d5:	66 a3 80 6b 2f f0    	mov    %ax,0xf02f6b80
f01031db:	66 c7 05 82 6b 2f f0 	movw   $0x8,0xf02f6b82
f01031e2:	08 00 
f01031e4:	c6 05 84 6b 2f f0 00 	movb   $0x0,0xf02f6b84
f01031eb:	c6 05 85 6b 2f f0 8e 	movb   $0x8e,0xf02f6b85
f01031f2:	c1 e8 10             	shr    $0x10,%eax
f01031f5:	66 a3 86 6b 2f f0    	mov    %ax,0xf02f6b86

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
f01031fb:	b8 86 37 10 f0       	mov    $0xf0103786,%eax
        SETGATE(idt[(32 + IRQ_ERROR)], 0, GD_KT, handler_ptr, 0);
f0103200:	66 a3 78 5d 2f f0    	mov    %ax,0xf02f5d78
f0103206:	66 c7 05 7a 5d 2f f0 	movw   $0x8,0xf02f5d7a
f010320d:	08 00 
f010320f:	c6 05 7c 5d 2f f0 00 	movb   $0x0,0xf02f5d7c
f0103216:	c6 05 7d 5d 2f f0 8e 	movb   $0x8e,0xf02f5d7d
f010321d:	c1 e8 10             	shr    $0x10,%eax
f0103220:	66 a3 7e 5d 2f f0    	mov    %ax,0xf02f5d7e

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
f0103226:	c7 05 e4 63 2f f0 00 	movl   $0xefc00000,0xf02f63e4
f010322d:	00 c0 ef 
	ts.ts_ss0 = GD_KD;
f0103230:	66 c7 05 e8 63 2f f0 	movw   $0x10,0xf02f63e8
f0103237:	10 00 

	// Initialize the TSS field of the gdt.
	gdt[GD_TSS >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f0103239:	66 b8 68 00          	mov    $0x68,%ax
f010323d:	bb e0 63 2f f0       	mov    $0xf02f63e0,%ebx
f0103242:	89 d9                	mov    %ebx,%ecx
f0103244:	c1 e1 10             	shl    $0x10,%ecx
f0103247:	25 ff ff 00 00       	and    $0xffff,%eax
f010324c:	09 c8                	or     %ecx,%eax
f010324e:	89 d9                	mov    %ebx,%ecx
f0103250:	c1 e9 10             	shr    $0x10,%ecx
f0103253:	88 ca                	mov    %cl,%dl
f0103255:	80 e6 f0             	and    $0xf0,%dh
f0103258:	80 ce 09             	or     $0x9,%dh
f010325b:	80 ce 10             	or     $0x10,%dh
f010325e:	80 e6 9f             	and    $0x9f,%dh
f0103261:	80 ce 80             	or     $0x80,%dh
f0103264:	81 e2 ff ff f0 ff    	and    $0xfff0ffff,%edx
f010326a:	81 e2 ff ff ef ff    	and    $0xffefffff,%edx
f0103270:	81 e2 ff ff df ff    	and    $0xffdfffff,%edx
f0103276:	81 ca 00 00 40 00    	or     $0x400000,%edx
f010327c:	81 e2 ff ff 7f ff    	and    $0xff7fffff,%edx
f0103282:	81 e3 00 00 00 ff    	and    $0xff000000,%ebx
f0103288:	81 e2 ff ff ff 00    	and    $0xffffff,%edx
f010328e:	09 da                	or     %ebx,%edx
f0103290:	a3 c8 55 12 f0       	mov    %eax,0xf01255c8
f0103295:	89 15 cc 55 12 f0    	mov    %edx,0xf01255cc
					sizeof(struct Taskstate), 0);
	gdt[GD_TSS >> 3].sd_s = 0;
f010329b:	80 25 cd 55 12 f0 ef 	andb   $0xef,0xf01255cd
}

static __inline void
ltr(uint16_t sel)
{
f01032a2:	b8 28 00 00 00       	mov    $0x28,%eax
	__asm __volatile("ltr %0" : : "r" (sel));
f01032a7:	0f 00 d8             	ltr    %ax

	// Load the TSS
	ltr(GD_TSS);

	// Load the IDT
	asm volatile("lidt idt_pd");
f01032aa:	0f 01 1d dc 55 12 f0 	lidtl  0xf01255dc
}
f01032b1:	5b                   	pop    %ebx
f01032b2:	c9                   	leave  
f01032b3:	c3                   	ret    

f01032b4 <print_trapframe>:

void
print_trapframe(struct Trapframe *tf)
{
f01032b4:	55                   	push   %ebp
f01032b5:	89 e5                	mov    %esp,%ebp
f01032b7:	53                   	push   %ebx
f01032b8:	83 ec 0c             	sub    $0xc,%esp
f01032bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p\n", tf);
f01032be:	53                   	push   %ebx
f01032bf:	68 53 6c 10 f0       	push   $0xf0106c53
f01032c4:	e8 f9 fd ff ff       	call   f01030c2 <cprintf>
	print_regs(&tf->tf_regs);
f01032c9:	89 1c 24             	mov    %ebx,(%esp)
f01032cc:	e8 a8 00 00 00       	call   f0103379 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01032d1:	83 c4 08             	add    $0x8,%esp
f01032d4:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f01032d8:	50                   	push   %eax
f01032d9:	68 65 6c 10 f0       	push   $0xf0106c65
f01032de:	e8 df fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01032e3:	83 c4 08             	add    $0x8,%esp
f01032e6:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01032ea:	50                   	push   %eax
f01032eb:	68 78 6c 10 f0       	push   $0xf0106c78
f01032f0:	e8 cd fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01032f5:	83 c4 0c             	add    $0xc,%esp
f01032f8:	ff 73 28             	pushl  0x28(%ebx)
f01032fb:	e8 d8 fd ff ff       	call   f01030d8 <trapname>
f0103300:	89 04 24             	mov    %eax,(%esp)
f0103303:	ff 73 28             	pushl  0x28(%ebx)
f0103306:	68 8b 6c 10 f0       	push   $0xf0106c8b
f010330b:	e8 b2 fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  err  0x%08x\n", tf->tf_err);
f0103310:	83 c4 08             	add    $0x8,%esp
f0103313:	ff 73 2c             	pushl  0x2c(%ebx)
f0103316:	68 9d 6c 10 f0       	push   $0xf0106c9d
f010331b:	e8 a2 fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103320:	83 c4 08             	add    $0x8,%esp
f0103323:	ff 73 30             	pushl  0x30(%ebx)
f0103326:	68 ac 6c 10 f0       	push   $0xf0106cac
f010332b:	e8 92 fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103330:	83 c4 08             	add    $0x8,%esp
f0103333:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0103337:	50                   	push   %eax
f0103338:	68 bb 6c 10 f0       	push   $0xf0106cbb
f010333d:	e8 80 fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0103342:	83 c4 08             	add    $0x8,%esp
f0103345:	ff 73 38             	pushl  0x38(%ebx)
f0103348:	68 ce 6c 10 f0       	push   $0xf0106cce
f010334d:	e8 70 fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  esp  0x%08x\n", tf->tf_esp);
f0103352:	83 c4 08             	add    $0x8,%esp
f0103355:	ff 73 3c             	pushl  0x3c(%ebx)
f0103358:	68 dd 6c 10 f0       	push   $0xf0106cdd
f010335d:	e8 60 fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0103362:	83 c4 08             	add    $0x8,%esp
f0103365:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0103369:	50                   	push   %eax
f010336a:	68 ec 6c 10 f0       	push   $0xf0106cec
f010336f:	e8 4e fd ff ff       	call   f01030c2 <cprintf>
}
f0103374:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0103377:	c9                   	leave  
f0103378:	c3                   	ret    

f0103379 <print_regs>:

void
print_regs(struct PushRegs *regs)
{
f0103379:	55                   	push   %ebp
f010337a:	89 e5                	mov    %esp,%ebp
f010337c:	53                   	push   %ebx
f010337d:	83 ec 0c             	sub    $0xc,%esp
f0103380:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103383:	ff 33                	pushl  (%ebx)
f0103385:	68 ff 6c 10 f0       	push   $0xf0106cff
f010338a:	e8 33 fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f010338f:	83 c4 08             	add    $0x8,%esp
f0103392:	ff 73 04             	pushl  0x4(%ebx)
f0103395:	68 0e 6d 10 f0       	push   $0xf0106d0e
f010339a:	e8 23 fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f010339f:	83 c4 08             	add    $0x8,%esp
f01033a2:	ff 73 08             	pushl  0x8(%ebx)
f01033a5:	68 1d 6d 10 f0       	push   $0xf0106d1d
f01033aa:	e8 13 fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01033af:	83 c4 08             	add    $0x8,%esp
f01033b2:	ff 73 0c             	pushl  0xc(%ebx)
f01033b5:	68 2c 6d 10 f0       	push   $0xf0106d2c
f01033ba:	e8 03 fd ff ff       	call   f01030c2 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01033bf:	83 c4 08             	add    $0x8,%esp
f01033c2:	ff 73 10             	pushl  0x10(%ebx)
f01033c5:	68 3b 6d 10 f0       	push   $0xf0106d3b
f01033ca:	e8 f3 fc ff ff       	call   f01030c2 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f01033cf:	83 c4 08             	add    $0x8,%esp
f01033d2:	ff 73 14             	pushl  0x14(%ebx)
f01033d5:	68 4a 6d 10 f0       	push   $0xf0106d4a
f01033da:	e8 e3 fc ff ff       	call   f01030c2 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01033df:	83 c4 08             	add    $0x8,%esp
f01033e2:	ff 73 18             	pushl  0x18(%ebx)
f01033e5:	68 59 6d 10 f0       	push   $0xf0106d59
f01033ea:	e8 d3 fc ff ff       	call   f01030c2 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f01033ef:	83 c4 08             	add    $0x8,%esp
f01033f2:	ff 73 1c             	pushl  0x1c(%ebx)
f01033f5:	68 68 6d 10 f0       	push   $0xf0106d68
f01033fa:	e8 c3 fc ff ff       	call   f01030c2 <cprintf>
}
f01033ff:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0103402:	c9                   	leave  
f0103403:	c3                   	ret    

f0103404 <trap_dispatch>:

static void
trap_dispatch(struct Trapframe *tf)
{
f0103404:	55                   	push   %ebp
f0103405:	89 e5                	mov    %esp,%ebp
f0103407:	56                   	push   %esi
f0103408:	53                   	push   %ebx
f0103409:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Handle processor exceptions.
	// LAB 3: Your code here.
	

        int32_t eax_return;
        struct PushRegs *regs;
        regs = &tf->tf_regs;

        // seanyliu
        switch (tf->tf_trapno) {
f010340c:	8b 43 28             	mov    0x28(%ebx),%eax
f010340f:	83 f8 0e             	cmp    $0xe,%eax
f0103412:	74 18                	je     f010342c <trap_dispatch+0x28>
f0103414:	83 f8 0e             	cmp    $0xe,%eax
f0103417:	77 07                	ja     f0103420 <trap_dispatch+0x1c>
f0103419:	83 f8 03             	cmp    $0x3,%eax
f010341c:	74 1c                	je     f010343a <trap_dispatch+0x36>
f010341e:	eb 4d                	jmp    f010346d <trap_dispatch+0x69>
f0103420:	83 f8 20             	cmp    $0x20,%eax
f0103423:	74 3e                	je     f0103463 <trap_dispatch+0x5f>
f0103425:	83 f8 30             	cmp    $0x30,%eax
f0103428:	74 1b                	je     f0103445 <trap_dispatch+0x41>
f010342a:	eb 41                	jmp    f010346d <trap_dispatch+0x69>
          case T_PGFLT:
            return page_fault_handler(tf);
f010342c:	83 ec 0c             	sub    $0xc,%esp
f010342f:	53                   	push   %ebx
f0103430:	e8 13 01 00 00       	call   f0103548 <page_fault_handler>
f0103435:	e9 88 00 00 00       	jmp    f01034c2 <trap_dispatch+0xbe>
            break;
          case T_BRKPT:
            return monitor(tf);
f010343a:	83 ec 0c             	sub    $0xc,%esp
f010343d:	53                   	push   %ebx
f010343e:	e8 b5 d6 ff ff       	call   f0100af8 <monitor>
f0103443:	eb 7d                	jmp    f01034c2 <trap_dispatch+0xbe>
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
f0103445:	83 ec 08             	sub    $0x8,%esp
f0103448:	ff 73 04             	pushl  0x4(%ebx)
f010344b:	ff 33                	pushl  (%ebx)
f010344d:	ff 73 10             	pushl  0x10(%ebx)
f0103450:	ff 73 18             	pushl  0x18(%ebx)
f0103453:	ff 73 14             	pushl  0x14(%ebx)
f0103456:	ff 73 1c             	pushl  0x1c(%ebx)
f0103459:	e8 5f 0b 00 00       	call   f0103fbd <syscall>
            //if (eax_return < 0) panic("trap.c: syscall returned invalid value %d\n", eax_return);
            // don't panic, because use for -E_IPC_NOT_RECV
            regs->reg_eax = eax_return;
f010345e:	89 43 1c             	mov    %eax,0x1c(%ebx)
            return;
f0103461:	eb 5f                	jmp    f01034c2 <trap_dispatch+0xbe>
            break;
          case IRQ_OFFSET + IRQ_TIMER:
	    // Add time tick increment to clock interrupts.
	    // LAB 6: Your code here.
            time_tick();
f0103463:	e8 a3 26 00 00       	call   f0105b0b <time_tick>
            sched_yield();
f0103468:	e8 2f 03 00 00       	call   f010379c <sched_yield>
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
f010346d:	83 7b 28 27          	cmpl   $0x27,0x28(%ebx)
f0103471:	75 17                	jne    f010348a <trap_dispatch+0x86>
		cprintf("Spurious interrupt on irq 7\n");
f0103473:	83 ec 0c             	sub    $0xc,%esp
f0103476:	68 77 6d 10 f0       	push   $0xf0106d77
f010347b:	e8 42 fc ff ff       	call   f01030c2 <cprintf>
		print_trapframe(tf);
f0103480:	89 1c 24             	mov    %ebx,(%esp)
f0103483:	e8 2c fe ff ff       	call   f01032b4 <print_trapframe>
		return;
f0103488:	eb 38                	jmp    f01034c2 <trap_dispatch+0xbe>
	}


	// Handle keyboard interrupts.
	// LAB 7: Your code here.

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f010348a:	83 ec 0c             	sub    $0xc,%esp
f010348d:	53                   	push   %ebx
f010348e:	e8 21 fe ff ff       	call   f01032b4 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0103493:	83 c4 10             	add    $0x10,%esp
f0103496:	66 83 7b 34 08       	cmpw   $0x8,0x34(%ebx)
f010349b:	75 17                	jne    f01034b4 <trap_dispatch+0xb0>
		panic("unhandled trap in kernel");
f010349d:	83 ec 04             	sub    $0x4,%esp
f01034a0:	68 94 6d 10 f0       	push   $0xf0106d94
f01034a5:	68 ed 00 00 00       	push   $0xed
f01034aa:	68 ad 6d 10 f0       	push   $0xf0106dad
f01034af:	e8 35 cc ff ff       	call   f01000e9 <_panic>
	else {
		env_destroy(curenv);
f01034b4:	83 ec 0c             	sub    $0xc,%esp
f01034b7:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f01034bd:	e8 f0 f9 ff ff       	call   f0102eb2 <env_destroy>
		return;
	}
}
f01034c2:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f01034c5:	5b                   	pop    %ebx
f01034c6:	5e                   	pop    %esi
f01034c7:	c9                   	leave  
f01034c8:	c3                   	ret    

f01034c9 <trap>:

void
trap(struct Trapframe *tf)
{
f01034c9:	55                   	push   %ebp
f01034ca:	89 e5                	mov    %esp,%ebp
f01034cc:	83 ec 08             	sub    $0x8,%esp
f01034cf:	8b 55 08             	mov    0x8(%ebp),%edx
	if ((tf->tf_cs & 3) == 3) {
f01034d2:	0f b7 42 34          	movzwl 0x34(%edx),%eax
f01034d6:	83 e0 03             	and    $0x3,%eax
f01034d9:	83 f8 03             	cmp    $0x3,%eax
f01034dc:	75 3c                	jne    f010351a <trap+0x51>
		// Trapped from user mode.
		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		assert(curenv);
f01034de:	83 3d c4 5b 2f f0 00 	cmpl   $0x0,0xf02f5bc4
f01034e5:	75 19                	jne    f0103500 <trap+0x37>
f01034e7:	68 b9 6d 10 f0       	push   $0xf0106db9
f01034ec:	68 44 68 10 f0       	push   $0xf0106844
f01034f1:	68 fc 00 00 00       	push   $0xfc
f01034f6:	68 ad 6d 10 f0       	push   $0xf0106dad
f01034fb:	e8 e9 cb ff ff       	call   f01000e9 <_panic>
		curenv->env_tf = *tf;
f0103500:	83 ec 04             	sub    $0x4,%esp
f0103503:	6a 44                	push   $0x44
f0103505:	52                   	push   %edx
f0103506:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f010350c:	e8 3e 18 00 00       	call   f0104d4f <memcpy>
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0103511:	8b 15 c4 5b 2f f0    	mov    0xf02f5bc4,%edx
f0103517:	83 c4 10             	add    $0x10,%esp
	}
	
	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
f010351a:	83 ec 0c             	sub    $0xc,%esp
f010351d:	52                   	push   %edx
f010351e:	e8 e1 fe ff ff       	call   f0103404 <trap_dispatch>

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNABLE)
f0103523:	83 c4 10             	add    $0x10,%esp
f0103526:	83 3d c4 5b 2f f0 00 	cmpl   $0x0,0xf02f5bc4
f010352d:	74 14                	je     f0103543 <trap+0x7a>
f010352f:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103534:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0103538:	75 09                	jne    f0103543 <trap+0x7a>
		env_run(curenv);
f010353a:	83 ec 0c             	sub    $0xc,%esp
f010353d:	50                   	push   %eax
f010353e:	e8 c4 f9 ff ff       	call   f0102f07 <env_run>
	else
		sched_yield();
f0103543:	e8 54 02 00 00       	call   f010379c <sched_yield>

f0103548 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0103548:	55                   	push   %ebp
f0103549:	89 e5                	mov    %esp,%ebp
f010354b:	57                   	push   %edi
f010354c:	56                   	push   %esi
f010354d:	53                   	push   %ebx
f010354e:	83 ec 0c             	sub    $0xc,%esp
}

static __inline uint32_t
rcr2(void)
{
f0103551:	0f 20 d7             	mov    %cr2,%edi
	uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	
	// LAB 3: Your code here.
        // seanyliu
	if ((tf->tf_cs & 3) == 0) panic("page_fault_handler: page fault happened in kernel mode.");
f0103554:	8b 45 08             	mov    0x8(%ebp),%eax
f0103557:	f6 40 34 03          	testb  $0x3,0x34(%eax)
f010355b:	75 17                	jne    f0103574 <page_fault_handler+0x2c>
f010355d:	83 ec 04             	sub    $0x4,%esp
f0103560:	68 10 6e 10 f0       	push   $0xf0106e10
f0103565:	68 1b 01 00 00       	push   $0x11b
f010356a:	68 ad 6d 10 f0       	push   $0xf0106dad
f010356f:	e8 75 cb ff ff       	call   f01000e9 <_panic>

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
f0103574:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103579:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010357d:	75 30                	jne    f01035af <page_fault_handler+0x67>
	  // Destroy the environment that caused the fault.
	  cprintf("[%08x] user fault va %08x ip %08x\n",
f010357f:	8b 55 08             	mov    0x8(%ebp),%edx
f0103582:	ff 72 30             	pushl  0x30(%edx)
f0103585:	57                   	push   %edi
f0103586:	ff 70 4c             	pushl  0x4c(%eax)
f0103589:	68 48 6e 10 f0       	push   $0xf0106e48
f010358e:	e8 2f fb ff ff       	call   f01030c2 <cprintf>
		  curenv->env_id, fault_va, tf->tf_eip);
	  print_trapframe(tf);
f0103593:	83 c4 04             	add    $0x4,%esp
f0103596:	ff 75 08             	pushl  0x8(%ebp)
f0103599:	e8 16 fd ff ff       	call   f01032b4 <print_trapframe>
	  env_destroy(curenv);
f010359e:	83 c4 04             	add    $0x4,%esp
f01035a1:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f01035a7:	e8 06 f9 ff ff       	call   f0102eb2 <env_destroy>
f01035ac:	83 c4 10             	add    $0x10,%esp
        }

        uint32_t writeloc = UXSTACKTOP - sizeof(struct UTrapframe);
f01035af:	bb cc ff bf ee       	mov    $0xeebfffcc,%ebx
        // check if recursive case or not
        if ((tf->tf_esp >= UXSTACKTOP - PGSIZE) && (tf->tf_esp <= UXSTACKTOP - 1)) {
f01035b4:	8b 75 08             	mov    0x8(%ebp),%esi
f01035b7:	8b 56 3c             	mov    0x3c(%esi),%edx
f01035ba:	8d 82 00 10 40 11    	lea    0x11401000(%edx),%eax
f01035c0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f01035c5:	77 03                	ja     f01035ca <page_fault_handler+0x82>
          writeloc = tf->tf_esp - sizeof(struct UTrapframe) - 4;
f01035c7:	8d 5a c8             	lea    0xffffffc8(%edx),%ebx
        }

        // verify that we can write below UXSTACKTOP
        user_mem_assert(curenv, (void *)writeloc, sizeof(struct UTrapframe), PTE_U);
f01035ca:	6a 04                	push   $0x4
f01035cc:	6a 34                	push   $0x34
f01035ce:	53                   	push   %ebx
f01035cf:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f01035d5:	e8 29 e6 ff ff       	call   f0101c03 <user_mem_assert>

        // Create the UTrapframe
        struct UTrapframe* utf;
        utf = (struct UTrapframe*) writeloc;
        utf->utf_fault_va = fault_va;
f01035da:	89 3b                	mov    %edi,(%ebx)
        utf->utf_err = tf->tf_err;
f01035dc:	8b 55 08             	mov    0x8(%ebp),%edx
f01035df:	8b 42 2c             	mov    0x2c(%edx),%eax
f01035e2:	89 43 04             	mov    %eax,0x4(%ebx)
        utf->utf_regs = tf->tf_regs;
f01035e5:	8d 7b 08             	lea    0x8(%ebx),%edi
f01035e8:	fc                   	cld    
f01035e9:	b9 08 00 00 00       	mov    $0x8,%ecx
f01035ee:	8b 75 08             	mov    0x8(%ebp),%esi
f01035f1:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
        utf->utf_eip = tf->tf_eip;
f01035f3:	8b 42 30             	mov    0x30(%edx),%eax
f01035f6:	89 43 28             	mov    %eax,0x28(%ebx)
        utf->utf_eflags = tf->tf_eflags;
f01035f9:	8b 42 38             	mov    0x38(%edx),%eax
f01035fc:	89 43 2c             	mov    %eax,0x2c(%ebx)
        utf->utf_esp = tf->tf_esp;
f01035ff:	8b 42 3c             	mov    0x3c(%edx),%eax
f0103602:	89 43 30             	mov    %eax,0x30(%ebx)

        // Update the tf->tf_esp
        tf->tf_esp = (uintptr_t)writeloc;
f0103605:	89 5a 3c             	mov    %ebx,0x3c(%edx)

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
        tf->tf_eip = (uintptr_t) curenv->env_pgfault_upcall;
f0103608:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f010360d:	8b 40 64             	mov    0x64(%eax),%eax
f0103610:	89 42 30             	mov    %eax,0x30(%edx)
        //curnenv->env_tf = tf;
        env_run(curenv);
f0103613:	83 c4 04             	add    $0x4,%esp
f0103616:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f010361c:	e8 e6 f8 ff ff       	call   f0102f07 <env_run>
f0103621:	00 00                	add    %al,(%eax)
	...

f0103624 <handler0>:
 * Lab 3: Your code here for generating entry points for the different traps.
 */
#define IRQ_OFFSET 32

  TRAPHANDLER_NOEC(handler0, T_DIVIDE); /* DIVIDE is already used */
f0103624:	6a 00                	push   $0x0
f0103626:	6a 00                	push   $0x0
f0103628:	e9 53 20 02 00       	jmp    f0125680 <_alltraps>
f010362d:	90                   	nop    

f010362e <handler1>:
  TRAPHANDLER_NOEC(handler1, T_DEBUG);
f010362e:	6a 00                	push   $0x0
f0103630:	6a 01                	push   $0x1
f0103632:	e9 49 20 02 00       	jmp    f0125680 <_alltraps>
f0103637:	90                   	nop    

f0103638 <handler2>:
  TRAPHANDLER_NOEC(handler2, T_NMI);
f0103638:	6a 00                	push   $0x0
f010363a:	6a 02                	push   $0x2
f010363c:	e9 3f 20 02 00       	jmp    f0125680 <_alltraps>
f0103641:	90                   	nop    

f0103642 <handler3>:
  TRAPHANDLER_NOEC(handler3, T_BRKPT);
f0103642:	6a 00                	push   $0x0
f0103644:	6a 03                	push   $0x3
f0103646:	e9 35 20 02 00       	jmp    f0125680 <_alltraps>
f010364b:	90                   	nop    

f010364c <handler4>:
  TRAPHANDLER_NOEC(handler4, T_OFLOW);
f010364c:	6a 00                	push   $0x0
f010364e:	6a 04                	push   $0x4
f0103650:	e9 2b 20 02 00       	jmp    f0125680 <_alltraps>
f0103655:	90                   	nop    

f0103656 <handler5>:
  TRAPHANDLER_NOEC(handler5, T_BOUND);
f0103656:	6a 00                	push   $0x0
f0103658:	6a 05                	push   $0x5
f010365a:	e9 21 20 02 00       	jmp    f0125680 <_alltraps>
f010365f:	90                   	nop    

f0103660 <handler6>:
  TRAPHANDLER_NOEC(handler6, T_ILLOP);
f0103660:	6a 00                	push   $0x0
f0103662:	6a 06                	push   $0x6
f0103664:	e9 17 20 02 00       	jmp    f0125680 <_alltraps>
f0103669:	90                   	nop    

f010366a <handler7>:
  TRAPHANDLER_NOEC(handler7, T_DEVICE);
f010366a:	6a 00                	push   $0x0
f010366c:	6a 07                	push   $0x7
f010366e:	e9 0d 20 02 00       	jmp    f0125680 <_alltraps>
f0103673:	90                   	nop    

f0103674 <handler8>:
  TRAPHANDLER(handler8, T_DBLFLT);
f0103674:	6a 08                	push   $0x8
f0103676:	e9 05 20 02 00       	jmp    f0125680 <_alltraps>
f010367b:	90                   	nop    

f010367c <handler9>:
/* handler9: */
  TRAPHANDLER(handler9, T_DIVIDE); // need for cleanliness of table
f010367c:	6a 00                	push   $0x0
f010367e:	e9 fd 1f 02 00       	jmp    f0125680 <_alltraps>
f0103683:	90                   	nop    

f0103684 <handler10>:
  TRAPHANDLER(handler10, T_TSS);
f0103684:	6a 0a                	push   $0xa
f0103686:	e9 f5 1f 02 00       	jmp    f0125680 <_alltraps>
f010368b:	90                   	nop    

f010368c <handler11>:
  TRAPHANDLER(handler11, T_SEGNP);
f010368c:	6a 0b                	push   $0xb
f010368e:	e9 ed 1f 02 00       	jmp    f0125680 <_alltraps>
f0103693:	90                   	nop    

f0103694 <handler12>:
  TRAPHANDLER(handler12, T_STACK);
f0103694:	6a 0c                	push   $0xc
f0103696:	e9 e5 1f 02 00       	jmp    f0125680 <_alltraps>
f010369b:	90                   	nop    

f010369c <handler13>:
  TRAPHANDLER(handler13, T_GPFLT);
f010369c:	6a 0d                	push   $0xd
f010369e:	e9 dd 1f 02 00       	jmp    f0125680 <_alltraps>
f01036a3:	90                   	nop    

f01036a4 <handler14>:
  TRAPHANDLER(handler14, T_PGFLT);
f01036a4:	6a 0e                	push   $0xe
f01036a6:	e9 d5 1f 02 00       	jmp    f0125680 <_alltraps>
f01036ab:	90                   	nop    

f01036ac <handler15>:
/*handler15:*/
/*  TRAPHANDLER(RES, T_RES);*/
  TRAPHANDLER(handler15, T_PGFLT); // need for cleanliness of table
f01036ac:	6a 0e                	push   $0xe
f01036ae:	e9 cd 1f 02 00       	jmp    f0125680 <_alltraps>
f01036b3:	90                   	nop    

f01036b4 <handler16>:
  TRAPHANDLER_NOEC(handler16, T_FPERR);
f01036b4:	6a 00                	push   $0x0
f01036b6:	6a 10                	push   $0x10
f01036b8:	e9 c3 1f 02 00       	jmp    f0125680 <_alltraps>
f01036bd:	90                   	nop    

f01036be <handler17>:
  TRAPHANDLER_NOEC(handler17, T_ALIGN);
f01036be:	6a 00                	push   $0x0
f01036c0:	6a 11                	push   $0x11
f01036c2:	e9 b9 1f 02 00       	jmp    f0125680 <_alltraps>
f01036c7:	90                   	nop    

f01036c8 <handler18>:
  TRAPHANDLER_NOEC(handler18, T_MCHK);
f01036c8:	6a 00                	push   $0x0
f01036ca:	6a 12                	push   $0x12
f01036cc:	e9 af 1f 02 00       	jmp    f0125680 <_alltraps>
f01036d1:	90                   	nop    

f01036d2 <handler19>:
  TRAPHANDLER_NOEC(handler19, T_SIMDERR );
f01036d2:	6a 00                	push   $0x0
f01036d4:	6a 13                	push   $0x13
f01036d6:	e9 a5 1f 02 00       	jmp    f0125680 <_alltraps>
f01036db:	90                   	nop    

f01036dc <handler32>:

# vector table
.data
.globl irqs
irqs:
.text

  TRAPHANDLER_NOEC(handler32, IRQ_OFFSET + IRQ_TIMER);
f01036dc:	6a 00                	push   $0x0
f01036de:	6a 20                	push   $0x20
f01036e0:	e9 9b 1f 02 00       	jmp    f0125680 <_alltraps>
f01036e5:	90                   	nop    

f01036e6 <handler33>:
  TRAPHANDLER_NOEC(handler33, IRQ_OFFSET + IRQ_KBD);
f01036e6:	6a 00                	push   $0x0
f01036e8:	6a 21                	push   $0x21
f01036ea:	e9 91 1f 02 00       	jmp    f0125680 <_alltraps>
f01036ef:	90                   	nop    

f01036f0 <handler34>:
  TRAPHANDLER_NOEC(handler34, IRQ_OFFSET + 2);
f01036f0:	6a 00                	push   $0x0
f01036f2:	6a 22                	push   $0x22
f01036f4:	e9 87 1f 02 00       	jmp    f0125680 <_alltraps>
f01036f9:	90                   	nop    

f01036fa <handler35>:
  TRAPHANDLER_NOEC(handler35, IRQ_OFFSET + 3);
f01036fa:	6a 00                	push   $0x0
f01036fc:	6a 23                	push   $0x23
f01036fe:	e9 7d 1f 02 00       	jmp    f0125680 <_alltraps>
f0103703:	90                   	nop    

f0103704 <handler36>:
  TRAPHANDLER_NOEC(handler36, IRQ_OFFSET + 4);
f0103704:	6a 00                	push   $0x0
f0103706:	6a 24                	push   $0x24
f0103708:	e9 73 1f 02 00       	jmp    f0125680 <_alltraps>
f010370d:	90                   	nop    

f010370e <handler37>:
  TRAPHANDLER_NOEC(handler37, IRQ_OFFSET + 5);
f010370e:	6a 00                	push   $0x0
f0103710:	6a 25                	push   $0x25
f0103712:	e9 69 1f 02 00       	jmp    f0125680 <_alltraps>
f0103717:	90                   	nop    

f0103718 <handler38>:
  TRAPHANDLER_NOEC(handler38, IRQ_OFFSET + 6);
f0103718:	6a 00                	push   $0x0
f010371a:	6a 26                	push   $0x26
f010371c:	e9 5f 1f 02 00       	jmp    f0125680 <_alltraps>
f0103721:	90                   	nop    

f0103722 <handler39>:
  TRAPHANDLER_NOEC(handler39, IRQ_OFFSET + IRQ_SPURIOUS);
f0103722:	6a 00                	push   $0x0
f0103724:	6a 27                	push   $0x27
f0103726:	e9 55 1f 02 00       	jmp    f0125680 <_alltraps>
f010372b:	90                   	nop    

f010372c <handler40>:
  TRAPHANDLER_NOEC(handler40, IRQ_OFFSET + 8);
f010372c:	6a 00                	push   $0x0
f010372e:	6a 28                	push   $0x28
f0103730:	e9 4b 1f 02 00       	jmp    f0125680 <_alltraps>
f0103735:	90                   	nop    

f0103736 <handler41>:
  TRAPHANDLER_NOEC(handler41, IRQ_OFFSET + 9);
f0103736:	6a 00                	push   $0x0
f0103738:	6a 29                	push   $0x29
f010373a:	e9 41 1f 02 00       	jmp    f0125680 <_alltraps>
f010373f:	90                   	nop    

f0103740 <handler42>:
  TRAPHANDLER_NOEC(handler42, IRQ_OFFSET + 10);
f0103740:	6a 00                	push   $0x0
f0103742:	6a 2a                	push   $0x2a
f0103744:	e9 37 1f 02 00       	jmp    f0125680 <_alltraps>
f0103749:	90                   	nop    

f010374a <handler43>:
  TRAPHANDLER_NOEC(handler43, IRQ_OFFSET + 11);
f010374a:	6a 00                	push   $0x0
f010374c:	6a 2b                	push   $0x2b
f010374e:	e9 2d 1f 02 00       	jmp    f0125680 <_alltraps>
f0103753:	90                   	nop    

f0103754 <handler44>:
  TRAPHANDLER_NOEC(handler44, IRQ_OFFSET + 12);
f0103754:	6a 00                	push   $0x0
f0103756:	6a 2c                	push   $0x2c
f0103758:	e9 23 1f 02 00       	jmp    f0125680 <_alltraps>
f010375d:	90                   	nop    

f010375e <handler45>:
  TRAPHANDLER_NOEC(handler45, IRQ_OFFSET + 13);
f010375e:	6a 00                	push   $0x0
f0103760:	6a 2d                	push   $0x2d
f0103762:	e9 19 1f 02 00       	jmp    f0125680 <_alltraps>
f0103767:	90                   	nop    

f0103768 <handler46>:
  TRAPHANDLER_NOEC(handler46, IRQ_OFFSET + IRQ_IDE);
f0103768:	6a 00                	push   $0x0
f010376a:	6a 2e                	push   $0x2e
f010376c:	e9 0f 1f 02 00       	jmp    f0125680 <_alltraps>
f0103771:	90                   	nop    

f0103772 <handler47>:
  TRAPHANDLER_NOEC(handler47, IRQ_OFFSET + 14);
f0103772:	6a 00                	push   $0x0
f0103774:	6a 2e                	push   $0x2e
f0103776:	e9 05 1f 02 00       	jmp    f0125680 <_alltraps>
f010377b:	90                   	nop    

f010377c <handler48>:


  TRAPHANDLER_NOEC(handler48, T_SYSCALL);
f010377c:	6a 00                	push   $0x0
f010377e:	6a 30                	push   $0x30
f0103780:	e9 fb 1e 02 00       	jmp    f0125680 <_alltraps>
f0103785:	90                   	nop    

f0103786 <handler51>:
  TRAPHANDLER_NOEC(handler51, IRQ_OFFSET + IRQ_ERROR);
f0103786:	6a 00                	push   $0x0
f0103788:	6a 33                	push   $0x33
f010378a:	e9 f1 1e 02 00       	jmp    f0125680 <_alltraps>
f010378f:	90                   	nop    

f0103790 <handler500>:
  TRAPHANDLER_NOEC(handler500, T_DEFAULT);
f0103790:	6a 00                	push   $0x0
f0103792:	68 f4 01 00 00       	push   $0x1f4
f0103797:	e9 e4 1e 02 00       	jmp    f0125680 <_alltraps>

f010379c <sched_yield>:

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f010379c:	55                   	push   %ebp
f010379d:	89 e5                	mov    %esp,%ebp
f010379f:	57                   	push   %edi
f01037a0:	56                   	push   %esi
f01037a1:	53                   	push   %ebx
f01037a2:	83 ec 0c             	sub    $0xc,%esp
	// Implement simple round-robin scheduling.
	// Search through 'envs' for a runnable environment,
	// in circular fashion starting after the previously running env,
	// and switch to the first such environment found.
	// It's OK to choose the previously running env if no other env
	// is runnable.
	// But never choose envs[0], the idle environment,
	// unless NOTHING else is runnable.

	// LAB 4: Your code here.
        // seanyliu

        // calculate the previous environment index
        int previdx = 0;
f01037a5:	bf 00 00 00 00       	mov    $0x0,%edi
        if (curenv != NULL) {
f01037aa:	83 3d c4 5b 2f f0 00 	cmpl   $0x0,0xf02f5bc4
f01037b1:	74 0e                	je     f01037c1 <sched_yield+0x25>
          previdx = ENVX(curenv->env_id);
f01037b3:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f01037b8:	8b 78 4c             	mov    0x4c(%eax),%edi
f01037bb:	81 e7 ff 03 00 00    	and    $0x3ff,%edi
        }

        // LAB 4: Challenge
        // implement fixed priority scheduler
        int bidx; // base idx
        int eidx; // env idx
        int newidx = 0; // next priority to select
f01037c1:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
        int newpriority = ENV_PR_LOWEST - 1; // next priority's index
f01037c8:	c7 45 ec fd ff ff ff 	movl   $0xfffffffd,0xffffffec(%ebp)
        for (bidx = 0; bidx < NENV; bidx++) {
f01037cf:	bb 00 00 00 00       	mov    $0x0,%ebx
f01037d4:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f01037d9:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
          // for loop also checks the previous idx
          eidx = (bidx + previdx + 1) % NENV; // explicitly start at previdx+1
f01037dc:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
f01037df:	8d 51 01             	lea    0x1(%ecx),%edx
f01037e2:	89 d0                	mov    %edx,%eax
f01037e4:	85 d2                	test   %edx,%edx
f01037e6:	79 06                	jns    f01037ee <sched_yield+0x52>
f01037e8:	8d 81 00 04 00 00    	lea    0x400(%ecx),%eax
f01037ee:	25 00 fc ff ff       	and    $0xfffffc00,%eax
          if (eidx != 0) { // skip 0
f01037f3:	89 d1                	mov    %edx,%ecx
f01037f5:	29 c1                	sub    %eax,%ecx
f01037f7:	74 22                	je     f010381b <sched_yield+0x7f>
            if (envs[eidx].env_status == ENV_RUNNABLE) {
f01037f9:	8b 55 e8             	mov    0xffffffe8(%ebp),%edx
f01037fc:	89 c8                	mov    %ecx,%eax
f01037fe:	c1 e0 07             	shl    $0x7,%eax
f0103801:	83 7c 10 54 01       	cmpl   $0x1,0x54(%eax,%edx,1)
f0103806:	75 13                	jne    f010381b <sched_yield+0x7f>
              if (envs[eidx].env_priority > newpriority) {
f0103808:	8b 75 ec             	mov    0xffffffec(%ebp),%esi
f010380b:	39 74 10 7c          	cmp    %esi,0x7c(%eax,%edx,1)
f010380f:	7e 0a                	jle    f010381b <sched_yield+0x7f>
                newpriority = envs[eidx].env_priority;
f0103811:	8b 44 10 7c          	mov    0x7c(%eax,%edx,1),%eax
f0103815:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
                newidx = eidx;
f0103818:	89 4d f0             	mov    %ecx,0xfffffff0(%ebp)
f010381b:	43                   	inc    %ebx
f010381c:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
f0103822:	7e b8                	jle    f01037dc <sched_yield+0x40>
              }
            }
          }
        }
        if (newidx != 0) {
f0103824:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0103828:	74 15                	je     f010383f <sched_yield+0xa3>
          env_run(&envs[newidx]);
f010382a:	83 ec 0c             	sub    $0xc,%esp
f010382d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103830:	c1 e0 07             	shl    $0x7,%eax
f0103833:	03 05 c0 5b 2f f0    	add    0xf02f5bc0,%eax
f0103839:	50                   	push   %eax
f010383a:	e8 c8 f6 ff ff       	call   f0102f07 <env_run>
          return;
        }

        /*
        // select the next environment
        int newidx = previdx + 1;
        while (newidx != previdx) {
          if (newidx >= NENV) {
            newidx = 0;
            continue; // because you skip over 0
          }
          if (newidx != 0) { // skip 0
            if (envs[newidx].env_status == ENV_RUNNABLE) {
              env_run(&envs[newidx]);
              return;
            }
          }
          newidx++;
        }

        // didn't find another enviornment.  check the previous env.
        if (envs[previdx].env_status == ENV_RUNNABLE) {
          env_run(&envs[previdx]);
          return;
        }
        */

	// Run the special idle environment when nothing else is runnable.
	if (envs[0].env_status == ENV_RUNNABLE)
f010383f:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f0103844:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0103848:	75 09                	jne    f0103853 <sched_yield+0xb7>
		env_run(&envs[0]);
f010384a:	83 ec 0c             	sub    $0xc,%esp
f010384d:	50                   	push   %eax
f010384e:	e8 b4 f6 ff ff       	call   f0102f07 <env_run>
	else {
		cprintf("Destroyed all environments - nothing more to do!\n");
f0103853:	83 ec 0c             	sub    $0xc,%esp
f0103856:	68 6c 6e 10 f0       	push   $0xf0106e6c
f010385b:	e8 62 f8 ff ff       	call   f01030c2 <cprintf>
		while (1)
f0103860:	83 c4 10             	add    $0x10,%esp
			monitor(NULL);
f0103863:	83 ec 0c             	sub    $0xc,%esp
f0103866:	6a 00                	push   $0x0
f0103868:	e8 8b d2 ff ff       	call   f0100af8 <monitor>
f010386d:	83 c4 10             	add    $0x10,%esp
f0103870:	eb f1                	jmp    f0103863 <sched_yield+0xc7>
	...

f0103874 <sys_cputs>:
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
f0103874:	55                   	push   %ebp
f0103875:	89 e5                	mov    %esp,%ebp
f0103877:	56                   	push   %esi
f0103878:	53                   	push   %ebx
f0103879:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010387c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.
        user_mem_assert(curenv, s, len, PTE_U);
f010387f:	6a 04                	push   $0x4
f0103881:	56                   	push   %esi
f0103882:	53                   	push   %ebx
f0103883:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f0103889:	e8 75 e3 ff ff       	call   f0101c03 <user_mem_assert>
	
	// LAB 3: Your code here.

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f010388e:	83 c4 0c             	add    $0xc,%esp
f0103891:	53                   	push   %ebx
f0103892:	56                   	push   %esi
f0103893:	68 9e 6e 10 f0       	push   $0xf0106e9e
f0103898:	e8 25 f8 ff ff       	call   f01030c2 <cprintf>
}
f010389d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f01038a0:	5b                   	pop    %ebx
f01038a1:	5e                   	pop    %esi
f01038a2:	c9                   	leave  
f01038a3:	c3                   	ret    

f01038a4 <sys_cgetc>:

// Read a character from the system console.
// Returns the character.
static int
sys_cgetc(void)
{
f01038a4:	55                   	push   %ebp
f01038a5:	89 e5                	mov    %esp,%ebp
f01038a7:	83 ec 08             	sub    $0x8,%esp
	int c;

	// The cons_getc() primitive doesn't wait for a character,
	// but the sys_cgetc() system call does.
	while ((c = cons_getc()) == 0)
f01038aa:	e8 55 cd ff ff       	call   f0100604 <cons_getc>
f01038af:	85 c0                	test   %eax,%eax
f01038b1:	74 f7                	je     f01038aa <sys_cgetc+0x6>
		/* do nothing */;

	return c;
}
f01038b3:	c9                   	leave  
f01038b4:	c3                   	ret    

f01038b5 <sys_getenvid>:

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
f01038b5:	55                   	push   %ebp
f01038b6:	89 e5                	mov    %esp,%ebp
	return curenv->env_id;
f01038b8:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f01038bd:	8b 40 4c             	mov    0x4c(%eax),%eax
}
f01038c0:	c9                   	leave  
f01038c1:	c3                   	ret    

f01038c2 <sys_env_destroy>:

// Destroy a given environment (possibly the currently running environment).
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
f01038c2:	55                   	push   %ebp
f01038c3:	89 e5                	mov    %esp,%ebp
f01038c5:	83 ec 0c             	sub    $0xc,%esp
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f01038c8:	6a 01                	push   $0x1
f01038ca:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f01038cd:	50                   	push   %eax
f01038ce:	ff 75 08             	pushl  0x8(%ebp)
f01038d1:	e8 da ef ff ff       	call   f01028b0 <envid2env>
f01038d6:	83 c4 10             	add    $0x10,%esp
		return r;
f01038d9:	89 c2                	mov    %eax,%edx
f01038db:	85 c0                	test   %eax,%eax
f01038dd:	78 10                	js     f01038ef <sys_env_destroy+0x2d>
	env_destroy(e);
f01038df:	83 ec 0c             	sub    $0xc,%esp
f01038e2:	ff 75 fc             	pushl  0xfffffffc(%ebp)
f01038e5:	e8 c8 f5 ff ff       	call   f0102eb2 <env_destroy>
	return 0;
f01038ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
f01038ef:	89 d0                	mov    %edx,%eax
f01038f1:	c9                   	leave  
f01038f2:	c3                   	ret    

f01038f3 <sys_yield>:

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
f01038f3:	55                   	push   %ebp
f01038f4:	89 e5                	mov    %esp,%ebp
f01038f6:	83 ec 08             	sub    $0x8,%esp
	sched_yield();
f01038f9:	e8 9e fe ff ff       	call   f010379c <sched_yield>

f01038fe <sys_exofork>:
}

// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
static envid_t
sys_exofork(void)
{
f01038fe:	55                   	push   %ebp
f01038ff:	89 e5                	mov    %esp,%ebp
f0103901:	83 ec 10             	sub    $0x10,%esp
	// Create the new environment with env_alloc(), from kern/env.c.
	// It should be left as env_alloc created it, except that
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	// LAB 4: Your code here.
	//panic("sys_exofork not implemented");

        struct Env *new_env;
        int create_status;

        // create a new environment, with parent being current env
        if ((create_status = env_alloc(&new_env, curenv->env_id)) < 0) {
f0103904:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103909:	ff 70 4c             	pushl  0x4c(%eax)
f010390c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f010390f:	50                   	push   %eax
f0103910:	e8 9b f1 ff ff       	call   f0102ab0 <env_alloc>
f0103915:	83 c4 10             	add    $0x10,%esp
          return create_status; // env_alloc can return -E_NO_FREE_ENV
f0103918:	89 c2                	mov    %eax,%edx
f010391a:	85 c0                	test   %eax,%eax
f010391c:	78 2d                	js     f010394b <sys_exofork+0x4d>
        }

	// status is set to ENV_NOT_RUNNABLE
        new_env->env_status = ENV_NOT_RUNNABLE;
f010391e:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f0103921:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)

        // register set is copied from the current environment
        // -- but tweaked so sys_exofork will appear to return 0
        memmove(&new_env->env_tf, &curenv->env_tf, sizeof(curenv->env_tf));
f0103928:	83 ec 04             	sub    $0x4,%esp
f010392b:	6a 44                	push   $0x44
f010392d:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f0103933:	ff 75 fc             	pushl  0xfffffffc(%ebp)
f0103936:	e8 a9 13 00 00       	call   f0104ce4 <memmove>
        // Why do we put eax = 0?  See:
        // http://pdos.csail.mit.edu/6.828/2009/xv6-book/trap.pdf
        // Syscall records the return value of the system call function in %eax.
        new_env->env_tf.tf_regs.reg_eax = (uint32_t) 0;
f010393b:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f010393e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

        return new_env->env_id;
f0103945:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f0103948:	8b 50 4c             	mov    0x4c(%eax),%edx
}
f010394b:	89 d0                	mov    %edx,%eax
f010394d:	c9                   	leave  
f010394e:	c3                   	ret    

f010394f <sys_env_set_status>:

// Set envid's env_status to status, which must be ENV_RUNNABLE
// or ENV_NOT_RUNNABLE.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
f010394f:	55                   	push   %ebp
f0103950:	89 e5                	mov    %esp,%ebp
f0103952:	53                   	push   %ebx
f0103953:	83 ec 08             	sub    $0x8,%esp
f0103956:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
f0103959:	6a 01                	push   $0x1
f010395b:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
f010395e:	50                   	push   %eax
f010395f:	ff 75 08             	pushl  0x8(%ebp)
f0103962:	e8 49 ef ff ff       	call   f01028b0 <envid2env>
f0103967:	83 c4 10             	add    $0x10,%esp
	  return r;
f010396a:	89 c2                	mov    %eax,%edx
f010396c:	85 c0                	test   %eax,%eax
f010396e:	78 18                	js     f0103988 <sys_env_set_status+0x39>
        }
        if ((status == ENV_RUNNABLE) || (status == ENV_NOT_RUNNABLE)) {
f0103970:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
          env->env_status = status;
        } else {
          return -E_INVAL;
f0103973:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103978:	83 f8 01             	cmp    $0x1,%eax
f010397b:	77 0b                	ja     f0103988 <sys_env_set_status+0x39>
f010397d:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
f0103980:	89 58 54             	mov    %ebx,0x54(%eax)
        }

        return 0;
f0103983:	ba 00 00 00 00       	mov    $0x0,%edx
	// panic("sys_env_set_status not implemented");
}
f0103988:	89 d0                	mov    %edx,%eax
f010398a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f010398d:	c9                   	leave  
f010398e:	c3                   	ret    

f010398f <sys_env_set_trapframe>:

// Set envid's trap frame to 'tf'.
// tf is modified to make sure that user environments always run at code
// protection level 3 (CPL 3) with interrupts enabled.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
f010398f:	55                   	push   %ebp
f0103990:	89 e5                	mov    %esp,%ebp
f0103992:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
        int r;
        struct Env *env;
        if ((r = envid2env(envid, &env, 1)) < 0) {
f0103995:	6a 01                	push   $0x1
f0103997:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f010399a:	50                   	push   %eax
f010399b:	ff 75 08             	pushl  0x8(%ebp)
f010399e:	e8 0d ef ff ff       	call   f01028b0 <envid2env>
f01039a3:	83 c4 10             	add    $0x10,%esp
          return r;
f01039a6:	89 c2                	mov    %eax,%edx
f01039a8:	85 c0                	test   %eax,%eax
f01039aa:	78 27                	js     f01039d3 <sys_env_set_trapframe+0x44>
        }
        env->env_tf = *tf;
f01039ac:	83 ec 04             	sub    $0x4,%esp
f01039af:	6a 44                	push   $0x44
f01039b1:	ff 75 0c             	pushl  0xc(%ebp)
f01039b4:	ff 75 fc             	pushl  0xfffffffc(%ebp)
f01039b7:	e8 93 13 00 00       	call   f0104d4f <memcpy>
        env->env_tf.tf_cs |= 3;
f01039bc:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f01039bf:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
        env->env_tf.tf_eflags |= FL_IF;
f01039c4:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f01039c7:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
        return 0;
f01039ce:	ba 00 00 00 00       	mov    $0x0,%edx

	//panic("sys_set_trapframe not implemented");
}
f01039d3:	89 d0                	mov    %edx,%eax
f01039d5:	c9                   	leave  
f01039d6:	c3                   	ret    

f01039d7 <sys_env_set_pgfault_upcall>:

// Set the page fault upcall for 'envid' by modifying the corresponding struct
// Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// kernel will push a fault record onto the exception stack, then branch to
// 'func'.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
f01039d7:	55                   	push   %ebp
f01039d8:	89 e5                	mov    %esp,%ebp
f01039da:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
        // seanyliu

        int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
f01039dd:	6a 01                	push   $0x1
f01039df:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f01039e2:	50                   	push   %eax
f01039e3:	ff 75 08             	pushl  0x8(%ebp)
f01039e6:	e8 c5 ee ff ff       	call   f01028b0 <envid2env>
f01039eb:	83 c4 10             	add    $0x10,%esp
	  return r;
f01039ee:	89 c2                	mov    %eax,%edx
f01039f0:	85 c0                	test   %eax,%eax
f01039f2:	78 0e                	js     f0103a02 <sys_env_set_pgfault_upcall+0x2b>
        }

        env->env_pgfault_upcall = func;
f01039f4:	8b 55 0c             	mov    0xc(%ebp),%edx
f01039f7:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f01039fa:	89 50 64             	mov    %edx,0x64(%eax)

        return 0;
f01039fd:	ba 00 00 00 00       	mov    $0x0,%edx
        
	//panic("sys_env_set_pgfault_upcall not implemented");
}
f0103a02:	89 d0                	mov    %edx,%eax
f0103a04:	c9                   	leave  
f0103a05:	c3                   	ret    

f0103a06 <sys_page_alloc>:

// Allocate a page of memory and map it at 'va' with permission
// 'perm' in the address space of 'envid'.
// The page's contents are set to 0.
// If a page is already mapped at 'va', that page is unmapped as a
// side effect.
//
// perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
//         but no other bits may be set.  See PTE_USER in inc/mmu.h.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
f0103a06:	55                   	push   %ebp
f0103a07:	89 e5                	mov    %esp,%ebp
f0103a09:	57                   	push   %edi
f0103a0a:	56                   	push   %esi
f0103a0b:	53                   	push   %ebx
f0103a0c:	83 ec 10             	sub    $0x10,%esp
f0103a0f:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103a12:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Hint: This function is a wrapper around page_alloc() and
	//   page_insert() from kern/pmap.c.
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 4: Your code here.
        // seanyliu

        int r;
        struct Env *env;
        struct Page *env_page;

	if ((r = envid2env(envid, &env, 1)) < 0) {
f0103a15:	6a 01                	push   $0x1
f0103a17:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0103a1a:	50                   	push   %eax
f0103a1b:	ff 75 08             	pushl  0x8(%ebp)
f0103a1e:	e8 8d ee ff ff       	call   f01028b0 <envid2env>
f0103a23:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103a26:	89 c2                	mov    %eax,%edx
f0103a28:	85 c0                	test   %eax,%eax
f0103a2a:	0f 88 f9 00 00 00    	js     f0103b29 <sys_page_alloc+0x123>
        }

        // check that va is valid
        if ((int)va >= UTOP) { // kernel space
          return -E_INVAL;
f0103a30:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103a35:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f0103a3b:	0f 87 e8 00 00 00    	ja     f0103b29 <sys_page_alloc+0x123>
        }
        if (va != ROUNDUP(va, PGSIZE)) { // page alignment
f0103a41:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
f0103a47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103a4c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103a51:	39 f0                	cmp    %esi,%eax
f0103a53:	0f 85 d0 00 00 00    	jne    f0103b29 <sys_page_alloc+0x123>
        }

        // Check the permission bits
        if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
f0103a59:	89 f8                	mov    %edi,%eax
f0103a5b:	83 e0 05             	and    $0x5,%eax
          return -E_INVAL;
f0103a5e:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103a63:	83 f8 05             	cmp    $0x5,%eax
f0103a66:	0f 85 bd 00 00 00    	jne    f0103b29 <sys_page_alloc+0x123>
        }
        if ((perm | PTE_USER) != PTE_USER) {
f0103a6c:	89 f8                	mov    %edi,%eax
f0103a6e:	0d 07 0e 00 00       	or     $0xe07,%eax
          return -E_INVAL;
f0103a73:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103a78:	3d 07 0e 00 00       	cmp    $0xe07,%eax
f0103a7d:	0f 85 a6 00 00 00    	jne    f0103b29 <sys_page_alloc+0x123>
        }

        if ((r = page_alloc(&env_page)) < 0) {
f0103a83:	83 ec 0c             	sub    $0xc,%esp
f0103a86:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0103a89:	50                   	push   %eax
f0103a8a:	e8 17 dd ff ff       	call   f01017a6 <page_alloc>
f0103a8f:	83 c4 10             	add    $0x10,%esp
          return r; // -E_NO_MEM
f0103a92:	89 c2                	mov    %eax,%edx
f0103a94:	85 c0                	test   %eax,%eax
f0103a96:	0f 88 8d 00 00 00    	js     f0103b29 <sys_page_alloc+0x123>
        }
        if ((r = page_insert(env->env_pgdir, env_page, va, perm)) < 0) {
f0103a9c:	57                   	push   %edi
f0103a9d:	56                   	push   %esi
f0103a9e:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0103aa1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103aa4:	ff 70 5c             	pushl  0x5c(%eax)
f0103aa7:	e8 b1 de ff ff       	call   f010195d <page_insert>
f0103aac:	89 c3                	mov    %eax,%ebx
f0103aae:	83 c4 10             	add    $0x10,%esp
f0103ab1:	85 c0                	test   %eax,%eax
f0103ab3:	79 0f                	jns    f0103ac4 <sys_page_alloc+0xbe>
          // deallocate the page
          page_free(env_page);
f0103ab5:	83 ec 0c             	sub    $0xc,%esp
f0103ab8:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0103abb:	e8 2b dd ff ff       	call   f01017eb <page_free>
          return r; // -E_NO_MEM
f0103ac0:	89 da                	mov    %ebx,%edx
f0103ac2:	eb 65                	jmp    f0103b29 <sys_page_alloc+0x123>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0103ac4:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
f0103ac7:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0103acd:	c1 fa 02             	sar    $0x2,%edx
f0103ad0:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0103ad3:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0103ad6:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0103ad9:	89 c1                	mov    %eax,%ecx
f0103adb:	c1 e1 08             	shl    $0x8,%ecx
f0103ade:	01 c8                	add    %ecx,%eax
f0103ae0:	89 c1                	mov    %eax,%ecx
f0103ae2:	c1 e1 10             	shl    $0x10,%ecx
f0103ae5:	01 c8                	add    %ecx,%eax
f0103ae7:	8d 04 42             	lea    (%edx,%eax,2),%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0103aea:	89 c2                	mov    %eax,%edx
f0103aec:	c1 e2 0c             	shl    $0xc,%edx
	return page2ppn(pp) << PGSHIFT;
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
		panic("pa2page called with invalid pa");
	return &pages[PPN(pa)];
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0103aef:	89 d0                	mov    %edx,%eax
f0103af1:	c1 e8 0c             	shr    $0xc,%eax
f0103af4:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0103afa:	72 12                	jb     f0103b0e <sys_page_alloc+0x108>
f0103afc:	52                   	push   %edx
f0103afd:	68 ac 62 10 f0       	push   $0xf01062ac
f0103b02:	6a 5b                	push   $0x5b
f0103b04:	68 76 5f 10 f0       	push   $0xf0105f76
f0103b09:	e8 db c5 ff ff       	call   f01000e9 <_panic>
f0103b0e:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f0103b14:	83 ec 04             	sub    $0x4,%esp
f0103b17:	68 00 10 00 00       	push   $0x1000
f0103b1c:	6a 00                	push   $0x0
f0103b1e:	50                   	push   %eax
f0103b1f:	e8 6d 11 00 00       	call   f0104c91 <memset>
        }

        // The page's contents are set to 0.
        memset(page2kva(env_page), 0, PGSIZE);

        return 0;
f0103b24:	ba 00 00 00 00       	mov    $0x0,%edx
	//panic("sys_page_alloc not implemented");
}
f0103b29:	89 d0                	mov    %edx,%eax
f0103b2b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0103b2e:	5b                   	pop    %ebx
f0103b2f:	5e                   	pop    %esi
f0103b30:	5f                   	pop    %edi
f0103b31:	c9                   	leave  
f0103b32:	c3                   	ret    

f0103b33 <sys_page_map_wopermcheck>:


// need this for sys_ipc_try_send
static int
sys_page_map_wopermcheck(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
f0103b33:	55                   	push   %ebp
f0103b34:	89 e5                	mov    %esp,%ebp
f0103b36:	57                   	push   %edi
f0103b37:	56                   	push   %esi
f0103b38:	53                   	push   %ebx
f0103b39:	83 ec 10             	sub    $0x10,%esp
f0103b3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103b3f:	8b 75 14             	mov    0x14(%ebp),%esi
f0103b42:	8b 7d 18             	mov    0x18(%ebp),%edi
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.
        // seanyliu
        int r;
        pte_t *src_pte;
        pte_t *dst_pte;
        struct Env *src_env;
        struct Env *dst_env;
        struct Page *src_page;

        // -E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
        // or the caller doesn't have permission to change one of them.
	if ((r = envid2env(srcenvid, &src_env, 0)) < 0) {
f0103b45:	6a 00                	push   $0x0
f0103b47:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0103b4a:	50                   	push   %eax
f0103b4b:	ff 75 08             	pushl  0x8(%ebp)
f0103b4e:	e8 5d ed ff ff       	call   f01028b0 <envid2env>
f0103b53:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103b56:	89 c2                	mov    %eax,%edx
f0103b58:	85 c0                	test   %eax,%eax
f0103b5a:	0f 88 e0 00 00 00    	js     f0103c40 <sys_page_map_wopermcheck+0x10d>
        }
	if ((r = envid2env(dstenvid, &dst_env, 0)) < 0) {
f0103b60:	83 ec 04             	sub    $0x4,%esp
f0103b63:	6a 00                	push   $0x0
f0103b65:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0103b68:	50                   	push   %eax
f0103b69:	ff 75 10             	pushl  0x10(%ebp)
f0103b6c:	e8 3f ed ff ff       	call   f01028b0 <envid2env>
f0103b71:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103b74:	89 c2                	mov    %eax,%edx
f0103b76:	85 c0                	test   %eax,%eax
f0103b78:	0f 88 c2 00 00 00    	js     f0103c40 <sys_page_map_wopermcheck+0x10d>
        }

        // check that srcva is valid
        if ((int)srcva >= UTOP) { // kernel space
          return -E_INVAL;
f0103b7e:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103b83:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103b89:	0f 87 b1 00 00 00    	ja     f0103c40 <sys_page_map_wopermcheck+0x10d>
        }
        if (srcva != ROUNDUP(srcva, PGSIZE)) { // page alignment
f0103b8f:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0103b95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103b9a:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103b9f:	39 d8                	cmp    %ebx,%eax
f0103ba1:	0f 85 99 00 00 00    	jne    f0103c40 <sys_page_map_wopermcheck+0x10d>
        }

        // check that dstva is valid
        if ((int)dstva >= UTOP) { // kernel space
          return -E_INVAL;
f0103ba7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103bac:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f0103bb2:	0f 87 88 00 00 00    	ja     f0103c40 <sys_page_map_wopermcheck+0x10d>
        }
        if (dstva != ROUNDUP(dstva, PGSIZE)) { // page alignment
f0103bb8:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
f0103bbe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103bc3:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103bc8:	39 f0                	cmp    %esi,%eax
f0103bca:	75 74                	jne    f0103c40 <sys_page_map_wopermcheck+0x10d>
        }

        // -E_INVAL if srcva is not mapped in srcenvid's address space.
        src_page = page_lookup(src_env->env_pgdir, srcva, &src_pte);
f0103bcc:	83 ec 04             	sub    $0x4,%esp
f0103bcf:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0103bd2:	50                   	push   %eax
f0103bd3:	53                   	push   %ebx
f0103bd4:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103bd7:	ff 70 5c             	pushl  0x5c(%eax)
f0103bda:	e8 d6 de ff ff       	call   f0101ab5 <page_lookup>
f0103bdf:	89 c1                	mov    %eax,%ecx
        if (src_page == NULL) {
f0103be1:	83 c4 10             	add    $0x10,%esp
          return -E_INVAL;
f0103be4:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103be9:	85 c0                	test   %eax,%eax
f0103beb:	74 53                	je     f0103c40 <sys_page_map_wopermcheck+0x10d>
        }

        // Check the permission bits
        if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
f0103bed:	89 f8                	mov    %edi,%eax
f0103bef:	83 e0 05             	and    $0x5,%eax
          return -E_INVAL;
f0103bf2:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103bf7:	83 f8 05             	cmp    $0x5,%eax
f0103bfa:	75 44                	jne    f0103c40 <sys_page_map_wopermcheck+0x10d>
        }
        if ((perm | PTE_USER) != PTE_USER) {
f0103bfc:	89 f8                	mov    %edi,%eax
f0103bfe:	0d 07 0e 00 00       	or     $0xe07,%eax
          return -E_INVAL;
f0103c03:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103c08:	3d 07 0e 00 00       	cmp    $0xe07,%eax
f0103c0d:	75 31                	jne    f0103c40 <sys_page_map_wopermcheck+0x10d>
        }

        // -E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
        // address space.
        if ((perm & PTE_W) && (!(*src_pte & PTE_W))) {
f0103c0f:	f7 c7 02 00 00 00    	test   $0x2,%edi
f0103c15:	74 0d                	je     f0103c24 <sys_page_map_wopermcheck+0xf1>
          return -E_INVAL;
f0103c17:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103c1c:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f0103c1f:	f6 00 02             	testb  $0x2,(%eax)
f0103c22:	74 1c                	je     f0103c40 <sys_page_map_wopermcheck+0x10d>
        }

        // Map the page of memory at 'srcva' in srcenvid's address space
        // at 'dstva' in dstenvid's address space with permission 'perm'.
        // Perm has the same restrictions as in sys_page_alloc, except
        // that it also must not grant write access to a read-only
        // page.
        if ((r = page_insert(dst_env->env_pgdir, src_page, dstva, perm)) < 0) {
f0103c24:	57                   	push   %edi
f0103c25:	56                   	push   %esi
f0103c26:	51                   	push   %ecx
f0103c27:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0103c2a:	ff 70 5c             	pushl  0x5c(%eax)
f0103c2d:	e8 2b dd ff ff       	call   f010195d <page_insert>
f0103c32:	83 c4 10             	add    $0x10,%esp
          return r; // -E_NO_MEM
f0103c35:	89 c2                	mov    %eax,%edx
f0103c37:	85 c0                	test   %eax,%eax
f0103c39:	78 05                	js     f0103c40 <sys_page_map_wopermcheck+0x10d>
        }

        return 0;
f0103c3b:	ba 00 00 00 00       	mov    $0x0,%edx
	// panic("sys_page_map not implemented");
}
f0103c40:	89 d0                	mov    %edx,%eax
f0103c42:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0103c45:	5b                   	pop    %ebx
f0103c46:	5e                   	pop    %esi
f0103c47:	5f                   	pop    %edi
f0103c48:	c9                   	leave  
f0103c49:	c3                   	ret    

f0103c4a <sys_page_map>:



// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Map the page of memory at 'srcva' in srcenvid's address space
// at 'dstva' in dstenvid's address space with permission 'perm'.
// Perm has the same restrictions as in sys_page_alloc, except
// that it also must not grant write access to a read-only
// page.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
//		or the caller doesn't have permission to change one of them.
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or dstva >= UTOP or dstva is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
f0103c4a:	55                   	push   %ebp
f0103c4b:	89 e5                	mov    %esp,%ebp
f0103c4d:	57                   	push   %edi
f0103c4e:	56                   	push   %esi
f0103c4f:	53                   	push   %ebx
f0103c50:	83 ec 10             	sub    $0x10,%esp
f0103c53:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103c56:	8b 75 14             	mov    0x14(%ebp),%esi
f0103c59:	8b 7d 18             	mov    0x18(%ebp),%edi
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.
        // seanyliu
        int r;
        pte_t *src_pte;
        pte_t *dst_pte;
        struct Env *src_env;
        struct Env *dst_env;
        struct Page *src_page;

        // -E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
        // or the caller doesn't have permission to change one of them.
	if ((r = envid2env(srcenvid, &src_env, 1)) < 0) {
f0103c5c:	6a 01                	push   $0x1
f0103c5e:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0103c61:	50                   	push   %eax
f0103c62:	ff 75 08             	pushl  0x8(%ebp)
f0103c65:	e8 46 ec ff ff       	call   f01028b0 <envid2env>
f0103c6a:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103c6d:	89 c2                	mov    %eax,%edx
f0103c6f:	85 c0                	test   %eax,%eax
f0103c71:	0f 88 e0 00 00 00    	js     f0103d57 <sys_page_map+0x10d>
        }
	if ((r = envid2env(dstenvid, &dst_env, 1)) < 0) {
f0103c77:	83 ec 04             	sub    $0x4,%esp
f0103c7a:	6a 01                	push   $0x1
f0103c7c:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0103c7f:	50                   	push   %eax
f0103c80:	ff 75 10             	pushl  0x10(%ebp)
f0103c83:	e8 28 ec ff ff       	call   f01028b0 <envid2env>
f0103c88:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103c8b:	89 c2                	mov    %eax,%edx
f0103c8d:	85 c0                	test   %eax,%eax
f0103c8f:	0f 88 c2 00 00 00    	js     f0103d57 <sys_page_map+0x10d>
        }

        // check that srcva is valid
        if ((int)srcva >= UTOP) { // kernel space
          return -E_INVAL;
f0103c95:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103c9a:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103ca0:	0f 87 b1 00 00 00    	ja     f0103d57 <sys_page_map+0x10d>
        }
        if (srcva != ROUNDUP(srcva, PGSIZE)) { // page alignment
f0103ca6:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0103cac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103cb1:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103cb6:	39 d8                	cmp    %ebx,%eax
f0103cb8:	0f 85 99 00 00 00    	jne    f0103d57 <sys_page_map+0x10d>
        }

        // check that dstva is valid
        if ((int)dstva >= UTOP) { // kernel space
          return -E_INVAL;
f0103cbe:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103cc3:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f0103cc9:	0f 87 88 00 00 00    	ja     f0103d57 <sys_page_map+0x10d>
        }
        if (dstva != ROUNDUP(dstva, PGSIZE)) { // page alignment
f0103ccf:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
f0103cd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103cda:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103cdf:	39 f0                	cmp    %esi,%eax
f0103ce1:	75 74                	jne    f0103d57 <sys_page_map+0x10d>
        }

        // -E_INVAL if srcva is not mapped in srcenvid's address space.
        src_page = page_lookup(src_env->env_pgdir, srcva, &src_pte);
f0103ce3:	83 ec 04             	sub    $0x4,%esp
f0103ce6:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0103ce9:	50                   	push   %eax
f0103cea:	53                   	push   %ebx
f0103ceb:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103cee:	ff 70 5c             	pushl  0x5c(%eax)
f0103cf1:	e8 bf dd ff ff       	call   f0101ab5 <page_lookup>
f0103cf6:	89 c1                	mov    %eax,%ecx
        if (src_page == NULL) {
f0103cf8:	83 c4 10             	add    $0x10,%esp
          return -E_INVAL;
f0103cfb:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d00:	85 c0                	test   %eax,%eax
f0103d02:	74 53                	je     f0103d57 <sys_page_map+0x10d>
        }

        // Check the permission bits
        if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
f0103d04:	89 f8                	mov    %edi,%eax
f0103d06:	83 e0 05             	and    $0x5,%eax
          return -E_INVAL;
f0103d09:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d0e:	83 f8 05             	cmp    $0x5,%eax
f0103d11:	75 44                	jne    f0103d57 <sys_page_map+0x10d>
        }
        if ((perm | PTE_USER) != PTE_USER) {
f0103d13:	89 f8                	mov    %edi,%eax
f0103d15:	0d 07 0e 00 00       	or     $0xe07,%eax
          return -E_INVAL;
f0103d1a:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d1f:	3d 07 0e 00 00       	cmp    $0xe07,%eax
f0103d24:	75 31                	jne    f0103d57 <sys_page_map+0x10d>
        }

        // -E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
        // address space.
        if ((perm & PTE_W) && (!(*src_pte & PTE_W))) {
f0103d26:	f7 c7 02 00 00 00    	test   $0x2,%edi
f0103d2c:	74 0d                	je     f0103d3b <sys_page_map+0xf1>
          return -E_INVAL;
f0103d2e:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d33:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f0103d36:	f6 00 02             	testb  $0x2,(%eax)
f0103d39:	74 1c                	je     f0103d57 <sys_page_map+0x10d>
        }

        // Map the page of memory at 'srcva' in srcenvid's address space
        // at 'dstva' in dstenvid's address space with permission 'perm'.
        // Perm has the same restrictions as in sys_page_alloc, except
        // that it also must not grant write access to a read-only
        // page.
        if ((r = page_insert(dst_env->env_pgdir, src_page, dstva, perm)) < 0) {
f0103d3b:	57                   	push   %edi
f0103d3c:	56                   	push   %esi
f0103d3d:	51                   	push   %ecx
f0103d3e:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0103d41:	ff 70 5c             	pushl  0x5c(%eax)
f0103d44:	e8 14 dc ff ff       	call   f010195d <page_insert>
f0103d49:	83 c4 10             	add    $0x10,%esp
          return r; // -E_NO_MEM
f0103d4c:	89 c2                	mov    %eax,%edx
f0103d4e:	85 c0                	test   %eax,%eax
f0103d50:	78 05                	js     f0103d57 <sys_page_map+0x10d>
        }

        return 0;
f0103d52:	ba 00 00 00 00       	mov    $0x0,%edx
	// panic("sys_page_map not implemented");
}
f0103d57:	89 d0                	mov    %edx,%eax
f0103d59:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0103d5c:	5b                   	pop    %ebx
f0103d5d:	5e                   	pop    %esi
f0103d5e:	5f                   	pop    %edi
f0103d5f:	c9                   	leave  
f0103d60:	c3                   	ret    

f0103d61 <sys_page_unmap>:

// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, void *va)
{
f0103d61:	55                   	push   %ebp
f0103d62:	89 e5                	mov    %esp,%ebp
f0103d64:	53                   	push   %ebx
f0103d65:	83 ec 08             	sub    $0x8,%esp
f0103d68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
        // seanyliu

        int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
f0103d6b:	6a 01                	push   $0x1
f0103d6d:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
f0103d70:	50                   	push   %eax
f0103d71:	ff 75 08             	pushl  0x8(%ebp)
f0103d74:	e8 37 eb ff ff       	call   f01028b0 <envid2env>
f0103d79:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103d7c:	89 c2                	mov    %eax,%edx
f0103d7e:	85 c0                	test   %eax,%eax
f0103d80:	78 35                	js     f0103db7 <sys_page_unmap+0x56>
        }

        // check that srcva is valid
        if ((int)va >= UTOP) { // kernel space
          return -E_INVAL;
f0103d82:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d87:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103d8d:	77 28                	ja     f0103db7 <sys_page_unmap+0x56>
        }
        if (va != ROUNDUP(va, PGSIZE)) { // page alignment
f0103d8f:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0103d95:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103d9a:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d9f:	39 d8                	cmp    %ebx,%eax
f0103da1:	75 14                	jne    f0103db7 <sys_page_unmap+0x56>
        }

        page_remove(env->env_pgdir, va);
f0103da3:	83 ec 08             	sub    $0x8,%esp
f0103da6:	53                   	push   %ebx
f0103da7:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
f0103daa:	ff 70 5c             	pushl  0x5c(%eax)
f0103dad:	e8 72 dd ff ff       	call   f0101b24 <page_remove>

        return 0;
f0103db2:	ba 00 00 00 00       	mov    $0x0,%edx

	//panic("sys_page_unmap not implemented");
}
f0103db7:	89 d0                	mov    %edx,%eax
f0103db9:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0103dbc:	c9                   	leave  
f0103dbd:	c3                   	ret    

f0103dbe <sys_ipc_try_send>:

// Try to send 'value' to the target env 'envid'.
// If srcva < UTOP, then also send page currently mapped at 'srcva',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target has not requested IPC with sys_ipc_recv.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused ipc_recv system call.
//
// If the sender sends a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc only happens when no errors occur.
//
// Returns 0 on success where no page mapping occurs,
// 1 on success where a page mapping occurs, and < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
f0103dbe:	55                   	push   %ebp
f0103dbf:	89 e5                	mov    %esp,%ebp
f0103dc1:	57                   	push   %edi
f0103dc2:	56                   	push   %esi
f0103dc3:	53                   	push   %ebx
f0103dc4:	83 ec 10             	sub    $0x10,%esp
f0103dc7:	8b 75 08             	mov    0x8(%ebp),%esi
f0103dca:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0103dcd:	8b 7d 14             	mov    0x14(%ebp),%edi
  // LAB 4: Your code here.
  //panic("sys_ipc_try_send not implemented");
  // seanyliu
  int r;
  struct Env *target_env;
  struct Page *src_page;
  struct Page *dst_page;
  pte_t *src_pte;

  // -E_BAD_ENV if environment envid doesn't currently exist.
  if ((r = envid2env(envid, &target_env, 0)) < 0) return r;
f0103dd0:	6a 00                	push   $0x0
f0103dd2:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0103dd5:	50                   	push   %eax
f0103dd6:	56                   	push   %esi
f0103dd7:	e8 d4 ea ff ff       	call   f01028b0 <envid2env>
f0103ddc:	83 c4 10             	add    $0x10,%esp
f0103ddf:	89 c2                	mov    %eax,%edx
f0103de1:	85 c0                	test   %eax,%eax
f0103de3:	0f 88 92 00 00 00    	js     f0103e7b <sys_ipc_try_send+0xbd>

  // -E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
  // or another environment managed to send first.
  if (target_env->env_ipc_recving != 1) {
    return -E_IPC_NOT_RECV;
f0103de9:	ba f9 ff ff ff       	mov    $0xfffffff9,%edx
f0103dee:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103df1:	83 78 68 01          	cmpl   $0x1,0x68(%eax)
f0103df5:	0f 85 80 00 00 00    	jne    f0103e7b <sys_ipc_try_send+0xbd>
  }

  if (((int)srcva < UTOP) && (target_env->env_ipc_dstva != 0)) {
f0103dfb:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103e01:	77 26                	ja     f0103e29 <sys_ipc_try_send+0x6b>
f0103e03:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e06:	83 78 6c 00          	cmpl   $0x0,0x6c(%eax)
f0103e0a:	74 1d                	je     f0103e29 <sys_ipc_try_send+0x6b>
    // -E_INVAL if srcva < UTOP but srcva is not page-aligned.
    // -E_INVAL if srcva < UTOP and perm is inappropriate
    //   (see sys_page_alloc).
    // -E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
    //   address space.
    // -E_INVAL if (perm & PTE_W), but srcva is read-only in the
    //   current environment's address space.
    // -E_NO_MEM if there's not enough memory to map srcva in envid's
    //   address space.
    r = sys_page_map_wopermcheck(sys_getenvid(), srcva, envid, target_env->env_ipc_dstva, perm);
f0103e0c:	83 ec 0c             	sub    $0xc,%esp
f0103e0f:	57                   	push   %edi
f0103e10:	ff 70 6c             	pushl  0x6c(%eax)
f0103e13:	56                   	push   %esi
f0103e14:	53                   	push   %ebx
f0103e15:	e8 9b fa ff ff       	call   f01038b5 <sys_getenvid>
f0103e1a:	50                   	push   %eax
f0103e1b:	e8 13 fd ff ff       	call   f0103b33 <sys_page_map_wopermcheck>
    if (r < 0) return r;
f0103e20:	83 c4 20             	add    $0x20,%esp
f0103e23:	89 c2                	mov    %eax,%edx
f0103e25:	85 c0                	test   %eax,%eax
f0103e27:	78 52                	js     f0103e7b <sys_ipc_try_send+0xbd>
  }

  // Otherwise, the send succeeds, and the target's ipc fields are
  // updated as follows:
  //    env_ipc_recving is set to 0 to block future sends;
  //    env_ipc_from is set to the sending envid;
  //    env_ipc_value is set to the 'value' parameter;
  //    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
  // The target environment is marked runnable again, returning 0
  // from the paused ipc_recv system call.
  target_env->env_ipc_recving = 0;
f0103e29:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e2c:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  target_env->env_ipc_from = sys_getenvid();
f0103e33:	e8 7d fa ff ff       	call   f01038b5 <sys_getenvid>
f0103e38:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
f0103e3b:	89 42 74             	mov    %eax,0x74(%edx)
  target_env->env_ipc_value = value;
f0103e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103e41:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e44:	89 50 70             	mov    %edx,0x70(%eax)
  target_env->env_status = ENV_RUNNABLE;
f0103e47:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e4a:	c7 40 54 01 00 00 00 	movl   $0x1,0x54(%eax)
  if (((int)srcva < UTOP) && (target_env->env_ipc_dstva != 0)) {
f0103e51:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103e57:	77 13                	ja     f0103e6c <sys_ipc_try_send+0xae>
f0103e59:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e5c:	83 78 6c 00          	cmpl   $0x0,0x6c(%eax)
f0103e60:	74 0a                	je     f0103e6c <sys_ipc_try_send+0xae>
    target_env->env_ipc_perm = perm;
f0103e62:	89 78 78             	mov    %edi,0x78(%eax)
    return 1;
f0103e65:	ba 01 00 00 00       	mov    $0x1,%edx
f0103e6a:	eb 0f                	jmp    f0103e7b <sys_ipc_try_send+0xbd>
  } else {
    target_env->env_ipc_perm = 0;
f0103e6c:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e6f:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
    return 0;
f0103e76:	ba 00 00 00 00       	mov    $0x0,%edx
  }

}
f0103e7b:	89 d0                	mov    %edx,%eax
f0103e7d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0103e80:	5b                   	pop    %ebx
f0103e81:	5e                   	pop    %esi
f0103e82:	5f                   	pop    %edi
f0103e83:	c9                   	leave  
f0103e84:	c3                   	ret    

f0103e85 <sys_ipc_recv>:

// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
f0103e85:	55                   	push   %ebp
f0103e86:	89 e5                	mov    %esp,%ebp
f0103e88:	83 ec 08             	sub    $0x8,%esp
f0103e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  // LAB 4: Your code here.
  // seanyliu

  // Verify that the dstva is correct
  if (((int)dstva < UTOP) && (dstva != ROUNDUP(dstva, PGSIZE))) {
f0103e8e:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f0103e94:	77 26                	ja     f0103ebc <sys_ipc_recv+0x37>
f0103e96:	8d 82 ff 0f 00 00    	lea    0xfff(%edx),%eax
f0103e9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return -E_INVAL;
f0103ea1:	b9 fd ff ff ff       	mov    $0xfffffffd,%ecx
f0103ea6:	39 d0                	cmp    %edx,%eax
f0103ea8:	75 4c                	jne    f0103ef6 <sys_ipc_recv+0x71>
  }

  if ((int)dstva < UTOP) {
f0103eaa:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f0103eb0:	77 0a                	ja     f0103ebc <sys_ipc_recv+0x37>
    curenv->env_ipc_dstva = dstva;
f0103eb2:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103eb7:	89 50 6c             	mov    %edx,0x6c(%eax)
f0103eba:	eb 0c                	jmp    f0103ec8 <sys_ipc_recv+0x43>
  } else {
    curenv->env_ipc_dstva = 0;
f0103ebc:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103ec1:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
  }
  curenv->env_ipc_recving = 1;
f0103ec8:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103ecd:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%eax)
  curenv->env_status = ENV_NOT_RUNNABLE;
f0103ed4:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103ed9:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
  curenv->env_tf.tf_regs.reg_eax = 0;
f0103ee0:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103ee5:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  sys_yield();
f0103eec:	e8 02 fa ff ff       	call   f01038f3 <sys_yield>

  // panic("sys_ipc_recv not implemented");
  return 0;
f0103ef1:	b9 00 00 00 00       	mov    $0x0,%ecx
}
f0103ef6:	89 c8                	mov    %ecx,%eax
f0103ef8:	c9                   	leave  
f0103ef9:	c3                   	ret    

f0103efa <sys_env_set_priority>:


// Set envid's env_priority to priority, which must be in the correct bounds
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if priority is not a valid priority for an environment.
static int
sys_env_set_priority(envid_t envid, int priority)
{
f0103efa:	55                   	push   %ebp
f0103efb:	89 e5                	mov    %esp,%ebp
f0103efd:	53                   	push   %ebx
f0103efe:	83 ec 08             	sub    $0x8,%esp
f0103f01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's priority.

	// Lab 4: Challenge
        // seanyliu
	int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
f0103f04:	6a 01                	push   $0x1
f0103f06:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
f0103f09:	50                   	push   %eax
f0103f0a:	ff 75 08             	pushl  0x8(%ebp)
f0103f0d:	e8 9e e9 ff ff       	call   f01028b0 <envid2env>
f0103f12:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103f15:	89 c2                	mov    %eax,%edx
f0103f17:	85 c0                	test   %eax,%eax
f0103f19:	78 18                	js     f0103f33 <sys_env_set_priority+0x39>
        }
        if ((ENV_PR_LOWEST <= priority) && (priority <= ENV_PR_HIGHEST)) {
f0103f1b:	8d 43 02             	lea    0x2(%ebx),%eax
          env->env_priority = priority;
        } else {
          return -E_INVAL;
f0103f1e:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103f23:	83 f8 04             	cmp    $0x4,%eax
f0103f26:	77 0b                	ja     f0103f33 <sys_env_set_priority+0x39>
f0103f28:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
f0103f2b:	89 58 7c             	mov    %ebx,0x7c(%eax)
        }

        return 0;
f0103f2e:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0103f33:	89 d0                	mov    %edx,%eax
f0103f35:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0103f38:	c9                   	leave  
f0103f39:	c3                   	ret    

f0103f3a <sys_transmit_packet>:

// LAB 6
/*
static int
sys_transmit_packet(char* packet, int pktsize) {
  int r;
  if (pktsize > MAX_PKT_SIZE) {
    return -E_INVAL;
  }
  if ((r = e100_transmit_packet(packet, pktsize)) < 0) {
    return r;
  }
  return 0;
}
*/

static int
sys_transmit_packet(char *packet, int size)
{
f0103f3a:	55                   	push   %ebp
f0103f3b:	89 e5                	mov    %esp,%ebp
f0103f3d:	83 ec 10             	sub    $0x10,%esp
  return e100_transmit_packet(packet,size);
f0103f40:	ff 75 0c             	pushl  0xc(%ebp)
f0103f43:	ff 75 08             	pushl  0x8(%ebp)
f0103f46:	e8 5d 12 00 00       	call   f01051a8 <e100_transmit_packet>
}
f0103f4b:	c9                   	leave  
f0103f4c:	c3                   	ret    

f0103f4d <sys_receive_packet>:

static int
sys_receive_packet(char *packet, int *size)
{
f0103f4d:	55                   	push   %ebp
f0103f4e:	89 e5                	mov    %esp,%ebp
f0103f50:	83 ec 10             	sub    $0x10,%esp
  int r;
  if ((r = e100_receive_packet(packet, size)) < 0) {
f0103f53:	ff 75 0c             	pushl  0xc(%ebp)
f0103f56:	ff 75 08             	pushl  0x8(%ebp)
f0103f59:	e8 64 15 00 00       	call   f01054c2 <e100_receive_packet>
f0103f5e:	83 c4 10             	add    $0x10,%esp
    return r;
f0103f61:	89 c2                	mov    %eax,%edx
f0103f63:	85 c0                	test   %eax,%eax
f0103f65:	78 05                	js     f0103f6c <sys_receive_packet+0x1f>
  }
  return 0;
f0103f67:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0103f6c:	89 d0                	mov    %edx,%eax
f0103f6e:	c9                   	leave  
f0103f6f:	c3                   	ret    

f0103f70 <sys_receive_packet_zerocopy>:

// Challenge: Lab 6
static int
sys_receive_packet_zerocopy(int *size)
{
f0103f70:	55                   	push   %ebp
f0103f71:	89 e5                	mov    %esp,%ebp
f0103f73:	83 ec 14             	sub    $0x14,%esp
  int r;
  if ((r = e100_receive_packet_zerocopy(size)) < 0) {
f0103f76:	ff 75 08             	pushl  0x8(%ebp)
f0103f79:	e8 d3 14 00 00       	call   f0105451 <e100_receive_packet_zerocopy>
f0103f7e:	83 c4 10             	add    $0x10,%esp
    return r;
f0103f81:	89 c2                	mov    %eax,%edx
f0103f83:	85 c0                	test   %eax,%eax
f0103f85:	78 05                	js     f0103f8c <sys_receive_packet_zerocopy+0x1c>
  }
  return 0;
f0103f87:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0103f8c:	89 d0                	mov    %edx,%eax
f0103f8e:	c9                   	leave  
f0103f8f:	c3                   	ret    

f0103f90 <sys_time_msec>:

// Return the current time.
static int
sys_time_msec(void) 
{
f0103f90:	55                   	push   %ebp
f0103f91:	89 e5                	mov    %esp,%ebp
f0103f93:	83 ec 08             	sub    $0x8,%esp
	// LAB 6: Your code here.
        return time_msec();
f0103f96:	e8 a4 1b 00 00       	call   f0105b3f <time_msec>
	//panic("sys_time_msec not implemented");
}
f0103f9b:	c9                   	leave  
f0103f9c:	c3                   	ret    

f0103f9d <sys_map_receive_buffers>:

// Challenge: LAB 6
static int
sys_map_receive_buffers(char *first_buffer)
{
f0103f9d:	55                   	push   %ebp
f0103f9e:	89 e5                	mov    %esp,%ebp
f0103fa0:	83 ec 14             	sub    $0x14,%esp
        int r;
        if ((r = e100_map_receive_buffers(first_buffer)) < 0) {
f0103fa3:	ff 75 08             	pushl  0x8(%ebp)
f0103fa6:	e8 a1 15 00 00       	call   f010554c <e100_map_receive_buffers>
f0103fab:	83 c4 10             	add    $0x10,%esp
          return r;
f0103fae:	89 c2                	mov    %eax,%edx
f0103fb0:	85 c0                	test   %eax,%eax
f0103fb2:	78 05                	js     f0103fb9 <sys_map_receive_buffers+0x1c>
        }
        return 0;
f0103fb4:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0103fb9:	89 d0                	mov    %edx,%eax
f0103fbb:	c9                   	leave  
f0103fbc:	c3                   	ret    

f0103fbd <syscall>:


// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0103fbd:	55                   	push   %ebp
f0103fbe:	89 e5                	mov    %esp,%ebp
f0103fc0:	57                   	push   %edi
f0103fc1:	56                   	push   %esi
f0103fc2:	53                   	push   %ebx
f0103fc3:	83 ec 0c             	sub    $0xc,%esp
f0103fc6:	8b 55 08             	mov    0x8(%ebp),%edx
f0103fc9:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103fcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0103fcf:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0103fd2:	8b 7d 18             	mov    0x18(%ebp),%edi
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.

        // seanyliu
        if (syscallno >= 0 && syscallno < NSYSCALLS) {
          //cprintf("%d\n", syscallno);
          switch (syscallno) {
            case SYS_cputs:
              // sys_cputs(const char *s, size_t len)
              sys_cputs((char *)a1, a2);
              break;
            case SYS_cgetc:
              return sys_cgetc();
              break;
            case SYS_getenvid:
              return sys_getenvid();
              break;
            case SYS_env_destroy:
              return sys_env_destroy(a1);
              break;
            case SYS_yield:
              sys_yield();
              break;
            case SYS_exofork:
              return sys_exofork();
              break;
            case SYS_env_set_status:
              return sys_env_set_status((envid_t) a1, (int) a2);
              break;
            case SYS_page_alloc:
              return sys_page_alloc((envid_t) a1, (void *) a2, (int) a3);
              break;
            case SYS_page_map:
              return sys_page_map((envid_t) a1, (void *) a2, (envid_t) a3, (void *) a4, (int) a5);
              break;
            case SYS_page_unmap:
              return sys_page_unmap((envid_t) a1, (void *) a2);
              break;
            case SYS_env_set_pgfault_upcall:
              return sys_env_set_pgfault_upcall((envid_t) a1, (void *) a2);
              break;
            case SYS_ipc_try_send:
              return sys_ipc_try_send((envid_t) a1, (uint32_t) a2, (void *) a3, (unsigned) a4);
              break;
            case SYS_ipc_recv:
              return sys_ipc_recv((void *) a1);
              break;
            case SYS_env_set_trapframe:
              return sys_env_set_trapframe((envid_t) a1, (struct Trapframe*)a2);
              break;
            // Lab 4: Challenge
            case SYS_env_set_priority:
              return sys_env_set_priority((envid_t) a1, (int) a2);
              break;
            case SYS_time_msec:
              return sys_time_msec();
              break;
            case SYS_transmit_packet:
              return sys_transmit_packet((char *)a1, (int) a2);
              break;
            case SYS_receive_packet:
              return sys_receive_packet((char *)a1, (int*) a2);
              break;
            case SYS_receive_packet_zerocopy:
              return sys_receive_packet_zerocopy((int *)a1);
              break;
            case SYS_map_receive_buffers:
              return sys_map_receive_buffers((char *)a1);
              break;
            default:
	      panic("kern/syscall.c: unexpected syscall %d\n", syscallno);
              break;
          }
        } else {
          return -E_INVAL;
f0103fd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0103fda:	83 fa 13             	cmp    $0x13,%edx
f0103fdd:	0f 87 02 01 00 00    	ja     f01040e5 <syscall+0x128>
f0103fe3:	ff 24 95 a4 6e 10 f0 	jmp    *0xf0106ea4(,%edx,4)
f0103fea:	83 ec 08             	sub    $0x8,%esp
f0103fed:	53                   	push   %ebx
f0103fee:	56                   	push   %esi
f0103fef:	e8 80 f8 ff ff       	call   f0103874 <sys_cputs>
f0103ff4:	83 c4 10             	add    $0x10,%esp
f0103ff7:	e9 e4 00 00 00       	jmp    f01040e0 <syscall+0x123>
f0103ffc:	e8 a3 f8 ff ff       	call   f01038a4 <sys_cgetc>
f0104001:	e9 df 00 00 00       	jmp    f01040e5 <syscall+0x128>
f0104006:	e8 aa f8 ff ff       	call   f01038b5 <sys_getenvid>
f010400b:	e9 d5 00 00 00       	jmp    f01040e5 <syscall+0x128>
f0104010:	83 ec 0c             	sub    $0xc,%esp
f0104013:	56                   	push   %esi
f0104014:	e8 a9 f8 ff ff       	call   f01038c2 <sys_env_destroy>
f0104019:	e9 c7 00 00 00       	jmp    f01040e5 <syscall+0x128>
f010401e:	e8 d0 f8 ff ff       	call   f01038f3 <sys_yield>
f0104023:	e9 b8 00 00 00       	jmp    f01040e0 <syscall+0x123>
f0104028:	e8 d1 f8 ff ff       	call   f01038fe <sys_exofork>
f010402d:	e9 b3 00 00 00       	jmp    f01040e5 <syscall+0x128>
f0104032:	83 ec 08             	sub    $0x8,%esp
f0104035:	53                   	push   %ebx
f0104036:	56                   	push   %esi
f0104037:	e8 13 f9 ff ff       	call   f010394f <sys_env_set_status>
f010403c:	e9 a4 00 00 00       	jmp    f01040e5 <syscall+0x128>
f0104041:	83 ec 04             	sub    $0x4,%esp
f0104044:	51                   	push   %ecx
f0104045:	53                   	push   %ebx
f0104046:	56                   	push   %esi
f0104047:	e8 ba f9 ff ff       	call   f0103a06 <sys_page_alloc>
f010404c:	e9 94 00 00 00       	jmp    f01040e5 <syscall+0x128>
f0104051:	83 ec 0c             	sub    $0xc,%esp
f0104054:	ff 75 1c             	pushl  0x1c(%ebp)
f0104057:	57                   	push   %edi
f0104058:	51                   	push   %ecx
f0104059:	53                   	push   %ebx
f010405a:	56                   	push   %esi
f010405b:	e8 ea fb ff ff       	call   f0103c4a <sys_page_map>
f0104060:	e9 80 00 00 00       	jmp    f01040e5 <syscall+0x128>
f0104065:	83 ec 08             	sub    $0x8,%esp
f0104068:	53                   	push   %ebx
f0104069:	56                   	push   %esi
f010406a:	e8 f2 fc ff ff       	call   f0103d61 <sys_page_unmap>
f010406f:	eb 74                	jmp    f01040e5 <syscall+0x128>
f0104071:	83 ec 08             	sub    $0x8,%esp
f0104074:	53                   	push   %ebx
f0104075:	56                   	push   %esi
f0104076:	e8 5c f9 ff ff       	call   f01039d7 <sys_env_set_pgfault_upcall>
f010407b:	eb 68                	jmp    f01040e5 <syscall+0x128>
f010407d:	57                   	push   %edi
f010407e:	51                   	push   %ecx
f010407f:	53                   	push   %ebx
f0104080:	56                   	push   %esi
f0104081:	e8 38 fd ff ff       	call   f0103dbe <sys_ipc_try_send>
f0104086:	eb 5d                	jmp    f01040e5 <syscall+0x128>
f0104088:	83 ec 0c             	sub    $0xc,%esp
f010408b:	56                   	push   %esi
f010408c:	e8 f4 fd ff ff       	call   f0103e85 <sys_ipc_recv>
f0104091:	eb 52                	jmp    f01040e5 <syscall+0x128>
f0104093:	83 ec 08             	sub    $0x8,%esp
f0104096:	53                   	push   %ebx
f0104097:	56                   	push   %esi
f0104098:	e8 f2 f8 ff ff       	call   f010398f <sys_env_set_trapframe>
f010409d:	eb 46                	jmp    f01040e5 <syscall+0x128>
f010409f:	83 ec 08             	sub    $0x8,%esp
f01040a2:	53                   	push   %ebx
f01040a3:	56                   	push   %esi
f01040a4:	e8 51 fe ff ff       	call   f0103efa <sys_env_set_priority>
f01040a9:	eb 3a                	jmp    f01040e5 <syscall+0x128>
f01040ab:	e8 e0 fe ff ff       	call   f0103f90 <sys_time_msec>
f01040b0:	eb 33                	jmp    f01040e5 <syscall+0x128>
f01040b2:	83 ec 08             	sub    $0x8,%esp
f01040b5:	53                   	push   %ebx
f01040b6:	56                   	push   %esi
f01040b7:	e8 7e fe ff ff       	call   f0103f3a <sys_transmit_packet>
f01040bc:	eb 27                	jmp    f01040e5 <syscall+0x128>
f01040be:	83 ec 08             	sub    $0x8,%esp
f01040c1:	53                   	push   %ebx
f01040c2:	56                   	push   %esi
f01040c3:	e8 85 fe ff ff       	call   f0103f4d <sys_receive_packet>
f01040c8:	eb 1b                	jmp    f01040e5 <syscall+0x128>
f01040ca:	83 ec 0c             	sub    $0xc,%esp
f01040cd:	56                   	push   %esi
f01040ce:	e8 9d fe ff ff       	call   f0103f70 <sys_receive_packet_zerocopy>
f01040d3:	eb 10                	jmp    f01040e5 <syscall+0x128>
f01040d5:	83 ec 0c             	sub    $0xc,%esp
f01040d8:	56                   	push   %esi
f01040d9:	e8 bf fe ff ff       	call   f0103f9d <sys_map_receive_buffers>
f01040de:	eb 05                	jmp    f01040e5 <syscall+0x128>
        }

        return 0;
f01040e0:	b8 00 00 00 00       	mov    $0x0,%eax

	//panic("syscall not implemented");
}
f01040e5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f01040e8:	5b                   	pop    %ebx
f01040e9:	5e                   	pop    %esi
f01040ea:	5f                   	pop    %edi
f01040eb:	c9                   	leave  
f01040ec:	c3                   	ret    
f01040ed:	00 00                	add    %al,(%eax)
	...

f01040f0 <stab_binsearch>:
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f01040f0:	55                   	push   %ebp
f01040f1:	89 e5                	mov    %esp,%ebp
f01040f3:	57                   	push   %edi
f01040f4:	56                   	push   %esi
f01040f5:	53                   	push   %ebx
f01040f6:	83 ec 0c             	sub    $0xc,%esp
f01040f9:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f01040fc:	8b 45 0c             	mov    0xc(%ebp),%eax
f01040ff:	8b 08                	mov    (%eax),%ecx
f0104101:	8b 55 10             	mov    0x10(%ebp),%edx
f0104104:	8b 12                	mov    (%edx),%edx
f0104106:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
f0104109:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
	
	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
			l = true_m + 1;
		} else if (stabs[m].n_value > addr) {
			*region_right = m - 1;
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
			l = m;
			addr++;
f0104110:	39 d1                	cmp    %edx,%ecx
f0104112:	0f 8f 88 00 00 00    	jg     f01041a0 <stab_binsearch+0xb0>
f0104118:	8b 5d e8             	mov    0xffffffe8(%ebp),%ebx
f010411b:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
f010411e:	89 c2                	mov    %eax,%edx
f0104120:	c1 ea 1f             	shr    $0x1f,%edx
f0104123:	01 d0                	add    %edx,%eax
f0104125:	89 c3                	mov    %eax,%ebx
f0104127:	d1 fb                	sar    %ebx
f0104129:	89 da                	mov    %ebx,%edx
f010412b:	39 cb                	cmp    %ecx,%ebx
f010412d:	7c 23                	jl     f0104152 <stab_binsearch+0x62>
f010412f:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0104132:	0f b6 44 87 04       	movzbl 0x4(%edi,%eax,4),%eax
f0104137:	3b 45 14             	cmp    0x14(%ebp),%eax
f010413a:	74 12                	je     f010414e <stab_binsearch+0x5e>
f010413c:	4a                   	dec    %edx
f010413d:	39 ca                	cmp    %ecx,%edx
f010413f:	7c 11                	jl     f0104152 <stab_binsearch+0x62>
f0104141:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104144:	0f b6 44 87 04       	movzbl 0x4(%edi,%eax,4),%eax
f0104149:	3b 45 14             	cmp    0x14(%ebp),%eax
f010414c:	75 ee                	jne    f010413c <stab_binsearch+0x4c>
f010414e:	39 ca                	cmp    %ecx,%edx
f0104150:	7d 05                	jge    f0104157 <stab_binsearch+0x67>
f0104152:	8d 4b 01             	lea    0x1(%ebx),%ecx
f0104155:	eb 40                	jmp    f0104197 <stab_binsearch+0xa7>
f0104157:	c7 45 f0 01 00 00 00 	movl   $0x1,0xfffffff0(%ebp)
f010415e:	8d 34 52             	lea    (%edx,%edx,2),%esi
f0104161:	8b 45 18             	mov    0x18(%ebp),%eax
f0104164:	39 44 b7 08          	cmp    %eax,0x8(%edi,%esi,4)
f0104168:	73 0a                	jae    f0104174 <stab_binsearch+0x84>
f010416a:	8b 75 0c             	mov    0xc(%ebp),%esi
f010416d:	89 16                	mov    %edx,(%esi)
f010416f:	8d 4b 01             	lea    0x1(%ebx),%ecx
f0104172:	eb 23                	jmp    f0104197 <stab_binsearch+0xa7>
f0104174:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104177:	8b 5d 18             	mov    0x18(%ebp),%ebx
f010417a:	39 5c 87 08          	cmp    %ebx,0x8(%edi,%eax,4)
f010417e:	76 0d                	jbe    f010418d <stab_binsearch+0x9d>
f0104180:	8d 42 ff             	lea    0xffffffff(%edx),%eax
f0104183:	8b 75 10             	mov    0x10(%ebp),%esi
f0104186:	89 06                	mov    %eax,(%esi)
f0104188:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
f010418b:	eb 0a                	jmp    f0104197 <stab_binsearch+0xa7>
f010418d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104190:	89 10                	mov    %edx,(%eax)
f0104192:	89 d1                	mov    %edx,%ecx
f0104194:	ff 45 18             	incl   0x18(%ebp)
f0104197:	3b 4d e8             	cmp    0xffffffe8(%ebp),%ecx
f010419a:	0f 8e 78 ff ff ff    	jle    f0104118 <stab_binsearch+0x28>
		}
	}

	if (!any_matches)
f01041a0:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f01041a4:	75 0d                	jne    f01041b3 <stab_binsearch+0xc3>
		*region_right = *region_left - 1;
f01041a6:	8b 55 0c             	mov    0xc(%ebp),%edx
f01041a9:	8b 02                	mov    (%edx),%eax
f01041ab:	48                   	dec    %eax
f01041ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
f01041af:	89 03                	mov    %eax,(%ebx)
f01041b1:	eb 33                	jmp    f01041e6 <stab_binsearch+0xf6>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01041b3:	8b 75 10             	mov    0x10(%ebp),%esi
f01041b6:	8b 0e                	mov    (%esi),%ecx
f01041b8:	8b 45 0c             	mov    0xc(%ebp),%eax
f01041bb:	39 08                	cmp    %ecx,(%eax)
f01041bd:	7d 22                	jge    f01041e1 <stab_binsearch+0xf1>
f01041bf:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f01041c2:	0f b6 44 87 04       	movzbl 0x4(%edi,%eax,4),%eax
f01041c7:	3b 45 14             	cmp    0x14(%ebp),%eax
f01041ca:	74 15                	je     f01041e1 <stab_binsearch+0xf1>
f01041cc:	49                   	dec    %ecx
f01041cd:	8b 55 0c             	mov    0xc(%ebp),%edx
f01041d0:	39 0a                	cmp    %ecx,(%edx)
f01041d2:	7d 0d                	jge    f01041e1 <stab_binsearch+0xf1>
f01041d4:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f01041d7:	0f b6 44 87 04       	movzbl 0x4(%edi,%eax,4),%eax
f01041dc:	3b 45 14             	cmp    0x14(%ebp),%eax
f01041df:	75 eb                	jne    f01041cc <stab_binsearch+0xdc>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f01041e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01041e4:	89 0b                	mov    %ecx,(%ebx)
	}
}
f01041e6:	83 c4 0c             	add    $0xc,%esp
f01041e9:	5b                   	pop    %ebx
f01041ea:	5e                   	pop    %esi
f01041eb:	5f                   	pop    %edi
f01041ec:	c9                   	leave  
f01041ed:	c3                   	ret    

f01041ee <debuginfo_eip>:


// debuginfo_eip(addr, info)
//
//	Fill in the 'info' structure with information about the specified
//	instruction address, 'addr'.  Returns 0 if information was found, and
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f01041ee:	55                   	push   %ebp
f01041ef:	89 e5                	mov    %esp,%ebp
f01041f1:	57                   	push   %edi
f01041f2:	56                   	push   %esi
f01041f3:	53                   	push   %ebx
f01041f4:	83 ec 2c             	sub    $0x2c,%esp
f01041f7:	8b 7d 08             	mov    0x8(%ebp),%edi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f01041fa:	8b 45 0c             	mov    0xc(%ebp),%eax
f01041fd:	c7 00 f4 6e 10 f0    	movl   $0xf0106ef4,(%eax)
	info->eip_line = 0;
f0104203:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	info->eip_fn_name = "<unknown>";
f010420a:	c7 40 08 f4 6e 10 f0 	movl   $0xf0106ef4,0x8(%eax)
	info->eip_fn_namelen = 9;
f0104211:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
	info->eip_fn_addr = addr;
f0104218:	89 78 10             	mov    %edi,0x10(%eax)
	info->eip_fn_narg = 0;
f010421b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104222:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104228:	76 1d                	jbe    f0104247 <debuginfo_eip+0x59>
		stabs = __STAB_BEGIN__;
f010422a:	bb e8 75 10 f0       	mov    $0xf01075e8,%ebx
		stab_end = __STAB_END__;
f010422f:	c7 45 d8 08 4f 11 f0 	movl   $0xf0114f08,0xffffffd8(%ebp)
		stabstr = __STABSTR_BEGIN__;
f0104236:	c7 45 d4 09 4f 11 f0 	movl   $0xf0114f09,0xffffffd4(%ebp)
		stabstr_end = __STABSTR_END__;
f010423d:	be e8 c6 11 f0       	mov    $0xf011c6e8,%esi
f0104242:	e9 9e 00 00 00       	jmp    f01042e5 <debuginfo_eip+0xf7>
	} else {
		// The user-application linker script, user/user.ld,
		// puts information about the application's stabs (equivalent
		// to __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__, and
		// __STABSTR_END__) in a structure located at virtual address
		// USTABDATA.
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;
f0104247:	be 00 00 20 00       	mov    $0x200000,%esi

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.

                // seanyliu
                if (user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U) < 0) {
f010424c:	6a 04                	push   $0x4
f010424e:	6a 10                	push   $0x10
f0104250:	68 00 00 20 00       	push   $0x200000
f0104255:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f010425b:	e8 26 d9 ff ff       	call   f0101b86 <user_mem_check>
f0104260:	83 c4 10             	add    $0x10,%esp
                  return -1;
f0104263:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104268:	85 c0                	test   %eax,%eax
f010426a:	0f 88 27 02 00 00    	js     f0104497 <debuginfo_eip+0x2a9>
                }
	
		stabs = usd->stabs;
f0104270:	8b 1e                	mov    (%esi),%ebx
		stab_end = usd->stab_end;
f0104272:	8b 56 04             	mov    0x4(%esi),%edx
f0104275:	89 55 d8             	mov    %edx,0xffffffd8(%ebp)
		stabstr = usd->stabstr;
f0104278:	8b 4e 08             	mov    0x8(%esi),%ecx
f010427b:	89 4d d4             	mov    %ecx,0xffffffd4(%ebp)
		stabstr_end = usd->stabstr_end;
f010427e:	8b 76 0c             	mov    0xc(%esi),%esi

                if (user_mem_check(curenv, stabs, (stab_end - stabs), PTE_U) < 0) {
f0104281:	6a 04                	push   $0x4
f0104283:	29 da                	sub    %ebx,%edx
f0104285:	c1 fa 02             	sar    $0x2,%edx
f0104288:	8d 04 92             	lea    (%edx,%edx,4),%eax
f010428b:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010428e:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0104291:	89 c1                	mov    %eax,%ecx
f0104293:	c1 e1 08             	shl    $0x8,%ecx
f0104296:	01 c8                	add    %ecx,%eax
f0104298:	89 c1                	mov    %eax,%ecx
f010429a:	c1 e1 10             	shl    $0x10,%ecx
f010429d:	01 c8                	add    %ecx,%eax
f010429f:	8d 04 42             	lea    (%edx,%eax,2),%eax
f01042a2:	50                   	push   %eax
f01042a3:	53                   	push   %ebx
f01042a4:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f01042aa:	e8 d7 d8 ff ff       	call   f0101b86 <user_mem_check>
f01042af:	83 c4 10             	add    $0x10,%esp
                  return -1;
f01042b2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01042b7:	85 c0                	test   %eax,%eax
f01042b9:	0f 88 d8 01 00 00    	js     f0104497 <debuginfo_eip+0x2a9>
                }
                if (user_mem_check(curenv, stabstr, (stabstr_end - stabstr), PTE_U) < 0) {
f01042bf:	6a 04                	push   $0x4
f01042c1:	89 f0                	mov    %esi,%eax
f01042c3:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
f01042c6:	50                   	push   %eax
f01042c7:	ff 75 d4             	pushl  0xffffffd4(%ebp)
f01042ca:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f01042d0:	e8 b1 d8 ff ff       	call   f0101b86 <user_mem_check>
f01042d5:	83 c4 10             	add    $0x10,%esp
                  return -1;
f01042d8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01042dd:	85 c0                	test   %eax,%eax
f01042df:	0f 88 b2 01 00 00    	js     f0104497 <debuginfo_eip+0x2a9>
                }

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01042e5:	3b 75 d4             	cmp    0xffffffd4(%ebp),%esi
f01042e8:	76 06                	jbe    f01042f0 <debuginfo_eip+0x102>
f01042ea:	80 7e ff 00          	cmpb   $0x0,0xffffffff(%esi)
f01042ee:	74 0a                	je     f01042fa <debuginfo_eip+0x10c>
		return -1;
f01042f0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01042f5:	e9 9d 01 00 00       	jmp    f0104497 <debuginfo_eip+0x2a9>

	// Now we find the right stabs that define the function containing
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.
	
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01042fa:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104301:	8b 55 d8             	mov    0xffffffd8(%ebp),%edx
f0104304:	29 da                	sub    %ebx,%edx
f0104306:	c1 fa 02             	sar    $0x2,%edx
f0104309:	8d 04 92             	lea    (%edx,%edx,4),%eax
f010430c:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010430f:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0104312:	89 c1                	mov    %eax,%ecx
f0104314:	c1 e1 08             	shl    $0x8,%ecx
f0104317:	01 c8                	add    %ecx,%eax
f0104319:	89 c1                	mov    %eax,%ecx
f010431b:	c1 e1 10             	shl    $0x10,%ecx
f010431e:	01 c8                	add    %ecx,%eax
f0104320:	8d 44 42 ff          	lea    0xffffffff(%edx,%eax,2),%eax
f0104324:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104327:	57                   	push   %edi
f0104328:	6a 64                	push   $0x64
f010432a:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f010432d:	50                   	push   %eax
f010432e:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0104331:	50                   	push   %eax
f0104332:	53                   	push   %ebx
f0104333:	e8 b8 fd ff ff       	call   f01040f0 <stab_binsearch>
	if (lfile == 0)
f0104338:	83 c4 14             	add    $0x14,%esp
		return -1;
f010433b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104340:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
f0104344:	0f 84 4d 01 00 00    	je     f0104497 <debuginfo_eip+0x2a9>

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f010434a:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f010434d:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
	rfun = rfile;
f0104350:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0104353:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0104356:	57                   	push   %edi
f0104357:	6a 24                	push   $0x24
f0104359:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f010435c:	50                   	push   %eax
f010435d:	8d 45 e4             	lea    0xffffffe4(%ebp),%eax
f0104360:	50                   	push   %eax
f0104361:	53                   	push   %ebx
f0104362:	e8 89 fd ff ff       	call   f01040f0 <stab_binsearch>

	if (lfun <= rfun) {
f0104367:	83 c4 14             	add    $0x14,%esp
f010436a:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f010436d:	3b 45 e8             	cmp    0xffffffe8(%ebp),%eax
f0104370:	7f 3d                	jg     f01043af <debuginfo_eip+0x1c1>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0104372:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104375:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f010437c:	89 f0                	mov    %esi,%eax
f010437e:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
f0104381:	39 04 1a             	cmp    %eax,(%edx,%ebx,1)
f0104384:	73 0c                	jae    f0104392 <debuginfo_eip+0x1a4>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0104386:	8b 45 d4             	mov    0xffffffd4(%ebp),%eax
f0104389:	03 04 1a             	add    (%edx,%ebx,1),%eax
f010438c:	8b 55 0c             	mov    0xc(%ebp),%edx
f010438f:	89 42 08             	mov    %eax,0x8(%edx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0104392:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
f0104395:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0104398:	8b 44 83 08          	mov    0x8(%ebx,%eax,4),%eax
f010439c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010439f:	89 41 10             	mov    %eax,0x10(%ecx)
		addr -= info->eip_fn_addr;
f01043a2:	29 c7                	sub    %eax,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f01043a4:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
		rline = rfun;
f01043a7:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f01043aa:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
f01043ad:	eb 12                	jmp    f01043c1 <debuginfo_eip+0x1d3>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f01043af:	8b 45 0c             	mov    0xc(%ebp),%eax
f01043b2:	89 78 10             	mov    %edi,0x10(%eax)
		lline = lfile;
f01043b5:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f01043b8:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
		rline = rfile;
f01043bb:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f01043be:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f01043c1:	83 ec 08             	sub    $0x8,%esp
f01043c4:	6a 3a                	push   $0x3a
f01043c6:	8b 55 0c             	mov    0xc(%ebp),%edx
f01043c9:	ff 72 08             	pushl  0x8(%edx)
f01043cc:	e8 a6 08 00 00       	call   f0104c77 <strfind>
f01043d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01043d4:	2b 41 08             	sub    0x8(%ecx),%eax
f01043d7:	89 41 0c             	mov    %eax,0xc(%ecx)

	
	// Search within [lline, rline] for the line number stab.
	// If found, set info->eip_line to the right line number.
	// If not found, return -1.
	//
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

        // seanyliu
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f01043da:	57                   	push   %edi
f01043db:	6a 44                	push   $0x44
f01043dd:	8d 45 e0             	lea    0xffffffe0(%ebp),%eax
f01043e0:	50                   	push   %eax
f01043e1:	8d 45 dc             	lea    0xffffffdc(%ebp),%eax
f01043e4:	50                   	push   %eax
f01043e5:	53                   	push   %ebx
f01043e6:	e8 05 fd ff ff       	call   f01040f0 <stab_binsearch>
        if (lline <= rline) {
f01043eb:	83 c4 24             	add    $0x24,%esp
f01043ee:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
          info->eip_line = lline;
        } else {
          return -1;
f01043f1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01043f6:	3b 45 e0             	cmp    0xffffffe0(%ebp),%eax
f01043f9:	0f 8f 98 00 00 00    	jg     f0104497 <debuginfo_eip+0x2a9>
f01043ff:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104402:	89 42 04             	mov    %eax,0x4(%edx)
f0104405:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
        }
	
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0104408:	eb 03                	jmp    f010440d <debuginfo_eip+0x21f>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f010440a:	ff 4d dc             	decl   0xffffffdc(%ebp)
f010440d:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0104410:	39 d0                	cmp    %edx,%eax
f0104412:	7c 1b                	jl     f010442f <debuginfo_eip+0x241>
f0104414:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104417:	c1 e0 02             	shl    $0x2,%eax
f010441a:	80 7c 18 04 84       	cmpb   $0x84,0x4(%eax,%ebx,1)
f010441f:	74 0e                	je     f010442f <debuginfo_eip+0x241>
f0104421:	80 7c 18 04 64       	cmpb   $0x64,0x4(%eax,%ebx,1)
f0104426:	75 e2                	jne    f010440a <debuginfo_eip+0x21c>
f0104428:	83 7c 18 08 00       	cmpl   $0x0,0x8(%eax,%ebx,1)
f010442d:	74 db                	je     f010440a <debuginfo_eip+0x21c>
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f010442f:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0104432:	3b 45 ec             	cmp    0xffffffec(%ebp),%eax
f0104435:	7c 1f                	jl     f0104456 <debuginfo_eip+0x268>
f0104437:	8d 04 40             	lea    (%eax,%eax,2),%eax
f010443a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f0104441:	89 f0                	mov    %esi,%eax
f0104443:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
f0104446:	39 04 1a             	cmp    %eax,(%edx,%ebx,1)
f0104449:	73 0b                	jae    f0104456 <debuginfo_eip+0x268>
		info->eip_file = stabstr + stabs[lline].n_strx;
f010444b:	8b 45 d4             	mov    0xffffffd4(%ebp),%eax
f010444e:	03 04 1a             	add    (%edx,%ebx,1),%eax
f0104451:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104454:	89 01                	mov    %eax,(%ecx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0104456:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f0104459:	3b 45 e8             	cmp    0xffffffe8(%ebp),%eax
f010445c:	7d 34                	jge    f0104492 <debuginfo_eip+0x2a4>
		for (lline = lfun + 1;
f010445e:	40                   	inc    %eax
f010445f:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
f0104462:	89 c2                	mov    %eax,%edx
f0104464:	3b 45 e8             	cmp    0xffffffe8(%ebp),%eax
f0104467:	7d 29                	jge    f0104492 <debuginfo_eip+0x2a4>
f0104469:	8d 04 40             	lea    (%eax,%eax,2),%eax
f010446c:	80 7c 83 04 a0       	cmpb   $0xa0,0x4(%ebx,%eax,4)
f0104471:	75 1f                	jne    f0104492 <debuginfo_eip+0x2a4>
f0104473:	8b 4d e8             	mov    0xffffffe8(%ebp),%ecx
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0104476:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104479:	ff 40 14             	incl   0x14(%eax)
f010447c:	8d 42 01             	lea    0x1(%edx),%eax
f010447f:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
f0104482:	89 c2                	mov    %eax,%edx
f0104484:	39 c8                	cmp    %ecx,%eax
f0104486:	7d 0a                	jge    f0104492 <debuginfo_eip+0x2a4>
f0104488:	8d 04 40             	lea    (%eax,%eax,2),%eax
f010448b:	80 7c 83 04 a0       	cmpb   $0xa0,0x4(%ebx,%eax,4)
f0104490:	74 e4                	je     f0104476 <debuginfo_eip+0x288>
	
	return 0;
f0104492:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0104497:	89 d0                	mov    %edx,%eax
f0104499:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f010449c:	5b                   	pop    %ebx
f010449d:	5e                   	pop    %esi
f010449e:	5f                   	pop    %edi
f010449f:	c9                   	leave  
f01044a0:	c3                   	ret    
f01044a1:	00 00                	add    %al,(%eax)
	...

f01044a4 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f01044a4:	55                   	push   %ebp
f01044a5:	89 e5                	mov    %esp,%ebp
f01044a7:	57                   	push   %edi
f01044a8:	56                   	push   %esi
f01044a9:	53                   	push   %ebx
f01044aa:	83 ec 0c             	sub    $0xc,%esp
f01044ad:	8b 75 10             	mov    0x10(%ebp),%esi
f01044b0:	8b 7d 14             	mov    0x14(%ebp),%edi
f01044b3:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f01044b6:	8b 45 18             	mov    0x18(%ebp),%eax
f01044b9:	ba 00 00 00 00       	mov    $0x0,%edx
f01044be:	39 fa                	cmp    %edi,%edx
f01044c0:	77 39                	ja     f01044fb <printnum+0x57>
f01044c2:	72 04                	jb     f01044c8 <printnum+0x24>
f01044c4:	39 f0                	cmp    %esi,%eax
f01044c6:	77 33                	ja     f01044fb <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f01044c8:	83 ec 04             	sub    $0x4,%esp
f01044cb:	ff 75 20             	pushl  0x20(%ebp)
f01044ce:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
f01044d1:	50                   	push   %eax
f01044d2:	ff 75 18             	pushl  0x18(%ebp)
f01044d5:	8b 45 18             	mov    0x18(%ebp),%eax
f01044d8:	ba 00 00 00 00       	mov    $0x0,%edx
f01044dd:	52                   	push   %edx
f01044de:	50                   	push   %eax
f01044df:	57                   	push   %edi
f01044e0:	56                   	push   %esi
f01044e1:	e8 6a 16 00 00       	call   f0105b50 <__udivdi3>
f01044e6:	83 c4 10             	add    $0x10,%esp
f01044e9:	52                   	push   %edx
f01044ea:	50                   	push   %eax
f01044eb:	ff 75 0c             	pushl  0xc(%ebp)
f01044ee:	ff 75 08             	pushl  0x8(%ebp)
f01044f1:	e8 ae ff ff ff       	call   f01044a4 <printnum>
f01044f6:	83 c4 20             	add    $0x20,%esp
f01044f9:	eb 19                	jmp    f0104514 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01044fb:	4b                   	dec    %ebx
f01044fc:	85 db                	test   %ebx,%ebx
f01044fe:	7e 14                	jle    f0104514 <printnum+0x70>
f0104500:	83 ec 08             	sub    $0x8,%esp
f0104503:	ff 75 0c             	pushl  0xc(%ebp)
f0104506:	ff 75 20             	pushl  0x20(%ebp)
f0104509:	ff 55 08             	call   *0x8(%ebp)
f010450c:	83 c4 10             	add    $0x10,%esp
f010450f:	4b                   	dec    %ebx
f0104510:	85 db                	test   %ebx,%ebx
f0104512:	7f ec                	jg     f0104500 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0104514:	83 ec 08             	sub    $0x8,%esp
f0104517:	ff 75 0c             	pushl  0xc(%ebp)
f010451a:	8b 45 18             	mov    0x18(%ebp),%eax
f010451d:	ba 00 00 00 00       	mov    $0x0,%edx
f0104522:	83 ec 04             	sub    $0x4,%esp
f0104525:	52                   	push   %edx
f0104526:	50                   	push   %eax
f0104527:	57                   	push   %edi
f0104528:	56                   	push   %esi
f0104529:	e8 2e 17 00 00       	call   f0105c5c <__umoddi3>
f010452e:	83 c4 14             	add    $0x14,%esp
f0104531:	0f be 80 f8 6f 10 f0 	movsbl 0xf0106ff8(%eax),%eax
f0104538:	50                   	push   %eax
f0104539:	ff 55 08             	call   *0x8(%ebp)
}
f010453c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f010453f:	5b                   	pop    %ebx
f0104540:	5e                   	pop    %esi
f0104541:	5f                   	pop    %edi
f0104542:	c9                   	leave  
f0104543:	c3                   	ret    

f0104544 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f0104544:	55                   	push   %ebp
f0104545:	89 e5                	mov    %esp,%ebp
f0104547:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010454a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
f010454d:	83 f8 01             	cmp    $0x1,%eax
f0104550:	7e 0f                	jle    f0104561 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
f0104552:	8b 01                	mov    (%ecx),%eax
f0104554:	83 c0 08             	add    $0x8,%eax
f0104557:	89 01                	mov    %eax,(%ecx)
f0104559:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
f010455c:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
f010455f:	eb 24                	jmp    f0104585 <getuint+0x41>
	else if (lflag)
f0104561:	85 c0                	test   %eax,%eax
f0104563:	74 11                	je     f0104576 <getuint+0x32>
		return va_arg(*ap, unsigned long);
f0104565:	8b 01                	mov    (%ecx),%eax
f0104567:	83 c0 04             	add    $0x4,%eax
f010456a:	89 01                	mov    %eax,(%ecx)
f010456c:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
f010456f:	ba 00 00 00 00       	mov    $0x0,%edx
f0104574:	eb 0f                	jmp    f0104585 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
f0104576:	8b 01                	mov    (%ecx),%eax
f0104578:	83 c0 04             	add    $0x4,%eax
f010457b:	89 01                	mov    %eax,(%ecx)
f010457d:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
f0104580:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0104585:	c9                   	leave  
f0104586:	c3                   	ret    

f0104587 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
f0104587:	55                   	push   %ebp
f0104588:	89 e5                	mov    %esp,%ebp
f010458a:	8b 55 08             	mov    0x8(%ebp),%edx
f010458d:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
f0104590:	83 f8 01             	cmp    $0x1,%eax
f0104593:	7e 0f                	jle    f01045a4 <getint+0x1d>
		return va_arg(*ap, long long);
f0104595:	8b 02                	mov    (%edx),%eax
f0104597:	83 c0 08             	add    $0x8,%eax
f010459a:	89 02                	mov    %eax,(%edx)
f010459c:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
f010459f:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
f01045a2:	eb 1c                	jmp    f01045c0 <getint+0x39>
	else if (lflag)
f01045a4:	85 c0                	test   %eax,%eax
f01045a6:	74 0d                	je     f01045b5 <getint+0x2e>
		return va_arg(*ap, long);
f01045a8:	8b 02                	mov    (%edx),%eax
f01045aa:	83 c0 04             	add    $0x4,%eax
f01045ad:	89 02                	mov    %eax,(%edx)
f01045af:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
f01045b2:	99                   	cltd   
f01045b3:	eb 0b                	jmp    f01045c0 <getint+0x39>
	else
		return va_arg(*ap, int);
f01045b5:	8b 02                	mov    (%edx),%eax
f01045b7:	83 c0 04             	add    $0x4,%eax
f01045ba:	89 02                	mov    %eax,(%edx)
f01045bc:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
f01045bf:	99                   	cltd   
}
f01045c0:	c9                   	leave  
f01045c1:	c3                   	ret    

f01045c2 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f01045c2:	55                   	push   %ebp
f01045c3:	89 e5                	mov    %esp,%ebp
f01045c5:	57                   	push   %edi
f01045c6:	56                   	push   %esi
f01045c7:	53                   	push   %ebx
f01045c8:	83 ec 1c             	sub    $0x1c,%esp
f01045cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	register const char *p;
	register int ch, err;
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
			putch(ch, putdat);
f01045ce:	0f b6 13             	movzbl (%ebx),%edx
f01045d1:	43                   	inc    %ebx
f01045d2:	83 fa 25             	cmp    $0x25,%edx
f01045d5:	74 1e                	je     f01045f5 <vprintfmt+0x33>
f01045d7:	85 d2                	test   %edx,%edx
f01045d9:	0f 84 d7 02 00 00    	je     f01048b6 <vprintfmt+0x2f4>
f01045df:	83 ec 08             	sub    $0x8,%esp
f01045e2:	ff 75 0c             	pushl  0xc(%ebp)
f01045e5:	52                   	push   %edx
f01045e6:	ff 55 08             	call   *0x8(%ebp)
f01045e9:	83 c4 10             	add    $0x10,%esp
f01045ec:	0f b6 13             	movzbl (%ebx),%edx
f01045ef:	43                   	inc    %ebx
f01045f0:	83 fa 25             	cmp    $0x25,%edx
f01045f3:	75 e2                	jne    f01045d7 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
f01045f5:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
f01045f9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
f0104600:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
f0104605:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
f010460a:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0104611:	0f b6 13             	movzbl (%ebx),%edx
f0104614:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
f0104617:	43                   	inc    %ebx
f0104618:	83 f8 55             	cmp    $0x55,%eax
f010461b:	0f 87 70 02 00 00    	ja     f0104891 <vprintfmt+0x2cf>
f0104621:	ff 24 85 7c 70 10 f0 	jmp    *0xf010707c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
f0104628:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
f010462c:	eb e3                	jmp    f0104611 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f010462e:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
f0104632:	eb dd                	jmp    f0104611 <vprintfmt+0x4f>

		// width field
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0104634:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
f0104639:	8d 04 b6             	lea    (%esi,%esi,4),%eax
f010463c:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
f0104640:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
f0104643:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
f0104646:	83 f8 09             	cmp    $0x9,%eax
f0104649:	77 27                	ja     f0104672 <vprintfmt+0xb0>
f010464b:	43                   	inc    %ebx
f010464c:	eb eb                	jmp    f0104639 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f010464e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f0104652:	8b 45 14             	mov    0x14(%ebp),%eax
f0104655:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
f0104658:	eb 18                	jmp    f0104672 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
f010465a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f010465e:	79 b1                	jns    f0104611 <vprintfmt+0x4f>
				width = 0;
f0104660:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
f0104667:	eb a8                	jmp    f0104611 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
f0104669:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
f0104670:	eb 9f                	jmp    f0104611 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
f0104672:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0104676:	79 99                	jns    f0104611 <vprintfmt+0x4f>
				width = precision, precision = -1;
f0104678:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
f010467b:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
f0104680:	eb 8f                	jmp    f0104611 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f0104682:	41                   	inc    %ecx
			goto reswitch;
f0104683:	eb 8c                	jmp    f0104611 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0104685:	83 ec 08             	sub    $0x8,%esp
f0104688:	ff 75 0c             	pushl  0xc(%ebp)
f010468b:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f010468f:	8b 45 14             	mov    0x14(%ebp),%eax
f0104692:	ff 70 fc             	pushl  0xfffffffc(%eax)
f0104695:	ff 55 08             	call   *0x8(%ebp)
			break;
f0104698:	83 c4 10             	add    $0x10,%esp
f010469b:	e9 2e ff ff ff       	jmp    f01045ce <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
f01046a0:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f01046a4:	8b 45 14             	mov    0x14(%ebp),%eax
f01046a7:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
f01046aa:	85 c0                	test   %eax,%eax
f01046ac:	79 02                	jns    f01046b0 <vprintfmt+0xee>
				err = -err;
f01046ae:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
f01046b0:	83 f8 0e             	cmp    $0xe,%eax
f01046b3:	7f 0b                	jg     f01046c0 <vprintfmt+0xfe>
f01046b5:	8b 3c 85 40 70 10 f0 	mov    0xf0107040(,%eax,4),%edi
f01046bc:	85 ff                	test   %edi,%edi
f01046be:	75 19                	jne    f01046d9 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
f01046c0:	50                   	push   %eax
f01046c1:	68 09 70 10 f0       	push   $0xf0107009
f01046c6:	ff 75 0c             	pushl  0xc(%ebp)
f01046c9:	ff 75 08             	pushl  0x8(%ebp)
f01046cc:	e8 ed 01 00 00       	call   f01048be <printfmt>
f01046d1:	83 c4 10             	add    $0x10,%esp
f01046d4:	e9 f5 fe ff ff       	jmp    f01045ce <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
f01046d9:	57                   	push   %edi
f01046da:	68 56 68 10 f0       	push   $0xf0106856
f01046df:	ff 75 0c             	pushl  0xc(%ebp)
f01046e2:	ff 75 08             	pushl  0x8(%ebp)
f01046e5:	e8 d4 01 00 00       	call   f01048be <printfmt>
f01046ea:	83 c4 10             	add    $0x10,%esp
			break;
f01046ed:	e9 dc fe ff ff       	jmp    f01045ce <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f01046f2:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f01046f6:	8b 45 14             	mov    0x14(%ebp),%eax
f01046f9:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
f01046fc:	85 ff                	test   %edi,%edi
f01046fe:	75 05                	jne    f0104705 <vprintfmt+0x143>
				p = "(null)";
f0104700:	bf 12 70 10 f0       	mov    $0xf0107012,%edi
			if (width > 0 && padc != '-')
f0104705:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0104709:	7e 3b                	jle    f0104746 <vprintfmt+0x184>
f010470b:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
f010470f:	74 35                	je     f0104746 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
f0104711:	83 ec 08             	sub    $0x8,%esp
f0104714:	56                   	push   %esi
f0104715:	57                   	push   %edi
f0104716:	e8 2a 04 00 00       	call   f0104b45 <strnlen>
f010471b:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
f010471e:	83 c4 10             	add    $0x10,%esp
f0104721:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0104725:	7e 1f                	jle    f0104746 <vprintfmt+0x184>
f0104727:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
f010472b:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
f010472e:	83 ec 08             	sub    $0x8,%esp
f0104731:	ff 75 0c             	pushl  0xc(%ebp)
f0104734:	ff 75 e4             	pushl  0xffffffe4(%ebp)
f0104737:	ff 55 08             	call   *0x8(%ebp)
f010473a:	83 c4 10             	add    $0x10,%esp
f010473d:	ff 4d f0             	decl   0xfffffff0(%ebp)
f0104740:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0104744:	7f e8                	jg     f010472e <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0104746:	0f be 17             	movsbl (%edi),%edx
f0104749:	47                   	inc    %edi
f010474a:	85 d2                	test   %edx,%edx
f010474c:	74 44                	je     f0104792 <vprintfmt+0x1d0>
f010474e:	85 f6                	test   %esi,%esi
f0104750:	78 03                	js     f0104755 <vprintfmt+0x193>
f0104752:	4e                   	dec    %esi
f0104753:	78 3d                	js     f0104792 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
f0104755:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
f0104759:	74 18                	je     f0104773 <vprintfmt+0x1b1>
f010475b:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
f010475e:	83 f8 5e             	cmp    $0x5e,%eax
f0104761:	76 10                	jbe    f0104773 <vprintfmt+0x1b1>
					putch('?', putdat);
f0104763:	83 ec 08             	sub    $0x8,%esp
f0104766:	ff 75 0c             	pushl  0xc(%ebp)
f0104769:	6a 3f                	push   $0x3f
f010476b:	ff 55 08             	call   *0x8(%ebp)
f010476e:	83 c4 10             	add    $0x10,%esp
f0104771:	eb 0d                	jmp    f0104780 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
f0104773:	83 ec 08             	sub    $0x8,%esp
f0104776:	ff 75 0c             	pushl  0xc(%ebp)
f0104779:	52                   	push   %edx
f010477a:	ff 55 08             	call   *0x8(%ebp)
f010477d:	83 c4 10             	add    $0x10,%esp
f0104780:	ff 4d f0             	decl   0xfffffff0(%ebp)
f0104783:	0f be 17             	movsbl (%edi),%edx
f0104786:	47                   	inc    %edi
f0104787:	85 d2                	test   %edx,%edx
f0104789:	74 07                	je     f0104792 <vprintfmt+0x1d0>
f010478b:	85 f6                	test   %esi,%esi
f010478d:	78 c6                	js     f0104755 <vprintfmt+0x193>
f010478f:	4e                   	dec    %esi
f0104790:	79 c3                	jns    f0104755 <vprintfmt+0x193>
			for (; width > 0; width--)
f0104792:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0104796:	0f 8e 32 fe ff ff    	jle    f01045ce <vprintfmt+0xc>
				putch(' ', putdat);
f010479c:	83 ec 08             	sub    $0x8,%esp
f010479f:	ff 75 0c             	pushl  0xc(%ebp)
f01047a2:	6a 20                	push   $0x20
f01047a4:	ff 55 08             	call   *0x8(%ebp)
f01047a7:	83 c4 10             	add    $0x10,%esp
f01047aa:	ff 4d f0             	decl   0xfffffff0(%ebp)
f01047ad:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f01047b1:	7f e9                	jg     f010479c <vprintfmt+0x1da>
			break;
f01047b3:	e9 16 fe ff ff       	jmp    f01045ce <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f01047b8:	51                   	push   %ecx
f01047b9:	8d 45 14             	lea    0x14(%ebp),%eax
f01047bc:	50                   	push   %eax
f01047bd:	e8 c5 fd ff ff       	call   f0104587 <getint>
f01047c2:	89 c6                	mov    %eax,%esi
f01047c4:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
f01047c6:	83 c4 08             	add    $0x8,%esp
f01047c9:	85 d2                	test   %edx,%edx
f01047cb:	79 15                	jns    f01047e2 <vprintfmt+0x220>
				putch('-', putdat);
f01047cd:	83 ec 08             	sub    $0x8,%esp
f01047d0:	ff 75 0c             	pushl  0xc(%ebp)
f01047d3:	6a 2d                	push   $0x2d
f01047d5:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01047d8:	f7 de                	neg    %esi
f01047da:	83 d7 00             	adc    $0x0,%edi
f01047dd:	f7 df                	neg    %edi
f01047df:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
f01047e2:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
f01047e7:	eb 75                	jmp    f010485e <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f01047e9:	51                   	push   %ecx
f01047ea:	8d 45 14             	lea    0x14(%ebp),%eax
f01047ed:	50                   	push   %eax
f01047ee:	e8 51 fd ff ff       	call   f0104544 <getuint>
f01047f3:	89 c6                	mov    %eax,%esi
f01047f5:	89 d7                	mov    %edx,%edi
			base = 10;
f01047f7:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
f01047fc:	83 c4 08             	add    $0x8,%esp
f01047ff:	eb 5d                	jmp    f010485e <vprintfmt+0x29c>

		// (unsigned) octal
		case 'o':
                        /*
                        // Staff code below
			// Replace this with your code.
			putch('X', putdat);
			putch('X', putdat);
			putch('X', putdat);
			break;
                        */
                        // seanyliu
			num = getuint(&ap, lflag);
f0104801:	51                   	push   %ecx
f0104802:	8d 45 14             	lea    0x14(%ebp),%eax
f0104805:	50                   	push   %eax
f0104806:	e8 39 fd ff ff       	call   f0104544 <getuint>
f010480b:	89 c6                	mov    %eax,%esi
f010480d:	89 d7                	mov    %edx,%edi
			base = 8;
f010480f:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
f0104814:	83 c4 08             	add    $0x8,%esp
f0104817:	eb 45                	jmp    f010485e <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
f0104819:	83 ec 08             	sub    $0x8,%esp
f010481c:	ff 75 0c             	pushl  0xc(%ebp)
f010481f:	6a 30                	push   $0x30
f0104821:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f0104824:	83 c4 08             	add    $0x8,%esp
f0104827:	ff 75 0c             	pushl  0xc(%ebp)
f010482a:	6a 78                	push   $0x78
f010482c:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f010482f:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f0104833:	8b 45 14             	mov    0x14(%ebp),%eax
f0104836:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
f0104839:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f010483e:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
f0104843:	83 c4 10             	add    $0x10,%esp
f0104846:	eb 16                	jmp    f010485e <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0104848:	51                   	push   %ecx
f0104849:	8d 45 14             	lea    0x14(%ebp),%eax
f010484c:	50                   	push   %eax
f010484d:	e8 f2 fc ff ff       	call   f0104544 <getuint>
f0104852:	89 c6                	mov    %eax,%esi
f0104854:	89 d7                	mov    %edx,%edi
			base = 16;
f0104856:	ba 10 00 00 00       	mov    $0x10,%edx
f010485b:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
f010485e:	83 ec 04             	sub    $0x4,%esp
f0104861:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
f0104865:	50                   	push   %eax
f0104866:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0104869:	52                   	push   %edx
f010486a:	57                   	push   %edi
f010486b:	56                   	push   %esi
f010486c:	ff 75 0c             	pushl  0xc(%ebp)
f010486f:	ff 75 08             	pushl  0x8(%ebp)
f0104872:	e8 2d fc ff ff       	call   f01044a4 <printnum>
			break;
f0104877:	83 c4 20             	add    $0x20,%esp
f010487a:	e9 4f fd ff ff       	jmp    f01045ce <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f010487f:	83 ec 08             	sub    $0x8,%esp
f0104882:	ff 75 0c             	pushl  0xc(%ebp)
f0104885:	52                   	push   %edx
f0104886:	ff 55 08             	call   *0x8(%ebp)
			break;
f0104889:	83 c4 10             	add    $0x10,%esp
f010488c:	e9 3d fd ff ff       	jmp    f01045ce <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0104891:	83 ec 08             	sub    $0x8,%esp
f0104894:	ff 75 0c             	pushl  0xc(%ebp)
f0104897:	6a 25                	push   $0x25
f0104899:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f010489c:	4b                   	dec    %ebx
f010489d:	83 c4 10             	add    $0x10,%esp
f01048a0:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
f01048a4:	0f 84 24 fd ff ff    	je     f01045ce <vprintfmt+0xc>
f01048aa:	4b                   	dec    %ebx
f01048ab:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
f01048af:	75 f9                	jne    f01048aa <vprintfmt+0x2e8>
				/* do nothing */;
			break;
f01048b1:	e9 18 fd ff ff       	jmp    f01045ce <vprintfmt+0xc>
		}
	}
}
f01048b6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f01048b9:	5b                   	pop    %ebx
f01048ba:	5e                   	pop    %esi
f01048bb:	5f                   	pop    %edi
f01048bc:	c9                   	leave  
f01048bd:	c3                   	ret    

f01048be <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f01048be:	55                   	push   %ebp
f01048bf:	89 e5                	mov    %esp,%ebp
f01048c1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01048c4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f01048c7:	50                   	push   %eax
f01048c8:	ff 75 10             	pushl  0x10(%ebp)
f01048cb:	ff 75 0c             	pushl  0xc(%ebp)
f01048ce:	ff 75 08             	pushl  0x8(%ebp)
f01048d1:	e8 ec fc ff ff       	call   f01045c2 <vprintfmt>
	va_end(ap);
}
f01048d6:	c9                   	leave  
f01048d7:	c3                   	ret    

f01048d8 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01048d8:	55                   	push   %ebp
f01048d9:	89 e5                	mov    %esp,%ebp
f01048db:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
f01048de:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
f01048e1:	8b 0a                	mov    (%edx),%ecx
f01048e3:	3b 4a 04             	cmp    0x4(%edx),%ecx
f01048e6:	73 07                	jae    f01048ef <sprintputch+0x17>
		*b->buf++ = ch;
f01048e8:	8b 45 08             	mov    0x8(%ebp),%eax
f01048eb:	88 01                	mov    %al,(%ecx)
f01048ed:	ff 02                	incl   (%edx)
}
f01048ef:	c9                   	leave  
f01048f0:	c3                   	ret    

f01048f1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01048f1:	55                   	push   %ebp
f01048f2:	89 e5                	mov    %esp,%ebp
f01048f4:	83 ec 18             	sub    $0x18,%esp
f01048f7:	8b 55 08             	mov    0x8(%ebp),%edx
f01048fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01048fd:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
f0104900:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
f0104904:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
f0104907:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
f010490e:	85 d2                	test   %edx,%edx
f0104910:	74 04                	je     f0104916 <vsnprintf+0x25>
f0104912:	85 c9                	test   %ecx,%ecx
f0104914:	7f 07                	jg     f010491d <vsnprintf+0x2c>
		return -E_INVAL;
f0104916:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010491b:	eb 1d                	jmp    f010493a <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f010491d:	ff 75 14             	pushl  0x14(%ebp)
f0104920:	ff 75 10             	pushl  0x10(%ebp)
f0104923:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0104926:	50                   	push   %eax
f0104927:	68 d8 48 10 f0       	push   $0xf01048d8
f010492c:	e8 91 fc ff ff       	call   f01045c2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0104931:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f0104934:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0104937:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
f010493a:	c9                   	leave  
f010493b:	c3                   	ret    

f010493c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010493c:	55                   	push   %ebp
f010493d:	89 e5                	mov    %esp,%ebp
f010493f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0104942:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0104945:	50                   	push   %eax
f0104946:	ff 75 10             	pushl  0x10(%ebp)
f0104949:	ff 75 0c             	pushl  0xc(%ebp)
f010494c:	ff 75 08             	pushl  0x8(%ebp)
f010494f:	e8 9d ff ff ff       	call   f01048f1 <vsnprintf>
	va_end(ap);

	return rc;
}
f0104954:	c9                   	leave  
f0104955:	c3                   	ret    
	...

f0104958 <readline>:
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0104958:	55                   	push   %ebp
f0104959:	89 e5                	mov    %esp,%ebp
f010495b:	57                   	push   %edi
f010495c:	56                   	push   %esi
f010495d:	53                   	push   %ebx
f010495e:	83 ec 0c             	sub    $0xc,%esp
f0104961:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0104964:	85 c0                	test   %eax,%eax
f0104966:	74 11                	je     f0104979 <readline+0x21>
		cprintf("%s", prompt);
f0104968:	83 ec 08             	sub    $0x8,%esp
f010496b:	50                   	push   %eax
f010496c:	68 56 68 10 f0       	push   $0xf0106856
f0104971:	e8 4c e7 ff ff       	call   f01030c2 <cprintf>
f0104976:	83 c4 10             	add    $0x10,%esp
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
f0104979:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
f010497e:	83 ec 0c             	sub    $0xc,%esp
f0104981:	6a 00                	push   $0x0
f0104983:	e8 35 bd ff ff       	call   f01006bd <iscons>
f0104988:	89 c7                	mov    %eax,%edi
	while (1) {
f010498a:	83 c4 10             	add    $0x10,%esp
		c = getchar();
f010498d:	e8 1a bd ff ff       	call   f01006ac <getchar>
f0104992:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0104994:	85 c0                	test   %eax,%eax
f0104996:	79 1d                	jns    f01049b5 <readline+0x5d>
			if (c != -E_EOF)
f0104998:	83 f8 f8             	cmp    $0xfffffff8,%eax
f010499b:	74 11                	je     f01049ae <readline+0x56>
				cprintf("read error: %e\n", c);
f010499d:	83 ec 08             	sub    $0x8,%esp
f01049a0:	50                   	push   %eax
f01049a1:	68 d4 71 10 f0       	push   $0xf01071d4
f01049a6:	e8 17 e7 ff ff       	call   f01030c2 <cprintf>
f01049ab:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01049ae:	b8 00 00 00 00       	mov    $0x0,%eax
f01049b3:	eb 6f                	jmp    f0104a24 <readline+0xcc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01049b5:	83 f8 08             	cmp    $0x8,%eax
f01049b8:	74 05                	je     f01049bf <readline+0x67>
f01049ba:	83 f8 7f             	cmp    $0x7f,%eax
f01049bd:	75 18                	jne    f01049d7 <readline+0x7f>
f01049bf:	85 f6                	test   %esi,%esi
f01049c1:	7e 14                	jle    f01049d7 <readline+0x7f>
			if (echoing)
f01049c3:	85 ff                	test   %edi,%edi
f01049c5:	74 0d                	je     f01049d4 <readline+0x7c>
				cputchar('\b');
f01049c7:	83 ec 0c             	sub    $0xc,%esp
f01049ca:	6a 08                	push   $0x8
f01049cc:	e8 cb bc ff ff       	call   f010069c <cputchar>
f01049d1:	83 c4 10             	add    $0x10,%esp
			i--;
f01049d4:	4e                   	dec    %esi
f01049d5:	eb b6                	jmp    f010498d <readline+0x35>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01049d7:	83 fb 1f             	cmp    $0x1f,%ebx
f01049da:	7e 21                	jle    f01049fd <readline+0xa5>
f01049dc:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01049e2:	7f 19                	jg     f01049fd <readline+0xa5>
			if (echoing)
f01049e4:	85 ff                	test   %edi,%edi
f01049e6:	74 0c                	je     f01049f4 <readline+0x9c>
				cputchar(c);
f01049e8:	83 ec 0c             	sub    $0xc,%esp
f01049eb:	53                   	push   %ebx
f01049ec:	e8 ab bc ff ff       	call   f010069c <cputchar>
f01049f1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01049f4:	88 9e 60 64 2f f0    	mov    %bl,0xf02f6460(%esi)
f01049fa:	46                   	inc    %esi
f01049fb:	eb 90                	jmp    f010498d <readline+0x35>
		} else if (c == '\n' || c == '\r') {
f01049fd:	83 fb 0a             	cmp    $0xa,%ebx
f0104a00:	74 05                	je     f0104a07 <readline+0xaf>
f0104a02:	83 fb 0d             	cmp    $0xd,%ebx
f0104a05:	75 86                	jne    f010498d <readline+0x35>
			if (echoing)
f0104a07:	85 ff                	test   %edi,%edi
f0104a09:	74 0d                	je     f0104a18 <readline+0xc0>
				cputchar('\n');
f0104a0b:	83 ec 0c             	sub    $0xc,%esp
f0104a0e:	6a 0a                	push   $0xa
f0104a10:	e8 87 bc ff ff       	call   f010069c <cputchar>
f0104a15:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
f0104a18:	c6 86 60 64 2f f0 00 	movb   $0x0,0xf02f6460(%esi)
			return buf;
f0104a1f:	b8 60 64 2f f0       	mov    $0xf02f6460,%eax
		}
	}
}
f0104a24:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0104a27:	5b                   	pop    %ebx
f0104a28:	5e                   	pop    %esi
f0104a29:	5f                   	pop    %edi
f0104a2a:	c9                   	leave  
f0104a2b:	c3                   	ret    

f0104a2c <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
f0104a2c:	55                   	push   %ebp
f0104a2d:	89 e5                	mov    %esp,%ebp
f0104a2f:	56                   	push   %esi
f0104a30:	53                   	push   %ebx
f0104a31:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
f0104a34:	83 ec 0c             	sub    $0xc,%esp
f0104a37:	56                   	push   %esi
f0104a38:	e8 ef 00 00 00       	call   f0104b2c <strlen>
  char letter;
  int hexnum = 0;
f0104a3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
f0104a42:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
f0104a47:	83 c4 10             	add    $0x10,%esp
f0104a4a:	89 c2                	mov    %eax,%edx
f0104a4c:	4a                   	dec    %edx
f0104a4d:	0f 88 d0 00 00 00    	js     f0104b23 <strtoint+0xf7>
    letter = string[cidx];
f0104a53:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
f0104a56:	85 d2                	test   %edx,%edx
f0104a58:	75 12                	jne    f0104a6c <strtoint+0x40>
      if (letter != '0') {
f0104a5a:	3c 30                	cmp    $0x30,%al
f0104a5c:	0f 84 ba 00 00 00    	je     f0104b1c <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
f0104a62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104a67:	e9 b9 00 00 00       	jmp    f0104b25 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
f0104a6c:	83 fa 01             	cmp    $0x1,%edx
f0104a6f:	75 12                	jne    f0104a83 <strtoint+0x57>
      if (letter != 'x') {
f0104a71:	3c 78                	cmp    $0x78,%al
f0104a73:	0f 84 a3 00 00 00    	je     f0104b1c <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
f0104a79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104a7e:	e9 a2 00 00 00       	jmp    f0104b25 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
f0104a83:	0f be c0             	movsbl %al,%eax
f0104a86:	83 e8 30             	sub    $0x30,%eax
f0104a89:	83 f8 36             	cmp    $0x36,%eax
f0104a8c:	0f 87 80 00 00 00    	ja     f0104b12 <strtoint+0xe6>
f0104a92:	ff 24 85 e4 71 10 f0 	jmp    *0xf01071e4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
f0104a99:	01 cb                	add    %ecx,%ebx
          break;
f0104a9b:	eb 7c                	jmp    f0104b19 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
f0104a9d:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
f0104aa0:	eb 77                	jmp    f0104b19 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
f0104aa2:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0104aa5:	01 c3                	add    %eax,%ebx
          break;
f0104aa7:	eb 70                	jmp    f0104b19 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
f0104aa9:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
f0104aac:	eb 6b                	jmp    f0104b19 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
f0104aae:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
f0104ab1:	01 c3                	add    %eax,%ebx
          break;
f0104ab3:	eb 64                	jmp    f0104b19 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
f0104ab5:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0104ab8:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
f0104abb:	eb 5c                	jmp    f0104b19 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
f0104abd:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
f0104ac4:	29 c8                	sub    %ecx,%eax
f0104ac6:	01 c3                	add    %eax,%ebx
          break;
f0104ac8:	eb 4f                	jmp    f0104b19 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
f0104aca:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
f0104acd:	eb 4a                	jmp    f0104b19 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
f0104acf:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
f0104ad2:	01 c3                	add    %eax,%ebx
          break;
f0104ad4:	eb 43                	jmp    f0104b19 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
f0104ad6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
f0104ad9:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
f0104adc:	eb 3b                	jmp    f0104b19 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
f0104ade:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
f0104ae1:	8d 04 41             	lea    (%ecx,%eax,2),%eax
f0104ae4:	01 c3                	add    %eax,%ebx
          break;
f0104ae6:	eb 31                	jmp    f0104b19 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
f0104ae8:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0104aeb:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
f0104aee:	eb 29                	jmp    f0104b19 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
f0104af0:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0104af3:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0104af6:	01 c3                	add    %eax,%ebx
          break;
f0104af8:	eb 1f                	jmp    f0104b19 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
f0104afa:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
f0104b01:	29 c8                	sub    %ecx,%eax
f0104b03:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
f0104b06:	eb 11                	jmp    f0104b19 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
f0104b08:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0104b0b:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0104b0e:	01 c3                	add    %eax,%ebx
          break;
f0104b10:	eb 07                	jmp    f0104b19 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
f0104b12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104b17:	eb 0c                	jmp    f0104b25 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
f0104b19:	c1 e1 04             	shl    $0x4,%ecx
f0104b1c:	4a                   	dec    %edx
f0104b1d:	0f 89 30 ff ff ff    	jns    f0104a53 <strtoint+0x27>
    }
  }

  return hexnum;
f0104b23:	89 d8                	mov    %ebx,%eax
}
f0104b25:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0104b28:	5b                   	pop    %ebx
f0104b29:	5e                   	pop    %esi
f0104b2a:	c9                   	leave  
f0104b2b:	c3                   	ret    

f0104b2c <strlen>:





int
strlen(const char *s)
{
f0104b2c:	55                   	push   %ebp
f0104b2d:	89 e5                	mov    %esp,%ebp
f0104b2f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0104b32:	b8 00 00 00 00       	mov    $0x0,%eax
f0104b37:	80 3a 00             	cmpb   $0x0,(%edx)
f0104b3a:	74 07                	je     f0104b43 <strlen+0x17>
		n++;
f0104b3c:	40                   	inc    %eax
f0104b3d:	42                   	inc    %edx
f0104b3e:	80 3a 00             	cmpb   $0x0,(%edx)
f0104b41:	75 f9                	jne    f0104b3c <strlen+0x10>
	return n;
}
f0104b43:	c9                   	leave  
f0104b44:	c3                   	ret    

f0104b45 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0104b45:	55                   	push   %ebp
f0104b46:	89 e5                	mov    %esp,%ebp
f0104b48:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0104b4e:	b8 00 00 00 00       	mov    $0x0,%eax
f0104b53:	85 d2                	test   %edx,%edx
f0104b55:	74 0f                	je     f0104b66 <strnlen+0x21>
f0104b57:	80 39 00             	cmpb   $0x0,(%ecx)
f0104b5a:	74 0a                	je     f0104b66 <strnlen+0x21>
		n++;
f0104b5c:	40                   	inc    %eax
f0104b5d:	41                   	inc    %ecx
f0104b5e:	4a                   	dec    %edx
f0104b5f:	74 05                	je     f0104b66 <strnlen+0x21>
f0104b61:	80 39 00             	cmpb   $0x0,(%ecx)
f0104b64:	75 f6                	jne    f0104b5c <strnlen+0x17>
	return n;
}
f0104b66:	c9                   	leave  
f0104b67:	c3                   	ret    

f0104b68 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0104b68:	55                   	push   %ebp
f0104b69:	89 e5                	mov    %esp,%ebp
f0104b6b:	53                   	push   %ebx
f0104b6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
f0104b72:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
f0104b74:	8a 02                	mov    (%edx),%al
f0104b76:	42                   	inc    %edx
f0104b77:	88 01                	mov    %al,(%ecx)
f0104b79:	41                   	inc    %ecx
f0104b7a:	84 c0                	test   %al,%al
f0104b7c:	75 f6                	jne    f0104b74 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0104b7e:	89 d8                	mov    %ebx,%eax
f0104b80:	5b                   	pop    %ebx
f0104b81:	c9                   	leave  
f0104b82:	c3                   	ret    

f0104b83 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0104b83:	55                   	push   %ebp
f0104b84:	89 e5                	mov    %esp,%ebp
f0104b86:	57                   	push   %edi
f0104b87:	56                   	push   %esi
f0104b88:	53                   	push   %ebx
f0104b89:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104b8f:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
f0104b92:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
f0104b94:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104b99:	39 f3                	cmp    %esi,%ebx
f0104b9b:	73 10                	jae    f0104bad <strncpy+0x2a>
		*dst++ = *src;
f0104b9d:	8a 02                	mov    (%edx),%al
f0104b9f:	88 01                	mov    %al,(%ecx)
f0104ba1:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0104ba2:	80 3a 01             	cmpb   $0x1,(%edx)
f0104ba5:	83 da ff             	sbb    $0xffffffff,%edx
f0104ba8:	43                   	inc    %ebx
f0104ba9:	39 f3                	cmp    %esi,%ebx
f0104bab:	72 f0                	jb     f0104b9d <strncpy+0x1a>
	}
	return ret;
}
f0104bad:	89 f8                	mov    %edi,%eax
f0104baf:	5b                   	pop    %ebx
f0104bb0:	5e                   	pop    %esi
f0104bb1:	5f                   	pop    %edi
f0104bb2:	c9                   	leave  
f0104bb3:	c3                   	ret    

f0104bb4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0104bb4:	55                   	push   %ebp
f0104bb5:	89 e5                	mov    %esp,%ebp
f0104bb7:	56                   	push   %esi
f0104bb8:	53                   	push   %ebx
f0104bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104bbf:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
f0104bc2:	89 de                	mov    %ebx,%esi
	if (size > 0) {
f0104bc4:	85 d2                	test   %edx,%edx
f0104bc6:	74 19                	je     f0104be1 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0104bc8:	4a                   	dec    %edx
f0104bc9:	74 13                	je     f0104bde <strlcpy+0x2a>
f0104bcb:	80 39 00             	cmpb   $0x0,(%ecx)
f0104bce:	74 0e                	je     f0104bde <strlcpy+0x2a>
f0104bd0:	8a 01                	mov    (%ecx),%al
f0104bd2:	41                   	inc    %ecx
f0104bd3:	88 03                	mov    %al,(%ebx)
f0104bd5:	43                   	inc    %ebx
f0104bd6:	4a                   	dec    %edx
f0104bd7:	74 05                	je     f0104bde <strlcpy+0x2a>
f0104bd9:	80 39 00             	cmpb   $0x0,(%ecx)
f0104bdc:	75 f2                	jne    f0104bd0 <strlcpy+0x1c>
		*dst = '\0';
f0104bde:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
f0104be1:	89 d8                	mov    %ebx,%eax
f0104be3:	29 f0                	sub    %esi,%eax
}
f0104be5:	5b                   	pop    %ebx
f0104be6:	5e                   	pop    %esi
f0104be7:	c9                   	leave  
f0104be8:	c3                   	ret    

f0104be9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0104be9:	55                   	push   %ebp
f0104bea:	89 e5                	mov    %esp,%ebp
f0104bec:	8b 55 08             	mov    0x8(%ebp),%edx
f0104bef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
f0104bf2:	80 3a 00             	cmpb   $0x0,(%edx)
f0104bf5:	74 13                	je     f0104c0a <strcmp+0x21>
f0104bf7:	8a 02                	mov    (%edx),%al
f0104bf9:	3a 01                	cmp    (%ecx),%al
f0104bfb:	75 0d                	jne    f0104c0a <strcmp+0x21>
f0104bfd:	42                   	inc    %edx
f0104bfe:	41                   	inc    %ecx
f0104bff:	80 3a 00             	cmpb   $0x0,(%edx)
f0104c02:	74 06                	je     f0104c0a <strcmp+0x21>
f0104c04:	8a 02                	mov    (%edx),%al
f0104c06:	3a 01                	cmp    (%ecx),%al
f0104c08:	74 f3                	je     f0104bfd <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0104c0a:	0f b6 02             	movzbl (%edx),%eax
f0104c0d:	0f b6 11             	movzbl (%ecx),%edx
f0104c10:	29 d0                	sub    %edx,%eax
}
f0104c12:	c9                   	leave  
f0104c13:	c3                   	ret    

f0104c14 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0104c14:	55                   	push   %ebp
f0104c15:	89 e5                	mov    %esp,%ebp
f0104c17:	53                   	push   %ebx
f0104c18:	8b 55 08             	mov    0x8(%ebp),%edx
f0104c1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104c1e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
f0104c21:	85 c9                	test   %ecx,%ecx
f0104c23:	74 1f                	je     f0104c44 <strncmp+0x30>
f0104c25:	80 3a 00             	cmpb   $0x0,(%edx)
f0104c28:	74 16                	je     f0104c40 <strncmp+0x2c>
f0104c2a:	8a 02                	mov    (%edx),%al
f0104c2c:	3a 03                	cmp    (%ebx),%al
f0104c2e:	75 10                	jne    f0104c40 <strncmp+0x2c>
f0104c30:	42                   	inc    %edx
f0104c31:	43                   	inc    %ebx
f0104c32:	49                   	dec    %ecx
f0104c33:	74 0f                	je     f0104c44 <strncmp+0x30>
f0104c35:	80 3a 00             	cmpb   $0x0,(%edx)
f0104c38:	74 06                	je     f0104c40 <strncmp+0x2c>
f0104c3a:	8a 02                	mov    (%edx),%al
f0104c3c:	3a 03                	cmp    (%ebx),%al
f0104c3e:	74 f0                	je     f0104c30 <strncmp+0x1c>
	if (n == 0)
f0104c40:	85 c9                	test   %ecx,%ecx
f0104c42:	75 07                	jne    f0104c4b <strncmp+0x37>
		return 0;
f0104c44:	b8 00 00 00 00       	mov    $0x0,%eax
f0104c49:	eb 0a                	jmp    f0104c55 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0104c4b:	0f b6 12             	movzbl (%edx),%edx
f0104c4e:	0f b6 03             	movzbl (%ebx),%eax
f0104c51:	29 c2                	sub    %eax,%edx
f0104c53:	89 d0                	mov    %edx,%eax
}
f0104c55:	5b                   	pop    %ebx
f0104c56:	c9                   	leave  
f0104c57:	c3                   	ret    

f0104c58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0104c58:	55                   	push   %ebp
f0104c59:	89 e5                	mov    %esp,%ebp
f0104c5b:	8b 45 08             	mov    0x8(%ebp),%eax
f0104c5e:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
f0104c61:	80 38 00             	cmpb   $0x0,(%eax)
f0104c64:	74 0a                	je     f0104c70 <strchr+0x18>
		if (*s == c)
f0104c66:	38 10                	cmp    %dl,(%eax)
f0104c68:	74 0b                	je     f0104c75 <strchr+0x1d>
f0104c6a:	40                   	inc    %eax
f0104c6b:	80 38 00             	cmpb   $0x0,(%eax)
f0104c6e:	75 f6                	jne    f0104c66 <strchr+0xe>
			return (char *) s;
	return 0;
f0104c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104c75:	c9                   	leave  
f0104c76:	c3                   	ret    

f0104c77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0104c77:	55                   	push   %ebp
f0104c78:	89 e5                	mov    %esp,%ebp
f0104c7a:	8b 45 08             	mov    0x8(%ebp),%eax
f0104c7d:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
f0104c80:	80 38 00             	cmpb   $0x0,(%eax)
f0104c83:	74 0a                	je     f0104c8f <strfind+0x18>
		if (*s == c)
f0104c85:	38 10                	cmp    %dl,(%eax)
f0104c87:	74 06                	je     f0104c8f <strfind+0x18>
f0104c89:	40                   	inc    %eax
f0104c8a:	80 38 00             	cmpb   $0x0,(%eax)
f0104c8d:	75 f6                	jne    f0104c85 <strfind+0xe>
			break;
	return (char *) s;
}
f0104c8f:	c9                   	leave  
f0104c90:	c3                   	ret    

f0104c91 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0104c91:	55                   	push   %ebp
f0104c92:	89 e5                	mov    %esp,%ebp
f0104c94:	57                   	push   %edi
f0104c95:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104c98:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
f0104c9b:	89 f8                	mov    %edi,%eax
f0104c9d:	85 c9                	test   %ecx,%ecx
f0104c9f:	74 40                	je     f0104ce1 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
f0104ca1:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0104ca7:	75 30                	jne    f0104cd9 <memset+0x48>
f0104ca9:	f6 c1 03             	test   $0x3,%cl
f0104cac:	75 2b                	jne    f0104cd9 <memset+0x48>
		c &= 0xFF;
f0104cae:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0104cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104cb8:	c1 e0 18             	shl    $0x18,%eax
f0104cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104cbe:	c1 e2 10             	shl    $0x10,%edx
f0104cc1:	09 d0                	or     %edx,%eax
f0104cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104cc6:	c1 e2 08             	shl    $0x8,%edx
f0104cc9:	09 d0                	or     %edx,%eax
f0104ccb:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
f0104cce:	c1 e9 02             	shr    $0x2,%ecx
f0104cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104cd4:	fc                   	cld    
f0104cd5:	f3 ab                	repz stos %eax,%es:(%edi)
f0104cd7:	eb 06                	jmp    f0104cdf <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0104cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104cdc:	fc                   	cld    
f0104cdd:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
f0104cdf:	89 f8                	mov    %edi,%eax
}
f0104ce1:	5f                   	pop    %edi
f0104ce2:	c9                   	leave  
f0104ce3:	c3                   	ret    

f0104ce4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0104ce4:	55                   	push   %ebp
f0104ce5:	89 e5                	mov    %esp,%ebp
f0104ce7:	57                   	push   %edi
f0104ce8:	56                   	push   %esi
f0104ce9:	8b 45 08             	mov    0x8(%ebp),%eax
f0104cec:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
f0104cef:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
f0104cf2:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
f0104cf4:	39 c6                	cmp    %eax,%esi
f0104cf6:	73 33                	jae    f0104d2b <memmove+0x47>
f0104cf8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0104cfb:	39 c2                	cmp    %eax,%edx
f0104cfd:	76 2c                	jbe    f0104d2b <memmove+0x47>
		s += n;
f0104cff:	89 d6                	mov    %edx,%esi
		d += n;
f0104d01:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104d04:	f6 c2 03             	test   $0x3,%dl
f0104d07:	75 1b                	jne    f0104d24 <memmove+0x40>
f0104d09:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0104d0f:	75 13                	jne    f0104d24 <memmove+0x40>
f0104d11:	f6 c1 03             	test   $0x3,%cl
f0104d14:	75 0e                	jne    f0104d24 <memmove+0x40>
			asm volatile("std; rep movsl\n"
f0104d16:	83 ef 04             	sub    $0x4,%edi
f0104d19:	83 ee 04             	sub    $0x4,%esi
f0104d1c:	c1 e9 02             	shr    $0x2,%ecx
f0104d1f:	fd                   	std    
f0104d20:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
f0104d22:	eb 27                	jmp    f0104d4b <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0104d24:	4f                   	dec    %edi
f0104d25:	4e                   	dec    %esi
f0104d26:	fd                   	std    
f0104d27:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
f0104d29:	eb 20                	jmp    f0104d4b <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104d2b:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0104d31:	75 15                	jne    f0104d48 <memmove+0x64>
f0104d33:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0104d39:	75 0d                	jne    f0104d48 <memmove+0x64>
f0104d3b:	f6 c1 03             	test   $0x3,%cl
f0104d3e:	75 08                	jne    f0104d48 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
f0104d40:	c1 e9 02             	shr    $0x2,%ecx
f0104d43:	fc                   	cld    
f0104d44:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
f0104d46:	eb 03                	jmp    f0104d4b <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0104d48:	fc                   	cld    
f0104d49:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0104d4b:	5e                   	pop    %esi
f0104d4c:	5f                   	pop    %edi
f0104d4d:	c9                   	leave  
f0104d4e:	c3                   	ret    

f0104d4f <memcpy>:

#else

void *
memset(void *v, int c, size_t n)
{
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
		*p++ = c;

	return v;
}

/* no memcpy - use memmove instead */

void *
memmove(void *dst, const void *src, size_t n)
{
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;

	return dst;
}
#endif

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
f0104d4f:	55                   	push   %ebp
f0104d50:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f0104d52:	ff 75 10             	pushl  0x10(%ebp)
f0104d55:	ff 75 0c             	pushl  0xc(%ebp)
f0104d58:	ff 75 08             	pushl  0x8(%ebp)
f0104d5b:	e8 84 ff ff ff       	call   f0104ce4 <memmove>
}
f0104d60:	c9                   	leave  
f0104d61:	c3                   	ret    

f0104d62 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0104d62:	55                   	push   %ebp
f0104d63:	89 e5                	mov    %esp,%ebp
f0104d65:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
f0104d66:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
f0104d69:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0104d6c:	8b 55 10             	mov    0x10(%ebp),%edx
f0104d6f:	4a                   	dec    %edx
f0104d70:	83 fa ff             	cmp    $0xffffffff,%edx
f0104d73:	74 1a                	je     f0104d8f <memcmp+0x2d>
f0104d75:	8a 01                	mov    (%ecx),%al
f0104d77:	3a 03                	cmp    (%ebx),%al
f0104d79:	74 0c                	je     f0104d87 <memcmp+0x25>
f0104d7b:	0f b6 d0             	movzbl %al,%edx
f0104d7e:	0f b6 03             	movzbl (%ebx),%eax
f0104d81:	29 c2                	sub    %eax,%edx
f0104d83:	89 d0                	mov    %edx,%eax
f0104d85:	eb 0d                	jmp    f0104d94 <memcmp+0x32>
f0104d87:	41                   	inc    %ecx
f0104d88:	43                   	inc    %ebx
f0104d89:	4a                   	dec    %edx
f0104d8a:	83 fa ff             	cmp    $0xffffffff,%edx
f0104d8d:	75 e6                	jne    f0104d75 <memcmp+0x13>
	}

	return 0;
f0104d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104d94:	5b                   	pop    %ebx
f0104d95:	c9                   	leave  
f0104d96:	c3                   	ret    

f0104d97 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0104d97:	55                   	push   %ebp
f0104d98:	89 e5                	mov    %esp,%ebp
f0104d9a:	8b 45 08             	mov    0x8(%ebp),%eax
f0104d9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0104da0:	89 c2                	mov    %eax,%edx
f0104da2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0104da5:	39 d0                	cmp    %edx,%eax
f0104da7:	73 09                	jae    f0104db2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0104da9:	38 08                	cmp    %cl,(%eax)
f0104dab:	74 05                	je     f0104db2 <memfind+0x1b>
f0104dad:	40                   	inc    %eax
f0104dae:	39 d0                	cmp    %edx,%eax
f0104db0:	72 f7                	jb     f0104da9 <memfind+0x12>
			break;
	return (void *) s;
}
f0104db2:	c9                   	leave  
f0104db3:	c3                   	ret    

f0104db4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0104db4:	55                   	push   %ebp
f0104db5:	89 e5                	mov    %esp,%ebp
f0104db7:	57                   	push   %edi
f0104db8:	56                   	push   %esi
f0104db9:	53                   	push   %ebx
f0104dba:	8b 55 08             	mov    0x8(%ebp),%edx
f0104dbd:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104dc0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
f0104dc3:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
f0104dc8:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
f0104dcd:	80 3a 20             	cmpb   $0x20,(%edx)
f0104dd0:	74 05                	je     f0104dd7 <strtol+0x23>
f0104dd2:	80 3a 09             	cmpb   $0x9,(%edx)
f0104dd5:	75 0b                	jne    f0104de2 <strtol+0x2e>
f0104dd7:	42                   	inc    %edx
f0104dd8:	80 3a 20             	cmpb   $0x20,(%edx)
f0104ddb:	74 fa                	je     f0104dd7 <strtol+0x23>
f0104ddd:	80 3a 09             	cmpb   $0x9,(%edx)
f0104de0:	74 f5                	je     f0104dd7 <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
f0104de2:	80 3a 2b             	cmpb   $0x2b,(%edx)
f0104de5:	75 03                	jne    f0104dea <strtol+0x36>
		s++;
f0104de7:	42                   	inc    %edx
f0104de8:	eb 0b                	jmp    f0104df5 <strtol+0x41>
	else if (*s == '-')
f0104dea:	80 3a 2d             	cmpb   $0x2d,(%edx)
f0104ded:	75 06                	jne    f0104df5 <strtol+0x41>
		s++, neg = 1;
f0104def:	42                   	inc    %edx
f0104df0:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0104df5:	85 c9                	test   %ecx,%ecx
f0104df7:	74 05                	je     f0104dfe <strtol+0x4a>
f0104df9:	83 f9 10             	cmp    $0x10,%ecx
f0104dfc:	75 15                	jne    f0104e13 <strtol+0x5f>
f0104dfe:	80 3a 30             	cmpb   $0x30,(%edx)
f0104e01:	75 10                	jne    f0104e13 <strtol+0x5f>
f0104e03:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0104e07:	75 0a                	jne    f0104e13 <strtol+0x5f>
		s += 2, base = 16;
f0104e09:	83 c2 02             	add    $0x2,%edx
f0104e0c:	b9 10 00 00 00       	mov    $0x10,%ecx
f0104e11:	eb 14                	jmp    f0104e27 <strtol+0x73>
	else if (base == 0 && s[0] == '0')
f0104e13:	85 c9                	test   %ecx,%ecx
f0104e15:	75 10                	jne    f0104e27 <strtol+0x73>
f0104e17:	80 3a 30             	cmpb   $0x30,(%edx)
f0104e1a:	75 05                	jne    f0104e21 <strtol+0x6d>
		s++, base = 8;
f0104e1c:	42                   	inc    %edx
f0104e1d:	b1 08                	mov    $0x8,%cl
f0104e1f:	eb 06                	jmp    f0104e27 <strtol+0x73>
	else if (base == 0)
f0104e21:	85 c9                	test   %ecx,%ecx
f0104e23:	75 02                	jne    f0104e27 <strtol+0x73>
		base = 10;
f0104e25:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0104e27:	8a 02                	mov    (%edx),%al
f0104e29:	83 e8 30             	sub    $0x30,%eax
f0104e2c:	3c 09                	cmp    $0x9,%al
f0104e2e:	77 08                	ja     f0104e38 <strtol+0x84>
			dig = *s - '0';
f0104e30:	0f be 02             	movsbl (%edx),%eax
f0104e33:	83 e8 30             	sub    $0x30,%eax
f0104e36:	eb 20                	jmp    f0104e58 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
f0104e38:	8a 02                	mov    (%edx),%al
f0104e3a:	83 e8 61             	sub    $0x61,%eax
f0104e3d:	3c 19                	cmp    $0x19,%al
f0104e3f:	77 08                	ja     f0104e49 <strtol+0x95>
			dig = *s - 'a' + 10;
f0104e41:	0f be 02             	movsbl (%edx),%eax
f0104e44:	83 e8 57             	sub    $0x57,%eax
f0104e47:	eb 0f                	jmp    f0104e58 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
f0104e49:	8a 02                	mov    (%edx),%al
f0104e4b:	83 e8 41             	sub    $0x41,%eax
f0104e4e:	3c 19                	cmp    $0x19,%al
f0104e50:	77 12                	ja     f0104e64 <strtol+0xb0>
			dig = *s - 'A' + 10;
f0104e52:	0f be 02             	movsbl (%edx),%eax
f0104e55:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
f0104e58:	39 c8                	cmp    %ecx,%eax
f0104e5a:	7d 08                	jge    f0104e64 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
f0104e5c:	42                   	inc    %edx
f0104e5d:	0f af d9             	imul   %ecx,%ebx
f0104e60:	01 c3                	add    %eax,%ebx
f0104e62:	eb c3                	jmp    f0104e27 <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
f0104e64:	85 f6                	test   %esi,%esi
f0104e66:	74 02                	je     f0104e6a <strtol+0xb6>
		*endptr = (char *) s;
f0104e68:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
f0104e6a:	89 d8                	mov    %ebx,%eax
f0104e6c:	85 ff                	test   %edi,%edi
f0104e6e:	74 02                	je     f0104e72 <strtol+0xbe>
f0104e70:	f7 d8                	neg    %eax
}
f0104e72:	5b                   	pop    %ebx
f0104e73:	5e                   	pop    %esi
f0104e74:	5f                   	pop    %edi
f0104e75:	c9                   	leave  
f0104e76:	c3                   	ret    
	...

f0104e78 <pci_e100_attach>:
 * Attach the e100 device
 */
int
pci_e100_attach(struct pci_func *pcif)
{
f0104e78:	55                   	push   %ebp
f0104e79:	89 e5                	mov    %esp,%ebp
f0104e7b:	53                   	push   %ebx
f0104e7c:	83 ec 10             	sub    $0x10,%esp
f0104e7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pci_func_enable(pcif);
f0104e82:	53                   	push   %ebx
f0104e83:	e8 0f 0b 00 00       	call   f0105997 <pci_func_enable>
  reg_base = pcif->reg_base;
f0104e88:	8d 43 14             	lea    0x14(%ebx),%eax
f0104e8b:	a3 a4 68 32 f0       	mov    %eax,0xf03268a4
  reg_size = pcif->reg_size;
f0104e90:	8d 43 2c             	lea    0x2c(%ebx),%eax
f0104e93:	a3 a0 68 32 f0       	mov    %eax,0xf03268a0
  irq_line = pcif->irq_line;
f0104e98:	8a 43 44             	mov    0x44(%ebx),%al
f0104e9b:	a2 a8 68 32 f0       	mov    %al,0xf03268a8
  iobase = pcif->reg_base[1];
f0104ea0:	8b 43 18             	mov    0x18(%ebx),%eax
f0104ea3:	a3 00 8b 32 f0       	mov    %eax,0xf0328b00

  // DEBUG: Verify valid iobase:
  // cprintf("hihihi %08x\n", reg_base[1]);
  // outputted reg_base[1]: 0000c040

  sw_reset_e100(iobase);
f0104ea8:	89 04 24             	mov    %eax,(%esp)
f0104eab:	e8 19 00 00 00       	call   f0104ec9 <sw_reset_e100>

  init_cbl();
f0104eb0:	e8 32 00 00 00       	call   f0104ee7 <init_cbl>
  e100_transmit_nop();
f0104eb5:	e8 91 02 00 00       	call   f010514b <e100_transmit_nop>
  cu_start(); // only start once, because must determine that all previously blocks were completed...too consuming.
f0104eba:	e8 6b 04 00 00       	call   f010532a <cu_start>

  // Challenge: start these later
  //init_rfa();
  //ru_start();

  return 1;
}
f0104ebf:	b8 01 00 00 00       	mov    $0x1,%eax
f0104ec4:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0104ec7:	c9                   	leave  
f0104ec8:	c3                   	ret    

f0104ec9 <sw_reset_e100>:

/**
 * Initiates a reset of the device
 */
void sw_reset_e100(uint32_t base) {
f0104ec9:	55                   	push   %ebp
f0104eca:	89 e5                	mov    %esp,%ebp
}

static __inline void
outl(int port, uint32_t data)
{
f0104ecc:	8b 55 08             	mov    0x8(%ebp),%edx
f0104ecf:	83 c2 08             	add    $0x8,%edx
f0104ed2:	b8 00 00 00 00       	mov    $0x0,%eax
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0104ed7:	ef                   	out    %eax,(%dx)
f0104ed8:	ba 84 00 00 00       	mov    $0x84,%edx
f0104edd:	ec                   	in     (%dx),%al
f0104ede:	ec                   	in     (%dx),%al
f0104edf:	ec                   	in     (%dx),%al
f0104ee0:	ec                   	in     (%dx),%al
f0104ee1:	ec                   	in     (%dx),%al
f0104ee2:	ec                   	in     (%dx),%al
f0104ee3:	ec                   	in     (%dx),%al
f0104ee4:	ec                   	in     (%dx),%al
  outl(base + CSR_PORT_OFFSET, 0x00000000); // write to the port

  // delay for 10us
  // see Intel manual 6.3.3.1
  inb(0x84);
  inb(0x84);
  inb(0x84);
  inb(0x84);
  inb(0x84);
  inb(0x84);
  inb(0x84);
  inb(0x84);
}
f0104ee5:	c9                   	leave  
f0104ee6:	c3                   	ret    

f0104ee7 <init_cbl>:



/**
 * Builds the CBL
 */
void init_cbl(void) {
f0104ee7:	55                   	push   %ebp
f0104ee8:	89 e5                	mov    %esp,%ebp
f0104eea:	83 ec 0c             	sub    $0xc,%esp
  int tidx;
  int neighbor = 0;

  cbl_to_process = 0;
f0104eed:	c7 05 f4 78 32 f0 00 	movl   $0x0,0xf03278f4
f0104ef4:	00 00 00 
  cbl_next_free = 0;
f0104ef7:	c7 05 80 68 2f f0 00 	movl   $0x0,0xf02f6880
f0104efe:	00 00 00 

  // clear all the memory
  memset(&cu_cbl, 0, DMA_CU_MAXCB * sizeof(struct tcb));
f0104f01:	68 00 10 00 00       	push   $0x1000
f0104f06:	6a 00                	push   $0x0
f0104f08:	68 c0 68 32 f0       	push   $0xf03268c0
f0104f0d:	e8 7f fd ff ff       	call   f0104c91 <memset>

  // loop through array and set the links
  for (tidx = 0; tidx<DMA_CU_MAXCB; tidx++) {
f0104f12:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104f17:	83 c4 10             	add    $0x10,%esp
    if (tidx == 0) {
      neighbor = DMA_CU_MAXCB - 1;
f0104f1a:	b8 7f 00 00 00       	mov    $0x7f,%eax
f0104f1f:	85 c9                	test   %ecx,%ecx
f0104f21:	74 03                	je     f0104f26 <init_cbl+0x3f>
    } else {
      neighbor = tidx - 1;
f0104f23:	8d 41 ff             	lea    0xffffffff(%ecx),%eax
    }
    cu_cbl[neighbor].cb_header.link = PADDR((uint32_t) &cu_cbl[tidx]);
f0104f26:	89 c2                	mov    %eax,%edx
f0104f28:	c1 e2 05             	shl    $0x5,%edx
f0104f2b:	89 c8                	mov    %ecx,%eax
f0104f2d:	c1 e0 05             	shl    $0x5,%eax
f0104f30:	05 c0 68 32 f0       	add    $0xf03268c0,%eax
f0104f35:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104f3a:	77 12                	ja     f0104f4e <init_cbl+0x67>
f0104f3c:	50                   	push   %eax
f0104f3d:	68 54 62 10 f0       	push   $0xf0106254
f0104f42:	6a 65                	push   $0x65
f0104f44:	68 e3 72 10 f0       	push   $0xf01072e3
f0104f49:	e8 9b b1 ff ff       	call   f01000e9 <_panic>
f0104f4e:	05 00 00 00 10       	add    $0x10000000,%eax
f0104f53:	89 82 c4 68 32 f0    	mov    %eax,0xf03268c4(%edx)
    cu_cbl[tidx].cb_header.status = CB_STATUS_PROCESSED;
f0104f59:	89 c8                	mov    %ecx,%eax
f0104f5b:	c1 e0 05             	shl    $0x5,%eax
f0104f5e:	66 c7 80 c0 68 32 f0 	movw   $0x8000,0xf03268c0(%eax)
f0104f65:	00 80 

    // These values are always fixed for our purposes.  See page 92 of manual.
    // http://pdos.csail.mit.edu/6.828/2009/readings/8255X_OpenSDM.pdf
    cu_cbl[tidx].cb_header.cmd = 0; // change to 4 when ready to transmit
f0104f67:	66 c7 80 c2 68 32 f0 	movw   $0x0,0xf03268c2(%eax)
f0104f6e:	00 00 
    //cu_cbl[tidx].tbd_array_addr = 0xFFFFFFFF;
    //cu_cbl[tidx].tbd_count = 0;
    cu_cbl[tidx].thrs = 0xE0;
f0104f70:	c6 80 ce 68 32 f0 e0 	movb   $0xe0,0xf03268ce(%eax)

    // Challenge
    cu_cbl[tidx].tbd_array_addr = PADDR(&cu_cbl[tidx].tbd);
f0104f77:	89 c2                	mov    %eax,%edx
f0104f79:	8d 80 d0 68 32 f0    	lea    0xf03268d0(%eax),%eax
f0104f7f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104f84:	77 12                	ja     f0104f98 <init_cbl+0xb1>
f0104f86:	50                   	push   %eax
f0104f87:	68 54 62 10 f0       	push   $0xf0106254
f0104f8c:	6a 70                	push   $0x70
f0104f8e:	68 e3 72 10 f0       	push   $0xf01072e3
f0104f93:	e8 51 b1 ff ff       	call   f01000e9 <_panic>
f0104f98:	05 00 00 00 10       	add    $0x10000000,%eax
f0104f9d:	89 82 c8 68 32 f0    	mov    %eax,0xf03268c8(%edx)
    cu_cbl[tidx].tbd_count = 1; // 1:1 mapping
f0104fa3:	89 c8                	mov    %ecx,%eax
f0104fa5:	c1 e0 05             	shl    $0x5,%eax
f0104fa8:	c6 80 cf 68 32 f0 01 	movb   $0x1,0xf03268cf(%eax)
f0104faf:	41                   	inc    %ecx
f0104fb0:	83 f9 7f             	cmp    $0x7f,%ecx
f0104fb3:	0f 8e 61 ff ff ff    	jle    f0104f1a <init_cbl+0x33>
  }
}
f0104fb9:	c9                   	leave  
f0104fba:	c3                   	ret    

f0104fbb <init_rfa>:

/**
 * Builds the RFA
 */
void init_rfa(void) {
f0104fbb:	55                   	push   %ebp
f0104fbc:	89 e5                	mov    %esp,%ebp
f0104fbe:	57                   	push   %edi
f0104fbf:	56                   	push   %esi
f0104fc0:	53                   	push   %ebx
f0104fc1:	83 ec 10             	sub    $0x10,%esp
  int tidx;
  int neighbor = 0;

  rfd_to_process = 0;
f0104fc4:	c7 05 ac 68 32 f0 00 	movl   $0x0,0xf03268ac
f0104fcb:	00 00 00 
  //cbl_to_process = 0;
  //cbl_next_free = 0;

  // clear all the memory
  memset(&ru_rfa, 0, DMA_RU_SIZE * sizeof(struct rfd));
f0104fce:	68 00 12 00 00       	push   $0x1200
f0104fd3:	6a 00                	push   $0x0
f0104fd5:	68 a0 68 2f f0       	push   $0xf02f68a0
f0104fda:	e8 b2 fc ff ff       	call   f0104c91 <memset>

  // Challenge
  memset(rbds, 0, DMA_RU_SIZE * sizeof(struct rbd));
f0104fdf:	83 c4 0c             	add    $0xc,%esp
f0104fe2:	6a 30                	push   $0x30
f0104fe4:	6a 00                	push   $0x0
f0104fe6:	68 c0 78 32 f0       	push   $0xf03278c0
f0104feb:	e8 a1 fc ff ff       	call   f0104c91 <memset>

  // loop through array and set the links
  for (tidx = 0; tidx<DMA_RU_SIZE; tidx++) {
f0104ff0:	be 00 00 00 00       	mov    $0x0,%esi
f0104ff5:	83 c4 10             	add    $0x10,%esp
    //cprintf("********* dma item: %d\n", tidx);
    if (tidx == 0) {
      neighbor = DMA_RU_SIZE - 1;
f0104ff8:	b8 02 00 00 00       	mov    $0x2,%eax
f0104ffd:	85 f6                	test   %esi,%esi
f0104fff:	74 03                	je     f0105004 <init_rfa+0x49>
    } else {
      neighbor = tidx - 1;
f0105001:	8d 46 ff             	lea    0xffffffff(%esi),%eax
    }
    ru_rfa[neighbor].header.link = PADDR((uint32_t) &ru_rfa[tidx]);
f0105004:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105007:	89 c2                	mov    %eax,%edx
f0105009:	c1 e2 09             	shl    $0x9,%edx
f010500c:	8d 04 76             	lea    (%esi,%esi,2),%eax
f010500f:	c1 e0 09             	shl    $0x9,%eax
f0105012:	05 a0 68 2f f0       	add    $0xf02f68a0,%eax
f0105017:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010501c:	77 15                	ja     f0105033 <init_rfa+0x78>
f010501e:	50                   	push   %eax
f010501f:	68 54 62 10 f0       	push   $0xf0106254
f0105024:	68 8e 00 00 00       	push   $0x8e
f0105029:	68 e3 72 10 f0       	push   $0xf01072e3
f010502e:	e8 b6 b0 ff ff       	call   f01000e9 <_panic>
f0105033:	05 00 00 00 10       	add    $0x10000000,%eax
f0105038:	89 82 a4 68 2f f0    	mov    %eax,0xf02f68a4(%edx)
    //ru_rfa[tidx].size = 1518;

    // Challenge
    ru_rfa[tidx].size = 0;
f010503e:	8d 04 76             	lea    (%esi,%esi,2),%eax
f0105041:	c1 e0 09             	shl    $0x9,%eax
f0105044:	66 c7 80 ae 68 2f f0 	movw   $0x0,0xf02f68ae(%eax)
f010504b:	00 00 
    ru_rfa[tidx].header.cmd |= TCBCOMMAND_SF;
f010504d:	66 83 88 a2 68 2f f0 	orw    $0x8,0xf02f68a2(%eax)
f0105054:	08 
    ru_rfa[tidx].reserved = PADDR(&rbds[tidx]);
f0105055:	89 c2                	mov    %eax,%edx
f0105057:	89 f0                	mov    %esi,%eax
f0105059:	c1 e0 04             	shl    $0x4,%eax
f010505c:	05 c0 78 32 f0       	add    $0xf03278c0,%eax
f0105061:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0105066:	77 15                	ja     f010507d <init_rfa+0xc2>
f0105068:	50                   	push   %eax
f0105069:	68 54 62 10 f0       	push   $0xf0106254
f010506e:	68 94 00 00 00       	push   $0x94
f0105073:	68 e3 72 10 f0       	push   $0xf01072e3
f0105078:	e8 6c b0 ff ff       	call   f01000e9 <_panic>
f010507d:	05 00 00 00 10       	add    $0x10000000,%eax
f0105082:	89 82 a8 68 2f f0    	mov    %eax,0xf02f68a8(%edx)
    rbds[tidx].count = MAX_PKT_SIZE;
f0105088:	89 f0                	mov    %esi,%eax
f010508a:	c1 e0 04             	shl    $0x4,%eax
f010508d:	c7 80 c0 78 32 f0 ee 	movl   $0x5ee,0xf03278c0(%eax)
f0105094:	05 00 00 
    rbds[tidx].link = PADDR(&rbds[(tidx+1)%DMA_RU_SIZE]);
f0105097:	89 c3                	mov    %eax,%ebx
f0105099:	8d 4e 01             	lea    0x1(%esi),%ecx
f010509c:	ba 03 00 00 00       	mov    $0x3,%edx
f01050a1:	89 c8                	mov    %ecx,%eax
f01050a3:	89 d7                	mov    %edx,%edi
f01050a5:	99                   	cltd   
f01050a6:	f7 ff                	idiv   %edi
f01050a8:	c1 e2 04             	shl    $0x4,%edx
f01050ab:	8d 8a c0 78 32 f0    	lea    0xf03278c0(%edx),%ecx
f01050b1:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01050b7:	77 15                	ja     f01050ce <init_rfa+0x113>
f01050b9:	51                   	push   %ecx
f01050ba:	68 54 62 10 f0       	push   $0xf0106254
f01050bf:	68 96 00 00 00       	push   $0x96
f01050c4:	68 e3 72 10 f0       	push   $0xf01072e3
f01050c9:	e8 1b b0 ff ff       	call   f01000e9 <_panic>
f01050ce:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
f01050d4:	89 83 c4 78 32 f0    	mov    %eax,0xf03278c4(%ebx)
    rbds[tidx].size = MAX_PKT_SIZE;
f01050da:	89 f3                	mov    %esi,%ebx
f01050dc:	c1 e3 04             	shl    $0x4,%ebx
f01050df:	c7 83 cc 78 32 f0 ee 	movl   $0x5ee,0xf03278cc(%ebx)
f01050e6:	05 00 00 

    struct Page *buffer_page = page_lookup(curenv->env_pgdir, buffer_zero + (tidx * PGSIZE), NULL);
f01050e9:	83 ec 04             	sub    $0x4,%esp
f01050ec:	6a 00                	push   $0x0
f01050ee:	89 f0                	mov    %esi,%eax
f01050f0:	c1 e0 0c             	shl    $0xc,%eax
f01050f3:	03 05 f0 78 32 f0    	add    0xf03278f0,%eax
f01050f9:	50                   	push   %eax
f01050fa:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f01050ff:	ff 70 5c             	pushl  0x5c(%eax)
f0105102:	e8 ae c9 ff ff       	call   f0101ab5 <page_lookup>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0105107:	83 c4 10             	add    $0x10,%esp
f010510a:	2b 05 7c 68 2f f0    	sub    0xf02f687c,%eax
f0105110:	c1 f8 02             	sar    $0x2,%eax
f0105113:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0105116:	8d 14 90             	lea    (%eax,%edx,4),%edx
f0105119:	8d 14 90             	lea    (%eax,%edx,4),%edx
f010511c:	89 d1                	mov    %edx,%ecx
f010511e:	c1 e1 08             	shl    $0x8,%ecx
f0105121:	01 ca                	add    %ecx,%edx
f0105123:	89 d1                	mov    %edx,%ecx
f0105125:	c1 e1 10             	shl    $0x10,%ecx
f0105128:	01 ca                	add    %ecx,%edx
f010512a:	8d 14 50             	lea    (%eax,%edx,2),%edx
f010512d:	c1 e2 0c             	shl    $0xc,%edx
f0105130:	83 c2 04             	add    $0x4,%edx
f0105133:	89 93 c8 78 32 f0    	mov    %edx,0xf03278c8(%ebx)
f0105139:	46                   	inc    %esi
f010513a:	83 fe 02             	cmp    $0x2,%esi
f010513d:	0f 8e b5 fe ff ff    	jle    f0104ff8 <init_rfa+0x3d>
    rbds[tidx].buffer_address = page2pa(buffer_page) + sizeof(int);
    //ru_rfa[tidx].header.cmd = 0x8000;
    //ru_rfa[tidx].reserved = 0xffffffff;
    //ru_rfa[tidx].header.status = CB_STATUS_PROCESSED;

    // These values are always fixed for our purposes.  See page 92 of manual.
    // http://pdos.csail.mit.edu/6.828/2009/readings/8255X_OpenSDM.pdf
    //cu_cbl[tidx].cb_header.cmd = 0; // change to 4 when ready to transmit
    //cu_cbl[tidx].tbd_array_addr = 0xFFFFFFFF;
    //cu_cbl[tidx].tbd_count = 0;
    //cu_cbl[tidx].thrs = 0xE0;

  }
}
f0105143:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0105146:	5b                   	pop    %ebx
f0105147:	5e                   	pop    %esi
f0105148:	5f                   	pop    %edi
f0105149:	c9                   	leave  
f010514a:	c3                   	ret    

f010514b <e100_transmit_nop>:

void e100_transmit_nop(void) {
f010514b:	55                   	push   %ebp
f010514c:	89 e5                	mov    %esp,%ebp
f010514e:	83 ec 10             	sub    $0x10,%esp
  // Set a NOP
  cprintf("nop at cbl index: %08x\n", cbl_next_free);
f0105151:	ff 35 80 68 2f f0    	pushl  0xf02f6880
f0105157:	68 ef 72 10 f0       	push   $0xf01072ef
f010515c:	e8 61 df ff ff       	call   f01030c2 <cprintf>
  cu_cbl[cbl_next_free].cb_header.status = 0;
f0105161:	8b 0d 80 68 2f f0    	mov    0xf02f6880,%ecx
f0105167:	89 c8                	mov    %ecx,%eax
f0105169:	c1 e0 05             	shl    $0x5,%eax
f010516c:	66 c7 80 c0 68 32 f0 	movw   $0x0,0xf03268c0(%eax)
f0105173:	00 00 
  cu_cbl[cbl_next_free].cb_header.cmd = TCB_NOP | TCB_S;
f0105175:	66 c7 80 c2 68 32 f0 	movw   $0x4000,0xf03268c2(%eax)
f010517c:	00 40 
  cbl_next_free = (cbl_next_free + 1) % DMA_CU_MAXCB; // should be = 1
f010517e:	8d 51 01             	lea    0x1(%ecx),%edx
f0105181:	89 d0                	mov    %edx,%eax
f0105183:	85 d2                	test   %edx,%edx
f0105185:	79 06                	jns    f010518d <e100_transmit_nop+0x42>
f0105187:	8d 81 80 00 00 00    	lea    0x80(%ecx),%eax
f010518d:	83 e0 80             	and    $0xffffff80,%eax
f0105190:	29 c2                	sub    %eax,%edx
f0105192:	89 15 80 68 2f f0    	mov    %edx,0xf02f6880
  cprintf("cbl_to_process now moved to: %08x\n", cbl_next_free);
f0105198:	83 c4 08             	add    $0x8,%esp
f010519b:	52                   	push   %edx
f010519c:	68 c0 72 10 f0       	push   $0xf01072c0
f01051a1:	e8 1c df ff ff       	call   f01030c2 <cprintf>
}
f01051a6:	c9                   	leave  
f01051a7:	c3                   	ret    

f01051a8 <e100_transmit_packet>:

/**
 * Transmit a packet
Modify this for the zero-copy write challenge question.  No longer perform a memmove, and instead just shove in the buffer.
 */
int e100_transmit_packet(char* packet, int pktsize) {
f01051a8:	55                   	push   %ebp
f01051a9:	89 e5                	mov    %esp,%ebp
f01051ab:	56                   	push   %esi
f01051ac:	53                   	push   %ebx
  int tcb_empty;
  char scb_issued;
  int cbl_prev = cbl_next_free;
f01051ad:	8b 1d 80 68 2f f0    	mov    0xf02f6880,%ebx

  // Step 0: Move the 'head' to the next unprocessed packet
  int start = cbl_to_process;
f01051b3:	8b 35 f4 78 32 f0    	mov    0xf03278f4,%esi
  struct Page *page_to_free;
  while ((cu_cbl[cbl_to_process].cb_header.status == CB_STATUS_PROCESSED) && (cbl_to_process != cbl_next_free)) {

    // Challenge: free pages that you see have completed
    // Don't free here.  sys_ipc_ allocated it.
    //page_to_free = pa2page(cu_cbl[cbl_to_process].tbd_array_addr[cbl_to_process].buffer_address);
    //sys_page_unmap(&page_to_free);

    // shift the cbl_to_process index
    cbl_to_process = (cbl_to_process + 1) % DMA_CU_MAXCB;
    if (cbl_to_process == start) {
      // back to where we started.
      // everything is empty, so leave pointer
      // where it was.
      break;
f01051b9:	89 f0                	mov    %esi,%eax
f01051bb:	c1 e0 05             	shl    $0x5,%eax
f01051be:	66 8b 80 c0 68 32 f0 	mov    0xf03268c0(%eax),%ax
f01051c5:	66 3d 00 80          	cmp    $0x8000,%ax
f01051c9:	75 3c                	jne    f0105207 <e100_transmit_packet+0x5f>
f01051cb:	39 de                	cmp    %ebx,%esi
f01051cd:	74 38                	je     f0105207 <e100_transmit_packet+0x5f>
f01051cf:	89 f1                	mov    %esi,%ecx
f01051d1:	8d 51 01             	lea    0x1(%ecx),%edx
f01051d4:	89 d0                	mov    %edx,%eax
f01051d6:	85 d2                	test   %edx,%edx
f01051d8:	79 06                	jns    f01051e0 <e100_transmit_packet+0x38>
f01051da:	8d 81 80 00 00 00    	lea    0x80(%ecx),%eax
f01051e0:	83 e0 80             	and    $0xffffff80,%eax
f01051e3:	29 c2                	sub    %eax,%edx
f01051e5:	89 d1                	mov    %edx,%ecx
f01051e7:	39 f2                	cmp    %esi,%edx
f01051e9:	74 16                	je     f0105201 <e100_transmit_packet+0x59>
f01051eb:	89 d0                	mov    %edx,%eax
f01051ed:	c1 e0 05             	shl    $0x5,%eax
f01051f0:	66 8b 80 c0 68 32 f0 	mov    0xf03268c0(%eax),%ax
f01051f7:	66 3d 00 80          	cmp    $0x8000,%ax
f01051fb:	75 04                	jne    f0105201 <e100_transmit_packet+0x59>
f01051fd:	39 da                	cmp    %ebx,%edx
f01051ff:	75 d0                	jne    f01051d1 <e100_transmit_packet+0x29>
f0105201:	89 0d f4 78 32 f0    	mov    %ecx,0xf03278f4
    }
  }
  cprintf("transmit at cbl index: %08x\n", cbl_next_free);
f0105207:	83 ec 08             	sub    $0x8,%esp
f010520a:	ff 35 80 68 2f f0    	pushl  0xf02f6880
f0105210:	68 07 73 10 f0       	push   $0xf0107307
f0105215:	e8 a8 de ff ff       	call   f01030c2 <cprintf>

  // Step 1: 
  // Check if there is room to copy in the packet 
  if (!(cu_cbl[cbl_next_free].cb_header.status & CB_STATUS_PROCESSED)) {
f010521a:	a1 80 68 2f f0       	mov    0xf02f6880,%eax
f010521f:	c1 e0 05             	shl    $0x5,%eax
f0105222:	83 c4 10             	add    $0x10,%esp
f0105225:	66 8b 80 c0 68 32 f0 	mov    0xf03268c0(%eax),%ax
    // no memory because you've circled back on the DMA ring
    return -E100_NO_MEM;
f010522c:	ba 9c ff ff ff       	mov    $0xffffff9c,%edx
f0105231:	66 85 c0             	test   %ax,%ax
f0105234:	0f 89 e7 00 00 00    	jns    f0105321 <e100_transmit_packet+0x179>
  }

  cprintf("prior to writing memory");
f010523a:	83 ec 0c             	sub    $0xc,%esp
f010523d:	68 24 73 10 f0       	push   $0xf0107324
f0105242:	e8 7b de ff ff       	call   f01030c2 <cprintf>

  // Step 2:
  // Write the next TCB
  cu_cbl[cbl_next_free].cb_header.status = 0; // reset the CB's status
f0105247:	8b 1d 80 68 2f f0    	mov    0xf02f6880,%ebx
f010524d:	c1 e3 05             	shl    $0x5,%ebx
f0105250:	66 c7 83 c0 68 32 f0 	movw   $0x0,0xf03268c0(%ebx)
f0105257:	00 00 
  //cu_cbl[cbl_next_free].cb_header.cmd = 0x4 | TCB_S; // transmit
  //cu_cbl[cbl_next_free].tcb_byte_count = pktsize;
  //memmove((void *)cu_cbl[cbl_next_free].data, (void *)packet, pktsize);

  // Challenge:
  cu_cbl[cbl_next_free].tcb_byte_count = 0;
f0105259:	66 c7 83 cc 68 32 f0 	movw   $0x0,0xf03268cc(%ebx)
f0105260:	00 00 
  cu_cbl[cbl_next_free].cb_header.cmd = TCBCOMMAND_TRANSMIT | TCB_S | TCBCOMMAND_SF;
f0105262:	66 c7 83 c2 68 32 f0 	movw   $0x400c,0xf03268c2(%ebx)
f0105269:	0c 40 
  cu_cbl[cbl_next_free].tbd.buffer_address = page2pa(page_lookup(curenv->env_pgdir, (void *)packet, 0)) + sizeof(int); // plus sizeof(int) because u need to avoid the packet size at the front
f010526b:	81 c3 c0 68 32 f0    	add    $0xf03268c0,%ebx
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0105271:	83 c4 0c             	add    $0xc,%esp
f0105274:	6a 00                	push   $0x0
f0105276:	ff 75 08             	pushl  0x8(%ebp)
f0105279:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f010527e:	ff 70 5c             	pushl  0x5c(%eax)
f0105281:	e8 2f c8 ff ff       	call   f0101ab5 <page_lookup>
f0105286:	83 c4 10             	add    $0x10,%esp
f0105289:	2b 05 7c 68 2f f0    	sub    0xf02f687c,%eax
f010528f:	c1 f8 02             	sar    $0x2,%eax
f0105292:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0105295:	8d 14 90             	lea    (%eax,%edx,4),%edx
f0105298:	8d 14 90             	lea    (%eax,%edx,4),%edx
f010529b:	89 d1                	mov    %edx,%ecx
f010529d:	c1 e1 08             	shl    $0x8,%ecx
f01052a0:	01 ca                	add    %ecx,%edx
f01052a2:	89 d1                	mov    %edx,%ecx
f01052a4:	c1 e1 10             	shl    $0x10,%ecx
f01052a7:	01 ca                	add    %ecx,%edx
f01052a9:	8d 14 50             	lea    (%eax,%edx,2),%edx
f01052ac:	c1 e2 0c             	shl    $0xc,%edx
f01052af:	83 c2 04             	add    $0x4,%edx
f01052b2:	89 53 10             	mov    %edx,0x10(%ebx)
  cu_cbl[cbl_next_free].tbd.buffer_size = pktsize;
f01052b5:	a1 80 68 2f f0       	mov    0xf02f6880,%eax
f01052ba:	c1 e0 05             	shl    $0x5,%eax
f01052bd:	8b 55 0c             	mov    0xc(%ebp),%edx
f01052c0:	89 90 d4 68 32 f0    	mov    %edx,0xf03268d4(%eax)

  // Step 3:
  // Set the suspend bit
  // Done in previous step
  //cu_cbl[cbl_next_free].cb_header.cmd |= TCB_S;
  
  // Step 4:
  // Clear the suspend bit of the TCB in the list (no longer last)
  if (cbl_next_free == 0) cbl_prev = DMA_CU_MAXCB - 1;
f01052c6:	bb 7f 00 00 00       	mov    $0x7f,%ebx
f01052cb:	83 3d 80 68 2f f0 00 	cmpl   $0x0,0xf02f6880
f01052d2:	74 07                	je     f01052db <e100_transmit_packet+0x133>
  else {
    cbl_prev = cbl_next_free - 1;
f01052d4:	8b 1d 80 68 2f f0    	mov    0xf02f6880,%ebx
f01052da:	4b                   	dec    %ebx
  }
  cprintf("cbl_prev: %08x", cbl_prev);
f01052db:	83 ec 08             	sub    $0x8,%esp
f01052de:	53                   	push   %ebx
f01052df:	68 3c 73 10 f0       	push   $0xf010733c
f01052e4:	e8 d9 dd ff ff       	call   f01030c2 <cprintf>
  cu_cbl[cbl_prev].cb_header.cmd &= ~TCB_S;
f01052e9:	89 d8                	mov    %ebx,%eax
f01052eb:	c1 e0 05             	shl    $0x5,%eax
f01052ee:	66 81 a0 c2 68 32 f0 	andw   $0xbfff,0xf03268c2(%eax)
f01052f5:	ff bf 

  // Move the next_free index
  cbl_next_free = (cbl_next_free + 1) % DMA_CU_MAXCB;
f01052f7:	8b 0d 80 68 2f f0    	mov    0xf02f6880,%ecx
f01052fd:	8d 51 01             	lea    0x1(%ecx),%edx
f0105300:	89 d0                	mov    %edx,%eax
f0105302:	85 d2                	test   %edx,%edx
f0105304:	79 06                	jns    f010530c <e100_transmit_packet+0x164>
f0105306:	8d 81 80 00 00 00    	lea    0x80(%ecx),%eax
f010530c:	83 e0 80             	and    $0xffffff80,%eax
f010530f:	29 c2                	sub    %eax,%edx
f0105311:	89 15 80 68 2f f0    	mov    %edx,0xf02f6880

  cu_resume();
f0105317:	e8 f2 00 00 00       	call   f010540e <cu_resume>
  //cu_start();
  return 0;
f010531c:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0105321:	89 d0                	mov    %edx,%eax
f0105323:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0105326:	5b                   	pop    %ebx
f0105327:	5e                   	pop    %esi
f0105328:	c9                   	leave  
f0105329:	c3                   	ret    

f010532a <cu_start>:


/*
int e100_transmit_packet(char* packet, int pktsize) {
  int tcb_empty;
  char scb_issued;
  int cbl_prev = cbl_next_free;

  // Step 0: Move the 'head' to the next unprocessed packet
  int start = cbl_to_process;
  while ((cu_cbl[cbl_to_process].cb_header.status == CB_STATUS_PROCESSED) && (cbl_to_process != cbl_next_free)) {
    // shift the cbl_to_process index
    cbl_to_process = (cbl_to_process + 1) % DMA_CU_MAXCB;
    if (cbl_to_process == start) {
      // back to where we started.
      // everything is empty, so leave pointer
      // where it was.
      break;
    }
  }
  cprintf("transmit at cbl index: %08x\n", cbl_next_free);

  // Step 1: 
  // Check if there is room to copy in the packet 
  if (!(cu_cbl[cbl_next_free].cb_header.status & CB_STATUS_PROCESSED)) {
    // no memory because you've circled back on the DMA ring
    return -E100_NO_MEM;
  }

  cprintf("prior to writing memory");

  // Step 2:
  // Write the next TCB
  cu_cbl[cbl_next_free].cb_header.status = 0; // reset the CB's status
  cu_cbl[cbl_next_free].cb_header.cmd = 0x4 | TCB_S; // transmit
  cu_cbl[cbl_next_free].tcb_byte_count = pktsize;
  memmove((void *)cu_cbl[cbl_next_free].data, (void *)packet, pktsize);

  // Link the previous TCB to this one if the head is not equal to this
  //if (cbl_to_process != cbl_next_free) {
  //  if (cbl_next_free == 0) cbl_prev = DMA_CU_MAXCB - 1;
  //  else {
  //    cbl_prev = cbl_next_free - 1;
  //  }
  //  cprintf("SET LINK: %08x\n", PADDR((uint32_t)&cu_cbl[cbl_next_free]));
  //  cu_cbl[cbl_prev].cb_header.link = PADDR((uint32_t)&cu_cbl[cbl_next_free]);
  //}
  //cprintf("cbl_to_process %08x\n", cbl_to_process);
  //cprintf("cbl_next_free %08x\n", cbl_next_free);
  //cprintf("cbl_to_process link: %08x\n", cu_cbl[cbl_next_free].cb_header.link);

  // Step 3:
  // Set the suspend bit
  cu_cbl[cbl_next_free].cb_header.cmd |= TCB_S;
  
  // Step 4:
  // Clear the suspend bit of the TCB in the list (no longer last)
  if (cbl_next_free == 0) cbl_prev = DMA_CU_MAXCB - 1;
  else {
    cbl_prev = cbl_next_free - 1;
  }
  cprintf("cbl_prev: %08x", cbl_prev);
  cu_cbl[cbl_prev].cb_header.cmd &= ~TCB_S;

  // Move the next_free index
  cbl_next_free = (cbl_next_free + 1) % DMA_CU_MAXCB;

  cu_resume();
  //cu_start();
  return 0;
}
*/

/**
 * Start the CU.  Only do this if the CU is
 * idle or suspended
 */
void cu_start(void) {
f010532a:	55                   	push   %ebp
f010532b:	89 e5                	mov    %esp,%ebp
f010532d:	83 ec 14             	sub    $0x14,%esp
  cprintf("Entering start CU\n");
f0105330:	68 4b 73 10 f0       	push   $0xf010734b
f0105335:	e8 88 dd ff ff       	call   f01030c2 <cprintf>
}

static __inline uint8_t
inb(int port)
{
f010533a:	83 c4 10             	add    $0x10,%esp
f010533d:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f0105343:	ec                   	in     (%dx),%al
  char cu_status;
  char scb_issued;

  // Start the CU if it's idle
  cu_status = inb(iobase + SCB_STATUS_OFFSET);

  // Step 4:
  // Restart CU if idle or suspended
  // Page 46, must do this check
  if ((cu_status>>4 == CU_STATUS_IDLE) || (cu_status>>4 == CU_STATUS_SUSPENDED)) {
f0105344:	c0 f8 04             	sar    $0x4,%al
f0105347:	3c 01                	cmp    $0x1,%al
f0105349:	77 72                	ja     f01053bd <cu_start+0x93>
    cprintf("Starting CU...\n");
f010534b:	83 ec 0c             	sub    $0xc,%esp
f010534e:	68 5e 73 10 f0       	push   $0xf010735e
f0105353:	e8 6a dd ff ff       	call   f01030c2 <cprintf>
}

static __inline void
outl(int port, uint32_t data)
{
f0105358:	83 c4 10             	add    $0x10,%esp
f010535b:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f0105361:	83 c2 04             	add    $0x4,%edx

    outl(iobase + SCB_GENERAL_POINTER_OFFSET, PADDR(&cu_cbl[cbl_to_process]));
f0105364:	a1 f4 78 32 f0       	mov    0xf03278f4,%eax
f0105369:	c1 e0 05             	shl    $0x5,%eax
f010536c:	05 c0 68 32 f0       	add    $0xf03268c0,%eax
f0105371:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0105376:	77 15                	ja     f010538d <cu_start+0x63>
f0105378:	50                   	push   %eax
f0105379:	68 54 62 10 f0       	push   $0xf0106254
f010537e:	68 56 01 00 00       	push   $0x156
f0105383:	68 e3 72 10 f0       	push   $0xf01072e3
f0105388:	e8 5c ad ff ff       	call   f01000e9 <_panic>
f010538d:	05 00 00 00 10       	add    $0x10000000,%eax

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0105392:	ef                   	out    %eax,(%dx)
f0105393:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f0105399:	83 c2 02             	add    $0x2,%edx
f010539c:	b0 10                	mov    $0x10,%al
f010539e:	ee                   	out    %al,(%dx)
f010539f:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f01053a5:	83 c2 02             	add    $0x2,%edx
f01053a8:	ec                   	in     (%dx),%al
    outb(iobase + SCB_COMMAND_OFFSET, CUC_CU_START);

    // wait until command goes through, pg. 45
    // The Command byte is cleared by the 8255x indicating command acceptance.
    do {
      scb_issued = inb(iobase + SCB_COMMAND_OFFSET);
    } while (scb_issued != 0);
f01053a9:	84 c0                	test   %al,%al
f01053ab:	75 fb                	jne    f01053a8 <cu_start+0x7e>

    cprintf("CU Started.\n");
f01053ad:	83 ec 0c             	sub    $0xc,%esp
f01053b0:	68 6e 73 10 f0       	push   $0xf010736e
f01053b5:	e8 08 dd ff ff       	call   f01030c2 <cprintf>
f01053ba:	83 c4 10             	add    $0x10,%esp
  }

}
f01053bd:	c9                   	leave  
f01053be:	c3                   	ret    

f01053bf <ru_start>:

void ru_start(void) {
f01053bf:	55                   	push   %ebp
f01053c0:	89 e5                	mov    %esp,%ebp
f01053c2:	83 ec 08             	sub    $0x8,%esp
}

static __inline void
outl(int port, uint32_t data)
{
f01053c5:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f01053cb:	83 c2 04             	add    $0x4,%edx
  outl(iobase + SCB_GENERAL_POINTER_OFFSET, PADDR(&ru_rfa[rfd_to_process]));
f01053ce:	a1 ac 68 32 f0       	mov    0xf03268ac,%eax
f01053d3:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01053d6:	c1 e0 09             	shl    $0x9,%eax
f01053d9:	05 a0 68 2f f0       	add    $0xf02f68a0,%eax
f01053de:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01053e3:	77 15                	ja     f01053fa <ru_start+0x3b>
f01053e5:	50                   	push   %eax
f01053e6:	68 54 62 10 f0       	push   $0xf0106254
f01053eb:	68 65 01 00 00       	push   $0x165
f01053f0:	68 e3 72 10 f0       	push   $0xf01072e3
f01053f5:	e8 ef ac ff ff       	call   f01000e9 <_panic>
f01053fa:	05 00 00 00 10       	add    $0x10000000,%eax

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f01053ff:	ef                   	out    %eax,(%dx)
f0105400:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f0105406:	83 c2 02             	add    $0x2,%edx
f0105409:	b0 01                	mov    $0x1,%al
f010540b:	ee                   	out    %al,(%dx)
  outb(iobase + SCB_COMMAND_OFFSET, RU_START);
}
f010540c:	c9                   	leave  
f010540d:	c3                   	ret    

f010540e <cu_resume>:

/**
 * Resume the CU, since it goes inactive after completing each operation.
 */
void cu_resume(void) {
f010540e:	55                   	push   %ebp
f010540f:	89 e5                	mov    %esp,%ebp
f0105411:	83 ec 14             	sub    $0x14,%esp
}

static __inline uint8_t
inb(int port)
{
f0105414:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010541a:	ec                   	in     (%dx),%al
  char cu_status;
  char scb_issued;

  // Start the CU if it's idle
  cu_status = inb(iobase + SCB_STATUS_OFFSET);

  cprintf("Resuming CU...\n");
f010541b:	68 7b 73 10 f0       	push   $0xf010737b
f0105420:	e8 9d dc ff ff       	call   f01030c2 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
f0105425:	83 c4 10             	add    $0x10,%esp
f0105428:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f010542e:	83 c2 02             	add    $0x2,%edx
f0105431:	b0 20                	mov    $0x20,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0105433:	ee                   	out    %al,(%dx)
f0105434:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f010543a:	83 c2 02             	add    $0x2,%edx
f010543d:	ec                   	in     (%dx),%al
  outb(iobase + SCB_COMMAND_OFFSET, CUC_CU_RESUME);

  // wait until command goes through, pg. 45
  // The Command byte is cleared by the 8255x indicating command acceptance.
  do {
    scb_issued = inb(iobase + SCB_COMMAND_OFFSET);
  } while (scb_issued != 0);
f010543e:	84 c0                	test   %al,%al
f0105440:	75 fb                	jne    f010543d <cu_resume+0x2f>

  cprintf("CU resumed.\n");
f0105442:	83 ec 0c             	sub    $0xc,%esp
f0105445:	68 8b 73 10 f0       	push   $0xf010738b
f010544a:	e8 73 dc ff ff       	call   f01030c2 <cprintf>
}
f010544f:	c9                   	leave  
f0105450:	c3                   	ret    

f0105451 <e100_receive_packet_zerocopy>:

int
e100_receive_packet_zerocopy(int* size) {
f0105451:	55                   	push   %ebp
f0105452:	89 e5                	mov    %esp,%ebp
f0105454:	53                   	push   %ebx
f0105455:	83 ec 04             	sub    $0x4,%esp
  if (ru_rfa[rfd_to_process].header.status & CB_STATUS_PROCESSED) {
f0105458:	8b 15 ac 68 32 f0    	mov    0xf03268ac,%edx
f010545e:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0105461:	c1 e0 09             	shl    $0x9,%eax
f0105464:	66 8b 80 a0 68 2f f0 	mov    0xf02f68a0(%eax),%ax
    //struct jif_pkt* packet;
    //packet = (struct jif_pkt*) (&buffer_zero + (rfd_to_process * PGSIZE));
    *size = rbds[rfd_to_process].count & 0x3fff;
    //*(int *)(&buffer_zero + (rfd_to_process * PGSIZE)) = size;
    ru_rfa[rfd_to_process].header.status = 0;
    rfd_to_process = (rfd_to_process + 1) % DMA_RU_SIZE;
    return 0;
  }
  return -1;
f010546b:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0105470:	66 85 c0             	test   %ax,%ax
f0105473:	79 45                	jns    f01054ba <e100_receive_packet_zerocopy+0x69>
f0105475:	89 d0                	mov    %edx,%eax
f0105477:	c1 e0 04             	shl    $0x4,%eax
f010547a:	8b 90 c0 78 32 f0    	mov    0xf03278c0(%eax),%edx
f0105480:	81 e2 ff 3f 00 00    	and    $0x3fff,%edx
f0105486:	8b 45 08             	mov    0x8(%ebp),%eax
f0105489:	89 10                	mov    %edx,(%eax)
f010548b:	8b 15 ac 68 32 f0    	mov    0xf03268ac,%edx
f0105491:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0105494:	c1 e0 09             	shl    $0x9,%eax
f0105497:	66 c7 80 a0 68 2f f0 	movw   $0x0,0xf02f68a0(%eax)
f010549e:	00 00 
f01054a0:	8d 4a 01             	lea    0x1(%edx),%ecx
f01054a3:	ba 03 00 00 00       	mov    $0x3,%edx
f01054a8:	89 c8                	mov    %ecx,%eax
f01054aa:	89 d3                	mov    %edx,%ebx
f01054ac:	99                   	cltd   
f01054ad:	f7 fb                	idiv   %ebx
f01054af:	89 15 ac 68 32 f0    	mov    %edx,0xf03268ac
f01054b5:	b9 00 00 00 00       	mov    $0x0,%ecx
}
f01054ba:	89 c8                	mov    %ecx,%eax
f01054bc:	83 c4 04             	add    $0x4,%esp
f01054bf:	5b                   	pop    %ebx
f01054c0:	c9                   	leave  
f01054c1:	c3                   	ret    

f01054c2 <e100_receive_packet>:

int
e100_receive_packet(char *packet, int *size) {
f01054c2:	55                   	push   %ebp
f01054c3:	89 e5                	mov    %esp,%ebp
f01054c5:	53                   	push   %ebx
f01054c6:	83 ec 04             	sub    $0x4,%esp

  uint32_t packet_paddr;
  void *packet_obj;

  if (ru_rfa[rfd_to_process].header.status & CB_STATUS_PROCESSED) {
f01054c9:	a1 ac 68 32 f0       	mov    0xf03268ac,%eax
f01054ce:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01054d1:	89 c2                	mov    %eax,%edx
f01054d3:	c1 e2 09             	shl    $0x9,%edx
f01054d6:	66 8b 82 a0 68 2f f0 	mov    0xf02f68a0(%edx),%ax
    *size = ru_rfa[rfd_to_process].count_f_eof & 0x3fff;
    memmove(packet, ru_rfa[rfd_to_process].data, *size);

    // Challenge
    // We want the equivalent of:
    //memmove(packet, KADDR(rbds[rfd_to_process].buffer_address), *size);
    // Turns out, very hard to do in exo kernel.
    ru_rfa[rfd_to_process].header.status = 0;
    rfd_to_process = (rfd_to_process + 1) % DMA_RU_SIZE;
    return 0;
  }
  return -1;
f01054dd:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01054e2:	66 85 c0             	test   %ax,%ax
f01054e5:	79 5e                	jns    f0105545 <e100_receive_packet+0x83>
f01054e7:	0f b7 92 ac 68 2f f0 	movzwl 0xf02f68ac(%edx),%edx
f01054ee:	81 e2 ff 3f 00 00    	and    $0x3fff,%edx
f01054f4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01054f7:	89 10                	mov    %edx,(%eax)
f01054f9:	83 ec 04             	sub    $0x4,%esp
f01054fc:	52                   	push   %edx
f01054fd:	a1 ac 68 32 f0       	mov    0xf03268ac,%eax
f0105502:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105505:	c1 e0 09             	shl    $0x9,%eax
f0105508:	05 b0 68 2f f0       	add    $0xf02f68b0,%eax
f010550d:	50                   	push   %eax
f010550e:	ff 75 08             	pushl  0x8(%ebp)
f0105511:	e8 ce f7 ff ff       	call   f0104ce4 <memmove>
f0105516:	8b 15 ac 68 32 f0    	mov    0xf03268ac,%edx
f010551c:	8d 04 52             	lea    (%edx,%edx,2),%eax
f010551f:	c1 e0 09             	shl    $0x9,%eax
f0105522:	66 c7 80 a0 68 2f f0 	movw   $0x0,0xf02f68a0(%eax)
f0105529:	00 00 
f010552b:	8d 4a 01             	lea    0x1(%edx),%ecx
f010552e:	ba 03 00 00 00       	mov    $0x3,%edx
f0105533:	89 c8                	mov    %ecx,%eax
f0105535:	89 d3                	mov    %edx,%ebx
f0105537:	99                   	cltd   
f0105538:	f7 fb                	idiv   %ebx
f010553a:	89 15 ac 68 32 f0    	mov    %edx,0xf03268ac
f0105540:	b9 00 00 00 00       	mov    $0x0,%ecx
}
f0105545:	89 c8                	mov    %ecx,%eax
f0105547:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f010554a:	c9                   	leave  
f010554b:	c3                   	ret    

f010554c <e100_map_receive_buffers>:

int
e100_map_receive_buffers(char *first_buffer) {
f010554c:	55                   	push   %ebp
f010554d:	89 e5                	mov    %esp,%ebp
f010554f:	83 ec 08             	sub    $0x8,%esp
  buffer_zero = first_buffer;
f0105552:	8b 45 08             	mov    0x8(%ebp),%eax
f0105555:	a3 f0 78 32 f0       	mov    %eax,0xf03278f0
  init_rfa();
f010555a:	e8 5c fa ff ff       	call   f0104fbb <init_rfa>
  ru_start();
f010555f:	e8 5b fe ff ff       	call   f01053bf <ru_start>
  return 0;
}
f0105564:	b8 00 00 00 00       	mov    $0x0,%eax
f0105569:	c9                   	leave  
f010556a:	c3                   	ret    
	...

f010556c <pci_conf1_set_addr>:
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f010556c:	55                   	push   %ebp
f010556d:	89 e5                	mov    %esp,%ebp
f010556f:	53                   	push   %ebx
f0105570:	83 ec 04             	sub    $0x4,%esp
f0105573:	8b 45 08             	mov    0x8(%ebp),%eax
f0105576:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105579:	8b 5d 10             	mov    0x10(%ebp),%ebx
f010557c:	8b 4d 14             	mov    0x14(%ebp),%ecx
	assert(bus < 256);
f010557f:	3d ff 00 00 00       	cmp    $0xff,%eax
f0105584:	76 16                	jbe    f010559c <pci_conf1_set_addr+0x30>
f0105586:	68 98 73 10 f0       	push   $0xf0107398
f010558b:	68 44 68 10 f0       	push   $0xf0106844
f0105590:	6a 2b                	push   $0x2b
f0105592:	68 a2 73 10 f0       	push   $0xf01073a2
f0105597:	e8 4d ab ff ff       	call   f01000e9 <_panic>
	assert(dev < 32);
f010559c:	83 fa 1f             	cmp    $0x1f,%edx
f010559f:	76 16                	jbe    f01055b7 <pci_conf1_set_addr+0x4b>
f01055a1:	68 ad 73 10 f0       	push   $0xf01073ad
f01055a6:	68 44 68 10 f0       	push   $0xf0106844
f01055ab:	6a 2c                	push   $0x2c
f01055ad:	68 a2 73 10 f0       	push   $0xf01073a2
f01055b2:	e8 32 ab ff ff       	call   f01000e9 <_panic>
	assert(func < 8);
f01055b7:	83 fb 07             	cmp    $0x7,%ebx
f01055ba:	76 16                	jbe    f01055d2 <pci_conf1_set_addr+0x66>
f01055bc:	68 b6 73 10 f0       	push   $0xf01073b6
f01055c1:	68 44 68 10 f0       	push   $0xf0106844
f01055c6:	6a 2d                	push   $0x2d
f01055c8:	68 a2 73 10 f0       	push   $0xf01073a2
f01055cd:	e8 17 ab ff ff       	call   f01000e9 <_panic>
	assert(offset < 256);
f01055d2:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
f01055d8:	76 16                	jbe    f01055f0 <pci_conf1_set_addr+0x84>
f01055da:	68 bf 73 10 f0       	push   $0xf01073bf
f01055df:	68 44 68 10 f0       	push   $0xf0106844
f01055e4:	6a 2e                	push   $0x2e
f01055e6:	68 a2 73 10 f0       	push   $0xf01073a2
f01055eb:	e8 f9 aa ff ff       	call   f01000e9 <_panic>
	assert((offset & 0x3) == 0);
f01055f0:	f6 c1 03             	test   $0x3,%cl
f01055f3:	74 16                	je     f010560b <pci_conf1_set_addr+0x9f>
f01055f5:	68 cc 73 10 f0       	push   $0xf01073cc
f01055fa:	68 44 68 10 f0       	push   $0xf0106844
f01055ff:	6a 2f                	push   $0x2f
f0105601:	68 a2 73 10 f0       	push   $0xf01073a2
f0105606:	e8 de aa ff ff       	call   f01000e9 <_panic>
	
	uint32_t v = (1 << 31) |		// config-space
f010560b:	c1 e0 10             	shl    $0x10,%eax
f010560e:	c1 e2 0b             	shl    $0xb,%edx
f0105611:	09 d0                	or     %edx,%eax
f0105613:	89 da                	mov    %ebx,%edx
f0105615:	c1 e2 08             	shl    $0x8,%edx
f0105618:	09 d0                	or     %edx,%eax
f010561a:	09 c8                	or     %ecx,%eax
}

static __inline void
outl(int port, uint32_t data)
{
f010561c:	8b 15 a0 56 12 f0    	mov    0xf01256a0,%edx
f0105622:	0d 00 00 00 80       	or     $0x80000000,%eax
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0105627:	ef                   	out    %eax,(%dx)
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
	outl(pci_conf1_addr_ioport, v);
}
f0105628:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f010562b:	c9                   	leave  
f010562c:	c3                   	ret    

f010562d <pci_conf_read>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f010562d:	55                   	push   %ebp
f010562e:	89 e5                	mov    %esp,%ebp
f0105630:	83 ec 08             	sub    $0x8,%esp
f0105633:	8b 45 08             	mov    0x8(%ebp),%eax
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0105636:	ff 75 0c             	pushl  0xc(%ebp)
f0105639:	ff 70 08             	pushl  0x8(%eax)
f010563c:	ff 70 04             	pushl  0x4(%eax)
f010563f:	8b 00                	mov    (%eax),%eax
f0105641:	ff 70 04             	pushl  0x4(%eax)
f0105644:	e8 23 ff ff ff       	call   f010556c <pci_conf1_set_addr>
}

static __inline uint32_t
inl(int port)
{
f0105649:	83 c4 10             	add    $0x10,%esp
f010564c:	8b 15 a4 56 12 f0    	mov    0xf01256a4,%edx
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0105652:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f0105653:	c9                   	leave  
f0105654:	c3                   	ret    

f0105655 <pci_conf_write>:

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f0105655:	55                   	push   %ebp
f0105656:	89 e5                	mov    %esp,%ebp
f0105658:	83 ec 08             	sub    $0x8,%esp
f010565b:	8b 45 08             	mov    0x8(%ebp),%eax
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010565e:	ff 75 0c             	pushl  0xc(%ebp)
f0105661:	ff 70 08             	pushl  0x8(%eax)
f0105664:	ff 70 04             	pushl  0x4(%eax)
f0105667:	8b 00                	mov    (%eax),%eax
f0105669:	ff 70 04             	pushl  0x4(%eax)
f010566c:	e8 fb fe ff ff       	call   f010556c <pci_conf1_set_addr>
}

static __inline void
outl(int port, uint32_t data)
{
f0105671:	83 c4 10             	add    $0x10,%esp
f0105674:	8b 15 a4 56 12 f0    	mov    0xf01256a4,%edx
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010567a:	8b 45 10             	mov    0x10(%ebp),%eax
f010567d:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f010567e:	c9                   	leave  
f010567f:	c3                   	ret    

f0105680 <pci_attach_match>:

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0105680:	55                   	push   %ebp
f0105681:	89 e5                	mov    %esp,%ebp
f0105683:	57                   	push   %edi
f0105684:	56                   	push   %esi
f0105685:	53                   	push   %ebx
f0105686:	83 ec 0c             	sub    $0xc,%esp
f0105689:	8b 7d 08             	mov    0x8(%ebp),%edi
f010568c:	8b 75 10             	mov    0x10(%ebp),%esi
	uint32_t i;
	
	for (i = 0; list[i].attachfn; i++) {
f010568f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105694:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
f0105698:	74 50                	je     f01056ea <pci_attach_match+0x6a>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f010569a:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f010569d:	c1 e0 02             	shl    $0x2,%eax
f01056a0:	39 3c 30             	cmp    %edi,(%eax,%esi,1)
f01056a3:	75 3a                	jne    f01056df <pci_attach_match+0x5f>
f01056a5:	8b 55 0c             	mov    0xc(%ebp),%edx
f01056a8:	39 54 30 04          	cmp    %edx,0x4(%eax,%esi,1)
f01056ac:	75 31                	jne    f01056df <pci_attach_match+0x5f>
			int r = list[i].attachfn(pcif);
f01056ae:	83 ec 0c             	sub    $0xc,%esp
f01056b1:	ff 75 14             	pushl  0x14(%ebp)
f01056b4:	ff 54 30 08          	call   *0x8(%eax,%esi,1)
			if (r > 0)
f01056b8:	83 c4 10             	add    $0x10,%esp
f01056bb:	85 c0                	test   %eax,%eax
f01056bd:	7f 30                	jg     f01056ef <pci_attach_match+0x6f>
				return r;
			if (r < 0)
f01056bf:	85 c0                	test   %eax,%eax
f01056c1:	79 1c                	jns    f01056df <pci_attach_match+0x5f>
				cprintf("pci_attach_match: attaching "
f01056c3:	83 ec 0c             	sub    $0xc,%esp
f01056c6:	50                   	push   %eax
f01056c7:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01056ca:	ff 74 86 08          	pushl  0x8(%esi,%eax,4)
f01056ce:	ff 75 0c             	pushl  0xc(%ebp)
f01056d1:	57                   	push   %edi
f01056d2:	68 54 74 10 f0       	push   $0xf0107454
f01056d7:	e8 e6 d9 ff ff       	call   f01030c2 <cprintf>
f01056dc:	83 c4 20             	add    $0x20,%esp
f01056df:	43                   	inc    %ebx
f01056e0:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01056e3:	83 7c 86 08 00       	cmpl   $0x0,0x8(%esi,%eax,4)
f01056e8:	75 b0                	jne    f010569a <pci_attach_match+0x1a>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
f01056ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01056ef:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f01056f2:	5b                   	pop    %ebx
f01056f3:	5e                   	pop    %esi
f01056f4:	5f                   	pop    %edi
f01056f5:	c9                   	leave  
f01056f6:	c3                   	ret    

f01056f7 <pci_attach>:

static int
pci_attach(struct pci_func *f)
{
f01056f7:	55                   	push   %ebp
f01056f8:	89 e5                	mov    %esp,%ebp
f01056fa:	56                   	push   %esi
f01056fb:	53                   	push   %ebx
f01056fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return
f01056ff:	be 00 00 00 00       	mov    $0x0,%esi
f0105704:	53                   	push   %ebx
f0105705:	68 a8 56 12 f0       	push   $0xf01256a8
f010570a:	0f b6 43 12          	movzbl 0x12(%ebx),%eax
f010570e:	50                   	push   %eax
f010570f:	0f b6 43 13          	movzbl 0x13(%ebx),%eax
f0105713:	50                   	push   %eax
f0105714:	e8 67 ff ff ff       	call   f0105680 <pci_attach_match>
f0105719:	83 c4 10             	add    $0x10,%esp
f010571c:	85 c0                	test   %eax,%eax
f010571e:	75 21                	jne    f0105741 <pci_attach+0x4a>
f0105720:	53                   	push   %ebx
f0105721:	68 c0 56 12 f0       	push   $0xf01256c0
f0105726:	8b 43 0c             	mov    0xc(%ebx),%eax
f0105729:	89 c2                	mov    %eax,%edx
f010572b:	c1 ea 10             	shr    $0x10,%edx
f010572e:	52                   	push   %edx
f010572f:	25 ff ff 00 00       	and    $0xffff,%eax
f0105734:	50                   	push   %eax
f0105735:	e8 46 ff ff ff       	call   f0105680 <pci_attach_match>
f010573a:	83 c4 10             	add    $0x10,%esp
f010573d:	85 c0                	test   %eax,%eax
f010573f:	74 05                	je     f0105746 <pci_attach+0x4f>
f0105741:	be 01 00 00 00       	mov    $0x1,%esi
		pci_attach_match(PCI_CLASS(f->dev_class), 
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
		pci_attach_match(PCI_VENDOR(f->dev_id), 
				 PCI_PRODUCT(f->dev_id),
				 &pci_attach_vendor[0], f);
}
f0105746:	89 f0                	mov    %esi,%eax
f0105748:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f010574b:	5b                   	pop    %ebx
f010574c:	5e                   	pop    %esi
f010574d:	c9                   	leave  
f010574e:	c3                   	ret    

f010574f <pci_print_func>:

static const char *pci_class[] = 
{
	[0x0] = "Unknown",
	[0x1] = "Storage controller",
	[0x2] = "Network controller",
	[0x3] = "Display controller",
	[0x4] = "Multimedia device",
	[0x5] = "Memory controller",
	[0x6] = "Bridge device",
};

static void 
pci_print_func(struct pci_func *f)
{
f010574f:	55                   	push   %ebp
f0105750:	89 e5                	mov    %esp,%ebp
f0105752:	83 ec 08             	sub    $0x8,%esp
f0105755:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const char *class = pci_class[0];
f0105758:	8b 15 d8 56 12 f0    	mov    0xf01256d8,%edx
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f010575e:	0f b6 41 13          	movzbl 0x13(%ecx),%eax
f0105762:	83 f8 06             	cmp    $0x6,%eax
f0105765:	77 07                	ja     f010576e <pci_print_func+0x1f>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0105767:	8b 14 85 d8 56 12 f0 	mov    0xf01256d8(,%eax,4),%edx

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f010576e:	83 ec 08             	sub    $0x8,%esp
f0105771:	0f b6 41 44          	movzbl 0x44(%ecx),%eax
f0105775:	50                   	push   %eax
f0105776:	52                   	push   %edx
f0105777:	0f b6 41 12          	movzbl 0x12(%ecx),%eax
f010577b:	50                   	push   %eax
f010577c:	0f b6 41 13          	movzbl 0x13(%ecx),%eax
f0105780:	50                   	push   %eax
f0105781:	8b 41 0c             	mov    0xc(%ecx),%eax
f0105784:	89 c2                	mov    %eax,%edx
f0105786:	c1 ea 10             	shr    $0x10,%edx
f0105789:	52                   	push   %edx
f010578a:	25 ff ff 00 00       	and    $0xffff,%eax
f010578f:	50                   	push   %eax
f0105790:	ff 71 08             	pushl  0x8(%ecx)
f0105793:	ff 71 04             	pushl  0x4(%ecx)
f0105796:	8b 01                	mov    (%ecx),%eax
f0105798:	ff 70 04             	pushl  0x4(%eax)
f010579b:	68 80 74 10 f0       	push   $0xf0107480
f01057a0:	e8 1d d9 ff ff       	call   f01030c2 <cprintf>
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
		f->irq_line);
}
f01057a5:	c9                   	leave  
f01057a6:	c3                   	ret    

f01057a7 <pci_scan_bus>:

static int 
pci_scan_bus(struct pci_bus *bus)
{
f01057a7:	55                   	push   %ebp
f01057a8:	89 e5                	mov    %esp,%ebp
f01057aa:	57                   	push   %edi
f01057ab:	56                   	push   %esi
f01057ac:	53                   	push   %ebx
f01057ad:	81 ec 10 01 00 00    	sub    $0x110,%esp
	int totaldev = 0;
f01057b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,0xfffffef4(%ebp)
f01057ba:	00 00 00 
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f01057bd:	6a 48                	push   $0x48
f01057bf:	6a 00                	push   $0x0
f01057c1:	8d 45 98             	lea    0xffffff98(%ebp),%eax
f01057c4:	50                   	push   %eax
f01057c5:	e8 c7 f4 ff ff       	call   f0104c91 <memset>
	df.bus = bus;
f01057ca:	8b 45 08             	mov    0x8(%ebp),%eax
f01057cd:	89 45 98             	mov    %eax,0xffffff98(%ebp)
	
	for (df.dev = 0; df.dev < 32; df.dev++) {
f01057d0:	c7 45 9c 00 00 00 00 	movl   $0x0,0xffffff9c(%ebp)
f01057d7:	83 c4 10             	add    $0x10,%esp
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f01057da:	83 ec 08             	sub    $0x8,%esp
f01057dd:	6a 0c                	push   $0xc
f01057df:	8d 45 98             	lea    0xffffff98(%ebp),%eax
f01057e2:	50                   	push   %eax
f01057e3:	e8 45 fe ff ff       	call   f010562d <pci_conf_read>
f01057e8:	89 c7                	mov    %eax,%edi
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f01057ea:	c1 e8 10             	shr    $0x10,%eax
f01057ed:	83 e0 7f             	and    $0x7f,%eax
f01057f0:	83 c4 10             	add    $0x10,%esp
f01057f3:	83 f8 01             	cmp    $0x1,%eax
f01057f6:	0f 87 cf 00 00 00    	ja     f01058cb <pci_scan_bus+0x124>
			continue;
		
		totaldev++;
f01057fc:	ff 85 f4 fe ff ff    	incl   0xfffffef4(%ebp)
		
		struct pci_func f = df;
f0105802:	8d 85 48 ff ff ff    	lea    0xffffff48(%ebp),%eax
f0105808:	83 ec 04             	sub    $0x4,%esp
f010580b:	6a 48                	push   $0x48
f010580d:	8d 55 98             	lea    0xffffff98(%ebp),%edx
f0105810:	52                   	push   %edx
f0105811:	50                   	push   %eax
f0105812:	e8 38 f5 ff ff       	call   f0104d4f <memcpy>
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0105817:	c7 85 50 ff ff ff 00 	movl   $0x0,0xffffff50(%ebp)
f010581e:	00 00 00 
f0105821:	83 c4 10             	add    $0x10,%esp
f0105824:	8d b5 48 ff ff ff    	lea    0xffffff48(%ebp),%esi
f010582a:	eb 7e                	jmp    f01058aa <pci_scan_bus+0x103>
		     f.func++) {
			struct pci_func af = f;
f010582c:	8d 9d f8 fe ff ff    	lea    0xfffffef8(%ebp),%ebx
f0105832:	83 ec 04             	sub    $0x4,%esp
f0105835:	6a 48                	push   $0x48
f0105837:	56                   	push   %esi
f0105838:	53                   	push   %ebx
f0105839:	e8 11 f5 ff ff       	call   f0104d4f <memcpy>
			
			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f010583e:	83 c4 08             	add    $0x8,%esp
f0105841:	6a 00                	push   $0x0
f0105843:	56                   	push   %esi
f0105844:	e8 e4 fd ff ff       	call   f010562d <pci_conf_read>
f0105849:	89 85 04 ff ff ff    	mov    %eax,0xffffff04(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f010584f:	83 c4 10             	add    $0x10,%esp
f0105852:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f0105856:	74 4c                	je     f01058a4 <pci_scan_bus+0xfd>
				continue;
			
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0105858:	83 ec 08             	sub    $0x8,%esp
f010585b:	6a 3c                	push   $0x3c
f010585d:	53                   	push   %ebx
f010585e:	e8 ca fd ff ff       	call   f010562d <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0105863:	88 85 3c ff ff ff    	mov    %al,0xffffff3c(%ebp)
			
			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0105869:	83 c4 08             	add    $0x8,%esp
f010586c:	6a 08                	push   $0x8
f010586e:	53                   	push   %ebx
f010586f:	e8 b9 fd ff ff       	call   f010562d <pci_conf_read>
f0105874:	89 85 08 ff ff ff    	mov    %eax,0xffffff08(%ebp)
			if (pci_show_devs)
f010587a:	83 c4 10             	add    $0x10,%esp
f010587d:	83 3d 9c 56 12 f0 00 	cmpl   $0x0,0xf012569c
f0105884:	74 0c                	je     f0105892 <pci_scan_bus+0xeb>
				pci_print_func(&af);
f0105886:	83 ec 0c             	sub    $0xc,%esp
f0105889:	53                   	push   %ebx
f010588a:	e8 c0 fe ff ff       	call   f010574f <pci_print_func>
f010588f:	83 c4 10             	add    $0x10,%esp
			pci_attach(&af);
f0105892:	83 ec 0c             	sub    $0xc,%esp
f0105895:	8d 85 f8 fe ff ff    	lea    0xfffffef8(%ebp),%eax
f010589b:	50                   	push   %eax
f010589c:	e8 56 fe ff ff       	call   f01056f7 <pci_attach>
f01058a1:	83 c4 10             	add    $0x10,%esp
f01058a4:	ff 85 50 ff ff ff    	incl   0xffffff50(%ebp)
f01058aa:	8b 85 50 ff ff ff    	mov    0xffffff50(%ebp),%eax
f01058b0:	f7 c7 00 00 80 00    	test   $0x800000,%edi
f01058b6:	74 0b                	je     f01058c3 <pci_scan_bus+0x11c>
f01058b8:	83 f8 07             	cmp    $0x7,%eax
f01058bb:	0f 86 6b ff ff ff    	jbe    f010582c <pci_scan_bus+0x85>
f01058c1:	eb 08                	jmp    f01058cb <pci_scan_bus+0x124>
f01058c3:	85 c0                	test   %eax,%eax
f01058c5:	0f 84 61 ff ff ff    	je     f010582c <pci_scan_bus+0x85>
f01058cb:	ff 45 9c             	incl   0xffffff9c(%ebp)
f01058ce:	83 7d 9c 1f          	cmpl   $0x1f,0xffffff9c(%ebp)
f01058d2:	0f 86 02 ff ff ff    	jbe    f01057da <pci_scan_bus+0x33>
		}
	}
	
	return totaldev;
}
f01058d8:	8b 85 f4 fe ff ff    	mov    0xfffffef4(%ebp),%eax
f01058de:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f01058e1:	5b                   	pop    %ebx
f01058e2:	5e                   	pop    %esi
f01058e3:	5f                   	pop    %edi
f01058e4:	c9                   	leave  
f01058e5:	c3                   	ret    

f01058e6 <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f01058e6:	55                   	push   %ebp
f01058e7:	89 e5                	mov    %esp,%ebp
f01058e9:	57                   	push   %edi
f01058ea:	56                   	push   %esi
f01058eb:	53                   	push   %ebx
f01058ec:	83 ec 14             	sub    $0x14,%esp
f01058ef:	8b 75 08             	mov    0x8(%ebp),%esi
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f01058f2:	6a 1c                	push   $0x1c
f01058f4:	56                   	push   %esi
f01058f5:	e8 33 fd ff ff       	call   f010562d <pci_conf_read>
f01058fa:	89 c3                	mov    %eax,%ebx
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f01058fc:	83 c4 08             	add    $0x8,%esp
f01058ff:	6a 18                	push   $0x18
f0105901:	56                   	push   %esi
f0105902:	e8 26 fd ff ff       	call   f010562d <pci_conf_read>
f0105907:	89 c7                	mov    %eax,%edi
	
	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0105909:	89 d8                	mov    %ebx,%eax
f010590b:	83 e0 0f             	and    $0xf,%eax
f010590e:	83 c4 10             	add    $0x10,%esp
f0105911:	83 f8 01             	cmp    $0x1,%eax
f0105914:	75 1c                	jne    f0105932 <pci_bridge_attach+0x4c>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0105916:	ff 76 08             	pushl  0x8(%esi)
f0105919:	ff 76 04             	pushl  0x4(%esi)
f010591c:	8b 06                	mov    (%esi),%eax
f010591e:	ff 70 04             	pushl  0x4(%eax)
f0105921:	68 bc 74 10 f0       	push   $0xf01074bc
f0105926:	e8 97 d7 ff ff       	call   f01030c2 <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
f010592b:	b8 00 00 00 00       	mov    $0x0,%eax
f0105930:	eb 5d                	jmp    f010598f <pci_bridge_attach+0xa9>
	}
	
	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f0105932:	83 ec 04             	sub    $0x4,%esp
f0105935:	6a 08                	push   $0x8
f0105937:	6a 00                	push   $0x0
f0105939:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f010593c:	50                   	push   %eax
f010593d:	e8 4f f3 ff ff       	call   f0104c91 <memset>
	nbus.parent_bridge = pcif;
f0105942:	89 75 e8             	mov    %esi,0xffffffe8(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0105945:	89 f8                	mov    %edi,%eax
f0105947:	0f b6 d4             	movzbl %ah,%edx
f010594a:	89 55 ec             	mov    %edx,0xffffffec(%ebp)
	
	if (pci_show_devs)
f010594d:	83 c4 10             	add    $0x10,%esp
f0105950:	83 3d 9c 56 12 f0 00 	cmpl   $0x0,0xf012569c
f0105957:	74 25                	je     f010597e <pci_bridge_attach+0x98>
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0105959:	83 ec 08             	sub    $0x8,%esp
f010595c:	c1 e8 10             	shr    $0x10,%eax
f010595f:	25 ff 00 00 00       	and    $0xff,%eax
f0105964:	50                   	push   %eax
f0105965:	52                   	push   %edx
f0105966:	ff 76 08             	pushl  0x8(%esi)
f0105969:	ff 76 04             	pushl  0x4(%esi)
f010596c:	8b 06                	mov    (%esi),%eax
f010596e:	ff 70 04             	pushl  0x4(%eax)
f0105971:	68 f0 74 10 f0       	push   $0xf01074f0
f0105976:	e8 47 d7 ff ff       	call   f01030c2 <cprintf>
f010597b:	83 c4 20             	add    $0x20,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
	
	pci_scan_bus(&nbus);
f010597e:	83 ec 0c             	sub    $0xc,%esp
f0105981:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0105984:	50                   	push   %eax
f0105985:	e8 1d fe ff ff       	call   f01057a7 <pci_scan_bus>
	return 1;
f010598a:	b8 01 00 00 00       	mov    $0x1,%eax
}
f010598f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0105992:	5b                   	pop    %ebx
f0105993:	5e                   	pop    %esi
f0105994:	5f                   	pop    %edi
f0105995:	c9                   	leave  
f0105996:	c3                   	ret    

f0105997 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0105997:	55                   	push   %ebp
f0105998:	89 e5                	mov    %esp,%ebp
f010599a:	57                   	push   %edi
f010599b:	56                   	push   %esi
f010599c:	53                   	push   %ebx
f010599d:	83 ec 10             	sub    $0x10,%esp
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f01059a0:	6a 07                	push   $0x7
f01059a2:	6a 04                	push   $0x4
f01059a4:	ff 75 08             	pushl  0x8(%ebp)
f01059a7:	e8 a9 fc ff ff       	call   f0105655 <pci_conf_write>
		       PCI_COMMAND_IO_ENABLE |
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);
	
	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01059ac:	be 10 00 00 00       	mov    $0x10,%esi
f01059b1:	83 c4 10             	add    $0x10,%esp
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);
f01059b4:	83 ec 08             	sub    $0x8,%esp
f01059b7:	56                   	push   %esi
f01059b8:	ff 75 08             	pushl  0x8(%ebp)
f01059bb:	e8 6d fc ff ff       	call   f010562d <pci_conf_read>
f01059c0:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
		
		bar_width = 4;
f01059c3:	c7 45 f0 04 00 00 00 	movl   $0x4,0xfffffff0(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f01059ca:	83 c4 0c             	add    $0xc,%esp
f01059cd:	6a ff                	push   $0xffffffff
f01059cf:	56                   	push   %esi
f01059d0:	ff 75 08             	pushl  0x8(%ebp)
f01059d3:	e8 7d fc ff ff       	call   f0105655 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f01059d8:	83 c4 08             	add    $0x8,%esp
f01059db:	56                   	push   %esi
f01059dc:	ff 75 08             	pushl  0x8(%ebp)
f01059df:	e8 49 fc ff ff       	call   f010562d <pci_conf_read>
f01059e4:	89 c2                	mov    %eax,%edx
		
		if (rv == 0)
f01059e6:	83 c4 10             	add    $0x10,%esp
f01059e9:	85 c0                	test   %eax,%eax
f01059eb:	0f 84 d4 00 00 00    	je     f0105ac5 <pci_func_enable+0x12e>
			continue;
		
		int regnum = PCI_MAPREG_NUM(bar);
f01059f1:	8d 46 f0             	lea    0xfffffff0(%esi),%eax
f01059f4:	c1 e8 02             	shr    $0x2,%eax
f01059f7:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f01059fa:	f6 c2 01             	test   $0x1,%dl
f01059fd:	75 40                	jne    f0105a3f <pci_func_enable+0xa8>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f01059ff:	89 d0                	mov    %edx,%eax
f0105a01:	83 e0 06             	and    $0x6,%eax
f0105a04:	83 f8 04             	cmp    $0x4,%eax
f0105a07:	75 07                	jne    f0105a10 <pci_func_enable+0x79>
				bar_width = 8;
f0105a09:	c7 45 f0 08 00 00 00 	movl   $0x8,0xfffffff0(%ebp)
			
			size = PCI_MAPREG_MEM_SIZE(rv);
f0105a10:	89 d3                	mov    %edx,%ebx
f0105a12:	83 e3 f0             	and    $0xfffffff0,%ebx
f0105a15:	f7 db                	neg    %ebx
f0105a17:	21 d3                	and    %edx,%ebx
f0105a19:	83 e3 f0             	and    $0xfffffff0,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0105a1c:	8b 7d ec             	mov    0xffffffec(%ebp),%edi
f0105a1f:	83 e7 f0             	and    $0xfffffff0,%edi
			if (pci_show_addrs)
f0105a22:	83 3d 60 68 2f f0 00 	cmpl   $0x0,0xf02f6860
f0105a29:	74 41                	je     f0105a6c <pci_func_enable+0xd5>
				cprintf("  mem region %d: %d bytes at 0x%x\n",
f0105a2b:	57                   	push   %edi
f0105a2c:	53                   	push   %ebx
f0105a2d:	ff 75 e8             	pushl  0xffffffe8(%ebp)
f0105a30:	68 20 75 10 f0       	push   $0xf0107520
f0105a35:	e8 88 d6 ff ff       	call   f01030c2 <cprintf>
f0105a3a:	83 c4 10             	add    $0x10,%esp
f0105a3d:	eb 2d                	jmp    f0105a6c <pci_func_enable+0xd5>
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0105a3f:	89 d3                	mov    %edx,%ebx
f0105a41:	83 e3 fc             	and    $0xfffffffc,%ebx
f0105a44:	f7 db                	neg    %ebx
f0105a46:	21 d3                	and    %edx,%ebx
f0105a48:	83 e3 fc             	and    $0xfffffffc,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f0105a4b:	8b 7d ec             	mov    0xffffffec(%ebp),%edi
f0105a4e:	83 e7 fc             	and    $0xfffffffc,%edi
			if (pci_show_addrs)
f0105a51:	83 3d 60 68 2f f0 00 	cmpl   $0x0,0xf02f6860
f0105a58:	74 12                	je     f0105a6c <pci_func_enable+0xd5>
				cprintf("  io region %d: %d bytes at 0x%x\n",
f0105a5a:	57                   	push   %edi
f0105a5b:	53                   	push   %ebx
f0105a5c:	ff 75 e8             	pushl  0xffffffe8(%ebp)
f0105a5f:	68 44 75 10 f0       	push   $0xf0107544
f0105a64:	e8 59 d6 ff ff       	call   f01030c2 <cprintf>
f0105a69:	83 c4 10             	add    $0x10,%esp
					regnum, size, base);
		}
		
		pci_conf_write(f, bar, oldv);
f0105a6c:	83 ec 04             	sub    $0x4,%esp
f0105a6f:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0105a72:	56                   	push   %esi
f0105a73:	ff 75 08             	pushl  0x8(%ebp)
f0105a76:	e8 da fb ff ff       	call   f0105655 <pci_conf_write>
		f->reg_base[regnum] = base;
f0105a7b:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f0105a7e:	8b 55 08             	mov    0x8(%ebp),%edx
f0105a81:	89 7c 82 14          	mov    %edi,0x14(%edx,%eax,4)
		f->reg_size[regnum] = size;
f0105a85:	89 5c 82 2c          	mov    %ebx,0x2c(%edx,%eax,4)
		
		if (size && !base)
f0105a89:	83 c4 10             	add    $0x10,%esp
f0105a8c:	85 db                	test   %ebx,%ebx
f0105a8e:	74 35                	je     f0105ac5 <pci_func_enable+0x12e>
f0105a90:	85 ff                	test   %edi,%edi
f0105a92:	75 31                	jne    f0105ac5 <pci_func_enable+0x12e>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0105a94:	83 ec 0c             	sub    $0xc,%esp
f0105a97:	53                   	push   %ebx
f0105a98:	6a 00                	push   $0x0
f0105a9a:	50                   	push   %eax
f0105a9b:	8b 42 0c             	mov    0xc(%edx),%eax
f0105a9e:	89 c2                	mov    %eax,%edx
f0105aa0:	c1 ea 10             	shr    $0x10,%edx
f0105aa3:	52                   	push   %edx
f0105aa4:	25 ff ff 00 00       	and    $0xffff,%eax
f0105aa9:	50                   	push   %eax
f0105aaa:	8b 45 08             	mov    0x8(%ebp),%eax
f0105aad:	ff 70 08             	pushl  0x8(%eax)
f0105ab0:	ff 70 04             	pushl  0x4(%eax)
f0105ab3:	8b 00                	mov    (%eax),%eax
f0105ab5:	ff 70 04             	pushl  0x4(%eax)
f0105ab8:	68 68 75 10 f0       	push   $0xf0107568
f0105abd:	e8 00 d6 ff ff       	call   f01030c2 <cprintf>
f0105ac2:	83 c4 30             	add    $0x30,%esp
f0105ac5:	03 75 f0             	add    0xfffffff0(%ebp),%esi
f0105ac8:	83 fe 27             	cmp    $0x27,%esi
f0105acb:	0f 86 e3 fe ff ff    	jbe    f01059b4 <pci_func_enable+0x1d>
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
				regnum, base, size);
	}
}
f0105ad1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0105ad4:	5b                   	pop    %ebx
f0105ad5:	5e                   	pop    %esi
f0105ad6:	5f                   	pop    %edi
f0105ad7:	c9                   	leave  
f0105ad8:	c3                   	ret    

f0105ad9 <pci_init>:

int
pci_init(void)
{
f0105ad9:	55                   	push   %ebp
f0105ada:	89 e5                	mov    %esp,%ebp
f0105adc:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0105adf:	6a 08                	push   $0x8
f0105ae1:	6a 00                	push   $0x0
f0105ae3:	68 64 68 2f f0       	push   $0xf02f6864
f0105ae8:	e8 a4 f1 ff ff       	call   f0104c91 <memset>
	
	return pci_scan_bus(&root_bus);
f0105aed:	c7 04 24 64 68 2f f0 	movl   $0xf02f6864,(%esp)
f0105af4:	e8 ae fc ff ff       	call   f01057a7 <pci_scan_bus>
}
f0105af9:	c9                   	leave  
f0105afa:	c3                   	ret    
	...

f0105afc <time_init>:
static unsigned int ticks;

void
time_init(void) 
{
f0105afc:	55                   	push   %ebp
f0105afd:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f0105aff:	c7 05 6c 68 2f f0 00 	movl   $0x0,0xf02f686c
f0105b06:	00 00 00 
}
f0105b09:	c9                   	leave  
f0105b0a:	c3                   	ret    

f0105b0b <time_tick>:

// this is called once per timer interupt; a timer interupt fires 100 times a
// second
void
time_tick(void) 
{
f0105b0b:	55                   	push   %ebp
f0105b0c:	89 e5                	mov    %esp,%ebp
f0105b0e:	83 ec 08             	sub    $0x8,%esp
	ticks++;
f0105b11:	a1 6c 68 2f f0       	mov    0xf02f686c,%eax
f0105b16:	40                   	inc    %eax
f0105b17:	a3 6c 68 2f f0       	mov    %eax,0xf02f686c
	if (ticks * 10 < ticks)
f0105b1c:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105b1f:	d1 e0                	shl    %eax
f0105b21:	3b 05 6c 68 2f f0    	cmp    0xf02f686c,%eax
f0105b27:	73 14                	jae    f0105b3d <time_tick+0x32>
		panic("time_tick: time overflowed");
f0105b29:	83 ec 04             	sub    $0x4,%esp
f0105b2c:	68 c1 75 10 f0       	push   $0xf01075c1
f0105b31:	6a 13                	push   $0x13
f0105b33:	68 dc 75 10 f0       	push   $0xf01075dc
f0105b38:	e8 ac a5 ff ff       	call   f01000e9 <_panic>
}
f0105b3d:	c9                   	leave  
f0105b3e:	c3                   	ret    

f0105b3f <time_msec>:

unsigned int
time_msec(void) 
{
f0105b3f:	55                   	push   %ebp
f0105b40:	89 e5                	mov    %esp,%ebp
	return ticks * 10;
f0105b42:	a1 6c 68 2f f0       	mov    0xf02f686c,%eax
f0105b47:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105b4a:	d1 e0                	shl    %eax
}
f0105b4c:	c9                   	leave  
f0105b4d:	c3                   	ret    
	...

f0105b50 <__udivdi3>:
f0105b50:	55                   	push   %ebp
f0105b51:	89 e5                	mov    %esp,%ebp
f0105b53:	57                   	push   %edi
f0105b54:	56                   	push   %esi
f0105b55:	83 ec 14             	sub    $0x14,%esp
f0105b58:	8b 55 14             	mov    0x14(%ebp),%edx
f0105b5b:	8b 75 08             	mov    0x8(%ebp),%esi
f0105b5e:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105b61:	8b 45 10             	mov    0x10(%ebp),%eax
f0105b64:	85 d2                	test   %edx,%edx
f0105b66:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
f0105b69:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
f0105b6c:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
f0105b6f:	89 fe                	mov    %edi,%esi
f0105b71:	75 11                	jne    f0105b84 <__udivdi3+0x34>
f0105b73:	39 f8                	cmp    %edi,%eax
f0105b75:	76 4d                	jbe    f0105bc4 <__udivdi3+0x74>
f0105b77:	89 fa                	mov    %edi,%edx
f0105b79:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0105b7c:	f7 75 e4             	divl   0xffffffe4(%ebp)
f0105b7f:	89 c7                	mov    %eax,%edi
f0105b81:	eb 09                	jmp    f0105b8c <__udivdi3+0x3c>
f0105b83:	90                   	nop    
f0105b84:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
f0105b87:	76 17                	jbe    f0105ba0 <__udivdi3+0x50>
f0105b89:	31 ff                	xor    %edi,%edi
f0105b8b:	90                   	nop    
f0105b8c:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
f0105b93:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
f0105b96:	83 c4 14             	add    $0x14,%esp
f0105b99:	5e                   	pop    %esi
f0105b9a:	89 f8                	mov    %edi,%eax
f0105b9c:	5f                   	pop    %edi
f0105b9d:	c9                   	leave  
f0105b9e:	c3                   	ret    
f0105b9f:	90                   	nop    
f0105ba0:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
f0105ba4:	89 c7                	mov    %eax,%edi
f0105ba6:	83 f7 1f             	xor    $0x1f,%edi
f0105ba9:	75 4d                	jne    f0105bf8 <__udivdi3+0xa8>
f0105bab:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
f0105bae:	77 0a                	ja     f0105bba <__udivdi3+0x6a>
f0105bb0:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
f0105bb3:	31 ff                	xor    %edi,%edi
f0105bb5:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
f0105bb8:	72 d2                	jb     f0105b8c <__udivdi3+0x3c>
f0105bba:	bf 01 00 00 00       	mov    $0x1,%edi
f0105bbf:	eb cb                	jmp    f0105b8c <__udivdi3+0x3c>
f0105bc1:	8d 76 00             	lea    0x0(%esi),%esi
f0105bc4:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f0105bc7:	85 c0                	test   %eax,%eax
f0105bc9:	75 0e                	jne    f0105bd9 <__udivdi3+0x89>
f0105bcb:	b8 01 00 00 00       	mov    $0x1,%eax
f0105bd0:	31 c9                	xor    %ecx,%ecx
f0105bd2:	31 d2                	xor    %edx,%edx
f0105bd4:	f7 f1                	div    %ecx
f0105bd6:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
f0105bd9:	89 f0                	mov    %esi,%eax
f0105bdb:	31 d2                	xor    %edx,%edx
f0105bdd:	f7 75 e4             	divl   0xffffffe4(%ebp)
f0105be0:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
f0105be3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0105be6:	f7 75 e4             	divl   0xffffffe4(%ebp)
f0105be9:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
f0105bec:	83 c4 14             	add    $0x14,%esp
f0105bef:	89 c7                	mov    %eax,%edi
f0105bf1:	5e                   	pop    %esi
f0105bf2:	89 f8                	mov    %edi,%eax
f0105bf4:	5f                   	pop    %edi
f0105bf5:	c9                   	leave  
f0105bf6:	c3                   	ret    
f0105bf7:	90                   	nop    
f0105bf8:	b8 20 00 00 00       	mov    $0x20,%eax
f0105bfd:	29 f8                	sub    %edi,%eax
f0105bff:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
f0105c02:	89 f9                	mov    %edi,%ecx
f0105c04:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f0105c07:	d3 e2                	shl    %cl,%edx
f0105c09:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f0105c0c:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
f0105c0f:	d3 e8                	shr    %cl,%eax
f0105c11:	09 c2                	or     %eax,%edx
f0105c13:	89 f9                	mov    %edi,%ecx
f0105c15:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
f0105c18:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
f0105c1b:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
f0105c1e:	89 f2                	mov    %esi,%edx
f0105c20:	d3 ea                	shr    %cl,%edx
f0105c22:	89 f9                	mov    %edi,%ecx
f0105c24:	d3 e6                	shl    %cl,%esi
f0105c26:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0105c29:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
f0105c2c:	d3 e8                	shr    %cl,%eax
f0105c2e:	09 c6                	or     %eax,%esi
f0105c30:	89 f9                	mov    %edi,%ecx
f0105c32:	89 f0                	mov    %esi,%eax
f0105c34:	f7 75 f4             	divl   0xfffffff4(%ebp)
f0105c37:	89 d6                	mov    %edx,%esi
f0105c39:	89 c7                	mov    %eax,%edi
f0105c3b:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
f0105c3e:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f0105c41:	f7 e7                	mul    %edi
f0105c43:	39 f2                	cmp    %esi,%edx
f0105c45:	77 0f                	ja     f0105c56 <__udivdi3+0x106>
f0105c47:	0f 85 3f ff ff ff    	jne    f0105b8c <__udivdi3+0x3c>
f0105c4d:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
f0105c50:	0f 86 36 ff ff ff    	jbe    f0105b8c <__udivdi3+0x3c>
f0105c56:	4f                   	dec    %edi
f0105c57:	e9 30 ff ff ff       	jmp    f0105b8c <__udivdi3+0x3c>

f0105c5c <__umoddi3>:
f0105c5c:	55                   	push   %ebp
f0105c5d:	89 e5                	mov    %esp,%ebp
f0105c5f:	57                   	push   %edi
f0105c60:	56                   	push   %esi
f0105c61:	83 ec 30             	sub    $0x30,%esp
f0105c64:	8b 55 14             	mov    0x14(%ebp),%edx
f0105c67:	8b 45 10             	mov    0x10(%ebp),%eax
f0105c6a:	89 d7                	mov    %edx,%edi
f0105c6c:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
f0105c6f:	89 c6                	mov    %eax,%esi
f0105c71:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105c74:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c77:	85 ff                	test   %edi,%edi
f0105c79:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
f0105c80:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
f0105c87:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
f0105c8a:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
f0105c8d:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
f0105c90:	75 3e                	jne    f0105cd0 <__umoddi3+0x74>
f0105c92:	39 d6                	cmp    %edx,%esi
f0105c94:	0f 86 a2 00 00 00    	jbe    f0105d3c <__umoddi3+0xe0>
f0105c9a:	f7 f6                	div    %esi
f0105c9c:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
f0105c9f:	85 c9                	test   %ecx,%ecx
f0105ca1:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
f0105ca4:	74 1b                	je     f0105cc1 <__umoddi3+0x65>
f0105ca6:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105ca9:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
f0105cac:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
f0105cb3:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0105cb6:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
f0105cb9:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
f0105cbc:	89 10                	mov    %edx,(%eax)
f0105cbe:	89 48 04             	mov    %ecx,0x4(%eax)
f0105cc1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0105cc4:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f0105cc7:	83 c4 30             	add    $0x30,%esp
f0105cca:	5e                   	pop    %esi
f0105ccb:	5f                   	pop    %edi
f0105ccc:	c9                   	leave  
f0105ccd:	c3                   	ret    
f0105cce:	89 f6                	mov    %esi,%esi
f0105cd0:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
f0105cd3:	76 1f                	jbe    f0105cf4 <__umoddi3+0x98>
f0105cd5:	8b 55 08             	mov    0x8(%ebp),%edx
f0105cd8:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
f0105cdb:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
f0105cde:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
f0105ce1:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
f0105ce4:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
f0105ce7:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
f0105cea:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
f0105ced:	83 c4 30             	add    $0x30,%esp
f0105cf0:	5e                   	pop    %esi
f0105cf1:	5f                   	pop    %edi
f0105cf2:	c9                   	leave  
f0105cf3:	c3                   	ret    
f0105cf4:	0f bd c7             	bsr    %edi,%eax
f0105cf7:	83 f0 1f             	xor    $0x1f,%eax
f0105cfa:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
f0105cfd:	75 61                	jne    f0105d60 <__umoddi3+0x104>
f0105cff:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
f0105d02:	77 05                	ja     f0105d09 <__umoddi3+0xad>
f0105d04:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
f0105d07:	72 10                	jb     f0105d19 <__umoddi3+0xbd>
f0105d09:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
f0105d0c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105d0f:	29 f0                	sub    %esi,%eax
f0105d11:	19 fa                	sbb    %edi,%edx
f0105d13:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
f0105d16:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
f0105d19:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
f0105d1c:	85 d2                	test   %edx,%edx
f0105d1e:	74 a1                	je     f0105cc1 <__umoddi3+0x65>
f0105d20:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105d23:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
f0105d26:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
f0105d29:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
f0105d2c:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
f0105d2f:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
f0105d32:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
f0105d35:	89 01                	mov    %eax,(%ecx)
f0105d37:	89 51 04             	mov    %edx,0x4(%ecx)
f0105d3a:	eb 85                	jmp    f0105cc1 <__umoddi3+0x65>
f0105d3c:	85 f6                	test   %esi,%esi
f0105d3e:	75 0b                	jne    f0105d4b <__umoddi3+0xef>
f0105d40:	b8 01 00 00 00       	mov    $0x1,%eax
f0105d45:	31 d2                	xor    %edx,%edx
f0105d47:	f7 f6                	div    %esi
f0105d49:	89 c6                	mov    %eax,%esi
f0105d4b:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
f0105d4e:	89 fa                	mov    %edi,%edx
f0105d50:	f7 f6                	div    %esi
f0105d52:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105d55:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
f0105d58:	f7 f6                	div    %esi
f0105d5a:	e9 3d ff ff ff       	jmp    f0105c9c <__umoddi3+0x40>
f0105d5f:	90                   	nop    
f0105d60:	b8 20 00 00 00       	mov    $0x20,%eax
f0105d65:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
f0105d68:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
f0105d6b:	89 fa                	mov    %edi,%edx
f0105d6d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
f0105d70:	d3 e2                	shl    %cl,%edx
f0105d72:	89 f0                	mov    %esi,%eax
f0105d74:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
f0105d77:	d3 e8                	shr    %cl,%eax
f0105d79:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
f0105d7c:	d3 e6                	shl    %cl,%esi
f0105d7e:	89 d7                	mov    %edx,%edi
f0105d80:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
f0105d83:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
f0105d86:	09 c7                	or     %eax,%edi
f0105d88:	d3 ea                	shr    %cl,%edx
f0105d8a:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
f0105d8d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
f0105d90:	d3 e0                	shl    %cl,%eax
f0105d92:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
f0105d95:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
f0105d98:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105d9b:	d3 e8                	shr    %cl,%eax
f0105d9d:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
f0105da0:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
f0105da3:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
f0105da6:	f7 f7                	div    %edi
f0105da8:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
f0105dab:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
f0105dae:	f7 e6                	mul    %esi
f0105db0:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
f0105db3:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
f0105db6:	77 0a                	ja     f0105dc2 <__umoddi3+0x166>
f0105db8:	75 12                	jne    f0105dcc <__umoddi3+0x170>
f0105dba:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105dbd:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
f0105dc0:	76 0a                	jbe    f0105dcc <__umoddi3+0x170>
f0105dc2:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
f0105dc5:	29 f1                	sub    %esi,%ecx
f0105dc7:	19 fa                	sbb    %edi,%edx
f0105dc9:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
f0105dcc:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0105dcf:	85 c0                	test   %eax,%eax
f0105dd1:	0f 84 ea fe ff ff    	je     f0105cc1 <__umoddi3+0x65>
f0105dd7:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
f0105dda:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105ddd:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
f0105de0:	19 d1                	sbb    %edx,%ecx
f0105de2:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
f0105de5:	89 ca                	mov    %ecx,%edx
f0105de7:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
f0105dea:	d3 e2                	shl    %cl,%edx
f0105dec:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
f0105def:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
f0105df2:	d3 e8                	shr    %cl,%eax
f0105df4:	09 c2                	or     %eax,%edx
f0105df6:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
f0105df9:	d3 e8                	shr    %cl,%eax
f0105dfb:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
f0105dfe:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
f0105e01:	e9 ad fe ff ff       	jmp    f0105cb3 <__umoddi3+0x57>
