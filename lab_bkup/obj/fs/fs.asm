
obj/fs/fs:     file format elf32-i386

Disassembly of section .text:

00800020 <_start>:
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 3f 1b 00 00       	call   801b70 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <ide_wait_ready>:
static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80003c:	89 ca                	mov    %ecx,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	0f b6 d0             	movzbl %al,%edx
  800042:	89 d0                	mov    %edx,%eax
  800044:	25 c0 00 00 00       	and    $0xc0,%eax
  800049:	83 f8 40             	cmp    $0x40,%eax
  80004c:	75 ee                	jne    80003c <ide_wait_ready+0x8>
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800052:	74 0a                	je     80005e <ide_wait_ready+0x2a>
		return -1;
  800054:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800059:	f6 c2 21             	test   $0x21,%dl
  80005c:	75 05                	jne    800063 <ide_wait_ready+0x2f>
	return 0;
  80005e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	53                   	push   %ebx
  800069:	83 ec 04             	sub    $0x4,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80006c:	6a 00                	push   $0x0
  80006e:	e8 c1 ff ff ff       	call   800034 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
  800073:	83 c4 04             	add    $0x4,%esp
  800076:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80007b:	b0 f0                	mov    $0xf0,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80007d:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0; 
  80007e:	b9 00 00 00 00       	mov    $0x0,%ecx
}

static __inline uint8_t
inb(int port)
{
  800083:	b2 f7                	mov    $0xf7,%dl
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800085:	ec                   	in     (%dx),%al
  800086:	a8 a1                	test   $0xa1,%al
  800088:	74 0e                	je     800098 <ide_probe_disk1+0x33>
  80008a:	41                   	inc    %ecx
  80008b:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  800091:	7f 05                	jg     800098 <ide_probe_disk1+0x33>
static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800093:	ec                   	in     (%dx),%al
  800094:	a8 a1                	test   $0xa1,%al
  800096:	75 f2                	jne    80008a <ide_probe_disk1+0x25>
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
  800098:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80009d:	b0 e0                	mov    $0xe0,%al
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80009f:	ee                   	out    %al,(%dx)
           x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0; 
           x++)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000a0:	83 ec 08             	sub    $0x8,%esp
  8000a3:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a9:	0f 9e c0             	setle  %al
  8000ac:	0f b6 d8             	movzbl %al,%ebx
  8000af:	53                   	push   %ebx
  8000b0:	68 00 3f 80 00       	push   $0x803f00
  8000b5:	e8 02 1c 00 00       	call   801cbc <cprintf>
	return (x < 1000);
  8000ba:	83 c4 10             	add    $0x10,%esp
}
  8000bd:	89 d8                	mov    %ebx,%eax
  8000bf:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8000c2:	c9                   	leave  
  8000c3:	c3                   	ret    

008000c4 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	76 14                	jbe    8000e6 <ide_set_disk+0x22>
		panic("bad disk number");
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 17 3f 80 00       	push   $0x803f17
  8000da:	6a 3a                	push   $0x3a
  8000dc:	68 27 3f 80 00       	push   $0x803f27
  8000e1:	e8 e6 1a 00 00       	call   801bcc <_panic>
	diskno = d;
  8000e6:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8000eb:	c9                   	leave  
  8000ec:	c3                   	ret    

008000ed <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	57                   	push   %edi
  8000f1:	56                   	push   %esi
  8000f2:	53                   	push   %ebx
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  8000fc:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  800102:	76 16                	jbe    80011a <ide_read+0x2d>
  800104:	68 30 3f 80 00       	push   $0x803f30
  800109:	68 3d 3f 80 00       	push   $0x803f3d
  80010e:	6a 43                	push   $0x43
  800110:	68 27 3f 80 00       	push   $0x803f27
  800115:	e8 b2 1a 00 00       	call   801bcc <_panic>

	ide_wait_ready(0);
  80011a:	6a 00                	push   $0x0
  80011c:	e8 13 ff ff ff       	call   800034 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
  800121:	83 c4 04             	add    $0x4,%esp
  800124:	ba f2 01 00 00       	mov    $0x1f2,%edx
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800129:	89 f0                	mov    %esi,%eax
  80012b:	ee                   	out    %al,(%dx)
  80012c:	b2 f3                	mov    $0xf3,%dl
  80012e:	88 d8                	mov    %bl,%al
  800130:	ee                   	out    %al,(%dx)
  800131:	b2 f4                	mov    $0xf4,%dl
  800133:	89 d8                	mov    %ebx,%eax
  800135:	c1 e8 08             	shr    $0x8,%eax
  800138:	ee                   	out    %al,(%dx)
  800139:	b2 f5                	mov    $0xf5,%dl
  80013b:	89 d8                	mov    %ebx,%eax
  80013d:	c1 e8 10             	shr    $0x10,%eax
  800140:	ee                   	out    %al,(%dx)
  800141:	b9 f6 01 00 00       	mov    $0x1f6,%ecx
  800146:	a0 00 80 80 00       	mov    0x808000,%al
  80014b:	83 e0 01             	and    $0x1,%eax
  80014e:	c1 e0 04             	shl    $0x4,%eax
  800151:	89 da                	mov    %ebx,%edx
  800153:	c1 ea 18             	shr    $0x18,%edx
  800156:	83 e2 0f             	and    $0xf,%edx
  800159:	09 d0                	or     %edx,%eax
  80015b:	83 c8 e0             	or     $0xffffffe0,%eax
  80015e:	89 ca                	mov    %ecx,%edx
  800160:	ee                   	out    %al,(%dx)
  800161:	b2 f7                	mov    $0xf7,%dl
  800163:	b0 20                	mov    $0x20,%al
  800165:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800166:	85 f6                	test   %esi,%esi
  800168:	74 2a                	je     800194 <ide_read+0xa7>
  80016a:	bb f0 01 00 00       	mov    $0x1f0,%ebx
		if ((r = ide_wait_ready(1)) < 0)
  80016f:	6a 01                	push   $0x1
  800171:	e8 be fe ff ff       	call   800034 <ide_wait_ready>
  800176:	83 c4 04             	add    $0x4,%esp
  800179:	85 c0                	test   %eax,%eax
  80017b:	78 1c                	js     800199 <ide_read+0xac>
}

static __inline void
insl(int port, void *addr, int cnt)
{
  80017d:	b9 80 00 00 00       	mov    $0x80,%ecx
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  800182:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800185:	89 da                	mov    %ebx,%edx
  800187:	fc                   	cld    
  800188:	f2 6d                	repnz insl (%dx),%es:(%edi)
  80018a:	81 45 0c 00 02 00 00 	addl   $0x200,0xc(%ebp)
  800191:	4e                   	dec    %esi
  800192:	75 db                	jne    80016f <ide_read+0x82>
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}
	
	return 0;
  800194:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800199:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80019c:	5b                   	pop    %ebx
  80019d:	5e                   	pop    %esi
  80019e:	5f                   	pop    %edi
  80019f:	c9                   	leave  
  8001a0:	c3                   	ret    

008001a1 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	57                   	push   %edi
  8001a5:	56                   	push   %esi
  8001a6:	53                   	push   %ebx
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001ad:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;
	
	assert(nsecs <= 256);
  8001b0:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001b6:	76 16                	jbe    8001ce <ide_write+0x2d>
  8001b8:	68 30 3f 80 00       	push   $0x803f30
  8001bd:	68 3d 3f 80 00       	push   $0x803f3d
  8001c2:	6a 5c                	push   $0x5c
  8001c4:	68 27 3f 80 00       	push   $0x803f27
  8001c9:	e8 fe 19 00 00       	call   801bcc <_panic>

	ide_wait_ready(0);
  8001ce:	6a 00                	push   $0x0
  8001d0:	e8 5f fe ff ff       	call   800034 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
  8001d5:	83 c4 04             	add    $0x4,%esp
  8001d8:	ba f2 01 00 00       	mov    $0x1f2,%edx
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001dd:	89 f8                	mov    %edi,%eax
  8001df:	ee                   	out    %al,(%dx)
  8001e0:	b2 f3                	mov    $0xf3,%dl
  8001e2:	88 d8                	mov    %bl,%al
  8001e4:	ee                   	out    %al,(%dx)
  8001e5:	b2 f4                	mov    $0xf4,%dl
  8001e7:	89 d8                	mov    %ebx,%eax
  8001e9:	c1 e8 08             	shr    $0x8,%eax
  8001ec:	ee                   	out    %al,(%dx)
  8001ed:	b2 f5                	mov    $0xf5,%dl
  8001ef:	89 d8                	mov    %ebx,%eax
  8001f1:	c1 e8 10             	shr    $0x10,%eax
  8001f4:	ee                   	out    %al,(%dx)
  8001f5:	b9 f6 01 00 00       	mov    $0x1f6,%ecx
  8001fa:	a0 00 80 80 00       	mov    0x808000,%al
  8001ff:	83 e0 01             	and    $0x1,%eax
  800202:	c1 e0 04             	shl    $0x4,%eax
  800205:	89 da                	mov    %ebx,%edx
  800207:	c1 ea 18             	shr    $0x18,%edx
  80020a:	83 e2 0f             	and    $0xf,%edx
  80020d:	09 d0                	or     %edx,%eax
  80020f:	83 c8 e0             	or     $0xffffffe0,%eax
  800212:	89 ca                	mov    %ecx,%edx
  800214:	ee                   	out    %al,(%dx)
  800215:	b2 f7                	mov    $0xf7,%dl
  800217:	b0 30                	mov    $0x30,%al
  800219:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  80021a:	85 ff                	test   %edi,%edi
  80021c:	74 2a                	je     800248 <ide_write+0xa7>
  80021e:	bb f0 01 00 00       	mov    $0x1f0,%ebx
		if ((r = ide_wait_ready(1)) < 0)
  800223:	6a 01                	push   $0x1
  800225:	e8 0a fe ff ff       	call   800034 <ide_wait_ready>
  80022a:	83 c4 04             	add    $0x4,%esp
  80022d:	85 c0                	test   %eax,%eax
  80022f:	78 1c                	js     80024d <ide_write+0xac>
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
  800231:	b9 80 00 00 00       	mov    $0x80,%ecx
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  800236:	8b 75 0c             	mov    0xc(%ebp),%esi
  800239:	89 da                	mov    %ebx,%edx
  80023b:	fc                   	cld    
  80023c:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
  80023e:	81 45 0c 00 02 00 00 	addl   $0x200,0xc(%ebp)
  800245:	4f                   	dec    %edi
  800246:	75 db                	jne    800223 <ide_write+0x82>
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  800248:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80024d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800250:	5b                   	pop    %ebx
  800251:	5e                   	pop    %esi
  800252:	5f                   	pop    %edi
  800253:	c9                   	leave  
  800254:	c3                   	ret    
  800255:	00 00                	add    %al,(%eax)
	...

00800258 <diskaddr>:

// Return the virtual address of this disk block.
char*
diskaddr(uint32_t blockno)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	83 ec 08             	sub    $0x8,%esp
  80025e:	8b 55 08             	mov    0x8(%ebp),%edx
	if (super && blockno >= super->s_nblocks)
  800261:	83 3d a4 c0 80 00 00 	cmpl   $0x0,0x80c0a4
  800268:	74 1c                	je     800286 <diskaddr+0x2e>
  80026a:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  80026f:	39 50 04             	cmp    %edx,0x4(%eax)
  800272:	77 12                	ja     800286 <diskaddr+0x2e>
		panic("bad block number %08x in diskaddr", blockno);
  800274:	52                   	push   %edx
  800275:	68 54 3f 80 00       	push   $0x803f54
  80027a:	6a 10                	push   $0x10
  80027c:	68 34 40 80 00       	push   $0x804034
  800281:	e8 46 19 00 00       	call   801bcc <_panic>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800286:	89 d0                	mov    %edx,%eax
  800288:	c1 e0 0c             	shl    $0xc,%eax
  80028b:	05 00 00 00 10       	add    $0x10000000,%eax
}
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	8b 55 08             	mov    0x8(%ebp),%edx
	return (vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P);
  800298:	b9 00 00 00 00       	mov    $0x0,%ecx
  80029d:	89 d0                	mov    %edx,%eax
  80029f:	c1 e8 16             	shr    $0x16,%eax
  8002a2:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8002a9:	a8 01                	test   $0x1,%al
  8002ab:	74 12                	je     8002bf <va_is_mapped+0x2d>
  8002ad:	89 d0                	mov    %edx,%eax
  8002af:	c1 e8 0c             	shr    $0xc,%eax
  8002b2:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8002b9:	a8 01                	test   $0x1,%al
  8002bb:	74 02                	je     8002bf <va_is_mapped+0x2d>
  8002bd:	b1 01                	mov    $0x1,%cl
}
  8002bf:	89 c8                	mov    %ecx,%eax
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <block_is_mapped>:

// Is this disk block mapped?
bool
block_is_mapped(uint32_t blockno)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	56                   	push   %esi
  8002c7:	53                   	push   %ebx
	char *va = diskaddr(blockno);
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	ff 75 08             	pushl  0x8(%ebp)
  8002ce:	e8 85 ff ff ff       	call   800258 <diskaddr>
  8002d3:	89 c3                	mov    %eax,%ebx
	return va_is_mapped(va) && va != 0;
  8002d5:	be 00 00 00 00       	mov    $0x0,%esi
  8002da:	50                   	push   %eax
  8002db:	e8 b2 ff ff ff       	call   800292 <va_is_mapped>
  8002e0:	83 c4 14             	add    $0x14,%esp
  8002e3:	85 c0                	test   %eax,%eax
  8002e5:	74 08                	je     8002ef <block_is_mapped+0x2c>
  8002e7:	85 db                	test   %ebx,%ebx
  8002e9:	74 04                	je     8002ef <block_is_mapped+0x2c>
  8002eb:	66 be 01 00          	mov    $0x1,%si
}
  8002ef:	89 f0                	mov    %esi,%eax
  8002f1:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8002f4:	5b                   	pop    %ebx
  8002f5:	5e                   	pop    %esi
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
	return (vpt[VPN(va)] & PTE_D) != 0;
  8002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fe:	c1 e8 0c             	shr    $0xc,%eax
  800301:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800308:	c1 e8 06             	shr    $0x6,%eax
  80030b:	83 e0 01             	and    $0x1,%eax
}
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <block_is_dirty>:

// Is this block dirty?
bool
block_is_dirty(uint32_t blockno)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	56                   	push   %esi
  800314:	53                   	push   %ebx
	char *va = diskaddr(blockno);
  800315:	83 ec 0c             	sub    $0xc,%esp
  800318:	ff 75 08             	pushl  0x8(%ebp)
  80031b:	e8 38 ff ff ff       	call   800258 <diskaddr>
  800320:	89 c3                	mov    %eax,%ebx
	return va_is_mapped(va) && va_is_dirty(va);
  800322:	be 00 00 00 00       	mov    $0x0,%esi
  800327:	50                   	push   %eax
  800328:	e8 65 ff ff ff       	call   800292 <va_is_mapped>
  80032d:	83 c4 14             	add    $0x14,%esp
  800330:	85 c0                	test   %eax,%eax
  800332:	74 11                	je     800345 <block_is_dirty+0x35>
  800334:	53                   	push   %ebx
  800335:	e8 be ff ff ff       	call   8002f8 <va_is_dirty>
  80033a:	83 c4 04             	add    $0x4,%esp
  80033d:	85 c0                	test   %eax,%eax
  80033f:	74 04                	je     800345 <block_is_dirty+0x35>
  800341:	66 be 01 00          	mov    $0x1,%si
}
  800345:	89 f0                	mov    %esi,%eax
  800347:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <map_block>:

// Allocate a page to hold the disk block
int
map_block(uint32_t blockno)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	53                   	push   %ebx
  800352:	83 ec 10             	sub    $0x10,%esp
  800355:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (block_is_mapped(blockno))
  800358:	53                   	push   %ebx
  800359:	e8 65 ff ff ff       	call   8002c3 <block_is_mapped>
  80035e:	83 c4 10             	add    $0x10,%esp
		return 0;
  800361:	ba 00 00 00 00       	mov    $0x0,%edx
  800366:	85 c0                	test   %eax,%eax
  800368:	75 1b                	jne    800385 <map_block+0x37>
	return sys_page_alloc(0, diskaddr(blockno), PTE_U|PTE_P|PTE_W);
  80036a:	83 ec 04             	sub    $0x4,%esp
  80036d:	6a 07                	push   $0x7
  80036f:	83 ec 04             	sub    $0x4,%esp
  800372:	53                   	push   %ebx
  800373:	e8 e0 fe ff ff       	call   800258 <diskaddr>
  800378:	83 c4 08             	add    $0x8,%esp
  80037b:	50                   	push   %eax
  80037c:	6a 00                	push   $0x0
  80037e:	e8 0f 23 00 00       	call   802692 <sys_page_alloc>
  800383:	89 c2                	mov    %eax,%edx
}
  800385:	89 d0                	mov    %edx,%eax
  800387:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <read_block>:

// Make sure a particular disk block is loaded into memory.
// Returns 0 on success, or a negative error code on error.
// 
// If blk != 0, set *blk to the address of the block in memory.
//
// Hint: Use diskaddr, map_block, and ide_read.
static int
read_block(uint32_t blockno, char **blk)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	57                   	push   %edi
  800390:	56                   	push   %esi
  800391:	53                   	push   %ebx
  800392:	83 ec 0c             	sub    $0xc,%esp
  800395:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800398:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *addr;

	if (super && blockno >= super->s_nblocks)
  80039b:	83 3d a4 c0 80 00 00 	cmpl   $0x0,0x80c0a4
  8003a2:	74 1c                	je     8003c0 <read_block+0x34>
  8003a4:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  8003a9:	39 58 04             	cmp    %ebx,0x4(%eax)
  8003ac:	77 12                	ja     8003c0 <read_block+0x34>
		panic("reading non-existent block %08x\n", blockno);
  8003ae:	53                   	push   %ebx
  8003af:	68 78 3f 80 00       	push   $0x803f78
  8003b4:	6a 48                	push   $0x48
  8003b6:	68 34 40 80 00       	push   $0x804034
  8003bb:	e8 0c 18 00 00       	call   801bcc <_panic>

	if (bitmap && block_is_free(blockno))
  8003c0:	83 3d a0 c0 80 00 00 	cmpl   $0x0,0x80c0a0
  8003c7:	74 22                	je     8003eb <read_block+0x5f>
  8003c9:	83 ec 0c             	sub    $0xc,%esp
  8003cc:	53                   	push   %ebx
  8003cd:	e8 c0 01 00 00       	call   800592 <block_is_free>
  8003d2:	83 c4 10             	add    $0x10,%esp
  8003d5:	85 c0                	test   %eax,%eax
  8003d7:	74 12                	je     8003eb <read_block+0x5f>
		panic("reading free block %08x\n", blockno);
  8003d9:	53                   	push   %ebx
  8003da:	68 3c 40 80 00       	push   $0x80403c
  8003df:	6a 4b                	push   $0x4b
  8003e1:	68 34 40 80 00       	push   $0x804034
  8003e6:	e8 e1 17 00 00       	call   801bcc <_panic>

	// LAB 5: Your code here.
        // seanyliu
	if ((r = map_block(blockno)) < 0) {
  8003eb:	83 ec 0c             	sub    $0xc,%esp
  8003ee:	53                   	push   %ebx
  8003ef:	e8 5a ff ff ff       	call   80034e <map_block>
  8003f4:	83 c4 10             	add    $0x10,%esp
          return r;
  8003f7:	89 c2                	mov    %eax,%edx
  8003f9:	85 c0                	test   %eax,%eax
  8003fb:	78 32                	js     80042f <read_block+0xa3>
        }

        addr = diskaddr(blockno);
  8003fd:	83 ec 0c             	sub    $0xc,%esp
  800400:	53                   	push   %ebx
  800401:	e8 52 fe ff ff       	call   800258 <diskaddr>
  800406:	89 c6                	mov    %eax,%esi
        if ((r = ide_read(blockno * BLKSECTS, addr, BLKSECTS)) < 0) {
  800408:	83 c4 0c             	add    $0xc,%esp
  80040b:	6a 08                	push   $0x8
  80040d:	50                   	push   %eax
  80040e:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
  800415:	50                   	push   %eax
  800416:	e8 d2 fc ff ff       	call   8000ed <ide_read>
  80041b:	83 c4 10             	add    $0x10,%esp
          return r;
  80041e:	89 c2                	mov    %eax,%edx
  800420:	85 c0                	test   %eax,%eax
  800422:	78 0b                	js     80042f <read_block+0xa3>
        }

        if (blk != 0) {
  800424:	85 ff                	test   %edi,%edi
  800426:	74 02                	je     80042a <read_block+0x9e>
          *blk = addr;
  800428:	89 37                	mov    %esi,(%edi)
        }
	//panic("read_block not implemented");
	return 0;
  80042a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80042f:	89 d0                	mov    %edx,%eax
  800431:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800434:	5b                   	pop    %ebx
  800435:	5e                   	pop    %esi
  800436:	5f                   	pop    %edi
  800437:	c9                   	leave  
  800438:	c3                   	ret    

00800439 <write_block>:

// Copy the current contents of the block out to disk.
// Then clear the PTE_D bit using sys_page_map.
// Hint: Use ide_write.
// Hint: Use the PTE_USER constant when calling sys_page_map.
void
write_block(uint32_t blockno)
{
  800439:	55                   	push   %ebp
  80043a:	89 e5                	mov    %esp,%ebp
  80043c:	56                   	push   %esi
  80043d:	53                   	push   %ebx
  80043e:	8b 75 08             	mov    0x8(%ebp),%esi
	char *addr;

	if (!block_is_mapped(blockno))
  800441:	83 ec 0c             	sub    $0xc,%esp
  800444:	56                   	push   %esi
  800445:	e8 79 fe ff ff       	call   8002c3 <block_is_mapped>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 12                	jne    800463 <write_block+0x2a>
		panic("write unmapped block %08x", blockno);
  800451:	56                   	push   %esi
  800452:	68 55 40 80 00       	push   $0x804055
  800457:	6a 69                	push   $0x69
  800459:	68 34 40 80 00       	push   $0x804034
  80045e:	e8 69 17 00 00       	call   801bcc <_panic>
	
	// Write the disk block and clear PTE_D.
	// LAB 5: Your code here.
        // seanyliu
        int r;
        addr = diskaddr(blockno);
  800463:	83 ec 0c             	sub    $0xc,%esp
  800466:	56                   	push   %esi
  800467:	e8 ec fd ff ff       	call   800258 <diskaddr>
  80046c:	89 c3                	mov    %eax,%ebx
        if ((r = ide_write(blockno * BLKSECTS, addr, BLKSECTS)) < 0) {
  80046e:	83 c4 0c             	add    $0xc,%esp
  800471:	6a 08                	push   $0x8
  800473:	50                   	push   %eax
  800474:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  80047b:	50                   	push   %eax
  80047c:	e8 20 fd ff ff       	call   8001a1 <ide_write>
  800481:	83 c4 10             	add    $0x10,%esp
  800484:	85 c0                	test   %eax,%eax
  800486:	79 12                	jns    80049a <write_block+0x61>
          panic("fs.c: write_block fail %d", r);
  800488:	50                   	push   %eax
  800489:	68 6f 40 80 00       	push   $0x80406f
  80048e:	6a 71                	push   $0x71
  800490:	68 34 40 80 00       	push   $0x804034
  800495:	e8 32 17 00 00       	call   801bcc <_panic>
        }

        // Then clear the PTE_D bit using sys_page_map.
        if ((r = sys_page_map(sys_getenvid(), addr, sys_getenvid(), addr, PTE_USER)) < 0) {
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	68 07 0e 00 00       	push   $0xe07
  8004a2:	53                   	push   %ebx
  8004a3:	83 ec 0c             	sub    $0xc,%esp
  8004a6:	e8 a9 21 00 00       	call   802654 <sys_getenvid>
  8004ab:	83 c4 0c             	add    $0xc,%esp
  8004ae:	50                   	push   %eax
  8004af:	53                   	push   %ebx
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	e8 9c 21 00 00       	call   802654 <sys_getenvid>
  8004b8:	89 04 24             	mov    %eax,(%esp)
  8004bb:	e8 15 22 00 00       	call   8026d5 <sys_page_map>
  8004c0:	83 c4 20             	add    $0x20,%esp
  8004c3:	85 c0                	test   %eax,%eax
  8004c5:	79 12                	jns    8004d9 <write_block+0xa0>
          panic("fs.c: sys_page_map fail %d", r);
  8004c7:	50                   	push   %eax
  8004c8:	68 89 40 80 00       	push   $0x804089
  8004cd:	6a 76                	push   $0x76
  8004cf:	68 34 40 80 00       	push   $0x804034
  8004d4:	e8 f3 16 00 00       	call   801bcc <_panic>
        }
        
	//panic("write_block not implemented");
}
  8004d9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8004dc:	5b                   	pop    %ebx
  8004dd:	5e                   	pop    %esi
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <unmap_block>:

// Make sure this block is unmapped.
void
unmap_block(uint32_t blockno)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	53                   	push   %ebx
  8004e4:	83 ec 10             	sub    $0x10,%esp
  8004e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;

	if (!block_is_mapped(blockno))
  8004ea:	53                   	push   %ebx
  8004eb:	e8 d3 fd ff ff       	call   8002c3 <block_is_mapped>
  8004f0:	83 c4 10             	add    $0x10,%esp
  8004f3:	85 c0                	test   %eax,%eax
  8004f5:	0f 84 92 00 00 00    	je     80058d <unmap_block+0xad>
		return;

	assert(block_is_free(blockno) || !block_is_dirty(blockno));
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	53                   	push   %ebx
  8004ff:	e8 8e 00 00 00       	call   800592 <block_is_free>
  800504:	83 c4 10             	add    $0x10,%esp
  800507:	85 c0                	test   %eax,%eax
  800509:	75 29                	jne    800534 <unmap_block+0x54>
  80050b:	83 ec 0c             	sub    $0xc,%esp
  80050e:	53                   	push   %ebx
  80050f:	e8 fc fd ff ff       	call   800310 <block_is_dirty>
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	85 c0                	test   %eax,%eax
  800519:	74 19                	je     800534 <unmap_block+0x54>
  80051b:	68 9c 3f 80 00       	push   $0x803f9c
  800520:	68 3d 3f 80 00       	push   $0x803f3d
  800525:	68 85 00 00 00       	push   $0x85
  80052a:	68 34 40 80 00       	push   $0x804034
  80052f:	e8 98 16 00 00       	call   801bcc <_panic>

	if ((r = sys_page_unmap(0, diskaddr(blockno))) < 0)
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	53                   	push   %ebx
  800538:	e8 1b fd ff ff       	call   800258 <diskaddr>
  80053d:	83 c4 08             	add    $0x8,%esp
  800540:	50                   	push   %eax
  800541:	6a 00                	push   $0x0
  800543:	e8 cf 21 00 00       	call   802717 <sys_page_unmap>
  800548:	83 c4 10             	add    $0x10,%esp
  80054b:	85 c0                	test   %eax,%eax
  80054d:	79 15                	jns    800564 <unmap_block+0x84>
		panic("unmap_block: sys_mem_unmap: %e", r);
  80054f:	50                   	push   %eax
  800550:	68 d0 3f 80 00       	push   $0x803fd0
  800555:	68 88 00 00 00       	push   $0x88
  80055a:	68 34 40 80 00       	push   $0x804034
  80055f:	e8 68 16 00 00       	call   801bcc <_panic>
	assert(!block_is_mapped(blockno));
  800564:	83 ec 0c             	sub    $0xc,%esp
  800567:	53                   	push   %ebx
  800568:	e8 56 fd ff ff       	call   8002c3 <block_is_mapped>
  80056d:	83 c4 10             	add    $0x10,%esp
  800570:	85 c0                	test   %eax,%eax
  800572:	74 19                	je     80058d <unmap_block+0xad>
  800574:	68 a4 40 80 00       	push   $0x8040a4
  800579:	68 3d 3f 80 00       	push   $0x803f3d
  80057e:	68 89 00 00 00       	push   $0x89
  800583:	68 34 40 80 00       	push   $0x804034
  800588:	e8 3f 16 00 00       	call   801bcc <_panic>
}
  80058d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	53                   	push   %ebx
  800596:	8b 55 08             	mov    0x8(%ebp),%edx
	if (super == 0 || blockno >= super->s_nblocks)
  800599:	83 3d a4 c0 80 00 00 	cmpl   $0x0,0x80c0a4
  8005a0:	74 0a                	je     8005ac <block_is_free+0x1a>
  8005a2:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  8005a7:	39 50 04             	cmp    %edx,0x4(%eax)
  8005aa:	77 07                	ja     8005b3 <block_is_free+0x21>
		return 0;
  8005ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b1:	eb 20                	jmp    8005d3 <block_is_free+0x41>
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  8005b3:	89 d3                	mov    %edx,%ebx
  8005b5:	c1 eb 05             	shr    $0x5,%ebx
  8005b8:	89 d1                	mov    %edx,%ecx
  8005ba:	83 e1 1f             	and    $0x1f,%ecx
  8005bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8005c2:	d3 e0                	shl    %cl,%eax
		return 1;
  8005c4:	8b 15 a0 c0 80 00    	mov    0x80c0a0,%edx
  8005ca:	85 04 9a             	test   %eax,(%edx,%ebx,4)
  8005cd:	0f 95 c0             	setne  %al
  8005d0:	0f b6 c0             	movzbl %al,%eax
	return 0;
}
  8005d3:	5b                   	pop    %ebx
  8005d4:	c9                   	leave  
  8005d5:	c3                   	ret    

008005d6 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	53                   	push   %ebx
  8005da:	83 ec 04             	sub    $0x4,%esp
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  8005e0:	85 c0                	test   %eax,%eax
  8005e2:	75 17                	jne    8005fb <free_block+0x25>
		panic("attempt to free zero block");
  8005e4:	83 ec 04             	sub    $0x4,%esp
  8005e7:	68 be 40 80 00       	push   $0x8040be
  8005ec:	68 9e 00 00 00       	push   $0x9e
  8005f1:	68 34 40 80 00       	push   $0x804034
  8005f6:	e8 d1 15 00 00       	call   801bcc <_panic>
	bitmap[blockno/32] |= 1<<(blockno%32);
  8005fb:	89 c3                	mov    %eax,%ebx
  8005fd:	c1 eb 05             	shr    $0x5,%ebx
  800600:	8b 15 a0 c0 80 00    	mov    0x80c0a0,%edx
  800606:	89 c1                	mov    %eax,%ecx
  800608:	83 e1 1f             	and    $0x1f,%ecx
  80060b:	b8 01 00 00 00       	mov    $0x1,%eax
  800610:	d3 e0                	shl    %cl,%eax
  800612:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  800615:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800618:	c9                   	leave  
  800619:	c3                   	ret    

0080061a <alloc_block_num>:

// Search the bitmap for a free block and allocate it.  When you
// allocate a block, immediately flush the changed bitmap block
// to disk.
// 
// Return block number allocated on success,
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block_num(void)
{
  80061a:	55                   	push   %ebp
  80061b:	89 e5                	mov    %esp,%ebp
  80061d:	57                   	push   %edi
  80061e:	56                   	push   %esi
  80061f:	53                   	push   %ebx
  800620:	83 ec 0c             	sub    $0xc,%esp
	// LAB 5: Your code here.
        // seanyliu
        int bidx;
        int editedva;
        int blockno;
        if (super == 0) {
          return -E_NO_DISK;
  800623:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800628:	83 3d a4 c0 80 00 00 	cmpl   $0x0,0x80c0a4
  80062f:	0f 84 a1 00 00 00    	je     8006d6 <alloc_block_num+0xbc>
        }
        for (bidx = 0; bidx < super->s_nblocks; bidx++) {
  800635:	bb 00 00 00 00       	mov    $0x0,%ebx
  80063a:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  80063f:	3b 58 04             	cmp    0x4(%eax),%ebx
  800642:	0f 83 89 00 00 00    	jae    8006d1 <alloc_block_num+0xb7>
          if (block_is_free(bidx)) {
  800648:	53                   	push   %ebx
  800649:	e8 44 ff ff ff       	call   800592 <block_is_free>
  80064e:	83 c4 04             	add    $0x4,%esp
  800651:	85 c0                	test   %eax,%eax
  800653:	74 6d                	je     8006c2 <alloc_block_num+0xa8>
            // update bitmap
	    bitmap[bidx/32] &= ~(1<<(bidx%32));
  800655:	89 d8                	mov    %ebx,%eax
  800657:	85 db                	test   %ebx,%ebx
  800659:	79 03                	jns    80065e <alloc_block_num+0x44>
  80065b:	8d 43 1f             	lea    0x1f(%ebx),%eax
  80065e:	89 c6                	mov    %eax,%esi
  800660:	c1 fe 05             	sar    $0x5,%esi
  800663:	8b 15 a0 c0 80 00    	mov    0x80c0a0,%edx
  800669:	89 d7                	mov    %edx,%edi
  80066b:	89 d8                	mov    %ebx,%eax
  80066d:	85 db                	test   %ebx,%ebx
  80066f:	79 03                	jns    800674 <alloc_block_num+0x5a>
  800671:	8d 43 1f             	lea    0x1f(%ebx),%eax
  800674:	83 e0 e0             	and    $0xffffffe0,%eax
  800677:	89 d9                	mov    %ebx,%ecx
  800679:	29 c1                	sub    %eax,%ecx
  80067b:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  800680:	d3 c0                	rol    %cl,%eax
  800682:	23 04 b7             	and    (%edi,%esi,4),%eax
  800685:	89 04 b2             	mov    %eax,(%edx,%esi,4)

            // find the va that was edited
            editedva = (int)&bitmap[bidx/32];
  800688:	89 d8                	mov    %ebx,%eax
  80068a:	85 db                	test   %ebx,%ebx
  80068c:	79 03                	jns    800691 <alloc_block_num+0x77>
  80068e:	8d 43 1f             	lea    0x1f(%ebx),%eax
  800691:	89 c2                	mov    %eax,%edx
  800693:	c1 fa 05             	sar    $0x5,%edx
  800696:	a1 a0 c0 80 00       	mov    0x80c0a0,%eax
  80069b:	8d 14 90             	lea    (%eax,%edx,4),%edx

            // find the block that was edited
            blockno = (editedva - DISKMAP) / BLKSIZE;
  80069e:	8d 82 00 00 00 f0    	lea    0xf0000000(%edx),%eax
  8006a4:	89 c1                	mov    %eax,%ecx
  8006a6:	85 c0                	test   %eax,%eax
  8006a8:	79 06                	jns    8006b0 <alloc_block_num+0x96>
  8006aa:	8d 8a ff 0f 00 f0    	lea    0xf0000fff(%edx),%ecx
  8006b0:	89 c8                	mov    %ecx,%eax
  8006b2:	c1 f8 0c             	sar    $0xc,%eax

            // update the block
            write_block(blockno);
  8006b5:	83 ec 0c             	sub    $0xc,%esp
  8006b8:	50                   	push   %eax
  8006b9:	e8 7b fd ff ff       	call   800439 <write_block>
            return bidx;
  8006be:	89 d8                	mov    %ebx,%eax
  8006c0:	eb 14                	jmp    8006d6 <alloc_block_num+0xbc>
  8006c2:	43                   	inc    %ebx
  8006c3:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  8006c8:	3b 58 04             	cmp    0x4(%eax),%ebx
  8006cb:	0f 82 77 ff ff ff    	jb     800648 <alloc_block_num+0x2e>
          }
        }
	//panic("alloc_block_num not implemented");
	return -E_NO_DISK;
  8006d1:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  8006d6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8006d9:	5b                   	pop    %ebx
  8006da:	5e                   	pop    %esi
  8006db:	5f                   	pop    %edi
  8006dc:	c9                   	leave  
  8006dd:	c3                   	ret    

008006de <alloc_block>:

// Allocate a block -- first find a free block in the bitmap,
// then map it into memory using map_block.
int
alloc_block(void)
{
  8006de:	55                   	push   %ebp
  8006df:	89 e5                	mov    %esp,%ebp
  8006e1:	56                   	push   %esi
  8006e2:	53                   	push   %ebx
	// LAB 5: Your code here.
        // seanyliu
        int r;
        int blockidx;
        // allocate a block
        if ((blockidx = alloc_block_num()) < 0) {
  8006e3:	e8 32 ff ff ff       	call   80061a <alloc_block_num>
  8006e8:	89 c3                	mov    %eax,%ebx
  8006ea:	85 db                	test   %ebx,%ebx
  8006ec:	78 1f                	js     80070d <alloc_block+0x2f>
          return blockidx;
        }
        // mape block into memory
	if ((r = map_block(blockidx)) < 0) {
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	53                   	push   %ebx
  8006f2:	e8 57 fc ff ff       	call   80034e <map_block>
  8006f7:	89 c6                	mov    %eax,%esi
  8006f9:	83 c4 10             	add    $0x10,%esp
          free_block(blockidx);
          return r; // -E_NO_MEM
        } else {
          return blockidx;
  8006fc:	89 d8                	mov    %ebx,%eax
  8006fe:	85 f6                	test   %esi,%esi
  800700:	79 0b                	jns    80070d <alloc_block+0x2f>
  800702:	83 ec 0c             	sub    $0xc,%esp
  800705:	53                   	push   %ebx
  800706:	e8 cb fe ff ff       	call   8005d6 <free_block>
  80070b:	89 f0                	mov    %esi,%eax
        }
	//panic("alloc_block not implemented");
	return -E_NO_DISK;
}
  80070d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800710:	5b                   	pop    %ebx
  800711:	5e                   	pop    %esi
  800712:	c9                   	leave  
  800713:	c3                   	ret    

00800714 <read_super>:

// Read and validate the file system super-block.
void
read_super(void)
{
  800714:	55                   	push   %ebp
  800715:	89 e5                	mov    %esp,%ebp
  800717:	83 ec 10             	sub    $0x10,%esp
	int r;
	char *blk;

	if ((r = read_block(1, &blk)) < 0)
  80071a:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80071d:	50                   	push   %eax
  80071e:	6a 01                	push   $0x1
  800720:	e8 67 fc ff ff       	call   80038c <read_block>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	85 c0                	test   %eax,%eax
  80072a:	79 15                	jns    800741 <read_super+0x2d>
		panic("cannot read superblock: %e", r);
  80072c:	50                   	push   %eax
  80072d:	68 d9 40 80 00       	push   $0x8040d9
  800732:	68 e9 00 00 00       	push   $0xe9
  800737:	68 34 40 80 00       	push   $0x804034
  80073c:	e8 8b 14 00 00       	call   801bcc <_panic>

	super = (struct Super*) blk;
  800741:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  800744:	a3 a4 c0 80 00       	mov    %eax,0x80c0a4
	if (super->s_magic != FS_MAGIC)
  800749:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  80074f:	74 17                	je     800768 <read_super+0x54>
		panic("bad file system magic number");
  800751:	83 ec 04             	sub    $0x4,%esp
  800754:	68 f4 40 80 00       	push   $0x8040f4
  800759:	68 ed 00 00 00       	push   $0xed
  80075e:	68 34 40 80 00       	push   $0x804034
  800763:	e8 64 14 00 00       	call   801bcc <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800768:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  80076d:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800774:	76 17                	jbe    80078d <read_super+0x79>
		panic("file system is too large");
  800776:	83 ec 04             	sub    $0x4,%esp
  800779:	68 11 41 80 00       	push   $0x804111
  80077e:	68 f0 00 00 00       	push   $0xf0
  800783:	68 34 40 80 00       	push   $0x804034
  800788:	e8 3f 14 00 00       	call   801bcc <_panic>

	cprintf("superblock is good\n");
  80078d:	83 ec 0c             	sub    $0xc,%esp
  800790:	68 2a 41 80 00       	push   $0x80412a
  800795:	e8 22 15 00 00       	call   801cbc <cprintf>
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <read_bitmap>:

// Read and validate the file system bitmap.
//
// Read all the bitmap blocks into memory.
// Set the "bitmap" pointer to point at the beginning of the first
// bitmap block.
// 
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use
// (for each block i, assert(!block_is_free(i))).
//
// Hint: Assume that the superblock has already been loaded into
// memory (in variable 'super').  Check out super->s_nblocks.
void
read_bitmap(void)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	53                   	push   %ebx
  8007a0:	83 ec 04             	sub    $0x4,%esp
	int r;
	uint32_t i;
	char *blk;

	// Read the bitmap into memory.
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.
	// Set 'bitmap' to point to the first address in the bitmap.
	// Hint: Use read_block.
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++) {
  8007a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007a8:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  8007ad:	3b 58 04             	cmp    0x4(%eax),%ebx
  8007b0:	73 75                	jae    800827 <read_bitmap+0x8b>
		if ((r = read_block(2+i, &blk)) < 0)
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8007b8:	50                   	push   %eax
  8007b9:	8d 43 02             	lea    0x2(%ebx),%eax
  8007bc:	50                   	push   %eax
  8007bd:	e8 ca fb ff ff       	call   80038c <read_block>
  8007c2:	83 c4 10             	add    $0x10,%esp
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	79 19                	jns    8007e2 <read_bitmap+0x46>
			panic("cannot read bitmap block %d: %e", i, r);
  8007c9:	83 ec 0c             	sub    $0xc,%esp
  8007cc:	50                   	push   %eax
  8007cd:	53                   	push   %ebx
  8007ce:	68 f0 3f 80 00       	push   $0x803ff0
  8007d3:	68 10 01 00 00       	push   $0x110
  8007d8:	68 34 40 80 00       	push   $0x804034
  8007dd:	e8 ea 13 00 00       	call   801bcc <_panic>
		if (i == 0)
  8007e2:	85 db                	test   %ebx,%ebx
  8007e4:	75 08                	jne    8007ee <read_bitmap+0x52>
			bitmap = (uint32_t*) blk;
  8007e6:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8007e9:	a3 a0 c0 80 00       	mov    %eax,0x80c0a0
		// Make sure all bitmap blocks are marked in-use
		assert(!block_is_free(2+i));
  8007ee:	8d 43 02             	lea    0x2(%ebx),%eax
  8007f1:	50                   	push   %eax
  8007f2:	e8 9b fd ff ff       	call   800592 <block_is_free>
  8007f7:	83 c4 04             	add    $0x4,%esp
  8007fa:	85 c0                	test   %eax,%eax
  8007fc:	74 19                	je     800817 <read_bitmap+0x7b>
  8007fe:	68 3e 41 80 00       	push   $0x80413e
  800803:	68 3d 3f 80 00       	push   $0x803f3d
  800808:	68 14 01 00 00       	push   $0x114
  80080d:	68 34 40 80 00       	push   $0x804034
  800812:	e8 b5 13 00 00       	call   801bcc <_panic>
  800817:	43                   	inc    %ebx
  800818:	89 da                	mov    %ebx,%edx
  80081a:	c1 e2 0f             	shl    $0xf,%edx
  80081d:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  800822:	3b 50 04             	cmp    0x4(%eax),%edx
  800825:	72 8b                	jb     8007b2 <read_bitmap+0x16>
	}

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800827:	6a 00                	push   $0x0
  800829:	e8 64 fd ff ff       	call   800592 <block_is_free>
  80082e:	83 c4 04             	add    $0x4,%esp
  800831:	85 c0                	test   %eax,%eax
  800833:	74 19                	je     80084e <read_bitmap+0xb2>
  800835:	68 52 41 80 00       	push   $0x804152
  80083a:	68 3d 3f 80 00       	push   $0x803f3d
  80083f:	68 18 01 00 00       	push   $0x118
  800844:	68 34 40 80 00       	push   $0x804034
  800849:	e8 7e 13 00 00       	call   801bcc <_panic>
	assert(!block_is_free(1));
  80084e:	6a 01                	push   $0x1
  800850:	e8 3d fd ff ff       	call   800592 <block_is_free>
  800855:	83 c4 04             	add    $0x4,%esp
  800858:	85 c0                	test   %eax,%eax
  80085a:	74 19                	je     800875 <read_bitmap+0xd9>
  80085c:	68 64 41 80 00       	push   $0x804164
  800861:	68 3d 3f 80 00       	push   $0x803f3d
  800866:	68 19 01 00 00       	push   $0x119
  80086b:	68 34 40 80 00       	push   $0x804034
  800870:	e8 57 13 00 00       	call   801bcc <_panic>
	assert(bitmap);
  800875:	83 3d a0 c0 80 00 00 	cmpl   $0x0,0x80c0a0
  80087c:	75 19                	jne    800897 <read_bitmap+0xfb>
  80087e:	68 76 41 80 00       	push   $0x804176
  800883:	68 3d 3f 80 00       	push   $0x803f3d
  800888:	68 1a 01 00 00       	push   $0x11a
  80088d:	68 34 40 80 00       	push   $0x804034
  800892:	e8 35 13 00 00       	call   801bcc <_panic>

	cprintf("read_bitmap is good\n");
  800897:	83 ec 0c             	sub    $0xc,%esp
  80089a:	68 7d 41 80 00       	push   $0x80417d
  80089f:	e8 18 14 00 00       	call   801cbc <cprintf>
}
  8008a4:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8008a7:	c9                   	leave  
  8008a8:	c3                   	ret    

008008a9 <check_write_block>:

// Test that write_block works, by smashing the superblock and reading it back.
void
check_write_block(void)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	83 ec 10             	sub    $0x10,%esp
	super = 0;
  8008af:	c7 05 a4 c0 80 00 00 	movl   $0x0,0x80c0a4
  8008b6:	00 00 00 

	// back up super block
	read_block(0, 0);
  8008b9:	6a 00                	push   $0x0
  8008bb:	6a 00                	push   $0x0
  8008bd:	e8 ca fa ff ff       	call   80038c <read_block>
	memmove(diskaddr(0), diskaddr(1), PGSIZE);
  8008c2:	83 c4 0c             	add    $0xc,%esp
  8008c5:	68 00 10 00 00       	push   $0x1000
  8008ca:	83 ec 04             	sub    $0x4,%esp
  8008cd:	6a 01                	push   $0x1
  8008cf:	e8 84 f9 ff ff       	call   800258 <diskaddr>
  8008d4:	83 c4 08             	add    $0x8,%esp
  8008d7:	50                   	push   %eax
  8008d8:	6a 00                	push   $0x0
  8008da:	e8 79 f9 ff ff       	call   800258 <diskaddr>
  8008df:	89 04 24             	mov    %eax,(%esp)
  8008e2:	e8 55 1b 00 00       	call   80243c <memmove>

	// smash it 
	strcpy(diskaddr(1), "OOPS!\n");
  8008e7:	83 c4 08             	add    $0x8,%esp
  8008ea:	68 92 41 80 00       	push   $0x804192
  8008ef:	6a 01                	push   $0x1
  8008f1:	e8 62 f9 ff ff       	call   800258 <diskaddr>
  8008f6:	89 04 24             	mov    %eax,(%esp)
  8008f9:	e8 c2 19 00 00       	call   8022c0 <strcpy>
	write_block(1);
  8008fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800905:	e8 2f fb ff ff       	call   800439 <write_block>
	assert(block_is_mapped(1));
  80090a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800911:	e8 ad f9 ff ff       	call   8002c3 <block_is_mapped>
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	85 c0                	test   %eax,%eax
  80091b:	75 19                	jne    800936 <check_write_block+0x8d>
  80091d:	68 b4 41 80 00       	push   $0x8041b4
  800922:	68 3d 3f 80 00       	push   $0x803f3d
  800927:	68 2c 01 00 00       	push   $0x12c
  80092c:	68 34 40 80 00       	push   $0x804034
  800931:	e8 96 12 00 00       	call   801bcc <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800936:	83 ec 0c             	sub    $0xc,%esp
  800939:	6a 01                	push   $0x1
  80093b:	e8 18 f9 ff ff       	call   800258 <diskaddr>
  800940:	83 c4 10             	add    $0x10,%esp
  800943:	50                   	push   %eax
  800944:	e8 af f9 ff ff       	call   8002f8 <va_is_dirty>
  800949:	83 c4 04             	add    $0x4,%esp
  80094c:	85 c0                	test   %eax,%eax
  80094e:	74 19                	je     800969 <check_write_block+0xc0>
  800950:	68 99 41 80 00       	push   $0x804199
  800955:	68 3d 3f 80 00       	push   $0x803f3d
  80095a:	68 2d 01 00 00       	push   $0x12d
  80095f:	68 34 40 80 00       	push   $0x804034
  800964:	e8 63 12 00 00       	call   801bcc <_panic>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800969:	83 ec 0c             	sub    $0xc,%esp
  80096c:	6a 01                	push   $0x1
  80096e:	e8 e5 f8 ff ff       	call   800258 <diskaddr>
  800973:	83 c4 08             	add    $0x8,%esp
  800976:	50                   	push   %eax
  800977:	6a 00                	push   $0x0
  800979:	e8 99 1d 00 00       	call   802717 <sys_page_unmap>
	assert(!block_is_mapped(1));
  80097e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800985:	e8 39 f9 ff ff       	call   8002c3 <block_is_mapped>
  80098a:	83 c4 10             	add    $0x10,%esp
  80098d:	85 c0                	test   %eax,%eax
  80098f:	74 19                	je     8009aa <check_write_block+0x101>
  800991:	68 b3 41 80 00       	push   $0x8041b3
  800996:	68 3d 3f 80 00       	push   $0x803f3d
  80099b:	68 31 01 00 00       	push   $0x131
  8009a0:	68 34 40 80 00       	push   $0x804034
  8009a5:	e8 22 12 00 00       	call   801bcc <_panic>

	// read it back in
	read_block(1, 0);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	6a 00                	push   $0x0
  8009af:	6a 01                	push   $0x1
  8009b1:	e8 d6 f9 ff ff       	call   80038c <read_block>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8009b6:	83 c4 08             	add    $0x8,%esp
  8009b9:	68 92 41 80 00       	push   $0x804192
  8009be:	6a 01                	push   $0x1
  8009c0:	e8 93 f8 ff ff       	call   800258 <diskaddr>
  8009c5:	89 04 24             	mov    %eax,(%esp)
  8009c8:	e8 74 19 00 00       	call   802341 <strcmp>
  8009cd:	83 c4 10             	add    $0x10,%esp
  8009d0:	85 c0                	test   %eax,%eax
  8009d2:	74 19                	je     8009ed <check_write_block+0x144>
  8009d4:	68 10 40 80 00       	push   $0x804010
  8009d9:	68 3d 3f 80 00       	push   $0x803f3d
  8009de:	68 35 01 00 00       	push   $0x135
  8009e3:	68 34 40 80 00       	push   $0x804034
  8009e8:	e8 df 11 00 00       	call   801bcc <_panic>

	// fix it
	memmove(diskaddr(1), diskaddr(0), PGSIZE);
  8009ed:	83 ec 04             	sub    $0x4,%esp
  8009f0:	68 00 10 00 00       	push   $0x1000
  8009f5:	83 ec 04             	sub    $0x4,%esp
  8009f8:	6a 00                	push   $0x0
  8009fa:	e8 59 f8 ff ff       	call   800258 <diskaddr>
  8009ff:	83 c4 08             	add    $0x8,%esp
  800a02:	50                   	push   %eax
  800a03:	6a 01                	push   $0x1
  800a05:	e8 4e f8 ff ff       	call   800258 <diskaddr>
  800a0a:	89 04 24             	mov    %eax,(%esp)
  800a0d:	e8 2a 1a 00 00       	call   80243c <memmove>
	write_block(1);
  800a12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a19:	e8 1b fa ff ff       	call   800439 <write_block>
	super = (struct Super*)diskaddr(1);
  800a1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a25:	e8 2e f8 ff ff       	call   800258 <diskaddr>
  800a2a:	a3 a4 c0 80 00       	mov    %eax,0x80c0a4

	cprintf("write_block is good\n");
  800a2f:	c7 04 24 c7 41 80 00 	movl   $0x8041c7,(%esp)
  800a36:	e8 81 12 00 00       	call   801cbc <cprintf>
}
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <fs_init>:

// Initialize the file system
void
fs_init(void)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	83 ec 08             	sub    $0x8,%esp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  800a43:	e8 1d f6 ff ff       	call   800065 <ide_probe_disk1>
  800a48:	85 c0                	test   %eax,%eax
  800a4a:	74 0f                	je     800a5b <fs_init+0x1e>
		ide_set_disk(1);
  800a4c:	83 ec 0c             	sub    $0xc,%esp
  800a4f:	6a 01                	push   $0x1
  800a51:	e8 6e f6 ff ff       	call   8000c4 <ide_set_disk>
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	eb 0d                	jmp    800a68 <fs_init+0x2b>
	else
		ide_set_disk(0);
  800a5b:	83 ec 0c             	sub    $0xc,%esp
  800a5e:	6a 00                	push   $0x0
  800a60:	e8 5f f6 ff ff       	call   8000c4 <ide_set_disk>
  800a65:	83 c4 10             	add    $0x10,%esp
	
	read_super();
  800a68:	e8 a7 fc ff ff       	call   800714 <read_super>
	check_write_block();
  800a6d:	e8 37 fe ff ff       	call   8008a9 <check_write_block>
	read_bitmap();
  800a72:	e8 25 fd ff ff       	call   80079c <read_bitmap>
}
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    

00800a79 <file_block_walk>:

// Find the disk block number slot for the 'filebno'th block in file 'f'.
// Set '*ppdiskbno' to point to that slot.
// The slot will be one of the f->f_direct[] entries,
// or an entry in the indirect block.
// When 'alloc' is set, this function will allocate an indirect block
// if necessary.
//
// Returns:
//	0 on success (but note that *ppdiskbno might equal 0).
//	-E_NOT_FOUND if the function needed to allocate an indirect block, but
//		alloc was 0.
//	-E_NO_DISK if there's no space on the disk for an indirect block.
//	-E_NO_MEM if there's no space in memory for an indirect block.
//	-E_INVAL if filebno is out of range (it's >= NINDIRECT).
//
// Analogy: This is like pgdir_walk for files.  
// Hint: Don't forget to clear any block you allocate.
int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	57                   	push   %edi
  800a7d:	56                   	push   %esi
  800a7e:	53                   	push   %ebx
  800a7f:	83 ec 0c             	sub    $0xc,%esp
  800a82:	8b 75 08             	mov    0x8(%ebp),%esi
  800a85:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a88:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// LAB 5: Your code here.
        // seanyliu

        int newblock;
        int r;
        char* indirectblock;

        // -E_INVAL if filebno is out of range (it's >= NINDIRECT).
        if (filebno >= NINDIRECT) {
          return -E_INVAL;
  800a8b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800a90:	81 ff ff 03 00 00    	cmp    $0x3ff,%edi
  800a96:	0f 87 81 00 00 00    	ja     800b1d <file_block_walk+0xa4>
        }

        // Set '*ppdiskbno' to point to that slot.
        if (filebno < NDIRECT) {
  800a9c:	83 ff 09             	cmp    $0x9,%edi
  800a9f:	77 0e                	ja     800aaf <file_block_walk+0x36>
          // assume the direct block is allocated
          *ppdiskbno = &f->f_direct[filebno];
  800aa1:	8d 84 be 88 00 00 00 	lea    0x88(%esi,%edi,4),%eax
  800aa8:	8b 55 10             	mov    0x10(%ebp),%edx
  800aab:	89 02                	mov    %eax,(%edx)
  800aad:	eb 69                	jmp    800b18 <file_block_walk+0x9f>
        } else {
          // indirect block entry
          if (f->f_indirect == 0) {
  800aaf:	83 be b0 00 00 00 00 	cmpl   $0x0,0xb0(%esi)
  800ab6:	75 1c                	jne    800ad4 <file_block_walk+0x5b>
            // require an indirect block
            if (alloc == 0) {
              return -E_NOT_FOUND;
  800ab8:	ba f5 ff ff ff       	mov    $0xfffffff5,%edx
  800abd:	85 db                	test   %ebx,%ebx
  800abf:	74 5c                	je     800b1d <file_block_walk+0xa4>
            }
            if ((newblock = alloc_block()) < 0) {
  800ac1:	e8 18 fc ff ff       	call   8006de <alloc_block>
              return newblock; // -E_NO_DISK, -E_NO_MEM, performs free_block on fail
  800ac6:	89 c2                	mov    %eax,%edx
  800ac8:	85 c0                	test   %eax,%eax
  800aca:	78 51                	js     800b1d <file_block_walk+0xa4>
            }
            f->f_indirect = newblock;
  800acc:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
  800ad2:	eb 05                	jmp    800ad9 <file_block_walk+0x60>
          } else {
            alloc = 0; // flag so we know that no alloc was made
  800ad4:	bb 00 00 00 00       	mov    $0x0,%ebx
          }

          // read out the indirect block
          if ((r = read_block(f->f_indirect, &indirectblock)) < 0) {
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  800adf:	50                   	push   %eax
  800ae0:	ff b6 b0 00 00 00    	pushl  0xb0(%esi)
  800ae6:	e8 a1 f8 ff ff       	call   80038c <read_block>
  800aeb:	83 c4 10             	add    $0x10,%esp
            return r;
  800aee:	89 c2                	mov    %eax,%edx
  800af0:	85 c0                	test   %eax,%eax
  800af2:	78 29                	js     800b1d <file_block_walk+0xa4>
          }
          if (alloc != 0) memset(indirectblock, 0, BLKSIZE);
  800af4:	85 db                	test   %ebx,%ebx
  800af6:	74 15                	je     800b0d <file_block_walk+0x94>
  800af8:	83 ec 04             	sub    $0x4,%esp
  800afb:	68 00 10 00 00       	push   $0x1000
  800b00:	6a 00                	push   $0x0
  800b02:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800b05:	e8 df 18 00 00       	call   8023e9 <memset>
  800b0a:	83 c4 10             	add    $0x10,%esp

          *ppdiskbno = (uint32_t *)indirectblock + filebno;
  800b0d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  800b10:	8d 04 b8             	lea    (%eax,%edi,4),%eax
  800b13:	8b 55 10             	mov    0x10(%ebp),%edx
  800b16:	89 02                	mov    %eax,(%edx)
        }

        return 0;
  800b18:	ba 00 00 00 00       	mov    $0x0,%edx
	//panic("file_block_walk not implemented");
	//return -E_NO_DISK;
}
  800b1d:	89 d0                	mov    %edx,%eax
  800b1f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5f                   	pop    %edi
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    

00800b27 <file_map_block>:


// Set '*diskbno' to the disk block number for the 'filebno'th block
// in file 'f'.
// If 'alloc' is set and the block does not exist, allocate it.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_NOT_FOUND if alloc was 0 but the block did not exist.
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_NO_MEM if we're out of memory.
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk.

int
file_map_block(struct File *f, uint32_t filebno, uint32_t *diskbno, bool alloc)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	53                   	push   %ebx
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// LAB 5: Your code here.
        int r;
        uint32_t* newblock;
        if ((r = file_block_walk(f, filebno, &newblock, alloc)) < 0) {
  800b31:	53                   	push   %ebx
  800b32:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800b35:	50                   	push   %eax
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	ff 75 08             	pushl  0x8(%ebp)
  800b3c:	e8 38 ff ff ff       	call   800a79 <file_block_walk>
  800b41:	83 c4 10             	add    $0x10,%esp
          return r;
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	85 c0                	test   %eax,%eax
  800b48:	78 2a                	js     800b74 <file_map_block+0x4d>
        }
        if (*newblock == 0) {
  800b4a:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800b4d:	83 38 00             	cmpl   $0x0,(%eax)
  800b50:	75 13                	jne    800b65 <file_map_block+0x3e>
          if (alloc == 0) return -E_NOT_FOUND;
  800b52:	ba f5 ff ff ff       	mov    $0xfffffff5,%edx
  800b57:	85 db                	test   %ebx,%ebx
  800b59:	74 19                	je     800b74 <file_map_block+0x4d>
          if ((*newblock = alloc_block()) < 0) {
  800b5b:	8b 5d f8             	mov    0xfffffff8(%ebp),%ebx
  800b5e:	e8 7b fb ff ff       	call   8006de <alloc_block>
  800b63:	89 03                	mov    %eax,(%ebx)
            return *newblock; // -E_NO_DISK, -E_NO_MEM, performs free_block on fail
          }
        }
        *diskbno = *newblock;
  800b65:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  800b68:	8b 10                	mov    (%eax),%edx
  800b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6d:	89 10                	mov    %edx,(%eax)
        return 0;
  800b6f:	ba 00 00 00 00       	mov    $0x0,%edx
	//panic("file_map_block not implemented");
	//return -E_NO_DISK;
}
  800b74:	89 d0                	mov    %edx,%eax
  800b76:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <file_clear_block>:


// Remove a block from file f.  If it's not there, just silently succeed.
// Returns 0 on success, < 0 on error.
int
file_clear_block(struct File *f, uint32_t filebno)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 08             	sub    $0x8,%esp
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800b81:	6a 00                	push   $0x0
  800b83:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	ff 75 08             	pushl  0x8(%ebp)
  800b8d:	e8 e7 fe ff ff       	call   800a79 <file_block_walk>
  800b92:	83 c4 10             	add    $0x10,%esp
		return r;
  800b95:	89 c2                	mov    %eax,%edx
  800b97:	85 c0                	test   %eax,%eax
  800b99:	78 23                	js     800bbe <file_clear_block+0x43>
	if (*ptr) {
  800b9b:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  800b9e:	83 38 00             	cmpl   $0x0,(%eax)
  800ba1:	74 16                	je     800bb9 <file_clear_block+0x3e>
		free_block(*ptr);
  800ba3:	83 ec 0c             	sub    $0xc,%esp
  800ba6:	ff 30                	pushl  (%eax)
  800ba8:	e8 29 fa ff ff       	call   8005d6 <free_block>
		*ptr = 0;
  800bad:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  800bb0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800bb6:	83 c4 10             	add    $0x10,%esp
	}
	return 0;
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <file_get_block>:

// Set *blk to point at the filebno'th block in file 'f'.
// Allocate the block if it doesn't yet exist.
// Returns 0 on success, < 0 on error.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	83 ec 08             	sub    $0x8,%esp
	int r;
	uint32_t diskbno;

	// Read in the block, leaving the pointer in *blk.
	// Hint: Use file_map_block and read_block.
	// LAB 5: Your code here.
        // seanyliu
        if ((r = file_map_block(f, filebno, &diskbno, 1)) < 0) {
  800bc8:	6a 01                	push   $0x1
  800bca:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800bcd:	50                   	push   %eax
  800bce:	ff 75 0c             	pushl  0xc(%ebp)
  800bd1:	ff 75 08             	pushl  0x8(%ebp)
  800bd4:	e8 4e ff ff ff       	call   800b27 <file_map_block>
  800bd9:	83 c4 10             	add    $0x10,%esp
          return r;
  800bdc:	89 c2                	mov    %eax,%edx
  800bde:	85 c0                	test   %eax,%eax
  800be0:	78 1c                	js     800bfe <file_get_block+0x3c>
        }
        if ((r = read_block(diskbno, blk)) < 0) {
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 10             	pushl  0x10(%ebp)
  800be8:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  800beb:	e8 9c f7 ff ff       	call   80038c <read_block>
  800bf0:	83 c4 10             	add    $0x10,%esp
          return r;
  800bf3:	89 c2                	mov    %eax,%edx
  800bf5:	85 c0                	test   %eax,%eax
  800bf7:	78 05                	js     800bfe <file_get_block+0x3c>
        }
	//panic("file_get_block not implemented");
	return 0;
  800bf9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bfe:	89 d0                	mov    %edx,%eax
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <file_dirty>:

// Mark the offset/BLKSIZE'th block dirty in file f
// by writing its first word to itself.  
int
file_dirty(struct File *f, off_t offset)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 0c             	sub    $0xc,%esp
	int r;
	char *blk;

	// LAB 5: Your code here.
        // seanyliu
        if ((r = file_get_block(f, offset/BLKSIZE, &blk)) < 0) {
  800c08:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  800c0b:	50                   	push   %eax
  800c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0f:	85 c0                	test   %eax,%eax
  800c11:	79 05                	jns    800c18 <file_dirty+0x16>
  800c13:	05 ff 0f 00 00       	add    $0xfff,%eax
  800c18:	c1 f8 0c             	sar    $0xc,%eax
  800c1b:	50                   	push   %eax
  800c1c:	ff 75 08             	pushl  0x8(%ebp)
  800c1f:	e8 9e ff ff ff       	call   800bc2 <file_get_block>
  800c24:	83 c4 10             	add    $0x10,%esp
          return r;
  800c27:	89 c2                	mov    %eax,%edx
  800c29:	85 c0                	test   %eax,%eax
  800c2b:	78 05                	js     800c32 <file_dirty+0x30>
        }
        *blk = *blk;

	//panic("file_dirty not implemented");
	return 0;
  800c2d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <dir_lookup>:

// Try to find a file named "name" in dir.  If so, set *file to it.
int
dir_lookup(struct File *dir, const char *name, struct File **file)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
  800c3c:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	uint32_t i, j, nblock;
	char *blk;
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	66 f7 80 80 00 00 00 	testw  $0xfff,0x80(%eax)
  800c49:	ff 0f 
  800c4b:	74 32                	je     800c7f <dir_lookup+0x49>
  800c4d:	68 dc 41 80 00       	push   $0x8041dc
  800c52:	68 3d 3f 80 00       	push   $0x803f3d
  800c57:	68 fb 01 00 00       	push   $0x1fb
  800c5c:	68 34 40 80 00       	push   $0x804034
  800c61:	e8 66 0f 00 00       	call   801bcc <_panic>
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
				*file = &f[j];
  800c66:	8b 45 10             	mov    0x10(%ebp),%eax
  800c69:	89 30                	mov    %esi,(%eax)
				f[j].f_dir = dir;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  800c71:	89 84 17 b4 00 00 00 	mov    %eax,0xb4(%edi,%edx,1)
				return 0;
  800c78:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7d:	eb 7c                	jmp    800cfb <dir_lookup+0xc5>
  800c7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c82:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	79 05                	jns    800c91 <dir_lookup+0x5b>
  800c8c:	05 ff 0f 00 00       	add    $0xfff,%eax
  800c91:	c1 f8 0c             	sar    $0xc,%eax
  800c94:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  800c97:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  800c9e:	39 45 ec             	cmp    %eax,0xffffffec(%ebp)
  800ca1:	73 53                	jae    800cf6 <dir_lookup+0xc0>
  800ca3:	83 ec 04             	sub    $0x4,%esp
  800ca6:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  800ca9:	50                   	push   %eax
  800caa:	ff 75 ec             	pushl  0xffffffec(%ebp)
  800cad:	ff 75 08             	pushl  0x8(%ebp)
  800cb0:	e8 0d ff ff ff       	call   800bc2 <file_get_block>
  800cb5:	83 c4 10             	add    $0x10,%esp
  800cb8:	85 c0                	test   %eax,%eax
  800cba:	78 3f                	js     800cfb <dir_lookup+0xc5>
  800cbc:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  800cbf:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  800cc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc7:	83 ec 08             	sub    $0x8,%esp
  800cca:	ff 75 0c             	pushl  0xc(%ebp)
  800ccd:	89 df                	mov    %ebx,%edi
  800ccf:	c1 e7 08             	shl    $0x8,%edi
  800cd2:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  800cd5:	8d 34 17             	lea    (%edi,%edx,1),%esi
  800cd8:	56                   	push   %esi
  800cd9:	e8 63 16 00 00       	call   802341 <strcmp>
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	74 81                	je     800c66 <dir_lookup+0x30>
  800ce5:	43                   	inc    %ebx
  800ce6:	83 fb 0f             	cmp    $0xf,%ebx
  800ce9:	76 dc                	jbe    800cc7 <dir_lookup+0x91>
  800ceb:	ff 45 ec             	incl   0xffffffec(%ebp)
  800cee:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800cf1:	39 45 ec             	cmp    %eax,0xffffffec(%ebp)
  800cf4:	72 ad                	jb     800ca3 <dir_lookup+0x6d>
			}
	}
	return -E_NOT_FOUND;
  800cf6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800cfb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <dir_alloc_file>:

// Set *file to point at a free File structure in dir.
int
dir_alloc_file(struct File *dir, struct File **file)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 0c             	sub    $0xc,%esp
  800d0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  800d0f:	66 f7 83 80 00 00 00 	testw  $0xfff,0x80(%ebx)
  800d16:	ff 0f 
  800d18:	74 19                	je     800d33 <dir_alloc_file+0x30>
  800d1a:	68 dc 41 80 00       	push   $0x8041dc
  800d1f:	68 3d 3f 80 00       	push   $0x803f3d
  800d24:	68 14 02 00 00       	push   $0x214
  800d29:	68 34 40 80 00       	push   $0x804034
  800d2e:	e8 99 0e 00 00       	call   801bcc <_panic>
	nblock = dir->f_size / BLKSIZE;
  800d33:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	79 05                	jns    800d42 <dir_alloc_file+0x3f>
  800d3d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800d42:	89 c7                	mov    %eax,%edi
  800d44:	c1 ff 0c             	sar    $0xc,%edi
	for (i = 0; i < nblock; i++) {
  800d47:	be 00 00 00 00       	mov    $0x0,%esi
  800d4c:	39 fe                	cmp    %edi,%esi
  800d4e:	73 33                	jae    800d83 <dir_alloc_file+0x80>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800d50:	83 ec 04             	sub    $0x4,%esp
  800d53:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  800d56:	50                   	push   %eax
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	e8 64 fe ff ff       	call   800bc2 <file_get_block>
  800d5e:	83 c4 10             	add    $0x10,%esp
  800d61:	85 c0                	test   %eax,%eax
  800d63:	78 41                	js     800da6 <dir_alloc_file+0xa3>
			return r;
		f = (struct File*) blk;
  800d65:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
		for (j = 0; j < BLKFILES; j++)
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
			if (f[j].f_name[0] == '\0') {
  800d6d:	89 c2                	mov    %eax,%edx
  800d6f:	c1 e2 08             	shl    $0x8,%edx
  800d72:	80 3c 0a 00          	cmpb   $0x0,(%edx,%ecx,1)
  800d76:	74 32                	je     800daa <dir_alloc_file+0xa7>
  800d78:	40                   	inc    %eax
  800d79:	83 f8 0f             	cmp    $0xf,%eax
  800d7c:	76 ef                	jbe    800d6d <dir_alloc_file+0x6a>
  800d7e:	46                   	inc    %esi
  800d7f:	39 fe                	cmp    %edi,%esi
  800d81:	72 cd                	jb     800d50 <dir_alloc_file+0x4d>
				*file = &f[j];
				f[j].f_dir = dir;
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  800d83:	81 83 80 00 00 00 00 	addl   $0x1000,0x80(%ebx)
  800d8a:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  800d8d:	83 ec 04             	sub    $0x4,%esp
  800d90:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  800d93:	50                   	push   %eax
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	e8 27 fe ff ff       	call   800bc2 <file_get_block>
  800d9b:	83 c4 10             	add    $0x10,%esp
		return r;
  800d9e:	89 c2                	mov    %eax,%edx
  800da0:	85 c0                	test   %eax,%eax
  800da2:	78 2f                	js     800dd3 <dir_alloc_file+0xd0>
  800da4:	eb 1a                	jmp    800dc0 <dir_alloc_file+0xbd>
  800da6:	89 c2                	mov    %eax,%edx
  800da8:	eb 29                	jmp    800dd3 <dir_alloc_file+0xd0>
  800daa:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  800dad:	8b 75 0c             	mov    0xc(%ebp),%esi
  800db0:	89 06                	mov    %eax,(%esi)
  800db2:	89 9c 0a b4 00 00 00 	mov    %ebx,0xb4(%edx,%ecx,1)
  800db9:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbe:	eb 13                	jmp    800dd3 <dir_alloc_file+0xd0>
	f = (struct File*) blk;
  800dc0:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
	*file = &f[0];
  800dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc6:	89 08                	mov    %ecx,(%eax)
	f[0].f_dir = dir;
  800dc8:	89 99 b4 00 00 00    	mov    %ebx,0xb4(%ecx)
	return 0;
  800dce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dd3:	89 d0                	mov    %edx,%eax
  800dd5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <walk_path>:

// Skip over slashes.
static inline const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
	return p;
}

// Evaluate a path name, starting at the root.
// On success, set *pf to the file we found
// and set *pdir to the directory the file is in.
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
  800de3:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  800de9:	8b 75 08             	mov    0x8(%ebp),%esi
  800dec:	89 f0                	mov    %esi,%eax
  800dee:	80 3e 2f             	cmpb   $0x2f,(%esi)
  800df1:	75 06                	jne    800df9 <walk_path+0x1c>
  800df3:	40                   	inc    %eax
  800df4:	80 38 2f             	cmpb   $0x2f,(%eax)
  800df7:	74 fa                	je     800df3 <walk_path+0x16>
  800df9:	89 c6                	mov    %eax,%esi
	const char *p;
	char name[MAXNAMELEN];
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800dfb:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  800e00:	83 c0 08             	add    $0x8,%eax
  800e03:	89 85 64 ff ff ff    	mov    %eax,0xffffff64(%ebp)
	dir = 0;
  800e09:	bf 00 00 00 00       	mov    $0x0,%edi
	name[0] = 0;
  800e0e:	c6 85 68 ff ff ff 00 	movb   $0x0,0xffffff68(%ebp)

	if (pdir)
  800e15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e19:	74 09                	je     800e24 <walk_path+0x47>
		*pdir = 0;
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pf = 0;
  800e24:	8b 55 10             	mov    0x10(%ebp),%edx
  800e27:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
				if (pdir)
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800e2d:	80 3e 00             	cmpb   $0x0,(%esi)
  800e30:	0f 84 d8 00 00 00    	je     800f0e <walk_path+0x131>
  800e36:	8b bd 64 ff ff ff    	mov    0xffffff64(%ebp),%edi
  800e3c:	89 f2                	mov    %esi,%edx
  800e3e:	80 3e 2f             	cmpb   $0x2f,(%esi)
  800e41:	74 10                	je     800e53 <walk_path+0x76>
  800e43:	80 3e 00             	cmpb   $0x0,(%esi)
  800e46:	74 0b                	je     800e53 <walk_path+0x76>
  800e48:	46                   	inc    %esi
  800e49:	80 3e 2f             	cmpb   $0x2f,(%esi)
  800e4c:	74 05                	je     800e53 <walk_path+0x76>
  800e4e:	80 3e 00             	cmpb   $0x0,(%esi)
  800e51:	75 f5                	jne    800e48 <walk_path+0x6b>
  800e53:	89 f0                	mov    %esi,%eax
  800e55:	29 d0                	sub    %edx,%eax
  800e57:	83 f8 7f             	cmp    $0x7f,%eax
  800e5a:	7e 0a                	jle    800e66 <walk_path+0x89>
  800e5c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800e61:	e9 c3 00 00 00       	jmp    800f29 <walk_path+0x14c>
  800e66:	83 ec 04             	sub    $0x4,%esp
  800e69:	89 f3                	mov    %esi,%ebx
  800e6b:	29 d3                	sub    %edx,%ebx
  800e6d:	53                   	push   %ebx
  800e6e:	52                   	push   %edx
  800e6f:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  800e75:	50                   	push   %eax
  800e76:	e8 c1 15 00 00       	call   80243c <memmove>
  800e7b:	c6 84 1d 68 ff ff ff 	movb   $0x0,0xffffff68(%ebp,%ebx,1)
  800e82:	00 
  800e83:	83 c4 10             	add    $0x10,%esp
  800e86:	89 f0                	mov    %esi,%eax
  800e88:	80 3e 2f             	cmpb   $0x2f,(%esi)
  800e8b:	75 06                	jne    800e93 <walk_path+0xb6>
  800e8d:	40                   	inc    %eax
  800e8e:	80 38 2f             	cmpb   $0x2f,(%eax)
  800e91:	74 fa                	je     800e8d <walk_path+0xb0>
  800e93:	89 c6                	mov    %eax,%esi
  800e95:	83 bf 84 00 00 00 01 	cmpl   $0x1,0x84(%edi)
  800e9c:	74 0a                	je     800ea8 <walk_path+0xcb>
  800e9e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800ea3:	e9 81 00 00 00       	jmp    800f29 <walk_path+0x14c>
  800ea8:	83 ec 04             	sub    $0x4,%esp
  800eab:	8d 85 64 ff ff ff    	lea    0xffffff64(%ebp),%eax
  800eb1:	50                   	push   %eax
  800eb2:	8d 95 68 ff ff ff    	lea    0xffffff68(%ebp),%edx
  800eb8:	52                   	push   %edx
  800eb9:	57                   	push   %edi
  800eba:	e8 77 fd ff ff       	call   800c36 <dir_lookup>
  800ebf:	89 c3                	mov    %eax,%ebx
  800ec1:	83 c4 10             	add    $0x10,%esp
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	79 3d                	jns    800f05 <walk_path+0x128>
  800ec8:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800ecb:	75 34                	jne    800f01 <walk_path+0x124>
  800ecd:	80 3e 00             	cmpb   $0x0,(%esi)
  800ed0:	75 2f                	jne    800f01 <walk_path+0x124>
  800ed2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed6:	74 05                	je     800edd <walk_path+0x100>
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 38                	mov    %edi,(%eax)
  800edd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  800ee1:	74 15                	je     800ef8 <walk_path+0x11b>
  800ee3:	83 ec 08             	sub    $0x8,%esp
  800ee6:	8d 95 68 ff ff ff    	lea    0xffffff68(%ebp),%edx
  800eec:	52                   	push   %edx
  800eed:	ff 75 14             	pushl  0x14(%ebp)
  800ef0:	e8 cb 13 00 00       	call   8022c0 <strcpy>
  800ef5:	83 c4 10             	add    $0x10,%esp
  800ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  800efb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800f01:	89 d8                	mov    %ebx,%eax
  800f03:	eb 24                	jmp    800f29 <walk_path+0x14c>
  800f05:	80 3e 00             	cmpb   $0x0,(%esi)
  800f08:	0f 85 28 ff ff ff    	jne    800e36 <walk_path+0x59>
		}
	}

	if (pdir)
  800f0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f12:	74 05                	je     800f19 <walk_path+0x13c>
		*pdir = dir;
  800f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f17:	89 3a                	mov    %edi,(%edx)
	*pf = f;
  800f19:	8b 85 64 ff ff ff    	mov    0xffffff64(%ebp),%eax
  800f1f:	8b 55 10             	mov    0x10(%ebp),%edx
  800f22:	89 02                	mov    %eax,(%edx)
	return 0;
  800f24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f29:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f2c:	5b                   	pop    %ebx
  800f2d:	5e                   	pop    %esi
  800f2e:	5f                   	pop    %edi
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
  800f34:	53                   	push   %ebx
  800f35:	81 ec 94 00 00 00    	sub    $0x94,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  800f3b:	8d 85 78 ff ff ff    	lea    0xffffff78(%ebp),%eax
  800f41:	50                   	push   %eax
  800f42:	8d 85 74 ff ff ff    	lea    0xffffff74(%ebp),%eax
  800f48:	50                   	push   %eax
  800f49:	8d 85 70 ff ff ff    	lea    0xffffff70(%ebp),%eax
  800f4f:	50                   	push   %eax
  800f50:	ff 75 08             	pushl  0x8(%ebp)
  800f53:	e8 85 fe ff ff       	call   800ddd <walk_path>
  800f58:	89 c3                	mov    %eax,%ebx
  800f5a:	83 c4 10             	add    $0x10,%esp
		return -E_FILE_EXISTS;
  800f5d:	ba f3 ff ff ff       	mov    $0xfffffff3,%edx
  800f62:	85 c0                	test   %eax,%eax
  800f64:	74 55                	je     800fbb <file_create+0x8a>
	if (r != -E_NOT_FOUND || dir == 0)
  800f66:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800f69:	75 09                	jne    800f74 <file_create+0x43>
  800f6b:	83 bd 70 ff ff ff 00 	cmpl   $0x0,0xffffff70(%ebp)
  800f72:	75 04                	jne    800f78 <file_create+0x47>
		return r;
  800f74:	89 da                	mov    %ebx,%edx
  800f76:	eb 43                	jmp    800fbb <file_create+0x8a>
	if (dir_alloc_file(dir, &f) < 0)
  800f78:	83 ec 08             	sub    $0x8,%esp
  800f7b:	8d 85 74 ff ff ff    	lea    0xffffff74(%ebp),%eax
  800f81:	50                   	push   %eax
  800f82:	ff b5 70 ff ff ff    	pushl  0xffffff70(%ebp)
  800f88:	e8 76 fd ff ff       	call   800d03 <dir_alloc_file>
  800f8d:	83 c4 10             	add    $0x10,%esp
		return r;
  800f90:	89 da                	mov    %ebx,%edx
  800f92:	85 c0                	test   %eax,%eax
  800f94:	78 25                	js     800fbb <file_create+0x8a>
	strcpy(f->f_name, name);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	8d 85 78 ff ff ff    	lea    0xffffff78(%ebp),%eax
  800f9f:	50                   	push   %eax
  800fa0:	ff b5 74 ff ff ff    	pushl  0xffffff74(%ebp)
  800fa6:	e8 15 13 00 00       	call   8022c0 <strcpy>
	*pf = f;
  800fab:	8b 95 74 ff ff ff    	mov    0xffffff74(%ebp),%edx
  800fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb4:	89 10                	mov    %edx,(%eax)
	return 0;
  800fb6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800fbb:	89 d0                	mov    %edx,%eax
  800fbd:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    

00800fc2 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
  800fc5:	83 ec 08             	sub    $0x8,%esp
	// Hint: Use walk_path.
	return walk_path(path, 0, pf, 0);
  800fc8:	6a 00                	push   $0x0
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	6a 00                	push   $0x0
  800fcf:	ff 75 08             	pushl  0x8(%ebp)
  800fd2:	e8 06 fe ff ff       	call   800ddd <walk_path>
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <file_truncate_blocks>:

// Remove any blocks currently used by file 'f',
// but not necessary for a file of size 'newsize'.
// For both the old and new sizes, figure out the number of blocks required,
// and then clear the blocks from new_nblocks to old_nblocks.
// If the new_nblocks is no more than NDIRECT, and the indirect block has
// been allocated (f->f_indirect != 0), then free the indirect block too.
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 0c             	sub    $0xc,%esp
  800fe2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	// Hint: Use file_clear_block and/or free_block.
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
  800fee:	8d b2 ff 0f 00 00    	lea    0xfff(%edx),%esi
  800ff4:	89 f0                	mov    %esi,%eax
  800ff6:	85 f6                	test   %esi,%esi
  800ff8:	79 06                	jns    801000 <file_truncate_blocks+0x27>
  800ffa:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  801000:	89 c6                	mov    %eax,%esi
  801002:	c1 fe 0c             	sar    $0xc,%esi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  801005:	8d b9 ff 0f 00 00    	lea    0xfff(%ecx),%edi
  80100b:	89 f8                	mov    %edi,%eax
  80100d:	85 ff                	test   %edi,%edi
  80100f:	79 06                	jns    801017 <file_truncate_blocks+0x3e>
  801011:	8d 81 fe 1f 00 00    	lea    0x1ffe(%ecx),%eax
  801017:	89 c7                	mov    %eax,%edi
  801019:	c1 ff 0c             	sar    $0xc,%edi
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  80101c:	89 fb                	mov    %edi,%ebx
  80101e:	39 f7                	cmp    %esi,%edi
  801020:	73 29                	jae    80104b <file_truncate_blocks+0x72>
		if ((r = file_clear_block(f, bno)) < 0)
  801022:	83 ec 08             	sub    $0x8,%esp
  801025:	53                   	push   %ebx
  801026:	ff 75 08             	pushl  0x8(%ebp)
  801029:	e8 4d fb ff ff       	call   800b7b <file_clear_block>
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	85 c0                	test   %eax,%eax
  801033:	79 11                	jns    801046 <file_truncate_blocks+0x6d>
			cprintf("warning: file_clear_block: %e", r);
  801035:	83 ec 08             	sub    $0x8,%esp
  801038:	50                   	push   %eax
  801039:	68 f9 41 80 00       	push   $0x8041f9
  80103e:	e8 79 0c 00 00       	call   801cbc <cprintf>
  801043:	83 c4 10             	add    $0x10,%esp
  801046:	43                   	inc    %ebx
  801047:	39 f3                	cmp    %esi,%ebx
  801049:	72 d7                	jb     801022 <file_truncate_blocks+0x49>

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  80104b:	83 ff 0a             	cmp    $0xa,%edi
  80104e:	77 2a                	ja     80107a <file_truncate_blocks+0xa1>
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	83 b8 b0 00 00 00 00 	cmpl   $0x0,0xb0(%eax)
  80105a:	74 1e                	je     80107a <file_truncate_blocks+0xa1>
		free_block(f->f_indirect);
  80105c:	83 ec 0c             	sub    $0xc,%esp
  80105f:	ff b0 b0 00 00 00    	pushl  0xb0(%eax)
  801065:	e8 6c f5 ff ff       	call   8005d6 <free_block>
		f->f_indirect = 0;
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
  801074:	00 00 00 
  801077:	83 c4 10             	add    $0x10,%esp
	}
}
  80107a:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80107d:	5b                   	pop    %ebx
  80107e:	5e                   	pop    %esi
  80107f:	5f                   	pop    %edi
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <file_set_size>:

int
file_set_size(struct File *f, off_t newsize)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	56                   	push   %esi
  801086:	53                   	push   %ebx
  801087:	8b 75 08             	mov    0x8(%ebp),%esi
  80108a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if (f->f_size > newsize)
  80108d:	39 9e 80 00 00 00    	cmp    %ebx,0x80(%esi)
  801093:	7e 0d                	jle    8010a2 <file_set_size+0x20>
		file_truncate_blocks(f, newsize);
  801095:	83 ec 08             	sub    $0x8,%esp
  801098:	53                   	push   %ebx
  801099:	56                   	push   %esi
  80109a:	e8 3a ff ff ff       	call   800fd9 <file_truncate_blocks>
  80109f:	83 c4 10             	add    $0x10,%esp
	f->f_size = newsize;
  8010a2:	89 9e 80 00 00 00    	mov    %ebx,0x80(%esi)
	if (f->f_dir)
  8010a8:	83 be b4 00 00 00 00 	cmpl   $0x0,0xb4(%esi)
  8010af:	74 11                	je     8010c2 <file_set_size+0x40>
		file_flush(f->f_dir);
  8010b1:	83 ec 0c             	sub    $0xc,%esp
  8010b4:	ff b6 b4 00 00 00    	pushl  0xb4(%esi)
  8010ba:	e8 0f 00 00 00       	call   8010ce <file_flush>
  8010bf:	83 c4 10             	add    $0x10,%esp
	return 0;
}
  8010c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c7:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8010ca:	5b                   	pop    %ebx
  8010cb:	5e                   	pop    %esi
  8010cc:	c9                   	leave  
  8010cd:	c3                   	ret    

008010ce <file_flush>:

// Flush the contents of file f out to disk.
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
//
// Hint: use file_map_block, block_is_dirty, and write_block.
void
file_flush(struct File *f)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
  8010d1:	56                   	push   %esi
  8010d2:	53                   	push   %ebx
  8010d3:	83 ec 10             	sub    $0x10,%esp
  8010d6:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t diskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  8010d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010de:	eb 35                	jmp    801115 <file_flush+0x47>
		if (file_map_block(f, i, &diskbno, 0) < 0)
  8010e0:	6a 00                	push   $0x0
  8010e2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8010e5:	50                   	push   %eax
  8010e6:	53                   	push   %ebx
  8010e7:	56                   	push   %esi
  8010e8:	e8 3a fa ff ff       	call   800b27 <file_map_block>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	78 20                	js     801114 <file_flush+0x46>
			continue;
		if (block_is_dirty(diskbno))
  8010f4:	83 ec 0c             	sub    $0xc,%esp
  8010f7:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8010fa:	e8 11 f2 ff ff       	call   800310 <block_is_dirty>
  8010ff:	83 c4 10             	add    $0x10,%esp
  801102:	85 c0                	test   %eax,%eax
  801104:	74 0e                	je     801114 <file_flush+0x46>
			write_block(diskbno);
  801106:	83 ec 0c             	sub    $0xc,%esp
  801109:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  80110c:	e8 28 f3 ff ff       	call   800439 <write_block>
  801111:	83 c4 10             	add    $0x10,%esp
  801114:	43                   	inc    %ebx
  801115:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  80111b:	89 d0                	mov    %edx,%eax
  80111d:	05 ff 0f 00 00       	add    $0xfff,%eax
  801122:	79 06                	jns    80112a <file_flush+0x5c>
  801124:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  80112a:	c1 f8 0c             	sar    $0xc,%eax
  80112d:	39 d8                	cmp    %ebx,%eax
  80112f:	7f af                	jg     8010e0 <file_flush+0x12>
	}	
}
  801131:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801134:	5b                   	pop    %ebx
  801135:	5e                   	pop    %esi
  801136:	c9                   	leave  
  801137:	c3                   	ret    

00801138 <fs_sync>:

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	53                   	push   %ebx
  80113c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < super->s_nblocks; i++)
  80113f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801144:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  801149:	3b 58 04             	cmp    0x4(%eax),%ebx
  80114c:	73 27                	jae    801175 <fs_sync+0x3d>
		if (block_is_dirty(i))
  80114e:	83 ec 0c             	sub    $0xc,%esp
  801151:	53                   	push   %ebx
  801152:	e8 b9 f1 ff ff       	call   800310 <block_is_dirty>
  801157:	83 c4 10             	add    $0x10,%esp
  80115a:	85 c0                	test   %eax,%eax
  80115c:	74 0c                	je     80116a <fs_sync+0x32>
			write_block(i);
  80115e:	83 ec 0c             	sub    $0xc,%esp
  801161:	53                   	push   %ebx
  801162:	e8 d2 f2 ff ff       	call   800439 <write_block>
  801167:	83 c4 10             	add    $0x10,%esp
  80116a:	43                   	inc    %ebx
  80116b:	a1 a4 c0 80 00       	mov    0x80c0a4,%eax
  801170:	3b 58 04             	cmp    0x4(%eax),%ebx
  801173:	72 d9                	jb     80114e <fs_sync+0x16>
}
  801175:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801178:	c9                   	leave  
  801179:	c3                   	ret    

0080117a <file_close>:

// Close a file.
void
file_close(struct File *f)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	53                   	push   %ebx
  80117e:	83 ec 10             	sub    $0x10,%esp
  801181:	8b 5d 08             	mov    0x8(%ebp),%ebx
	file_flush(f);
  801184:	53                   	push   %ebx
  801185:	e8 44 ff ff ff       	call   8010ce <file_flush>
	if (f->f_dir)
  80118a:	83 c4 10             	add    $0x10,%esp
  80118d:	83 bb b4 00 00 00 00 	cmpl   $0x0,0xb4(%ebx)
  801194:	74 11                	je     8011a7 <file_close+0x2d>
		file_flush(f->f_dir);
  801196:	83 ec 0c             	sub    $0xc,%esp
  801199:	ff b3 b4 00 00 00    	pushl  0xb4(%ebx)
  80119f:	e8 2a ff ff ff       	call   8010ce <file_flush>
  8011a4:	83 c4 10             	add    $0x10,%esp
}
  8011a7:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8011aa:	c9                   	leave  
  8011ab:	c3                   	ret    

008011ac <file_remove>:

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 08             	sub    $0x8,%esp
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  8011b2:	6a 00                	push   $0x0
  8011b4:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8011b7:	50                   	push   %eax
  8011b8:	6a 00                	push   $0x0
  8011ba:	ff 75 08             	pushl  0x8(%ebp)
  8011bd:	e8 1b fc ff ff       	call   800ddd <walk_path>
  8011c2:	83 c4 10             	add    $0x10,%esp
		return r;
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	85 c0                	test   %eax,%eax
  8011c9:	78 45                	js     801210 <file_remove+0x64>

	file_truncate_blocks(f, 0);
  8011cb:	83 ec 08             	sub    $0x8,%esp
  8011ce:	6a 00                	push   $0x0
  8011d0:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8011d3:	e8 01 fe ff ff       	call   800fd9 <file_truncate_blocks>
	f->f_name[0] = '\0';
  8011d8:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)
	f->f_size = 0;
  8011de:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8011e1:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  8011e8:	00 00 00 
	if (f->f_dir)
  8011eb:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8011ee:	83 c4 10             	add    $0x10,%esp
  8011f1:	83 b8 b4 00 00 00 00 	cmpl   $0x0,0xb4(%eax)
  8011f8:	74 11                	je     80120b <file_remove+0x5f>
		file_flush(f->f_dir);
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	ff b0 b4 00 00 00    	pushl  0xb4(%eax)
  801203:	e8 c6 fe ff ff       	call   8010ce <file_flush>
  801208:	83 c4 10             	add    $0x10,%esp

	return 0;
  80120b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801210:	89 d0                	mov    %edx,%eax
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <serve_init>:
#define REQVA		0x0ffff000

void
serve_init(void)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
	int i;
	uintptr_t va = FILEVA;
  801217:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80121c:	ba 00 00 00 00       	mov    $0x0,%edx
		opentab[i].o_fileid = i;
  801221:	89 d0                	mov    %edx,%eax
  801223:	c1 e0 04             	shl    $0x4,%eax
  801226:	89 90 20 80 80 00    	mov    %edx,0x808020(%eax)
		opentab[i].o_fd = (struct Fd*) va;
  80122c:	89 88 2c 80 80 00    	mov    %ecx,0x80802c(%eax)
		va += PGSIZE;
  801232:	81 c1 00 10 00 00    	add    $0x1000,%ecx
  801238:	42                   	inc    %edx
  801239:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  80123f:	7e e0                	jle    801221 <serve_init+0xd>
	}
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	56                   	push   %esi
  801247:	53                   	push   %ebx
  801248:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  80124b:	bb 00 00 00 00       	mov    $0x0,%ebx
		switch (pageref(opentab[i].o_fd)) {
  801250:	83 ec 0c             	sub    $0xc,%esp
  801253:	89 d8                	mov    %ebx,%eax
  801255:	c1 e0 04             	shl    $0x4,%eax
  801258:	ff b0 2c 80 80 00    	pushl  0x80802c(%eax)
  80125e:	e8 85 24 00 00       	call   8036e8 <pageref>
  801263:	83 c4 10             	add    $0x10,%esp
  801266:	85 c0                	test   %eax,%eax
  801268:	74 07                	je     801271 <openfile_alloc+0x2e>
  80126a:	83 f8 01             	cmp    $0x1,%eax
  80126d:	74 25                	je     801294 <openfile_alloc+0x51>
  80126f:	eb 55                	jmp    8012c6 <openfile_alloc+0x83>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801271:	83 ec 04             	sub    $0x4,%esp
  801274:	68 07 04 00 00       	push   $0x407
  801279:	89 d8                	mov    %ebx,%eax
  80127b:	c1 e0 04             	shl    $0x4,%eax
  80127e:	ff b0 2c 80 80 00    	pushl  0x80802c(%eax)
  801284:	6a 00                	push   $0x0
  801286:	e8 07 14 00 00       	call   802692 <sys_page_alloc>
  80128b:	83 c4 10             	add    $0x10,%esp
				return r;
  80128e:	89 c2                	mov    %eax,%edx
  801290:	85 c0                	test   %eax,%eax
  801292:	78 40                	js     8012d4 <openfile_alloc+0x91>
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  801294:	89 d8                	mov    %ebx,%eax
  801296:	c1 e0 04             	shl    $0x4,%eax
  801299:	81 80 20 80 80 00 00 	addl   $0x400,0x808020(%eax)
  8012a0:	04 00 00 
			*o = &opentab[i];
  8012a3:	8d 90 20 80 80 00    	lea    0x808020(%eax),%edx
  8012a9:	89 16                	mov    %edx,(%esi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8012ab:	83 ec 04             	sub    $0x4,%esp
  8012ae:	68 00 10 00 00       	push   $0x1000
  8012b3:	6a 00                	push   $0x0
  8012b5:	ff b0 2c 80 80 00    	pushl  0x80802c(%eax)
  8012bb:	e8 29 11 00 00       	call   8023e9 <memset>
			return (*o)->o_fileid;
  8012c0:	8b 06                	mov    (%esi),%eax
  8012c2:	8b 10                	mov    (%eax),%edx
  8012c4:	eb 0e                	jmp    8012d4 <openfile_alloc+0x91>
  8012c6:	43                   	inc    %ebx
  8012c7:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  8012cd:	7e 81                	jle    801250 <openfile_alloc+0xd>
		}
	}
	return -E_MAX_OPEN;
  8012cf:	ba f6 ff ff ff       	mov    $0xfffffff6,%edx
}
  8012d4:	89 d0                	mov    %edx,%eax
  8012d6:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8012d9:	5b                   	pop    %ebx
  8012da:	5e                   	pop    %esi
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	57                   	push   %edi
  8012e1:	56                   	push   %esi
  8012e2:	53                   	push   %ebx
  8012e3:	83 ec 18             	sub    $0x18,%esp
  8012e6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8012e9:	89 f8                	mov    %edi,%eax
  8012eb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012f0:	89 c3                	mov    %eax,%ebx
  8012f2:	c1 e3 04             	shl    $0x4,%ebx
  8012f5:	8d b3 20 80 80 00    	lea    0x808020(%ebx),%esi
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  8012fb:	ff 76 0c             	pushl  0xc(%esi)
  8012fe:	e8 e5 23 00 00       	call   8036e8 <pageref>
  801303:	83 c4 10             	add    $0x10,%esp
  801306:	83 f8 01             	cmp    $0x1,%eax
  801309:	74 08                	je     801313 <openfile_lookup+0x36>
  80130b:	39 bb 20 80 80 00    	cmp    %edi,0x808020(%ebx)
  801311:	74 07                	je     80131a <openfile_lookup+0x3d>
		return -E_INVAL;
  801313:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801318:	eb 0a                	jmp    801324 <openfile_lookup+0x47>
	*po = o;
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
  80131d:	89 30                	mov    %esi,(%eax)
	return 0;
  80131f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801324:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801327:	5b                   	pop    %ebx
  801328:	5e                   	pop    %esi
  801329:	5f                   	pop    %edi
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <serve_open>:

// Serve requests, sending responses back to envid.
// To send a result back, ipc_send(envid, r, 0, 0).
// To include a page, ipc_send(envid, r, srcva, perm).
void
serve_open(envid_t envid, struct Fsreq_open *rq)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	57                   	push   %edi
  801330:	56                   	push   %esi
  801331:	53                   	push   %ebx
  801332:	81 ec 20 04 00 00    	sub    $0x420,%esp
  801338:	8b 7d 08             	mov    0x8(%ebp),%edi
  80133b:	8b 75 0c             	mov    0xc(%ebp),%esi
	char path[MAXPATHLEN];
	struct File *f;
	int fileid;
	int r;
	struct OpenFile *o;

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, rq->req_path, rq->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, rq->req_path, MAXPATHLEN);
  80133e:	68 00 04 00 00       	push   $0x400
  801343:	56                   	push   %esi
  801344:	8d 9d e8 fb ff ff    	lea    0xfffffbe8(%ebp),%ebx
  80134a:	53                   	push   %ebx
  80134b:	e8 ec 10 00 00       	call   80243c <memmove>
	path[MAXPATHLEN-1] = 0;
  801350:	c6 45 e7 00          	movb   $0x0,0xffffffe7(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  801354:	8d 85 e4 fb ff ff    	lea    0xfffffbe4(%ebp),%eax
  80135a:	89 04 24             	mov    %eax,(%esp)
  80135d:	e8 e1 fe ff ff       	call   801243 <openfile_alloc>
  801362:	83 c4 10             	add    $0x10,%esp
  801365:	85 c0                	test   %eax,%eax
  801367:	0f 88 a4 00 00 00    	js     801411 <serve_open+0xe5>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		goto out;
	}
	fileid = r;

	// Open the file
	if ((r = file_open(path, &f)) < 0) {
  80136d:	83 ec 08             	sub    $0x8,%esp
  801370:	8d 85 e0 fb ff ff    	lea    0xfffffbe0(%ebp),%eax
  801376:	50                   	push   %eax
  801377:	53                   	push   %ebx
  801378:	e8 45 fc ff ff       	call   800fc2 <file_open>
  80137d:	83 c4 10             	add    $0x10,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	0f 88 89 00 00 00    	js     801411 <serve_open+0xe5>
		if (debug)
			cprintf("file_open failed: %e", r);
		goto out;
	}

	// Save the file pointer
	o->o_file = f;
  801388:	8b 95 e0 fb ff ff    	mov    0xfffffbe0(%ebp),%edx
  80138e:	8b 85 e4 fb ff ff    	mov    0xfffffbe4(%ebp),%eax
  801394:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.file = *f;
  801397:	8b 85 e4 fb ff ff    	mov    0xfffffbe4(%ebp),%eax
  80139d:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a0:	83 c0 10             	add    $0x10,%eax
  8013a3:	83 ec 04             	sub    $0x4,%esp
  8013a6:	68 00 01 00 00       	push   $0x100
  8013ab:	ff b5 e0 fb ff ff    	pushl  0xfffffbe0(%ebp)
  8013b1:	50                   	push   %eax
  8013b2:	e8 f0 10 00 00       	call   8024a7 <memcpy>
	o->o_fd->fd_file.id = o->o_fileid;
  8013b7:	8b 85 e4 fb ff ff    	mov    0xfffffbe4(%ebp),%eax
  8013bd:	8b 50 0c             	mov    0xc(%eax),%edx
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	89 42 0c             	mov    %eax,0xc(%edx)
	o->o_fd->fd_omode = rq->req_omode;
  8013c5:	8b 85 e4 fb ff ff    	mov    0xfffffbe4(%ebp),%eax
  8013cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8013ce:	8b 86 00 04 00 00    	mov    0x400(%esi),%eax
  8013d4:	89 42 08             	mov    %eax,0x8(%edx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  8013d7:	8b 85 e4 fb ff ff    	mov    0xfffffbe4(%ebp),%eax
  8013dd:	8b 50 0c             	mov    0xc(%eax),%edx
  8013e0:	a1 40 c0 80 00       	mov    0x80c040,%eax
  8013e5:	89 02                	mov    %eax,(%edx)
	o->o_mode = rq->req_omode;
  8013e7:	8b 96 00 04 00 00    	mov    0x400(%esi),%edx
  8013ed:	8b 85 e4 fb ff ff    	mov    0xfffffbe4(%ebp),%eax
  8013f3:	89 50 08             	mov    %edx,0x8(%eax)

	if (debug)
  8013f6:	83 c4 10             	add    $0x10,%esp
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);
	//ipc_send(envid, 0, o->o_fd, PTE_P|PTE_U|PTE_W);
	ipc_send(envid, 0, o->o_fd, PTE_P|PTE_U|PTE_W|PTE_SHARE); // LAB 7
  8013f9:	68 07 04 00 00       	push   $0x407
  8013fe:	8b 85 e4 fb ff ff    	mov    0xfffffbe4(%ebp),%eax
  801404:	ff 70 0c             	pushl  0xc(%eax)
  801407:	6a 00                	push   $0x0
  801409:	57                   	push   %edi
  80140a:	e8 40 16 00 00       	call   802a4f <ipc_send>
	return;
  80140f:	eb 0b                	jmp    80141c <serve_open+0xf0>
out:
	ipc_send(envid, r, 0, 0);
  801411:	6a 00                	push   $0x0
  801413:	6a 00                	push   $0x0
  801415:	50                   	push   %eax
  801416:	57                   	push   %edi
  801417:	e8 33 16 00 00       	call   802a4f <ipc_send>
}
  80141c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80141f:	5b                   	pop    %ebx
  801420:	5e                   	pop    %esi
  801421:	5f                   	pop    %edi
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <serve_set_size>:

void
serve_set_size(envid_t envid, struct Fsreq_set_size *rq)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	56                   	push   %esi
  801428:	53                   	push   %ebx
  801429:	83 ec 14             	sub    $0x14,%esp
  80142c:	8b 75 08             	mov    0x8(%ebp),%esi
  80142f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct OpenFile *o;
	int r;
	
	if (debug)
		cprintf("serve_set_size %08x %08x %08x\n", envid, rq->req_fileid, rq->req_size);

	// The file system server maintains three structures
	// for each open file.
	//
	// 1. The on-disk 'struct File' is mapped into the part of memory
	//    that maps the disk.  This memory is kept private to the
	//    file server.
	// 2. Each open file has a 'struct Fd' as well,
	//    which sort of corresponds to a Unix file descriptor.
	//    This 'struct Fd' is kept on *its own page* in memory,
	//    and it is shared with any environments that
	//    have the file open.
	//    Part of the 'struct Fd' is a *copy* of the on-disk
	//    'struct File' (struct Fd::fd_file.file), except that the
	//    block pointers are effectively garbage.
	//    This lets environments find out a file's size by examining
	//    struct Fd::fd_file.file.f_size, for example.
	//    *The server must make sure to keep two copies of the
	//    'struct File' in sync!*
	// 3. 'struct OpenFile' links these other two structures,
	//    and is kept private to the file server.
	//    The server maintains an array of all open files, indexed
	//    by "file ID".
	//    (There can be at most MAXFILE files open concurrently.)
	//    The client uses file IDs to communicate with the server.
	//    File IDs are a lot like environment IDs in the kernel.
	//    Use openfile_lookup to translate file IDs to struct OpenFile.

	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, rq->req_fileid, &o)) < 0)
  801432:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801435:	50                   	push   %eax
  801436:	ff 33                	pushl  (%ebx)
  801438:	56                   	push   %esi
  801439:	e8 9f fe ff ff       	call   8012dd <openfile_lookup>
  80143e:	89 c1                	mov    %eax,%ecx
  801440:	83 c4 10             	add    $0x10,%esp
  801443:	85 c0                	test   %eax,%eax
  801445:	78 29                	js     801470 <serve_set_size+0x4c>
		goto out;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	if ((r = file_set_size(o->o_file, rq->req_size)) < 0)
  801447:	83 ec 08             	sub    $0x8,%esp
  80144a:	ff 73 04             	pushl  0x4(%ebx)
  80144d:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801450:	ff 70 04             	pushl  0x4(%eax)
  801453:	e8 2a fc ff ff       	call   801082 <file_set_size>
  801458:	89 c1                	mov    %eax,%ecx
  80145a:	83 c4 10             	add    $0x10,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 0f                	js     801470 <serve_set_size+0x4c>
		goto out;

	// Third, update the 'struct Fd' copy of the 'struct File'
	// as appropriate.
	o->o_fd->fd_file.file.f_size = rq->req_size;
  801461:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801464:	8b 50 0c             	mov    0xc(%eax),%edx
  801467:	8b 43 04             	mov    0x4(%ebx),%eax
  80146a:	89 82 90 00 00 00    	mov    %eax,0x90(%edx)

	// Finally, return to the client!
	// (We just return r since we know it's 0 at this point.)
out:
	ipc_send(envid, r, 0, 0);
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	51                   	push   %ecx
  801475:	56                   	push   %esi
  801476:	e8 d4 15 00 00       	call   802a4f <ipc_send>
}
  80147b:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80147e:	5b                   	pop    %ebx
  80147f:	5e                   	pop    %esi
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <serve_map>:

void
serve_map(envid_t envid, struct Fsreq_map *rq)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	56                   	push   %esi
  801486:	53                   	push   %ebx
  801487:	83 ec 14             	sub    $0x14,%esp
  80148a:	8b 75 08             	mov    0x8(%ebp),%esi
  80148d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	char *blk;
	struct OpenFile *o;
	int perm;

	if (debug)
		cprintf("serve_map %08x %08x %08x\n", envid, rq->req_fileid, rq->req_offset);

	// Map the requested block in the client's address space
	// by using ipc_send.
	// Map read-only unless the file's open mode (o->o_mode) allows writes
	// (see the O_ flags in inc/lib.h).
	
	// LAB 5: Your code here.
	//panic("serve_map not implemented");
        if ((r = openfile_lookup(envid, rq->req_fileid, &o)) < 0) {
  801490:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801493:	50                   	push   %eax
  801494:	ff 33                	pushl  (%ebx)
  801496:	56                   	push   %esi
  801497:	e8 41 fe ff ff       	call   8012dd <openfile_lookup>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 4a                	js     8014ed <serve_map+0x6b>
          goto out;
        }
        if ((r = file_get_block(o->o_file, rq->req_offset / BLKSIZE, &blk)) < 0) {
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8014a9:	50                   	push   %eax
  8014aa:	8b 43 04             	mov    0x4(%ebx),%eax
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	79 05                	jns    8014b6 <serve_map+0x34>
  8014b1:	05 ff 0f 00 00       	add    $0xfff,%eax
  8014b6:	c1 f8 0c             	sar    $0xc,%eax
  8014b9:	50                   	push   %eax
  8014ba:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8014bd:	ff 70 04             	pushl  0x4(%eax)
  8014c0:	e8 fd f6 ff ff       	call   800bc2 <file_get_block>
  8014c5:	83 c4 10             	add    $0x10,%esp
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	78 21                	js     8014ed <serve_map+0x6b>
          goto out;
        }
        perm = PTE_P | PTE_U | PTE_SHARE; // LAB 7: add PTE_SHARE
  8014cc:	ba 05 04 00 00       	mov    $0x405,%edx
        if (o->o_mode == O_RDWR || o->o_mode == O_WRONLY) {
  8014d1:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8014d4:	8b 40 08             	mov    0x8(%eax),%eax
  8014d7:	48                   	dec    %eax
  8014d8:	83 f8 01             	cmp    $0x1,%eax
  8014db:	77 02                	ja     8014df <serve_map+0x5d>
          perm |= PTE_W;
  8014dd:	b2 07                	mov    $0x7,%dl
        }
	ipc_send(envid, 0, blk, perm);
  8014df:	52                   	push   %edx
  8014e0:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8014e3:	6a 00                	push   $0x0
  8014e5:	56                   	push   %esi
  8014e6:	e8 64 15 00 00       	call   802a4f <ipc_send>
        return;
  8014eb:	eb 0b                	jmp    8014f8 <serve_map+0x76>
        
out:
	ipc_send(envid, r, 0, 0);
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	50                   	push   %eax
  8014f2:	56                   	push   %esi
  8014f3:	e8 57 15 00 00       	call   802a4f <ipc_send>
}
  8014f8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8014fb:	5b                   	pop    %ebx
  8014fc:	5e                   	pop    %esi
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <serve_close>:

void
serve_close(envid_t envid, struct Fsreq_close *rq)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	53                   	push   %ebx
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct OpenFile *o;
	int r;

	if (debug)
		cprintf("serve_close %08x %08x\n", envid, rq->req_fileid);

	if ((r = openfile_lookup(envid, rq->req_fileid, &o)) < 0)
  801509:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80150c:	50                   	push   %eax
  80150d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801510:	ff 30                	pushl  (%eax)
  801512:	53                   	push   %ebx
  801513:	e8 c5 fd ff ff       	call   8012dd <openfile_lookup>
  801518:	83 c4 10             	add    $0x10,%esp
  80151b:	85 c0                	test   %eax,%eax
  80151d:	78 16                	js     801535 <serve_close+0x36>
		goto out;
	file_close(o->o_file);
  80151f:	83 ec 0c             	sub    $0xc,%esp
  801522:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801525:	ff 70 04             	pushl  0x4(%eax)
  801528:	e8 4d fc ff ff       	call   80117a <file_close>
	r = 0;
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
  801532:	83 c4 10             	add    $0x10,%esp

out:
	ipc_send(envid, r, 0, 0);
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	50                   	push   %eax
  80153a:	53                   	push   %ebx
  80153b:	e8 0f 15 00 00       	call   802a4f <ipc_send>
}
  801540:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <serve_remove>:

void
serve_remove(envid_t envid, struct Fsreq_remove *rq)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	53                   	push   %ebx
  801549:	81 ec 08 04 00 00    	sub    $0x408,%esp
	char path[MAXPATHLEN];
	int r;

	if (debug)
		cprintf("serve_remove %08x %s\n", envid, rq->req_path);

	// Delete the named file.
	// Note: This request doesn't refer to an open file.
	// Hint: Make sure the path is null-terminated!

	// Copy in the path, making sure it's null-terminated
	memmove(path, rq->req_path, MAXPATHLEN);
  80154f:	68 00 04 00 00       	push   $0x400
  801554:	ff 75 0c             	pushl  0xc(%ebp)
  801557:	8d 9d f8 fb ff ff    	lea    0xfffffbf8(%ebp),%ebx
  80155d:	53                   	push   %ebx
  80155e:	e8 d9 0e 00 00       	call   80243c <memmove>
	path[MAXPATHLEN-1] = 0;
  801563:	c6 45 f7 00          	movb   $0x0,0xfffffff7(%ebp)

	// Delete the specified file
	r = file_remove(path);
  801567:	89 1c 24             	mov    %ebx,(%esp)
  80156a:	e8 3d fc ff ff       	call   8011ac <file_remove>
	ipc_send(envid, r, 0, 0);
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	50                   	push   %eax
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	e8 d3 14 00 00       	call   802a4f <ipc_send>
}
  80157c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <serve_dirty>:

void
serve_dirty(envid_t envid, struct Fsreq_dirty *rq)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	56                   	push   %esi
  801585:	53                   	push   %ebx
  801586:	83 ec 14             	sub    $0x14,%esp
  801589:	8b 75 08             	mov    0x8(%ebp),%esi
  80158c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct OpenFile *o;
	int r;

	if (debug)
		cprintf("serve_dirty %08x %08x %08x\n", envid, rq->req_fileid, rq->req_offset);

	// Mark the page containing the requested file offset as dirty.
	// Returns 0 on success, < 0 on error.
	
	// LAB 5: Your code here.
        // Look up an open file for envid.
	//panic("serve_dirty not implemented");

        if ((r = openfile_lookup(envid, rq->req_fileid, &o)) < 0) {
  80158f:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801592:	50                   	push   %eax
  801593:	ff 33                	pushl  (%ebx)
  801595:	56                   	push   %esi
  801596:	e8 42 fd ff ff       	call   8012dd <openfile_lookup>
  80159b:	83 c4 10             	add    $0x10,%esp
  80159e:	85 c0                	test   %eax,%eax
  8015a0:	78 14                	js     8015b6 <serve_dirty+0x35>
          goto out;
        }
        if ((r = file_dirty(o->o_file, rq->req_offset)) < 0) {
  8015a2:	83 ec 08             	sub    $0x8,%esp
  8015a5:	ff 73 04             	pushl  0x4(%ebx)
  8015a8:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8015ab:	ff 70 04             	pushl  0x4(%eax)
  8015ae:	e8 4f f6 ff ff       	call   800c02 <file_dirty>
  8015b3:	83 c4 10             	add    $0x10,%esp
          goto out;
        }
out:
        ipc_send(envid, r, 0, 0);
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	50                   	push   %eax
  8015bb:	56                   	push   %esi
  8015bc:	e8 8e 14 00 00       	call   802a4f <ipc_send>
}
  8015c1:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8015c4:	5b                   	pop    %ebx
  8015c5:	5e                   	pop    %esi
  8015c6:	c9                   	leave  
  8015c7:	c3                   	ret    

008015c8 <serve_sync>:

void
serve_sync(envid_t envid)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  8015ce:	e8 65 fb ff ff       	call   801138 <fs_sync>
	ipc_send(envid, 0, 0, 0);
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	ff 75 08             	pushl  0x8(%ebp)
  8015dc:	e8 6e 14 00 00       	call   802a4f <ipc_send>
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <serve>:

void
serve(void)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 08             	sub    $0x8,%esp
	uint32_t req, whom;
	int perm;
	
	while (1) {
		perm = 0;
  8015e9:	c7 45 fc 00 00 00 00 	movl   $0x0,0xfffffffc(%ebp)
		req = ipc_recv((int32_t *) &whom, (void *) REQVA, &perm);
  8015f0:	83 ec 04             	sub    $0x4,%esp
  8015f3:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8015f6:	50                   	push   %eax
  8015f7:	68 00 f0 ff 0f       	push   $0xffff000
  8015fc:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8015ff:	50                   	push   %eax
  801600:	e8 e7 13 00 00       	call   8029ec <ipc_recv>
		if (debug)
  801605:	83 c4 10             	add    $0x10,%esp
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, vpt[VPN(REQVA)], REQVA);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  801608:	f6 45 fc 01          	testb  $0x1,0xfffffffc(%ebp)
  80160c:	75 15                	jne    801623 <serve+0x40>
			cprintf("Invalid request from %08x: no argument page\n",
  80160e:	83 ec 08             	sub    $0x8,%esp
  801611:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801614:	68 18 42 80 00       	push   $0x804218
  801619:	e8 9e 06 00 00       	call   801cbc <cprintf>
				whom);
			continue; // just leave it hanging...
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	eb c6                	jmp    8015e9 <serve+0x6>
		}

		switch (req) {
  801623:	83 f8 07             	cmp    $0x7,%eax
  801626:	0f 87 98 00 00 00    	ja     8016c4 <serve+0xe1>
  80162c:	ff 24 85 6c 42 80 00 	jmp    *0x80426c(,%eax,4)
		case FSREQ_OPEN:
			serve_open(whom, (struct Fsreq_open*)REQVA);
  801633:	83 ec 08             	sub    $0x8,%esp
  801636:	68 00 f0 ff 0f       	push   $0xffff000
  80163b:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80163e:	e8 e9 fc ff ff       	call   80132c <serve_open>
			break;
  801643:	83 c4 10             	add    $0x10,%esp
  801646:	e9 8d 00 00 00       	jmp    8016d8 <serve+0xf5>
		case FSREQ_MAP:
			serve_map(whom, (struct Fsreq_map*)REQVA);
  80164b:	83 ec 08             	sub    $0x8,%esp
  80164e:	68 00 f0 ff 0f       	push   $0xffff000
  801653:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801656:	e8 27 fe ff ff       	call   801482 <serve_map>
			break;
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	eb 78                	jmp    8016d8 <serve+0xf5>
		case FSREQ_SET_SIZE:
			serve_set_size(whom, (struct Fsreq_set_size*)REQVA);
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	68 00 f0 ff 0f       	push   $0xffff000
  801668:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80166b:	e8 b4 fd ff ff       	call   801424 <serve_set_size>
			break;
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	eb 63                	jmp    8016d8 <serve+0xf5>
		case FSREQ_CLOSE:
			serve_close(whom, (struct Fsreq_close*)REQVA);
  801675:	83 ec 08             	sub    $0x8,%esp
  801678:	68 00 f0 ff 0f       	push   $0xffff000
  80167d:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801680:	e8 7a fe ff ff       	call   8014ff <serve_close>
			break;
  801685:	83 c4 10             	add    $0x10,%esp
  801688:	eb 4e                	jmp    8016d8 <serve+0xf5>
		case FSREQ_DIRTY:
			serve_dirty(whom, (struct Fsreq_dirty*)REQVA);
  80168a:	83 ec 08             	sub    $0x8,%esp
  80168d:	68 00 f0 ff 0f       	push   $0xffff000
  801692:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801695:	e8 e7 fe ff ff       	call   801581 <serve_dirty>
			break;
  80169a:	83 c4 10             	add    $0x10,%esp
  80169d:	eb 39                	jmp    8016d8 <serve+0xf5>
		case FSREQ_REMOVE:
			serve_remove(whom, (struct Fsreq_remove*)REQVA);
  80169f:	83 ec 08             	sub    $0x8,%esp
  8016a2:	68 00 f0 ff 0f       	push   $0xffff000
  8016a7:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8016aa:	e8 96 fe ff ff       	call   801545 <serve_remove>
			break;
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	eb 24                	jmp    8016d8 <serve+0xf5>
		case FSREQ_SYNC:
			serve_sync(whom);
  8016b4:	83 ec 0c             	sub    $0xc,%esp
  8016b7:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8016ba:	e8 09 ff ff ff       	call   8015c8 <serve_sync>
			break;
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	eb 14                	jmp    8016d8 <serve+0xf5>
		default:
			cprintf("Invalid request code %d from %08x\n", whom, req);
  8016c4:	83 ec 04             	sub    $0x4,%esp
  8016c7:	50                   	push   %eax
  8016c8:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8016cb:	68 48 42 80 00       	push   $0x804248
  8016d0:	e8 e7 05 00 00       	call   801cbc <cprintf>
			break;
  8016d5:	83 c4 10             	add    $0x10,%esp
		}
		sys_page_unmap(0, (void*) REQVA);
  8016d8:	83 ec 08             	sub    $0x8,%esp
  8016db:	68 00 f0 ff 0f       	push   $0xffff000
  8016e0:	6a 00                	push   $0x0
  8016e2:	e8 30 10 00 00       	call   802717 <sys_page_unmap>
  8016e7:	83 c4 10             	add    $0x10,%esp
  8016ea:	e9 fa fe ff ff       	jmp    8015e9 <serve+0x6>

008016ef <umain>:
	}
}

void
umain(void)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
        binaryname = "fs";
  8016f5:	c7 05 24 c0 80 00 8c 	movl   $0x80428c,0x80c024
  8016fc:	42 80 00 
	cprintf("FS is running\n");
  8016ff:	68 8f 42 80 00       	push   $0x80428f
  801704:	e8 b3 05 00 00       	call   801cbc <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
  801709:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  80170e:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  801713:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801715:	c7 04 24 9e 42 80 00 	movl   $0x80429e,(%esp)
  80171c:	e8 9b 05 00 00       	call   801cbc <cprintf>

	serve_init();
  801721:	e8 ee fa ff ff       	call   801214 <serve_init>
	fs_init();
  801726:	e8 12 f3 ff ff       	call   800a3d <fs_init>
	fs_test();
  80172b:	e8 35 00 00 00       	call   801765 <fs_test>

	serve();
  801730:	e8 ae fe ff ff       	call   8015e3 <serve>
}
  801735:	c9                   	leave  
  801736:	c3                   	ret    
	...

00801738 <strecmp>:


int
strecmp(char *a, char *b)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	53                   	push   %ebx
  80173c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80173f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*b)
		if (*a++ != *b++)
			return 1;
  801742:	80 39 00             	cmpb   $0x0,(%ecx)
  801745:	74 16                	je     80175d <strecmp+0x25>
  801747:	8a 11                	mov    (%ecx),%dl
  801749:	41                   	inc    %ecx
  80174a:	8a 03                	mov    (%ebx),%al
  80174c:	43                   	inc    %ebx
  80174d:	38 d0                	cmp    %dl,%al
  80174f:	74 07                	je     801758 <strecmp+0x20>
  801751:	b8 01 00 00 00       	mov    $0x1,%eax
  801756:	eb 0a                	jmp    801762 <strecmp+0x2a>
  801758:	80 39 00             	cmpb   $0x0,(%ecx)
  80175b:	75 ea                	jne    801747 <strecmp+0xf>
	return 0;
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801762:	5b                   	pop    %ebx
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	56                   	push   %esi
  801769:	53                   	push   %ebx
  80176a:	83 ec 14             	sub    $0x14,%esp
	struct File *f;
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80176d:	6a 07                	push   $0x7
  80176f:	68 00 10 00 00       	push   $0x1000
  801774:	6a 00                	push   $0x0
  801776:	e8 17 0f 00 00       	call   802692 <sys_page_alloc>
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	85 c0                	test   %eax,%eax
  801780:	79 12                	jns    801794 <fs_test+0x2f>
		panic("sys_page_alloc: %e", r);
  801782:	50                   	push   %eax
  801783:	68 3b 43 80 00       	push   $0x80433b
  801788:	6a 1d                	push   $0x1d
  80178a:	68 4e 43 80 00       	push   $0x80434e
  80178f:	e8 38 04 00 00       	call   801bcc <_panic>
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	68 00 10 00 00       	push   $0x1000
  80179c:	ff 35 a0 c0 80 00    	pushl  0x80c0a0
  8017a2:	68 00 10 00 00       	push   $0x1000
  8017a7:	e8 90 0c 00 00       	call   80243c <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8017ac:	e8 2d ef ff ff       	call   8006de <alloc_block>
  8017b1:	89 c2                	mov    %eax,%edx
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	85 c0                	test   %eax,%eax
  8017b8:	79 12                	jns    8017cc <fs_test+0x67>
		panic("alloc_block: %e", r);
  8017ba:	50                   	push   %eax
  8017bb:	68 58 43 80 00       	push   $0x804358
  8017c0:	6a 22                	push   $0x22
  8017c2:	68 4e 43 80 00       	push   $0x80434e
  8017c7:	e8 00 04 00 00       	call   801bcc <_panic>
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8017cc:	85 d2                	test   %edx,%edx
  8017ce:	79 03                	jns    8017d3 <fs_test+0x6e>
  8017d0:	8d 42 1f             	lea    0x1f(%edx),%eax
  8017d3:	89 c3                	mov    %eax,%ebx
  8017d5:	c1 fb 05             	sar    $0x5,%ebx
  8017d8:	89 d0                	mov    %edx,%eax
  8017da:	85 d2                	test   %edx,%edx
  8017dc:	79 03                	jns    8017e1 <fs_test+0x7c>
  8017de:	8d 42 1f             	lea    0x1f(%edx),%eax
  8017e1:	83 e0 e0             	and    $0xffffffe0,%eax
  8017e4:	89 d1                	mov    %edx,%ecx
  8017e6:	29 c1                	sub    %eax,%ecx
  8017e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ed:	d3 e0                	shl    %cl,%eax
  8017ef:	85 04 9d 00 10 00 00 	test   %eax,0x1000(,%ebx,4)
  8017f6:	75 16                	jne    80180e <fs_test+0xa9>
  8017f8:	68 68 43 80 00       	push   $0x804368
  8017fd:	68 3d 3f 80 00       	push   $0x803f3d
  801802:	6a 24                	push   $0x24
  801804:	68 4e 43 80 00       	push   $0x80434e
  801809:	e8 be 03 00 00       	call   801bcc <_panic>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  80180e:	89 d0                	mov    %edx,%eax
  801810:	85 d2                	test   %edx,%edx
  801812:	79 03                	jns    801817 <fs_test+0xb2>
  801814:	8d 42 1f             	lea    0x1f(%edx),%eax
  801817:	89 c6                	mov    %eax,%esi
  801819:	c1 fe 05             	sar    $0x5,%esi
  80181c:	8b 1d a0 c0 80 00    	mov    0x80c0a0,%ebx
  801822:	89 d0                	mov    %edx,%eax
  801824:	85 d2                	test   %edx,%edx
  801826:	79 03                	jns    80182b <fs_test+0xc6>
  801828:	8d 42 1f             	lea    0x1f(%edx),%eax
  80182b:	83 e0 e0             	and    $0xffffffe0,%eax
  80182e:	89 d1                	mov    %edx,%ecx
  801830:	29 c1                	sub    %eax,%ecx
  801832:	b8 01 00 00 00       	mov    $0x1,%eax
  801837:	d3 e0                	shl    %cl,%eax
  801839:	85 04 b3             	test   %eax,(%ebx,%esi,4)
  80183c:	74 16                	je     801854 <fs_test+0xef>
  80183e:	68 d8 42 80 00       	push   $0x8042d8
  801843:	68 3d 3f 80 00       	push   $0x803f3d
  801848:	6a 26                	push   $0x26
  80184a:	68 4e 43 80 00       	push   $0x80434e
  80184f:	e8 78 03 00 00       	call   801bcc <_panic>
	cprintf("alloc_block is good\n");
  801854:	83 ec 0c             	sub    $0xc,%esp
  801857:	68 83 43 80 00       	push   $0x804383
  80185c:	e8 5b 04 00 00       	call   801cbc <cprintf>
	
	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801861:	83 c4 08             	add    $0x8,%esp
  801864:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801867:	50                   	push   %eax
  801868:	68 98 43 80 00       	push   $0x804398
  80186d:	e8 50 f7 ff ff       	call   800fc2 <file_open>
  801872:	89 c2                	mov    %eax,%edx
  801874:	83 c4 10             	add    $0x10,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	79 17                	jns    801892 <fs_test+0x12d>
  80187b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80187e:	74 12                	je     801892 <fs_test+0x12d>
		panic("file_open /not-found: %e", r);
  801880:	50                   	push   %eax
  801881:	68 a3 43 80 00       	push   $0x8043a3
  801886:	6a 2a                	push   $0x2a
  801888:	68 4e 43 80 00       	push   $0x80434e
  80188d:	e8 3a 03 00 00       	call   801bcc <_panic>
	else if (r == 0)
  801892:	85 d2                	test   %edx,%edx
  801894:	75 14                	jne    8018aa <fs_test+0x145>
		panic("file_open /not-found succeeded!");
  801896:	83 ec 04             	sub    $0x4,%esp
  801899:	68 f8 42 80 00       	push   $0x8042f8
  80189e:	6a 2c                	push   $0x2c
  8018a0:	68 4e 43 80 00       	push   $0x80434e
  8018a5:	e8 22 03 00 00       	call   801bcc <_panic>
	if ((r = file_open("/newmotd", &f)) < 0)
  8018aa:	83 ec 08             	sub    $0x8,%esp
  8018ad:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8018b0:	50                   	push   %eax
  8018b1:	68 bc 43 80 00       	push   $0x8043bc
  8018b6:	e8 07 f7 ff ff       	call   800fc2 <file_open>
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	79 12                	jns    8018d4 <fs_test+0x16f>
		panic("file_open /newmotd: %e", r);
  8018c2:	50                   	push   %eax
  8018c3:	68 c5 43 80 00       	push   $0x8043c5
  8018c8:	6a 2e                	push   $0x2e
  8018ca:	68 4e 43 80 00       	push   $0x80434e
  8018cf:	e8 f8 02 00 00       	call   801bcc <_panic>
	cprintf("file_open is good\n");
  8018d4:	83 ec 0c             	sub    $0xc,%esp
  8018d7:	68 dc 43 80 00       	push   $0x8043dc
  8018dc:	e8 db 03 00 00       	call   801cbc <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  8018e1:	83 c4 0c             	add    $0xc,%esp
  8018e4:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8018e7:	50                   	push   %eax
  8018e8:	6a 00                	push   $0x0
  8018ea:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8018ed:	e8 d0 f2 ff ff       	call   800bc2 <file_get_block>
  8018f2:	83 c4 10             	add    $0x10,%esp
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	79 12                	jns    80190b <fs_test+0x1a6>
		panic("file_get_block: %e", r);
  8018f9:	50                   	push   %eax
  8018fa:	68 ef 43 80 00       	push   $0x8043ef
  8018ff:	6a 32                	push   $0x32
  801901:	68 4e 43 80 00       	push   $0x80434e
  801906:	e8 c1 02 00 00       	call   801bcc <_panic>
	if (strecmp(blk, msg) != 0)
  80190b:	ff 35 20 c0 80 00    	pushl  0x80c020
  801911:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801914:	e8 1f fe ff ff       	call   801738 <strecmp>
  801919:	83 c4 08             	add    $0x8,%esp
  80191c:	85 c0                	test   %eax,%eax
  80191e:	74 14                	je     801934 <fs_test+0x1cf>
		panic("file_get_block returned wrong data");
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	68 18 43 80 00       	push   $0x804318
  801928:	6a 34                	push   $0x34
  80192a:	68 4e 43 80 00       	push   $0x80434e
  80192f:	e8 98 02 00 00       	call   801bcc <_panic>
	cprintf("file_get_block is good\n");
  801934:	83 ec 0c             	sub    $0xc,%esp
  801937:	68 02 44 80 00       	push   $0x804402
  80193c:	e8 7b 03 00 00       	call   801cbc <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801941:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801944:	8a 02                	mov    (%edx),%al
  801946:	88 02                	mov    %al,(%edx)
	assert((vpt[VPN(blk)] & PTE_D));
  801948:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80194b:	c1 e8 0c             	shr    $0xc,%eax
  80194e:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801955:	83 c4 10             	add    $0x10,%esp
  801958:	a8 40                	test   $0x40,%al
  80195a:	75 16                	jne    801972 <fs_test+0x20d>
  80195c:	68 1b 44 80 00       	push   $0x80441b
  801961:	68 3d 3f 80 00       	push   $0x803f3d
  801966:	6a 38                	push   $0x38
  801968:	68 4e 43 80 00       	push   $0x80434e
  80196d:	e8 5a 02 00 00       	call   801bcc <_panic>
	file_flush(f);
  801972:	83 ec 0c             	sub    $0xc,%esp
  801975:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801978:	e8 51 f7 ff ff       	call   8010ce <file_flush>
	assert(!(vpt[VPN(blk)] & PTE_D));
  80197d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801980:	c1 e8 0c             	shr    $0xc,%eax
  801983:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	a8 40                	test   $0x40,%al
  80198f:	74 16                	je     8019a7 <fs_test+0x242>
  801991:	68 1a 44 80 00       	push   $0x80441a
  801996:	68 3d 3f 80 00       	push   $0x803f3d
  80199b:	6a 3a                	push   $0x3a
  80199d:	68 4e 43 80 00       	push   $0x80434e
  8019a2:	e8 25 02 00 00       	call   801bcc <_panic>
	cprintf("file_flush is good\n");
  8019a7:	83 ec 0c             	sub    $0xc,%esp
  8019aa:	68 33 44 80 00       	push   $0x804433
  8019af:	e8 08 03 00 00       	call   801cbc <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  8019b4:	83 c4 08             	add    $0x8,%esp
  8019b7:	6a 00                	push   $0x0
  8019b9:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8019bc:	e8 c1 f6 ff ff       	call   801082 <file_set_size>
  8019c1:	83 c4 10             	add    $0x10,%esp
  8019c4:	85 c0                	test   %eax,%eax
  8019c6:	79 12                	jns    8019da <fs_test+0x275>
		panic("file_set_size: %e", r);
  8019c8:	50                   	push   %eax
  8019c9:	68 47 44 80 00       	push   $0x804447
  8019ce:	6a 3e                	push   $0x3e
  8019d0:	68 4e 43 80 00       	push   $0x80434e
  8019d5:	e8 f2 01 00 00       	call   801bcc <_panic>
	assert(f->f_direct[0] == 0);
  8019da:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8019dd:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  8019e4:	74 16                	je     8019fc <fs_test+0x297>
  8019e6:	68 59 44 80 00       	push   $0x804459
  8019eb:	68 3d 3f 80 00       	push   $0x803f3d
  8019f0:	6a 3f                	push   $0x3f
  8019f2:	68 4e 43 80 00       	push   $0x80434e
  8019f7:	e8 d0 01 00 00       	call   801bcc <_panic>
	assert(!(vpt[VPN(f)] & PTE_D));
  8019fc:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8019ff:	c1 e8 0c             	shr    $0xc,%eax
  801a02:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a09:	a8 40                	test   $0x40,%al
  801a0b:	74 16                	je     801a23 <fs_test+0x2be>
  801a0d:	68 6d 44 80 00       	push   $0x80446d
  801a12:	68 3d 3f 80 00       	push   $0x803f3d
  801a17:	6a 40                	push   $0x40
  801a19:	68 4e 43 80 00       	push   $0x80434e
  801a1e:	e8 a9 01 00 00       	call   801bcc <_panic>
	cprintf("file_truncate is good\n");
  801a23:	83 ec 0c             	sub    $0xc,%esp
  801a26:	68 84 44 80 00       	push   $0x804484
  801a2b:	e8 8c 02 00 00       	call   801cbc <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801a30:	83 c4 04             	add    $0x4,%esp
  801a33:	ff 35 20 c0 80 00    	pushl  0x80c020
  801a39:	e8 46 08 00 00       	call   802284 <strlen>
  801a3e:	83 c4 08             	add    $0x8,%esp
  801a41:	50                   	push   %eax
  801a42:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801a45:	e8 38 f6 ff ff       	call   801082 <file_set_size>
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	85 c0                	test   %eax,%eax
  801a4f:	79 12                	jns    801a63 <fs_test+0x2fe>
		panic("file_set_size 2: %e", r);
  801a51:	50                   	push   %eax
  801a52:	68 9b 44 80 00       	push   $0x80449b
  801a57:	6a 44                	push   $0x44
  801a59:	68 4e 43 80 00       	push   $0x80434e
  801a5e:	e8 69 01 00 00       	call   801bcc <_panic>
	assert(!(vpt[VPN(f)] & PTE_D));
  801a63:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801a66:	c1 e8 0c             	shr    $0xc,%eax
  801a69:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a70:	a8 40                	test   $0x40,%al
  801a72:	74 16                	je     801a8a <fs_test+0x325>
  801a74:	68 6d 44 80 00       	push   $0x80446d
  801a79:	68 3d 3f 80 00       	push   $0x803f3d
  801a7e:	6a 45                	push   $0x45
  801a80:	68 4e 43 80 00       	push   $0x80434e
  801a85:	e8 42 01 00 00       	call   801bcc <_panic>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801a90:	50                   	push   %eax
  801a91:	6a 00                	push   $0x0
  801a93:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801a96:	e8 27 f1 ff ff       	call   800bc2 <file_get_block>
  801a9b:	83 c4 10             	add    $0x10,%esp
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	79 12                	jns    801ab4 <fs_test+0x34f>
		panic("file_get_block 2: %e", r);
  801aa2:	50                   	push   %eax
  801aa3:	68 af 44 80 00       	push   $0x8044af
  801aa8:	6a 47                	push   $0x47
  801aaa:	68 4e 43 80 00       	push   $0x80434e
  801aaf:	e8 18 01 00 00       	call   801bcc <_panic>
	strcpy(blk, msg);	
  801ab4:	83 ec 08             	sub    $0x8,%esp
  801ab7:	ff 35 20 c0 80 00    	pushl  0x80c020
  801abd:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801ac0:	e8 fb 07 00 00       	call   8022c0 <strcpy>
	assert((vpt[VPN(blk)] & PTE_D));
  801ac5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801ac8:	c1 e8 0c             	shr    $0xc,%eax
  801acb:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801ad2:	83 c4 10             	add    $0x10,%esp
  801ad5:	a8 40                	test   $0x40,%al
  801ad7:	75 16                	jne    801aef <fs_test+0x38a>
  801ad9:	68 1b 44 80 00       	push   $0x80441b
  801ade:	68 3d 3f 80 00       	push   $0x803f3d
  801ae3:	6a 49                	push   $0x49
  801ae5:	68 4e 43 80 00       	push   $0x80434e
  801aea:	e8 dd 00 00 00       	call   801bcc <_panic>
	file_flush(f);
  801aef:	83 ec 0c             	sub    $0xc,%esp
  801af2:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801af5:	e8 d4 f5 ff ff       	call   8010ce <file_flush>
	assert(!(vpt[VPN(blk)] & PTE_D));
  801afa:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801afd:	c1 e8 0c             	shr    $0xc,%eax
  801b00:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b07:	83 c4 10             	add    $0x10,%esp
  801b0a:	a8 40                	test   $0x40,%al
  801b0c:	74 16                	je     801b24 <fs_test+0x3bf>
  801b0e:	68 1a 44 80 00       	push   $0x80441a
  801b13:	68 3d 3f 80 00       	push   $0x803f3d
  801b18:	6a 4b                	push   $0x4b
  801b1a:	68 4e 43 80 00       	push   $0x80434e
  801b1f:	e8 a8 00 00 00       	call   801bcc <_panic>
	file_close(f);
  801b24:	83 ec 0c             	sub    $0xc,%esp
  801b27:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801b2a:	e8 4b f6 ff ff       	call   80117a <file_close>
	assert(!(vpt[VPN(f)] & PTE_D));	
  801b2f:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801b32:	c1 e8 0c             	shr    $0xc,%eax
  801b35:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	a8 40                	test   $0x40,%al
  801b41:	74 16                	je     801b59 <fs_test+0x3f4>
  801b43:	68 6d 44 80 00       	push   $0x80446d
  801b48:	68 3d 3f 80 00       	push   $0x803f3d
  801b4d:	6a 4d                	push   $0x4d
  801b4f:	68 4e 43 80 00       	push   $0x80434e
  801b54:	e8 73 00 00 00       	call   801bcc <_panic>
	cprintf("file rewrite is good\n");
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	68 c4 44 80 00       	push   $0x8044c4
  801b61:	e8 56 01 00 00       	call   801cbc <cprintf>
}
  801b66:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801b69:	5b                   	pop    %ebx
  801b6a:	5e                   	pop    %esi
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    
  801b6d:	00 00                	add    %al,(%eax)
	...

00801b70 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	56                   	push   %esi
  801b74:	53                   	push   %ebx
  801b75:	8b 75 08             	mov    0x8(%ebp),%esi
  801b78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  801b7b:	e8 d4 0a 00 00       	call   802654 <sys_getenvid>
  801b80:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b85:	c1 e0 07             	shl    $0x7,%eax
  801b88:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b8d:	a3 a8 c0 80 00       	mov    %eax,0x80c0a8

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801b92:	85 f6                	test   %esi,%esi
  801b94:	7e 07                	jle    801b9d <libmain+0x2d>
		binaryname = argv[0];
  801b96:	8b 03                	mov    (%ebx),%eax
  801b98:	a3 24 c0 80 00       	mov    %eax,0x80c024

	// call user main routine
	umain(argc, argv);
  801b9d:	83 ec 08             	sub    $0x8,%esp
  801ba0:	53                   	push   %ebx
  801ba1:	56                   	push   %esi
  801ba2:	e8 48 fb ff ff       	call   8016ef <umain>

	// exit gracefully
	exit();
  801ba7:	e8 08 00 00 00       	call   801bb4 <exit>
}
  801bac:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    
	...

00801bb4 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  801bba:	e8 b9 10 00 00       	call   802c78 <close_all>
	sys_env_destroy(0);
  801bbf:	83 ec 0c             	sub    $0xc,%esp
  801bc2:	6a 00                	push   $0x0
  801bc4:	e8 4a 0a 00 00       	call   802613 <sys_env_destroy>
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    
	...

00801bcc <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	53                   	push   %ebx
  801bd0:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  801bd3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  801bd6:	83 3d ac c0 80 00 00 	cmpl   $0x0,0x80c0ac
  801bdd:	74 16                	je     801bf5 <_panic+0x29>
		cprintf("%s: ", argv0);
  801bdf:	83 ec 08             	sub    $0x8,%esp
  801be2:	ff 35 ac c0 80 00    	pushl  0x80c0ac
  801be8:	68 f1 44 80 00       	push   $0x8044f1
  801bed:	e8 ca 00 00 00       	call   801cbc <cprintf>
  801bf2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	ff 35 24 c0 80 00    	pushl  0x80c024
  801c01:	68 f6 44 80 00       	push   $0x8044f6
  801c06:	e8 b1 00 00 00       	call   801cbc <cprintf>
	vcprintf(fmt, ap);
  801c0b:	83 c4 08             	add    $0x8,%esp
  801c0e:	53                   	push   %ebx
  801c0f:	ff 75 10             	pushl  0x10(%ebp)
  801c12:	e8 54 00 00 00       	call   801c6b <vcprintf>
	cprintf("\n");
  801c17:	c7 04 24 97 41 80 00 	movl   $0x804197,(%esp)
  801c1e:	e8 99 00 00 00       	call   801cbc <cprintf>

	// Cause a breakpoint exception
	while (1)
  801c23:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  801c26:	cc                   	int3   
  801c27:	eb fd                	jmp    801c26 <_panic+0x5a>
  801c29:	00 00                	add    %al,(%eax)
	...

00801c2c <putch>:


static void
putch(int ch, struct printbuf *b)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	53                   	push   %ebx
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c36:	8b 03                	mov    (%ebx),%eax
  801c38:	8b 55 08             	mov    0x8(%ebp),%edx
  801c3b:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  801c3f:	40                   	inc    %eax
  801c40:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801c42:	3d ff 00 00 00       	cmp    $0xff,%eax
  801c47:	75 1a                	jne    801c63 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  801c49:	83 ec 08             	sub    $0x8,%esp
  801c4c:	68 ff 00 00 00       	push   $0xff
  801c51:	8d 43 08             	lea    0x8(%ebx),%eax
  801c54:	50                   	push   %eax
  801c55:	e8 76 09 00 00       	call   8025d0 <sys_cputs>
		b->idx = 0;
  801c5a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c60:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  801c63:	ff 43 04             	incl   0x4(%ebx)
}
  801c66:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801c74:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  801c7b:	00 00 00 
	b.cnt = 0;
  801c7e:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  801c85:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801c88:	ff 75 0c             	pushl  0xc(%ebp)
  801c8b:	ff 75 08             	pushl  0x8(%ebp)
  801c8e:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  801c94:	50                   	push   %eax
  801c95:	68 2c 1c 80 00       	push   $0x801c2c
  801c9a:	e8 4f 01 00 00       	call   801dee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801c9f:	83 c4 08             	add    $0x8,%esp
  801ca2:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  801ca8:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  801cae:	50                   	push   %eax
  801caf:	e8 1c 09 00 00       	call   8025d0 <sys_cputs>

	return b.cnt;
  801cb4:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801cc2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801cc5:	50                   	push   %eax
  801cc6:	ff 75 08             	pushl  0x8(%ebp)
  801cc9:	e8 9d ff ff ff       	call   801c6b <vcprintf>
	va_end(ap);

	return cnt;
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	57                   	push   %edi
  801cd4:	56                   	push   %esi
  801cd5:	53                   	push   %ebx
  801cd6:	83 ec 0c             	sub    $0xc,%esp
  801cd9:	8b 75 10             	mov    0x10(%ebp),%esi
  801cdc:	8b 7d 14             	mov    0x14(%ebp),%edi
  801cdf:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801ce2:	8b 45 18             	mov    0x18(%ebp),%eax
  801ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  801cea:	39 fa                	cmp    %edi,%edx
  801cec:	77 39                	ja     801d27 <printnum+0x57>
  801cee:	72 04                	jb     801cf4 <printnum+0x24>
  801cf0:	39 f0                	cmp    %esi,%eax
  801cf2:	77 33                	ja     801d27 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801cf4:	83 ec 04             	sub    $0x4,%esp
  801cf7:	ff 75 20             	pushl  0x20(%ebp)
  801cfa:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  801cfd:	50                   	push   %eax
  801cfe:	ff 75 18             	pushl  0x18(%ebp)
  801d01:	8b 45 18             	mov    0x18(%ebp),%eax
  801d04:	ba 00 00 00 00       	mov    $0x0,%edx
  801d09:	52                   	push   %edx
  801d0a:	50                   	push   %eax
  801d0b:	57                   	push   %edi
  801d0c:	56                   	push   %esi
  801d0d:	e8 22 1f 00 00       	call   803c34 <__udivdi3>
  801d12:	83 c4 10             	add    $0x10,%esp
  801d15:	52                   	push   %edx
  801d16:	50                   	push   %eax
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	ff 75 08             	pushl  0x8(%ebp)
  801d1d:	e8 ae ff ff ff       	call   801cd0 <printnum>
  801d22:	83 c4 20             	add    $0x20,%esp
  801d25:	eb 19                	jmp    801d40 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801d27:	4b                   	dec    %ebx
  801d28:	85 db                	test   %ebx,%ebx
  801d2a:	7e 14                	jle    801d40 <printnum+0x70>
  801d2c:	83 ec 08             	sub    $0x8,%esp
  801d2f:	ff 75 0c             	pushl  0xc(%ebp)
  801d32:	ff 75 20             	pushl  0x20(%ebp)
  801d35:	ff 55 08             	call   *0x8(%ebp)
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	4b                   	dec    %ebx
  801d3c:	85 db                	test   %ebx,%ebx
  801d3e:	7f ec                	jg     801d2c <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801d40:	83 ec 08             	sub    $0x8,%esp
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	8b 45 18             	mov    0x18(%ebp),%eax
  801d49:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	52                   	push   %edx
  801d52:	50                   	push   %eax
  801d53:	57                   	push   %edi
  801d54:	56                   	push   %esi
  801d55:	e8 e6 1f 00 00       	call   803d40 <__umoddi3>
  801d5a:	83 c4 14             	add    $0x14,%esp
  801d5d:	0f be 80 0c 46 80 00 	movsbl 0x80460c(%eax),%eax
  801d64:	50                   	push   %eax
  801d65:	ff 55 08             	call   *0x8(%ebp)
}
  801d68:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d6b:	5b                   	pop    %ebx
  801d6c:	5e                   	pop    %esi
  801d6d:	5f                   	pop    %edi
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d76:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  801d79:	83 f8 01             	cmp    $0x1,%eax
  801d7c:	7e 0f                	jle    801d8d <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  801d7e:	8b 01                	mov    (%ecx),%eax
  801d80:	83 c0 08             	add    $0x8,%eax
  801d83:	89 01                	mov    %eax,(%ecx)
  801d85:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  801d88:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  801d8b:	eb 24                	jmp    801db1 <getuint+0x41>
	else if (lflag)
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	74 11                	je     801da2 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  801d91:	8b 01                	mov    (%ecx),%eax
  801d93:	83 c0 04             	add    $0x4,%eax
  801d96:	89 01                	mov    %eax,(%ecx)
  801d98:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  801d9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801da0:	eb 0f                	jmp    801db1 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  801da2:	8b 01                	mov    (%ecx),%eax
  801da4:	83 c0 04             	add    $0x4,%eax
  801da7:	89 01                	mov    %eax,(%ecx)
  801da9:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  801dac:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	8b 55 08             	mov    0x8(%ebp),%edx
  801db9:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  801dbc:	83 f8 01             	cmp    $0x1,%eax
  801dbf:	7e 0f                	jle    801dd0 <getint+0x1d>
		return va_arg(*ap, long long);
  801dc1:	8b 02                	mov    (%edx),%eax
  801dc3:	83 c0 08             	add    $0x8,%eax
  801dc6:	89 02                	mov    %eax,(%edx)
  801dc8:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  801dcb:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  801dce:	eb 1c                	jmp    801dec <getint+0x39>
	else if (lflag)
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	74 0d                	je     801de1 <getint+0x2e>
		return va_arg(*ap, long);
  801dd4:	8b 02                	mov    (%edx),%eax
  801dd6:	83 c0 04             	add    $0x4,%eax
  801dd9:	89 02                	mov    %eax,(%edx)
  801ddb:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  801dde:	99                   	cltd   
  801ddf:	eb 0b                	jmp    801dec <getint+0x39>
	else
		return va_arg(*ap, int);
  801de1:	8b 02                	mov    (%edx),%eax
  801de3:	83 c0 04             	add    $0x4,%eax
  801de6:	89 02                	mov    %eax,(%edx)
  801de8:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  801deb:	99                   	cltd   
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	57                   	push   %edi
  801df2:	56                   	push   %esi
  801df3:	53                   	push   %ebx
  801df4:	83 ec 1c             	sub    $0x1c,%esp
  801df7:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  801dfa:	0f b6 13             	movzbl (%ebx),%edx
  801dfd:	43                   	inc    %ebx
  801dfe:	83 fa 25             	cmp    $0x25,%edx
  801e01:	74 1e                	je     801e21 <vprintfmt+0x33>
  801e03:	85 d2                	test   %edx,%edx
  801e05:	0f 84 d7 02 00 00    	je     8020e2 <vprintfmt+0x2f4>
  801e0b:	83 ec 08             	sub    $0x8,%esp
  801e0e:	ff 75 0c             	pushl  0xc(%ebp)
  801e11:	52                   	push   %edx
  801e12:	ff 55 08             	call   *0x8(%ebp)
  801e15:	83 c4 10             	add    $0x10,%esp
  801e18:	0f b6 13             	movzbl (%ebx),%edx
  801e1b:	43                   	inc    %ebx
  801e1c:	83 fa 25             	cmp    $0x25,%edx
  801e1f:	75 e2                	jne    801e03 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  801e21:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  801e25:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  801e2c:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  801e31:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  801e36:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801e3d:	0f b6 13             	movzbl (%ebx),%edx
  801e40:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  801e43:	43                   	inc    %ebx
  801e44:	83 f8 55             	cmp    $0x55,%eax
  801e47:	0f 87 70 02 00 00    	ja     8020bd <vprintfmt+0x2cf>
  801e4d:	ff 24 85 9c 46 80 00 	jmp    *0x80469c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  801e54:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  801e58:	eb e3                	jmp    801e3d <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801e5a:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  801e5e:	eb dd                	jmp    801e3d <vprintfmt+0x4f>

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
  801e60:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  801e65:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  801e68:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  801e6c:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  801e6f:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  801e72:	83 f8 09             	cmp    $0x9,%eax
  801e75:	77 27                	ja     801e9e <vprintfmt+0xb0>
  801e77:	43                   	inc    %ebx
  801e78:	eb eb                	jmp    801e65 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801e7a:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801e7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801e81:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  801e84:	eb 18                	jmp    801e9e <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  801e86:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801e8a:	79 b1                	jns    801e3d <vprintfmt+0x4f>
				width = 0;
  801e8c:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  801e93:	eb a8                	jmp    801e3d <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  801e95:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  801e9c:	eb 9f                	jmp    801e3d <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  801e9e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801ea2:	79 99                	jns    801e3d <vprintfmt+0x4f>
				width = precision, precision = -1;
  801ea4:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  801ea7:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  801eac:	eb 8f                	jmp    801e3d <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801eae:	41                   	inc    %ecx
			goto reswitch;
  801eaf:	eb 8c                	jmp    801e3d <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801eb1:	83 ec 08             	sub    $0x8,%esp
  801eb4:	ff 75 0c             	pushl  0xc(%ebp)
  801eb7:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801ebb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ebe:	ff 70 fc             	pushl  0xfffffffc(%eax)
  801ec1:	ff 55 08             	call   *0x8(%ebp)
			break;
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	e9 2e ff ff ff       	jmp    801dfa <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801ecc:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed3:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  801ed6:	85 c0                	test   %eax,%eax
  801ed8:	79 02                	jns    801edc <vprintfmt+0xee>
				err = -err;
  801eda:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801edc:	83 f8 0e             	cmp    $0xe,%eax
  801edf:	7f 0b                	jg     801eec <vprintfmt+0xfe>
  801ee1:	8b 3c 85 60 46 80 00 	mov    0x804660(,%eax,4),%edi
  801ee8:	85 ff                	test   %edi,%edi
  801eea:	75 19                	jne    801f05 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  801eec:	50                   	push   %eax
  801eed:	68 1d 46 80 00       	push   $0x80461d
  801ef2:	ff 75 0c             	pushl  0xc(%ebp)
  801ef5:	ff 75 08             	pushl  0x8(%ebp)
  801ef8:	e8 ed 01 00 00       	call   8020ea <printfmt>
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	e9 f5 fe ff ff       	jmp    801dfa <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  801f05:	57                   	push   %edi
  801f06:	68 4f 3f 80 00       	push   $0x803f4f
  801f0b:	ff 75 0c             	pushl  0xc(%ebp)
  801f0e:	ff 75 08             	pushl  0x8(%ebp)
  801f11:	e8 d4 01 00 00       	call   8020ea <printfmt>
  801f16:	83 c4 10             	add    $0x10,%esp
			break;
  801f19:	e9 dc fe ff ff       	jmp    801dfa <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801f1e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  801f22:	8b 45 14             	mov    0x14(%ebp),%eax
  801f25:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  801f28:	85 ff                	test   %edi,%edi
  801f2a:	75 05                	jne    801f31 <vprintfmt+0x143>
				p = "(null)";
  801f2c:	bf 26 46 80 00       	mov    $0x804626,%edi
			if (width > 0 && padc != '-')
  801f31:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801f35:	7e 3b                	jle    801f72 <vprintfmt+0x184>
  801f37:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  801f3b:	74 35                	je     801f72 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  801f3d:	83 ec 08             	sub    $0x8,%esp
  801f40:	56                   	push   %esi
  801f41:	57                   	push   %edi
  801f42:	e8 56 03 00 00       	call   80229d <strnlen>
  801f47:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801f51:	7e 1f                	jle    801f72 <vprintfmt+0x184>
  801f53:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  801f57:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  801f5a:	83 ec 08             	sub    $0x8,%esp
  801f5d:	ff 75 0c             	pushl  0xc(%ebp)
  801f60:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  801f63:	ff 55 08             	call   *0x8(%ebp)
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	ff 4d f0             	decl   0xfffffff0(%ebp)
  801f6c:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801f70:	7f e8                	jg     801f5a <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801f72:	0f be 17             	movsbl (%edi),%edx
  801f75:	47                   	inc    %edi
  801f76:	85 d2                	test   %edx,%edx
  801f78:	74 44                	je     801fbe <vprintfmt+0x1d0>
  801f7a:	85 f6                	test   %esi,%esi
  801f7c:	78 03                	js     801f81 <vprintfmt+0x193>
  801f7e:	4e                   	dec    %esi
  801f7f:	78 3d                	js     801fbe <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  801f81:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  801f85:	74 18                	je     801f9f <vprintfmt+0x1b1>
  801f87:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  801f8a:	83 f8 5e             	cmp    $0x5e,%eax
  801f8d:	76 10                	jbe    801f9f <vprintfmt+0x1b1>
					putch('?', putdat);
  801f8f:	83 ec 08             	sub    $0x8,%esp
  801f92:	ff 75 0c             	pushl  0xc(%ebp)
  801f95:	6a 3f                	push   $0x3f
  801f97:	ff 55 08             	call   *0x8(%ebp)
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	eb 0d                	jmp    801fac <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  801f9f:	83 ec 08             	sub    $0x8,%esp
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	52                   	push   %edx
  801fa6:	ff 55 08             	call   *0x8(%ebp)
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	ff 4d f0             	decl   0xfffffff0(%ebp)
  801faf:	0f be 17             	movsbl (%edi),%edx
  801fb2:	47                   	inc    %edi
  801fb3:	85 d2                	test   %edx,%edx
  801fb5:	74 07                	je     801fbe <vprintfmt+0x1d0>
  801fb7:	85 f6                	test   %esi,%esi
  801fb9:	78 c6                	js     801f81 <vprintfmt+0x193>
  801fbb:	4e                   	dec    %esi
  801fbc:	79 c3                	jns    801f81 <vprintfmt+0x193>
			for (; width > 0; width--)
  801fbe:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801fc2:	0f 8e 32 fe ff ff    	jle    801dfa <vprintfmt+0xc>
				putch(' ', putdat);
  801fc8:	83 ec 08             	sub    $0x8,%esp
  801fcb:	ff 75 0c             	pushl  0xc(%ebp)
  801fce:	6a 20                	push   $0x20
  801fd0:	ff 55 08             	call   *0x8(%ebp)
  801fd3:	83 c4 10             	add    $0x10,%esp
  801fd6:	ff 4d f0             	decl   0xfffffff0(%ebp)
  801fd9:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801fdd:	7f e9                	jg     801fc8 <vprintfmt+0x1da>
			break;
  801fdf:	e9 16 fe ff ff       	jmp    801dfa <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801fe4:	51                   	push   %ecx
  801fe5:	8d 45 14             	lea    0x14(%ebp),%eax
  801fe8:	50                   	push   %eax
  801fe9:	e8 c5 fd ff ff       	call   801db3 <getint>
  801fee:	89 c6                	mov    %eax,%esi
  801ff0:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  801ff2:	83 c4 08             	add    $0x8,%esp
  801ff5:	85 d2                	test   %edx,%edx
  801ff7:	79 15                	jns    80200e <vprintfmt+0x220>
				putch('-', putdat);
  801ff9:	83 ec 08             	sub    $0x8,%esp
  801ffc:	ff 75 0c             	pushl  0xc(%ebp)
  801fff:	6a 2d                	push   $0x2d
  802001:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  802004:	f7 de                	neg    %esi
  802006:	83 d7 00             	adc    $0x0,%edi
  802009:	f7 df                	neg    %edi
  80200b:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80200e:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  802013:	eb 75                	jmp    80208a <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802015:	51                   	push   %ecx
  802016:	8d 45 14             	lea    0x14(%ebp),%eax
  802019:	50                   	push   %eax
  80201a:	e8 51 fd ff ff       	call   801d70 <getuint>
  80201f:	89 c6                	mov    %eax,%esi
  802021:	89 d7                	mov    %edx,%edi
			base = 10;
  802023:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  802028:	83 c4 08             	add    $0x8,%esp
  80202b:	eb 5d                	jmp    80208a <vprintfmt+0x29c>

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
  80202d:	51                   	push   %ecx
  80202e:	8d 45 14             	lea    0x14(%ebp),%eax
  802031:	50                   	push   %eax
  802032:	e8 39 fd ff ff       	call   801d70 <getuint>
  802037:	89 c6                	mov    %eax,%esi
  802039:	89 d7                	mov    %edx,%edi
			base = 8;
  80203b:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  802040:	83 c4 08             	add    $0x8,%esp
  802043:	eb 45                	jmp    80208a <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  802045:	83 ec 08             	sub    $0x8,%esp
  802048:	ff 75 0c             	pushl  0xc(%ebp)
  80204b:	6a 30                	push   $0x30
  80204d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  802050:	83 c4 08             	add    $0x8,%esp
  802053:	ff 75 0c             	pushl  0xc(%ebp)
  802056:	6a 78                	push   $0x78
  802058:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80205b:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80205f:	8b 45 14             	mov    0x14(%ebp),%eax
  802062:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  802065:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80206a:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  80206f:	83 c4 10             	add    $0x10,%esp
  802072:	eb 16                	jmp    80208a <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802074:	51                   	push   %ecx
  802075:	8d 45 14             	lea    0x14(%ebp),%eax
  802078:	50                   	push   %eax
  802079:	e8 f2 fc ff ff       	call   801d70 <getuint>
  80207e:	89 c6                	mov    %eax,%esi
  802080:	89 d7                	mov    %edx,%edi
			base = 16;
  802082:	ba 10 00 00 00       	mov    $0x10,%edx
  802087:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  802091:	50                   	push   %eax
  802092:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802095:	52                   	push   %edx
  802096:	57                   	push   %edi
  802097:	56                   	push   %esi
  802098:	ff 75 0c             	pushl  0xc(%ebp)
  80209b:	ff 75 08             	pushl  0x8(%ebp)
  80209e:	e8 2d fc ff ff       	call   801cd0 <printnum>
			break;
  8020a3:	83 c4 20             	add    $0x20,%esp
  8020a6:	e9 4f fd ff ff       	jmp    801dfa <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8020ab:	83 ec 08             	sub    $0x8,%esp
  8020ae:	ff 75 0c             	pushl  0xc(%ebp)
  8020b1:	52                   	push   %edx
  8020b2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8020b5:	83 c4 10             	add    $0x10,%esp
  8020b8:	e9 3d fd ff ff       	jmp    801dfa <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8020bd:	83 ec 08             	sub    $0x8,%esp
  8020c0:	ff 75 0c             	pushl  0xc(%ebp)
  8020c3:	6a 25                	push   $0x25
  8020c5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8020c8:	4b                   	dec    %ebx
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8020d0:	0f 84 24 fd ff ff    	je     801dfa <vprintfmt+0xc>
  8020d6:	4b                   	dec    %ebx
  8020d7:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8020db:	75 f9                	jne    8020d6 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8020dd:	e9 18 fd ff ff       	jmp    801dfa <vprintfmt+0xc>
		}
	}
}
  8020e2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8020e5:	5b                   	pop    %ebx
  8020e6:	5e                   	pop    %esi
  8020e7:	5f                   	pop    %edi
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8020f0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8020f3:	50                   	push   %eax
  8020f4:	ff 75 10             	pushl  0x10(%ebp)
  8020f7:	ff 75 0c             	pushl  0xc(%ebp)
  8020fa:	ff 75 08             	pushl  0x8(%ebp)
  8020fd:	e8 ec fc ff ff       	call   801dee <vprintfmt>
	va_end(ap);
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  80210a:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  80210d:	8b 0a                	mov    (%edx),%ecx
  80210f:	3b 4a 04             	cmp    0x4(%edx),%ecx
  802112:	73 07                	jae    80211b <sprintputch+0x17>
		*b->buf++ = ch;
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	88 01                	mov    %al,(%ecx)
  802119:	ff 02                	incl   (%edx)
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 18             	sub    $0x18,%esp
  802123:	8b 55 08             	mov    0x8(%ebp),%edx
  802126:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  802129:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  80212c:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  802130:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  802133:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  80213a:	85 d2                	test   %edx,%edx
  80213c:	74 04                	je     802142 <vsnprintf+0x25>
  80213e:	85 c9                	test   %ecx,%ecx
  802140:	7f 07                	jg     802149 <vsnprintf+0x2c>
		return -E_INVAL;
  802142:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802147:	eb 1d                	jmp    802166 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802149:	ff 75 14             	pushl  0x14(%ebp)
  80214c:	ff 75 10             	pushl  0x10(%ebp)
  80214f:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  802152:	50                   	push   %eax
  802153:	68 04 21 80 00       	push   $0x802104
  802158:	e8 91 fc ff ff       	call   801dee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80215d:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  802160:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802163:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80216e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802171:	50                   	push   %eax
  802172:	ff 75 10             	pushl  0x10(%ebp)
  802175:	ff 75 0c             	pushl  0xc(%ebp)
  802178:	ff 75 08             	pushl  0x8(%ebp)
  80217b:	e8 9d ff ff ff       	call   80211d <vsnprintf>
	va_end(ap);

	return rc;
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    
	...

00802184 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	56                   	push   %esi
  802188:	53                   	push   %ebx
  802189:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  80218c:	83 ec 0c             	sub    $0xc,%esp
  80218f:	56                   	push   %esi
  802190:	e8 ef 00 00 00       	call   802284 <strlen>
  char letter;
  int hexnum = 0;
  802195:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80219a:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  80219f:	83 c4 10             	add    $0x10,%esp
  8021a2:	89 c2                	mov    %eax,%edx
  8021a4:	4a                   	dec    %edx
  8021a5:	0f 88 d0 00 00 00    	js     80227b <strtoint+0xf7>
    letter = string[cidx];
  8021ab:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  8021ae:	85 d2                	test   %edx,%edx
  8021b0:	75 12                	jne    8021c4 <strtoint+0x40>
      if (letter != '0') {
  8021b2:	3c 30                	cmp    $0x30,%al
  8021b4:	0f 84 ba 00 00 00    	je     802274 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8021ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8021bf:	e9 b9 00 00 00       	jmp    80227d <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  8021c4:	83 fa 01             	cmp    $0x1,%edx
  8021c7:	75 12                	jne    8021db <strtoint+0x57>
      if (letter != 'x') {
  8021c9:	3c 78                	cmp    $0x78,%al
  8021cb:	0f 84 a3 00 00 00    	je     802274 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8021d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8021d6:	e9 a2 00 00 00       	jmp    80227d <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8021db:	0f be c0             	movsbl %al,%eax
  8021de:	83 e8 30             	sub    $0x30,%eax
  8021e1:	83 f8 36             	cmp    $0x36,%eax
  8021e4:	0f 87 80 00 00 00    	ja     80226a <strtoint+0xe6>
  8021ea:	ff 24 85 f4 47 80 00 	jmp    *0x8047f4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8021f1:	01 cb                	add    %ecx,%ebx
          break;
  8021f3:	eb 7c                	jmp    802271 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8021f5:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8021f8:	eb 77                	jmp    802271 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8021fa:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8021fd:	01 c3                	add    %eax,%ebx
          break;
  8021ff:	eb 70                	jmp    802271 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  802201:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  802204:	eb 6b                	jmp    802271 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  802206:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  802209:	01 c3                	add    %eax,%ebx
          break;
  80220b:	eb 64                	jmp    802271 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  80220d:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  802210:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  802213:	eb 5c                	jmp    802271 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  802215:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  80221c:	29 c8                	sub    %ecx,%eax
  80221e:	01 c3                	add    %eax,%ebx
          break;
  802220:	eb 4f                	jmp    802271 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  802222:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  802225:	eb 4a                	jmp    802271 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  802227:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  80222a:	01 c3                	add    %eax,%ebx
          break;
  80222c:	eb 43                	jmp    802271 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  80222e:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  802231:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  802234:	eb 3b                	jmp    802271 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  802236:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  802239:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  80223c:	01 c3                	add    %eax,%ebx
          break;
  80223e:	eb 31                	jmp    802271 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  802240:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  802243:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  802246:	eb 29                	jmp    802271 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  802248:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80224b:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  80224e:	01 c3                	add    %eax,%ebx
          break;
  802250:	eb 1f                	jmp    802271 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  802252:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  802259:	29 c8                	sub    %ecx,%eax
  80225b:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  80225e:	eb 11                	jmp    802271 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  802260:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  802263:	8d 04 80             	lea    (%eax,%eax,4),%eax
  802266:	01 c3                	add    %eax,%ebx
          break;
  802268:	eb 07                	jmp    802271 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  80226a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80226f:	eb 0c                	jmp    80227d <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  802271:	c1 e1 04             	shl    $0x4,%ecx
  802274:	4a                   	dec    %edx
  802275:	0f 89 30 ff ff ff    	jns    8021ab <strtoint+0x27>
    }
  }

  return hexnum;
  80227b:	89 d8                	mov    %ebx,%eax
}
  80227d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802280:	5b                   	pop    %ebx
  802281:	5e                   	pop    %esi
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <strlen>:





int
strlen(const char *s)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
  802287:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80228a:	b8 00 00 00 00       	mov    $0x0,%eax
  80228f:	80 3a 00             	cmpb   $0x0,(%edx)
  802292:	74 07                	je     80229b <strlen+0x17>
		n++;
  802294:	40                   	inc    %eax
  802295:	42                   	inc    %edx
  802296:	80 3a 00             	cmpb   $0x0,(%edx)
  802299:	75 f9                	jne    802294 <strlen+0x10>
	return n;
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
  8022a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022a3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8022a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ab:	85 d2                	test   %edx,%edx
  8022ad:	74 0f                	je     8022be <strnlen+0x21>
  8022af:	80 39 00             	cmpb   $0x0,(%ecx)
  8022b2:	74 0a                	je     8022be <strnlen+0x21>
		n++;
  8022b4:	40                   	inc    %eax
  8022b5:	41                   	inc    %ecx
  8022b6:	4a                   	dec    %edx
  8022b7:	74 05                	je     8022be <strnlen+0x21>
  8022b9:	80 39 00             	cmpb   $0x0,(%ecx)
  8022bc:	75 f6                	jne    8022b4 <strnlen+0x17>
	return n;
}
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	53                   	push   %ebx
  8022c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  8022ca:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  8022cc:	8a 02                	mov    (%edx),%al
  8022ce:	42                   	inc    %edx
  8022cf:	88 01                	mov    %al,(%ecx)
  8022d1:	41                   	inc    %ecx
  8022d2:	84 c0                	test   %al,%al
  8022d4:	75 f6                	jne    8022cc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8022d6:	89 d8                	mov    %ebx,%eax
  8022d8:	5b                   	pop    %ebx
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	57                   	push   %edi
  8022df:	56                   	push   %esi
  8022e0:	53                   	push   %ebx
  8022e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e7:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  8022ea:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  8022ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022f1:	39 f3                	cmp    %esi,%ebx
  8022f3:	73 10                	jae    802305 <strncpy+0x2a>
		*dst++ = *src;
  8022f5:	8a 02                	mov    (%edx),%al
  8022f7:	88 01                	mov    %al,(%ecx)
  8022f9:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8022fa:	80 3a 01             	cmpb   $0x1,(%edx)
  8022fd:	83 da ff             	sbb    $0xffffffff,%edx
  802300:	43                   	inc    %ebx
  802301:	39 f3                	cmp    %esi,%ebx
  802303:	72 f0                	jb     8022f5 <strncpy+0x1a>
	}
	return ret;
}
  802305:	89 f8                	mov    %edi,%eax
  802307:	5b                   	pop    %ebx
  802308:	5e                   	pop    %esi
  802309:	5f                   	pop    %edi
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	56                   	push   %esi
  802310:	53                   	push   %ebx
  802311:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802314:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802317:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  80231a:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  80231c:	85 d2                	test   %edx,%edx
  80231e:	74 19                	je     802339 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802320:	4a                   	dec    %edx
  802321:	74 13                	je     802336 <strlcpy+0x2a>
  802323:	80 39 00             	cmpb   $0x0,(%ecx)
  802326:	74 0e                	je     802336 <strlcpy+0x2a>
  802328:	8a 01                	mov    (%ecx),%al
  80232a:	41                   	inc    %ecx
  80232b:	88 03                	mov    %al,(%ebx)
  80232d:	43                   	inc    %ebx
  80232e:	4a                   	dec    %edx
  80232f:	74 05                	je     802336 <strlcpy+0x2a>
  802331:	80 39 00             	cmpb   $0x0,(%ecx)
  802334:	75 f2                	jne    802328 <strlcpy+0x1c>
		*dst = '\0';
  802336:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  802339:	89 d8                	mov    %ebx,%eax
  80233b:	29 f0                	sub    %esi,%eax
}
  80233d:	5b                   	pop    %ebx
  80233e:	5e                   	pop    %esi
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	8b 55 08             	mov    0x8(%ebp),%edx
  802347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  80234a:	80 3a 00             	cmpb   $0x0,(%edx)
  80234d:	74 13                	je     802362 <strcmp+0x21>
  80234f:	8a 02                	mov    (%edx),%al
  802351:	3a 01                	cmp    (%ecx),%al
  802353:	75 0d                	jne    802362 <strcmp+0x21>
  802355:	42                   	inc    %edx
  802356:	41                   	inc    %ecx
  802357:	80 3a 00             	cmpb   $0x0,(%edx)
  80235a:	74 06                	je     802362 <strcmp+0x21>
  80235c:	8a 02                	mov    (%edx),%al
  80235e:	3a 01                	cmp    (%ecx),%al
  802360:	74 f3                	je     802355 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802362:	0f b6 02             	movzbl (%edx),%eax
  802365:	0f b6 11             	movzbl (%ecx),%edx
  802368:	29 d0                	sub    %edx,%eax
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	53                   	push   %ebx
  802370:	8b 55 08             	mov    0x8(%ebp),%edx
  802373:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802376:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  802379:	85 c9                	test   %ecx,%ecx
  80237b:	74 1f                	je     80239c <strncmp+0x30>
  80237d:	80 3a 00             	cmpb   $0x0,(%edx)
  802380:	74 16                	je     802398 <strncmp+0x2c>
  802382:	8a 02                	mov    (%edx),%al
  802384:	3a 03                	cmp    (%ebx),%al
  802386:	75 10                	jne    802398 <strncmp+0x2c>
  802388:	42                   	inc    %edx
  802389:	43                   	inc    %ebx
  80238a:	49                   	dec    %ecx
  80238b:	74 0f                	je     80239c <strncmp+0x30>
  80238d:	80 3a 00             	cmpb   $0x0,(%edx)
  802390:	74 06                	je     802398 <strncmp+0x2c>
  802392:	8a 02                	mov    (%edx),%al
  802394:	3a 03                	cmp    (%ebx),%al
  802396:	74 f0                	je     802388 <strncmp+0x1c>
	if (n == 0)
  802398:	85 c9                	test   %ecx,%ecx
  80239a:	75 07                	jne    8023a3 <strncmp+0x37>
		return 0;
  80239c:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a1:	eb 0a                	jmp    8023ad <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8023a3:	0f b6 12             	movzbl (%edx),%edx
  8023a6:	0f b6 03             	movzbl (%ebx),%eax
  8023a9:	29 c2                	sub    %eax,%edx
  8023ab:	89 d0                	mov    %edx,%eax
}
  8023ad:	5b                   	pop    %ebx
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8023b9:	80 38 00             	cmpb   $0x0,(%eax)
  8023bc:	74 0a                	je     8023c8 <strchr+0x18>
		if (*s == c)
  8023be:	38 10                	cmp    %dl,(%eax)
  8023c0:	74 0b                	je     8023cd <strchr+0x1d>
  8023c2:	40                   	inc    %eax
  8023c3:	80 38 00             	cmpb   $0x0,(%eax)
  8023c6:	75 f6                	jne    8023be <strchr+0xe>
			return (char *) s;
	return 0;
  8023c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cd:	c9                   	leave  
  8023ce:	c3                   	ret    

008023cf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8023d8:	80 38 00             	cmpb   $0x0,(%eax)
  8023db:	74 0a                	je     8023e7 <strfind+0x18>
		if (*s == c)
  8023dd:	38 10                	cmp    %dl,(%eax)
  8023df:	74 06                	je     8023e7 <strfind+0x18>
  8023e1:	40                   	inc    %eax
  8023e2:	80 38 00             	cmpb   $0x0,(%eax)
  8023e5:	75 f6                	jne    8023dd <strfind+0xe>
			break;
	return (char *) s;
}
  8023e7:	c9                   	leave  
  8023e8:	c3                   	ret    

008023e9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8023e9:	55                   	push   %ebp
  8023ea:	89 e5                	mov    %esp,%ebp
  8023ec:	57                   	push   %edi
  8023ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  8023f3:	89 f8                	mov    %edi,%eax
  8023f5:	85 c9                	test   %ecx,%ecx
  8023f7:	74 40                	je     802439 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  8023f9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8023ff:	75 30                	jne    802431 <memset+0x48>
  802401:	f6 c1 03             	test   $0x3,%cl
  802404:	75 2b                	jne    802431 <memset+0x48>
		c &= 0xFF;
  802406:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80240d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802410:	c1 e0 18             	shl    $0x18,%eax
  802413:	8b 55 0c             	mov    0xc(%ebp),%edx
  802416:	c1 e2 10             	shl    $0x10,%edx
  802419:	09 d0                	or     %edx,%eax
  80241b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241e:	c1 e2 08             	shl    $0x8,%edx
  802421:	09 d0                	or     %edx,%eax
  802423:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  802426:	c1 e9 02             	shr    $0x2,%ecx
  802429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242c:	fc                   	cld    
  80242d:	f3 ab                	repz stos %eax,%es:(%edi)
  80242f:	eb 06                	jmp    802437 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802431:	8b 45 0c             	mov    0xc(%ebp),%eax
  802434:	fc                   	cld    
  802435:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  802437:	89 f8                	mov    %edi,%eax
}
  802439:	5f                   	pop    %edi
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	57                   	push   %edi
  802440:	56                   	push   %esi
  802441:	8b 45 08             	mov    0x8(%ebp),%eax
  802444:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  802447:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80244a:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80244c:	39 c6                	cmp    %eax,%esi
  80244e:	73 33                	jae    802483 <memmove+0x47>
  802450:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802453:	39 c2                	cmp    %eax,%edx
  802455:	76 2c                	jbe    802483 <memmove+0x47>
		s += n;
  802457:	89 d6                	mov    %edx,%esi
		d += n;
  802459:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80245c:	f6 c2 03             	test   $0x3,%dl
  80245f:	75 1b                	jne    80247c <memmove+0x40>
  802461:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802467:	75 13                	jne    80247c <memmove+0x40>
  802469:	f6 c1 03             	test   $0x3,%cl
  80246c:	75 0e                	jne    80247c <memmove+0x40>
			asm volatile("std; rep movsl\n"
  80246e:	83 ef 04             	sub    $0x4,%edi
  802471:	83 ee 04             	sub    $0x4,%esi
  802474:	c1 e9 02             	shr    $0x2,%ecx
  802477:	fd                   	std    
  802478:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  80247a:	eb 27                	jmp    8024a3 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80247c:	4f                   	dec    %edi
  80247d:	4e                   	dec    %esi
  80247e:	fd                   	std    
  80247f:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  802481:	eb 20                	jmp    8024a3 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802483:	f7 c6 03 00 00 00    	test   $0x3,%esi
  802489:	75 15                	jne    8024a0 <memmove+0x64>
  80248b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802491:	75 0d                	jne    8024a0 <memmove+0x64>
  802493:	f6 c1 03             	test   $0x3,%cl
  802496:	75 08                	jne    8024a0 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  802498:	c1 e9 02             	shr    $0x2,%ecx
  80249b:	fc                   	cld    
  80249c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  80249e:	eb 03                	jmp    8024a3 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8024a0:	fc                   	cld    
  8024a1:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8024a3:	5e                   	pop    %esi
  8024a4:	5f                   	pop    %edi
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <memcpy>:

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
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8024aa:	ff 75 10             	pushl  0x10(%ebp)
  8024ad:	ff 75 0c             	pushl  0xc(%ebp)
  8024b0:	ff 75 08             	pushl  0x8(%ebp)
  8024b3:	e8 84 ff ff ff       	call   80243c <memmove>
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  8024be:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  8024c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8024c4:	8b 55 10             	mov    0x10(%ebp),%edx
  8024c7:	4a                   	dec    %edx
  8024c8:	83 fa ff             	cmp    $0xffffffff,%edx
  8024cb:	74 1a                	je     8024e7 <memcmp+0x2d>
  8024cd:	8a 01                	mov    (%ecx),%al
  8024cf:	3a 03                	cmp    (%ebx),%al
  8024d1:	74 0c                	je     8024df <memcmp+0x25>
  8024d3:	0f b6 d0             	movzbl %al,%edx
  8024d6:	0f b6 03             	movzbl (%ebx),%eax
  8024d9:	29 c2                	sub    %eax,%edx
  8024db:	89 d0                	mov    %edx,%eax
  8024dd:	eb 0d                	jmp    8024ec <memcmp+0x32>
  8024df:	41                   	inc    %ecx
  8024e0:	43                   	inc    %ebx
  8024e1:	4a                   	dec    %edx
  8024e2:	83 fa ff             	cmp    $0xffffffff,%edx
  8024e5:	75 e6                	jne    8024cd <memcmp+0x13>
	}

	return 0;
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ec:	5b                   	pop    %ebx
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8024f8:	89 c2                	mov    %eax,%edx
  8024fa:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8024fd:	39 d0                	cmp    %edx,%eax
  8024ff:	73 09                	jae    80250a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  802501:	38 08                	cmp    %cl,(%eax)
  802503:	74 05                	je     80250a <memfind+0x1b>
  802505:	40                   	inc    %eax
  802506:	39 d0                	cmp    %edx,%eax
  802508:	72 f7                	jb     802501 <memfind+0x12>
			break;
	return (void *) s;
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    

0080250c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	57                   	push   %edi
  802510:	56                   	push   %esi
  802511:	53                   	push   %ebx
  802512:	8b 55 08             	mov    0x8(%ebp),%edx
  802515:	8b 75 0c             	mov    0xc(%ebp),%esi
  802518:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  80251b:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  802520:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  802525:	80 3a 20             	cmpb   $0x20,(%edx)
  802528:	74 05                	je     80252f <strtol+0x23>
  80252a:	80 3a 09             	cmpb   $0x9,(%edx)
  80252d:	75 0b                	jne    80253a <strtol+0x2e>
  80252f:	42                   	inc    %edx
  802530:	80 3a 20             	cmpb   $0x20,(%edx)
  802533:	74 fa                	je     80252f <strtol+0x23>
  802535:	80 3a 09             	cmpb   $0x9,(%edx)
  802538:	74 f5                	je     80252f <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  80253a:	80 3a 2b             	cmpb   $0x2b,(%edx)
  80253d:	75 03                	jne    802542 <strtol+0x36>
		s++;
  80253f:	42                   	inc    %edx
  802540:	eb 0b                	jmp    80254d <strtol+0x41>
	else if (*s == '-')
  802542:	80 3a 2d             	cmpb   $0x2d,(%edx)
  802545:	75 06                	jne    80254d <strtol+0x41>
		s++, neg = 1;
  802547:	42                   	inc    %edx
  802548:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80254d:	85 c9                	test   %ecx,%ecx
  80254f:	74 05                	je     802556 <strtol+0x4a>
  802551:	83 f9 10             	cmp    $0x10,%ecx
  802554:	75 15                	jne    80256b <strtol+0x5f>
  802556:	80 3a 30             	cmpb   $0x30,(%edx)
  802559:	75 10                	jne    80256b <strtol+0x5f>
  80255b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80255f:	75 0a                	jne    80256b <strtol+0x5f>
		s += 2, base = 16;
  802561:	83 c2 02             	add    $0x2,%edx
  802564:	b9 10 00 00 00       	mov    $0x10,%ecx
  802569:	eb 14                	jmp    80257f <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  80256b:	85 c9                	test   %ecx,%ecx
  80256d:	75 10                	jne    80257f <strtol+0x73>
  80256f:	80 3a 30             	cmpb   $0x30,(%edx)
  802572:	75 05                	jne    802579 <strtol+0x6d>
		s++, base = 8;
  802574:	42                   	inc    %edx
  802575:	b1 08                	mov    $0x8,%cl
  802577:	eb 06                	jmp    80257f <strtol+0x73>
	else if (base == 0)
  802579:	85 c9                	test   %ecx,%ecx
  80257b:	75 02                	jne    80257f <strtol+0x73>
		base = 10;
  80257d:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80257f:	8a 02                	mov    (%edx),%al
  802581:	83 e8 30             	sub    $0x30,%eax
  802584:	3c 09                	cmp    $0x9,%al
  802586:	77 08                	ja     802590 <strtol+0x84>
			dig = *s - '0';
  802588:	0f be 02             	movsbl (%edx),%eax
  80258b:	83 e8 30             	sub    $0x30,%eax
  80258e:	eb 20                	jmp    8025b0 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  802590:	8a 02                	mov    (%edx),%al
  802592:	83 e8 61             	sub    $0x61,%eax
  802595:	3c 19                	cmp    $0x19,%al
  802597:	77 08                	ja     8025a1 <strtol+0x95>
			dig = *s - 'a' + 10;
  802599:	0f be 02             	movsbl (%edx),%eax
  80259c:	83 e8 57             	sub    $0x57,%eax
  80259f:	eb 0f                	jmp    8025b0 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  8025a1:	8a 02                	mov    (%edx),%al
  8025a3:	83 e8 41             	sub    $0x41,%eax
  8025a6:	3c 19                	cmp    $0x19,%al
  8025a8:	77 12                	ja     8025bc <strtol+0xb0>
			dig = *s - 'A' + 10;
  8025aa:	0f be 02             	movsbl (%edx),%eax
  8025ad:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  8025b0:	39 c8                	cmp    %ecx,%eax
  8025b2:	7d 08                	jge    8025bc <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  8025b4:	42                   	inc    %edx
  8025b5:	0f af d9             	imul   %ecx,%ebx
  8025b8:	01 c3                	add    %eax,%ebx
  8025ba:	eb c3                	jmp    80257f <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  8025bc:	85 f6                	test   %esi,%esi
  8025be:	74 02                	je     8025c2 <strtol+0xb6>
		*endptr = (char *) s;
  8025c0:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8025c2:	89 d8                	mov    %ebx,%eax
  8025c4:	85 ff                	test   %edi,%edi
  8025c6:	74 02                	je     8025ca <strtol+0xbe>
  8025c8:	f7 d8                	neg    %eax
}
  8025ca:	5b                   	pop    %ebx
  8025cb:	5e                   	pop    %esi
  8025cc:	5f                   	pop    %edi
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    
	...

008025d0 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	57                   	push   %edi
  8025d4:	56                   	push   %esi
  8025d5:	53                   	push   %ebx
  8025d6:	83 ec 04             	sub    $0x4,%esp
  8025d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025df:	bf 00 00 00 00       	mov    $0x0,%edi
  8025e4:	89 f8                	mov    %edi,%eax
  8025e6:	89 fb                	mov    %edi,%ebx
  8025e8:	89 fe                	mov    %edi,%esi
  8025ea:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8025ec:	83 c4 04             	add    $0x4,%esp
  8025ef:	5b                   	pop    %ebx
  8025f0:	5e                   	pop    %esi
  8025f1:	5f                   	pop    %edi
  8025f2:	c9                   	leave  
  8025f3:	c3                   	ret    

008025f4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8025f4:	55                   	push   %ebp
  8025f5:	89 e5                	mov    %esp,%ebp
  8025f7:	57                   	push   %edi
  8025f8:	56                   	push   %esi
  8025f9:	53                   	push   %ebx
  8025fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ff:	bf 00 00 00 00       	mov    $0x0,%edi
  802604:	89 fa                	mov    %edi,%edx
  802606:	89 f9                	mov    %edi,%ecx
  802608:	89 fb                	mov    %edi,%ebx
  80260a:	89 fe                	mov    %edi,%esi
  80260c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80260e:	5b                   	pop    %ebx
  80260f:	5e                   	pop    %esi
  802610:	5f                   	pop    %edi
  802611:	c9                   	leave  
  802612:	c3                   	ret    

00802613 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802613:	55                   	push   %ebp
  802614:	89 e5                	mov    %esp,%ebp
  802616:	57                   	push   %edi
  802617:	56                   	push   %esi
  802618:	53                   	push   %ebx
  802619:	83 ec 0c             	sub    $0xc,%esp
  80261c:	8b 55 08             	mov    0x8(%ebp),%edx
  80261f:	b8 03 00 00 00       	mov    $0x3,%eax
  802624:	bf 00 00 00 00       	mov    $0x0,%edi
  802629:	89 f9                	mov    %edi,%ecx
  80262b:	89 fb                	mov    %edi,%ebx
  80262d:	89 fe                	mov    %edi,%esi
  80262f:	cd 30                	int    $0x30
  802631:	85 c0                	test   %eax,%eax
  802633:	7e 17                	jle    80264c <sys_env_destroy+0x39>
  802635:	83 ec 0c             	sub    $0xc,%esp
  802638:	50                   	push   %eax
  802639:	6a 03                	push   $0x3
  80263b:	68 d0 48 80 00       	push   $0x8048d0
  802640:	6a 23                	push   $0x23
  802642:	68 ed 48 80 00       	push   $0x8048ed
  802647:	e8 80 f5 ff ff       	call   801bcc <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80264c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80264f:	5b                   	pop    %ebx
  802650:	5e                   	pop    %esi
  802651:	5f                   	pop    %edi
  802652:	c9                   	leave  
  802653:	c3                   	ret    

00802654 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
  802657:	57                   	push   %edi
  802658:	56                   	push   %esi
  802659:	53                   	push   %ebx
  80265a:	b8 02 00 00 00       	mov    $0x2,%eax
  80265f:	bf 00 00 00 00       	mov    $0x0,%edi
  802664:	89 fa                	mov    %edi,%edx
  802666:	89 f9                	mov    %edi,%ecx
  802668:	89 fb                	mov    %edi,%ebx
  80266a:	89 fe                	mov    %edi,%esi
  80266c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80266e:	5b                   	pop    %ebx
  80266f:	5e                   	pop    %esi
  802670:	5f                   	pop    %edi
  802671:	c9                   	leave  
  802672:	c3                   	ret    

00802673 <sys_yield>:

void
sys_yield(void)
{
  802673:	55                   	push   %ebp
  802674:	89 e5                	mov    %esp,%ebp
  802676:	57                   	push   %edi
  802677:	56                   	push   %esi
  802678:	53                   	push   %ebx
  802679:	b8 0b 00 00 00       	mov    $0xb,%eax
  80267e:	bf 00 00 00 00       	mov    $0x0,%edi
  802683:	89 fa                	mov    %edi,%edx
  802685:	89 f9                	mov    %edi,%ecx
  802687:	89 fb                	mov    %edi,%ebx
  802689:	89 fe                	mov    %edi,%esi
  80268b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80268d:	5b                   	pop    %ebx
  80268e:	5e                   	pop    %esi
  80268f:	5f                   	pop    %edi
  802690:	c9                   	leave  
  802691:	c3                   	ret    

00802692 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
  802695:	57                   	push   %edi
  802696:	56                   	push   %esi
  802697:	53                   	push   %ebx
  802698:	83 ec 0c             	sub    $0xc,%esp
  80269b:	8b 55 08             	mov    0x8(%ebp),%edx
  80269e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026a4:	b8 04 00 00 00       	mov    $0x4,%eax
  8026a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ae:	89 fe                	mov    %edi,%esi
  8026b0:	cd 30                	int    $0x30
  8026b2:	85 c0                	test   %eax,%eax
  8026b4:	7e 17                	jle    8026cd <sys_page_alloc+0x3b>
  8026b6:	83 ec 0c             	sub    $0xc,%esp
  8026b9:	50                   	push   %eax
  8026ba:	6a 04                	push   $0x4
  8026bc:	68 d0 48 80 00       	push   $0x8048d0
  8026c1:	6a 23                	push   $0x23
  8026c3:	68 ed 48 80 00       	push   $0x8048ed
  8026c8:	e8 ff f4 ff ff       	call   801bcc <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8026cd:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8026d0:	5b                   	pop    %ebx
  8026d1:	5e                   	pop    %esi
  8026d2:	5f                   	pop    %edi
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	57                   	push   %edi
  8026d9:	56                   	push   %esi
  8026da:	53                   	push   %ebx
  8026db:	83 ec 0c             	sub    $0xc,%esp
  8026de:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026e7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8026ea:	8b 75 18             	mov    0x18(%ebp),%esi
  8026ed:	b8 05 00 00 00       	mov    $0x5,%eax
  8026f2:	cd 30                	int    $0x30
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	7e 17                	jle    80270f <sys_page_map+0x3a>
  8026f8:	83 ec 0c             	sub    $0xc,%esp
  8026fb:	50                   	push   %eax
  8026fc:	6a 05                	push   $0x5
  8026fe:	68 d0 48 80 00       	push   $0x8048d0
  802703:	6a 23                	push   $0x23
  802705:	68 ed 48 80 00       	push   $0x8048ed
  80270a:	e8 bd f4 ff ff       	call   801bcc <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80270f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802712:	5b                   	pop    %ebx
  802713:	5e                   	pop    %esi
  802714:	5f                   	pop    %edi
  802715:	c9                   	leave  
  802716:	c3                   	ret    

00802717 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802717:	55                   	push   %ebp
  802718:	89 e5                	mov    %esp,%ebp
  80271a:	57                   	push   %edi
  80271b:	56                   	push   %esi
  80271c:	53                   	push   %ebx
  80271d:	83 ec 0c             	sub    $0xc,%esp
  802720:	8b 55 08             	mov    0x8(%ebp),%edx
  802723:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802726:	b8 06 00 00 00       	mov    $0x6,%eax
  80272b:	bf 00 00 00 00       	mov    $0x0,%edi
  802730:	89 fb                	mov    %edi,%ebx
  802732:	89 fe                	mov    %edi,%esi
  802734:	cd 30                	int    $0x30
  802736:	85 c0                	test   %eax,%eax
  802738:	7e 17                	jle    802751 <sys_page_unmap+0x3a>
  80273a:	83 ec 0c             	sub    $0xc,%esp
  80273d:	50                   	push   %eax
  80273e:	6a 06                	push   $0x6
  802740:	68 d0 48 80 00       	push   $0x8048d0
  802745:	6a 23                	push   $0x23
  802747:	68 ed 48 80 00       	push   $0x8048ed
  80274c:	e8 7b f4 ff ff       	call   801bcc <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802751:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802754:	5b                   	pop    %ebx
  802755:	5e                   	pop    %esi
  802756:	5f                   	pop    %edi
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	57                   	push   %edi
  80275d:	56                   	push   %esi
  80275e:	53                   	push   %ebx
  80275f:	83 ec 0c             	sub    $0xc,%esp
  802762:	8b 55 08             	mov    0x8(%ebp),%edx
  802765:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802768:	b8 08 00 00 00       	mov    $0x8,%eax
  80276d:	bf 00 00 00 00       	mov    $0x0,%edi
  802772:	89 fb                	mov    %edi,%ebx
  802774:	89 fe                	mov    %edi,%esi
  802776:	cd 30                	int    $0x30
  802778:	85 c0                	test   %eax,%eax
  80277a:	7e 17                	jle    802793 <sys_env_set_status+0x3a>
  80277c:	83 ec 0c             	sub    $0xc,%esp
  80277f:	50                   	push   %eax
  802780:	6a 08                	push   $0x8
  802782:	68 d0 48 80 00       	push   $0x8048d0
  802787:	6a 23                	push   $0x23
  802789:	68 ed 48 80 00       	push   $0x8048ed
  80278e:	e8 39 f4 ff ff       	call   801bcc <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802793:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802796:	5b                   	pop    %ebx
  802797:	5e                   	pop    %esi
  802798:	5f                   	pop    %edi
  802799:	c9                   	leave  
  80279a:	c3                   	ret    

0080279b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80279b:	55                   	push   %ebp
  80279c:	89 e5                	mov    %esp,%ebp
  80279e:	57                   	push   %edi
  80279f:	56                   	push   %esi
  8027a0:	53                   	push   %ebx
  8027a1:	83 ec 0c             	sub    $0xc,%esp
  8027a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027aa:	b8 09 00 00 00       	mov    $0x9,%eax
  8027af:	bf 00 00 00 00       	mov    $0x0,%edi
  8027b4:	89 fb                	mov    %edi,%ebx
  8027b6:	89 fe                	mov    %edi,%esi
  8027b8:	cd 30                	int    $0x30
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	7e 17                	jle    8027d5 <sys_env_set_trapframe+0x3a>
  8027be:	83 ec 0c             	sub    $0xc,%esp
  8027c1:	50                   	push   %eax
  8027c2:	6a 09                	push   $0x9
  8027c4:	68 d0 48 80 00       	push   $0x8048d0
  8027c9:	6a 23                	push   $0x23
  8027cb:	68 ed 48 80 00       	push   $0x8048ed
  8027d0:	e8 f7 f3 ff ff       	call   801bcc <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8027d5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8027d8:	5b                   	pop    %ebx
  8027d9:	5e                   	pop    %esi
  8027da:	5f                   	pop    %edi
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	57                   	push   %edi
  8027e1:	56                   	push   %esi
  8027e2:	53                   	push   %ebx
  8027e3:	83 ec 0c             	sub    $0xc,%esp
  8027e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  8027f1:	bf 00 00 00 00       	mov    $0x0,%edi
  8027f6:	89 fb                	mov    %edi,%ebx
  8027f8:	89 fe                	mov    %edi,%esi
  8027fa:	cd 30                	int    $0x30
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	7e 17                	jle    802817 <sys_env_set_pgfault_upcall+0x3a>
  802800:	83 ec 0c             	sub    $0xc,%esp
  802803:	50                   	push   %eax
  802804:	6a 0a                	push   $0xa
  802806:	68 d0 48 80 00       	push   $0x8048d0
  80280b:	6a 23                	push   $0x23
  80280d:	68 ed 48 80 00       	push   $0x8048ed
  802812:	e8 b5 f3 ff ff       	call   801bcc <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802817:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80281a:	5b                   	pop    %ebx
  80281b:	5e                   	pop    %esi
  80281c:	5f                   	pop    %edi
  80281d:	c9                   	leave  
  80281e:	c3                   	ret    

0080281f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80281f:	55                   	push   %ebp
  802820:	89 e5                	mov    %esp,%ebp
  802822:	57                   	push   %edi
  802823:	56                   	push   %esi
  802824:	53                   	push   %ebx
  802825:	8b 55 08             	mov    0x8(%ebp),%edx
  802828:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80282b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80282e:	8b 7d 14             	mov    0x14(%ebp),%edi
  802831:	b8 0c 00 00 00       	mov    $0xc,%eax
  802836:	be 00 00 00 00       	mov    $0x0,%esi
  80283b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80283d:	5b                   	pop    %ebx
  80283e:	5e                   	pop    %esi
  80283f:	5f                   	pop    %edi
  802840:	c9                   	leave  
  802841:	c3                   	ret    

00802842 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802842:	55                   	push   %ebp
  802843:	89 e5                	mov    %esp,%ebp
  802845:	57                   	push   %edi
  802846:	56                   	push   %esi
  802847:	53                   	push   %ebx
  802848:	83 ec 0c             	sub    $0xc,%esp
  80284b:	8b 55 08             	mov    0x8(%ebp),%edx
  80284e:	b8 0d 00 00 00       	mov    $0xd,%eax
  802853:	bf 00 00 00 00       	mov    $0x0,%edi
  802858:	89 f9                	mov    %edi,%ecx
  80285a:	89 fb                	mov    %edi,%ebx
  80285c:	89 fe                	mov    %edi,%esi
  80285e:	cd 30                	int    $0x30
  802860:	85 c0                	test   %eax,%eax
  802862:	7e 17                	jle    80287b <sys_ipc_recv+0x39>
  802864:	83 ec 0c             	sub    $0xc,%esp
  802867:	50                   	push   %eax
  802868:	6a 0d                	push   $0xd
  80286a:	68 d0 48 80 00       	push   $0x8048d0
  80286f:	6a 23                	push   $0x23
  802871:	68 ed 48 80 00       	push   $0x8048ed
  802876:	e8 51 f3 ff ff       	call   801bcc <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80287b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80287e:	5b                   	pop    %ebx
  80287f:	5e                   	pop    %esi
  802880:	5f                   	pop    %edi
  802881:	c9                   	leave  
  802882:	c3                   	ret    

00802883 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
  802886:	57                   	push   %edi
  802887:	56                   	push   %esi
  802888:	53                   	push   %ebx
  802889:	83 ec 0c             	sub    $0xc,%esp
  80288c:	8b 55 08             	mov    0x8(%ebp),%edx
  80288f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802892:	b8 10 00 00 00       	mov    $0x10,%eax
  802897:	bf 00 00 00 00       	mov    $0x0,%edi
  80289c:	89 fb                	mov    %edi,%ebx
  80289e:	89 fe                	mov    %edi,%esi
  8028a0:	cd 30                	int    $0x30
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	7e 17                	jle    8028bd <sys_transmit_packet+0x3a>
  8028a6:	83 ec 0c             	sub    $0xc,%esp
  8028a9:	50                   	push   %eax
  8028aa:	6a 10                	push   $0x10
  8028ac:	68 d0 48 80 00       	push   $0x8048d0
  8028b1:	6a 23                	push   $0x23
  8028b3:	68 ed 48 80 00       	push   $0x8048ed
  8028b8:	e8 0f f3 ff ff       	call   801bcc <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  8028bd:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8028c0:	5b                   	pop    %ebx
  8028c1:	5e                   	pop    %esi
  8028c2:	5f                   	pop    %edi
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    

008028c5 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	57                   	push   %edi
  8028c9:	56                   	push   %esi
  8028ca:	53                   	push   %ebx
  8028cb:	83 ec 0c             	sub    $0xc,%esp
  8028ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028d4:	b8 11 00 00 00       	mov    $0x11,%eax
  8028d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8028de:	89 fb                	mov    %edi,%ebx
  8028e0:	89 fe                	mov    %edi,%esi
  8028e2:	cd 30                	int    $0x30
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	7e 17                	jle    8028ff <sys_receive_packet+0x3a>
  8028e8:	83 ec 0c             	sub    $0xc,%esp
  8028eb:	50                   	push   %eax
  8028ec:	6a 11                	push   $0x11
  8028ee:	68 d0 48 80 00       	push   $0x8048d0
  8028f3:	6a 23                	push   $0x23
  8028f5:	68 ed 48 80 00       	push   $0x8048ed
  8028fa:	e8 cd f2 ff ff       	call   801bcc <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  8028ff:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802902:	5b                   	pop    %ebx
  802903:	5e                   	pop    %esi
  802904:	5f                   	pop    %edi
  802905:	c9                   	leave  
  802906:	c3                   	ret    

00802907 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802907:	55                   	push   %ebp
  802908:	89 e5                	mov    %esp,%ebp
  80290a:	57                   	push   %edi
  80290b:	56                   	push   %esi
  80290c:	53                   	push   %ebx
  80290d:	b8 0f 00 00 00       	mov    $0xf,%eax
  802912:	bf 00 00 00 00       	mov    $0x0,%edi
  802917:	89 fa                	mov    %edi,%edx
  802919:	89 f9                	mov    %edi,%ecx
  80291b:	89 fb                	mov    %edi,%ebx
  80291d:	89 fe                	mov    %edi,%esi
  80291f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802921:	5b                   	pop    %ebx
  802922:	5e                   	pop    %esi
  802923:	5f                   	pop    %edi
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
  802929:	57                   	push   %edi
  80292a:	56                   	push   %esi
  80292b:	53                   	push   %ebx
  80292c:	83 ec 0c             	sub    $0xc,%esp
  80292f:	8b 55 08             	mov    0x8(%ebp),%edx
  802932:	b8 0e 00 00 00       	mov    $0xe,%eax
  802937:	bf 00 00 00 00       	mov    $0x0,%edi
  80293c:	89 f9                	mov    %edi,%ecx
  80293e:	89 fb                	mov    %edi,%ebx
  802940:	89 fe                	mov    %edi,%esi
  802942:	cd 30                	int    $0x30
  802944:	85 c0                	test   %eax,%eax
  802946:	7e 17                	jle    80295f <sys_map_receive_buffers+0x39>
  802948:	83 ec 0c             	sub    $0xc,%esp
  80294b:	50                   	push   %eax
  80294c:	6a 0e                	push   $0xe
  80294e:	68 d0 48 80 00       	push   $0x8048d0
  802953:	6a 23                	push   $0x23
  802955:	68 ed 48 80 00       	push   $0x8048ed
  80295a:	e8 6d f2 ff ff       	call   801bcc <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  80295f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802962:	5b                   	pop    %ebx
  802963:	5e                   	pop    %esi
  802964:	5f                   	pop    %edi
  802965:	c9                   	leave  
  802966:	c3                   	ret    

00802967 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
  80296a:	57                   	push   %edi
  80296b:	56                   	push   %esi
  80296c:	53                   	push   %ebx
  80296d:	83 ec 0c             	sub    $0xc,%esp
  802970:	8b 55 08             	mov    0x8(%ebp),%edx
  802973:	b8 12 00 00 00       	mov    $0x12,%eax
  802978:	bf 00 00 00 00       	mov    $0x0,%edi
  80297d:	89 f9                	mov    %edi,%ecx
  80297f:	89 fb                	mov    %edi,%ebx
  802981:	89 fe                	mov    %edi,%esi
  802983:	cd 30                	int    $0x30
  802985:	85 c0                	test   %eax,%eax
  802987:	7e 17                	jle    8029a0 <sys_receive_packet_zerocopy+0x39>
  802989:	83 ec 0c             	sub    $0xc,%esp
  80298c:	50                   	push   %eax
  80298d:	6a 12                	push   $0x12
  80298f:	68 d0 48 80 00       	push   $0x8048d0
  802994:	6a 23                	push   $0x23
  802996:	68 ed 48 80 00       	push   $0x8048ed
  80299b:	e8 2c f2 ff ff       	call   801bcc <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  8029a0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8029a3:	5b                   	pop    %ebx
  8029a4:	5e                   	pop    %esi
  8029a5:	5f                   	pop    %edi
  8029a6:	c9                   	leave  
  8029a7:	c3                   	ret    

008029a8 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  8029a8:	55                   	push   %ebp
  8029a9:	89 e5                	mov    %esp,%ebp
  8029ab:	57                   	push   %edi
  8029ac:	56                   	push   %esi
  8029ad:	53                   	push   %ebx
  8029ae:	83 ec 0c             	sub    $0xc,%esp
  8029b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029b7:	b8 13 00 00 00       	mov    $0x13,%eax
  8029bc:	bf 00 00 00 00       	mov    $0x0,%edi
  8029c1:	89 fb                	mov    %edi,%ebx
  8029c3:	89 fe                	mov    %edi,%esi
  8029c5:	cd 30                	int    $0x30
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	7e 17                	jle    8029e2 <sys_env_set_priority+0x3a>
  8029cb:	83 ec 0c             	sub    $0xc,%esp
  8029ce:	50                   	push   %eax
  8029cf:	6a 13                	push   $0x13
  8029d1:	68 d0 48 80 00       	push   $0x8048d0
  8029d6:	6a 23                	push   $0x23
  8029d8:	68 ed 48 80 00       	push   $0x8048ed
  8029dd:	e8 ea f1 ff ff       	call   801bcc <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  8029e2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8029e5:	5b                   	pop    %ebx
  8029e6:	5e                   	pop    %esi
  8029e7:	5f                   	pop    %edi
  8029e8:	c9                   	leave  
  8029e9:	c3                   	ret    
	...

008029ec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8029ec:	55                   	push   %ebp
  8029ed:	89 e5                	mov    %esp,%ebp
  8029ef:	56                   	push   %esi
  8029f0:	53                   	push   %ebx
  8029f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8029f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f7:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  8029fa:	85 c0                	test   %eax,%eax
  8029fc:	75 12                	jne    802a10 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  8029fe:	83 ec 0c             	sub    $0xc,%esp
  802a01:	68 00 00 c0 ee       	push   $0xeec00000
  802a06:	e8 37 fe ff ff       	call   802842 <sys_ipc_recv>
  802a0b:	83 c4 10             	add    $0x10,%esp
  802a0e:	eb 0c                	jmp    802a1c <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802a10:	83 ec 0c             	sub    $0xc,%esp
  802a13:	50                   	push   %eax
  802a14:	e8 29 fe ff ff       	call   802842 <sys_ipc_recv>
  802a19:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802a1c:	89 c2                	mov    %eax,%edx
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	78 24                	js     802a46 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  802a22:	85 db                	test   %ebx,%ebx
  802a24:	74 0a                	je     802a30 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  802a26:	a1 a8 c0 80 00       	mov    0x80c0a8,%eax
  802a2b:	8b 40 74             	mov    0x74(%eax),%eax
  802a2e:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802a30:	85 f6                	test   %esi,%esi
  802a32:	74 0a                	je     802a3e <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802a34:	a1 a8 c0 80 00       	mov    0x80c0a8,%eax
  802a39:	8b 40 78             	mov    0x78(%eax),%eax
  802a3c:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  802a3e:	a1 a8 c0 80 00       	mov    0x80c0a8,%eax
  802a43:	8b 50 70             	mov    0x70(%eax),%edx

}
  802a46:	89 d0                	mov    %edx,%eax
  802a48:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802a4b:	5b                   	pop    %ebx
  802a4c:	5e                   	pop    %esi
  802a4d:	c9                   	leave  
  802a4e:	c3                   	ret    

00802a4f <ipc_send>:

// Send 'val' (and 'pg' with 'perm', if 'pg' is nonnull) to 'toenv'.
// This function keeps trying until it succeeds.
// It should panic() on any error other than -E_IPC_NOT_RECV.
//
// Hint:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a4f:	55                   	push   %ebp
  802a50:	89 e5                	mov    %esp,%ebp
  802a52:	57                   	push   %edi
  802a53:	56                   	push   %esi
  802a54:	53                   	push   %ebx
  802a55:	83 ec 0c             	sub    $0xc,%esp
  802a58:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a5e:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802a61:	85 db                	test   %ebx,%ebx
  802a63:	75 0a                	jne    802a6f <ipc_send+0x20>
    pg = (void *) UTOP;
  802a65:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  802a6a:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  802a6f:	56                   	push   %esi
  802a70:	53                   	push   %ebx
  802a71:	57                   	push   %edi
  802a72:	ff 75 08             	pushl  0x8(%ebp)
  802a75:	e8 a5 fd ff ff       	call   80281f <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  802a7a:	83 c4 10             	add    $0x10,%esp
  802a7d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a80:	75 07                	jne    802a89 <ipc_send+0x3a>
      sys_yield();
  802a82:	e8 ec fb ff ff       	call   802673 <sys_yield>
  802a87:	eb e6                	jmp    802a6f <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  802a89:	85 c0                	test   %eax,%eax
  802a8b:	79 12                	jns    802a9f <ipc_send+0x50>
  802a8d:	50                   	push   %eax
  802a8e:	68 fb 48 80 00       	push   $0x8048fb
  802a93:	6a 49                	push   $0x49
  802a95:	68 18 49 80 00       	push   $0x804918
  802a9a:	e8 2d f1 ff ff       	call   801bcc <_panic>
    else break;
  }
}
  802a9f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802aa2:	5b                   	pop    %ebx
  802aa3:	5e                   	pop    %esi
  802aa4:	5f                   	pop    %edi
  802aa5:	c9                   	leave  
  802aa6:	c3                   	ret    
	...

00802aa8 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  802aa8:	55                   	push   %ebp
  802aa9:	89 e5                	mov    %esp,%ebp
  802aab:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  802aae:	ff 75 08             	pushl  0x8(%ebp)
  802ab1:	e8 0a 00 00 00       	call   802ac0 <fd2num>
  802ab6:	c1 e0 16             	shl    $0x16,%eax
  802ab9:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  802abe:	c9                   	leave  
  802abf:	c3                   	ret    

00802ac0 <fd2num>:

int
fd2num(struct Fd *fd)
{
  802ac0:	55                   	push   %ebp
  802ac1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	05 00 00 40 30       	add    $0x30400000,%eax
  802acb:	c1 e8 0c             	shr    $0xc,%eax
}
  802ace:	c9                   	leave  
  802acf:	c3                   	ret    

00802ad0 <fd_alloc>:

// Finds the smallest i from 0 to MAXFD-1 that doesn't have
// its fd page mapped.
// Sets *fd_store to the corresponding fd page virtual address.
//
// fd_alloc does NOT actually allocate an fd page.
// It is up to the caller to allocate the page somehow.
// This means that if someone calls fd_alloc twice in a row
// without allocating the first page we return, we'll return the same
// page the second time.
//
// Hint: Use INDEX2FD.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802ad0:	55                   	push   %ebp
  802ad1:	89 e5                	mov    %esp,%ebp
  802ad3:	57                   	push   %edi
  802ad4:	56                   	push   %esi
  802ad5:	53                   	push   %ebx
  802ad6:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802ad9:	b9 00 00 00 00       	mov    $0x0,%ecx
  802ade:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  802ae3:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  802ae8:	89 c8                	mov    %ecx,%eax
  802aea:	c1 e0 0c             	shl    $0xc,%eax
  802aed:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  802af3:	89 d0                	mov    %edx,%eax
  802af5:	c1 e8 16             	shr    $0x16,%eax
  802af8:	8b 04 86             	mov    (%esi,%eax,4),%eax
  802afb:	a8 01                	test   $0x1,%al
  802afd:	74 0c                	je     802b0b <fd_alloc+0x3b>
  802aff:	89 d0                	mov    %edx,%eax
  802b01:	c1 e8 0c             	shr    $0xc,%eax
  802b04:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  802b07:	a8 01                	test   $0x1,%al
  802b09:	75 09                	jne    802b14 <fd_alloc+0x44>
			*fd_store = fd;
  802b0b:	89 17                	mov    %edx,(%edi)
			return 0;
  802b0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b12:	eb 11                	jmp    802b25 <fd_alloc+0x55>
  802b14:	41                   	inc    %ecx
  802b15:	83 f9 1f             	cmp    $0x1f,%ecx
  802b18:	7e ce                	jle    802ae8 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  802b1a:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  802b20:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  802b25:	5b                   	pop    %ebx
  802b26:	5e                   	pop    %esi
  802b27:	5f                   	pop    %edi
  802b28:	c9                   	leave  
  802b29:	c3                   	ret    

00802b2a <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802b2a:	55                   	push   %ebp
  802b2b:	89 e5                	mov    %esp,%ebp
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  802b30:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  802b35:	83 f8 1f             	cmp    $0x1f,%eax
  802b38:	77 3a                	ja     802b74 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  802b3a:	c1 e0 0c             	shl    $0xc,%eax
  802b3d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  802b43:	89 d0                	mov    %edx,%eax
  802b45:	c1 e8 16             	shr    $0x16,%eax
  802b48:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  802b4f:	a8 01                	test   $0x1,%al
  802b51:	74 10                	je     802b63 <fd_lookup+0x39>
  802b53:	89 d0                	mov    %edx,%eax
  802b55:	c1 e8 0c             	shr    $0xc,%eax
  802b58:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  802b5f:	a8 01                	test   $0x1,%al
  802b61:	75 07                	jne    802b6a <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  802b63:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  802b68:	eb 0a                	jmp    802b74 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  802b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b6d:	89 10                	mov    %edx,(%eax)
	return 0;
  802b6f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  802b74:	89 d0                	mov    %edx,%eax
  802b76:	c9                   	leave  
  802b77:	c3                   	ret    

00802b78 <fd_close>:

// Frees file descriptor 'fd' by closing the corresponding file
// and unmapping the file descriptor page.
// If 'must_exist' is 0, then fd can be a closed or nonexistent file
// descriptor; the function will return 0 and have no other effect.
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802b78:	55                   	push   %ebp
  802b79:	89 e5                	mov    %esp,%ebp
  802b7b:	56                   	push   %esi
  802b7c:	53                   	push   %ebx
  802b7d:	83 ec 10             	sub    $0x10,%esp
  802b80:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802b83:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802b86:	50                   	push   %eax
  802b87:	56                   	push   %esi
  802b88:	e8 33 ff ff ff       	call   802ac0 <fd2num>
  802b8d:	89 04 24             	mov    %eax,(%esp)
  802b90:	e8 95 ff ff ff       	call   802b2a <fd_lookup>
  802b95:	89 c3                	mov    %eax,%ebx
  802b97:	83 c4 08             	add    $0x8,%esp
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	78 05                	js     802ba3 <fd_close+0x2b>
  802b9e:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802ba1:	74 0f                	je     802bb2 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  802ba3:	89 d8                	mov    %ebx,%eax
  802ba5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ba9:	75 3a                	jne    802be5 <fd_close+0x6d>
  802bab:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb0:	eb 33                	jmp    802be5 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  802bb2:	83 ec 08             	sub    $0x8,%esp
  802bb5:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  802bb8:	50                   	push   %eax
  802bb9:	ff 36                	pushl  (%esi)
  802bbb:	e8 2c 00 00 00       	call   802bec <dev_lookup>
  802bc0:	89 c3                	mov    %eax,%ebx
  802bc2:	83 c4 10             	add    $0x10,%esp
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	78 0f                	js     802bd8 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  802bc9:	83 ec 0c             	sub    $0xc,%esp
  802bcc:	56                   	push   %esi
  802bcd:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802bd0:	ff 50 10             	call   *0x10(%eax)
  802bd3:	89 c3                	mov    %eax,%ebx
  802bd5:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802bd8:	83 ec 08             	sub    $0x8,%esp
  802bdb:	56                   	push   %esi
  802bdc:	6a 00                	push   $0x0
  802bde:	e8 34 fb ff ff       	call   802717 <sys_page_unmap>
	return r;
  802be3:	89 d8                	mov    %ebx,%eax
}
  802be5:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802be8:	5b                   	pop    %ebx
  802be9:	5e                   	pop    %esi
  802bea:	c9                   	leave  
  802beb:	c3                   	ret    

00802bec <dev_lookup>:


/******************
 * FILE FUNCTIONS *
 *                *
 ******************/

static struct Dev *devtab[] =
{
	&devfile,
	&devpipe,
	&devcons,
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802bec:	55                   	push   %ebp
  802bed:	89 e5                	mov    %esp,%ebp
  802bef:	56                   	push   %esi
  802bf0:	53                   	push   %ebx
  802bf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802bf4:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  802bf7:	ba 00 00 00 00       	mov    $0x0,%edx
  802bfc:	83 3d 28 c0 80 00 00 	cmpl   $0x0,0x80c028
  802c03:	74 1c                	je     802c21 <dev_lookup+0x35>
  802c05:	b9 28 c0 80 00       	mov    $0x80c028,%ecx
		if (devtab[i]->dev_id == dev_id) {
  802c0a:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  802c0d:	39 18                	cmp    %ebx,(%eax)
  802c0f:	75 09                	jne    802c1a <dev_lookup+0x2e>
			*dev = devtab[i];
  802c11:	89 06                	mov    %eax,(%esi)
			return 0;
  802c13:	b8 00 00 00 00       	mov    $0x0,%eax
  802c18:	eb 29                	jmp    802c43 <dev_lookup+0x57>
  802c1a:	42                   	inc    %edx
  802c1b:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  802c1f:	75 e9                	jne    802c0a <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  802c21:	83 ec 04             	sub    $0x4,%esp
  802c24:	53                   	push   %ebx
  802c25:	a1 a8 c0 80 00       	mov    0x80c0a8,%eax
  802c2a:	8b 40 4c             	mov    0x4c(%eax),%eax
  802c2d:	50                   	push   %eax
  802c2e:	68 24 49 80 00       	push   $0x804924
  802c33:	e8 84 f0 ff ff       	call   801cbc <cprintf>
	*dev = 0;
  802c38:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  802c3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802c43:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802c46:	5b                   	pop    %ebx
  802c47:	5e                   	pop    %esi
  802c48:	c9                   	leave  
  802c49:	c3                   	ret    

00802c4a <close>:

int
close(int fdnum)
{
  802c4a:	55                   	push   %ebp
  802c4b:	89 e5                	mov    %esp,%ebp
  802c4d:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c50:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802c53:	50                   	push   %eax
  802c54:	ff 75 08             	pushl  0x8(%ebp)
  802c57:	e8 ce fe ff ff       	call   802b2a <fd_lookup>
  802c5c:	83 c4 08             	add    $0x8,%esp
		return r;
  802c5f:	89 c2                	mov    %eax,%edx
  802c61:	85 c0                	test   %eax,%eax
  802c63:	78 0f                	js     802c74 <close+0x2a>
	else
		return fd_close(fd, 1);
  802c65:	83 ec 08             	sub    $0x8,%esp
  802c68:	6a 01                	push   $0x1
  802c6a:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802c6d:	e8 06 ff ff ff       	call   802b78 <fd_close>
  802c72:	89 c2                	mov    %eax,%edx
}
  802c74:	89 d0                	mov    %edx,%eax
  802c76:	c9                   	leave  
  802c77:	c3                   	ret    

00802c78 <close_all>:

void
close_all(void)
{
  802c78:	55                   	push   %ebp
  802c79:	89 e5                	mov    %esp,%ebp
  802c7b:	53                   	push   %ebx
  802c7c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802c7f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802c84:	83 ec 0c             	sub    $0xc,%esp
  802c87:	53                   	push   %ebx
  802c88:	e8 bd ff ff ff       	call   802c4a <close>
  802c8d:	83 c4 10             	add    $0x10,%esp
  802c90:	43                   	inc    %ebx
  802c91:	83 fb 1f             	cmp    $0x1f,%ebx
  802c94:	7e ee                	jle    802c84 <close_all+0xc>
}
  802c96:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802c99:	c9                   	leave  
  802c9a:	c3                   	ret    

00802c9b <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802c9b:	55                   	push   %ebp
  802c9c:	89 e5                	mov    %esp,%ebp
  802c9e:	57                   	push   %edi
  802c9f:	56                   	push   %esi
  802ca0:	53                   	push   %ebx
  802ca1:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802ca4:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  802ca7:	50                   	push   %eax
  802ca8:	ff 75 08             	pushl  0x8(%ebp)
  802cab:	e8 7a fe ff ff       	call   802b2a <fd_lookup>
  802cb0:	89 c6                	mov    %eax,%esi
  802cb2:	83 c4 08             	add    $0x8,%esp
  802cb5:	85 f6                	test   %esi,%esi
  802cb7:	0f 88 f8 00 00 00    	js     802db5 <dup+0x11a>
		return r;
	close(newfdnum);
  802cbd:	83 ec 0c             	sub    $0xc,%esp
  802cc0:	ff 75 0c             	pushl  0xc(%ebp)
  802cc3:	e8 82 ff ff ff       	call   802c4a <close>

	newfd = INDEX2FD(newfdnum);
  802cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ccb:	c1 e0 0c             	shl    $0xc,%eax
  802cce:	2d 00 00 40 30       	sub    $0x30400000,%eax
  802cd3:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  802cd6:	83 c4 04             	add    $0x4,%esp
  802cd9:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802cdc:	e8 c7 fd ff ff       	call   802aa8 <fd2data>
  802ce1:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  802ce3:	83 c4 04             	add    $0x4,%esp
  802ce6:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  802ce9:	e8 ba fd ff ff       	call   802aa8 <fd2data>
  802cee:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  802cf1:	89 f8                	mov    %edi,%eax
  802cf3:	c1 e8 16             	shr    $0x16,%eax
  802cf6:	83 c4 10             	add    $0x10,%esp
  802cf9:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 48                	je     802d4c <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  802d04:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  802d09:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  802d0c:	89 d0                	mov    %edx,%eax
  802d0e:	c1 e8 0c             	shr    $0xc,%eax
  802d11:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  802d18:	a8 01                	test   $0x1,%al
  802d1a:	74 22                	je     802d3e <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  802d1c:	83 ec 0c             	sub    $0xc,%esp
  802d1f:	25 07 0e 00 00       	and    $0xe07,%eax
  802d24:	50                   	push   %eax
  802d25:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802d28:	01 d8                	add    %ebx,%eax
  802d2a:	50                   	push   %eax
  802d2b:	6a 00                	push   $0x0
  802d2d:	52                   	push   %edx
  802d2e:	6a 00                	push   $0x0
  802d30:	e8 a0 f9 ff ff       	call   8026d5 <sys_page_map>
  802d35:	89 c6                	mov    %eax,%esi
  802d37:	83 c4 20             	add    $0x20,%esp
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	78 3f                	js     802d7d <dup+0xe2>
  802d3e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802d44:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  802d4a:	7e bd                	jle    802d09 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  802d4c:	83 ec 0c             	sub    $0xc,%esp
  802d4f:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802d52:	89 d0                	mov    %edx,%eax
  802d54:	c1 e8 0c             	shr    $0xc,%eax
  802d57:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  802d5e:	25 07 0e 00 00       	and    $0xe07,%eax
  802d63:	50                   	push   %eax
  802d64:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  802d67:	6a 00                	push   $0x0
  802d69:	52                   	push   %edx
  802d6a:	6a 00                	push   $0x0
  802d6c:	e8 64 f9 ff ff       	call   8026d5 <sys_page_map>
  802d71:	89 c6                	mov    %eax,%esi
  802d73:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  802d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d79:	85 f6                	test   %esi,%esi
  802d7b:	79 38                	jns    802db5 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  802d7d:	83 ec 08             	sub    $0x8,%esp
  802d80:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  802d83:	6a 00                	push   $0x0
  802d85:	e8 8d f9 ff ff       	call   802717 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  802d8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d8f:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  802d92:	83 ec 08             	sub    $0x8,%esp
  802d95:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802d98:	01 d8                	add    %ebx,%eax
  802d9a:	50                   	push   %eax
  802d9b:	6a 00                	push   $0x0
  802d9d:	e8 75 f9 ff ff       	call   802717 <sys_page_unmap>
  802da2:	83 c4 10             	add    $0x10,%esp
  802da5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802dab:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  802db1:	7e df                	jle    802d92 <dup+0xf7>
	return r;
  802db3:	89 f0                	mov    %esi,%eax
}
  802db5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802db8:	5b                   	pop    %ebx
  802db9:	5e                   	pop    %esi
  802dba:	5f                   	pop    %edi
  802dbb:	c9                   	leave  
  802dbc:	c3                   	ret    

00802dbd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802dbd:	55                   	push   %ebp
  802dbe:	89 e5                	mov    %esp,%ebp
  802dc0:	53                   	push   %ebx
  802dc1:	83 ec 14             	sub    $0x14,%esp
  802dc4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802dc7:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  802dca:	50                   	push   %eax
  802dcb:	53                   	push   %ebx
  802dcc:	e8 59 fd ff ff       	call   802b2a <fd_lookup>
  802dd1:	89 c2                	mov    %eax,%edx
  802dd3:	83 c4 08             	add    $0x8,%esp
  802dd6:	85 c0                	test   %eax,%eax
  802dd8:	78 1a                	js     802df4 <read+0x37>
  802dda:	83 ec 08             	sub    $0x8,%esp
  802ddd:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802de0:	50                   	push   %eax
  802de1:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802de4:	ff 30                	pushl  (%eax)
  802de6:	e8 01 fe ff ff       	call   802bec <dev_lookup>
  802deb:	89 c2                	mov    %eax,%edx
  802ded:	83 c4 10             	add    $0x10,%esp
  802df0:	85 c0                	test   %eax,%eax
  802df2:	79 04                	jns    802df8 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  802df4:	89 d0                	mov    %edx,%eax
  802df6:	eb 50                	jmp    802e48 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802df8:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802dfb:	8b 40 08             	mov    0x8(%eax),%eax
  802dfe:	83 e0 03             	and    $0x3,%eax
  802e01:	83 f8 01             	cmp    $0x1,%eax
  802e04:	75 1e                	jne    802e24 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  802e06:	83 ec 04             	sub    $0x4,%esp
  802e09:	53                   	push   %ebx
  802e0a:	a1 a8 c0 80 00       	mov    0x80c0a8,%eax
  802e0f:	8b 40 4c             	mov    0x4c(%eax),%eax
  802e12:	50                   	push   %eax
  802e13:	68 65 49 80 00       	push   $0x804965
  802e18:	e8 9f ee ff ff       	call   801cbc <cprintf>
		return -E_INVAL;
  802e1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802e22:	eb 24                	jmp    802e48 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  802e24:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802e27:	ff 70 04             	pushl  0x4(%eax)
  802e2a:	ff 75 10             	pushl  0x10(%ebp)
  802e2d:	ff 75 0c             	pushl  0xc(%ebp)
  802e30:	50                   	push   %eax
  802e31:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  802e34:	ff 50 08             	call   *0x8(%eax)
  802e37:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  802e39:	83 c4 10             	add    $0x10,%esp
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	78 06                	js     802e46 <read+0x89>
		fd->fd_offset += r;
  802e40:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802e43:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  802e46:	89 d0                	mov    %edx,%eax
}
  802e48:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802e4b:	c9                   	leave  
  802e4c:	c3                   	ret    

00802e4d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802e4d:	55                   	push   %ebp
  802e4e:	89 e5                	mov    %esp,%ebp
  802e50:	57                   	push   %edi
  802e51:	56                   	push   %esi
  802e52:	53                   	push   %ebx
  802e53:	83 ec 0c             	sub    $0xc,%esp
  802e56:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802e59:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802e5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e61:	39 f3                	cmp    %esi,%ebx
  802e63:	73 25                	jae    802e8a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	89 f0                	mov    %esi,%eax
  802e6a:	29 d8                	sub    %ebx,%eax
  802e6c:	50                   	push   %eax
  802e6d:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  802e70:	50                   	push   %eax
  802e71:	ff 75 08             	pushl  0x8(%ebp)
  802e74:	e8 44 ff ff ff       	call   802dbd <read>
		if (m < 0)
  802e79:	83 c4 10             	add    $0x10,%esp
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	78 0c                	js     802e8c <readn+0x3f>
			return m;
		if (m == 0)
  802e80:	85 c0                	test   %eax,%eax
  802e82:	74 06                	je     802e8a <readn+0x3d>
  802e84:	01 c3                	add    %eax,%ebx
  802e86:	39 f3                	cmp    %esi,%ebx
  802e88:	72 db                	jb     802e65 <readn+0x18>
			break;
	}
	return tot;
  802e8a:	89 d8                	mov    %ebx,%eax
}
  802e8c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802e8f:	5b                   	pop    %ebx
  802e90:	5e                   	pop    %esi
  802e91:	5f                   	pop    %edi
  802e92:	c9                   	leave  
  802e93:	c3                   	ret    

00802e94 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802e94:	55                   	push   %ebp
  802e95:	89 e5                	mov    %esp,%ebp
  802e97:	53                   	push   %ebx
  802e98:	83 ec 14             	sub    $0x14,%esp
  802e9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802e9e:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  802ea1:	50                   	push   %eax
  802ea2:	53                   	push   %ebx
  802ea3:	e8 82 fc ff ff       	call   802b2a <fd_lookup>
  802ea8:	89 c2                	mov    %eax,%edx
  802eaa:	83 c4 08             	add    $0x8,%esp
  802ead:	85 c0                	test   %eax,%eax
  802eaf:	78 1a                	js     802ecb <write+0x37>
  802eb1:	83 ec 08             	sub    $0x8,%esp
  802eb4:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802eb7:	50                   	push   %eax
  802eb8:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802ebb:	ff 30                	pushl  (%eax)
  802ebd:	e8 2a fd ff ff       	call   802bec <dev_lookup>
  802ec2:	89 c2                	mov    %eax,%edx
  802ec4:	83 c4 10             	add    $0x10,%esp
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	79 04                	jns    802ecf <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  802ecb:	89 d0                	mov    %edx,%eax
  802ecd:	eb 4b                	jmp    802f1a <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802ecf:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802ed2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802ed6:	75 1e                	jne    802ef6 <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  802ed8:	83 ec 04             	sub    $0x4,%esp
  802edb:	53                   	push   %ebx
  802edc:	a1 a8 c0 80 00       	mov    0x80c0a8,%eax
  802ee1:	8b 40 4c             	mov    0x4c(%eax),%eax
  802ee4:	50                   	push   %eax
  802ee5:	68 81 49 80 00       	push   $0x804981
  802eea:	e8 cd ed ff ff       	call   801cbc <cprintf>
		return -E_INVAL;
  802eef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ef4:	eb 24                	jmp    802f1a <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  802ef6:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802ef9:	ff 70 04             	pushl  0x4(%eax)
  802efc:	ff 75 10             	pushl  0x10(%ebp)
  802eff:	ff 75 0c             	pushl  0xc(%ebp)
  802f02:	50                   	push   %eax
  802f03:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  802f06:	ff 50 0c             	call   *0xc(%eax)
  802f09:	89 c2                	mov    %eax,%edx
	if (r > 0)
  802f0b:	83 c4 10             	add    $0x10,%esp
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	7e 06                	jle    802f18 <write+0x84>
		fd->fd_offset += r;
  802f12:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802f15:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  802f18:	89 d0                	mov    %edx,%eax
}
  802f1a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802f1d:	c9                   	leave  
  802f1e:	c3                   	ret    

00802f1f <seek>:

int
seek(int fdnum, off_t offset)
{
  802f1f:	55                   	push   %ebp
  802f20:	89 e5                	mov    %esp,%ebp
  802f22:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f25:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802f28:	50                   	push   %eax
  802f29:	ff 75 08             	pushl  0x8(%ebp)
  802f2c:	e8 f9 fb ff ff       	call   802b2a <fd_lookup>
  802f31:	83 c4 08             	add    $0x8,%esp
		return r;
  802f34:	89 c2                	mov    %eax,%edx
  802f36:	85 c0                	test   %eax,%eax
  802f38:	78 0e                	js     802f48 <seek+0x29>
	fd->fd_offset = offset;
  802f3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f3d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802f40:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802f43:	ba 00 00 00 00       	mov    $0x0,%edx
}
  802f48:	89 d0                	mov    %edx,%eax
  802f4a:	c9                   	leave  
  802f4b:	c3                   	ret    

00802f4c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802f4c:	55                   	push   %ebp
  802f4d:	89 e5                	mov    %esp,%ebp
  802f4f:	53                   	push   %ebx
  802f50:	83 ec 14             	sub    $0x14,%esp
  802f53:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802f56:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  802f59:	50                   	push   %eax
  802f5a:	53                   	push   %ebx
  802f5b:	e8 ca fb ff ff       	call   802b2a <fd_lookup>
  802f60:	83 c4 08             	add    $0x8,%esp
  802f63:	85 c0                	test   %eax,%eax
  802f65:	78 4e                	js     802fb5 <ftruncate+0x69>
  802f67:	83 ec 08             	sub    $0x8,%esp
  802f6a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802f6d:	50                   	push   %eax
  802f6e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802f71:	ff 30                	pushl  (%eax)
  802f73:	e8 74 fc ff ff       	call   802bec <dev_lookup>
  802f78:	83 c4 10             	add    $0x10,%esp
  802f7b:	85 c0                	test   %eax,%eax
  802f7d:	78 36                	js     802fb5 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802f7f:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802f82:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802f86:	75 1e                	jne    802fa6 <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802f88:	83 ec 04             	sub    $0x4,%esp
  802f8b:	53                   	push   %ebx
  802f8c:	a1 a8 c0 80 00       	mov    0x80c0a8,%eax
  802f91:	8b 40 4c             	mov    0x4c(%eax),%eax
  802f94:	50                   	push   %eax
  802f95:	68 44 49 80 00       	push   $0x804944
  802f9a:	e8 1d ed ff ff       	call   801cbc <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  802f9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802fa4:	eb 0f                	jmp    802fb5 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  802fa6:	83 ec 08             	sub    $0x8,%esp
  802fa9:	ff 75 0c             	pushl  0xc(%ebp)
  802fac:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  802faf:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  802fb2:	ff 50 1c             	call   *0x1c(%eax)
}
  802fb5:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
  802fbd:	53                   	push   %ebx
  802fbe:	83 ec 14             	sub    $0x14,%esp
  802fc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802fc4:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  802fc7:	50                   	push   %eax
  802fc8:	ff 75 08             	pushl  0x8(%ebp)
  802fcb:	e8 5a fb ff ff       	call   802b2a <fd_lookup>
  802fd0:	83 c4 08             	add    $0x8,%esp
  802fd3:	85 c0                	test   %eax,%eax
  802fd5:	78 42                	js     803019 <fstat+0x5f>
  802fd7:	83 ec 08             	sub    $0x8,%esp
  802fda:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802fdd:	50                   	push   %eax
  802fde:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  802fe1:	ff 30                	pushl  (%eax)
  802fe3:	e8 04 fc ff ff       	call   802bec <dev_lookup>
  802fe8:	83 c4 10             	add    $0x10,%esp
  802feb:	85 c0                	test   %eax,%eax
  802fed:	78 2a                	js     803019 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  802fef:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802ff2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802ff9:	00 00 00 
	stat->st_isdir = 0;
  802ffc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803003:	00 00 00 
	stat->st_dev = dev;
  803006:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  803009:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80300f:	83 ec 08             	sub    $0x8,%esp
  803012:	53                   	push   %ebx
  803013:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  803016:	ff 50 14             	call   *0x14(%eax)
}
  803019:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80301c:	c9                   	leave  
  80301d:	c3                   	ret    

0080301e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80301e:	55                   	push   %ebp
  80301f:	89 e5                	mov    %esp,%ebp
  803021:	56                   	push   %esi
  803022:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  803023:	83 ec 08             	sub    $0x8,%esp
  803026:	6a 00                	push   $0x0
  803028:	ff 75 08             	pushl  0x8(%ebp)
  80302b:	e8 28 00 00 00       	call   803058 <open>
  803030:	89 c6                	mov    %eax,%esi
  803032:	83 c4 10             	add    $0x10,%esp
  803035:	85 f6                	test   %esi,%esi
  803037:	78 18                	js     803051 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  803039:	83 ec 08             	sub    $0x8,%esp
  80303c:	ff 75 0c             	pushl  0xc(%ebp)
  80303f:	56                   	push   %esi
  803040:	e8 75 ff ff ff       	call   802fba <fstat>
  803045:	89 c3                	mov    %eax,%ebx
	close(fd);
  803047:	89 34 24             	mov    %esi,(%esp)
  80304a:	e8 fb fb ff ff       	call   802c4a <close>
	return r;
  80304f:	89 d8                	mov    %ebx,%eax
}
  803051:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  803054:	5b                   	pop    %ebx
  803055:	5e                   	pop    %esi
  803056:	c9                   	leave  
  803057:	c3                   	ret    

00803058 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  803058:	55                   	push   %ebp
  803059:	89 e5                	mov    %esp,%ebp
  80305b:	53                   	push   %ebx
  80305c:	83 ec 10             	sub    $0x10,%esp
	// Find an unused file descriptor page using fd_alloc.
	// Then send a message to the file server to open a file
	// using a function in fsipc.c.
	// (fd_alloc does not allocate a page, it just returns an
	// unused fd address.  Do you need to allocate a page?  Look
	// at fsipc.c if you aren't sure.)
	// Then map the file data (you may find fmap() helpful).
	// Return the file descriptor index.
	// If any step fails, use fd_close to free the file descriptor.

	// LAB 5: Your code here.
	// panic("open() unimplemented!");
        int r;
        struct Fd *fd_store;
        if ((r = fd_alloc(&fd_store)) < 0) {
  80305f:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  803062:	50                   	push   %eax
  803063:	e8 68 fa ff ff       	call   802ad0 <fd_alloc>
  803068:	89 c3                	mov    %eax,%ebx
  80306a:	83 c4 10             	add    $0x10,%esp
  80306d:	85 db                	test   %ebx,%ebx
  80306f:	78 36                	js     8030a7 <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  803071:	83 ec 04             	sub    $0x4,%esp
  803074:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  803077:	ff 75 0c             	pushl  0xc(%ebp)
  80307a:	ff 75 08             	pushl  0x8(%ebp)
  80307d:	e8 1b 05 00 00       	call   80359d <fsipc_open>
  803082:	89 c3                	mov    %eax,%ebx
  803084:	83 c4 10             	add    $0x10,%esp
  803087:	85 c0                	test   %eax,%eax
  803089:	79 11                	jns    80309c <open+0x44>
          fd_close(fd_store, 0);
  80308b:	83 ec 08             	sub    $0x8,%esp
  80308e:	6a 00                	push   $0x0
  803090:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  803093:	e8 e0 fa ff ff       	call   802b78 <fd_close>
          return r;
  803098:	89 d8                	mov    %ebx,%eax
  80309a:	eb 0b                	jmp    8030a7 <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  80309c:	83 ec 0c             	sub    $0xc,%esp
  80309f:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8030a2:	e8 19 fa ff ff       	call   802ac0 <fd2num>
}
  8030a7:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8030aa:	c9                   	leave  
  8030ab:	c3                   	ret    

008030ac <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8030ac:	55                   	push   %ebp
  8030ad:	89 e5                	mov    %esp,%ebp
  8030af:	53                   	push   %ebx
  8030b0:	83 ec 04             	sub    $0x4,%esp
  8030b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  8030b6:	6a 01                	push   $0x1
  8030b8:	6a 00                	push   $0x0
  8030ba:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  8030c0:	53                   	push   %ebx
  8030c1:	e8 e7 03 00 00       	call   8034ad <funmap>
  8030c6:	83 c4 10             	add    $0x10,%esp
          return r;
  8030c9:	89 c2                	mov    %eax,%edx
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	78 19                	js     8030e8 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  8030cf:	83 ec 0c             	sub    $0xc,%esp
  8030d2:	ff 73 0c             	pushl  0xc(%ebx)
  8030d5:	e8 68 05 00 00       	call   803642 <fsipc_close>
  8030da:	83 c4 10             	add    $0x10,%esp
          return r;
  8030dd:	89 c2                	mov    %eax,%edx
  8030df:	85 c0                	test   %eax,%eax
  8030e1:	78 05                	js     8030e8 <file_close+0x3c>
        }
        return 0;
  8030e3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8030e8:	89 d0                	mov    %edx,%eax
  8030ea:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8030ed:	c9                   	leave  
  8030ee:	c3                   	ret    

008030ef <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8030ef:	55                   	push   %ebp
  8030f0:	89 e5                	mov    %esp,%ebp
  8030f2:	57                   	push   %edi
  8030f3:	56                   	push   %esi
  8030f4:	53                   	push   %ebx
  8030f5:	83 ec 0c             	sub    $0xc,%esp
  8030f8:	8b 75 10             	mov    0x10(%ebp),%esi
  8030fb:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  803107:	b9 00 00 00 00       	mov    $0x0,%ecx
  80310c:	39 d7                	cmp    %edx,%edi
  80310e:	0f 87 95 00 00 00    	ja     8031a9 <file_read+0xba>
	if (offset + n > size)
  803114:	8d 04 37             	lea    (%edi,%esi,1),%eax
  803117:	39 d0                	cmp    %edx,%eax
  803119:	76 04                	jbe    80311f <file_read+0x30>
		n = size - offset;
  80311b:	89 d6                	mov    %edx,%esi
  80311d:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  80311f:	83 ec 0c             	sub    $0xc,%esp
  803122:	ff 75 08             	pushl  0x8(%ebp)
  803125:	e8 7e f9 ff ff       	call   802aa8 <fd2data>
  80312a:	89 c3                	mov    %eax,%ebx
  80312c:	01 fb                	add    %edi,%ebx
  80312e:	83 c4 10             	add    $0x10,%esp
  803131:	eb 41                	jmp    803174 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  803133:	89 d8                	mov    %ebx,%eax
  803135:	c1 e8 16             	shr    $0x16,%eax
  803138:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80313f:	a8 01                	test   $0x1,%al
  803141:	74 10                	je     803153 <file_read+0x64>
  803143:	89 d8                	mov    %ebx,%eax
  803145:	c1 e8 0c             	shr    $0xc,%eax
  803148:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80314f:	a8 01                	test   $0x1,%al
  803151:	75 1b                	jne    80316e <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  803153:	83 ec 04             	sub    $0x4,%esp
  803156:	8d 04 37             	lea    (%edi,%esi,1),%eax
  803159:	50                   	push   %eax
  80315a:	57                   	push   %edi
  80315b:	ff 75 08             	pushl  0x8(%ebp)
  80315e:	e8 d4 02 00 00       	call   803437 <fmap>
  803163:	83 c4 10             	add    $0x10,%esp
              return r;
  803166:	89 c1                	mov    %eax,%ecx
  803168:	85 c0                	test   %eax,%eax
  80316a:	78 3d                	js     8031a9 <file_read+0xba>
  80316c:	eb 1c                	jmp    80318a <file_read+0x9b>
  80316e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  803174:	83 ec 0c             	sub    $0xc,%esp
  803177:	ff 75 08             	pushl  0x8(%ebp)
  80317a:	e8 29 f9 ff ff       	call   802aa8 <fd2data>
  80317f:	01 f8                	add    %edi,%eax
  803181:	01 f0                	add    %esi,%eax
  803183:	83 c4 10             	add    $0x10,%esp
  803186:	39 d8                	cmp    %ebx,%eax
  803188:	77 a9                	ja     803133 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  80318a:	83 ec 04             	sub    $0x4,%esp
  80318d:	56                   	push   %esi
  80318e:	83 ec 04             	sub    $0x4,%esp
  803191:	ff 75 08             	pushl  0x8(%ebp)
  803194:	e8 0f f9 ff ff       	call   802aa8 <fd2data>
  803199:	83 c4 08             	add    $0x8,%esp
  80319c:	01 f8                	add    %edi,%eax
  80319e:	50                   	push   %eax
  80319f:	ff 75 0c             	pushl  0xc(%ebp)
  8031a2:	e8 95 f2 ff ff       	call   80243c <memmove>
	return n;
  8031a7:	89 f1                	mov    %esi,%ecx
}
  8031a9:	89 c8                	mov    %ecx,%eax
  8031ab:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8031ae:	5b                   	pop    %ebx
  8031af:	5e                   	pop    %esi
  8031b0:	5f                   	pop    %edi
  8031b1:	c9                   	leave  
  8031b2:	c3                   	ret    

008031b3 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  8031b3:	55                   	push   %ebp
  8031b4:	89 e5                	mov    %esp,%ebp
  8031b6:	56                   	push   %esi
  8031b7:	53                   	push   %ebx
  8031b8:	83 ec 18             	sub    $0x18,%esp
  8031bb:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8031be:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8031c1:	50                   	push   %eax
  8031c2:	ff 75 08             	pushl  0x8(%ebp)
  8031c5:	e8 60 f9 ff ff       	call   802b2a <fd_lookup>
  8031ca:	83 c4 10             	add    $0x10,%esp
		return r;
  8031cd:	89 c2                	mov    %eax,%edx
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	0f 88 9f 00 00 00    	js     803276 <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  8031d7:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8031da:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  8031dc:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8031e1:	3b 05 40 c0 80 00    	cmp    0x80c040,%eax
  8031e7:	0f 85 89 00 00 00    	jne    803276 <read_map+0xc3>
	va = fd2data(fd) + offset;
  8031ed:	83 ec 0c             	sub    $0xc,%esp
  8031f0:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8031f3:	e8 b0 f8 ff ff       	call   802aa8 <fd2data>
  8031f8:	89 c3                	mov    %eax,%ebx
  8031fa:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  8031fc:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  8031ff:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  803204:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  80320a:	7f 6a                	jg     803276 <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  80320c:	89 d8                	mov    %ebx,%eax
  80320e:	c1 e8 16             	shr    $0x16,%eax
  803211:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  803218:	a8 01                	test   $0x1,%al
  80321a:	74 10                	je     80322c <read_map+0x79>
  80321c:	89 d8                	mov    %ebx,%eax
  80321e:	c1 e8 0c             	shr    $0xc,%eax
  803221:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  803228:	a8 01                	test   $0x1,%al
  80322a:	75 19                	jne    803245 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  80322c:	83 ec 04             	sub    $0x4,%esp
  80322f:	8d 46 01             	lea    0x1(%esi),%eax
  803232:	50                   	push   %eax
  803233:	56                   	push   %esi
  803234:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  803237:	e8 fb 01 00 00       	call   803437 <fmap>
  80323c:	83 c4 10             	add    $0x10,%esp
            return r;
  80323f:	89 c2                	mov    %eax,%edx
  803241:	85 c0                	test   %eax,%eax
  803243:	78 31                	js     803276 <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  803245:	89 d8                	mov    %ebx,%eax
  803247:	c1 e8 16             	shr    $0x16,%eax
  80324a:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  803251:	a8 01                	test   $0x1,%al
  803253:	74 10                	je     803265 <read_map+0xb2>
  803255:	89 d8                	mov    %ebx,%eax
  803257:	c1 e8 0c             	shr    $0xc,%eax
  80325a:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  803261:	a8 01                	test   $0x1,%al
  803263:	75 07                	jne    80326c <read_map+0xb9>
		return -E_NO_DISK;
  803265:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  80326a:	eb 0a                	jmp    803276 <read_map+0xc3>

	*blk = (void*) va;
  80326c:	8b 45 10             	mov    0x10(%ebp),%eax
  80326f:	89 18                	mov    %ebx,(%eax)
	return 0;
  803271:	ba 00 00 00 00       	mov    $0x0,%edx
}
  803276:	89 d0                	mov    %edx,%eax
  803278:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80327b:	5b                   	pop    %ebx
  80327c:	5e                   	pop    %esi
  80327d:	c9                   	leave  
  80327e:	c3                   	ret    

0080327f <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  80327f:	55                   	push   %ebp
  803280:	89 e5                	mov    %esp,%ebp
  803282:	57                   	push   %edi
  803283:	56                   	push   %esi
  803284:	53                   	push   %ebx
  803285:	83 ec 0c             	sub    $0xc,%esp
  803288:	8b 75 08             	mov    0x8(%ebp),%esi
  80328b:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  80328e:	8b 45 10             	mov    0x10(%ebp),%eax
  803291:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  803294:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  803299:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  80329f:	0f 87 bd 00 00 00    	ja     803362 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  8032a5:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  8032ab:	73 17                	jae    8032c4 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  8032ad:	83 ec 08             	sub    $0x8,%esp
  8032b0:	52                   	push   %edx
  8032b1:	56                   	push   %esi
  8032b2:	e8 fb 00 00 00       	call   8033b2 <file_trunc>
  8032b7:	83 c4 10             	add    $0x10,%esp
			return r;
  8032ba:	89 c1                	mov    %eax,%ecx
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	0f 88 9e 00 00 00    	js     803362 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8032c4:	83 ec 0c             	sub    $0xc,%esp
  8032c7:	56                   	push   %esi
  8032c8:	e8 db f7 ff ff       	call   802aa8 <fd2data>
  8032cd:	89 c3                	mov    %eax,%ebx
  8032cf:	01 fb                	add    %edi,%ebx
  8032d1:	83 c4 10             	add    $0x10,%esp
  8032d4:	eb 42                	jmp    803318 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8032d6:	89 d8                	mov    %ebx,%eax
  8032d8:	c1 e8 16             	shr    $0x16,%eax
  8032db:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8032e2:	a8 01                	test   $0x1,%al
  8032e4:	74 10                	je     8032f6 <file_write+0x77>
  8032e6:	89 d8                	mov    %ebx,%eax
  8032e8:	c1 e8 0c             	shr    $0xc,%eax
  8032eb:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8032f2:	a8 01                	test   $0x1,%al
  8032f4:	75 1c                	jne    803312 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8032f6:	83 ec 04             	sub    $0x4,%esp
  8032f9:	8b 55 10             	mov    0x10(%ebp),%edx
  8032fc:	8d 04 17             	lea    (%edi,%edx,1),%eax
  8032ff:	50                   	push   %eax
  803300:	57                   	push   %edi
  803301:	56                   	push   %esi
  803302:	e8 30 01 00 00       	call   803437 <fmap>
  803307:	83 c4 10             	add    $0x10,%esp
              return r;
  80330a:	89 c1                	mov    %eax,%ecx
  80330c:	85 c0                	test   %eax,%eax
  80330e:	78 52                	js     803362 <file_write+0xe3>
  803310:	eb 1b                	jmp    80332d <file_write+0xae>
  803312:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  803318:	83 ec 0c             	sub    $0xc,%esp
  80331b:	56                   	push   %esi
  80331c:	e8 87 f7 ff ff       	call   802aa8 <fd2data>
  803321:	01 f8                	add    %edi,%eax
  803323:	03 45 10             	add    0x10(%ebp),%eax
  803326:	83 c4 10             	add    $0x10,%esp
  803329:	39 d8                	cmp    %ebx,%eax
  80332b:	77 a9                	ja     8032d6 <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  80332d:	83 ec 0c             	sub    $0xc,%esp
  803330:	68 9e 49 80 00       	push   $0x80499e
  803335:	e8 82 e9 ff ff       	call   801cbc <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  80333a:	83 c4 0c             	add    $0xc,%esp
  80333d:	ff 75 10             	pushl  0x10(%ebp)
  803340:	ff 75 0c             	pushl  0xc(%ebp)
  803343:	56                   	push   %esi
  803344:	e8 5f f7 ff ff       	call   802aa8 <fd2data>
  803349:	01 f8                	add    %edi,%eax
  80334b:	89 04 24             	mov    %eax,(%esp)
  80334e:	e8 e9 f0 ff ff       	call   80243c <memmove>
        cprintf("write done\n");
  803353:	c7 04 24 ab 49 80 00 	movl   $0x8049ab,(%esp)
  80335a:	e8 5d e9 ff ff       	call   801cbc <cprintf>
	return n;
  80335f:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  803362:	89 c8                	mov    %ecx,%eax
  803364:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  803367:	5b                   	pop    %ebx
  803368:	5e                   	pop    %esi
  803369:	5f                   	pop    %edi
  80336a:	c9                   	leave  
  80336b:	c3                   	ret    

0080336c <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  80336c:	55                   	push   %ebp
  80336d:	89 e5                	mov    %esp,%ebp
  80336f:	56                   	push   %esi
  803370:	53                   	push   %ebx
  803371:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803374:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  803377:	83 ec 08             	sub    $0x8,%esp
  80337a:	8d 43 10             	lea    0x10(%ebx),%eax
  80337d:	50                   	push   %eax
  80337e:	56                   	push   %esi
  80337f:	e8 3c ef ff ff       	call   8022c0 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  803384:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  80338a:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  803390:	83 c4 10             	add    $0x10,%esp
  803393:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  80339a:	0f 94 c0             	sete   %al
  80339d:	0f b6 c0             	movzbl %al,%eax
  8033a0:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  8033a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8033ab:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8033ae:	5b                   	pop    %ebx
  8033af:	5e                   	pop    %esi
  8033b0:	c9                   	leave  
  8033b1:	c3                   	ret    

008033b2 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  8033b2:	55                   	push   %ebp
  8033b3:	89 e5                	mov    %esp,%ebp
  8033b5:	57                   	push   %edi
  8033b6:	56                   	push   %esi
  8033b7:	53                   	push   %ebx
  8033b8:	83 ec 0c             	sub    $0xc,%esp
  8033bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8033be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  8033c1:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8033c6:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  8033cc:	7f 5f                	jg     80342d <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  8033ce:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  8033d4:	83 ec 08             	sub    $0x8,%esp
  8033d7:	53                   	push   %ebx
  8033d8:	ff 76 0c             	pushl  0xc(%esi)
  8033db:	e8 3a 02 00 00       	call   80361a <fsipc_set_size>
  8033e0:	83 c4 10             	add    $0x10,%esp
		return r;
  8033e3:	89 c2                	mov    %eax,%edx
  8033e5:	85 c0                	test   %eax,%eax
  8033e7:	78 44                	js     80342d <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  8033e9:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  8033ef:	74 19                	je     80340a <file_trunc+0x58>
  8033f1:	68 c4 49 80 00       	push   $0x8049c4
  8033f6:	68 3d 3f 80 00       	push   $0x803f3d
  8033fb:	68 dc 00 00 00       	push   $0xdc
  803400:	68 b7 49 80 00       	push   $0x8049b7
  803405:	e8 c2 e7 ff ff       	call   801bcc <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  80340a:	83 ec 04             	sub    $0x4,%esp
  80340d:	53                   	push   %ebx
  80340e:	57                   	push   %edi
  80340f:	56                   	push   %esi
  803410:	e8 22 00 00 00       	call   803437 <fmap>
  803415:	83 c4 10             	add    $0x10,%esp
		return r;
  803418:	89 c2                	mov    %eax,%edx
  80341a:	85 c0                	test   %eax,%eax
  80341c:	78 0f                	js     80342d <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  80341e:	6a 00                	push   $0x0
  803420:	53                   	push   %ebx
  803421:	57                   	push   %edi
  803422:	56                   	push   %esi
  803423:	e8 85 00 00 00       	call   8034ad <funmap>

	return 0;
  803428:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80342d:	89 d0                	mov    %edx,%eax
  80342f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  803432:	5b                   	pop    %ebx
  803433:	5e                   	pop    %esi
  803434:	5f                   	pop    %edi
  803435:	c9                   	leave  
  803436:	c3                   	ret    

00803437 <fmap>:

// Call the file system server to obtain and map file pages
// when the size of the file as mapped in our memory increases.
// Harmlessly does nothing if oldsize >= newsize.
// Returns 0 on success, < 0 on error.
// If there is an error, unmaps any newly allocated pages.
//
// Hint: Use fd2data to get the start of the file mapping area for fd.
// Hint: You can use ROUNDUP to page-align offsets.
static int
fmap(struct Fd* fd, off_t oldsize, off_t newsize)
{
  803437:	55                   	push   %ebp
  803438:	89 e5                	mov    %esp,%ebp
  80343a:	57                   	push   %edi
  80343b:	56                   	push   %esi
  80343c:	53                   	push   %ebx
  80343d:	83 ec 0c             	sub    $0xc,%esp
  803440:	8b 7d 08             	mov    0x8(%ebp),%edi
  803443:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  803446:	39 75 0c             	cmp    %esi,0xc(%ebp)
  803449:	7d 55                	jge    8034a0 <fmap+0x69>
          fma = fd2data(fd);
  80344b:	83 ec 0c             	sub    $0xc,%esp
  80344e:	57                   	push   %edi
  80344f:	e8 54 f6 ff ff       	call   802aa8 <fd2data>
  803454:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  803457:	83 c4 10             	add    $0x10,%esp
  80345a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80345d:	05 ff 0f 00 00       	add    $0xfff,%eax
  803462:	89 c3                	mov    %eax,%ebx
  803464:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80346a:	39 f3                	cmp    %esi,%ebx
  80346c:	7d 32                	jge    8034a0 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  80346e:	83 ec 04             	sub    $0x4,%esp
  803471:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  803474:	01 d8                	add    %ebx,%eax
  803476:	50                   	push   %eax
  803477:	53                   	push   %ebx
  803478:	ff 77 0c             	pushl  0xc(%edi)
  80347b:	e8 6f 01 00 00       	call   8035ef <fsipc_map>
  803480:	83 c4 10             	add    $0x10,%esp
  803483:	85 c0                	test   %eax,%eax
  803485:	79 0f                	jns    803496 <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  803487:	6a 00                	push   $0x0
  803489:	ff 75 0c             	pushl  0xc(%ebp)
  80348c:	53                   	push   %ebx
  80348d:	57                   	push   %edi
  80348e:	e8 1a 00 00 00       	call   8034ad <funmap>
  803493:	83 c4 10             	add    $0x10,%esp
  803496:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80349c:	39 f3                	cmp    %esi,%ebx
  80349e:	7c ce                	jl     80346e <fmap+0x37>
            }
          }
        }

        return 0;
}
  8034a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034a5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8034a8:	5b                   	pop    %ebx
  8034a9:	5e                   	pop    %esi
  8034aa:	5f                   	pop    %edi
  8034ab:	c9                   	leave  
  8034ac:	c3                   	ret    

008034ad <funmap>:

// Unmap any file pages that no longer represent valid file pages
// when the size of the file as mapped in our address space decreases.
// Harmlessly does nothing if newsize >= oldsize.
//
// Hint: Remember to call fsipc_dirty if dirty is true and PTE_D bit
// is set in the pagetable entry.
// Hint: Use fd2data to get the start of the file mapping area for fd.
// Hint: You can use ROUNDUP to page-align offsets.
static int
funmap(struct Fd* fd, off_t oldsize, off_t newsize, bool dirty)
{
  8034ad:	55                   	push   %ebp
  8034ae:	89 e5                	mov    %esp,%ebp
  8034b0:	57                   	push   %edi
  8034b1:	56                   	push   %esi
  8034b2:	53                   	push   %ebx
  8034b3:	83 ec 0c             	sub    $0xc,%esp
  8034b6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8034b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  8034bc:	39 f3                	cmp    %esi,%ebx
  8034be:	0f 8d 80 00 00 00    	jge    803544 <funmap+0x97>
          fma = fd2data(fd);
  8034c4:	83 ec 0c             	sub    $0xc,%esp
  8034c7:	ff 75 08             	pushl  0x8(%ebp)
  8034ca:	e8 d9 f5 ff ff       	call   802aa8 <fd2data>
  8034cf:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  8034d1:	83 c4 10             	add    $0x10,%esp
  8034d4:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8034da:	89 c3                	mov    %eax,%ebx
  8034dc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8034e2:	39 f3                	cmp    %esi,%ebx
  8034e4:	7d 5e                	jge    803544 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  8034e6:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8034e9:	89 c2                	mov    %eax,%edx
  8034eb:	c1 ea 0c             	shr    $0xc,%edx
  8034ee:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8034f5:	a8 01                	test   $0x1,%al
  8034f7:	74 41                	je     80353a <funmap+0x8d>
              if (dirty) {
  8034f9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  8034fd:	74 21                	je     803520 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  8034ff:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  803506:	a8 40                	test   $0x40,%al
  803508:	74 16                	je     803520 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  80350a:	83 ec 08             	sub    $0x8,%esp
  80350d:	53                   	push   %ebx
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	ff 70 0c             	pushl  0xc(%eax)
  803514:	e8 49 01 00 00       	call   803662 <fsipc_dirty>
  803519:	83 c4 10             	add    $0x10,%esp
  80351c:	85 c0                	test   %eax,%eax
  80351e:	78 29                	js     803549 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  803520:	83 ec 08             	sub    $0x8,%esp
  803523:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  803526:	50                   	push   %eax
  803527:	83 ec 04             	sub    $0x4,%esp
  80352a:	e8 25 f1 ff ff       	call   802654 <sys_getenvid>
  80352f:	89 04 24             	mov    %eax,(%esp)
  803532:	e8 e0 f1 ff ff       	call   802717 <sys_page_unmap>
  803537:	83 c4 10             	add    $0x10,%esp
  80353a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  803540:	39 f3                	cmp    %esi,%ebx
  803542:	7c a2                	jl     8034e6 <funmap+0x39>
            }
          }
        }

        return 0;
  803544:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803549:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80354c:	5b                   	pop    %ebx
  80354d:	5e                   	pop    %esi
  80354e:	5f                   	pop    %edi
  80354f:	c9                   	leave  
  803550:	c3                   	ret    

00803551 <remove>:

// Delete a file
int
remove(const char *path)
{
  803551:	55                   	push   %ebp
  803552:	89 e5                	mov    %esp,%ebp
  803554:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  803557:	ff 75 08             	pushl  0x8(%ebp)
  80355a:	e8 2b 01 00 00       	call   80368a <fsipc_remove>
}
  80355f:	c9                   	leave  
  803560:	c3                   	ret    

00803561 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  803561:	55                   	push   %ebp
  803562:	89 e5                	mov    %esp,%ebp
  803564:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  803567:	e8 64 01 00 00       	call   8036d0 <fsipc_sync>
}
  80356c:	c9                   	leave  
  80356d:	c3                   	ret    
	...

00803570 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  803570:	55                   	push   %ebp
  803571:	89 e5                	mov    %esp,%ebp
  803573:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  803576:	6a 07                	push   $0x7
  803578:	ff 75 0c             	pushl  0xc(%ebp)
  80357b:	ff 75 08             	pushl  0x8(%ebp)
  80357e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  803583:	50                   	push   %eax
  803584:	e8 c6 f4 ff ff       	call   802a4f <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  803589:	83 c4 0c             	add    $0xc,%esp
  80358c:	ff 75 14             	pushl  0x14(%ebp)
  80358f:	ff 75 10             	pushl  0x10(%ebp)
  803592:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  803595:	50                   	push   %eax
  803596:	e8 51 f4 ff ff       	call   8029ec <ipc_recv>
}
  80359b:	c9                   	leave  
  80359c:	c3                   	ret    

0080359d <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  80359d:	55                   	push   %ebp
  80359e:	89 e5                	mov    %esp,%ebp
  8035a0:	56                   	push   %esi
  8035a1:	53                   	push   %ebx
  8035a2:	83 ec 1c             	sub    $0x1c,%esp
  8035a5:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  8035a8:	bb 00 50 80 00       	mov    $0x805000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  8035ad:	56                   	push   %esi
  8035ae:	e8 d1 ec ff ff       	call   802284 <strlen>
  8035b3:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  8035b6:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8035bb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8035c0:	7f 24                	jg     8035e6 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  8035c2:	83 ec 08             	sub    $0x8,%esp
  8035c5:	56                   	push   %esi
  8035c6:	53                   	push   %ebx
  8035c7:	e8 f4 ec ff ff       	call   8022c0 <strcpy>
	req->req_omode = omode;
  8035cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035cf:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  8035d5:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8035d8:	50                   	push   %eax
  8035d9:	ff 75 10             	pushl  0x10(%ebp)
  8035dc:	53                   	push   %ebx
  8035dd:	6a 01                	push   $0x1
  8035df:	e8 8c ff ff ff       	call   803570 <fsipc>
  8035e4:	89 c2                	mov    %eax,%edx
}
  8035e6:	89 d0                	mov    %edx,%eax
  8035e8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8035eb:	5b                   	pop    %ebx
  8035ec:	5e                   	pop    %esi
  8035ed:	c9                   	leave  
  8035ee:	c3                   	ret    

008035ef <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8035ef:	55                   	push   %ebp
  8035f0:	89 e5                	mov    %esp,%ebp
  8035f2:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  8035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f8:	a3 00 50 80 00       	mov    %eax,0x805000
        req->req_offset = offset;
  8035fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803600:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  803605:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  803608:	50                   	push   %eax
  803609:	ff 75 10             	pushl  0x10(%ebp)
  80360c:	68 00 50 80 00       	push   $0x805000
  803611:	6a 02                	push   $0x2
  803613:	e8 58 ff ff ff       	call   803570 <fsipc>

	//return -E_UNSPECIFIED;
}
  803618:	c9                   	leave  
  803619:	c3                   	ret    

0080361a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80361a:	55                   	push   %ebp
  80361b:	89 e5                	mov    %esp,%ebp
  80361d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  803620:	8b 45 08             	mov    0x8(%ebp),%eax
  803623:	a3 00 50 80 00       	mov    %eax,0x805000
	req->req_size = size;
  803628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80362b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  803630:	6a 00                	push   $0x0
  803632:	6a 00                	push   $0x0
  803634:	68 00 50 80 00       	push   $0x805000
  803639:	6a 03                	push   $0x3
  80363b:	e8 30 ff ff ff       	call   803570 <fsipc>
}
  803640:	c9                   	leave  
  803641:	c3                   	ret    

00803642 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  803642:	55                   	push   %ebp
  803643:	89 e5                	mov    %esp,%ebp
  803645:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  803648:	8b 45 08             	mov    0x8(%ebp),%eax
  80364b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  803650:	6a 00                	push   $0x0
  803652:	6a 00                	push   $0x0
  803654:	68 00 50 80 00       	push   $0x805000
  803659:	6a 04                	push   $0x4
  80365b:	e8 10 ff ff ff       	call   803570 <fsipc>
}
  803660:	c9                   	leave  
  803661:	c3                   	ret    

00803662 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  803662:	55                   	push   %ebp
  803663:	89 e5                	mov    %esp,%ebp
  803665:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	a3 00 50 80 00       	mov    %eax,0x805000
        req->req_offset = offset;
  803670:	8b 45 0c             	mov    0xc(%ebp),%eax
  803673:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  803678:	6a 00                	push   $0x0
  80367a:	6a 00                	push   $0x0
  80367c:	68 00 50 80 00       	push   $0x805000
  803681:	6a 05                	push   $0x5
  803683:	e8 e8 fe ff ff       	call   803570 <fsipc>
}
  803688:	c9                   	leave  
  803689:	c3                   	ret    

0080368a <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  80368a:	55                   	push   %ebp
  80368b:	89 e5                	mov    %esp,%ebp
  80368d:	56                   	push   %esi
  80368e:	53                   	push   %ebx
  80368f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  803692:	be 00 50 80 00       	mov    $0x805000,%esi
	if (strlen(path) >= MAXPATHLEN)
  803697:	83 ec 0c             	sub    $0xc,%esp
  80369a:	53                   	push   %ebx
  80369b:	e8 e4 eb ff ff       	call   802284 <strlen>
  8036a0:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  8036a3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8036a8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8036ad:	7f 18                	jg     8036c7 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  8036af:	83 ec 08             	sub    $0x8,%esp
  8036b2:	53                   	push   %ebx
  8036b3:	56                   	push   %esi
  8036b4:	e8 07 ec ff ff       	call   8022c0 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  8036b9:	6a 00                	push   $0x0
  8036bb:	6a 00                	push   $0x0
  8036bd:	56                   	push   %esi
  8036be:	6a 06                	push   $0x6
  8036c0:	e8 ab fe ff ff       	call   803570 <fsipc>
  8036c5:	89 c2                	mov    %eax,%edx
}
  8036c7:	89 d0                	mov    %edx,%eax
  8036c9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8036cc:	5b                   	pop    %ebx
  8036cd:	5e                   	pop    %esi
  8036ce:	c9                   	leave  
  8036cf:	c3                   	ret    

008036d0 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  8036d0:	55                   	push   %ebp
  8036d1:	89 e5                	mov    %esp,%ebp
  8036d3:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  8036d6:	6a 00                	push   $0x0
  8036d8:	6a 00                	push   $0x0
  8036da:	68 00 50 80 00       	push   $0x805000
  8036df:	6a 07                	push   $0x7
  8036e1:	e8 8a fe ff ff       	call   803570 <fsipc>
}
  8036e6:	c9                   	leave  
  8036e7:	c3                   	ret    

008036e8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8036e8:	55                   	push   %ebp
  8036e9:	89 e5                	mov    %esp,%ebp
  8036eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8036ee:	89 c8                	mov    %ecx,%eax
  8036f0:	c1 e8 16             	shr    $0x16,%eax
  8036f3:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8036fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8036ff:	a8 01                	test   $0x1,%al
  803701:	74 28                	je     80372b <pageref+0x43>
	pte = vpt[VPN(v)];
  803703:	89 c8                	mov    %ecx,%eax
  803705:	c1 e8 0c             	shr    $0xc,%eax
  803708:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  80370f:	ba 00 00 00 00       	mov    $0x0,%edx
  803714:	a8 01                	test   $0x1,%al
  803716:	74 13                	je     80372b <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  803718:	c1 e8 0c             	shr    $0xc,%eax
  80371b:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80371e:	c1 e0 02             	shl    $0x2,%eax
  803721:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  803728:	0f b7 d0             	movzwl %ax,%edx
}
  80372b:	89 d0                	mov    %edx,%eax
  80372d:	c9                   	leave  
  80372e:	c3                   	ret    
	...

00803730 <pipe>:
};

int
pipe(int pfd[2])
{
  803730:	55                   	push   %ebp
  803731:	89 e5                	mov    %esp,%ebp
  803733:	57                   	push   %edi
  803734:	56                   	push   %esi
  803735:	53                   	push   %ebx
  803736:	83 ec 18             	sub    $0x18,%esp
  803739:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80373c:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80373f:	50                   	push   %eax
  803740:	e8 8b f3 ff ff       	call   802ad0 <fd_alloc>
  803745:	89 c3                	mov    %eax,%ebx
  803747:	83 c4 10             	add    $0x10,%esp
  80374a:	85 c0                	test   %eax,%eax
  80374c:	0f 88 25 01 00 00    	js     803877 <pipe+0x147>
  803752:	83 ec 04             	sub    $0x4,%esp
  803755:	68 07 04 00 00       	push   $0x407
  80375a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80375d:	6a 00                	push   $0x0
  80375f:	e8 2e ef ff ff       	call   802692 <sys_page_alloc>
  803764:	89 c3                	mov    %eax,%ebx
  803766:	83 c4 10             	add    $0x10,%esp
  803769:	85 c0                	test   %eax,%eax
  80376b:	0f 88 06 01 00 00    	js     803877 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803771:	83 ec 0c             	sub    $0xc,%esp
  803774:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  803777:	50                   	push   %eax
  803778:	e8 53 f3 ff ff       	call   802ad0 <fd_alloc>
  80377d:	89 c3                	mov    %eax,%ebx
  80377f:	83 c4 10             	add    $0x10,%esp
  803782:	85 c0                	test   %eax,%eax
  803784:	0f 88 dd 00 00 00    	js     803867 <pipe+0x137>
  80378a:	83 ec 04             	sub    $0x4,%esp
  80378d:	68 07 04 00 00       	push   $0x407
  803792:	ff 75 ec             	pushl  0xffffffec(%ebp)
  803795:	6a 00                	push   $0x0
  803797:	e8 f6 ee ff ff       	call   802692 <sys_page_alloc>
  80379c:	89 c3                	mov    %eax,%ebx
  80379e:	83 c4 10             	add    $0x10,%esp
  8037a1:	85 c0                	test   %eax,%eax
  8037a3:	0f 88 be 00 00 00    	js     803867 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8037a9:	83 ec 0c             	sub    $0xc,%esp
  8037ac:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8037af:	e8 f4 f2 ff ff       	call   802aa8 <fd2data>
  8037b4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037b6:	83 c4 0c             	add    $0xc,%esp
  8037b9:	68 07 04 00 00       	push   $0x407
  8037be:	50                   	push   %eax
  8037bf:	6a 00                	push   $0x0
  8037c1:	e8 cc ee ff ff       	call   802692 <sys_page_alloc>
  8037c6:	89 c3                	mov    %eax,%ebx
  8037c8:	83 c4 10             	add    $0x10,%esp
  8037cb:	85 c0                	test   %eax,%eax
  8037cd:	0f 88 84 00 00 00    	js     803857 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037d3:	83 ec 0c             	sub    $0xc,%esp
  8037d6:	68 07 04 00 00       	push   $0x407
  8037db:	83 ec 0c             	sub    $0xc,%esp
  8037de:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8037e1:	e8 c2 f2 ff ff       	call   802aa8 <fd2data>
  8037e6:	83 c4 10             	add    $0x10,%esp
  8037e9:	50                   	push   %eax
  8037ea:	6a 00                	push   $0x0
  8037ec:	56                   	push   %esi
  8037ed:	6a 00                	push   $0x0
  8037ef:	e8 e1 ee ff ff       	call   8026d5 <sys_page_map>
  8037f4:	89 c3                	mov    %eax,%ebx
  8037f6:	83 c4 20             	add    $0x20,%esp
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	78 4c                	js     803849 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8037fd:	8b 15 60 c0 80 00    	mov    0x80c060,%edx
  803803:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  803806:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803808:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80380b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803812:	8b 15 60 c0 80 00    	mov    0x80c060,%edx
  803818:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80381b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80381d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  803820:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  803827:	83 ec 0c             	sub    $0xc,%esp
  80382a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80382d:	e8 8e f2 ff ff       	call   802ac0 <fd2num>
  803832:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  803834:	83 c4 04             	add    $0x4,%esp
  803837:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80383a:	e8 81 f2 ff ff       	call   802ac0 <fd2num>
  80383f:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  803842:	b8 00 00 00 00       	mov    $0x0,%eax
  803847:	eb 30                	jmp    803879 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  803849:	83 ec 08             	sub    $0x8,%esp
  80384c:	56                   	push   %esi
  80384d:	6a 00                	push   $0x0
  80384f:	e8 c3 ee ff ff       	call   802717 <sys_page_unmap>
  803854:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  803857:	83 ec 08             	sub    $0x8,%esp
  80385a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80385d:	6a 00                	push   $0x0
  80385f:	e8 b3 ee ff ff       	call   802717 <sys_page_unmap>
  803864:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  803867:	83 ec 08             	sub    $0x8,%esp
  80386a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80386d:	6a 00                	push   $0x0
  80386f:	e8 a3 ee ff ff       	call   802717 <sys_page_unmap>
  803874:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  803877:	89 d8                	mov    %ebx,%eax
}
  803879:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80387c:	5b                   	pop    %ebx
  80387d:	5e                   	pop    %esi
  80387e:	5f                   	pop    %edi
  80387f:	c9                   	leave  
  803880:	c3                   	ret    

00803881 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803881:	55                   	push   %ebp
  803882:	89 e5                	mov    %esp,%ebp
  803884:	57                   	push   %edi
  803885:	56                   	push   %esi
  803886:	53                   	push   %ebx
  803887:	83 ec 0c             	sub    $0xc,%esp
  80388a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  80388d:	a1 a8 c0 80 00       	mov    0x80c0a8,%eax
  803892:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  803895:	83 ec 0c             	sub    $0xc,%esp
  803898:	ff 75 08             	pushl  0x8(%ebp)
  80389b:	e8 48 fe ff ff       	call   8036e8 <pageref>
  8038a0:	89 c3                	mov    %eax,%ebx
  8038a2:	89 3c 24             	mov    %edi,(%esp)
  8038a5:	e8 3e fe ff ff       	call   8036e8 <pageref>
  8038aa:	83 c4 10             	add    $0x10,%esp
  8038ad:	39 c3                	cmp    %eax,%ebx
  8038af:	0f 94 c0             	sete   %al
  8038b2:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  8038b5:	8b 0d a8 c0 80 00    	mov    0x80c0a8,%ecx
  8038bb:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  8038be:	39 c6                	cmp    %eax,%esi
  8038c0:	74 1b                	je     8038dd <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  8038c2:	83 fa 01             	cmp    $0x1,%edx
  8038c5:	75 c6                	jne    80388d <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8038c7:	6a 01                	push   $0x1
  8038c9:	8b 41 58             	mov    0x58(%ecx),%eax
  8038cc:	50                   	push   %eax
  8038cd:	56                   	push   %esi
  8038ce:	68 ec 49 80 00       	push   $0x8049ec
  8038d3:	e8 e4 e3 ff ff       	call   801cbc <cprintf>
  8038d8:	83 c4 10             	add    $0x10,%esp
  8038db:	eb b0                	jmp    80388d <_pipeisclosed+0xc>
	}
}
  8038dd:	89 d0                	mov    %edx,%eax
  8038df:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8038e2:	5b                   	pop    %ebx
  8038e3:	5e                   	pop    %esi
  8038e4:	5f                   	pop    %edi
  8038e5:	c9                   	leave  
  8038e6:	c3                   	ret    

008038e7 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8038e7:	55                   	push   %ebp
  8038e8:	89 e5                	mov    %esp,%ebp
  8038ea:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8038ed:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8038f0:	50                   	push   %eax
  8038f1:	ff 75 08             	pushl  0x8(%ebp)
  8038f4:	e8 31 f2 ff ff       	call   802b2a <fd_lookup>
  8038f9:	83 c4 10             	add    $0x10,%esp
		return r;
  8038fc:	89 c2                	mov    %eax,%edx
  8038fe:	85 c0                	test   %eax,%eax
  803900:	78 19                	js     80391b <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  803902:	83 ec 0c             	sub    $0xc,%esp
  803905:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  803908:	e8 9b f1 ff ff       	call   802aa8 <fd2data>
	return _pipeisclosed(fd, p);
  80390d:	83 c4 08             	add    $0x8,%esp
  803910:	50                   	push   %eax
  803911:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  803914:	e8 68 ff ff ff       	call   803881 <_pipeisclosed>
  803919:	89 c2                	mov    %eax,%edx
}
  80391b:	89 d0                	mov    %edx,%eax
  80391d:	c9                   	leave  
  80391e:	c3                   	ret    

0080391f <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80391f:	55                   	push   %ebp
  803920:	89 e5                	mov    %esp,%ebp
  803922:	57                   	push   %edi
  803923:	56                   	push   %esi
  803924:	53                   	push   %ebx
  803925:	83 ec 18             	sub    $0x18,%esp
  803928:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  80392b:	57                   	push   %edi
  80392c:	e8 77 f1 ff ff       	call   802aa8 <fd2data>
  803931:	89 c3                	mov    %eax,%ebx
	if (debug)
  803933:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  803936:	8b 45 0c             	mov    0xc(%ebp),%eax
  803939:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80393c:	be 00 00 00 00       	mov    $0x0,%esi
  803941:	3b 75 10             	cmp    0x10(%ebp),%esi
  803944:	73 55                	jae    80399b <piperead+0x7c>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("piperead yield\n");
			sys_yield();
  803946:	8b 03                	mov    (%ebx),%eax
  803948:	3b 43 04             	cmp    0x4(%ebx),%eax
  80394b:	75 2c                	jne    803979 <piperead+0x5a>
  80394d:	85 f6                	test   %esi,%esi
  80394f:	74 04                	je     803955 <piperead+0x36>
  803951:	89 f0                	mov    %esi,%eax
  803953:	eb 48                	jmp    80399d <piperead+0x7e>
  803955:	83 ec 08             	sub    $0x8,%esp
  803958:	53                   	push   %ebx
  803959:	57                   	push   %edi
  80395a:	e8 22 ff ff ff       	call   803881 <_pipeisclosed>
  80395f:	83 c4 10             	add    $0x10,%esp
  803962:	85 c0                	test   %eax,%eax
  803964:	74 07                	je     80396d <piperead+0x4e>
  803966:	b8 00 00 00 00       	mov    $0x0,%eax
  80396b:	eb 30                	jmp    80399d <piperead+0x7e>
  80396d:	e8 01 ed ff ff       	call   802673 <sys_yield>
  803972:	8b 03                	mov    (%ebx),%eax
  803974:	3b 43 04             	cmp    0x4(%ebx),%eax
  803977:	74 d4                	je     80394d <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803979:	8b 13                	mov    (%ebx),%edx
  80397b:	89 d0                	mov    %edx,%eax
  80397d:	85 d2                	test   %edx,%edx
  80397f:	79 03                	jns    803984 <piperead+0x65>
  803981:	8d 42 1f             	lea    0x1f(%edx),%eax
  803984:	83 e0 e0             	and    $0xffffffe0,%eax
  803987:	29 c2                	sub    %eax,%edx
  803989:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  80398d:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  803990:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  803993:	ff 03                	incl   (%ebx)
  803995:	46                   	inc    %esi
  803996:	3b 75 10             	cmp    0x10(%ebp),%esi
  803999:	72 ab                	jb     803946 <piperead+0x27>
	}
	return i;
  80399b:	89 f0                	mov    %esi,%eax
}
  80399d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8039a0:	5b                   	pop    %ebx
  8039a1:	5e                   	pop    %esi
  8039a2:	5f                   	pop    %edi
  8039a3:	c9                   	leave  
  8039a4:	c3                   	ret    

008039a5 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8039a5:	55                   	push   %ebp
  8039a6:	89 e5                	mov    %esp,%ebp
  8039a8:	57                   	push   %edi
  8039a9:	56                   	push   %esi
  8039aa:	53                   	push   %ebx
  8039ab:	83 ec 18             	sub    $0x18,%esp
  8039ae:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  8039b1:	57                   	push   %edi
  8039b2:	e8 f1 f0 ff ff       	call   802aa8 <fd2data>
  8039b7:	89 c3                	mov    %eax,%ebx
	if (debug)
  8039b9:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8039bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039bf:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8039c2:	be 00 00 00 00       	mov    $0x0,%esi
  8039c7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8039ca:	73 55                	jae    803a21 <pipewrite+0x7c>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("pipewrite yield\n");
			sys_yield();
  8039cc:	8b 03                	mov    (%ebx),%eax
  8039ce:	83 c0 20             	add    $0x20,%eax
  8039d1:	39 43 04             	cmp    %eax,0x4(%ebx)
  8039d4:	72 27                	jb     8039fd <pipewrite+0x58>
  8039d6:	83 ec 08             	sub    $0x8,%esp
  8039d9:	53                   	push   %ebx
  8039da:	57                   	push   %edi
  8039db:	e8 a1 fe ff ff       	call   803881 <_pipeisclosed>
  8039e0:	83 c4 10             	add    $0x10,%esp
  8039e3:	85 c0                	test   %eax,%eax
  8039e5:	74 07                	je     8039ee <pipewrite+0x49>
  8039e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8039ec:	eb 35                	jmp    803a23 <pipewrite+0x7e>
  8039ee:	e8 80 ec ff ff       	call   802673 <sys_yield>
  8039f3:	8b 03                	mov    (%ebx),%eax
  8039f5:	83 c0 20             	add    $0x20,%eax
  8039f8:	39 43 04             	cmp    %eax,0x4(%ebx)
  8039fb:	73 d9                	jae    8039d6 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8039fd:	8b 53 04             	mov    0x4(%ebx),%edx
  803a00:	89 d0                	mov    %edx,%eax
  803a02:	85 d2                	test   %edx,%edx
  803a04:	79 03                	jns    803a09 <pipewrite+0x64>
  803a06:	8d 42 1f             	lea    0x1f(%edx),%eax
  803a09:	83 e0 e0             	and    $0xffffffe0,%eax
  803a0c:	29 c2                	sub    %eax,%edx
  803a0e:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  803a11:	8a 04 31             	mov    (%ecx,%esi,1),%al
  803a14:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803a18:	ff 43 04             	incl   0x4(%ebx)
  803a1b:	46                   	inc    %esi
  803a1c:	3b 75 10             	cmp    0x10(%ebp),%esi
  803a1f:	72 ab                	jb     8039cc <pipewrite+0x27>
	}
	
	return i;
  803a21:	89 f0                	mov    %esi,%eax
}
  803a23:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  803a26:	5b                   	pop    %ebx
  803a27:	5e                   	pop    %esi
  803a28:	5f                   	pop    %edi
  803a29:	c9                   	leave  
  803a2a:	c3                   	ret    

00803a2b <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  803a2b:	55                   	push   %ebp
  803a2c:	89 e5                	mov    %esp,%ebp
  803a2e:	56                   	push   %esi
  803a2f:	53                   	push   %ebx
  803a30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803a33:	83 ec 0c             	sub    $0xc,%esp
  803a36:	ff 75 08             	pushl  0x8(%ebp)
  803a39:	e8 6a f0 ff ff       	call   802aa8 <fd2data>
  803a3e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803a40:	83 c4 08             	add    $0x8,%esp
  803a43:	68 ff 49 80 00       	push   $0x8049ff
  803a48:	53                   	push   %ebx
  803a49:	e8 72 e8 ff ff       	call   8022c0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803a4e:	8b 46 04             	mov    0x4(%esi),%eax
  803a51:	2b 06                	sub    (%esi),%eax
  803a53:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803a59:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803a60:	00 00 00 
	stat->st_dev = &devpipe;
  803a63:	c7 83 88 00 00 00 60 	movl   $0x80c060,0x88(%ebx)
  803a6a:	c0 80 00 
	return 0;
}
  803a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  803a72:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  803a75:	5b                   	pop    %ebx
  803a76:	5e                   	pop    %esi
  803a77:	c9                   	leave  
  803a78:	c3                   	ret    

00803a79 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  803a79:	55                   	push   %ebp
  803a7a:	89 e5                	mov    %esp,%ebp
  803a7c:	53                   	push   %ebx
  803a7d:	83 ec 0c             	sub    $0xc,%esp
  803a80:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803a83:	53                   	push   %ebx
  803a84:	6a 00                	push   $0x0
  803a86:	e8 8c ec ff ff       	call   802717 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803a8b:	89 1c 24             	mov    %ebx,(%esp)
  803a8e:	e8 15 f0 ff ff       	call   802aa8 <fd2data>
  803a93:	83 c4 08             	add    $0x8,%esp
  803a96:	50                   	push   %eax
  803a97:	6a 00                	push   $0x0
  803a99:	e8 79 ec ff ff       	call   802717 <sys_page_unmap>
}
  803a9e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  803aa1:	c9                   	leave  
  803aa2:	c3                   	ret    
	...

00803aa4 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  803aa4:	55                   	push   %ebp
  803aa5:	89 e5                	mov    %esp,%ebp
  803aa7:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  803aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  803aad:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803ab0:	6a 01                	push   $0x1
  803ab2:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  803ab5:	50                   	push   %eax
  803ab6:	e8 15 eb ff ff       	call   8025d0 <sys_cputs>
}
  803abb:	c9                   	leave  
  803abc:	c3                   	ret    

00803abd <getchar>:

int
getchar(void)
{
  803abd:	55                   	push   %ebp
  803abe:	89 e5                	mov    %esp,%ebp
  803ac0:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  803ac3:	6a 01                	push   $0x1
  803ac5:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  803ac8:	50                   	push   %eax
  803ac9:	6a 00                	push   $0x0
  803acb:	e8 ed f2 ff ff       	call   802dbd <read>
	if (r < 0)
  803ad0:	83 c4 10             	add    $0x10,%esp
		return r;
  803ad3:	89 c2                	mov    %eax,%edx
  803ad5:	85 c0                	test   %eax,%eax
  803ad7:	78 0d                	js     803ae6 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  803ad9:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  803ade:	85 c0                	test   %eax,%eax
  803ae0:	7e 04                	jle    803ae6 <getchar+0x29>
	return c;
  803ae2:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  803ae6:	89 d0                	mov    %edx,%eax
  803ae8:	c9                   	leave  
  803ae9:	c3                   	ret    

00803aea <iscons>:


// "Real" console file descriptor implementation.
// The putchar/getchar functions above will still come here by default,
// but now can be redirected to files, pipes, etc., via the fd layer.

static ssize_t cons_read(struct Fd*, void*, size_t, off_t);
static ssize_t cons_write(struct Fd*, const void*, size_t, off_t);
static int cons_close(struct Fd*);
static int cons_stat(struct Fd*, struct Stat*);

struct Dev devcons =
{
	.dev_id =	'c',
	.dev_name =	"cons",
	.dev_read =	cons_read,
	.dev_write =	cons_write,
	.dev_close =	cons_close,
	.dev_stat =	cons_stat
};

int
iscons(int fdnum)
{
  803aea:	55                   	push   %ebp
  803aeb:	89 e5                	mov    %esp,%ebp
  803aed:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803af0:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  803af3:	50                   	push   %eax
  803af4:	ff 75 08             	pushl  0x8(%ebp)
  803af7:	e8 2e f0 ff ff       	call   802b2a <fd_lookup>
  803afc:	83 c4 10             	add    $0x10,%esp
		return r;
  803aff:	89 c2                	mov    %eax,%edx
  803b01:	85 c0                	test   %eax,%eax
  803b03:	78 11                	js     803b16 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  803b05:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  803b08:	8b 00                	mov    (%eax),%eax
  803b0a:	3b 05 80 c0 80 00    	cmp    0x80c080,%eax
  803b10:	0f 94 c0             	sete   %al
  803b13:	0f b6 d0             	movzbl %al,%edx
}
  803b16:	89 d0                	mov    %edx,%eax
  803b18:	c9                   	leave  
  803b19:	c3                   	ret    

00803b1a <opencons>:

int
opencons(void)
{
  803b1a:	55                   	push   %ebp
  803b1b:	89 e5                	mov    %esp,%ebp
  803b1d:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  803b20:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  803b23:	50                   	push   %eax
  803b24:	e8 a7 ef ff ff       	call   802ad0 <fd_alloc>
  803b29:	83 c4 10             	add    $0x10,%esp
		return r;
  803b2c:	89 c2                	mov    %eax,%edx
  803b2e:	85 c0                	test   %eax,%eax
  803b30:	78 3c                	js     803b6e <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  803b32:	83 ec 04             	sub    $0x4,%esp
  803b35:	68 07 04 00 00       	push   $0x407
  803b3a:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  803b3d:	6a 00                	push   $0x0
  803b3f:	e8 4e eb ff ff       	call   802692 <sys_page_alloc>
  803b44:	83 c4 10             	add    $0x10,%esp
		return r;
  803b47:	89 c2                	mov    %eax,%edx
  803b49:	85 c0                	test   %eax,%eax
  803b4b:	78 21                	js     803b6e <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  803b4d:	a1 80 c0 80 00       	mov    0x80c080,%eax
  803b52:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  803b55:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  803b57:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  803b5a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803b61:	83 ec 0c             	sub    $0xc,%esp
  803b64:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  803b67:	e8 54 ef ff ff       	call   802ac0 <fd2num>
  803b6c:	89 c2                	mov    %eax,%edx
}
  803b6e:	89 d0                	mov    %edx,%eax
  803b70:	c9                   	leave  
  803b71:	c3                   	ret    

00803b72 <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  803b72:	55                   	push   %ebp
  803b73:	89 e5                	mov    %esp,%ebp
  803b75:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  803b78:	b8 00 00 00 00       	mov    $0x0,%eax
  803b7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803b81:	74 2a                	je     803bad <cons_read+0x3b>
  803b83:	eb 05                	jmp    803b8a <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803b85:	e8 e9 ea ff ff       	call   802673 <sys_yield>
  803b8a:	e8 65 ea ff ff       	call   8025f4 <sys_cgetc>
  803b8f:	89 c2                	mov    %eax,%edx
  803b91:	85 c0                	test   %eax,%eax
  803b93:	74 f0                	je     803b85 <cons_read+0x13>
	if (c < 0)
  803b95:	85 d2                	test   %edx,%edx
  803b97:	78 14                	js     803bad <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  803b99:	b8 00 00 00 00       	mov    $0x0,%eax
  803b9e:	83 fa 04             	cmp    $0x4,%edx
  803ba1:	74 0a                	je     803bad <cons_read+0x3b>
	*(char*)vbuf = c;
  803ba3:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ba6:	88 10                	mov    %dl,(%eax)
	return 1;
  803ba8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  803bad:	c9                   	leave  
  803bae:	c3                   	ret    

00803baf <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  803baf:	55                   	push   %ebp
  803bb0:	89 e5                	mov    %esp,%ebp
  803bb2:	57                   	push   %edi
  803bb3:	56                   	push   %esi
  803bb4:	53                   	push   %ebx
  803bb5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  803bbb:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  803bbe:	be 00 00 00 00       	mov    $0x0,%esi
  803bc3:	39 fe                	cmp    %edi,%esi
  803bc5:	73 3d                	jae    803c04 <cons_write+0x55>
		m = n - tot;
  803bc7:	89 fb                	mov    %edi,%ebx
  803bc9:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  803bcb:	83 fb 7f             	cmp    $0x7f,%ebx
  803bce:	76 05                	jbe    803bd5 <cons_write+0x26>
			m = sizeof(buf) - 1;
  803bd0:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  803bd5:	83 ec 04             	sub    $0x4,%esp
  803bd8:	53                   	push   %ebx
  803bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bdc:	01 f0                	add    %esi,%eax
  803bde:	50                   	push   %eax
  803bdf:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  803be5:	50                   	push   %eax
  803be6:	e8 51 e8 ff ff       	call   80243c <memmove>
		sys_cputs(buf, m);
  803beb:	83 c4 08             	add    $0x8,%esp
  803bee:	53                   	push   %ebx
  803bef:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  803bf5:	50                   	push   %eax
  803bf6:	e8 d5 e9 ff ff       	call   8025d0 <sys_cputs>
  803bfb:	83 c4 10             	add    $0x10,%esp
  803bfe:	01 de                	add    %ebx,%esi
  803c00:	39 fe                	cmp    %edi,%esi
  803c02:	72 c3                	jb     803bc7 <cons_write+0x18>
	}
	return tot;
}
  803c04:	89 f0                	mov    %esi,%eax
  803c06:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  803c09:	5b                   	pop    %ebx
  803c0a:	5e                   	pop    %esi
  803c0b:	5f                   	pop    %edi
  803c0c:	c9                   	leave  
  803c0d:	c3                   	ret    

00803c0e <cons_close>:

int
cons_close(struct Fd *fd)
{
  803c0e:	55                   	push   %ebp
  803c0f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803c11:	b8 00 00 00 00       	mov    $0x0,%eax
  803c16:	c9                   	leave  
  803c17:	c3                   	ret    

00803c18 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  803c18:	55                   	push   %ebp
  803c19:	89 e5                	mov    %esp,%ebp
  803c1b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  803c1e:	68 0b 4a 80 00       	push   $0x804a0b
  803c23:	ff 75 0c             	pushl  0xc(%ebp)
  803c26:	e8 95 e6 ff ff       	call   8022c0 <strcpy>
	return 0;
}
  803c2b:	b8 00 00 00 00       	mov    $0x0,%eax
  803c30:	c9                   	leave  
  803c31:	c3                   	ret    
	...

00803c34 <__udivdi3>:
  803c34:	55                   	push   %ebp
  803c35:	89 e5                	mov    %esp,%ebp
  803c37:	57                   	push   %edi
  803c38:	56                   	push   %esi
  803c39:	83 ec 14             	sub    $0x14,%esp
  803c3c:	8b 55 14             	mov    0x14(%ebp),%edx
  803c3f:	8b 75 08             	mov    0x8(%ebp),%esi
  803c42:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803c45:	8b 45 10             	mov    0x10(%ebp),%eax
  803c48:	85 d2                	test   %edx,%edx
  803c4a:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  803c4d:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  803c50:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  803c53:	89 fe                	mov    %edi,%esi
  803c55:	75 11                	jne    803c68 <__udivdi3+0x34>
  803c57:	39 f8                	cmp    %edi,%eax
  803c59:	76 4d                	jbe    803ca8 <__udivdi3+0x74>
  803c5b:	89 fa                	mov    %edi,%edx
  803c5d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  803c60:	f7 75 e4             	divl   0xffffffe4(%ebp)
  803c63:	89 c7                	mov    %eax,%edi
  803c65:	eb 09                	jmp    803c70 <__udivdi3+0x3c>
  803c67:	90                   	nop    
  803c68:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  803c6b:	76 17                	jbe    803c84 <__udivdi3+0x50>
  803c6d:	31 ff                	xor    %edi,%edi
  803c6f:	90                   	nop    
  803c70:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  803c77:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  803c7a:	83 c4 14             	add    $0x14,%esp
  803c7d:	5e                   	pop    %esi
  803c7e:	89 f8                	mov    %edi,%eax
  803c80:	5f                   	pop    %edi
  803c81:	c9                   	leave  
  803c82:	c3                   	ret    
  803c83:	90                   	nop    
  803c84:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  803c88:	89 c7                	mov    %eax,%edi
  803c8a:	83 f7 1f             	xor    $0x1f,%edi
  803c8d:	75 4d                	jne    803cdc <__udivdi3+0xa8>
  803c8f:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  803c92:	77 0a                	ja     803c9e <__udivdi3+0x6a>
  803c94:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  803c97:	31 ff                	xor    %edi,%edi
  803c99:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  803c9c:	72 d2                	jb     803c70 <__udivdi3+0x3c>
  803c9e:	bf 01 00 00 00       	mov    $0x1,%edi
  803ca3:	eb cb                	jmp    803c70 <__udivdi3+0x3c>
  803ca5:	8d 76 00             	lea    0x0(%esi),%esi
  803ca8:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  803cab:	85 c0                	test   %eax,%eax
  803cad:	75 0e                	jne    803cbd <__udivdi3+0x89>
  803caf:	b8 01 00 00 00       	mov    $0x1,%eax
  803cb4:	31 c9                	xor    %ecx,%ecx
  803cb6:	31 d2                	xor    %edx,%edx
  803cb8:	f7 f1                	div    %ecx
  803cba:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  803cbd:	89 f0                	mov    %esi,%eax
  803cbf:	31 d2                	xor    %edx,%edx
  803cc1:	f7 75 e4             	divl   0xffffffe4(%ebp)
  803cc4:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  803cc7:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  803cca:	f7 75 e4             	divl   0xffffffe4(%ebp)
  803ccd:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  803cd0:	83 c4 14             	add    $0x14,%esp
  803cd3:	89 c7                	mov    %eax,%edi
  803cd5:	5e                   	pop    %esi
  803cd6:	89 f8                	mov    %edi,%eax
  803cd8:	5f                   	pop    %edi
  803cd9:	c9                   	leave  
  803cda:	c3                   	ret    
  803cdb:	90                   	nop    
  803cdc:	b8 20 00 00 00       	mov    $0x20,%eax
  803ce1:	29 f8                	sub    %edi,%eax
  803ce3:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  803ce6:	89 f9                	mov    %edi,%ecx
  803ce8:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  803ceb:	d3 e2                	shl    %cl,%edx
  803ced:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  803cf0:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  803cf3:	d3 e8                	shr    %cl,%eax
  803cf5:	09 c2                	or     %eax,%edx
  803cf7:	89 f9                	mov    %edi,%ecx
  803cf9:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  803cfc:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  803cff:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  803d02:	89 f2                	mov    %esi,%edx
  803d04:	d3 ea                	shr    %cl,%edx
  803d06:	89 f9                	mov    %edi,%ecx
  803d08:	d3 e6                	shl    %cl,%esi
  803d0a:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  803d0d:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  803d10:	d3 e8                	shr    %cl,%eax
  803d12:	09 c6                	or     %eax,%esi
  803d14:	89 f9                	mov    %edi,%ecx
  803d16:	89 f0                	mov    %esi,%eax
  803d18:	f7 75 f4             	divl   0xfffffff4(%ebp)
  803d1b:	89 d6                	mov    %edx,%esi
  803d1d:	89 c7                	mov    %eax,%edi
  803d1f:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  803d22:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  803d25:	f7 e7                	mul    %edi
  803d27:	39 f2                	cmp    %esi,%edx
  803d29:	77 0f                	ja     803d3a <__udivdi3+0x106>
  803d2b:	0f 85 3f ff ff ff    	jne    803c70 <__udivdi3+0x3c>
  803d31:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  803d34:	0f 86 36 ff ff ff    	jbe    803c70 <__udivdi3+0x3c>
  803d3a:	4f                   	dec    %edi
  803d3b:	e9 30 ff ff ff       	jmp    803c70 <__udivdi3+0x3c>

00803d40 <__umoddi3>:
  803d40:	55                   	push   %ebp
  803d41:	89 e5                	mov    %esp,%ebp
  803d43:	57                   	push   %edi
  803d44:	56                   	push   %esi
  803d45:	83 ec 30             	sub    $0x30,%esp
  803d48:	8b 55 14             	mov    0x14(%ebp),%edx
  803d4b:	8b 45 10             	mov    0x10(%ebp),%eax
  803d4e:	89 d7                	mov    %edx,%edi
  803d50:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  803d53:	89 c6                	mov    %eax,%esi
  803d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d58:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5b:	85 ff                	test   %edi,%edi
  803d5d:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  803d64:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  803d6b:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  803d6e:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  803d71:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  803d74:	75 3e                	jne    803db4 <__umoddi3+0x74>
  803d76:	39 d6                	cmp    %edx,%esi
  803d78:	0f 86 a2 00 00 00    	jbe    803e20 <__umoddi3+0xe0>
  803d7e:	f7 f6                	div    %esi
  803d80:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  803d83:	85 c9                	test   %ecx,%ecx
  803d85:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  803d88:	74 1b                	je     803da5 <__umoddi3+0x65>
  803d8a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  803d8d:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  803d90:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  803d97:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  803d9a:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  803d9d:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  803da0:	89 10                	mov    %edx,(%eax)
  803da2:	89 48 04             	mov    %ecx,0x4(%eax)
  803da5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  803da8:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  803dab:	83 c4 30             	add    $0x30,%esp
  803dae:	5e                   	pop    %esi
  803daf:	5f                   	pop    %edi
  803db0:	c9                   	leave  
  803db1:	c3                   	ret    
  803db2:	89 f6                	mov    %esi,%esi
  803db4:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  803db7:	76 1f                	jbe    803dd8 <__umoddi3+0x98>
  803db9:	8b 55 08             	mov    0x8(%ebp),%edx
  803dbc:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  803dbf:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  803dc2:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  803dc5:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  803dc8:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  803dcb:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  803dce:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  803dd1:	83 c4 30             	add    $0x30,%esp
  803dd4:	5e                   	pop    %esi
  803dd5:	5f                   	pop    %edi
  803dd6:	c9                   	leave  
  803dd7:	c3                   	ret    
  803dd8:	0f bd c7             	bsr    %edi,%eax
  803ddb:	83 f0 1f             	xor    $0x1f,%eax
  803dde:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  803de1:	75 61                	jne    803e44 <__umoddi3+0x104>
  803de3:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  803de6:	77 05                	ja     803ded <__umoddi3+0xad>
  803de8:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  803deb:	72 10                	jb     803dfd <__umoddi3+0xbd>
  803ded:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  803df0:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  803df3:	29 f0                	sub    %esi,%eax
  803df5:	19 fa                	sbb    %edi,%edx
  803df7:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  803dfa:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  803dfd:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  803e00:	85 d2                	test   %edx,%edx
  803e02:	74 a1                	je     803da5 <__umoddi3+0x65>
  803e04:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  803e07:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  803e0a:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  803e0d:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  803e10:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  803e13:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  803e16:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  803e19:	89 01                	mov    %eax,(%ecx)
  803e1b:	89 51 04             	mov    %edx,0x4(%ecx)
  803e1e:	eb 85                	jmp    803da5 <__umoddi3+0x65>
  803e20:	85 f6                	test   %esi,%esi
  803e22:	75 0b                	jne    803e2f <__umoddi3+0xef>
  803e24:	b8 01 00 00 00       	mov    $0x1,%eax
  803e29:	31 d2                	xor    %edx,%edx
  803e2b:	f7 f6                	div    %esi
  803e2d:	89 c6                	mov    %eax,%esi
  803e2f:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  803e32:	89 fa                	mov    %edi,%edx
  803e34:	f7 f6                	div    %esi
  803e36:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  803e39:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  803e3c:	f7 f6                	div    %esi
  803e3e:	e9 3d ff ff ff       	jmp    803d80 <__umoddi3+0x40>
  803e43:	90                   	nop    
  803e44:	b8 20 00 00 00       	mov    $0x20,%eax
  803e49:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  803e4c:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  803e4f:	89 fa                	mov    %edi,%edx
  803e51:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  803e54:	d3 e2                	shl    %cl,%edx
  803e56:	89 f0                	mov    %esi,%eax
  803e58:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  803e5b:	d3 e8                	shr    %cl,%eax
  803e5d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  803e60:	d3 e6                	shl    %cl,%esi
  803e62:	89 d7                	mov    %edx,%edi
  803e64:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  803e67:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  803e6a:	09 c7                	or     %eax,%edi
  803e6c:	d3 ea                	shr    %cl,%edx
  803e6e:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  803e71:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  803e74:	d3 e0                	shl    %cl,%eax
  803e76:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  803e79:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  803e7c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  803e7f:	d3 e8                	shr    %cl,%eax
  803e81:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  803e84:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  803e87:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  803e8a:	f7 f7                	div    %edi
  803e8c:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  803e8f:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  803e92:	f7 e6                	mul    %esi
  803e94:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  803e97:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  803e9a:	77 0a                	ja     803ea6 <__umoddi3+0x166>
  803e9c:	75 12                	jne    803eb0 <__umoddi3+0x170>
  803e9e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  803ea1:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  803ea4:	76 0a                	jbe    803eb0 <__umoddi3+0x170>
  803ea6:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  803ea9:	29 f1                	sub    %esi,%ecx
  803eab:	19 fa                	sbb    %edi,%edx
  803ead:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  803eb0:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  803eb3:	85 c0                	test   %eax,%eax
  803eb5:	0f 84 ea fe ff ff    	je     803da5 <__umoddi3+0x65>
  803ebb:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  803ebe:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  803ec1:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  803ec4:	19 d1                	sbb    %edx,%ecx
  803ec6:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  803ec9:	89 ca                	mov    %ecx,%edx
  803ecb:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  803ece:	d3 e2                	shl    %cl,%edx
  803ed0:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  803ed3:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  803ed6:	d3 e8                	shr    %cl,%eax
  803ed8:	09 c2                	or     %eax,%edx
  803eda:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  803edd:	d3 e8                	shr    %cl,%eax
  803edf:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  803ee2:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  803ee5:	e9 ad fe ff ff       	jmp    803d97 <__umoddi3+0x57>
