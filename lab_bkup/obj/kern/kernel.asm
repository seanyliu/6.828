
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
f0100058:	e8 3c 4c 00 00       	call   f0104c99 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f010005d:	e8 12 06 00 00       	call   f0100674 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100062:	83 c4 08             	add    $0x8,%esp
f0100065:	68 ac 1a 00 00       	push   $0x1aac
f010006a:	68 20 5e 10 f0       	push   $0xf0105e20
f010006f:	e8 56 30 00 00       	call   f01030ca <cprintf>

	// Lab 2 memory management initialization functions
	i386_detect_memory();
f0100074:	e8 19 0b 00 00       	call   f0100b92 <i386_detect_memory>
	i386_vm_init();
f0100079:	e8 2a 0c 00 00       	call   f0100ca8 <i386_vm_init>

	// Lab 3 user environment initialization functions
	env_init();
f010007e:	e8 b0 28 00 00       	call   f0102933 <env_init>
	idt_init();
f0100083:	e8 8c 30 00 00       	call   f0103114 <idt_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f0100088:	e8 13 2f 00 00       	call   f0102fa0 <pic_init>
	kclock_init();
f010008d:	e8 ca 2e 00 00       	call   f0102f5c <kclock_init>

	time_init();
f0100092:	e8 6d 5a 00 00       	call   f0105b04 <time_init>
	pci_init();
f0100097:	e8 45 5a 00 00       	call   f0105ae1 <pci_init>

	// Should always have an idle process as first one.
	ENV_CREATE(user_idle);
f010009c:	83 c4 08             	add    $0x8,%esp
f010009f:	68 8e 71 01 00       	push   $0x1718e
f01000a4:	68 21 e9 13 f0       	push   $0xf013e921
f01000a9:	e8 3f 2c 00 00       	call   f0102ced <env_create>

	// Start fs.
	ENV_CREATE(fs_fs);
f01000ae:	83 c4 08             	add    $0x8,%esp
f01000b1:	68 fd 17 02 00       	push   $0x217fd
f01000b6:	68 7a 06 25 f0       	push   $0xf025067a
f01000bb:	e8 2d 2c 00 00       	call   f0102ced <env_create>

	// Start ns.
	ENV_CREATE(net_ns);	
f01000c0:	83 c4 08             	add    $0x8,%esp
f01000c3:	68 84 57 05 00       	push   $0x55784
f01000c8:	68 d9 01 2a f0       	push   $0xf02a01d9
f01000cd:	e8 1b 2c 00 00       	call   f0102ced <env_create>

	// Start init
#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE2(TEST, TESTSIZE);
#else
	// Touch all you want.
	ENV_CREATE(user_icode);
f01000d2:	83 c4 08             	add    $0x8,%esp
f01000d5:	68 2d 92 01 00       	push   $0x1922d
f01000da:	68 f4 56 12 f0       	push   $0xf01256f4
f01000df:	e8 09 2c 00 00       	call   f0102ced <env_create>
	// ENV_CREATE(user_pipereadeof);
	// ENV_CREATE(user_pipewriteeof);

	// Should not be necessary - drain keyboard because interrupt has given up.
	kbd_intr();
f01000e4:	e8 ae 04 00 00       	call   f0100597 <kbd_intr>


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
f01000e9:	e8 b6 36 00 00       	call   f01037a4 <sched_yield>

f01000ee <_panic>:


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
f01000ee:	55                   	push   %ebp
f01000ef:	89 e5                	mov    %esp,%ebp
f01000f1:	53                   	push   %ebx
f01000f2:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	if (panicstr)
f01000f5:	83 3d 60 59 2f f0 00 	cmpl   $0x0,0xf02f5960
f01000fc:	75 39                	jne    f0100137 <_panic+0x49>
		goto dead;
	panicstr = fmt;
f01000fe:	8b 45 10             	mov    0x10(%ebp),%eax
f0100101:	a3 60 59 2f f0       	mov    %eax,0xf02f5960

	va_start(ap, fmt);
f0100106:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic at %s:%d: ", file, line);
f0100109:	83 ec 04             	sub    $0x4,%esp
f010010c:	ff 75 0c             	pushl  0xc(%ebp)
f010010f:	ff 75 08             	pushl  0x8(%ebp)
f0100112:	68 3b 5e 10 f0       	push   $0xf0105e3b
f0100117:	e8 ae 2f 00 00       	call   f01030ca <cprintf>
	vcprintf(fmt, ap);
f010011c:	83 c4 08             	add    $0x8,%esp
f010011f:	53                   	push   %ebx
f0100120:	ff 75 10             	pushl  0x10(%ebp)
f0100123:	e8 7c 2f 00 00       	call   f01030a4 <vcprintf>
	cprintf("\n");
f0100128:	c7 04 24 bd 5f 10 f0 	movl   $0xf0105fbd,(%esp)
f010012f:	e8 96 2f 00 00       	call   f01030ca <cprintf>
	va_end(ap);
f0100134:	83 c4 10             	add    $0x10,%esp

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100137:	83 ec 0c             	sub    $0xc,%esp
f010013a:	6a 00                	push   $0x0
f010013c:	e8 bf 09 00 00       	call   f0100b00 <monitor>
f0100141:	83 c4 10             	add    $0x10,%esp
f0100144:	eb f1                	jmp    f0100137 <_panic+0x49>

f0100146 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100146:	55                   	push   %ebp
f0100147:	89 e5                	mov    %esp,%ebp
f0100149:	53                   	push   %ebx
f010014a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f010014d:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f0100150:	ff 75 0c             	pushl  0xc(%ebp)
f0100153:	ff 75 08             	pushl  0x8(%ebp)
f0100156:	68 53 5e 10 f0       	push   $0xf0105e53
f010015b:	e8 6a 2f 00 00       	call   f01030ca <cprintf>
	vcprintf(fmt, ap);
f0100160:	83 c4 08             	add    $0x8,%esp
f0100163:	53                   	push   %ebx
f0100164:	ff 75 10             	pushl  0x10(%ebp)
f0100167:	e8 38 2f 00 00       	call   f01030a4 <vcprintf>
	cprintf("\n");
f010016c:	c7 04 24 bd 5f 10 f0 	movl   $0xf0105fbd,(%esp)
f0100173:	e8 52 2f 00 00       	call   f01030ca <cprintf>
	va_end(ap);
}
f0100178:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f010017b:	c9                   	leave  
f010017c:	c3                   	ret    
f010017d:	00 00                	add    %al,(%eax)
	...

f0100180 <delay>:

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f0100180:	55                   	push   %ebp
f0100181:	89 e5                	mov    %esp,%ebp
}

static __inline uint8_t
inb(int port)
{
f0100183:	ba 84 00 00 00       	mov    $0x84,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100188:	ec                   	in     (%dx),%al
f0100189:	ec                   	in     (%dx),%al
f010018a:	ec                   	in     (%dx),%al
f010018b:	ec                   	in     (%dx),%al
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
f010018c:	c9                   	leave  
f010018d:	c3                   	ret    

f010018e <serial_proc_data>:

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
f010018e:	55                   	push   %ebp
f010018f:	89 e5                	mov    %esp,%ebp
}

static __inline uint8_t
inb(int port)
{
f0100191:	ba fd 03 00 00       	mov    $0x3fd,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100196:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
f0100197:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}

static __inline uint8_t
inb(int port)
{
f010019c:	a8 01                	test   $0x1,%al
f010019e:	74 09                	je     f01001a9 <serial_proc_data+0x1b>
f01001a0:	ba f8 03 00 00       	mov    $0x3f8,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01001a5:	ec                   	in     (%dx),%al
f01001a6:	0f b6 d0             	movzbl %al,%edx
	return inb(COM1+COM_RX);
}
f01001a9:	89 d0                	mov    %edx,%eax
f01001ab:	c9                   	leave  
f01001ac:	c3                   	ret    

f01001ad <serial_intr>:

void
serial_intr(void)
{
f01001ad:	55                   	push   %ebp
f01001ae:	89 e5                	mov    %esp,%ebp
f01001b0:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
f01001b3:	83 3d 84 59 2f f0 00 	cmpl   $0x0,0xf02f5984
f01001ba:	74 10                	je     f01001cc <serial_intr+0x1f>
		cons_intr(serial_proc_data);
f01001bc:	83 ec 0c             	sub    $0xc,%esp
f01001bf:	68 8e 01 10 f0       	push   $0xf010018e
f01001c4:	e8 02 04 00 00       	call   f01005cb <cons_intr>
f01001c9:	83 c4 10             	add    $0x10,%esp
}
f01001cc:	c9                   	leave  
f01001cd:	c3                   	ret    

f01001ce <serial_putc>:

static void
serial_putc(int c)
{
f01001ce:	55                   	push   %ebp
f01001cf:	89 e5                	mov    %esp,%ebp
f01001d1:	56                   	push   %esi
f01001d2:	53                   	push   %ebx
	int i;
	
	for (i = 0;
f01001d3:	bb 00 00 00 00       	mov    $0x0,%ebx
}

static __inline uint8_t
inb(int port)
{
f01001d8:	ba fd 03 00 00       	mov    $0x3fd,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01001dd:	ec                   	in     (%dx),%al
f01001de:	a8 20                	test   $0x20,%al
f01001e0:	75 1a                	jne    f01001fc <serial_putc+0x2e>
f01001e2:	be fd 03 00 00       	mov    $0x3fd,%esi
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
f01001e7:	e8 94 ff ff ff       	call   f0100180 <delay>
f01001ec:	43                   	inc    %ebx
static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01001ed:	89 f2                	mov    %esi,%edx
f01001ef:	ec                   	in     (%dx),%al
f01001f0:	a8 20                	test   $0x20,%al
f01001f2:	75 08                	jne    f01001fc <serial_putc+0x2e>
f01001f4:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f01001fa:	7e eb                	jle    f01001e7 <serial_putc+0x19>
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
f01001fc:	ba f8 03 00 00       	mov    $0x3f8,%edx
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100201:	8a 45 08             	mov    0x8(%ebp),%al
f0100204:	ee                   	out    %al,(%dx)
	
	outb(COM1 + COM_TX, c);
}
f0100205:	5b                   	pop    %ebx
f0100206:	5e                   	pop    %esi
f0100207:	c9                   	leave  
f0100208:	c3                   	ret    

f0100209 <serial_init>:

static void
serial_init(void)
{
f0100209:	55                   	push   %ebp
f010020a:	89 e5                	mov    %esp,%ebp
f010020c:	53                   	push   %ebx
f010020d:	83 ec 04             	sub    $0x4,%esp
}

static __inline void
outb(int port, uint8_t data)
{
f0100210:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f0100215:	b0 00                	mov    $0x0,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100217:	89 da                	mov    %ebx,%edx
f0100219:	ee                   	out    %al,(%dx)
f010021a:	b2 fb                	mov    $0xfb,%dl
f010021c:	b0 80                	mov    $0x80,%al
f010021e:	ee                   	out    %al,(%dx)
f010021f:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
f0100224:	b0 0c                	mov    $0xc,%al
f0100226:	89 ca                	mov    %ecx,%edx
f0100228:	ee                   	out    %al,(%dx)
f0100229:	b2 f9                	mov    $0xf9,%dl
f010022b:	b0 00                	mov    $0x0,%al
f010022d:	ee                   	out    %al,(%dx)
f010022e:	b2 fb                	mov    $0xfb,%dl
f0100230:	b0 03                	mov    $0x3,%al
f0100232:	ee                   	out    %al,(%dx)
f0100233:	b2 fc                	mov    $0xfc,%dl
f0100235:	b0 00                	mov    $0x0,%al
f0100237:	ee                   	out    %al,(%dx)
f0100238:	b2 f9                	mov    $0xf9,%dl
f010023a:	b0 01                	mov    $0x1,%al
f010023c:	ee                   	out    %al,(%dx)
f010023d:	b2 fd                	mov    $0xfd,%dl
f010023f:	ec                   	in     (%dx),%al
f0100240:	3c ff                	cmp    $0xff,%al
f0100242:	0f 95 c0             	setne  %al
f0100245:	0f b6 c0             	movzbl %al,%eax
f0100248:	a3 84 59 2f f0       	mov    %eax,0xf02f5984
f010024d:	89 da                	mov    %ebx,%edx
f010024f:	ec                   	in     (%dx),%al
f0100250:	89 ca                	mov    %ecx,%edx
f0100252:	ec                   	in     (%dx),%al
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
f0100253:	83 3d 84 59 2f f0 00 	cmpl   $0x0,0xf02f5984
f010025a:	74 18                	je     f0100274 <serial_init+0x6b>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f010025c:	83 ec 0c             	sub    $0xc,%esp
f010025f:	0f b7 05 d8 55 12 f0 	movzwl 0xf01255d8,%eax
f0100266:	25 ef ff 00 00       	and    $0xffef,%eax
f010026b:	50                   	push   %eax
f010026c:	e8 99 2d 00 00       	call   f010300a <irq_setmask_8259A>
f0100271:	83 c4 10             	add    $0x10,%esp
}
f0100274:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100277:	c9                   	leave  
f0100278:	c3                   	ret    

f0100279 <lpt_putc>:



/***** Parallel port output code *****/
// For information on PC parallel port programming, see the class References
// page.

static void
lpt_putc(int c)
{
f0100279:	55                   	push   %ebp
f010027a:	89 e5                	mov    %esp,%ebp
f010027c:	56                   	push   %esi
f010027d:	53                   	push   %ebx
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f010027e:	bb 00 00 00 00       	mov    $0x0,%ebx
}

static __inline uint8_t
inb(int port)
{
f0100283:	ba 79 03 00 00       	mov    $0x379,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100288:	ec                   	in     (%dx),%al
f0100289:	84 c0                	test   %al,%al
f010028b:	78 1a                	js     f01002a7 <lpt_putc+0x2e>
f010028d:	be 79 03 00 00       	mov    $0x379,%esi
		delay();
f0100292:	e8 e9 fe ff ff       	call   f0100180 <delay>
f0100297:	43                   	inc    %ebx
static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100298:	89 f2                	mov    %esi,%edx
f010029a:	ec                   	in     (%dx),%al
f010029b:	84 c0                	test   %al,%al
f010029d:	78 08                	js     f01002a7 <lpt_putc+0x2e>
f010029f:	81 fb ff 31 00 00    	cmp    $0x31ff,%ebx
f01002a5:	7e eb                	jle    f0100292 <lpt_putc+0x19>
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
f01002a7:	ba 78 03 00 00       	mov    $0x378,%edx
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002ac:	8a 45 08             	mov    0x8(%ebp),%al
f01002af:	ee                   	out    %al,(%dx)
f01002b0:	b2 7a                	mov    $0x7a,%dl
f01002b2:	b0 0d                	mov    $0xd,%al
f01002b4:	ee                   	out    %al,(%dx)
f01002b5:	b0 08                	mov    $0x8,%al
f01002b7:	ee                   	out    %al,(%dx)
	outb(0x378+0, c);
	outb(0x378+2, 0x08|0x04|0x01);
	outb(0x378+2, 0x08);
}
f01002b8:	5b                   	pop    %ebx
f01002b9:	5e                   	pop    %esi
f01002ba:	c9                   	leave  
f01002bb:	c3                   	ret    

f01002bc <cga_init>:




/***** Text-mode CGA/VGA display output *****/

static unsigned addr_6845;
static uint16_t *crt_buf;
static uint16_t crt_pos;

static void
cga_init(void)
{
f01002bc:	55                   	push   %ebp
f01002bd:	89 e5                	mov    %esp,%ebp
f01002bf:	57                   	push   %edi
f01002c0:	56                   	push   %esi
f01002c1:	53                   	push   %ebx
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01002c2:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
	was = *cp;
f01002c7:	66 8b 15 00 80 0b f0 	mov    0xf00b8000,%dx
	*cp = (uint16_t) 0xA55A;
f01002ce:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01002d5:	5a a5 
	if (*cp != 0xA55A) {
f01002d7:	66 a1 00 80 0b f0    	mov    0xf00b8000,%ax
f01002dd:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01002e1:	74 10                	je     f01002f3 <cga_init+0x37>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01002e3:	66 be 00 00          	mov    $0x0,%si
		addr_6845 = MONO_BASE;
f01002e7:	c7 05 88 59 2f f0 b4 	movl   $0x3b4,0xf02f5988
f01002ee:	03 00 00 
f01002f1:	eb 0d                	jmp    f0100300 <cga_init+0x44>
	} else {
		*cp = was;
f01002f3:	66 89 16             	mov    %dx,(%esi)
		addr_6845 = CGA_BASE;
f01002f6:	c7 05 88 59 2f f0 d4 	movl   $0x3d4,0xf02f5988
f01002fd:	03 00 00 
}

static __inline void
outb(int port, uint8_t data)
{
f0100300:	8b 0d 88 59 2f f0    	mov    0xf02f5988,%ecx
f0100306:	b0 0e                	mov    $0xe,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100308:	89 ca                	mov    %ecx,%edx
f010030a:	ee                   	out    %al,(%dx)
f010030b:	8d 79 01             	lea    0x1(%ecx),%edi
f010030e:	89 fa                	mov    %edi,%edx
f0100310:	ec                   	in     (%dx),%al
f0100311:	0f b6 d8             	movzbl %al,%ebx
f0100314:	c1 e3 08             	shl    $0x8,%ebx
f0100317:	b0 0f                	mov    $0xf,%al
f0100319:	89 ca                	mov    %ecx,%edx
f010031b:	ee                   	out    %al,(%dx)
f010031c:	89 fa                	mov    %edi,%edx
f010031e:	ec                   	in     (%dx),%al
f010031f:	0f b6 c0             	movzbl %al,%eax
f0100322:	09 c3                	or     %eax,%ebx
	}
	
	/* Extract cursor location */
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f0100324:	89 35 8c 59 2f f0    	mov    %esi,0xf02f598c
	crt_pos = pos;
f010032a:	66 89 1d 90 59 2f f0 	mov    %bx,0xf02f5990
}
f0100331:	5b                   	pop    %ebx
f0100332:	5e                   	pop    %esi
f0100333:	5f                   	pop    %edi
f0100334:	c9                   	leave  
f0100335:	c3                   	ret    

f0100336 <cga_putc>:



static void
cga_putc(int c)
{
f0100336:	55                   	push   %ebp
f0100337:	89 e5                	mov    %esp,%ebp
f0100339:	56                   	push   %esi
f010033a:	53                   	push   %ebx
f010033b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f010033e:	f7 c1 00 ff ff ff    	test   $0xffffff00,%ecx
f0100344:	75 03                	jne    f0100349 <cga_putc+0x13>
		c |= 0x0700;
f0100346:	80 cd 07             	or     $0x7,%ch

	switch (c & 0xff) {
f0100349:	0f b6 c1             	movzbl %cl,%eax
f010034c:	83 f8 09             	cmp    $0x9,%eax
f010034f:	74 7b                	je     f01003cc <cga_putc+0x96>
f0100351:	83 f8 09             	cmp    $0x9,%eax
f0100354:	7f 0a                	jg     f0100360 <cga_putc+0x2a>
f0100356:	83 f8 08             	cmp    $0x8,%eax
f0100359:	74 14                	je     f010036f <cga_putc+0x39>
f010035b:	e9 ab 00 00 00       	jmp    f010040b <cga_putc+0xd5>
f0100360:	83 f8 0a             	cmp    $0xa,%eax
f0100363:	74 3c                	je     f01003a1 <cga_putc+0x6b>
f0100365:	83 f8 0d             	cmp    $0xd,%eax
f0100368:	74 3f                	je     f01003a9 <cga_putc+0x73>
f010036a:	e9 9c 00 00 00       	jmp    f010040b <cga_putc+0xd5>
	case '\b':
		if (crt_pos > 0) {
f010036f:	66 83 3d 90 59 2f f0 	cmpw   $0x0,0xf02f5990
f0100376:	00 
f0100377:	0f 84 a5 00 00 00    	je     f0100422 <cga_putc+0xec>
			crt_pos--;
f010037d:	66 ff 0d 90 59 2f f0 	decw   0xf02f5990
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100384:	0f b7 05 90 59 2f f0 	movzwl 0xf02f5990,%eax
f010038b:	89 ca                	mov    %ecx,%edx
f010038d:	b2 00                	mov    $0x0,%dl
f010038f:	83 ca 20             	or     $0x20,%edx
f0100392:	8b 0d 8c 59 2f f0    	mov    0xf02f598c,%ecx
f0100398:	66 89 14 41          	mov    %dx,(%ecx,%eax,2)
		}
		break;
f010039c:	e9 81 00 00 00       	jmp    f0100422 <cga_putc+0xec>
	case '\n':
		crt_pos += CRT_COLS;
f01003a1:	66 83 05 90 59 2f f0 	addw   $0x50,0xf02f5990
f01003a8:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f01003a9:	66 8b 1d 90 59 2f f0 	mov    0xf02f5990,%bx
f01003b0:	b9 50 00 00 00       	mov    $0x50,%ecx
f01003b5:	ba 00 00 00 00       	mov    $0x0,%edx
f01003ba:	89 d8                	mov    %ebx,%eax
f01003bc:	66 f7 f1             	div    %cx
f01003bf:	89 d8                	mov    %ebx,%eax
f01003c1:	66 29 d0             	sub    %dx,%ax
f01003c4:	66 a3 90 59 2f f0    	mov    %ax,0xf02f5990
		break;
f01003ca:	eb 56                	jmp    f0100422 <cga_putc+0xec>
	case '\t':
		cons_putc(' ');
f01003cc:	83 ec 0c             	sub    $0xc,%esp
f01003cf:	6a 20                	push   $0x20
f01003d1:	e8 7a 02 00 00       	call   f0100650 <cons_putc>
		cons_putc(' ');
f01003d6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01003dd:	e8 6e 02 00 00       	call   f0100650 <cons_putc>
		cons_putc(' ');
f01003e2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01003e9:	e8 62 02 00 00       	call   f0100650 <cons_putc>
		cons_putc(' ');
f01003ee:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f01003f5:	e8 56 02 00 00       	call   f0100650 <cons_putc>
		cons_putc(' ');
f01003fa:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0100401:	e8 4a 02 00 00       	call   f0100650 <cons_putc>
		break;
f0100406:	83 c4 10             	add    $0x10,%esp
f0100409:	eb 17                	jmp    f0100422 <cga_putc+0xec>
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f010040b:	0f b7 15 90 59 2f f0 	movzwl 0xf02f5990,%edx
f0100412:	a1 8c 59 2f f0       	mov    0xf02f598c,%eax
f0100417:	66 89 0c 50          	mov    %cx,(%eax,%edx,2)
f010041b:	66 ff 05 90 59 2f f0 	incw   0xf02f5990
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f0100422:	66 81 3d 90 59 2f f0 	cmpw   $0x7cf,0xf02f5990
f0100429:	cf 07 
f010042b:	76 3f                	jbe    f010046c <cga_putc+0x136>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f010042d:	83 ec 04             	sub    $0x4,%esp
f0100430:	68 00 0f 00 00       	push   $0xf00
f0100435:	8b 15 8c 59 2f f0    	mov    0xf02f598c,%edx
f010043b:	8d 82 a0 00 00 00    	lea    0xa0(%edx),%eax
f0100441:	50                   	push   %eax
f0100442:	52                   	push   %edx
f0100443:	e8 a4 48 00 00       	call   f0104cec <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100448:	ba 80 07 00 00       	mov    $0x780,%edx
f010044d:	83 c4 10             	add    $0x10,%esp
			crt_buf[i] = 0x0700 | ' ';
f0100450:	a1 8c 59 2f f0       	mov    0xf02f598c,%eax
f0100455:	66 c7 04 50 20 07    	movw   $0x720,(%eax,%edx,2)
f010045b:	42                   	inc    %edx
f010045c:	81 fa cf 07 00 00    	cmp    $0x7cf,%edx
f0100462:	7e ec                	jle    f0100450 <cga_putc+0x11a>
		crt_pos -= CRT_COLS;
f0100464:	66 83 2d 90 59 2f f0 	subw   $0x50,0xf02f5990
f010046b:	50 
}

static __inline void
outb(int port, uint8_t data)
{
f010046c:	8b 1d 88 59 2f f0    	mov    0xf02f5988,%ebx
f0100472:	b0 0e                	mov    $0xe,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100474:	89 da                	mov    %ebx,%edx
f0100476:	ee                   	out    %al,(%dx)
f0100477:	8d 73 01             	lea    0x1(%ebx),%esi
f010047a:	66 8b 0d 90 59 2f f0 	mov    0xf02f5990,%cx
f0100481:	89 c8                	mov    %ecx,%eax
f0100483:	66 c1 e8 08          	shr    $0x8,%ax
f0100487:	89 f2                	mov    %esi,%edx
f0100489:	ee                   	out    %al,(%dx)
f010048a:	b0 0f                	mov    $0xf,%al
f010048c:	89 da                	mov    %ebx,%edx
f010048e:	ee                   	out    %al,(%dx)
f010048f:	88 c8                	mov    %cl,%al
f0100491:	89 f2                	mov    %esi,%edx
f0100493:	ee                   	out    %al,(%dx)
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
	outb(addr_6845 + 1, crt_pos >> 8);
	outb(addr_6845, 15);
	outb(addr_6845 + 1, crt_pos);
}
f0100494:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0100497:	5b                   	pop    %ebx
f0100498:	5e                   	pop    %esi
f0100499:	c9                   	leave  
f010049a:	c3                   	ret    

f010049b <kbd_proc_data>:


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
f010049b:	55                   	push   %ebp
f010049c:	89 e5                	mov    %esp,%ebp
f010049e:	53                   	push   %ebx
f010049f:	83 ec 04             	sub    $0x4,%esp
}

static __inline uint8_t
inb(int port)
{
f01004a2:	ba 64 00 00 00       	mov    $0x64,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004a7:	ec                   	in     (%dx),%al
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
f01004a8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
}

static __inline uint8_t
inb(int port)
{
f01004ad:	a8 01                	test   $0x1,%al
f01004af:	0f 84 db 00 00 00    	je     f0100590 <kbd_proc_data+0xf5>
f01004b5:	ba 60 00 00 00       	mov    $0x60,%edx
f01004ba:	ec                   	in     (%dx),%al
f01004bb:	88 c2                	mov    %al,%dl

	data = inb(KBDATAP);

	if (data == 0xE0) {
f01004bd:	3c e0                	cmp    $0xe0,%al
f01004bf:	75 11                	jne    f01004d2 <kbd_proc_data+0x37>
		// E0 escape character
		shift |= E0ESC;
f01004c1:	83 0d 80 59 2f f0 40 	orl    $0x40,0xf02f5980
		return 0;
f01004c8:	ba 00 00 00 00       	mov    $0x0,%edx
f01004cd:	e9 be 00 00 00       	jmp    f0100590 <kbd_proc_data+0xf5>
	} else if (data & 0x80) {
f01004d2:	84 c0                	test   %al,%al
f01004d4:	79 2d                	jns    f0100503 <kbd_proc_data+0x68>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f01004d6:	f6 05 80 59 2f f0 40 	testb  $0x40,0xf02f5980
f01004dd:	75 03                	jne    f01004e2 <kbd_proc_data+0x47>
f01004df:	83 e2 7f             	and    $0x7f,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01004e2:	0f b6 c2             	movzbl %dl,%eax
f01004e5:	8a 80 20 50 12 f0    	mov    0xf0125020(%eax),%al
f01004eb:	83 c8 40             	or     $0x40,%eax
f01004ee:	0f b6 c0             	movzbl %al,%eax
f01004f1:	f7 d0                	not    %eax
f01004f3:	21 05 80 59 2f f0    	and    %eax,0xf02f5980
		return 0;
f01004f9:	ba 00 00 00 00       	mov    $0x0,%edx
f01004fe:	e9 8d 00 00 00       	jmp    f0100590 <kbd_proc_data+0xf5>
	} else if (shift & E0ESC) {
f0100503:	a1 80 59 2f f0       	mov    0xf02f5980,%eax
f0100508:	a8 40                	test   $0x40,%al
f010050a:	74 0b                	je     f0100517 <kbd_proc_data+0x7c>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f010050c:	83 ca 80             	or     $0xffffff80,%edx
		shift &= ~E0ESC;
f010050f:	83 e0 bf             	and    $0xffffffbf,%eax
f0100512:	a3 80 59 2f f0       	mov    %eax,0xf02f5980
	}

	shift |= shiftcode[data];
f0100517:	0f b6 ca             	movzbl %dl,%ecx
f010051a:	0f b6 81 20 50 12 f0 	movzbl 0xf0125020(%ecx),%eax
f0100521:	0b 05 80 59 2f f0    	or     0xf02f5980,%eax
	shift ^= togglecode[data];
f0100527:	0f b6 91 20 51 12 f0 	movzbl 0xf0125120(%ecx),%edx
f010052e:	31 c2                	xor    %eax,%edx
f0100530:	89 15 80 59 2f f0    	mov    %edx,0xf02f5980

	c = charcode[shift & (CTL | SHIFT)][data];
f0100536:	89 d0                	mov    %edx,%eax
f0100538:	83 e0 03             	and    $0x3,%eax
f010053b:	8b 04 85 20 55 12 f0 	mov    0xf0125520(,%eax,4),%eax
f0100542:	0f b6 1c 08          	movzbl (%eax,%ecx,1),%ebx
	if (shift & CAPSLOCK) {
f0100546:	f6 c2 08             	test   $0x8,%dl
f0100549:	74 18                	je     f0100563 <kbd_proc_data+0xc8>
		if ('a' <= c && c <= 'z')
f010054b:	8d 43 9f             	lea    0xffffff9f(%ebx),%eax
f010054e:	83 f8 19             	cmp    $0x19,%eax
f0100551:	77 05                	ja     f0100558 <kbd_proc_data+0xbd>
			c += 'A' - 'a';
f0100553:	83 eb 20             	sub    $0x20,%ebx
f0100556:	eb 0b                	jmp    f0100563 <kbd_proc_data+0xc8>
		else if ('A' <= c && c <= 'Z')
f0100558:	8d 43 bf             	lea    0xffffffbf(%ebx),%eax
f010055b:	83 f8 19             	cmp    $0x19,%eax
f010055e:	77 03                	ja     f0100563 <kbd_proc_data+0xc8>
			c += 'a' - 'A';
f0100560:	83 c3 20             	add    $0x20,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100563:	a1 80 59 2f f0       	mov    0xf02f5980,%eax
f0100568:	f7 d0                	not    %eax
f010056a:	a8 06                	test   $0x6,%al
f010056c:	75 20                	jne    f010058e <kbd_proc_data+0xf3>
f010056e:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100574:	75 18                	jne    f010058e <kbd_proc_data+0xf3>
		cprintf("Rebooting!\n");
f0100576:	83 ec 0c             	sub    $0xc,%esp
f0100579:	68 6d 5e 10 f0       	push   $0xf0105e6d
f010057e:	e8 47 2b 00 00       	call   f01030ca <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
f0100583:	83 c4 10             	add    $0x10,%esp
f0100586:	ba 92 00 00 00       	mov    $0x92,%edx
f010058b:	b0 03                	mov    $0x3,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010058d:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f010058e:	89 da                	mov    %ebx,%edx
}
f0100590:	89 d0                	mov    %edx,%eax
f0100592:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100595:	c9                   	leave  
f0100596:	c3                   	ret    

f0100597 <kbd_intr>:

void
kbd_intr(void)
{
f0100597:	55                   	push   %ebp
f0100598:	89 e5                	mov    %esp,%ebp
f010059a:	83 ec 14             	sub    $0x14,%esp
	cons_intr(kbd_proc_data);
f010059d:	68 9b 04 10 f0       	push   $0xf010049b
f01005a2:	e8 24 00 00 00       	call   f01005cb <cons_intr>
}
f01005a7:	c9                   	leave  
f01005a8:	c3                   	ret    

f01005a9 <kbd_init>:

static void
kbd_init(void)
{
f01005a9:	55                   	push   %ebp
f01005aa:	89 e5                	mov    %esp,%ebp
f01005ac:	83 ec 08             	sub    $0x8,%esp
	// Drain the kbd buffer so that Bochs generates interrupts.
	kbd_intr();
f01005af:	e8 e3 ff ff ff       	call   f0100597 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f01005b4:	83 ec 0c             	sub    $0xc,%esp
f01005b7:	0f b7 05 d8 55 12 f0 	movzwl 0xf01255d8,%eax
f01005be:	25 fd ff 00 00       	and    $0xfffd,%eax
f01005c3:	50                   	push   %eax
f01005c4:	e8 41 2a 00 00       	call   f010300a <irq_setmask_8259A>
}
f01005c9:	c9                   	leave  
f01005ca:	c3                   	ret    

f01005cb <cons_intr>:



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
f01005cb:	55                   	push   %ebp
f01005cc:	89 e5                	mov    %esp,%ebp
f01005ce:	53                   	push   %ebx
f01005cf:	83 ec 04             	sub    $0x4,%esp
f01005d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f01005d5:	eb 26                	jmp    f01005fd <cons_intr+0x32>
		if (c == 0)
f01005d7:	85 d2                	test   %edx,%edx
f01005d9:	74 22                	je     f01005fd <cons_intr+0x32>
			continue;
		cons.buf[cons.wpos++] = c;
f01005db:	a1 a4 5b 2f f0       	mov    0xf02f5ba4,%eax
f01005e0:	88 90 a0 59 2f f0    	mov    %dl,0xf02f59a0(%eax)
f01005e6:	40                   	inc    %eax
f01005e7:	a3 a4 5b 2f f0       	mov    %eax,0xf02f5ba4
		if (cons.wpos == CONSBUFSIZE)
f01005ec:	3d 00 02 00 00       	cmp    $0x200,%eax
f01005f1:	75 0a                	jne    f01005fd <cons_intr+0x32>
			cons.wpos = 0;
f01005f3:	c7 05 a4 5b 2f f0 00 	movl   $0x0,0xf02f5ba4
f01005fa:	00 00 00 
f01005fd:	ff d3                	call   *%ebx
f01005ff:	89 c2                	mov    %eax,%edx
f0100601:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100604:	75 d1                	jne    f01005d7 <cons_intr+0xc>
	}
}
f0100606:	83 c4 04             	add    $0x4,%esp
f0100609:	5b                   	pop    %ebx
f010060a:	c9                   	leave  
f010060b:	c3                   	ret    

f010060c <cons_getc>:

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f010060c:	55                   	push   %ebp
f010060d:	89 e5                	mov    %esp,%ebp
f010060f:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f0100612:	e8 96 fb ff ff       	call   f01001ad <serial_intr>
	kbd_intr();
f0100617:	e8 7b ff ff ff       	call   f0100597 <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f010061c:	a1 a0 5b 2f f0       	mov    0xf02f5ba0,%eax
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
	}
	return 0;
f0100621:	ba 00 00 00 00       	mov    $0x0,%edx
f0100626:	3b 05 a4 5b 2f f0    	cmp    0xf02f5ba4,%eax
f010062c:	74 1e                	je     f010064c <cons_getc+0x40>
f010062e:	0f b6 90 a0 59 2f f0 	movzbl 0xf02f59a0(%eax),%edx
f0100635:	40                   	inc    %eax
f0100636:	a3 a0 5b 2f f0       	mov    %eax,0xf02f5ba0
f010063b:	3d 00 02 00 00       	cmp    $0x200,%eax
f0100640:	75 0a                	jne    f010064c <cons_getc+0x40>
f0100642:	c7 05 a0 5b 2f f0 00 	movl   $0x0,0xf02f5ba0
f0100649:	00 00 00 
}
f010064c:	89 d0                	mov    %edx,%eax
f010064e:	c9                   	leave  
f010064f:	c3                   	ret    

f0100650 <cons_putc>:

// output a character to the console
static void
cons_putc(int c)
{
f0100650:	55                   	push   %ebp
f0100651:	89 e5                	mov    %esp,%ebp
f0100653:	53                   	push   %ebx
f0100654:	83 ec 04             	sub    $0x4,%esp
f0100657:	8b 5d 08             	mov    0x8(%ebp),%ebx
	serial_putc(c);
f010065a:	53                   	push   %ebx
f010065b:	e8 6e fb ff ff       	call   f01001ce <serial_putc>
	lpt_putc(c);
f0100660:	53                   	push   %ebx
f0100661:	e8 13 fc ff ff       	call   f0100279 <lpt_putc>
	cga_putc(c);
f0100666:	83 ec 04             	sub    $0x4,%esp
f0100669:	53                   	push   %ebx
f010066a:	e8 c7 fc ff ff       	call   f0100336 <cga_putc>
}
f010066f:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100672:	c9                   	leave  
f0100673:	c3                   	ret    

f0100674 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100674:	55                   	push   %ebp
f0100675:	89 e5                	mov    %esp,%ebp
f0100677:	83 ec 08             	sub    $0x8,%esp
	cga_init();
f010067a:	e8 3d fc ff ff       	call   f01002bc <cga_init>
	kbd_init();
f010067f:	e8 25 ff ff ff       	call   f01005a9 <kbd_init>
	serial_init();
f0100684:	e8 80 fb ff ff       	call   f0100209 <serial_init>

	if (!serial_exists)
f0100689:	83 3d 84 59 2f f0 00 	cmpl   $0x0,0xf02f5984
f0100690:	75 10                	jne    f01006a2 <cons_init+0x2e>
		cprintf("Serial port does not exist!\n");
f0100692:	83 ec 0c             	sub    $0xc,%esp
f0100695:	68 79 5e 10 f0       	push   $0xf0105e79
f010069a:	e8 2b 2a 00 00       	call   f01030ca <cprintf>
f010069f:	83 c4 10             	add    $0x10,%esp
}
f01006a2:	c9                   	leave  
f01006a3:	c3                   	ret    

f01006a4 <cputchar>:


// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01006a4:	55                   	push   %ebp
f01006a5:	89 e5                	mov    %esp,%ebp
f01006a7:	83 ec 14             	sub    $0x14,%esp
	cons_putc(c);
f01006aa:	ff 75 08             	pushl  0x8(%ebp)
f01006ad:	e8 9e ff ff ff       	call   f0100650 <cons_putc>
}
f01006b2:	c9                   	leave  
f01006b3:	c3                   	ret    

f01006b4 <getchar>:

int
getchar(void)
{
f01006b4:	55                   	push   %ebp
f01006b5:	89 e5                	mov    %esp,%ebp
f01006b7:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01006ba:	e8 4d ff ff ff       	call   f010060c <cons_getc>
f01006bf:	85 c0                	test   %eax,%eax
f01006c1:	74 f7                	je     f01006ba <getchar+0x6>
		/* do nothing */;
	return c;
}
f01006c3:	c9                   	leave  
f01006c4:	c3                   	ret    

f01006c5 <iscons>:

int
iscons(int fdnum)
{
f01006c5:	55                   	push   %ebp
f01006c6:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f01006c8:	b8 01 00 00 00       	mov    $0x1,%eax
f01006cd:	c9                   	leave  
f01006ce:	c3                   	ret    
	...

f01006d0 <mon_hex_to_int>:
// lab 2 challenge

int
mon_hex_to_int(int argc, char **argv, struct Trapframe *tf)
{
f01006d0:	55                   	push   %ebp
f01006d1:	89 e5                	mov    %esp,%ebp
f01006d3:	53                   	push   %ebx
f01006d4:	83 ec 10             	sub    $0x10,%esp
f01006d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char* paddr_string = argv[1];
  int disp_int = strtoint(paddr_string);
f01006da:	ff 73 04             	pushl  0x4(%ebx)
f01006dd:	e8 52 43 00 00       	call   f0104a34 <strtoint>

  if (disp_int == -1) {
f01006e2:	83 c4 10             	add    $0x10,%esp
f01006e5:	83 f8 ff             	cmp    $0xffffffff,%eax
f01006e8:	75 12                	jne    f01006fc <mon_hex_to_int+0x2c>
    cprintf("Error: invalid hex address.\n");
f01006ea:	83 ec 0c             	sub    $0xc,%esp
f01006ed:	68 48 5f 10 f0       	push   $0xf0105f48
f01006f2:	e8 d3 29 00 00       	call   f01030ca <cprintf>
f01006f7:	83 c4 10             	add    $0x10,%esp
f01006fa:	eb 14                	jmp    f0100710 <mon_hex_to_int+0x40>
  } else {
    cprintf("Hex %s = int %d\n", argv[1], disp_int);
f01006fc:	83 ec 04             	sub    $0x4,%esp
f01006ff:	50                   	push   %eax
f0100700:	ff 73 04             	pushl  0x4(%ebx)
f0100703:	68 65 5f 10 f0       	push   $0xf0105f65
f0100708:	e8 bd 29 00 00       	call   f01030ca <cprintf>
f010070d:	83 c4 10             	add    $0x10,%esp
  }

  return 0;
}
f0100710:	b8 00 00 00 00       	mov    $0x0,%eax
f0100715:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100718:	c9                   	leave  
f0100719:	c3                   	ret    

f010071a <mon_page_status>:

int
mon_page_status(int argc, char **argv, struct Trapframe *tf)
{
f010071a:	55                   	push   %ebp
f010071b:	89 e5                	mov    %esp,%ebp
f010071d:	53                   	push   %ebx
f010071e:	83 ec 10             	sub    $0x10,%esp
  char* paddr_string = argv[1];
  int paddr = strtoint(paddr_string);
f0100721:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100724:	ff 70 04             	pushl  0x4(%eax)
f0100727:	e8 08 43 00 00       	call   f0104a34 <strtoint>
f010072c:	89 c1                	mov    %eax,%ecx
  struct Page *pp;

  // check paddr is valid hex format
  if (paddr == -1) {
f010072e:	83 c4 10             	add    $0x10,%esp
f0100731:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100734:	75 14                	jne    f010074a <mon_page_status+0x30>
    cprintf("Error: invalid hex address.\n");
f0100736:	83 ec 0c             	sub    $0xc,%esp
f0100739:	68 48 5f 10 f0       	push   $0xf0105f48
f010073e:	e8 87 29 00 00       	call   f01030ca <cprintf>
    return 0;
f0100743:	b8 00 00 00 00       	mov    $0x0,%eax
f0100748:	eb 6e                	jmp    f01007b8 <mon_page_status+0x9e>

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f010074a:	c1 e8 0c             	shr    $0xc,%eax
f010074d:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0100753:	72 14                	jb     f0100769 <mon_page_status+0x4f>
		panic("pa2page called with invalid pa");
f0100755:	83 ec 04             	sub    $0x4,%esp
f0100758:	68 b4 60 10 f0       	push   $0xf01060b4
f010075d:	6a 54                	push   $0x54
f010075f:	68 76 5f 10 f0       	push   $0xf0105f76
f0100764:	e8 85 f9 ff ff       	call   f01000ee <_panic>
f0100769:	89 cb                	mov    %ecx,%ebx
f010076b:	c1 eb 0c             	shr    $0xc,%ebx
f010076e:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
f0100771:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0100776:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  }
  pp = pa2page(paddr);

  cprintf("page_status 0x%08x            \n", paddr);
f0100779:	83 ec 08             	sub    $0x8,%esp
f010077c:	51                   	push   %ecx
f010077d:	68 d4 60 10 f0       	push   $0xf01060d4
f0100782:	e8 43 29 00 00       	call   f01030ca <cprintf>

  switch (pp->pp_ref) {
f0100787:	83 c4 10             	add    $0x10,%esp
f010078a:	66 83 7b 08 00       	cmpw   $0x0,0x8(%ebx)
f010078f:	75 12                	jne    f01007a3 <mon_page_status+0x89>
    case 0:
      cprintf("        free\n");
f0100791:	83 ec 0c             	sub    $0xc,%esp
f0100794:	68 84 5f 10 f0       	push   $0xf0105f84
f0100799:	e8 2c 29 00 00       	call   f01030ca <cprintf>
      break;
f010079e:	83 c4 10             	add    $0x10,%esp
f01007a1:	eb 10                	jmp    f01007b3 <mon_page_status+0x99>
    default:
      cprintf("        allocated\n");
f01007a3:	83 ec 0c             	sub    $0xc,%esp
f01007a6:	68 92 5f 10 f0       	push   $0xf0105f92
f01007ab:	e8 1a 29 00 00       	call   f01030ca <cprintf>
      break;
f01007b0:	83 c4 10             	add    $0x10,%esp
  }


  return 0;
f01007b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01007b8:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f01007bb:	c9                   	leave  
f01007bc:	c3                   	ret    

f01007bd <mon_free_page>:

int
mon_free_page(int argc, char **argv, struct Trapframe *tf)
{
f01007bd:	55                   	push   %ebp
f01007be:	89 e5                	mov    %esp,%ebp
f01007c0:	56                   	push   %esi
f01007c1:	53                   	push   %ebx
  char* paddr_string = argv[1];
f01007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
f01007c5:	8b 58 04             	mov    0x4(%eax),%ebx
  int paddr = strtoint(paddr_string);
f01007c8:	83 ec 0c             	sub    $0xc,%esp
f01007cb:	53                   	push   %ebx
f01007cc:	e8 63 42 00 00       	call   f0104a34 <strtoint>
f01007d1:	89 c6                	mov    %eax,%esi
  struct Page *pp;

  // check paddr is valid hex format
  if (paddr == -1) {
f01007d3:	83 c4 10             	add    $0x10,%esp
f01007d6:	83 f8 ff             	cmp    $0xffffffff,%eax
f01007d9:	75 14                	jne    f01007ef <mon_free_page+0x32>
    cprintf("Error: invalid hex address.\n");
f01007db:	83 ec 0c             	sub    $0xc,%esp
f01007de:	68 48 5f 10 f0       	push   $0xf0105f48
f01007e3:	e8 e2 28 00 00       	call   f01030ca <cprintf>
    return 0;
f01007e8:	b8 00 00 00 00       	mov    $0x0,%eax
f01007ed:	eb 56                	jmp    f0100845 <mon_free_page+0x88>
  }

  cprintf("free_page %s            \n", paddr_string);
f01007ef:	83 ec 08             	sub    $0x8,%esp
f01007f2:	53                   	push   %ebx
f01007f3:	68 a5 5f 10 f0       	push   $0xf0105fa5
f01007f8:	e8 cd 28 00 00       	call   f01030ca <cprintf>
}

static inline struct Page*
pa2page(physaddr_t pa)
{
f01007fd:	83 c4 10             	add    $0x10,%esp
	if (PPN(pa) >= npage)
f0100800:	89 f0                	mov    %esi,%eax
f0100802:	c1 e8 0c             	shr    $0xc,%eax
f0100805:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f010080b:	72 14                	jb     f0100821 <mon_free_page+0x64>
		panic("pa2page called with invalid pa");
f010080d:	83 ec 04             	sub    $0x4,%esp
f0100810:	68 b4 60 10 f0       	push   $0xf01060b4
f0100815:	6a 54                	push   $0x54
f0100817:	68 76 5f 10 f0       	push   $0xf0105f76
f010081c:	e8 cd f8 ff ff       	call   f01000ee <_panic>
f0100821:	89 f0                	mov    %esi,%eax
f0100823:	c1 e8 0c             	shr    $0xc,%eax
f0100826:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0100829:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f010082e:	8d 04 90             	lea    (%eax,%edx,4),%eax

  // get out the page
  pp = pa2page(paddr);
  pp->pp_ref = 0;
f0100831:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
  page_free(pp);
f0100837:	83 ec 0c             	sub    $0xc,%esp
f010083a:	50                   	push   %eax
f010083b:	e8 b3 0f 00 00       	call   f01017f3 <page_free>

  return 0;
f0100840:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100845:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0100848:	5b                   	pop    %ebx
f0100849:	5e                   	pop    %esi
f010084a:	c9                   	leave  
f010084b:	c3                   	ret    

f010084c <mon_alloc_page>:

int
mon_alloc_page(int argc, char **argv, struct Trapframe *tf)
{
f010084c:	55                   	push   %ebp
f010084d:	89 e5                	mov    %esp,%ebp
f010084f:	83 ec 14             	sub    $0x14,%esp
  struct Page *new_page;
  cprintf("alloc_page    \n");
f0100852:	68 bf 5f 10 f0       	push   $0xf0105fbf
f0100857:	e8 6e 28 00 00       	call   f01030ca <cprintf>
  page_alloc(&new_page);
f010085c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f010085f:	89 04 24             	mov    %eax,(%esp)
f0100862:	e8 47 0f 00 00       	call   f01017ae <page_alloc>
  new_page->pp_ref++;
f0100867:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f010086a:	66 ff 40 08          	incw   0x8(%eax)
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f010086e:	83 c4 08             	add    $0x8,%esp
f0100871:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
f0100874:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f010087a:	c1 fa 02             	sar    $0x2,%edx
f010087d:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0100880:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0100883:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0100886:	89 c1                	mov    %eax,%ecx
f0100888:	c1 e1 08             	shl    $0x8,%ecx
f010088b:	01 c8                	add    %ecx,%eax
f010088d:	89 c1                	mov    %eax,%ecx
f010088f:	c1 e1 10             	shl    $0x10,%ecx
f0100892:	01 c8                	add    %ecx,%eax
f0100894:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0100897:	c1 e0 0c             	shl    $0xc,%eax
f010089a:	50                   	push   %eax
f010089b:	68 cf 5f 10 f0       	push   $0xf0105fcf
f01008a0:	e8 25 28 00 00       	call   f01030ca <cprintf>
  cprintf("        0x%08x\n", page2pa(new_page));
  return 0;
}
f01008a5:	b8 00 00 00 00       	mov    $0x0,%eax
f01008aa:	c9                   	leave  
f01008ab:	c3                   	ret    

f01008ac <mon_help>:




int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f01008ac:	55                   	push   %ebp
f01008ad:	89 e5                	mov    %esp,%ebp
f01008af:	53                   	push   %ebx
f01008b0:	83 ec 04             	sub    $0x4,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
f01008b3:	bb 00 00 00 00       	mov    $0x0,%ebx
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f01008b8:	83 ec 04             	sub    $0x4,%esp
f01008bb:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01008be:	c1 e0 02             	shl    $0x2,%eax
f01008c1:	ff b0 44 55 12 f0    	pushl  0xf0125544(%eax)
f01008c7:	ff b0 40 55 12 f0    	pushl  0xf0125540(%eax)
f01008cd:	68 df 5f 10 f0       	push   $0xf0105fdf
f01008d2:	e8 f3 27 00 00       	call   f01030ca <cprintf>
f01008d7:	83 c4 10             	add    $0x10,%esp
f01008da:	43                   	inc    %ebx
f01008db:	83 fb 06             	cmp    $0x6,%ebx
f01008de:	76 d8                	jbe    f01008b8 <mon_help+0xc>
	return 0;
}
f01008e0:	b8 00 00 00 00       	mov    $0x0,%eax
f01008e5:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f01008e8:	c9                   	leave  
f01008e9:	c3                   	ret    

f01008ea <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01008ea:	55                   	push   %ebp
f01008eb:	89 e5                	mov    %esp,%ebp
f01008ed:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01008f0:	68 e8 5f 10 f0       	push   $0xf0105fe8
f01008f5:	e8 d0 27 00 00       	call   f01030ca <cprintf>
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
f01008fa:	83 c4 0c             	add    $0xc,%esp
f01008fd:	68 0c 00 10 00       	push   $0x10000c
f0100902:	68 0c 00 10 f0       	push   $0xf010000c
f0100907:	68 f4 60 10 f0       	push   $0xf01060f4
f010090c:	e8 b9 27 00 00       	call   f01030ca <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100911:	83 c4 0c             	add    $0xc,%esp
f0100914:	68 0e 5e 10 00       	push   $0x105e0e
f0100919:	68 0e 5e 10 f0       	push   $0xf0105e0e
f010091e:	68 18 61 10 f0       	push   $0xf0106118
f0100923:	e8 a2 27 00 00       	call   f01030ca <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100928:	83 c4 0c             	add    $0xc,%esp
f010092b:	68 5d 59 2f 00       	push   $0x2f595d
f0100930:	68 5d 59 2f f0       	push   $0xf02f595d
f0100935:	68 3c 61 10 f0       	push   $0xf010613c
f010093a:	e8 8b 27 00 00       	call   f01030ca <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010093f:	83 c4 0c             	add    $0xc,%esp
f0100942:	68 04 8b 32 00       	push   $0x328b04
f0100947:	68 04 8b 32 f0       	push   $0xf0328b04
f010094c:	68 60 61 10 f0       	push   $0xf0106160
f0100951:	e8 74 27 00 00       	call   f01030ca <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100956:	83 c4 08             	add    $0x8,%esp
f0100959:	b8 0c 00 10 f0       	mov    $0xf010000c,%eax
f010095e:	f7 d8                	neg    %eax
f0100960:	05 03 8f 32 f0       	add    $0xf0328f03,%eax
f0100965:	79 05                	jns    f010096c <mon_kerninfo+0x82>
f0100967:	05 ff 03 00 00       	add    $0x3ff,%eax
f010096c:	c1 f8 0a             	sar    $0xa,%eax
f010096f:	50                   	push   %eax
f0100970:	68 84 61 10 f0       	push   $0xf0106184
f0100975:	e8 50 27 00 00       	call   f01030ca <cprintf>
		(end-_start+1023)/1024);
	return 0;
}
f010097a:	b8 00 00 00 00       	mov    $0x0,%eax
f010097f:	c9                   	leave  
f0100980:	c3                   	ret    

f0100981 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100981:	55                   	push   %ebp
f0100982:	89 e5                	mov    %esp,%ebp
f0100984:	56                   	push   %esi
f0100985:	53                   	push   %ebx
f0100986:	83 ec 20             	sub    $0x20,%esp
}

static __inline uint32_t
read_ebp(void)
{
f0100989:	89 eb                	mov    %ebp,%ebx

	// Your code here.
        // seanyliu - 9/15/2009

        // First, extract the current base pointer, since
        // this gives us a pointer to the base frame. We
        // also should initialize eip.
        int* ebp = (int*)read_ebp();
        int* eip = (int*)read_eip();
f010098b:	e8 cd 01 00 00       	call   f0100b5d <read_eip>
f0100990:	89 c6                	mov    %eax,%esi
        struct Eipdebuginfo info;
        //cprintf("DEBUG: *ebp %08x ; ebp %08x ; &ebp %08x ; (int)ebp %08x ; \n", *ebp, ebp, &ebp, (int)ebp);
        //cprintf("DEBUG: read_ebp() %08x\n", read_ebp());

  	cprintf("Stack backtrace:\n");
f0100992:	83 ec 0c             	sub    $0xc,%esp
f0100995:	68 01 60 10 f0       	push   $0xf0106001
f010099a:	e8 2b 27 00 00       	call   f01030ca <cprintf>
        // We could do a while as long as ebp is < the stack.
        // However, in obj/kern/kernel.asm, we see that the ebp
        // is initially nuked to be 0x0.  Therefore, we can
        // use this as a conditional check of when to quit.
        // This is in case there is junk at the top of the stack
        // and the original ebp is not the first line.
        while (ebp != 0x0) {
f010099f:	83 c4 10             	add    $0x10,%esp
          //cprintf("DEBUG in while: *ebp %08x ; ebp %08x ; &ebp %08x ; (int)ebp %08x ; \n", *ebp, ebp, &ebp, (int)ebp);
  	  cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
          if (debuginfo_eip((int)eip, &info) == 0) {
            cprintf("         %s:%d: %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, (int)eip - info.eip_fn_addr);
          }
          eip = (int*)ebp[1];
          ebp = (int*)ebp[0]; // see http://unixwiz.net/techtips/win32-callconv-asm.html
f01009a2:	85 db                	test   %ebx,%ebx
f01009a4:	74 5c                	je     f0100a02 <mon_backtrace+0x81>
f01009a6:	ff 73 18             	pushl  0x18(%ebx)
f01009a9:	ff 73 14             	pushl  0x14(%ebx)
f01009ac:	ff 73 10             	pushl  0x10(%ebx)
f01009af:	ff 73 0c             	pushl  0xc(%ebx)
f01009b2:	ff 73 08             	pushl  0x8(%ebx)
f01009b5:	ff 73 04             	pushl  0x4(%ebx)
f01009b8:	53                   	push   %ebx
f01009b9:	68 b0 61 10 f0       	push   $0xf01061b0
f01009be:	e8 07 27 00 00       	call   f01030ca <cprintf>
f01009c3:	83 c4 18             	add    $0x18,%esp
f01009c6:	8d 45 d8             	lea    0xffffffd8(%ebp),%eax
f01009c9:	50                   	push   %eax
f01009ca:	56                   	push   %esi
f01009cb:	e8 26 38 00 00       	call   f01041f6 <debuginfo_eip>
f01009d0:	83 c4 10             	add    $0x10,%esp
f01009d3:	85 c0                	test   %eax,%eax
f01009d5:	75 22                	jne    f01009f9 <mon_backtrace+0x78>
f01009d7:	83 ec 08             	sub    $0x8,%esp
f01009da:	89 f0                	mov    %esi,%eax
f01009dc:	2b 45 e8             	sub    0xffffffe8(%ebp),%eax
f01009df:	50                   	push   %eax
f01009e0:	ff 75 e0             	pushl  0xffffffe0(%ebp)
f01009e3:	ff 75 e4             	pushl  0xffffffe4(%ebp)
f01009e6:	ff 75 dc             	pushl  0xffffffdc(%ebp)
f01009e9:	ff 75 d8             	pushl  0xffffffd8(%ebp)
f01009ec:	68 13 60 10 f0       	push   $0xf0106013
f01009f1:	e8 d4 26 00 00       	call   f01030ca <cprintf>
f01009f6:	83 c4 20             	add    $0x20,%esp
f01009f9:	8b 73 04             	mov    0x4(%ebx),%esi
f01009fc:	8b 1b                	mov    (%ebx),%ebx
f01009fe:	85 db                	test   %ebx,%ebx
f0100a00:	75 a4                	jne    f01009a6 <mon_backtrace+0x25>
        }
  	/*
	cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, ebp[1], ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
        if (debuginfo_eip((int)eip, &info) == 0) {
          cprintf("         %s:%d: %.*s+%d\n", info.eip_file, info.eip_line, info.eip_fn_namelen, info.eip_fn_name, (int)eip - info.eip_fn_addr);
        }
	*/
	return 0;
}
f0100a02:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a07:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0100a0a:	5b                   	pop    %ebx
f0100a0b:	5e                   	pop    %esi
f0100a0c:	c9                   	leave  
f0100a0d:	c3                   	ret    

f0100a0e <runcmd>:



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
f0100a0e:	55                   	push   %ebp
f0100a0f:	89 e5                	mov    %esp,%ebp
f0100a11:	57                   	push   %edi
f0100a12:	56                   	push   %esi
f0100a13:	53                   	push   %ebx
f0100a14:	83 ec 4c             	sub    $0x4c,%esp
f0100a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0100a1a:	bf 00 00 00 00       	mov    $0x0,%edi
	argv[argc] = 0;
f0100a1f:	c7 45 a8 00 00 00 00 	movl   $0x0,0xffffffa8(%ebp)
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100a26:	eb 04                	jmp    f0100a2c <runcmd+0x1e>
			*buf++ = 0;
f0100a28:	c6 03 00             	movb   $0x0,(%ebx)
f0100a2b:	43                   	inc    %ebx
f0100a2c:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a2f:	74 49                	je     f0100a7a <runcmd+0x6c>
f0100a31:	83 ec 08             	sub    $0x8,%esp
f0100a34:	0f be 03             	movsbl (%ebx),%eax
f0100a37:	50                   	push   %eax
f0100a38:	68 2c 60 10 f0       	push   $0xf010602c
f0100a3d:	e8 1e 42 00 00       	call   f0104c60 <strchr>
f0100a42:	83 c4 10             	add    $0x10,%esp
f0100a45:	85 c0                	test   %eax,%eax
f0100a47:	75 df                	jne    f0100a28 <runcmd+0x1a>
		if (*buf == 0)
f0100a49:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a4c:	74 2c                	je     f0100a7a <runcmd+0x6c>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100a4e:	83 ff 0f             	cmp    $0xf,%edi
f0100a51:	74 3a                	je     f0100a8d <runcmd+0x7f>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
f0100a53:	89 5c bd a8          	mov    %ebx,0xffffffa8(%ebp,%edi,4)
f0100a57:	47                   	inc    %edi
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a58:	eb 01                	jmp    f0100a5b <runcmd+0x4d>
			buf++;
f0100a5a:	43                   	inc    %ebx
f0100a5b:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a5e:	74 1a                	je     f0100a7a <runcmd+0x6c>
f0100a60:	83 ec 08             	sub    $0x8,%esp
f0100a63:	0f be 03             	movsbl (%ebx),%eax
f0100a66:	50                   	push   %eax
f0100a67:	68 2c 60 10 f0       	push   $0xf010602c
f0100a6c:	e8 ef 41 00 00       	call   f0104c60 <strchr>
f0100a71:	83 c4 10             	add    $0x10,%esp
f0100a74:	85 c0                	test   %eax,%eax
f0100a76:	74 e2                	je     f0100a5a <runcmd+0x4c>
f0100a78:	eb b2                	jmp    f0100a2c <runcmd+0x1e>
	}
	argv[argc] = 0;
f0100a7a:	c7 44 bd a8 00 00 00 	movl   $0x0,0xffffffa8(%ebp,%edi,4)
f0100a81:	00 

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
f0100a82:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a87:	85 ff                	test   %edi,%edi
f0100a89:	74 6d                	je     f0100af8 <runcmd+0xea>
f0100a8b:	eb 29                	jmp    f0100ab6 <runcmd+0xa8>
f0100a8d:	83 ec 08             	sub    $0x8,%esp
f0100a90:	6a 10                	push   $0x10
f0100a92:	68 31 60 10 f0       	push   $0xf0106031
f0100a97:	e8 2e 26 00 00       	call   f01030ca <cprintf>
f0100a9c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100aa1:	eb 55                	jmp    f0100af8 <runcmd+0xea>
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
f0100aa3:	83 ec 04             	sub    $0x4,%esp
f0100aa6:	ff 75 0c             	pushl  0xc(%ebp)
f0100aa9:	8d 45 a8             	lea    0xffffffa8(%ebp),%eax
f0100aac:	50                   	push   %eax
f0100aad:	57                   	push   %edi
f0100aae:	ff 96 48 55 12 f0    	call   *0xf0125548(%esi)
f0100ab4:	eb 42                	jmp    f0100af8 <runcmd+0xea>
f0100ab6:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100abb:	83 ec 08             	sub    $0x8,%esp
f0100abe:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100ac1:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
f0100ac8:	ff b6 40 55 12 f0    	pushl  0xf0125540(%esi)
f0100ace:	ff 75 a8             	pushl  0xffffffa8(%ebp)
f0100ad1:	e8 1b 41 00 00       	call   f0104bf1 <strcmp>
f0100ad6:	83 c4 10             	add    $0x10,%esp
f0100ad9:	85 c0                	test   %eax,%eax
f0100adb:	74 c6                	je     f0100aa3 <runcmd+0x95>
f0100add:	43                   	inc    %ebx
f0100ade:	83 fb 06             	cmp    $0x6,%ebx
f0100ae1:	76 d8                	jbe    f0100abb <runcmd+0xad>
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100ae3:	83 ec 08             	sub    $0x8,%esp
f0100ae6:	ff 75 a8             	pushl  0xffffffa8(%ebp)
f0100ae9:	68 4e 60 10 f0       	push   $0xf010604e
f0100aee:	e8 d7 25 00 00       	call   f01030ca <cprintf>
	return 0;
f0100af3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100af8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0100afb:	5b                   	pop    %ebx
f0100afc:	5e                   	pop    %esi
f0100afd:	5f                   	pop    %edi
f0100afe:	c9                   	leave  
f0100aff:	c3                   	ret    

f0100b00 <monitor>:

void
monitor(struct Trapframe *tf)
{
f0100b00:	55                   	push   %ebp
f0100b01:	89 e5                	mov    %esp,%ebp
f0100b03:	53                   	push   %ebx
f0100b04:	83 ec 10             	sub    $0x10,%esp
f0100b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100b0a:	68 e4 61 10 f0       	push   $0xf01061e4
f0100b0f:	e8 b6 25 00 00       	call   f01030ca <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100b14:	c7 04 24 08 62 10 f0 	movl   $0xf0106208,(%esp)
f0100b1b:	e8 aa 25 00 00       	call   f01030ca <cprintf>

	if (tf != NULL)
f0100b20:	83 c4 10             	add    $0x10,%esp
f0100b23:	85 db                	test   %ebx,%ebx
f0100b25:	74 0c                	je     f0100b33 <monitor+0x33>
		print_trapframe(tf);
f0100b27:	83 ec 0c             	sub    $0xc,%esp
f0100b2a:	53                   	push   %ebx
f0100b2b:	e8 8c 27 00 00       	call   f01032bc <print_trapframe>
f0100b30:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100b33:	83 ec 0c             	sub    $0xc,%esp
f0100b36:	68 64 60 10 f0       	push   $0xf0106064
f0100b3b:	e8 20 3e 00 00       	call   f0104960 <readline>
		if (buf != NULL)
f0100b40:	83 c4 10             	add    $0x10,%esp
f0100b43:	85 c0                	test   %eax,%eax
f0100b45:	74 ec                	je     f0100b33 <monitor+0x33>
			if (runcmd(buf, tf) < 0)
f0100b47:	83 ec 08             	sub    $0x8,%esp
f0100b4a:	53                   	push   %ebx
f0100b4b:	50                   	push   %eax
f0100b4c:	e8 bd fe ff ff       	call   f0100a0e <runcmd>
f0100b51:	83 c4 10             	add    $0x10,%esp
f0100b54:	85 c0                	test   %eax,%eax
f0100b56:	79 db                	jns    f0100b33 <monitor+0x33>
				break;
	}
}
f0100b58:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100b5b:	c9                   	leave  
f0100b5c:	c3                   	ret    

f0100b5d <read_eip>:

// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
f0100b5d:	55                   	push   %ebp
f0100b5e:	89 e5                	mov    %esp,%ebp
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
f0100b60:	8b 45 04             	mov    0x4(%ebp),%eax
	return callerpc;
}
f0100b63:	c9                   	leave  
f0100b64:	c3                   	ret    
f0100b65:	00 00                	add    %al,(%eax)
	...

f0100b68 <nvram_read>:
};

static int
nvram_read(int r)
{
f0100b68:	55                   	push   %ebp
f0100b69:	89 e5                	mov    %esp,%ebp
f0100b6b:	56                   	push   %esi
f0100b6c:	53                   	push   %ebx
f0100b6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0100b70:	83 ec 0c             	sub    $0xc,%esp
f0100b73:	53                   	push   %ebx
f0100b74:	e8 bb 23 00 00       	call   f0102f34 <mc146818_read>
f0100b79:	89 c6                	mov    %eax,%esi
f0100b7b:	43                   	inc    %ebx
f0100b7c:	89 1c 24             	mov    %ebx,(%esp)
f0100b7f:	e8 b0 23 00 00       	call   f0102f34 <mc146818_read>
f0100b84:	c1 e0 08             	shl    $0x8,%eax
f0100b87:	09 c6                	or     %eax,%esi
}
f0100b89:	89 f0                	mov    %esi,%eax
f0100b8b:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0100b8e:	5b                   	pop    %ebx
f0100b8f:	5e                   	pop    %esi
f0100b90:	c9                   	leave  
f0100b91:	c3                   	ret    

f0100b92 <i386_detect_memory>:

void
i386_detect_memory(void)
{
f0100b92:	55                   	push   %ebp
f0100b93:	89 e5                	mov    %esp,%ebp
f0100b95:	83 ec 14             	sub    $0x14,%esp
	// CMOS tells us how many kilobytes there are
	basemem = ROUNDDOWN(nvram_read(NVRAM_BASELO)*1024, PGSIZE);
f0100b98:	6a 15                	push   $0x15
f0100b9a:	e8 c9 ff ff ff       	call   f0100b68 <nvram_read>
f0100b9f:	c1 e0 0a             	shl    $0xa,%eax
f0100ba2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100ba7:	a3 ac 5b 2f f0       	mov    %eax,0xf02f5bac
	extmem = ROUNDDOWN(nvram_read(NVRAM_EXTLO)*1024, PGSIZE);
f0100bac:	c7 04 24 17 00 00 00 	movl   $0x17,(%esp)
f0100bb3:	e8 b0 ff ff ff       	call   f0100b68 <nvram_read>
f0100bb8:	83 c4 10             	add    $0x10,%esp
f0100bbb:	c1 e0 0a             	shl    $0xa,%eax
f0100bbe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100bc3:	a3 b0 5b 2f f0       	mov    %eax,0xf02f5bb0

	// Calculate the maximum physical address based on whether
	// or not there is any extended memory.  See comment in <inc/mmu.h>.
	if (extmem)
f0100bc8:	85 c0                	test   %eax,%eax
f0100bca:	74 0c                	je     f0100bd8 <i386_detect_memory+0x46>
		maxpa = EXTPHYSMEM + extmem;
f0100bcc:	05 00 00 10 00       	add    $0x100000,%eax
f0100bd1:	a3 a8 5b 2f f0       	mov    %eax,0xf02f5ba8
f0100bd6:	eb 0a                	jmp    f0100be2 <i386_detect_memory+0x50>
	else
		maxpa = basemem;
f0100bd8:	a1 ac 5b 2f f0       	mov    0xf02f5bac,%eax
f0100bdd:	a3 a8 5b 2f f0       	mov    %eax,0xf02f5ba8

	npage = maxpa / PGSIZE;
f0100be2:	a1 a8 5b 2f f0       	mov    0xf02f5ba8,%eax
f0100be7:	89 c2                	mov    %eax,%edx
f0100be9:	c1 ea 0c             	shr    $0xc,%edx
f0100bec:	89 15 70 68 2f f0    	mov    %edx,0xf02f6870

	cprintf("Physical memory: %dK available, ", (int)(maxpa/1024));
f0100bf2:	83 ec 08             	sub    $0x8,%esp
f0100bf5:	c1 e8 0a             	shr    $0xa,%eax
f0100bf8:	50                   	push   %eax
f0100bf9:	68 30 62 10 f0       	push   $0xf0106230
f0100bfe:	e8 c7 24 00 00       	call   f01030ca <cprintf>
	cprintf("base = %dK, extended = %dK\n", (int)(basemem/1024), (int)(extmem/1024));
f0100c03:	83 c4 0c             	add    $0xc,%esp
f0100c06:	a1 b0 5b 2f f0       	mov    0xf02f5bb0,%eax
f0100c0b:	c1 e8 0a             	shr    $0xa,%eax
f0100c0e:	50                   	push   %eax
f0100c0f:	a1 ac 5b 2f f0       	mov    0xf02f5bac,%eax
f0100c14:	c1 e8 0a             	shr    $0xa,%eax
f0100c17:	50                   	push   %eax
f0100c18:	68 06 68 10 f0       	push   $0xf0106806
f0100c1d:	e8 a8 24 00 00       	call   f01030ca <cprintf>
}
f0100c22:	c9                   	leave  
f0100c23:	c3                   	ret    

f0100c24 <boot_alloc>:

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
f0100c24:	55                   	push   %ebp
f0100c25:	89 e5                	mov    %esp,%ebp
f0100c27:	53                   	push   %ebx
f0100c28:	83 ec 04             	sub    $0x4,%esp
f0100c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
	extern char end[];
	void *v;

	// Initialize boot_freemem if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment -
	// i.e., the first virtual address that the linker
	// did _not_ assign to any kernel code or global variables.
	if (boot_freemem == 0)
f0100c2e:	83 3d b4 5b 2f f0 00 	cmpl   $0x0,0xf02f5bb4
f0100c35:	75 0a                	jne    f0100c41 <boot_alloc+0x1d>
		boot_freemem = end;
f0100c37:	c7 05 b4 5b 2f f0 04 	movl   $0xf0328b04,0xf02f5bb4
f0100c3e:	8b 32 f0 

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
f0100c41:	89 d3                	mov    %edx,%ebx
f0100c43:	03 1d b4 5b 2f f0    	add    0xf02f5bb4,%ebx
f0100c49:	4b                   	dec    %ebx
f0100c4a:	89 d8                	mov    %ebx,%eax
f0100c4c:	89 d1                	mov    %edx,%ecx
f0100c4e:	ba 00 00 00 00       	mov    $0x0,%edx
f0100c53:	f7 f1                	div    %ecx

	//	Step 2: save current value of boot_freemem as allocated chunk
        v = boot_freemem;
f0100c55:	29 d3                	sub    %edx,%ebx

	//	Step 3: increase boot_freemem to record allocation
        boot_freemem += n;
f0100c57:	8b 45 08             	mov    0x8(%ebp),%eax
f0100c5a:	01 d8                	add    %ebx,%eax
f0100c5c:	a3 b4 5b 2f f0       	mov    %eax,0xf02f5bb4
        if (PADDR(boot_freemem) > maxpa) {
f0100c61:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100c66:	77 15                	ja     f0100c7d <boot_alloc+0x59>
f0100c68:	50                   	push   %eax
f0100c69:	68 54 62 10 f0       	push   $0xf0106254
f0100c6e:	68 91 00 00 00       	push   $0x91
f0100c73:	68 22 68 10 f0       	push   $0xf0106822
f0100c78:	e8 71 f4 ff ff       	call   f01000ee <_panic>
f0100c7d:	05 00 00 00 10       	add    $0x10000000,%eax
f0100c82:	3b 05 a8 5b 2f f0    	cmp    0xf02f5ba8,%eax
f0100c88:	76 17                	jbe    f0100ca1 <boot_alloc+0x7d>
          panic("boot_alloc, allocating beyond our memory capacity");
f0100c8a:	83 ec 04             	sub    $0x4,%esp
f0100c8d:	68 78 62 10 f0       	push   $0xf0106278
f0100c92:	68 92 00 00 00       	push   $0x92
f0100c97:	68 22 68 10 f0       	push   $0xf0106822
f0100c9c:	e8 4d f4 ff ff       	call   f01000ee <_panic>
        }

	//	Step 4: return allocated chunk
        return v;

	//return NULL;
}
f0100ca1:	89 d8                	mov    %ebx,%eax
f0100ca3:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100ca6:	c9                   	leave  
f0100ca7:	c3                   	ret    

f0100ca8 <i386_vm_init>:

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
f0100ca8:	55                   	push   %ebp
f0100ca9:	89 e5                	mov    %esp,%ebp
f0100cab:	53                   	push   %ebx
f0100cac:	83 ec 0c             	sub    $0xc,%esp
	pde_t* pgdir;
	uint32_t cr0;
	size_t n;

	// Delete this line:
        // seanyliu
	//panic("i386_vm_init: This function is not finished\n");

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	pgdir = boot_alloc(PGSIZE, PGSIZE);
f0100caf:	68 00 10 00 00       	push   $0x1000
f0100cb4:	68 00 10 00 00       	push   $0x1000
f0100cb9:	e8 66 ff ff ff       	call   f0100c24 <boot_alloc>
f0100cbe:	89 c3                	mov    %eax,%ebx
	memset(pgdir, 0, PGSIZE);
f0100cc0:	83 c4 0c             	add    $0xc,%esp
f0100cc3:	68 00 10 00 00       	push   $0x1000
f0100cc8:	6a 00                	push   $0x0
f0100cca:	50                   	push   %eax
f0100ccb:	e8 c9 3f 00 00       	call   f0104c99 <memset>
	boot_pgdir = pgdir;
f0100cd0:	89 1d 78 68 2f f0    	mov    %ebx,0xf02f6878
	boot_cr3 = PADDR(pgdir);
f0100cd6:	83 c4 10             	add    $0x10,%esp
f0100cd9:	89 d8                	mov    %ebx,%eax
f0100cdb:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100ce1:	77 15                	ja     f0100cf8 <i386_vm_init+0x50>
f0100ce3:	53                   	push   %ebx
f0100ce4:	68 54 62 10 f0       	push   $0xf0106254
f0100ce9:	68 b7 00 00 00       	push   $0xb7
f0100cee:	68 22 68 10 f0       	push   $0xf0106822
f0100cf3:	e8 f6 f3 ff ff       	call   f01000ee <_panic>
f0100cf8:	05 00 00 00 10       	add    $0x10000000,%eax
f0100cfd:	a3 74 68 2f f0       	mov    %eax,0xf02f6874

	//////////////////////////////////////////////////////////////////////
	// Recursively insert PD in itself as a page table, to form
	// a virtual page table at virtual address VPT.
	// (For now, you don't have understand the greater purpose of the
	// following two lines.)

	// Permissions: kernel RW, user NONE
	pgdir[PDX(VPT)] = PADDR(pgdir)|PTE_W|PTE_P;
f0100d02:	89 d8                	mov    %ebx,%eax
f0100d04:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100d0a:	77 15                	ja     f0100d21 <i386_vm_init+0x79>
f0100d0c:	53                   	push   %ebx
f0100d0d:	68 54 62 10 f0       	push   $0xf0106254
f0100d12:	68 c0 00 00 00       	push   $0xc0
f0100d17:	68 22 68 10 f0       	push   $0xf0106822
f0100d1c:	e8 cd f3 ff ff       	call   f01000ee <_panic>
f0100d21:	05 00 00 00 10       	add    $0x10000000,%eax
f0100d26:	83 c8 03             	or     $0x3,%eax
f0100d29:	89 83 fc 0e 00 00    	mov    %eax,0xefc(%ebx)

	// same for UVPT
	// Permissions: kernel R, user R 
	pgdir[PDX(UVPT)] = PADDR(pgdir)|PTE_U|PTE_P;
f0100d2f:	89 d8                	mov    %ebx,%eax
f0100d31:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0100d37:	77 15                	ja     f0100d4e <i386_vm_init+0xa6>
f0100d39:	53                   	push   %ebx
f0100d3a:	68 54 62 10 f0       	push   $0xf0106254
f0100d3f:	68 c4 00 00 00       	push   $0xc4
f0100d44:	68 22 68 10 f0       	push   $0xf0106822
f0100d49:	e8 a0 f3 ff ff       	call   f01000ee <_panic>
f0100d4e:	05 00 00 00 10       	add    $0x10000000,%eax
f0100d53:	83 c8 05             	or     $0x5,%eax
f0100d56:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)

	//////////////////////////////////////////////////////////////////////
	// Make 'pages' point to an array of size 'npage' of 'struct Page'.
	// The kernel uses this structure to keep track of physical pages;
	// 'npage' equals the number of physical pages in memory.  User-level
	// programs will get read-only access to the array as well.
	// You must allocate the array yourself.
	// Your code goes here: 

        // seanyliu
        n = npage * sizeof(struct Page);
f0100d5c:	a1 70 68 2f f0       	mov    0xf02f6870,%eax
f0100d61:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100d64:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
        pages = boot_alloc(n, PGSIZE);
f0100d6b:	83 ec 08             	sub    $0x8,%esp
f0100d6e:	68 00 10 00 00       	push   $0x1000
f0100d73:	52                   	push   %edx
f0100d74:	e8 ab fe ff ff       	call   f0100c24 <boot_alloc>
f0100d79:	a3 7c 68 2f f0       	mov    %eax,0xf02f687c

	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
        n = NENV * sizeof(struct Env);
        envs = boot_alloc(n, PGSIZE);
f0100d7e:	83 c4 08             	add    $0x8,%esp
f0100d81:	68 00 10 00 00       	push   $0x1000
f0100d86:	68 00 00 02 00       	push   $0x20000
f0100d8b:	e8 94 fe ff ff       	call   f0100c24 <boot_alloc>
f0100d90:	a3 c0 5b 2f f0       	mov    %eax,0xf02f5bc0

	//////////////////////////////////////////////////////////////////////
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_segment or page_insert
	page_init();
f0100d95:	e8 8a 08 00 00       	call   f0101624 <page_init>

        check_page_alloc();
f0100d9a:	e8 59 01 00 00       	call   f0100ef8 <check_page_alloc>

	page_check();
f0100d9f:	e8 b1 0e 00 00       	call   f0101c55 <page_check>

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
f0100da4:	a1 70 68 2f f0       	mov    0xf02f6870,%eax
f0100da9:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100dac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
        boot_map_segment(pgdir, UPAGES, n, PADDR(pages), PTE_U | PTE_P);
f0100db3:	83 c4 10             	add    $0x10,%esp
f0100db6:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0100dbb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100dc0:	77 15                	ja     f0100dd7 <i386_vm_init+0x12f>
f0100dc2:	50                   	push   %eax
f0100dc3:	68 54 62 10 f0       	push   $0xf0106254
f0100dc8:	68 ee 00 00 00       	push   $0xee
f0100dcd:	68 22 68 10 f0       	push   $0xf0106822
f0100dd2:	e8 17 f3 ff ff       	call   f01000ee <_panic>
f0100dd7:	05 00 00 00 10       	add    $0x10000000,%eax
f0100ddc:	83 ec 0c             	sub    $0xc,%esp
f0100ddf:	6a 05                	push   $0x5
f0100de1:	50                   	push   %eax
f0100de2:	52                   	push   %edx
f0100de3:	68 00 00 00 ef       	push   $0xef000000
f0100de8:	53                   	push   %ebx
f0100de9:	e8 66 0c 00 00       	call   f0101a54 <boot_map_segment>

	//////////////////////////////////////////////////////////////////////
	// Map the 'envs' array read-only by the user at linear address UENVS
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
        n = NENV * sizeof(struct Env);
f0100dee:	ba 00 00 02 00       	mov    $0x20000,%edx
        boot_map_segment(pgdir, UENVS, n, PADDR(envs), PTE_U | PTE_P);
f0100df3:	83 c4 20             	add    $0x20,%esp
f0100df6:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f0100dfb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e00:	77 15                	ja     f0100e17 <i386_vm_init+0x16f>
f0100e02:	50                   	push   %eax
f0100e03:	68 54 62 10 f0       	push   $0xf0106254
f0100e08:	68 f8 00 00 00       	push   $0xf8
f0100e0d:	68 22 68 10 f0       	push   $0xf0106822
f0100e12:	e8 d7 f2 ff ff       	call   f01000ee <_panic>
f0100e17:	05 00 00 00 10       	add    $0x10000000,%eax
f0100e1c:	83 ec 0c             	sub    $0xc,%esp
f0100e1f:	6a 05                	push   $0x5
f0100e21:	50                   	push   %eax
f0100e22:	52                   	push   %edx
f0100e23:	68 00 00 c0 ee       	push   $0xeec00000
f0100e28:	53                   	push   %ebx
f0100e29:	e8 26 0c 00 00       	call   f0101a54 <boot_map_segment>

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
f0100e2e:	83 c4 20             	add    $0x20,%esp
f0100e31:	b8 00 d0 11 f0       	mov    $0xf011d000,%eax
f0100e36:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100e3b:	77 15                	ja     f0100e52 <i386_vm_init+0x1aa>
f0100e3d:	50                   	push   %eax
f0100e3e:	68 54 62 10 f0       	push   $0xf0106254
f0100e43:	68 03 01 00 00       	push   $0x103
f0100e48:	68 22 68 10 f0       	push   $0xf0106822
f0100e4d:	e8 9c f2 ff ff       	call   f01000ee <_panic>
f0100e52:	05 00 00 00 10       	add    $0x10000000,%eax
f0100e57:	83 ec 0c             	sub    $0xc,%esp
f0100e5a:	6a 03                	push   $0x3
f0100e5c:	50                   	push   %eax
f0100e5d:	68 00 80 00 00       	push   $0x8000
f0100e62:	68 00 80 bf ef       	push   $0xefbf8000
f0100e67:	53                   	push   %ebx
f0100e68:	e8 e7 0b 00 00       	call   f0101a54 <boot_map_segment>
        boot_map_segment(pgdir, KSTACKTOP - PTSIZE, PTSIZE - KSTKSIZE, 0, 0);
f0100e6d:	83 c4 14             	add    $0x14,%esp
f0100e70:	6a 00                	push   $0x0
f0100e72:	6a 00                	push   $0x0
f0100e74:	68 00 80 3f 00       	push   $0x3f8000
f0100e79:	68 00 00 80 ef       	push   $0xef800000
f0100e7e:	53                   	push   %ebx
f0100e7f:	e8 d0 0b 00 00       	call   f0101a54 <boot_map_segment>

	//////////////////////////////////////////////////////////////////////
	// Map all of physical memory at KERNBASE. 
	// Ie.  the VA range [KERNBASE, 2^32) should map to
	//      the PA range [0, 2^32 - KERNBASE)
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here: 
        boot_map_segment(pgdir, KERNBASE, ~KERNBASE + 1, 0, PTE_W | PTE_P);
f0100e84:	83 c4 14             	add    $0x14,%esp
f0100e87:	6a 03                	push   $0x3
f0100e89:	6a 00                	push   $0x0
f0100e8b:	68 00 00 00 10       	push   $0x10000000
f0100e90:	68 00 00 00 f0       	push   $0xf0000000
f0100e95:	53                   	push   %ebx
f0100e96:	e8 b9 0b 00 00       	call   f0101a54 <boot_map_segment>

	// Check that the initial page directory has been set up correctly.
	check_boot_pgdir();
f0100e9b:	83 c4 20             	add    $0x20,%esp
f0100e9e:	e8 9f 04 00 00       	call   f0101342 <check_boot_pgdir>

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
f0100ea3:	8b 83 00 0f 00 00    	mov    0xf00(%ebx),%eax
f0100ea9:	89 03                	mov    %eax,(%ebx)
}

static __inline void
lcr3(uint32_t val)
{
f0100eab:	a1 74 68 2f f0       	mov    0xf02f6874,%eax
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0100eb0:	0f 22 d8             	mov    %eax,%cr3
f0100eb3:	0f 20 c0             	mov    %cr0,%eax

	// Install page table.
	lcr3(boot_cr3);

	// Turn on paging.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_TS|CR0_EM|CR0_MP;
f0100eb6:	0d 2f 00 05 80       	or     $0x8005002f,%eax
}

static __inline void
lcr0(uint32_t val)
{
f0100ebb:	83 e0 f3             	and    $0xfffffff3,%eax
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f0100ebe:	0f 22 c0             	mov    %eax,%cr0
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Current mapping: KERNBASE+x => x => x.
	// (x < 4MB so uses paging pgdir[0])

	// Reload all segment registers.
	asm volatile("lgdt gdt_pd");
f0100ec1:	0f 01 15 d0 55 12 f0 	lgdtl  0xf01255d0
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f0100ec8:	b8 23 00 00 00       	mov    $0x23,%eax
f0100ecd:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0100ecf:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0100ed1:	b0 10                	mov    $0x10,%al
f0100ed3:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f0100ed5:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f0100ed7:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));  // reload cs
f0100ed9:	ea e0 0e 10 f0 08 00 	ljmp   $0x8,$0xf0100ee0
	asm volatile("lldt %%ax" :: "a" (0));
f0100ee0:	b0 00                	mov    $0x0,%al
f0100ee2:	0f 00 d0             	lldt   %ax

	// Final mapping: KERNBASE+x => KERNBASE+x => x.

	// This mapping was only used after paging was turned on but
	// before the segment registers were reloaded.
	pgdir[0] = 0;
f0100ee5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}

static __inline void
lcr3(uint32_t val)
{
f0100eeb:	a1 74 68 2f f0       	mov    0xf02f6874,%eax
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0100ef0:	0f 22 d8             	mov    %eax,%cr3

	// Flush the TLB for good measure, to kill the pgdir[0] mapping.
	lcr3(boot_cr3);
}
f0100ef3:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0100ef6:	c9                   	leave  
f0100ef7:	c3                   	ret    

f0100ef8 <check_page_alloc>:

//
// Check the physical page allocator (page_alloc(), page_free(),
// and page_init()).
//
static void
check_page_alloc()
{
f0100ef8:	55                   	push   %ebp
f0100ef9:	89 e5                	mov    %esp,%ebp
f0100efb:	53                   	push   %ebx
f0100efc:	83 ec 14             	sub    $0x14,%esp
	struct Page *pp, *pp0, *pp1, *pp2;
	struct Page_list fl;
	
        // if there's a page that shouldn't be on
        // the free list, try to make sure it
        // eventually causes trouble.
	LIST_FOREACH(pp0, &page_free_list, pp_link)
f0100eff:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f0100f04:	89 45 f8             	mov    %eax,0xfffffff8(%ebp)
f0100f07:	85 c0                	test   %eax,%eax
f0100f09:	74 72                	je     f0100f7d <check_page_alloc+0x85>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0100f0b:	8b 55 f8             	mov    0xfffffff8(%ebp),%edx
f0100f0e:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0100f14:	c1 fa 02             	sar    $0x2,%edx
f0100f17:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0100f1a:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0100f1d:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0100f20:	89 c1                	mov    %eax,%ecx
f0100f22:	c1 e1 08             	shl    $0x8,%ecx
f0100f25:	01 c8                	add    %ecx,%eax
f0100f27:	89 c1                	mov    %eax,%ecx
f0100f29:	c1 e1 10             	shl    $0x10,%ecx
f0100f2c:	01 c8                	add    %ecx,%eax
f0100f2e:	8d 04 42             	lea    (%edx,%eax,2),%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0100f31:	89 c2                	mov    %eax,%edx
f0100f33:	c1 e2 0c             	shl    $0xc,%edx
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
f0100f36:	89 d0                	mov    %edx,%eax
f0100f38:	c1 e8 0c             	shr    $0xc,%eax
f0100f3b:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0100f41:	72 12                	jb     f0100f55 <check_page_alloc+0x5d>
f0100f43:	52                   	push   %edx
f0100f44:	68 ac 62 10 f0       	push   $0xf01062ac
f0100f49:	6a 5b                	push   $0x5b
f0100f4b:	68 76 5f 10 f0       	push   $0xf0105f76
f0100f50:	e8 99 f1 ff ff       	call   f01000ee <_panic>
f0100f55:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f0100f5b:	83 ec 04             	sub    $0x4,%esp
f0100f5e:	68 80 00 00 00       	push   $0x80
f0100f63:	68 97 00 00 00       	push   $0x97
f0100f68:	50                   	push   %eax
f0100f69:	e8 2b 3d 00 00       	call   f0104c99 <memset>
f0100f6e:	83 c4 10             	add    $0x10,%esp
f0100f71:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
f0100f74:	8b 00                	mov    (%eax),%eax
f0100f76:	89 45 f8             	mov    %eax,0xfffffff8(%ebp)
f0100f79:	85 c0                	test   %eax,%eax
f0100f7b:	75 8e                	jne    f0100f0b <check_page_alloc+0x13>
		memset(page2kva(pp0), 0x97, 128);

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0100f7d:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
f0100f84:	c7 45 f4 00 00 00 00 	movl   $0x0,0xfffffff4(%ebp)
f0100f8b:	c7 45 f8 00 00 00 00 	movl   $0x0,0xfffffff8(%ebp)
	assert(page_alloc(&pp0) == 0);
f0100f92:	83 ec 0c             	sub    $0xc,%esp
f0100f95:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
f0100f98:	50                   	push   %eax
f0100f99:	e8 10 08 00 00       	call   f01017ae <page_alloc>
f0100f9e:	83 c4 10             	add    $0x10,%esp
f0100fa1:	85 c0                	test   %eax,%eax
f0100fa3:	74 19                	je     f0100fbe <check_page_alloc+0xc6>
f0100fa5:	68 2e 68 10 f0       	push   $0xf010682e
f0100faa:	68 44 68 10 f0       	push   $0xf0106844
f0100faf:	68 57 01 00 00       	push   $0x157
f0100fb4:	68 22 68 10 f0       	push   $0xf0106822
f0100fb9:	e8 30 f1 ff ff       	call   f01000ee <_panic>
	assert(page_alloc(&pp1) == 0);
f0100fbe:	83 ec 0c             	sub    $0xc,%esp
f0100fc1:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f0100fc4:	50                   	push   %eax
f0100fc5:	e8 e4 07 00 00       	call   f01017ae <page_alloc>
f0100fca:	83 c4 10             	add    $0x10,%esp
f0100fcd:	85 c0                	test   %eax,%eax
f0100fcf:	74 19                	je     f0100fea <check_page_alloc+0xf2>
f0100fd1:	68 59 68 10 f0       	push   $0xf0106859
f0100fd6:	68 44 68 10 f0       	push   $0xf0106844
f0100fdb:	68 58 01 00 00       	push   $0x158
f0100fe0:	68 22 68 10 f0       	push   $0xf0106822
f0100fe5:	e8 04 f1 ff ff       	call   f01000ee <_panic>
	assert(page_alloc(&pp2) == 0);
f0100fea:	83 ec 0c             	sub    $0xc,%esp
f0100fed:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0100ff0:	50                   	push   %eax
f0100ff1:	e8 b8 07 00 00       	call   f01017ae <page_alloc>
f0100ff6:	83 c4 10             	add    $0x10,%esp
f0100ff9:	85 c0                	test   %eax,%eax
f0100ffb:	74 19                	je     f0101016 <check_page_alloc+0x11e>
f0100ffd:	68 6f 68 10 f0       	push   $0xf010686f
f0101002:	68 44 68 10 f0       	push   $0xf0106844
f0101007:	68 59 01 00 00       	push   $0x159
f010100c:	68 22 68 10 f0       	push   $0xf0106822
f0101011:	e8 d8 f0 ff ff       	call   f01000ee <_panic>

	assert(pp0);
f0101016:	83 7d f8 00          	cmpl   $0x0,0xfffffff8(%ebp)
f010101a:	75 19                	jne    f0101035 <check_page_alloc+0x13d>
f010101c:	68 93 68 10 f0       	push   $0xf0106893
f0101021:	68 44 68 10 f0       	push   $0xf0106844
f0101026:	68 5b 01 00 00       	push   $0x15b
f010102b:	68 22 68 10 f0       	push   $0xf0106822
f0101030:	e8 b9 f0 ff ff       	call   f01000ee <_panic>
	assert(pp1 && pp1 != pp0);
f0101035:	83 7d f4 00          	cmpl   $0x0,0xfffffff4(%ebp)
f0101039:	74 08                	je     f0101043 <check_page_alloc+0x14b>
f010103b:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f010103e:	3b 45 f8             	cmp    0xfffffff8(%ebp),%eax
f0101041:	75 19                	jne    f010105c <check_page_alloc+0x164>
f0101043:	68 85 68 10 f0       	push   $0xf0106885
f0101048:	68 44 68 10 f0       	push   $0xf0106844
f010104d:	68 5c 01 00 00       	push   $0x15c
f0101052:	68 22 68 10 f0       	push   $0xf0106822
f0101057:	e8 92 f0 ff ff       	call   f01000ee <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f010105c:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0101060:	74 0d                	je     f010106f <check_page_alloc+0x177>
f0101062:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0101065:	3b 45 f4             	cmp    0xfffffff4(%ebp),%eax
f0101068:	74 05                	je     f010106f <check_page_alloc+0x177>
f010106a:	3b 45 f8             	cmp    0xfffffff8(%ebp),%eax
f010106d:	75 19                	jne    f0101088 <check_page_alloc+0x190>
f010106f:	68 d0 62 10 f0       	push   $0xf01062d0
f0101074:	68 44 68 10 f0       	push   $0xf0106844
f0101079:	68 5d 01 00 00       	push   $0x15d
f010107e:	68 22 68 10 f0       	push   $0xf0106822
f0101083:	e8 66 f0 ff ff       	call   f01000ee <_panic>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101088:	8b 55 f8             	mov    0xfffffff8(%ebp),%edx
f010108b:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0101091:	c1 fa 02             	sar    $0x2,%edx
f0101094:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101097:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010109a:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010109d:	89 c1                	mov    %eax,%ecx
f010109f:	c1 e1 08             	shl    $0x8,%ecx
f01010a2:	01 c8                	add    %ecx,%eax
f01010a4:	89 c1                	mov    %eax,%ecx
f01010a6:	c1 e1 10             	shl    $0x10,%ecx
f01010a9:	01 c8                	add    %ecx,%eax
f01010ab:	8d 04 42             	lea    (%edx,%eax,2),%eax
f01010ae:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01010b1:	8b 15 70 68 2f f0    	mov    0xf02f6870,%edx
f01010b7:	c1 e2 0c             	shl    $0xc,%edx
f01010ba:	39 d0                	cmp    %edx,%eax
f01010bc:	72 19                	jb     f01010d7 <check_page_alloc+0x1df>
        assert(page2pa(pp0) < npage*PGSIZE);
f01010be:	68 97 68 10 f0       	push   $0xf0106897
f01010c3:	68 44 68 10 f0       	push   $0xf0106844
f01010c8:	68 5e 01 00 00       	push   $0x15e
f01010cd:	68 22 68 10 f0       	push   $0xf0106822
f01010d2:	e8 17 f0 ff ff       	call   f01000ee <_panic>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f01010d7:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f01010da:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f01010e0:	c1 fa 02             	sar    $0x2,%edx
f01010e3:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01010e6:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01010e9:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01010ec:	89 c1                	mov    %eax,%ecx
f01010ee:	c1 e1 08             	shl    $0x8,%ecx
f01010f1:	01 c8                	add    %ecx,%eax
f01010f3:	89 c1                	mov    %eax,%ecx
f01010f5:	c1 e1 10             	shl    $0x10,%ecx
f01010f8:	01 c8                	add    %ecx,%eax
f01010fa:	8d 04 42             	lea    (%edx,%eax,2),%eax
f01010fd:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101100:	8b 15 70 68 2f f0    	mov    0xf02f6870,%edx
f0101106:	c1 e2 0c             	shl    $0xc,%edx
f0101109:	39 d0                	cmp    %edx,%eax
f010110b:	72 19                	jb     f0101126 <check_page_alloc+0x22e>
        assert(page2pa(pp1) < npage*PGSIZE);
f010110d:	68 b3 68 10 f0       	push   $0xf01068b3
f0101112:	68 44 68 10 f0       	push   $0xf0106844
f0101117:	68 5f 01 00 00       	push   $0x15f
f010111c:	68 22 68 10 f0       	push   $0xf0106822
f0101121:	e8 c8 ef ff ff       	call   f01000ee <_panic>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101126:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
f0101129:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f010112f:	c1 fa 02             	sar    $0x2,%edx
f0101132:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101135:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101138:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010113b:	89 c1                	mov    %eax,%ecx
f010113d:	c1 e1 08             	shl    $0x8,%ecx
f0101140:	01 c8                	add    %ecx,%eax
f0101142:	89 c1                	mov    %eax,%ecx
f0101144:	c1 e1 10             	shl    $0x10,%ecx
f0101147:	01 c8                	add    %ecx,%eax
f0101149:	8d 04 42             	lea    (%edx,%eax,2),%eax
f010114c:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f010114f:	8b 15 70 68 2f f0    	mov    0xf02f6870,%edx
f0101155:	c1 e2 0c             	shl    $0xc,%edx
f0101158:	39 d0                	cmp    %edx,%eax
f010115a:	72 19                	jb     f0101175 <check_page_alloc+0x27d>
        assert(page2pa(pp2) < npage*PGSIZE);
f010115c:	68 cf 68 10 f0       	push   $0xf01068cf
f0101161:	68 44 68 10 f0       	push   $0xf0106844
f0101166:	68 60 01 00 00       	push   $0x160
f010116b:	68 22 68 10 f0       	push   $0xf0106822
f0101170:	e8 79 ef ff ff       	call   f01000ee <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101175:	8b 1d b8 5b 2f f0    	mov    0xf02f5bb8,%ebx
	LIST_INIT(&page_free_list);
f010117b:	c7 05 b8 5b 2f f0 00 	movl   $0x0,0xf02f5bb8
f0101182:	00 00 00 

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101185:	83 ec 0c             	sub    $0xc,%esp
f0101188:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f010118b:	50                   	push   %eax
f010118c:	e8 1d 06 00 00       	call   f01017ae <page_alloc>
f0101191:	83 c4 10             	add    $0x10,%esp
f0101194:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101197:	74 19                	je     f01011b2 <check_page_alloc+0x2ba>
f0101199:	68 eb 68 10 f0       	push   $0xf01068eb
f010119e:	68 44 68 10 f0       	push   $0xf0106844
f01011a3:	68 67 01 00 00       	push   $0x167
f01011a8:	68 22 68 10 f0       	push   $0xf0106822
f01011ad:	e8 3c ef ff ff       	call   f01000ee <_panic>

        // free and re-allocate?
        page_free(pp0);
f01011b2:	83 ec 0c             	sub    $0xc,%esp
f01011b5:	ff 75 f8             	pushl  0xfffffff8(%ebp)
f01011b8:	e8 36 06 00 00       	call   f01017f3 <page_free>
        page_free(pp1);
f01011bd:	83 c4 04             	add    $0x4,%esp
f01011c0:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f01011c3:	e8 2b 06 00 00       	call   f01017f3 <page_free>
        page_free(pp2);
f01011c8:	83 c4 04             	add    $0x4,%esp
f01011cb:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f01011ce:	e8 20 06 00 00       	call   f01017f3 <page_free>
	pp0 = pp1 = pp2 = 0;
f01011d3:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
f01011da:	c7 45 f4 00 00 00 00 	movl   $0x0,0xfffffff4(%ebp)
f01011e1:	c7 45 f8 00 00 00 00 	movl   $0x0,0xfffffff8(%ebp)
	assert(page_alloc(&pp0) == 0);
f01011e8:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
f01011eb:	89 04 24             	mov    %eax,(%esp)
f01011ee:	e8 bb 05 00 00       	call   f01017ae <page_alloc>
f01011f3:	83 c4 10             	add    $0x10,%esp
f01011f6:	85 c0                	test   %eax,%eax
f01011f8:	74 19                	je     f0101213 <check_page_alloc+0x31b>
f01011fa:	68 2e 68 10 f0       	push   $0xf010682e
f01011ff:	68 44 68 10 f0       	push   $0xf0106844
f0101204:	68 6e 01 00 00       	push   $0x16e
f0101209:	68 22 68 10 f0       	push   $0xf0106822
f010120e:	e8 db ee ff ff       	call   f01000ee <_panic>
	assert(page_alloc(&pp1) == 0);
f0101213:	83 ec 0c             	sub    $0xc,%esp
f0101216:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f0101219:	50                   	push   %eax
f010121a:	e8 8f 05 00 00       	call   f01017ae <page_alloc>
f010121f:	83 c4 10             	add    $0x10,%esp
f0101222:	85 c0                	test   %eax,%eax
f0101224:	74 19                	je     f010123f <check_page_alloc+0x347>
f0101226:	68 59 68 10 f0       	push   $0xf0106859
f010122b:	68 44 68 10 f0       	push   $0xf0106844
f0101230:	68 6f 01 00 00       	push   $0x16f
f0101235:	68 22 68 10 f0       	push   $0xf0106822
f010123a:	e8 af ee ff ff       	call   f01000ee <_panic>
	assert(page_alloc(&pp2) == 0);
f010123f:	83 ec 0c             	sub    $0xc,%esp
f0101242:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0101245:	50                   	push   %eax
f0101246:	e8 63 05 00 00       	call   f01017ae <page_alloc>
f010124b:	83 c4 10             	add    $0x10,%esp
f010124e:	85 c0                	test   %eax,%eax
f0101250:	74 19                	je     f010126b <check_page_alloc+0x373>
f0101252:	68 6f 68 10 f0       	push   $0xf010686f
f0101257:	68 44 68 10 f0       	push   $0xf0106844
f010125c:	68 70 01 00 00       	push   $0x170
f0101261:	68 22 68 10 f0       	push   $0xf0106822
f0101266:	e8 83 ee ff ff       	call   f01000ee <_panic>
	assert(pp0);
f010126b:	83 7d f8 00          	cmpl   $0x0,0xfffffff8(%ebp)
f010126f:	75 19                	jne    f010128a <check_page_alloc+0x392>
f0101271:	68 93 68 10 f0       	push   $0xf0106893
f0101276:	68 44 68 10 f0       	push   $0xf0106844
f010127b:	68 71 01 00 00       	push   $0x171
f0101280:	68 22 68 10 f0       	push   $0xf0106822
f0101285:	e8 64 ee ff ff       	call   f01000ee <_panic>
	assert(pp1 && pp1 != pp0);
f010128a:	83 7d f4 00          	cmpl   $0x0,0xfffffff4(%ebp)
f010128e:	74 08                	je     f0101298 <check_page_alloc+0x3a0>
f0101290:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f0101293:	3b 45 f8             	cmp    0xfffffff8(%ebp),%eax
f0101296:	75 19                	jne    f01012b1 <check_page_alloc+0x3b9>
f0101298:	68 85 68 10 f0       	push   $0xf0106885
f010129d:	68 44 68 10 f0       	push   $0xf0106844
f01012a2:	68 72 01 00 00       	push   $0x172
f01012a7:	68 22 68 10 f0       	push   $0xf0106822
f01012ac:	e8 3d ee ff ff       	call   f01000ee <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01012b1:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f01012b5:	74 0d                	je     f01012c4 <check_page_alloc+0x3cc>
f01012b7:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f01012ba:	3b 45 f4             	cmp    0xfffffff4(%ebp),%eax
f01012bd:	74 05                	je     f01012c4 <check_page_alloc+0x3cc>
f01012bf:	3b 45 f8             	cmp    0xfffffff8(%ebp),%eax
f01012c2:	75 19                	jne    f01012dd <check_page_alloc+0x3e5>
f01012c4:	68 d0 62 10 f0       	push   $0xf01062d0
f01012c9:	68 44 68 10 f0       	push   $0xf0106844
f01012ce:	68 73 01 00 00       	push   $0x173
f01012d3:	68 22 68 10 f0       	push   $0xf0106822
f01012d8:	e8 11 ee ff ff       	call   f01000ee <_panic>
	assert(page_alloc(&pp) == -E_NO_MEM);
f01012dd:	83 ec 0c             	sub    $0xc,%esp
f01012e0:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f01012e3:	50                   	push   %eax
f01012e4:	e8 c5 04 00 00       	call   f01017ae <page_alloc>
f01012e9:	83 c4 10             	add    $0x10,%esp
f01012ec:	83 f8 fc             	cmp    $0xfffffffc,%eax
f01012ef:	74 19                	je     f010130a <check_page_alloc+0x412>
f01012f1:	68 eb 68 10 f0       	push   $0xf01068eb
f01012f6:	68 44 68 10 f0       	push   $0xf0106844
f01012fb:	68 74 01 00 00       	push   $0x174
f0101300:	68 22 68 10 f0       	push   $0xf0106822
f0101305:	e8 e4 ed ff ff       	call   f01000ee <_panic>

	// give free list back
	page_free_list = fl;
f010130a:	89 1d b8 5b 2f f0    	mov    %ebx,0xf02f5bb8

	// free the pages we took
	page_free(pp0);
f0101310:	83 ec 0c             	sub    $0xc,%esp
f0101313:	ff 75 f8             	pushl  0xfffffff8(%ebp)
f0101316:	e8 d8 04 00 00       	call   f01017f3 <page_free>
	page_free(pp1);
f010131b:	83 c4 04             	add    $0x4,%esp
f010131e:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f0101321:	e8 cd 04 00 00       	call   f01017f3 <page_free>
	page_free(pp2);
f0101326:	83 c4 04             	add    $0x4,%esp
f0101329:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f010132c:	e8 c2 04 00 00       	call   f01017f3 <page_free>

	cprintf("check_page_alloc() succeeded!\n");
f0101331:	c7 04 24 f0 62 10 f0 	movl   $0xf01062f0,(%esp)
f0101338:	e8 8d 1d 00 00       	call   f01030ca <cprintf>
}
f010133d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0101340:	c9                   	leave  
f0101341:	c3                   	ret    

f0101342 <check_boot_pgdir>:

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
f0101342:	55                   	push   %ebp
f0101343:	89 e5                	mov    %esp,%ebp
f0101345:	57                   	push   %edi
f0101346:	56                   	push   %esi
f0101347:	53                   	push   %ebx
f0101348:	83 ec 0c             	sub    $0xc,%esp
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = boot_pgdir;
f010134b:	8b 35 78 68 2f f0    	mov    0xf02f6878,%esi

	// check pages array
	n = ROUNDUP(npage*sizeof(struct Page), PGSIZE);
f0101351:	a1 70 68 2f f0       	mov    0xf02f6870,%eax
f0101356:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0101359:	8d 04 85 ff 0f 00 00 	lea    0xfff(,%eax,4),%eax
f0101360:	89 c7                	mov    %eax,%edi
f0101362:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
	for (i = 0; i < n; i += PGSIZE)
f0101368:	bb 00 00 00 00       	mov    $0x0,%ebx
f010136d:	39 fb                	cmp    %edi,%ebx
f010136f:	73 64                	jae    f01013d5 <check_boot_pgdir+0x93>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0101371:	83 ec 08             	sub    $0x8,%esp
f0101374:	8d 83 00 00 00 ef    	lea    0xef000000(%ebx),%eax
f010137a:	50                   	push   %eax
f010137b:	56                   	push   %esi
f010137c:	e8 1b 02 00 00       	call   f010159c <check_va2pa>
f0101381:	89 c2                	mov    %eax,%edx
f0101383:	83 c4 10             	add    $0x10,%esp
f0101386:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f010138b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101390:	77 15                	ja     f01013a7 <check_boot_pgdir+0x65>
f0101392:	50                   	push   %eax
f0101393:	68 54 62 10 f0       	push   $0xf0106254
f0101398:	68 96 01 00 00       	push   $0x196
f010139d:	68 22 68 10 f0       	push   $0xf0106822
f01013a2:	e8 47 ed ff ff       	call   f01000ee <_panic>
f01013a7:	8d 84 18 00 00 00 10 	lea    0x10000000(%eax,%ebx,1),%eax
f01013ae:	39 c2                	cmp    %eax,%edx
f01013b0:	74 19                	je     f01013cb <check_boot_pgdir+0x89>
f01013b2:	68 10 63 10 f0       	push   $0xf0106310
f01013b7:	68 44 68 10 f0       	push   $0xf0106844
f01013bc:	68 96 01 00 00       	push   $0x196
f01013c1:	68 22 68 10 f0       	push   $0xf0106822
f01013c6:	e8 23 ed ff ff       	call   f01000ee <_panic>
f01013cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01013d1:	39 fb                	cmp    %edi,%ebx
f01013d3:	72 9c                	jb     f0101371 <check_boot_pgdir+0x2f>
	
	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
f01013d5:	bf 00 00 02 00       	mov    $0x20000,%edi
	for (i = 0; i < n; i += PGSIZE)
f01013da:	bb 00 00 00 00       	mov    $0x0,%ebx
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01013df:	83 ec 08             	sub    $0x8,%esp
f01013e2:	8d 83 00 00 c0 ee    	lea    0xeec00000(%ebx),%eax
f01013e8:	50                   	push   %eax
f01013e9:	56                   	push   %esi
f01013ea:	e8 ad 01 00 00       	call   f010159c <check_va2pa>
f01013ef:	89 c2                	mov    %eax,%edx
f01013f1:	83 c4 10             	add    $0x10,%esp
f01013f4:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f01013f9:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01013fe:	77 15                	ja     f0101415 <check_boot_pgdir+0xd3>
f0101400:	50                   	push   %eax
f0101401:	68 54 62 10 f0       	push   $0xf0106254
f0101406:	68 9b 01 00 00       	push   $0x19b
f010140b:	68 22 68 10 f0       	push   $0xf0106822
f0101410:	e8 d9 ec ff ff       	call   f01000ee <_panic>
f0101415:	8d 84 18 00 00 00 10 	lea    0x10000000(%eax,%ebx,1),%eax
f010141c:	39 c2                	cmp    %eax,%edx
f010141e:	74 19                	je     f0101439 <check_boot_pgdir+0xf7>
f0101420:	68 44 63 10 f0       	push   $0xf0106344
f0101425:	68 44 68 10 f0       	push   $0xf0106844
f010142a:	68 9b 01 00 00       	push   $0x19b
f010142f:	68 22 68 10 f0       	push   $0xf0106822
f0101434:	e8 b5 ec ff ff       	call   f01000ee <_panic>
f0101439:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010143f:	39 fb                	cmp    %edi,%ebx
f0101441:	72 9c                	jb     f01013df <check_boot_pgdir+0x9d>

	// check phys mem
	for (i = 0; i < npage * PGSIZE; i += PGSIZE)
f0101443:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101448:	a1 70 68 2f f0       	mov    0xf02f6870,%eax
f010144d:	c1 e0 0c             	shl    $0xc,%eax
f0101450:	83 f8 00             	cmp    $0x0,%eax
f0101453:	76 42                	jbe    f0101497 <check_boot_pgdir+0x155>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0101455:	83 ec 08             	sub    $0x8,%esp
f0101458:	8d 83 00 00 00 f0    	lea    0xf0000000(%ebx),%eax
f010145e:	50                   	push   %eax
f010145f:	56                   	push   %esi
f0101460:	e8 37 01 00 00       	call   f010159c <check_va2pa>
f0101465:	83 c4 10             	add    $0x10,%esp
f0101468:	39 d8                	cmp    %ebx,%eax
f010146a:	74 19                	je     f0101485 <check_boot_pgdir+0x143>
f010146c:	68 78 63 10 f0       	push   $0xf0106378
f0101471:	68 44 68 10 f0       	push   $0xf0106844
f0101476:	68 9f 01 00 00       	push   $0x19f
f010147b:	68 22 68 10 f0       	push   $0xf0106822
f0101480:	e8 69 ec ff ff       	call   f01000ee <_panic>
f0101485:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010148b:	a1 70 68 2f f0       	mov    0xf02f6870,%eax
f0101490:	c1 e0 0c             	shl    $0xc,%eax
f0101493:	39 d8                	cmp    %ebx,%eax
f0101495:	77 be                	ja     f0101455 <check_boot_pgdir+0x113>

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0101497:	bb 00 00 00 00       	mov    $0x0,%ebx
f010149c:	bf 00 d0 11 f0       	mov    $0xf011d000,%edi
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f01014a1:	83 ec 08             	sub    $0x8,%esp
f01014a4:	8d 83 00 80 bf ef    	lea    0xefbf8000(%ebx),%eax
f01014aa:	50                   	push   %eax
f01014ab:	56                   	push   %esi
f01014ac:	e8 eb 00 00 00       	call   f010159c <check_va2pa>
f01014b1:	89 c2                	mov    %eax,%edx
f01014b3:	83 c4 10             	add    $0x10,%esp
f01014b6:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f01014bc:	77 19                	ja     f01014d7 <check_boot_pgdir+0x195>
f01014be:	68 00 d0 11 f0       	push   $0xf011d000
f01014c3:	68 54 62 10 f0       	push   $0xf0106254
f01014c8:	68 a3 01 00 00       	push   $0x1a3
f01014cd:	68 22 68 10 f0       	push   $0xf0106822
f01014d2:	e8 17 ec ff ff       	call   f01000ee <_panic>
f01014d7:	8d 84 1f 00 00 00 10 	lea    0x10000000(%edi,%ebx,1),%eax
f01014de:	39 c2                	cmp    %eax,%edx
f01014e0:	74 19                	je     f01014fb <check_boot_pgdir+0x1b9>
f01014e2:	68 a0 63 10 f0       	push   $0xf01063a0
f01014e7:	68 44 68 10 f0       	push   $0xf0106844
f01014ec:	68 a3 01 00 00       	push   $0x1a3
f01014f1:	68 22 68 10 f0       	push   $0xf0106822
f01014f6:	e8 f3 eb ff ff       	call   f01000ee <_panic>
f01014fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101501:	81 fb ff 7f 00 00    	cmp    $0x7fff,%ebx
f0101507:	76 98                	jbe    f01014a1 <check_boot_pgdir+0x15f>

	// check for zero/non-zero in PDEs
	for (i = 0; i < NPDENTRIES; i++) {
f0101509:	bb 00 00 00 00       	mov    $0x0,%ebx
		switch (i) {
f010150e:	8d 83 45 fc ff ff    	lea    0xfffffc45(%ebx),%eax
f0101514:	83 f8 04             	cmp    $0x4,%eax
f0101517:	77 1f                	ja     f0101538 <check_boot_pgdir+0x1f6>
		case PDX(VPT):
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
			assert(pgdir[i]);
f0101519:	83 3c 9e 00          	cmpl   $0x0,(%esi,%ebx,4)
f010151d:	75 5f                	jne    f010157e <check_boot_pgdir+0x23c>
f010151f:	68 08 69 10 f0       	push   $0xf0106908
f0101524:	68 44 68 10 f0       	push   $0xf0106844
f0101529:	68 ad 01 00 00       	push   $0x1ad
f010152e:	68 22 68 10 f0       	push   $0xf0106822
f0101533:	e8 b6 eb ff ff       	call   f01000ee <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE))
f0101538:	81 fb bf 03 00 00    	cmp    $0x3bf,%ebx
f010153e:	76 1f                	jbe    f010155f <check_boot_pgdir+0x21d>
				assert(pgdir[i]);
f0101540:	83 3c 9e 00          	cmpl   $0x0,(%esi,%ebx,4)
f0101544:	75 38                	jne    f010157e <check_boot_pgdir+0x23c>
f0101546:	68 08 69 10 f0       	push   $0xf0106908
f010154b:	68 44 68 10 f0       	push   $0xf0106844
f0101550:	68 b1 01 00 00       	push   $0x1b1
f0101555:	68 22 68 10 f0       	push   $0xf0106822
f010155a:	e8 8f eb ff ff       	call   f01000ee <_panic>
			else
				assert(pgdir[i] == 0);
f010155f:	83 3c 9e 00          	cmpl   $0x0,(%esi,%ebx,4)
f0101563:	74 19                	je     f010157e <check_boot_pgdir+0x23c>
f0101565:	68 11 69 10 f0       	push   $0xf0106911
f010156a:	68 44 68 10 f0       	push   $0xf0106844
f010156f:	68 b3 01 00 00       	push   $0x1b3
f0101574:	68 22 68 10 f0       	push   $0xf0106822
f0101579:	e8 70 eb ff ff       	call   f01000ee <_panic>
f010157e:	43                   	inc    %ebx
f010157f:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
f0101585:	76 87                	jbe    f010150e <check_boot_pgdir+0x1cc>
			break;
		}
	}
	cprintf("check_boot_pgdir() succeeded!\n");
f0101587:	83 ec 0c             	sub    $0xc,%esp
f010158a:	68 e8 63 10 f0       	push   $0xf01063e8
f010158f:	e8 36 1b 00 00       	call   f01030ca <cprintf>
}
f0101594:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0101597:	5b                   	pop    %ebx
f0101598:	5e                   	pop    %esi
f0101599:	5f                   	pop    %edi
f010159a:	c9                   	leave  
f010159b:	c3                   	ret    

f010159c <check_va2pa>:

// This function returns the physical address of the page containing 'va',
// defined by the page directory 'pgdir'.  The hardware normally performs
// this functionality for us!  We define our own version to help check
// the check_boot_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f010159c:	55                   	push   %ebp
f010159d:	89 e5                	mov    %esp,%ebp
f010159f:	53                   	push   %ebx
f01015a0:	83 ec 04             	sub    $0x4,%esp
f01015a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f01015a6:	89 d8                	mov    %ebx,%eax
f01015a8:	c1 e8 16             	shr    $0x16,%eax
f01015ab:	c1 e0 02             	shl    $0x2,%eax
f01015ae:	03 45 08             	add    0x8(%ebp),%eax
	if (!(*pgdir & PTE_P))
		return ~0;
f01015b1:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01015b6:	f6 00 01             	testb  $0x1,(%eax)
f01015b9:	74 58                	je     f0101613 <check_va2pa+0x77>
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f01015bb:	8b 10                	mov    (%eax),%edx
f01015bd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01015c3:	89 d0                	mov    %edx,%eax
f01015c5:	c1 e8 0c             	shr    $0xc,%eax
f01015c8:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f01015ce:	72 15                	jb     f01015e5 <check_va2pa+0x49>
f01015d0:	52                   	push   %edx
f01015d1:	68 ac 62 10 f0       	push   $0xf01062ac
f01015d6:	68 c7 01 00 00       	push   $0x1c7
f01015db:	68 22 68 10 f0       	push   $0xf0106822
f01015e0:	e8 09 eb ff ff       	call   f01000ee <_panic>
f01015e5:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
	if (!(p[PTX(va)] & PTE_P))
f01015eb:	89 d8                	mov    %ebx,%eax
f01015ed:	c1 e8 0c             	shr    $0xc,%eax
f01015f0:	25 ff 03 00 00       	and    $0x3ff,%eax
		return ~0;
f01015f5:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01015fa:	f6 04 82 01          	testb  $0x1,(%edx,%eax,4)
f01015fe:	74 13                	je     f0101613 <check_va2pa+0x77>
	return PTE_ADDR(p[PTX(va)]);
f0101600:	89 d8                	mov    %ebx,%eax
f0101602:	c1 e8 0c             	shr    $0xc,%eax
f0101605:	25 ff 03 00 00       	and    $0x3ff,%eax
f010160a:	8b 0c 82             	mov    (%edx,%eax,4),%ecx
f010160d:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
}
f0101613:	89 c8                	mov    %ecx,%eax
f0101615:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0101618:	c9                   	leave  
f0101619:	c3                   	ret    

f010161a <get_page_status>:
		
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
f010161a:	55                   	push   %ebp
f010161b:	89 e5                	mov    %esp,%ebp
  return 0;
}
f010161d:	b8 00 00 00 00       	mov    $0x0,%eax
f0101622:	c9                   	leave  
f0101623:	c3                   	ret    

f0101624 <page_init>:

//  
// Initialize page structure and memory free list.
// After this point, ONLY use the functions below
// to allocate and deallocate physical memory via the page_free_list,
// and NEVER use boot_alloc()
//
void
page_init(void)
{
f0101624:	55                   	push   %ebp
f0101625:	89 e5                	mov    %esp,%ebp
f0101627:	53                   	push   %ebx
f0101628:	83 ec 04             	sub    $0x4,%esp
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
f010162b:	c7 05 b8 5b 2f f0 00 	movl   $0x0,0xf02f5bb8
f0101632:	00 00 00 

        // seanyliu
	// 1) Mark page 0 as in use
        // do this by not adding to page_free_list
	pages[0].pp_ref = 0;
f0101635:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f010163a:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)

	// 2) Mark the rest of base memory as free
	for (i = 0; i < PPN(IOPHYSMEM); i++) {
f0101640:	bb 00 00 00 00       	mov    $0x0,%ebx
		pages[i].pp_ref = 0;
f0101645:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0101648:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
f010164f:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0101654:	66 c7 44 01 08 00 00 	movw   $0x0,0x8(%ecx,%eax,1)
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
f010165b:	8b 15 b8 5b 2f f0    	mov    0xf02f5bb8,%edx
f0101661:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0101666:	89 14 01             	mov    %edx,(%ecx,%eax,1)
f0101669:	85 d2                	test   %edx,%edx
f010166b:	74 10                	je     f010167d <page_init+0x59>
f010166d:	89 ca                	mov    %ecx,%edx
f010166f:	03 15 7c 68 2f f0    	add    0xf02f687c,%edx
f0101675:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f010167a:	89 50 04             	mov    %edx,0x4(%eax)
f010167d:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0101680:	c1 e0 02             	shl    $0x2,%eax
f0101683:	8b 0d 7c 68 2f f0    	mov    0xf02f687c,%ecx
f0101689:	8d 14 08             	lea    (%eax,%ecx,1),%edx
f010168c:	89 15 b8 5b 2f f0    	mov    %edx,0xf02f5bb8
f0101692:	c7 44 08 04 b8 5b 2f 	movl   $0xf02f5bb8,0x4(%eax,%ecx,1)
f0101699:	f0 
f010169a:	43                   	inc    %ebx
f010169b:	81 fb 9f 00 00 00    	cmp    $0x9f,%ebx
f01016a1:	76 a2                	jbe    f0101645 <page_init+0x21>
	}

	// 3) Then comes the IO hole
	for (i = PPN(IOPHYSMEM); i < PPN(EXTPHYSMEM); i++) {
f01016a3:	bb a0 00 00 00       	mov    $0xa0,%ebx
        	pages[i].pp_ref = 0;
f01016a8:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
f01016ab:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f01016b0:	66 c7 44 90 08 00 00 	movw   $0x0,0x8(%eax,%edx,4)
f01016b7:	43                   	inc    %ebx
f01016b8:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f01016be:	76 e8                	jbe    f01016a8 <page_init+0x84>
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
f01016c0:	bb 00 01 00 00       	mov    $0x100,%ebx
f01016c5:	eb 10                	jmp    f01016d7 <page_init+0xb3>
        	pages[i].pp_ref = 0;
f01016c7:	8d 14 5b             	lea    (%ebx,%ebx,2),%edx
f01016ca:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f01016cf:	66 c7 44 90 08 00 00 	movw   $0x0,0x8(%eax,%edx,4)
f01016d6:	43                   	inc    %ebx
f01016d7:	a1 b4 5b 2f f0       	mov    0xf02f5bb4,%eax
f01016dc:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01016e1:	77 15                	ja     f01016f8 <page_init+0xd4>
f01016e3:	50                   	push   %eax
f01016e4:	68 54 62 10 f0       	push   $0xf0106254
f01016e9:	68 0e 02 00 00       	push   $0x20e
f01016ee:	68 22 68 10 f0       	push   $0xf0106822
f01016f3:	e8 f6 e9 ff ff       	call   f01000ee <_panic>
f01016f8:	05 00 00 00 10       	add    $0x10000000,%eax
f01016fd:	c1 e8 0c             	shr    $0xc,%eax
f0101700:	39 c3                	cmp    %eax,%ebx
f0101702:	72 c3                	jb     f01016c7 <page_init+0xa3>
                // DO NOT LIST_INSERT_HEAD
        }

        for (i = PPN(PADDR(boot_freemem)); i < npage; i++) {
f0101704:	a1 b4 5b 2f f0       	mov    0xf02f5bb4,%eax
f0101709:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010170e:	77 15                	ja     f0101725 <page_init+0x101>
f0101710:	50                   	push   %eax
f0101711:	68 54 62 10 f0       	push   $0xf0106254
f0101716:	68 13 02 00 00       	push   $0x213
f010171b:	68 22 68 10 f0       	push   $0xf0106822
f0101720:	e8 c9 e9 ff ff       	call   f01000ee <_panic>
f0101725:	05 00 00 00 10       	add    $0x10000000,%eax
f010172a:	89 c3                	mov    %eax,%ebx
f010172c:	c1 eb 0c             	shr    $0xc,%ebx
f010172f:	3b 1d 70 68 2f f0    	cmp    0xf02f6870,%ebx
f0101735:	73 5e                	jae    f0101795 <page_init+0x171>
		pages[i].pp_ref = 0;
f0101737:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f010173a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
f0101741:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0101746:	66 c7 44 01 08 00 00 	movw   $0x0,0x8(%ecx,%eax,1)
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
f010174d:	8b 15 b8 5b 2f f0    	mov    0xf02f5bb8,%edx
f0101753:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0101758:	89 14 01             	mov    %edx,(%ecx,%eax,1)
f010175b:	85 d2                	test   %edx,%edx
f010175d:	74 10                	je     f010176f <page_init+0x14b>
f010175f:	89 ca                	mov    %ecx,%edx
f0101761:	03 15 7c 68 2f f0    	add    0xf02f687c,%edx
f0101767:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f010176c:	89 50 04             	mov    %edx,0x4(%eax)
f010176f:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0101772:	c1 e0 02             	shl    $0x2,%eax
f0101775:	8b 0d 7c 68 2f f0    	mov    0xf02f687c,%ecx
f010177b:	8d 14 08             	lea    (%eax,%ecx,1),%edx
f010177e:	89 15 b8 5b 2f f0    	mov    %edx,0xf02f5bb8
f0101784:	c7 44 08 04 b8 5b 2f 	movl   $0xf02f5bb8,0x4(%eax,%ecx,1)
f010178b:	f0 
f010178c:	43                   	inc    %ebx
f010178d:	3b 1d 70 68 2f f0    	cmp    0xf02f6870,%ebx
f0101793:	72 a2                	jb     f0101737 <page_init+0x113>
        }

	// Staff code below:
	//for (i = 0; i < npage; i++) {
	//	pages[i].pp_ref = 0;
	//	LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
	//}
}
f0101795:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0101798:	c9                   	leave  
f0101799:	c3                   	ret    

f010179a <page_initpp>:

//
// Initialize a Page structure.
// The result has null links and 0 refcount.
// Note that the corresponding physical page is NOT initialized!
//
static void
page_initpp(struct Page *pp)
{
f010179a:	55                   	push   %ebp
f010179b:	89 e5                	mov    %esp,%ebp
f010179d:	83 ec 0c             	sub    $0xc,%esp
	memset(pp, 0, sizeof(*pp));
f01017a0:	6a 0c                	push   $0xc
f01017a2:	6a 00                	push   $0x0
f01017a4:	ff 75 08             	pushl  0x8(%ebp)
f01017a7:	e8 ed 34 00 00       	call   f0104c99 <memset>
}
f01017ac:	c9                   	leave  
f01017ad:	c3                   	ret    

f01017ae <page_alloc>:

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
f01017ae:	55                   	push   %ebp
f01017af:	89 e5                	mov    %esp,%ebp
f01017b1:	83 ec 08             	sub    $0x8,%esp
f01017b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  // Fill this function in
  // seanyliu
  if (LIST_EMPTY(&page_free_list)) {
    return -E_NO_MEM;
f01017b7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01017bc:	83 3d b8 5b 2f f0 00 	cmpl   $0x0,0xf02f5bb8
f01017c3:	74 2c                	je     f01017f1 <page_alloc+0x43>
  }
  *pp_store = LIST_FIRST(&page_free_list);
f01017c5:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f01017ca:	89 01                	mov    %eax,(%ecx)
  LIST_REMOVE(*pp_store, pp_link);
f01017cc:	83 38 00             	cmpl   $0x0,(%eax)
f01017cf:	74 08                	je     f01017d9 <page_alloc+0x2b>
f01017d1:	8b 10                	mov    (%eax),%edx
f01017d3:	8b 40 04             	mov    0x4(%eax),%eax
f01017d6:	89 42 04             	mov    %eax,0x4(%edx)
f01017d9:	8b 01                	mov    (%ecx),%eax
f01017db:	8b 50 04             	mov    0x4(%eax),%edx
f01017de:	8b 00                	mov    (%eax),%eax
f01017e0:	89 02                	mov    %eax,(%edx)
  page_initpp(*pp_store);
f01017e2:	83 ec 0c             	sub    $0xc,%esp
f01017e5:	ff 31                	pushl  (%ecx)
f01017e7:	e8 ae ff ff ff       	call   f010179a <page_initpp>
  return 0;
f01017ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01017f1:	c9                   	leave  
f01017f2:	c3                   	ret    

f01017f3 <page_free>:

//
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct Page *pp)
{
f01017f3:	55                   	push   %ebp
f01017f4:	89 e5                	mov    %esp,%ebp
f01017f6:	8b 55 08             	mov    0x8(%ebp),%edx
  // Fill this function in
  // seanyliu
  LIST_INSERT_HEAD(&page_free_list, pp, pp_link);
f01017f9:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f01017fe:	89 02                	mov    %eax,(%edx)
f0101800:	85 c0                	test   %eax,%eax
f0101802:	74 08                	je     f010180c <page_free+0x19>
f0101804:	a1 b8 5b 2f f0       	mov    0xf02f5bb8,%eax
f0101809:	89 50 04             	mov    %edx,0x4(%eax)
f010180c:	89 15 b8 5b 2f f0    	mov    %edx,0xf02f5bb8
f0101812:	c7 42 04 b8 5b 2f f0 	movl   $0xf02f5bb8,0x4(%edx)
}
f0101819:	c9                   	leave  
f010181a:	c3                   	ret    

f010181b <page_decref>:

//
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct Page* pp)
{
f010181b:	55                   	push   %ebp
f010181c:	89 e5                	mov    %esp,%ebp
f010181e:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f0101821:	66 ff 48 08          	decw   0x8(%eax)
f0101825:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f010182a:	75 09                	jne    f0101835 <page_decref+0x1a>
		page_free(pp);
f010182c:	50                   	push   %eax
f010182d:	e8 c1 ff ff ff       	call   f01017f3 <page_free>
f0101832:	83 c4 04             	add    $0x4,%esp
}
f0101835:	c9                   	leave  
f0101836:	c3                   	ret    

f0101837 <pgdir_walk>:

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
f0101837:	55                   	push   %ebp
f0101838:	89 e5                	mov    %esp,%ebp
f010183a:	56                   	push   %esi
f010183b:	53                   	push   %ebx
f010183c:	83 ec 10             	sub    $0x10,%esp
f010183f:	8b 75 0c             	mov    0xc(%ebp),%esi

  // Fill this function in
  // return NULL;

  // seanyliu
  uint32_t *pgdir_entry = &pgdir[PDX(va)];
f0101842:	89 f3                	mov    %esi,%ebx
f0101844:	c1 eb 16             	shr    $0x16,%ebx
f0101847:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
f010184e:	89 c3                	mov    %eax,%ebx
f0101850:	03 5d 08             	add    0x8(%ebp),%ebx
  if (!(*pgdir_entry & PTE_P)) {
f0101853:	f6 03 01             	testb  $0x1,(%ebx)
f0101856:	0f 85 c5 00 00 00    	jne    f0101921 <pgdir_walk+0xea>
    if (!create) {
      return NULL;
f010185c:	ba 00 00 00 00       	mov    $0x0,%edx
f0101861:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101865:	0f 84 f1 00 00 00    	je     f010195c <pgdir_walk+0x125>
    }

    struct Page *new_pgtbl;
    if (page_alloc(&new_pgtbl)) {
f010186b:	83 ec 0c             	sub    $0xc,%esp
f010186e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f0101871:	50                   	push   %eax
f0101872:	e8 37 ff ff ff       	call   f01017ae <page_alloc>
f0101877:	83 c4 10             	add    $0x10,%esp
      return NULL;
f010187a:	ba 00 00 00 00       	mov    $0x0,%edx
f010187f:	85 c0                	test   %eax,%eax
f0101881:	0f 85 d5 00 00 00    	jne    f010195c <pgdir_walk+0x125>
    }
    new_pgtbl->pp_ref = 1;
f0101887:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f010188a:	66 c7 40 08 01 00    	movw   $0x1,0x8(%eax)

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101890:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f0101893:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0101899:	c1 fa 02             	sar    $0x2,%edx
f010189c:	8d 04 92             	lea    (%edx,%edx,4),%eax
f010189f:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01018a2:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01018a5:	89 c1                	mov    %eax,%ecx
f01018a7:	c1 e1 08             	shl    $0x8,%ecx
f01018aa:	01 c8                	add    %ecx,%eax
f01018ac:	89 c1                	mov    %eax,%ecx
f01018ae:	c1 e1 10             	shl    $0x10,%ecx
f01018b1:	01 c8                	add    %ecx,%eax
f01018b3:	8d 04 42             	lea    (%edx,%eax,2),%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01018b6:	89 c2                	mov    %eax,%edx
f01018b8:	c1 e2 0c             	shl    $0xc,%edx
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
f01018bb:	89 d0                	mov    %edx,%eax
f01018bd:	c1 e8 0c             	shr    $0xc,%eax
f01018c0:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f01018c6:	72 12                	jb     f01018da <pgdir_walk+0xa3>
f01018c8:	52                   	push   %edx
f01018c9:	68 ac 62 10 f0       	push   $0xf01062ac
f01018ce:	6a 5b                	push   $0x5b
f01018d0:	68 76 5f 10 f0       	push   $0xf0105f76
f01018d5:	e8 14 e8 ff ff       	call   f01000ee <_panic>
f01018da:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f01018e0:	83 ec 04             	sub    $0x4,%esp
f01018e3:	68 00 10 00 00       	push   $0x1000
f01018e8:	6a 00                	push   $0x0
f01018ea:	50                   	push   %eax
f01018eb:	e8 a9 33 00 00       	call   f0104c99 <memset>
f01018f0:	83 c4 10             	add    $0x10,%esp
f01018f3:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f01018f6:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f01018fc:	c1 fa 02             	sar    $0x2,%edx
f01018ff:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101902:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101905:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101908:	89 c1                	mov    %eax,%ecx
f010190a:	c1 e1 08             	shl    $0x8,%ecx
f010190d:	01 c8                	add    %ecx,%eax
f010190f:	89 c1                	mov    %eax,%ecx
f0101911:	c1 e1 10             	shl    $0x10,%ecx
f0101914:	01 c8                	add    %ecx,%eax
f0101916:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0101919:	c1 e0 0c             	shl    $0xc,%eax
f010191c:	83 c8 07             	or     $0x7,%eax
f010191f:	89 03                	mov    %eax,(%ebx)
    memset(page2kva(new_pgtbl), 0, PGSIZE);
    *pgdir_entry = page2pa(new_pgtbl) | PTE_P | PTE_W | PTE_U;
  }

  pte_t *pgtbl_entry = KADDR(PTE_ADDR(*pgdir_entry));
f0101921:	8b 13                	mov    (%ebx),%edx
f0101923:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101929:	89 d0                	mov    %edx,%eax
f010192b:	c1 e8 0c             	shr    $0xc,%eax
f010192e:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0101934:	72 15                	jb     f010194b <pgdir_walk+0x114>
f0101936:	52                   	push   %edx
f0101937:	68 ac 62 10 f0       	push   $0xf01062ac
f010193c:	68 86 02 00 00       	push   $0x286
f0101941:	68 22 68 10 f0       	push   $0xf0106822
f0101946:	e8 a3 e7 ff ff       	call   f01000ee <_panic>
  return &pgtbl_entry[PTX(va)];
f010194b:	89 f0                	mov    %esi,%eax
f010194d:	c1 e8 0a             	shr    $0xa,%eax
f0101950:	25 fc 0f 00 00       	and    $0xffc,%eax
f0101955:	8d 94 02 00 00 00 f0 	lea    0xf0000000(%edx,%eax,1),%edx
}
f010195c:	89 d0                	mov    %edx,%eax
f010195e:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0101961:	5b                   	pop    %ebx
f0101962:	5e                   	pop    %esi
f0101963:	c9                   	leave  
f0101964:	c3                   	ret    

f0101965 <page_insert>:

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
f0101965:	55                   	push   %ebp
f0101966:	89 e5                	mov    %esp,%ebp
f0101968:	57                   	push   %edi
f0101969:	56                   	push   %esi
f010196a:	53                   	push   %ebx
f010196b:	83 ec 10             	sub    $0x10,%esp
  // Fill this function in
  //return 0;

  // seanyliu
  pte_t *pgtbl_entry;
  pgtbl_entry = pgdir_walk(pgdir, va, 1);
f010196e:	6a 01                	push   $0x1
f0101970:	ff 75 10             	pushl  0x10(%ebp)
f0101973:	ff 75 08             	pushl  0x8(%ebp)
f0101976:	e8 bc fe ff ff       	call   f0101837 <pgdir_walk>
f010197b:	89 c6                	mov    %eax,%esi
  if (pgtbl_entry == NULL) {
f010197d:	83 c4 10             	add    $0x10,%esp
    return -E_NO_MEM;
f0101980:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0101985:	85 f6                	test   %esi,%esi
f0101987:	0f 84 bf 00 00 00    	je     f0101a4c <page_insert+0xe7>
  }

  if (*pgtbl_entry & PTE_P) {
f010198d:	8b 06                	mov    (%esi),%eax
f010198f:	a8 01                	test   $0x1,%al
f0101991:	74 7c                	je     f0101a0f <page_insert+0xaa>
    if (PTE_ADDR(*pgtbl_entry) == page2pa(pp)) {
f0101993:	89 c3                	mov    %eax,%ebx
f0101995:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f010199b:	8b 3d 7c 68 2f f0    	mov    0xf02f687c,%edi
f01019a1:	8b 55 0c             	mov    0xc(%ebp),%edx
f01019a4:	29 fa                	sub    %edi,%edx
f01019a6:	c1 fa 02             	sar    $0x2,%edx
f01019a9:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01019ac:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01019af:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01019b2:	89 c1                	mov    %eax,%ecx
f01019b4:	c1 e1 08             	shl    $0x8,%ecx
f01019b7:	01 c8                	add    %ecx,%eax
f01019b9:	89 c1                	mov    %eax,%ecx
f01019bb:	c1 e1 10             	shl    $0x10,%ecx
f01019be:	01 c8                	add    %ecx,%eax
f01019c0:	8d 04 42             	lea    (%edx,%eax,2),%eax
f01019c3:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01019c6:	39 c3                	cmp    %eax,%ebx
f01019c8:	75 34                	jne    f01019fe <page_insert+0x99>
f01019ca:	8b 55 0c             	mov    0xc(%ebp),%edx
f01019cd:	29 fa                	sub    %edi,%edx
f01019cf:	c1 fa 02             	sar    $0x2,%edx
f01019d2:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01019d5:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01019d8:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01019db:	89 c1                	mov    %eax,%ecx
f01019dd:	c1 e1 08             	shl    $0x8,%ecx
f01019e0:	01 c8                	add    %ecx,%eax
f01019e2:	89 c1                	mov    %eax,%ecx
f01019e4:	c1 e1 10             	shl    $0x10,%ecx
f01019e7:	01 c8                	add    %ecx,%eax
f01019e9:	8d 04 42             	lea    (%edx,%eax,2),%eax
f01019ec:	c1 e0 0c             	shl    $0xc,%eax
f01019ef:	0b 45 14             	or     0x14(%ebp),%eax
f01019f2:	83 c8 01             	or     $0x1,%eax
f01019f5:	89 06                	mov    %eax,(%esi)
      *pgtbl_entry = page2pa(pp) | perm | PTE_P;
      return 0;
f01019f7:	b8 00 00 00 00       	mov    $0x0,%eax
f01019fc:	eb 4e                	jmp    f0101a4c <page_insert+0xe7>
    }
    page_remove(pgdir, va);
f01019fe:	83 ec 08             	sub    $0x8,%esp
f0101a01:	ff 75 10             	pushl  0x10(%ebp)
f0101a04:	ff 75 08             	pushl  0x8(%ebp)
f0101a07:	e8 20 01 00 00       	call   f0101b2c <page_remove>
f0101a0c:	83 c4 10             	add    $0x10,%esp

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101a0f:	8b 55 0c             	mov    0xc(%ebp),%edx
f0101a12:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0101a18:	c1 fa 02             	sar    $0x2,%edx
f0101a1b:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101a1e:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101a21:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101a24:	89 c1                	mov    %eax,%ecx
f0101a26:	c1 e1 08             	shl    $0x8,%ecx
f0101a29:	01 c8                	add    %ecx,%eax
f0101a2b:	89 c1                	mov    %eax,%ecx
f0101a2d:	c1 e1 10             	shl    $0x10,%ecx
f0101a30:	01 c8                	add    %ecx,%eax
f0101a32:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0101a35:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101a38:	0b 45 14             	or     0x14(%ebp),%eax
f0101a3b:	83 c8 01             	or     $0x1,%eax
f0101a3e:	89 06                	mov    %eax,(%esi)
  }

  *pgtbl_entry = page2pa(pp) | perm | PTE_P;
  pp->pp_ref++;
f0101a40:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101a43:	66 ff 40 08          	incw   0x8(%eax)

  return 0;
f0101a47:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101a4c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0101a4f:	5b                   	pop    %ebx
f0101a50:	5e                   	pop    %esi
f0101a51:	5f                   	pop    %edi
f0101a52:	c9                   	leave  
f0101a53:	c3                   	ret    

f0101a54 <boot_map_segment>:

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
f0101a54:	55                   	push   %ebp
f0101a55:	89 e5                	mov    %esp,%ebp
f0101a57:	57                   	push   %edi
f0101a58:	56                   	push   %esi
f0101a59:	53                   	push   %ebx
f0101a5a:	83 ec 0c             	sub    $0xc,%esp
f0101a5d:	8b 75 10             	mov    0x10(%ebp),%esi
f0101a60:	8b 7d 18             	mov    0x18(%ebp),%edi
  // Fill this function in
  // seanyliu
  pte_t *pgtbl_entry;
  int idx;

  for (idx = 0; idx < size; idx += PGSIZE) {
f0101a63:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101a68:	39 f3                	cmp    %esi,%ebx
f0101a6a:	73 49                	jae    f0101ab5 <boot_map_segment+0x61>
    pgtbl_entry = pgdir_walk(pgdir, (void *)(la + idx), 1);
f0101a6c:	83 ec 04             	sub    $0x4,%esp
f0101a6f:	6a 01                	push   $0x1
f0101a71:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101a74:	01 d8                	add    %ebx,%eax
f0101a76:	50                   	push   %eax
f0101a77:	ff 75 08             	pushl  0x8(%ebp)
f0101a7a:	e8 b8 fd ff ff       	call   f0101837 <pgdir_walk>
f0101a7f:	89 c2                	mov    %eax,%edx
    if (pgtbl_entry == NULL) {
f0101a81:	83 c4 10             	add    $0x10,%esp
f0101a84:	85 c0                	test   %eax,%eax
f0101a86:	75 17                	jne    f0101a9f <boot_map_segment+0x4b>
      panic("boot_map_segment: page table could not be created");
f0101a88:	83 ec 04             	sub    $0x4,%esp
f0101a8b:	68 08 64 10 f0       	push   $0xf0106408
f0101a90:	68 d0 02 00 00       	push   $0x2d0
f0101a95:	68 22 68 10 f0       	push   $0xf0106822
f0101a9a:	e8 4f e6 ff ff       	call   f01000ee <_panic>
    }
    *pgtbl_entry = (pa + idx) | perm | PTE_P;
f0101a9f:	8b 45 14             	mov    0x14(%ebp),%eax
f0101aa2:	01 d8                	add    %ebx,%eax
f0101aa4:	09 f8                	or     %edi,%eax
f0101aa6:	83 c8 01             	or     $0x1,%eax
f0101aa9:	89 02                	mov    %eax,(%edx)
f0101aab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101ab1:	39 f3                	cmp    %esi,%ebx
f0101ab3:	72 b7                	jb     f0101a6c <boot_map_segment+0x18>
  }

}
f0101ab5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0101ab8:	5b                   	pop    %ebx
f0101ab9:	5e                   	pop    %esi
f0101aba:	5f                   	pop    %edi
f0101abb:	c9                   	leave  
f0101abc:	c3                   	ret    

f0101abd <page_lookup>:

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
f0101abd:	55                   	push   %ebp
f0101abe:	89 e5                	mov    %esp,%ebp
f0101ac0:	53                   	push   %ebx
f0101ac1:	83 ec 08             	sub    $0x8,%esp
f0101ac4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  // Fill this function in
  // return NULL;

  // seanyliu
  pte_t *pgtbl_entry;

  pgtbl_entry = pgdir_walk(pgdir, va, 0);
f0101ac7:	6a 00                	push   $0x0
f0101ac9:	ff 75 0c             	pushl  0xc(%ebp)
f0101acc:	ff 75 08             	pushl  0x8(%ebp)
f0101acf:	e8 63 fd ff ff       	call   f0101837 <pgdir_walk>
  if (pgtbl_entry == NULL || !(*pgtbl_entry & PTE_P)) {
f0101ad4:	83 c4 10             	add    $0x10,%esp
f0101ad7:	85 c0                	test   %eax,%eax
f0101ad9:	74 05                	je     f0101ae0 <page_lookup+0x23>
f0101adb:	f6 00 01             	testb  $0x1,(%eax)
f0101ade:	75 07                	jne    f0101ae7 <page_lookup+0x2a>
    return NULL;
f0101ae0:	b8 00 00 00 00       	mov    $0x0,%eax
f0101ae5:	eb 40                	jmp    f0101b27 <page_lookup+0x6a>
  }
  if (pte_store != 0) {
f0101ae7:	85 db                	test   %ebx,%ebx
f0101ae9:	74 02                	je     f0101aed <page_lookup+0x30>
    *pte_store = pgtbl_entry;
f0101aeb:	89 03                	mov    %eax,(%ebx)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
f0101aed:	8b 10                	mov    (%eax),%edx
f0101aef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PPN(pa) >= npage)
f0101af5:	89 d0                	mov    %edx,%eax
f0101af7:	c1 e8 0c             	shr    $0xc,%eax
f0101afa:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0101b00:	72 14                	jb     f0101b16 <page_lookup+0x59>
		panic("pa2page called with invalid pa");
f0101b02:	83 ec 04             	sub    $0x4,%esp
f0101b05:	68 b4 60 10 f0       	push   $0xf01060b4
f0101b0a:	6a 54                	push   $0x54
f0101b0c:	68 76 5f 10 f0       	push   $0xf0105f76
f0101b11:	e8 d8 e5 ff ff       	call   f01000ee <_panic>
f0101b16:	89 d0                	mov    %edx,%eax
f0101b18:	c1 e8 0c             	shr    $0xc,%eax
f0101b1b:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0101b1e:	8b 15 7c 68 2f f0    	mov    0xf02f687c,%edx
f0101b24:	8d 04 82             	lea    (%edx,%eax,4),%eax
  }
  return pa2page(PTE_ADDR(*pgtbl_entry));
}
f0101b27:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0101b2a:	c9                   	leave  
f0101b2b:	c3                   	ret    

f0101b2c <page_remove>:

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
f0101b2c:	55                   	push   %ebp
f0101b2d:	89 e5                	mov    %esp,%ebp
f0101b2f:	56                   	push   %esi
f0101b30:	53                   	push   %ebx
f0101b31:	83 ec 14             	sub    $0x14,%esp
f0101b34:	8b 75 08             	mov    0x8(%ebp),%esi
f0101b37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  // Fill this function in
  // seanyliu

  struct Page *page;
  pte_t *pgtbl_entry;

  page = page_lookup(pgdir, va, &pgtbl_entry);
f0101b3a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f0101b3d:	50                   	push   %eax
f0101b3e:	53                   	push   %ebx
f0101b3f:	56                   	push   %esi
f0101b40:	e8 78 ff ff ff       	call   f0101abd <page_lookup>
  if (page == NULL) {
f0101b45:	83 c4 10             	add    $0x10,%esp
f0101b48:	85 c0                	test   %eax,%eax
f0101b4a:	74 19                	je     f0101b65 <page_remove+0x39>
    return;
  }
  page_decref(page);
f0101b4c:	50                   	push   %eax
f0101b4d:	e8 c9 fc ff ff       	call   f010181b <page_decref>
  *pgtbl_entry = 0;
f0101b52:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f0101b55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  tlb_invalidate(pgdir, va);
f0101b5b:	83 ec 04             	sub    $0x4,%esp
f0101b5e:	53                   	push   %ebx
f0101b5f:	56                   	push   %esi
f0101b60:	e8 07 00 00 00       	call   f0101b6c <tlb_invalidate>

}
f0101b65:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0101b68:	5b                   	pop    %ebx
f0101b69:	5e                   	pop    %esi
f0101b6a:	c9                   	leave  
f0101b6b:	c3                   	ret    

f0101b6c <tlb_invalidate>:

//
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0101b6c:	55                   	push   %ebp
f0101b6d:	89 e5                	mov    %esp,%ebp
f0101b6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f0101b72:	83 3d c4 5b 2f f0 00 	cmpl   $0x0,0xf02f5bc4
f0101b79:	74 0e                	je     f0101b89 <tlb_invalidate+0x1d>
f0101b7b:	8b 15 c4 5b 2f f0    	mov    0xf02f5bc4,%edx
f0101b81:	8b 45 08             	mov    0x8(%ebp),%eax
f0101b84:	39 42 5c             	cmp    %eax,0x5c(%edx)
f0101b87:	75 03                	jne    f0101b8c <tlb_invalidate+0x20>

static __inline void 
invlpg(void *addr)
{ 
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101b89:	0f 01 39             	invlpg (%ecx)
		invlpg(va);
}
f0101b8c:	c9                   	leave  
f0101b8d:	c3                   	ret    

f0101b8e <user_mem_check>:

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
f0101b8e:	55                   	push   %ebp
f0101b8f:	89 e5                	mov    %esp,%ebp
f0101b91:	57                   	push   %edi
f0101b92:	56                   	push   %esi
f0101b93:	53                   	push   %ebx
f0101b94:	83 ec 0c             	sub    $0xc,%esp
f0101b97:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// LAB 3: Your code here. 
        // seanyliu
        int pidx;
	pte_t *ptep;
        const void* va_round = ROUNDDOWN(va, PGSIZE);
        int end = (int)va + len;
f0101b9a:	8b 45 10             	mov    0x10(%ebp),%eax
f0101b9d:	01 f8                	add    %edi,%eax
f0101b9f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
        for (pidx = (int)va_round; pidx < end; pidx += PGSIZE) {
f0101ba2:	89 fb                	mov    %edi,%ebx
f0101ba4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0101baa:	39 c3                	cmp    %eax,%ebx
f0101bac:	7d 50                	jge    f0101bfe <user_mem_check+0x70>
f0101bae:	8b 75 14             	mov    0x14(%ebp),%esi
f0101bb1:	83 ce 01             	or     $0x1,%esi
          ptep = pgdir_walk(env->env_pgdir, (void *)va, 0);
f0101bb4:	83 ec 04             	sub    $0x4,%esp
f0101bb7:	6a 00                	push   $0x0
f0101bb9:	57                   	push   %edi
f0101bba:	8b 55 08             	mov    0x8(%ebp),%edx
f0101bbd:	ff 72 5c             	pushl  0x5c(%edx)
f0101bc0:	e8 72 fc ff ff       	call   f0101837 <pgdir_walk>
          if ((ptep == NULL) || ((int)va >= ULIM) || ((*ptep & (perm | PTE_P)) != (perm | PTE_P))) {
f0101bc5:	83 c4 10             	add    $0x10,%esp
f0101bc8:	85 c0                	test   %eax,%eax
f0101bca:	74 10                	je     f0101bdc <user_mem_check+0x4e>
f0101bcc:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0101bd2:	77 08                	ja     f0101bdc <user_mem_check+0x4e>
f0101bd4:	89 f2                	mov    %esi,%edx
f0101bd6:	23 10                	and    (%eax),%edx
f0101bd8:	39 f2                	cmp    %esi,%edx
f0101bda:	74 17                	je     f0101bf3 <user_mem_check+0x65>
            user_mem_check_addr = (uintptr_t) pidx;
f0101bdc:	89 1d bc 5b 2f f0    	mov    %ebx,0xf02f5bbc

            // account for the rounding on va
            if (user_mem_check_addr < (uintptr_t)va) {
f0101be2:	39 df                	cmp    %ebx,%edi
f0101be4:	76 06                	jbe    f0101bec <user_mem_check+0x5e>
              user_mem_check_addr = (uintptr_t)va;
f0101be6:	89 3d bc 5b 2f f0    	mov    %edi,0xf02f5bbc
            }
            return -E_FAULT;
f0101bec:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0101bf1:	eb 10                	jmp    f0101c03 <user_mem_check+0x75>
f0101bf3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101bf9:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
f0101bfc:	7c b6                	jl     f0101bb4 <user_mem_check+0x26>
          }
        }


	return 0;
f0101bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0101c03:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0101c06:	5b                   	pop    %ebx
f0101c07:	5e                   	pop    %esi
f0101c08:	5f                   	pop    %edi
f0101c09:	c9                   	leave  
f0101c0a:	c3                   	ret    

f0101c0b <user_mem_assert>:

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
f0101c0b:	55                   	push   %ebp
f0101c0c:	89 e5                	mov    %esp,%ebp
f0101c0e:	53                   	push   %ebx
f0101c0f:	83 ec 04             	sub    $0x4,%esp
f0101c12:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0101c15:	8b 45 14             	mov    0x14(%ebp),%eax
f0101c18:	83 c8 04             	or     $0x4,%eax
f0101c1b:	50                   	push   %eax
f0101c1c:	ff 75 10             	pushl  0x10(%ebp)
f0101c1f:	ff 75 0c             	pushl  0xc(%ebp)
f0101c22:	53                   	push   %ebx
f0101c23:	e8 66 ff ff ff       	call   f0101b8e <user_mem_check>
f0101c28:	83 c4 10             	add    $0x10,%esp
f0101c2b:	85 c0                	test   %eax,%eax
f0101c2d:	79 21                	jns    f0101c50 <user_mem_assert+0x45>
		cprintf("[%08x] user_mem_check assertion failure for "
f0101c2f:	83 ec 04             	sub    $0x4,%esp
f0101c32:	ff 35 bc 5b 2f f0    	pushl  0xf02f5bbc
f0101c38:	ff 73 4c             	pushl  0x4c(%ebx)
f0101c3b:	68 3c 64 10 f0       	push   $0xf010643c
f0101c40:	e8 85 14 00 00       	call   f01030ca <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f0101c45:	89 1c 24             	mov    %ebx,(%esp)
f0101c48:	e8 6d 12 00 00       	call   f0102eba <env_destroy>
f0101c4d:	83 c4 10             	add    $0x10,%esp
	}
}
f0101c50:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0101c53:	c9                   	leave  
f0101c54:	c3                   	ret    

f0101c55 <page_check>:

// check page_insert, page_remove, &c
static void
page_check(void)
{
f0101c55:	55                   	push   %ebp
f0101c56:	89 e5                	mov    %esp,%ebp
f0101c58:	56                   	push   %esi
f0101c59:	53                   	push   %ebx
f0101c5a:	83 ec 2c             	sub    $0x2c,%esp
	struct Page *pp, *pp0, *pp1, *pp2;
	struct Page_list fl;
	pte_t *ptep, *ptep1;
	void *va;
	int i;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0101c5d:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
f0101c64:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
f0101c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,0xfffffff4(%ebp)
	assert(page_alloc(&pp0) == 0);
f0101c72:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f0101c75:	50                   	push   %eax
f0101c76:	e8 33 fb ff ff       	call   f01017ae <page_alloc>
f0101c7b:	83 c4 10             	add    $0x10,%esp
f0101c7e:	85 c0                	test   %eax,%eax
f0101c80:	74 19                	je     f0101c9b <page_check+0x46>
f0101c82:	68 2e 68 10 f0       	push   $0xf010682e
f0101c87:	68 44 68 10 f0       	push   $0xf0106844
f0101c8c:	68 6e 03 00 00       	push   $0x36e
f0101c91:	68 22 68 10 f0       	push   $0xf0106822
f0101c96:	e8 53 e4 ff ff       	call   f01000ee <_panic>
	assert(page_alloc(&pp1) == 0);
f0101c9b:	83 ec 0c             	sub    $0xc,%esp
f0101c9e:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0101ca1:	50                   	push   %eax
f0101ca2:	e8 07 fb ff ff       	call   f01017ae <page_alloc>
f0101ca7:	83 c4 10             	add    $0x10,%esp
f0101caa:	85 c0                	test   %eax,%eax
f0101cac:	74 19                	je     f0101cc7 <page_check+0x72>
f0101cae:	68 59 68 10 f0       	push   $0xf0106859
f0101cb3:	68 44 68 10 f0       	push   $0xf0106844
f0101cb8:	68 6f 03 00 00       	push   $0x36f
f0101cbd:	68 22 68 10 f0       	push   $0xf0106822
f0101cc2:	e8 27 e4 ff ff       	call   f01000ee <_panic>
	assert(page_alloc(&pp2) == 0);
f0101cc7:	83 ec 0c             	sub    $0xc,%esp
f0101cca:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0101ccd:	50                   	push   %eax
f0101cce:	e8 db fa ff ff       	call   f01017ae <page_alloc>
f0101cd3:	83 c4 10             	add    $0x10,%esp
f0101cd6:	85 c0                	test   %eax,%eax
f0101cd8:	74 19                	je     f0101cf3 <page_check+0x9e>
f0101cda:	68 6f 68 10 f0       	push   $0xf010686f
f0101cdf:	68 44 68 10 f0       	push   $0xf0106844
f0101ce4:	68 70 03 00 00       	push   $0x370
f0101ce9:	68 22 68 10 f0       	push   $0xf0106822
f0101cee:	e8 fb e3 ff ff       	call   f01000ee <_panic>

	assert(pp0);
f0101cf3:	83 7d f4 00          	cmpl   $0x0,0xfffffff4(%ebp)
f0101cf7:	75 19                	jne    f0101d12 <page_check+0xbd>
f0101cf9:	68 93 68 10 f0       	push   $0xf0106893
f0101cfe:	68 44 68 10 f0       	push   $0xf0106844
f0101d03:	68 72 03 00 00       	push   $0x372
f0101d08:	68 22 68 10 f0       	push   $0xf0106822
f0101d0d:	e8 dc e3 ff ff       	call   f01000ee <_panic>
	assert(pp1 && pp1 != pp0);
f0101d12:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0101d16:	74 08                	je     f0101d20 <page_check+0xcb>
f0101d18:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0101d1b:	3b 45 f4             	cmp    0xfffffff4(%ebp),%eax
f0101d1e:	75 19                	jne    f0101d39 <page_check+0xe4>
f0101d20:	68 85 68 10 f0       	push   $0xf0106885
f0101d25:	68 44 68 10 f0       	push   $0xf0106844
f0101d2a:	68 73 03 00 00       	push   $0x373
f0101d2f:	68 22 68 10 f0       	push   $0xf0106822
f0101d34:	e8 b5 e3 ff ff       	call   f01000ee <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d39:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
f0101d3d:	74 0d                	je     f0101d4c <page_check+0xf7>
f0101d3f:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0101d42:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
f0101d45:	74 05                	je     f0101d4c <page_check+0xf7>
f0101d47:	3b 45 f4             	cmp    0xfffffff4(%ebp),%eax
f0101d4a:	75 19                	jne    f0101d65 <page_check+0x110>
f0101d4c:	68 d0 62 10 f0       	push   $0xf01062d0
f0101d51:	68 44 68 10 f0       	push   $0xf0106844
f0101d56:	68 74 03 00 00       	push   $0x374
f0101d5b:	68 22 68 10 f0       	push   $0xf0106822
f0101d60:	e8 89 e3 ff ff       	call   f01000ee <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101d65:	8b 35 b8 5b 2f f0    	mov    0xf02f5bb8,%esi
	LIST_INIT(&page_free_list);
f0101d6b:	c7 05 b8 5b 2f f0 00 	movl   $0x0,0xf02f5bb8
f0101d72:	00 00 00 

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101d75:	83 ec 0c             	sub    $0xc,%esp
f0101d78:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0101d7b:	50                   	push   %eax
f0101d7c:	e8 2d fa ff ff       	call   f01017ae <page_alloc>
f0101d81:	83 c4 10             	add    $0x10,%esp
f0101d84:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101d87:	74 19                	je     f0101da2 <page_check+0x14d>
f0101d89:	68 eb 68 10 f0       	push   $0xf01068eb
f0101d8e:	68 44 68 10 f0       	push   $0xf0106844
f0101d93:	68 7b 03 00 00       	push   $0x37b
f0101d98:	68 22 68 10 f0       	push   $0xf0106822
f0101d9d:	e8 4c e3 ff ff       	call   f01000ee <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(boot_pgdir, (void *) 0x0, &ptep) == NULL);
f0101da2:	83 ec 04             	sub    $0x4,%esp
f0101da5:	8d 45 e4             	lea    0xffffffe4(%ebp),%eax
f0101da8:	50                   	push   %eax
f0101da9:	6a 00                	push   $0x0
f0101dab:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101db1:	e8 07 fd ff ff       	call   f0101abd <page_lookup>
f0101db6:	83 c4 10             	add    $0x10,%esp
f0101db9:	85 c0                	test   %eax,%eax
f0101dbb:	74 19                	je     f0101dd6 <page_check+0x181>
f0101dbd:	68 74 64 10 f0       	push   $0xf0106474
f0101dc2:	68 44 68 10 f0       	push   $0xf0106844
f0101dc7:	68 7e 03 00 00       	push   $0x37e
f0101dcc:	68 22 68 10 f0       	push   $0xf0106822
f0101dd1:	e8 18 e3 ff ff       	call   f01000ee <_panic>

	// there is no free memory, so we can't allocate a page table 
	assert(page_insert(boot_pgdir, pp1, 0x0, 0) < 0);
f0101dd6:	6a 00                	push   $0x0
f0101dd8:	6a 00                	push   $0x0
f0101dda:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0101ddd:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101de3:	e8 7d fb ff ff       	call   f0101965 <page_insert>
f0101de8:	83 c4 10             	add    $0x10,%esp
f0101deb:	85 c0                	test   %eax,%eax
f0101ded:	78 19                	js     f0101e08 <page_check+0x1b3>
f0101def:	68 ac 64 10 f0       	push   $0xf01064ac
f0101df4:	68 44 68 10 f0       	push   $0xf0106844
f0101df9:	68 81 03 00 00       	push   $0x381
f0101dfe:	68 22 68 10 f0       	push   $0xf0106822
f0101e03:	e8 e6 e2 ff ff       	call   f01000ee <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101e08:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f0101e0b:	e8 e3 f9 ff ff       	call   f01017f3 <page_free>
	assert(page_insert(boot_pgdir, pp1, 0x0, 0) == 0);
f0101e10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101e17:	6a 00                	push   $0x0
f0101e19:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0101e1c:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101e22:	e8 3e fb ff ff       	call   f0101965 <page_insert>
f0101e27:	83 c4 10             	add    $0x10,%esp
f0101e2a:	85 c0                	test   %eax,%eax
f0101e2c:	74 19                	je     f0101e47 <page_check+0x1f2>
f0101e2e:	68 d8 64 10 f0       	push   $0xf01064d8
f0101e33:	68 44 68 10 f0       	push   $0xf0106844
f0101e38:	68 85 03 00 00       	push   $0x385
f0101e3d:	68 22 68 10 f0       	push   $0xf0106822
f0101e42:	e8 a7 e2 ff ff       	call   f01000ee <_panic>
	assert(PTE_ADDR(boot_pgdir[0]) == page2pa(pp0));
f0101e47:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f0101e4c:	8b 18                	mov    (%eax),%ebx
f0101e4e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0101e54:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f0101e57:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0101e5d:	c1 fa 02             	sar    $0x2,%edx
f0101e60:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101e63:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101e66:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101e69:	89 c1                	mov    %eax,%ecx
f0101e6b:	c1 e1 08             	shl    $0x8,%ecx
f0101e6e:	01 c8                	add    %ecx,%eax
f0101e70:	89 c1                	mov    %eax,%ecx
f0101e72:	c1 e1 10             	shl    $0x10,%ecx
f0101e75:	01 c8                	add    %ecx,%eax
f0101e77:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0101e7a:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101e7d:	39 c3                	cmp    %eax,%ebx
f0101e7f:	74 19                	je     f0101e9a <page_check+0x245>
f0101e81:	68 04 65 10 f0       	push   $0xf0106504
f0101e86:	68 44 68 10 f0       	push   $0xf0106844
f0101e8b:	68 86 03 00 00       	push   $0x386
f0101e90:	68 22 68 10 f0       	push   $0xf0106822
f0101e95:	e8 54 e2 ff ff       	call   f01000ee <_panic>
	assert(check_va2pa(boot_pgdir, 0x0) == page2pa(pp1));
f0101e9a:	83 ec 08             	sub    $0x8,%esp
f0101e9d:	6a 00                	push   $0x0
f0101e9f:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101ea5:	e8 f2 f6 ff ff       	call   f010159c <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101eaa:	83 c4 10             	add    $0x10,%esp
f0101ead:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
f0101eb0:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f0101eb6:	c1 f9 02             	sar    $0x2,%ecx
f0101eb9:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f0101ebc:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0101ebf:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0101ec2:	89 d3                	mov    %edx,%ebx
f0101ec4:	c1 e3 08             	shl    $0x8,%ebx
f0101ec7:	01 da                	add    %ebx,%edx
f0101ec9:	89 d3                	mov    %edx,%ebx
f0101ecb:	c1 e3 10             	shl    $0x10,%ebx
f0101ece:	01 da                	add    %ebx,%edx
f0101ed0:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f0101ed3:	c1 e2 0c             	shl    $0xc,%edx
f0101ed6:	39 d0                	cmp    %edx,%eax
f0101ed8:	74 19                	je     f0101ef3 <page_check+0x29e>
f0101eda:	68 2c 65 10 f0       	push   $0xf010652c
f0101edf:	68 44 68 10 f0       	push   $0xf0106844
f0101ee4:	68 87 03 00 00       	push   $0x387
f0101ee9:	68 22 68 10 f0       	push   $0xf0106822
f0101eee:	e8 fb e1 ff ff       	call   f01000ee <_panic>
	assert(pp1->pp_ref == 1);
f0101ef3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0101ef6:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f0101efb:	74 19                	je     f0101f16 <page_check+0x2c1>
f0101efd:	68 1f 69 10 f0       	push   $0xf010691f
f0101f02:	68 44 68 10 f0       	push   $0xf0106844
f0101f07:	68 88 03 00 00       	push   $0x388
f0101f0c:	68 22 68 10 f0       	push   $0xf0106822
f0101f11:	e8 d8 e1 ff ff       	call   f01000ee <_panic>
	assert(pp0->pp_ref == 1);
f0101f16:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f0101f19:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f0101f1e:	74 19                	je     f0101f39 <page_check+0x2e4>
f0101f20:	68 30 69 10 f0       	push   $0xf0106930
f0101f25:	68 44 68 10 f0       	push   $0xf0106844
f0101f2a:	68 89 03 00 00       	push   $0x389
f0101f2f:	68 22 68 10 f0       	push   $0xf0106822
f0101f34:	e8 b5 e1 ff ff       	call   f01000ee <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, 0) == 0);
f0101f39:	6a 00                	push   $0x0
f0101f3b:	68 00 10 00 00       	push   $0x1000
f0101f40:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0101f43:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101f49:	e8 17 fa ff ff       	call   f0101965 <page_insert>
f0101f4e:	83 c4 10             	add    $0x10,%esp
f0101f51:	85 c0                	test   %eax,%eax
f0101f53:	74 19                	je     f0101f6e <page_check+0x319>
f0101f55:	68 5c 65 10 f0       	push   $0xf010655c
f0101f5a:	68 44 68 10 f0       	push   $0xf0106844
f0101f5f:	68 8c 03 00 00       	push   $0x38c
f0101f64:	68 22 68 10 f0       	push   $0xf0106822
f0101f69:	e8 80 e1 ff ff       	call   f01000ee <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f0101f6e:	83 ec 08             	sub    $0x8,%esp
f0101f71:	68 00 10 00 00       	push   $0x1000
f0101f76:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0101f7c:	e8 1b f6 ff ff       	call   f010159c <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0101f81:	83 c4 10             	add    $0x10,%esp
f0101f84:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
f0101f87:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f0101f8d:	c1 f9 02             	sar    $0x2,%ecx
f0101f90:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f0101f93:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0101f96:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0101f99:	89 d3                	mov    %edx,%ebx
f0101f9b:	c1 e3 08             	shl    $0x8,%ebx
f0101f9e:	01 da                	add    %ebx,%edx
f0101fa0:	89 d3                	mov    %edx,%ebx
f0101fa2:	c1 e3 10             	shl    $0x10,%ebx
f0101fa5:	01 da                	add    %ebx,%edx
f0101fa7:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f0101faa:	c1 e2 0c             	shl    $0xc,%edx
f0101fad:	39 d0                	cmp    %edx,%eax
f0101faf:	74 19                	je     f0101fca <page_check+0x375>
f0101fb1:	68 94 65 10 f0       	push   $0xf0106594
f0101fb6:	68 44 68 10 f0       	push   $0xf0106844
f0101fbb:	68 8d 03 00 00       	push   $0x38d
f0101fc0:	68 22 68 10 f0       	push   $0xf0106822
f0101fc5:	e8 24 e1 ff ff       	call   f01000ee <_panic>
	assert(pp2->pp_ref == 1);
f0101fca:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0101fcd:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f0101fd2:	74 19                	je     f0101fed <page_check+0x398>
f0101fd4:	68 41 69 10 f0       	push   $0xf0106941
f0101fd9:	68 44 68 10 f0       	push   $0xf0106844
f0101fde:	68 8e 03 00 00       	push   $0x38e
f0101fe3:	68 22 68 10 f0       	push   $0xf0106822
f0101fe8:	e8 01 e1 ff ff       	call   f01000ee <_panic>

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101fed:	83 ec 0c             	sub    $0xc,%esp
f0101ff0:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0101ff3:	50                   	push   %eax
f0101ff4:	e8 b5 f7 ff ff       	call   f01017ae <page_alloc>
f0101ff9:	83 c4 10             	add    $0x10,%esp
f0101ffc:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101fff:	74 19                	je     f010201a <page_check+0x3c5>
f0102001:	68 eb 68 10 f0       	push   $0xf01068eb
f0102006:	68 44 68 10 f0       	push   $0xf0106844
f010200b:	68 91 03 00 00       	push   $0x391
f0102010:	68 22 68 10 f0       	push   $0xf0106822
f0102015:	e8 d4 e0 ff ff       	call   f01000ee <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, 0) == 0);
f010201a:	6a 00                	push   $0x0
f010201c:	68 00 10 00 00       	push   $0x1000
f0102021:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0102024:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010202a:	e8 36 f9 ff ff       	call   f0101965 <page_insert>
f010202f:	83 c4 10             	add    $0x10,%esp
f0102032:	85 c0                	test   %eax,%eax
f0102034:	74 19                	je     f010204f <page_check+0x3fa>
f0102036:	68 5c 65 10 f0       	push   $0xf010655c
f010203b:	68 44 68 10 f0       	push   $0xf0106844
f0102040:	68 94 03 00 00       	push   $0x394
f0102045:	68 22 68 10 f0       	push   $0xf0106822
f010204a:	e8 9f e0 ff ff       	call   f01000ee <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f010204f:	83 ec 08             	sub    $0x8,%esp
f0102052:	68 00 10 00 00       	push   $0x1000
f0102057:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010205d:	e8 3a f5 ff ff       	call   f010159c <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0102062:	83 c4 10             	add    $0x10,%esp
f0102065:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
f0102068:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f010206e:	c1 f9 02             	sar    $0x2,%ecx
f0102071:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f0102074:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0102077:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f010207a:	89 d3                	mov    %edx,%ebx
f010207c:	c1 e3 08             	shl    $0x8,%ebx
f010207f:	01 da                	add    %ebx,%edx
f0102081:	89 d3                	mov    %edx,%ebx
f0102083:	c1 e3 10             	shl    $0x10,%ebx
f0102086:	01 da                	add    %ebx,%edx
f0102088:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f010208b:	c1 e2 0c             	shl    $0xc,%edx
f010208e:	39 d0                	cmp    %edx,%eax
f0102090:	74 19                	je     f01020ab <page_check+0x456>
f0102092:	68 94 65 10 f0       	push   $0xf0106594
f0102097:	68 44 68 10 f0       	push   $0xf0106844
f010209c:	68 95 03 00 00       	push   $0x395
f01020a1:	68 22 68 10 f0       	push   $0xf0106822
f01020a6:	e8 43 e0 ff ff       	call   f01000ee <_panic>
	assert(pp2->pp_ref == 1);
f01020ab:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f01020ae:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f01020b3:	74 19                	je     f01020ce <page_check+0x479>
f01020b5:	68 41 69 10 f0       	push   $0xf0106941
f01020ba:	68 44 68 10 f0       	push   $0xf0106844
f01020bf:	68 96 03 00 00       	push   $0x396
f01020c4:	68 22 68 10 f0       	push   $0xf0106822
f01020c9:	e8 20 e0 ff ff       	call   f01000ee <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(page_alloc(&pp) == -E_NO_MEM);
f01020ce:	83 ec 0c             	sub    $0xc,%esp
f01020d1:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f01020d4:	50                   	push   %eax
f01020d5:	e8 d4 f6 ff ff       	call   f01017ae <page_alloc>
f01020da:	83 c4 10             	add    $0x10,%esp
f01020dd:	83 f8 fc             	cmp    $0xfffffffc,%eax
f01020e0:	74 19                	je     f01020fb <page_check+0x4a6>
f01020e2:	68 eb 68 10 f0       	push   $0xf01068eb
f01020e7:	68 44 68 10 f0       	push   $0xf0106844
f01020ec:	68 9a 03 00 00       	push   $0x39a
f01020f1:	68 22 68 10 f0       	push   $0xf0106822
f01020f6:	e8 f3 df ff ff       	call   f01000ee <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = KADDR(PTE_ADDR(boot_pgdir[PDX(PGSIZE)]));
f01020fb:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f0102100:	8b 10                	mov    (%eax),%edx
f0102102:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102108:	89 d0                	mov    %edx,%eax
f010210a:	c1 e8 0c             	shr    $0xc,%eax
f010210d:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102113:	72 15                	jb     f010212a <page_check+0x4d5>
f0102115:	52                   	push   %edx
f0102116:	68 ac 62 10 f0       	push   $0xf01062ac
f010211b:	68 9d 03 00 00       	push   $0x39d
f0102120:	68 22 68 10 f0       	push   $0xf0106822
f0102125:	e8 c4 df ff ff       	call   f01000ee <_panic>
f010212a:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f0102130:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
	assert(pgdir_walk(boot_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102133:	83 ec 04             	sub    $0x4,%esp
f0102136:	6a 00                	push   $0x0
f0102138:	68 00 10 00 00       	push   $0x1000
f010213d:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102143:	e8 ef f6 ff ff       	call   f0101837 <pgdir_walk>
f0102148:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
f010214b:	83 c2 04             	add    $0x4,%edx
f010214e:	83 c4 10             	add    $0x10,%esp
f0102151:	39 d0                	cmp    %edx,%eax
f0102153:	74 19                	je     f010216e <page_check+0x519>
f0102155:	68 c4 65 10 f0       	push   $0xf01065c4
f010215a:	68 44 68 10 f0       	push   $0xf0106844
f010215f:	68 9e 03 00 00       	push   $0x39e
f0102164:	68 22 68 10 f0       	push   $0xf0106822
f0102169:	e8 80 df ff ff       	call   f01000ee <_panic>

	// should be able to change permissions too.
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, PTE_U) == 0);
f010216e:	6a 04                	push   $0x4
f0102170:	68 00 10 00 00       	push   $0x1000
f0102175:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0102178:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010217e:	e8 e2 f7 ff ff       	call   f0101965 <page_insert>
f0102183:	83 c4 10             	add    $0x10,%esp
f0102186:	85 c0                	test   %eax,%eax
f0102188:	74 19                	je     f01021a3 <page_check+0x54e>
f010218a:	68 04 66 10 f0       	push   $0xf0106604
f010218f:	68 44 68 10 f0       	push   $0xf0106844
f0102194:	68 a1 03 00 00       	push   $0x3a1
f0102199:	68 22 68 10 f0       	push   $0xf0106822
f010219e:	e8 4b df ff ff       	call   f01000ee <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f01021a3:	83 ec 08             	sub    $0x8,%esp
f01021a6:	68 00 10 00 00       	push   $0x1000
f01021ab:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f01021b1:	e8 e6 f3 ff ff       	call   f010159c <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01021b6:	83 c4 10             	add    $0x10,%esp
f01021b9:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
f01021bc:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f01021c2:	c1 f9 02             	sar    $0x2,%ecx
f01021c5:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f01021c8:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f01021cb:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f01021ce:	89 d3                	mov    %edx,%ebx
f01021d0:	c1 e3 08             	shl    $0x8,%ebx
f01021d3:	01 da                	add    %ebx,%edx
f01021d5:	89 d3                	mov    %edx,%ebx
f01021d7:	c1 e3 10             	shl    $0x10,%ebx
f01021da:	01 da                	add    %ebx,%edx
f01021dc:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f01021df:	c1 e2 0c             	shl    $0xc,%edx
f01021e2:	39 d0                	cmp    %edx,%eax
f01021e4:	74 19                	je     f01021ff <page_check+0x5aa>
f01021e6:	68 94 65 10 f0       	push   $0xf0106594
f01021eb:	68 44 68 10 f0       	push   $0xf0106844
f01021f0:	68 a2 03 00 00       	push   $0x3a2
f01021f5:	68 22 68 10 f0       	push   $0xf0106822
f01021fa:	e8 ef de ff ff       	call   f01000ee <_panic>
	assert(pp2->pp_ref == 1);
f01021ff:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0102202:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f0102207:	74 19                	je     f0102222 <page_check+0x5cd>
f0102209:	68 41 69 10 f0       	push   $0xf0106941
f010220e:	68 44 68 10 f0       	push   $0xf0106844
f0102213:	68 a3 03 00 00       	push   $0x3a3
f0102218:	68 22 68 10 f0       	push   $0xf0106822
f010221d:	e8 cc de ff ff       	call   f01000ee <_panic>
	assert(*pgdir_walk(boot_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102222:	83 ec 04             	sub    $0x4,%esp
f0102225:	6a 00                	push   $0x0
f0102227:	68 00 10 00 00       	push   $0x1000
f010222c:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102232:	e8 00 f6 ff ff       	call   f0101837 <pgdir_walk>
f0102237:	83 c4 10             	add    $0x10,%esp
f010223a:	f6 00 04             	testb  $0x4,(%eax)
f010223d:	75 19                	jne    f0102258 <page_check+0x603>
f010223f:	68 40 66 10 f0       	push   $0xf0106640
f0102244:	68 44 68 10 f0       	push   $0xf0106844
f0102249:	68 a4 03 00 00       	push   $0x3a4
f010224e:	68 22 68 10 f0       	push   $0xf0106822
f0102253:	e8 96 de ff ff       	call   f01000ee <_panic>
	assert(boot_pgdir[0] & PTE_U);
f0102258:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f010225d:	f6 00 04             	testb  $0x4,(%eax)
f0102260:	75 19                	jne    f010227b <page_check+0x626>
f0102262:	68 52 69 10 f0       	push   $0xf0106952
f0102267:	68 44 68 10 f0       	push   $0xf0106844
f010226c:	68 a5 03 00 00       	push   $0x3a5
f0102271:	68 22 68 10 f0       	push   $0xf0106822
f0102276:	e8 73 de ff ff       	call   f01000ee <_panic>
	
	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(boot_pgdir, pp0, (void*) PTSIZE, 0) < 0);
f010227b:	6a 00                	push   $0x0
f010227d:	68 00 00 40 00       	push   $0x400000
f0102282:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f0102285:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010228b:	e8 d5 f6 ff ff       	call   f0101965 <page_insert>
f0102290:	83 c4 10             	add    $0x10,%esp
f0102293:	85 c0                	test   %eax,%eax
f0102295:	78 19                	js     f01022b0 <page_check+0x65b>
f0102297:	68 74 66 10 f0       	push   $0xf0106674
f010229c:	68 44 68 10 f0       	push   $0xf0106844
f01022a1:	68 a8 03 00 00       	push   $0x3a8
f01022a6:	68 22 68 10 f0       	push   $0xf0106822
f01022ab:	e8 3e de ff ff       	call   f01000ee <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(boot_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01022b0:	6a 00                	push   $0x0
f01022b2:	68 00 10 00 00       	push   $0x1000
f01022b7:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f01022ba:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f01022c0:	e8 a0 f6 ff ff       	call   f0101965 <page_insert>
f01022c5:	83 c4 10             	add    $0x10,%esp
f01022c8:	85 c0                	test   %eax,%eax
f01022ca:	74 19                	je     f01022e5 <page_check+0x690>
f01022cc:	68 a8 66 10 f0       	push   $0xf01066a8
f01022d1:	68 44 68 10 f0       	push   $0xf0106844
f01022d6:	68 ab 03 00 00       	push   $0x3ab
f01022db:	68 22 68 10 f0       	push   $0xf0106822
f01022e0:	e8 09 de ff ff       	call   f01000ee <_panic>
	assert(!(*pgdir_walk(boot_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01022e5:	83 ec 04             	sub    $0x4,%esp
f01022e8:	6a 00                	push   $0x0
f01022ea:	68 00 10 00 00       	push   $0x1000
f01022ef:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f01022f5:	e8 3d f5 ff ff       	call   f0101837 <pgdir_walk>
f01022fa:	83 c4 10             	add    $0x10,%esp
f01022fd:	f6 00 04             	testb  $0x4,(%eax)
f0102300:	74 19                	je     f010231b <page_check+0x6c6>
f0102302:	68 e0 66 10 f0       	push   $0xf01066e0
f0102307:	68 44 68 10 f0       	push   $0xf0106844
f010230c:	68 ac 03 00 00       	push   $0x3ac
f0102311:	68 22 68 10 f0       	push   $0xf0106822
f0102316:	e8 d3 dd ff ff       	call   f01000ee <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(boot_pgdir, 0) == page2pa(pp1));
f010231b:	83 ec 08             	sub    $0x8,%esp
f010231e:	6a 00                	push   $0x0
f0102320:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102326:	e8 71 f2 ff ff       	call   f010159c <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f010232b:	83 c4 10             	add    $0x10,%esp
f010232e:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
f0102331:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f0102337:	c1 f9 02             	sar    $0x2,%ecx
f010233a:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f010233d:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0102340:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f0102343:	89 d3                	mov    %edx,%ebx
f0102345:	c1 e3 08             	shl    $0x8,%ebx
f0102348:	01 da                	add    %ebx,%edx
f010234a:	89 d3                	mov    %edx,%ebx
f010234c:	c1 e3 10             	shl    $0x10,%ebx
f010234f:	01 da                	add    %ebx,%edx
f0102351:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f0102354:	c1 e2 0c             	shl    $0xc,%edx
f0102357:	39 d0                	cmp    %edx,%eax
f0102359:	74 19                	je     f0102374 <page_check+0x71f>
f010235b:	68 18 67 10 f0       	push   $0xf0106718
f0102360:	68 44 68 10 f0       	push   $0xf0106844
f0102365:	68 af 03 00 00       	push   $0x3af
f010236a:	68 22 68 10 f0       	push   $0xf0106822
f010236f:	e8 7a dd ff ff       	call   f01000ee <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp1));
f0102374:	83 ec 08             	sub    $0x8,%esp
f0102377:	68 00 10 00 00       	push   $0x1000
f010237c:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102382:	e8 15 f2 ff ff       	call   f010159c <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0102387:	83 c4 10             	add    $0x10,%esp
f010238a:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
f010238d:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f0102393:	c1 f9 02             	sar    $0x2,%ecx
f0102396:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f0102399:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f010239c:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f010239f:	89 d3                	mov    %edx,%ebx
f01023a1:	c1 e3 08             	shl    $0x8,%ebx
f01023a4:	01 da                	add    %ebx,%edx
f01023a6:	89 d3                	mov    %edx,%ebx
f01023a8:	c1 e3 10             	shl    $0x10,%ebx
f01023ab:	01 da                	add    %ebx,%edx
f01023ad:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f01023b0:	c1 e2 0c             	shl    $0xc,%edx
f01023b3:	39 d0                	cmp    %edx,%eax
f01023b5:	74 19                	je     f01023d0 <page_check+0x77b>
f01023b7:	68 44 67 10 f0       	push   $0xf0106744
f01023bc:	68 44 68 10 f0       	push   $0xf0106844
f01023c1:	68 b0 03 00 00       	push   $0x3b0
f01023c6:	68 22 68 10 f0       	push   $0xf0106822
f01023cb:	e8 1e dd ff ff       	call   f01000ee <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01023d0:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f01023d3:	66 83 78 08 02       	cmpw   $0x2,0x8(%eax)
f01023d8:	74 19                	je     f01023f3 <page_check+0x79e>
f01023da:	68 68 69 10 f0       	push   $0xf0106968
f01023df:	68 44 68 10 f0       	push   $0xf0106844
f01023e4:	68 b2 03 00 00       	push   $0x3b2
f01023e9:	68 22 68 10 f0       	push   $0xf0106822
f01023ee:	e8 fb dc ff ff       	call   f01000ee <_panic>
	assert(pp2->pp_ref == 0);
f01023f3:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f01023f6:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f01023fb:	74 19                	je     f0102416 <page_check+0x7c1>
f01023fd:	68 79 69 10 f0       	push   $0xf0106979
f0102402:	68 44 68 10 f0       	push   $0xf0106844
f0102407:	68 b3 03 00 00       	push   $0x3b3
f010240c:	68 22 68 10 f0       	push   $0xf0106822
f0102411:	e8 d8 dc ff ff       	call   f01000ee <_panic>

	// pp2 should be returned by page_alloc
	assert(page_alloc(&pp) == 0 && pp == pp2);
f0102416:	83 ec 0c             	sub    $0xc,%esp
f0102419:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f010241c:	50                   	push   %eax
f010241d:	e8 8c f3 ff ff       	call   f01017ae <page_alloc>
f0102422:	83 c4 10             	add    $0x10,%esp
f0102425:	85 c0                	test   %eax,%eax
f0102427:	75 08                	jne    f0102431 <page_check+0x7dc>
f0102429:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f010242c:	3b 45 ec             	cmp    0xffffffec(%ebp),%eax
f010242f:	74 19                	je     f010244a <page_check+0x7f5>
f0102431:	68 74 67 10 f0       	push   $0xf0106774
f0102436:	68 44 68 10 f0       	push   $0xf0106844
f010243b:	68 b6 03 00 00       	push   $0x3b6
f0102440:	68 22 68 10 f0       	push   $0xf0106822
f0102445:	e8 a4 dc ff ff       	call   f01000ee <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(boot_pgdir, 0x0);
f010244a:	83 ec 08             	sub    $0x8,%esp
f010244d:	6a 00                	push   $0x0
f010244f:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102455:	e8 d2 f6 ff ff       	call   f0101b2c <page_remove>
	assert(check_va2pa(boot_pgdir, 0x0) == ~0);
f010245a:	83 c4 08             	add    $0x8,%esp
f010245d:	6a 00                	push   $0x0
f010245f:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102465:	e8 32 f1 ff ff       	call   f010159c <check_va2pa>
f010246a:	83 c4 10             	add    $0x10,%esp
f010246d:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102470:	74 19                	je     f010248b <page_check+0x836>
f0102472:	68 98 67 10 f0       	push   $0xf0106798
f0102477:	68 44 68 10 f0       	push   $0xf0106844
f010247c:	68 ba 03 00 00       	push   $0x3ba
f0102481:	68 22 68 10 f0       	push   $0xf0106822
f0102486:	e8 63 dc ff ff       	call   f01000ee <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp1));
f010248b:	83 ec 08             	sub    $0x8,%esp
f010248e:	68 00 10 00 00       	push   $0x1000
f0102493:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f0102499:	e8 fe f0 ff ff       	call   f010159c <check_va2pa>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f010249e:	83 c4 10             	add    $0x10,%esp
f01024a1:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
f01024a4:	2b 0d 7c 68 2f f0    	sub    0xf02f687c,%ecx
f01024aa:	c1 f9 02             	sar    $0x2,%ecx
f01024ad:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f01024b0:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f01024b3:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f01024b6:	89 d3                	mov    %edx,%ebx
f01024b8:	c1 e3 08             	shl    $0x8,%ebx
f01024bb:	01 da                	add    %ebx,%edx
f01024bd:	89 d3                	mov    %edx,%ebx
f01024bf:	c1 e3 10             	shl    $0x10,%ebx
f01024c2:	01 da                	add    %ebx,%edx
f01024c4:	8d 14 51             	lea    (%ecx,%edx,2),%edx
f01024c7:	c1 e2 0c             	shl    $0xc,%edx
f01024ca:	39 d0                	cmp    %edx,%eax
f01024cc:	74 19                	je     f01024e7 <page_check+0x892>
f01024ce:	68 44 67 10 f0       	push   $0xf0106744
f01024d3:	68 44 68 10 f0       	push   $0xf0106844
f01024d8:	68 bb 03 00 00       	push   $0x3bb
f01024dd:	68 22 68 10 f0       	push   $0xf0106822
f01024e2:	e8 07 dc ff ff       	call   f01000ee <_panic>
	assert(pp1->pp_ref == 1);
f01024e7:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f01024ea:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f01024ef:	74 19                	je     f010250a <page_check+0x8b5>
f01024f1:	68 1f 69 10 f0       	push   $0xf010691f
f01024f6:	68 44 68 10 f0       	push   $0xf0106844
f01024fb:	68 bc 03 00 00       	push   $0x3bc
f0102500:	68 22 68 10 f0       	push   $0xf0106822
f0102505:	e8 e4 db ff ff       	call   f01000ee <_panic>
	assert(pp2->pp_ref == 0);
f010250a:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f010250d:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f0102512:	74 19                	je     f010252d <page_check+0x8d8>
f0102514:	68 79 69 10 f0       	push   $0xf0106979
f0102519:	68 44 68 10 f0       	push   $0xf0106844
f010251e:	68 bd 03 00 00       	push   $0x3bd
f0102523:	68 22 68 10 f0       	push   $0xf0106822
f0102528:	e8 c1 db ff ff       	call   f01000ee <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(boot_pgdir, (void*) PGSIZE);
f010252d:	83 ec 08             	sub    $0x8,%esp
f0102530:	68 00 10 00 00       	push   $0x1000
f0102535:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010253b:	e8 ec f5 ff ff       	call   f0101b2c <page_remove>
	assert(check_va2pa(boot_pgdir, 0x0) == ~0);
f0102540:	83 c4 08             	add    $0x8,%esp
f0102543:	6a 00                	push   $0x0
f0102545:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010254b:	e8 4c f0 ff ff       	call   f010159c <check_va2pa>
f0102550:	83 c4 10             	add    $0x10,%esp
f0102553:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102556:	74 19                	je     f0102571 <page_check+0x91c>
f0102558:	68 98 67 10 f0       	push   $0xf0106798
f010255d:	68 44 68 10 f0       	push   $0xf0106844
f0102562:	68 c1 03 00 00       	push   $0x3c1
f0102567:	68 22 68 10 f0       	push   $0xf0106822
f010256c:	e8 7d db ff ff       	call   f01000ee <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == ~0);
f0102571:	83 ec 08             	sub    $0x8,%esp
f0102574:	68 00 10 00 00       	push   $0x1000
f0102579:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f010257f:	e8 18 f0 ff ff       	call   f010159c <check_va2pa>
f0102584:	83 c4 10             	add    $0x10,%esp
f0102587:	83 f8 ff             	cmp    $0xffffffff,%eax
f010258a:	74 19                	je     f01025a5 <page_check+0x950>
f010258c:	68 bc 67 10 f0       	push   $0xf01067bc
f0102591:	68 44 68 10 f0       	push   $0xf0106844
f0102596:	68 c2 03 00 00       	push   $0x3c2
f010259b:	68 22 68 10 f0       	push   $0xf0106822
f01025a0:	e8 49 db ff ff       	call   f01000ee <_panic>
	assert(pp1->pp_ref == 0);
f01025a5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f01025a8:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f01025ad:	74 19                	je     f01025c8 <page_check+0x973>
f01025af:	68 8a 69 10 f0       	push   $0xf010698a
f01025b4:	68 44 68 10 f0       	push   $0xf0106844
f01025b9:	68 c3 03 00 00       	push   $0x3c3
f01025be:	68 22 68 10 f0       	push   $0xf0106822
f01025c3:	e8 26 db ff ff       	call   f01000ee <_panic>
	assert(pp2->pp_ref == 0);
f01025c8:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f01025cb:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f01025d0:	74 19                	je     f01025eb <page_check+0x996>
f01025d2:	68 79 69 10 f0       	push   $0xf0106979
f01025d7:	68 44 68 10 f0       	push   $0xf0106844
f01025dc:	68 c4 03 00 00       	push   $0x3c4
f01025e1:	68 22 68 10 f0       	push   $0xf0106822
f01025e6:	e8 03 db ff ff       	call   f01000ee <_panic>

	// so it should be returned by page_alloc
	assert(page_alloc(&pp) == 0 && pp == pp1);
f01025eb:	83 ec 0c             	sub    $0xc,%esp
f01025ee:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f01025f1:	50                   	push   %eax
f01025f2:	e8 b7 f1 ff ff       	call   f01017ae <page_alloc>
f01025f7:	83 c4 10             	add    $0x10,%esp
f01025fa:	85 c0                	test   %eax,%eax
f01025fc:	75 08                	jne    f0102606 <page_check+0x9b1>
f01025fe:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f0102601:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
f0102604:	74 19                	je     f010261f <page_check+0x9ca>
f0102606:	68 e4 67 10 f0       	push   $0xf01067e4
f010260b:	68 44 68 10 f0       	push   $0xf0106844
f0102610:	68 c7 03 00 00       	push   $0x3c7
f0102615:	68 22 68 10 f0       	push   $0xf0106822
f010261a:	e8 cf da ff ff       	call   f01000ee <_panic>

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f010261f:	83 ec 0c             	sub    $0xc,%esp
f0102622:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0102625:	50                   	push   %eax
f0102626:	e8 83 f1 ff ff       	call   f01017ae <page_alloc>
f010262b:	83 c4 10             	add    $0x10,%esp
f010262e:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0102631:	74 19                	je     f010264c <page_check+0x9f7>
f0102633:	68 eb 68 10 f0       	push   $0xf01068eb
f0102638:	68 44 68 10 f0       	push   $0xf0106844
f010263d:	68 ca 03 00 00       	push   $0x3ca
f0102642:	68 22 68 10 f0       	push   $0xf0106822
f0102647:	e8 a2 da ff ff       	call   f01000ee <_panic>
	
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
f010264c:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f0102651:	8b 18                	mov    (%eax),%ebx
f0102653:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0102659:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f010265c:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0102662:	c1 fa 02             	sar    $0x2,%edx
f0102665:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0102668:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010266b:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010266e:	89 c1                	mov    %eax,%ecx
f0102670:	c1 e1 08             	shl    $0x8,%ecx
f0102673:	01 c8                	add    %ecx,%eax
f0102675:	89 c1                	mov    %eax,%ecx
f0102677:	c1 e1 10             	shl    $0x10,%ecx
f010267a:	01 c8                	add    %ecx,%eax
f010267c:	8d 04 42             	lea    (%edx,%eax,2),%eax
f010267f:	c1 e0 0c             	shl    $0xc,%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0102682:	39 c3                	cmp    %eax,%ebx
f0102684:	74 19                	je     f010269f <page_check+0xa4a>
f0102686:	68 04 65 10 f0       	push   $0xf0106504
f010268b:	68 44 68 10 f0       	push   $0xf0106844
f0102690:	68 dd 03 00 00       	push   $0x3dd
f0102695:	68 22 68 10 f0       	push   $0xf0106822
f010269a:	e8 4f da ff ff       	call   f01000ee <_panic>
	boot_pgdir[0] = 0;
f010269f:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f01026a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f01026aa:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f01026ad:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f01026b2:	74 19                	je     f01026cd <page_check+0xa78>
f01026b4:	68 30 69 10 f0       	push   $0xf0106930
f01026b9:	68 44 68 10 f0       	push   $0xf0106844
f01026be:	68 df 03 00 00       	push   $0x3df
f01026c3:	68 22 68 10 f0       	push   $0xf0106822
f01026c8:	e8 21 da ff ff       	call   f01000ee <_panic>
	pp0->pp_ref = 0;
f01026cd:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f01026d0:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
	
	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f01026d6:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f01026d9:	e8 15 f1 ff ff       	call   f01017f3 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
f01026de:	bb 00 10 40 00       	mov    $0x401000,%ebx
	ptep = pgdir_walk(boot_pgdir, va, 1);
f01026e3:	6a 01                	push   $0x1
f01026e5:	68 00 10 40 00       	push   $0x401000
f01026ea:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f01026f0:	e8 42 f1 ff ff       	call   f0101837 <pgdir_walk>
f01026f5:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
	ptep1 = KADDR(PTE_ADDR(boot_pgdir[PDX(va)]));
f01026f8:	83 c4 10             	add    $0x10,%esp
f01026fb:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f0102700:	8b 50 04             	mov    0x4(%eax),%edx
f0102703:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102709:	89 d0                	mov    %edx,%eax
f010270b:	c1 e8 0c             	shr    $0xc,%eax
f010270e:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102714:	72 15                	jb     f010272b <page_check+0xad6>
f0102716:	52                   	push   %edx
f0102717:	68 ac 62 10 f0       	push   $0xf01062ac
f010271c:	68 e6 03 00 00       	push   $0x3e6
f0102721:	68 22 68 10 f0       	push   $0xf0106822
f0102726:	e8 c3 d9 ff ff       	call   f01000ee <_panic>
	assert(ptep == ptep1 + PTX(va));
f010272b:	89 d8                	mov    %ebx,%eax
f010272d:	c1 e8 0a             	shr    $0xa,%eax
f0102730:	83 e0 04             	and    $0x4,%eax
f0102733:	8d 84 02 00 00 00 f0 	lea    0xf0000000(%edx,%eax,1),%eax
f010273a:	3b 45 e4             	cmp    0xffffffe4(%ebp),%eax
f010273d:	74 19                	je     f0102758 <page_check+0xb03>
f010273f:	68 9b 69 10 f0       	push   $0xf010699b
f0102744:	68 44 68 10 f0       	push   $0xf0106844
f0102749:	68 e7 03 00 00       	push   $0x3e7
f010274e:	68 22 68 10 f0       	push   $0xf0106822
f0102753:	e8 96 d9 ff ff       	call   f01000ee <_panic>
	boot_pgdir[PDX(va)] = 0;
f0102758:	89 da                	mov    %ebx,%edx
f010275a:	c1 ea 16             	shr    $0x16,%edx
f010275d:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f0102762:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
	pp0->pp_ref = 0;
f0102769:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f010276c:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0102772:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f0102775:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f010277b:	c1 fa 02             	sar    $0x2,%edx
f010277e:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0102781:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102784:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102787:	89 c1                	mov    %eax,%ecx
f0102789:	c1 e1 08             	shl    $0x8,%ecx
f010278c:	01 c8                	add    %ecx,%eax
f010278e:	89 c1                	mov    %eax,%ecx
f0102790:	c1 e1 10             	shl    $0x10,%ecx
f0102793:	01 c8                	add    %ecx,%eax
f0102795:	8d 04 42             	lea    (%edx,%eax,2),%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0102798:	89 c2                	mov    %eax,%edx
f010279a:	c1 e2 0c             	shl    $0xc,%edx
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
f010279d:	89 d0                	mov    %edx,%eax
f010279f:	c1 e8 0c             	shr    $0xc,%eax
f01027a2:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f01027a8:	72 12                	jb     f01027bc <page_check+0xb67>
f01027aa:	52                   	push   %edx
f01027ab:	68 ac 62 10 f0       	push   $0xf01062ac
f01027b0:	6a 5b                	push   $0x5b
f01027b2:	68 76 5f 10 f0       	push   $0xf0105f76
f01027b7:	e8 32 d9 ff ff       	call   f01000ee <_panic>
f01027bc:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f01027c2:	83 ec 04             	sub    $0x4,%esp
f01027c5:	68 00 10 00 00       	push   $0x1000
f01027ca:	68 ff 00 00 00       	push   $0xff
f01027cf:	50                   	push   %eax
f01027d0:	e8 c4 24 00 00       	call   f0104c99 <memset>
	
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
f01027d5:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f01027d8:	e8 16 f0 ff ff       	call   f01017f3 <page_free>
	pgdir_walk(boot_pgdir, 0x0, 1);
f01027dd:	6a 01                	push   $0x1
f01027df:	6a 00                	push   $0x0
f01027e1:	ff 35 78 68 2f f0    	pushl  0xf02f6878
f01027e7:	e8 4b f0 ff ff       	call   f0101837 <pgdir_walk>
}

static inline void*
page2kva(struct Page *pp)
{
f01027ec:	83 c4 20             	add    $0x20,%esp
f01027ef:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f01027f2:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f01027f8:	c1 fa 02             	sar    $0x2,%edx
f01027fb:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01027fe:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102801:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102804:	89 c1                	mov    %eax,%ecx
f0102806:	c1 e1 08             	shl    $0x8,%ecx
f0102809:	01 c8                	add    %ecx,%eax
f010280b:	89 c1                	mov    %eax,%ecx
f010280d:	c1 e1 10             	shl    $0x10,%ecx
f0102810:	01 c8                	add    %ecx,%eax
f0102812:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0102815:	89 c2                	mov    %eax,%edx
f0102817:	c1 e2 0c             	shl    $0xc,%edx
	return KADDR(page2pa(pp));
f010281a:	89 d0                	mov    %edx,%eax
f010281c:	c1 e8 0c             	shr    $0xc,%eax
f010281f:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102825:	72 12                	jb     f0102839 <page_check+0xbe4>
f0102827:	52                   	push   %edx
f0102828:	68 ac 62 10 f0       	push   $0xf01062ac
f010282d:	6a 5b                	push   $0x5b
f010282f:	68 76 5f 10 f0       	push   $0xf0105f76
f0102834:	e8 b5 d8 ff ff       	call   f01000ee <_panic>
f0102839:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f010283f:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
	ptep = page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f0102842:	ba 00 00 00 00       	mov    $0x0,%edx
		assert((ptep[i] & PTE_P) == 0);
f0102847:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f010284a:	f6 04 90 01          	testb  $0x1,(%eax,%edx,4)
f010284e:	74 19                	je     f0102869 <page_check+0xc14>
f0102850:	68 b3 69 10 f0       	push   $0xf01069b3
f0102855:	68 44 68 10 f0       	push   $0xf0106844
f010285a:	68 f1 03 00 00       	push   $0x3f1
f010285f:	68 22 68 10 f0       	push   $0xf0106822
f0102864:	e8 85 d8 ff ff       	call   f01000ee <_panic>
f0102869:	42                   	inc    %edx
f010286a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
f0102870:	7e d5                	jle    f0102847 <page_check+0xbf2>
	boot_pgdir[0] = 0;
f0102872:	a1 78 68 2f f0       	mov    0xf02f6878,%eax
f0102877:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f010287d:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
f0102880:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)

	// give free list back
	page_free_list = fl;
f0102886:	89 35 b8 5b 2f f0    	mov    %esi,0xf02f5bb8

	// free the pages we took
	page_free(pp0);
f010288c:	ff 75 f4             	pushl  0xfffffff4(%ebp)
f010288f:	e8 5f ef ff ff       	call   f01017f3 <page_free>
	page_free(pp1);
f0102894:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0102897:	e8 57 ef ff ff       	call   f01017f3 <page_free>
	page_free(pp2);
f010289c:	ff 75 ec             	pushl  0xffffffec(%ebp)
f010289f:	e8 4f ef ff ff       	call   f01017f3 <page_free>
	
	cprintf("page_check() succeeded!\n");
f01028a4:	68 ca 69 10 f0       	push   $0xf01069ca
f01028a9:	e8 1c 08 00 00       	call   f01030ca <cprintf>
}
f01028ae:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f01028b1:	5b                   	pop    %ebx
f01028b2:	5e                   	pop    %esi
f01028b3:	c9                   	leave  
f01028b4:	c3                   	ret    
f01028b5:	00 00                	add    %al,(%eax)
	...

f01028b8 <envid2env>:
//   On error, sets *penv to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f01028b8:	55                   	push   %ebp
f01028b9:	89 e5                	mov    %esp,%ebp
f01028bb:	53                   	push   %ebx
f01028bc:	8b 55 08             	mov    0x8(%ebp),%edx
f01028bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f01028c2:	85 d2                	test   %edx,%edx
f01028c4:	75 0e                	jne    f01028d4 <envid2env+0x1c>
		*env_store = curenv;
f01028c6:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f01028cb:	89 03                	mov    %eax,(%ebx)
		return 0;
f01028cd:	b8 00 00 00 00       	mov    $0x0,%eax
f01028d2:	eb 5c                	jmp    f0102930 <envid2env+0x78>
	}

	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f01028d4:	89 d1                	mov    %edx,%ecx
f01028d6:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
f01028dc:	89 c8                	mov    %ecx,%eax
f01028de:	c1 e0 07             	shl    $0x7,%eax
f01028e1:	89 c1                	mov    %eax,%ecx
f01028e3:	03 0d c0 5b 2f f0    	add    0xf02f5bc0,%ecx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f01028e9:	83 79 54 00          	cmpl   $0x0,0x54(%ecx)
f01028ed:	74 05                	je     f01028f4 <envid2env+0x3c>
f01028ef:	39 51 4c             	cmp    %edx,0x4c(%ecx)
f01028f2:	74 0d                	je     f0102901 <envid2env+0x49>
		*env_store = 0;
f01028f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return -E_BAD_ENV;
f01028fa:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01028ff:	eb 2f                	jmp    f0102930 <envid2env+0x78>
	}

	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0102901:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0102905:	74 22                	je     f0102929 <envid2env+0x71>
f0102907:	3b 0d c4 5b 2f f0    	cmp    0xf02f5bc4,%ecx
f010290d:	74 1a                	je     f0102929 <envid2env+0x71>
f010290f:	8b 51 50             	mov    0x50(%ecx),%edx
f0102912:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0102917:	3b 50 4c             	cmp    0x4c(%eax),%edx
f010291a:	74 0d                	je     f0102929 <envid2env+0x71>
		*env_store = 0;
f010291c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		return -E_BAD_ENV;
f0102922:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0102927:	eb 07                	jmp    f0102930 <envid2env+0x78>
	}

	*env_store = e;
f0102929:	89 0b                	mov    %ecx,(%ebx)
	return 0;
f010292b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0102930:	5b                   	pop    %ebx
f0102931:	c9                   	leave  
f0102932:	c3                   	ret    

f0102933 <env_init>:

//
// Mark all environments in 'envs' as free, set their env_ids to 0,
// and insert them into the env_free_list.
// Insert in reverse order, so that the first call to env_alloc()
// returns envs[0].
//
void
env_init(void)
{
f0102933:	55                   	push   %ebp
f0102934:	89 e5                	mov    %esp,%ebp
f0102936:	53                   	push   %ebx
  // LAB 3: Your code here.
  // seanyliu
  int i;
  LIST_INIT(&env_free_list);
f0102937:	c7 05 c8 5b 2f f0 00 	movl   $0x0,0xf02f5bc8
f010293e:	00 00 00 

  // Insert in reverse order, so that the first call to env_alloc()
  for (i = NENV-1; i >= 0; i--) {
f0102941:	bb ff 03 00 00       	mov    $0x3ff,%ebx
    envs[i].env_status = ENV_FREE;
f0102946:	89 d9                	mov    %ebx,%ecx
f0102948:	c1 e1 07             	shl    $0x7,%ecx
f010294b:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f0102950:	c7 44 01 54 00 00 00 	movl   $0x0,0x54(%ecx,%eax,1)
f0102957:	00 
    envs[i].env_id = 0;
f0102958:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f010295d:	c7 44 01 4c 00 00 00 	movl   $0x0,0x4c(%ecx,%eax,1)
f0102964:	00 
    LIST_INSERT_HEAD(&env_free_list, &envs[i], env_link);
f0102965:	8b 15 c8 5b 2f f0    	mov    0xf02f5bc8,%edx
f010296b:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f0102970:	89 54 01 44          	mov    %edx,0x44(%ecx,%eax,1)
f0102974:	85 d2                	test   %edx,%edx
f0102976:	74 14                	je     f010298c <env_init+0x59>
f0102978:	89 c8                	mov    %ecx,%eax
f010297a:	03 05 c0 5b 2f f0    	add    0xf02f5bc0,%eax
f0102980:	83 c0 44             	add    $0x44,%eax
f0102983:	8b 15 c8 5b 2f f0    	mov    0xf02f5bc8,%edx
f0102989:	89 42 48             	mov    %eax,0x48(%edx)
f010298c:	89 d9                	mov    %ebx,%ecx
f010298e:	c1 e1 07             	shl    $0x7,%ecx
f0102991:	8b 15 c0 5b 2f f0    	mov    0xf02f5bc0,%edx
f0102997:	8d 04 11             	lea    (%ecx,%edx,1),%eax
f010299a:	a3 c8 5b 2f f0       	mov    %eax,0xf02f5bc8
f010299f:	c7 44 11 48 c8 5b 2f 	movl   $0xf02f5bc8,0x48(%ecx,%edx,1)
f01029a6:	f0 
f01029a7:	4b                   	dec    %ebx
f01029a8:	79 9c                	jns    f0102946 <env_init+0x13>
  }

}
f01029aa:	5b                   	pop    %ebx
f01029ab:	c9                   	leave  
f01029ac:	c3                   	ret    

f01029ad <env_setup_vm>:

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
f01029ad:	55                   	push   %ebp
f01029ae:	89 e5                	mov    %esp,%ebp
f01029b0:	56                   	push   %esi
f01029b1:	53                   	push   %ebx
f01029b2:	83 ec 1c             	sub    $0x1c,%esp
f01029b5:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;
	struct Page *p = NULL;
f01029b8:	c7 45 f4 00 00 00 00 	movl   $0x0,0xfffffff4(%ebp)

	// Allocate a page for the page directory
	if ((r = page_alloc(&p)) < 0)
f01029bf:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
f01029c2:	50                   	push   %eax
f01029c3:	e8 e6 ed ff ff       	call   f01017ae <page_alloc>
f01029c8:	83 c4 10             	add    $0x10,%esp
		return r;
f01029cb:	89 c2                	mov    %eax,%edx
f01029cd:	85 c0                	test   %eax,%eax
f01029cf:	0f 88 da 00 00 00    	js     f0102aaf <env_setup_vm+0x102>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f01029d5:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f01029d8:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f01029de:	c1 fa 02             	sar    $0x2,%edx
f01029e1:	8d 04 92             	lea    (%edx,%edx,4),%eax
f01029e4:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01029e7:	8d 04 82             	lea    (%edx,%eax,4),%eax
f01029ea:	89 c1                	mov    %eax,%ecx
f01029ec:	c1 e1 08             	shl    $0x8,%ecx
f01029ef:	01 c8                	add    %ecx,%eax
f01029f1:	89 c1                	mov    %eax,%ecx
f01029f3:	c1 e1 10             	shl    $0x10,%ecx
f01029f6:	01 c8                	add    %ecx,%eax
f01029f8:	8d 04 42             	lea    (%edx,%eax,2),%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f01029fb:	89 c2                	mov    %eax,%edx
f01029fd:	c1 e2 0c             	shl    $0xc,%edx
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
f0102a00:	89 d0                	mov    %edx,%eax
f0102a02:	c1 e8 0c             	shr    $0xc,%eax
f0102a05:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102a0b:	72 12                	jb     f0102a1f <env_setup_vm+0x72>
f0102a0d:	52                   	push   %edx
f0102a0e:	68 ac 62 10 f0       	push   $0xf01062ac
f0102a13:	6a 5b                	push   $0x5b
f0102a15:	68 76 5f 10 f0       	push   $0xf0105f76
f0102a1a:	e8 cf d6 ff ff       	call   f01000ee <_panic>
f0102a1f:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f0102a25:	89 46 5c             	mov    %eax,0x5c(%esi)
f0102a28:	8b 5d f4             	mov    0xfffffff4(%ebp),%ebx
f0102a2b:	89 da                	mov    %ebx,%edx
f0102a2d:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0102a33:	c1 fa 02             	sar    $0x2,%edx
f0102a36:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0102a39:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102a3c:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102a3f:	89 c1                	mov    %eax,%ecx
f0102a41:	c1 e1 08             	shl    $0x8,%ecx
f0102a44:	01 c8                	add    %ecx,%eax
f0102a46:	89 c1                	mov    %eax,%ecx
f0102a48:	c1 e1 10             	shl    $0x10,%ecx
f0102a4b:	01 c8                	add    %ecx,%eax
f0102a4d:	8d 04 42             	lea    (%edx,%eax,2),%eax
f0102a50:	c1 e0 0c             	shl    $0xc,%eax
f0102a53:	89 46 60             	mov    %eax,0x60(%esi)

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
f0102a56:	66 ff 43 08          	incw   0x8(%ebx)

	// The VA space of all envs is identical above UTOP
	// (except at VPT and UVPT, which we've set below).
	// See inc/memlayout.h for permissions and layout.
	// Can you use boot_pgdir as a template?  Hint: Yes.
	// (Make sure you got the permissions right in Lab 2.)
        memset(e->env_pgdir, 0, PGSIZE);
f0102a5a:	83 ec 04             	sub    $0x4,%esp
f0102a5d:	68 00 10 00 00       	push   $0x1000
f0102a62:	6a 00                	push   $0x0
f0102a64:	ff 76 5c             	pushl  0x5c(%esi)
f0102a67:	e8 2d 22 00 00       	call   f0104c99 <memset>

        // note that you cannot di i=UTOP;i<npaage*PGSIZE;i++ and then PDX(i);
        // PDX indexes into the page dir, whereas npage*pgsize refernces a
        // physical page.
        //for (i = PDX(UTOP); i < npage; i++) {
        for (i = PDX(UTOP); i < NPDENTRIES; i++) { // arkajit hint
f0102a6c:	b9 bb 03 00 00       	mov    $0x3bb,%ecx
f0102a71:	83 c4 10             	add    $0x10,%esp
          e->env_pgdir[i] = boot_pgdir[i];
f0102a74:	8b 46 5c             	mov    0x5c(%esi),%eax
f0102a77:	8b 15 78 68 2f f0    	mov    0xf02f6878,%edx
f0102a7d:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
f0102a80:	89 14 88             	mov    %edx,(%eax,%ecx,4)
f0102a83:	41                   	inc    %ecx
f0102a84:	81 f9 ff 03 00 00    	cmp    $0x3ff,%ecx
f0102a8a:	7e e8                	jle    f0102a74 <env_setup_vm+0xc7>
        }

	// VPT and UVPT map the env's own page table, with
	// different permissions.
	e->env_pgdir[PDX(VPT)]  = e->env_cr3 | PTE_P | PTE_W;
f0102a8c:	8b 56 5c             	mov    0x5c(%esi),%edx
f0102a8f:	8b 46 60             	mov    0x60(%esi),%eax
f0102a92:	83 c8 03             	or     $0x3,%eax
f0102a95:	89 82 fc 0e 00 00    	mov    %eax,0xefc(%edx)
	e->env_pgdir[PDX(UVPT)] = e->env_cr3 | PTE_P | PTE_U;
f0102a9b:	8b 56 5c             	mov    0x5c(%esi),%edx
f0102a9e:	8b 46 60             	mov    0x60(%esi),%eax
f0102aa1:	83 c8 05             	or     $0x5,%eax
f0102aa4:	89 82 f4 0e 00 00    	mov    %eax,0xef4(%edx)

	return 0;
f0102aaa:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0102aaf:	89 d0                	mov    %edx,%eax
f0102ab1:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0102ab4:	5b                   	pop    %ebx
f0102ab5:	5e                   	pop    %esi
f0102ab6:	c9                   	leave  
f0102ab7:	c3                   	ret    

f0102ab8 <env_alloc>:

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
f0102ab8:	55                   	push   %ebp
f0102ab9:	89 e5                	mov    %esp,%ebp
f0102abb:	53                   	push   %ebx
f0102abc:	83 ec 04             	sub    $0x4,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = LIST_FIRST(&env_free_list)))
f0102abf:	8b 1d c8 5b 2f f0    	mov    0xf02f5bc8,%ebx
		return -E_NO_FREE_ENV;
f0102ac5:	ba fb ff ff ff       	mov    $0xfffffffb,%edx
f0102aca:	85 db                	test   %ebx,%ebx
f0102acc:	0f 84 cd 00 00 00    	je     f0102b9f <env_alloc+0xe7>

	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
f0102ad2:	83 ec 0c             	sub    $0xc,%esp
f0102ad5:	53                   	push   %ebx
f0102ad6:	e8 d2 fe ff ff       	call   f01029ad <env_setup_vm>
f0102adb:	83 c4 10             	add    $0x10,%esp
		return r;
f0102ade:	89 c2                	mov    %eax,%edx
f0102ae0:	85 c0                	test   %eax,%eax
f0102ae2:	0f 88 b7 00 00 00    	js     f0102b9f <env_alloc+0xe7>

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0102ae8:	8b 53 4c             	mov    0x4c(%ebx),%edx
f0102aeb:	81 c2 00 10 00 00    	add    $0x1000,%edx
	if (generation <= 0)	// Don't create a negative env_id.
f0102af1:	81 e2 00 fc ff ff    	and    $0xfffffc00,%edx
f0102af7:	7f 05                	jg     f0102afe <env_alloc+0x46>
		generation = 1 << ENVGENSHIFT;
f0102af9:	ba 00 10 00 00       	mov    $0x1000,%edx
	e->env_id = generation | (e - envs);
f0102afe:	89 d8                	mov    %ebx,%eax
f0102b00:	2b 05 c0 5b 2f f0    	sub    0xf02f5bc0,%eax
f0102b06:	c1 f8 07             	sar    $0x7,%eax
f0102b09:	09 d0                	or     %edx,%eax
f0102b0b:	89 43 4c             	mov    %eax,0x4c(%ebx)
	
	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0102b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0102b11:	89 43 50             	mov    %eax,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0102b14:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
	e->env_runs = 0;
f0102b1b:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0102b22:	83 ec 04             	sub    $0x4,%esp
f0102b25:	6a 44                	push   $0x44
f0102b27:	6a 00                	push   $0x0
f0102b29:	53                   	push   %ebx
f0102b2a:	e8 6a 21 00 00       	call   f0104c99 <memset>

	// Set up appropriate initial values for the segment registers.
	// GD_UD is the user data segment selector in the GDT, and 
	// GD_UT is the user text segment selector (see inc/memlayout.h).
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.
	e->env_tf.tf_ds = GD_UD | 3;
f0102b2f:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0102b35:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0102b3b:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0102b41:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0102b48:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
        e->env_tf.tf_eflags |= FL_IF;
f0102b4e:	8b 53 38             	mov    0x38(%ebx),%edx
f0102b51:	89 d0                	mov    %edx,%eax
f0102b53:	80 cc 02             	or     $0x2,%ah
f0102b56:	89 43 38             	mov    %eax,0x38(%ebx)

	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0102b59:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0102b60:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

	// If this is the file server (e == &envs[1]) give it I/O privileges.
	// LAB 5: Your code here.
        // seanyliu
        if (e == &envs[1]) {
f0102b67:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f0102b6c:	83 e8 80             	sub    $0xffffff80,%eax
f0102b6f:	83 c4 10             	add    $0x10,%esp
f0102b72:	39 d8                	cmp    %ebx,%eax
f0102b74:	75 08                	jne    f0102b7e <env_alloc+0xc6>
          e->env_tf.tf_eflags |= FL_IOPL_3;
f0102b76:	89 d0                	mov    %edx,%eax
f0102b78:	80 cc 32             	or     $0x32,%ah
f0102b7b:	89 43 38             	mov    %eax,0x38(%ebx)
        }

	// commit the allocation
	LIST_REMOVE(e, env_link);
f0102b7e:	83 7b 44 00          	cmpl   $0x0,0x44(%ebx)
f0102b82:	74 09                	je     f0102b8d <env_alloc+0xd5>
f0102b84:	8b 53 44             	mov    0x44(%ebx),%edx
f0102b87:	8b 43 48             	mov    0x48(%ebx),%eax
f0102b8a:	89 42 48             	mov    %eax,0x48(%edx)
f0102b8d:	8b 53 48             	mov    0x48(%ebx),%edx
f0102b90:	8b 43 44             	mov    0x44(%ebx),%eax
f0102b93:	89 02                	mov    %eax,(%edx)
	*newenv_store = e;
f0102b95:	8b 45 08             	mov    0x8(%ebp),%eax
f0102b98:	89 18                	mov    %ebx,(%eax)

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
f0102b9a:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0102b9f:	89 d0                	mov    %edx,%eax
f0102ba1:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0102ba4:	c9                   	leave  
f0102ba5:	c3                   	ret    

f0102ba6 <segment_alloc>:

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
f0102ba6:	55                   	push   %ebp
f0102ba7:	89 e5                	mov    %esp,%ebp
f0102ba9:	57                   	push   %edi
f0102baa:	56                   	push   %esi
f0102bab:	53                   	push   %ebx
f0102bac:	83 ec 0c             	sub    $0xc,%esp
f0102baf:	8b 7d 08             	mov    0x8(%ebp),%edi
f0102bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
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
f0102bb5:	89 c6                	mov    %eax,%esi
f0102bb7:	03 75 10             	add    0x10(%ebp),%esi
        for (pidx = (int)va_round; pidx < end; pidx += PGSIZE) {
f0102bba:	89 c3                	mov    %eax,%ebx
f0102bbc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0102bc2:	39 f3                	cmp    %esi,%ebx
f0102bc4:	7d 5c                	jge    f0102c22 <segment_alloc+0x7c>
	  if ((r = page_alloc(&pp)) < 0) {
f0102bc6:	83 ec 0c             	sub    $0xc,%esp
f0102bc9:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0102bcc:	50                   	push   %eax
f0102bcd:	e8 dc eb ff ff       	call   f01017ae <page_alloc>
f0102bd2:	83 c4 10             	add    $0x10,%esp
f0102bd5:	85 c0                	test   %eax,%eax
f0102bd7:	79 15                	jns    f0102bee <segment_alloc+0x48>
            panic("segment_alloc: %e page_alloc failed", r);
f0102bd9:	50                   	push   %eax
f0102bda:	68 e4 69 10 f0       	push   $0xf01069e4
f0102bdf:	68 0c 01 00 00       	push   $0x10c
f0102be4:	68 78 6a 10 f0       	push   $0xf0106a78
f0102be9:	e8 00 d5 ff ff       	call   f01000ee <_panic>
          } else if ((r = page_insert(e->env_pgdir, pp, (void*)pidx, PTE_W | PTE_U )) != 0) {
f0102bee:	6a 06                	push   $0x6
f0102bf0:	53                   	push   %ebx
f0102bf1:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0102bf4:	ff 77 5c             	pushl  0x5c(%edi)
f0102bf7:	e8 69 ed ff ff       	call   f0101965 <page_insert>
f0102bfc:	83 c4 10             	add    $0x10,%esp
f0102bff:	85 c0                	test   %eax,%eax
f0102c01:	74 15                	je     f0102c18 <segment_alloc+0x72>
            panic("segment_alloc: %e page_insert failed", r);
f0102c03:	50                   	push   %eax
f0102c04:	68 08 6a 10 f0       	push   $0xf0106a08
f0102c09:	68 0e 01 00 00       	push   $0x10e
f0102c0e:	68 78 6a 10 f0       	push   $0xf0106a78
f0102c13:	e8 d6 d4 ff ff       	call   f01000ee <_panic>
f0102c18:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102c1e:	39 f3                	cmp    %esi,%ebx
f0102c20:	7c a4                	jl     f0102bc6 <segment_alloc+0x20>
          }
        }

}
f0102c22:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0102c25:	5b                   	pop    %ebx
f0102c26:	5e                   	pop    %esi
f0102c27:	5f                   	pop    %edi
f0102c28:	c9                   	leave  
f0102c29:	c3                   	ret    

f0102c2a <load_icode>:

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
f0102c2a:	55                   	push   %ebp
f0102c2b:	89 e5                	mov    %esp,%ebp
f0102c2d:	57                   	push   %edi
f0102c2e:	56                   	push   %esi
f0102c2f:	53                   	push   %ebx
f0102c30:	83 ec 0c             	sub    $0xc,%esp
f0102c33:	8b 7d 0c             	mov    0xc(%ebp),%edi
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
f0102c36:	89 fb                	mov    %edi,%ebx
f0102c38:	03 5f 1c             	add    0x1c(%edi),%ebx
        eph = ph + ((struct Elf *)binary)->e_phnum;
f0102c3b:	0f b7 77 2c          	movzwl 0x2c(%edi),%esi
f0102c3f:	89 f0                	mov    %esi,%eax
f0102c41:	c1 e0 05             	shl    $0x5,%eax
f0102c44:	8d 34 18             	lea    (%eax,%ebx,1),%esi
}

static __inline void
lcr3(uint32_t val)
{
f0102c47:	8b 55 08             	mov    0x8(%ebp),%edx
f0102c4a:	8b 42 60             	mov    0x60(%edx),%eax
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0102c4d:	0f 22 d8             	mov    %eax,%cr3

        // note that we have to copy the ELF header into env's address space
        // but memcpy will default to copying in the current kernel address space.
        // therefore, we should first load in the environment user space.
        // this is okay, because all the environments have the kernel mapped!
        lcr3(e->env_cr3);

        // SEAN ADD: check if ELF_MAGIC ((struct Elf *)binary)->...)
	//  (The ELF header should have ph->p_filesz <= ph->p_memsz.)

        for (; ph < eph; ph++) {
f0102c50:	39 f3                	cmp    %esi,%ebx
f0102c52:	73 4b                	jae    f0102c9f <load_icode+0x75>
	  //  You should only load segments with ph->p_type == ELF_PROG_LOAD.
          if (ph->p_type == ELF_PROG_LOAD) {
f0102c54:	83 3b 01             	cmpl   $0x1,(%ebx)
f0102c57:	75 3f                	jne    f0102c98 <load_icode+0x6e>
            segment_alloc(e, (void *) ph->p_va, ph->p_memsz);
f0102c59:	83 ec 04             	sub    $0x4,%esp
f0102c5c:	ff 73 14             	pushl  0x14(%ebx)
f0102c5f:	ff 73 08             	pushl  0x8(%ebx)
f0102c62:	ff 75 08             	pushl  0x8(%ebp)
f0102c65:	e8 3c ff ff ff       	call   f0102ba6 <segment_alloc>
            memmove((void *)ph->p_va, binary + ph->p_offset, ph->p_filesz);
f0102c6a:	83 c4 0c             	add    $0xc,%esp
f0102c6d:	ff 73 10             	pushl  0x10(%ebx)
f0102c70:	89 f8                	mov    %edi,%eax
f0102c72:	03 43 04             	add    0x4(%ebx),%eax
f0102c75:	50                   	push   %eax
f0102c76:	ff 73 08             	pushl  0x8(%ebx)
f0102c79:	e8 6e 20 00 00       	call   f0104cec <memmove>
            memset((void *)ph->p_va + ph->p_filesz, 0, ph->p_memsz - ph->p_filesz);
f0102c7e:	83 c4 0c             	add    $0xc,%esp
f0102c81:	8b 53 10             	mov    0x10(%ebx),%edx
f0102c84:	8b 43 14             	mov    0x14(%ebx),%eax
f0102c87:	29 d0                	sub    %edx,%eax
f0102c89:	50                   	push   %eax
f0102c8a:	6a 00                	push   $0x0
f0102c8c:	03 53 08             	add    0x8(%ebx),%edx
f0102c8f:	52                   	push   %edx
f0102c90:	e8 04 20 00 00       	call   f0104c99 <memset>
f0102c95:	83 c4 10             	add    $0x10,%esp
f0102c98:	83 c3 20             	add    $0x20,%ebx
f0102c9b:	39 f3                	cmp    %esi,%ebx
f0102c9d:	72 b5                	jb     f0102c54 <load_icode+0x2a>
          }
        }

	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.

	// LAB 3: Your code here.
        struct Page *init_stack;
        if ((r = page_alloc(&init_stack)) < 0) panic("load_icode: %e failed to page_alloc", r);
f0102c9f:	83 ec 0c             	sub    $0xc,%esp
f0102ca2:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0102ca5:	50                   	push   %eax
f0102ca6:	e8 03 eb ff ff       	call   f01017ae <page_alloc>
f0102cab:	83 c4 10             	add    $0x10,%esp
f0102cae:	85 c0                	test   %eax,%eax
f0102cb0:	79 15                	jns    f0102cc7 <load_icode+0x9d>
f0102cb2:	50                   	push   %eax
f0102cb3:	68 30 6a 10 f0       	push   $0xf0106a30
f0102cb8:	68 74 01 00 00       	push   $0x174
f0102cbd:	68 78 6a 10 f0       	push   $0xf0106a78
f0102cc2:	e8 27 d4 ff ff       	call   f01000ee <_panic>
        page_insert(e->env_pgdir, init_stack, (void *)(USTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P);
f0102cc7:	6a 07                	push   $0x7
f0102cc9:	68 00 d0 bf ee       	push   $0xeebfd000
f0102cce:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0102cd1:	8b 45 08             	mov    0x8(%ebp),%eax
f0102cd4:	ff 70 5c             	pushl  0x5c(%eax)
f0102cd7:	e8 89 ec ff ff       	call   f0101965 <page_insert>

        e->env_tf.tf_eip = ((struct Elf *)binary)->e_entry;
f0102cdc:	8b 47 18             	mov    0x18(%edi),%eax
f0102cdf:	8b 55 08             	mov    0x8(%ebp),%edx
f0102ce2:	89 42 30             	mov    %eax,0x30(%edx)
}
f0102ce5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0102ce8:	5b                   	pop    %ebx
f0102ce9:	5e                   	pop    %esi
f0102cea:	5f                   	pop    %edi
f0102ceb:	c9                   	leave  
f0102cec:	c3                   	ret    

f0102ced <env_create>:

//
// Allocates a new env and loads the named elf binary into it.
// This function is ONLY called during kernel initialization,
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, size_t size)
{
f0102ced:	55                   	push   %ebp
f0102cee:	89 e5                	mov    %esp,%ebp
f0102cf0:	83 ec 10             	sub    $0x10,%esp
	// LAB 3: Your code here.
        // seanyliu
        struct Env *e_store;
        int r;
        if ((r = env_alloc(&e_store, 0)) < 0) {
f0102cf3:	6a 00                	push   $0x0
f0102cf5:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f0102cf8:	50                   	push   %eax
f0102cf9:	e8 ba fd ff ff       	call   f0102ab8 <env_alloc>
f0102cfe:	83 c4 10             	add    $0x10,%esp
f0102d01:	85 c0                	test   %eax,%eax
f0102d03:	79 15                	jns    f0102d1a <env_create+0x2d>
          panic("segment_alloc: %e env_create failed", r);
f0102d05:	50                   	push   %eax
f0102d06:	68 54 6a 10 f0       	push   $0xf0106a54
f0102d0b:	68 88 01 00 00       	push   $0x188
f0102d10:	68 78 6a 10 f0       	push   $0xf0106a78
f0102d15:	e8 d4 d3 ff ff       	call   f01000ee <_panic>
        }

        load_icode(e_store, binary, size);
f0102d1a:	83 ec 04             	sub    $0x4,%esp
f0102d1d:	ff 75 0c             	pushl  0xc(%ebp)
f0102d20:	ff 75 08             	pushl  0x8(%ebp)
f0102d23:	ff 75 fc             	pushl  0xfffffffc(%ebp)
f0102d26:	e8 ff fe ff ff       	call   f0102c2a <load_icode>

        // this is automatically done by env_alloc
        // envs[0] = *e_store;
}
f0102d2b:	c9                   	leave  
f0102d2c:	c3                   	ret    

f0102d2d <env_free>:

//
// Frees env e and all memory it uses.
// 
void
env_free(struct Env *e)
{
f0102d2d:	55                   	push   %ebp
f0102d2e:	89 e5                	mov    %esp,%ebp
f0102d30:	57                   	push   %edi
f0102d31:	56                   	push   %esi
f0102d32:	53                   	push   %ebx
f0102d33:	83 ec 0c             	sub    $0xc,%esp
	pte_t *pt;
	uint32_t pdeno, pteno;
	physaddr_t pa;
	
	// If freeing the current environment, switch to boot_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0102d36:	8b 45 08             	mov    0x8(%ebp),%eax
f0102d39:	3b 05 c4 5b 2f f0    	cmp    0xf02f5bc4,%eax
f0102d3f:	75 08                	jne    f0102d49 <env_free+0x1c>
}

static __inline void
lcr3(uint32_t val)
{
f0102d41:	a1 74 68 2f f0       	mov    0xf02f6874,%eax
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0102d46:	0f 22 d8             	mov    %eax,%cr3
		lcr3(boot_cr3);

	// Note the environment's demise.
	// cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0102d49:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0102d50:	8b 55 08             	mov    0x8(%ebp),%edx
f0102d53:	8b 42 5c             	mov    0x5c(%edx),%eax
f0102d56:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
f0102d59:	8b 04 90             	mov    (%eax,%edx,4),%eax
f0102d5c:	a8 01                	test   $0x1,%al
f0102d5e:	0f 84 b3 00 00 00    	je     f0102e17 <env_free+0xea>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0102d64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102d69:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
		pt = (pte_t*) KADDR(pa);
f0102d6c:	89 c2                	mov    %eax,%edx
f0102d6e:	c1 e8 0c             	shr    $0xc,%eax
f0102d71:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102d77:	72 15                	jb     f0102d8e <env_free+0x61>
f0102d79:	52                   	push   %edx
f0102d7a:	68 ac 62 10 f0       	push   $0xf01062ac
f0102d7f:	68 ae 01 00 00       	push   $0x1ae
f0102d84:	68 78 6a 10 f0       	push   $0xf0106a78
f0102d89:	e8 60 d3 ff ff       	call   f01000ee <_panic>
f0102d8e:	8d b2 00 00 00 f0    	lea    0xf0000000(%edx),%esi

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0102d94:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102d99:	8b 7d f0             	mov    0xfffffff0(%ebp),%edi
f0102d9c:	c1 e7 16             	shl    $0x16,%edi
			if (pt[pteno] & PTE_P)
f0102d9f:	f6 04 9e 01          	testb  $0x1,(%esi,%ebx,4)
f0102da3:	74 19                	je     f0102dbe <env_free+0x91>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0102da5:	83 ec 08             	sub    $0x8,%esp
f0102da8:	89 d8                	mov    %ebx,%eax
f0102daa:	c1 e0 0c             	shl    $0xc,%eax
f0102dad:	09 f8                	or     %edi,%eax
f0102daf:	50                   	push   %eax
f0102db0:	8b 45 08             	mov    0x8(%ebp),%eax
f0102db3:	ff 70 5c             	pushl  0x5c(%eax)
f0102db6:	e8 71 ed ff ff       	call   f0101b2c <page_remove>
f0102dbb:	83 c4 10             	add    $0x10,%esp
f0102dbe:	43                   	inc    %ebx
f0102dbf:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
f0102dc5:	76 d8                	jbe    f0102d9f <env_free+0x72>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0102dc7:	8b 55 08             	mov    0x8(%ebp),%edx
f0102dca:	8b 42 5c             	mov    0x5c(%edx),%eax
f0102dcd:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
f0102dd0:	c7 04 90 00 00 00 00 	movl   $0x0,(%eax,%edx,4)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
f0102dd7:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
	if (PPN(pa) >= npage)
f0102dda:	89 d0                	mov    %edx,%eax
f0102ddc:	c1 e8 0c             	shr    $0xc,%eax
f0102ddf:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102de5:	72 14                	jb     f0102dfb <env_free+0xce>
		panic("pa2page called with invalid pa");
f0102de7:	83 ec 04             	sub    $0x4,%esp
f0102dea:	68 b4 60 10 f0       	push   $0xf01060b4
f0102def:	6a 54                	push   $0x54
f0102df1:	68 76 5f 10 f0       	push   $0xf0105f76
f0102df6:	e8 f3 d2 ff ff       	call   f01000ee <_panic>
f0102dfb:	89 d0                	mov    %edx,%eax
f0102dfd:	c1 e8 0c             	shr    $0xc,%eax
f0102e00:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0102e03:	a1 7c 68 2f f0       	mov    0xf02f687c,%eax
f0102e08:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0102e0b:	83 ec 0c             	sub    $0xc,%esp
f0102e0e:	50                   	push   %eax
f0102e0f:	e8 07 ea ff ff       	call   f010181b <page_decref>
f0102e14:	83 c4 10             	add    $0x10,%esp
f0102e17:	ff 45 f0             	incl   0xfffffff0(%ebp)
f0102e1a:	81 7d f0 ba 03 00 00 	cmpl   $0x3ba,0xfffffff0(%ebp)
f0102e21:	0f 86 29 ff ff ff    	jbe    f0102d50 <env_free+0x23>
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = e->env_cr3;
f0102e27:	8b 45 08             	mov    0x8(%ebp),%eax
f0102e2a:	8b 40 60             	mov    0x60(%eax),%eax
	e->env_pgdir = 0;
f0102e2d:	8b 55 08             	mov    0x8(%ebp),%edx
f0102e30:	c7 42 5c 00 00 00 00 	movl   $0x0,0x5c(%edx)
	e->env_cr3 = 0;
f0102e37:	c7 42 60 00 00 00 00 	movl   $0x0,0x60(%edx)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
f0102e3e:	89 c2                	mov    %eax,%edx
	if (PPN(pa) >= npage)
f0102e40:	c1 e8 0c             	shr    $0xc,%eax
f0102e43:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0102e49:	72 14                	jb     f0102e5f <env_free+0x132>
		panic("pa2page called with invalid pa");
f0102e4b:	83 ec 04             	sub    $0x4,%esp
f0102e4e:	68 b4 60 10 f0       	push   $0xf01060b4
f0102e53:	6a 54                	push   $0x54
f0102e55:	68 76 5f 10 f0       	push   $0xf0105f76
f0102e5a:	e8 8f d2 ff ff       	call   f01000ee <_panic>
f0102e5f:	89 d0                	mov    %edx,%eax
f0102e61:	c1 e8 0c             	shr    $0xc,%eax
f0102e64:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0102e67:	8b 15 7c 68 2f f0    	mov    0xf02f687c,%edx
f0102e6d:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0102e70:	83 ec 0c             	sub    $0xc,%esp
f0102e73:	50                   	push   %eax
f0102e74:	e8 a2 e9 ff ff       	call   f010181b <page_decref>
	page_decref(pa2page(pa));

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0102e79:	8b 45 08             	mov    0x8(%ebp),%eax
f0102e7c:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	LIST_INSERT_HEAD(&env_free_list, e, env_link);
f0102e83:	a1 c8 5b 2f f0       	mov    0xf02f5bc8,%eax
f0102e88:	8b 55 08             	mov    0x8(%ebp),%edx
f0102e8b:	89 42 44             	mov    %eax,0x44(%edx)
f0102e8e:	83 c4 10             	add    $0x10,%esp
f0102e91:	85 c0                	test   %eax,%eax
f0102e93:	74 0e                	je     f0102ea3 <env_free+0x176>
f0102e95:	8b 55 08             	mov    0x8(%ebp),%edx
f0102e98:	83 c2 44             	add    $0x44,%edx
f0102e9b:	a1 c8 5b 2f f0       	mov    0xf02f5bc8,%eax
f0102ea0:	89 50 48             	mov    %edx,0x48(%eax)
f0102ea3:	8b 45 08             	mov    0x8(%ebp),%eax
f0102ea6:	a3 c8 5b 2f f0       	mov    %eax,0xf02f5bc8
f0102eab:	c7 40 48 c8 5b 2f f0 	movl   $0xf02f5bc8,0x48(%eax)
}
f0102eb2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0102eb5:	5b                   	pop    %ebx
f0102eb6:	5e                   	pop    %esi
f0102eb7:	5f                   	pop    %edi
f0102eb8:	c9                   	leave  
f0102eb9:	c3                   	ret    

f0102eba <env_destroy>:

//
// Frees environment e.
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e) 
{
f0102eba:	55                   	push   %ebp
f0102ebb:	89 e5                	mov    %esp,%ebp
f0102ebd:	53                   	push   %ebx
f0102ebe:	83 ec 10             	sub    $0x10,%esp
f0102ec1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	env_free(e);
f0102ec4:	53                   	push   %ebx
f0102ec5:	e8 63 fe ff ff       	call   f0102d2d <env_free>

	if (curenv == e) {
f0102eca:	83 c4 10             	add    $0x10,%esp
f0102ecd:	39 1d c4 5b 2f f0    	cmp    %ebx,0xf02f5bc4
f0102ed3:	75 0f                	jne    f0102ee4 <env_destroy+0x2a>
		curenv = NULL;
f0102ed5:	c7 05 c4 5b 2f f0 00 	movl   $0x0,0xf02f5bc4
f0102edc:	00 00 00 
		sched_yield();
f0102edf:	e8 c0 08 00 00       	call   f01037a4 <sched_yield>
	}
}
f0102ee4:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0102ee7:	c9                   	leave  
f0102ee8:	c3                   	ret    

f0102ee9 <env_pop_tf>:


//
// Restores the register values in the Trapframe with the 'iret' instruction.
// This exits the kernel and starts executing some environment's code.
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0102ee9:	55                   	push   %ebp
f0102eea:	89 e5                	mov    %esp,%ebp
f0102eec:	83 ec 0c             	sub    $0xc,%esp
f0102eef:	8b 45 08             	mov    0x8(%ebp),%eax
	__asm __volatile("movl %0,%%esp\n"
f0102ef2:	89 c4                	mov    %eax,%esp
f0102ef4:	61                   	popa   
f0102ef5:	07                   	pop    %es
f0102ef6:	1f                   	pop    %ds
f0102ef7:	83 c4 08             	add    $0x8,%esp
f0102efa:	cf                   	iret   
		"\tpopal\n"
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0102efb:	68 83 6a 10 f0       	push   $0xf0106a83
f0102f00:	68 e6 01 00 00       	push   $0x1e6
f0102f05:	68 78 6a 10 f0       	push   $0xf0106a78
f0102f0a:	e8 df d1 ff ff       	call   f01000ee <_panic>

f0102f0f <env_run>:
}

//
// Context switch from curenv to env e.
// Note: if this is the first call to env_run, curenv is NULL.
//  (This function does not return.)
//
void
env_run(struct Env *e)
{
f0102f0f:	55                   	push   %ebp
f0102f10:	89 e5                	mov    %esp,%ebp
f0102f12:	83 ec 14             	sub    $0x14,%esp
f0102f15:	8b 45 08             	mov    0x8(%ebp),%eax
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
f0102f18:	a3 c4 5b 2f f0       	mov    %eax,0xf02f5bc4
        curenv->env_runs++;
f0102f1d:	ff 40 58             	incl   0x58(%eax)
}

static __inline void
lcr3(uint32_t val)
{
f0102f20:	8b 15 c4 5b 2f f0    	mov    0xf02f5bc4,%edx
f0102f26:	8b 42 60             	mov    0x60(%edx),%eax
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0102f29:	0f 22 d8             	mov    %eax,%cr3
	lcr3(curenv->env_cr3);

        // Step 2
        env_pop_tf(&(curenv->env_tf));
f0102f2c:	52                   	push   %edx
f0102f2d:	e8 b7 ff ff ff       	call   f0102ee9 <env_pop_tf>
	...

f0102f34 <mc146818_read>:


unsigned
mc146818_read(unsigned reg)
{
f0102f34:	55                   	push   %ebp
f0102f35:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
f0102f37:	ba 70 00 00 00       	mov    $0x70,%edx
f0102f3c:	8a 45 08             	mov    0x8(%ebp),%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0102f3f:	ee                   	out    %al,(%dx)
f0102f40:	b2 71                	mov    $0x71,%dl
f0102f42:	ec                   	in     (%dx),%al
f0102f43:	0f b6 c0             	movzbl %al,%eax
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
}
f0102f46:	c9                   	leave  
f0102f47:	c3                   	ret    

f0102f48 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0102f48:	55                   	push   %ebp
f0102f49:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
f0102f4b:	ba 70 00 00 00       	mov    $0x70,%edx
f0102f50:	8a 45 08             	mov    0x8(%ebp),%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0102f53:	ee                   	out    %al,(%dx)
f0102f54:	b2 71                	mov    $0x71,%dl
f0102f56:	8a 45 0c             	mov    0xc(%ebp),%al
f0102f59:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0102f5a:	c9                   	leave  
f0102f5b:	c3                   	ret    

f0102f5c <kclock_init>:


void
kclock_init(void)
{
f0102f5c:	55                   	push   %ebp
f0102f5d:	89 e5                	mov    %esp,%ebp
f0102f5f:	83 ec 14             	sub    $0x14,%esp
}

static __inline void
outb(int port, uint8_t data)
{
f0102f62:	ba 43 00 00 00       	mov    $0x43,%edx
f0102f67:	b0 34                	mov    $0x34,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0102f69:	ee                   	out    %al,(%dx)
f0102f6a:	b2 40                	mov    $0x40,%dl
f0102f6c:	b0 9c                	mov    $0x9c,%al
f0102f6e:	ee                   	out    %al,(%dx)
f0102f6f:	b0 2e                	mov    $0x2e,%al
f0102f71:	ee                   	out    %al,(%dx)
	/* initialize 8253 clock to interrupt 100 times/sec */
	outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
	outb(IO_TIMER1, TIMER_DIV(100) % 256);
	outb(IO_TIMER1, TIMER_DIV(100) / 256);
	cprintf("	Setup timer interrupts via 8259A\n");
f0102f72:	68 90 6a 10 f0       	push   $0xf0106a90
f0102f77:	e8 4e 01 00 00       	call   f01030ca <cprintf>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<0));
f0102f7c:	0f b7 05 d8 55 12 f0 	movzwl 0xf01255d8,%eax
f0102f83:	25 fe ff 00 00       	and    $0xfffe,%eax
f0102f88:	89 04 24             	mov    %eax,(%esp)
f0102f8b:	e8 7a 00 00 00       	call   f010300a <irq_setmask_8259A>
	cprintf("	unmasked timer interrupt\n");
f0102f90:	c7 04 24 b3 6a 10 f0 	movl   $0xf0106ab3,(%esp)
f0102f97:	e8 2e 01 00 00       	call   f01030ca <cprintf>
}
f0102f9c:	c9                   	leave  
f0102f9d:	c3                   	ret    
	...

f0102fa0 <pic_init>:

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0102fa0:	55                   	push   %ebp
f0102fa1:	89 e5                	mov    %esp,%ebp
f0102fa3:	83 ec 08             	sub    $0x8,%esp
	didinit = 1;
f0102fa6:	c7 05 cc 5b 2f f0 01 	movl   $0x1,0xf02f5bcc
f0102fad:	00 00 00 
}

static __inline void
outb(int port, uint8_t data)
{
f0102fb0:	ba 21 00 00 00       	mov    $0x21,%edx
f0102fb5:	b0 ff                	mov    $0xff,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0102fb7:	ee                   	out    %al,(%dx)
f0102fb8:	b2 a1                	mov    $0xa1,%dl
f0102fba:	ee                   	out    %al,(%dx)
f0102fbb:	b2 20                	mov    $0x20,%dl
f0102fbd:	b0 11                	mov    $0x11,%al
f0102fbf:	ee                   	out    %al,(%dx)
f0102fc0:	b2 21                	mov    $0x21,%dl
f0102fc2:	b0 20                	mov    $0x20,%al
f0102fc4:	ee                   	out    %al,(%dx)
f0102fc5:	b0 04                	mov    $0x4,%al
f0102fc7:	ee                   	out    %al,(%dx)
f0102fc8:	b0 03                	mov    $0x3,%al
f0102fca:	ee                   	out    %al,(%dx)
f0102fcb:	b2 a0                	mov    $0xa0,%dl
f0102fcd:	b0 11                	mov    $0x11,%al
f0102fcf:	ee                   	out    %al,(%dx)
f0102fd0:	b2 a1                	mov    $0xa1,%dl
f0102fd2:	b0 28                	mov    $0x28,%al
f0102fd4:	ee                   	out    %al,(%dx)
f0102fd5:	b0 02                	mov    $0x2,%al
f0102fd7:	ee                   	out    %al,(%dx)
f0102fd8:	b0 01                	mov    $0x1,%al
f0102fda:	ee                   	out    %al,(%dx)
f0102fdb:	b2 20                	mov    $0x20,%dl
f0102fdd:	b0 68                	mov    $0x68,%al
f0102fdf:	ee                   	out    %al,(%dx)
f0102fe0:	b0 0a                	mov    $0xa,%al
f0102fe2:	ee                   	out    %al,(%dx)
f0102fe3:	b2 a0                	mov    $0xa0,%dl
f0102fe5:	b0 68                	mov    $0x68,%al
f0102fe7:	ee                   	out    %al,(%dx)
f0102fe8:	b0 0a                	mov    $0xa,%al
f0102fea:	ee                   	out    %al,(%dx)

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
f0102feb:	66 83 3d d8 55 12 f0 	cmpw   $0xffffffff,0xf01255d8
f0102ff2:	ff 
f0102ff3:	74 13                	je     f0103008 <pic_init+0x68>
		irq_setmask_8259A(irq_mask_8259A);
f0102ff5:	83 ec 0c             	sub    $0xc,%esp
f0102ff8:	0f b7 05 d8 55 12 f0 	movzwl 0xf01255d8,%eax
f0102fff:	50                   	push   %eax
f0103000:	e8 05 00 00 00       	call   f010300a <irq_setmask_8259A>
f0103005:	83 c4 10             	add    $0x10,%esp
}
f0103008:	c9                   	leave  
f0103009:	c3                   	ret    

f010300a <irq_setmask_8259A>:

void
irq_setmask_8259A(uint16_t mask)
{
f010300a:	55                   	push   %ebp
f010300b:	89 e5                	mov    %esp,%ebp
f010300d:	56                   	push   %esi
f010300e:	53                   	push   %ebx
f010300f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103012:	89 c6                	mov    %eax,%esi
	int i;
	irq_mask_8259A = mask;
f0103014:	66 a3 d8 55 12 f0    	mov    %ax,0xf01255d8
	if (!didinit)
f010301a:	83 3d cc 5b 2f f0 00 	cmpl   $0x0,0xf02f5bcc
f0103021:	74 59                	je     f010307c <irq_setmask_8259A+0x72>
}

static __inline void
outb(int port, uint8_t data)
{
f0103023:	ba 21 00 00 00       	mov    $0x21,%edx
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103028:	ee                   	out    %al,(%dx)
f0103029:	b2 a1                	mov    $0xa1,%dl
f010302b:	89 f0                	mov    %esi,%eax
f010302d:	66 c1 e8 08          	shr    $0x8,%ax
f0103031:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
f0103032:	83 ec 0c             	sub    $0xc,%esp
f0103035:	68 ce 6a 10 f0       	push   $0xf0106ace
f010303a:	e8 8b 00 00 00       	call   f01030ca <cprintf>
	for (i = 0; i < 16; i++)
f010303f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103044:	83 c4 10             	add    $0x10,%esp
f0103047:	0f b7 c6             	movzwl %si,%eax
f010304a:	89 c6                	mov    %eax,%esi
f010304c:	f7 d6                	not    %esi
		if (~mask & (1<<i))
f010304e:	89 f0                	mov    %esi,%eax
f0103050:	88 d9                	mov    %bl,%cl
f0103052:	d3 f8                	sar    %cl,%eax
f0103054:	a8 01                	test   $0x1,%al
f0103056:	74 11                	je     f0103069 <irq_setmask_8259A+0x5f>
			cprintf(" %d", i);
f0103058:	83 ec 08             	sub    $0x8,%esp
f010305b:	53                   	push   %ebx
f010305c:	68 0e 70 10 f0       	push   $0xf010700e
f0103061:	e8 64 00 00 00       	call   f01030ca <cprintf>
f0103066:	83 c4 10             	add    $0x10,%esp
f0103069:	43                   	inc    %ebx
f010306a:	83 fb 0f             	cmp    $0xf,%ebx
f010306d:	7e df                	jle    f010304e <irq_setmask_8259A+0x44>
	cprintf("\n");
f010306f:	83 ec 0c             	sub    $0xc,%esp
f0103072:	68 bd 5f 10 f0       	push   $0xf0105fbd
f0103077:	e8 4e 00 00 00       	call   f01030ca <cprintf>
}
f010307c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f010307f:	5b                   	pop    %ebx
f0103080:	5e                   	pop    %esi
f0103081:	c9                   	leave  
f0103082:	c3                   	ret    

f0103083 <irq_eoi>:

void
irq_eoi(void)
{
f0103083:	55                   	push   %ebp
f0103084:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
f0103086:	ba 20 00 00 00       	mov    $0x20,%edx
f010308b:	b0 20                	mov    $0x20,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010308d:	ee                   	out    %al,(%dx)
f010308e:	b2 a0                	mov    $0xa0,%dl
f0103090:	ee                   	out    %al,(%dx)
	// OCW2: rse00xxx
	//   r: rotate
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0103091:	c9                   	leave  
f0103092:	c3                   	ret    
	...

f0103094 <putch>:


static void
putch(int ch, int *cnt)
{
f0103094:	55                   	push   %ebp
f0103095:	89 e5                	mov    %esp,%ebp
f0103097:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f010309a:	ff 75 08             	pushl  0x8(%ebp)
f010309d:	e8 02 d6 ff ff       	call   f01006a4 <cputchar>
	*cnt++;
}
f01030a2:	c9                   	leave  
f01030a3:	c3                   	ret    

f01030a4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f01030a4:	55                   	push   %ebp
f01030a5:	89 e5                	mov    %esp,%ebp
f01030a7:	83 ec 08             	sub    $0x8,%esp
	int cnt = 0;
f01030aa:	c7 45 fc 00 00 00 00 	movl   $0x0,0xfffffffc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01030b1:	ff 75 0c             	pushl  0xc(%ebp)
f01030b4:	ff 75 08             	pushl  0x8(%ebp)
f01030b7:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f01030ba:	50                   	push   %eax
f01030bb:	68 94 30 10 f0       	push   $0xf0103094
f01030c0:	e8 05 15 00 00       	call   f01045ca <vprintfmt>
	return cnt;
f01030c5:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
}
f01030c8:	c9                   	leave  
f01030c9:	c3                   	ret    

f01030ca <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01030ca:	55                   	push   %ebp
f01030cb:	89 e5                	mov    %esp,%ebp
f01030cd:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01030d0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f01030d3:	50                   	push   %eax
f01030d4:	ff 75 08             	pushl  0x8(%ebp)
f01030d7:	e8 c8 ff ff ff       	call   f01030a4 <vcprintf>
	va_end(ap);

	return cnt;
}
f01030dc:	c9                   	leave  
f01030dd:	c3                   	ret    
	...

f01030e0 <trapname>:
};


static const char *trapname(int trapno)
{
f01030e0:	55                   	push   %ebp
f01030e1:	89 e5                	mov    %esp,%ebp
f01030e3:	8b 45 08             	mov    0x8(%ebp),%eax
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
f01030e6:	83 f8 13             	cmp    $0x13,%eax
f01030e9:	77 09                	ja     f01030f4 <trapname+0x14>
		return excnames[trapno];
f01030eb:	8b 14 85 c0 6d 10 f0 	mov    0xf0106dc0(,%eax,4),%edx
f01030f2:	eb 1c                	jmp    f0103110 <trapname+0x30>
	if (trapno == T_SYSCALL)
		return "System call";
f01030f4:	ba 34 6c 10 f0       	mov    $0xf0106c34,%edx
f01030f9:	83 f8 30             	cmp    $0x30,%eax
f01030fc:	74 12                	je     f0103110 <trapname+0x30>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01030fe:	83 e8 20             	sub    $0x20,%eax
		return "Hardware Interrupt";
f0103101:	ba 40 6c 10 f0       	mov    $0xf0106c40,%edx
f0103106:	83 f8 0f             	cmp    $0xf,%eax
f0103109:	76 05                	jbe    f0103110 <trapname+0x30>
	return "(unknown trap)";
f010310b:	ba cc 6b 10 f0       	mov    $0xf0106bcc,%edx
}
f0103110:	89 d0                	mov    %edx,%eax
f0103112:	c9                   	leave  
f0103113:	c3                   	ret    

f0103114 <idt_init>:


void
idt_init(void)
{
f0103114:	55                   	push   %ebp
f0103115:	89 e5                	mov    %esp,%ebp
f0103117:	53                   	push   %ebx
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.
        // seanyliu
        int idx;
        void *handler_ptr;
        extern int vectors[]; // in trapentry.S
        extern int irqs[]; // in trapentry.S

        for (idx = 0; idx < 19; idx++) {
f0103118:	ba 00 00 00 00       	mov    $0x0,%edx
f010311d:	b9 e0 5b 2f f0       	mov    $0xf02f5be0,%ecx
f0103122:	bb e4 55 12 f0       	mov    $0xf01255e4,%ebx
          SETGATE(idt[idx], 0, GD_KT, vectors[idx], 0);
f0103127:	8b 04 93             	mov    (%ebx,%edx,4),%eax
f010312a:	66 89 04 d1          	mov    %ax,(%ecx,%edx,8)
f010312e:	66 c7 44 d1 02 08 00 	movw   $0x8,0x2(%ecx,%edx,8)
f0103135:	c6 44 d1 04 00       	movb   $0x0,0x4(%ecx,%edx,8)
f010313a:	c6 44 d1 05 8e       	movb   $0x8e,0x5(%ecx,%edx,8)
f010313f:	c1 e8 10             	shr    $0x10,%eax
f0103142:	66 89 44 d1 06       	mov    %ax,0x6(%ecx,%edx,8)
f0103147:	42                   	inc    %edx
f0103148:	83 fa 12             	cmp    $0x12,%edx
f010314b:	7e da                	jle    f0103127 <idt_init+0x13>
        }

        extern char handler3;
        handler_ptr = &handler3;
f010314d:	b8 4a 36 10 f0       	mov    $0xf010364a,%eax
        SETGATE(idt[T_BRKPT], 0, GD_KT, handler_ptr, 3);
f0103152:	66 a3 f8 5b 2f f0    	mov    %ax,0xf02f5bf8
f0103158:	66 c7 05 fa 5b 2f f0 	movw   $0x8,0xf02f5bfa
f010315f:	08 00 
f0103161:	c6 05 fc 5b 2f f0 00 	movb   $0x0,0xf02f5bfc
f0103168:	c6 05 fd 5b 2f f0 ee 	movb   $0xee,0xf02f5bfd
f010316f:	c1 e8 10             	shr    $0x10,%eax
f0103172:	66 a3 fe 5b 2f f0    	mov    %ax,0xf02f5bfe

        for (idx = 0; idx < 16; idx++) {
f0103178:	ba 00 00 00 00       	mov    $0x0,%edx
f010317d:	b9 e0 5c 2f f0       	mov    $0xf02f5ce0,%ecx
f0103182:	bb 34 56 12 f0       	mov    $0xf0125634,%ebx
          SETGATE(idt[IRQ_OFFSET + idx], 0, GD_KT, irqs[idx], 0);
f0103187:	8b 04 93             	mov    (%ebx,%edx,4),%eax
f010318a:	66 89 04 d1          	mov    %ax,(%ecx,%edx,8)
f010318e:	66 c7 44 d1 02 08 00 	movw   $0x8,0x2(%ecx,%edx,8)
f0103195:	c6 44 d1 04 00       	movb   $0x0,0x4(%ecx,%edx,8)
f010319a:	c6 44 d1 05 8e       	movb   $0x8e,0x5(%ecx,%edx,8)
f010319f:	c1 e8 10             	shr    $0x10,%eax
f01031a2:	66 89 44 d1 06       	mov    %ax,0x6(%ecx,%edx,8)
f01031a7:	42                   	inc    %edx
f01031a8:	83 fa 0f             	cmp    $0xf,%edx
f01031ab:	7e da                	jle    f0103187 <idt_init+0x73>
        }

        extern char handler48;
        handler_ptr = &handler48;
f01031ad:	b8 84 37 10 f0       	mov    $0xf0103784,%eax
        //SETGATE(idt[T_SYSCALL], 1, GD_KT, handler_ptr, 3);
        SETGATE(idt[T_SYSCALL], 0, GD_KT, handler_ptr, 3);
f01031b2:	66 a3 60 5d 2f f0    	mov    %ax,0xf02f5d60
f01031b8:	66 c7 05 62 5d 2f f0 	movw   $0x8,0xf02f5d62
f01031bf:	08 00 
f01031c1:	c6 05 64 5d 2f f0 00 	movb   $0x0,0xf02f5d64
f01031c8:	c6 05 65 5d 2f f0 ee 	movb   $0xee,0xf02f5d65
f01031cf:	c1 e8 10             	shr    $0x10,%eax
f01031d2:	66 a3 66 5d 2f f0    	mov    %ax,0xf02f5d66

        extern char handler500;
        handler_ptr = &handler500;
f01031d8:	b8 98 37 10 f0       	mov    $0xf0103798,%eax
        SETGATE(idt[T_DEFAULT], 0, GD_KT, handler_ptr, 0);
f01031dd:	66 a3 80 6b 2f f0    	mov    %ax,0xf02f6b80
f01031e3:	66 c7 05 82 6b 2f f0 	movw   $0x8,0xf02f6b82
f01031ea:	08 00 
f01031ec:	c6 05 84 6b 2f f0 00 	movb   $0x0,0xf02f6b84
f01031f3:	c6 05 85 6b 2f f0 8e 	movb   $0x8e,0xf02f6b85
f01031fa:	c1 e8 10             	shr    $0x10,%eax
f01031fd:	66 a3 86 6b 2f f0    	mov    %ax,0xf02f6b86

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
f0103203:	b8 8e 37 10 f0       	mov    $0xf010378e,%eax
        SETGATE(idt[(32 + IRQ_ERROR)], 0, GD_KT, handler_ptr, 0);
f0103208:	66 a3 78 5d 2f f0    	mov    %ax,0xf02f5d78
f010320e:	66 c7 05 7a 5d 2f f0 	movw   $0x8,0xf02f5d7a
f0103215:	08 00 
f0103217:	c6 05 7c 5d 2f f0 00 	movb   $0x0,0xf02f5d7c
f010321e:	c6 05 7d 5d 2f f0 8e 	movb   $0x8e,0xf02f5d7d
f0103225:	c1 e8 10             	shr    $0x10,%eax
f0103228:	66 a3 7e 5d 2f f0    	mov    %ax,0xf02f5d7e

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
f010322e:	c7 05 e4 63 2f f0 00 	movl   $0xefc00000,0xf02f63e4
f0103235:	00 c0 ef 
	ts.ts_ss0 = GD_KD;
f0103238:	66 c7 05 e8 63 2f f0 	movw   $0x10,0xf02f63e8
f010323f:	10 00 

	// Initialize the TSS field of the gdt.
	gdt[GD_TSS >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f0103241:	66 b8 68 00          	mov    $0x68,%ax
f0103245:	bb e0 63 2f f0       	mov    $0xf02f63e0,%ebx
f010324a:	89 d9                	mov    %ebx,%ecx
f010324c:	c1 e1 10             	shl    $0x10,%ecx
f010324f:	25 ff ff 00 00       	and    $0xffff,%eax
f0103254:	09 c8                	or     %ecx,%eax
f0103256:	89 d9                	mov    %ebx,%ecx
f0103258:	c1 e9 10             	shr    $0x10,%ecx
f010325b:	88 ca                	mov    %cl,%dl
f010325d:	80 e6 f0             	and    $0xf0,%dh
f0103260:	80 ce 09             	or     $0x9,%dh
f0103263:	80 ce 10             	or     $0x10,%dh
f0103266:	80 e6 9f             	and    $0x9f,%dh
f0103269:	80 ce 80             	or     $0x80,%dh
f010326c:	81 e2 ff ff f0 ff    	and    $0xfff0ffff,%edx
f0103272:	81 e2 ff ff ef ff    	and    $0xffefffff,%edx
f0103278:	81 e2 ff ff df ff    	and    $0xffdfffff,%edx
f010327e:	81 ca 00 00 40 00    	or     $0x400000,%edx
f0103284:	81 e2 ff ff 7f ff    	and    $0xff7fffff,%edx
f010328a:	81 e3 00 00 00 ff    	and    $0xff000000,%ebx
f0103290:	81 e2 ff ff ff 00    	and    $0xffffff,%edx
f0103296:	09 da                	or     %ebx,%edx
f0103298:	a3 c8 55 12 f0       	mov    %eax,0xf01255c8
f010329d:	89 15 cc 55 12 f0    	mov    %edx,0xf01255cc
					sizeof(struct Taskstate), 0);
	gdt[GD_TSS >> 3].sd_s = 0;
f01032a3:	80 25 cd 55 12 f0 ef 	andb   $0xef,0xf01255cd
}

static __inline void
ltr(uint16_t sel)
{
f01032aa:	b8 28 00 00 00       	mov    $0x28,%eax
	__asm __volatile("ltr %0" : : "r" (sel));
f01032af:	0f 00 d8             	ltr    %ax

	// Load the TSS
	ltr(GD_TSS);

	// Load the IDT
	asm volatile("lidt idt_pd");
f01032b2:	0f 01 1d dc 55 12 f0 	lidtl  0xf01255dc
}
f01032b9:	5b                   	pop    %ebx
f01032ba:	c9                   	leave  
f01032bb:	c3                   	ret    

f01032bc <print_trapframe>:

void
print_trapframe(struct Trapframe *tf)
{
f01032bc:	55                   	push   %ebp
f01032bd:	89 e5                	mov    %esp,%ebp
f01032bf:	53                   	push   %ebx
f01032c0:	83 ec 0c             	sub    $0xc,%esp
f01032c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p\n", tf);
f01032c6:	53                   	push   %ebx
f01032c7:	68 53 6c 10 f0       	push   $0xf0106c53
f01032cc:	e8 f9 fd ff ff       	call   f01030ca <cprintf>
	print_regs(&tf->tf_regs);
f01032d1:	89 1c 24             	mov    %ebx,(%esp)
f01032d4:	e8 a8 00 00 00       	call   f0103381 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01032d9:	83 c4 08             	add    $0x8,%esp
f01032dc:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f01032e0:	50                   	push   %eax
f01032e1:	68 65 6c 10 f0       	push   $0xf0106c65
f01032e6:	e8 df fd ff ff       	call   f01030ca <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01032eb:	83 c4 08             	add    $0x8,%esp
f01032ee:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01032f2:	50                   	push   %eax
f01032f3:	68 78 6c 10 f0       	push   $0xf0106c78
f01032f8:	e8 cd fd ff ff       	call   f01030ca <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01032fd:	83 c4 0c             	add    $0xc,%esp
f0103300:	ff 73 28             	pushl  0x28(%ebx)
f0103303:	e8 d8 fd ff ff       	call   f01030e0 <trapname>
f0103308:	89 04 24             	mov    %eax,(%esp)
f010330b:	ff 73 28             	pushl  0x28(%ebx)
f010330e:	68 8b 6c 10 f0       	push   $0xf0106c8b
f0103313:	e8 b2 fd ff ff       	call   f01030ca <cprintf>
	cprintf("  err  0x%08x\n", tf->tf_err);
f0103318:	83 c4 08             	add    $0x8,%esp
f010331b:	ff 73 2c             	pushl  0x2c(%ebx)
f010331e:	68 9d 6c 10 f0       	push   $0xf0106c9d
f0103323:	e8 a2 fd ff ff       	call   f01030ca <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0103328:	83 c4 08             	add    $0x8,%esp
f010332b:	ff 73 30             	pushl  0x30(%ebx)
f010332e:	68 ac 6c 10 f0       	push   $0xf0106cac
f0103333:	e8 92 fd ff ff       	call   f01030ca <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0103338:	83 c4 08             	add    $0x8,%esp
f010333b:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f010333f:	50                   	push   %eax
f0103340:	68 bb 6c 10 f0       	push   $0xf0106cbb
f0103345:	e8 80 fd ff ff       	call   f01030ca <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f010334a:	83 c4 08             	add    $0x8,%esp
f010334d:	ff 73 38             	pushl  0x38(%ebx)
f0103350:	68 ce 6c 10 f0       	push   $0xf0106cce
f0103355:	e8 70 fd ff ff       	call   f01030ca <cprintf>
	cprintf("  esp  0x%08x\n", tf->tf_esp);
f010335a:	83 c4 08             	add    $0x8,%esp
f010335d:	ff 73 3c             	pushl  0x3c(%ebx)
f0103360:	68 dd 6c 10 f0       	push   $0xf0106cdd
f0103365:	e8 60 fd ff ff       	call   f01030ca <cprintf>
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
f010336a:	83 c4 08             	add    $0x8,%esp
f010336d:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0103371:	50                   	push   %eax
f0103372:	68 ec 6c 10 f0       	push   $0xf0106cec
f0103377:	e8 4e fd ff ff       	call   f01030ca <cprintf>
}
f010337c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f010337f:	c9                   	leave  
f0103380:	c3                   	ret    

f0103381 <print_regs>:

void
print_regs(struct PushRegs *regs)
{
f0103381:	55                   	push   %ebp
f0103382:	89 e5                	mov    %esp,%ebp
f0103384:	53                   	push   %ebx
f0103385:	83 ec 0c             	sub    $0xc,%esp
f0103388:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f010338b:	ff 33                	pushl  (%ebx)
f010338d:	68 ff 6c 10 f0       	push   $0xf0106cff
f0103392:	e8 33 fd ff ff       	call   f01030ca <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103397:	83 c4 08             	add    $0x8,%esp
f010339a:	ff 73 04             	pushl  0x4(%ebx)
f010339d:	68 0e 6d 10 f0       	push   $0xf0106d0e
f01033a2:	e8 23 fd ff ff       	call   f01030ca <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f01033a7:	83 c4 08             	add    $0x8,%esp
f01033aa:	ff 73 08             	pushl  0x8(%ebx)
f01033ad:	68 1d 6d 10 f0       	push   $0xf0106d1d
f01033b2:	e8 13 fd ff ff       	call   f01030ca <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01033b7:	83 c4 08             	add    $0x8,%esp
f01033ba:	ff 73 0c             	pushl  0xc(%ebx)
f01033bd:	68 2c 6d 10 f0       	push   $0xf0106d2c
f01033c2:	e8 03 fd ff ff       	call   f01030ca <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01033c7:	83 c4 08             	add    $0x8,%esp
f01033ca:	ff 73 10             	pushl  0x10(%ebx)
f01033cd:	68 3b 6d 10 f0       	push   $0xf0106d3b
f01033d2:	e8 f3 fc ff ff       	call   f01030ca <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f01033d7:	83 c4 08             	add    $0x8,%esp
f01033da:	ff 73 14             	pushl  0x14(%ebx)
f01033dd:	68 4a 6d 10 f0       	push   $0xf0106d4a
f01033e2:	e8 e3 fc ff ff       	call   f01030ca <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01033e7:	83 c4 08             	add    $0x8,%esp
f01033ea:	ff 73 18             	pushl  0x18(%ebx)
f01033ed:	68 59 6d 10 f0       	push   $0xf0106d59
f01033f2:	e8 d3 fc ff ff       	call   f01030ca <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f01033f7:	83 c4 08             	add    $0x8,%esp
f01033fa:	ff 73 1c             	pushl  0x1c(%ebx)
f01033fd:	68 68 6d 10 f0       	push   $0xf0106d68
f0103402:	e8 c3 fc ff ff       	call   f01030ca <cprintf>
}
f0103407:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f010340a:	c9                   	leave  
f010340b:	c3                   	ret    

f010340c <trap_dispatch>:

static void
trap_dispatch(struct Trapframe *tf)
{
f010340c:	55                   	push   %ebp
f010340d:	89 e5                	mov    %esp,%ebp
f010340f:	56                   	push   %esi
f0103410:	53                   	push   %ebx
f0103411:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Handle processor exceptions.
	// LAB 3: Your code here.
	

        int32_t eax_return;
        struct PushRegs *regs;
        regs = &tf->tf_regs;

        // seanyliu
        switch (tf->tf_trapno) {
f0103414:	8b 43 28             	mov    0x28(%ebx),%eax
f0103417:	83 f8 0e             	cmp    $0xe,%eax
f010341a:	74 18                	je     f0103434 <trap_dispatch+0x28>
f010341c:	83 f8 0e             	cmp    $0xe,%eax
f010341f:	77 07                	ja     f0103428 <trap_dispatch+0x1c>
f0103421:	83 f8 03             	cmp    $0x3,%eax
f0103424:	74 1c                	je     f0103442 <trap_dispatch+0x36>
f0103426:	eb 4d                	jmp    f0103475 <trap_dispatch+0x69>
f0103428:	83 f8 20             	cmp    $0x20,%eax
f010342b:	74 3e                	je     f010346b <trap_dispatch+0x5f>
f010342d:	83 f8 30             	cmp    $0x30,%eax
f0103430:	74 1b                	je     f010344d <trap_dispatch+0x41>
f0103432:	eb 41                	jmp    f0103475 <trap_dispatch+0x69>
          case T_PGFLT:
            return page_fault_handler(tf);
f0103434:	83 ec 0c             	sub    $0xc,%esp
f0103437:	53                   	push   %ebx
f0103438:	e8 13 01 00 00       	call   f0103550 <page_fault_handler>
f010343d:	e9 88 00 00 00       	jmp    f01034ca <trap_dispatch+0xbe>
            break;
          case T_BRKPT:
            return monitor(tf);
f0103442:	83 ec 0c             	sub    $0xc,%esp
f0103445:	53                   	push   %ebx
f0103446:	e8 b5 d6 ff ff       	call   f0100b00 <monitor>
f010344b:	eb 7d                	jmp    f01034ca <trap_dispatch+0xbe>
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
f010344d:	83 ec 08             	sub    $0x8,%esp
f0103450:	ff 73 04             	pushl  0x4(%ebx)
f0103453:	ff 33                	pushl  (%ebx)
f0103455:	ff 73 10             	pushl  0x10(%ebx)
f0103458:	ff 73 18             	pushl  0x18(%ebx)
f010345b:	ff 73 14             	pushl  0x14(%ebx)
f010345e:	ff 73 1c             	pushl  0x1c(%ebx)
f0103461:	e8 5f 0b 00 00       	call   f0103fc5 <syscall>
            //if (eax_return < 0) panic("trap.c: syscall returned invalid value %d\n", eax_return);
            // don't panic, because use for -E_IPC_NOT_RECV
            regs->reg_eax = eax_return;
f0103466:	89 43 1c             	mov    %eax,0x1c(%ebx)
            return;
f0103469:	eb 5f                	jmp    f01034ca <trap_dispatch+0xbe>
            break;
          case IRQ_OFFSET + IRQ_TIMER:
	    // Add time tick increment to clock interrupts.
	    // LAB 6: Your code here.
            time_tick();
f010346b:	e8 a3 26 00 00       	call   f0105b13 <time_tick>
            sched_yield();
f0103470:	e8 2f 03 00 00       	call   f01037a4 <sched_yield>
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
f0103475:	83 7b 28 27          	cmpl   $0x27,0x28(%ebx)
f0103479:	75 17                	jne    f0103492 <trap_dispatch+0x86>
		cprintf("Spurious interrupt on irq 7\n");
f010347b:	83 ec 0c             	sub    $0xc,%esp
f010347e:	68 77 6d 10 f0       	push   $0xf0106d77
f0103483:	e8 42 fc ff ff       	call   f01030ca <cprintf>
		print_trapframe(tf);
f0103488:	89 1c 24             	mov    %ebx,(%esp)
f010348b:	e8 2c fe ff ff       	call   f01032bc <print_trapframe>
		return;
f0103490:	eb 38                	jmp    f01034ca <trap_dispatch+0xbe>
	}


	// Handle keyboard interrupts.
	// LAB 7: Your code here.

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f0103492:	83 ec 0c             	sub    $0xc,%esp
f0103495:	53                   	push   %ebx
f0103496:	e8 21 fe ff ff       	call   f01032bc <print_trapframe>
	if (tf->tf_cs == GD_KT)
f010349b:	83 c4 10             	add    $0x10,%esp
f010349e:	66 83 7b 34 08       	cmpw   $0x8,0x34(%ebx)
f01034a3:	75 17                	jne    f01034bc <trap_dispatch+0xb0>
		panic("unhandled trap in kernel");
f01034a5:	83 ec 04             	sub    $0x4,%esp
f01034a8:	68 94 6d 10 f0       	push   $0xf0106d94
f01034ad:	68 ed 00 00 00       	push   $0xed
f01034b2:	68 ad 6d 10 f0       	push   $0xf0106dad
f01034b7:	e8 32 cc ff ff       	call   f01000ee <_panic>
	else {
		env_destroy(curenv);
f01034bc:	83 ec 0c             	sub    $0xc,%esp
f01034bf:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f01034c5:	e8 f0 f9 ff ff       	call   f0102eba <env_destroy>
		return;
	}
}
f01034ca:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f01034cd:	5b                   	pop    %ebx
f01034ce:	5e                   	pop    %esi
f01034cf:	c9                   	leave  
f01034d0:	c3                   	ret    

f01034d1 <trap>:

void
trap(struct Trapframe *tf)
{
f01034d1:	55                   	push   %ebp
f01034d2:	89 e5                	mov    %esp,%ebp
f01034d4:	83 ec 08             	sub    $0x8,%esp
f01034d7:	8b 55 08             	mov    0x8(%ebp),%edx
	if ((tf->tf_cs & 3) == 3) {
f01034da:	0f b7 42 34          	movzwl 0x34(%edx),%eax
f01034de:	83 e0 03             	and    $0x3,%eax
f01034e1:	83 f8 03             	cmp    $0x3,%eax
f01034e4:	75 3c                	jne    f0103522 <trap+0x51>
		// Trapped from user mode.
		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		assert(curenv);
f01034e6:	83 3d c4 5b 2f f0 00 	cmpl   $0x0,0xf02f5bc4
f01034ed:	75 19                	jne    f0103508 <trap+0x37>
f01034ef:	68 b9 6d 10 f0       	push   $0xf0106db9
f01034f4:	68 44 68 10 f0       	push   $0xf0106844
f01034f9:	68 fc 00 00 00       	push   $0xfc
f01034fe:	68 ad 6d 10 f0       	push   $0xf0106dad
f0103503:	e8 e6 cb ff ff       	call   f01000ee <_panic>
		curenv->env_tf = *tf;
f0103508:	83 ec 04             	sub    $0x4,%esp
f010350b:	6a 44                	push   $0x44
f010350d:	52                   	push   %edx
f010350e:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f0103514:	e8 3e 18 00 00       	call   f0104d57 <memcpy>
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0103519:	8b 15 c4 5b 2f f0    	mov    0xf02f5bc4,%edx
f010351f:	83 c4 10             	add    $0x10,%esp
	}
	
	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
f0103522:	83 ec 0c             	sub    $0xc,%esp
f0103525:	52                   	push   %edx
f0103526:	e8 e1 fe ff ff       	call   f010340c <trap_dispatch>

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNABLE)
f010352b:	83 c4 10             	add    $0x10,%esp
f010352e:	83 3d c4 5b 2f f0 00 	cmpl   $0x0,0xf02f5bc4
f0103535:	74 14                	je     f010354b <trap+0x7a>
f0103537:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f010353c:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0103540:	75 09                	jne    f010354b <trap+0x7a>
		env_run(curenv);
f0103542:	83 ec 0c             	sub    $0xc,%esp
f0103545:	50                   	push   %eax
f0103546:	e8 c4 f9 ff ff       	call   f0102f0f <env_run>
	else
		sched_yield();
f010354b:	e8 54 02 00 00       	call   f01037a4 <sched_yield>

f0103550 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0103550:	55                   	push   %ebp
f0103551:	89 e5                	mov    %esp,%ebp
f0103553:	57                   	push   %edi
f0103554:	56                   	push   %esi
f0103555:	53                   	push   %ebx
f0103556:	83 ec 0c             	sub    $0xc,%esp
}

static __inline uint32_t
rcr2(void)
{
f0103559:	0f 20 d7             	mov    %cr2,%edi
	uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	
	// LAB 3: Your code here.
        // seanyliu
	if ((tf->tf_cs & 3) == 0) panic("page_fault_handler: page fault happened in kernel mode.");
f010355c:	8b 45 08             	mov    0x8(%ebp),%eax
f010355f:	f6 40 34 03          	testb  $0x3,0x34(%eax)
f0103563:	75 17                	jne    f010357c <page_fault_handler+0x2c>
f0103565:	83 ec 04             	sub    $0x4,%esp
f0103568:	68 10 6e 10 f0       	push   $0xf0106e10
f010356d:	68 1b 01 00 00       	push   $0x11b
f0103572:	68 ad 6d 10 f0       	push   $0xf0106dad
f0103577:	e8 72 cb ff ff       	call   f01000ee <_panic>

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
f010357c:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103581:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0103585:	75 30                	jne    f01035b7 <page_fault_handler+0x67>
	  // Destroy the environment that caused the fault.
	  cprintf("[%08x] user fault va %08x ip %08x\n",
f0103587:	8b 55 08             	mov    0x8(%ebp),%edx
f010358a:	ff 72 30             	pushl  0x30(%edx)
f010358d:	57                   	push   %edi
f010358e:	ff 70 4c             	pushl  0x4c(%eax)
f0103591:	68 48 6e 10 f0       	push   $0xf0106e48
f0103596:	e8 2f fb ff ff       	call   f01030ca <cprintf>
		  curenv->env_id, fault_va, tf->tf_eip);
	  print_trapframe(tf);
f010359b:	83 c4 04             	add    $0x4,%esp
f010359e:	ff 75 08             	pushl  0x8(%ebp)
f01035a1:	e8 16 fd ff ff       	call   f01032bc <print_trapframe>
	  env_destroy(curenv);
f01035a6:	83 c4 04             	add    $0x4,%esp
f01035a9:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f01035af:	e8 06 f9 ff ff       	call   f0102eba <env_destroy>
f01035b4:	83 c4 10             	add    $0x10,%esp
        }

        uint32_t writeloc = UXSTACKTOP - sizeof(struct UTrapframe);
f01035b7:	bb cc ff bf ee       	mov    $0xeebfffcc,%ebx
        // check if recursive case or not
        if ((tf->tf_esp >= UXSTACKTOP - PGSIZE) && (tf->tf_esp <= UXSTACKTOP - 1)) {
f01035bc:	8b 75 08             	mov    0x8(%ebp),%esi
f01035bf:	8b 56 3c             	mov    0x3c(%esi),%edx
f01035c2:	8d 82 00 10 40 11    	lea    0x11401000(%edx),%eax
f01035c8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
f01035cd:	77 03                	ja     f01035d2 <page_fault_handler+0x82>
          writeloc = tf->tf_esp - sizeof(struct UTrapframe) - 4;
f01035cf:	8d 5a c8             	lea    0xffffffc8(%edx),%ebx
        }

        // verify that we can write below UXSTACKTOP
        user_mem_assert(curenv, (void *)writeloc, sizeof(struct UTrapframe), PTE_U);
f01035d2:	6a 04                	push   $0x4
f01035d4:	6a 34                	push   $0x34
f01035d6:	53                   	push   %ebx
f01035d7:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f01035dd:	e8 29 e6 ff ff       	call   f0101c0b <user_mem_assert>

        // Create the UTrapframe
        struct UTrapframe* utf;
        utf = (struct UTrapframe*) writeloc;
        utf->utf_fault_va = fault_va;
f01035e2:	89 3b                	mov    %edi,(%ebx)
        utf->utf_err = tf->tf_err;
f01035e4:	8b 55 08             	mov    0x8(%ebp),%edx
f01035e7:	8b 42 2c             	mov    0x2c(%edx),%eax
f01035ea:	89 43 04             	mov    %eax,0x4(%ebx)
        utf->utf_regs = tf->tf_regs;
f01035ed:	8d 7b 08             	lea    0x8(%ebx),%edi
f01035f0:	fc                   	cld    
f01035f1:	b9 08 00 00 00       	mov    $0x8,%ecx
f01035f6:	8b 75 08             	mov    0x8(%ebp),%esi
f01035f9:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
        utf->utf_eip = tf->tf_eip;
f01035fb:	8b 42 30             	mov    0x30(%edx),%eax
f01035fe:	89 43 28             	mov    %eax,0x28(%ebx)
        utf->utf_eflags = tf->tf_eflags;
f0103601:	8b 42 38             	mov    0x38(%edx),%eax
f0103604:	89 43 2c             	mov    %eax,0x2c(%ebx)
        utf->utf_esp = tf->tf_esp;
f0103607:	8b 42 3c             	mov    0x3c(%edx),%eax
f010360a:	89 43 30             	mov    %eax,0x30(%ebx)

        // Update the tf->tf_esp
        tf->tf_esp = (uintptr_t)writeloc;
f010360d:	89 5a 3c             	mov    %ebx,0x3c(%edx)

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
        tf->tf_eip = (uintptr_t) curenv->env_pgfault_upcall;
f0103610:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103615:	8b 40 64             	mov    0x64(%eax),%eax
f0103618:	89 42 30             	mov    %eax,0x30(%edx)
        //curnenv->env_tf = tf;
        env_run(curenv);
f010361b:	83 c4 04             	add    $0x4,%esp
f010361e:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f0103624:	e8 e6 f8 ff ff       	call   f0102f0f <env_run>
f0103629:	00 00                	add    %al,(%eax)
	...

f010362c <handler0>:
 * Lab 3: Your code here for generating entry points for the different traps.
 */
#define IRQ_OFFSET 32

  TRAPHANDLER_NOEC(handler0, T_DIVIDE); /* DIVIDE is already used */
f010362c:	6a 00                	push   $0x0
f010362e:	6a 00                	push   $0x0
f0103630:	e9 4b 20 02 00       	jmp    f0125680 <_alltraps>
f0103635:	90                   	nop    

f0103636 <handler1>:
  TRAPHANDLER_NOEC(handler1, T_DEBUG);
f0103636:	6a 00                	push   $0x0
f0103638:	6a 01                	push   $0x1
f010363a:	e9 41 20 02 00       	jmp    f0125680 <_alltraps>
f010363f:	90                   	nop    

f0103640 <handler2>:
  TRAPHANDLER_NOEC(handler2, T_NMI);
f0103640:	6a 00                	push   $0x0
f0103642:	6a 02                	push   $0x2
f0103644:	e9 37 20 02 00       	jmp    f0125680 <_alltraps>
f0103649:	90                   	nop    

f010364a <handler3>:
  TRAPHANDLER_NOEC(handler3, T_BRKPT);
f010364a:	6a 00                	push   $0x0
f010364c:	6a 03                	push   $0x3
f010364e:	e9 2d 20 02 00       	jmp    f0125680 <_alltraps>
f0103653:	90                   	nop    

f0103654 <handler4>:
  TRAPHANDLER_NOEC(handler4, T_OFLOW);
f0103654:	6a 00                	push   $0x0
f0103656:	6a 04                	push   $0x4
f0103658:	e9 23 20 02 00       	jmp    f0125680 <_alltraps>
f010365d:	90                   	nop    

f010365e <handler5>:
  TRAPHANDLER_NOEC(handler5, T_BOUND);
f010365e:	6a 00                	push   $0x0
f0103660:	6a 05                	push   $0x5
f0103662:	e9 19 20 02 00       	jmp    f0125680 <_alltraps>
f0103667:	90                   	nop    

f0103668 <handler6>:
  TRAPHANDLER_NOEC(handler6, T_ILLOP);
f0103668:	6a 00                	push   $0x0
f010366a:	6a 06                	push   $0x6
f010366c:	e9 0f 20 02 00       	jmp    f0125680 <_alltraps>
f0103671:	90                   	nop    

f0103672 <handler7>:
  TRAPHANDLER_NOEC(handler7, T_DEVICE);
f0103672:	6a 00                	push   $0x0
f0103674:	6a 07                	push   $0x7
f0103676:	e9 05 20 02 00       	jmp    f0125680 <_alltraps>
f010367b:	90                   	nop    

f010367c <handler8>:
  TRAPHANDLER(handler8, T_DBLFLT);
f010367c:	6a 08                	push   $0x8
f010367e:	e9 fd 1f 02 00       	jmp    f0125680 <_alltraps>
f0103683:	90                   	nop    

f0103684 <handler9>:
/* handler9: */
  TRAPHANDLER(handler9, T_DIVIDE); // need for cleanliness of table
f0103684:	6a 00                	push   $0x0
f0103686:	e9 f5 1f 02 00       	jmp    f0125680 <_alltraps>
f010368b:	90                   	nop    

f010368c <handler10>:
  TRAPHANDLER(handler10, T_TSS);
f010368c:	6a 0a                	push   $0xa
f010368e:	e9 ed 1f 02 00       	jmp    f0125680 <_alltraps>
f0103693:	90                   	nop    

f0103694 <handler11>:
  TRAPHANDLER(handler11, T_SEGNP);
f0103694:	6a 0b                	push   $0xb
f0103696:	e9 e5 1f 02 00       	jmp    f0125680 <_alltraps>
f010369b:	90                   	nop    

f010369c <handler12>:
  TRAPHANDLER(handler12, T_STACK);
f010369c:	6a 0c                	push   $0xc
f010369e:	e9 dd 1f 02 00       	jmp    f0125680 <_alltraps>
f01036a3:	90                   	nop    

f01036a4 <handler13>:
  TRAPHANDLER(handler13, T_GPFLT);
f01036a4:	6a 0d                	push   $0xd
f01036a6:	e9 d5 1f 02 00       	jmp    f0125680 <_alltraps>
f01036ab:	90                   	nop    

f01036ac <handler14>:
  TRAPHANDLER(handler14, T_PGFLT);
f01036ac:	6a 0e                	push   $0xe
f01036ae:	e9 cd 1f 02 00       	jmp    f0125680 <_alltraps>
f01036b3:	90                   	nop    

f01036b4 <handler15>:
/*handler15:*/
/*  TRAPHANDLER(RES, T_RES);*/
  TRAPHANDLER(handler15, T_PGFLT); // need for cleanliness of table
f01036b4:	6a 0e                	push   $0xe
f01036b6:	e9 c5 1f 02 00       	jmp    f0125680 <_alltraps>
f01036bb:	90                   	nop    

f01036bc <handler16>:
  TRAPHANDLER_NOEC(handler16, T_FPERR);
f01036bc:	6a 00                	push   $0x0
f01036be:	6a 10                	push   $0x10
f01036c0:	e9 bb 1f 02 00       	jmp    f0125680 <_alltraps>
f01036c5:	90                   	nop    

f01036c6 <handler17>:
  TRAPHANDLER_NOEC(handler17, T_ALIGN);
f01036c6:	6a 00                	push   $0x0
f01036c8:	6a 11                	push   $0x11
f01036ca:	e9 b1 1f 02 00       	jmp    f0125680 <_alltraps>
f01036cf:	90                   	nop    

f01036d0 <handler18>:
  TRAPHANDLER_NOEC(handler18, T_MCHK);
f01036d0:	6a 00                	push   $0x0
f01036d2:	6a 12                	push   $0x12
f01036d4:	e9 a7 1f 02 00       	jmp    f0125680 <_alltraps>
f01036d9:	90                   	nop    

f01036da <handler19>:
  TRAPHANDLER_NOEC(handler19, T_SIMDERR );
f01036da:	6a 00                	push   $0x0
f01036dc:	6a 13                	push   $0x13
f01036de:	e9 9d 1f 02 00       	jmp    f0125680 <_alltraps>
f01036e3:	90                   	nop    

f01036e4 <handler32>:

# vector table
.data
.globl irqs
irqs:
.text

  TRAPHANDLER_NOEC(handler32, IRQ_OFFSET + IRQ_TIMER);
f01036e4:	6a 00                	push   $0x0
f01036e6:	6a 20                	push   $0x20
f01036e8:	e9 93 1f 02 00       	jmp    f0125680 <_alltraps>
f01036ed:	90                   	nop    

f01036ee <handler33>:
  TRAPHANDLER_NOEC(handler33, IRQ_OFFSET + IRQ_KBD);
f01036ee:	6a 00                	push   $0x0
f01036f0:	6a 21                	push   $0x21
f01036f2:	e9 89 1f 02 00       	jmp    f0125680 <_alltraps>
f01036f7:	90                   	nop    

f01036f8 <handler34>:
  TRAPHANDLER_NOEC(handler34, IRQ_OFFSET + 2);
f01036f8:	6a 00                	push   $0x0
f01036fa:	6a 22                	push   $0x22
f01036fc:	e9 7f 1f 02 00       	jmp    f0125680 <_alltraps>
f0103701:	90                   	nop    

f0103702 <handler35>:
  TRAPHANDLER_NOEC(handler35, IRQ_OFFSET + 3);
f0103702:	6a 00                	push   $0x0
f0103704:	6a 23                	push   $0x23
f0103706:	e9 75 1f 02 00       	jmp    f0125680 <_alltraps>
f010370b:	90                   	nop    

f010370c <handler36>:
  TRAPHANDLER_NOEC(handler36, IRQ_OFFSET + 4);
f010370c:	6a 00                	push   $0x0
f010370e:	6a 24                	push   $0x24
f0103710:	e9 6b 1f 02 00       	jmp    f0125680 <_alltraps>
f0103715:	90                   	nop    

f0103716 <handler37>:
  TRAPHANDLER_NOEC(handler37, IRQ_OFFSET + 5);
f0103716:	6a 00                	push   $0x0
f0103718:	6a 25                	push   $0x25
f010371a:	e9 61 1f 02 00       	jmp    f0125680 <_alltraps>
f010371f:	90                   	nop    

f0103720 <handler38>:
  TRAPHANDLER_NOEC(handler38, IRQ_OFFSET + 6);
f0103720:	6a 00                	push   $0x0
f0103722:	6a 26                	push   $0x26
f0103724:	e9 57 1f 02 00       	jmp    f0125680 <_alltraps>
f0103729:	90                   	nop    

f010372a <handler39>:
  TRAPHANDLER_NOEC(handler39, IRQ_OFFSET + IRQ_SPURIOUS);
f010372a:	6a 00                	push   $0x0
f010372c:	6a 27                	push   $0x27
f010372e:	e9 4d 1f 02 00       	jmp    f0125680 <_alltraps>
f0103733:	90                   	nop    

f0103734 <handler40>:
  TRAPHANDLER_NOEC(handler40, IRQ_OFFSET + 8);
f0103734:	6a 00                	push   $0x0
f0103736:	6a 28                	push   $0x28
f0103738:	e9 43 1f 02 00       	jmp    f0125680 <_alltraps>
f010373d:	90                   	nop    

f010373e <handler41>:
  TRAPHANDLER_NOEC(handler41, IRQ_OFFSET + 9);
f010373e:	6a 00                	push   $0x0
f0103740:	6a 29                	push   $0x29
f0103742:	e9 39 1f 02 00       	jmp    f0125680 <_alltraps>
f0103747:	90                   	nop    

f0103748 <handler42>:
  TRAPHANDLER_NOEC(handler42, IRQ_OFFSET + 10);
f0103748:	6a 00                	push   $0x0
f010374a:	6a 2a                	push   $0x2a
f010374c:	e9 2f 1f 02 00       	jmp    f0125680 <_alltraps>
f0103751:	90                   	nop    

f0103752 <handler43>:
  TRAPHANDLER_NOEC(handler43, IRQ_OFFSET + 11);
f0103752:	6a 00                	push   $0x0
f0103754:	6a 2b                	push   $0x2b
f0103756:	e9 25 1f 02 00       	jmp    f0125680 <_alltraps>
f010375b:	90                   	nop    

f010375c <handler44>:
  TRAPHANDLER_NOEC(handler44, IRQ_OFFSET + 12);
f010375c:	6a 00                	push   $0x0
f010375e:	6a 2c                	push   $0x2c
f0103760:	e9 1b 1f 02 00       	jmp    f0125680 <_alltraps>
f0103765:	90                   	nop    

f0103766 <handler45>:
  TRAPHANDLER_NOEC(handler45, IRQ_OFFSET + 13);
f0103766:	6a 00                	push   $0x0
f0103768:	6a 2d                	push   $0x2d
f010376a:	e9 11 1f 02 00       	jmp    f0125680 <_alltraps>
f010376f:	90                   	nop    

f0103770 <handler46>:
  TRAPHANDLER_NOEC(handler46, IRQ_OFFSET + IRQ_IDE);
f0103770:	6a 00                	push   $0x0
f0103772:	6a 2e                	push   $0x2e
f0103774:	e9 07 1f 02 00       	jmp    f0125680 <_alltraps>
f0103779:	90                   	nop    

f010377a <handler47>:
  TRAPHANDLER_NOEC(handler47, IRQ_OFFSET + 14);
f010377a:	6a 00                	push   $0x0
f010377c:	6a 2e                	push   $0x2e
f010377e:	e9 fd 1e 02 00       	jmp    f0125680 <_alltraps>
f0103783:	90                   	nop    

f0103784 <handler48>:


  TRAPHANDLER_NOEC(handler48, T_SYSCALL);
f0103784:	6a 00                	push   $0x0
f0103786:	6a 30                	push   $0x30
f0103788:	e9 f3 1e 02 00       	jmp    f0125680 <_alltraps>
f010378d:	90                   	nop    

f010378e <handler51>:
  TRAPHANDLER_NOEC(handler51, IRQ_OFFSET + IRQ_ERROR);
f010378e:	6a 00                	push   $0x0
f0103790:	6a 33                	push   $0x33
f0103792:	e9 e9 1e 02 00       	jmp    f0125680 <_alltraps>
f0103797:	90                   	nop    

f0103798 <handler500>:
  TRAPHANDLER_NOEC(handler500, T_DEFAULT);
f0103798:	6a 00                	push   $0x0
f010379a:	68 f4 01 00 00       	push   $0x1f4
f010379f:	e9 dc 1e 02 00       	jmp    f0125680 <_alltraps>

f01037a4 <sched_yield>:

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f01037a4:	55                   	push   %ebp
f01037a5:	89 e5                	mov    %esp,%ebp
f01037a7:	57                   	push   %edi
f01037a8:	56                   	push   %esi
f01037a9:	53                   	push   %ebx
f01037aa:	83 ec 0c             	sub    $0xc,%esp
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
f01037ad:	bf 00 00 00 00       	mov    $0x0,%edi
        if (curenv != NULL) {
f01037b2:	83 3d c4 5b 2f f0 00 	cmpl   $0x0,0xf02f5bc4
f01037b9:	74 0e                	je     f01037c9 <sched_yield+0x25>
          previdx = ENVX(curenv->env_id);
f01037bb:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f01037c0:	8b 78 4c             	mov    0x4c(%eax),%edi
f01037c3:	81 e7 ff 03 00 00    	and    $0x3ff,%edi
        }

        // LAB 4: Challenge
        // implement fixed priority scheduler
        int bidx; // base idx
        int eidx; // env idx
        int newidx = 0; // next priority to select
f01037c9:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
        int newpriority = ENV_PR_LOWEST - 1; // next priority's index
f01037d0:	c7 45 ec fd ff ff ff 	movl   $0xfffffffd,0xffffffec(%ebp)
        for (bidx = 0; bidx < NENV; bidx++) {
f01037d7:	bb 00 00 00 00       	mov    $0x0,%ebx
f01037dc:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f01037e1:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
          // for loop also checks the previous idx
          eidx = (bidx + previdx + 1) % NENV; // explicitly start at previdx+1
f01037e4:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
f01037e7:	8d 51 01             	lea    0x1(%ecx),%edx
f01037ea:	89 d0                	mov    %edx,%eax
f01037ec:	85 d2                	test   %edx,%edx
f01037ee:	79 06                	jns    f01037f6 <sched_yield+0x52>
f01037f0:	8d 81 00 04 00 00    	lea    0x400(%ecx),%eax
f01037f6:	25 00 fc ff ff       	and    $0xfffffc00,%eax
          if (eidx != 0) { // skip 0
f01037fb:	89 d1                	mov    %edx,%ecx
f01037fd:	29 c1                	sub    %eax,%ecx
f01037ff:	74 22                	je     f0103823 <sched_yield+0x7f>
            if (envs[eidx].env_status == ENV_RUNNABLE) {
f0103801:	8b 55 e8             	mov    0xffffffe8(%ebp),%edx
f0103804:	89 c8                	mov    %ecx,%eax
f0103806:	c1 e0 07             	shl    $0x7,%eax
f0103809:	83 7c 10 54 01       	cmpl   $0x1,0x54(%eax,%edx,1)
f010380e:	75 13                	jne    f0103823 <sched_yield+0x7f>
              if (envs[eidx].env_priority > newpriority) {
f0103810:	8b 75 ec             	mov    0xffffffec(%ebp),%esi
f0103813:	39 74 10 7c          	cmp    %esi,0x7c(%eax,%edx,1)
f0103817:	7e 0a                	jle    f0103823 <sched_yield+0x7f>
                newpriority = envs[eidx].env_priority;
f0103819:	8b 44 10 7c          	mov    0x7c(%eax,%edx,1),%eax
f010381d:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
                newidx = eidx;
f0103820:	89 4d f0             	mov    %ecx,0xfffffff0(%ebp)
f0103823:	43                   	inc    %ebx
f0103824:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
f010382a:	7e b8                	jle    f01037e4 <sched_yield+0x40>
              }
            }
          }
        }
        if (newidx != 0) {
f010382c:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0103830:	74 15                	je     f0103847 <sched_yield+0xa3>
          env_run(&envs[newidx]);
f0103832:	83 ec 0c             	sub    $0xc,%esp
f0103835:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103838:	c1 e0 07             	shl    $0x7,%eax
f010383b:	03 05 c0 5b 2f f0    	add    0xf02f5bc0,%eax
f0103841:	50                   	push   %eax
f0103842:	e8 c8 f6 ff ff       	call   f0102f0f <env_run>
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
f0103847:	a1 c0 5b 2f f0       	mov    0xf02f5bc0,%eax
f010384c:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0103850:	75 09                	jne    f010385b <sched_yield+0xb7>
		env_run(&envs[0]);
f0103852:	83 ec 0c             	sub    $0xc,%esp
f0103855:	50                   	push   %eax
f0103856:	e8 b4 f6 ff ff       	call   f0102f0f <env_run>
	else {
		cprintf("Destroyed all environments - nothing more to do!\n");
f010385b:	83 ec 0c             	sub    $0xc,%esp
f010385e:	68 6c 6e 10 f0       	push   $0xf0106e6c
f0103863:	e8 62 f8 ff ff       	call   f01030ca <cprintf>
		while (1)
f0103868:	83 c4 10             	add    $0x10,%esp
			monitor(NULL);
f010386b:	83 ec 0c             	sub    $0xc,%esp
f010386e:	6a 00                	push   $0x0
f0103870:	e8 8b d2 ff ff       	call   f0100b00 <monitor>
f0103875:	83 c4 10             	add    $0x10,%esp
f0103878:	eb f1                	jmp    f010386b <sched_yield+0xc7>
	...

f010387c <sys_cputs>:
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
f010387c:	55                   	push   %ebp
f010387d:	89 e5                	mov    %esp,%ebp
f010387f:	56                   	push   %esi
f0103880:	53                   	push   %ebx
f0103881:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0103884:	8b 75 0c             	mov    0xc(%ebp),%esi
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.
        user_mem_assert(curenv, s, len, PTE_U);
f0103887:	6a 04                	push   $0x4
f0103889:	56                   	push   %esi
f010388a:	53                   	push   %ebx
f010388b:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f0103891:	e8 75 e3 ff ff       	call   f0101c0b <user_mem_assert>
	
	// LAB 3: Your code here.

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f0103896:	83 c4 0c             	add    $0xc,%esp
f0103899:	53                   	push   %ebx
f010389a:	56                   	push   %esi
f010389b:	68 9e 6e 10 f0       	push   $0xf0106e9e
f01038a0:	e8 25 f8 ff ff       	call   f01030ca <cprintf>
}
f01038a5:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f01038a8:	5b                   	pop    %ebx
f01038a9:	5e                   	pop    %esi
f01038aa:	c9                   	leave  
f01038ab:	c3                   	ret    

f01038ac <sys_cgetc>:

// Read a character from the system console.
// Returns the character.
static int
sys_cgetc(void)
{
f01038ac:	55                   	push   %ebp
f01038ad:	89 e5                	mov    %esp,%ebp
f01038af:	83 ec 08             	sub    $0x8,%esp
	int c;

	// The cons_getc() primitive doesn't wait for a character,
	// but the sys_cgetc() system call does.
	while ((c = cons_getc()) == 0)
f01038b2:	e8 55 cd ff ff       	call   f010060c <cons_getc>
f01038b7:	85 c0                	test   %eax,%eax
f01038b9:	74 f7                	je     f01038b2 <sys_cgetc+0x6>
		/* do nothing */;

	return c;
}
f01038bb:	c9                   	leave  
f01038bc:	c3                   	ret    

f01038bd <sys_getenvid>:

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
f01038bd:	55                   	push   %ebp
f01038be:	89 e5                	mov    %esp,%ebp
	return curenv->env_id;
f01038c0:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f01038c5:	8b 40 4c             	mov    0x4c(%eax),%eax
}
f01038c8:	c9                   	leave  
f01038c9:	c3                   	ret    

f01038ca <sys_env_destroy>:

// Destroy a given environment (possibly the currently running environment).
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
f01038ca:	55                   	push   %ebp
f01038cb:	89 e5                	mov    %esp,%ebp
f01038cd:	83 ec 0c             	sub    $0xc,%esp
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f01038d0:	6a 01                	push   $0x1
f01038d2:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f01038d5:	50                   	push   %eax
f01038d6:	ff 75 08             	pushl  0x8(%ebp)
f01038d9:	e8 da ef ff ff       	call   f01028b8 <envid2env>
f01038de:	83 c4 10             	add    $0x10,%esp
		return r;
f01038e1:	89 c2                	mov    %eax,%edx
f01038e3:	85 c0                	test   %eax,%eax
f01038e5:	78 10                	js     f01038f7 <sys_env_destroy+0x2d>
	env_destroy(e);
f01038e7:	83 ec 0c             	sub    $0xc,%esp
f01038ea:	ff 75 fc             	pushl  0xfffffffc(%ebp)
f01038ed:	e8 c8 f5 ff ff       	call   f0102eba <env_destroy>
	return 0;
f01038f2:	ba 00 00 00 00       	mov    $0x0,%edx
}
f01038f7:	89 d0                	mov    %edx,%eax
f01038f9:	c9                   	leave  
f01038fa:	c3                   	ret    

f01038fb <sys_yield>:

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
f01038fb:	55                   	push   %ebp
f01038fc:	89 e5                	mov    %esp,%ebp
f01038fe:	83 ec 08             	sub    $0x8,%esp
	sched_yield();
f0103901:	e8 9e fe ff ff       	call   f01037a4 <sched_yield>

f0103906 <sys_exofork>:
}

// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
static envid_t
sys_exofork(void)
{
f0103906:	55                   	push   %ebp
f0103907:	89 e5                	mov    %esp,%ebp
f0103909:	83 ec 10             	sub    $0x10,%esp
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
f010390c:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103911:	ff 70 4c             	pushl  0x4c(%eax)
f0103914:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f0103917:	50                   	push   %eax
f0103918:	e8 9b f1 ff ff       	call   f0102ab8 <env_alloc>
f010391d:	83 c4 10             	add    $0x10,%esp
          return create_status; // env_alloc can return -E_NO_FREE_ENV
f0103920:	89 c2                	mov    %eax,%edx
f0103922:	85 c0                	test   %eax,%eax
f0103924:	78 2d                	js     f0103953 <sys_exofork+0x4d>
        }

	// status is set to ENV_NOT_RUNNABLE
        new_env->env_status = ENV_NOT_RUNNABLE;
f0103926:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f0103929:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)

        // register set is copied from the current environment
        // -- but tweaked so sys_exofork will appear to return 0
        memmove(&new_env->env_tf, &curenv->env_tf, sizeof(curenv->env_tf));
f0103930:	83 ec 04             	sub    $0x4,%esp
f0103933:	6a 44                	push   $0x44
f0103935:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f010393b:	ff 75 fc             	pushl  0xfffffffc(%ebp)
f010393e:	e8 a9 13 00 00       	call   f0104cec <memmove>
        // Why do we put eax = 0?  See:
        // http://pdos.csail.mit.edu/6.828/2009/xv6-book/trap.pdf
        // Syscall records the return value of the system call function in %eax.
        new_env->env_tf.tf_regs.reg_eax = (uint32_t) 0;
f0103943:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f0103946:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

        return new_env->env_id;
f010394d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f0103950:	8b 50 4c             	mov    0x4c(%eax),%edx
}
f0103953:	89 d0                	mov    %edx,%eax
f0103955:	c9                   	leave  
f0103956:	c3                   	ret    

f0103957 <sys_env_set_status>:

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
f0103957:	55                   	push   %ebp
f0103958:	89 e5                	mov    %esp,%ebp
f010395a:	53                   	push   %ebx
f010395b:	83 ec 08             	sub    $0x8,%esp
f010395e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
f0103961:	6a 01                	push   $0x1
f0103963:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
f0103966:	50                   	push   %eax
f0103967:	ff 75 08             	pushl  0x8(%ebp)
f010396a:	e8 49 ef ff ff       	call   f01028b8 <envid2env>
f010396f:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103972:	89 c2                	mov    %eax,%edx
f0103974:	85 c0                	test   %eax,%eax
f0103976:	78 18                	js     f0103990 <sys_env_set_status+0x39>
        }
        if ((status == ENV_RUNNABLE) || (status == ENV_NOT_RUNNABLE)) {
f0103978:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
          env->env_status = status;
        } else {
          return -E_INVAL;
f010397b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103980:	83 f8 01             	cmp    $0x1,%eax
f0103983:	77 0b                	ja     f0103990 <sys_env_set_status+0x39>
f0103985:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
f0103988:	89 58 54             	mov    %ebx,0x54(%eax)
        }

        return 0;
f010398b:	ba 00 00 00 00       	mov    $0x0,%edx
	// panic("sys_env_set_status not implemented");
}
f0103990:	89 d0                	mov    %edx,%eax
f0103992:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0103995:	c9                   	leave  
f0103996:	c3                   	ret    

f0103997 <sys_env_set_trapframe>:

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
f0103997:	55                   	push   %ebp
f0103998:	89 e5                	mov    %esp,%ebp
f010399a:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
        int r;
        struct Env *env;
        if ((r = envid2env(envid, &env, 1)) < 0) {
f010399d:	6a 01                	push   $0x1
f010399f:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f01039a2:	50                   	push   %eax
f01039a3:	ff 75 08             	pushl  0x8(%ebp)
f01039a6:	e8 0d ef ff ff       	call   f01028b8 <envid2env>
f01039ab:	83 c4 10             	add    $0x10,%esp
          return r;
f01039ae:	89 c2                	mov    %eax,%edx
f01039b0:	85 c0                	test   %eax,%eax
f01039b2:	78 27                	js     f01039db <sys_env_set_trapframe+0x44>
        }
        env->env_tf = *tf;
f01039b4:	83 ec 04             	sub    $0x4,%esp
f01039b7:	6a 44                	push   $0x44
f01039b9:	ff 75 0c             	pushl  0xc(%ebp)
f01039bc:	ff 75 fc             	pushl  0xfffffffc(%ebp)
f01039bf:	e8 93 13 00 00       	call   f0104d57 <memcpy>
        env->env_tf.tf_cs |= 3;
f01039c4:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f01039c7:	66 83 48 34 03       	orw    $0x3,0x34(%eax)
        env->env_tf.tf_eflags |= FL_IF;
f01039cc:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f01039cf:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
        return 0;
f01039d6:	ba 00 00 00 00       	mov    $0x0,%edx

	//panic("sys_set_trapframe not implemented");
}
f01039db:	89 d0                	mov    %edx,%eax
f01039dd:	c9                   	leave  
f01039de:	c3                   	ret    

f01039df <sys_env_set_pgfault_upcall>:

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
f01039df:	55                   	push   %ebp
f01039e0:	89 e5                	mov    %esp,%ebp
f01039e2:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here.
        // seanyliu

        int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
f01039e5:	6a 01                	push   $0x1
f01039e7:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
f01039ea:	50                   	push   %eax
f01039eb:	ff 75 08             	pushl  0x8(%ebp)
f01039ee:	e8 c5 ee ff ff       	call   f01028b8 <envid2env>
f01039f3:	83 c4 10             	add    $0x10,%esp
	  return r;
f01039f6:	89 c2                	mov    %eax,%edx
f01039f8:	85 c0                	test   %eax,%eax
f01039fa:	78 0e                	js     f0103a0a <sys_env_set_pgfault_upcall+0x2b>
        }

        env->env_pgfault_upcall = func;
f01039fc:	8b 55 0c             	mov    0xc(%ebp),%edx
f01039ff:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
f0103a02:	89 50 64             	mov    %edx,0x64(%eax)

        return 0;
f0103a05:	ba 00 00 00 00       	mov    $0x0,%edx
        
	//panic("sys_env_set_pgfault_upcall not implemented");
}
f0103a0a:	89 d0                	mov    %edx,%eax
f0103a0c:	c9                   	leave  
f0103a0d:	c3                   	ret    

f0103a0e <sys_page_alloc>:

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
f0103a0e:	55                   	push   %ebp
f0103a0f:	89 e5                	mov    %esp,%ebp
f0103a11:	57                   	push   %edi
f0103a12:	56                   	push   %esi
f0103a13:	53                   	push   %ebx
f0103a14:	83 ec 10             	sub    $0x10,%esp
f0103a17:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103a1a:	8b 7d 10             	mov    0x10(%ebp),%edi
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
f0103a1d:	6a 01                	push   $0x1
f0103a1f:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0103a22:	50                   	push   %eax
f0103a23:	ff 75 08             	pushl  0x8(%ebp)
f0103a26:	e8 8d ee ff ff       	call   f01028b8 <envid2env>
f0103a2b:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103a2e:	89 c2                	mov    %eax,%edx
f0103a30:	85 c0                	test   %eax,%eax
f0103a32:	0f 88 f9 00 00 00    	js     f0103b31 <sys_page_alloc+0x123>
        }

        // check that va is valid
        if ((int)va >= UTOP) { // kernel space
          return -E_INVAL;
f0103a38:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103a3d:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f0103a43:	0f 87 e8 00 00 00    	ja     f0103b31 <sys_page_alloc+0x123>
        }
        if (va != ROUNDUP(va, PGSIZE)) { // page alignment
f0103a49:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
f0103a4f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103a54:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103a59:	39 f0                	cmp    %esi,%eax
f0103a5b:	0f 85 d0 00 00 00    	jne    f0103b31 <sys_page_alloc+0x123>
        }

        // Check the permission bits
        if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
f0103a61:	89 f8                	mov    %edi,%eax
f0103a63:	83 e0 05             	and    $0x5,%eax
          return -E_INVAL;
f0103a66:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103a6b:	83 f8 05             	cmp    $0x5,%eax
f0103a6e:	0f 85 bd 00 00 00    	jne    f0103b31 <sys_page_alloc+0x123>
        }
        if ((perm | PTE_USER) != PTE_USER) {
f0103a74:	89 f8                	mov    %edi,%eax
f0103a76:	0d 07 0e 00 00       	or     $0xe07,%eax
          return -E_INVAL;
f0103a7b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103a80:	3d 07 0e 00 00       	cmp    $0xe07,%eax
f0103a85:	0f 85 a6 00 00 00    	jne    f0103b31 <sys_page_alloc+0x123>
        }

        if ((r = page_alloc(&env_page)) < 0) {
f0103a8b:	83 ec 0c             	sub    $0xc,%esp
f0103a8e:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0103a91:	50                   	push   %eax
f0103a92:	e8 17 dd ff ff       	call   f01017ae <page_alloc>
f0103a97:	83 c4 10             	add    $0x10,%esp
          return r; // -E_NO_MEM
f0103a9a:	89 c2                	mov    %eax,%edx
f0103a9c:	85 c0                	test   %eax,%eax
f0103a9e:	0f 88 8d 00 00 00    	js     f0103b31 <sys_page_alloc+0x123>
        }
        if ((r = page_insert(env->env_pgdir, env_page, va, perm)) < 0) {
f0103aa4:	57                   	push   %edi
f0103aa5:	56                   	push   %esi
f0103aa6:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0103aa9:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103aac:	ff 70 5c             	pushl  0x5c(%eax)
f0103aaf:	e8 b1 de ff ff       	call   f0101965 <page_insert>
f0103ab4:	89 c3                	mov    %eax,%ebx
f0103ab6:	83 c4 10             	add    $0x10,%esp
f0103ab9:	85 c0                	test   %eax,%eax
f0103abb:	79 0f                	jns    f0103acc <sys_page_alloc+0xbe>
          // deallocate the page
          page_free(env_page);
f0103abd:	83 ec 0c             	sub    $0xc,%esp
f0103ac0:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0103ac3:	e8 2b dd ff ff       	call   f01017f3 <page_free>
          return r; // -E_NO_MEM
f0103ac8:	89 da                	mov    %ebx,%edx
f0103aca:	eb 65                	jmp    f0103b31 <sys_page_alloc+0x123>

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f0103acc:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
f0103acf:	2b 15 7c 68 2f f0    	sub    0xf02f687c,%edx
f0103ad5:	c1 fa 02             	sar    $0x2,%edx
f0103ad8:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0103adb:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0103ade:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0103ae1:	89 c1                	mov    %eax,%ecx
f0103ae3:	c1 e1 08             	shl    $0x8,%ecx
f0103ae6:	01 c8                	add    %ecx,%eax
f0103ae8:	89 c1                	mov    %eax,%ecx
f0103aea:	c1 e1 10             	shl    $0x10,%ecx
f0103aed:	01 c8                	add    %ecx,%eax
f0103aef:	8d 04 42             	lea    (%edx,%eax,2),%eax
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0103af2:	89 c2                	mov    %eax,%edx
f0103af4:	c1 e2 0c             	shl    $0xc,%edx
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
f0103af7:	89 d0                	mov    %edx,%eax
f0103af9:	c1 e8 0c             	shr    $0xc,%eax
f0103afc:	3b 05 70 68 2f f0    	cmp    0xf02f6870,%eax
f0103b02:	72 12                	jb     f0103b16 <sys_page_alloc+0x108>
f0103b04:	52                   	push   %edx
f0103b05:	68 ac 62 10 f0       	push   $0xf01062ac
f0103b0a:	6a 5b                	push   $0x5b
f0103b0c:	68 76 5f 10 f0       	push   $0xf0105f76
f0103b11:	e8 d8 c5 ff ff       	call   f01000ee <_panic>
f0103b16:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
f0103b1c:	83 ec 04             	sub    $0x4,%esp
f0103b1f:	68 00 10 00 00       	push   $0x1000
f0103b24:	6a 00                	push   $0x0
f0103b26:	50                   	push   %eax
f0103b27:	e8 6d 11 00 00       	call   f0104c99 <memset>
        }

        // The page's contents are set to 0.
        memset(page2kva(env_page), 0, PGSIZE);

        return 0;
f0103b2c:	ba 00 00 00 00       	mov    $0x0,%edx
	//panic("sys_page_alloc not implemented");
}
f0103b31:	89 d0                	mov    %edx,%eax
f0103b33:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0103b36:	5b                   	pop    %ebx
f0103b37:	5e                   	pop    %esi
f0103b38:	5f                   	pop    %edi
f0103b39:	c9                   	leave  
f0103b3a:	c3                   	ret    

f0103b3b <sys_page_map_wopermcheck>:


// need this for sys_ipc_try_send
static int
sys_page_map_wopermcheck(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
f0103b3b:	55                   	push   %ebp
f0103b3c:	89 e5                	mov    %esp,%ebp
f0103b3e:	57                   	push   %edi
f0103b3f:	56                   	push   %esi
f0103b40:	53                   	push   %ebx
f0103b41:	83 ec 10             	sub    $0x10,%esp
f0103b44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103b47:	8b 75 14             	mov    0x14(%ebp),%esi
f0103b4a:	8b 7d 18             	mov    0x18(%ebp),%edi
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
f0103b4d:	6a 00                	push   $0x0
f0103b4f:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0103b52:	50                   	push   %eax
f0103b53:	ff 75 08             	pushl  0x8(%ebp)
f0103b56:	e8 5d ed ff ff       	call   f01028b8 <envid2env>
f0103b5b:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103b5e:	89 c2                	mov    %eax,%edx
f0103b60:	85 c0                	test   %eax,%eax
f0103b62:	0f 88 e0 00 00 00    	js     f0103c48 <sys_page_map_wopermcheck+0x10d>
        }
	if ((r = envid2env(dstenvid, &dst_env, 0)) < 0) {
f0103b68:	83 ec 04             	sub    $0x4,%esp
f0103b6b:	6a 00                	push   $0x0
f0103b6d:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0103b70:	50                   	push   %eax
f0103b71:	ff 75 10             	pushl  0x10(%ebp)
f0103b74:	e8 3f ed ff ff       	call   f01028b8 <envid2env>
f0103b79:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103b7c:	89 c2                	mov    %eax,%edx
f0103b7e:	85 c0                	test   %eax,%eax
f0103b80:	0f 88 c2 00 00 00    	js     f0103c48 <sys_page_map_wopermcheck+0x10d>
        }

        // check that srcva is valid
        if ((int)srcva >= UTOP) { // kernel space
          return -E_INVAL;
f0103b86:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103b8b:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103b91:	0f 87 b1 00 00 00    	ja     f0103c48 <sys_page_map_wopermcheck+0x10d>
        }
        if (srcva != ROUNDUP(srcva, PGSIZE)) { // page alignment
f0103b97:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0103b9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103ba2:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103ba7:	39 d8                	cmp    %ebx,%eax
f0103ba9:	0f 85 99 00 00 00    	jne    f0103c48 <sys_page_map_wopermcheck+0x10d>
        }

        // check that dstva is valid
        if ((int)dstva >= UTOP) { // kernel space
          return -E_INVAL;
f0103baf:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103bb4:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f0103bba:	0f 87 88 00 00 00    	ja     f0103c48 <sys_page_map_wopermcheck+0x10d>
        }
        if (dstva != ROUNDUP(dstva, PGSIZE)) { // page alignment
f0103bc0:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
f0103bc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103bcb:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103bd0:	39 f0                	cmp    %esi,%eax
f0103bd2:	75 74                	jne    f0103c48 <sys_page_map_wopermcheck+0x10d>
        }

        // -E_INVAL if srcva is not mapped in srcenvid's address space.
        src_page = page_lookup(src_env->env_pgdir, srcva, &src_pte);
f0103bd4:	83 ec 04             	sub    $0x4,%esp
f0103bd7:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0103bda:	50                   	push   %eax
f0103bdb:	53                   	push   %ebx
f0103bdc:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103bdf:	ff 70 5c             	pushl  0x5c(%eax)
f0103be2:	e8 d6 de ff ff       	call   f0101abd <page_lookup>
f0103be7:	89 c1                	mov    %eax,%ecx
        if (src_page == NULL) {
f0103be9:	83 c4 10             	add    $0x10,%esp
          return -E_INVAL;
f0103bec:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103bf1:	85 c0                	test   %eax,%eax
f0103bf3:	74 53                	je     f0103c48 <sys_page_map_wopermcheck+0x10d>
        }

        // Check the permission bits
        if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
f0103bf5:	89 f8                	mov    %edi,%eax
f0103bf7:	83 e0 05             	and    $0x5,%eax
          return -E_INVAL;
f0103bfa:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103bff:	83 f8 05             	cmp    $0x5,%eax
f0103c02:	75 44                	jne    f0103c48 <sys_page_map_wopermcheck+0x10d>
        }
        if ((perm | PTE_USER) != PTE_USER) {
f0103c04:	89 f8                	mov    %edi,%eax
f0103c06:	0d 07 0e 00 00       	or     $0xe07,%eax
          return -E_INVAL;
f0103c0b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103c10:	3d 07 0e 00 00       	cmp    $0xe07,%eax
f0103c15:	75 31                	jne    f0103c48 <sys_page_map_wopermcheck+0x10d>
        }

        // -E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
        // address space.
        if ((perm & PTE_W) && (!(*src_pte & PTE_W))) {
f0103c17:	f7 c7 02 00 00 00    	test   $0x2,%edi
f0103c1d:	74 0d                	je     f0103c2c <sys_page_map_wopermcheck+0xf1>
          return -E_INVAL;
f0103c1f:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103c24:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f0103c27:	f6 00 02             	testb  $0x2,(%eax)
f0103c2a:	74 1c                	je     f0103c48 <sys_page_map_wopermcheck+0x10d>
        }

        // Map the page of memory at 'srcva' in srcenvid's address space
        // at 'dstva' in dstenvid's address space with permission 'perm'.
        // Perm has the same restrictions as in sys_page_alloc, except
        // that it also must not grant write access to a read-only
        // page.
        if ((r = page_insert(dst_env->env_pgdir, src_page, dstva, perm)) < 0) {
f0103c2c:	57                   	push   %edi
f0103c2d:	56                   	push   %esi
f0103c2e:	51                   	push   %ecx
f0103c2f:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0103c32:	ff 70 5c             	pushl  0x5c(%eax)
f0103c35:	e8 2b dd ff ff       	call   f0101965 <page_insert>
f0103c3a:	83 c4 10             	add    $0x10,%esp
          return r; // -E_NO_MEM
f0103c3d:	89 c2                	mov    %eax,%edx
f0103c3f:	85 c0                	test   %eax,%eax
f0103c41:	78 05                	js     f0103c48 <sys_page_map_wopermcheck+0x10d>
        }

        return 0;
f0103c43:	ba 00 00 00 00       	mov    $0x0,%edx
	// panic("sys_page_map not implemented");
}
f0103c48:	89 d0                	mov    %edx,%eax
f0103c4a:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0103c4d:	5b                   	pop    %ebx
f0103c4e:	5e                   	pop    %esi
f0103c4f:	5f                   	pop    %edi
f0103c50:	c9                   	leave  
f0103c51:	c3                   	ret    

f0103c52 <sys_page_map>:



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
f0103c52:	55                   	push   %ebp
f0103c53:	89 e5                	mov    %esp,%ebp
f0103c55:	57                   	push   %edi
f0103c56:	56                   	push   %esi
f0103c57:	53                   	push   %ebx
f0103c58:	83 ec 10             	sub    $0x10,%esp
f0103c5b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0103c5e:	8b 75 14             	mov    0x14(%ebp),%esi
f0103c61:	8b 7d 18             	mov    0x18(%ebp),%edi
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
f0103c64:	6a 01                	push   $0x1
f0103c66:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0103c69:	50                   	push   %eax
f0103c6a:	ff 75 08             	pushl  0x8(%ebp)
f0103c6d:	e8 46 ec ff ff       	call   f01028b8 <envid2env>
f0103c72:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103c75:	89 c2                	mov    %eax,%edx
f0103c77:	85 c0                	test   %eax,%eax
f0103c79:	0f 88 e0 00 00 00    	js     f0103d5f <sys_page_map+0x10d>
        }
	if ((r = envid2env(dstenvid, &dst_env, 1)) < 0) {
f0103c7f:	83 ec 04             	sub    $0x4,%esp
f0103c82:	6a 01                	push   $0x1
f0103c84:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0103c87:	50                   	push   %eax
f0103c88:	ff 75 10             	pushl  0x10(%ebp)
f0103c8b:	e8 28 ec ff ff       	call   f01028b8 <envid2env>
f0103c90:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103c93:	89 c2                	mov    %eax,%edx
f0103c95:	85 c0                	test   %eax,%eax
f0103c97:	0f 88 c2 00 00 00    	js     f0103d5f <sys_page_map+0x10d>
        }

        // check that srcva is valid
        if ((int)srcva >= UTOP) { // kernel space
          return -E_INVAL;
f0103c9d:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103ca2:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103ca8:	0f 87 b1 00 00 00    	ja     f0103d5f <sys_page_map+0x10d>
        }
        if (srcva != ROUNDUP(srcva, PGSIZE)) { // page alignment
f0103cae:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0103cb4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103cb9:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103cbe:	39 d8                	cmp    %ebx,%eax
f0103cc0:	0f 85 99 00 00 00    	jne    f0103d5f <sys_page_map+0x10d>
        }

        // check that dstva is valid
        if ((int)dstva >= UTOP) { // kernel space
          return -E_INVAL;
f0103cc6:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103ccb:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f0103cd1:	0f 87 88 00 00 00    	ja     f0103d5f <sys_page_map+0x10d>
        }
        if (dstva != ROUNDUP(dstva, PGSIZE)) { // page alignment
f0103cd7:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
f0103cdd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103ce2:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103ce7:	39 f0                	cmp    %esi,%eax
f0103ce9:	75 74                	jne    f0103d5f <sys_page_map+0x10d>
        }

        // -E_INVAL if srcva is not mapped in srcenvid's address space.
        src_page = page_lookup(src_env->env_pgdir, srcva, &src_pte);
f0103ceb:	83 ec 04             	sub    $0x4,%esp
f0103cee:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0103cf1:	50                   	push   %eax
f0103cf2:	53                   	push   %ebx
f0103cf3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103cf6:	ff 70 5c             	pushl  0x5c(%eax)
f0103cf9:	e8 bf dd ff ff       	call   f0101abd <page_lookup>
f0103cfe:	89 c1                	mov    %eax,%ecx
        if (src_page == NULL) {
f0103d00:	83 c4 10             	add    $0x10,%esp
          return -E_INVAL;
f0103d03:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d08:	85 c0                	test   %eax,%eax
f0103d0a:	74 53                	je     f0103d5f <sys_page_map+0x10d>
        }

        // Check the permission bits
        if ((perm & (PTE_U | PTE_P)) != (PTE_U | PTE_P)) {
f0103d0c:	89 f8                	mov    %edi,%eax
f0103d0e:	83 e0 05             	and    $0x5,%eax
          return -E_INVAL;
f0103d11:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d16:	83 f8 05             	cmp    $0x5,%eax
f0103d19:	75 44                	jne    f0103d5f <sys_page_map+0x10d>
        }
        if ((perm | PTE_USER) != PTE_USER) {
f0103d1b:	89 f8                	mov    %edi,%eax
f0103d1d:	0d 07 0e 00 00       	or     $0xe07,%eax
          return -E_INVAL;
f0103d22:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d27:	3d 07 0e 00 00       	cmp    $0xe07,%eax
f0103d2c:	75 31                	jne    f0103d5f <sys_page_map+0x10d>
        }

        // -E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
        // address space.
        if ((perm & PTE_W) && (!(*src_pte & PTE_W))) {
f0103d2e:	f7 c7 02 00 00 00    	test   $0x2,%edi
f0103d34:	74 0d                	je     f0103d43 <sys_page_map+0xf1>
          return -E_INVAL;
f0103d36:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d3b:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f0103d3e:	f6 00 02             	testb  $0x2,(%eax)
f0103d41:	74 1c                	je     f0103d5f <sys_page_map+0x10d>
        }

        // Map the page of memory at 'srcva' in srcenvid's address space
        // at 'dstva' in dstenvid's address space with permission 'perm'.
        // Perm has the same restrictions as in sys_page_alloc, except
        // that it also must not grant write access to a read-only
        // page.
        if ((r = page_insert(dst_env->env_pgdir, src_page, dstva, perm)) < 0) {
f0103d43:	57                   	push   %edi
f0103d44:	56                   	push   %esi
f0103d45:	51                   	push   %ecx
f0103d46:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0103d49:	ff 70 5c             	pushl  0x5c(%eax)
f0103d4c:	e8 14 dc ff ff       	call   f0101965 <page_insert>
f0103d51:	83 c4 10             	add    $0x10,%esp
          return r; // -E_NO_MEM
f0103d54:	89 c2                	mov    %eax,%edx
f0103d56:	85 c0                	test   %eax,%eax
f0103d58:	78 05                	js     f0103d5f <sys_page_map+0x10d>
        }

        return 0;
f0103d5a:	ba 00 00 00 00       	mov    $0x0,%edx
	// panic("sys_page_map not implemented");
}
f0103d5f:	89 d0                	mov    %edx,%eax
f0103d61:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0103d64:	5b                   	pop    %ebx
f0103d65:	5e                   	pop    %esi
f0103d66:	5f                   	pop    %edi
f0103d67:	c9                   	leave  
f0103d68:	c3                   	ret    

f0103d69 <sys_page_unmap>:

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
f0103d69:	55                   	push   %ebp
f0103d6a:	89 e5                	mov    %esp,%ebp
f0103d6c:	53                   	push   %ebx
f0103d6d:	83 ec 08             	sub    $0x8,%esp
f0103d70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
        // seanyliu

        int r;
        struct Env *env;
	if ((r = envid2env(envid, &env, 1)) < 0) {
f0103d73:	6a 01                	push   $0x1
f0103d75:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
f0103d78:	50                   	push   %eax
f0103d79:	ff 75 08             	pushl  0x8(%ebp)
f0103d7c:	e8 37 eb ff ff       	call   f01028b8 <envid2env>
f0103d81:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103d84:	89 c2                	mov    %eax,%edx
f0103d86:	85 c0                	test   %eax,%eax
f0103d88:	78 35                	js     f0103dbf <sys_page_unmap+0x56>
        }

        // check that srcva is valid
        if ((int)va >= UTOP) { // kernel space
          return -E_INVAL;
f0103d8a:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103d8f:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103d95:	77 28                	ja     f0103dbf <sys_page_unmap+0x56>
        }
        if (va != ROUNDUP(va, PGSIZE)) { // page alignment
f0103d97:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
f0103d9d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
          return -E_INVAL;
f0103da2:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103da7:	39 d8                	cmp    %ebx,%eax
f0103da9:	75 14                	jne    f0103dbf <sys_page_unmap+0x56>
        }

        page_remove(env->env_pgdir, va);
f0103dab:	83 ec 08             	sub    $0x8,%esp
f0103dae:	53                   	push   %ebx
f0103daf:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
f0103db2:	ff 70 5c             	pushl  0x5c(%eax)
f0103db5:	e8 72 dd ff ff       	call   f0101b2c <page_remove>

        return 0;
f0103dba:	ba 00 00 00 00       	mov    $0x0,%edx

	//panic("sys_page_unmap not implemented");
}
f0103dbf:	89 d0                	mov    %edx,%eax
f0103dc1:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0103dc4:	c9                   	leave  
f0103dc5:	c3                   	ret    

f0103dc6 <sys_ipc_try_send>:

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
f0103dc6:	55                   	push   %ebp
f0103dc7:	89 e5                	mov    %esp,%ebp
f0103dc9:	57                   	push   %edi
f0103dca:	56                   	push   %esi
f0103dcb:	53                   	push   %ebx
f0103dcc:	83 ec 10             	sub    $0x10,%esp
f0103dcf:	8b 75 08             	mov    0x8(%ebp),%esi
f0103dd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0103dd5:	8b 7d 14             	mov    0x14(%ebp),%edi
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
f0103dd8:	6a 00                	push   $0x0
f0103dda:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0103ddd:	50                   	push   %eax
f0103dde:	56                   	push   %esi
f0103ddf:	e8 d4 ea ff ff       	call   f01028b8 <envid2env>
f0103de4:	83 c4 10             	add    $0x10,%esp
f0103de7:	89 c2                	mov    %eax,%edx
f0103de9:	85 c0                	test   %eax,%eax
f0103deb:	0f 88 92 00 00 00    	js     f0103e83 <sys_ipc_try_send+0xbd>

  // -E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
  // or another environment managed to send first.
  if (target_env->env_ipc_recving != 1) {
    return -E_IPC_NOT_RECV;
f0103df1:	ba f9 ff ff ff       	mov    $0xfffffff9,%edx
f0103df6:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103df9:	83 78 68 01          	cmpl   $0x1,0x68(%eax)
f0103dfd:	0f 85 80 00 00 00    	jne    f0103e83 <sys_ipc_try_send+0xbd>
  }

  if (((int)srcva < UTOP) && (target_env->env_ipc_dstva != 0)) {
f0103e03:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103e09:	77 26                	ja     f0103e31 <sys_ipc_try_send+0x6b>
f0103e0b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e0e:	83 78 6c 00          	cmpl   $0x0,0x6c(%eax)
f0103e12:	74 1d                	je     f0103e31 <sys_ipc_try_send+0x6b>
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
f0103e14:	83 ec 0c             	sub    $0xc,%esp
f0103e17:	57                   	push   %edi
f0103e18:	ff 70 6c             	pushl  0x6c(%eax)
f0103e1b:	56                   	push   %esi
f0103e1c:	53                   	push   %ebx
f0103e1d:	e8 9b fa ff ff       	call   f01038bd <sys_getenvid>
f0103e22:	50                   	push   %eax
f0103e23:	e8 13 fd ff ff       	call   f0103b3b <sys_page_map_wopermcheck>
    if (r < 0) return r;
f0103e28:	83 c4 20             	add    $0x20,%esp
f0103e2b:	89 c2                	mov    %eax,%edx
f0103e2d:	85 c0                	test   %eax,%eax
f0103e2f:	78 52                	js     f0103e83 <sys_ipc_try_send+0xbd>
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
f0103e31:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e34:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
  target_env->env_ipc_from = sys_getenvid();
f0103e3b:	e8 7d fa ff ff       	call   f01038bd <sys_getenvid>
f0103e40:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
f0103e43:	89 42 74             	mov    %eax,0x74(%edx)
  target_env->env_ipc_value = value;
f0103e46:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103e49:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e4c:	89 50 70             	mov    %edx,0x70(%eax)
  target_env->env_status = ENV_RUNNABLE;
f0103e4f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e52:	c7 40 54 01 00 00 00 	movl   $0x1,0x54(%eax)
  if (((int)srcva < UTOP) && (target_env->env_ipc_dstva != 0)) {
f0103e59:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0103e5f:	77 13                	ja     f0103e74 <sys_ipc_try_send+0xae>
f0103e61:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e64:	83 78 6c 00          	cmpl   $0x0,0x6c(%eax)
f0103e68:	74 0a                	je     f0103e74 <sys_ipc_try_send+0xae>
    target_env->env_ipc_perm = perm;
f0103e6a:	89 78 78             	mov    %edi,0x78(%eax)
    return 1;
f0103e6d:	ba 01 00 00 00       	mov    $0x1,%edx
f0103e72:	eb 0f                	jmp    f0103e83 <sys_ipc_try_send+0xbd>
  } else {
    target_env->env_ipc_perm = 0;
f0103e74:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0103e77:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
    return 0;
f0103e7e:	ba 00 00 00 00       	mov    $0x0,%edx
  }

}
f0103e83:	89 d0                	mov    %edx,%eax
f0103e85:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0103e88:	5b                   	pop    %ebx
f0103e89:	5e                   	pop    %esi
f0103e8a:	5f                   	pop    %edi
f0103e8b:	c9                   	leave  
f0103e8c:	c3                   	ret    

f0103e8d <sys_ipc_recv>:

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
f0103e8d:	55                   	push   %ebp
f0103e8e:	89 e5                	mov    %esp,%ebp
f0103e90:	83 ec 08             	sub    $0x8,%esp
f0103e93:	8b 55 08             	mov    0x8(%ebp),%edx
  // LAB 4: Your code here.
  // seanyliu

  // Verify that the dstva is correct
  if (((int)dstva < UTOP) && (dstva != ROUNDUP(dstva, PGSIZE))) {
f0103e96:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f0103e9c:	77 26                	ja     f0103ec4 <sys_ipc_recv+0x37>
f0103e9e:	8d 82 ff 0f 00 00    	lea    0xfff(%edx),%eax
f0103ea4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return -E_INVAL;
f0103ea9:	b9 fd ff ff ff       	mov    $0xfffffffd,%ecx
f0103eae:	39 d0                	cmp    %edx,%eax
f0103eb0:	75 4c                	jne    f0103efe <sys_ipc_recv+0x71>
  }

  if ((int)dstva < UTOP) {
f0103eb2:	81 fa ff ff bf ee    	cmp    $0xeebfffff,%edx
f0103eb8:	77 0a                	ja     f0103ec4 <sys_ipc_recv+0x37>
    curenv->env_ipc_dstva = dstva;
f0103eba:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103ebf:	89 50 6c             	mov    %edx,0x6c(%eax)
f0103ec2:	eb 0c                	jmp    f0103ed0 <sys_ipc_recv+0x43>
  } else {
    curenv->env_ipc_dstva = 0;
f0103ec4:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103ec9:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
  }
  curenv->env_ipc_recving = 1;
f0103ed0:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103ed5:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%eax)
  curenv->env_status = ENV_NOT_RUNNABLE;
f0103edc:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103ee1:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
  curenv->env_tf.tf_regs.reg_eax = 0;
f0103ee8:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0103eed:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  sys_yield();
f0103ef4:	e8 02 fa ff ff       	call   f01038fb <sys_yield>

  // panic("sys_ipc_recv not implemented");
  return 0;
f0103ef9:	b9 00 00 00 00       	mov    $0x0,%ecx
}
f0103efe:	89 c8                	mov    %ecx,%eax
f0103f00:	c9                   	leave  
f0103f01:	c3                   	ret    

f0103f02 <sys_env_set_priority>:


// Set envid's env_priority to priority, which must be in the correct bounds
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if priority is not a valid priority for an environment.
static int
sys_env_set_priority(envid_t envid, int priority)
{
f0103f02:	55                   	push   %ebp
f0103f03:	89 e5                	mov    %esp,%ebp
f0103f05:	53                   	push   %ebx
f0103f06:	83 ec 08             	sub    $0x8,%esp
f0103f09:	8b 5d 0c             	mov    0xc(%ebp),%ebx
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
f0103f0c:	6a 01                	push   $0x1
f0103f0e:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
f0103f11:	50                   	push   %eax
f0103f12:	ff 75 08             	pushl  0x8(%ebp)
f0103f15:	e8 9e e9 ff ff       	call   f01028b8 <envid2env>
f0103f1a:	83 c4 10             	add    $0x10,%esp
	  return r;
f0103f1d:	89 c2                	mov    %eax,%edx
f0103f1f:	85 c0                	test   %eax,%eax
f0103f21:	78 18                	js     f0103f3b <sys_env_set_priority+0x39>
        }
        if ((ENV_PR_LOWEST <= priority) && (priority <= ENV_PR_HIGHEST)) {
f0103f23:	8d 43 02             	lea    0x2(%ebx),%eax
          env->env_priority = priority;
        } else {
          return -E_INVAL;
f0103f26:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
f0103f2b:	83 f8 04             	cmp    $0x4,%eax
f0103f2e:	77 0b                	ja     f0103f3b <sys_env_set_priority+0x39>
f0103f30:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
f0103f33:	89 58 7c             	mov    %ebx,0x7c(%eax)
        }

        return 0;
f0103f36:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0103f3b:	89 d0                	mov    %edx,%eax
f0103f3d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0103f40:	c9                   	leave  
f0103f41:	c3                   	ret    

f0103f42 <sys_transmit_packet>:

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
f0103f42:	55                   	push   %ebp
f0103f43:	89 e5                	mov    %esp,%ebp
f0103f45:	83 ec 10             	sub    $0x10,%esp
  return e100_transmit_packet(packet,size);
f0103f48:	ff 75 0c             	pushl  0xc(%ebp)
f0103f4b:	ff 75 08             	pushl  0x8(%ebp)
f0103f4e:	e8 5d 12 00 00       	call   f01051b0 <e100_transmit_packet>
}
f0103f53:	c9                   	leave  
f0103f54:	c3                   	ret    

f0103f55 <sys_receive_packet>:

static int
sys_receive_packet(char *packet, int *size)
{
f0103f55:	55                   	push   %ebp
f0103f56:	89 e5                	mov    %esp,%ebp
f0103f58:	83 ec 10             	sub    $0x10,%esp
  int r;
  if ((r = e100_receive_packet(packet, size)) < 0) {
f0103f5b:	ff 75 0c             	pushl  0xc(%ebp)
f0103f5e:	ff 75 08             	pushl  0x8(%ebp)
f0103f61:	e8 64 15 00 00       	call   f01054ca <e100_receive_packet>
f0103f66:	83 c4 10             	add    $0x10,%esp
    return r;
f0103f69:	89 c2                	mov    %eax,%edx
f0103f6b:	85 c0                	test   %eax,%eax
f0103f6d:	78 05                	js     f0103f74 <sys_receive_packet+0x1f>
  }
  return 0;
f0103f6f:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0103f74:	89 d0                	mov    %edx,%eax
f0103f76:	c9                   	leave  
f0103f77:	c3                   	ret    

f0103f78 <sys_receive_packet_zerocopy>:

// Challenge: Lab 6
static int
sys_receive_packet_zerocopy(int *size)
{
f0103f78:	55                   	push   %ebp
f0103f79:	89 e5                	mov    %esp,%ebp
f0103f7b:	83 ec 14             	sub    $0x14,%esp
  int r;
  if ((r = e100_receive_packet_zerocopy(size)) < 0) {
f0103f7e:	ff 75 08             	pushl  0x8(%ebp)
f0103f81:	e8 d3 14 00 00       	call   f0105459 <e100_receive_packet_zerocopy>
f0103f86:	83 c4 10             	add    $0x10,%esp
    return r;
f0103f89:	89 c2                	mov    %eax,%edx
f0103f8b:	85 c0                	test   %eax,%eax
f0103f8d:	78 05                	js     f0103f94 <sys_receive_packet_zerocopy+0x1c>
  }
  return 0;
f0103f8f:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0103f94:	89 d0                	mov    %edx,%eax
f0103f96:	c9                   	leave  
f0103f97:	c3                   	ret    

f0103f98 <sys_time_msec>:

// Return the current time.
static int
sys_time_msec(void) 
{
f0103f98:	55                   	push   %ebp
f0103f99:	89 e5                	mov    %esp,%ebp
f0103f9b:	83 ec 08             	sub    $0x8,%esp
	// LAB 6: Your code here.
        return time_msec();
f0103f9e:	e8 a4 1b 00 00       	call   f0105b47 <time_msec>
	//panic("sys_time_msec not implemented");
}
f0103fa3:	c9                   	leave  
f0103fa4:	c3                   	ret    

f0103fa5 <sys_map_receive_buffers>:

// Challenge: LAB 6
static int
sys_map_receive_buffers(char *first_buffer)
{
f0103fa5:	55                   	push   %ebp
f0103fa6:	89 e5                	mov    %esp,%ebp
f0103fa8:	83 ec 14             	sub    $0x14,%esp
        int r;
        if ((r = e100_map_receive_buffers(first_buffer)) < 0) {
f0103fab:	ff 75 08             	pushl  0x8(%ebp)
f0103fae:	e8 a1 15 00 00       	call   f0105554 <e100_map_receive_buffers>
f0103fb3:	83 c4 10             	add    $0x10,%esp
          return r;
f0103fb6:	89 c2                	mov    %eax,%edx
f0103fb8:	85 c0                	test   %eax,%eax
f0103fba:	78 05                	js     f0103fc1 <sys_map_receive_buffers+0x1c>
        }
        return 0;
f0103fbc:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0103fc1:	89 d0                	mov    %edx,%eax
f0103fc3:	c9                   	leave  
f0103fc4:	c3                   	ret    

f0103fc5 <syscall>:


// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0103fc5:	55                   	push   %ebp
f0103fc6:	89 e5                	mov    %esp,%ebp
f0103fc8:	57                   	push   %edi
f0103fc9:	56                   	push   %esi
f0103fca:	53                   	push   %ebx
f0103fcb:	83 ec 0c             	sub    $0xc,%esp
f0103fce:	8b 55 08             	mov    0x8(%ebp),%edx
f0103fd1:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103fd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0103fd7:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0103fda:	8b 7d 18             	mov    0x18(%ebp),%edi
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
f0103fdd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0103fe2:	83 fa 13             	cmp    $0x13,%edx
f0103fe5:	0f 87 02 01 00 00    	ja     f01040ed <syscall+0x128>
f0103feb:	ff 24 95 a4 6e 10 f0 	jmp    *0xf0106ea4(,%edx,4)
f0103ff2:	83 ec 08             	sub    $0x8,%esp
f0103ff5:	53                   	push   %ebx
f0103ff6:	56                   	push   %esi
f0103ff7:	e8 80 f8 ff ff       	call   f010387c <sys_cputs>
f0103ffc:	83 c4 10             	add    $0x10,%esp
f0103fff:	e9 e4 00 00 00       	jmp    f01040e8 <syscall+0x123>
f0104004:	e8 a3 f8 ff ff       	call   f01038ac <sys_cgetc>
f0104009:	e9 df 00 00 00       	jmp    f01040ed <syscall+0x128>
f010400e:	e8 aa f8 ff ff       	call   f01038bd <sys_getenvid>
f0104013:	e9 d5 00 00 00       	jmp    f01040ed <syscall+0x128>
f0104018:	83 ec 0c             	sub    $0xc,%esp
f010401b:	56                   	push   %esi
f010401c:	e8 a9 f8 ff ff       	call   f01038ca <sys_env_destroy>
f0104021:	e9 c7 00 00 00       	jmp    f01040ed <syscall+0x128>
f0104026:	e8 d0 f8 ff ff       	call   f01038fb <sys_yield>
f010402b:	e9 b8 00 00 00       	jmp    f01040e8 <syscall+0x123>
f0104030:	e8 d1 f8 ff ff       	call   f0103906 <sys_exofork>
f0104035:	e9 b3 00 00 00       	jmp    f01040ed <syscall+0x128>
f010403a:	83 ec 08             	sub    $0x8,%esp
f010403d:	53                   	push   %ebx
f010403e:	56                   	push   %esi
f010403f:	e8 13 f9 ff ff       	call   f0103957 <sys_env_set_status>
f0104044:	e9 a4 00 00 00       	jmp    f01040ed <syscall+0x128>
f0104049:	83 ec 04             	sub    $0x4,%esp
f010404c:	51                   	push   %ecx
f010404d:	53                   	push   %ebx
f010404e:	56                   	push   %esi
f010404f:	e8 ba f9 ff ff       	call   f0103a0e <sys_page_alloc>
f0104054:	e9 94 00 00 00       	jmp    f01040ed <syscall+0x128>
f0104059:	83 ec 0c             	sub    $0xc,%esp
f010405c:	ff 75 1c             	pushl  0x1c(%ebp)
f010405f:	57                   	push   %edi
f0104060:	51                   	push   %ecx
f0104061:	53                   	push   %ebx
f0104062:	56                   	push   %esi
f0104063:	e8 ea fb ff ff       	call   f0103c52 <sys_page_map>
f0104068:	e9 80 00 00 00       	jmp    f01040ed <syscall+0x128>
f010406d:	83 ec 08             	sub    $0x8,%esp
f0104070:	53                   	push   %ebx
f0104071:	56                   	push   %esi
f0104072:	e8 f2 fc ff ff       	call   f0103d69 <sys_page_unmap>
f0104077:	eb 74                	jmp    f01040ed <syscall+0x128>
f0104079:	83 ec 08             	sub    $0x8,%esp
f010407c:	53                   	push   %ebx
f010407d:	56                   	push   %esi
f010407e:	e8 5c f9 ff ff       	call   f01039df <sys_env_set_pgfault_upcall>
f0104083:	eb 68                	jmp    f01040ed <syscall+0x128>
f0104085:	57                   	push   %edi
f0104086:	51                   	push   %ecx
f0104087:	53                   	push   %ebx
f0104088:	56                   	push   %esi
f0104089:	e8 38 fd ff ff       	call   f0103dc6 <sys_ipc_try_send>
f010408e:	eb 5d                	jmp    f01040ed <syscall+0x128>
f0104090:	83 ec 0c             	sub    $0xc,%esp
f0104093:	56                   	push   %esi
f0104094:	e8 f4 fd ff ff       	call   f0103e8d <sys_ipc_recv>
f0104099:	eb 52                	jmp    f01040ed <syscall+0x128>
f010409b:	83 ec 08             	sub    $0x8,%esp
f010409e:	53                   	push   %ebx
f010409f:	56                   	push   %esi
f01040a0:	e8 f2 f8 ff ff       	call   f0103997 <sys_env_set_trapframe>
f01040a5:	eb 46                	jmp    f01040ed <syscall+0x128>
f01040a7:	83 ec 08             	sub    $0x8,%esp
f01040aa:	53                   	push   %ebx
f01040ab:	56                   	push   %esi
f01040ac:	e8 51 fe ff ff       	call   f0103f02 <sys_env_set_priority>
f01040b1:	eb 3a                	jmp    f01040ed <syscall+0x128>
f01040b3:	e8 e0 fe ff ff       	call   f0103f98 <sys_time_msec>
f01040b8:	eb 33                	jmp    f01040ed <syscall+0x128>
f01040ba:	83 ec 08             	sub    $0x8,%esp
f01040bd:	53                   	push   %ebx
f01040be:	56                   	push   %esi
f01040bf:	e8 7e fe ff ff       	call   f0103f42 <sys_transmit_packet>
f01040c4:	eb 27                	jmp    f01040ed <syscall+0x128>
f01040c6:	83 ec 08             	sub    $0x8,%esp
f01040c9:	53                   	push   %ebx
f01040ca:	56                   	push   %esi
f01040cb:	e8 85 fe ff ff       	call   f0103f55 <sys_receive_packet>
f01040d0:	eb 1b                	jmp    f01040ed <syscall+0x128>
f01040d2:	83 ec 0c             	sub    $0xc,%esp
f01040d5:	56                   	push   %esi
f01040d6:	e8 9d fe ff ff       	call   f0103f78 <sys_receive_packet_zerocopy>
f01040db:	eb 10                	jmp    f01040ed <syscall+0x128>
f01040dd:	83 ec 0c             	sub    $0xc,%esp
f01040e0:	56                   	push   %esi
f01040e1:	e8 bf fe ff ff       	call   f0103fa5 <sys_map_receive_buffers>
f01040e6:	eb 05                	jmp    f01040ed <syscall+0x128>
        }

        return 0;
f01040e8:	b8 00 00 00 00       	mov    $0x0,%eax

	//panic("syscall not implemented");
}
f01040ed:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f01040f0:	5b                   	pop    %ebx
f01040f1:	5e                   	pop    %esi
f01040f2:	5f                   	pop    %edi
f01040f3:	c9                   	leave  
f01040f4:	c3                   	ret    
f01040f5:	00 00                	add    %al,(%eax)
	...

f01040f8 <stab_binsearch>:
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f01040f8:	55                   	push   %ebp
f01040f9:	89 e5                	mov    %esp,%ebp
f01040fb:	57                   	push   %edi
f01040fc:	56                   	push   %esi
f01040fd:	53                   	push   %ebx
f01040fe:	83 ec 0c             	sub    $0xc,%esp
f0104101:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104104:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104107:	8b 08                	mov    (%eax),%ecx
f0104109:	8b 55 10             	mov    0x10(%ebp),%edx
f010410c:	8b 12                	mov    (%edx),%edx
f010410e:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
f0104111:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
	
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
f0104118:	39 d1                	cmp    %edx,%ecx
f010411a:	0f 8f 88 00 00 00    	jg     f01041a8 <stab_binsearch+0xb0>
f0104120:	8b 5d e8             	mov    0xffffffe8(%ebp),%ebx
f0104123:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
f0104126:	89 c2                	mov    %eax,%edx
f0104128:	c1 ea 1f             	shr    $0x1f,%edx
f010412b:	01 d0                	add    %edx,%eax
f010412d:	89 c3                	mov    %eax,%ebx
f010412f:	d1 fb                	sar    %ebx
f0104131:	89 da                	mov    %ebx,%edx
f0104133:	39 cb                	cmp    %ecx,%ebx
f0104135:	7c 23                	jl     f010415a <stab_binsearch+0x62>
f0104137:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f010413a:	0f b6 44 87 04       	movzbl 0x4(%edi,%eax,4),%eax
f010413f:	3b 45 14             	cmp    0x14(%ebp),%eax
f0104142:	74 12                	je     f0104156 <stab_binsearch+0x5e>
f0104144:	4a                   	dec    %edx
f0104145:	39 ca                	cmp    %ecx,%edx
f0104147:	7c 11                	jl     f010415a <stab_binsearch+0x62>
f0104149:	8d 04 52             	lea    (%edx,%edx,2),%eax
f010414c:	0f b6 44 87 04       	movzbl 0x4(%edi,%eax,4),%eax
f0104151:	3b 45 14             	cmp    0x14(%ebp),%eax
f0104154:	75 ee                	jne    f0104144 <stab_binsearch+0x4c>
f0104156:	39 ca                	cmp    %ecx,%edx
f0104158:	7d 05                	jge    f010415f <stab_binsearch+0x67>
f010415a:	8d 4b 01             	lea    0x1(%ebx),%ecx
f010415d:	eb 40                	jmp    f010419f <stab_binsearch+0xa7>
f010415f:	c7 45 f0 01 00 00 00 	movl   $0x1,0xfffffff0(%ebp)
f0104166:	8d 34 52             	lea    (%edx,%edx,2),%esi
f0104169:	8b 45 18             	mov    0x18(%ebp),%eax
f010416c:	39 44 b7 08          	cmp    %eax,0x8(%edi,%esi,4)
f0104170:	73 0a                	jae    f010417c <stab_binsearch+0x84>
f0104172:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104175:	89 16                	mov    %edx,(%esi)
f0104177:	8d 4b 01             	lea    0x1(%ebx),%ecx
f010417a:	eb 23                	jmp    f010419f <stab_binsearch+0xa7>
f010417c:	8d 04 52             	lea    (%edx,%edx,2),%eax
f010417f:	8b 5d 18             	mov    0x18(%ebp),%ebx
f0104182:	39 5c 87 08          	cmp    %ebx,0x8(%edi,%eax,4)
f0104186:	76 0d                	jbe    f0104195 <stab_binsearch+0x9d>
f0104188:	8d 42 ff             	lea    0xffffffff(%edx),%eax
f010418b:	8b 75 10             	mov    0x10(%ebp),%esi
f010418e:	89 06                	mov    %eax,(%esi)
f0104190:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
f0104193:	eb 0a                	jmp    f010419f <stab_binsearch+0xa7>
f0104195:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104198:	89 10                	mov    %edx,(%eax)
f010419a:	89 d1                	mov    %edx,%ecx
f010419c:	ff 45 18             	incl   0x18(%ebp)
f010419f:	3b 4d e8             	cmp    0xffffffe8(%ebp),%ecx
f01041a2:	0f 8e 78 ff ff ff    	jle    f0104120 <stab_binsearch+0x28>
		}
	}

	if (!any_matches)
f01041a8:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f01041ac:	75 0d                	jne    f01041bb <stab_binsearch+0xc3>
		*region_right = *region_left - 1;
f01041ae:	8b 55 0c             	mov    0xc(%ebp),%edx
f01041b1:	8b 02                	mov    (%edx),%eax
f01041b3:	48                   	dec    %eax
f01041b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
f01041b7:	89 03                	mov    %eax,(%ebx)
f01041b9:	eb 33                	jmp    f01041ee <stab_binsearch+0xf6>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01041bb:	8b 75 10             	mov    0x10(%ebp),%esi
f01041be:	8b 0e                	mov    (%esi),%ecx
f01041c0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01041c3:	39 08                	cmp    %ecx,(%eax)
f01041c5:	7d 22                	jge    f01041e9 <stab_binsearch+0xf1>
f01041c7:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f01041ca:	0f b6 44 87 04       	movzbl 0x4(%edi,%eax,4),%eax
f01041cf:	3b 45 14             	cmp    0x14(%ebp),%eax
f01041d2:	74 15                	je     f01041e9 <stab_binsearch+0xf1>
f01041d4:	49                   	dec    %ecx
f01041d5:	8b 55 0c             	mov    0xc(%ebp),%edx
f01041d8:	39 0a                	cmp    %ecx,(%edx)
f01041da:	7d 0d                	jge    f01041e9 <stab_binsearch+0xf1>
f01041dc:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f01041df:	0f b6 44 87 04       	movzbl 0x4(%edi,%eax,4),%eax
f01041e4:	3b 45 14             	cmp    0x14(%ebp),%eax
f01041e7:	75 eb                	jne    f01041d4 <stab_binsearch+0xdc>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f01041e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01041ec:	89 0b                	mov    %ecx,(%ebx)
	}
}
f01041ee:	83 c4 0c             	add    $0xc,%esp
f01041f1:	5b                   	pop    %ebx
f01041f2:	5e                   	pop    %esi
f01041f3:	5f                   	pop    %edi
f01041f4:	c9                   	leave  
f01041f5:	c3                   	ret    

f01041f6 <debuginfo_eip>:


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
f01041f6:	55                   	push   %ebp
f01041f7:	89 e5                	mov    %esp,%ebp
f01041f9:	57                   	push   %edi
f01041fa:	56                   	push   %esi
f01041fb:	53                   	push   %ebx
f01041fc:	83 ec 2c             	sub    $0x2c,%esp
f01041ff:	8b 7d 08             	mov    0x8(%ebp),%edi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104202:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104205:	c7 00 f4 6e 10 f0    	movl   $0xf0106ef4,(%eax)
	info->eip_line = 0;
f010420b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	info->eip_fn_name = "<unknown>";
f0104212:	c7 40 08 f4 6e 10 f0 	movl   $0xf0106ef4,0x8(%eax)
	info->eip_fn_namelen = 9;
f0104219:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
	info->eip_fn_addr = addr;
f0104220:	89 78 10             	mov    %edi,0x10(%eax)
	info->eip_fn_narg = 0;
f0104223:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f010422a:	81 ff ff ff 7f ef    	cmp    $0xef7fffff,%edi
f0104230:	76 1d                	jbe    f010424f <debuginfo_eip+0x59>
		stabs = __STAB_BEGIN__;
f0104232:	bb e8 75 10 f0       	mov    $0xf01075e8,%ebx
		stab_end = __STAB_END__;
f0104237:	c7 45 d8 14 4f 11 f0 	movl   $0xf0114f14,0xffffffd8(%ebp)
		stabstr = __STABSTR_BEGIN__;
f010423e:	c7 45 d4 15 4f 11 f0 	movl   $0xf0114f15,0xffffffd4(%ebp)
		stabstr_end = __STABSTR_END__;
f0104245:	be f4 c6 11 f0       	mov    $0xf011c6f4,%esi
f010424a:	e9 9e 00 00 00       	jmp    f01042ed <debuginfo_eip+0xf7>
	} else {
		// The user-application linker script, user/user.ld,
		// puts information about the application's stabs (equivalent
		// to __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__, and
		// __STABSTR_END__) in a structure located at virtual address
		// USTABDATA.
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;
f010424f:	be 00 00 20 00       	mov    $0x200000,%esi

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.

                // seanyliu
                if (user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_U) < 0) {
f0104254:	6a 04                	push   $0x4
f0104256:	6a 10                	push   $0x10
f0104258:	68 00 00 20 00       	push   $0x200000
f010425d:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f0104263:	e8 26 d9 ff ff       	call   f0101b8e <user_mem_check>
f0104268:	83 c4 10             	add    $0x10,%esp
                  return -1;
f010426b:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104270:	85 c0                	test   %eax,%eax
f0104272:	0f 88 27 02 00 00    	js     f010449f <debuginfo_eip+0x2a9>
                }
	
		stabs = usd->stabs;
f0104278:	8b 1e                	mov    (%esi),%ebx
		stab_end = usd->stab_end;
f010427a:	8b 56 04             	mov    0x4(%esi),%edx
f010427d:	89 55 d8             	mov    %edx,0xffffffd8(%ebp)
		stabstr = usd->stabstr;
f0104280:	8b 4e 08             	mov    0x8(%esi),%ecx
f0104283:	89 4d d4             	mov    %ecx,0xffffffd4(%ebp)
		stabstr_end = usd->stabstr_end;
f0104286:	8b 76 0c             	mov    0xc(%esi),%esi

                if (user_mem_check(curenv, stabs, (stab_end - stabs), PTE_U) < 0) {
f0104289:	6a 04                	push   $0x4
f010428b:	29 da                	sub    %ebx,%edx
f010428d:	c1 fa 02             	sar    $0x2,%edx
f0104290:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0104293:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0104296:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0104299:	89 c1                	mov    %eax,%ecx
f010429b:	c1 e1 08             	shl    $0x8,%ecx
f010429e:	01 c8                	add    %ecx,%eax
f01042a0:	89 c1                	mov    %eax,%ecx
f01042a2:	c1 e1 10             	shl    $0x10,%ecx
f01042a5:	01 c8                	add    %ecx,%eax
f01042a7:	8d 04 42             	lea    (%edx,%eax,2),%eax
f01042aa:	50                   	push   %eax
f01042ab:	53                   	push   %ebx
f01042ac:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f01042b2:	e8 d7 d8 ff ff       	call   f0101b8e <user_mem_check>
f01042b7:	83 c4 10             	add    $0x10,%esp
                  return -1;
f01042ba:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01042bf:	85 c0                	test   %eax,%eax
f01042c1:	0f 88 d8 01 00 00    	js     f010449f <debuginfo_eip+0x2a9>
                }
                if (user_mem_check(curenv, stabstr, (stabstr_end - stabstr), PTE_U) < 0) {
f01042c7:	6a 04                	push   $0x4
f01042c9:	89 f0                	mov    %esi,%eax
f01042cb:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
f01042ce:	50                   	push   %eax
f01042cf:	ff 75 d4             	pushl  0xffffffd4(%ebp)
f01042d2:	ff 35 c4 5b 2f f0    	pushl  0xf02f5bc4
f01042d8:	e8 b1 d8 ff ff       	call   f0101b8e <user_mem_check>
f01042dd:	83 c4 10             	add    $0x10,%esp
                  return -1;
f01042e0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01042e5:	85 c0                	test   %eax,%eax
f01042e7:	0f 88 b2 01 00 00    	js     f010449f <debuginfo_eip+0x2a9>
                }

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01042ed:	3b 75 d4             	cmp    0xffffffd4(%ebp),%esi
f01042f0:	76 06                	jbe    f01042f8 <debuginfo_eip+0x102>
f01042f2:	80 7e ff 00          	cmpb   $0x0,0xffffffff(%esi)
f01042f6:	74 0a                	je     f0104302 <debuginfo_eip+0x10c>
		return -1;
f01042f8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01042fd:	e9 9d 01 00 00       	jmp    f010449f <debuginfo_eip+0x2a9>

	// Now we find the right stabs that define the function containing
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.
	
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104302:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	rfile = (stab_end - stabs) - 1;
f0104309:	8b 55 d8             	mov    0xffffffd8(%ebp),%edx
f010430c:	29 da                	sub    %ebx,%edx
f010430e:	c1 fa 02             	sar    $0x2,%edx
f0104311:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0104314:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0104317:	8d 04 82             	lea    (%edx,%eax,4),%eax
f010431a:	89 c1                	mov    %eax,%ecx
f010431c:	c1 e1 08             	shl    $0x8,%ecx
f010431f:	01 c8                	add    %ecx,%eax
f0104321:	89 c1                	mov    %eax,%ecx
f0104323:	c1 e1 10             	shl    $0x10,%ecx
f0104326:	01 c8                	add    %ecx,%eax
f0104328:	8d 44 42 ff          	lea    0xffffffff(%edx,%eax,2),%eax
f010432c:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f010432f:	57                   	push   %edi
f0104330:	6a 64                	push   $0x64
f0104332:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
f0104335:	50                   	push   %eax
f0104336:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
f0104339:	50                   	push   %eax
f010433a:	53                   	push   %ebx
f010433b:	e8 b8 fd ff ff       	call   f01040f8 <stab_binsearch>
	if (lfile == 0)
f0104340:	83 c4 14             	add    $0x14,%esp
		return -1;
f0104343:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0104348:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
f010434c:	0f 84 4d 01 00 00    	je     f010449f <debuginfo_eip+0x2a9>

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104352:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0104355:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
	rfun = rfile;
f0104358:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f010435b:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f010435e:	57                   	push   %edi
f010435f:	6a 24                	push   $0x24
f0104361:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0104364:	50                   	push   %eax
f0104365:	8d 45 e4             	lea    0xffffffe4(%ebp),%eax
f0104368:	50                   	push   %eax
f0104369:	53                   	push   %ebx
f010436a:	e8 89 fd ff ff       	call   f01040f8 <stab_binsearch>

	if (lfun <= rfun) {
f010436f:	83 c4 14             	add    $0x14,%esp
f0104372:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f0104375:	3b 45 e8             	cmp    0xffffffe8(%ebp),%eax
f0104378:	7f 3d                	jg     f01043b7 <debuginfo_eip+0x1c1>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f010437a:	8d 04 40             	lea    (%eax,%eax,2),%eax
f010437d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f0104384:	89 f0                	mov    %esi,%eax
f0104386:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
f0104389:	39 04 1a             	cmp    %eax,(%edx,%ebx,1)
f010438c:	73 0c                	jae    f010439a <debuginfo_eip+0x1a4>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f010438e:	8b 45 d4             	mov    0xffffffd4(%ebp),%eax
f0104391:	03 04 1a             	add    (%edx,%ebx,1),%eax
f0104394:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104397:	89 42 08             	mov    %eax,0x8(%edx)
		info->eip_fn_addr = stabs[lfun].n_value;
f010439a:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
f010439d:	8d 04 52             	lea    (%edx,%edx,2),%eax
f01043a0:	8b 44 83 08          	mov    0x8(%ebx,%eax,4),%eax
f01043a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01043a7:	89 41 10             	mov    %eax,0x10(%ecx)
		addr -= info->eip_fn_addr;
f01043aa:	29 c7                	sub    %eax,%edi
		// Search within the function definition for the line number.
		lline = lfun;
f01043ac:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
		rline = rfun;
f01043af:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f01043b2:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
f01043b5:	eb 12                	jmp    f01043c9 <debuginfo_eip+0x1d3>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f01043b7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01043ba:	89 78 10             	mov    %edi,0x10(%eax)
		lline = lfile;
f01043bd:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f01043c0:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
		rline = rfile;
f01043c3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f01043c6:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f01043c9:	83 ec 08             	sub    $0x8,%esp
f01043cc:	6a 3a                	push   $0x3a
f01043ce:	8b 55 0c             	mov    0xc(%ebp),%edx
f01043d1:	ff 72 08             	pushl  0x8(%edx)
f01043d4:	e8 a6 08 00 00       	call   f0104c7f <strfind>
f01043d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01043dc:	2b 41 08             	sub    0x8(%ecx),%eax
f01043df:	89 41 0c             	mov    %eax,0xc(%ecx)

	
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
f01043e2:	57                   	push   %edi
f01043e3:	6a 44                	push   $0x44
f01043e5:	8d 45 e0             	lea    0xffffffe0(%ebp),%eax
f01043e8:	50                   	push   %eax
f01043e9:	8d 45 dc             	lea    0xffffffdc(%ebp),%eax
f01043ec:	50                   	push   %eax
f01043ed:	53                   	push   %ebx
f01043ee:	e8 05 fd ff ff       	call   f01040f8 <stab_binsearch>
        if (lline <= rline) {
f01043f3:	83 c4 24             	add    $0x24,%esp
f01043f6:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
          info->eip_line = lline;
        } else {
          return -1;
f01043f9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f01043fe:	3b 45 e0             	cmp    0xffffffe0(%ebp),%eax
f0104401:	0f 8f 98 00 00 00    	jg     f010449f <debuginfo_eip+0x2a9>
f0104407:	8b 55 0c             	mov    0xc(%ebp),%edx
f010440a:	89 42 04             	mov    %eax,0x4(%edx)
f010440d:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
        }
	
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0104410:	eb 03                	jmp    f0104415 <debuginfo_eip+0x21f>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0104412:	ff 4d dc             	decl   0xffffffdc(%ebp)
f0104415:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0104418:	39 d0                	cmp    %edx,%eax
f010441a:	7c 1b                	jl     f0104437 <debuginfo_eip+0x241>
f010441c:	8d 04 40             	lea    (%eax,%eax,2),%eax
f010441f:	c1 e0 02             	shl    $0x2,%eax
f0104422:	80 7c 18 04 84       	cmpb   $0x84,0x4(%eax,%ebx,1)
f0104427:	74 0e                	je     f0104437 <debuginfo_eip+0x241>
f0104429:	80 7c 18 04 64       	cmpb   $0x64,0x4(%eax,%ebx,1)
f010442e:	75 e2                	jne    f0104412 <debuginfo_eip+0x21c>
f0104430:	83 7c 18 08 00       	cmpl   $0x0,0x8(%eax,%ebx,1)
f0104435:	74 db                	je     f0104412 <debuginfo_eip+0x21c>
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0104437:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f010443a:	3b 45 ec             	cmp    0xffffffec(%ebp),%eax
f010443d:	7c 1f                	jl     f010445e <debuginfo_eip+0x268>
f010443f:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
f0104449:	89 f0                	mov    %esi,%eax
f010444b:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
f010444e:	39 04 1a             	cmp    %eax,(%edx,%ebx,1)
f0104451:	73 0b                	jae    f010445e <debuginfo_eip+0x268>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0104453:	8b 45 d4             	mov    0xffffffd4(%ebp),%eax
f0104456:	03 04 1a             	add    (%edx,%ebx,1),%eax
f0104459:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010445c:	89 01                	mov    %eax,(%ecx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f010445e:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f0104461:	3b 45 e8             	cmp    0xffffffe8(%ebp),%eax
f0104464:	7d 34                	jge    f010449a <debuginfo_eip+0x2a4>
		for (lline = lfun + 1;
f0104466:	40                   	inc    %eax
f0104467:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
f010446a:	89 c2                	mov    %eax,%edx
f010446c:	3b 45 e8             	cmp    0xffffffe8(%ebp),%eax
f010446f:	7d 29                	jge    f010449a <debuginfo_eip+0x2a4>
f0104471:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104474:	80 7c 83 04 a0       	cmpb   $0xa0,0x4(%ebx,%eax,4)
f0104479:	75 1f                	jne    f010449a <debuginfo_eip+0x2a4>
f010447b:	8b 4d e8             	mov    0xffffffe8(%ebp),%ecx
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f010447e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104481:	ff 40 14             	incl   0x14(%eax)
f0104484:	8d 42 01             	lea    0x1(%edx),%eax
f0104487:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
f010448a:	89 c2                	mov    %eax,%edx
f010448c:	39 c8                	cmp    %ecx,%eax
f010448e:	7d 0a                	jge    f010449a <debuginfo_eip+0x2a4>
f0104490:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0104493:	80 7c 83 04 a0       	cmpb   $0xa0,0x4(%ebx,%eax,4)
f0104498:	74 e4                	je     f010447e <debuginfo_eip+0x288>
	
	return 0;
f010449a:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010449f:	89 d0                	mov    %edx,%eax
f01044a1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f01044a4:	5b                   	pop    %ebx
f01044a5:	5e                   	pop    %esi
f01044a6:	5f                   	pop    %edi
f01044a7:	c9                   	leave  
f01044a8:	c3                   	ret    
f01044a9:	00 00                	add    %al,(%eax)
	...

f01044ac <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f01044ac:	55                   	push   %ebp
f01044ad:	89 e5                	mov    %esp,%ebp
f01044af:	57                   	push   %edi
f01044b0:	56                   	push   %esi
f01044b1:	53                   	push   %ebx
f01044b2:	83 ec 0c             	sub    $0xc,%esp
f01044b5:	8b 75 10             	mov    0x10(%ebp),%esi
f01044b8:	8b 7d 14             	mov    0x14(%ebp),%edi
f01044bb:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f01044be:	8b 45 18             	mov    0x18(%ebp),%eax
f01044c1:	ba 00 00 00 00       	mov    $0x0,%edx
f01044c6:	39 fa                	cmp    %edi,%edx
f01044c8:	77 39                	ja     f0104503 <printnum+0x57>
f01044ca:	72 04                	jb     f01044d0 <printnum+0x24>
f01044cc:	39 f0                	cmp    %esi,%eax
f01044ce:	77 33                	ja     f0104503 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f01044d0:	83 ec 04             	sub    $0x4,%esp
f01044d3:	ff 75 20             	pushl  0x20(%ebp)
f01044d6:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
f01044d9:	50                   	push   %eax
f01044da:	ff 75 18             	pushl  0x18(%ebp)
f01044dd:	8b 45 18             	mov    0x18(%ebp),%eax
f01044e0:	ba 00 00 00 00       	mov    $0x0,%edx
f01044e5:	52                   	push   %edx
f01044e6:	50                   	push   %eax
f01044e7:	57                   	push   %edi
f01044e8:	56                   	push   %esi
f01044e9:	e8 6a 16 00 00       	call   f0105b58 <__udivdi3>
f01044ee:	83 c4 10             	add    $0x10,%esp
f01044f1:	52                   	push   %edx
f01044f2:	50                   	push   %eax
f01044f3:	ff 75 0c             	pushl  0xc(%ebp)
f01044f6:	ff 75 08             	pushl  0x8(%ebp)
f01044f9:	e8 ae ff ff ff       	call   f01044ac <printnum>
f01044fe:	83 c4 20             	add    $0x20,%esp
f0104501:	eb 19                	jmp    f010451c <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104503:	4b                   	dec    %ebx
f0104504:	85 db                	test   %ebx,%ebx
f0104506:	7e 14                	jle    f010451c <printnum+0x70>
f0104508:	83 ec 08             	sub    $0x8,%esp
f010450b:	ff 75 0c             	pushl  0xc(%ebp)
f010450e:	ff 75 20             	pushl  0x20(%ebp)
f0104511:	ff 55 08             	call   *0x8(%ebp)
f0104514:	83 c4 10             	add    $0x10,%esp
f0104517:	4b                   	dec    %ebx
f0104518:	85 db                	test   %ebx,%ebx
f010451a:	7f ec                	jg     f0104508 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f010451c:	83 ec 08             	sub    $0x8,%esp
f010451f:	ff 75 0c             	pushl  0xc(%ebp)
f0104522:	8b 45 18             	mov    0x18(%ebp),%eax
f0104525:	ba 00 00 00 00       	mov    $0x0,%edx
f010452a:	83 ec 04             	sub    $0x4,%esp
f010452d:	52                   	push   %edx
f010452e:	50                   	push   %eax
f010452f:	57                   	push   %edi
f0104530:	56                   	push   %esi
f0104531:	e8 2e 17 00 00       	call   f0105c64 <__umoddi3>
f0104536:	83 c4 14             	add    $0x14,%esp
f0104539:	0f be 80 f8 6f 10 f0 	movsbl 0xf0106ff8(%eax),%eax
f0104540:	50                   	push   %eax
f0104541:	ff 55 08             	call   *0x8(%ebp)
}
f0104544:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0104547:	5b                   	pop    %ebx
f0104548:	5e                   	pop    %esi
f0104549:	5f                   	pop    %edi
f010454a:	c9                   	leave  
f010454b:	c3                   	ret    

f010454c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f010454c:	55                   	push   %ebp
f010454d:	89 e5                	mov    %esp,%ebp
f010454f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104552:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
f0104555:	83 f8 01             	cmp    $0x1,%eax
f0104558:	7e 0f                	jle    f0104569 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
f010455a:	8b 01                	mov    (%ecx),%eax
f010455c:	83 c0 08             	add    $0x8,%eax
f010455f:	89 01                	mov    %eax,(%ecx)
f0104561:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
f0104564:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
f0104567:	eb 24                	jmp    f010458d <getuint+0x41>
	else if (lflag)
f0104569:	85 c0                	test   %eax,%eax
f010456b:	74 11                	je     f010457e <getuint+0x32>
		return va_arg(*ap, unsigned long);
f010456d:	8b 01                	mov    (%ecx),%eax
f010456f:	83 c0 04             	add    $0x4,%eax
f0104572:	89 01                	mov    %eax,(%ecx)
f0104574:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
f0104577:	ba 00 00 00 00       	mov    $0x0,%edx
f010457c:	eb 0f                	jmp    f010458d <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
f010457e:	8b 01                	mov    (%ecx),%eax
f0104580:	83 c0 04             	add    $0x4,%eax
f0104583:	89 01                	mov    %eax,(%ecx)
f0104585:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
f0104588:	ba 00 00 00 00       	mov    $0x0,%edx
}
f010458d:	c9                   	leave  
f010458e:	c3                   	ret    

f010458f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
f010458f:	55                   	push   %ebp
f0104590:	89 e5                	mov    %esp,%ebp
f0104592:	8b 55 08             	mov    0x8(%ebp),%edx
f0104595:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
f0104598:	83 f8 01             	cmp    $0x1,%eax
f010459b:	7e 0f                	jle    f01045ac <getint+0x1d>
		return va_arg(*ap, long long);
f010459d:	8b 02                	mov    (%edx),%eax
f010459f:	83 c0 08             	add    $0x8,%eax
f01045a2:	89 02                	mov    %eax,(%edx)
f01045a4:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
f01045a7:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
f01045aa:	eb 1c                	jmp    f01045c8 <getint+0x39>
	else if (lflag)
f01045ac:	85 c0                	test   %eax,%eax
f01045ae:	74 0d                	je     f01045bd <getint+0x2e>
		return va_arg(*ap, long);
f01045b0:	8b 02                	mov    (%edx),%eax
f01045b2:	83 c0 04             	add    $0x4,%eax
f01045b5:	89 02                	mov    %eax,(%edx)
f01045b7:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
f01045ba:	99                   	cltd   
f01045bb:	eb 0b                	jmp    f01045c8 <getint+0x39>
	else
		return va_arg(*ap, int);
f01045bd:	8b 02                	mov    (%edx),%eax
f01045bf:	83 c0 04             	add    $0x4,%eax
f01045c2:	89 02                	mov    %eax,(%edx)
f01045c4:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
f01045c7:	99                   	cltd   
}
f01045c8:	c9                   	leave  
f01045c9:	c3                   	ret    

f01045ca <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f01045ca:	55                   	push   %ebp
f01045cb:	89 e5                	mov    %esp,%ebp
f01045cd:	57                   	push   %edi
f01045ce:	56                   	push   %esi
f01045cf:	53                   	push   %ebx
f01045d0:	83 ec 1c             	sub    $0x1c,%esp
f01045d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
f01045d6:	0f b6 13             	movzbl (%ebx),%edx
f01045d9:	43                   	inc    %ebx
f01045da:	83 fa 25             	cmp    $0x25,%edx
f01045dd:	74 1e                	je     f01045fd <vprintfmt+0x33>
f01045df:	85 d2                	test   %edx,%edx
f01045e1:	0f 84 d7 02 00 00    	je     f01048be <vprintfmt+0x2f4>
f01045e7:	83 ec 08             	sub    $0x8,%esp
f01045ea:	ff 75 0c             	pushl  0xc(%ebp)
f01045ed:	52                   	push   %edx
f01045ee:	ff 55 08             	call   *0x8(%ebp)
f01045f1:	83 c4 10             	add    $0x10,%esp
f01045f4:	0f b6 13             	movzbl (%ebx),%edx
f01045f7:	43                   	inc    %ebx
f01045f8:	83 fa 25             	cmp    $0x25,%edx
f01045fb:	75 e2                	jne    f01045df <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
f01045fd:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
f0104601:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
f0104608:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
f010460d:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
f0104612:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0104619:	0f b6 13             	movzbl (%ebx),%edx
f010461c:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
f010461f:	43                   	inc    %ebx
f0104620:	83 f8 55             	cmp    $0x55,%eax
f0104623:	0f 87 70 02 00 00    	ja     f0104899 <vprintfmt+0x2cf>
f0104629:	ff 24 85 7c 70 10 f0 	jmp    *0xf010707c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
f0104630:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
f0104634:	eb e3                	jmp    f0104619 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f0104636:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
f010463a:	eb dd                	jmp    f0104619 <vprintfmt+0x4f>

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
f010463c:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
f0104641:	8d 04 b6             	lea    (%esi,%esi,4),%eax
f0104644:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
f0104648:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
f010464b:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
f010464e:	83 f8 09             	cmp    $0x9,%eax
f0104651:	77 27                	ja     f010467a <vprintfmt+0xb0>
f0104653:	43                   	inc    %ebx
f0104654:	eb eb                	jmp    f0104641 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0104656:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f010465a:	8b 45 14             	mov    0x14(%ebp),%eax
f010465d:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
f0104660:	eb 18                	jmp    f010467a <vprintfmt+0xb0>

		case '.':
			if (width < 0)
f0104662:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0104666:	79 b1                	jns    f0104619 <vprintfmt+0x4f>
				width = 0;
f0104668:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
f010466f:	eb a8                	jmp    f0104619 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
f0104671:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
f0104678:	eb 9f                	jmp    f0104619 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
f010467a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f010467e:	79 99                	jns    f0104619 <vprintfmt+0x4f>
				width = precision, precision = -1;
f0104680:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
f0104683:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
f0104688:	eb 8f                	jmp    f0104619 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f010468a:	41                   	inc    %ecx
			goto reswitch;
f010468b:	eb 8c                	jmp    f0104619 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f010468d:	83 ec 08             	sub    $0x8,%esp
f0104690:	ff 75 0c             	pushl  0xc(%ebp)
f0104693:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f0104697:	8b 45 14             	mov    0x14(%ebp),%eax
f010469a:	ff 70 fc             	pushl  0xfffffffc(%eax)
f010469d:	ff 55 08             	call   *0x8(%ebp)
			break;
f01046a0:	83 c4 10             	add    $0x10,%esp
f01046a3:	e9 2e ff ff ff       	jmp    f01045d6 <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
f01046a8:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f01046ac:	8b 45 14             	mov    0x14(%ebp),%eax
f01046af:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
f01046b2:	85 c0                	test   %eax,%eax
f01046b4:	79 02                	jns    f01046b8 <vprintfmt+0xee>
				err = -err;
f01046b6:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
f01046b8:	83 f8 0e             	cmp    $0xe,%eax
f01046bb:	7f 0b                	jg     f01046c8 <vprintfmt+0xfe>
f01046bd:	8b 3c 85 40 70 10 f0 	mov    0xf0107040(,%eax,4),%edi
f01046c4:	85 ff                	test   %edi,%edi
f01046c6:	75 19                	jne    f01046e1 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
f01046c8:	50                   	push   %eax
f01046c9:	68 09 70 10 f0       	push   $0xf0107009
f01046ce:	ff 75 0c             	pushl  0xc(%ebp)
f01046d1:	ff 75 08             	pushl  0x8(%ebp)
f01046d4:	e8 ed 01 00 00       	call   f01048c6 <printfmt>
f01046d9:	83 c4 10             	add    $0x10,%esp
f01046dc:	e9 f5 fe ff ff       	jmp    f01045d6 <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
f01046e1:	57                   	push   %edi
f01046e2:	68 56 68 10 f0       	push   $0xf0106856
f01046e7:	ff 75 0c             	pushl  0xc(%ebp)
f01046ea:	ff 75 08             	pushl  0x8(%ebp)
f01046ed:	e8 d4 01 00 00       	call   f01048c6 <printfmt>
f01046f2:	83 c4 10             	add    $0x10,%esp
			break;
f01046f5:	e9 dc fe ff ff       	jmp    f01045d6 <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f01046fa:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f01046fe:	8b 45 14             	mov    0x14(%ebp),%eax
f0104701:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
f0104704:	85 ff                	test   %edi,%edi
f0104706:	75 05                	jne    f010470d <vprintfmt+0x143>
				p = "(null)";
f0104708:	bf 12 70 10 f0       	mov    $0xf0107012,%edi
			if (width > 0 && padc != '-')
f010470d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f0104711:	7e 3b                	jle    f010474e <vprintfmt+0x184>
f0104713:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
f0104717:	74 35                	je     f010474e <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
f0104719:	83 ec 08             	sub    $0x8,%esp
f010471c:	56                   	push   %esi
f010471d:	57                   	push   %edi
f010471e:	e8 2a 04 00 00       	call   f0104b4d <strnlen>
f0104723:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
f0104726:	83 c4 10             	add    $0x10,%esp
f0104729:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f010472d:	7e 1f                	jle    f010474e <vprintfmt+0x184>
f010472f:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
f0104733:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
f0104736:	83 ec 08             	sub    $0x8,%esp
f0104739:	ff 75 0c             	pushl  0xc(%ebp)
f010473c:	ff 75 e4             	pushl  0xffffffe4(%ebp)
f010473f:	ff 55 08             	call   *0x8(%ebp)
f0104742:	83 c4 10             	add    $0x10,%esp
f0104745:	ff 4d f0             	decl   0xfffffff0(%ebp)
f0104748:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f010474c:	7f e8                	jg     f0104736 <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010474e:	0f be 17             	movsbl (%edi),%edx
f0104751:	47                   	inc    %edi
f0104752:	85 d2                	test   %edx,%edx
f0104754:	74 44                	je     f010479a <vprintfmt+0x1d0>
f0104756:	85 f6                	test   %esi,%esi
f0104758:	78 03                	js     f010475d <vprintfmt+0x193>
f010475a:	4e                   	dec    %esi
f010475b:	78 3d                	js     f010479a <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
f010475d:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
f0104761:	74 18                	je     f010477b <vprintfmt+0x1b1>
f0104763:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
f0104766:	83 f8 5e             	cmp    $0x5e,%eax
f0104769:	76 10                	jbe    f010477b <vprintfmt+0x1b1>
					putch('?', putdat);
f010476b:	83 ec 08             	sub    $0x8,%esp
f010476e:	ff 75 0c             	pushl  0xc(%ebp)
f0104771:	6a 3f                	push   $0x3f
f0104773:	ff 55 08             	call   *0x8(%ebp)
f0104776:	83 c4 10             	add    $0x10,%esp
f0104779:	eb 0d                	jmp    f0104788 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
f010477b:	83 ec 08             	sub    $0x8,%esp
f010477e:	ff 75 0c             	pushl  0xc(%ebp)
f0104781:	52                   	push   %edx
f0104782:	ff 55 08             	call   *0x8(%ebp)
f0104785:	83 c4 10             	add    $0x10,%esp
f0104788:	ff 4d f0             	decl   0xfffffff0(%ebp)
f010478b:	0f be 17             	movsbl (%edi),%edx
f010478e:	47                   	inc    %edi
f010478f:	85 d2                	test   %edx,%edx
f0104791:	74 07                	je     f010479a <vprintfmt+0x1d0>
f0104793:	85 f6                	test   %esi,%esi
f0104795:	78 c6                	js     f010475d <vprintfmt+0x193>
f0104797:	4e                   	dec    %esi
f0104798:	79 c3                	jns    f010475d <vprintfmt+0x193>
			for (; width > 0; width--)
f010479a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f010479e:	0f 8e 32 fe ff ff    	jle    f01045d6 <vprintfmt+0xc>
				putch(' ', putdat);
f01047a4:	83 ec 08             	sub    $0x8,%esp
f01047a7:	ff 75 0c             	pushl  0xc(%ebp)
f01047aa:	6a 20                	push   $0x20
f01047ac:	ff 55 08             	call   *0x8(%ebp)
f01047af:	83 c4 10             	add    $0x10,%esp
f01047b2:	ff 4d f0             	decl   0xfffffff0(%ebp)
f01047b5:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
f01047b9:	7f e9                	jg     f01047a4 <vprintfmt+0x1da>
			break;
f01047bb:	e9 16 fe ff ff       	jmp    f01045d6 <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f01047c0:	51                   	push   %ecx
f01047c1:	8d 45 14             	lea    0x14(%ebp),%eax
f01047c4:	50                   	push   %eax
f01047c5:	e8 c5 fd ff ff       	call   f010458f <getint>
f01047ca:	89 c6                	mov    %eax,%esi
f01047cc:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
f01047ce:	83 c4 08             	add    $0x8,%esp
f01047d1:	85 d2                	test   %edx,%edx
f01047d3:	79 15                	jns    f01047ea <vprintfmt+0x220>
				putch('-', putdat);
f01047d5:	83 ec 08             	sub    $0x8,%esp
f01047d8:	ff 75 0c             	pushl  0xc(%ebp)
f01047db:	6a 2d                	push   $0x2d
f01047dd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01047e0:	f7 de                	neg    %esi
f01047e2:	83 d7 00             	adc    $0x0,%edi
f01047e5:	f7 df                	neg    %edi
f01047e7:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
f01047ea:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
f01047ef:	eb 75                	jmp    f0104866 <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f01047f1:	51                   	push   %ecx
f01047f2:	8d 45 14             	lea    0x14(%ebp),%eax
f01047f5:	50                   	push   %eax
f01047f6:	e8 51 fd ff ff       	call   f010454c <getuint>
f01047fb:	89 c6                	mov    %eax,%esi
f01047fd:	89 d7                	mov    %edx,%edi
			base = 10;
f01047ff:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
f0104804:	83 c4 08             	add    $0x8,%esp
f0104807:	eb 5d                	jmp    f0104866 <vprintfmt+0x29c>

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
f0104809:	51                   	push   %ecx
f010480a:	8d 45 14             	lea    0x14(%ebp),%eax
f010480d:	50                   	push   %eax
f010480e:	e8 39 fd ff ff       	call   f010454c <getuint>
f0104813:	89 c6                	mov    %eax,%esi
f0104815:	89 d7                	mov    %edx,%edi
			base = 8;
f0104817:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
f010481c:	83 c4 08             	add    $0x8,%esp
f010481f:	eb 45                	jmp    f0104866 <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
f0104821:	83 ec 08             	sub    $0x8,%esp
f0104824:	ff 75 0c             	pushl  0xc(%ebp)
f0104827:	6a 30                	push   $0x30
f0104829:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f010482c:	83 c4 08             	add    $0x8,%esp
f010482f:	ff 75 0c             	pushl  0xc(%ebp)
f0104832:	6a 78                	push   $0x78
f0104834:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
f0104837:	83 45 14 04          	addl   $0x4,0x14(%ebp)
f010483b:	8b 45 14             	mov    0x14(%ebp),%eax
f010483e:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
f0104841:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f0104846:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
f010484b:	83 c4 10             	add    $0x10,%esp
f010484e:	eb 16                	jmp    f0104866 <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0104850:	51                   	push   %ecx
f0104851:	8d 45 14             	lea    0x14(%ebp),%eax
f0104854:	50                   	push   %eax
f0104855:	e8 f2 fc ff ff       	call   f010454c <getuint>
f010485a:	89 c6                	mov    %eax,%esi
f010485c:	89 d7                	mov    %edx,%edi
			base = 16;
f010485e:	ba 10 00 00 00       	mov    $0x10,%edx
f0104863:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
f0104866:	83 ec 04             	sub    $0x4,%esp
f0104869:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
f010486d:	50                   	push   %eax
f010486e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
f0104871:	52                   	push   %edx
f0104872:	57                   	push   %edi
f0104873:	56                   	push   %esi
f0104874:	ff 75 0c             	pushl  0xc(%ebp)
f0104877:	ff 75 08             	pushl  0x8(%ebp)
f010487a:	e8 2d fc ff ff       	call   f01044ac <printnum>
			break;
f010487f:	83 c4 20             	add    $0x20,%esp
f0104882:	e9 4f fd ff ff       	jmp    f01045d6 <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f0104887:	83 ec 08             	sub    $0x8,%esp
f010488a:	ff 75 0c             	pushl  0xc(%ebp)
f010488d:	52                   	push   %edx
f010488e:	ff 55 08             	call   *0x8(%ebp)
			break;
f0104891:	83 c4 10             	add    $0x10,%esp
f0104894:	e9 3d fd ff ff       	jmp    f01045d6 <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0104899:	83 ec 08             	sub    $0x8,%esp
f010489c:	ff 75 0c             	pushl  0xc(%ebp)
f010489f:	6a 25                	push   $0x25
f01048a1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f01048a4:	4b                   	dec    %ebx
f01048a5:	83 c4 10             	add    $0x10,%esp
f01048a8:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
f01048ac:	0f 84 24 fd ff ff    	je     f01045d6 <vprintfmt+0xc>
f01048b2:	4b                   	dec    %ebx
f01048b3:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
f01048b7:	75 f9                	jne    f01048b2 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
f01048b9:	e9 18 fd ff ff       	jmp    f01045d6 <vprintfmt+0xc>
		}
	}
}
f01048be:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f01048c1:	5b                   	pop    %ebx
f01048c2:	5e                   	pop    %esi
f01048c3:	5f                   	pop    %edi
f01048c4:	c9                   	leave  
f01048c5:	c3                   	ret    

f01048c6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f01048c6:	55                   	push   %ebp
f01048c7:	89 e5                	mov    %esp,%ebp
f01048c9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01048cc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f01048cf:	50                   	push   %eax
f01048d0:	ff 75 10             	pushl  0x10(%ebp)
f01048d3:	ff 75 0c             	pushl  0xc(%ebp)
f01048d6:	ff 75 08             	pushl  0x8(%ebp)
f01048d9:	e8 ec fc ff ff       	call   f01045ca <vprintfmt>
	va_end(ap);
}
f01048de:	c9                   	leave  
f01048df:	c3                   	ret    

f01048e0 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01048e0:	55                   	push   %ebp
f01048e1:	89 e5                	mov    %esp,%ebp
f01048e3:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
f01048e6:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
f01048e9:	8b 0a                	mov    (%edx),%ecx
f01048eb:	3b 4a 04             	cmp    0x4(%edx),%ecx
f01048ee:	73 07                	jae    f01048f7 <sprintputch+0x17>
		*b->buf++ = ch;
f01048f0:	8b 45 08             	mov    0x8(%ebp),%eax
f01048f3:	88 01                	mov    %al,(%ecx)
f01048f5:	ff 02                	incl   (%edx)
}
f01048f7:	c9                   	leave  
f01048f8:	c3                   	ret    

f01048f9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01048f9:	55                   	push   %ebp
f01048fa:	89 e5                	mov    %esp,%ebp
f01048fc:	83 ec 18             	sub    $0x18,%esp
f01048ff:	8b 55 08             	mov    0x8(%ebp),%edx
f0104902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0104905:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
f0104908:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
f010490c:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
f010490f:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
f0104916:	85 d2                	test   %edx,%edx
f0104918:	74 04                	je     f010491e <vsnprintf+0x25>
f010491a:	85 c9                	test   %ecx,%ecx
f010491c:	7f 07                	jg     f0104925 <vsnprintf+0x2c>
		return -E_INVAL;
f010491e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104923:	eb 1d                	jmp    f0104942 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0104925:	ff 75 14             	pushl  0x14(%ebp)
f0104928:	ff 75 10             	pushl  0x10(%ebp)
f010492b:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f010492e:	50                   	push   %eax
f010492f:	68 e0 48 10 f0       	push   $0xf01048e0
f0104934:	e8 91 fc ff ff       	call   f01045ca <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0104939:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f010493c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f010493f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
f0104942:	c9                   	leave  
f0104943:	c3                   	ret    

f0104944 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0104944:	55                   	push   %ebp
f0104945:	89 e5                	mov    %esp,%ebp
f0104947:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f010494a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f010494d:	50                   	push   %eax
f010494e:	ff 75 10             	pushl  0x10(%ebp)
f0104951:	ff 75 0c             	pushl  0xc(%ebp)
f0104954:	ff 75 08             	pushl  0x8(%ebp)
f0104957:	e8 9d ff ff ff       	call   f01048f9 <vsnprintf>
	va_end(ap);

	return rc;
}
f010495c:	c9                   	leave  
f010495d:	c3                   	ret    
	...

f0104960 <readline>:
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0104960:	55                   	push   %ebp
f0104961:	89 e5                	mov    %esp,%ebp
f0104963:	57                   	push   %edi
f0104964:	56                   	push   %esi
f0104965:	53                   	push   %ebx
f0104966:	83 ec 0c             	sub    $0xc,%esp
f0104969:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f010496c:	85 c0                	test   %eax,%eax
f010496e:	74 11                	je     f0104981 <readline+0x21>
		cprintf("%s", prompt);
f0104970:	83 ec 08             	sub    $0x8,%esp
f0104973:	50                   	push   %eax
f0104974:	68 56 68 10 f0       	push   $0xf0106856
f0104979:	e8 4c e7 ff ff       	call   f01030ca <cprintf>
f010497e:	83 c4 10             	add    $0x10,%esp
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
f0104981:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
f0104986:	83 ec 0c             	sub    $0xc,%esp
f0104989:	6a 00                	push   $0x0
f010498b:	e8 35 bd ff ff       	call   f01006c5 <iscons>
f0104990:	89 c7                	mov    %eax,%edi
	while (1) {
f0104992:	83 c4 10             	add    $0x10,%esp
		c = getchar();
f0104995:	e8 1a bd ff ff       	call   f01006b4 <getchar>
f010499a:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010499c:	85 c0                	test   %eax,%eax
f010499e:	79 1d                	jns    f01049bd <readline+0x5d>
			if (c != -E_EOF)
f01049a0:	83 f8 f8             	cmp    $0xfffffff8,%eax
f01049a3:	74 11                	je     f01049b6 <readline+0x56>
				cprintf("read error: %e\n", c);
f01049a5:	83 ec 08             	sub    $0x8,%esp
f01049a8:	50                   	push   %eax
f01049a9:	68 d4 71 10 f0       	push   $0xf01071d4
f01049ae:	e8 17 e7 ff ff       	call   f01030ca <cprintf>
f01049b3:	83 c4 10             	add    $0x10,%esp
			return NULL;
f01049b6:	b8 00 00 00 00       	mov    $0x0,%eax
f01049bb:	eb 6f                	jmp    f0104a2c <readline+0xcc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01049bd:	83 f8 08             	cmp    $0x8,%eax
f01049c0:	74 05                	je     f01049c7 <readline+0x67>
f01049c2:	83 f8 7f             	cmp    $0x7f,%eax
f01049c5:	75 18                	jne    f01049df <readline+0x7f>
f01049c7:	85 f6                	test   %esi,%esi
f01049c9:	7e 14                	jle    f01049df <readline+0x7f>
			if (echoing)
f01049cb:	85 ff                	test   %edi,%edi
f01049cd:	74 0d                	je     f01049dc <readline+0x7c>
				cputchar('\b');
f01049cf:	83 ec 0c             	sub    $0xc,%esp
f01049d2:	6a 08                	push   $0x8
f01049d4:	e8 cb bc ff ff       	call   f01006a4 <cputchar>
f01049d9:	83 c4 10             	add    $0x10,%esp
			i--;
f01049dc:	4e                   	dec    %esi
f01049dd:	eb b6                	jmp    f0104995 <readline+0x35>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01049df:	83 fb 1f             	cmp    $0x1f,%ebx
f01049e2:	7e 21                	jle    f0104a05 <readline+0xa5>
f01049e4:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01049ea:	7f 19                	jg     f0104a05 <readline+0xa5>
			if (echoing)
f01049ec:	85 ff                	test   %edi,%edi
f01049ee:	74 0c                	je     f01049fc <readline+0x9c>
				cputchar(c);
f01049f0:	83 ec 0c             	sub    $0xc,%esp
f01049f3:	53                   	push   %ebx
f01049f4:	e8 ab bc ff ff       	call   f01006a4 <cputchar>
f01049f9:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
f01049fc:	88 9e 60 64 2f f0    	mov    %bl,0xf02f6460(%esi)
f0104a02:	46                   	inc    %esi
f0104a03:	eb 90                	jmp    f0104995 <readline+0x35>
		} else if (c == '\n' || c == '\r') {
f0104a05:	83 fb 0a             	cmp    $0xa,%ebx
f0104a08:	74 05                	je     f0104a0f <readline+0xaf>
f0104a0a:	83 fb 0d             	cmp    $0xd,%ebx
f0104a0d:	75 86                	jne    f0104995 <readline+0x35>
			if (echoing)
f0104a0f:	85 ff                	test   %edi,%edi
f0104a11:	74 0d                	je     f0104a20 <readline+0xc0>
				cputchar('\n');
f0104a13:	83 ec 0c             	sub    $0xc,%esp
f0104a16:	6a 0a                	push   $0xa
f0104a18:	e8 87 bc ff ff       	call   f01006a4 <cputchar>
f0104a1d:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
f0104a20:	c6 86 60 64 2f f0 00 	movb   $0x0,0xf02f6460(%esi)
			return buf;
f0104a27:	b8 60 64 2f f0       	mov    $0xf02f6460,%eax
		}
	}
}
f0104a2c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0104a2f:	5b                   	pop    %ebx
f0104a30:	5e                   	pop    %esi
f0104a31:	5f                   	pop    %edi
f0104a32:	c9                   	leave  
f0104a33:	c3                   	ret    

f0104a34 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
f0104a34:	55                   	push   %ebp
f0104a35:	89 e5                	mov    %esp,%ebp
f0104a37:	56                   	push   %esi
f0104a38:	53                   	push   %ebx
f0104a39:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
f0104a3c:	83 ec 0c             	sub    $0xc,%esp
f0104a3f:	56                   	push   %esi
f0104a40:	e8 ef 00 00 00       	call   f0104b34 <strlen>
  char letter;
  int hexnum = 0;
f0104a45:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
f0104a4a:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
f0104a4f:	83 c4 10             	add    $0x10,%esp
f0104a52:	89 c2                	mov    %eax,%edx
f0104a54:	4a                   	dec    %edx
f0104a55:	0f 88 d0 00 00 00    	js     f0104b2b <strtoint+0xf7>
    letter = string[cidx];
f0104a5b:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
f0104a5e:	85 d2                	test   %edx,%edx
f0104a60:	75 12                	jne    f0104a74 <strtoint+0x40>
      if (letter != '0') {
f0104a62:	3c 30                	cmp    $0x30,%al
f0104a64:	0f 84 ba 00 00 00    	je     f0104b24 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
f0104a6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104a6f:	e9 b9 00 00 00       	jmp    f0104b2d <strtoint+0xf9>
      }
    } else if (cidx == 1) {
f0104a74:	83 fa 01             	cmp    $0x1,%edx
f0104a77:	75 12                	jne    f0104a8b <strtoint+0x57>
      if (letter != 'x') {
f0104a79:	3c 78                	cmp    $0x78,%al
f0104a7b:	0f 84 a3 00 00 00    	je     f0104b24 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
f0104a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104a86:	e9 a2 00 00 00       	jmp    f0104b2d <strtoint+0xf9>
      }
    } else {
      switch (letter) {
f0104a8b:	0f be c0             	movsbl %al,%eax
f0104a8e:	83 e8 30             	sub    $0x30,%eax
f0104a91:	83 f8 36             	cmp    $0x36,%eax
f0104a94:	0f 87 80 00 00 00    	ja     f0104b1a <strtoint+0xe6>
f0104a9a:	ff 24 85 e4 71 10 f0 	jmp    *0xf01071e4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
f0104aa1:	01 cb                	add    %ecx,%ebx
          break;
f0104aa3:	eb 7c                	jmp    f0104b21 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
f0104aa5:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
f0104aa8:	eb 77                	jmp    f0104b21 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
f0104aaa:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0104aad:	01 c3                	add    %eax,%ebx
          break;
f0104aaf:	eb 70                	jmp    f0104b21 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
f0104ab1:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
f0104ab4:	eb 6b                	jmp    f0104b21 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
f0104ab6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
f0104ab9:	01 c3                	add    %eax,%ebx
          break;
f0104abb:	eb 64                	jmp    f0104b21 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
f0104abd:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0104ac0:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
f0104ac3:	eb 5c                	jmp    f0104b21 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
f0104ac5:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
f0104acc:	29 c8                	sub    %ecx,%eax
f0104ace:	01 c3                	add    %eax,%ebx
          break;
f0104ad0:	eb 4f                	jmp    f0104b21 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
f0104ad2:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
f0104ad5:	eb 4a                	jmp    f0104b21 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
f0104ad7:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
f0104ada:	01 c3                	add    %eax,%ebx
          break;
f0104adc:	eb 43                	jmp    f0104b21 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
f0104ade:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
f0104ae1:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
f0104ae4:	eb 3b                	jmp    f0104b21 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
f0104ae6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
f0104ae9:	8d 04 41             	lea    (%ecx,%eax,2),%eax
f0104aec:	01 c3                	add    %eax,%ebx
          break;
f0104aee:	eb 31                	jmp    f0104b21 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
f0104af0:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0104af3:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
f0104af6:	eb 29                	jmp    f0104b21 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
f0104af8:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0104afb:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0104afe:	01 c3                	add    %eax,%ebx
          break;
f0104b00:	eb 1f                	jmp    f0104b21 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
f0104b02:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
f0104b09:	29 c8                	sub    %ecx,%eax
f0104b0b:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
f0104b0e:	eb 11                	jmp    f0104b21 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
f0104b10:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
f0104b13:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0104b16:	01 c3                	add    %eax,%ebx
          break;
f0104b18:	eb 07                	jmp    f0104b21 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
f0104b1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104b1f:	eb 0c                	jmp    f0104b2d <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
f0104b21:	c1 e1 04             	shl    $0x4,%ecx
f0104b24:	4a                   	dec    %edx
f0104b25:	0f 89 30 ff ff ff    	jns    f0104a5b <strtoint+0x27>
    }
  }

  return hexnum;
f0104b2b:	89 d8                	mov    %ebx,%eax
}
f0104b2d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0104b30:	5b                   	pop    %ebx
f0104b31:	5e                   	pop    %esi
f0104b32:	c9                   	leave  
f0104b33:	c3                   	ret    

f0104b34 <strlen>:





int
strlen(const char *s)
{
f0104b34:	55                   	push   %ebp
f0104b35:	89 e5                	mov    %esp,%ebp
f0104b37:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0104b3a:	b8 00 00 00 00       	mov    $0x0,%eax
f0104b3f:	80 3a 00             	cmpb   $0x0,(%edx)
f0104b42:	74 07                	je     f0104b4b <strlen+0x17>
		n++;
f0104b44:	40                   	inc    %eax
f0104b45:	42                   	inc    %edx
f0104b46:	80 3a 00             	cmpb   $0x0,(%edx)
f0104b49:	75 f9                	jne    f0104b44 <strlen+0x10>
	return n;
}
f0104b4b:	c9                   	leave  
f0104b4c:	c3                   	ret    

f0104b4d <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0104b4d:	55                   	push   %ebp
f0104b4e:	89 e5                	mov    %esp,%ebp
f0104b50:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104b53:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0104b56:	b8 00 00 00 00       	mov    $0x0,%eax
f0104b5b:	85 d2                	test   %edx,%edx
f0104b5d:	74 0f                	je     f0104b6e <strnlen+0x21>
f0104b5f:	80 39 00             	cmpb   $0x0,(%ecx)
f0104b62:	74 0a                	je     f0104b6e <strnlen+0x21>
		n++;
f0104b64:	40                   	inc    %eax
f0104b65:	41                   	inc    %ecx
f0104b66:	4a                   	dec    %edx
f0104b67:	74 05                	je     f0104b6e <strnlen+0x21>
f0104b69:	80 39 00             	cmpb   $0x0,(%ecx)
f0104b6c:	75 f6                	jne    f0104b64 <strnlen+0x17>
	return n;
}
f0104b6e:	c9                   	leave  
f0104b6f:	c3                   	ret    

f0104b70 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0104b70:	55                   	push   %ebp
f0104b71:	89 e5                	mov    %esp,%ebp
f0104b73:	53                   	push   %ebx
f0104b74:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104b77:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
f0104b7a:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
f0104b7c:	8a 02                	mov    (%edx),%al
f0104b7e:	42                   	inc    %edx
f0104b7f:	88 01                	mov    %al,(%ecx)
f0104b81:	41                   	inc    %ecx
f0104b82:	84 c0                	test   %al,%al
f0104b84:	75 f6                	jne    f0104b7c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0104b86:	89 d8                	mov    %ebx,%eax
f0104b88:	5b                   	pop    %ebx
f0104b89:	c9                   	leave  
f0104b8a:	c3                   	ret    

f0104b8b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0104b8b:	55                   	push   %ebp
f0104b8c:	89 e5                	mov    %esp,%ebp
f0104b8e:	57                   	push   %edi
f0104b8f:	56                   	push   %esi
f0104b90:	53                   	push   %ebx
f0104b91:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104b94:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104b97:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
f0104b9a:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
f0104b9c:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104ba1:	39 f3                	cmp    %esi,%ebx
f0104ba3:	73 10                	jae    f0104bb5 <strncpy+0x2a>
		*dst++ = *src;
f0104ba5:	8a 02                	mov    (%edx),%al
f0104ba7:	88 01                	mov    %al,(%ecx)
f0104ba9:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0104baa:	80 3a 01             	cmpb   $0x1,(%edx)
f0104bad:	83 da ff             	sbb    $0xffffffff,%edx
f0104bb0:	43                   	inc    %ebx
f0104bb1:	39 f3                	cmp    %esi,%ebx
f0104bb3:	72 f0                	jb     f0104ba5 <strncpy+0x1a>
	}
	return ret;
}
f0104bb5:	89 f8                	mov    %edi,%eax
f0104bb7:	5b                   	pop    %ebx
f0104bb8:	5e                   	pop    %esi
f0104bb9:	5f                   	pop    %edi
f0104bba:	c9                   	leave  
f0104bbb:	c3                   	ret    

f0104bbc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0104bbc:	55                   	push   %ebp
f0104bbd:	89 e5                	mov    %esp,%ebp
f0104bbf:	56                   	push   %esi
f0104bc0:	53                   	push   %ebx
f0104bc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104bc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104bc7:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
f0104bca:	89 de                	mov    %ebx,%esi
	if (size > 0) {
f0104bcc:	85 d2                	test   %edx,%edx
f0104bce:	74 19                	je     f0104be9 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0104bd0:	4a                   	dec    %edx
f0104bd1:	74 13                	je     f0104be6 <strlcpy+0x2a>
f0104bd3:	80 39 00             	cmpb   $0x0,(%ecx)
f0104bd6:	74 0e                	je     f0104be6 <strlcpy+0x2a>
f0104bd8:	8a 01                	mov    (%ecx),%al
f0104bda:	41                   	inc    %ecx
f0104bdb:	88 03                	mov    %al,(%ebx)
f0104bdd:	43                   	inc    %ebx
f0104bde:	4a                   	dec    %edx
f0104bdf:	74 05                	je     f0104be6 <strlcpy+0x2a>
f0104be1:	80 39 00             	cmpb   $0x0,(%ecx)
f0104be4:	75 f2                	jne    f0104bd8 <strlcpy+0x1c>
		*dst = '\0';
f0104be6:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
f0104be9:	89 d8                	mov    %ebx,%eax
f0104beb:	29 f0                	sub    %esi,%eax
}
f0104bed:	5b                   	pop    %ebx
f0104bee:	5e                   	pop    %esi
f0104bef:	c9                   	leave  
f0104bf0:	c3                   	ret    

f0104bf1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0104bf1:	55                   	push   %ebp
f0104bf2:	89 e5                	mov    %esp,%ebp
f0104bf4:	8b 55 08             	mov    0x8(%ebp),%edx
f0104bf7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
f0104bfa:	80 3a 00             	cmpb   $0x0,(%edx)
f0104bfd:	74 13                	je     f0104c12 <strcmp+0x21>
f0104bff:	8a 02                	mov    (%edx),%al
f0104c01:	3a 01                	cmp    (%ecx),%al
f0104c03:	75 0d                	jne    f0104c12 <strcmp+0x21>
f0104c05:	42                   	inc    %edx
f0104c06:	41                   	inc    %ecx
f0104c07:	80 3a 00             	cmpb   $0x0,(%edx)
f0104c0a:	74 06                	je     f0104c12 <strcmp+0x21>
f0104c0c:	8a 02                	mov    (%edx),%al
f0104c0e:	3a 01                	cmp    (%ecx),%al
f0104c10:	74 f3                	je     f0104c05 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0104c12:	0f b6 02             	movzbl (%edx),%eax
f0104c15:	0f b6 11             	movzbl (%ecx),%edx
f0104c18:	29 d0                	sub    %edx,%eax
}
f0104c1a:	c9                   	leave  
f0104c1b:	c3                   	ret    

f0104c1c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0104c1c:	55                   	push   %ebp
f0104c1d:	89 e5                	mov    %esp,%ebp
f0104c1f:	53                   	push   %ebx
f0104c20:	8b 55 08             	mov    0x8(%ebp),%edx
f0104c23:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0104c26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
f0104c29:	85 c9                	test   %ecx,%ecx
f0104c2b:	74 1f                	je     f0104c4c <strncmp+0x30>
f0104c2d:	80 3a 00             	cmpb   $0x0,(%edx)
f0104c30:	74 16                	je     f0104c48 <strncmp+0x2c>
f0104c32:	8a 02                	mov    (%edx),%al
f0104c34:	3a 03                	cmp    (%ebx),%al
f0104c36:	75 10                	jne    f0104c48 <strncmp+0x2c>
f0104c38:	42                   	inc    %edx
f0104c39:	43                   	inc    %ebx
f0104c3a:	49                   	dec    %ecx
f0104c3b:	74 0f                	je     f0104c4c <strncmp+0x30>
f0104c3d:	80 3a 00             	cmpb   $0x0,(%edx)
f0104c40:	74 06                	je     f0104c48 <strncmp+0x2c>
f0104c42:	8a 02                	mov    (%edx),%al
f0104c44:	3a 03                	cmp    (%ebx),%al
f0104c46:	74 f0                	je     f0104c38 <strncmp+0x1c>
	if (n == 0)
f0104c48:	85 c9                	test   %ecx,%ecx
f0104c4a:	75 07                	jne    f0104c53 <strncmp+0x37>
		return 0;
f0104c4c:	b8 00 00 00 00       	mov    $0x0,%eax
f0104c51:	eb 0a                	jmp    f0104c5d <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0104c53:	0f b6 12             	movzbl (%edx),%edx
f0104c56:	0f b6 03             	movzbl (%ebx),%eax
f0104c59:	29 c2                	sub    %eax,%edx
f0104c5b:	89 d0                	mov    %edx,%eax
}
f0104c5d:	5b                   	pop    %ebx
f0104c5e:	c9                   	leave  
f0104c5f:	c3                   	ret    

f0104c60 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0104c60:	55                   	push   %ebp
f0104c61:	89 e5                	mov    %esp,%ebp
f0104c63:	8b 45 08             	mov    0x8(%ebp),%eax
f0104c66:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
f0104c69:	80 38 00             	cmpb   $0x0,(%eax)
f0104c6c:	74 0a                	je     f0104c78 <strchr+0x18>
		if (*s == c)
f0104c6e:	38 10                	cmp    %dl,(%eax)
f0104c70:	74 0b                	je     f0104c7d <strchr+0x1d>
f0104c72:	40                   	inc    %eax
f0104c73:	80 38 00             	cmpb   $0x0,(%eax)
f0104c76:	75 f6                	jne    f0104c6e <strchr+0xe>
			return (char *) s;
	return 0;
f0104c78:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104c7d:	c9                   	leave  
f0104c7e:	c3                   	ret    

f0104c7f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0104c7f:	55                   	push   %ebp
f0104c80:	89 e5                	mov    %esp,%ebp
f0104c82:	8b 45 08             	mov    0x8(%ebp),%eax
f0104c85:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
f0104c88:	80 38 00             	cmpb   $0x0,(%eax)
f0104c8b:	74 0a                	je     f0104c97 <strfind+0x18>
		if (*s == c)
f0104c8d:	38 10                	cmp    %dl,(%eax)
f0104c8f:	74 06                	je     f0104c97 <strfind+0x18>
f0104c91:	40                   	inc    %eax
f0104c92:	80 38 00             	cmpb   $0x0,(%eax)
f0104c95:	75 f6                	jne    f0104c8d <strfind+0xe>
			break;
	return (char *) s;
}
f0104c97:	c9                   	leave  
f0104c98:	c3                   	ret    

f0104c99 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0104c99:	55                   	push   %ebp
f0104c9a:	89 e5                	mov    %esp,%ebp
f0104c9c:	57                   	push   %edi
f0104c9d:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104ca0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
f0104ca3:	89 f8                	mov    %edi,%eax
f0104ca5:	85 c9                	test   %ecx,%ecx
f0104ca7:	74 40                	je     f0104ce9 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
f0104ca9:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0104caf:	75 30                	jne    f0104ce1 <memset+0x48>
f0104cb1:	f6 c1 03             	test   $0x3,%cl
f0104cb4:	75 2b                	jne    f0104ce1 <memset+0x48>
		c &= 0xFF;
f0104cb6:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0104cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104cc0:	c1 e0 18             	shl    $0x18,%eax
f0104cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104cc6:	c1 e2 10             	shl    $0x10,%edx
f0104cc9:	09 d0                	or     %edx,%eax
f0104ccb:	8b 55 0c             	mov    0xc(%ebp),%edx
f0104cce:	c1 e2 08             	shl    $0x8,%edx
f0104cd1:	09 d0                	or     %edx,%eax
f0104cd3:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
f0104cd6:	c1 e9 02             	shr    $0x2,%ecx
f0104cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104cdc:	fc                   	cld    
f0104cdd:	f3 ab                	repz stos %eax,%es:(%edi)
f0104cdf:	eb 06                	jmp    f0104ce7 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0104ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104ce4:	fc                   	cld    
f0104ce5:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
f0104ce7:	89 f8                	mov    %edi,%eax
}
f0104ce9:	5f                   	pop    %edi
f0104cea:	c9                   	leave  
f0104ceb:	c3                   	ret    

f0104cec <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0104cec:	55                   	push   %ebp
f0104ced:	89 e5                	mov    %esp,%ebp
f0104cef:	57                   	push   %edi
f0104cf0:	56                   	push   %esi
f0104cf1:	8b 45 08             	mov    0x8(%ebp),%eax
f0104cf4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
f0104cf7:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
f0104cfa:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
f0104cfc:	39 c6                	cmp    %eax,%esi
f0104cfe:	73 33                	jae    f0104d33 <memmove+0x47>
f0104d00:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0104d03:	39 c2                	cmp    %eax,%edx
f0104d05:	76 2c                	jbe    f0104d33 <memmove+0x47>
		s += n;
f0104d07:	89 d6                	mov    %edx,%esi
		d += n;
f0104d09:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104d0c:	f6 c2 03             	test   $0x3,%dl
f0104d0f:	75 1b                	jne    f0104d2c <memmove+0x40>
f0104d11:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0104d17:	75 13                	jne    f0104d2c <memmove+0x40>
f0104d19:	f6 c1 03             	test   $0x3,%cl
f0104d1c:	75 0e                	jne    f0104d2c <memmove+0x40>
			asm volatile("std; rep movsl\n"
f0104d1e:	83 ef 04             	sub    $0x4,%edi
f0104d21:	83 ee 04             	sub    $0x4,%esi
f0104d24:	c1 e9 02             	shr    $0x2,%ecx
f0104d27:	fd                   	std    
f0104d28:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
f0104d2a:	eb 27                	jmp    f0104d53 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0104d2c:	4f                   	dec    %edi
f0104d2d:	4e                   	dec    %esi
f0104d2e:	fd                   	std    
f0104d2f:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
f0104d31:	eb 20                	jmp    f0104d53 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0104d33:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0104d39:	75 15                	jne    f0104d50 <memmove+0x64>
f0104d3b:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0104d41:	75 0d                	jne    f0104d50 <memmove+0x64>
f0104d43:	f6 c1 03             	test   $0x3,%cl
f0104d46:	75 08                	jne    f0104d50 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
f0104d48:	c1 e9 02             	shr    $0x2,%ecx
f0104d4b:	fc                   	cld    
f0104d4c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
f0104d4e:	eb 03                	jmp    f0104d53 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0104d50:	fc                   	cld    
f0104d51:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0104d53:	5e                   	pop    %esi
f0104d54:	5f                   	pop    %edi
f0104d55:	c9                   	leave  
f0104d56:	c3                   	ret    

f0104d57 <memcpy>:

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
f0104d57:	55                   	push   %ebp
f0104d58:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f0104d5a:	ff 75 10             	pushl  0x10(%ebp)
f0104d5d:	ff 75 0c             	pushl  0xc(%ebp)
f0104d60:	ff 75 08             	pushl  0x8(%ebp)
f0104d63:	e8 84 ff ff ff       	call   f0104cec <memmove>
}
f0104d68:	c9                   	leave  
f0104d69:	c3                   	ret    

f0104d6a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0104d6a:	55                   	push   %ebp
f0104d6b:	89 e5                	mov    %esp,%ebp
f0104d6d:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
f0104d6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
f0104d71:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0104d74:	8b 55 10             	mov    0x10(%ebp),%edx
f0104d77:	4a                   	dec    %edx
f0104d78:	83 fa ff             	cmp    $0xffffffff,%edx
f0104d7b:	74 1a                	je     f0104d97 <memcmp+0x2d>
f0104d7d:	8a 01                	mov    (%ecx),%al
f0104d7f:	3a 03                	cmp    (%ebx),%al
f0104d81:	74 0c                	je     f0104d8f <memcmp+0x25>
f0104d83:	0f b6 d0             	movzbl %al,%edx
f0104d86:	0f b6 03             	movzbl (%ebx),%eax
f0104d89:	29 c2                	sub    %eax,%edx
f0104d8b:	89 d0                	mov    %edx,%eax
f0104d8d:	eb 0d                	jmp    f0104d9c <memcmp+0x32>
f0104d8f:	41                   	inc    %ecx
f0104d90:	43                   	inc    %ebx
f0104d91:	4a                   	dec    %edx
f0104d92:	83 fa ff             	cmp    $0xffffffff,%edx
f0104d95:	75 e6                	jne    f0104d7d <memcmp+0x13>
	}

	return 0;
f0104d97:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0104d9c:	5b                   	pop    %ebx
f0104d9d:	c9                   	leave  
f0104d9e:	c3                   	ret    

f0104d9f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0104d9f:	55                   	push   %ebp
f0104da0:	89 e5                	mov    %esp,%ebp
f0104da2:	8b 45 08             	mov    0x8(%ebp),%eax
f0104da5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0104da8:	89 c2                	mov    %eax,%edx
f0104daa:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0104dad:	39 d0                	cmp    %edx,%eax
f0104daf:	73 09                	jae    f0104dba <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
f0104db1:	38 08                	cmp    %cl,(%eax)
f0104db3:	74 05                	je     f0104dba <memfind+0x1b>
f0104db5:	40                   	inc    %eax
f0104db6:	39 d0                	cmp    %edx,%eax
f0104db8:	72 f7                	jb     f0104db1 <memfind+0x12>
			break;
	return (void *) s;
}
f0104dba:	c9                   	leave  
f0104dbb:	c3                   	ret    

f0104dbc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0104dbc:	55                   	push   %ebp
f0104dbd:	89 e5                	mov    %esp,%ebp
f0104dbf:	57                   	push   %edi
f0104dc0:	56                   	push   %esi
f0104dc1:	53                   	push   %ebx
f0104dc2:	8b 55 08             	mov    0x8(%ebp),%edx
f0104dc5:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104dc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
f0104dcb:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
f0104dd0:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
f0104dd5:	80 3a 20             	cmpb   $0x20,(%edx)
f0104dd8:	74 05                	je     f0104ddf <strtol+0x23>
f0104dda:	80 3a 09             	cmpb   $0x9,(%edx)
f0104ddd:	75 0b                	jne    f0104dea <strtol+0x2e>
f0104ddf:	42                   	inc    %edx
f0104de0:	80 3a 20             	cmpb   $0x20,(%edx)
f0104de3:	74 fa                	je     f0104ddf <strtol+0x23>
f0104de5:	80 3a 09             	cmpb   $0x9,(%edx)
f0104de8:	74 f5                	je     f0104ddf <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
f0104dea:	80 3a 2b             	cmpb   $0x2b,(%edx)
f0104ded:	75 03                	jne    f0104df2 <strtol+0x36>
		s++;
f0104def:	42                   	inc    %edx
f0104df0:	eb 0b                	jmp    f0104dfd <strtol+0x41>
	else if (*s == '-')
f0104df2:	80 3a 2d             	cmpb   $0x2d,(%edx)
f0104df5:	75 06                	jne    f0104dfd <strtol+0x41>
		s++, neg = 1;
f0104df7:	42                   	inc    %edx
f0104df8:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0104dfd:	85 c9                	test   %ecx,%ecx
f0104dff:	74 05                	je     f0104e06 <strtol+0x4a>
f0104e01:	83 f9 10             	cmp    $0x10,%ecx
f0104e04:	75 15                	jne    f0104e1b <strtol+0x5f>
f0104e06:	80 3a 30             	cmpb   $0x30,(%edx)
f0104e09:	75 10                	jne    f0104e1b <strtol+0x5f>
f0104e0b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0104e0f:	75 0a                	jne    f0104e1b <strtol+0x5f>
		s += 2, base = 16;
f0104e11:	83 c2 02             	add    $0x2,%edx
f0104e14:	b9 10 00 00 00       	mov    $0x10,%ecx
f0104e19:	eb 14                	jmp    f0104e2f <strtol+0x73>
	else if (base == 0 && s[0] == '0')
f0104e1b:	85 c9                	test   %ecx,%ecx
f0104e1d:	75 10                	jne    f0104e2f <strtol+0x73>
f0104e1f:	80 3a 30             	cmpb   $0x30,(%edx)
f0104e22:	75 05                	jne    f0104e29 <strtol+0x6d>
		s++, base = 8;
f0104e24:	42                   	inc    %edx
f0104e25:	b1 08                	mov    $0x8,%cl
f0104e27:	eb 06                	jmp    f0104e2f <strtol+0x73>
	else if (base == 0)
f0104e29:	85 c9                	test   %ecx,%ecx
f0104e2b:	75 02                	jne    f0104e2f <strtol+0x73>
		base = 10;
f0104e2d:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0104e2f:	8a 02                	mov    (%edx),%al
f0104e31:	83 e8 30             	sub    $0x30,%eax
f0104e34:	3c 09                	cmp    $0x9,%al
f0104e36:	77 08                	ja     f0104e40 <strtol+0x84>
			dig = *s - '0';
f0104e38:	0f be 02             	movsbl (%edx),%eax
f0104e3b:	83 e8 30             	sub    $0x30,%eax
f0104e3e:	eb 20                	jmp    f0104e60 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
f0104e40:	8a 02                	mov    (%edx),%al
f0104e42:	83 e8 61             	sub    $0x61,%eax
f0104e45:	3c 19                	cmp    $0x19,%al
f0104e47:	77 08                	ja     f0104e51 <strtol+0x95>
			dig = *s - 'a' + 10;
f0104e49:	0f be 02             	movsbl (%edx),%eax
f0104e4c:	83 e8 57             	sub    $0x57,%eax
f0104e4f:	eb 0f                	jmp    f0104e60 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
f0104e51:	8a 02                	mov    (%edx),%al
f0104e53:	83 e8 41             	sub    $0x41,%eax
f0104e56:	3c 19                	cmp    $0x19,%al
f0104e58:	77 12                	ja     f0104e6c <strtol+0xb0>
			dig = *s - 'A' + 10;
f0104e5a:	0f be 02             	movsbl (%edx),%eax
f0104e5d:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
f0104e60:	39 c8                	cmp    %ecx,%eax
f0104e62:	7d 08                	jge    f0104e6c <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
f0104e64:	42                   	inc    %edx
f0104e65:	0f af d9             	imul   %ecx,%ebx
f0104e68:	01 c3                	add    %eax,%ebx
f0104e6a:	eb c3                	jmp    f0104e2f <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
f0104e6c:	85 f6                	test   %esi,%esi
f0104e6e:	74 02                	je     f0104e72 <strtol+0xb6>
		*endptr = (char *) s;
f0104e70:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
f0104e72:	89 d8                	mov    %ebx,%eax
f0104e74:	85 ff                	test   %edi,%edi
f0104e76:	74 02                	je     f0104e7a <strtol+0xbe>
f0104e78:	f7 d8                	neg    %eax
}
f0104e7a:	5b                   	pop    %ebx
f0104e7b:	5e                   	pop    %esi
f0104e7c:	5f                   	pop    %edi
f0104e7d:	c9                   	leave  
f0104e7e:	c3                   	ret    
	...

f0104e80 <pci_e100_attach>:
 * Attach the e100 device
 */
int
pci_e100_attach(struct pci_func *pcif)
{
f0104e80:	55                   	push   %ebp
f0104e81:	89 e5                	mov    %esp,%ebp
f0104e83:	53                   	push   %ebx
f0104e84:	83 ec 10             	sub    $0x10,%esp
f0104e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pci_func_enable(pcif);
f0104e8a:	53                   	push   %ebx
f0104e8b:	e8 0f 0b 00 00       	call   f010599f <pci_func_enable>
  reg_base = pcif->reg_base;
f0104e90:	8d 43 14             	lea    0x14(%ebx),%eax
f0104e93:	a3 a4 68 32 f0       	mov    %eax,0xf03268a4
  reg_size = pcif->reg_size;
f0104e98:	8d 43 2c             	lea    0x2c(%ebx),%eax
f0104e9b:	a3 a0 68 32 f0       	mov    %eax,0xf03268a0
  irq_line = pcif->irq_line;
f0104ea0:	8a 43 44             	mov    0x44(%ebx),%al
f0104ea3:	a2 a8 68 32 f0       	mov    %al,0xf03268a8
  iobase = pcif->reg_base[1];
f0104ea8:	8b 43 18             	mov    0x18(%ebx),%eax
f0104eab:	a3 00 8b 32 f0       	mov    %eax,0xf0328b00

  // DEBUG: Verify valid iobase:
  // cprintf("hihihi %08x\n", reg_base[1]);
  // outputted reg_base[1]: 0000c040

  sw_reset_e100(iobase);
f0104eb0:	89 04 24             	mov    %eax,(%esp)
f0104eb3:	e8 19 00 00 00       	call   f0104ed1 <sw_reset_e100>

  init_cbl();
f0104eb8:	e8 32 00 00 00       	call   f0104eef <init_cbl>
  e100_transmit_nop();
f0104ebd:	e8 91 02 00 00       	call   f0105153 <e100_transmit_nop>
  cu_start(); // only start once, because must determine that all previously blocks were completed...too consuming.
f0104ec2:	e8 6b 04 00 00       	call   f0105332 <cu_start>

  // Challenge: start these later
  //init_rfa();
  //ru_start();

  return 1;
}
f0104ec7:	b8 01 00 00 00       	mov    $0x1,%eax
f0104ecc:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0104ecf:	c9                   	leave  
f0104ed0:	c3                   	ret    

f0104ed1 <sw_reset_e100>:

/**
 * Initiates a reset of the device
 */
void sw_reset_e100(uint32_t base) {
f0104ed1:	55                   	push   %ebp
f0104ed2:	89 e5                	mov    %esp,%ebp
}

static __inline void
outl(int port, uint32_t data)
{
f0104ed4:	8b 55 08             	mov    0x8(%ebp),%edx
f0104ed7:	83 c2 08             	add    $0x8,%edx
f0104eda:	b8 00 00 00 00       	mov    $0x0,%eax
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0104edf:	ef                   	out    %eax,(%dx)
f0104ee0:	ba 84 00 00 00       	mov    $0x84,%edx
f0104ee5:	ec                   	in     (%dx),%al
f0104ee6:	ec                   	in     (%dx),%al
f0104ee7:	ec                   	in     (%dx),%al
f0104ee8:	ec                   	in     (%dx),%al
f0104ee9:	ec                   	in     (%dx),%al
f0104eea:	ec                   	in     (%dx),%al
f0104eeb:	ec                   	in     (%dx),%al
f0104eec:	ec                   	in     (%dx),%al
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
f0104eed:	c9                   	leave  
f0104eee:	c3                   	ret    

f0104eef <init_cbl>:



/**
 * Builds the CBL
 */
void init_cbl(void) {
f0104eef:	55                   	push   %ebp
f0104ef0:	89 e5                	mov    %esp,%ebp
f0104ef2:	83 ec 0c             	sub    $0xc,%esp
  int tidx;
  int neighbor = 0;

  cbl_to_process = 0;
f0104ef5:	c7 05 f4 78 32 f0 00 	movl   $0x0,0xf03278f4
f0104efc:	00 00 00 
  cbl_next_free = 0;
f0104eff:	c7 05 80 68 2f f0 00 	movl   $0x0,0xf02f6880
f0104f06:	00 00 00 

  // clear all the memory
  memset(&cu_cbl, 0, DMA_CU_MAXCB * sizeof(struct tcb));
f0104f09:	68 00 10 00 00       	push   $0x1000
f0104f0e:	6a 00                	push   $0x0
f0104f10:	68 c0 68 32 f0       	push   $0xf03268c0
f0104f15:	e8 7f fd ff ff       	call   f0104c99 <memset>

  // loop through array and set the links
  for (tidx = 0; tidx<DMA_CU_MAXCB; tidx++) {
f0104f1a:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104f1f:	83 c4 10             	add    $0x10,%esp
    if (tidx == 0) {
      neighbor = DMA_CU_MAXCB - 1;
f0104f22:	b8 7f 00 00 00       	mov    $0x7f,%eax
f0104f27:	85 c9                	test   %ecx,%ecx
f0104f29:	74 03                	je     f0104f2e <init_cbl+0x3f>
    } else {
      neighbor = tidx - 1;
f0104f2b:	8d 41 ff             	lea    0xffffffff(%ecx),%eax
    }
    cu_cbl[neighbor].cb_header.link = PADDR((uint32_t) &cu_cbl[tidx]);
f0104f2e:	89 c2                	mov    %eax,%edx
f0104f30:	c1 e2 05             	shl    $0x5,%edx
f0104f33:	89 c8                	mov    %ecx,%eax
f0104f35:	c1 e0 05             	shl    $0x5,%eax
f0104f38:	05 c0 68 32 f0       	add    $0xf03268c0,%eax
f0104f3d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104f42:	77 12                	ja     f0104f56 <init_cbl+0x67>
f0104f44:	50                   	push   %eax
f0104f45:	68 54 62 10 f0       	push   $0xf0106254
f0104f4a:	6a 65                	push   $0x65
f0104f4c:	68 e3 72 10 f0       	push   $0xf01072e3
f0104f51:	e8 98 b1 ff ff       	call   f01000ee <_panic>
f0104f56:	05 00 00 00 10       	add    $0x10000000,%eax
f0104f5b:	89 82 c4 68 32 f0    	mov    %eax,0xf03268c4(%edx)
    cu_cbl[tidx].cb_header.status = CB_STATUS_PROCESSED;
f0104f61:	89 c8                	mov    %ecx,%eax
f0104f63:	c1 e0 05             	shl    $0x5,%eax
f0104f66:	66 c7 80 c0 68 32 f0 	movw   $0x8000,0xf03268c0(%eax)
f0104f6d:	00 80 

    // These values are always fixed for our purposes.  See page 92 of manual.
    // http://pdos.csail.mit.edu/6.828/2009/readings/8255X_OpenSDM.pdf
    cu_cbl[tidx].cb_header.cmd = 0; // change to 4 when ready to transmit
f0104f6f:	66 c7 80 c2 68 32 f0 	movw   $0x0,0xf03268c2(%eax)
f0104f76:	00 00 
    //cu_cbl[tidx].tbd_array_addr = 0xFFFFFFFF;
    //cu_cbl[tidx].tbd_count = 0;
    cu_cbl[tidx].thrs = 0xE0;
f0104f78:	c6 80 ce 68 32 f0 e0 	movb   $0xe0,0xf03268ce(%eax)

    // Challenge
    cu_cbl[tidx].tbd_array_addr = PADDR(&cu_cbl[tidx].tbd);
f0104f7f:	89 c2                	mov    %eax,%edx
f0104f81:	8d 80 d0 68 32 f0    	lea    0xf03268d0(%eax),%eax
f0104f87:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104f8c:	77 12                	ja     f0104fa0 <init_cbl+0xb1>
f0104f8e:	50                   	push   %eax
f0104f8f:	68 54 62 10 f0       	push   $0xf0106254
f0104f94:	6a 70                	push   $0x70
f0104f96:	68 e3 72 10 f0       	push   $0xf01072e3
f0104f9b:	e8 4e b1 ff ff       	call   f01000ee <_panic>
f0104fa0:	05 00 00 00 10       	add    $0x10000000,%eax
f0104fa5:	89 82 c8 68 32 f0    	mov    %eax,0xf03268c8(%edx)
    cu_cbl[tidx].tbd_count = 1; // 1:1 mapping
f0104fab:	89 c8                	mov    %ecx,%eax
f0104fad:	c1 e0 05             	shl    $0x5,%eax
f0104fb0:	c6 80 cf 68 32 f0 01 	movb   $0x1,0xf03268cf(%eax)
f0104fb7:	41                   	inc    %ecx
f0104fb8:	83 f9 7f             	cmp    $0x7f,%ecx
f0104fbb:	0f 8e 61 ff ff ff    	jle    f0104f22 <init_cbl+0x33>
  }
}
f0104fc1:	c9                   	leave  
f0104fc2:	c3                   	ret    

f0104fc3 <init_rfa>:

/**
 * Builds the RFA
 */
void init_rfa(void) {
f0104fc3:	55                   	push   %ebp
f0104fc4:	89 e5                	mov    %esp,%ebp
f0104fc6:	57                   	push   %edi
f0104fc7:	56                   	push   %esi
f0104fc8:	53                   	push   %ebx
f0104fc9:	83 ec 10             	sub    $0x10,%esp
  int tidx;
  int neighbor = 0;

  rfd_to_process = 0;
f0104fcc:	c7 05 ac 68 32 f0 00 	movl   $0x0,0xf03268ac
f0104fd3:	00 00 00 
  //cbl_to_process = 0;
  //cbl_next_free = 0;

  // clear all the memory
  memset(&ru_rfa, 0, DMA_RU_SIZE * sizeof(struct rfd));
f0104fd6:	68 00 12 00 00       	push   $0x1200
f0104fdb:	6a 00                	push   $0x0
f0104fdd:	68 a0 68 2f f0       	push   $0xf02f68a0
f0104fe2:	e8 b2 fc ff ff       	call   f0104c99 <memset>

  // Challenge
  memset(rbds, 0, DMA_RU_SIZE * sizeof(struct rbd));
f0104fe7:	83 c4 0c             	add    $0xc,%esp
f0104fea:	6a 30                	push   $0x30
f0104fec:	6a 00                	push   $0x0
f0104fee:	68 c0 78 32 f0       	push   $0xf03278c0
f0104ff3:	e8 a1 fc ff ff       	call   f0104c99 <memset>

  // loop through array and set the links
  for (tidx = 0; tidx<DMA_RU_SIZE; tidx++) {
f0104ff8:	be 00 00 00 00       	mov    $0x0,%esi
f0104ffd:	83 c4 10             	add    $0x10,%esp
    //cprintf("********* dma item: %d\n", tidx);
    if (tidx == 0) {
      neighbor = DMA_RU_SIZE - 1;
f0105000:	b8 02 00 00 00       	mov    $0x2,%eax
f0105005:	85 f6                	test   %esi,%esi
f0105007:	74 03                	je     f010500c <init_rfa+0x49>
    } else {
      neighbor = tidx - 1;
f0105009:	8d 46 ff             	lea    0xffffffff(%esi),%eax
    }
    ru_rfa[neighbor].header.link = PADDR((uint32_t) &ru_rfa[tidx]);
f010500c:	8d 04 40             	lea    (%eax,%eax,2),%eax
f010500f:	89 c2                	mov    %eax,%edx
f0105011:	c1 e2 09             	shl    $0x9,%edx
f0105014:	8d 04 76             	lea    (%esi,%esi,2),%eax
f0105017:	c1 e0 09             	shl    $0x9,%eax
f010501a:	05 a0 68 2f f0       	add    $0xf02f68a0,%eax
f010501f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0105024:	77 15                	ja     f010503b <init_rfa+0x78>
f0105026:	50                   	push   %eax
f0105027:	68 54 62 10 f0       	push   $0xf0106254
f010502c:	68 8e 00 00 00       	push   $0x8e
f0105031:	68 e3 72 10 f0       	push   $0xf01072e3
f0105036:	e8 b3 b0 ff ff       	call   f01000ee <_panic>
f010503b:	05 00 00 00 10       	add    $0x10000000,%eax
f0105040:	89 82 a4 68 2f f0    	mov    %eax,0xf02f68a4(%edx)
    //ru_rfa[tidx].size = 1518;

    // Challenge
    ru_rfa[tidx].size = 0;
f0105046:	8d 04 76             	lea    (%esi,%esi,2),%eax
f0105049:	c1 e0 09             	shl    $0x9,%eax
f010504c:	66 c7 80 ae 68 2f f0 	movw   $0x0,0xf02f68ae(%eax)
f0105053:	00 00 
    ru_rfa[tidx].header.cmd |= TCBCOMMAND_SF;
f0105055:	66 83 88 a2 68 2f f0 	orw    $0x8,0xf02f68a2(%eax)
f010505c:	08 
    ru_rfa[tidx].reserved = PADDR(&rbds[tidx]);
f010505d:	89 c2                	mov    %eax,%edx
f010505f:	89 f0                	mov    %esi,%eax
f0105061:	c1 e0 04             	shl    $0x4,%eax
f0105064:	05 c0 78 32 f0       	add    $0xf03278c0,%eax
f0105069:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010506e:	77 15                	ja     f0105085 <init_rfa+0xc2>
f0105070:	50                   	push   %eax
f0105071:	68 54 62 10 f0       	push   $0xf0106254
f0105076:	68 94 00 00 00       	push   $0x94
f010507b:	68 e3 72 10 f0       	push   $0xf01072e3
f0105080:	e8 69 b0 ff ff       	call   f01000ee <_panic>
f0105085:	05 00 00 00 10       	add    $0x10000000,%eax
f010508a:	89 82 a8 68 2f f0    	mov    %eax,0xf02f68a8(%edx)
    rbds[tidx].count = MAX_PKT_SIZE;
f0105090:	89 f0                	mov    %esi,%eax
f0105092:	c1 e0 04             	shl    $0x4,%eax
f0105095:	c7 80 c0 78 32 f0 ee 	movl   $0x5ee,0xf03278c0(%eax)
f010509c:	05 00 00 
    rbds[tidx].link = PADDR(&rbds[(tidx+1)%DMA_RU_SIZE]);
f010509f:	89 c3                	mov    %eax,%ebx
f01050a1:	8d 4e 01             	lea    0x1(%esi),%ecx
f01050a4:	ba 03 00 00 00       	mov    $0x3,%edx
f01050a9:	89 c8                	mov    %ecx,%eax
f01050ab:	89 d7                	mov    %edx,%edi
f01050ad:	99                   	cltd   
f01050ae:	f7 ff                	idiv   %edi
f01050b0:	c1 e2 04             	shl    $0x4,%edx
f01050b3:	8d 8a c0 78 32 f0    	lea    0xf03278c0(%edx),%ecx
f01050b9:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f01050bf:	77 15                	ja     f01050d6 <init_rfa+0x113>
f01050c1:	51                   	push   %ecx
f01050c2:	68 54 62 10 f0       	push   $0xf0106254
f01050c7:	68 96 00 00 00       	push   $0x96
f01050cc:	68 e3 72 10 f0       	push   $0xf01072e3
f01050d1:	e8 18 b0 ff ff       	call   f01000ee <_panic>
f01050d6:	8d 81 00 00 00 10    	lea    0x10000000(%ecx),%eax
f01050dc:	89 83 c4 78 32 f0    	mov    %eax,0xf03278c4(%ebx)
    rbds[tidx].size = MAX_PKT_SIZE;
f01050e2:	89 f3                	mov    %esi,%ebx
f01050e4:	c1 e3 04             	shl    $0x4,%ebx
f01050e7:	c7 83 cc 78 32 f0 ee 	movl   $0x5ee,0xf03278cc(%ebx)
f01050ee:	05 00 00 

    struct Page *buffer_page = page_lookup(curenv->env_pgdir, buffer_zero + (tidx * PGSIZE), NULL);
f01050f1:	83 ec 04             	sub    $0x4,%esp
f01050f4:	6a 00                	push   $0x0
f01050f6:	89 f0                	mov    %esi,%eax
f01050f8:	c1 e0 0c             	shl    $0xc,%eax
f01050fb:	03 05 f0 78 32 f0    	add    0xf03278f0,%eax
f0105101:	50                   	push   %eax
f0105102:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0105107:	ff 70 5c             	pushl  0x5c(%eax)
f010510a:	e8 ae c9 ff ff       	call   f0101abd <page_lookup>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f010510f:	83 c4 10             	add    $0x10,%esp
f0105112:	2b 05 7c 68 2f f0    	sub    0xf02f687c,%eax
f0105118:	c1 f8 02             	sar    $0x2,%eax
f010511b:	8d 14 80             	lea    (%eax,%eax,4),%edx
f010511e:	8d 14 90             	lea    (%eax,%edx,4),%edx
f0105121:	8d 14 90             	lea    (%eax,%edx,4),%edx
f0105124:	89 d1                	mov    %edx,%ecx
f0105126:	c1 e1 08             	shl    $0x8,%ecx
f0105129:	01 ca                	add    %ecx,%edx
f010512b:	89 d1                	mov    %edx,%ecx
f010512d:	c1 e1 10             	shl    $0x10,%ecx
f0105130:	01 ca                	add    %ecx,%edx
f0105132:	8d 14 50             	lea    (%eax,%edx,2),%edx
f0105135:	c1 e2 0c             	shl    $0xc,%edx
f0105138:	83 c2 04             	add    $0x4,%edx
f010513b:	89 93 c8 78 32 f0    	mov    %edx,0xf03278c8(%ebx)
f0105141:	46                   	inc    %esi
f0105142:	83 fe 02             	cmp    $0x2,%esi
f0105145:	0f 8e b5 fe ff ff    	jle    f0105000 <init_rfa+0x3d>
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
f010514b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f010514e:	5b                   	pop    %ebx
f010514f:	5e                   	pop    %esi
f0105150:	5f                   	pop    %edi
f0105151:	c9                   	leave  
f0105152:	c3                   	ret    

f0105153 <e100_transmit_nop>:

void e100_transmit_nop(void) {
f0105153:	55                   	push   %ebp
f0105154:	89 e5                	mov    %esp,%ebp
f0105156:	83 ec 10             	sub    $0x10,%esp
  // Set a NOP
  cprintf("nop at cbl index: %08x\n", cbl_next_free);
f0105159:	ff 35 80 68 2f f0    	pushl  0xf02f6880
f010515f:	68 ef 72 10 f0       	push   $0xf01072ef
f0105164:	e8 61 df ff ff       	call   f01030ca <cprintf>
  cu_cbl[cbl_next_free].cb_header.status = 0;
f0105169:	8b 0d 80 68 2f f0    	mov    0xf02f6880,%ecx
f010516f:	89 c8                	mov    %ecx,%eax
f0105171:	c1 e0 05             	shl    $0x5,%eax
f0105174:	66 c7 80 c0 68 32 f0 	movw   $0x0,0xf03268c0(%eax)
f010517b:	00 00 
  cu_cbl[cbl_next_free].cb_header.cmd = TCB_NOP | TCB_S;
f010517d:	66 c7 80 c2 68 32 f0 	movw   $0x4000,0xf03268c2(%eax)
f0105184:	00 40 
  cbl_next_free = (cbl_next_free + 1) % DMA_CU_MAXCB; // should be = 1
f0105186:	8d 51 01             	lea    0x1(%ecx),%edx
f0105189:	89 d0                	mov    %edx,%eax
f010518b:	85 d2                	test   %edx,%edx
f010518d:	79 06                	jns    f0105195 <e100_transmit_nop+0x42>
f010518f:	8d 81 80 00 00 00    	lea    0x80(%ecx),%eax
f0105195:	83 e0 80             	and    $0xffffff80,%eax
f0105198:	29 c2                	sub    %eax,%edx
f010519a:	89 15 80 68 2f f0    	mov    %edx,0xf02f6880
  cprintf("cbl_to_process now moved to: %08x\n", cbl_next_free);
f01051a0:	83 c4 08             	add    $0x8,%esp
f01051a3:	52                   	push   %edx
f01051a4:	68 c0 72 10 f0       	push   $0xf01072c0
f01051a9:	e8 1c df ff ff       	call   f01030ca <cprintf>
}
f01051ae:	c9                   	leave  
f01051af:	c3                   	ret    

f01051b0 <e100_transmit_packet>:

/**
 * Transmit a packet
Modify this for the zero-copy write challenge question.  No longer perform a memmove, and instead just shove in the buffer.
 */
int e100_transmit_packet(char* packet, int pktsize) {
f01051b0:	55                   	push   %ebp
f01051b1:	89 e5                	mov    %esp,%ebp
f01051b3:	56                   	push   %esi
f01051b4:	53                   	push   %ebx
  int tcb_empty;
  char scb_issued;
  int cbl_prev = cbl_next_free;
f01051b5:	8b 1d 80 68 2f f0    	mov    0xf02f6880,%ebx

  // Step 0: Move the 'head' to the next unprocessed packet
  int start = cbl_to_process;
f01051bb:	8b 35 f4 78 32 f0    	mov    0xf03278f4,%esi
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
f01051c1:	89 f0                	mov    %esi,%eax
f01051c3:	c1 e0 05             	shl    $0x5,%eax
f01051c6:	66 8b 80 c0 68 32 f0 	mov    0xf03268c0(%eax),%ax
f01051cd:	66 3d 00 80          	cmp    $0x8000,%ax
f01051d1:	75 3c                	jne    f010520f <e100_transmit_packet+0x5f>
f01051d3:	39 de                	cmp    %ebx,%esi
f01051d5:	74 38                	je     f010520f <e100_transmit_packet+0x5f>
f01051d7:	89 f1                	mov    %esi,%ecx
f01051d9:	8d 51 01             	lea    0x1(%ecx),%edx
f01051dc:	89 d0                	mov    %edx,%eax
f01051de:	85 d2                	test   %edx,%edx
f01051e0:	79 06                	jns    f01051e8 <e100_transmit_packet+0x38>
f01051e2:	8d 81 80 00 00 00    	lea    0x80(%ecx),%eax
f01051e8:	83 e0 80             	and    $0xffffff80,%eax
f01051eb:	29 c2                	sub    %eax,%edx
f01051ed:	89 d1                	mov    %edx,%ecx
f01051ef:	39 f2                	cmp    %esi,%edx
f01051f1:	74 16                	je     f0105209 <e100_transmit_packet+0x59>
f01051f3:	89 d0                	mov    %edx,%eax
f01051f5:	c1 e0 05             	shl    $0x5,%eax
f01051f8:	66 8b 80 c0 68 32 f0 	mov    0xf03268c0(%eax),%ax
f01051ff:	66 3d 00 80          	cmp    $0x8000,%ax
f0105203:	75 04                	jne    f0105209 <e100_transmit_packet+0x59>
f0105205:	39 da                	cmp    %ebx,%edx
f0105207:	75 d0                	jne    f01051d9 <e100_transmit_packet+0x29>
f0105209:	89 0d f4 78 32 f0    	mov    %ecx,0xf03278f4
    }
  }
  cprintf("transmit at cbl index: %08x\n", cbl_next_free);
f010520f:	83 ec 08             	sub    $0x8,%esp
f0105212:	ff 35 80 68 2f f0    	pushl  0xf02f6880
f0105218:	68 07 73 10 f0       	push   $0xf0107307
f010521d:	e8 a8 de ff ff       	call   f01030ca <cprintf>

  // Step 1: 
  // Check if there is room to copy in the packet 
  if (!(cu_cbl[cbl_next_free].cb_header.status & CB_STATUS_PROCESSED)) {
f0105222:	a1 80 68 2f f0       	mov    0xf02f6880,%eax
f0105227:	c1 e0 05             	shl    $0x5,%eax
f010522a:	83 c4 10             	add    $0x10,%esp
f010522d:	66 8b 80 c0 68 32 f0 	mov    0xf03268c0(%eax),%ax
    // no memory because you've circled back on the DMA ring
    return -E100_NO_MEM;
f0105234:	ba 9c ff ff ff       	mov    $0xffffff9c,%edx
f0105239:	66 85 c0             	test   %ax,%ax
f010523c:	0f 89 e7 00 00 00    	jns    f0105329 <e100_transmit_packet+0x179>
  }

  cprintf("prior to writing memory");
f0105242:	83 ec 0c             	sub    $0xc,%esp
f0105245:	68 24 73 10 f0       	push   $0xf0107324
f010524a:	e8 7b de ff ff       	call   f01030ca <cprintf>

  // Step 2:
  // Write the next TCB
  cu_cbl[cbl_next_free].cb_header.status = 0; // reset the CB's status
f010524f:	8b 1d 80 68 2f f0    	mov    0xf02f6880,%ebx
f0105255:	c1 e3 05             	shl    $0x5,%ebx
f0105258:	66 c7 83 c0 68 32 f0 	movw   $0x0,0xf03268c0(%ebx)
f010525f:	00 00 
  //cu_cbl[cbl_next_free].cb_header.cmd = 0x4 | TCB_S; // transmit
  //cu_cbl[cbl_next_free].tcb_byte_count = pktsize;
  //memmove((void *)cu_cbl[cbl_next_free].data, (void *)packet, pktsize);

  // Challenge:
  cu_cbl[cbl_next_free].tcb_byte_count = 0;
f0105261:	66 c7 83 cc 68 32 f0 	movw   $0x0,0xf03268cc(%ebx)
f0105268:	00 00 
  cu_cbl[cbl_next_free].cb_header.cmd = TCBCOMMAND_TRANSMIT | TCB_S | TCBCOMMAND_SF;
f010526a:	66 c7 83 c2 68 32 f0 	movw   $0x400c,0xf03268c2(%ebx)
f0105271:	0c 40 
  cu_cbl[cbl_next_free].tbd.buffer_address = page2pa(page_lookup(curenv->env_pgdir, (void *)packet, 0)) + sizeof(int); // plus sizeof(int) because u need to avoid the packet size at the front
f0105273:	81 c3 c0 68 32 f0    	add    $0xf03268c0,%ebx
}

static inline physaddr_t
page2pa(struct Page *pp)
{
f0105279:	83 c4 0c             	add    $0xc,%esp
f010527c:	6a 00                	push   $0x0
f010527e:	ff 75 08             	pushl  0x8(%ebp)
f0105281:	a1 c4 5b 2f f0       	mov    0xf02f5bc4,%eax
f0105286:	ff 70 5c             	pushl  0x5c(%eax)
f0105289:	e8 2f c8 ff ff       	call   f0101abd <page_lookup>
f010528e:	83 c4 10             	add    $0x10,%esp
f0105291:	2b 05 7c 68 2f f0    	sub    0xf02f687c,%eax
f0105297:	c1 f8 02             	sar    $0x2,%eax
f010529a:	8d 14 80             	lea    (%eax,%eax,4),%edx
f010529d:	8d 14 90             	lea    (%eax,%edx,4),%edx
f01052a0:	8d 14 90             	lea    (%eax,%edx,4),%edx
f01052a3:	89 d1                	mov    %edx,%ecx
f01052a5:	c1 e1 08             	shl    $0x8,%ecx
f01052a8:	01 ca                	add    %ecx,%edx
f01052aa:	89 d1                	mov    %edx,%ecx
f01052ac:	c1 e1 10             	shl    $0x10,%ecx
f01052af:	01 ca                	add    %ecx,%edx
f01052b1:	8d 14 50             	lea    (%eax,%edx,2),%edx
f01052b4:	c1 e2 0c             	shl    $0xc,%edx
f01052b7:	83 c2 04             	add    $0x4,%edx
f01052ba:	89 53 10             	mov    %edx,0x10(%ebx)
  cu_cbl[cbl_next_free].tbd.buffer_size = pktsize;
f01052bd:	a1 80 68 2f f0       	mov    0xf02f6880,%eax
f01052c2:	c1 e0 05             	shl    $0x5,%eax
f01052c5:	8b 55 0c             	mov    0xc(%ebp),%edx
f01052c8:	89 90 d4 68 32 f0    	mov    %edx,0xf03268d4(%eax)

  // Step 3:
  // Set the suspend bit
  // Done in previous step
  //cu_cbl[cbl_next_free].cb_header.cmd |= TCB_S;
  
  // Step 4:
  // Clear the suspend bit of the TCB in the list (no longer last)
  if (cbl_next_free == 0) cbl_prev = DMA_CU_MAXCB - 1;
f01052ce:	bb 7f 00 00 00       	mov    $0x7f,%ebx
f01052d3:	83 3d 80 68 2f f0 00 	cmpl   $0x0,0xf02f6880
f01052da:	74 07                	je     f01052e3 <e100_transmit_packet+0x133>
  else {
    cbl_prev = cbl_next_free - 1;
f01052dc:	8b 1d 80 68 2f f0    	mov    0xf02f6880,%ebx
f01052e2:	4b                   	dec    %ebx
  }
  cprintf("cbl_prev: %08x", cbl_prev);
f01052e3:	83 ec 08             	sub    $0x8,%esp
f01052e6:	53                   	push   %ebx
f01052e7:	68 3c 73 10 f0       	push   $0xf010733c
f01052ec:	e8 d9 dd ff ff       	call   f01030ca <cprintf>
  cu_cbl[cbl_prev].cb_header.cmd &= ~TCB_S;
f01052f1:	89 d8                	mov    %ebx,%eax
f01052f3:	c1 e0 05             	shl    $0x5,%eax
f01052f6:	66 81 a0 c2 68 32 f0 	andw   $0xbfff,0xf03268c2(%eax)
f01052fd:	ff bf 

  // Move the next_free index
  cbl_next_free = (cbl_next_free + 1) % DMA_CU_MAXCB;
f01052ff:	8b 0d 80 68 2f f0    	mov    0xf02f6880,%ecx
f0105305:	8d 51 01             	lea    0x1(%ecx),%edx
f0105308:	89 d0                	mov    %edx,%eax
f010530a:	85 d2                	test   %edx,%edx
f010530c:	79 06                	jns    f0105314 <e100_transmit_packet+0x164>
f010530e:	8d 81 80 00 00 00    	lea    0x80(%ecx),%eax
f0105314:	83 e0 80             	and    $0xffffff80,%eax
f0105317:	29 c2                	sub    %eax,%edx
f0105319:	89 15 80 68 2f f0    	mov    %edx,0xf02f6880

  cu_resume();
f010531f:	e8 f2 00 00 00       	call   f0105416 <cu_resume>
  //cu_start();
  return 0;
f0105324:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0105329:	89 d0                	mov    %edx,%eax
f010532b:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f010532e:	5b                   	pop    %ebx
f010532f:	5e                   	pop    %esi
f0105330:	c9                   	leave  
f0105331:	c3                   	ret    

f0105332 <cu_start>:


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
f0105332:	55                   	push   %ebp
f0105333:	89 e5                	mov    %esp,%ebp
f0105335:	83 ec 14             	sub    $0x14,%esp
  cprintf("Entering start CU\n");
f0105338:	68 4b 73 10 f0       	push   $0xf010734b
f010533d:	e8 88 dd ff ff       	call   f01030ca <cprintf>
}

static __inline uint8_t
inb(int port)
{
f0105342:	83 c4 10             	add    $0x10,%esp
f0105345:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f010534b:	ec                   	in     (%dx),%al
  char cu_status;
  char scb_issued;

  // Start the CU if it's idle
  cu_status = inb(iobase + SCB_STATUS_OFFSET);

  // Step 4:
  // Restart CU if idle or suspended
  // Page 46, must do this check
  if ((cu_status>>4 == CU_STATUS_IDLE) || (cu_status>>4 == CU_STATUS_SUSPENDED)) {
f010534c:	c0 f8 04             	sar    $0x4,%al
f010534f:	3c 01                	cmp    $0x1,%al
f0105351:	77 72                	ja     f01053c5 <cu_start+0x93>
    cprintf("Starting CU...\n");
f0105353:	83 ec 0c             	sub    $0xc,%esp
f0105356:	68 5e 73 10 f0       	push   $0xf010735e
f010535b:	e8 6a dd ff ff       	call   f01030ca <cprintf>
}

static __inline void
outl(int port, uint32_t data)
{
f0105360:	83 c4 10             	add    $0x10,%esp
f0105363:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f0105369:	83 c2 04             	add    $0x4,%edx

    outl(iobase + SCB_GENERAL_POINTER_OFFSET, PADDR(&cu_cbl[cbl_to_process]));
f010536c:	a1 f4 78 32 f0       	mov    0xf03278f4,%eax
f0105371:	c1 e0 05             	shl    $0x5,%eax
f0105374:	05 c0 68 32 f0       	add    $0xf03268c0,%eax
f0105379:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010537e:	77 15                	ja     f0105395 <cu_start+0x63>
f0105380:	50                   	push   %eax
f0105381:	68 54 62 10 f0       	push   $0xf0106254
f0105386:	68 56 01 00 00       	push   $0x156
f010538b:	68 e3 72 10 f0       	push   $0xf01072e3
f0105390:	e8 59 ad ff ff       	call   f01000ee <_panic>
f0105395:	05 00 00 00 10       	add    $0x10000000,%eax

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010539a:	ef                   	out    %eax,(%dx)
f010539b:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f01053a1:	83 c2 02             	add    $0x2,%edx
f01053a4:	b0 10                	mov    $0x10,%al
f01053a6:	ee                   	out    %al,(%dx)
f01053a7:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f01053ad:	83 c2 02             	add    $0x2,%edx
f01053b0:	ec                   	in     (%dx),%al
    outb(iobase + SCB_COMMAND_OFFSET, CUC_CU_START);

    // wait until command goes through, pg. 45
    // The Command byte is cleared by the 8255x indicating command acceptance.
    do {
      scb_issued = inb(iobase + SCB_COMMAND_OFFSET);
    } while (scb_issued != 0);
f01053b1:	84 c0                	test   %al,%al
f01053b3:	75 fb                	jne    f01053b0 <cu_start+0x7e>

    cprintf("CU Started.\n");
f01053b5:	83 ec 0c             	sub    $0xc,%esp
f01053b8:	68 6e 73 10 f0       	push   $0xf010736e
f01053bd:	e8 08 dd ff ff       	call   f01030ca <cprintf>
f01053c2:	83 c4 10             	add    $0x10,%esp
  }

}
f01053c5:	c9                   	leave  
f01053c6:	c3                   	ret    

f01053c7 <ru_start>:

void ru_start(void) {
f01053c7:	55                   	push   %ebp
f01053c8:	89 e5                	mov    %esp,%ebp
f01053ca:	83 ec 08             	sub    $0x8,%esp
}

static __inline void
outl(int port, uint32_t data)
{
f01053cd:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f01053d3:	83 c2 04             	add    $0x4,%edx
  outl(iobase + SCB_GENERAL_POINTER_OFFSET, PADDR(&ru_rfa[rfd_to_process]));
f01053d6:	a1 ac 68 32 f0       	mov    0xf03268ac,%eax
f01053db:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01053de:	c1 e0 09             	shl    $0x9,%eax
f01053e1:	05 a0 68 2f f0       	add    $0xf02f68a0,%eax
f01053e6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01053eb:	77 15                	ja     f0105402 <ru_start+0x3b>
f01053ed:	50                   	push   %eax
f01053ee:	68 54 62 10 f0       	push   $0xf0106254
f01053f3:	68 65 01 00 00       	push   $0x165
f01053f8:	68 e3 72 10 f0       	push   $0xf01072e3
f01053fd:	e8 ec ac ff ff       	call   f01000ee <_panic>
f0105402:	05 00 00 00 10       	add    $0x10000000,%eax

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0105407:	ef                   	out    %eax,(%dx)
f0105408:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f010540e:	83 c2 02             	add    $0x2,%edx
f0105411:	b0 01                	mov    $0x1,%al
f0105413:	ee                   	out    %al,(%dx)
  outb(iobase + SCB_COMMAND_OFFSET, RU_START);
}
f0105414:	c9                   	leave  
f0105415:	c3                   	ret    

f0105416 <cu_resume>:

/**
 * Resume the CU, since it goes inactive after completing each operation.
 */
void cu_resume(void) {
f0105416:	55                   	push   %ebp
f0105417:	89 e5                	mov    %esp,%ebp
f0105419:	83 ec 14             	sub    $0x14,%esp
}

static __inline uint8_t
inb(int port)
{
f010541c:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105422:	ec                   	in     (%dx),%al
  char cu_status;
  char scb_issued;

  // Start the CU if it's idle
  cu_status = inb(iobase + SCB_STATUS_OFFSET);

  cprintf("Resuming CU...\n");
f0105423:	68 7b 73 10 f0       	push   $0xf010737b
f0105428:	e8 9d dc ff ff       	call   f01030ca <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
f010542d:	83 c4 10             	add    $0x10,%esp
f0105430:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f0105436:	83 c2 02             	add    $0x2,%edx
f0105439:	b0 20                	mov    $0x20,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010543b:	ee                   	out    %al,(%dx)
f010543c:	8b 15 00 8b 32 f0    	mov    0xf0328b00,%edx
f0105442:	83 c2 02             	add    $0x2,%edx
f0105445:	ec                   	in     (%dx),%al
  outb(iobase + SCB_COMMAND_OFFSET, CUC_CU_RESUME);

  // wait until command goes through, pg. 45
  // The Command byte is cleared by the 8255x indicating command acceptance.
  do {
    scb_issued = inb(iobase + SCB_COMMAND_OFFSET);
  } while (scb_issued != 0);
f0105446:	84 c0                	test   %al,%al
f0105448:	75 fb                	jne    f0105445 <cu_resume+0x2f>

  cprintf("CU resumed.\n");
f010544a:	83 ec 0c             	sub    $0xc,%esp
f010544d:	68 8b 73 10 f0       	push   $0xf010738b
f0105452:	e8 73 dc ff ff       	call   f01030ca <cprintf>
}
f0105457:	c9                   	leave  
f0105458:	c3                   	ret    

f0105459 <e100_receive_packet_zerocopy>:

int
e100_receive_packet_zerocopy(int* size) {
f0105459:	55                   	push   %ebp
f010545a:	89 e5                	mov    %esp,%ebp
f010545c:	53                   	push   %ebx
f010545d:	83 ec 04             	sub    $0x4,%esp
  if (ru_rfa[rfd_to_process].header.status & CB_STATUS_PROCESSED) {
f0105460:	8b 15 ac 68 32 f0    	mov    0xf03268ac,%edx
f0105466:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0105469:	c1 e0 09             	shl    $0x9,%eax
f010546c:	66 8b 80 a0 68 2f f0 	mov    0xf02f68a0(%eax),%ax
    //struct jif_pkt* packet;
    //packet = (struct jif_pkt*) (&buffer_zero + (rfd_to_process * PGSIZE));
    *size = rbds[rfd_to_process].count & 0x3fff;
    //*(int *)(&buffer_zero + (rfd_to_process * PGSIZE)) = size;
    ru_rfa[rfd_to_process].header.status = 0;
    rfd_to_process = (rfd_to_process + 1) % DMA_RU_SIZE;
    return 0;
  }
  return -1;
f0105473:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0105478:	66 85 c0             	test   %ax,%ax
f010547b:	79 45                	jns    f01054c2 <e100_receive_packet_zerocopy+0x69>
f010547d:	89 d0                	mov    %edx,%eax
f010547f:	c1 e0 04             	shl    $0x4,%eax
f0105482:	8b 90 c0 78 32 f0    	mov    0xf03278c0(%eax),%edx
f0105488:	81 e2 ff 3f 00 00    	and    $0x3fff,%edx
f010548e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105491:	89 10                	mov    %edx,(%eax)
f0105493:	8b 15 ac 68 32 f0    	mov    0xf03268ac,%edx
f0105499:	8d 04 52             	lea    (%edx,%edx,2),%eax
f010549c:	c1 e0 09             	shl    $0x9,%eax
f010549f:	66 c7 80 a0 68 2f f0 	movw   $0x0,0xf02f68a0(%eax)
f01054a6:	00 00 
f01054a8:	8d 4a 01             	lea    0x1(%edx),%ecx
f01054ab:	ba 03 00 00 00       	mov    $0x3,%edx
f01054b0:	89 c8                	mov    %ecx,%eax
f01054b2:	89 d3                	mov    %edx,%ebx
f01054b4:	99                   	cltd   
f01054b5:	f7 fb                	idiv   %ebx
f01054b7:	89 15 ac 68 32 f0    	mov    %edx,0xf03268ac
f01054bd:	b9 00 00 00 00       	mov    $0x0,%ecx
}
f01054c2:	89 c8                	mov    %ecx,%eax
f01054c4:	83 c4 04             	add    $0x4,%esp
f01054c7:	5b                   	pop    %ebx
f01054c8:	c9                   	leave  
f01054c9:	c3                   	ret    

f01054ca <e100_receive_packet>:

int
e100_receive_packet(char *packet, int *size) {
f01054ca:	55                   	push   %ebp
f01054cb:	89 e5                	mov    %esp,%ebp
f01054cd:	53                   	push   %ebx
f01054ce:	83 ec 04             	sub    $0x4,%esp

  uint32_t packet_paddr;
  void *packet_obj;

  if (ru_rfa[rfd_to_process].header.status & CB_STATUS_PROCESSED) {
f01054d1:	a1 ac 68 32 f0       	mov    0xf03268ac,%eax
f01054d6:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01054d9:	89 c2                	mov    %eax,%edx
f01054db:	c1 e2 09             	shl    $0x9,%edx
f01054de:	66 8b 82 a0 68 2f f0 	mov    0xf02f68a0(%edx),%ax
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
f01054e5:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f01054ea:	66 85 c0             	test   %ax,%ax
f01054ed:	79 5e                	jns    f010554d <e100_receive_packet+0x83>
f01054ef:	0f b7 92 ac 68 2f f0 	movzwl 0xf02f68ac(%edx),%edx
f01054f6:	81 e2 ff 3f 00 00    	and    $0x3fff,%edx
f01054fc:	8b 45 0c             	mov    0xc(%ebp),%eax
f01054ff:	89 10                	mov    %edx,(%eax)
f0105501:	83 ec 04             	sub    $0x4,%esp
f0105504:	52                   	push   %edx
f0105505:	a1 ac 68 32 f0       	mov    0xf03268ac,%eax
f010550a:	8d 04 40             	lea    (%eax,%eax,2),%eax
f010550d:	c1 e0 09             	shl    $0x9,%eax
f0105510:	05 b0 68 2f f0       	add    $0xf02f68b0,%eax
f0105515:	50                   	push   %eax
f0105516:	ff 75 08             	pushl  0x8(%ebp)
f0105519:	e8 ce f7 ff ff       	call   f0104cec <memmove>
f010551e:	8b 15 ac 68 32 f0    	mov    0xf03268ac,%edx
f0105524:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0105527:	c1 e0 09             	shl    $0x9,%eax
f010552a:	66 c7 80 a0 68 2f f0 	movw   $0x0,0xf02f68a0(%eax)
f0105531:	00 00 
f0105533:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105536:	ba 03 00 00 00       	mov    $0x3,%edx
f010553b:	89 c8                	mov    %ecx,%eax
f010553d:	89 d3                	mov    %edx,%ebx
f010553f:	99                   	cltd   
f0105540:	f7 fb                	idiv   %ebx
f0105542:	89 15 ac 68 32 f0    	mov    %edx,0xf03268ac
f0105548:	b9 00 00 00 00       	mov    $0x0,%ecx
}
f010554d:	89 c8                	mov    %ecx,%eax
f010554f:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0105552:	c9                   	leave  
f0105553:	c3                   	ret    

f0105554 <e100_map_receive_buffers>:

int
e100_map_receive_buffers(char *first_buffer) {
f0105554:	55                   	push   %ebp
f0105555:	89 e5                	mov    %esp,%ebp
f0105557:	83 ec 08             	sub    $0x8,%esp
  buffer_zero = first_buffer;
f010555a:	8b 45 08             	mov    0x8(%ebp),%eax
f010555d:	a3 f0 78 32 f0       	mov    %eax,0xf03278f0
  init_rfa();
f0105562:	e8 5c fa ff ff       	call   f0104fc3 <init_rfa>
  ru_start();
f0105567:	e8 5b fe ff ff       	call   f01053c7 <ru_start>
  return 0;
}
f010556c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105571:	c9                   	leave  
f0105572:	c3                   	ret    
	...

f0105574 <pci_conf1_set_addr>:
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f0105574:	55                   	push   %ebp
f0105575:	89 e5                	mov    %esp,%ebp
f0105577:	53                   	push   %ebx
f0105578:	83 ec 04             	sub    $0x4,%esp
f010557b:	8b 45 08             	mov    0x8(%ebp),%eax
f010557e:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105581:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0105584:	8b 4d 14             	mov    0x14(%ebp),%ecx
	assert(bus < 256);
f0105587:	3d ff 00 00 00       	cmp    $0xff,%eax
f010558c:	76 16                	jbe    f01055a4 <pci_conf1_set_addr+0x30>
f010558e:	68 98 73 10 f0       	push   $0xf0107398
f0105593:	68 44 68 10 f0       	push   $0xf0106844
f0105598:	6a 2b                	push   $0x2b
f010559a:	68 a2 73 10 f0       	push   $0xf01073a2
f010559f:	e8 4a ab ff ff       	call   f01000ee <_panic>
	assert(dev < 32);
f01055a4:	83 fa 1f             	cmp    $0x1f,%edx
f01055a7:	76 16                	jbe    f01055bf <pci_conf1_set_addr+0x4b>
f01055a9:	68 ad 73 10 f0       	push   $0xf01073ad
f01055ae:	68 44 68 10 f0       	push   $0xf0106844
f01055b3:	6a 2c                	push   $0x2c
f01055b5:	68 a2 73 10 f0       	push   $0xf01073a2
f01055ba:	e8 2f ab ff ff       	call   f01000ee <_panic>
	assert(func < 8);
f01055bf:	83 fb 07             	cmp    $0x7,%ebx
f01055c2:	76 16                	jbe    f01055da <pci_conf1_set_addr+0x66>
f01055c4:	68 b6 73 10 f0       	push   $0xf01073b6
f01055c9:	68 44 68 10 f0       	push   $0xf0106844
f01055ce:	6a 2d                	push   $0x2d
f01055d0:	68 a2 73 10 f0       	push   $0xf01073a2
f01055d5:	e8 14 ab ff ff       	call   f01000ee <_panic>
	assert(offset < 256);
f01055da:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
f01055e0:	76 16                	jbe    f01055f8 <pci_conf1_set_addr+0x84>
f01055e2:	68 bf 73 10 f0       	push   $0xf01073bf
f01055e7:	68 44 68 10 f0       	push   $0xf0106844
f01055ec:	6a 2e                	push   $0x2e
f01055ee:	68 a2 73 10 f0       	push   $0xf01073a2
f01055f3:	e8 f6 aa ff ff       	call   f01000ee <_panic>
	assert((offset & 0x3) == 0);
f01055f8:	f6 c1 03             	test   $0x3,%cl
f01055fb:	74 16                	je     f0105613 <pci_conf1_set_addr+0x9f>
f01055fd:	68 cc 73 10 f0       	push   $0xf01073cc
f0105602:	68 44 68 10 f0       	push   $0xf0106844
f0105607:	6a 2f                	push   $0x2f
f0105609:	68 a2 73 10 f0       	push   $0xf01073a2
f010560e:	e8 db aa ff ff       	call   f01000ee <_panic>
	
	uint32_t v = (1 << 31) |		// config-space
f0105613:	c1 e0 10             	shl    $0x10,%eax
f0105616:	c1 e2 0b             	shl    $0xb,%edx
f0105619:	09 d0                	or     %edx,%eax
f010561b:	89 da                	mov    %ebx,%edx
f010561d:	c1 e2 08             	shl    $0x8,%edx
f0105620:	09 d0                	or     %edx,%eax
f0105622:	09 c8                	or     %ecx,%eax
}

static __inline void
outl(int port, uint32_t data)
{
f0105624:	8b 15 a0 56 12 f0    	mov    0xf01256a0,%edx
f010562a:	0d 00 00 00 80       	or     $0x80000000,%eax
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010562f:	ef                   	out    %eax,(%dx)
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
	outl(pci_conf1_addr_ioport, v);
}
f0105630:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
f0105633:	c9                   	leave  
f0105634:	c3                   	ret    

f0105635 <pci_conf_read>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f0105635:	55                   	push   %ebp
f0105636:	89 e5                	mov    %esp,%ebp
f0105638:	83 ec 08             	sub    $0x8,%esp
f010563b:	8b 45 08             	mov    0x8(%ebp),%eax
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010563e:	ff 75 0c             	pushl  0xc(%ebp)
f0105641:	ff 70 08             	pushl  0x8(%eax)
f0105644:	ff 70 04             	pushl  0x4(%eax)
f0105647:	8b 00                	mov    (%eax),%eax
f0105649:	ff 70 04             	pushl  0x4(%eax)
f010564c:	e8 23 ff ff ff       	call   f0105574 <pci_conf1_set_addr>
}

static __inline uint32_t
inl(int port)
{
f0105651:	83 c4 10             	add    $0x10,%esp
f0105654:	8b 15 a4 56 12 f0    	mov    0xf01256a4,%edx
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f010565a:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f010565b:	c9                   	leave  
f010565c:	c3                   	ret    

f010565d <pci_conf_write>:

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f010565d:	55                   	push   %ebp
f010565e:	89 e5                	mov    %esp,%ebp
f0105660:	83 ec 08             	sub    $0x8,%esp
f0105663:	8b 45 08             	mov    0x8(%ebp),%eax
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0105666:	ff 75 0c             	pushl  0xc(%ebp)
f0105669:	ff 70 08             	pushl  0x8(%eax)
f010566c:	ff 70 04             	pushl  0x4(%eax)
f010566f:	8b 00                	mov    (%eax),%eax
f0105671:	ff 70 04             	pushl  0x4(%eax)
f0105674:	e8 fb fe ff ff       	call   f0105574 <pci_conf1_set_addr>
}

static __inline void
outl(int port, uint32_t data)
{
f0105679:	83 c4 10             	add    $0x10,%esp
f010567c:	8b 15 a4 56 12 f0    	mov    0xf01256a4,%edx
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0105682:	8b 45 10             	mov    0x10(%ebp),%eax
f0105685:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f0105686:	c9                   	leave  
f0105687:	c3                   	ret    

f0105688 <pci_attach_match>:

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0105688:	55                   	push   %ebp
f0105689:	89 e5                	mov    %esp,%ebp
f010568b:	57                   	push   %edi
f010568c:	56                   	push   %esi
f010568d:	53                   	push   %ebx
f010568e:	83 ec 0c             	sub    $0xc,%esp
f0105691:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105694:	8b 75 10             	mov    0x10(%ebp),%esi
	uint32_t i;
	
	for (i = 0; list[i].attachfn; i++) {
f0105697:	bb 00 00 00 00       	mov    $0x0,%ebx
f010569c:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
f01056a0:	74 50                	je     f01056f2 <pci_attach_match+0x6a>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f01056a2:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01056a5:	c1 e0 02             	shl    $0x2,%eax
f01056a8:	39 3c 30             	cmp    %edi,(%eax,%esi,1)
f01056ab:	75 3a                	jne    f01056e7 <pci_attach_match+0x5f>
f01056ad:	8b 55 0c             	mov    0xc(%ebp),%edx
f01056b0:	39 54 30 04          	cmp    %edx,0x4(%eax,%esi,1)
f01056b4:	75 31                	jne    f01056e7 <pci_attach_match+0x5f>
			int r = list[i].attachfn(pcif);
f01056b6:	83 ec 0c             	sub    $0xc,%esp
f01056b9:	ff 75 14             	pushl  0x14(%ebp)
f01056bc:	ff 54 30 08          	call   *0x8(%eax,%esi,1)
			if (r > 0)
f01056c0:	83 c4 10             	add    $0x10,%esp
f01056c3:	85 c0                	test   %eax,%eax
f01056c5:	7f 30                	jg     f01056f7 <pci_attach_match+0x6f>
				return r;
			if (r < 0)
f01056c7:	85 c0                	test   %eax,%eax
f01056c9:	79 1c                	jns    f01056e7 <pci_attach_match+0x5f>
				cprintf("pci_attach_match: attaching "
f01056cb:	83 ec 0c             	sub    $0xc,%esp
f01056ce:	50                   	push   %eax
f01056cf:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01056d2:	ff 74 86 08          	pushl  0x8(%esi,%eax,4)
f01056d6:	ff 75 0c             	pushl  0xc(%ebp)
f01056d9:	57                   	push   %edi
f01056da:	68 54 74 10 f0       	push   $0xf0107454
f01056df:	e8 e6 d9 ff ff       	call   f01030ca <cprintf>
f01056e4:	83 c4 20             	add    $0x20,%esp
f01056e7:	43                   	inc    %ebx
f01056e8:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f01056eb:	83 7c 86 08 00       	cmpl   $0x0,0x8(%esi,%eax,4)
f01056f0:	75 b0                	jne    f01056a2 <pci_attach_match+0x1a>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
f01056f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01056f7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f01056fa:	5b                   	pop    %ebx
f01056fb:	5e                   	pop    %esi
f01056fc:	5f                   	pop    %edi
f01056fd:	c9                   	leave  
f01056fe:	c3                   	ret    

f01056ff <pci_attach>:

static int
pci_attach(struct pci_func *f)
{
f01056ff:	55                   	push   %ebp
f0105700:	89 e5                	mov    %esp,%ebp
f0105702:	56                   	push   %esi
f0105703:	53                   	push   %ebx
f0105704:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return
f0105707:	be 00 00 00 00       	mov    $0x0,%esi
f010570c:	53                   	push   %ebx
f010570d:	68 a8 56 12 f0       	push   $0xf01256a8
f0105712:	0f b6 43 12          	movzbl 0x12(%ebx),%eax
f0105716:	50                   	push   %eax
f0105717:	0f b6 43 13          	movzbl 0x13(%ebx),%eax
f010571b:	50                   	push   %eax
f010571c:	e8 67 ff ff ff       	call   f0105688 <pci_attach_match>
f0105721:	83 c4 10             	add    $0x10,%esp
f0105724:	85 c0                	test   %eax,%eax
f0105726:	75 21                	jne    f0105749 <pci_attach+0x4a>
f0105728:	53                   	push   %ebx
f0105729:	68 c0 56 12 f0       	push   $0xf01256c0
f010572e:	8b 43 0c             	mov    0xc(%ebx),%eax
f0105731:	89 c2                	mov    %eax,%edx
f0105733:	c1 ea 10             	shr    $0x10,%edx
f0105736:	52                   	push   %edx
f0105737:	25 ff ff 00 00       	and    $0xffff,%eax
f010573c:	50                   	push   %eax
f010573d:	e8 46 ff ff ff       	call   f0105688 <pci_attach_match>
f0105742:	83 c4 10             	add    $0x10,%esp
f0105745:	85 c0                	test   %eax,%eax
f0105747:	74 05                	je     f010574e <pci_attach+0x4f>
f0105749:	be 01 00 00 00       	mov    $0x1,%esi
		pci_attach_match(PCI_CLASS(f->dev_class), 
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
		pci_attach_match(PCI_VENDOR(f->dev_id), 
				 PCI_PRODUCT(f->dev_id),
				 &pci_attach_vendor[0], f);
}
f010574e:	89 f0                	mov    %esi,%eax
f0105750:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
f0105753:	5b                   	pop    %ebx
f0105754:	5e                   	pop    %esi
f0105755:	c9                   	leave  
f0105756:	c3                   	ret    

f0105757 <pci_print_func>:

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
f0105757:	55                   	push   %ebp
f0105758:	89 e5                	mov    %esp,%ebp
f010575a:	83 ec 08             	sub    $0x8,%esp
f010575d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const char *class = pci_class[0];
f0105760:	8b 15 d8 56 12 f0    	mov    0xf01256d8,%edx
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f0105766:	0f b6 41 13          	movzbl 0x13(%ecx),%eax
f010576a:	83 f8 06             	cmp    $0x6,%eax
f010576d:	77 07                	ja     f0105776 <pci_print_func+0x1f>
		class = pci_class[PCI_CLASS(f->dev_class)];
f010576f:	8b 14 85 d8 56 12 f0 	mov    0xf01256d8(,%eax,4),%edx

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0105776:	83 ec 08             	sub    $0x8,%esp
f0105779:	0f b6 41 44          	movzbl 0x44(%ecx),%eax
f010577d:	50                   	push   %eax
f010577e:	52                   	push   %edx
f010577f:	0f b6 41 12          	movzbl 0x12(%ecx),%eax
f0105783:	50                   	push   %eax
f0105784:	0f b6 41 13          	movzbl 0x13(%ecx),%eax
f0105788:	50                   	push   %eax
f0105789:	8b 41 0c             	mov    0xc(%ecx),%eax
f010578c:	89 c2                	mov    %eax,%edx
f010578e:	c1 ea 10             	shr    $0x10,%edx
f0105791:	52                   	push   %edx
f0105792:	25 ff ff 00 00       	and    $0xffff,%eax
f0105797:	50                   	push   %eax
f0105798:	ff 71 08             	pushl  0x8(%ecx)
f010579b:	ff 71 04             	pushl  0x4(%ecx)
f010579e:	8b 01                	mov    (%ecx),%eax
f01057a0:	ff 70 04             	pushl  0x4(%eax)
f01057a3:	68 80 74 10 f0       	push   $0xf0107480
f01057a8:	e8 1d d9 ff ff       	call   f01030ca <cprintf>
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
		f->irq_line);
}
f01057ad:	c9                   	leave  
f01057ae:	c3                   	ret    

f01057af <pci_scan_bus>:

static int 
pci_scan_bus(struct pci_bus *bus)
{
f01057af:	55                   	push   %ebp
f01057b0:	89 e5                	mov    %esp,%ebp
f01057b2:	57                   	push   %edi
f01057b3:	56                   	push   %esi
f01057b4:	53                   	push   %ebx
f01057b5:	81 ec 10 01 00 00    	sub    $0x110,%esp
	int totaldev = 0;
f01057bb:	c7 85 f4 fe ff ff 00 	movl   $0x0,0xfffffef4(%ebp)
f01057c2:	00 00 00 
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f01057c5:	6a 48                	push   $0x48
f01057c7:	6a 00                	push   $0x0
f01057c9:	8d 45 98             	lea    0xffffff98(%ebp),%eax
f01057cc:	50                   	push   %eax
f01057cd:	e8 c7 f4 ff ff       	call   f0104c99 <memset>
	df.bus = bus;
f01057d2:	8b 45 08             	mov    0x8(%ebp),%eax
f01057d5:	89 45 98             	mov    %eax,0xffffff98(%ebp)
	
	for (df.dev = 0; df.dev < 32; df.dev++) {
f01057d8:	c7 45 9c 00 00 00 00 	movl   $0x0,0xffffff9c(%ebp)
f01057df:	83 c4 10             	add    $0x10,%esp
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f01057e2:	83 ec 08             	sub    $0x8,%esp
f01057e5:	6a 0c                	push   $0xc
f01057e7:	8d 45 98             	lea    0xffffff98(%ebp),%eax
f01057ea:	50                   	push   %eax
f01057eb:	e8 45 fe ff ff       	call   f0105635 <pci_conf_read>
f01057f0:	89 c7                	mov    %eax,%edi
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f01057f2:	c1 e8 10             	shr    $0x10,%eax
f01057f5:	83 e0 7f             	and    $0x7f,%eax
f01057f8:	83 c4 10             	add    $0x10,%esp
f01057fb:	83 f8 01             	cmp    $0x1,%eax
f01057fe:	0f 87 cf 00 00 00    	ja     f01058d3 <pci_scan_bus+0x124>
			continue;
		
		totaldev++;
f0105804:	ff 85 f4 fe ff ff    	incl   0xfffffef4(%ebp)
		
		struct pci_func f = df;
f010580a:	8d 85 48 ff ff ff    	lea    0xffffff48(%ebp),%eax
f0105810:	83 ec 04             	sub    $0x4,%esp
f0105813:	6a 48                	push   $0x48
f0105815:	8d 55 98             	lea    0xffffff98(%ebp),%edx
f0105818:	52                   	push   %edx
f0105819:	50                   	push   %eax
f010581a:	e8 38 f5 ff ff       	call   f0104d57 <memcpy>
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f010581f:	c7 85 50 ff ff ff 00 	movl   $0x0,0xffffff50(%ebp)
f0105826:	00 00 00 
f0105829:	83 c4 10             	add    $0x10,%esp
f010582c:	8d b5 48 ff ff ff    	lea    0xffffff48(%ebp),%esi
f0105832:	eb 7e                	jmp    f01058b2 <pci_scan_bus+0x103>
		     f.func++) {
			struct pci_func af = f;
f0105834:	8d 9d f8 fe ff ff    	lea    0xfffffef8(%ebp),%ebx
f010583a:	83 ec 04             	sub    $0x4,%esp
f010583d:	6a 48                	push   $0x48
f010583f:	56                   	push   %esi
f0105840:	53                   	push   %ebx
f0105841:	e8 11 f5 ff ff       	call   f0104d57 <memcpy>
			
			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0105846:	83 c4 08             	add    $0x8,%esp
f0105849:	6a 00                	push   $0x0
f010584b:	56                   	push   %esi
f010584c:	e8 e4 fd ff ff       	call   f0105635 <pci_conf_read>
f0105851:	89 85 04 ff ff ff    	mov    %eax,0xffffff04(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0105857:	83 c4 10             	add    $0x10,%esp
f010585a:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f010585e:	74 4c                	je     f01058ac <pci_scan_bus+0xfd>
				continue;
			
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0105860:	83 ec 08             	sub    $0x8,%esp
f0105863:	6a 3c                	push   $0x3c
f0105865:	53                   	push   %ebx
f0105866:	e8 ca fd ff ff       	call   f0105635 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f010586b:	88 85 3c ff ff ff    	mov    %al,0xffffff3c(%ebp)
			
			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0105871:	83 c4 08             	add    $0x8,%esp
f0105874:	6a 08                	push   $0x8
f0105876:	53                   	push   %ebx
f0105877:	e8 b9 fd ff ff       	call   f0105635 <pci_conf_read>
f010587c:	89 85 08 ff ff ff    	mov    %eax,0xffffff08(%ebp)
			if (pci_show_devs)
f0105882:	83 c4 10             	add    $0x10,%esp
f0105885:	83 3d 9c 56 12 f0 00 	cmpl   $0x0,0xf012569c
f010588c:	74 0c                	je     f010589a <pci_scan_bus+0xeb>
				pci_print_func(&af);
f010588e:	83 ec 0c             	sub    $0xc,%esp
f0105891:	53                   	push   %ebx
f0105892:	e8 c0 fe ff ff       	call   f0105757 <pci_print_func>
f0105897:	83 c4 10             	add    $0x10,%esp
			pci_attach(&af);
f010589a:	83 ec 0c             	sub    $0xc,%esp
f010589d:	8d 85 f8 fe ff ff    	lea    0xfffffef8(%ebp),%eax
f01058a3:	50                   	push   %eax
f01058a4:	e8 56 fe ff ff       	call   f01056ff <pci_attach>
f01058a9:	83 c4 10             	add    $0x10,%esp
f01058ac:	ff 85 50 ff ff ff    	incl   0xffffff50(%ebp)
f01058b2:	8b 85 50 ff ff ff    	mov    0xffffff50(%ebp),%eax
f01058b8:	f7 c7 00 00 80 00    	test   $0x800000,%edi
f01058be:	74 0b                	je     f01058cb <pci_scan_bus+0x11c>
f01058c0:	83 f8 07             	cmp    $0x7,%eax
f01058c3:	0f 86 6b ff ff ff    	jbe    f0105834 <pci_scan_bus+0x85>
f01058c9:	eb 08                	jmp    f01058d3 <pci_scan_bus+0x124>
f01058cb:	85 c0                	test   %eax,%eax
f01058cd:	0f 84 61 ff ff ff    	je     f0105834 <pci_scan_bus+0x85>
f01058d3:	ff 45 9c             	incl   0xffffff9c(%ebp)
f01058d6:	83 7d 9c 1f          	cmpl   $0x1f,0xffffff9c(%ebp)
f01058da:	0f 86 02 ff ff ff    	jbe    f01057e2 <pci_scan_bus+0x33>
		}
	}
	
	return totaldev;
}
f01058e0:	8b 85 f4 fe ff ff    	mov    0xfffffef4(%ebp),%eax
f01058e6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f01058e9:	5b                   	pop    %ebx
f01058ea:	5e                   	pop    %esi
f01058eb:	5f                   	pop    %edi
f01058ec:	c9                   	leave  
f01058ed:	c3                   	ret    

f01058ee <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f01058ee:	55                   	push   %ebp
f01058ef:	89 e5                	mov    %esp,%ebp
f01058f1:	57                   	push   %edi
f01058f2:	56                   	push   %esi
f01058f3:	53                   	push   %ebx
f01058f4:	83 ec 14             	sub    $0x14,%esp
f01058f7:	8b 75 08             	mov    0x8(%ebp),%esi
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f01058fa:	6a 1c                	push   $0x1c
f01058fc:	56                   	push   %esi
f01058fd:	e8 33 fd ff ff       	call   f0105635 <pci_conf_read>
f0105902:	89 c3                	mov    %eax,%ebx
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0105904:	83 c4 08             	add    $0x8,%esp
f0105907:	6a 18                	push   $0x18
f0105909:	56                   	push   %esi
f010590a:	e8 26 fd ff ff       	call   f0105635 <pci_conf_read>
f010590f:	89 c7                	mov    %eax,%edi
	
	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0105911:	89 d8                	mov    %ebx,%eax
f0105913:	83 e0 0f             	and    $0xf,%eax
f0105916:	83 c4 10             	add    $0x10,%esp
f0105919:	83 f8 01             	cmp    $0x1,%eax
f010591c:	75 1c                	jne    f010593a <pci_bridge_attach+0x4c>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f010591e:	ff 76 08             	pushl  0x8(%esi)
f0105921:	ff 76 04             	pushl  0x4(%esi)
f0105924:	8b 06                	mov    (%esi),%eax
f0105926:	ff 70 04             	pushl  0x4(%eax)
f0105929:	68 bc 74 10 f0       	push   $0xf01074bc
f010592e:	e8 97 d7 ff ff       	call   f01030ca <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
f0105933:	b8 00 00 00 00       	mov    $0x0,%eax
f0105938:	eb 5d                	jmp    f0105997 <pci_bridge_attach+0xa9>
	}
	
	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f010593a:	83 ec 04             	sub    $0x4,%esp
f010593d:	6a 08                	push   $0x8
f010593f:	6a 00                	push   $0x0
f0105941:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f0105944:	50                   	push   %eax
f0105945:	e8 4f f3 ff ff       	call   f0104c99 <memset>
	nbus.parent_bridge = pcif;
f010594a:	89 75 e8             	mov    %esi,0xffffffe8(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f010594d:	89 f8                	mov    %edi,%eax
f010594f:	0f b6 d4             	movzbl %ah,%edx
f0105952:	89 55 ec             	mov    %edx,0xffffffec(%ebp)
	
	if (pci_show_devs)
f0105955:	83 c4 10             	add    $0x10,%esp
f0105958:	83 3d 9c 56 12 f0 00 	cmpl   $0x0,0xf012569c
f010595f:	74 25                	je     f0105986 <pci_bridge_attach+0x98>
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0105961:	83 ec 08             	sub    $0x8,%esp
f0105964:	c1 e8 10             	shr    $0x10,%eax
f0105967:	25 ff 00 00 00       	and    $0xff,%eax
f010596c:	50                   	push   %eax
f010596d:	52                   	push   %edx
f010596e:	ff 76 08             	pushl  0x8(%esi)
f0105971:	ff 76 04             	pushl  0x4(%esi)
f0105974:	8b 06                	mov    (%esi),%eax
f0105976:	ff 70 04             	pushl  0x4(%eax)
f0105979:	68 f0 74 10 f0       	push   $0xf01074f0
f010597e:	e8 47 d7 ff ff       	call   f01030ca <cprintf>
f0105983:	83 c4 20             	add    $0x20,%esp
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
	
	pci_scan_bus(&nbus);
f0105986:	83 ec 0c             	sub    $0xc,%esp
f0105989:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
f010598c:	50                   	push   %eax
f010598d:	e8 1d fe ff ff       	call   f01057af <pci_scan_bus>
	return 1;
f0105992:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0105997:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f010599a:	5b                   	pop    %ebx
f010599b:	5e                   	pop    %esi
f010599c:	5f                   	pop    %edi
f010599d:	c9                   	leave  
f010599e:	c3                   	ret    

f010599f <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f010599f:	55                   	push   %ebp
f01059a0:	89 e5                	mov    %esp,%ebp
f01059a2:	57                   	push   %edi
f01059a3:	56                   	push   %esi
f01059a4:	53                   	push   %ebx
f01059a5:	83 ec 10             	sub    $0x10,%esp
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f01059a8:	6a 07                	push   $0x7
f01059aa:	6a 04                	push   $0x4
f01059ac:	ff 75 08             	pushl  0x8(%ebp)
f01059af:	e8 a9 fc ff ff       	call   f010565d <pci_conf_write>
		       PCI_COMMAND_IO_ENABLE |
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);
	
	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f01059b4:	be 10 00 00 00       	mov    $0x10,%esi
f01059b9:	83 c4 10             	add    $0x10,%esp
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);
f01059bc:	83 ec 08             	sub    $0x8,%esp
f01059bf:	56                   	push   %esi
f01059c0:	ff 75 08             	pushl  0x8(%ebp)
f01059c3:	e8 6d fc ff ff       	call   f0105635 <pci_conf_read>
f01059c8:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
		
		bar_width = 4;
f01059cb:	c7 45 f0 04 00 00 00 	movl   $0x4,0xfffffff0(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f01059d2:	83 c4 0c             	add    $0xc,%esp
f01059d5:	6a ff                	push   $0xffffffff
f01059d7:	56                   	push   %esi
f01059d8:	ff 75 08             	pushl  0x8(%ebp)
f01059db:	e8 7d fc ff ff       	call   f010565d <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f01059e0:	83 c4 08             	add    $0x8,%esp
f01059e3:	56                   	push   %esi
f01059e4:	ff 75 08             	pushl  0x8(%ebp)
f01059e7:	e8 49 fc ff ff       	call   f0105635 <pci_conf_read>
f01059ec:	89 c2                	mov    %eax,%edx
		
		if (rv == 0)
f01059ee:	83 c4 10             	add    $0x10,%esp
f01059f1:	85 c0                	test   %eax,%eax
f01059f3:	0f 84 d4 00 00 00    	je     f0105acd <pci_func_enable+0x12e>
			continue;
		
		int regnum = PCI_MAPREG_NUM(bar);
f01059f9:	8d 46 f0             	lea    0xfffffff0(%esi),%eax
f01059fc:	c1 e8 02             	shr    $0x2,%eax
f01059ff:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0105a02:	f6 c2 01             	test   $0x1,%dl
f0105a05:	75 40                	jne    f0105a47 <pci_func_enable+0xa8>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0105a07:	89 d0                	mov    %edx,%eax
f0105a09:	83 e0 06             	and    $0x6,%eax
f0105a0c:	83 f8 04             	cmp    $0x4,%eax
f0105a0f:	75 07                	jne    f0105a18 <pci_func_enable+0x79>
				bar_width = 8;
f0105a11:	c7 45 f0 08 00 00 00 	movl   $0x8,0xfffffff0(%ebp)
			
			size = PCI_MAPREG_MEM_SIZE(rv);
f0105a18:	89 d3                	mov    %edx,%ebx
f0105a1a:	83 e3 f0             	and    $0xfffffff0,%ebx
f0105a1d:	f7 db                	neg    %ebx
f0105a1f:	21 d3                	and    %edx,%ebx
f0105a21:	83 e3 f0             	and    $0xfffffff0,%ebx
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0105a24:	8b 7d ec             	mov    0xffffffec(%ebp),%edi
f0105a27:	83 e7 f0             	and    $0xfffffff0,%edi
			if (pci_show_addrs)
f0105a2a:	83 3d 60 68 2f f0 00 	cmpl   $0x0,0xf02f6860
f0105a31:	74 41                	je     f0105a74 <pci_func_enable+0xd5>
				cprintf("  mem region %d: %d bytes at 0x%x\n",
f0105a33:	57                   	push   %edi
f0105a34:	53                   	push   %ebx
f0105a35:	ff 75 e8             	pushl  0xffffffe8(%ebp)
f0105a38:	68 20 75 10 f0       	push   $0xf0107520
f0105a3d:	e8 88 d6 ff ff       	call   f01030ca <cprintf>
f0105a42:	83 c4 10             	add    $0x10,%esp
f0105a45:	eb 2d                	jmp    f0105a74 <pci_func_enable+0xd5>
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0105a47:	89 d3                	mov    %edx,%ebx
f0105a49:	83 e3 fc             	and    $0xfffffffc,%ebx
f0105a4c:	f7 db                	neg    %ebx
f0105a4e:	21 d3                	and    %edx,%ebx
f0105a50:	83 e3 fc             	and    $0xfffffffc,%ebx
			base = PCI_MAPREG_IO_ADDR(oldv);
f0105a53:	8b 7d ec             	mov    0xffffffec(%ebp),%edi
f0105a56:	83 e7 fc             	and    $0xfffffffc,%edi
			if (pci_show_addrs)
f0105a59:	83 3d 60 68 2f f0 00 	cmpl   $0x0,0xf02f6860
f0105a60:	74 12                	je     f0105a74 <pci_func_enable+0xd5>
				cprintf("  io region %d: %d bytes at 0x%x\n",
f0105a62:	57                   	push   %edi
f0105a63:	53                   	push   %ebx
f0105a64:	ff 75 e8             	pushl  0xffffffe8(%ebp)
f0105a67:	68 44 75 10 f0       	push   $0xf0107544
f0105a6c:	e8 59 d6 ff ff       	call   f01030ca <cprintf>
f0105a71:	83 c4 10             	add    $0x10,%esp
					regnum, size, base);
		}
		
		pci_conf_write(f, bar, oldv);
f0105a74:	83 ec 04             	sub    $0x4,%esp
f0105a77:	ff 75 ec             	pushl  0xffffffec(%ebp)
f0105a7a:	56                   	push   %esi
f0105a7b:	ff 75 08             	pushl  0x8(%ebp)
f0105a7e:	e8 da fb ff ff       	call   f010565d <pci_conf_write>
		f->reg_base[regnum] = base;
f0105a83:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
f0105a86:	8b 55 08             	mov    0x8(%ebp),%edx
f0105a89:	89 7c 82 14          	mov    %edi,0x14(%edx,%eax,4)
		f->reg_size[regnum] = size;
f0105a8d:	89 5c 82 2c          	mov    %ebx,0x2c(%edx,%eax,4)
		
		if (size && !base)
f0105a91:	83 c4 10             	add    $0x10,%esp
f0105a94:	85 db                	test   %ebx,%ebx
f0105a96:	74 35                	je     f0105acd <pci_func_enable+0x12e>
f0105a98:	85 ff                	test   %edi,%edi
f0105a9a:	75 31                	jne    f0105acd <pci_func_enable+0x12e>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0105a9c:	83 ec 0c             	sub    $0xc,%esp
f0105a9f:	53                   	push   %ebx
f0105aa0:	6a 00                	push   $0x0
f0105aa2:	50                   	push   %eax
f0105aa3:	8b 42 0c             	mov    0xc(%edx),%eax
f0105aa6:	89 c2                	mov    %eax,%edx
f0105aa8:	c1 ea 10             	shr    $0x10,%edx
f0105aab:	52                   	push   %edx
f0105aac:	25 ff ff 00 00       	and    $0xffff,%eax
f0105ab1:	50                   	push   %eax
f0105ab2:	8b 45 08             	mov    0x8(%ebp),%eax
f0105ab5:	ff 70 08             	pushl  0x8(%eax)
f0105ab8:	ff 70 04             	pushl  0x4(%eax)
f0105abb:	8b 00                	mov    (%eax),%eax
f0105abd:	ff 70 04             	pushl  0x4(%eax)
f0105ac0:	68 68 75 10 f0       	push   $0xf0107568
f0105ac5:	e8 00 d6 ff ff       	call   f01030ca <cprintf>
f0105aca:	83 c4 30             	add    $0x30,%esp
f0105acd:	03 75 f0             	add    0xfffffff0(%ebp),%esi
f0105ad0:	83 fe 27             	cmp    $0x27,%esi
f0105ad3:	0f 86 e3 fe ff ff    	jbe    f01059bc <pci_func_enable+0x1d>
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
				regnum, base, size);
	}
}
f0105ad9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
f0105adc:	5b                   	pop    %ebx
f0105add:	5e                   	pop    %esi
f0105ade:	5f                   	pop    %edi
f0105adf:	c9                   	leave  
f0105ae0:	c3                   	ret    

f0105ae1 <pci_init>:

int
pci_init(void)
{
f0105ae1:	55                   	push   %ebp
f0105ae2:	89 e5                	mov    %esp,%ebp
f0105ae4:	83 ec 0c             	sub    $0xc,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0105ae7:	6a 08                	push   $0x8
f0105ae9:	6a 00                	push   $0x0
f0105aeb:	68 64 68 2f f0       	push   $0xf02f6864
f0105af0:	e8 a4 f1 ff ff       	call   f0104c99 <memset>
	
	return pci_scan_bus(&root_bus);
f0105af5:	c7 04 24 64 68 2f f0 	movl   $0xf02f6864,(%esp)
f0105afc:	e8 ae fc ff ff       	call   f01057af <pci_scan_bus>
}
f0105b01:	c9                   	leave  
f0105b02:	c3                   	ret    
	...

f0105b04 <time_init>:
static unsigned int ticks;

void
time_init(void) 
{
f0105b04:	55                   	push   %ebp
f0105b05:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f0105b07:	c7 05 6c 68 2f f0 00 	movl   $0x0,0xf02f686c
f0105b0e:	00 00 00 
}
f0105b11:	c9                   	leave  
f0105b12:	c3                   	ret    

f0105b13 <time_tick>:

// this is called once per timer interupt; a timer interupt fires 100 times a
// second
void
time_tick(void) 
{
f0105b13:	55                   	push   %ebp
f0105b14:	89 e5                	mov    %esp,%ebp
f0105b16:	83 ec 08             	sub    $0x8,%esp
	ticks++;
f0105b19:	a1 6c 68 2f f0       	mov    0xf02f686c,%eax
f0105b1e:	40                   	inc    %eax
f0105b1f:	a3 6c 68 2f f0       	mov    %eax,0xf02f686c
	if (ticks * 10 < ticks)
f0105b24:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105b27:	d1 e0                	shl    %eax
f0105b29:	3b 05 6c 68 2f f0    	cmp    0xf02f686c,%eax
f0105b2f:	73 14                	jae    f0105b45 <time_tick+0x32>
		panic("time_tick: time overflowed");
f0105b31:	83 ec 04             	sub    $0x4,%esp
f0105b34:	68 c1 75 10 f0       	push   $0xf01075c1
f0105b39:	6a 13                	push   $0x13
f0105b3b:	68 dc 75 10 f0       	push   $0xf01075dc
f0105b40:	e8 a9 a5 ff ff       	call   f01000ee <_panic>
}
f0105b45:	c9                   	leave  
f0105b46:	c3                   	ret    

f0105b47 <time_msec>:

unsigned int
time_msec(void) 
{
f0105b47:	55                   	push   %ebp
f0105b48:	89 e5                	mov    %esp,%ebp
	return ticks * 10;
f0105b4a:	a1 6c 68 2f f0       	mov    0xf02f686c,%eax
f0105b4f:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105b52:	d1 e0                	shl    %eax
}
f0105b54:	c9                   	leave  
f0105b55:	c3                   	ret    
	...

f0105b58 <__udivdi3>:
f0105b58:	55                   	push   %ebp
f0105b59:	89 e5                	mov    %esp,%ebp
f0105b5b:	57                   	push   %edi
f0105b5c:	56                   	push   %esi
f0105b5d:	83 ec 14             	sub    $0x14,%esp
f0105b60:	8b 55 14             	mov    0x14(%ebp),%edx
f0105b63:	8b 75 08             	mov    0x8(%ebp),%esi
f0105b66:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105b69:	8b 45 10             	mov    0x10(%ebp),%eax
f0105b6c:	85 d2                	test   %edx,%edx
f0105b6e:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
f0105b71:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
f0105b74:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
f0105b77:	89 fe                	mov    %edi,%esi
f0105b79:	75 11                	jne    f0105b8c <__udivdi3+0x34>
f0105b7b:	39 f8                	cmp    %edi,%eax
f0105b7d:	76 4d                	jbe    f0105bcc <__udivdi3+0x74>
f0105b7f:	89 fa                	mov    %edi,%edx
f0105b81:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0105b84:	f7 75 e4             	divl   0xffffffe4(%ebp)
f0105b87:	89 c7                	mov    %eax,%edi
f0105b89:	eb 09                	jmp    f0105b94 <__udivdi3+0x3c>
f0105b8b:	90                   	nop    
f0105b8c:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
f0105b8f:	76 17                	jbe    f0105ba8 <__udivdi3+0x50>
f0105b91:	31 ff                	xor    %edi,%edi
f0105b93:	90                   	nop    
f0105b94:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
f0105b9b:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
f0105b9e:	83 c4 14             	add    $0x14,%esp
f0105ba1:	5e                   	pop    %esi
f0105ba2:	89 f8                	mov    %edi,%eax
f0105ba4:	5f                   	pop    %edi
f0105ba5:	c9                   	leave  
f0105ba6:	c3                   	ret    
f0105ba7:	90                   	nop    
f0105ba8:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
f0105bac:	89 c7                	mov    %eax,%edi
f0105bae:	83 f7 1f             	xor    $0x1f,%edi
f0105bb1:	75 4d                	jne    f0105c00 <__udivdi3+0xa8>
f0105bb3:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
f0105bb6:	77 0a                	ja     f0105bc2 <__udivdi3+0x6a>
f0105bb8:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
f0105bbb:	31 ff                	xor    %edi,%edi
f0105bbd:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
f0105bc0:	72 d2                	jb     f0105b94 <__udivdi3+0x3c>
f0105bc2:	bf 01 00 00 00       	mov    $0x1,%edi
f0105bc7:	eb cb                	jmp    f0105b94 <__udivdi3+0x3c>
f0105bc9:	8d 76 00             	lea    0x0(%esi),%esi
f0105bcc:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f0105bcf:	85 c0                	test   %eax,%eax
f0105bd1:	75 0e                	jne    f0105be1 <__udivdi3+0x89>
f0105bd3:	b8 01 00 00 00       	mov    $0x1,%eax
f0105bd8:	31 c9                	xor    %ecx,%ecx
f0105bda:	31 d2                	xor    %edx,%edx
f0105bdc:	f7 f1                	div    %ecx
f0105bde:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
f0105be1:	89 f0                	mov    %esi,%eax
f0105be3:	31 d2                	xor    %edx,%edx
f0105be5:	f7 75 e4             	divl   0xffffffe4(%ebp)
f0105be8:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
f0105beb:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0105bee:	f7 75 e4             	divl   0xffffffe4(%ebp)
f0105bf1:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
f0105bf4:	83 c4 14             	add    $0x14,%esp
f0105bf7:	89 c7                	mov    %eax,%edi
f0105bf9:	5e                   	pop    %esi
f0105bfa:	89 f8                	mov    %edi,%eax
f0105bfc:	5f                   	pop    %edi
f0105bfd:	c9                   	leave  
f0105bfe:	c3                   	ret    
f0105bff:	90                   	nop    
f0105c00:	b8 20 00 00 00       	mov    $0x20,%eax
f0105c05:	29 f8                	sub    %edi,%eax
f0105c07:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
f0105c0a:	89 f9                	mov    %edi,%ecx
f0105c0c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f0105c0f:	d3 e2                	shl    %cl,%edx
f0105c11:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f0105c14:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
f0105c17:	d3 e8                	shr    %cl,%eax
f0105c19:	09 c2                	or     %eax,%edx
f0105c1b:	89 f9                	mov    %edi,%ecx
f0105c1d:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
f0105c20:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
f0105c23:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
f0105c26:	89 f2                	mov    %esi,%edx
f0105c28:	d3 ea                	shr    %cl,%edx
f0105c2a:	89 f9                	mov    %edi,%ecx
f0105c2c:	d3 e6                	shl    %cl,%esi
f0105c2e:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0105c31:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
f0105c34:	d3 e8                	shr    %cl,%eax
f0105c36:	09 c6                	or     %eax,%esi
f0105c38:	89 f9                	mov    %edi,%ecx
f0105c3a:	89 f0                	mov    %esi,%eax
f0105c3c:	f7 75 f4             	divl   0xfffffff4(%ebp)
f0105c3f:	89 d6                	mov    %edx,%esi
f0105c41:	89 c7                	mov    %eax,%edi
f0105c43:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
f0105c46:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
f0105c49:	f7 e7                	mul    %edi
f0105c4b:	39 f2                	cmp    %esi,%edx
f0105c4d:	77 0f                	ja     f0105c5e <__udivdi3+0x106>
f0105c4f:	0f 85 3f ff ff ff    	jne    f0105b94 <__udivdi3+0x3c>
f0105c55:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
f0105c58:	0f 86 36 ff ff ff    	jbe    f0105b94 <__udivdi3+0x3c>
f0105c5e:	4f                   	dec    %edi
f0105c5f:	e9 30 ff ff ff       	jmp    f0105b94 <__udivdi3+0x3c>

f0105c64 <__umoddi3>:
f0105c64:	55                   	push   %ebp
f0105c65:	89 e5                	mov    %esp,%ebp
f0105c67:	57                   	push   %edi
f0105c68:	56                   	push   %esi
f0105c69:	83 ec 30             	sub    $0x30,%esp
f0105c6c:	8b 55 14             	mov    0x14(%ebp),%edx
f0105c6f:	8b 45 10             	mov    0x10(%ebp),%eax
f0105c72:	89 d7                	mov    %edx,%edi
f0105c74:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
f0105c77:	89 c6                	mov    %eax,%esi
f0105c79:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105c7c:	8b 45 08             	mov    0x8(%ebp),%eax
f0105c7f:	85 ff                	test   %edi,%edi
f0105c81:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
f0105c88:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
f0105c8f:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
f0105c92:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
f0105c95:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
f0105c98:	75 3e                	jne    f0105cd8 <__umoddi3+0x74>
f0105c9a:	39 d6                	cmp    %edx,%esi
f0105c9c:	0f 86 a2 00 00 00    	jbe    f0105d44 <__umoddi3+0xe0>
f0105ca2:	f7 f6                	div    %esi
f0105ca4:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
f0105ca7:	85 c9                	test   %ecx,%ecx
f0105ca9:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
f0105cac:	74 1b                	je     f0105cc9 <__umoddi3+0x65>
f0105cae:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105cb1:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
f0105cb4:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
f0105cbb:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0105cbe:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
f0105cc1:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
f0105cc4:	89 10                	mov    %edx,(%eax)
f0105cc6:	89 48 04             	mov    %ecx,0x4(%eax)
f0105cc9:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
f0105ccc:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
f0105ccf:	83 c4 30             	add    $0x30,%esp
f0105cd2:	5e                   	pop    %esi
f0105cd3:	5f                   	pop    %edi
f0105cd4:	c9                   	leave  
f0105cd5:	c3                   	ret    
f0105cd6:	89 f6                	mov    %esi,%esi
f0105cd8:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
f0105cdb:	76 1f                	jbe    f0105cfc <__umoddi3+0x98>
f0105cdd:	8b 55 08             	mov    0x8(%ebp),%edx
f0105ce0:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
f0105ce3:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
f0105ce6:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
f0105ce9:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
f0105cec:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
f0105cef:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
f0105cf2:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
f0105cf5:	83 c4 30             	add    $0x30,%esp
f0105cf8:	5e                   	pop    %esi
f0105cf9:	5f                   	pop    %edi
f0105cfa:	c9                   	leave  
f0105cfb:	c3                   	ret    
f0105cfc:	0f bd c7             	bsr    %edi,%eax
f0105cff:	83 f0 1f             	xor    $0x1f,%eax
f0105d02:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
f0105d05:	75 61                	jne    f0105d68 <__umoddi3+0x104>
f0105d07:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
f0105d0a:	77 05                	ja     f0105d11 <__umoddi3+0xad>
f0105d0c:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
f0105d0f:	72 10                	jb     f0105d21 <__umoddi3+0xbd>
f0105d11:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
f0105d14:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105d17:	29 f0                	sub    %esi,%eax
f0105d19:	19 fa                	sbb    %edi,%edx
f0105d1b:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
f0105d1e:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
f0105d21:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
f0105d24:	85 d2                	test   %edx,%edx
f0105d26:	74 a1                	je     f0105cc9 <__umoddi3+0x65>
f0105d28:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105d2b:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
f0105d2e:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
f0105d31:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
f0105d34:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
f0105d37:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
f0105d3a:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
f0105d3d:	89 01                	mov    %eax,(%ecx)
f0105d3f:	89 51 04             	mov    %edx,0x4(%ecx)
f0105d42:	eb 85                	jmp    f0105cc9 <__umoddi3+0x65>
f0105d44:	85 f6                	test   %esi,%esi
f0105d46:	75 0b                	jne    f0105d53 <__umoddi3+0xef>
f0105d48:	b8 01 00 00 00       	mov    $0x1,%eax
f0105d4d:	31 d2                	xor    %edx,%edx
f0105d4f:	f7 f6                	div    %esi
f0105d51:	89 c6                	mov    %eax,%esi
f0105d53:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
f0105d56:	89 fa                	mov    %edi,%edx
f0105d58:	f7 f6                	div    %esi
f0105d5a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105d5d:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
f0105d60:	f7 f6                	div    %esi
f0105d62:	e9 3d ff ff ff       	jmp    f0105ca4 <__umoddi3+0x40>
f0105d67:	90                   	nop    
f0105d68:	b8 20 00 00 00       	mov    $0x20,%eax
f0105d6d:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
f0105d70:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
f0105d73:	89 fa                	mov    %edi,%edx
f0105d75:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
f0105d78:	d3 e2                	shl    %cl,%edx
f0105d7a:	89 f0                	mov    %esi,%eax
f0105d7c:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
f0105d7f:	d3 e8                	shr    %cl,%eax
f0105d81:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
f0105d84:	d3 e6                	shl    %cl,%esi
f0105d86:	89 d7                	mov    %edx,%edi
f0105d88:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
f0105d8b:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
f0105d8e:	09 c7                	or     %eax,%edi
f0105d90:	d3 ea                	shr    %cl,%edx
f0105d92:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
f0105d95:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
f0105d98:	d3 e0                	shl    %cl,%eax
f0105d9a:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
f0105d9d:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
f0105da0:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105da3:	d3 e8                	shr    %cl,%eax
f0105da5:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
f0105da8:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
f0105dab:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
f0105dae:	f7 f7                	div    %edi
f0105db0:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
f0105db3:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
f0105db6:	f7 e6                	mul    %esi
f0105db8:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
f0105dbb:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
f0105dbe:	77 0a                	ja     f0105dca <__umoddi3+0x166>
f0105dc0:	75 12                	jne    f0105dd4 <__umoddi3+0x170>
f0105dc2:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105dc5:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
f0105dc8:	76 0a                	jbe    f0105dd4 <__umoddi3+0x170>
f0105dca:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
f0105dcd:	29 f1                	sub    %esi,%ecx
f0105dcf:	19 fa                	sbb    %edi,%edx
f0105dd1:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
f0105dd4:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
f0105dd7:	85 c0                	test   %eax,%eax
f0105dd9:	0f 84 ea fe ff ff    	je     f0105cc9 <__umoddi3+0x65>
f0105ddf:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
f0105de2:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
f0105de5:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
f0105de8:	19 d1                	sbb    %edx,%ecx
f0105dea:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
f0105ded:	89 ca                	mov    %ecx,%edx
f0105def:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
f0105df2:	d3 e2                	shl    %cl,%edx
f0105df4:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
f0105df7:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
f0105dfa:	d3 e8                	shr    %cl,%eax
f0105dfc:	09 c2                	or     %eax,%edx
f0105dfe:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
f0105e01:	d3 e8                	shr    %cl,%eax
f0105e03:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
f0105e06:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
f0105e09:	e9 ad fe ff ff       	jmp    f0105cbb <__umoddi3+0x57>
