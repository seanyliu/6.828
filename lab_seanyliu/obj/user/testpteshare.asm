
obj/user/testpteshare:     file format elf32-i386

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
  80002c:	e8 43 01 00 00       	call   800174 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
void childofspawn(void);

void
umain(int argc, char **argv)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	53                   	push   %ebx
  800038:	83 ec 04             	sub    $0x4,%esp
	int r;

	if (argc != 0)
  80003b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80003f:	74 05                	je     800046 <umain+0x12>
		childofspawn();
  800041:	e8 11 01 00 00       	call   800157 <childofspawn>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800046:	83 ec 04             	sub    $0x4,%esp
  800049:	68 07 04 00 00       	push   $0x407
  80004e:	68 00 00 00 a0       	push   $0xa0000000
  800053:	6a 00                	push   $0x0
  800055:	e8 3c 0c 00 00       	call   800c96 <sys_page_alloc>
  80005a:	83 c4 10             	add    $0x10,%esp
  80005d:	85 c0                	test   %eax,%eax
  80005f:	79 12                	jns    800073 <umain+0x3f>
		panic("sys_page_alloc: %e", r);
  800061:	50                   	push   %eax
  800062:	68 7e 2f 80 00       	push   $0x802f7e
  800067:	6a 13                	push   $0x13
  800069:	68 91 2f 80 00       	push   $0x802f91
  80006e:	e8 5d 01 00 00       	call   8001d0 <_panic>

	// check fork
	if ((r = fork()) < 0)
  800073:	e8 8e 11 00 00       	call   801206 <fork>
  800078:	89 c3                	mov    %eax,%ebx
  80007a:	85 c0                	test   %eax,%eax
  80007c:	79 12                	jns    800090 <umain+0x5c>
		panic("fork: %e", r);
  80007e:	50                   	push   %eax
  80007f:	68 a5 2f 80 00       	push   $0x802fa5
  800084:	6a 17                	push   $0x17
  800086:	68 91 2f 80 00       	push   $0x802f91
  80008b:	e8 40 01 00 00       	call   8001d0 <_panic>
	if (r == 0) {
  800090:	85 c0                	test   %eax,%eax
  800092:	75 1b                	jne    8000af <umain+0x7b>
		strcpy(VA, msg);
  800094:	83 ec 08             	sub    $0x8,%esp
  800097:	ff 35 00 70 80 00    	pushl  0x807000
  80009d:	68 00 00 00 a0       	push   $0xa0000000
  8000a2:	e8 1d 08 00 00       	call   8008c4 <strcpy>
		exit();
  8000a7:	e8 0c 01 00 00       	call   8001b8 <exit>
  8000ac:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	53                   	push   %ebx
  8000b3:	e8 34 28 00 00       	call   8028ec <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000b8:	83 c4 08             	add    $0x8,%esp
  8000bb:	ff 35 00 70 80 00    	pushl  0x807000
  8000c1:	68 00 00 00 a0       	push   $0xa0000000
  8000c6:	e8 7a 08 00 00       	call   800945 <strcmp>
  8000cb:	83 c4 08             	add    $0x8,%esp
  8000ce:	ba ae 2f 80 00       	mov    $0x802fae,%edx
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	74 05                	je     8000dc <umain+0xa8>
  8000d7:	ba b4 2f 80 00       	mov    $0x802fb4,%edx
  8000dc:	52                   	push   %edx
  8000dd:	68 ba 2f 80 00       	push   $0x802fba
  8000e2:	e8 d9 01 00 00       	call   8002c0 <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  8000e7:	6a 00                	push   $0x0
  8000e9:	68 d5 2f 80 00       	push   $0x802fd5
  8000ee:	68 da 2f 80 00       	push   $0x802fda
  8000f3:	68 d9 2f 80 00       	push   $0x802fd9
  8000f8:	e8 eb 20 00 00       	call   8021e8 <spawnl>
  8000fd:	83 c4 20             	add    $0x20,%esp
  800100:	85 c0                	test   %eax,%eax
  800102:	79 12                	jns    800116 <umain+0xe2>
		panic("spawn: %e", r);
  800104:	50                   	push   %eax
  800105:	68 e7 2f 80 00       	push   $0x802fe7
  80010a:	6a 21                	push   $0x21
  80010c:	68 91 2f 80 00       	push   $0x802f91
  800111:	e8 ba 00 00 00       	call   8001d0 <_panic>
	wait(r);
  800116:	83 ec 0c             	sub    $0xc,%esp
  800119:	50                   	push   %eax
  80011a:	e8 cd 27 00 00       	call   8028ec <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80011f:	83 c4 08             	add    $0x8,%esp
  800122:	ff 35 04 70 80 00    	pushl  0x807004
  800128:	68 00 00 00 a0       	push   $0xa0000000
  80012d:	e8 13 08 00 00       	call   800945 <strcmp>
  800132:	83 c4 08             	add    $0x8,%esp
  800135:	ba ae 2f 80 00       	mov    $0x802fae,%edx
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 05                	je     800143 <umain+0x10f>
  80013e:	ba b4 2f 80 00       	mov    $0x802fb4,%edx
  800143:	52                   	push   %edx
  800144:	68 f1 2f 80 00       	push   $0x802ff1
  800149:	e8 72 01 00 00       	call   8002c0 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
  80014e:	83 c4 10             	add    $0x10,%esp
	__asm __volatile("int3");
  800151:	cc                   	int3   

	breakpoint();
}
  800152:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <childofspawn>:

void
childofspawn(void)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	83 ec 10             	sub    $0x10,%esp
	strcpy(VA, msg2);
  80015d:	ff 35 04 70 80 00    	pushl  0x807004
  800163:	68 00 00 00 a0       	push   $0xa0000000
  800168:	e8 57 07 00 00       	call   8008c4 <strcpy>
	exit();
  80016d:	e8 46 00 00 00       	call   8001b8 <exit>
}
  800172:	c9                   	leave  
  800173:	c3                   	ret    

00800174 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	56                   	push   %esi
  800178:	53                   	push   %ebx
  800179:	8b 75 08             	mov    0x8(%ebp),%esi
  80017c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  80017f:	e8 d4 0a 00 00       	call   800c58 <sys_getenvid>
  800184:	25 ff 03 00 00       	and    $0x3ff,%eax
  800189:	c1 e0 07             	shl    $0x7,%eax
  80018c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800191:	a3 80 70 80 00       	mov    %eax,0x807080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	85 f6                	test   %esi,%esi
  800198:	7e 07                	jle    8001a1 <libmain+0x2d>
		binaryname = argv[0];
  80019a:	8b 03                	mov    (%ebx),%eax
  80019c:	a3 08 70 80 00       	mov    %eax,0x807008

	// call user main routine
	umain(argc, argv);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	53                   	push   %ebx
  8001a5:	56                   	push   %esi
  8001a6:	e8 89 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8001ab:	e8 08 00 00 00       	call   8001b8 <exit>
}
  8001b0:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8001b3:	5b                   	pop    %ebx
  8001b4:	5e                   	pop    %esi
  8001b5:	c9                   	leave  
  8001b6:	c3                   	ret    
	...

008001b8 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001be:	e8 9d 13 00 00       	call   801560 <close_all>
	sys_env_destroy(0);
  8001c3:	83 ec 0c             	sub    $0xc,%esp
  8001c6:	6a 00                	push   $0x0
  8001c8:	e8 4a 0a 00 00       	call   800c17 <sys_env_destroy>
}
  8001cd:	c9                   	leave  
  8001ce:	c3                   	ret    
	...

008001d0 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	53                   	push   %ebx
  8001d4:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  8001d7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  8001da:	83 3d 84 70 80 00 00 	cmpl   $0x0,0x807084
  8001e1:	74 16                	je     8001f9 <_panic+0x29>
		cprintf("%s: ", argv0);
  8001e3:	83 ec 08             	sub    $0x8,%esp
  8001e6:	ff 35 84 70 80 00    	pushl  0x807084
  8001ec:	68 24 30 80 00       	push   $0x803024
  8001f1:	e8 ca 00 00 00       	call   8002c0 <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001f9:	ff 75 0c             	pushl  0xc(%ebp)
  8001fc:	ff 75 08             	pushl  0x8(%ebp)
  8001ff:	ff 35 08 70 80 00    	pushl  0x807008
  800205:	68 29 30 80 00       	push   $0x803029
  80020a:	e8 b1 00 00 00       	call   8002c0 <cprintf>
	vcprintf(fmt, ap);
  80020f:	83 c4 08             	add    $0x8,%esp
  800212:	53                   	push   %ebx
  800213:	ff 75 10             	pushl  0x10(%ebp)
  800216:	e8 54 00 00 00       	call   80026f <vcprintf>
	cprintf("\n");
  80021b:	c7 04 24 d8 36 80 00 	movl   $0x8036d8,(%esp)
  800222:	e8 99 00 00 00       	call   8002c0 <cprintf>

	// Cause a breakpoint exception
	while (1)
  800227:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  80022a:	cc                   	int3   
  80022b:	eb fd                	jmp    80022a <_panic+0x5a>
  80022d:	00 00                	add    %al,(%eax)
	...

00800230 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	53                   	push   %ebx
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80023a:	8b 03                	mov    (%ebx),%eax
  80023c:	8b 55 08             	mov    0x8(%ebp),%edx
  80023f:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  800243:	40                   	inc    %eax
  800244:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800246:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024b:	75 1a                	jne    800267 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  80024d:	83 ec 08             	sub    $0x8,%esp
  800250:	68 ff 00 00 00       	push   $0xff
  800255:	8d 43 08             	lea    0x8(%ebx),%eax
  800258:	50                   	push   %eax
  800259:	e8 76 09 00 00       	call   800bd4 <sys_cputs>
		b->idx = 0;
  80025e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800264:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800267:	ff 43 04             	incl   0x4(%ebx)
}
  80026a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80026d:	c9                   	leave  
  80026e:	c3                   	ret    

0080026f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
  800272:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800278:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  80027f:	00 00 00 
	b.cnt = 0;
  800282:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800289:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80028c:	ff 75 0c             	pushl  0xc(%ebp)
  80028f:	ff 75 08             	pushl  0x8(%ebp)
  800292:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800298:	50                   	push   %eax
  800299:	68 30 02 80 00       	push   $0x800230
  80029e:	e8 4f 01 00 00       	call   8003f2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a3:	83 c4 08             	add    $0x8,%esp
  8002a6:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  8002ac:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  8002b2:	50                   	push   %eax
  8002b3:	e8 1c 09 00 00       	call   800bd4 <sys_cputs>

	return b.cnt;
  8002b8:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c9:	50                   	push   %eax
  8002ca:	ff 75 08             	pushl  0x8(%ebp)
  8002cd:	e8 9d ff ff ff       	call   80026f <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d2:	c9                   	leave  
  8002d3:	c3                   	ret    

008002d4 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d4:	55                   	push   %ebp
  8002d5:	89 e5                	mov    %esp,%ebp
  8002d7:	57                   	push   %edi
  8002d8:	56                   	push   %esi
  8002d9:	53                   	push   %ebx
  8002da:	83 ec 0c             	sub    $0xc,%esp
  8002dd:	8b 75 10             	mov    0x10(%ebp),%esi
  8002e0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002e3:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ee:	39 fa                	cmp    %edi,%edx
  8002f0:	77 39                	ja     80032b <printnum+0x57>
  8002f2:	72 04                	jb     8002f8 <printnum+0x24>
  8002f4:	39 f0                	cmp    %esi,%eax
  8002f6:	77 33                	ja     80032b <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	ff 75 20             	pushl  0x20(%ebp)
  8002fe:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  800301:	50                   	push   %eax
  800302:	ff 75 18             	pushl  0x18(%ebp)
  800305:	8b 45 18             	mov    0x18(%ebp),%eax
  800308:	ba 00 00 00 00       	mov    $0x0,%edx
  80030d:	52                   	push   %edx
  80030e:	50                   	push   %eax
  80030f:	57                   	push   %edi
  800310:	56                   	push   %esi
  800311:	e8 7e 29 00 00       	call   802c94 <__udivdi3>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	52                   	push   %edx
  80031a:	50                   	push   %eax
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	e8 ae ff ff ff       	call   8002d4 <printnum>
  800326:	83 c4 20             	add    $0x20,%esp
  800329:	eb 19                	jmp    800344 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032b:	4b                   	dec    %ebx
  80032c:	85 db                	test   %ebx,%ebx
  80032e:	7e 14                	jle    800344 <printnum+0x70>
  800330:	83 ec 08             	sub    $0x8,%esp
  800333:	ff 75 0c             	pushl  0xc(%ebp)
  800336:	ff 75 20             	pushl  0x20(%ebp)
  800339:	ff 55 08             	call   *0x8(%ebp)
  80033c:	83 c4 10             	add    $0x10,%esp
  80033f:	4b                   	dec    %ebx
  800340:	85 db                	test   %ebx,%ebx
  800342:	7f ec                	jg     800330 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800344:	83 ec 08             	sub    $0x8,%esp
  800347:	ff 75 0c             	pushl  0xc(%ebp)
  80034a:	8b 45 18             	mov    0x18(%ebp),%eax
  80034d:	ba 00 00 00 00       	mov    $0x0,%edx
  800352:	83 ec 04             	sub    $0x4,%esp
  800355:	52                   	push   %edx
  800356:	50                   	push   %eax
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	e8 42 2a 00 00       	call   802da0 <__umoddi3>
  80035e:	83 c4 14             	add    $0x14,%esp
  800361:	0f be 80 3f 31 80 00 	movsbl 0x80313f(%eax),%eax
  800368:	50                   	push   %eax
  800369:	ff 55 08             	call   *0x8(%ebp)
}
  80036c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80036f:	5b                   	pop    %ebx
  800370:	5e                   	pop    %esi
  800371:	5f                   	pop    %edi
  800372:	c9                   	leave  
  800373:	c3                   	ret    

00800374 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80037d:	83 f8 01             	cmp    $0x1,%eax
  800380:	7e 0f                	jle    800391 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  800382:	8b 01                	mov    (%ecx),%eax
  800384:	83 c0 08             	add    $0x8,%eax
  800387:	89 01                	mov    %eax,(%ecx)
  800389:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80038c:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80038f:	eb 24                	jmp    8003b5 <getuint+0x41>
	else if (lflag)
  800391:	85 c0                	test   %eax,%eax
  800393:	74 11                	je     8003a6 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800395:	8b 01                	mov    (%ecx),%eax
  800397:	83 c0 04             	add    $0x4,%eax
  80039a:	89 01                	mov    %eax,(%ecx)
  80039c:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80039f:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a4:	eb 0f                	jmp    8003b5 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  8003a6:	8b 01                	mov    (%ecx),%eax
  8003a8:	83 c0 04             	add    $0x4,%eax
  8003ab:	89 01                	mov    %eax,(%ecx)
  8003ad:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003b0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003b5:	c9                   	leave  
  8003b6:	c3                   	ret    

008003b7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003b7:	55                   	push   %ebp
  8003b8:	89 e5                	mov    %esp,%ebp
  8003ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8003c0:	83 f8 01             	cmp    $0x1,%eax
  8003c3:	7e 0f                	jle    8003d4 <getint+0x1d>
		return va_arg(*ap, long long);
  8003c5:	8b 02                	mov    (%edx),%eax
  8003c7:	83 c0 08             	add    $0x8,%eax
  8003ca:	89 02                	mov    %eax,(%edx)
  8003cc:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8003cf:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8003d2:	eb 1c                	jmp    8003f0 <getint+0x39>
	else if (lflag)
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	74 0d                	je     8003e5 <getint+0x2e>
		return va_arg(*ap, long);
  8003d8:	8b 02                	mov    (%edx),%eax
  8003da:	83 c0 04             	add    $0x4,%eax
  8003dd:	89 02                	mov    %eax,(%edx)
  8003df:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003e2:	99                   	cltd   
  8003e3:	eb 0b                	jmp    8003f0 <getint+0x39>
	else
		return va_arg(*ap, int);
  8003e5:	8b 02                	mov    (%edx),%eax
  8003e7:	83 c0 04             	add    $0x4,%eax
  8003ea:	89 02                	mov    %eax,(%edx)
  8003ec:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003ef:	99                   	cltd   
}
  8003f0:	c9                   	leave  
  8003f1:	c3                   	ret    

008003f2 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003f2:	55                   	push   %ebp
  8003f3:	89 e5                	mov    %esp,%ebp
  8003f5:	57                   	push   %edi
  8003f6:	56                   	push   %esi
  8003f7:	53                   	push   %ebx
  8003f8:	83 ec 1c             	sub    $0x1c,%esp
  8003fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  8003fe:	0f b6 13             	movzbl (%ebx),%edx
  800401:	43                   	inc    %ebx
  800402:	83 fa 25             	cmp    $0x25,%edx
  800405:	74 1e                	je     800425 <vprintfmt+0x33>
  800407:	85 d2                	test   %edx,%edx
  800409:	0f 84 d7 02 00 00    	je     8006e6 <vprintfmt+0x2f4>
  80040f:	83 ec 08             	sub    $0x8,%esp
  800412:	ff 75 0c             	pushl  0xc(%ebp)
  800415:	52                   	push   %edx
  800416:	ff 55 08             	call   *0x8(%ebp)
  800419:	83 c4 10             	add    $0x10,%esp
  80041c:	0f b6 13             	movzbl (%ebx),%edx
  80041f:	43                   	inc    %ebx
  800420:	83 fa 25             	cmp    $0x25,%edx
  800423:	75 e2                	jne    800407 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  800425:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  800429:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  800430:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  800435:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  80043a:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800441:	0f b6 13             	movzbl (%ebx),%edx
  800444:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  800447:	43                   	inc    %ebx
  800448:	83 f8 55             	cmp    $0x55,%eax
  80044b:	0f 87 70 02 00 00    	ja     8006c1 <vprintfmt+0x2cf>
  800451:	ff 24 85 bc 31 80 00 	jmp    *0x8031bc(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800458:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  80045c:	eb e3                	jmp    800441 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80045e:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  800462:	eb dd                	jmp    800441 <vprintfmt+0x4f>

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
  800464:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800469:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  80046c:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  800470:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800473:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  800476:	83 f8 09             	cmp    $0x9,%eax
  800479:	77 27                	ja     8004a2 <vprintfmt+0xb0>
  80047b:	43                   	inc    %ebx
  80047c:	eb eb                	jmp    800469 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80047e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800488:	eb 18                	jmp    8004a2 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  80048a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80048e:	79 b1                	jns    800441 <vprintfmt+0x4f>
				width = 0;
  800490:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800497:	eb a8                	jmp    800441 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800499:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  8004a0:	eb 9f                	jmp    800441 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  8004a2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004a6:	79 99                	jns    800441 <vprintfmt+0x4f>
				width = precision, precision = -1;
  8004a8:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8004ab:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  8004b0:	eb 8f                	jmp    800441 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004b2:	41                   	inc    %ecx
			goto reswitch;
  8004b3:	eb 8c                	jmp    800441 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	ff 75 0c             	pushl  0xc(%ebp)
  8004bb:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c2:	ff 70 fc             	pushl  0xfffffffc(%eax)
  8004c5:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004c8:	83 c4 10             	add    $0x10,%esp
  8004cb:	e9 2e ff ff ff       	jmp    8003fe <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004d0:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  8004da:	85 c0                	test   %eax,%eax
  8004dc:	79 02                	jns    8004e0 <vprintfmt+0xee>
				err = -err;
  8004de:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004e0:	83 f8 0e             	cmp    $0xe,%eax
  8004e3:	7f 0b                	jg     8004f0 <vprintfmt+0xfe>
  8004e5:	8b 3c 85 80 31 80 00 	mov    0x803180(,%eax,4),%edi
  8004ec:	85 ff                	test   %edi,%edi
  8004ee:	75 19                	jne    800509 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8004f0:	50                   	push   %eax
  8004f1:	68 50 31 80 00       	push   $0x803150
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	e8 ed 01 00 00       	call   8006ee <printfmt>
  800501:	83 c4 10             	add    $0x10,%esp
  800504:	e9 f5 fe ff ff       	jmp    8003fe <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800509:	57                   	push   %edi
  80050a:	68 c1 35 80 00       	push   $0x8035c1
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	ff 75 08             	pushl  0x8(%ebp)
  800515:	e8 d4 01 00 00       	call   8006ee <printfmt>
  80051a:	83 c4 10             	add    $0x10,%esp
			break;
  80051d:	e9 dc fe ff ff       	jmp    8003fe <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800522:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800526:	8b 45 14             	mov    0x14(%ebp),%eax
  800529:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  80052c:	85 ff                	test   %edi,%edi
  80052e:	75 05                	jne    800535 <vprintfmt+0x143>
				p = "(null)";
  800530:	bf 59 31 80 00       	mov    $0x803159,%edi
			if (width > 0 && padc != '-')
  800535:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800539:	7e 3b                	jle    800576 <vprintfmt+0x184>
  80053b:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  80053f:	74 35                	je     800576 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	56                   	push   %esi
  800545:	57                   	push   %edi
  800546:	e8 56 03 00 00       	call   8008a1 <strnlen>
  80054b:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  80054e:	83 c4 10             	add    $0x10,%esp
  800551:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800555:	7e 1f                	jle    800576 <vprintfmt+0x184>
  800557:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  80055b:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  80055e:	83 ec 08             	sub    $0x8,%esp
  800561:	ff 75 0c             	pushl  0xc(%ebp)
  800564:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  800567:	ff 55 08             	call   *0x8(%ebp)
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800570:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800574:	7f e8                	jg     80055e <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800576:	0f be 17             	movsbl (%edi),%edx
  800579:	47                   	inc    %edi
  80057a:	85 d2                	test   %edx,%edx
  80057c:	74 44                	je     8005c2 <vprintfmt+0x1d0>
  80057e:	85 f6                	test   %esi,%esi
  800580:	78 03                	js     800585 <vprintfmt+0x193>
  800582:	4e                   	dec    %esi
  800583:	78 3d                	js     8005c2 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800585:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800589:	74 18                	je     8005a3 <vprintfmt+0x1b1>
  80058b:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80058e:	83 f8 5e             	cmp    $0x5e,%eax
  800591:	76 10                	jbe    8005a3 <vprintfmt+0x1b1>
					putch('?', putdat);
  800593:	83 ec 08             	sub    $0x8,%esp
  800596:	ff 75 0c             	pushl  0xc(%ebp)
  800599:	6a 3f                	push   $0x3f
  80059b:	ff 55 08             	call   *0x8(%ebp)
  80059e:	83 c4 10             	add    $0x10,%esp
  8005a1:	eb 0d                	jmp    8005b0 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	ff 75 0c             	pushl  0xc(%ebp)
  8005a9:	52                   	push   %edx
  8005aa:	ff 55 08             	call   *0x8(%ebp)
  8005ad:	83 c4 10             	add    $0x10,%esp
  8005b0:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8005b3:	0f be 17             	movsbl (%edi),%edx
  8005b6:	47                   	inc    %edi
  8005b7:	85 d2                	test   %edx,%edx
  8005b9:	74 07                	je     8005c2 <vprintfmt+0x1d0>
  8005bb:	85 f6                	test   %esi,%esi
  8005bd:	78 c6                	js     800585 <vprintfmt+0x193>
  8005bf:	4e                   	dec    %esi
  8005c0:	79 c3                	jns    800585 <vprintfmt+0x193>
			for (; width > 0; width--)
  8005c2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005c6:	0f 8e 32 fe ff ff    	jle    8003fe <vprintfmt+0xc>
				putch(' ', putdat);
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	ff 75 0c             	pushl  0xc(%ebp)
  8005d2:	6a 20                	push   $0x20
  8005d4:	ff 55 08             	call   *0x8(%ebp)
  8005d7:	83 c4 10             	add    $0x10,%esp
  8005da:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8005dd:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005e1:	7f e9                	jg     8005cc <vprintfmt+0x1da>
			break;
  8005e3:	e9 16 fe ff ff       	jmp    8003fe <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005e8:	51                   	push   %ecx
  8005e9:	8d 45 14             	lea    0x14(%ebp),%eax
  8005ec:	50                   	push   %eax
  8005ed:	e8 c5 fd ff ff       	call   8003b7 <getint>
  8005f2:	89 c6                	mov    %eax,%esi
  8005f4:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8005f6:	83 c4 08             	add    $0x8,%esp
  8005f9:	85 d2                	test   %edx,%edx
  8005fb:	79 15                	jns    800612 <vprintfmt+0x220>
				putch('-', putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	ff 75 0c             	pushl  0xc(%ebp)
  800603:	6a 2d                	push   $0x2d
  800605:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800608:	f7 de                	neg    %esi
  80060a:	83 d7 00             	adc    $0x0,%edi
  80060d:	f7 df                	neg    %edi
  80060f:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800612:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800617:	eb 75                	jmp    80068e <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800619:	51                   	push   %ecx
  80061a:	8d 45 14             	lea    0x14(%ebp),%eax
  80061d:	50                   	push   %eax
  80061e:	e8 51 fd ff ff       	call   800374 <getuint>
  800623:	89 c6                	mov    %eax,%esi
  800625:	89 d7                	mov    %edx,%edi
			base = 10;
  800627:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  80062c:	83 c4 08             	add    $0x8,%esp
  80062f:	eb 5d                	jmp    80068e <vprintfmt+0x29c>

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
  800631:	51                   	push   %ecx
  800632:	8d 45 14             	lea    0x14(%ebp),%eax
  800635:	50                   	push   %eax
  800636:	e8 39 fd ff ff       	call   800374 <getuint>
  80063b:	89 c6                	mov    %eax,%esi
  80063d:	89 d7                	mov    %edx,%edi
			base = 8;
  80063f:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  800644:	83 c4 08             	add    $0x8,%esp
  800647:	eb 45                	jmp    80068e <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	ff 75 0c             	pushl  0xc(%ebp)
  80064f:	6a 30                	push   $0x30
  800651:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800654:	83 c4 08             	add    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	6a 78                	push   $0x78
  80065c:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80065f:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800669:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80066e:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	eb 16                	jmp    80068e <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800678:	51                   	push   %ecx
  800679:	8d 45 14             	lea    0x14(%ebp),%eax
  80067c:	50                   	push   %eax
  80067d:	e8 f2 fc ff ff       	call   800374 <getuint>
  800682:	89 c6                	mov    %eax,%esi
  800684:	89 d7                	mov    %edx,%edi
			base = 16;
  800686:	ba 10 00 00 00       	mov    $0x10,%edx
  80068b:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800695:	50                   	push   %eax
  800696:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800699:	52                   	push   %edx
  80069a:	57                   	push   %edi
  80069b:	56                   	push   %esi
  80069c:	ff 75 0c             	pushl  0xc(%ebp)
  80069f:	ff 75 08             	pushl  0x8(%ebp)
  8006a2:	e8 2d fc ff ff       	call   8002d4 <printnum>
			break;
  8006a7:	83 c4 20             	add    $0x20,%esp
  8006aa:	e9 4f fd ff ff       	jmp    8003fe <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006af:	83 ec 08             	sub    $0x8,%esp
  8006b2:	ff 75 0c             	pushl  0xc(%ebp)
  8006b5:	52                   	push   %edx
  8006b6:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006b9:	83 c4 10             	add    $0x10,%esp
  8006bc:	e9 3d fd ff ff       	jmp    8003fe <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006c1:	83 ec 08             	sub    $0x8,%esp
  8006c4:	ff 75 0c             	pushl  0xc(%ebp)
  8006c7:	6a 25                	push   $0x25
  8006c9:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006cc:	4b                   	dec    %ebx
  8006cd:	83 c4 10             	add    $0x10,%esp
  8006d0:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8006d4:	0f 84 24 fd ff ff    	je     8003fe <vprintfmt+0xc>
  8006da:	4b                   	dec    %ebx
  8006db:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8006df:	75 f9                	jne    8006da <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8006e1:	e9 18 fd ff ff       	jmp    8003fe <vprintfmt+0xc>
		}
	}
}
  8006e6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8006e9:	5b                   	pop    %ebx
  8006ea:	5e                   	pop    %esi
  8006eb:	5f                   	pop    %edi
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8006f4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006f7:	50                   	push   %eax
  8006f8:	ff 75 10             	pushl  0x10(%ebp)
  8006fb:	ff 75 0c             	pushl  0xc(%ebp)
  8006fe:	ff 75 08             	pushl  0x8(%ebp)
  800701:	e8 ec fc ff ff       	call   8003f2 <vprintfmt>
	va_end(ap);
}
  800706:	c9                   	leave  
  800707:	c3                   	ret    

00800708 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800708:	55                   	push   %ebp
  800709:	89 e5                	mov    %esp,%ebp
  80070b:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  80070e:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  800711:	8b 0a                	mov    (%edx),%ecx
  800713:	3b 4a 04             	cmp    0x4(%edx),%ecx
  800716:	73 07                	jae    80071f <sprintputch+0x17>
		*b->buf++ = ch;
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	88 01                	mov    %al,(%ecx)
  80071d:	ff 02                	incl   (%edx)
}
  80071f:	c9                   	leave  
  800720:	c3                   	ret    

00800721 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800721:	55                   	push   %ebp
  800722:	89 e5                	mov    %esp,%ebp
  800724:	83 ec 18             	sub    $0x18,%esp
  800727:	8b 55 08             	mov    0x8(%ebp),%edx
  80072a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80072d:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  800730:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800734:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  800737:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  80073e:	85 d2                	test   %edx,%edx
  800740:	74 04                	je     800746 <vsnprintf+0x25>
  800742:	85 c9                	test   %ecx,%ecx
  800744:	7f 07                	jg     80074d <vsnprintf+0x2c>
		return -E_INVAL;
  800746:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80074b:	eb 1d                	jmp    80076a <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80074d:	ff 75 14             	pushl  0x14(%ebp)
  800750:	ff 75 10             	pushl  0x10(%ebp)
  800753:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  800756:	50                   	push   %eax
  800757:	68 08 07 80 00       	push   $0x800708
  80075c:	e8 91 fc ff ff       	call   8003f2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800761:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800764:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800767:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  80076a:	c9                   	leave  
  80076b:	c3                   	ret    

0080076c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800772:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800775:	50                   	push   %eax
  800776:	ff 75 10             	pushl  0x10(%ebp)
  800779:	ff 75 0c             	pushl  0xc(%ebp)
  80077c:	ff 75 08             	pushl  0x8(%ebp)
  80077f:	e8 9d ff ff ff       	call   800721 <vsnprintf>
	va_end(ap);

	return rc;
}
  800784:	c9                   	leave  
  800785:	c3                   	ret    
	...

00800788 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	56                   	push   %esi
  80078c:	53                   	push   %ebx
  80078d:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	56                   	push   %esi
  800794:	e8 ef 00 00 00       	call   800888 <strlen>
  char letter;
  int hexnum = 0;
  800799:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80079e:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  8007a3:	83 c4 10             	add    $0x10,%esp
  8007a6:	89 c2                	mov    %eax,%edx
  8007a8:	4a                   	dec    %edx
  8007a9:	0f 88 d0 00 00 00    	js     80087f <strtoint+0xf7>
    letter = string[cidx];
  8007af:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  8007b2:	85 d2                	test   %edx,%edx
  8007b4:	75 12                	jne    8007c8 <strtoint+0x40>
      if (letter != '0') {
  8007b6:	3c 30                	cmp    $0x30,%al
  8007b8:	0f 84 ba 00 00 00    	je     800878 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8007be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8007c3:	e9 b9 00 00 00       	jmp    800881 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  8007c8:	83 fa 01             	cmp    $0x1,%edx
  8007cb:	75 12                	jne    8007df <strtoint+0x57>
      if (letter != 'x') {
  8007cd:	3c 78                	cmp    $0x78,%al
  8007cf:	0f 84 a3 00 00 00    	je     800878 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8007d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8007da:	e9 a2 00 00 00       	jmp    800881 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8007df:	0f be c0             	movsbl %al,%eax
  8007e2:	83 e8 30             	sub    $0x30,%eax
  8007e5:	83 f8 36             	cmp    $0x36,%eax
  8007e8:	0f 87 80 00 00 00    	ja     80086e <strtoint+0xe6>
  8007ee:	ff 24 85 14 33 80 00 	jmp    *0x803314(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8007f5:	01 cb                	add    %ecx,%ebx
          break;
  8007f7:	eb 7c                	jmp    800875 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8007f9:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8007fc:	eb 77                	jmp    800875 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8007fe:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800801:	01 c3                	add    %eax,%ebx
          break;
  800803:	eb 70                	jmp    800875 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  800805:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800808:	eb 6b                	jmp    800875 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  80080a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  80080d:	01 c3                	add    %eax,%ebx
          break;
  80080f:	eb 64                	jmp    800875 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  800811:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800814:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800817:	eb 5c                	jmp    800875 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800819:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800820:	29 c8                	sub    %ecx,%eax
  800822:	01 c3                	add    %eax,%ebx
          break;
  800824:	eb 4f                	jmp    800875 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  800826:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  800829:	eb 4a                	jmp    800875 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  80082b:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  80082e:	01 c3                	add    %eax,%ebx
          break;
  800830:	eb 43                	jmp    800875 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  800832:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800835:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800838:	eb 3b                	jmp    800875 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  80083a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  80083d:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  800840:	01 c3                	add    %eax,%ebx
          break;
  800842:	eb 31                	jmp    800875 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800844:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800847:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  80084a:	eb 29                	jmp    800875 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  80084c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80084f:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  800852:	01 c3                	add    %eax,%ebx
          break;
  800854:	eb 1f                	jmp    800875 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800856:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  80085d:	29 c8                	sub    %ecx,%eax
  80085f:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800862:	eb 11                	jmp    800875 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800864:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800867:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80086a:	01 c3                	add    %eax,%ebx
          break;
  80086c:	eb 07                	jmp    800875 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  80086e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800873:	eb 0c                	jmp    800881 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800875:	c1 e1 04             	shl    $0x4,%ecx
  800878:	4a                   	dec    %edx
  800879:	0f 89 30 ff ff ff    	jns    8007af <strtoint+0x27>
    }
  }

  return hexnum;
  80087f:	89 d8                	mov    %ebx,%eax
}
  800881:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800884:	5b                   	pop    %ebx
  800885:	5e                   	pop    %esi
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <strlen>:





int
strlen(const char *s)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80088e:	b8 00 00 00 00       	mov    $0x0,%eax
  800893:	80 3a 00             	cmpb   $0x0,(%edx)
  800896:	74 07                	je     80089f <strlen+0x17>
		n++;
  800898:	40                   	inc    %eax
  800899:	42                   	inc    %edx
  80089a:	80 3a 00             	cmpb   $0x0,(%edx)
  80089d:	75 f9                	jne    800898 <strlen+0x10>
	return n;
}
  80089f:	c9                   	leave  
  8008a0:	c3                   	ret    

008008a1 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8008af:	85 d2                	test   %edx,%edx
  8008b1:	74 0f                	je     8008c2 <strnlen+0x21>
  8008b3:	80 39 00             	cmpb   $0x0,(%ecx)
  8008b6:	74 0a                	je     8008c2 <strnlen+0x21>
		n++;
  8008b8:	40                   	inc    %eax
  8008b9:	41                   	inc    %ecx
  8008ba:	4a                   	dec    %edx
  8008bb:	74 05                	je     8008c2 <strnlen+0x21>
  8008bd:	80 39 00             	cmpb   $0x0,(%ecx)
  8008c0:	75 f6                	jne    8008b8 <strnlen+0x17>
	return n;
}
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	53                   	push   %ebx
  8008c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  8008ce:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  8008d0:	8a 02                	mov    (%edx),%al
  8008d2:	42                   	inc    %edx
  8008d3:	88 01                	mov    %al,(%ecx)
  8008d5:	41                   	inc    %ecx
  8008d6:	84 c0                	test   %al,%al
  8008d8:	75 f6                	jne    8008d0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008da:	89 d8                	mov    %ebx,%eax
  8008dc:	5b                   	pop    %ebx
  8008dd:	c9                   	leave  
  8008de:	c3                   	ret    

008008df <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	57                   	push   %edi
  8008e3:	56                   	push   %esi
  8008e4:	53                   	push   %ebx
  8008e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008eb:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  8008ee:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  8008f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008f5:	39 f3                	cmp    %esi,%ebx
  8008f7:	73 10                	jae    800909 <strncpy+0x2a>
		*dst++ = *src;
  8008f9:	8a 02                	mov    (%edx),%al
  8008fb:	88 01                	mov    %al,(%ecx)
  8008fd:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008fe:	80 3a 01             	cmpb   $0x1,(%edx)
  800901:	83 da ff             	sbb    $0xffffffff,%edx
  800904:	43                   	inc    %ebx
  800905:	39 f3                	cmp    %esi,%ebx
  800907:	72 f0                	jb     8008f9 <strncpy+0x1a>
	}
	return ret;
}
  800909:	89 f8                	mov    %edi,%eax
  80090b:	5b                   	pop    %ebx
  80090c:	5e                   	pop    %esi
  80090d:	5f                   	pop    %edi
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	56                   	push   %esi
  800914:	53                   	push   %ebx
  800915:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800918:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091b:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  80091e:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  800920:	85 d2                	test   %edx,%edx
  800922:	74 19                	je     80093d <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800924:	4a                   	dec    %edx
  800925:	74 13                	je     80093a <strlcpy+0x2a>
  800927:	80 39 00             	cmpb   $0x0,(%ecx)
  80092a:	74 0e                	je     80093a <strlcpy+0x2a>
  80092c:	8a 01                	mov    (%ecx),%al
  80092e:	41                   	inc    %ecx
  80092f:	88 03                	mov    %al,(%ebx)
  800931:	43                   	inc    %ebx
  800932:	4a                   	dec    %edx
  800933:	74 05                	je     80093a <strlcpy+0x2a>
  800935:	80 39 00             	cmpb   $0x0,(%ecx)
  800938:	75 f2                	jne    80092c <strlcpy+0x1c>
		*dst = '\0';
  80093a:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  80093d:	89 d8                	mov    %ebx,%eax
  80093f:	29 f0                	sub    %esi,%eax
}
  800941:	5b                   	pop    %ebx
  800942:	5e                   	pop    %esi
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
  800948:	8b 55 08             	mov    0x8(%ebp),%edx
  80094b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  80094e:	80 3a 00             	cmpb   $0x0,(%edx)
  800951:	74 13                	je     800966 <strcmp+0x21>
  800953:	8a 02                	mov    (%edx),%al
  800955:	3a 01                	cmp    (%ecx),%al
  800957:	75 0d                	jne    800966 <strcmp+0x21>
  800959:	42                   	inc    %edx
  80095a:	41                   	inc    %ecx
  80095b:	80 3a 00             	cmpb   $0x0,(%edx)
  80095e:	74 06                	je     800966 <strcmp+0x21>
  800960:	8a 02                	mov    (%edx),%al
  800962:	3a 01                	cmp    (%ecx),%al
  800964:	74 f3                	je     800959 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800966:	0f b6 02             	movzbl (%edx),%eax
  800969:	0f b6 11             	movzbl (%ecx),%edx
  80096c:	29 d0                	sub    %edx,%eax
}
  80096e:	c9                   	leave  
  80096f:	c3                   	ret    

00800970 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	53                   	push   %ebx
  800974:	8b 55 08             	mov    0x8(%ebp),%edx
  800977:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80097a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  80097d:	85 c9                	test   %ecx,%ecx
  80097f:	74 1f                	je     8009a0 <strncmp+0x30>
  800981:	80 3a 00             	cmpb   $0x0,(%edx)
  800984:	74 16                	je     80099c <strncmp+0x2c>
  800986:	8a 02                	mov    (%edx),%al
  800988:	3a 03                	cmp    (%ebx),%al
  80098a:	75 10                	jne    80099c <strncmp+0x2c>
  80098c:	42                   	inc    %edx
  80098d:	43                   	inc    %ebx
  80098e:	49                   	dec    %ecx
  80098f:	74 0f                	je     8009a0 <strncmp+0x30>
  800991:	80 3a 00             	cmpb   $0x0,(%edx)
  800994:	74 06                	je     80099c <strncmp+0x2c>
  800996:	8a 02                	mov    (%edx),%al
  800998:	3a 03                	cmp    (%ebx),%al
  80099a:	74 f0                	je     80098c <strncmp+0x1c>
	if (n == 0)
  80099c:	85 c9                	test   %ecx,%ecx
  80099e:	75 07                	jne    8009a7 <strncmp+0x37>
		return 0;
  8009a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009a5:	eb 0a                	jmp    8009b1 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a7:	0f b6 12             	movzbl (%edx),%edx
  8009aa:	0f b6 03             	movzbl (%ebx),%eax
  8009ad:	29 c2                	sub    %eax,%edx
  8009af:	89 d0                	mov    %edx,%eax
}
  8009b1:	5b                   	pop    %ebx
  8009b2:	c9                   	leave  
  8009b3:	c3                   	ret    

008009b4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8009bd:	80 38 00             	cmpb   $0x0,(%eax)
  8009c0:	74 0a                	je     8009cc <strchr+0x18>
		if (*s == c)
  8009c2:	38 10                	cmp    %dl,(%eax)
  8009c4:	74 0b                	je     8009d1 <strchr+0x1d>
  8009c6:	40                   	inc    %eax
  8009c7:	80 38 00             	cmpb   $0x0,(%eax)
  8009ca:	75 f6                	jne    8009c2 <strchr+0xe>
			return (char *) s;
	return 0;
  8009cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d1:	c9                   	leave  
  8009d2:	c3                   	ret    

008009d3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009d3:	55                   	push   %ebp
  8009d4:	89 e5                	mov    %esp,%ebp
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8009dc:	80 38 00             	cmpb   $0x0,(%eax)
  8009df:	74 0a                	je     8009eb <strfind+0x18>
		if (*s == c)
  8009e1:	38 10                	cmp    %dl,(%eax)
  8009e3:	74 06                	je     8009eb <strfind+0x18>
  8009e5:	40                   	inc    %eax
  8009e6:	80 38 00             	cmpb   $0x0,(%eax)
  8009e9:	75 f6                	jne    8009e1 <strfind+0xe>
			break;
	return (char *) s;
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	57                   	push   %edi
  8009f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  8009f7:	89 f8                	mov    %edi,%eax
  8009f9:	85 c9                	test   %ecx,%ecx
  8009fb:	74 40                	je     800a3d <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  8009fd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a03:	75 30                	jne    800a35 <memset+0x48>
  800a05:	f6 c1 03             	test   $0x3,%cl
  800a08:	75 2b                	jne    800a35 <memset+0x48>
		c &= 0xFF;
  800a0a:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a14:	c1 e0 18             	shl    $0x18,%eax
  800a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1a:	c1 e2 10             	shl    $0x10,%edx
  800a1d:	09 d0                	or     %edx,%eax
  800a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a22:	c1 e2 08             	shl    $0x8,%edx
  800a25:	09 d0                	or     %edx,%eax
  800a27:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800a2a:	c1 e9 02             	shr    $0x2,%ecx
  800a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a30:	fc                   	cld    
  800a31:	f3 ab                	repz stos %eax,%es:(%edi)
  800a33:	eb 06                	jmp    800a3b <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a38:	fc                   	cld    
  800a39:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800a3b:	89 f8                	mov    %edi,%eax
}
  800a3d:	5f                   	pop    %edi
  800a3e:	c9                   	leave  
  800a3f:	c3                   	ret    

00800a40 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	57                   	push   %edi
  800a44:	56                   	push   %esi
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800a4b:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a4e:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a50:	39 c6                	cmp    %eax,%esi
  800a52:	73 33                	jae    800a87 <memmove+0x47>
  800a54:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a57:	39 c2                	cmp    %eax,%edx
  800a59:	76 2c                	jbe    800a87 <memmove+0x47>
		s += n;
  800a5b:	89 d6                	mov    %edx,%esi
		d += n;
  800a5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a60:	f6 c2 03             	test   $0x3,%dl
  800a63:	75 1b                	jne    800a80 <memmove+0x40>
  800a65:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a6b:	75 13                	jne    800a80 <memmove+0x40>
  800a6d:	f6 c1 03             	test   $0x3,%cl
  800a70:	75 0e                	jne    800a80 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800a72:	83 ef 04             	sub    $0x4,%edi
  800a75:	83 ee 04             	sub    $0x4,%esi
  800a78:	c1 e9 02             	shr    $0x2,%ecx
  800a7b:	fd                   	std    
  800a7c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800a7e:	eb 27                	jmp    800aa7 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a80:	4f                   	dec    %edi
  800a81:	4e                   	dec    %esi
  800a82:	fd                   	std    
  800a83:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800a85:	eb 20                	jmp    800aa7 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a87:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a8d:	75 15                	jne    800aa4 <memmove+0x64>
  800a8f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a95:	75 0d                	jne    800aa4 <memmove+0x64>
  800a97:	f6 c1 03             	test   $0x3,%cl
  800a9a:	75 08                	jne    800aa4 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800a9c:	c1 e9 02             	shr    $0x2,%ecx
  800a9f:	fc                   	cld    
  800aa0:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800aa2:	eb 03                	jmp    800aa7 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aa4:	fc                   	cld    
  800aa5:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa7:	5e                   	pop    %esi
  800aa8:	5f                   	pop    %edi
  800aa9:	c9                   	leave  
  800aaa:	c3                   	ret    

00800aab <memcpy>:

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
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800aae:	ff 75 10             	pushl  0x10(%ebp)
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	ff 75 08             	pushl  0x8(%ebp)
  800ab7:	e8 84 ff ff ff       	call   800a40 <memmove>
}
  800abc:	c9                   	leave  
  800abd:	c3                   	ret    

00800abe <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800ac2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800ac5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ac8:	8b 55 10             	mov    0x10(%ebp),%edx
  800acb:	4a                   	dec    %edx
  800acc:	83 fa ff             	cmp    $0xffffffff,%edx
  800acf:	74 1a                	je     800aeb <memcmp+0x2d>
  800ad1:	8a 01                	mov    (%ecx),%al
  800ad3:	3a 03                	cmp    (%ebx),%al
  800ad5:	74 0c                	je     800ae3 <memcmp+0x25>
  800ad7:	0f b6 d0             	movzbl %al,%edx
  800ada:	0f b6 03             	movzbl (%ebx),%eax
  800add:	29 c2                	sub    %eax,%edx
  800adf:	89 d0                	mov    %edx,%eax
  800ae1:	eb 0d                	jmp    800af0 <memcmp+0x32>
  800ae3:	41                   	inc    %ecx
  800ae4:	43                   	inc    %ebx
  800ae5:	4a                   	dec    %edx
  800ae6:	83 fa ff             	cmp    $0xffffffff,%edx
  800ae9:	75 e6                	jne    800ad1 <memcmp+0x13>
	}

	return 0;
  800aeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af0:	5b                   	pop    %ebx
  800af1:	c9                   	leave  
  800af2:	c3                   	ret    

00800af3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b01:	39 d0                	cmp    %edx,%eax
  800b03:	73 09                	jae    800b0e <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b05:	38 08                	cmp    %cl,(%eax)
  800b07:	74 05                	je     800b0e <memfind+0x1b>
  800b09:	40                   	inc    %eax
  800b0a:	39 d0                	cmp    %edx,%eax
  800b0c:	72 f7                	jb     800b05 <memfind+0x12>
			break;
	return (void *) s;
}
  800b0e:	c9                   	leave  
  800b0f:	c3                   	ret    

00800b10 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	57                   	push   %edi
  800b14:	56                   	push   %esi
  800b15:	53                   	push   %ebx
  800b16:	8b 55 08             	mov    0x8(%ebp),%edx
  800b19:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800b1f:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800b24:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800b29:	80 3a 20             	cmpb   $0x20,(%edx)
  800b2c:	74 05                	je     800b33 <strtol+0x23>
  800b2e:	80 3a 09             	cmpb   $0x9,(%edx)
  800b31:	75 0b                	jne    800b3e <strtol+0x2e>
  800b33:	42                   	inc    %edx
  800b34:	80 3a 20             	cmpb   $0x20,(%edx)
  800b37:	74 fa                	je     800b33 <strtol+0x23>
  800b39:	80 3a 09             	cmpb   $0x9,(%edx)
  800b3c:	74 f5                	je     800b33 <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800b3e:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800b41:	75 03                	jne    800b46 <strtol+0x36>
		s++;
  800b43:	42                   	inc    %edx
  800b44:	eb 0b                	jmp    800b51 <strtol+0x41>
	else if (*s == '-')
  800b46:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800b49:	75 06                	jne    800b51 <strtol+0x41>
		s++, neg = 1;
  800b4b:	42                   	inc    %edx
  800b4c:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b51:	85 c9                	test   %ecx,%ecx
  800b53:	74 05                	je     800b5a <strtol+0x4a>
  800b55:	83 f9 10             	cmp    $0x10,%ecx
  800b58:	75 15                	jne    800b6f <strtol+0x5f>
  800b5a:	80 3a 30             	cmpb   $0x30,(%edx)
  800b5d:	75 10                	jne    800b6f <strtol+0x5f>
  800b5f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b63:	75 0a                	jne    800b6f <strtol+0x5f>
		s += 2, base = 16;
  800b65:	83 c2 02             	add    $0x2,%edx
  800b68:	b9 10 00 00 00       	mov    $0x10,%ecx
  800b6d:	eb 14                	jmp    800b83 <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800b6f:	85 c9                	test   %ecx,%ecx
  800b71:	75 10                	jne    800b83 <strtol+0x73>
  800b73:	80 3a 30             	cmpb   $0x30,(%edx)
  800b76:	75 05                	jne    800b7d <strtol+0x6d>
		s++, base = 8;
  800b78:	42                   	inc    %edx
  800b79:	b1 08                	mov    $0x8,%cl
  800b7b:	eb 06                	jmp    800b83 <strtol+0x73>
	else if (base == 0)
  800b7d:	85 c9                	test   %ecx,%ecx
  800b7f:	75 02                	jne    800b83 <strtol+0x73>
		base = 10;
  800b81:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b83:	8a 02                	mov    (%edx),%al
  800b85:	83 e8 30             	sub    $0x30,%eax
  800b88:	3c 09                	cmp    $0x9,%al
  800b8a:	77 08                	ja     800b94 <strtol+0x84>
			dig = *s - '0';
  800b8c:	0f be 02             	movsbl (%edx),%eax
  800b8f:	83 e8 30             	sub    $0x30,%eax
  800b92:	eb 20                	jmp    800bb4 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800b94:	8a 02                	mov    (%edx),%al
  800b96:	83 e8 61             	sub    $0x61,%eax
  800b99:	3c 19                	cmp    $0x19,%al
  800b9b:	77 08                	ja     800ba5 <strtol+0x95>
			dig = *s - 'a' + 10;
  800b9d:	0f be 02             	movsbl (%edx),%eax
  800ba0:	83 e8 57             	sub    $0x57,%eax
  800ba3:	eb 0f                	jmp    800bb4 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800ba5:	8a 02                	mov    (%edx),%al
  800ba7:	83 e8 41             	sub    $0x41,%eax
  800baa:	3c 19                	cmp    $0x19,%al
  800bac:	77 12                	ja     800bc0 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800bae:	0f be 02             	movsbl (%edx),%eax
  800bb1:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800bb4:	39 c8                	cmp    %ecx,%eax
  800bb6:	7d 08                	jge    800bc0 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800bb8:	42                   	inc    %edx
  800bb9:	0f af d9             	imul   %ecx,%ebx
  800bbc:	01 c3                	add    %eax,%ebx
  800bbe:	eb c3                	jmp    800b83 <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bc0:	85 f6                	test   %esi,%esi
  800bc2:	74 02                	je     800bc6 <strtol+0xb6>
		*endptr = (char *) s;
  800bc4:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bc6:	89 d8                	mov    %ebx,%eax
  800bc8:	85 ff                	test   %edi,%edi
  800bca:	74 02                	je     800bce <strtol+0xbe>
  800bcc:	f7 d8                	neg    %eax
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	c9                   	leave  
  800bd2:	c3                   	ret    
	...

00800bd4 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
  800bda:	83 ec 04             	sub    $0x4,%esp
  800bdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800be0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be3:	bf 00 00 00 00       	mov    $0x0,%edi
  800be8:	89 f8                	mov    %edi,%eax
  800bea:	89 fb                	mov    %edi,%ebx
  800bec:	89 fe                	mov    %edi,%esi
  800bee:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bf0:	83 c4 04             	add    $0x4,%esp
  800bf3:	5b                   	pop    %ebx
  800bf4:	5e                   	pop    %esi
  800bf5:	5f                   	pop    %edi
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	57                   	push   %edi
  800bfc:	56                   	push   %esi
  800bfd:	53                   	push   %ebx
  800bfe:	b8 01 00 00 00       	mov    $0x1,%eax
  800c03:	bf 00 00 00 00       	mov    $0x0,%edi
  800c08:	89 fa                	mov    %edi,%edx
  800c0a:	89 f9                	mov    %edi,%ecx
  800c0c:	89 fb                	mov    %edi,%ebx
  800c0e:	89 fe                	mov    %edi,%esi
  800c10:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c12:	5b                   	pop    %ebx
  800c13:	5e                   	pop    %esi
  800c14:	5f                   	pop    %edi
  800c15:	c9                   	leave  
  800c16:	c3                   	ret    

00800c17 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	83 ec 0c             	sub    $0xc,%esp
  800c20:	8b 55 08             	mov    0x8(%ebp),%edx
  800c23:	b8 03 00 00 00       	mov    $0x3,%eax
  800c28:	bf 00 00 00 00       	mov    $0x0,%edi
  800c2d:	89 f9                	mov    %edi,%ecx
  800c2f:	89 fb                	mov    %edi,%ebx
  800c31:	89 fe                	mov    %edi,%esi
  800c33:	cd 30                	int    $0x30
  800c35:	85 c0                	test   %eax,%eax
  800c37:	7e 17                	jle    800c50 <sys_env_destroy+0x39>
  800c39:	83 ec 0c             	sub    $0xc,%esp
  800c3c:	50                   	push   %eax
  800c3d:	6a 03                	push   $0x3
  800c3f:	68 f0 33 80 00       	push   $0x8033f0
  800c44:	6a 23                	push   $0x23
  800c46:	68 0d 34 80 00       	push   $0x80340d
  800c4b:	e8 80 f5 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c50:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	57                   	push   %edi
  800c5c:	56                   	push   %esi
  800c5d:	53                   	push   %ebx
  800c5e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c63:	bf 00 00 00 00       	mov    $0x0,%edi
  800c68:	89 fa                	mov    %edi,%edx
  800c6a:	89 f9                	mov    %edi,%ecx
  800c6c:	89 fb                	mov    %edi,%ebx
  800c6e:	89 fe                	mov    %edi,%esi
  800c70:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c72:	5b                   	pop    %ebx
  800c73:	5e                   	pop    %esi
  800c74:	5f                   	pop    %edi
  800c75:	c9                   	leave  
  800c76:	c3                   	ret    

00800c77 <sys_yield>:

void
sys_yield(void)
{
  800c77:	55                   	push   %ebp
  800c78:	89 e5                	mov    %esp,%ebp
  800c7a:	57                   	push   %edi
  800c7b:	56                   	push   %esi
  800c7c:	53                   	push   %ebx
  800c7d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c82:	bf 00 00 00 00       	mov    $0x0,%edi
  800c87:	89 fa                	mov    %edi,%edx
  800c89:	89 f9                	mov    %edi,%ecx
  800c8b:	89 fb                	mov    %edi,%ebx
  800c8d:	89 fe                	mov    %edi,%esi
  800c8f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
  800c9c:	83 ec 0c             	sub    $0xc,%esp
  800c9f:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca8:	b8 04 00 00 00       	mov    $0x4,%eax
  800cad:	bf 00 00 00 00       	mov    $0x0,%edi
  800cb2:	89 fe                	mov    %edi,%esi
  800cb4:	cd 30                	int    $0x30
  800cb6:	85 c0                	test   %eax,%eax
  800cb8:	7e 17                	jle    800cd1 <sys_page_alloc+0x3b>
  800cba:	83 ec 0c             	sub    $0xc,%esp
  800cbd:	50                   	push   %eax
  800cbe:	6a 04                	push   $0x4
  800cc0:	68 f0 33 80 00       	push   $0x8033f0
  800cc5:	6a 23                	push   $0x23
  800cc7:	68 0d 34 80 00       	push   $0x80340d
  800ccc:	e8 ff f4 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	83 ec 0c             	sub    $0xc,%esp
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ceb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cee:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf1:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf6:	cd 30                	int    $0x30
  800cf8:	85 c0                	test   %eax,%eax
  800cfa:	7e 17                	jle    800d13 <sys_page_map+0x3a>
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	50                   	push   %eax
  800d00:	6a 05                	push   $0x5
  800d02:	68 f0 33 80 00       	push   $0x8033f0
  800d07:	6a 23                	push   $0x23
  800d09:	68 0d 34 80 00       	push   $0x80340d
  800d0e:	e8 bd f4 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d13:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	b8 06 00 00 00       	mov    $0x6,%eax
  800d2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d34:	89 fb                	mov    %edi,%ebx
  800d36:	89 fe                	mov    %edi,%esi
  800d38:	cd 30                	int    $0x30
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	7e 17                	jle    800d55 <sys_page_unmap+0x3a>
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 06                	push   $0x6
  800d44:	68 f0 33 80 00       	push   $0x8033f0
  800d49:	6a 23                	push   $0x23
  800d4b:	68 0d 34 80 00       	push   $0x80340d
  800d50:	e8 7b f4 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d55:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5f                   	pop    %edi
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	57                   	push   %edi
  800d61:	56                   	push   %esi
  800d62:	53                   	push   %ebx
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	b8 08 00 00 00       	mov    $0x8,%eax
  800d71:	bf 00 00 00 00       	mov    $0x0,%edi
  800d76:	89 fb                	mov    %edi,%ebx
  800d78:	89 fe                	mov    %edi,%esi
  800d7a:	cd 30                	int    $0x30
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	7e 17                	jle    800d97 <sys_env_set_status+0x3a>
  800d80:	83 ec 0c             	sub    $0xc,%esp
  800d83:	50                   	push   %eax
  800d84:	6a 08                	push   $0x8
  800d86:	68 f0 33 80 00       	push   $0x8033f0
  800d8b:	6a 23                	push   $0x23
  800d8d:	68 0d 34 80 00       	push   $0x80340d
  800d92:	e8 39 f4 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d97:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
  800da5:	83 ec 0c             	sub    $0xc,%esp
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dae:	b8 09 00 00 00       	mov    $0x9,%eax
  800db3:	bf 00 00 00 00       	mov    $0x0,%edi
  800db8:	89 fb                	mov    %edi,%ebx
  800dba:	89 fe                	mov    %edi,%esi
  800dbc:	cd 30                	int    $0x30
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	7e 17                	jle    800dd9 <sys_env_set_trapframe+0x3a>
  800dc2:	83 ec 0c             	sub    $0xc,%esp
  800dc5:	50                   	push   %eax
  800dc6:	6a 09                	push   $0x9
  800dc8:	68 f0 33 80 00       	push   $0x8033f0
  800dcd:	6a 23                	push   $0x23
  800dcf:	68 0d 34 80 00       	push   $0x80340d
  800dd4:	e8 f7 f3 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dd9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ddc:	5b                   	pop    %ebx
  800ddd:	5e                   	pop    %esi
  800dde:	5f                   	pop    %edi
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	57                   	push   %edi
  800de5:	56                   	push   %esi
  800de6:	53                   	push   %ebx
  800de7:	83 ec 0c             	sub    $0xc,%esp
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df5:	bf 00 00 00 00       	mov    $0x0,%edi
  800dfa:	89 fb                	mov    %edi,%ebx
  800dfc:	89 fe                	mov    %edi,%esi
  800dfe:	cd 30                	int    $0x30
  800e00:	85 c0                	test   %eax,%eax
  800e02:	7e 17                	jle    800e1b <sys_env_set_pgfault_upcall+0x3a>
  800e04:	83 ec 0c             	sub    $0xc,%esp
  800e07:	50                   	push   %eax
  800e08:	6a 0a                	push   $0xa
  800e0a:	68 f0 33 80 00       	push   $0x8033f0
  800e0f:	6a 23                	push   $0x23
  800e11:	68 0d 34 80 00       	push   $0x80340d
  800e16:	e8 b5 f3 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	c9                   	leave  
  800e22:	c3                   	ret    

00800e23 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e32:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e35:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3a:	be 00 00 00 00       	mov    $0x0,%esi
  800e3f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e52:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e57:	bf 00 00 00 00       	mov    $0x0,%edi
  800e5c:	89 f9                	mov    %edi,%ecx
  800e5e:	89 fb                	mov    %edi,%ebx
  800e60:	89 fe                	mov    %edi,%esi
  800e62:	cd 30                	int    $0x30
  800e64:	85 c0                	test   %eax,%eax
  800e66:	7e 17                	jle    800e7f <sys_ipc_recv+0x39>
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	50                   	push   %eax
  800e6c:	6a 0d                	push   $0xd
  800e6e:	68 f0 33 80 00       	push   $0x8033f0
  800e73:	6a 23                	push   $0x23
  800e75:	68 0d 34 80 00       	push   $0x80340d
  800e7a:	e8 51 f3 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	83 ec 0c             	sub    $0xc,%esp
  800e90:	8b 55 08             	mov    0x8(%ebp),%edx
  800e93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e96:	b8 10 00 00 00       	mov    $0x10,%eax
  800e9b:	bf 00 00 00 00       	mov    $0x0,%edi
  800ea0:	89 fb                	mov    %edi,%ebx
  800ea2:	89 fe                	mov    %edi,%esi
  800ea4:	cd 30                	int    $0x30
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	7e 17                	jle    800ec1 <sys_transmit_packet+0x3a>
  800eaa:	83 ec 0c             	sub    $0xc,%esp
  800ead:	50                   	push   %eax
  800eae:	6a 10                	push   $0x10
  800eb0:	68 f0 33 80 00       	push   $0x8033f0
  800eb5:	6a 23                	push   $0x23
  800eb7:	68 0d 34 80 00       	push   $0x80340d
  800ebc:	e8 0f f3 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800ec1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 0c             	sub    $0xc,%esp
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed8:	b8 11 00 00 00       	mov    $0x11,%eax
  800edd:	bf 00 00 00 00       	mov    $0x0,%edi
  800ee2:	89 fb                	mov    %edi,%ebx
  800ee4:	89 fe                	mov    %edi,%esi
  800ee6:	cd 30                	int    $0x30
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	7e 17                	jle    800f03 <sys_receive_packet+0x3a>
  800eec:	83 ec 0c             	sub    $0xc,%esp
  800eef:	50                   	push   %eax
  800ef0:	6a 11                	push   $0x11
  800ef2:	68 f0 33 80 00       	push   $0x8033f0
  800ef7:	6a 23                	push   $0x23
  800ef9:	68 0d 34 80 00       	push   $0x80340d
  800efe:	e8 cd f2 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800f03:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5f                   	pop    %edi
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
  800f11:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f16:	bf 00 00 00 00       	mov    $0x0,%edi
  800f1b:	89 fa                	mov    %edi,%edx
  800f1d:	89 f9                	mov    %edi,%ecx
  800f1f:	89 fb                	mov    %edi,%ebx
  800f21:	89 fe                	mov    %edi,%esi
  800f23:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f25:	5b                   	pop    %ebx
  800f26:	5e                   	pop    %esi
  800f27:	5f                   	pop    %edi
  800f28:	c9                   	leave  
  800f29:	c3                   	ret    

00800f2a <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
  800f30:	83 ec 0c             	sub    $0xc,%esp
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f3b:	bf 00 00 00 00       	mov    $0x0,%edi
  800f40:	89 f9                	mov    %edi,%ecx
  800f42:	89 fb                	mov    %edi,%ebx
  800f44:	89 fe                	mov    %edi,%esi
  800f46:	cd 30                	int    $0x30
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	7e 17                	jle    800f63 <sys_map_receive_buffers+0x39>
  800f4c:	83 ec 0c             	sub    $0xc,%esp
  800f4f:	50                   	push   %eax
  800f50:	6a 0e                	push   $0xe
  800f52:	68 f0 33 80 00       	push   $0x8033f0
  800f57:	6a 23                	push   $0x23
  800f59:	68 0d 34 80 00       	push   $0x80340d
  800f5e:	e8 6d f2 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800f63:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	c9                   	leave  
  800f6a:	c3                   	ret    

00800f6b <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
  800f71:	83 ec 0c             	sub    $0xc,%esp
  800f74:	8b 55 08             	mov    0x8(%ebp),%edx
  800f77:	b8 12 00 00 00       	mov    $0x12,%eax
  800f7c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f81:	89 f9                	mov    %edi,%ecx
  800f83:	89 fb                	mov    %edi,%ebx
  800f85:	89 fe                	mov    %edi,%esi
  800f87:	cd 30                	int    $0x30
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	7e 17                	jle    800fa4 <sys_receive_packet_zerocopy+0x39>
  800f8d:	83 ec 0c             	sub    $0xc,%esp
  800f90:	50                   	push   %eax
  800f91:	6a 12                	push   $0x12
  800f93:	68 f0 33 80 00       	push   $0x8033f0
  800f98:	6a 23                	push   $0x23
  800f9a:	68 0d 34 80 00       	push   $0x80340d
  800f9f:	e8 2c f2 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800fa4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	c9                   	leave  
  800fab:	c3                   	ret    

00800fac <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	57                   	push   %edi
  800fb0:	56                   	push   %esi
  800fb1:	53                   	push   %ebx
  800fb2:	83 ec 0c             	sub    $0xc,%esp
  800fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbb:	b8 13 00 00 00       	mov    $0x13,%eax
  800fc0:	bf 00 00 00 00       	mov    $0x0,%edi
  800fc5:	89 fb                	mov    %edi,%ebx
  800fc7:	89 fe                	mov    %edi,%esi
  800fc9:	cd 30                	int    $0x30
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	7e 17                	jle    800fe6 <sys_env_set_priority+0x3a>
  800fcf:	83 ec 0c             	sub    $0xc,%esp
  800fd2:	50                   	push   %eax
  800fd3:	6a 13                	push   $0x13
  800fd5:	68 f0 33 80 00       	push   $0x8033f0
  800fda:	6a 23                	push   $0x23
  800fdc:	68 0d 34 80 00       	push   $0x80340d
  800fe1:	e8 ea f1 ff ff       	call   8001d0 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800fe6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fe9:	5b                   	pop    %ebx
  800fea:	5e                   	pop    %esi
  800feb:	5f                   	pop    %edi
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    
	...

00800ff0 <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 04             	sub    $0x4,%esp
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ffa:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
	int r;

	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
        // seanyliu
        if (!(err & FEC_WR) || !(vpt[VPN(addr)] & PTE_COW)) {
  800ffc:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801000:	74 11                	je     801013 <pgfault+0x23>
  801002:	89 d8                	mov    %ebx,%eax
  801004:	c1 e8 0c             	shr    $0xc,%eax
  801007:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80100e:	f6 c4 08             	test   $0x8,%ah
  801011:	75 14                	jne    801027 <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  801013:	83 ec 04             	sub    $0x4,%esp
  801016:	68 1c 34 80 00       	push   $0x80341c
  80101b:	6a 1e                	push   $0x1e
  80101d:	68 70 34 80 00       	push   $0x803470
  801022:	e8 a9 f1 ff ff       	call   8001d0 <_panic>
        }

	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        // seanyliu
        addr = ROUNDDOWN(addr, PGSIZE);
  801027:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  80102d:	83 ec 04             	sub    $0x4,%esp
  801030:	6a 07                	push   $0x7
  801032:	68 00 f0 7f 00       	push   $0x7ff000
  801037:	83 ec 04             	sub    $0x4,%esp
  80103a:	e8 19 fc ff ff       	call   800c58 <sys_getenvid>
  80103f:	89 04 24             	mov    %eax,(%esp)
  801042:	e8 4f fc ff ff       	call   800c96 <sys_page_alloc>
  801047:	83 c4 10             	add    $0x10,%esp
  80104a:	85 c0                	test   %eax,%eax
  80104c:	79 12                	jns    801060 <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  80104e:	50                   	push   %eax
  80104f:	68 7b 34 80 00       	push   $0x80347b
  801054:	6a 2d                	push   $0x2d
  801056:	68 70 34 80 00       	push   $0x803470
  80105b:	e8 70 f1 ff ff       	call   8001d0 <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  801060:	83 ec 04             	sub    $0x4,%esp
  801063:	68 00 10 00 00       	push   $0x1000
  801068:	53                   	push   %ebx
  801069:	68 00 f0 7f 00       	push   $0x7ff000
  80106e:	e8 cd f9 ff ff       	call   800a40 <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  801073:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80107a:	53                   	push   %ebx
  80107b:	83 ec 0c             	sub    $0xc,%esp
  80107e:	e8 d5 fb ff ff       	call   800c58 <sys_getenvid>
  801083:	83 c4 0c             	add    $0xc,%esp
  801086:	50                   	push   %eax
  801087:	68 00 f0 7f 00       	push   $0x7ff000
  80108c:	83 ec 04             	sub    $0x4,%esp
  80108f:	e8 c4 fb ff ff       	call   800c58 <sys_getenvid>
  801094:	89 04 24             	mov    %eax,(%esp)
  801097:	e8 3d fc ff ff       	call   800cd9 <sys_page_map>
  80109c:	83 c4 20             	add    $0x20,%esp
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	79 12                	jns    8010b5 <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  8010a3:	50                   	push   %eax
  8010a4:	68 96 34 80 00       	push   $0x803496
  8010a9:	6a 33                	push   $0x33
  8010ab:	68 70 34 80 00       	push   $0x803470
  8010b0:	e8 1b f1 ff ff       	call   8001d0 <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  8010b5:	83 ec 08             	sub    $0x8,%esp
  8010b8:	68 00 f0 7f 00       	push   $0x7ff000
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	e8 93 fb ff ff       	call   800c58 <sys_getenvid>
  8010c5:	89 04 24             	mov    %eax,(%esp)
  8010c8:	e8 4e fc ff ff       	call   800d1b <sys_page_unmap>
  8010cd:	83 c4 10             	add    $0x10,%esp
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	79 12                	jns    8010e6 <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  8010d4:	50                   	push   %eax
  8010d5:	68 af 34 80 00       	push   $0x8034af
  8010da:	6a 36                	push   $0x36
  8010dc:	68 70 34 80 00       	push   $0x803470
  8010e1:	e8 ea f0 ff ff       	call   8001d0 <_panic>
        }

	//panic("pgfault not implemented");
}
  8010e6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <duppage>:

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why might we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
// 
static int
duppage(envid_t envid, unsigned pn)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	53                   	push   %ebx
  8010ef:	83 ec 04             	sub    $0x4,%esp
  8010f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  8010f8:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  8010fd:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801100:	f6 c4 04             	test   $0x4,%ah
  801103:	74 36                	je     80113b <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  801105:	83 ec 0c             	sub    $0xc,%esp
  801108:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  80110b:	25 07 0e 00 00       	and    $0xe07,%eax
  801110:	50                   	push   %eax
  801111:	89 d8                	mov    %ebx,%eax
  801113:	c1 e0 0c             	shl    $0xc,%eax
  801116:	50                   	push   %eax
  801117:	51                   	push   %ecx
  801118:	50                   	push   %eax
  801119:	83 ec 04             	sub    $0x4,%esp
  80111c:	e8 37 fb ff ff       	call   800c58 <sys_getenvid>
  801121:	89 04 24             	mov    %eax,(%esp)
  801124:	e8 b0 fb ff ff       	call   800cd9 <sys_page_map>
  801129:	83 c4 20             	add    $0x20,%esp
            return r;
  80112c:	89 c2                	mov    %eax,%edx
  80112e:	85 c0                	test   %eax,%eax
  801130:	0f 88 c9 00 00 00    	js     8011ff <duppage+0x114>
  801136:	e9 bf 00 00 00       	jmp    8011fa <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  80113b:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  801142:	a9 02 08 00 00       	test   $0x802,%eax
  801147:	74 7b                	je     8011c4 <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801149:	83 ec 0c             	sub    $0xc,%esp
  80114c:	68 05 08 00 00       	push   $0x805
  801151:	89 d8                	mov    %ebx,%eax
  801153:	c1 e0 0c             	shl    $0xc,%eax
  801156:	50                   	push   %eax
  801157:	51                   	push   %ecx
  801158:	50                   	push   %eax
  801159:	83 ec 04             	sub    $0x4,%esp
  80115c:	e8 f7 fa ff ff       	call   800c58 <sys_getenvid>
  801161:	89 04 24             	mov    %eax,(%esp)
  801164:	e8 70 fb ff ff       	call   800cd9 <sys_page_map>
  801169:	83 c4 20             	add    $0x20,%esp
  80116c:	85 c0                	test   %eax,%eax
  80116e:	79 12                	jns    801182 <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  801170:	50                   	push   %eax
  801171:	68 ca 34 80 00       	push   $0x8034ca
  801176:	6a 56                	push   $0x56
  801178:	68 70 34 80 00       	push   $0x803470
  80117d:	e8 4e f0 ff ff       	call   8001d0 <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801182:	83 ec 0c             	sub    $0xc,%esp
  801185:	68 05 08 00 00       	push   $0x805
  80118a:	c1 e3 0c             	shl    $0xc,%ebx
  80118d:	53                   	push   %ebx
  80118e:	83 ec 0c             	sub    $0xc,%esp
  801191:	e8 c2 fa ff ff       	call   800c58 <sys_getenvid>
  801196:	83 c4 0c             	add    $0xc,%esp
  801199:	50                   	push   %eax
  80119a:	53                   	push   %ebx
  80119b:	83 ec 04             	sub    $0x4,%esp
  80119e:	e8 b5 fa ff ff       	call   800c58 <sys_getenvid>
  8011a3:	89 04 24             	mov    %eax,(%esp)
  8011a6:	e8 2e fb ff ff       	call   800cd9 <sys_page_map>
  8011ab:	83 c4 20             	add    $0x20,%esp
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	79 48                	jns    8011fa <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  8011b2:	50                   	push   %eax
  8011b3:	68 ca 34 80 00       	push   $0x8034ca
  8011b8:	6a 5b                	push   $0x5b
  8011ba:	68 70 34 80 00       	push   $0x803470
  8011bf:	e8 0c f0 ff ff       	call   8001d0 <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  8011c4:	83 ec 0c             	sub    $0xc,%esp
  8011c7:	6a 05                	push   $0x5
  8011c9:	89 d8                	mov    %ebx,%eax
  8011cb:	c1 e0 0c             	shl    $0xc,%eax
  8011ce:	50                   	push   %eax
  8011cf:	51                   	push   %ecx
  8011d0:	50                   	push   %eax
  8011d1:	83 ec 04             	sub    $0x4,%esp
  8011d4:	e8 7f fa ff ff       	call   800c58 <sys_getenvid>
  8011d9:	89 04 24             	mov    %eax,(%esp)
  8011dc:	e8 f8 fa ff ff       	call   800cd9 <sys_page_map>
  8011e1:	83 c4 20             	add    $0x20,%esp
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	79 12                	jns    8011fa <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  8011e8:	50                   	push   %eax
  8011e9:	68 ca 34 80 00       	push   $0x8034ca
  8011ee:	6a 5f                	push   $0x5f
  8011f0:	68 70 34 80 00       	push   $0x803470
  8011f5:	e8 d6 ef ff ff       	call   8001d0 <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  8011fa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8011ff:	89 d0                	mov    %edx,%eax
  801201:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <fork>:

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use vpd, vpt, and duppage.
//   Remember to fix "env" and the user exception stack in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//

envid_t
fork(void)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	57                   	push   %edi
  80120a:	56                   	push   %esi
  80120b:	53                   	push   %ebx
  80120c:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  80120f:	68 f0 0f 80 00       	push   $0x800ff0
  801214:	e8 c3 18 00 00       	call   802adc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  801219:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  80121c:	ba 07 00 00 00       	mov    $0x7,%edx
  801221:	89 d0                	mov    %edx,%eax
  801223:	cd 30                	int    $0x30
  801225:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  801228:	85 c0                	test   %eax,%eax
  80122a:	79 15                	jns    801241 <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  80122c:	50                   	push   %eax
  80122d:	68 50 34 80 00       	push   $0x803450
  801232:	68 85 00 00 00       	push   $0x85
  801237:	68 70 34 80 00       	push   $0x803470
  80123c:	e8 8f ef ff ff       	call   8001d0 <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  801241:	bf 00 00 00 00       	mov    $0x0,%edi
  801246:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80124a:	75 21                	jne    80126d <fork+0x67>
  80124c:	e8 07 fa ff ff       	call   800c58 <sys_getenvid>
  801251:	25 ff 03 00 00       	and    $0x3ff,%eax
  801256:	c1 e0 07             	shl    $0x7,%eax
  801259:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80125e:	a3 80 70 80 00       	mov    %eax,0x807080
  801263:	ba 00 00 00 00       	mov    $0x0,%edx
  801268:	e9 fd 00 00 00       	jmp    80136a <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  80126d:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  801274:	a8 01                	test   $0x1,%al
  801276:	74 5f                	je     8012d7 <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  801278:	bb 00 00 00 00       	mov    $0x0,%ebx
  80127d:	89 f8                	mov    %edi,%eax
  80127f:	c1 e0 0a             	shl    $0xa,%eax
  801282:	89 c2                	mov    %eax,%edx
  801284:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801289:	77 4c                	ja     8012d7 <fork+0xd1>
  80128b:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  80128d:	01 da                	add    %ebx,%edx
  80128f:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801296:	a8 01                	test   $0x1,%al
  801298:	74 28                	je     8012c2 <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  80129a:	83 ec 08             	sub    $0x8,%esp
  80129d:	52                   	push   %edx
  80129e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8012a1:	e8 45 fe ff ff       	call   8010eb <duppage>
  8012a6:	83 c4 10             	add    $0x10,%esp
  8012a9:	85 c0                	test   %eax,%eax
  8012ab:	79 15                	jns    8012c2 <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  8012ad:	50                   	push   %eax
  8012ae:	68 e3 34 80 00       	push   $0x8034e3
  8012b3:	68 95 00 00 00       	push   $0x95
  8012b8:	68 70 34 80 00       	push   $0x803470
  8012bd:	e8 0e ef ff ff       	call   8001d0 <_panic>
  8012c2:	43                   	inc    %ebx
  8012c3:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  8012c9:	7f 0c                	jg     8012d7 <fork+0xd1>
  8012cb:	89 f2                	mov    %esi,%edx
  8012cd:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8012d0:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  8012d5:	76 b6                	jbe    80128d <fork+0x87>
  8012d7:	47                   	inc    %edi
  8012d8:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  8012de:	76 8d                	jbe    80126d <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8012e0:	83 ec 04             	sub    $0x4,%esp
  8012e3:	6a 07                	push   $0x7
  8012e5:	68 00 f0 bf ee       	push   $0xeebff000
  8012ea:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8012ed:	e8 a4 f9 ff ff       	call   800c96 <sys_page_alloc>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	79 15                	jns    80130e <fork+0x108>
          panic("fork: %d", r);
  8012f9:	50                   	push   %eax
  8012fa:	68 fc 34 80 00       	push   $0x8034fc
  8012ff:	68 9d 00 00 00       	push   $0x9d
  801304:	68 70 34 80 00       	push   $0x803470
  801309:	e8 c2 ee ff ff       	call   8001d0 <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  80130e:	83 ec 08             	sub    $0x8,%esp
  801311:	a1 80 70 80 00       	mov    0x807080,%eax
  801316:	8b 40 64             	mov    0x64(%eax),%eax
  801319:	50                   	push   %eax
  80131a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80131d:	e8 bf fa ff ff       	call   800de1 <sys_env_set_pgfault_upcall>
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	79 15                	jns    80133e <fork+0x138>
          panic("fork: %d", r);
  801329:	50                   	push   %eax
  80132a:	68 fc 34 80 00       	push   $0x8034fc
  80132f:	68 a2 00 00 00       	push   $0xa2
  801334:	68 70 34 80 00       	push   $0x803470
  801339:	e8 92 ee ff ff       	call   8001d0 <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  80133e:	83 ec 08             	sub    $0x8,%esp
  801341:	6a 01                	push   $0x1
  801343:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801346:	e8 12 fa ff ff       	call   800d5d <sys_env_set_status>
  80134b:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  80134e:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801351:	85 c0                	test   %eax,%eax
  801353:	79 15                	jns    80136a <fork+0x164>
  801355:	50                   	push   %eax
  801356:	68 fc 34 80 00       	push   $0x8034fc
  80135b:	68 a7 00 00 00       	push   $0xa7
  801360:	68 70 34 80 00       	push   $0x803470
  801365:	e8 66 ee ff ff       	call   8001d0 <_panic>
 
	//panic("fork not implemented");
}
  80136a:	89 d0                	mov    %edx,%eax
  80136c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80136f:	5b                   	pop    %ebx
  801370:	5e                   	pop    %esi
  801371:	5f                   	pop    %edi
  801372:	c9                   	leave  
  801373:	c3                   	ret    

00801374 <sfork>:



// Challenge!
int
sfork(void)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80137a:	68 05 35 80 00       	push   $0x803505
  80137f:	68 b5 00 00 00       	push   $0xb5
  801384:	68 70 34 80 00       	push   $0x803470
  801389:	e8 42 ee ff ff       	call   8001d0 <_panic>
	...

00801390 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801396:	ff 75 08             	pushl  0x8(%ebp)
  801399:	e8 0a 00 00 00       	call   8013a8 <fd2num>
  80139e:	c1 e0 16             	shl    $0x16,%eax
  8013a1:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <fd2num>:

int
fd2num(struct Fd *fd)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	05 00 00 40 30       	add    $0x30400000,%eax
  8013b3:	c1 e8 0c             	shr    $0xc,%eax
}
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <fd_alloc>:

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
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	57                   	push   %edi
  8013bc:	56                   	push   %esi
  8013bd:	53                   	push   %ebx
  8013be:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013c6:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  8013cb:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  8013d0:	89 c8                	mov    %ecx,%eax
  8013d2:	c1 e0 0c             	shl    $0xc,%eax
  8013d5:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8013db:	89 d0                	mov    %edx,%eax
  8013dd:	c1 e8 16             	shr    $0x16,%eax
  8013e0:	8b 04 86             	mov    (%esi,%eax,4),%eax
  8013e3:	a8 01                	test   $0x1,%al
  8013e5:	74 0c                	je     8013f3 <fd_alloc+0x3b>
  8013e7:	89 d0                	mov    %edx,%eax
  8013e9:	c1 e8 0c             	shr    $0xc,%eax
  8013ec:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  8013ef:	a8 01                	test   $0x1,%al
  8013f1:	75 09                	jne    8013fc <fd_alloc+0x44>
			*fd_store = fd;
  8013f3:	89 17                	mov    %edx,(%edi)
			return 0;
  8013f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013fa:	eb 11                	jmp    80140d <fd_alloc+0x55>
  8013fc:	41                   	inc    %ecx
  8013fd:	83 f9 1f             	cmp    $0x1f,%ecx
  801400:	7e ce                	jle    8013d0 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  801402:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801408:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80140d:	5b                   	pop    %ebx
  80140e:	5e                   	pop    %esi
  80140f:	5f                   	pop    %edi
  801410:	c9                   	leave  
  801411:	c3                   	ret    

00801412 <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801418:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80141d:	83 f8 1f             	cmp    $0x1f,%eax
  801420:	77 3a                	ja     80145c <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  801422:	c1 e0 0c             	shl    $0xc,%eax
  801425:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  80142b:	89 d0                	mov    %edx,%eax
  80142d:	c1 e8 16             	shr    $0x16,%eax
  801430:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801437:	a8 01                	test   $0x1,%al
  801439:	74 10                	je     80144b <fd_lookup+0x39>
  80143b:	89 d0                	mov    %edx,%eax
  80143d:	c1 e8 0c             	shr    $0xc,%eax
  801440:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801447:	a8 01                	test   $0x1,%al
  801449:	75 07                	jne    801452 <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  80144b:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801450:	eb 0a                	jmp    80145c <fd_lookup+0x4a>
	}
	*fd_store = fd;
  801452:	8b 45 0c             	mov    0xc(%ebp),%eax
  801455:	89 10                	mov    %edx,(%eax)
	return 0;
  801457:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80145c:	89 d0                	mov    %edx,%eax
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <fd_close>:

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
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	56                   	push   %esi
  801464:	53                   	push   %ebx
  801465:	83 ec 10             	sub    $0x10,%esp
  801468:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80146b:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80146e:	50                   	push   %eax
  80146f:	56                   	push   %esi
  801470:	e8 33 ff ff ff       	call   8013a8 <fd2num>
  801475:	89 04 24             	mov    %eax,(%esp)
  801478:	e8 95 ff ff ff       	call   801412 <fd_lookup>
  80147d:	89 c3                	mov    %eax,%ebx
  80147f:	83 c4 08             	add    $0x8,%esp
  801482:	85 c0                	test   %eax,%eax
  801484:	78 05                	js     80148b <fd_close+0x2b>
  801486:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  801489:	74 0f                	je     80149a <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80148b:	89 d8                	mov    %ebx,%eax
  80148d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801491:	75 3a                	jne    8014cd <fd_close+0x6d>
  801493:	b8 00 00 00 00       	mov    $0x0,%eax
  801498:	eb 33                	jmp    8014cd <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  80149a:	83 ec 08             	sub    $0x8,%esp
  80149d:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8014a0:	50                   	push   %eax
  8014a1:	ff 36                	pushl  (%esi)
  8014a3:	e8 2c 00 00 00       	call   8014d4 <dev_lookup>
  8014a8:	89 c3                	mov    %eax,%ebx
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 0f                	js     8014c0 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8014b1:	83 ec 0c             	sub    $0xc,%esp
  8014b4:	56                   	push   %esi
  8014b5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8014b8:	ff 50 10             	call   *0x10(%eax)
  8014bb:	89 c3                	mov    %eax,%ebx
  8014bd:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	56                   	push   %esi
  8014c4:	6a 00                	push   $0x0
  8014c6:	e8 50 f8 ff ff       	call   800d1b <sys_page_unmap>
	return r;
  8014cb:	89 d8                	mov    %ebx,%eax
}
  8014cd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8014d0:	5b                   	pop    %ebx
  8014d1:	5e                   	pop    %esi
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <dev_lookup>:


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
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	56                   	push   %esi
  8014d8:	53                   	push   %ebx
  8014d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8014dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  8014df:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e4:	83 3d 0c 70 80 00 00 	cmpl   $0x0,0x80700c
  8014eb:	74 1c                	je     801509 <dev_lookup+0x35>
  8014ed:	b9 0c 70 80 00       	mov    $0x80700c,%ecx
		if (devtab[i]->dev_id == dev_id) {
  8014f2:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  8014f5:	39 18                	cmp    %ebx,(%eax)
  8014f7:	75 09                	jne    801502 <dev_lookup+0x2e>
			*dev = devtab[i];
  8014f9:	89 06                	mov    %eax,(%esi)
			return 0;
  8014fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801500:	eb 29                	jmp    80152b <dev_lookup+0x57>
  801502:	42                   	inc    %edx
  801503:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  801507:	75 e9                	jne    8014f2 <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801509:	83 ec 04             	sub    $0x4,%esp
  80150c:	53                   	push   %ebx
  80150d:	a1 80 70 80 00       	mov    0x807080,%eax
  801512:	8b 40 4c             	mov    0x4c(%eax),%eax
  801515:	50                   	push   %eax
  801516:	68 1c 35 80 00       	push   $0x80351c
  80151b:	e8 a0 ed ff ff       	call   8002c0 <cprintf>
	*dev = 0;
  801520:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  801526:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80152b:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80152e:	5b                   	pop    %ebx
  80152f:	5e                   	pop    %esi
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <close>:

int
close(int fdnum)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801538:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	ff 75 08             	pushl  0x8(%ebp)
  80153f:	e8 ce fe ff ff       	call   801412 <fd_lookup>
  801544:	83 c4 08             	add    $0x8,%esp
		return r;
  801547:	89 c2                	mov    %eax,%edx
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 0f                	js     80155c <close+0x2a>
	else
		return fd_close(fd, 1);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	6a 01                	push   $0x1
  801552:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801555:	e8 06 ff ff ff       	call   801460 <fd_close>
  80155a:	89 c2                	mov    %eax,%edx
}
  80155c:	89 d0                	mov    %edx,%eax
  80155e:	c9                   	leave  
  80155f:	c3                   	ret    

00801560 <close_all>:

void
close_all(void)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	53                   	push   %ebx
  801564:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801567:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80156c:	83 ec 0c             	sub    $0xc,%esp
  80156f:	53                   	push   %ebx
  801570:	e8 bd ff ff ff       	call   801532 <close>
  801575:	83 c4 10             	add    $0x10,%esp
  801578:	43                   	inc    %ebx
  801579:	83 fb 1f             	cmp    $0x1f,%ebx
  80157c:	7e ee                	jle    80156c <close_all+0xc>
}
  80157e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	57                   	push   %edi
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
  801589:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80158c:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80158f:	50                   	push   %eax
  801590:	ff 75 08             	pushl  0x8(%ebp)
  801593:	e8 7a fe ff ff       	call   801412 <fd_lookup>
  801598:	89 c6                	mov    %eax,%esi
  80159a:	83 c4 08             	add    $0x8,%esp
  80159d:	85 f6                	test   %esi,%esi
  80159f:	0f 88 f8 00 00 00    	js     80169d <dup+0x11a>
		return r;
	close(newfdnum);
  8015a5:	83 ec 0c             	sub    $0xc,%esp
  8015a8:	ff 75 0c             	pushl  0xc(%ebp)
  8015ab:	e8 82 ff ff ff       	call   801532 <close>

	newfd = INDEX2FD(newfdnum);
  8015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b3:	c1 e0 0c             	shl    $0xc,%eax
  8015b6:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8015bb:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8015be:	83 c4 04             	add    $0x4,%esp
  8015c1:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8015c4:	e8 c7 fd ff ff       	call   801390 <fd2data>
  8015c9:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8015cb:	83 c4 04             	add    $0x4,%esp
  8015ce:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8015d1:	e8 ba fd ff ff       	call   801390 <fd2data>
  8015d6:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  8015d9:	89 f8                	mov    %edi,%eax
  8015db:	c1 e8 16             	shr    $0x16,%eax
  8015de:	83 c4 10             	add    $0x10,%esp
  8015e1:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	74 48                	je     801634 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8015ec:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  8015f1:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  8015f4:	89 d0                	mov    %edx,%eax
  8015f6:	c1 e8 0c             	shr    $0xc,%eax
  8015f9:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  801600:	a8 01                	test   $0x1,%al
  801602:	74 22                	je     801626 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801604:	83 ec 0c             	sub    $0xc,%esp
  801607:	25 07 0e 00 00       	and    $0xe07,%eax
  80160c:	50                   	push   %eax
  80160d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801610:	01 d8                	add    %ebx,%eax
  801612:	50                   	push   %eax
  801613:	6a 00                	push   $0x0
  801615:	52                   	push   %edx
  801616:	6a 00                	push   $0x0
  801618:	e8 bc f6 ff ff       	call   800cd9 <sys_page_map>
  80161d:	89 c6                	mov    %eax,%esi
  80161f:	83 c4 20             	add    $0x20,%esp
  801622:	85 c0                	test   %eax,%eax
  801624:	78 3f                	js     801665 <dup+0xe2>
  801626:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80162c:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801632:	7e bd                	jle    8015f1 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801634:	83 ec 0c             	sub    $0xc,%esp
  801637:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80163a:	89 d0                	mov    %edx,%eax
  80163c:	c1 e8 0c             	shr    $0xc,%eax
  80163f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801646:	25 07 0e 00 00       	and    $0xe07,%eax
  80164b:	50                   	push   %eax
  80164c:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80164f:	6a 00                	push   $0x0
  801651:	52                   	push   %edx
  801652:	6a 00                	push   $0x0
  801654:	e8 80 f6 ff ff       	call   800cd9 <sys_page_map>
  801659:	89 c6                	mov    %eax,%esi
  80165b:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80165e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801661:	85 f6                	test   %esi,%esi
  801663:	79 38                	jns    80169d <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801665:	83 ec 08             	sub    $0x8,%esp
  801668:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80166b:	6a 00                	push   $0x0
  80166d:	e8 a9 f6 ff ff       	call   800d1b <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801672:	bb 00 00 00 00       	mov    $0x0,%ebx
  801677:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  80167a:	83 ec 08             	sub    $0x8,%esp
  80167d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801680:	01 d8                	add    %ebx,%eax
  801682:	50                   	push   %eax
  801683:	6a 00                	push   $0x0
  801685:	e8 91 f6 ff ff       	call   800d1b <sys_page_unmap>
  80168a:	83 c4 10             	add    $0x10,%esp
  80168d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801693:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801699:	7e df                	jle    80167a <dup+0xf7>
	return r;
  80169b:	89 f0                	mov    %esi,%eax
}
  80169d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8016a0:	5b                   	pop    %ebx
  8016a1:	5e                   	pop    %esi
  8016a2:	5f                   	pop    %edi
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	53                   	push   %ebx
  8016a9:	83 ec 14             	sub    $0x14,%esp
  8016ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016af:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8016b2:	50                   	push   %eax
  8016b3:	53                   	push   %ebx
  8016b4:	e8 59 fd ff ff       	call   801412 <fd_lookup>
  8016b9:	89 c2                	mov    %eax,%edx
  8016bb:	83 c4 08             	add    $0x8,%esp
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	78 1a                	js     8016dc <read+0x37>
  8016c2:	83 ec 08             	sub    $0x8,%esp
  8016c5:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8016c8:	50                   	push   %eax
  8016c9:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016cc:	ff 30                	pushl  (%eax)
  8016ce:	e8 01 fe ff ff       	call   8014d4 <dev_lookup>
  8016d3:	89 c2                	mov    %eax,%edx
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	79 04                	jns    8016e0 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8016dc:	89 d0                	mov    %edx,%eax
  8016de:	eb 50                	jmp    801730 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016e0:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016e3:	8b 40 08             	mov    0x8(%eax),%eax
  8016e6:	83 e0 03             	and    $0x3,%eax
  8016e9:	83 f8 01             	cmp    $0x1,%eax
  8016ec:	75 1e                	jne    80170c <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8016ee:	83 ec 04             	sub    $0x4,%esp
  8016f1:	53                   	push   %ebx
  8016f2:	a1 80 70 80 00       	mov    0x807080,%eax
  8016f7:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016fa:	50                   	push   %eax
  8016fb:	68 5d 35 80 00       	push   $0x80355d
  801700:	e8 bb eb ff ff       	call   8002c0 <cprintf>
		return -E_INVAL;
  801705:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170a:	eb 24                	jmp    801730 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  80170c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80170f:	ff 70 04             	pushl  0x4(%eax)
  801712:	ff 75 10             	pushl  0x10(%ebp)
  801715:	ff 75 0c             	pushl  0xc(%ebp)
  801718:	50                   	push   %eax
  801719:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80171c:	ff 50 08             	call   *0x8(%eax)
  80171f:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	85 c0                	test   %eax,%eax
  801726:	78 06                	js     80172e <read+0x89>
		fd->fd_offset += r;
  801728:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80172b:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80172e:	89 d0                	mov    %edx,%eax
}
  801730:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	57                   	push   %edi
  801739:	56                   	push   %esi
  80173a:	53                   	push   %ebx
  80173b:	83 ec 0c             	sub    $0xc,%esp
  80173e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801741:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801744:	bb 00 00 00 00       	mov    $0x0,%ebx
  801749:	39 f3                	cmp    %esi,%ebx
  80174b:	73 25                	jae    801772 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	89 f0                	mov    %esi,%eax
  801752:	29 d8                	sub    %ebx,%eax
  801754:	50                   	push   %eax
  801755:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801758:	50                   	push   %eax
  801759:	ff 75 08             	pushl  0x8(%ebp)
  80175c:	e8 44 ff ff ff       	call   8016a5 <read>
		if (m < 0)
  801761:	83 c4 10             	add    $0x10,%esp
  801764:	85 c0                	test   %eax,%eax
  801766:	78 0c                	js     801774 <readn+0x3f>
			return m;
		if (m == 0)
  801768:	85 c0                	test   %eax,%eax
  80176a:	74 06                	je     801772 <readn+0x3d>
  80176c:	01 c3                	add    %eax,%ebx
  80176e:	39 f3                	cmp    %esi,%ebx
  801770:	72 db                	jb     80174d <readn+0x18>
			break;
	}
	return tot;
  801772:	89 d8                	mov    %ebx,%eax
}
  801774:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801777:	5b                   	pop    %ebx
  801778:	5e                   	pop    %esi
  801779:	5f                   	pop    %edi
  80177a:	c9                   	leave  
  80177b:	c3                   	ret    

0080177c <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	53                   	push   %ebx
  801780:	83 ec 14             	sub    $0x14,%esp
  801783:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801786:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801789:	50                   	push   %eax
  80178a:	53                   	push   %ebx
  80178b:	e8 82 fc ff ff       	call   801412 <fd_lookup>
  801790:	89 c2                	mov    %eax,%edx
  801792:	83 c4 08             	add    $0x8,%esp
  801795:	85 c0                	test   %eax,%eax
  801797:	78 1a                	js     8017b3 <write+0x37>
  801799:	83 ec 08             	sub    $0x8,%esp
  80179c:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80179f:	50                   	push   %eax
  8017a0:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017a3:	ff 30                	pushl  (%eax)
  8017a5:	e8 2a fd ff ff       	call   8014d4 <dev_lookup>
  8017aa:	89 c2                	mov    %eax,%edx
  8017ac:	83 c4 10             	add    $0x10,%esp
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	79 04                	jns    8017b7 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8017b3:	89 d0                	mov    %edx,%eax
  8017b5:	eb 4b                	jmp    801802 <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017b7:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017be:	75 1e                	jne    8017de <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	53                   	push   %ebx
  8017c4:	a1 80 70 80 00       	mov    0x807080,%eax
  8017c9:	8b 40 4c             	mov    0x4c(%eax),%eax
  8017cc:	50                   	push   %eax
  8017cd:	68 79 35 80 00       	push   $0x803579
  8017d2:	e8 e9 ea ff ff       	call   8002c0 <cprintf>
		return -E_INVAL;
  8017d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017dc:	eb 24                	jmp    801802 <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8017de:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017e1:	ff 70 04             	pushl  0x4(%eax)
  8017e4:	ff 75 10             	pushl  0x10(%ebp)
  8017e7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ea:	50                   	push   %eax
  8017eb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8017ee:	ff 50 0c             	call   *0xc(%eax)
  8017f1:	89 c2                	mov    %eax,%edx
	if (r > 0)
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	7e 06                	jle    801800 <write+0x84>
		fd->fd_offset += r;
  8017fa:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017fd:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801800:	89 d0                	mov    %edx,%eax
}
  801802:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <seek>:

int
seek(int fdnum, off_t offset)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80180d:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801810:	50                   	push   %eax
  801811:	ff 75 08             	pushl  0x8(%ebp)
  801814:	e8 f9 fb ff ff       	call   801412 <fd_lookup>
  801819:	83 c4 08             	add    $0x8,%esp
		return r;
  80181c:	89 c2                	mov    %eax,%edx
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 0e                	js     801830 <seek+0x29>
	fd->fd_offset = offset;
  801822:	8b 55 0c             	mov    0xc(%ebp),%edx
  801825:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801828:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80182b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801830:	89 d0                	mov    %edx,%eax
  801832:	c9                   	leave  
  801833:	c3                   	ret    

00801834 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801834:	55                   	push   %ebp
  801835:	89 e5                	mov    %esp,%ebp
  801837:	53                   	push   %ebx
  801838:	83 ec 14             	sub    $0x14,%esp
  80183b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80183e:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801841:	50                   	push   %eax
  801842:	53                   	push   %ebx
  801843:	e8 ca fb ff ff       	call   801412 <fd_lookup>
  801848:	83 c4 08             	add    $0x8,%esp
  80184b:	85 c0                	test   %eax,%eax
  80184d:	78 4e                	js     80189d <ftruncate+0x69>
  80184f:	83 ec 08             	sub    $0x8,%esp
  801852:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801855:	50                   	push   %eax
  801856:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801859:	ff 30                	pushl  (%eax)
  80185b:	e8 74 fc ff ff       	call   8014d4 <dev_lookup>
  801860:	83 c4 10             	add    $0x10,%esp
  801863:	85 c0                	test   %eax,%eax
  801865:	78 36                	js     80189d <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801867:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80186a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80186e:	75 1e                	jne    80188e <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	53                   	push   %ebx
  801874:	a1 80 70 80 00       	mov    0x807080,%eax
  801879:	8b 40 4c             	mov    0x4c(%eax),%eax
  80187c:	50                   	push   %eax
  80187d:	68 3c 35 80 00       	push   $0x80353c
  801882:	e8 39 ea ff ff       	call   8002c0 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801887:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80188c:	eb 0f                	jmp    80189d <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  80188e:	83 ec 08             	sub    $0x8,%esp
  801891:	ff 75 0c             	pushl  0xc(%ebp)
  801894:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801897:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80189a:	ff 50 1c             	call   *0x1c(%eax)
}
  80189d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	53                   	push   %ebx
  8018a6:	83 ec 14             	sub    $0x14,%esp
  8018a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ac:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8018af:	50                   	push   %eax
  8018b0:	ff 75 08             	pushl  0x8(%ebp)
  8018b3:	e8 5a fb ff ff       	call   801412 <fd_lookup>
  8018b8:	83 c4 08             	add    $0x8,%esp
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 42                	js     801901 <fstat+0x5f>
  8018bf:	83 ec 08             	sub    $0x8,%esp
  8018c2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8018c5:	50                   	push   %eax
  8018c6:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018c9:	ff 30                	pushl  (%eax)
  8018cb:	e8 04 fc ff ff       	call   8014d4 <dev_lookup>
  8018d0:	83 c4 10             	add    $0x10,%esp
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 2a                	js     801901 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  8018d7:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018da:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018e1:	00 00 00 
	stat->st_isdir = 0;
  8018e4:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018eb:	00 00 00 
	stat->st_dev = dev;
  8018ee:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8018f1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	53                   	push   %ebx
  8018fb:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8018fe:	ff 50 14             	call   *0x14(%eax)
}
  801901:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	56                   	push   %esi
  80190a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80190b:	83 ec 08             	sub    $0x8,%esp
  80190e:	6a 00                	push   $0x0
  801910:	ff 75 08             	pushl  0x8(%ebp)
  801913:	e8 28 00 00 00       	call   801940 <open>
  801918:	89 c6                	mov    %eax,%esi
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	85 f6                	test   %esi,%esi
  80191f:	78 18                	js     801939 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801921:	83 ec 08             	sub    $0x8,%esp
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	56                   	push   %esi
  801928:	e8 75 ff ff ff       	call   8018a2 <fstat>
  80192d:	89 c3                	mov    %eax,%ebx
	close(fd);
  80192f:	89 34 24             	mov    %esi,(%esp)
  801932:	e8 fb fb ff ff       	call   801532 <close>
	return r;
  801937:	89 d8                	mov    %ebx,%eax
}
  801939:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80193c:	5b                   	pop    %ebx
  80193d:	5e                   	pop    %esi
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	53                   	push   %ebx
  801944:	83 ec 10             	sub    $0x10,%esp
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
  801947:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80194a:	50                   	push   %eax
  80194b:	e8 68 fa ff ff       	call   8013b8 <fd_alloc>
  801950:	89 c3                	mov    %eax,%ebx
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	85 db                	test   %ebx,%ebx
  801957:	78 36                	js     80198f <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80195f:	ff 75 0c             	pushl  0xc(%ebp)
  801962:	ff 75 08             	pushl  0x8(%ebp)
  801965:	e8 1b 05 00 00       	call   801e85 <fsipc_open>
  80196a:	89 c3                	mov    %eax,%ebx
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	85 c0                	test   %eax,%eax
  801971:	79 11                	jns    801984 <open+0x44>
          fd_close(fd_store, 0);
  801973:	83 ec 08             	sub    $0x8,%esp
  801976:	6a 00                	push   $0x0
  801978:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80197b:	e8 e0 fa ff ff       	call   801460 <fd_close>
          return r;
  801980:	89 d8                	mov    %ebx,%eax
  801982:	eb 0b                	jmp    80198f <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801984:	83 ec 0c             	sub    $0xc,%esp
  801987:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80198a:	e8 19 fa ff ff       	call   8013a8 <fd2num>
}
  80198f:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
  801997:	53                   	push   %ebx
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  80199e:	6a 01                	push   $0x1
  8019a0:	6a 00                	push   $0x0
  8019a2:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  8019a8:	53                   	push   %ebx
  8019a9:	e8 e7 03 00 00       	call   801d95 <funmap>
  8019ae:	83 c4 10             	add    $0x10,%esp
          return r;
  8019b1:	89 c2                	mov    %eax,%edx
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	78 19                	js     8019d0 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  8019b7:	83 ec 0c             	sub    $0xc,%esp
  8019ba:	ff 73 0c             	pushl  0xc(%ebx)
  8019bd:	e8 68 05 00 00       	call   801f2a <fsipc_close>
  8019c2:	83 c4 10             	add    $0x10,%esp
          return r;
  8019c5:	89 c2                	mov    %eax,%edx
  8019c7:	85 c0                	test   %eax,%eax
  8019c9:	78 05                	js     8019d0 <file_close+0x3c>
        }
        return 0;
  8019cb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019d0:	89 d0                	mov    %edx,%eax
  8019d2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	57                   	push   %edi
  8019db:	56                   	push   %esi
  8019dc:	53                   	push   %ebx
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	8b 75 10             	mov    0x10(%ebp),%esi
  8019e3:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  8019ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019f4:	39 d7                	cmp    %edx,%edi
  8019f6:	0f 87 95 00 00 00    	ja     801a91 <file_read+0xba>
	if (offset + n > size)
  8019fc:	8d 04 37             	lea    (%edi,%esi,1),%eax
  8019ff:	39 d0                	cmp    %edx,%eax
  801a01:	76 04                	jbe    801a07 <file_read+0x30>
		n = size - offset;
  801a03:	89 d6                	mov    %edx,%esi
  801a05:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801a07:	83 ec 0c             	sub    $0xc,%esp
  801a0a:	ff 75 08             	pushl  0x8(%ebp)
  801a0d:	e8 7e f9 ff ff       	call   801390 <fd2data>
  801a12:	89 c3                	mov    %eax,%ebx
  801a14:	01 fb                	add    %edi,%ebx
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	eb 41                	jmp    801a5c <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801a1b:	89 d8                	mov    %ebx,%eax
  801a1d:	c1 e8 16             	shr    $0x16,%eax
  801a20:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801a27:	a8 01                	test   $0x1,%al
  801a29:	74 10                	je     801a3b <file_read+0x64>
  801a2b:	89 d8                	mov    %ebx,%eax
  801a2d:	c1 e8 0c             	shr    $0xc,%eax
  801a30:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a37:	a8 01                	test   $0x1,%al
  801a39:	75 1b                	jne    801a56 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801a41:	50                   	push   %eax
  801a42:	57                   	push   %edi
  801a43:	ff 75 08             	pushl  0x8(%ebp)
  801a46:	e8 d4 02 00 00       	call   801d1f <fmap>
  801a4b:	83 c4 10             	add    $0x10,%esp
              return r;
  801a4e:	89 c1                	mov    %eax,%ecx
  801a50:	85 c0                	test   %eax,%eax
  801a52:	78 3d                	js     801a91 <file_read+0xba>
  801a54:	eb 1c                	jmp    801a72 <file_read+0x9b>
  801a56:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a5c:	83 ec 0c             	sub    $0xc,%esp
  801a5f:	ff 75 08             	pushl  0x8(%ebp)
  801a62:	e8 29 f9 ff ff       	call   801390 <fd2data>
  801a67:	01 f8                	add    %edi,%eax
  801a69:	01 f0                	add    %esi,%eax
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	39 d8                	cmp    %ebx,%eax
  801a70:	77 a9                	ja     801a1b <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	56                   	push   %esi
  801a76:	83 ec 04             	sub    $0x4,%esp
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	e8 0f f9 ff ff       	call   801390 <fd2data>
  801a81:	83 c4 08             	add    $0x8,%esp
  801a84:	01 f8                	add    %edi,%eax
  801a86:	50                   	push   %eax
  801a87:	ff 75 0c             	pushl  0xc(%ebp)
  801a8a:	e8 b1 ef ff ff       	call   800a40 <memmove>
	return n;
  801a8f:	89 f1                	mov    %esi,%ecx
}
  801a91:	89 c8                	mov    %ecx,%eax
  801a93:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801a96:	5b                   	pop    %ebx
  801a97:	5e                   	pop    %esi
  801a98:	5f                   	pop    %edi
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	56                   	push   %esi
  801a9f:	53                   	push   %ebx
  801aa0:	83 ec 18             	sub    $0x18,%esp
  801aa3:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aa6:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801aa9:	50                   	push   %eax
  801aaa:	ff 75 08             	pushl  0x8(%ebp)
  801aad:	e8 60 f9 ff ff       	call   801412 <fd_lookup>
  801ab2:	83 c4 10             	add    $0x10,%esp
		return r;
  801ab5:	89 c2                	mov    %eax,%edx
  801ab7:	85 c0                	test   %eax,%eax
  801ab9:	0f 88 9f 00 00 00    	js     801b5e <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801abf:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801ac2:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  801ac4:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801ac9:	3b 05 20 70 80 00    	cmp    0x807020,%eax
  801acf:	0f 85 89 00 00 00    	jne    801b5e <read_map+0xc3>
	va = fd2data(fd) + offset;
  801ad5:	83 ec 0c             	sub    $0xc,%esp
  801ad8:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801adb:	e8 b0 f8 ff ff       	call   801390 <fd2data>
  801ae0:	89 c3                	mov    %eax,%ebx
  801ae2:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801ae4:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801ae7:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801aec:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801af2:	7f 6a                	jg     801b5e <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801af4:	89 d8                	mov    %ebx,%eax
  801af6:	c1 e8 16             	shr    $0x16,%eax
  801af9:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801b00:	a8 01                	test   $0x1,%al
  801b02:	74 10                	je     801b14 <read_map+0x79>
  801b04:	89 d8                	mov    %ebx,%eax
  801b06:	c1 e8 0c             	shr    $0xc,%eax
  801b09:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b10:	a8 01                	test   $0x1,%al
  801b12:	75 19                	jne    801b2d <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801b14:	83 ec 04             	sub    $0x4,%esp
  801b17:	8d 46 01             	lea    0x1(%esi),%eax
  801b1a:	50                   	push   %eax
  801b1b:	56                   	push   %esi
  801b1c:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801b1f:	e8 fb 01 00 00       	call   801d1f <fmap>
  801b24:	83 c4 10             	add    $0x10,%esp
            return r;
  801b27:	89 c2                	mov    %eax,%edx
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	78 31                	js     801b5e <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801b2d:	89 d8                	mov    %ebx,%eax
  801b2f:	c1 e8 16             	shr    $0x16,%eax
  801b32:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801b39:	a8 01                	test   $0x1,%al
  801b3b:	74 10                	je     801b4d <read_map+0xb2>
  801b3d:	89 d8                	mov    %ebx,%eax
  801b3f:	c1 e8 0c             	shr    $0xc,%eax
  801b42:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b49:	a8 01                	test   $0x1,%al
  801b4b:	75 07                	jne    801b54 <read_map+0xb9>
		return -E_NO_DISK;
  801b4d:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801b52:	eb 0a                	jmp    801b5e <read_map+0xc3>

	*blk = (void*) va;
  801b54:	8b 45 10             	mov    0x10(%ebp),%eax
  801b57:	89 18                	mov    %ebx,(%eax)
	return 0;
  801b59:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b5e:	89 d0                	mov    %edx,%eax
  801b60:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801b63:	5b                   	pop    %ebx
  801b64:	5e                   	pop    %esi
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	57                   	push   %edi
  801b6b:	56                   	push   %esi
  801b6c:	53                   	push   %ebx
  801b6d:	83 ec 0c             	sub    $0xc,%esp
  801b70:	8b 75 08             	mov    0x8(%ebp),%esi
  801b73:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801b76:	8b 45 10             	mov    0x10(%ebp),%eax
  801b79:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801b7c:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801b81:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801b87:	0f 87 bd 00 00 00    	ja     801c4a <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801b8d:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801b93:	73 17                	jae    801bac <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801b95:	83 ec 08             	sub    $0x8,%esp
  801b98:	52                   	push   %edx
  801b99:	56                   	push   %esi
  801b9a:	e8 fb 00 00 00       	call   801c9a <file_trunc>
  801b9f:	83 c4 10             	add    $0x10,%esp
			return r;
  801ba2:	89 c1                	mov    %eax,%ecx
  801ba4:	85 c0                	test   %eax,%eax
  801ba6:	0f 88 9e 00 00 00    	js     801c4a <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801bac:	83 ec 0c             	sub    $0xc,%esp
  801baf:	56                   	push   %esi
  801bb0:	e8 db f7 ff ff       	call   801390 <fd2data>
  801bb5:	89 c3                	mov    %eax,%ebx
  801bb7:	01 fb                	add    %edi,%ebx
  801bb9:	83 c4 10             	add    $0x10,%esp
  801bbc:	eb 42                	jmp    801c00 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801bbe:	89 d8                	mov    %ebx,%eax
  801bc0:	c1 e8 16             	shr    $0x16,%eax
  801bc3:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801bca:	a8 01                	test   $0x1,%al
  801bcc:	74 10                	je     801bde <file_write+0x77>
  801bce:	89 d8                	mov    %ebx,%eax
  801bd0:	c1 e8 0c             	shr    $0xc,%eax
  801bd3:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801bda:	a8 01                	test   $0x1,%al
  801bdc:	75 1c                	jne    801bfa <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801bde:	83 ec 04             	sub    $0x4,%esp
  801be1:	8b 55 10             	mov    0x10(%ebp),%edx
  801be4:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801be7:	50                   	push   %eax
  801be8:	57                   	push   %edi
  801be9:	56                   	push   %esi
  801bea:	e8 30 01 00 00       	call   801d1f <fmap>
  801bef:	83 c4 10             	add    $0x10,%esp
              return r;
  801bf2:	89 c1                	mov    %eax,%ecx
  801bf4:	85 c0                	test   %eax,%eax
  801bf6:	78 52                	js     801c4a <file_write+0xe3>
  801bf8:	eb 1b                	jmp    801c15 <file_write+0xae>
  801bfa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c00:	83 ec 0c             	sub    $0xc,%esp
  801c03:	56                   	push   %esi
  801c04:	e8 87 f7 ff ff       	call   801390 <fd2data>
  801c09:	01 f8                	add    %edi,%eax
  801c0b:	03 45 10             	add    0x10(%ebp),%eax
  801c0e:	83 c4 10             	add    $0x10,%esp
  801c11:	39 d8                	cmp    %ebx,%eax
  801c13:	77 a9                	ja     801bbe <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801c15:	83 ec 0c             	sub    $0xc,%esp
  801c18:	68 96 35 80 00       	push   $0x803596
  801c1d:	e8 9e e6 ff ff       	call   8002c0 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801c22:	83 c4 0c             	add    $0xc,%esp
  801c25:	ff 75 10             	pushl  0x10(%ebp)
  801c28:	ff 75 0c             	pushl  0xc(%ebp)
  801c2b:	56                   	push   %esi
  801c2c:	e8 5f f7 ff ff       	call   801390 <fd2data>
  801c31:	01 f8                	add    %edi,%eax
  801c33:	89 04 24             	mov    %eax,(%esp)
  801c36:	e8 05 ee ff ff       	call   800a40 <memmove>
        cprintf("write done\n");
  801c3b:	c7 04 24 a3 35 80 00 	movl   $0x8035a3,(%esp)
  801c42:	e8 79 e6 ff ff       	call   8002c0 <cprintf>
	return n;
  801c47:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801c4a:	89 c8                	mov    %ecx,%eax
  801c4c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5f                   	pop    %edi
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
  801c57:	56                   	push   %esi
  801c58:	53                   	push   %ebx
  801c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801c5f:	83 ec 08             	sub    $0x8,%esp
  801c62:	8d 43 10             	lea    0x10(%ebx),%eax
  801c65:	50                   	push   %eax
  801c66:	56                   	push   %esi
  801c67:	e8 58 ec ff ff       	call   8008c4 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801c6c:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801c72:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801c78:	83 c4 10             	add    $0x10,%esp
  801c7b:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801c82:	0f 94 c0             	sete   %al
  801c85:	0f b6 c0             	movzbl %al,%eax
  801c88:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801c8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c93:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5e                   	pop    %esi
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	57                   	push   %edi
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 0c             	sub    $0xc,%esp
  801ca3:	8b 75 08             	mov    0x8(%ebp),%esi
  801ca6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801ca9:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801cae:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801cb4:	7f 5f                	jg     801d15 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801cb6:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801cbc:	83 ec 08             	sub    $0x8,%esp
  801cbf:	53                   	push   %ebx
  801cc0:	ff 76 0c             	pushl  0xc(%esi)
  801cc3:	e8 3a 02 00 00       	call   801f02 <fsipc_set_size>
  801cc8:	83 c4 10             	add    $0x10,%esp
		return r;
  801ccb:	89 c2                	mov    %eax,%edx
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	78 44                	js     801d15 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801cd1:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801cd7:	74 19                	je     801cf2 <file_trunc+0x58>
  801cd9:	68 d0 35 80 00       	push   $0x8035d0
  801cde:	68 af 35 80 00       	push   $0x8035af
  801ce3:	68 dc 00 00 00       	push   $0xdc
  801ce8:	68 c4 35 80 00       	push   $0x8035c4
  801ced:	e8 de e4 ff ff       	call   8001d0 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801cf2:	83 ec 04             	sub    $0x4,%esp
  801cf5:	53                   	push   %ebx
  801cf6:	57                   	push   %edi
  801cf7:	56                   	push   %esi
  801cf8:	e8 22 00 00 00       	call   801d1f <fmap>
  801cfd:	83 c4 10             	add    $0x10,%esp
		return r;
  801d00:	89 c2                	mov    %eax,%edx
  801d02:	85 c0                	test   %eax,%eax
  801d04:	78 0f                	js     801d15 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	53                   	push   %ebx
  801d09:	57                   	push   %edi
  801d0a:	56                   	push   %esi
  801d0b:	e8 85 00 00 00       	call   801d95 <funmap>

	return 0;
  801d10:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d15:	89 d0                	mov    %edx,%eax
  801d17:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d1a:	5b                   	pop    %ebx
  801d1b:	5e                   	pop    %esi
  801d1c:	5f                   	pop    %edi
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <fmap>:

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
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	57                   	push   %edi
  801d23:	56                   	push   %esi
  801d24:	53                   	push   %ebx
  801d25:	83 ec 0c             	sub    $0xc,%esp
  801d28:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d2b:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801d2e:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801d31:	7d 55                	jge    801d88 <fmap+0x69>
          fma = fd2data(fd);
  801d33:	83 ec 0c             	sub    $0xc,%esp
  801d36:	57                   	push   %edi
  801d37:	e8 54 f6 ff ff       	call   801390 <fd2data>
  801d3c:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d45:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d4a:	89 c3                	mov    %eax,%ebx
  801d4c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801d52:	39 f3                	cmp    %esi,%ebx
  801d54:	7d 32                	jge    801d88 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801d56:	83 ec 04             	sub    $0x4,%esp
  801d59:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801d5c:	01 d8                	add    %ebx,%eax
  801d5e:	50                   	push   %eax
  801d5f:	53                   	push   %ebx
  801d60:	ff 77 0c             	pushl  0xc(%edi)
  801d63:	e8 6f 01 00 00       	call   801ed7 <fsipc_map>
  801d68:	83 c4 10             	add    $0x10,%esp
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	79 0f                	jns    801d7e <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	53                   	push   %ebx
  801d75:	57                   	push   %edi
  801d76:	e8 1a 00 00 00       	call   801d95 <funmap>
  801d7b:	83 c4 10             	add    $0x10,%esp
  801d7e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d84:	39 f3                	cmp    %esi,%ebx
  801d86:	7c ce                	jl     801d56 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5f                   	pop    %edi
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <funmap>:

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
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	57                   	push   %edi
  801d99:	56                   	push   %esi
  801d9a:	53                   	push   %ebx
  801d9b:	83 ec 0c             	sub    $0xc,%esp
  801d9e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801da1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801da4:	39 f3                	cmp    %esi,%ebx
  801da6:	0f 8d 80 00 00 00    	jge    801e2c <funmap+0x97>
          fma = fd2data(fd);
  801dac:	83 ec 0c             	sub    $0xc,%esp
  801daf:	ff 75 08             	pushl  0x8(%ebp)
  801db2:	e8 d9 f5 ff ff       	call   801390 <fd2data>
  801db7:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801db9:	83 c4 10             	add    $0x10,%esp
  801dbc:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801dc2:	89 c3                	mov    %eax,%ebx
  801dc4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801dca:	39 f3                	cmp    %esi,%ebx
  801dcc:	7d 5e                	jge    801e2c <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801dce:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801dd1:	89 c2                	mov    %eax,%edx
  801dd3:	c1 ea 0c             	shr    $0xc,%edx
  801dd6:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801ddd:	a8 01                	test   $0x1,%al
  801ddf:	74 41                	je     801e22 <funmap+0x8d>
              if (dirty) {
  801de1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801de5:	74 21                	je     801e08 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801de7:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801dee:	a8 40                	test   $0x40,%al
  801df0:	74 16                	je     801e08 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801df2:	83 ec 08             	sub    $0x8,%esp
  801df5:	53                   	push   %ebx
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	ff 70 0c             	pushl  0xc(%eax)
  801dfc:	e8 49 01 00 00       	call   801f4a <fsipc_dirty>
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	85 c0                	test   %eax,%eax
  801e06:	78 29                	js     801e31 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801e08:	83 ec 08             	sub    $0x8,%esp
  801e0b:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801e0e:	50                   	push   %eax
  801e0f:	83 ec 04             	sub    $0x4,%esp
  801e12:	e8 41 ee ff ff       	call   800c58 <sys_getenvid>
  801e17:	89 04 24             	mov    %eax,(%esp)
  801e1a:	e8 fc ee ff ff       	call   800d1b <sys_page_unmap>
  801e1f:	83 c4 10             	add    $0x10,%esp
  801e22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e28:	39 f3                	cmp    %esi,%ebx
  801e2a:	7c a2                	jl     801dce <funmap+0x39>
            }
          }
        }

        return 0;
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e31:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801e34:	5b                   	pop    %ebx
  801e35:	5e                   	pop    %esi
  801e36:	5f                   	pop    %edi
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <remove>:

// Delete a file
int
remove(const char *path)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801e3f:	ff 75 08             	pushl  0x8(%ebp)
  801e42:	e8 2b 01 00 00       	call   801f72 <fsipc_remove>
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801e4f:	e8 64 01 00 00       	call   801fb8 <fsipc_sync>
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    
	...

00801e58 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801e5e:	6a 07                	push   $0x7
  801e60:	ff 75 0c             	pushl  0xc(%ebp)
  801e63:	ff 75 08             	pushl  0x8(%ebp)
  801e66:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801e6b:	50                   	push   %eax
  801e6c:	e8 82 0d 00 00       	call   802bf3 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801e71:	83 c4 0c             	add    $0xc,%esp
  801e74:	ff 75 14             	pushl  0x14(%ebp)
  801e77:	ff 75 10             	pushl  0x10(%ebp)
  801e7a:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801e7d:	50                   	push   %eax
  801e7e:	e8 0d 0d 00 00       	call   802b90 <ipc_recv>
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	56                   	push   %esi
  801e89:	53                   	push   %ebx
  801e8a:	83 ec 1c             	sub    $0x1c,%esp
  801e8d:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801e90:	bb 00 40 80 00       	mov    $0x804000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801e95:	56                   	push   %esi
  801e96:	e8 ed e9 ff ff       	call   800888 <strlen>
  801e9b:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801e9e:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801ea3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ea8:	7f 24                	jg     801ece <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801eaa:	83 ec 08             	sub    $0x8,%esp
  801ead:	56                   	push   %esi
  801eae:	53                   	push   %ebx
  801eaf:	e8 10 ea ff ff       	call   8008c4 <strcpy>
	req->req_omode = omode;
  801eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb7:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801ebd:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801ec0:	50                   	push   %eax
  801ec1:	ff 75 10             	pushl  0x10(%ebp)
  801ec4:	53                   	push   %ebx
  801ec5:	6a 01                	push   $0x1
  801ec7:	e8 8c ff ff ff       	call   801e58 <fsipc>
  801ecc:	89 c2                	mov    %eax,%edx
}
  801ece:	89 d0                	mov    %edx,%eax
  801ed0:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801ed3:	5b                   	pop    %ebx
  801ed4:	5e                   	pop    %esi
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801eed:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801ef0:	50                   	push   %eax
  801ef1:	ff 75 10             	pushl  0x10(%ebp)
  801ef4:	68 00 40 80 00       	push   $0x804000
  801ef9:	6a 02                	push   $0x2
  801efb:	e8 58 ff ff ff       	call   801e58 <fsipc>

	//return -E_UNSPECIFIED;
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	a3 00 40 80 00       	mov    %eax,0x804000
	req->req_size = size;
  801f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f13:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	68 00 40 80 00       	push   $0x804000
  801f21:	6a 03                	push   $0x3
  801f23:	e8 30 ff ff ff       	call   801e58 <fsipc>
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	68 00 40 80 00       	push   $0x804000
  801f41:	6a 04                	push   $0x4
  801f43:	e8 10 ff ff ff       	call   801e58 <fsipc>
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801f50:	8b 45 08             	mov    0x8(%ebp),%eax
  801f53:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  801f58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5b:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	68 00 40 80 00       	push   $0x804000
  801f69:	6a 05                	push   $0x5
  801f6b:	e8 e8 fe ff ff       	call   801e58 <fsipc>
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	56                   	push   %esi
  801f76:	53                   	push   %ebx
  801f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801f7a:	be 00 40 80 00       	mov    $0x804000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	53                   	push   %ebx
  801f83:	e8 00 e9 ff ff       	call   800888 <strlen>
  801f88:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801f8b:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801f90:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f95:	7f 18                	jg     801faf <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801f97:	83 ec 08             	sub    $0x8,%esp
  801f9a:	53                   	push   %ebx
  801f9b:	56                   	push   %esi
  801f9c:	e8 23 e9 ff ff       	call   8008c4 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	56                   	push   %esi
  801fa6:	6a 06                	push   $0x6
  801fa8:	e8 ab fe ff ff       	call   801e58 <fsipc>
  801fad:	89 c2                	mov    %eax,%edx
}
  801faf:	89 d0                	mov    %edx,%eax
  801fb1:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801fb4:	5b                   	pop    %ebx
  801fb5:	5e                   	pop    %esi
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	68 00 40 80 00       	push   $0x804000
  801fc7:	6a 07                	push   $0x7
  801fc9:	e8 8a fe ff ff       	call   801e58 <fsipc>
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <spawn>:
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	57                   	push   %edi
  801fd4:	56                   	push   %esi
  801fd5:	53                   	push   %ebx
  801fd6:	81 ec 74 02 00 00    	sub    $0x274,%esp
	unsigned char elf_buf[512];
	struct Trapframe child_tf;
	envid_t child;

	int fd, i, r;
	struct Elf *elf;
	struct Proghdr *ph;
	int perm;

	// This code follows this procedure:
	//
	//   - Open the program file.
	//
	//   - Read the ELF header, as you have before, and sanity check its
	//     magic number.  (Check out your load_icode!)
	//
	//   - Use sys_exofork() to create a new environment.
	//
	//   - Set child_tf to an initial struct Trapframe for the child.
	//
	//   - Call the init_stack() function above to set up
	//     the initial stack page for the child environment.
	//
	//   - Map all of the program's segments that are of p_type
	//     ELF_PROG_LOAD into the new environment's address space.
	//     Use the p_flags field in the Proghdr for each segment
	//     to determine how to map the segment:
	//
	//	* If the ELF flags do not include ELF_PROG_FLAG_WRITE,
	//	  then the segment contains text and read-only data.
	//	  Use read_map() to read the contents of this segment,
	//	  and map the pages it returns directly into the child
	//        so that multiple instances of the same program
	//	  will share the same copy of the program text.
	//        Be sure to map the program text read-only in the child.
	//        Read_map is like read but returns a pointer to the data in
	//        *blk rather than copying the data into another buffer.
	//
	//	* If the ELF segment flags DO include ELF_PROG_FLAG_WRITE,
	//	  then the segment contains read/write data and bss.
	//	  As with load_icode() in Lab 3, such an ELF segment
	//	  occupies p_memsz bytes in memory, but only the FIRST
	//	  p_filesz bytes of the segment are actually loaded
	//	  from the executable file - you must clear the rest to zero.
	//        For each page to be mapped for a read/write segment,
	//        allocate a page in the parent temporarily at UTEMP,
	//        read() the appropriate portion of the file into that page
	//	  and/or use memset() to zero non-loaded portions.
	//	  (You can avoid calling memset(), if you like, if
	//	  page_alloc() returns zeroed pages already.)
	//        Then insert the page mapping into the child.
	//        Look at init_stack() for inspiration.
	//        Be sure you understand why you can't use read_map() here.
	//
	//     Note: None of the segment addresses or lengths above
	//     are guaranteed to be page-aligned, so you must deal with
	//     these non-page-aligned values appropriately.
	//     The ELF linker does, however, guarantee that no two segments
	//     will overlap on the same page; and it guarantees that
	//     PGOFF(ph->p_offset) == PGOFF(ph->p_va).
	//
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801fdc:	6a 00                	push   $0x0
  801fde:	ff 75 08             	pushl  0x8(%ebp)
  801fe1:	e8 5a f9 ff ff       	call   801940 <open>
  801fe6:	89 c3                	mov    %eax,%ebx
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	85 db                	test   %ebx,%ebx
  801fed:	0f 88 ed 01 00 00    	js     8021e0 <spawn+0x210>
		return r;
	fd = r;
  801ff3:	89 9d 90 fd ff ff    	mov    %ebx,0xfffffd90(%ebp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801ff9:	83 ec 04             	sub    $0x4,%esp
  801ffc:	68 00 02 00 00       	push   $0x200
  802001:	8d 85 e8 fd ff ff    	lea    0xfffffde8(%ebp),%eax
  802007:	50                   	push   %eax
  802008:	53                   	push   %ebx
  802009:	e8 97 f6 ff ff       	call   8016a5 <read>
  80200e:	83 c4 10             	add    $0x10,%esp
  802011:	3d 00 02 00 00       	cmp    $0x200,%eax
  802016:	75 0c                	jne    802024 <spawn+0x54>
  802018:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,0xfffffde8(%ebp)
  80201f:	45 4c 46 
  802022:	74 30                	je     802054 <spawn+0x84>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  802024:	83 ec 0c             	sub    $0xc,%esp
  802027:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  80202d:	e8 00 f5 ff ff       	call   801532 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802032:	83 c4 0c             	add    $0xc,%esp
  802035:	68 7f 45 4c 46       	push   $0x464c457f
  80203a:	ff b5 e8 fd ff ff    	pushl  0xfffffde8(%ebp)
  802040:	68 f3 35 80 00       	push   $0x8035f3
  802045:	e8 76 e2 ff ff       	call   8002c0 <cprintf>
		return -E_NOT_EXEC;
  80204a:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80204f:	e9 8c 01 00 00       	jmp    8021e0 <spawn+0x210>
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  802054:	ba 07 00 00 00       	mov    $0x7,%edx
  802059:	89 d0                	mov    %edx,%eax
  80205b:	cd 30                	int    $0x30
  80205d:	89 c3                	mov    %eax,%ebx
  80205f:	85 db                	test   %ebx,%ebx
  802061:	0f 88 79 01 00 00    	js     8021e0 <spawn+0x210>
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
	child = r;
  802067:	89 9d 94 fd ff ff    	mov    %ebx,0xfffffd94(%ebp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80206d:	89 d8                	mov    %ebx,%eax
  80206f:	25 ff 03 00 00       	and    $0x3ff,%eax
  802074:	c1 e0 07             	shl    $0x7,%eax
  802077:	8d 95 98 fd ff ff    	lea    0xfffffd98(%ebp),%edx
  80207d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802082:	83 ec 04             	sub    $0x4,%esp
  802085:	6a 44                	push   $0x44
  802087:	50                   	push   %eax
  802088:	52                   	push   %edx
  802089:	e8 1d ea ff ff       	call   800aab <memcpy>
	child_tf.tf_eip = elf->e_entry;
  80208e:	8b 85 00 fe ff ff    	mov    0xfffffe00(%ebp),%eax
  802094:	89 85 c8 fd ff ff    	mov    %eax,0xfffffdc8(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  80209a:	83 c4 0c             	add    $0xc,%esp
  80209d:	8d 85 d4 fd ff ff    	lea    0xfffffdd4(%ebp),%eax
  8020a3:	50                   	push   %eax
  8020a4:	ff 75 0c             	pushl  0xc(%ebp)
  8020a7:	53                   	push   %ebx
  8020a8:	e8 4f 01 00 00       	call   8021fc <init_stack>
  8020ad:	89 c3                	mov    %eax,%ebx
  8020af:	83 c4 10             	add    $0x10,%esp
  8020b2:	85 db                	test   %ebx,%ebx
  8020b4:	0f 88 26 01 00 00    	js     8021e0 <spawn+0x210>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8020ba:	8b 85 04 fe ff ff    	mov    0xfffffe04(%ebp),%eax
  8020c0:	8d b4 05 e8 fd ff ff 	lea    0xfffffde8(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8020c7:	bf 00 00 00 00       	mov    $0x0,%edi
  8020cc:	66 83 bd 14 fe ff ff 	cmpw   $0x0,0xfffffe14(%ebp)
  8020d3:	00 
  8020d4:	74 4f                	je     802125 <spawn+0x155>
		if (ph->p_type != ELF_PROG_LOAD)
  8020d6:	83 3e 01             	cmpl   $0x1,(%esi)
  8020d9:	75 3b                	jne    802116 <spawn+0x146>
			continue;
		perm = PTE_P | PTE_U;
  8020db:	b8 05 00 00 00       	mov    $0x5,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8020e0:	f6 46 18 02          	testb  $0x2,0x18(%esi)
  8020e4:	74 02                	je     8020e8 <spawn+0x118>
			perm |= PTE_W;
  8020e6:	b0 07                	mov    $0x7,%al
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  8020e8:	83 ec 04             	sub    $0x4,%esp
  8020eb:	50                   	push   %eax
  8020ec:	ff 76 04             	pushl  0x4(%esi)
  8020ef:	ff 76 10             	pushl  0x10(%esi)
  8020f2:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  8020f8:	ff 76 14             	pushl  0x14(%esi)
  8020fb:	ff 76 08             	pushl  0x8(%esi)
  8020fe:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802104:	e8 5f 02 00 00       	call   802368 <map_segment>
  802109:	89 c3                	mov    %eax,%ebx
  80210b:	83 c4 20             	add    $0x20,%esp
  80210e:	85 c0                	test   %eax,%eax
  802110:	0f 88 ac 00 00 00    	js     8021c2 <spawn+0x1f2>
  802116:	47                   	inc    %edi
  802117:	83 c6 20             	add    $0x20,%esi
  80211a:	0f b7 85 14 fe ff ff 	movzwl 0xfffffe14(%ebp),%eax
  802121:	39 f8                	cmp    %edi,%eax
  802123:	7f b1                	jg     8020d6 <spawn+0x106>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802125:	83 ec 0c             	sub    $0xc,%esp
  802128:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  80212e:	e8 ff f3 ff ff       	call   801532 <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  802133:	83 c4 04             	add    $0x4,%esp
  802136:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  80213c:	e8 9f 03 00 00       	call   8024e0 <copy_shared_pages>
  802141:	83 c4 10             	add    $0x10,%esp
  802144:	85 c0                	test   %eax,%eax
  802146:	79 15                	jns    80215d <spawn+0x18d>
		panic("copy_shared_pages: %e", r);
  802148:	50                   	push   %eax
  802149:	68 0d 36 80 00       	push   $0x80360d
  80214e:	68 82 00 00 00       	push   $0x82
  802153:	68 23 36 80 00       	push   $0x803623
  802158:	e8 73 e0 ff ff       	call   8001d0 <_panic>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80215d:	83 ec 08             	sub    $0x8,%esp
  802160:	8d 85 98 fd ff ff    	lea    0xfffffd98(%ebp),%eax
  802166:	50                   	push   %eax
  802167:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  80216d:	e8 2d ec ff ff       	call   800d9f <sys_env_set_trapframe>
  802172:	83 c4 10             	add    $0x10,%esp
  802175:	85 c0                	test   %eax,%eax
  802177:	79 15                	jns    80218e <spawn+0x1be>
		panic("sys_env_set_trapframe: %e", r);
  802179:	50                   	push   %eax
  80217a:	68 2f 36 80 00       	push   $0x80362f
  80217f:	68 85 00 00 00       	push   $0x85
  802184:	68 23 36 80 00       	push   $0x803623
  802189:	e8 42 e0 ff ff       	call   8001d0 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80218e:	83 ec 08             	sub    $0x8,%esp
  802191:	6a 01                	push   $0x1
  802193:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802199:	e8 bf eb ff ff       	call   800d5d <sys_env_set_status>
  80219e:	89 c3                	mov    %eax,%ebx
  8021a0:	83 c4 10             	add    $0x10,%esp
		panic("sys_env_set_status: %e", r);

	return child;
  8021a3:	8b 85 94 fd ff ff    	mov    0xfffffd94(%ebp),%eax
  8021a9:	85 db                	test   %ebx,%ebx
  8021ab:	79 33                	jns    8021e0 <spawn+0x210>
  8021ad:	53                   	push   %ebx
  8021ae:	68 49 36 80 00       	push   $0x803649
  8021b3:	68 88 00 00 00       	push   $0x88
  8021b8:	68 23 36 80 00       	push   $0x803623
  8021bd:	e8 0e e0 ff ff       	call   8001d0 <_panic>

error:
	sys_env_destroy(child);
  8021c2:	83 ec 0c             	sub    $0xc,%esp
  8021c5:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  8021cb:	e8 47 ea ff ff       	call   800c17 <sys_env_destroy>
	close(fd);
  8021d0:	83 c4 04             	add    $0x4,%esp
  8021d3:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  8021d9:	e8 54 f3 ff ff       	call   801532 <close>
	return r;
  8021de:	89 d8                	mov    %ebx,%eax
}
  8021e0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8021e3:	5b                   	pop    %ebx
  8021e4:	5e                   	pop    %esi
  8021e5:	5f                   	pop    %edi
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <spawnl>:

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	83 ec 10             	sub    $0x10,%esp
	return spawn(prog, &arg0);
  8021ee:	8d 45 0c             	lea    0xc(%ebp),%eax
  8021f1:	50                   	push   %eax
  8021f2:	ff 75 08             	pushl  0x8(%ebp)
  8021f5:	e8 d6 fd ff ff       	call   801fd0 <spawn>
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <init_stack>:


// Set up the initial stack page for the new child process with envid 'child'
// using the arguments array pointed to by 'argv',
// which is a null-terminated array of pointers to null-terminated strings.
//
// On success, returns 0 and sets *init_esp
// to the initial stack pointer with which the child should start.
// Returns < 0 on failure.
static int
init_stack(envid_t child, const char **argv, uintptr_t *init_esp)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	57                   	push   %edi
  802200:	56                   	push   %esi
  802201:	53                   	push   %ebx
  802202:	83 ec 0c             	sub    $0xc,%esp
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802205:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  80220a:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
  802211:	8b 45 0c             	mov    0xc(%ebp),%eax
  802214:	83 38 00             	cmpl   $0x0,(%eax)
  802217:	74 27                	je     802240 <init_stack+0x44>
		string_size += strlen(argv[argc]) + 1;
  802219:	83 ec 0c             	sub    $0xc,%esp
  80221c:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80221f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802222:	ff 34 90             	pushl  (%eax,%edx,4)
  802225:	e8 5e e6 ff ff       	call   800888 <strlen>
  80222a:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
  80222e:	83 c4 10             	add    $0x10,%esp
  802231:	ff 45 f0             	incl   0xfffffff0(%ebp)
  802234:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223a:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  80223e:	75 d9                	jne    802219 <init_stack+0x1d>

	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802240:	b8 00 10 40 00       	mov    $0x401000,%eax
  802245:	89 c7                	mov    %eax,%edi
  802247:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802249:	89 fa                	mov    %edi,%edx
  80224b:	83 e2 fc             	and    $0xfffffffc,%edx
  80224e:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802251:	c1 e0 02             	shl    $0x2,%eax
  802254:	89 d6                	mov    %edx,%esi
  802256:	29 c6                	sub    %eax,%esi
  802258:	83 ee 04             	sub    $0x4,%esi
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80225b:	8d 46 f8             	lea    0xfffffff8(%esi),%eax
		return -E_NO_MEM;
  80225e:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
  802263:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802268:	0f 86 f0 00 00 00    	jbe    80235e <init_stack+0x162>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80226e:	83 ec 04             	sub    $0x4,%esp
  802271:	6a 07                	push   $0x7
  802273:	68 00 00 40 00       	push   $0x400000
  802278:	6a 00                	push   $0x0
  80227a:	e8 17 ea ff ff       	call   800c96 <sys_page_alloc>
  80227f:	83 c4 10             	add    $0x10,%esp
		return r;
  802282:	89 c2                	mov    %eax,%edx
  802284:	85 c0                	test   %eax,%eax
  802286:	0f 88 d2 00 00 00    	js     80235e <init_stack+0x162>


	//	* Initialize 'argv_store[i]' to point to argument string i,
	//	  for all 0 <= i < argc.
	//	  Also, copy the argument strings from 'argv' into the
	//	  newly-allocated stack page.
	//
	//	* Set 'argv_store[argc]' to 0 to null-terminate the args array.
	//
	//	* Push two more words onto the child's stack below 'args',
	//	  containing the argc and argv parameters to be passed
	//	  to the child's umain() function.
	//	  argv should be below argc on the stack.
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80228c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802291:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
  802294:	7d 33                	jge    8022c9 <init_stack+0xcd>
		argv_store[i] = UTEMP2USTACK(string_store);
  802296:	8d 87 00 d0 7f ee    	lea    0xee7fd000(%edi),%eax
  80229c:	89 04 9e             	mov    %eax,(%esi,%ebx,4)
		strcpy(string_store, argv[i]);
  80229f:	83 ec 08             	sub    $0x8,%esp
  8022a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a5:	ff 34 9a             	pushl  (%edx,%ebx,4)
  8022a8:	57                   	push   %edi
  8022a9:	e8 16 e6 ff ff       	call   8008c4 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8022ae:	83 c4 04             	add    $0x4,%esp
  8022b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b4:	ff 34 98             	pushl  (%eax,%ebx,4)
  8022b7:	e8 cc e5 ff ff       	call   800888 <strlen>
  8022bc:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
  8022c0:	83 c4 10             	add    $0x10,%esp
  8022c3:	43                   	inc    %ebx
  8022c4:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
  8022c7:	7c cd                	jl     802296 <init_stack+0x9a>
	}
	argv_store[argc] = 0;
  8022c9:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8022cc:	c7 04 96 00 00 00 00 	movl   $0x0,(%esi,%edx,4)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8022d3:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8022d9:	74 19                	je     8022f4 <init_stack+0xf8>
  8022db:	68 9c 36 80 00       	push   $0x80369c
  8022e0:	68 af 35 80 00       	push   $0x8035af
  8022e5:	68 d9 00 00 00       	push   $0xd9
  8022ea:	68 23 36 80 00       	push   $0x803623
  8022ef:	e8 dc de ff ff       	call   8001d0 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8022f4:	8d 86 00 d0 7f ee    	lea    0xee7fd000(%esi),%eax
  8022fa:	89 46 fc             	mov    %eax,0xfffffffc(%esi)
	argv_store[-2] = argc;
  8022fd:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802300:	89 46 f8             	mov    %eax,0xfffffff8(%esi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802303:	8d 96 f8 cf 7f ee    	lea    0xee7fcff8(%esi),%edx
  802309:	8b 45 10             	mov    0x10(%ebp),%eax
  80230c:	89 10                	mov    %edx,(%eax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80230e:	83 ec 0c             	sub    $0xc,%esp
  802311:	6a 07                	push   $0x7
  802313:	68 00 d0 bf ee       	push   $0xeebfd000
  802318:	ff 75 08             	pushl  0x8(%ebp)
  80231b:	68 00 00 40 00       	push   $0x400000
  802320:	6a 00                	push   $0x0
  802322:	e8 b2 e9 ff ff       	call   800cd9 <sys_page_map>
  802327:	89 c3                	mov    %eax,%ebx
  802329:	83 c4 20             	add    $0x20,%esp
  80232c:	85 c0                	test   %eax,%eax
  80232e:	78 1d                	js     80234d <init_stack+0x151>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802330:	83 ec 08             	sub    $0x8,%esp
  802333:	68 00 00 40 00       	push   $0x400000
  802338:	6a 00                	push   $0x0
  80233a:	e8 dc e9 ff ff       	call   800d1b <sys_page_unmap>
  80233f:	89 c3                	mov    %eax,%ebx
  802341:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  802344:	ba 00 00 00 00       	mov    $0x0,%edx
  802349:	85 c0                	test   %eax,%eax
  80234b:	79 11                	jns    80235e <init_stack+0x162>

error:
	sys_page_unmap(0, UTEMP);
  80234d:	83 ec 08             	sub    $0x8,%esp
  802350:	68 00 00 40 00       	push   $0x400000
  802355:	6a 00                	push   $0x0
  802357:	e8 bf e9 ff ff       	call   800d1b <sys_page_unmap>
	return r;
  80235c:	89 da                	mov    %ebx,%edx
}
  80235e:	89 d0                	mov    %edx,%eax
  802360:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802363:	5b                   	pop    %ebx
  802364:	5e                   	pop    %esi
  802365:	5f                   	pop    %edi
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz, 
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	57                   	push   %edi
  80236c:	56                   	push   %esi
  80236d:	53                   	push   %ebx
  80236e:	83 ec 0c             	sub    $0xc,%esp
  802371:	8b 75 0c             	mov    0xc(%ebp),%esi
  802374:	8b 7d 18             	mov    0x18(%ebp),%edi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802377:	89 f3                	mov    %esi,%ebx
  802379:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  80237f:	74 0a                	je     80238b <map_segment+0x23>
		va -= i;
  802381:	29 de                	sub    %ebx,%esi
		memsz += i;
  802383:	01 5d 10             	add    %ebx,0x10(%ebp)
		filesz += i;
  802386:	01 df                	add    %ebx,%edi
		fileoffset -= i;
  802388:	29 5d 1c             	sub    %ebx,0x1c(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80238b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802390:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802393:	0f 83 3a 01 00 00    	jae    8024d3 <map_segment+0x16b>
		if (i >= filesz) {
  802399:	39 fb                	cmp    %edi,%ebx
  80239b:	72 22                	jb     8023bf <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80239d:	83 ec 04             	sub    $0x4,%esp
  8023a0:	ff 75 20             	pushl  0x20(%ebp)
  8023a3:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8023a6:	50                   	push   %eax
  8023a7:	ff 75 08             	pushl  0x8(%ebp)
  8023aa:	e8 e7 e8 ff ff       	call   800c96 <sys_page_alloc>
  8023af:	83 c4 10             	add    $0x10,%esp
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	0f 89 0a 01 00 00    	jns    8024c4 <map_segment+0x15c>
				return r;
  8023ba:	e9 19 01 00 00       	jmp    8024d8 <map_segment+0x170>
		} else {
			// from file
			if (perm & PTE_W) {
  8023bf:	f6 45 20 02          	testb  $0x2,0x20(%ebp)
  8023c3:	0f 84 ac 00 00 00    	je     802475 <map_segment+0x10d>
				// must make a copy so it can be writable
				if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8023c9:	83 ec 04             	sub    $0x4,%esp
  8023cc:	6a 07                	push   $0x7
  8023ce:	68 00 00 40 00       	push   $0x400000
  8023d3:	6a 00                	push   $0x0
  8023d5:	e8 bc e8 ff ff       	call   800c96 <sys_page_alloc>
  8023da:	83 c4 10             	add    $0x10,%esp
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	0f 88 f3 00 00 00    	js     8024d8 <map_segment+0x170>
					return r;
				if ((r = seek(fd, fileoffset + i)) < 0)
  8023e5:	83 ec 08             	sub    $0x8,%esp
  8023e8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8023eb:	01 d8                	add    %ebx,%eax
  8023ed:	50                   	push   %eax
  8023ee:	ff 75 14             	pushl  0x14(%ebp)
  8023f1:	e8 11 f4 ff ff       	call   801807 <seek>
  8023f6:	83 c4 10             	add    $0x10,%esp
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	0f 88 d7 00 00 00    	js     8024d8 <map_segment+0x170>
					return r;
				if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802401:	89 fa                	mov    %edi,%edx
  802403:	29 da                	sub    %ebx,%edx
  802405:	b8 00 10 00 00       	mov    $0x1000,%eax
  80240a:	39 d0                	cmp    %edx,%eax
  80240c:	76 02                	jbe    802410 <map_segment+0xa8>
  80240e:	89 d0                	mov    %edx,%eax
  802410:	83 ec 04             	sub    $0x4,%esp
  802413:	50                   	push   %eax
  802414:	68 00 00 40 00       	push   $0x400000
  802419:	ff 75 14             	pushl  0x14(%ebp)
  80241c:	e8 84 f2 ff ff       	call   8016a5 <read>
  802421:	83 c4 10             	add    $0x10,%esp
  802424:	85 c0                	test   %eax,%eax
  802426:	0f 88 ac 00 00 00    	js     8024d8 <map_segment+0x170>
					return r;
				if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80242c:	83 ec 0c             	sub    $0xc,%esp
  80242f:	ff 75 20             	pushl  0x20(%ebp)
  802432:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  802435:	50                   	push   %eax
  802436:	ff 75 08             	pushl  0x8(%ebp)
  802439:	68 00 00 40 00       	push   $0x400000
  80243e:	6a 00                	push   $0x0
  802440:	e8 94 e8 ff ff       	call   800cd9 <sys_page_map>
  802445:	83 c4 20             	add    $0x20,%esp
  802448:	85 c0                	test   %eax,%eax
  80244a:	79 15                	jns    802461 <map_segment+0xf9>
					panic("spawn: sys_page_map data: %e", r);
  80244c:	50                   	push   %eax
  80244d:	68 60 36 80 00       	push   $0x803660
  802452:	68 0e 01 00 00       	push   $0x10e
  802457:	68 23 36 80 00       	push   $0x803623
  80245c:	e8 6f dd ff ff       	call   8001d0 <_panic>
				sys_page_unmap(0, UTEMP);
  802461:	83 ec 08             	sub    $0x8,%esp
  802464:	68 00 00 40 00       	push   $0x400000
  802469:	6a 00                	push   $0x0
  80246b:	e8 ab e8 ff ff       	call   800d1b <sys_page_unmap>
  802470:	83 c4 10             	add    $0x10,%esp
  802473:	eb 4f                	jmp    8024c4 <map_segment+0x15c>
			} else {
				// can map buffer cache read only
				if ((r = read_map(fd, fileoffset + i, &blk)) < 0)
  802475:	83 ec 04             	sub    $0x4,%esp
  802478:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80247b:	50                   	push   %eax
  80247c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80247f:	01 d8                	add    %ebx,%eax
  802481:	50                   	push   %eax
  802482:	ff 75 14             	pushl  0x14(%ebp)
  802485:	e8 11 f6 ff ff       	call   801a9b <read_map>
  80248a:	83 c4 10             	add    $0x10,%esp
  80248d:	85 c0                	test   %eax,%eax
  80248f:	78 47                	js     8024d8 <map_segment+0x170>
					return r;
				if ((r = sys_page_map(0, blk, child, (void*) (va + i), perm)) < 0)
  802491:	83 ec 0c             	sub    $0xc,%esp
  802494:	ff 75 20             	pushl  0x20(%ebp)
  802497:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80249a:	50                   	push   %eax
  80249b:	ff 75 08             	pushl  0x8(%ebp)
  80249e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8024a1:	6a 00                	push   $0x0
  8024a3:	e8 31 e8 ff ff       	call   800cd9 <sys_page_map>
  8024a8:	83 c4 20             	add    $0x20,%esp
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	79 15                	jns    8024c4 <map_segment+0x15c>
					panic("spawn: sys_page_map text: %e", r);
  8024af:	50                   	push   %eax
  8024b0:	68 7d 36 80 00       	push   $0x80367d
  8024b5:	68 15 01 00 00       	push   $0x115
  8024ba:	68 23 36 80 00       	push   $0x803623
  8024bf:	e8 0c dd ff ff       	call   8001d0 <_panic>
  8024c4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8024ca:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8024cd:	0f 82 c6 fe ff ff    	jb     802399 <map_segment+0x31>
			}
		}
	}
	return 0;
  8024d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8024db:	5b                   	pop    %ebx
  8024dc:	5e                   	pop    %esi
  8024dd:	5f                   	pop    %edi
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child) {
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	57                   	push   %edi
  8024e4:	56                   	push   %esi
  8024e5:	53                   	push   %ebx
  8024e6:	83 ec 0c             	sub    $0xc,%esp
  // LAB 7: Your code here.

  int i,j, r;
  void* va;

  for (i=0; i < VPD(UTOP); i++) {
  8024e9:	be 00 00 00 00       	mov    $0x0,%esi
    if (vpd[i] & PTE_P) {
  8024ee:	8b 04 b5 00 d0 7b ef 	mov    0xef7bd000(,%esi,4),%eax
  8024f5:	a8 01                	test   $0x1,%al
  8024f7:	74 68                	je     802561 <copy_shared_pages+0x81>
      for (j=0; j<NPTENTRIES && i*NPDENTRIES+j < (UXSTACKTOP-PGSIZE)/PGSIZE; j++) { // make sure not to remap exception stack this way
  8024f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024fe:	89 f0                	mov    %esi,%eax
  802500:	c1 e0 0a             	shl    $0xa,%eax
  802503:	89 c2                	mov    %eax,%edx
  802505:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  80250a:	77 55                	ja     802561 <copy_shared_pages+0x81>
  80250c:	89 c7                	mov    %eax,%edi
        if ((vpt[i*NPDENTRIES+j] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  80250e:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  802511:	8b 04 8d 00 00 40 ef 	mov    0xef400000(,%ecx,4),%eax
  802518:	25 01 04 00 00       	and    $0x401,%eax
  80251d:	3d 01 04 00 00       	cmp    $0x401,%eax
  802522:	75 28                	jne    80254c <copy_shared_pages+0x6c>
          va = (void *)((i*NPDENTRIES+j) << PGSHIFT);
  802524:	89 ca                	mov    %ecx,%edx
  802526:	c1 e2 0c             	shl    $0xc,%edx
          if ((r = sys_page_map(0, va, child, va, vpt[i*NPDENTRIES+j] & PTE_USER)) < 0) {
  802529:	83 ec 0c             	sub    $0xc,%esp
  80252c:	8b 04 8d 00 00 40 ef 	mov    0xef400000(,%ecx,4),%eax
  802533:	25 07 0e 00 00       	and    $0xe07,%eax
  802538:	50                   	push   %eax
  802539:	52                   	push   %edx
  80253a:	ff 75 08             	pushl  0x8(%ebp)
  80253d:	52                   	push   %edx
  80253e:	6a 00                	push   $0x0
  802540:	e8 94 e7 ff ff       	call   800cd9 <sys_page_map>
  802545:	83 c4 20             	add    $0x20,%esp
  802548:	85 c0                	test   %eax,%eax
  80254a:	78 23                	js     80256f <copy_shared_pages+0x8f>
  80254c:	43                   	inc    %ebx
  80254d:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  802553:	7f 0c                	jg     802561 <copy_shared_pages+0x81>
  802555:	89 fa                	mov    %edi,%edx
  802557:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80255a:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  80255f:	76 ad                	jbe    80250e <copy_shared_pages+0x2e>
  802561:	46                   	inc    %esi
  802562:	81 fe ba 03 00 00    	cmp    $0x3ba,%esi
  802568:	76 84                	jbe    8024ee <copy_shared_pages+0xe>
            return r;
          }
        }
      }
    }
  }

  return 0;
  80256a:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80256f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802572:	5b                   	pop    %ebx
  802573:	5e                   	pop    %esi
  802574:	5f                   	pop    %edi
  802575:	c9                   	leave  
  802576:	c3                   	ret    
	...

00802578 <pipe>:
};

int
pipe(int pfd[2])
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	57                   	push   %edi
  80257c:	56                   	push   %esi
  80257d:	53                   	push   %ebx
  80257e:	83 ec 18             	sub    $0x18,%esp
  802581:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802584:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  802587:	50                   	push   %eax
  802588:	e8 2b ee ff ff       	call   8013b8 <fd_alloc>
  80258d:	89 c3                	mov    %eax,%ebx
  80258f:	83 c4 10             	add    $0x10,%esp
  802592:	85 c0                	test   %eax,%eax
  802594:	0f 88 25 01 00 00    	js     8026bf <pipe+0x147>
  80259a:	83 ec 04             	sub    $0x4,%esp
  80259d:	68 07 04 00 00       	push   $0x407
  8025a2:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8025a5:	6a 00                	push   $0x0
  8025a7:	e8 ea e6 ff ff       	call   800c96 <sys_page_alloc>
  8025ac:	89 c3                	mov    %eax,%ebx
  8025ae:	83 c4 10             	add    $0x10,%esp
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	0f 88 06 01 00 00    	js     8026bf <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025b9:	83 ec 0c             	sub    $0xc,%esp
  8025bc:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  8025bf:	50                   	push   %eax
  8025c0:	e8 f3 ed ff ff       	call   8013b8 <fd_alloc>
  8025c5:	89 c3                	mov    %eax,%ebx
  8025c7:	83 c4 10             	add    $0x10,%esp
  8025ca:	85 c0                	test   %eax,%eax
  8025cc:	0f 88 dd 00 00 00    	js     8026af <pipe+0x137>
  8025d2:	83 ec 04             	sub    $0x4,%esp
  8025d5:	68 07 04 00 00       	push   $0x407
  8025da:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8025dd:	6a 00                	push   $0x0
  8025df:	e8 b2 e6 ff ff       	call   800c96 <sys_page_alloc>
  8025e4:	89 c3                	mov    %eax,%ebx
  8025e6:	83 c4 10             	add    $0x10,%esp
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	0f 88 be 00 00 00    	js     8026af <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025f1:	83 ec 0c             	sub    $0xc,%esp
  8025f4:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8025f7:	e8 94 ed ff ff       	call   801390 <fd2data>
  8025fc:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fe:	83 c4 0c             	add    $0xc,%esp
  802601:	68 07 04 00 00       	push   $0x407
  802606:	50                   	push   %eax
  802607:	6a 00                	push   $0x0
  802609:	e8 88 e6 ff ff       	call   800c96 <sys_page_alloc>
  80260e:	89 c3                	mov    %eax,%ebx
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	85 c0                	test   %eax,%eax
  802615:	0f 88 84 00 00 00    	js     80269f <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261b:	83 ec 0c             	sub    $0xc,%esp
  80261e:	68 07 04 00 00       	push   $0x407
  802623:	83 ec 0c             	sub    $0xc,%esp
  802626:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802629:	e8 62 ed ff ff       	call   801390 <fd2data>
  80262e:	83 c4 10             	add    $0x10,%esp
  802631:	50                   	push   %eax
  802632:	6a 00                	push   $0x0
  802634:	56                   	push   %esi
  802635:	6a 00                	push   $0x0
  802637:	e8 9d e6 ff ff       	call   800cd9 <sys_page_map>
  80263c:	89 c3                	mov    %eax,%ebx
  80263e:	83 c4 20             	add    $0x20,%esp
  802641:	85 c0                	test   %eax,%eax
  802643:	78 4c                	js     802691 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802645:	8b 15 40 70 80 00    	mov    0x807040,%edx
  80264b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80264e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802650:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802653:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80265a:	8b 15 40 70 80 00    	mov    0x807040,%edx
  802660:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802663:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802665:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802668:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80266f:	83 ec 0c             	sub    $0xc,%esp
  802672:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802675:	e8 2e ed ff ff       	call   8013a8 <fd2num>
  80267a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80267c:	83 c4 04             	add    $0x4,%esp
  80267f:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802682:	e8 21 ed ff ff       	call   8013a8 <fd2num>
  802687:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  80268a:	b8 00 00 00 00       	mov    $0x0,%eax
  80268f:	eb 30                	jmp    8026c1 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  802691:	83 ec 08             	sub    $0x8,%esp
  802694:	56                   	push   %esi
  802695:	6a 00                	push   $0x0
  802697:	e8 7f e6 ff ff       	call   800d1b <sys_page_unmap>
  80269c:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80269f:	83 ec 08             	sub    $0x8,%esp
  8026a2:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8026a5:	6a 00                	push   $0x0
  8026a7:	e8 6f e6 ff ff       	call   800d1b <sys_page_unmap>
  8026ac:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8026af:	83 ec 08             	sub    $0x8,%esp
  8026b2:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8026b5:	6a 00                	push   $0x0
  8026b7:	e8 5f e6 ff ff       	call   800d1b <sys_page_unmap>
  8026bc:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  8026bf:	89 d8                	mov    %ebx,%eax
}
  8026c1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8026c4:	5b                   	pop    %ebx
  8026c5:	5e                   	pop    %esi
  8026c6:	5f                   	pop    %edi
  8026c7:	c9                   	leave  
  8026c8:	c3                   	ret    

008026c9 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026c9:	55                   	push   %ebp
  8026ca:	89 e5                	mov    %esp,%ebp
  8026cc:	57                   	push   %edi
  8026cd:	56                   	push   %esi
  8026ce:	53                   	push   %ebx
  8026cf:	83 ec 0c             	sub    $0xc,%esp
  8026d2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8026d5:	a1 80 70 80 00       	mov    0x807080,%eax
  8026da:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8026dd:	83 ec 0c             	sub    $0xc,%esp
  8026e0:	ff 75 08             	pushl  0x8(%ebp)
  8026e3:	e8 64 05 00 00       	call   802c4c <pageref>
  8026e8:	89 c3                	mov    %eax,%ebx
  8026ea:	89 3c 24             	mov    %edi,(%esp)
  8026ed:	e8 5a 05 00 00       	call   802c4c <pageref>
  8026f2:	83 c4 10             	add    $0x10,%esp
  8026f5:	39 c3                	cmp    %eax,%ebx
  8026f7:	0f 94 c0             	sete   %al
  8026fa:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  8026fd:	8b 0d 80 70 80 00    	mov    0x807080,%ecx
  802703:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  802706:	39 c6                	cmp    %eax,%esi
  802708:	74 1b                	je     802725 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  80270a:	83 fa 01             	cmp    $0x1,%edx
  80270d:	75 c6                	jne    8026d5 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80270f:	6a 01                	push   $0x1
  802711:	8b 41 58             	mov    0x58(%ecx),%eax
  802714:	50                   	push   %eax
  802715:	56                   	push   %esi
  802716:	68 c7 36 80 00       	push   $0x8036c7
  80271b:	e8 a0 db ff ff       	call   8002c0 <cprintf>
  802720:	83 c4 10             	add    $0x10,%esp
  802723:	eb b0                	jmp    8026d5 <_pipeisclosed+0xc>
	}
}
  802725:	89 d0                	mov    %edx,%eax
  802727:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80272a:	5b                   	pop    %ebx
  80272b:	5e                   	pop    %esi
  80272c:	5f                   	pop    %edi
  80272d:	c9                   	leave  
  80272e:	c3                   	ret    

0080272f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  80272f:	55                   	push   %ebp
  802730:	89 e5                	mov    %esp,%ebp
  802732:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802735:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802738:	50                   	push   %eax
  802739:	ff 75 08             	pushl  0x8(%ebp)
  80273c:	e8 d1 ec ff ff       	call   801412 <fd_lookup>
  802741:	83 c4 10             	add    $0x10,%esp
		return r;
  802744:	89 c2                	mov    %eax,%edx
  802746:	85 c0                	test   %eax,%eax
  802748:	78 19                	js     802763 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  80274a:	83 ec 0c             	sub    $0xc,%esp
  80274d:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802750:	e8 3b ec ff ff       	call   801390 <fd2data>
	return _pipeisclosed(fd, p);
  802755:	83 c4 08             	add    $0x8,%esp
  802758:	50                   	push   %eax
  802759:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80275c:	e8 68 ff ff ff       	call   8026c9 <_pipeisclosed>
  802761:	89 c2                	mov    %eax,%edx
}
  802763:	89 d0                	mov    %edx,%eax
  802765:	c9                   	leave  
  802766:	c3                   	ret    

00802767 <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
  80276a:	57                   	push   %edi
  80276b:	56                   	push   %esi
  80276c:	53                   	push   %ebx
  80276d:	83 ec 18             	sub    $0x18,%esp
  802770:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  802773:	57                   	push   %edi
  802774:	e8 17 ec ff ff       	call   801390 <fd2data>
  802779:	89 c3                	mov    %eax,%ebx
	if (debug)
  80277b:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80277e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802781:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802784:	be 00 00 00 00       	mov    $0x0,%esi
  802789:	3b 75 10             	cmp    0x10(%ebp),%esi
  80278c:	73 55                	jae    8027e3 <piperead+0x7c>
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
  80278e:	8b 03                	mov    (%ebx),%eax
  802790:	3b 43 04             	cmp    0x4(%ebx),%eax
  802793:	75 2c                	jne    8027c1 <piperead+0x5a>
  802795:	85 f6                	test   %esi,%esi
  802797:	74 04                	je     80279d <piperead+0x36>
  802799:	89 f0                	mov    %esi,%eax
  80279b:	eb 48                	jmp    8027e5 <piperead+0x7e>
  80279d:	83 ec 08             	sub    $0x8,%esp
  8027a0:	53                   	push   %ebx
  8027a1:	57                   	push   %edi
  8027a2:	e8 22 ff ff ff       	call   8026c9 <_pipeisclosed>
  8027a7:	83 c4 10             	add    $0x10,%esp
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	74 07                	je     8027b5 <piperead+0x4e>
  8027ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b3:	eb 30                	jmp    8027e5 <piperead+0x7e>
  8027b5:	e8 bd e4 ff ff       	call   800c77 <sys_yield>
  8027ba:	8b 03                	mov    (%ebx),%eax
  8027bc:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027bf:	74 d4                	je     802795 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027c1:	8b 13                	mov    (%ebx),%edx
  8027c3:	89 d0                	mov    %edx,%eax
  8027c5:	85 d2                	test   %edx,%edx
  8027c7:	79 03                	jns    8027cc <piperead+0x65>
  8027c9:	8d 42 1f             	lea    0x1f(%edx),%eax
  8027cc:	83 e0 e0             	and    $0xffffffe0,%eax
  8027cf:	29 c2                	sub    %eax,%edx
  8027d1:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  8027d5:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8027d8:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8027db:	ff 03                	incl   (%ebx)
  8027dd:	46                   	inc    %esi
  8027de:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027e1:	72 ab                	jb     80278e <piperead+0x27>
	}
	return i;
  8027e3:	89 f0                	mov    %esi,%eax
}
  8027e5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8027e8:	5b                   	pop    %ebx
  8027e9:	5e                   	pop    %esi
  8027ea:	5f                   	pop    %edi
  8027eb:	c9                   	leave  
  8027ec:	c3                   	ret    

008027ed <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8027ed:	55                   	push   %ebp
  8027ee:	89 e5                	mov    %esp,%ebp
  8027f0:	57                   	push   %edi
  8027f1:	56                   	push   %esi
  8027f2:	53                   	push   %ebx
  8027f3:	83 ec 18             	sub    $0x18,%esp
  8027f6:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  8027f9:	57                   	push   %edi
  8027fa:	e8 91 eb ff ff       	call   801390 <fd2data>
  8027ff:	89 c3                	mov    %eax,%ebx
	if (debug)
  802801:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802804:	8b 45 0c             	mov    0xc(%ebp),%eax
  802807:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80280a:	be 00 00 00 00       	mov    $0x0,%esi
  80280f:	3b 75 10             	cmp    0x10(%ebp),%esi
  802812:	73 55                	jae    802869 <pipewrite+0x7c>
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
  802814:	8b 03                	mov    (%ebx),%eax
  802816:	83 c0 20             	add    $0x20,%eax
  802819:	39 43 04             	cmp    %eax,0x4(%ebx)
  80281c:	72 27                	jb     802845 <pipewrite+0x58>
  80281e:	83 ec 08             	sub    $0x8,%esp
  802821:	53                   	push   %ebx
  802822:	57                   	push   %edi
  802823:	e8 a1 fe ff ff       	call   8026c9 <_pipeisclosed>
  802828:	83 c4 10             	add    $0x10,%esp
  80282b:	85 c0                	test   %eax,%eax
  80282d:	74 07                	je     802836 <pipewrite+0x49>
  80282f:	b8 00 00 00 00       	mov    $0x0,%eax
  802834:	eb 35                	jmp    80286b <pipewrite+0x7e>
  802836:	e8 3c e4 ff ff       	call   800c77 <sys_yield>
  80283b:	8b 03                	mov    (%ebx),%eax
  80283d:	83 c0 20             	add    $0x20,%eax
  802840:	39 43 04             	cmp    %eax,0x4(%ebx)
  802843:	73 d9                	jae    80281e <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802845:	8b 53 04             	mov    0x4(%ebx),%edx
  802848:	89 d0                	mov    %edx,%eax
  80284a:	85 d2                	test   %edx,%edx
  80284c:	79 03                	jns    802851 <pipewrite+0x64>
  80284e:	8d 42 1f             	lea    0x1f(%edx),%eax
  802851:	83 e0 e0             	and    $0xffffffe0,%eax
  802854:	29 c2                	sub    %eax,%edx
  802856:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  802859:	8a 04 31             	mov    (%ecx,%esi,1),%al
  80285c:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802860:	ff 43 04             	incl   0x4(%ebx)
  802863:	46                   	inc    %esi
  802864:	3b 75 10             	cmp    0x10(%ebp),%esi
  802867:	72 ab                	jb     802814 <pipewrite+0x27>
	}
	
	return i;
  802869:	89 f0                	mov    %esi,%eax
}
  80286b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80286e:	5b                   	pop    %ebx
  80286f:	5e                   	pop    %esi
  802870:	5f                   	pop    %edi
  802871:	c9                   	leave  
  802872:	c3                   	ret    

00802873 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
  802876:	56                   	push   %esi
  802877:	53                   	push   %ebx
  802878:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80287b:	83 ec 0c             	sub    $0xc,%esp
  80287e:	ff 75 08             	pushl  0x8(%ebp)
  802881:	e8 0a eb ff ff       	call   801390 <fd2data>
  802886:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802888:	83 c4 08             	add    $0x8,%esp
  80288b:	68 da 36 80 00       	push   $0x8036da
  802890:	53                   	push   %ebx
  802891:	e8 2e e0 ff ff       	call   8008c4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802896:	8b 46 04             	mov    0x4(%esi),%eax
  802899:	2b 06                	sub    (%esi),%eax
  80289b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8028a1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8028a8:	00 00 00 
	stat->st_dev = &devpipe;
  8028ab:	c7 83 88 00 00 00 40 	movl   $0x807040,0x88(%ebx)
  8028b2:	70 80 00 
	return 0;
}
  8028b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ba:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8028bd:	5b                   	pop    %ebx
  8028be:	5e                   	pop    %esi
  8028bf:	c9                   	leave  
  8028c0:	c3                   	ret    

008028c1 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  8028c1:	55                   	push   %ebp
  8028c2:	89 e5                	mov    %esp,%ebp
  8028c4:	53                   	push   %ebx
  8028c5:	83 ec 0c             	sub    $0xc,%esp
  8028c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8028cb:	53                   	push   %ebx
  8028cc:	6a 00                	push   $0x0
  8028ce:	e8 48 e4 ff ff       	call   800d1b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8028d3:	89 1c 24             	mov    %ebx,(%esp)
  8028d6:	e8 b5 ea ff ff       	call   801390 <fd2data>
  8028db:	83 c4 08             	add    $0x8,%esp
  8028de:	50                   	push   %eax
  8028df:	6a 00                	push   $0x0
  8028e1:	e8 35 e4 ff ff       	call   800d1b <sys_page_unmap>
}
  8028e6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8028e9:	c9                   	leave  
  8028ea:	c3                   	ret    
	...

008028ec <wait>:

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8028ec:	55                   	push   %ebp
  8028ed:	89 e5                	mov    %esp,%ebp
  8028ef:	56                   	push   %esi
  8028f0:	53                   	push   %ebx
  8028f1:	8b 75 08             	mov    0x8(%ebp),%esi
	volatile struct Env *e;

	assert(envid != 0);
  8028f4:	85 f6                	test   %esi,%esi
  8028f6:	75 16                	jne    80290e <wait+0x22>
  8028f8:	68 e1 36 80 00       	push   $0x8036e1
  8028fd:	68 af 35 80 00       	push   $0x8035af
  802902:	6a 09                	push   $0x9
  802904:	68 ec 36 80 00       	push   $0x8036ec
  802909:	e8 c2 d8 ff ff       	call   8001d0 <_panic>
	e = &envs[ENVX(envid)];
  80290e:	89 f3                	mov    %esi,%ebx
  802910:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802916:	89 d8                	mov    %ebx,%eax
  802918:	c1 e0 07             	shl    $0x7,%eax
  80291b:	8d 98 00 00 c0 ee    	lea    0xeec00000(%eax),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
		sys_yield();
  802921:	8b 43 4c             	mov    0x4c(%ebx),%eax
  802924:	39 f0                	cmp    %esi,%eax
  802926:	75 1a                	jne    802942 <wait+0x56>
  802928:	8b 43 54             	mov    0x54(%ebx),%eax
  80292b:	85 c0                	test   %eax,%eax
  80292d:	74 13                	je     802942 <wait+0x56>
  80292f:	e8 43 e3 ff ff       	call   800c77 <sys_yield>
  802934:	8b 43 4c             	mov    0x4c(%ebx),%eax
  802937:	39 f0                	cmp    %esi,%eax
  802939:	75 07                	jne    802942 <wait+0x56>
  80293b:	8b 43 54             	mov    0x54(%ebx),%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	75 ed                	jne    80292f <wait+0x43>
}
  802942:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802945:	5b                   	pop    %ebx
  802946:	5e                   	pop    %esi
  802947:	c9                   	leave  
  802948:	c3                   	ret    
  802949:	00 00                	add    %al,(%eax)
	...

0080294c <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
  80294f:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  802952:	8b 45 08             	mov    0x8(%ebp),%eax
  802955:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802958:	6a 01                	push   $0x1
  80295a:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  80295d:	50                   	push   %eax
  80295e:	e8 71 e2 ff ff       	call   800bd4 <sys_cputs>
}
  802963:	c9                   	leave  
  802964:	c3                   	ret    

00802965 <getchar>:

int
getchar(void)
{
  802965:	55                   	push   %ebp
  802966:	89 e5                	mov    %esp,%ebp
  802968:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80296b:	6a 01                	push   $0x1
  80296d:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802970:	50                   	push   %eax
  802971:	6a 00                	push   $0x0
  802973:	e8 2d ed ff ff       	call   8016a5 <read>
	if (r < 0)
  802978:	83 c4 10             	add    $0x10,%esp
		return r;
  80297b:	89 c2                	mov    %eax,%edx
  80297d:	85 c0                	test   %eax,%eax
  80297f:	78 0d                	js     80298e <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  802981:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  802986:	85 c0                	test   %eax,%eax
  802988:	7e 04                	jle    80298e <getchar+0x29>
	return c;
  80298a:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  80298e:	89 d0                	mov    %edx,%eax
  802990:	c9                   	leave  
  802991:	c3                   	ret    

00802992 <iscons>:


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
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
  802995:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802998:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80299b:	50                   	push   %eax
  80299c:	ff 75 08             	pushl  0x8(%ebp)
  80299f:	e8 6e ea ff ff       	call   801412 <fd_lookup>
  8029a4:	83 c4 10             	add    $0x10,%esp
		return r;
  8029a7:	89 c2                	mov    %eax,%edx
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	78 11                	js     8029be <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  8029ad:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	3b 05 60 70 80 00    	cmp    0x807060,%eax
  8029b8:	0f 94 c0             	sete   %al
  8029bb:	0f b6 d0             	movzbl %al,%edx
}
  8029be:	89 d0                	mov    %edx,%eax
  8029c0:	c9                   	leave  
  8029c1:	c3                   	ret    

008029c2 <opencons>:

int
opencons(void)
{
  8029c2:	55                   	push   %ebp
  8029c3:	89 e5                	mov    %esp,%ebp
  8029c5:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029c8:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8029cb:	50                   	push   %eax
  8029cc:	e8 e7 e9 ff ff       	call   8013b8 <fd_alloc>
  8029d1:	83 c4 10             	add    $0x10,%esp
		return r;
  8029d4:	89 c2                	mov    %eax,%edx
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	78 3c                	js     802a16 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029da:	83 ec 04             	sub    $0x4,%esp
  8029dd:	68 07 04 00 00       	push   $0x407
  8029e2:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8029e5:	6a 00                	push   $0x0
  8029e7:	e8 aa e2 ff ff       	call   800c96 <sys_page_alloc>
  8029ec:	83 c4 10             	add    $0x10,%esp
		return r;
  8029ef:	89 c2                	mov    %eax,%edx
  8029f1:	85 c0                	test   %eax,%eax
  8029f3:	78 21                	js     802a16 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8029f5:	a1 60 70 80 00       	mov    0x807060,%eax
  8029fa:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  8029fd:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  8029ff:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802a02:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a09:	83 ec 0c             	sub    $0xc,%esp
  802a0c:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802a0f:	e8 94 e9 ff ff       	call   8013a8 <fd2num>
  802a14:	89 c2                	mov    %eax,%edx
}
  802a16:	89 d0                	mov    %edx,%eax
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

00802a1a <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
  802a1d:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  802a20:	b8 00 00 00 00       	mov    $0x0,%eax
  802a25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a29:	74 2a                	je     802a55 <cons_read+0x3b>
  802a2b:	eb 05                	jmp    802a32 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802a2d:	e8 45 e2 ff ff       	call   800c77 <sys_yield>
  802a32:	e8 c1 e1 ff ff       	call   800bf8 <sys_cgetc>
  802a37:	89 c2                	mov    %eax,%edx
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	74 f0                	je     802a2d <cons_read+0x13>
	if (c < 0)
  802a3d:	85 d2                	test   %edx,%edx
  802a3f:	78 14                	js     802a55 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802a41:	b8 00 00 00 00       	mov    $0x0,%eax
  802a46:	83 fa 04             	cmp    $0x4,%edx
  802a49:	74 0a                	je     802a55 <cons_read+0x3b>
	*(char*)vbuf = c;
  802a4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a4e:	88 10                	mov    %dl,(%eax)
	return 1;
  802a50:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802a55:	c9                   	leave  
  802a56:	c3                   	ret    

00802a57 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  802a57:	55                   	push   %ebp
  802a58:	89 e5                	mov    %esp,%ebp
  802a5a:	57                   	push   %edi
  802a5b:	56                   	push   %esi
  802a5c:	53                   	push   %ebx
  802a5d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  802a63:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a66:	be 00 00 00 00       	mov    $0x0,%esi
  802a6b:	39 fe                	cmp    %edi,%esi
  802a6d:	73 3d                	jae    802aac <cons_write+0x55>
		m = n - tot;
  802a6f:	89 fb                	mov    %edi,%ebx
  802a71:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  802a73:	83 fb 7f             	cmp    $0x7f,%ebx
  802a76:	76 05                	jbe    802a7d <cons_write+0x26>
			m = sizeof(buf) - 1;
  802a78:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802a7d:	83 ec 04             	sub    $0x4,%esp
  802a80:	53                   	push   %ebx
  802a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a84:	01 f0                	add    %esi,%eax
  802a86:	50                   	push   %eax
  802a87:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802a8d:	50                   	push   %eax
  802a8e:	e8 ad df ff ff       	call   800a40 <memmove>
		sys_cputs(buf, m);
  802a93:	83 c4 08             	add    $0x8,%esp
  802a96:	53                   	push   %ebx
  802a97:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802a9d:	50                   	push   %eax
  802a9e:	e8 31 e1 ff ff       	call   800bd4 <sys_cputs>
  802aa3:	83 c4 10             	add    $0x10,%esp
  802aa6:	01 de                	add    %ebx,%esi
  802aa8:	39 fe                	cmp    %edi,%esi
  802aaa:	72 c3                	jb     802a6f <cons_write+0x18>
	}
	return tot;
}
  802aac:	89 f0                	mov    %esi,%eax
  802aae:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802ab1:	5b                   	pop    %ebx
  802ab2:	5e                   	pop    %esi
  802ab3:	5f                   	pop    %edi
  802ab4:	c9                   	leave  
  802ab5:	c3                   	ret    

00802ab6 <cons_close>:

int
cons_close(struct Fd *fd)
{
  802ab6:	55                   	push   %ebp
  802ab7:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802ab9:	b8 00 00 00 00       	mov    $0x0,%eax
  802abe:	c9                   	leave  
  802abf:	c3                   	ret    

00802ac0 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  802ac0:	55                   	push   %ebp
  802ac1:	89 e5                	mov    %esp,%ebp
  802ac3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802ac6:	68 fc 36 80 00       	push   $0x8036fc
  802acb:	ff 75 0c             	pushl  0xc(%ebp)
  802ace:	e8 f1 dd ff ff       	call   8008c4 <strcpy>
	return 0;
}
  802ad3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad8:	c9                   	leave  
  802ad9:	c3                   	ret    
	...

00802adc <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802adc:	55                   	push   %ebp
  802add:	89 e5                	mov    %esp,%ebp
  802adf:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802ae2:	83 3d 88 70 80 00 00 	cmpl   $0x0,0x807088
  802ae9:	75 68                	jne    802b53 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  802aeb:	83 ec 04             	sub    $0x4,%esp
  802aee:	6a 07                	push   $0x7
  802af0:	68 00 f0 bf ee       	push   $0xeebff000
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	e8 5b e1 ff ff       	call   800c58 <sys_getenvid>
  802afd:	89 04 24             	mov    %eax,(%esp)
  802b00:	e8 91 e1 ff ff       	call   800c96 <sys_page_alloc>
  802b05:	83 c4 10             	add    $0x10,%esp
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	79 14                	jns    802b20 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  802b0c:	83 ec 04             	sub    $0x4,%esp
  802b0f:	68 04 37 80 00       	push   $0x803704
  802b14:	6a 21                	push   $0x21
  802b16:	68 65 37 80 00       	push   $0x803765
  802b1b:	e8 b0 d6 ff ff       	call   8001d0 <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  802b20:	83 ec 08             	sub    $0x8,%esp
  802b23:	68 60 2b 80 00       	push   $0x802b60
  802b28:	83 ec 04             	sub    $0x4,%esp
  802b2b:	e8 28 e1 ff ff       	call   800c58 <sys_getenvid>
  802b30:	89 04 24             	mov    %eax,(%esp)
  802b33:	e8 a9 e2 ff ff       	call   800de1 <sys_env_set_pgfault_upcall>
  802b38:	83 c4 10             	add    $0x10,%esp
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	79 14                	jns    802b53 <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	68 34 37 80 00       	push   $0x803734
  802b47:	6a 24                	push   $0x24
  802b49:	68 65 37 80 00       	push   $0x803765
  802b4e:	e8 7d d6 ff ff       	call   8001d0 <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	a3 88 70 80 00       	mov    %eax,0x807088
}
  802b5b:	c9                   	leave  
  802b5c:	c3                   	ret    
  802b5d:	00 00                	add    %al,(%eax)
	...

00802b60 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b60:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b61:	a1 88 70 80 00       	mov    0x807088,%eax
	call *%eax
  802b66:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b68:	83 c4 04             	add    $0x4,%esp
	
	// Now the C page fault handler has returned and you must return
	// to the trap time state.
	// Push trap-time %eip onto the trap-time stack.
	//
	// Explanation:
	//   We must prepare the trap-time stack for our eventual return to
	//   re-execute the instruction that faulted.
	//   Unfortunately, we can't return directly from the exception stack:
	//   We can't call 'jmp', since that requires that we load the address
	//   into a register, and all registers must have their trap-time
	//   values after the return.
	//   We can't call 'ret' from the exception stack either, since if we
	//   did, %esp would have the wrong value.
	//   So instead, we push the trap-time %eip onto the *trap-time* stack!
	//   Below we'll switch to that stack and call 'ret', which will
	//   restore %eip to its pre-fault value.
	//
	//   In the case of a recursive fault on the exception stack,
	//   note that the word we're pushing now will fit in the
	//   blank word that the kernel reserved for us.
	//
	// Hints:
	//   What registers are available for intermediate calculations?
	//
	// LAB 4: Your code here.
        // seanyliu
	// Push trap-time %eip onto the trap-time stack.
        // obtain the trape-time %esp
        movl 12*4(%esp), %eax
  802b6b:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  802b6f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  802b73:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  802b76:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  802b79:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  802b7c:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  802b80:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  802b83:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  802b87:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  802b88:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  802b8b:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  802b8c:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  802b8d:	c3                   	ret    
	...

00802b90 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802b90:	55                   	push   %ebp
  802b91:	89 e5                	mov    %esp,%ebp
  802b93:	56                   	push   %esi
  802b94:	53                   	push   %ebx
  802b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9b:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	75 12                	jne    802bb4 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  802ba2:	83 ec 0c             	sub    $0xc,%esp
  802ba5:	68 00 00 c0 ee       	push   $0xeec00000
  802baa:	e8 97 e2 ff ff       	call   800e46 <sys_ipc_recv>
  802baf:	83 c4 10             	add    $0x10,%esp
  802bb2:	eb 0c                	jmp    802bc0 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802bb4:	83 ec 0c             	sub    $0xc,%esp
  802bb7:	50                   	push   %eax
  802bb8:	e8 89 e2 ff ff       	call   800e46 <sys_ipc_recv>
  802bbd:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802bc0:	89 c2                	mov    %eax,%edx
  802bc2:	85 c0                	test   %eax,%eax
  802bc4:	78 24                	js     802bea <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  802bc6:	85 db                	test   %ebx,%ebx
  802bc8:	74 0a                	je     802bd4 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  802bca:	a1 80 70 80 00       	mov    0x807080,%eax
  802bcf:	8b 40 74             	mov    0x74(%eax),%eax
  802bd2:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802bd4:	85 f6                	test   %esi,%esi
  802bd6:	74 0a                	je     802be2 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802bd8:	a1 80 70 80 00       	mov    0x807080,%eax
  802bdd:	8b 40 78             	mov    0x78(%eax),%eax
  802be0:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  802be2:	a1 80 70 80 00       	mov    0x807080,%eax
  802be7:	8b 50 70             	mov    0x70(%eax),%edx

}
  802bea:	89 d0                	mov    %edx,%eax
  802bec:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802bef:	5b                   	pop    %ebx
  802bf0:	5e                   	pop    %esi
  802bf1:	c9                   	leave  
  802bf2:	c3                   	ret    

00802bf3 <ipc_send>:

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
  802bf3:	55                   	push   %ebp
  802bf4:	89 e5                	mov    %esp,%ebp
  802bf6:	57                   	push   %edi
  802bf7:	56                   	push   %esi
  802bf8:	53                   	push   %ebx
  802bf9:	83 ec 0c             	sub    $0xc,%esp
  802bfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802bff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802c02:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802c05:	85 db                	test   %ebx,%ebx
  802c07:	75 0a                	jne    802c13 <ipc_send+0x20>
    pg = (void *) UTOP;
  802c09:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  802c0e:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  802c13:	56                   	push   %esi
  802c14:	53                   	push   %ebx
  802c15:	57                   	push   %edi
  802c16:	ff 75 08             	pushl  0x8(%ebp)
  802c19:	e8 05 e2 ff ff       	call   800e23 <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  802c1e:	83 c4 10             	add    $0x10,%esp
  802c21:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c24:	75 07                	jne    802c2d <ipc_send+0x3a>
      sys_yield();
  802c26:	e8 4c e0 ff ff       	call   800c77 <sys_yield>
  802c2b:	eb e6                	jmp    802c13 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	79 12                	jns    802c43 <ipc_send+0x50>
  802c31:	50                   	push   %eax
  802c32:	68 73 37 80 00       	push   $0x803773
  802c37:	6a 49                	push   $0x49
  802c39:	68 90 37 80 00       	push   $0x803790
  802c3e:	e8 8d d5 ff ff       	call   8001d0 <_panic>
    else break;
  }
}
  802c43:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802c46:	5b                   	pop    %ebx
  802c47:	5e                   	pop    %esi
  802c48:	5f                   	pop    %edi
  802c49:	c9                   	leave  
  802c4a:	c3                   	ret    
	...

00802c4c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c4c:	55                   	push   %ebp
  802c4d:	89 e5                	mov    %esp,%ebp
  802c4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802c52:	89 c8                	mov    %ecx,%eax
  802c54:	c1 e8 16             	shr    $0x16,%eax
  802c57:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  802c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  802c63:	a8 01                	test   $0x1,%al
  802c65:	74 28                	je     802c8f <pageref+0x43>
	pte = vpt[VPN(v)];
  802c67:	89 c8                	mov    %ecx,%eax
  802c69:	c1 e8 0c             	shr    $0xc,%eax
  802c6c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  802c73:	ba 00 00 00 00       	mov    $0x0,%edx
  802c78:	a8 01                	test   $0x1,%al
  802c7a:	74 13                	je     802c8f <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  802c7c:	c1 e8 0c             	shr    $0xc,%eax
  802c7f:	8d 04 40             	lea    (%eax,%eax,2),%eax
  802c82:	c1 e0 02             	shl    $0x2,%eax
  802c85:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802c8c:	0f b7 d0             	movzwl %ax,%edx
}
  802c8f:	89 d0                	mov    %edx,%eax
  802c91:	c9                   	leave  
  802c92:	c3                   	ret    
	...

00802c94 <__udivdi3>:
  802c94:	55                   	push   %ebp
  802c95:	89 e5                	mov    %esp,%ebp
  802c97:	57                   	push   %edi
  802c98:	56                   	push   %esi
  802c99:	83 ec 14             	sub    $0x14,%esp
  802c9c:	8b 55 14             	mov    0x14(%ebp),%edx
  802c9f:	8b 75 08             	mov    0x8(%ebp),%esi
  802ca2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  802ca8:	85 d2                	test   %edx,%edx
  802caa:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802cad:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802cb0:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802cb3:	89 fe                	mov    %edi,%esi
  802cb5:	75 11                	jne    802cc8 <__udivdi3+0x34>
  802cb7:	39 f8                	cmp    %edi,%eax
  802cb9:	76 4d                	jbe    802d08 <__udivdi3+0x74>
  802cbb:	89 fa                	mov    %edi,%edx
  802cbd:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802cc0:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802cc3:	89 c7                	mov    %eax,%edi
  802cc5:	eb 09                	jmp    802cd0 <__udivdi3+0x3c>
  802cc7:	90                   	nop    
  802cc8:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  802ccb:	76 17                	jbe    802ce4 <__udivdi3+0x50>
  802ccd:	31 ff                	xor    %edi,%edi
  802ccf:	90                   	nop    
  802cd0:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  802cd7:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802cda:	83 c4 14             	add    $0x14,%esp
  802cdd:	5e                   	pop    %esi
  802cde:	89 f8                	mov    %edi,%eax
  802ce0:	5f                   	pop    %edi
  802ce1:	c9                   	leave  
  802ce2:	c3                   	ret    
  802ce3:	90                   	nop    
  802ce4:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802ce8:	89 c7                	mov    %eax,%edi
  802cea:	83 f7 1f             	xor    $0x1f,%edi
  802ced:	75 4d                	jne    802d3c <__udivdi3+0xa8>
  802cef:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802cf2:	77 0a                	ja     802cfe <__udivdi3+0x6a>
  802cf4:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802cf7:	31 ff                	xor    %edi,%edi
  802cf9:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802cfc:	72 d2                	jb     802cd0 <__udivdi3+0x3c>
  802cfe:	bf 01 00 00 00       	mov    $0x1,%edi
  802d03:	eb cb                	jmp    802cd0 <__udivdi3+0x3c>
  802d05:	8d 76 00             	lea    0x0(%esi),%esi
  802d08:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	75 0e                	jne    802d1d <__udivdi3+0x89>
  802d0f:	b8 01 00 00 00       	mov    $0x1,%eax
  802d14:	31 c9                	xor    %ecx,%ecx
  802d16:	31 d2                	xor    %edx,%edx
  802d18:	f7 f1                	div    %ecx
  802d1a:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802d1d:	89 f0                	mov    %esi,%eax
  802d1f:	31 d2                	xor    %edx,%edx
  802d21:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802d24:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  802d27:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802d2a:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802d2d:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802d30:	83 c4 14             	add    $0x14,%esp
  802d33:	89 c7                	mov    %eax,%edi
  802d35:	5e                   	pop    %esi
  802d36:	89 f8                	mov    %edi,%eax
  802d38:	5f                   	pop    %edi
  802d39:	c9                   	leave  
  802d3a:	c3                   	ret    
  802d3b:	90                   	nop    
  802d3c:	b8 20 00 00 00       	mov    $0x20,%eax
  802d41:	29 f8                	sub    %edi,%eax
  802d43:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  802d46:	89 f9                	mov    %edi,%ecx
  802d48:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802d4b:	d3 e2                	shl    %cl,%edx
  802d4d:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802d50:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802d53:	d3 e8                	shr    %cl,%eax
  802d55:	09 c2                	or     %eax,%edx
  802d57:	89 f9                	mov    %edi,%ecx
  802d59:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  802d5c:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802d5f:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802d62:	89 f2                	mov    %esi,%edx
  802d64:	d3 ea                	shr    %cl,%edx
  802d66:	89 f9                	mov    %edi,%ecx
  802d68:	d3 e6                	shl    %cl,%esi
  802d6a:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802d6d:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802d70:	d3 e8                	shr    %cl,%eax
  802d72:	09 c6                	or     %eax,%esi
  802d74:	89 f9                	mov    %edi,%ecx
  802d76:	89 f0                	mov    %esi,%eax
  802d78:	f7 75 f4             	divl   0xfffffff4(%ebp)
  802d7b:	89 d6                	mov    %edx,%esi
  802d7d:	89 c7                	mov    %eax,%edi
  802d7f:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  802d82:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802d85:	f7 e7                	mul    %edi
  802d87:	39 f2                	cmp    %esi,%edx
  802d89:	77 0f                	ja     802d9a <__udivdi3+0x106>
  802d8b:	0f 85 3f ff ff ff    	jne    802cd0 <__udivdi3+0x3c>
  802d91:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802d94:	0f 86 36 ff ff ff    	jbe    802cd0 <__udivdi3+0x3c>
  802d9a:	4f                   	dec    %edi
  802d9b:	e9 30 ff ff ff       	jmp    802cd0 <__udivdi3+0x3c>

00802da0 <__umoddi3>:
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
  802da3:	57                   	push   %edi
  802da4:	56                   	push   %esi
  802da5:	83 ec 30             	sub    $0x30,%esp
  802da8:	8b 55 14             	mov    0x14(%ebp),%edx
  802dab:	8b 45 10             	mov    0x10(%ebp),%eax
  802dae:	89 d7                	mov    %edx,%edi
  802db0:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  802db3:	89 c6                	mov    %eax,%esi
  802db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	85 ff                	test   %edi,%edi
  802dbd:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802dc4:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802dcb:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  802dce:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802dd1:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802dd4:	75 3e                	jne    802e14 <__umoddi3+0x74>
  802dd6:	39 d6                	cmp    %edx,%esi
  802dd8:	0f 86 a2 00 00 00    	jbe    802e80 <__umoddi3+0xe0>
  802dde:	f7 f6                	div    %esi
  802de0:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802de3:	85 c9                	test   %ecx,%ecx
  802de5:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802de8:	74 1b                	je     802e05 <__umoddi3+0x65>
  802dea:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802ded:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802df0:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802df7:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802dfa:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802dfd:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802e00:	89 10                	mov    %edx,(%eax)
  802e02:	89 48 04             	mov    %ecx,0x4(%eax)
  802e05:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802e08:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802e0b:	83 c4 30             	add    $0x30,%esp
  802e0e:	5e                   	pop    %esi
  802e0f:	5f                   	pop    %edi
  802e10:	c9                   	leave  
  802e11:	c3                   	ret    
  802e12:	89 f6                	mov    %esi,%esi
  802e14:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  802e17:	76 1f                	jbe    802e38 <__umoddi3+0x98>
  802e19:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1c:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802e1f:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802e22:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802e25:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802e28:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802e2b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  802e2e:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802e31:	83 c4 30             	add    $0x30,%esp
  802e34:	5e                   	pop    %esi
  802e35:	5f                   	pop    %edi
  802e36:	c9                   	leave  
  802e37:	c3                   	ret    
  802e38:	0f bd c7             	bsr    %edi,%eax
  802e3b:	83 f0 1f             	xor    $0x1f,%eax
  802e3e:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  802e41:	75 61                	jne    802ea4 <__umoddi3+0x104>
  802e43:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  802e46:	77 05                	ja     802e4d <__umoddi3+0xad>
  802e48:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  802e4b:	72 10                	jb     802e5d <__umoddi3+0xbd>
  802e4d:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802e50:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802e53:	29 f0                	sub    %esi,%eax
  802e55:	19 fa                	sbb    %edi,%edx
  802e57:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802e5a:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802e5d:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802e60:	85 d2                	test   %edx,%edx
  802e62:	74 a1                	je     802e05 <__umoddi3+0x65>
  802e64:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802e67:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802e6a:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802e6d:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  802e70:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802e73:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802e76:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802e79:	89 01                	mov    %eax,(%ecx)
  802e7b:	89 51 04             	mov    %edx,0x4(%ecx)
  802e7e:	eb 85                	jmp    802e05 <__umoddi3+0x65>
  802e80:	85 f6                	test   %esi,%esi
  802e82:	75 0b                	jne    802e8f <__umoddi3+0xef>
  802e84:	b8 01 00 00 00       	mov    $0x1,%eax
  802e89:	31 d2                	xor    %edx,%edx
  802e8b:	f7 f6                	div    %esi
  802e8d:	89 c6                	mov    %eax,%esi
  802e8f:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802e92:	89 fa                	mov    %edi,%edx
  802e94:	f7 f6                	div    %esi
  802e96:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802e99:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802e9c:	f7 f6                	div    %esi
  802e9e:	e9 3d ff ff ff       	jmp    802de0 <__umoddi3+0x40>
  802ea3:	90                   	nop    
  802ea4:	b8 20 00 00 00       	mov    $0x20,%eax
  802ea9:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802eac:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  802eaf:	89 fa                	mov    %edi,%edx
  802eb1:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802eb4:	d3 e2                	shl    %cl,%edx
  802eb6:	89 f0                	mov    %esi,%eax
  802eb8:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802ebb:	d3 e8                	shr    %cl,%eax
  802ebd:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802ec0:	d3 e6                	shl    %cl,%esi
  802ec2:	89 d7                	mov    %edx,%edi
  802ec4:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802ec7:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802eca:	09 c7                	or     %eax,%edi
  802ecc:	d3 ea                	shr    %cl,%edx
  802ece:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802ed1:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802ed4:	d3 e0                	shl    %cl,%eax
  802ed6:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802ed9:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802edc:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802edf:	d3 e8                	shr    %cl,%eax
  802ee1:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802ee4:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802ee7:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802eea:	f7 f7                	div    %edi
  802eec:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802eef:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802ef2:	f7 e6                	mul    %esi
  802ef4:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  802ef7:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  802efa:	77 0a                	ja     802f06 <__umoddi3+0x166>
  802efc:	75 12                	jne    802f10 <__umoddi3+0x170>
  802efe:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802f01:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802f04:	76 0a                	jbe    802f10 <__umoddi3+0x170>
  802f06:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802f09:	29 f1                	sub    %esi,%ecx
  802f0b:	19 fa                	sbb    %edi,%edx
  802f0d:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802f10:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	0f 84 ea fe ff ff    	je     802e05 <__umoddi3+0x65>
  802f1b:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802f1e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802f21:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802f24:	19 d1                	sbb    %edx,%ecx
  802f26:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  802f29:	89 ca                	mov    %ecx,%edx
  802f2b:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802f2e:	d3 e2                	shl    %cl,%edx
  802f30:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802f33:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802f36:	d3 e8                	shr    %cl,%eax
  802f38:	09 c2                	or     %eax,%edx
  802f3a:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802f3d:	d3 e8                	shr    %cl,%eax
  802f3f:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802f42:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802f45:	e9 ad fe ff ff       	jmp    802df7 <__umoddi3+0x57>
