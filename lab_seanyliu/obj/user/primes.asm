
obj/user/primes:     file format elf32-i386

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
  80002c:	e8 bf 00 00 00       	call   8000f0 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:
#include <inc/lib.h>

unsigned
primeproc(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 10             	sub    $0x10,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	83 ec 04             	sub    $0x4,%esp
  80003f:	6a 00                	push   $0x0
  800041:	6a 00                	push   $0x0
  800043:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800046:	50                   	push   %eax
  800047:	e8 c0 12 00 00       	call   80130c <ipc_recv>
  80004c:	89 c3                	mov    %eax,%ebx
	cprintf("%d ", p);
  80004e:	83 c4 08             	add    $0x8,%esp
  800051:	50                   	push   %eax
  800052:	68 c0 28 80 00       	push   $0x8028c0
  800057:	e8 e0 01 00 00       	call   80023c <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80005c:	e8 21 11 00 00       	call   801182 <fork>
  800061:	89 c6                	mov    %eax,%esi
  800063:	83 c4 10             	add    $0x10,%esp
  800066:	85 c0                	test   %eax,%eax
  800068:	79 12                	jns    80007c <primeproc+0x48>
		panic("fork: %e", id);
  80006a:	50                   	push   %eax
  80006b:	68 c4 28 80 00       	push   $0x8028c4
  800070:	6a 1a                	push   $0x1a
  800072:	68 cd 28 80 00       	push   $0x8028cd
  800077:	e8 d0 00 00 00       	call   80014c <_panic>
	if (id == 0)
  80007c:	85 c0                	test   %eax,%eax
  80007e:	74 bc                	je     80003c <primeproc+0x8>
		goto top;
	
	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800080:	83 ec 04             	sub    $0x4,%esp
  800083:	6a 00                	push   $0x0
  800085:	6a 00                	push   $0x0
  800087:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80008a:	50                   	push   %eax
  80008b:	e8 7c 12 00 00       	call   80130c <ipc_recv>
  800090:	89 c1                	mov    %eax,%ecx
		if (i % p)
  800092:	99                   	cltd   
  800093:	f7 fb                	idiv   %ebx
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	85 d2                	test   %edx,%edx
  80009a:	74 e4                	je     800080 <primeproc+0x4c>
			ipc_send(id, i, 0, 0);
  80009c:	6a 00                	push   $0x0
  80009e:	6a 00                	push   $0x0
  8000a0:	51                   	push   %ecx
  8000a1:	56                   	push   %esi
  8000a2:	e8 c8 12 00 00       	call   80136f <ipc_send>
  8000a7:	83 c4 10             	add    $0x10,%esp
  8000aa:	eb d4                	jmp    800080 <primeproc+0x4c>

008000ac <umain>:
	}
}

void
umain(void)
{
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	56                   	push   %esi
  8000b0:	53                   	push   %ebx
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000b1:	e8 cc 10 00 00       	call   801182 <fork>
  8000b6:	89 c6                	mov    %eax,%esi
  8000b8:	85 c0                	test   %eax,%eax
  8000ba:	79 12                	jns    8000ce <umain+0x22>
		panic("fork: %e", id);
  8000bc:	50                   	push   %eax
  8000bd:	68 c4 28 80 00       	push   $0x8028c4
  8000c2:	6a 2d                	push   $0x2d
  8000c4:	68 cd 28 80 00       	push   $0x8028cd
  8000c9:	e8 7e 00 00 00       	call   80014c <_panic>
	if (id == 0)
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	75 05                	jne    8000d7 <umain+0x2b>
		primeproc();
  8000d2:	e8 5d ff ff ff       	call   800034 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
  8000d7:	bb 02 00 00 00       	mov    $0x2,%ebx
		ipc_send(id, i, 0, 0);
  8000dc:	6a 00                	push   $0x0
  8000de:	6a 00                	push   $0x0
  8000e0:	53                   	push   %ebx
  8000e1:	56                   	push   %esi
  8000e2:	e8 88 12 00 00       	call   80136f <ipc_send>
  8000e7:	83 c4 10             	add    $0x10,%esp
  8000ea:	43                   	inc    %ebx
  8000eb:	eb ef                	jmp    8000dc <umain+0x30>
  8000ed:	00 00                	add    %al,(%eax)
	...

008000f0 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000f0:	55                   	push   %ebp
  8000f1:	89 e5                	mov    %esp,%ebp
  8000f3:	56                   	push   %esi
  8000f4:	53                   	push   %ebx
  8000f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8000f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  8000fb:	e8 d4 0a 00 00       	call   800bd4 <sys_getenvid>
  800100:	25 ff 03 00 00       	and    $0x3ff,%eax
  800105:	c1 e0 07             	shl    $0x7,%eax
  800108:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010d:	a3 80 60 80 00       	mov    %eax,0x806080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800112:	85 f6                	test   %esi,%esi
  800114:	7e 07                	jle    80011d <libmain+0x2d>
		binaryname = argv[0];
  800116:	8b 03                	mov    (%ebx),%eax
  800118:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	53                   	push   %ebx
  800121:	56                   	push   %esi
  800122:	e8 85 ff ff ff       	call   8000ac <umain>

	// exit gracefully
	exit();
  800127:	e8 08 00 00 00       	call   800134 <exit>
}
  80012c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80012f:	5b                   	pop    %ebx
  800130:	5e                   	pop    %esi
  800131:	c9                   	leave  
  800132:	c3                   	ret    
	...

00800134 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80013a:	e8 59 14 00 00       	call   801598 <close_all>
	sys_env_destroy(0);
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	6a 00                	push   $0x0
  800144:	e8 4a 0a 00 00       	call   800b93 <sys_env_destroy>
}
  800149:	c9                   	leave  
  80014a:	c3                   	ret    
	...

0080014c <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80014c:	55                   	push   %ebp
  80014d:	89 e5                	mov    %esp,%ebp
  80014f:	53                   	push   %ebx
  800150:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  800153:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  800156:	83 3d 84 60 80 00 00 	cmpl   $0x0,0x806084
  80015d:	74 16                	je     800175 <_panic+0x29>
		cprintf("%s: ", argv0);
  80015f:	83 ec 08             	sub    $0x8,%esp
  800162:	ff 35 84 60 80 00    	pushl  0x806084
  800168:	68 f2 28 80 00       	push   $0x8028f2
  80016d:	e8 ca 00 00 00       	call   80023c <cprintf>
  800172:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800175:	ff 75 0c             	pushl  0xc(%ebp)
  800178:	ff 75 08             	pushl  0x8(%ebp)
  80017b:	ff 35 00 60 80 00    	pushl  0x806000
  800181:	68 f7 28 80 00       	push   $0x8028f7
  800186:	e8 b1 00 00 00       	call   80023c <cprintf>
	vcprintf(fmt, ap);
  80018b:	83 c4 08             	add    $0x8,%esp
  80018e:	53                   	push   %ebx
  80018f:	ff 75 10             	pushl  0x10(%ebp)
  800192:	e8 54 00 00 00       	call   8001eb <vcprintf>
	cprintf("\n");
  800197:	c7 04 24 11 2f 80 00 	movl   $0x802f11,(%esp)
  80019e:	e8 99 00 00 00       	call   80023c <cprintf>

	// Cause a breakpoint exception
	while (1)
  8001a3:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  8001a6:	cc                   	int3   
  8001a7:	eb fd                	jmp    8001a6 <_panic+0x5a>
  8001a9:	00 00                	add    %al,(%eax)
	...

008001ac <putch>:


static void
putch(int ch, struct printbuf *b)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	53                   	push   %ebx
  8001b0:	83 ec 04             	sub    $0x4,%esp
  8001b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b6:	8b 03                	mov    (%ebx),%eax
  8001b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bb:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  8001bf:	40                   	inc    %eax
  8001c0:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001c2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c7:	75 1a                	jne    8001e3 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	68 ff 00 00 00       	push   $0xff
  8001d1:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d4:	50                   	push   %eax
  8001d5:	e8 76 09 00 00       	call   800b50 <sys_cputs>
		b->idx = 0;
  8001da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001e0:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8001e3:	ff 43 04             	incl   0x4(%ebx)
}
  8001e6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8001e9:	c9                   	leave  
  8001ea:	c3                   	ret    

008001eb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001f4:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  8001fb:	00 00 00 
	b.cnt = 0;
  8001fe:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800205:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800208:	ff 75 0c             	pushl  0xc(%ebp)
  80020b:	ff 75 08             	pushl  0x8(%ebp)
  80020e:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800214:	50                   	push   %eax
  800215:	68 ac 01 80 00       	push   $0x8001ac
  80021a:	e8 4f 01 00 00       	call   80036e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80021f:	83 c4 08             	add    $0x8,%esp
  800222:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  800228:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  80022e:	50                   	push   %eax
  80022f:	e8 1c 09 00 00       	call   800b50 <sys_cputs>

	return b.cnt;
  800234:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800242:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800245:	50                   	push   %eax
  800246:	ff 75 08             	pushl  0x8(%ebp)
  800249:	e8 9d ff ff ff       	call   8001eb <vcprintf>
	va_end(ap);

	return cnt;
}
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	8b 75 10             	mov    0x10(%ebp),%esi
  80025c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80025f:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800262:	8b 45 18             	mov    0x18(%ebp),%eax
  800265:	ba 00 00 00 00       	mov    $0x0,%edx
  80026a:	39 fa                	cmp    %edi,%edx
  80026c:	77 39                	ja     8002a7 <printnum+0x57>
  80026e:	72 04                	jb     800274 <printnum+0x24>
  800270:	39 f0                	cmp    %esi,%eax
  800272:	77 33                	ja     8002a7 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	ff 75 20             	pushl  0x20(%ebp)
  80027a:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  80027d:	50                   	push   %eax
  80027e:	ff 75 18             	pushl  0x18(%ebp)
  800281:	8b 45 18             	mov    0x18(%ebp),%eax
  800284:	ba 00 00 00 00       	mov    $0x0,%edx
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	57                   	push   %edi
  80028c:	56                   	push   %esi
  80028d:	e8 76 23 00 00       	call   802608 <__udivdi3>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	52                   	push   %edx
  800296:	50                   	push   %eax
  800297:	ff 75 0c             	pushl  0xc(%ebp)
  80029a:	ff 75 08             	pushl  0x8(%ebp)
  80029d:	e8 ae ff ff ff       	call   800250 <printnum>
  8002a2:	83 c4 20             	add    $0x20,%esp
  8002a5:	eb 19                	jmp    8002c0 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a7:	4b                   	dec    %ebx
  8002a8:	85 db                	test   %ebx,%ebx
  8002aa:	7e 14                	jle    8002c0 <printnum+0x70>
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	ff 75 0c             	pushl  0xc(%ebp)
  8002b2:	ff 75 20             	pushl  0x20(%ebp)
  8002b5:	ff 55 08             	call   *0x8(%ebp)
  8002b8:	83 c4 10             	add    $0x10,%esp
  8002bb:	4b                   	dec    %ebx
  8002bc:	85 db                	test   %ebx,%ebx
  8002be:	7f ec                	jg     8002ac <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002c0:	83 ec 08             	sub    $0x8,%esp
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	8b 45 18             	mov    0x18(%ebp),%eax
  8002c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ce:	83 ec 04             	sub    $0x4,%esp
  8002d1:	52                   	push   %edx
  8002d2:	50                   	push   %eax
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	e8 3a 24 00 00       	call   802714 <__umoddi3>
  8002da:	83 c4 14             	add    $0x14,%esp
  8002dd:	0f be 80 0d 2a 80 00 	movsbl 0x802a0d(%eax),%eax
  8002e4:	50                   	push   %eax
  8002e5:	ff 55 08             	call   *0x8(%ebp)
}
  8002e8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8002eb:	5b                   	pop    %ebx
  8002ec:	5e                   	pop    %esi
  8002ed:	5f                   	pop    %edi
  8002ee:	c9                   	leave  
  8002ef:	c3                   	ret    

008002f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8002f9:	83 f8 01             	cmp    $0x1,%eax
  8002fc:	7e 0f                	jle    80030d <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  8002fe:	8b 01                	mov    (%ecx),%eax
  800300:	83 c0 08             	add    $0x8,%eax
  800303:	89 01                	mov    %eax,(%ecx)
  800305:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800308:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80030b:	eb 24                	jmp    800331 <getuint+0x41>
	else if (lflag)
  80030d:	85 c0                	test   %eax,%eax
  80030f:	74 11                	je     800322 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800311:	8b 01                	mov    (%ecx),%eax
  800313:	83 c0 04             	add    $0x4,%eax
  800316:	89 01                	mov    %eax,(%ecx)
  800318:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80031b:	ba 00 00 00 00       	mov    $0x0,%edx
  800320:	eb 0f                	jmp    800331 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  800322:	8b 01                	mov    (%ecx),%eax
  800324:	83 c0 04             	add    $0x4,%eax
  800327:	89 01                	mov    %eax,(%ecx)
  800329:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80032c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	8b 55 08             	mov    0x8(%ebp),%edx
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80033c:	83 f8 01             	cmp    $0x1,%eax
  80033f:	7e 0f                	jle    800350 <getint+0x1d>
		return va_arg(*ap, long long);
  800341:	8b 02                	mov    (%edx),%eax
  800343:	83 c0 08             	add    $0x8,%eax
  800346:	89 02                	mov    %eax,(%edx)
  800348:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80034b:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80034e:	eb 1c                	jmp    80036c <getint+0x39>
	else if (lflag)
  800350:	85 c0                	test   %eax,%eax
  800352:	74 0d                	je     800361 <getint+0x2e>
		return va_arg(*ap, long);
  800354:	8b 02                	mov    (%edx),%eax
  800356:	83 c0 04             	add    $0x4,%eax
  800359:	89 02                	mov    %eax,(%edx)
  80035b:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80035e:	99                   	cltd   
  80035f:	eb 0b                	jmp    80036c <getint+0x39>
	else
		return va_arg(*ap, int);
  800361:	8b 02                	mov    (%edx),%eax
  800363:	83 c0 04             	add    $0x4,%eax
  800366:	89 02                	mov    %eax,(%edx)
  800368:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80036b:	99                   	cltd   
}
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	57                   	push   %edi
  800372:	56                   	push   %esi
  800373:	53                   	push   %ebx
  800374:	83 ec 1c             	sub    $0x1c,%esp
  800377:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  80037a:	0f b6 13             	movzbl (%ebx),%edx
  80037d:	43                   	inc    %ebx
  80037e:	83 fa 25             	cmp    $0x25,%edx
  800381:	74 1e                	je     8003a1 <vprintfmt+0x33>
  800383:	85 d2                	test   %edx,%edx
  800385:	0f 84 d7 02 00 00    	je     800662 <vprintfmt+0x2f4>
  80038b:	83 ec 08             	sub    $0x8,%esp
  80038e:	ff 75 0c             	pushl  0xc(%ebp)
  800391:	52                   	push   %edx
  800392:	ff 55 08             	call   *0x8(%ebp)
  800395:	83 c4 10             	add    $0x10,%esp
  800398:	0f b6 13             	movzbl (%ebx),%edx
  80039b:	43                   	inc    %ebx
  80039c:	83 fa 25             	cmp    $0x25,%edx
  80039f:	75 e2                	jne    800383 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  8003a1:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  8003a5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  8003ac:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  8003b1:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  8003b6:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003bd:	0f b6 13             	movzbl (%ebx),%edx
  8003c0:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  8003c3:	43                   	inc    %ebx
  8003c4:	83 f8 55             	cmp    $0x55,%eax
  8003c7:	0f 87 70 02 00 00    	ja     80063d <vprintfmt+0x2cf>
  8003cd:	ff 24 85 9c 2a 80 00 	jmp    *0x802a9c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  8003d4:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  8003d8:	eb e3                	jmp    8003bd <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003da:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  8003de:	eb dd                	jmp    8003bd <vprintfmt+0x4f>

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
  8003e0:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  8003e5:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  8003e8:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  8003ec:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  8003ef:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  8003f2:	83 f8 09             	cmp    $0x9,%eax
  8003f5:	77 27                	ja     80041e <vprintfmt+0xb0>
  8003f7:	43                   	inc    %ebx
  8003f8:	eb eb                	jmp    8003e5 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003fa:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8003fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800401:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800404:	eb 18                	jmp    80041e <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  800406:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80040a:	79 b1                	jns    8003bd <vprintfmt+0x4f>
				width = 0;
  80040c:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800413:	eb a8                	jmp    8003bd <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800415:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  80041c:	eb 9f                	jmp    8003bd <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  80041e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800422:	79 99                	jns    8003bd <vprintfmt+0x4f>
				width = precision, precision = -1;
  800424:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  800427:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  80042c:	eb 8f                	jmp    8003bd <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80042e:	41                   	inc    %ecx
			goto reswitch;
  80042f:	eb 8c                	jmp    8003bd <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	ff 75 0c             	pushl  0xc(%ebp)
  800437:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80043b:	8b 45 14             	mov    0x14(%ebp),%eax
  80043e:	ff 70 fc             	pushl  0xfffffffc(%eax)
  800441:	ff 55 08             	call   *0x8(%ebp)
			break;
  800444:	83 c4 10             	add    $0x10,%esp
  800447:	e9 2e ff ff ff       	jmp    80037a <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80044c:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800450:	8b 45 14             	mov    0x14(%ebp),%eax
  800453:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  800456:	85 c0                	test   %eax,%eax
  800458:	79 02                	jns    80045c <vprintfmt+0xee>
				err = -err;
  80045a:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80045c:	83 f8 0e             	cmp    $0xe,%eax
  80045f:	7f 0b                	jg     80046c <vprintfmt+0xfe>
  800461:	8b 3c 85 60 2a 80 00 	mov    0x802a60(,%eax,4),%edi
  800468:	85 ff                	test   %edi,%edi
  80046a:	75 19                	jne    800485 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  80046c:	50                   	push   %eax
  80046d:	68 1e 2a 80 00       	push   $0x802a1e
  800472:	ff 75 0c             	pushl  0xc(%ebp)
  800475:	ff 75 08             	pushl  0x8(%ebp)
  800478:	e8 ed 01 00 00       	call   80066a <printfmt>
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	e9 f5 fe ff ff       	jmp    80037a <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800485:	57                   	push   %edi
  800486:	68 c9 2e 80 00       	push   $0x802ec9
  80048b:	ff 75 0c             	pushl  0xc(%ebp)
  80048e:	ff 75 08             	pushl  0x8(%ebp)
  800491:	e8 d4 01 00 00       	call   80066a <printfmt>
  800496:	83 c4 10             	add    $0x10,%esp
			break;
  800499:	e9 dc fe ff ff       	jmp    80037a <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80049e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a5:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  8004a8:	85 ff                	test   %edi,%edi
  8004aa:	75 05                	jne    8004b1 <vprintfmt+0x143>
				p = "(null)";
  8004ac:	bf 27 2a 80 00       	mov    $0x802a27,%edi
			if (width > 0 && padc != '-')
  8004b1:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004b5:	7e 3b                	jle    8004f2 <vprintfmt+0x184>
  8004b7:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  8004bb:	74 35                	je     8004f2 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	56                   	push   %esi
  8004c1:	57                   	push   %edi
  8004c2:	e8 56 03 00 00       	call   80081d <strnlen>
  8004c7:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  8004ca:	83 c4 10             	add    $0x10,%esp
  8004cd:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004d1:	7e 1f                	jle    8004f2 <vprintfmt+0x184>
  8004d3:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8004d7:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  8004e3:	ff 55 08             	call   *0x8(%ebp)
  8004e6:	83 c4 10             	add    $0x10,%esp
  8004e9:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8004ec:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004f0:	7f e8                	jg     8004da <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f2:	0f be 17             	movsbl (%edi),%edx
  8004f5:	47                   	inc    %edi
  8004f6:	85 d2                	test   %edx,%edx
  8004f8:	74 44                	je     80053e <vprintfmt+0x1d0>
  8004fa:	85 f6                	test   %esi,%esi
  8004fc:	78 03                	js     800501 <vprintfmt+0x193>
  8004fe:	4e                   	dec    %esi
  8004ff:	78 3d                	js     80053e <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800501:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800505:	74 18                	je     80051f <vprintfmt+0x1b1>
  800507:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80050a:	83 f8 5e             	cmp    $0x5e,%eax
  80050d:	76 10                	jbe    80051f <vprintfmt+0x1b1>
					putch('?', putdat);
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	ff 75 0c             	pushl  0xc(%ebp)
  800515:	6a 3f                	push   $0x3f
  800517:	ff 55 08             	call   *0x8(%ebp)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	eb 0d                	jmp    80052c <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  80051f:	83 ec 08             	sub    $0x8,%esp
  800522:	ff 75 0c             	pushl  0xc(%ebp)
  800525:	52                   	push   %edx
  800526:	ff 55 08             	call   *0x8(%ebp)
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80052f:	0f be 17             	movsbl (%edi),%edx
  800532:	47                   	inc    %edi
  800533:	85 d2                	test   %edx,%edx
  800535:	74 07                	je     80053e <vprintfmt+0x1d0>
  800537:	85 f6                	test   %esi,%esi
  800539:	78 c6                	js     800501 <vprintfmt+0x193>
  80053b:	4e                   	dec    %esi
  80053c:	79 c3                	jns    800501 <vprintfmt+0x193>
			for (; width > 0; width--)
  80053e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800542:	0f 8e 32 fe ff ff    	jle    80037a <vprintfmt+0xc>
				putch(' ', putdat);
  800548:	83 ec 08             	sub    $0x8,%esp
  80054b:	ff 75 0c             	pushl  0xc(%ebp)
  80054e:	6a 20                	push   $0x20
  800550:	ff 55 08             	call   *0x8(%ebp)
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800559:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80055d:	7f e9                	jg     800548 <vprintfmt+0x1da>
			break;
  80055f:	e9 16 fe ff ff       	jmp    80037a <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800564:	51                   	push   %ecx
  800565:	8d 45 14             	lea    0x14(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	e8 c5 fd ff ff       	call   800333 <getint>
  80056e:	89 c6                	mov    %eax,%esi
  800570:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  800572:	83 c4 08             	add    $0x8,%esp
  800575:	85 d2                	test   %edx,%edx
  800577:	79 15                	jns    80058e <vprintfmt+0x220>
				putch('-', putdat);
  800579:	83 ec 08             	sub    $0x8,%esp
  80057c:	ff 75 0c             	pushl  0xc(%ebp)
  80057f:	6a 2d                	push   $0x2d
  800581:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800584:	f7 de                	neg    %esi
  800586:	83 d7 00             	adc    $0x0,%edi
  800589:	f7 df                	neg    %edi
  80058b:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80058e:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800593:	eb 75                	jmp    80060a <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800595:	51                   	push   %ecx
  800596:	8d 45 14             	lea    0x14(%ebp),%eax
  800599:	50                   	push   %eax
  80059a:	e8 51 fd ff ff       	call   8002f0 <getuint>
  80059f:	89 c6                	mov    %eax,%esi
  8005a1:	89 d7                	mov    %edx,%edi
			base = 10;
  8005a3:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8005a8:	83 c4 08             	add    $0x8,%esp
  8005ab:	eb 5d                	jmp    80060a <vprintfmt+0x29c>

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
  8005ad:	51                   	push   %ecx
  8005ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8005b1:	50                   	push   %eax
  8005b2:	e8 39 fd ff ff       	call   8002f0 <getuint>
  8005b7:	89 c6                	mov    %eax,%esi
  8005b9:	89 d7                	mov    %edx,%edi
			base = 8;
  8005bb:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  8005c0:	83 c4 08             	add    $0x8,%esp
  8005c3:	eb 45                	jmp    80060a <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  8005c5:	83 ec 08             	sub    $0x8,%esp
  8005c8:	ff 75 0c             	pushl  0xc(%ebp)
  8005cb:	6a 30                	push   $0x30
  8005cd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8005d0:	83 c4 08             	add    $0x8,%esp
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	6a 78                	push   $0x78
  8005d8:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  8005db:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  8005e5:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8005ea:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	eb 16                	jmp    80060a <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8005f4:	51                   	push   %ecx
  8005f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8005f8:	50                   	push   %eax
  8005f9:	e8 f2 fc ff ff       	call   8002f0 <getuint>
  8005fe:	89 c6                	mov    %eax,%esi
  800600:	89 d7                	mov    %edx,%edi
			base = 16;
  800602:	ba 10 00 00 00       	mov    $0x10,%edx
  800607:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80060a:	83 ec 04             	sub    $0x4,%esp
  80060d:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800611:	50                   	push   %eax
  800612:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800615:	52                   	push   %edx
  800616:	57                   	push   %edi
  800617:	56                   	push   %esi
  800618:	ff 75 0c             	pushl  0xc(%ebp)
  80061b:	ff 75 08             	pushl  0x8(%ebp)
  80061e:	e8 2d fc ff ff       	call   800250 <printnum>
			break;
  800623:	83 c4 20             	add    $0x20,%esp
  800626:	e9 4f fd ff ff       	jmp    80037a <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	52                   	push   %edx
  800632:	ff 55 08             	call   *0x8(%ebp)
			break;
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	e9 3d fd ff ff       	jmp    80037a <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80063d:	83 ec 08             	sub    $0x8,%esp
  800640:	ff 75 0c             	pushl  0xc(%ebp)
  800643:	6a 25                	push   $0x25
  800645:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800648:	4b                   	dec    %ebx
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800650:	0f 84 24 fd ff ff    	je     80037a <vprintfmt+0xc>
  800656:	4b                   	dec    %ebx
  800657:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  80065b:	75 f9                	jne    800656 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  80065d:	e9 18 fd ff ff       	jmp    80037a <vprintfmt+0xc>
		}
	}
}
  800662:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800665:	5b                   	pop    %ebx
  800666:	5e                   	pop    %esi
  800667:	5f                   	pop    %edi
  800668:	c9                   	leave  
  800669:	c3                   	ret    

0080066a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80066a:	55                   	push   %ebp
  80066b:	89 e5                	mov    %esp,%ebp
  80066d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800670:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800673:	50                   	push   %eax
  800674:	ff 75 10             	pushl  0x10(%ebp)
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	ff 75 08             	pushl  0x8(%ebp)
  80067d:	e8 ec fc ff ff       	call   80036e <vprintfmt>
	va_end(ap);
}
  800682:	c9                   	leave  
  800683:	c3                   	ret    

00800684 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800684:	55                   	push   %ebp
  800685:	89 e5                	mov    %esp,%ebp
  800687:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  80068a:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  80068d:	8b 0a                	mov    (%edx),%ecx
  80068f:	3b 4a 04             	cmp    0x4(%edx),%ecx
  800692:	73 07                	jae    80069b <sprintputch+0x17>
		*b->buf++ = ch;
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	88 01                	mov    %al,(%ecx)
  800699:	ff 02                	incl   (%edx)
}
  80069b:	c9                   	leave  
  80069c:	c3                   	ret    

0080069d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
  8006a0:	83 ec 18             	sub    $0x18,%esp
  8006a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006a9:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  8006ac:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  8006b0:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8006b3:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  8006ba:	85 d2                	test   %edx,%edx
  8006bc:	74 04                	je     8006c2 <vsnprintf+0x25>
  8006be:	85 c9                	test   %ecx,%ecx
  8006c0:	7f 07                	jg     8006c9 <vsnprintf+0x2c>
		return -E_INVAL;
  8006c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006c7:	eb 1d                	jmp    8006e6 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006c9:	ff 75 14             	pushl  0x14(%ebp)
  8006cc:	ff 75 10             	pushl  0x10(%ebp)
  8006cf:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  8006d2:	50                   	push   %eax
  8006d3:	68 84 06 80 00       	push   $0x800684
  8006d8:	e8 91 fc ff ff       	call   80036e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006dd:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  8006e0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006e3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  8006e6:	c9                   	leave  
  8006e7:	c3                   	ret    

008006e8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8006e8:	55                   	push   %ebp
  8006e9:	89 e5                	mov    %esp,%ebp
  8006eb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8006ee:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8006f1:	50                   	push   %eax
  8006f2:	ff 75 10             	pushl  0x10(%ebp)
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 9d ff ff ff       	call   80069d <vsnprintf>
	va_end(ap);

	return rc;
}
  800700:	c9                   	leave  
  800701:	c3                   	ret    
	...

00800704 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800704:	55                   	push   %ebp
  800705:	89 e5                	mov    %esp,%ebp
  800707:	56                   	push   %esi
  800708:	53                   	push   %ebx
  800709:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  80070c:	83 ec 0c             	sub    $0xc,%esp
  80070f:	56                   	push   %esi
  800710:	e8 ef 00 00 00       	call   800804 <strlen>
  char letter;
  int hexnum = 0;
  800715:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80071a:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  80071f:	83 c4 10             	add    $0x10,%esp
  800722:	89 c2                	mov    %eax,%edx
  800724:	4a                   	dec    %edx
  800725:	0f 88 d0 00 00 00    	js     8007fb <strtoint+0xf7>
    letter = string[cidx];
  80072b:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  80072e:	85 d2                	test   %edx,%edx
  800730:	75 12                	jne    800744 <strtoint+0x40>
      if (letter != '0') {
  800732:	3c 30                	cmp    $0x30,%al
  800734:	0f 84 ba 00 00 00    	je     8007f4 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80073a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80073f:	e9 b9 00 00 00       	jmp    8007fd <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800744:	83 fa 01             	cmp    $0x1,%edx
  800747:	75 12                	jne    80075b <strtoint+0x57>
      if (letter != 'x') {
  800749:	3c 78                	cmp    $0x78,%al
  80074b:	0f 84 a3 00 00 00    	je     8007f4 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800756:	e9 a2 00 00 00       	jmp    8007fd <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  80075b:	0f be c0             	movsbl %al,%eax
  80075e:	83 e8 30             	sub    $0x30,%eax
  800761:	83 f8 36             	cmp    $0x36,%eax
  800764:	0f 87 80 00 00 00    	ja     8007ea <strtoint+0xe6>
  80076a:	ff 24 85 f4 2b 80 00 	jmp    *0x802bf4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  800771:	01 cb                	add    %ecx,%ebx
          break;
  800773:	eb 7c                	jmp    8007f1 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800775:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  800778:	eb 77                	jmp    8007f1 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  80077a:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80077d:	01 c3                	add    %eax,%ebx
          break;
  80077f:	eb 70                	jmp    8007f1 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  800781:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800784:	eb 6b                	jmp    8007f1 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  800786:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800789:	01 c3                	add    %eax,%ebx
          break;
  80078b:	eb 64                	jmp    8007f1 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  80078d:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800790:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800793:	eb 5c                	jmp    8007f1 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800795:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  80079c:	29 c8                	sub    %ecx,%eax
  80079e:	01 c3                	add    %eax,%ebx
          break;
  8007a0:	eb 4f                	jmp    8007f1 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8007a2:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8007a5:	eb 4a                	jmp    8007f1 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8007a7:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8007aa:	01 c3                	add    %eax,%ebx
          break;
  8007ac:	eb 43                	jmp    8007f1 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8007ae:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8007b1:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8007b4:	eb 3b                	jmp    8007f1 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  8007b6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8007b9:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  8007bc:	01 c3                	add    %eax,%ebx
          break;
  8007be:	eb 31                	jmp    8007f1 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  8007c0:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8007c3:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  8007c6:	eb 29                	jmp    8007f1 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  8007c8:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8007cb:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  8007ce:	01 c3                	add    %eax,%ebx
          break;
  8007d0:	eb 1f                	jmp    8007f1 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  8007d2:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8007d9:	29 c8                	sub    %ecx,%eax
  8007db:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8007de:	eb 11                	jmp    8007f1 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  8007e0:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8007e3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8007e6:	01 c3                	add    %eax,%ebx
          break;
  8007e8:	eb 07                	jmp    8007f1 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  8007ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8007ef:	eb 0c                	jmp    8007fd <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  8007f1:	c1 e1 04             	shl    $0x4,%ecx
  8007f4:	4a                   	dec    %edx
  8007f5:	0f 89 30 ff ff ff    	jns    80072b <strtoint+0x27>
    }
  }

  return hexnum;
  8007fb:	89 d8                	mov    %ebx,%eax
}
  8007fd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800800:	5b                   	pop    %ebx
  800801:	5e                   	pop    %esi
  800802:	c9                   	leave  
  800803:	c3                   	ret    

00800804 <strlen>:





int
strlen(const char *s)
{
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80080a:	b8 00 00 00 00       	mov    $0x0,%eax
  80080f:	80 3a 00             	cmpb   $0x0,(%edx)
  800812:	74 07                	je     80081b <strlen+0x17>
		n++;
  800814:	40                   	inc    %eax
  800815:	42                   	inc    %edx
  800816:	80 3a 00             	cmpb   $0x0,(%edx)
  800819:	75 f9                	jne    800814 <strlen+0x10>
	return n;
}
  80081b:	c9                   	leave  
  80081c:	c3                   	ret    

0080081d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80081d:	55                   	push   %ebp
  80081e:	89 e5                	mov    %esp,%ebp
  800820:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800823:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800826:	b8 00 00 00 00       	mov    $0x0,%eax
  80082b:	85 d2                	test   %edx,%edx
  80082d:	74 0f                	je     80083e <strnlen+0x21>
  80082f:	80 39 00             	cmpb   $0x0,(%ecx)
  800832:	74 0a                	je     80083e <strnlen+0x21>
		n++;
  800834:	40                   	inc    %eax
  800835:	41                   	inc    %ecx
  800836:	4a                   	dec    %edx
  800837:	74 05                	je     80083e <strnlen+0x21>
  800839:	80 39 00             	cmpb   $0x0,(%ecx)
  80083c:	75 f6                	jne    800834 <strnlen+0x17>
	return n;
}
  80083e:	c9                   	leave  
  80083f:	c3                   	ret    

00800840 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	53                   	push   %ebx
  800844:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800847:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  80084a:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  80084c:	8a 02                	mov    (%edx),%al
  80084e:	42                   	inc    %edx
  80084f:	88 01                	mov    %al,(%ecx)
  800851:	41                   	inc    %ecx
  800852:	84 c0                	test   %al,%al
  800854:	75 f6                	jne    80084c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800856:	89 d8                	mov    %ebx,%eax
  800858:	5b                   	pop    %ebx
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	57                   	push   %edi
  80085f:	56                   	push   %esi
  800860:	53                   	push   %ebx
  800861:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800864:	8b 55 0c             	mov    0xc(%ebp),%edx
  800867:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  80086a:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  80086c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800871:	39 f3                	cmp    %esi,%ebx
  800873:	73 10                	jae    800885 <strncpy+0x2a>
		*dst++ = *src;
  800875:	8a 02                	mov    (%edx),%al
  800877:	88 01                	mov    %al,(%ecx)
  800879:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80087a:	80 3a 01             	cmpb   $0x1,(%edx)
  80087d:	83 da ff             	sbb    $0xffffffff,%edx
  800880:	43                   	inc    %ebx
  800881:	39 f3                	cmp    %esi,%ebx
  800883:	72 f0                	jb     800875 <strncpy+0x1a>
	}
	return ret;
}
  800885:	89 f8                	mov    %edi,%eax
  800887:	5b                   	pop    %ebx
  800888:	5e                   	pop    %esi
  800889:	5f                   	pop    %edi
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    

0080088c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	56                   	push   %esi
  800890:	53                   	push   %ebx
  800891:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800894:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800897:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  80089a:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  80089c:	85 d2                	test   %edx,%edx
  80089e:	74 19                	je     8008b9 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a0:	4a                   	dec    %edx
  8008a1:	74 13                	je     8008b6 <strlcpy+0x2a>
  8008a3:	80 39 00             	cmpb   $0x0,(%ecx)
  8008a6:	74 0e                	je     8008b6 <strlcpy+0x2a>
  8008a8:	8a 01                	mov    (%ecx),%al
  8008aa:	41                   	inc    %ecx
  8008ab:	88 03                	mov    %al,(%ebx)
  8008ad:	43                   	inc    %ebx
  8008ae:	4a                   	dec    %edx
  8008af:	74 05                	je     8008b6 <strlcpy+0x2a>
  8008b1:	80 39 00             	cmpb   $0x0,(%ecx)
  8008b4:	75 f2                	jne    8008a8 <strlcpy+0x1c>
		*dst = '\0';
  8008b6:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  8008b9:	89 d8                	mov    %ebx,%eax
  8008bb:	29 f0                	sub    %esi,%eax
}
  8008bd:	5b                   	pop    %ebx
  8008be:	5e                   	pop    %esi
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  8008ca:	80 3a 00             	cmpb   $0x0,(%edx)
  8008cd:	74 13                	je     8008e2 <strcmp+0x21>
  8008cf:	8a 02                	mov    (%edx),%al
  8008d1:	3a 01                	cmp    (%ecx),%al
  8008d3:	75 0d                	jne    8008e2 <strcmp+0x21>
  8008d5:	42                   	inc    %edx
  8008d6:	41                   	inc    %ecx
  8008d7:	80 3a 00             	cmpb   $0x0,(%edx)
  8008da:	74 06                	je     8008e2 <strcmp+0x21>
  8008dc:	8a 02                	mov    (%edx),%al
  8008de:	3a 01                	cmp    (%ecx),%al
  8008e0:	74 f3                	je     8008d5 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e2:	0f b6 02             	movzbl (%edx),%eax
  8008e5:	0f b6 11             	movzbl (%ecx),%edx
  8008e8:	29 d0                	sub    %edx,%eax
}
  8008ea:	c9                   	leave  
  8008eb:	c3                   	ret    

008008ec <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	53                   	push   %ebx
  8008f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  8008f9:	85 c9                	test   %ecx,%ecx
  8008fb:	74 1f                	je     80091c <strncmp+0x30>
  8008fd:	80 3a 00             	cmpb   $0x0,(%edx)
  800900:	74 16                	je     800918 <strncmp+0x2c>
  800902:	8a 02                	mov    (%edx),%al
  800904:	3a 03                	cmp    (%ebx),%al
  800906:	75 10                	jne    800918 <strncmp+0x2c>
  800908:	42                   	inc    %edx
  800909:	43                   	inc    %ebx
  80090a:	49                   	dec    %ecx
  80090b:	74 0f                	je     80091c <strncmp+0x30>
  80090d:	80 3a 00             	cmpb   $0x0,(%edx)
  800910:	74 06                	je     800918 <strncmp+0x2c>
  800912:	8a 02                	mov    (%edx),%al
  800914:	3a 03                	cmp    (%ebx),%al
  800916:	74 f0                	je     800908 <strncmp+0x1c>
	if (n == 0)
  800918:	85 c9                	test   %ecx,%ecx
  80091a:	75 07                	jne    800923 <strncmp+0x37>
		return 0;
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	eb 0a                	jmp    80092d <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800923:	0f b6 12             	movzbl (%edx),%edx
  800926:	0f b6 03             	movzbl (%ebx),%eax
  800929:	29 c2                	sub    %eax,%edx
  80092b:	89 d0                	mov    %edx,%eax
}
  80092d:	5b                   	pop    %ebx
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    

00800930 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	8b 45 08             	mov    0x8(%ebp),%eax
  800936:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800939:	80 38 00             	cmpb   $0x0,(%eax)
  80093c:	74 0a                	je     800948 <strchr+0x18>
		if (*s == c)
  80093e:	38 10                	cmp    %dl,(%eax)
  800940:	74 0b                	je     80094d <strchr+0x1d>
  800942:	40                   	inc    %eax
  800943:	80 38 00             	cmpb   $0x0,(%eax)
  800946:	75 f6                	jne    80093e <strchr+0xe>
			return (char *) s;
	return 0;
  800948:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80094d:	c9                   	leave  
  80094e:	c3                   	ret    

0080094f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800958:	80 38 00             	cmpb   $0x0,(%eax)
  80095b:	74 0a                	je     800967 <strfind+0x18>
		if (*s == c)
  80095d:	38 10                	cmp    %dl,(%eax)
  80095f:	74 06                	je     800967 <strfind+0x18>
  800961:	40                   	inc    %eax
  800962:	80 38 00             	cmpb   $0x0,(%eax)
  800965:	75 f6                	jne    80095d <strfind+0xe>
			break;
	return (char *) s;
}
  800967:	c9                   	leave  
  800968:	c3                   	ret    

00800969 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	57                   	push   %edi
  80096d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800970:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800973:	89 f8                	mov    %edi,%eax
  800975:	85 c9                	test   %ecx,%ecx
  800977:	74 40                	je     8009b9 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800979:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80097f:	75 30                	jne    8009b1 <memset+0x48>
  800981:	f6 c1 03             	test   $0x3,%cl
  800984:	75 2b                	jne    8009b1 <memset+0x48>
		c &= 0xFF;
  800986:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80098d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800990:	c1 e0 18             	shl    $0x18,%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	c1 e2 10             	shl    $0x10,%edx
  800999:	09 d0                	or     %edx,%eax
  80099b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099e:	c1 e2 08             	shl    $0x8,%edx
  8009a1:	09 d0                	or     %edx,%eax
  8009a3:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  8009a6:	c1 e9 02             	shr    $0x2,%ecx
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	fc                   	cld    
  8009ad:	f3 ab                	repz stos %eax,%es:(%edi)
  8009af:	eb 06                	jmp    8009b7 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	fc                   	cld    
  8009b5:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8009b7:	89 f8                	mov    %edi,%eax
}
  8009b9:	5f                   	pop    %edi
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	57                   	push   %edi
  8009c0:	56                   	push   %esi
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8009c7:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8009ca:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8009cc:	39 c6                	cmp    %eax,%esi
  8009ce:	73 33                	jae    800a03 <memmove+0x47>
  8009d0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d3:	39 c2                	cmp    %eax,%edx
  8009d5:	76 2c                	jbe    800a03 <memmove+0x47>
		s += n;
  8009d7:	89 d6                	mov    %edx,%esi
		d += n;
  8009d9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009dc:	f6 c2 03             	test   $0x3,%dl
  8009df:	75 1b                	jne    8009fc <memmove+0x40>
  8009e1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009e7:	75 13                	jne    8009fc <memmove+0x40>
  8009e9:	f6 c1 03             	test   $0x3,%cl
  8009ec:	75 0e                	jne    8009fc <memmove+0x40>
			asm volatile("std; rep movsl\n"
  8009ee:	83 ef 04             	sub    $0x4,%edi
  8009f1:	83 ee 04             	sub    $0x4,%esi
  8009f4:	c1 e9 02             	shr    $0x2,%ecx
  8009f7:	fd                   	std    
  8009f8:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  8009fa:	eb 27                	jmp    800a23 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009fc:	4f                   	dec    %edi
  8009fd:	4e                   	dec    %esi
  8009fe:	fd                   	std    
  8009ff:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800a01:	eb 20                	jmp    800a23 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a03:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a09:	75 15                	jne    800a20 <memmove+0x64>
  800a0b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a11:	75 0d                	jne    800a20 <memmove+0x64>
  800a13:	f6 c1 03             	test   $0x3,%cl
  800a16:	75 08                	jne    800a20 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800a18:	c1 e9 02             	shr    $0x2,%ecx
  800a1b:	fc                   	cld    
  800a1c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800a1e:	eb 03                	jmp    800a23 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a20:	fc                   	cld    
  800a21:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a23:	5e                   	pop    %esi
  800a24:	5f                   	pop    %edi
  800a25:	c9                   	leave  
  800a26:	c3                   	ret    

00800a27 <memcpy>:

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
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a2a:	ff 75 10             	pushl  0x10(%ebp)
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	ff 75 08             	pushl  0x8(%ebp)
  800a33:	e8 84 ff ff ff       	call   8009bc <memmove>
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800a3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800a41:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a44:	8b 55 10             	mov    0x10(%ebp),%edx
  800a47:	4a                   	dec    %edx
  800a48:	83 fa ff             	cmp    $0xffffffff,%edx
  800a4b:	74 1a                	je     800a67 <memcmp+0x2d>
  800a4d:	8a 01                	mov    (%ecx),%al
  800a4f:	3a 03                	cmp    (%ebx),%al
  800a51:	74 0c                	je     800a5f <memcmp+0x25>
  800a53:	0f b6 d0             	movzbl %al,%edx
  800a56:	0f b6 03             	movzbl (%ebx),%eax
  800a59:	29 c2                	sub    %eax,%edx
  800a5b:	89 d0                	mov    %edx,%eax
  800a5d:	eb 0d                	jmp    800a6c <memcmp+0x32>
  800a5f:	41                   	inc    %ecx
  800a60:	43                   	inc    %ebx
  800a61:	4a                   	dec    %edx
  800a62:	83 fa ff             	cmp    $0xffffffff,%edx
  800a65:	75 e6                	jne    800a4d <memcmp+0x13>
	}

	return 0;
  800a67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6c:	5b                   	pop    %ebx
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a78:	89 c2                	mov    %eax,%edx
  800a7a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a7d:	39 d0                	cmp    %edx,%eax
  800a7f:	73 09                	jae    800a8a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a81:	38 08                	cmp    %cl,(%eax)
  800a83:	74 05                	je     800a8a <memfind+0x1b>
  800a85:	40                   	inc    %eax
  800a86:	39 d0                	cmp    %edx,%eax
  800a88:	72 f7                	jb     800a81 <memfind+0x12>
			break;
	return (void *) s;
}
  800a8a:	c9                   	leave  
  800a8b:	c3                   	ret    

00800a8c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	57                   	push   %edi
  800a90:	56                   	push   %esi
  800a91:	53                   	push   %ebx
  800a92:	8b 55 08             	mov    0x8(%ebp),%edx
  800a95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a98:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800a9b:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800aa0:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800aa5:	80 3a 20             	cmpb   $0x20,(%edx)
  800aa8:	74 05                	je     800aaf <strtol+0x23>
  800aaa:	80 3a 09             	cmpb   $0x9,(%edx)
  800aad:	75 0b                	jne    800aba <strtol+0x2e>
  800aaf:	42                   	inc    %edx
  800ab0:	80 3a 20             	cmpb   $0x20,(%edx)
  800ab3:	74 fa                	je     800aaf <strtol+0x23>
  800ab5:	80 3a 09             	cmpb   $0x9,(%edx)
  800ab8:	74 f5                	je     800aaf <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800aba:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800abd:	75 03                	jne    800ac2 <strtol+0x36>
		s++;
  800abf:	42                   	inc    %edx
  800ac0:	eb 0b                	jmp    800acd <strtol+0x41>
	else if (*s == '-')
  800ac2:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800ac5:	75 06                	jne    800acd <strtol+0x41>
		s++, neg = 1;
  800ac7:	42                   	inc    %edx
  800ac8:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800acd:	85 c9                	test   %ecx,%ecx
  800acf:	74 05                	je     800ad6 <strtol+0x4a>
  800ad1:	83 f9 10             	cmp    $0x10,%ecx
  800ad4:	75 15                	jne    800aeb <strtol+0x5f>
  800ad6:	80 3a 30             	cmpb   $0x30,(%edx)
  800ad9:	75 10                	jne    800aeb <strtol+0x5f>
  800adb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800adf:	75 0a                	jne    800aeb <strtol+0x5f>
		s += 2, base = 16;
  800ae1:	83 c2 02             	add    $0x2,%edx
  800ae4:	b9 10 00 00 00       	mov    $0x10,%ecx
  800ae9:	eb 14                	jmp    800aff <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800aeb:	85 c9                	test   %ecx,%ecx
  800aed:	75 10                	jne    800aff <strtol+0x73>
  800aef:	80 3a 30             	cmpb   $0x30,(%edx)
  800af2:	75 05                	jne    800af9 <strtol+0x6d>
		s++, base = 8;
  800af4:	42                   	inc    %edx
  800af5:	b1 08                	mov    $0x8,%cl
  800af7:	eb 06                	jmp    800aff <strtol+0x73>
	else if (base == 0)
  800af9:	85 c9                	test   %ecx,%ecx
  800afb:	75 02                	jne    800aff <strtol+0x73>
		base = 10;
  800afd:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800aff:	8a 02                	mov    (%edx),%al
  800b01:	83 e8 30             	sub    $0x30,%eax
  800b04:	3c 09                	cmp    $0x9,%al
  800b06:	77 08                	ja     800b10 <strtol+0x84>
			dig = *s - '0';
  800b08:	0f be 02             	movsbl (%edx),%eax
  800b0b:	83 e8 30             	sub    $0x30,%eax
  800b0e:	eb 20                	jmp    800b30 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800b10:	8a 02                	mov    (%edx),%al
  800b12:	83 e8 61             	sub    $0x61,%eax
  800b15:	3c 19                	cmp    $0x19,%al
  800b17:	77 08                	ja     800b21 <strtol+0x95>
			dig = *s - 'a' + 10;
  800b19:	0f be 02             	movsbl (%edx),%eax
  800b1c:	83 e8 57             	sub    $0x57,%eax
  800b1f:	eb 0f                	jmp    800b30 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800b21:	8a 02                	mov    (%edx),%al
  800b23:	83 e8 41             	sub    $0x41,%eax
  800b26:	3c 19                	cmp    $0x19,%al
  800b28:	77 12                	ja     800b3c <strtol+0xb0>
			dig = *s - 'A' + 10;
  800b2a:	0f be 02             	movsbl (%edx),%eax
  800b2d:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800b30:	39 c8                	cmp    %ecx,%eax
  800b32:	7d 08                	jge    800b3c <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800b34:	42                   	inc    %edx
  800b35:	0f af d9             	imul   %ecx,%ebx
  800b38:	01 c3                	add    %eax,%ebx
  800b3a:	eb c3                	jmp    800aff <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b3c:	85 f6                	test   %esi,%esi
  800b3e:	74 02                	je     800b42 <strtol+0xb6>
		*endptr = (char *) s;
  800b40:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b42:	89 d8                	mov    %ebx,%eax
  800b44:	85 ff                	test   %edi,%edi
  800b46:	74 02                	je     800b4a <strtol+0xbe>
  800b48:	f7 d8                	neg    %eax
}
  800b4a:	5b                   	pop    %ebx
  800b4b:	5e                   	pop    %esi
  800b4c:	5f                   	pop    %edi
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    
	...

00800b50 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	57                   	push   %edi
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	83 ec 04             	sub    $0x4,%esp
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b5f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b64:	89 f8                	mov    %edi,%eax
  800b66:	89 fb                	mov    %edi,%ebx
  800b68:	89 fe                	mov    %edi,%esi
  800b6a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b6c:	83 c4 04             	add    $0x4,%esp
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5f                   	pop    %edi
  800b72:	c9                   	leave  
  800b73:	c3                   	ret    

00800b74 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
  800b7a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b7f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b84:	89 fa                	mov    %edi,%edx
  800b86:	89 f9                	mov    %edi,%ecx
  800b88:	89 fb                	mov    %edi,%ebx
  800b8a:	89 fe                	mov    %edi,%esi
  800b8c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b8e:	5b                   	pop    %ebx
  800b8f:	5e                   	pop    %esi
  800b90:	5f                   	pop    %edi
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba4:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba9:	89 f9                	mov    %edi,%ecx
  800bab:	89 fb                	mov    %edi,%ebx
  800bad:	89 fe                	mov    %edi,%esi
  800baf:	cd 30                	int    $0x30
  800bb1:	85 c0                	test   %eax,%eax
  800bb3:	7e 17                	jle    800bcc <sys_env_destroy+0x39>
  800bb5:	83 ec 0c             	sub    $0xc,%esp
  800bb8:	50                   	push   %eax
  800bb9:	6a 03                	push   $0x3
  800bbb:	68 d0 2c 80 00       	push   $0x802cd0
  800bc0:	6a 23                	push   $0x23
  800bc2:	68 ed 2c 80 00       	push   $0x802ced
  800bc7:	e8 80 f5 ff ff       	call   80014c <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bcc:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
  800bda:	b8 02 00 00 00       	mov    $0x2,%eax
  800bdf:	bf 00 00 00 00       	mov    $0x0,%edi
  800be4:	89 fa                	mov    %edi,%edx
  800be6:	89 f9                	mov    %edi,%ecx
  800be8:	89 fb                	mov    %edi,%ebx
  800bea:	89 fe                	mov    %edi,%esi
  800bec:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <sys_yield>:

void
sys_yield(void)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bfe:	bf 00 00 00 00       	mov    $0x0,%edi
  800c03:	89 fa                	mov    %edi,%edx
  800c05:	89 f9                	mov    %edi,%ecx
  800c07:	89 fb                	mov    %edi,%ebx
  800c09:	89 fe                	mov    %edi,%esi
  800c0b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c0d:	5b                   	pop    %ebx
  800c0e:	5e                   	pop    %esi
  800c0f:	5f                   	pop    %edi
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	57                   	push   %edi
  800c16:	56                   	push   %esi
  800c17:	53                   	push   %ebx
  800c18:	83 ec 0c             	sub    $0xc,%esp
  800c1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c24:	b8 04 00 00 00       	mov    $0x4,%eax
  800c29:	bf 00 00 00 00       	mov    $0x0,%edi
  800c2e:	89 fe                	mov    %edi,%esi
  800c30:	cd 30                	int    $0x30
  800c32:	85 c0                	test   %eax,%eax
  800c34:	7e 17                	jle    800c4d <sys_page_alloc+0x3b>
  800c36:	83 ec 0c             	sub    $0xc,%esp
  800c39:	50                   	push   %eax
  800c3a:	6a 04                	push   $0x4
  800c3c:	68 d0 2c 80 00       	push   $0x802cd0
  800c41:	6a 23                	push   $0x23
  800c43:	68 ed 2c 80 00       	push   $0x802ced
  800c48:	e8 ff f4 ff ff       	call   80014c <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c4d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
  800c5b:	83 ec 0c             	sub    $0xc,%esp
  800c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c67:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c6a:	8b 75 18             	mov    0x18(%ebp),%esi
  800c6d:	b8 05 00 00 00       	mov    $0x5,%eax
  800c72:	cd 30                	int    $0x30
  800c74:	85 c0                	test   %eax,%eax
  800c76:	7e 17                	jle    800c8f <sys_page_map+0x3a>
  800c78:	83 ec 0c             	sub    $0xc,%esp
  800c7b:	50                   	push   %eax
  800c7c:	6a 05                	push   $0x5
  800c7e:	68 d0 2c 80 00       	push   $0x802cd0
  800c83:	6a 23                	push   $0x23
  800c85:	68 ed 2c 80 00       	push   $0x802ced
  800c8a:	e8 bd f4 ff ff       	call   80014c <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c8f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	83 ec 0c             	sub    $0xc,%esp
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca6:	b8 06 00 00 00       	mov    $0x6,%eax
  800cab:	bf 00 00 00 00       	mov    $0x0,%edi
  800cb0:	89 fb                	mov    %edi,%ebx
  800cb2:	89 fe                	mov    %edi,%esi
  800cb4:	cd 30                	int    $0x30
  800cb6:	85 c0                	test   %eax,%eax
  800cb8:	7e 17                	jle    800cd1 <sys_page_unmap+0x3a>
  800cba:	83 ec 0c             	sub    $0xc,%esp
  800cbd:	50                   	push   %eax
  800cbe:	6a 06                	push   $0x6
  800cc0:	68 d0 2c 80 00       	push   $0x802cd0
  800cc5:	6a 23                	push   $0x23
  800cc7:	68 ed 2c 80 00       	push   $0x802ced
  800ccc:	e8 7b f4 ff ff       	call   80014c <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cd1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	57                   	push   %edi
  800cdd:	56                   	push   %esi
  800cde:	53                   	push   %ebx
  800cdf:	83 ec 0c             	sub    $0xc,%esp
  800ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ced:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf2:	89 fb                	mov    %edi,%ebx
  800cf4:	89 fe                	mov    %edi,%esi
  800cf6:	cd 30                	int    $0x30
  800cf8:	85 c0                	test   %eax,%eax
  800cfa:	7e 17                	jle    800d13 <sys_env_set_status+0x3a>
  800cfc:	83 ec 0c             	sub    $0xc,%esp
  800cff:	50                   	push   %eax
  800d00:	6a 08                	push   $0x8
  800d02:	68 d0 2c 80 00       	push   $0x802cd0
  800d07:	6a 23                	push   $0x23
  800d09:	68 ed 2c 80 00       	push   $0x802ced
  800d0e:	e8 39 f4 ff ff       	call   80014c <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d13:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	c9                   	leave  
  800d1a:	c3                   	ret    

00800d1b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
  800d21:	83 ec 0c             	sub    $0xc,%esp
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d34:	89 fb                	mov    %edi,%ebx
  800d36:	89 fe                	mov    %edi,%esi
  800d38:	cd 30                	int    $0x30
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	7e 17                	jle    800d55 <sys_env_set_trapframe+0x3a>
  800d3e:	83 ec 0c             	sub    $0xc,%esp
  800d41:	50                   	push   %eax
  800d42:	6a 09                	push   $0x9
  800d44:	68 d0 2c 80 00       	push   $0x802cd0
  800d49:	6a 23                	push   $0x23
  800d4b:	68 ed 2c 80 00       	push   $0x802ced
  800d50:	e8 f7 f3 ff ff       	call   80014c <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d55:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d58:	5b                   	pop    %ebx
  800d59:	5e                   	pop    %esi
  800d5a:	5f                   	pop    %edi
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	57                   	push   %edi
  800d61:	56                   	push   %esi
  800d62:	53                   	push   %ebx
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d71:	bf 00 00 00 00       	mov    $0x0,%edi
  800d76:	89 fb                	mov    %edi,%ebx
  800d78:	89 fe                	mov    %edi,%esi
  800d7a:	cd 30                	int    $0x30
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	7e 17                	jle    800d97 <sys_env_set_pgfault_upcall+0x3a>
  800d80:	83 ec 0c             	sub    $0xc,%esp
  800d83:	50                   	push   %eax
  800d84:	6a 0a                	push   $0xa
  800d86:	68 d0 2c 80 00       	push   $0x802cd0
  800d8b:	6a 23                	push   $0x23
  800d8d:	68 ed 2c 80 00       	push   $0x802ced
  800d92:	e8 b5 f3 ff ff       	call   80014c <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d97:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d9a:	5b                   	pop    %ebx
  800d9b:	5e                   	pop    %esi
  800d9c:	5f                   	pop    %edi
  800d9d:	c9                   	leave  
  800d9e:	c3                   	ret    

00800d9f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
  800da5:	8b 55 08             	mov    0x8(%ebp),%edx
  800da8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800db6:	be 00 00 00 00       	mov    $0x0,%esi
  800dbb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	c9                   	leave  
  800dc1:	c3                   	ret    

00800dc2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 0c             	sub    $0xc,%esp
  800dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dce:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dd3:	bf 00 00 00 00       	mov    $0x0,%edi
  800dd8:	89 f9                	mov    %edi,%ecx
  800dda:	89 fb                	mov    %edi,%ebx
  800ddc:	89 fe                	mov    %edi,%esi
  800dde:	cd 30                	int    $0x30
  800de0:	85 c0                	test   %eax,%eax
  800de2:	7e 17                	jle    800dfb <sys_ipc_recv+0x39>
  800de4:	83 ec 0c             	sub    $0xc,%esp
  800de7:	50                   	push   %eax
  800de8:	6a 0d                	push   $0xd
  800dea:	68 d0 2c 80 00       	push   $0x802cd0
  800def:	6a 23                	push   $0x23
  800df1:	68 ed 2c 80 00       	push   $0x802ced
  800df6:	e8 51 f3 ff ff       	call   80014c <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dfb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    

00800e03 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	57                   	push   %edi
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
  800e09:	83 ec 0c             	sub    $0xc,%esp
  800e0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e12:	b8 10 00 00 00       	mov    $0x10,%eax
  800e17:	bf 00 00 00 00       	mov    $0x0,%edi
  800e1c:	89 fb                	mov    %edi,%ebx
  800e1e:	89 fe                	mov    %edi,%esi
  800e20:	cd 30                	int    $0x30
  800e22:	85 c0                	test   %eax,%eax
  800e24:	7e 17                	jle    800e3d <sys_transmit_packet+0x3a>
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	50                   	push   %eax
  800e2a:	6a 10                	push   $0x10
  800e2c:	68 d0 2c 80 00       	push   $0x802cd0
  800e31:	6a 23                	push   $0x23
  800e33:	68 ed 2c 80 00       	push   $0x802ced
  800e38:	e8 0f f3 ff ff       	call   80014c <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800e3d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5f                   	pop    %edi
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	57                   	push   %edi
  800e49:	56                   	push   %esi
  800e4a:	53                   	push   %ebx
  800e4b:	83 ec 0c             	sub    $0xc,%esp
  800e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e54:	b8 11 00 00 00       	mov    $0x11,%eax
  800e59:	bf 00 00 00 00       	mov    $0x0,%edi
  800e5e:	89 fb                	mov    %edi,%ebx
  800e60:	89 fe                	mov    %edi,%esi
  800e62:	cd 30                	int    $0x30
  800e64:	85 c0                	test   %eax,%eax
  800e66:	7e 17                	jle    800e7f <sys_receive_packet+0x3a>
  800e68:	83 ec 0c             	sub    $0xc,%esp
  800e6b:	50                   	push   %eax
  800e6c:	6a 11                	push   $0x11
  800e6e:	68 d0 2c 80 00       	push   $0x802cd0
  800e73:	6a 23                	push   $0x23
  800e75:	68 ed 2c 80 00       	push   $0x802ced
  800e7a:	e8 cd f2 ff ff       	call   80014c <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	c9                   	leave  
  800e86:	c3                   	ret    

00800e87 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	57                   	push   %edi
  800e8b:	56                   	push   %esi
  800e8c:	53                   	push   %ebx
  800e8d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e92:	bf 00 00 00 00       	mov    $0x0,%edi
  800e97:	89 fa                	mov    %edi,%edx
  800e99:	89 f9                	mov    %edi,%ecx
  800e9b:	89 fb                	mov    %edi,%ebx
  800e9d:	89 fe                	mov    %edi,%esi
  800e9f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ea1:	5b                   	pop    %ebx
  800ea2:	5e                   	pop    %esi
  800ea3:	5f                   	pop    %edi
  800ea4:	c9                   	leave  
  800ea5:	c3                   	ret    

00800ea6 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
  800eac:	83 ec 0c             	sub    $0xc,%esp
  800eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eb7:	bf 00 00 00 00       	mov    $0x0,%edi
  800ebc:	89 f9                	mov    %edi,%ecx
  800ebe:	89 fb                	mov    %edi,%ebx
  800ec0:	89 fe                	mov    %edi,%esi
  800ec2:	cd 30                	int    $0x30
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7e 17                	jle    800edf <sys_map_receive_buffers+0x39>
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	50                   	push   %eax
  800ecc:	6a 0e                	push   $0xe
  800ece:	68 d0 2c 80 00       	push   $0x802cd0
  800ed3:	6a 23                	push   $0x23
  800ed5:	68 ed 2c 80 00       	push   $0x802ced
  800eda:	e8 6d f2 ff ff       	call   80014c <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800edf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
  800eed:	83 ec 0c             	sub    $0xc,%esp
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	b8 12 00 00 00       	mov    $0x12,%eax
  800ef8:	bf 00 00 00 00       	mov    $0x0,%edi
  800efd:	89 f9                	mov    %edi,%ecx
  800eff:	89 fb                	mov    %edi,%ebx
  800f01:	89 fe                	mov    %edi,%esi
  800f03:	cd 30                	int    $0x30
  800f05:	85 c0                	test   %eax,%eax
  800f07:	7e 17                	jle    800f20 <sys_receive_packet_zerocopy+0x39>
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	50                   	push   %eax
  800f0d:	6a 12                	push   $0x12
  800f0f:	68 d0 2c 80 00       	push   $0x802cd0
  800f14:	6a 23                	push   $0x23
  800f16:	68 ed 2c 80 00       	push   $0x802ced
  800f1b:	e8 2c f2 ff ff       	call   80014c <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800f20:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f23:	5b                   	pop    %ebx
  800f24:	5e                   	pop    %esi
  800f25:	5f                   	pop    %edi
  800f26:	c9                   	leave  
  800f27:	c3                   	ret    

00800f28 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	57                   	push   %edi
  800f2c:	56                   	push   %esi
  800f2d:	53                   	push   %ebx
  800f2e:	83 ec 0c             	sub    $0xc,%esp
  800f31:	8b 55 08             	mov    0x8(%ebp),%edx
  800f34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f37:	b8 13 00 00 00       	mov    $0x13,%eax
  800f3c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f41:	89 fb                	mov    %edi,%ebx
  800f43:	89 fe                	mov    %edi,%esi
  800f45:	cd 30                	int    $0x30
  800f47:	85 c0                	test   %eax,%eax
  800f49:	7e 17                	jle    800f62 <sys_env_set_priority+0x3a>
  800f4b:	83 ec 0c             	sub    $0xc,%esp
  800f4e:	50                   	push   %eax
  800f4f:	6a 13                	push   $0x13
  800f51:	68 d0 2c 80 00       	push   $0x802cd0
  800f56:	6a 23                	push   $0x23
  800f58:	68 ed 2c 80 00       	push   $0x802ced
  800f5d:	e8 ea f1 ff ff       	call   80014c <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800f62:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	c9                   	leave  
  800f69:	c3                   	ret    
	...

00800f6c <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	53                   	push   %ebx
  800f70:	83 ec 04             	sub    $0x4,%esp
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f76:	8b 18                	mov    (%eax),%ebx
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
  800f78:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f7c:	74 11                	je     800f8f <pgfault+0x23>
  800f7e:	89 d8                	mov    %ebx,%eax
  800f80:	c1 e8 0c             	shr    $0xc,%eax
  800f83:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800f8a:	f6 c4 08             	test   $0x8,%ah
  800f8d:	75 14                	jne    800fa3 <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  800f8f:	83 ec 04             	sub    $0x4,%esp
  800f92:	68 fc 2c 80 00       	push   $0x802cfc
  800f97:	6a 1e                	push   $0x1e
  800f99:	68 50 2d 80 00       	push   $0x802d50
  800f9e:	e8 a9 f1 ff ff       	call   80014c <_panic>
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
  800fa3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  800fa9:	83 ec 04             	sub    $0x4,%esp
  800fac:	6a 07                	push   $0x7
  800fae:	68 00 f0 7f 00       	push   $0x7ff000
  800fb3:	83 ec 04             	sub    $0x4,%esp
  800fb6:	e8 19 fc ff ff       	call   800bd4 <sys_getenvid>
  800fbb:	89 04 24             	mov    %eax,(%esp)
  800fbe:	e8 4f fc ff ff       	call   800c12 <sys_page_alloc>
  800fc3:	83 c4 10             	add    $0x10,%esp
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	79 12                	jns    800fdc <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  800fca:	50                   	push   %eax
  800fcb:	68 5b 2d 80 00       	push   $0x802d5b
  800fd0:	6a 2d                	push   $0x2d
  800fd2:	68 50 2d 80 00       	push   $0x802d50
  800fd7:	e8 70 f1 ff ff       	call   80014c <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 00 10 00 00       	push   $0x1000
  800fe4:	53                   	push   %ebx
  800fe5:	68 00 f0 7f 00       	push   $0x7ff000
  800fea:	e8 cd f9 ff ff       	call   8009bc <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  800fef:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ff6:	53                   	push   %ebx
  800ff7:	83 ec 0c             	sub    $0xc,%esp
  800ffa:	e8 d5 fb ff ff       	call   800bd4 <sys_getenvid>
  800fff:	83 c4 0c             	add    $0xc,%esp
  801002:	50                   	push   %eax
  801003:	68 00 f0 7f 00       	push   $0x7ff000
  801008:	83 ec 04             	sub    $0x4,%esp
  80100b:	e8 c4 fb ff ff       	call   800bd4 <sys_getenvid>
  801010:	89 04 24             	mov    %eax,(%esp)
  801013:	e8 3d fc ff ff       	call   800c55 <sys_page_map>
  801018:	83 c4 20             	add    $0x20,%esp
  80101b:	85 c0                	test   %eax,%eax
  80101d:	79 12                	jns    801031 <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  80101f:	50                   	push   %eax
  801020:	68 76 2d 80 00       	push   $0x802d76
  801025:	6a 33                	push   $0x33
  801027:	68 50 2d 80 00       	push   $0x802d50
  80102c:	e8 1b f1 ff ff       	call   80014c <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  801031:	83 ec 08             	sub    $0x8,%esp
  801034:	68 00 f0 7f 00       	push   $0x7ff000
  801039:	83 ec 04             	sub    $0x4,%esp
  80103c:	e8 93 fb ff ff       	call   800bd4 <sys_getenvid>
  801041:	89 04 24             	mov    %eax,(%esp)
  801044:	e8 4e fc ff ff       	call   800c97 <sys_page_unmap>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	79 12                	jns    801062 <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  801050:	50                   	push   %eax
  801051:	68 8f 2d 80 00       	push   $0x802d8f
  801056:	6a 36                	push   $0x36
  801058:	68 50 2d 80 00       	push   $0x802d50
  80105d:	e8 ea f0 ff ff       	call   80014c <_panic>
        }

	//panic("pgfault not implemented");
}
  801062:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <duppage>:

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
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	53                   	push   %ebx
  80106b:	83 ec 04             	sub    $0x4,%esp
  80106e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801071:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  801074:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  801079:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  80107c:	f6 c4 04             	test   $0x4,%ah
  80107f:	74 36                	je     8010b7 <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  801081:	83 ec 0c             	sub    $0xc,%esp
  801084:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801087:	25 07 0e 00 00       	and    $0xe07,%eax
  80108c:	50                   	push   %eax
  80108d:	89 d8                	mov    %ebx,%eax
  80108f:	c1 e0 0c             	shl    $0xc,%eax
  801092:	50                   	push   %eax
  801093:	51                   	push   %ecx
  801094:	50                   	push   %eax
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	e8 37 fb ff ff       	call   800bd4 <sys_getenvid>
  80109d:	89 04 24             	mov    %eax,(%esp)
  8010a0:	e8 b0 fb ff ff       	call   800c55 <sys_page_map>
  8010a5:	83 c4 20             	add    $0x20,%esp
            return r;
  8010a8:	89 c2                	mov    %eax,%edx
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	0f 88 c9 00 00 00    	js     80117b <duppage+0x114>
  8010b2:	e9 bf 00 00 00       	jmp    801176 <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  8010b7:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  8010be:	a9 02 08 00 00       	test   $0x802,%eax
  8010c3:	74 7b                	je     801140 <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	68 05 08 00 00       	push   $0x805
  8010cd:	89 d8                	mov    %ebx,%eax
  8010cf:	c1 e0 0c             	shl    $0xc,%eax
  8010d2:	50                   	push   %eax
  8010d3:	51                   	push   %ecx
  8010d4:	50                   	push   %eax
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	e8 f7 fa ff ff       	call   800bd4 <sys_getenvid>
  8010dd:	89 04 24             	mov    %eax,(%esp)
  8010e0:	e8 70 fb ff ff       	call   800c55 <sys_page_map>
  8010e5:	83 c4 20             	add    $0x20,%esp
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	79 12                	jns    8010fe <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  8010ec:	50                   	push   %eax
  8010ed:	68 aa 2d 80 00       	push   $0x802daa
  8010f2:	6a 56                	push   $0x56
  8010f4:	68 50 2d 80 00       	push   $0x802d50
  8010f9:	e8 4e f0 ff ff       	call   80014c <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  8010fe:	83 ec 0c             	sub    $0xc,%esp
  801101:	68 05 08 00 00       	push   $0x805
  801106:	c1 e3 0c             	shl    $0xc,%ebx
  801109:	53                   	push   %ebx
  80110a:	83 ec 0c             	sub    $0xc,%esp
  80110d:	e8 c2 fa ff ff       	call   800bd4 <sys_getenvid>
  801112:	83 c4 0c             	add    $0xc,%esp
  801115:	50                   	push   %eax
  801116:	53                   	push   %ebx
  801117:	83 ec 04             	sub    $0x4,%esp
  80111a:	e8 b5 fa ff ff       	call   800bd4 <sys_getenvid>
  80111f:	89 04 24             	mov    %eax,(%esp)
  801122:	e8 2e fb ff ff       	call   800c55 <sys_page_map>
  801127:	83 c4 20             	add    $0x20,%esp
  80112a:	85 c0                	test   %eax,%eax
  80112c:	79 48                	jns    801176 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  80112e:	50                   	push   %eax
  80112f:	68 aa 2d 80 00       	push   $0x802daa
  801134:	6a 5b                	push   $0x5b
  801136:	68 50 2d 80 00       	push   $0x802d50
  80113b:	e8 0c f0 ff ff       	call   80014c <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  801140:	83 ec 0c             	sub    $0xc,%esp
  801143:	6a 05                	push   $0x5
  801145:	89 d8                	mov    %ebx,%eax
  801147:	c1 e0 0c             	shl    $0xc,%eax
  80114a:	50                   	push   %eax
  80114b:	51                   	push   %ecx
  80114c:	50                   	push   %eax
  80114d:	83 ec 04             	sub    $0x4,%esp
  801150:	e8 7f fa ff ff       	call   800bd4 <sys_getenvid>
  801155:	89 04 24             	mov    %eax,(%esp)
  801158:	e8 f8 fa ff ff       	call   800c55 <sys_page_map>
  80115d:	83 c4 20             	add    $0x20,%esp
  801160:	85 c0                	test   %eax,%eax
  801162:	79 12                	jns    801176 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  801164:	50                   	push   %eax
  801165:	68 aa 2d 80 00       	push   $0x802daa
  80116a:	6a 5f                	push   $0x5f
  80116c:	68 50 2d 80 00       	push   $0x802d50
  801171:	e8 d6 ef ff ff       	call   80014c <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  801176:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80117b:	89 d0                	mov    %edx,%eax
  80117d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <fork>:

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
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	57                   	push   %edi
  801186:	56                   	push   %esi
  801187:	53                   	push   %ebx
  801188:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  80118b:	68 6c 0f 80 00       	push   $0x800f6c
  801190:	e8 77 13 00 00       	call   80250c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  801195:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  801198:	ba 07 00 00 00       	mov    $0x7,%edx
  80119d:	89 d0                	mov    %edx,%eax
  80119f:	cd 30                	int    $0x30
  8011a1:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	79 15                	jns    8011bd <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  8011a8:	50                   	push   %eax
  8011a9:	68 30 2d 80 00       	push   $0x802d30
  8011ae:	68 85 00 00 00       	push   $0x85
  8011b3:	68 50 2d 80 00       	push   $0x802d50
  8011b8:	e8 8f ef ff ff       	call   80014c <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  8011bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8011c2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8011c6:	75 21                	jne    8011e9 <fork+0x67>
  8011c8:	e8 07 fa ff ff       	call   800bd4 <sys_getenvid>
  8011cd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011d2:	c1 e0 07             	shl    $0x7,%eax
  8011d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011da:	a3 80 60 80 00       	mov    %eax,0x806080
  8011df:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e4:	e9 fd 00 00 00       	jmp    8012e6 <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  8011e9:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  8011f0:	a8 01                	test   $0x1,%al
  8011f2:	74 5f                	je     801253 <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  8011f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f9:	89 f8                	mov    %edi,%eax
  8011fb:	c1 e0 0a             	shl    $0xa,%eax
  8011fe:	89 c2                	mov    %eax,%edx
  801200:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801205:	77 4c                	ja     801253 <fork+0xd1>
  801207:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  801209:	01 da                	add    %ebx,%edx
  80120b:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801212:	a8 01                	test   $0x1,%al
  801214:	74 28                	je     80123e <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	52                   	push   %edx
  80121a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80121d:	e8 45 fe ff ff       	call   801067 <duppage>
  801222:	83 c4 10             	add    $0x10,%esp
  801225:	85 c0                	test   %eax,%eax
  801227:	79 15                	jns    80123e <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  801229:	50                   	push   %eax
  80122a:	68 c3 2d 80 00       	push   $0x802dc3
  80122f:	68 95 00 00 00       	push   $0x95
  801234:	68 50 2d 80 00       	push   $0x802d50
  801239:	e8 0e ef ff ff       	call   80014c <_panic>
  80123e:	43                   	inc    %ebx
  80123f:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  801245:	7f 0c                	jg     801253 <fork+0xd1>
  801247:	89 f2                	mov    %esi,%edx
  801249:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80124c:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801251:	76 b6                	jbe    801209 <fork+0x87>
  801253:	47                   	inc    %edi
  801254:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  80125a:	76 8d                	jbe    8011e9 <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  80125c:	83 ec 04             	sub    $0x4,%esp
  80125f:	6a 07                	push   $0x7
  801261:	68 00 f0 bf ee       	push   $0xeebff000
  801266:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801269:	e8 a4 f9 ff ff       	call   800c12 <sys_page_alloc>
  80126e:	83 c4 10             	add    $0x10,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	79 15                	jns    80128a <fork+0x108>
          panic("fork: %d", r);
  801275:	50                   	push   %eax
  801276:	68 dc 2d 80 00       	push   $0x802ddc
  80127b:	68 9d 00 00 00       	push   $0x9d
  801280:	68 50 2d 80 00       	push   $0x802d50
  801285:	e8 c2 ee ff ff       	call   80014c <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	a1 80 60 80 00       	mov    0x806080,%eax
  801292:	8b 40 64             	mov    0x64(%eax),%eax
  801295:	50                   	push   %eax
  801296:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801299:	e8 bf fa ff ff       	call   800d5d <sys_env_set_pgfault_upcall>
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	79 15                	jns    8012ba <fork+0x138>
          panic("fork: %d", r);
  8012a5:	50                   	push   %eax
  8012a6:	68 dc 2d 80 00       	push   $0x802ddc
  8012ab:	68 a2 00 00 00       	push   $0xa2
  8012b0:	68 50 2d 80 00       	push   $0x802d50
  8012b5:	e8 92 ee ff ff       	call   80014c <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  8012ba:	83 ec 08             	sub    $0x8,%esp
  8012bd:	6a 01                	push   $0x1
  8012bf:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8012c2:	e8 12 fa ff ff       	call   800cd9 <sys_env_set_status>
  8012c7:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  8012ca:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	79 15                	jns    8012e6 <fork+0x164>
  8012d1:	50                   	push   %eax
  8012d2:	68 dc 2d 80 00       	push   $0x802ddc
  8012d7:	68 a7 00 00 00       	push   $0xa7
  8012dc:	68 50 2d 80 00       	push   $0x802d50
  8012e1:	e8 66 ee ff ff       	call   80014c <_panic>
 
	//panic("fork not implemented");
}
  8012e6:	89 d0                	mov    %edx,%eax
  8012e8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8012eb:	5b                   	pop    %ebx
  8012ec:	5e                   	pop    %esi
  8012ed:	5f                   	pop    %edi
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <sfork>:



// Challenge!
int
sfork(void)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8012f6:	68 e5 2d 80 00       	push   $0x802de5
  8012fb:	68 b5 00 00 00       	push   $0xb5
  801300:	68 50 2d 80 00       	push   $0x802d50
  801305:	e8 42 ee ff ff       	call   80014c <_panic>
	...

0080130c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	56                   	push   %esi
  801310:	53                   	push   %ebx
  801311:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80131a:	85 c0                	test   %eax,%eax
  80131c:	75 12                	jne    801330 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  80131e:	83 ec 0c             	sub    $0xc,%esp
  801321:	68 00 00 c0 ee       	push   $0xeec00000
  801326:	e8 97 fa ff ff       	call   800dc2 <sys_ipc_recv>
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	eb 0c                	jmp    80133c <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  801330:	83 ec 0c             	sub    $0xc,%esp
  801333:	50                   	push   %eax
  801334:	e8 89 fa ff ff       	call   800dc2 <sys_ipc_recv>
  801339:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  80133c:	89 c2                	mov    %eax,%edx
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 24                	js     801366 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  801342:	85 db                	test   %ebx,%ebx
  801344:	74 0a                	je     801350 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  801346:	a1 80 60 80 00       	mov    0x806080,%eax
  80134b:	8b 40 74             	mov    0x74(%eax),%eax
  80134e:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  801350:	85 f6                	test   %esi,%esi
  801352:	74 0a                	je     80135e <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  801354:	a1 80 60 80 00       	mov    0x806080,%eax
  801359:	8b 40 78             	mov    0x78(%eax),%eax
  80135c:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  80135e:	a1 80 60 80 00       	mov    0x806080,%eax
  801363:	8b 50 70             	mov    0x70(%eax),%edx

}
  801366:	89 d0                	mov    %edx,%eax
  801368:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80136b:	5b                   	pop    %ebx
  80136c:	5e                   	pop    %esi
  80136d:	c9                   	leave  
  80136e:	c3                   	ret    

0080136f <ipc_send>:

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
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
  801372:	57                   	push   %edi
  801373:	56                   	push   %esi
  801374:	53                   	push   %ebx
  801375:	83 ec 0c             	sub    $0xc,%esp
  801378:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80137b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80137e:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  801381:	85 db                	test   %ebx,%ebx
  801383:	75 0a                	jne    80138f <ipc_send+0x20>
    pg = (void *) UTOP;
  801385:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  80138a:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  80138f:	56                   	push   %esi
  801390:	53                   	push   %ebx
  801391:	57                   	push   %edi
  801392:	ff 75 08             	pushl  0x8(%ebp)
  801395:	e8 05 fa ff ff       	call   800d9f <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  80139a:	83 c4 10             	add    $0x10,%esp
  80139d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8013a0:	75 07                	jne    8013a9 <ipc_send+0x3a>
      sys_yield();
  8013a2:	e8 4c f8 ff ff       	call   800bf3 <sys_yield>
  8013a7:	eb e6                	jmp    80138f <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	79 12                	jns    8013bf <ipc_send+0x50>
  8013ad:	50                   	push   %eax
  8013ae:	68 fb 2d 80 00       	push   $0x802dfb
  8013b3:	6a 49                	push   $0x49
  8013b5:	68 18 2e 80 00       	push   $0x802e18
  8013ba:	e8 8d ed ff ff       	call   80014c <_panic>
    else break;
  }
}
  8013bf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    
	...

008013c8 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
  8013cb:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8013ce:	ff 75 08             	pushl  0x8(%ebp)
  8013d1:	e8 0a 00 00 00       	call   8013e0 <fd2num>
  8013d6:	c1 e0 16             	shl    $0x16,%eax
  8013d9:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <fd2num>:

int
fd2num(struct Fd *fd)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	05 00 00 40 30       	add    $0x30400000,%eax
  8013eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <fd_alloc>:

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
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	57                   	push   %edi
  8013f4:	56                   	push   %esi
  8013f5:	53                   	push   %ebx
  8013f6:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013fe:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801403:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  801408:	89 c8                	mov    %ecx,%eax
  80140a:	c1 e0 0c             	shl    $0xc,%eax
  80140d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801413:	89 d0                	mov    %edx,%eax
  801415:	c1 e8 16             	shr    $0x16,%eax
  801418:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80141b:	a8 01                	test   $0x1,%al
  80141d:	74 0c                	je     80142b <fd_alloc+0x3b>
  80141f:	89 d0                	mov    %edx,%eax
  801421:	c1 e8 0c             	shr    $0xc,%eax
  801424:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  801427:	a8 01                	test   $0x1,%al
  801429:	75 09                	jne    801434 <fd_alloc+0x44>
			*fd_store = fd;
  80142b:	89 17                	mov    %edx,(%edi)
			return 0;
  80142d:	b8 00 00 00 00       	mov    $0x0,%eax
  801432:	eb 11                	jmp    801445 <fd_alloc+0x55>
  801434:	41                   	inc    %ecx
  801435:	83 f9 1f             	cmp    $0x1f,%ecx
  801438:	7e ce                	jle    801408 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80143a:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801440:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5f                   	pop    %edi
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801450:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801455:	83 f8 1f             	cmp    $0x1f,%eax
  801458:	77 3a                	ja     801494 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80145a:	c1 e0 0c             	shl    $0xc,%eax
  80145d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801463:	89 d0                	mov    %edx,%eax
  801465:	c1 e8 16             	shr    $0x16,%eax
  801468:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80146f:	a8 01                	test   $0x1,%al
  801471:	74 10                	je     801483 <fd_lookup+0x39>
  801473:	89 d0                	mov    %edx,%eax
  801475:	c1 e8 0c             	shr    $0xc,%eax
  801478:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80147f:	a8 01                	test   $0x1,%al
  801481:	75 07                	jne    80148a <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801483:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801488:	eb 0a                	jmp    801494 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  80148a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148d:	89 10                	mov    %edx,(%eax)
	return 0;
  80148f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801494:	89 d0                	mov    %edx,%eax
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <fd_close>:

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
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	56                   	push   %esi
  80149c:	53                   	push   %ebx
  80149d:	83 ec 10             	sub    $0x10,%esp
  8014a0:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014a3:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8014a6:	50                   	push   %eax
  8014a7:	56                   	push   %esi
  8014a8:	e8 33 ff ff ff       	call   8013e0 <fd2num>
  8014ad:	89 04 24             	mov    %eax,(%esp)
  8014b0:	e8 95 ff ff ff       	call   80144a <fd_lookup>
  8014b5:	89 c3                	mov    %eax,%ebx
  8014b7:	83 c4 08             	add    $0x8,%esp
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	78 05                	js     8014c3 <fd_close+0x2b>
  8014be:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8014c1:	74 0f                	je     8014d2 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8014c3:	89 d8                	mov    %ebx,%eax
  8014c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014c9:	75 3a                	jne    801505 <fd_close+0x6d>
  8014cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d0:	eb 33                	jmp    801505 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8014d2:	83 ec 08             	sub    $0x8,%esp
  8014d5:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8014d8:	50                   	push   %eax
  8014d9:	ff 36                	pushl  (%esi)
  8014db:	e8 2c 00 00 00       	call   80150c <dev_lookup>
  8014e0:	89 c3                	mov    %eax,%ebx
  8014e2:	83 c4 10             	add    $0x10,%esp
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	78 0f                	js     8014f8 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8014e9:	83 ec 0c             	sub    $0xc,%esp
  8014ec:	56                   	push   %esi
  8014ed:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8014f0:	ff 50 10             	call   *0x10(%eax)
  8014f3:	89 c3                	mov    %eax,%ebx
  8014f5:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	56                   	push   %esi
  8014fc:	6a 00                	push   $0x0
  8014fe:	e8 94 f7 ff ff       	call   800c97 <sys_page_unmap>
	return r;
  801503:	89 d8                	mov    %ebx,%eax
}
  801505:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801508:	5b                   	pop    %ebx
  801509:	5e                   	pop    %esi
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <dev_lookup>:


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
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	56                   	push   %esi
  801510:	53                   	push   %ebx
  801511:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801514:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  801517:	ba 00 00 00 00       	mov    $0x0,%edx
  80151c:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  801523:	74 1c                	je     801541 <dev_lookup+0x35>
  801525:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80152a:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  80152d:	39 18                	cmp    %ebx,(%eax)
  80152f:	75 09                	jne    80153a <dev_lookup+0x2e>
			*dev = devtab[i];
  801531:	89 06                	mov    %eax,(%esi)
			return 0;
  801533:	b8 00 00 00 00       	mov    $0x0,%eax
  801538:	eb 29                	jmp    801563 <dev_lookup+0x57>
  80153a:	42                   	inc    %edx
  80153b:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  80153f:	75 e9                	jne    80152a <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801541:	83 ec 04             	sub    $0x4,%esp
  801544:	53                   	push   %ebx
  801545:	a1 80 60 80 00       	mov    0x806080,%eax
  80154a:	8b 40 4c             	mov    0x4c(%eax),%eax
  80154d:	50                   	push   %eax
  80154e:	68 24 2e 80 00       	push   $0x802e24
  801553:	e8 e4 ec ff ff       	call   80023c <cprintf>
	*dev = 0;
  801558:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  80155e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801563:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801566:	5b                   	pop    %ebx
  801567:	5e                   	pop    %esi
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <close>:

int
close(int fdnum)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801570:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801573:	50                   	push   %eax
  801574:	ff 75 08             	pushl  0x8(%ebp)
  801577:	e8 ce fe ff ff       	call   80144a <fd_lookup>
  80157c:	83 c4 08             	add    $0x8,%esp
		return r;
  80157f:	89 c2                	mov    %eax,%edx
  801581:	85 c0                	test   %eax,%eax
  801583:	78 0f                	js     801594 <close+0x2a>
	else
		return fd_close(fd, 1);
  801585:	83 ec 08             	sub    $0x8,%esp
  801588:	6a 01                	push   $0x1
  80158a:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80158d:	e8 06 ff ff ff       	call   801498 <fd_close>
  801592:	89 c2                	mov    %eax,%edx
}
  801594:	89 d0                	mov    %edx,%eax
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <close_all>:

void
close_all(void)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	53                   	push   %ebx
  80159c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80159f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015a4:	83 ec 0c             	sub    $0xc,%esp
  8015a7:	53                   	push   %ebx
  8015a8:	e8 bd ff ff ff       	call   80156a <close>
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	43                   	inc    %ebx
  8015b1:	83 fb 1f             	cmp    $0x1f,%ebx
  8015b4:	7e ee                	jle    8015a4 <close_all+0xc>
}
  8015b6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	57                   	push   %edi
  8015bf:	56                   	push   %esi
  8015c0:	53                   	push   %ebx
  8015c1:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015c4:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8015c7:	50                   	push   %eax
  8015c8:	ff 75 08             	pushl  0x8(%ebp)
  8015cb:	e8 7a fe ff ff       	call   80144a <fd_lookup>
  8015d0:	89 c6                	mov    %eax,%esi
  8015d2:	83 c4 08             	add    $0x8,%esp
  8015d5:	85 f6                	test   %esi,%esi
  8015d7:	0f 88 f8 00 00 00    	js     8016d5 <dup+0x11a>
		return r;
	close(newfdnum);
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	ff 75 0c             	pushl  0xc(%ebp)
  8015e3:	e8 82 ff ff ff       	call   80156a <close>

	newfd = INDEX2FD(newfdnum);
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	c1 e0 0c             	shl    $0xc,%eax
  8015ee:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8015f3:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8015f6:	83 c4 04             	add    $0x4,%esp
  8015f9:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8015fc:	e8 c7 fd ff ff       	call   8013c8 <fd2data>
  801601:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801603:	83 c4 04             	add    $0x4,%esp
  801606:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801609:	e8 ba fd ff ff       	call   8013c8 <fd2data>
  80160e:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801611:	89 f8                	mov    %edi,%eax
  801613:	c1 e8 16             	shr    $0x16,%eax
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801620:	85 c0                	test   %eax,%eax
  801622:	74 48                	je     80166c <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801624:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  801629:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  80162c:	89 d0                	mov    %edx,%eax
  80162e:	c1 e8 0c             	shr    $0xc,%eax
  801631:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  801638:	a8 01                	test   $0x1,%al
  80163a:	74 22                	je     80165e <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  80163c:	83 ec 0c             	sub    $0xc,%esp
  80163f:	25 07 0e 00 00       	and    $0xe07,%eax
  801644:	50                   	push   %eax
  801645:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801648:	01 d8                	add    %ebx,%eax
  80164a:	50                   	push   %eax
  80164b:	6a 00                	push   $0x0
  80164d:	52                   	push   %edx
  80164e:	6a 00                	push   $0x0
  801650:	e8 00 f6 ff ff       	call   800c55 <sys_page_map>
  801655:	89 c6                	mov    %eax,%esi
  801657:	83 c4 20             	add    $0x20,%esp
  80165a:	85 c0                	test   %eax,%eax
  80165c:	78 3f                	js     80169d <dup+0xe2>
  80165e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801664:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80166a:	7e bd                	jle    801629 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80166c:	83 ec 0c             	sub    $0xc,%esp
  80166f:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801672:	89 d0                	mov    %edx,%eax
  801674:	c1 e8 0c             	shr    $0xc,%eax
  801677:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80167e:	25 07 0e 00 00       	and    $0xe07,%eax
  801683:	50                   	push   %eax
  801684:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801687:	6a 00                	push   $0x0
  801689:	52                   	push   %edx
  80168a:	6a 00                	push   $0x0
  80168c:	e8 c4 f5 ff ff       	call   800c55 <sys_page_map>
  801691:	89 c6                	mov    %eax,%esi
  801693:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	85 f6                	test   %esi,%esi
  80169b:	79 38                	jns    8016d5 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  80169d:	83 ec 08             	sub    $0x8,%esp
  8016a0:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8016a3:	6a 00                	push   $0x0
  8016a5:	e8 ed f5 ff ff       	call   800c97 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8016aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016af:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8016b2:	83 ec 08             	sub    $0x8,%esp
  8016b5:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8016b8:	01 d8                	add    %ebx,%eax
  8016ba:	50                   	push   %eax
  8016bb:	6a 00                	push   $0x0
  8016bd:	e8 d5 f5 ff ff       	call   800c97 <sys_page_unmap>
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016cb:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8016d1:	7e df                	jle    8016b2 <dup+0xf7>
	return r;
  8016d3:	89 f0                	mov    %esi,%eax
}
  8016d5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8016d8:	5b                   	pop    %ebx
  8016d9:	5e                   	pop    %esi
  8016da:	5f                   	pop    %edi
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	53                   	push   %ebx
  8016e1:	83 ec 14             	sub    $0x14,%esp
  8016e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e7:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8016ea:	50                   	push   %eax
  8016eb:	53                   	push   %ebx
  8016ec:	e8 59 fd ff ff       	call   80144a <fd_lookup>
  8016f1:	89 c2                	mov    %eax,%edx
  8016f3:	83 c4 08             	add    $0x8,%esp
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 1a                	js     801714 <read+0x37>
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801700:	50                   	push   %eax
  801701:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801704:	ff 30                	pushl  (%eax)
  801706:	e8 01 fe ff ff       	call   80150c <dev_lookup>
  80170b:	89 c2                	mov    %eax,%edx
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	85 c0                	test   %eax,%eax
  801712:	79 04                	jns    801718 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801714:	89 d0                	mov    %edx,%eax
  801716:	eb 50                	jmp    801768 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801718:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80171b:	8b 40 08             	mov    0x8(%eax),%eax
  80171e:	83 e0 03             	and    $0x3,%eax
  801721:	83 f8 01             	cmp    $0x1,%eax
  801724:	75 1e                	jne    801744 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801726:	83 ec 04             	sub    $0x4,%esp
  801729:	53                   	push   %ebx
  80172a:	a1 80 60 80 00       	mov    0x806080,%eax
  80172f:	8b 40 4c             	mov    0x4c(%eax),%eax
  801732:	50                   	push   %eax
  801733:	68 65 2e 80 00       	push   $0x802e65
  801738:	e8 ff ea ff ff       	call   80023c <cprintf>
		return -E_INVAL;
  80173d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801742:	eb 24                	jmp    801768 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801744:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801747:	ff 70 04             	pushl  0x4(%eax)
  80174a:	ff 75 10             	pushl  0x10(%ebp)
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	50                   	push   %eax
  801751:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801754:	ff 50 08             	call   *0x8(%eax)
  801757:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 06                	js     801766 <read+0x89>
		fd->fd_offset += r;
  801760:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801763:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801766:	89 d0                	mov    %edx,%eax
}
  801768:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80176b:	c9                   	leave  
  80176c:	c3                   	ret    

0080176d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80176d:	55                   	push   %ebp
  80176e:	89 e5                	mov    %esp,%ebp
  801770:	57                   	push   %edi
  801771:	56                   	push   %esi
  801772:	53                   	push   %ebx
  801773:	83 ec 0c             	sub    $0xc,%esp
  801776:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801779:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80177c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801781:	39 f3                	cmp    %esi,%ebx
  801783:	73 25                	jae    8017aa <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	89 f0                	mov    %esi,%eax
  80178a:	29 d8                	sub    %ebx,%eax
  80178c:	50                   	push   %eax
  80178d:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801790:	50                   	push   %eax
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 44 ff ff ff       	call   8016dd <read>
		if (m < 0)
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	85 c0                	test   %eax,%eax
  80179e:	78 0c                	js     8017ac <readn+0x3f>
			return m;
		if (m == 0)
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	74 06                	je     8017aa <readn+0x3d>
  8017a4:	01 c3                	add    %eax,%ebx
  8017a6:	39 f3                	cmp    %esi,%ebx
  8017a8:	72 db                	jb     801785 <readn+0x18>
			break;
	}
	return tot;
  8017aa:	89 d8                	mov    %ebx,%eax
}
  8017ac:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5f                   	pop    %edi
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	53                   	push   %ebx
  8017b8:	83 ec 14             	sub    $0x14,%esp
  8017bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017be:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8017c1:	50                   	push   %eax
  8017c2:	53                   	push   %ebx
  8017c3:	e8 82 fc ff ff       	call   80144a <fd_lookup>
  8017c8:	89 c2                	mov    %eax,%edx
  8017ca:	83 c4 08             	add    $0x8,%esp
  8017cd:	85 c0                	test   %eax,%eax
  8017cf:	78 1a                	js     8017eb <write+0x37>
  8017d1:	83 ec 08             	sub    $0x8,%esp
  8017d4:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8017d7:	50                   	push   %eax
  8017d8:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017db:	ff 30                	pushl  (%eax)
  8017dd:	e8 2a fd ff ff       	call   80150c <dev_lookup>
  8017e2:	89 c2                	mov    %eax,%edx
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	85 c0                	test   %eax,%eax
  8017e9:	79 04                	jns    8017ef <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8017eb:	89 d0                	mov    %edx,%eax
  8017ed:	eb 4b                	jmp    80183a <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017ef:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017f2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017f6:	75 1e                	jne    801816 <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	53                   	push   %ebx
  8017fc:	a1 80 60 80 00       	mov    0x806080,%eax
  801801:	8b 40 4c             	mov    0x4c(%eax),%eax
  801804:	50                   	push   %eax
  801805:	68 81 2e 80 00       	push   $0x802e81
  80180a:	e8 2d ea ff ff       	call   80023c <cprintf>
		return -E_INVAL;
  80180f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801814:	eb 24                	jmp    80183a <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801816:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801819:	ff 70 04             	pushl  0x4(%eax)
  80181c:	ff 75 10             	pushl  0x10(%ebp)
  80181f:	ff 75 0c             	pushl  0xc(%ebp)
  801822:	50                   	push   %eax
  801823:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801826:	ff 50 0c             	call   *0xc(%eax)
  801829:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	85 c0                	test   %eax,%eax
  801830:	7e 06                	jle    801838 <write+0x84>
		fd->fd_offset += r;
  801832:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801835:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801838:	89 d0                	mov    %edx,%eax
}
  80183a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <seek>:

int
seek(int fdnum, off_t offset)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801845:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801848:	50                   	push   %eax
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	e8 f9 fb ff ff       	call   80144a <fd_lookup>
  801851:	83 c4 08             	add    $0x8,%esp
		return r;
  801854:	89 c2                	mov    %eax,%edx
  801856:	85 c0                	test   %eax,%eax
  801858:	78 0e                	js     801868 <seek+0x29>
	fd->fd_offset = offset;
  80185a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801860:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801863:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801868:	89 d0                	mov    %edx,%eax
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	53                   	push   %ebx
  801870:	83 ec 14             	sub    $0x14,%esp
  801873:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801876:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801879:	50                   	push   %eax
  80187a:	53                   	push   %ebx
  80187b:	e8 ca fb ff ff       	call   80144a <fd_lookup>
  801880:	83 c4 08             	add    $0x8,%esp
  801883:	85 c0                	test   %eax,%eax
  801885:	78 4e                	js     8018d5 <ftruncate+0x69>
  801887:	83 ec 08             	sub    $0x8,%esp
  80188a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80188d:	50                   	push   %eax
  80188e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801891:	ff 30                	pushl  (%eax)
  801893:	e8 74 fc ff ff       	call   80150c <dev_lookup>
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	85 c0                	test   %eax,%eax
  80189d:	78 36                	js     8018d5 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80189f:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018a6:	75 1e                	jne    8018c6 <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	53                   	push   %ebx
  8018ac:	a1 80 60 80 00       	mov    0x806080,%eax
  8018b1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018b4:	50                   	push   %eax
  8018b5:	68 44 2e 80 00       	push   $0x802e44
  8018ba:	e8 7d e9 ff ff       	call   80023c <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8018bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c4:	eb 0f                	jmp    8018d5 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8018c6:	83 ec 08             	sub    $0x8,%esp
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8018cf:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8018d2:	ff 50 1c             	call   *0x1c(%eax)
}
  8018d5:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 14             	sub    $0x14,%esp
  8018e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e4:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8018e7:	50                   	push   %eax
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	e8 5a fb ff ff       	call   80144a <fd_lookup>
  8018f0:	83 c4 08             	add    $0x8,%esp
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 42                	js     801939 <fstat+0x5f>
  8018f7:	83 ec 08             	sub    $0x8,%esp
  8018fa:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8018fd:	50                   	push   %eax
  8018fe:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801901:	ff 30                	pushl  (%eax)
  801903:	e8 04 fc ff ff       	call   80150c <dev_lookup>
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 2a                	js     801939 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  80190f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801912:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801919:	00 00 00 
	stat->st_isdir = 0;
  80191c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801923:	00 00 00 
	stat->st_dev = dev;
  801926:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801929:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80192f:	83 ec 08             	sub    $0x8,%esp
  801932:	53                   	push   %ebx
  801933:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801936:	ff 50 14             	call   *0x14(%eax)
}
  801939:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	56                   	push   %esi
  801942:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801943:	83 ec 08             	sub    $0x8,%esp
  801946:	6a 00                	push   $0x0
  801948:	ff 75 08             	pushl  0x8(%ebp)
  80194b:	e8 28 00 00 00       	call   801978 <open>
  801950:	89 c6                	mov    %eax,%esi
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	85 f6                	test   %esi,%esi
  801957:	78 18                	js     801971 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801959:	83 ec 08             	sub    $0x8,%esp
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	56                   	push   %esi
  801960:	e8 75 ff ff ff       	call   8018da <fstat>
  801965:	89 c3                	mov    %eax,%ebx
	close(fd);
  801967:	89 34 24             	mov    %esi,(%esp)
  80196a:	e8 fb fb ff ff       	call   80156a <close>
	return r;
  80196f:	89 d8                	mov    %ebx,%eax
}
  801971:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801974:	5b                   	pop    %ebx
  801975:	5e                   	pop    %esi
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	53                   	push   %ebx
  80197c:	83 ec 10             	sub    $0x10,%esp
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
  80197f:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801982:	50                   	push   %eax
  801983:	e8 68 fa ff ff       	call   8013f0 <fd_alloc>
  801988:	89 c3                	mov    %eax,%ebx
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	85 db                	test   %ebx,%ebx
  80198f:	78 36                	js     8019c7 <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801997:	ff 75 0c             	pushl  0xc(%ebp)
  80199a:	ff 75 08             	pushl  0x8(%ebp)
  80199d:	e8 1b 05 00 00       	call   801ebd <fsipc_open>
  8019a2:	89 c3                	mov    %eax,%ebx
  8019a4:	83 c4 10             	add    $0x10,%esp
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	79 11                	jns    8019bc <open+0x44>
          fd_close(fd_store, 0);
  8019ab:	83 ec 08             	sub    $0x8,%esp
  8019ae:	6a 00                	push   $0x0
  8019b0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8019b3:	e8 e0 fa ff ff       	call   801498 <fd_close>
          return r;
  8019b8:	89 d8                	mov    %ebx,%eax
  8019ba:	eb 0b                	jmp    8019c7 <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  8019bc:	83 ec 0c             	sub    $0xc,%esp
  8019bf:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8019c2:	e8 19 fa ff ff       	call   8013e0 <fd2num>
}
  8019c7:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	53                   	push   %ebx
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  8019d6:	6a 01                	push   $0x1
  8019d8:	6a 00                	push   $0x0
  8019da:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  8019e0:	53                   	push   %ebx
  8019e1:	e8 e7 03 00 00       	call   801dcd <funmap>
  8019e6:	83 c4 10             	add    $0x10,%esp
          return r;
  8019e9:	89 c2                	mov    %eax,%edx
  8019eb:	85 c0                	test   %eax,%eax
  8019ed:	78 19                	js     801a08 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  8019ef:	83 ec 0c             	sub    $0xc,%esp
  8019f2:	ff 73 0c             	pushl  0xc(%ebx)
  8019f5:	e8 68 05 00 00       	call   801f62 <fsipc_close>
  8019fa:	83 c4 10             	add    $0x10,%esp
          return r;
  8019fd:	89 c2                	mov    %eax,%edx
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	78 05                	js     801a08 <file_close+0x3c>
        }
        return 0;
  801a03:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a08:	89 d0                	mov    %edx,%eax
  801a0a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	57                   	push   %edi
  801a13:	56                   	push   %esi
  801a14:	53                   	push   %ebx
  801a15:	83 ec 0c             	sub    $0xc,%esp
  801a18:	8b 75 10             	mov    0x10(%ebp),%esi
  801a1b:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  801a27:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a2c:	39 d7                	cmp    %edx,%edi
  801a2e:	0f 87 95 00 00 00    	ja     801ac9 <file_read+0xba>
	if (offset + n > size)
  801a34:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801a37:	39 d0                	cmp    %edx,%eax
  801a39:	76 04                	jbe    801a3f <file_read+0x30>
		n = size - offset;
  801a3b:	89 d6                	mov    %edx,%esi
  801a3d:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801a3f:	83 ec 0c             	sub    $0xc,%esp
  801a42:	ff 75 08             	pushl  0x8(%ebp)
  801a45:	e8 7e f9 ff ff       	call   8013c8 <fd2data>
  801a4a:	89 c3                	mov    %eax,%ebx
  801a4c:	01 fb                	add    %edi,%ebx
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	eb 41                	jmp    801a94 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801a53:	89 d8                	mov    %ebx,%eax
  801a55:	c1 e8 16             	shr    $0x16,%eax
  801a58:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801a5f:	a8 01                	test   $0x1,%al
  801a61:	74 10                	je     801a73 <file_read+0x64>
  801a63:	89 d8                	mov    %ebx,%eax
  801a65:	c1 e8 0c             	shr    $0xc,%eax
  801a68:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a6f:	a8 01                	test   $0x1,%al
  801a71:	75 1b                	jne    801a8e <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801a73:	83 ec 04             	sub    $0x4,%esp
  801a76:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801a79:	50                   	push   %eax
  801a7a:	57                   	push   %edi
  801a7b:	ff 75 08             	pushl  0x8(%ebp)
  801a7e:	e8 d4 02 00 00       	call   801d57 <fmap>
  801a83:	83 c4 10             	add    $0x10,%esp
              return r;
  801a86:	89 c1                	mov    %eax,%ecx
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	78 3d                	js     801ac9 <file_read+0xba>
  801a8c:	eb 1c                	jmp    801aaa <file_read+0x9b>
  801a8e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a94:	83 ec 0c             	sub    $0xc,%esp
  801a97:	ff 75 08             	pushl  0x8(%ebp)
  801a9a:	e8 29 f9 ff ff       	call   8013c8 <fd2data>
  801a9f:	01 f8                	add    %edi,%eax
  801aa1:	01 f0                	add    %esi,%eax
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	39 d8                	cmp    %ebx,%eax
  801aa8:	77 a9                	ja     801a53 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801aaa:	83 ec 04             	sub    $0x4,%esp
  801aad:	56                   	push   %esi
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	e8 0f f9 ff ff       	call   8013c8 <fd2data>
  801ab9:	83 c4 08             	add    $0x8,%esp
  801abc:	01 f8                	add    %edi,%eax
  801abe:	50                   	push   %eax
  801abf:	ff 75 0c             	pushl  0xc(%ebp)
  801ac2:	e8 f5 ee ff ff       	call   8009bc <memmove>
	return n;
  801ac7:	89 f1                	mov    %esi,%ecx
}
  801ac9:	89 c8                	mov    %ecx,%eax
  801acb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ace:	5b                   	pop    %ebx
  801acf:	5e                   	pop    %esi
  801ad0:	5f                   	pop    %edi
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	56                   	push   %esi
  801ad7:	53                   	push   %ebx
  801ad8:	83 ec 18             	sub    $0x18,%esp
  801adb:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ade:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801ae1:	50                   	push   %eax
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	e8 60 f9 ff ff       	call   80144a <fd_lookup>
  801aea:	83 c4 10             	add    $0x10,%esp
		return r;
  801aed:	89 c2                	mov    %eax,%edx
  801aef:	85 c0                	test   %eax,%eax
  801af1:	0f 88 9f 00 00 00    	js     801b96 <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801af7:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801afa:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  801afc:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801b01:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  801b07:	0f 85 89 00 00 00    	jne    801b96 <read_map+0xc3>
	va = fd2data(fd) + offset;
  801b0d:	83 ec 0c             	sub    $0xc,%esp
  801b10:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801b13:	e8 b0 f8 ff ff       	call   8013c8 <fd2data>
  801b18:	89 c3                	mov    %eax,%ebx
  801b1a:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801b1c:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801b1f:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801b24:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801b2a:	7f 6a                	jg     801b96 <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801b2c:	89 d8                	mov    %ebx,%eax
  801b2e:	c1 e8 16             	shr    $0x16,%eax
  801b31:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801b38:	a8 01                	test   $0x1,%al
  801b3a:	74 10                	je     801b4c <read_map+0x79>
  801b3c:	89 d8                	mov    %ebx,%eax
  801b3e:	c1 e8 0c             	shr    $0xc,%eax
  801b41:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b48:	a8 01                	test   $0x1,%al
  801b4a:	75 19                	jne    801b65 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801b4c:	83 ec 04             	sub    $0x4,%esp
  801b4f:	8d 46 01             	lea    0x1(%esi),%eax
  801b52:	50                   	push   %eax
  801b53:	56                   	push   %esi
  801b54:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801b57:	e8 fb 01 00 00       	call   801d57 <fmap>
  801b5c:	83 c4 10             	add    $0x10,%esp
            return r;
  801b5f:	89 c2                	mov    %eax,%edx
  801b61:	85 c0                	test   %eax,%eax
  801b63:	78 31                	js     801b96 <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801b65:	89 d8                	mov    %ebx,%eax
  801b67:	c1 e8 16             	shr    $0x16,%eax
  801b6a:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801b71:	a8 01                	test   $0x1,%al
  801b73:	74 10                	je     801b85 <read_map+0xb2>
  801b75:	89 d8                	mov    %ebx,%eax
  801b77:	c1 e8 0c             	shr    $0xc,%eax
  801b7a:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b81:	a8 01                	test   $0x1,%al
  801b83:	75 07                	jne    801b8c <read_map+0xb9>
		return -E_NO_DISK;
  801b85:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801b8a:	eb 0a                	jmp    801b96 <read_map+0xc3>

	*blk = (void*) va;
  801b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8f:	89 18                	mov    %ebx,(%eax)
	return 0;
  801b91:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b96:	89 d0                	mov    %edx,%eax
  801b98:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	57                   	push   %edi
  801ba3:	56                   	push   %esi
  801ba4:	53                   	push   %ebx
  801ba5:	83 ec 0c             	sub    $0xc,%esp
  801ba8:	8b 75 08             	mov    0x8(%ebp),%esi
  801bab:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801bae:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb1:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801bb4:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801bb9:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801bbf:	0f 87 bd 00 00 00    	ja     801c82 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801bc5:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801bcb:	73 17                	jae    801be4 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801bcd:	83 ec 08             	sub    $0x8,%esp
  801bd0:	52                   	push   %edx
  801bd1:	56                   	push   %esi
  801bd2:	e8 fb 00 00 00       	call   801cd2 <file_trunc>
  801bd7:	83 c4 10             	add    $0x10,%esp
			return r;
  801bda:	89 c1                	mov    %eax,%ecx
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	0f 88 9e 00 00 00    	js     801c82 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801be4:	83 ec 0c             	sub    $0xc,%esp
  801be7:	56                   	push   %esi
  801be8:	e8 db f7 ff ff       	call   8013c8 <fd2data>
  801bed:	89 c3                	mov    %eax,%ebx
  801bef:	01 fb                	add    %edi,%ebx
  801bf1:	83 c4 10             	add    $0x10,%esp
  801bf4:	eb 42                	jmp    801c38 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801bf6:	89 d8                	mov    %ebx,%eax
  801bf8:	c1 e8 16             	shr    $0x16,%eax
  801bfb:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801c02:	a8 01                	test   $0x1,%al
  801c04:	74 10                	je     801c16 <file_write+0x77>
  801c06:	89 d8                	mov    %ebx,%eax
  801c08:	c1 e8 0c             	shr    $0xc,%eax
  801c0b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801c12:	a8 01                	test   $0x1,%al
  801c14:	75 1c                	jne    801c32 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801c16:	83 ec 04             	sub    $0x4,%esp
  801c19:	8b 55 10             	mov    0x10(%ebp),%edx
  801c1c:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801c1f:	50                   	push   %eax
  801c20:	57                   	push   %edi
  801c21:	56                   	push   %esi
  801c22:	e8 30 01 00 00       	call   801d57 <fmap>
  801c27:	83 c4 10             	add    $0x10,%esp
              return r;
  801c2a:	89 c1                	mov    %eax,%ecx
  801c2c:	85 c0                	test   %eax,%eax
  801c2e:	78 52                	js     801c82 <file_write+0xe3>
  801c30:	eb 1b                	jmp    801c4d <file_write+0xae>
  801c32:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c38:	83 ec 0c             	sub    $0xc,%esp
  801c3b:	56                   	push   %esi
  801c3c:	e8 87 f7 ff ff       	call   8013c8 <fd2data>
  801c41:	01 f8                	add    %edi,%eax
  801c43:	03 45 10             	add    0x10(%ebp),%eax
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	39 d8                	cmp    %ebx,%eax
  801c4b:	77 a9                	ja     801bf6 <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801c4d:	83 ec 0c             	sub    $0xc,%esp
  801c50:	68 9e 2e 80 00       	push   $0x802e9e
  801c55:	e8 e2 e5 ff ff       	call   80023c <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801c5a:	83 c4 0c             	add    $0xc,%esp
  801c5d:	ff 75 10             	pushl  0x10(%ebp)
  801c60:	ff 75 0c             	pushl  0xc(%ebp)
  801c63:	56                   	push   %esi
  801c64:	e8 5f f7 ff ff       	call   8013c8 <fd2data>
  801c69:	01 f8                	add    %edi,%eax
  801c6b:	89 04 24             	mov    %eax,(%esp)
  801c6e:	e8 49 ed ff ff       	call   8009bc <memmove>
        cprintf("write done\n");
  801c73:	c7 04 24 ab 2e 80 00 	movl   $0x802eab,(%esp)
  801c7a:	e8 bd e5 ff ff       	call   80023c <cprintf>
	return n;
  801c7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801c82:	89 c8                	mov    %ecx,%eax
  801c84:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c87:	5b                   	pop    %ebx
  801c88:	5e                   	pop    %esi
  801c89:	5f                   	pop    %edi
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
  801c8f:	56                   	push   %esi
  801c90:	53                   	push   %ebx
  801c91:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c94:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801c97:	83 ec 08             	sub    $0x8,%esp
  801c9a:	8d 43 10             	lea    0x10(%ebx),%eax
  801c9d:	50                   	push   %eax
  801c9e:	56                   	push   %esi
  801c9f:	e8 9c eb ff ff       	call   800840 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801ca4:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801caa:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801cb0:	83 c4 10             	add    $0x10,%esp
  801cb3:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801cba:	0f 94 c0             	sete   %al
  801cbd:	0f b6 c0             	movzbl %al,%eax
  801cc0:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ccb:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801cce:	5b                   	pop    %ebx
  801ccf:	5e                   	pop    %esi
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	57                   	push   %edi
  801cd6:	56                   	push   %esi
  801cd7:	53                   	push   %ebx
  801cd8:	83 ec 0c             	sub    $0xc,%esp
  801cdb:	8b 75 08             	mov    0x8(%ebp),%esi
  801cde:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801ce1:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801ce6:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801cec:	7f 5f                	jg     801d4d <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801cee:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801cf4:	83 ec 08             	sub    $0x8,%esp
  801cf7:	53                   	push   %ebx
  801cf8:	ff 76 0c             	pushl  0xc(%esi)
  801cfb:	e8 3a 02 00 00       	call   801f3a <fsipc_set_size>
  801d00:	83 c4 10             	add    $0x10,%esp
		return r;
  801d03:	89 c2                	mov    %eax,%edx
  801d05:	85 c0                	test   %eax,%eax
  801d07:	78 44                	js     801d4d <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801d09:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801d0f:	74 19                	je     801d2a <file_trunc+0x58>
  801d11:	68 d8 2e 80 00       	push   $0x802ed8
  801d16:	68 b7 2e 80 00       	push   $0x802eb7
  801d1b:	68 dc 00 00 00       	push   $0xdc
  801d20:	68 cc 2e 80 00       	push   $0x802ecc
  801d25:	e8 22 e4 ff ff       	call   80014c <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801d2a:	83 ec 04             	sub    $0x4,%esp
  801d2d:	53                   	push   %ebx
  801d2e:	57                   	push   %edi
  801d2f:	56                   	push   %esi
  801d30:	e8 22 00 00 00       	call   801d57 <fmap>
  801d35:	83 c4 10             	add    $0x10,%esp
		return r;
  801d38:	89 c2                	mov    %eax,%edx
  801d3a:	85 c0                	test   %eax,%eax
  801d3c:	78 0f                	js     801d4d <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	53                   	push   %ebx
  801d41:	57                   	push   %edi
  801d42:	56                   	push   %esi
  801d43:	e8 85 00 00 00       	call   801dcd <funmap>

	return 0;
  801d48:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d4d:	89 d0                	mov    %edx,%eax
  801d4f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d52:	5b                   	pop    %ebx
  801d53:	5e                   	pop    %esi
  801d54:	5f                   	pop    %edi
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <fmap>:

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
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	57                   	push   %edi
  801d5b:	56                   	push   %esi
  801d5c:	53                   	push   %ebx
  801d5d:	83 ec 0c             	sub    $0xc,%esp
  801d60:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d63:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801d66:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801d69:	7d 55                	jge    801dc0 <fmap+0x69>
          fma = fd2data(fd);
  801d6b:	83 ec 0c             	sub    $0xc,%esp
  801d6e:	57                   	push   %edi
  801d6f:	e8 54 f6 ff ff       	call   8013c8 <fd2data>
  801d74:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7d:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d82:	89 c3                	mov    %eax,%ebx
  801d84:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801d8a:	39 f3                	cmp    %esi,%ebx
  801d8c:	7d 32                	jge    801dc0 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801d8e:	83 ec 04             	sub    $0x4,%esp
  801d91:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801d94:	01 d8                	add    %ebx,%eax
  801d96:	50                   	push   %eax
  801d97:	53                   	push   %ebx
  801d98:	ff 77 0c             	pushl  0xc(%edi)
  801d9b:	e8 6f 01 00 00       	call   801f0f <fsipc_map>
  801da0:	83 c4 10             	add    $0x10,%esp
  801da3:	85 c0                	test   %eax,%eax
  801da5:	79 0f                	jns    801db6 <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	ff 75 0c             	pushl  0xc(%ebp)
  801dac:	53                   	push   %ebx
  801dad:	57                   	push   %edi
  801dae:	e8 1a 00 00 00       	call   801dcd <funmap>
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801dbc:	39 f3                	cmp    %esi,%ebx
  801dbe:	7c ce                	jl     801d8e <fmap+0x37>
            }
          }
        }

        return 0;
}
  801dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801dc8:	5b                   	pop    %ebx
  801dc9:	5e                   	pop    %esi
  801dca:	5f                   	pop    %edi
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <funmap>:

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
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	57                   	push   %edi
  801dd1:	56                   	push   %esi
  801dd2:	53                   	push   %ebx
  801dd3:	83 ec 0c             	sub    $0xc,%esp
  801dd6:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801ddc:	39 f3                	cmp    %esi,%ebx
  801dde:	0f 8d 80 00 00 00    	jge    801e64 <funmap+0x97>
          fma = fd2data(fd);
  801de4:	83 ec 0c             	sub    $0xc,%esp
  801de7:	ff 75 08             	pushl  0x8(%ebp)
  801dea:	e8 d9 f5 ff ff       	call   8013c8 <fd2data>
  801def:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801df1:	83 c4 10             	add    $0x10,%esp
  801df4:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801dfa:	89 c3                	mov    %eax,%ebx
  801dfc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801e02:	39 f3                	cmp    %esi,%ebx
  801e04:	7d 5e                	jge    801e64 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801e06:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801e09:	89 c2                	mov    %eax,%edx
  801e0b:	c1 ea 0c             	shr    $0xc,%edx
  801e0e:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801e15:	a8 01                	test   $0x1,%al
  801e17:	74 41                	je     801e5a <funmap+0x8d>
              if (dirty) {
  801e19:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801e1d:	74 21                	je     801e40 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801e1f:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801e26:	a8 40                	test   $0x40,%al
  801e28:	74 16                	je     801e40 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801e2a:	83 ec 08             	sub    $0x8,%esp
  801e2d:	53                   	push   %ebx
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e31:	ff 70 0c             	pushl  0xc(%eax)
  801e34:	e8 49 01 00 00       	call   801f82 <fsipc_dirty>
  801e39:	83 c4 10             	add    $0x10,%esp
  801e3c:	85 c0                	test   %eax,%eax
  801e3e:	78 29                	js     801e69 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801e40:	83 ec 08             	sub    $0x8,%esp
  801e43:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801e46:	50                   	push   %eax
  801e47:	83 ec 04             	sub    $0x4,%esp
  801e4a:	e8 85 ed ff ff       	call   800bd4 <sys_getenvid>
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 40 ee ff ff       	call   800c97 <sys_page_unmap>
  801e57:	83 c4 10             	add    $0x10,%esp
  801e5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e60:	39 f3                	cmp    %esi,%ebx
  801e62:	7c a2                	jl     801e06 <funmap+0x39>
            }
          }
        }

        return 0;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e69:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801e6c:	5b                   	pop    %ebx
  801e6d:	5e                   	pop    %esi
  801e6e:	5f                   	pop    %edi
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <remove>:

// Delete a file
int
remove(const char *path)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801e77:	ff 75 08             	pushl  0x8(%ebp)
  801e7a:	e8 2b 01 00 00       	call   801faa <fsipc_remove>
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801e87:	e8 64 01 00 00       	call   801ff0 <fsipc_sync>
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    
	...

00801e90 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801e96:	6a 07                	push   $0x7
  801e98:	ff 75 0c             	pushl  0xc(%ebp)
  801e9b:	ff 75 08             	pushl  0x8(%ebp)
  801e9e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801ea3:	50                   	push   %eax
  801ea4:	e8 c6 f4 ff ff       	call   80136f <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801ea9:	83 c4 0c             	add    $0xc,%esp
  801eac:	ff 75 14             	pushl  0x14(%ebp)
  801eaf:	ff 75 10             	pushl  0x10(%ebp)
  801eb2:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801eb5:	50                   	push   %eax
  801eb6:	e8 51 f4 ff ff       	call   80130c <ipc_recv>
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	56                   	push   %esi
  801ec1:	53                   	push   %ebx
  801ec2:	83 ec 1c             	sub    $0x1c,%esp
  801ec5:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801ec8:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801ecd:	56                   	push   %esi
  801ece:	e8 31 e9 ff ff       	call   800804 <strlen>
  801ed3:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801ed6:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801edb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ee0:	7f 24                	jg     801f06 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801ee2:	83 ec 08             	sub    $0x8,%esp
  801ee5:	56                   	push   %esi
  801ee6:	53                   	push   %ebx
  801ee7:	e8 54 e9 ff ff       	call   800840 <strcpy>
	req->req_omode = omode;
  801eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eef:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801ef5:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801ef8:	50                   	push   %eax
  801ef9:	ff 75 10             	pushl  0x10(%ebp)
  801efc:	53                   	push   %ebx
  801efd:	6a 01                	push   $0x1
  801eff:	e8 8c ff ff ff       	call   801e90 <fsipc>
  801f04:	89 c2                	mov    %eax,%edx
}
  801f06:	89 d0                	mov    %edx,%eax
  801f08:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801f0b:	5b                   	pop    %ebx
  801f0c:	5e                   	pop    %esi
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f20:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801f25:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801f28:	50                   	push   %eax
  801f29:	ff 75 10             	pushl  0x10(%ebp)
  801f2c:	68 00 30 80 00       	push   $0x803000
  801f31:	6a 02                	push   $0x2
  801f33:	e8 58 ff ff ff       	call   801e90 <fsipc>

	//return -E_UNSPECIFIED;
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  801f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4b:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	68 00 30 80 00       	push   $0x803000
  801f59:	6a 03                	push   $0x3
  801f5b:	e8 30 ff ff ff       	call   801e90 <fsipc>
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	68 00 30 80 00       	push   $0x803000
  801f79:	6a 04                	push   $0x4
  801f7b:	e8 10 ff ff ff       	call   801e90 <fsipc>
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f93:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	68 00 30 80 00       	push   $0x803000
  801fa1:	6a 05                	push   $0x5
  801fa3:	e8 e8 fe ff ff       	call   801e90 <fsipc>
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	56                   	push   %esi
  801fae:	53                   	push   %ebx
  801faf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801fb2:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801fb7:	83 ec 0c             	sub    $0xc,%esp
  801fba:	53                   	push   %ebx
  801fbb:	e8 44 e8 ff ff       	call   800804 <strlen>
  801fc0:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801fc3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801fc8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fcd:	7f 18                	jg     801fe7 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801fcf:	83 ec 08             	sub    $0x8,%esp
  801fd2:	53                   	push   %ebx
  801fd3:	56                   	push   %esi
  801fd4:	e8 67 e8 ff ff       	call   800840 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	56                   	push   %esi
  801fde:	6a 06                	push   $0x6
  801fe0:	e8 ab fe ff ff       	call   801e90 <fsipc>
  801fe5:	89 c2                	mov    %eax,%edx
}
  801fe7:	89 d0                	mov    %edx,%eax
  801fe9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801fec:	5b                   	pop    %ebx
  801fed:	5e                   	pop    %esi
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	68 00 30 80 00       	push   $0x803000
  801fff:	6a 07                	push   $0x7
  802001:	e8 8a fe ff ff       	call   801e90 <fsipc>
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <pipe>:
};

int
pipe(int pfd[2])
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	57                   	push   %edi
  80200c:	56                   	push   %esi
  80200d:	53                   	push   %ebx
  80200e:	83 ec 18             	sub    $0x18,%esp
  802011:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802014:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  802017:	50                   	push   %eax
  802018:	e8 d3 f3 ff ff       	call   8013f0 <fd_alloc>
  80201d:	89 c3                	mov    %eax,%ebx
  80201f:	83 c4 10             	add    $0x10,%esp
  802022:	85 c0                	test   %eax,%eax
  802024:	0f 88 25 01 00 00    	js     80214f <pipe+0x147>
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 07 04 00 00       	push   $0x407
  802032:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802035:	6a 00                	push   $0x0
  802037:	e8 d6 eb ff ff       	call   800c12 <sys_page_alloc>
  80203c:	89 c3                	mov    %eax,%ebx
  80203e:	83 c4 10             	add    $0x10,%esp
  802041:	85 c0                	test   %eax,%eax
  802043:	0f 88 06 01 00 00    	js     80214f <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802049:	83 ec 0c             	sub    $0xc,%esp
  80204c:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  80204f:	50                   	push   %eax
  802050:	e8 9b f3 ff ff       	call   8013f0 <fd_alloc>
  802055:	89 c3                	mov    %eax,%ebx
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	85 c0                	test   %eax,%eax
  80205c:	0f 88 dd 00 00 00    	js     80213f <pipe+0x137>
  802062:	83 ec 04             	sub    $0x4,%esp
  802065:	68 07 04 00 00       	push   $0x407
  80206a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80206d:	6a 00                	push   $0x0
  80206f:	e8 9e eb ff ff       	call   800c12 <sys_page_alloc>
  802074:	89 c3                	mov    %eax,%ebx
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	85 c0                	test   %eax,%eax
  80207b:	0f 88 be 00 00 00    	js     80213f <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802081:	83 ec 0c             	sub    $0xc,%esp
  802084:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802087:	e8 3c f3 ff ff       	call   8013c8 <fd2data>
  80208c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80208e:	83 c4 0c             	add    $0xc,%esp
  802091:	68 07 04 00 00       	push   $0x407
  802096:	50                   	push   %eax
  802097:	6a 00                	push   $0x0
  802099:	e8 74 eb ff ff       	call   800c12 <sys_page_alloc>
  80209e:	89 c3                	mov    %eax,%ebx
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	85 c0                	test   %eax,%eax
  8020a5:	0f 88 84 00 00 00    	js     80212f <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ab:	83 ec 0c             	sub    $0xc,%esp
  8020ae:	68 07 04 00 00       	push   $0x407
  8020b3:	83 ec 0c             	sub    $0xc,%esp
  8020b6:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8020b9:	e8 0a f3 ff ff       	call   8013c8 <fd2data>
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	50                   	push   %eax
  8020c2:	6a 00                	push   $0x0
  8020c4:	56                   	push   %esi
  8020c5:	6a 00                	push   $0x0
  8020c7:	e8 89 eb ff ff       	call   800c55 <sys_page_map>
  8020cc:	89 c3                	mov    %eax,%ebx
  8020ce:	83 c4 20             	add    $0x20,%esp
  8020d1:	85 c0                	test   %eax,%eax
  8020d3:	78 4c                	js     802121 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8020d5:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8020db:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8020de:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020e0:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8020e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8020ea:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8020f0:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8020f3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020f5:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8020f8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8020ff:	83 ec 0c             	sub    $0xc,%esp
  802102:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802105:	e8 d6 f2 ff ff       	call   8013e0 <fd2num>
  80210a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  80210c:	83 c4 04             	add    $0x4,%esp
  80210f:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802112:	e8 c9 f2 ff ff       	call   8013e0 <fd2num>
  802117:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  80211a:	b8 00 00 00 00       	mov    $0x0,%eax
  80211f:	eb 30                	jmp    802151 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  802121:	83 ec 08             	sub    $0x8,%esp
  802124:	56                   	push   %esi
  802125:	6a 00                	push   $0x0
  802127:	e8 6b eb ff ff       	call   800c97 <sys_page_unmap>
  80212c:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  80212f:	83 ec 08             	sub    $0x8,%esp
  802132:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802135:	6a 00                	push   $0x0
  802137:	e8 5b eb ff ff       	call   800c97 <sys_page_unmap>
  80213c:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  80213f:	83 ec 08             	sub    $0x8,%esp
  802142:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802145:	6a 00                	push   $0x0
  802147:	e8 4b eb ff ff       	call   800c97 <sys_page_unmap>
  80214c:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  80214f:	89 d8                	mov    %ebx,%eax
}
  802151:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802154:	5b                   	pop    %ebx
  802155:	5e                   	pop    %esi
  802156:	5f                   	pop    %edi
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	57                   	push   %edi
  80215d:	56                   	push   %esi
  80215e:	53                   	push   %ebx
  80215f:	83 ec 0c             	sub    $0xc,%esp
  802162:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802165:	a1 80 60 80 00       	mov    0x806080,%eax
  80216a:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	ff 75 08             	pushl  0x8(%ebp)
  802173:	e8 48 04 00 00       	call   8025c0 <pageref>
  802178:	89 c3                	mov    %eax,%ebx
  80217a:	89 3c 24             	mov    %edi,(%esp)
  80217d:	e8 3e 04 00 00       	call   8025c0 <pageref>
  802182:	83 c4 10             	add    $0x10,%esp
  802185:	39 c3                	cmp    %eax,%ebx
  802187:	0f 94 c0             	sete   %al
  80218a:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  80218d:	8b 0d 80 60 80 00    	mov    0x806080,%ecx
  802193:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  802196:	39 c6                	cmp    %eax,%esi
  802198:	74 1b                	je     8021b5 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  80219a:	83 fa 01             	cmp    $0x1,%edx
  80219d:	75 c6                	jne    802165 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80219f:	6a 01                	push   $0x1
  8021a1:	8b 41 58             	mov    0x58(%ecx),%eax
  8021a4:	50                   	push   %eax
  8021a5:	56                   	push   %esi
  8021a6:	68 00 2f 80 00       	push   $0x802f00
  8021ab:	e8 8c e0 ff ff       	call   80023c <cprintf>
  8021b0:	83 c4 10             	add    $0x10,%esp
  8021b3:	eb b0                	jmp    802165 <_pipeisclosed+0xc>
	}
}
  8021b5:	89 d0                	mov    %edx,%eax
  8021b7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8021ba:	5b                   	pop    %ebx
  8021bb:	5e                   	pop    %esi
  8021bc:	5f                   	pop    %edi
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021c5:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8021c8:	50                   	push   %eax
  8021c9:	ff 75 08             	pushl  0x8(%ebp)
  8021cc:	e8 79 f2 ff ff       	call   80144a <fd_lookup>
  8021d1:	83 c4 10             	add    $0x10,%esp
		return r;
  8021d4:	89 c2                	mov    %eax,%edx
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	78 19                	js     8021f3 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  8021da:	83 ec 0c             	sub    $0xc,%esp
  8021dd:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8021e0:	e8 e3 f1 ff ff       	call   8013c8 <fd2data>
	return _pipeisclosed(fd, p);
  8021e5:	83 c4 08             	add    $0x8,%esp
  8021e8:	50                   	push   %eax
  8021e9:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8021ec:	e8 68 ff ff ff       	call   802159 <_pipeisclosed>
  8021f1:	89 c2                	mov    %eax,%edx
}
  8021f3:	89 d0                	mov    %edx,%eax
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	57                   	push   %edi
  8021fb:	56                   	push   %esi
  8021fc:	53                   	push   %ebx
  8021fd:	83 ec 18             	sub    $0x18,%esp
  802200:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  802203:	57                   	push   %edi
  802204:	e8 bf f1 ff ff       	call   8013c8 <fd2data>
  802209:	89 c3                	mov    %eax,%ebx
	if (debug)
  80220b:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  80220e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802211:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802214:	be 00 00 00 00       	mov    $0x0,%esi
  802219:	3b 75 10             	cmp    0x10(%ebp),%esi
  80221c:	73 55                	jae    802273 <piperead+0x7c>
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
  80221e:	8b 03                	mov    (%ebx),%eax
  802220:	3b 43 04             	cmp    0x4(%ebx),%eax
  802223:	75 2c                	jne    802251 <piperead+0x5a>
  802225:	85 f6                	test   %esi,%esi
  802227:	74 04                	je     80222d <piperead+0x36>
  802229:	89 f0                	mov    %esi,%eax
  80222b:	eb 48                	jmp    802275 <piperead+0x7e>
  80222d:	83 ec 08             	sub    $0x8,%esp
  802230:	53                   	push   %ebx
  802231:	57                   	push   %edi
  802232:	e8 22 ff ff ff       	call   802159 <_pipeisclosed>
  802237:	83 c4 10             	add    $0x10,%esp
  80223a:	85 c0                	test   %eax,%eax
  80223c:	74 07                	je     802245 <piperead+0x4e>
  80223e:	b8 00 00 00 00       	mov    $0x0,%eax
  802243:	eb 30                	jmp    802275 <piperead+0x7e>
  802245:	e8 a9 e9 ff ff       	call   800bf3 <sys_yield>
  80224a:	8b 03                	mov    (%ebx),%eax
  80224c:	3b 43 04             	cmp    0x4(%ebx),%eax
  80224f:	74 d4                	je     802225 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802251:	8b 13                	mov    (%ebx),%edx
  802253:	89 d0                	mov    %edx,%eax
  802255:	85 d2                	test   %edx,%edx
  802257:	79 03                	jns    80225c <piperead+0x65>
  802259:	8d 42 1f             	lea    0x1f(%edx),%eax
  80225c:	83 e0 e0             	and    $0xffffffe0,%eax
  80225f:	29 c2                	sub    %eax,%edx
  802261:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  802265:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802268:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80226b:	ff 03                	incl   (%ebx)
  80226d:	46                   	inc    %esi
  80226e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802271:	72 ab                	jb     80221e <piperead+0x27>
	}
	return i;
  802273:	89 f0                	mov    %esi,%eax
}
  802275:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802278:	5b                   	pop    %ebx
  802279:	5e                   	pop    %esi
  80227a:	5f                   	pop    %edi
  80227b:	c9                   	leave  
  80227c:	c3                   	ret    

0080227d <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80227d:	55                   	push   %ebp
  80227e:	89 e5                	mov    %esp,%ebp
  802280:	57                   	push   %edi
  802281:	56                   	push   %esi
  802282:	53                   	push   %ebx
  802283:	83 ec 18             	sub    $0x18,%esp
  802286:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  802289:	57                   	push   %edi
  80228a:	e8 39 f1 ff ff       	call   8013c8 <fd2data>
  80228f:	89 c3                	mov    %eax,%ebx
	if (debug)
  802291:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802294:	8b 45 0c             	mov    0xc(%ebp),%eax
  802297:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80229a:	be 00 00 00 00       	mov    $0x0,%esi
  80229f:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022a2:	73 55                	jae    8022f9 <pipewrite+0x7c>
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
  8022a4:	8b 03                	mov    (%ebx),%eax
  8022a6:	83 c0 20             	add    $0x20,%eax
  8022a9:	39 43 04             	cmp    %eax,0x4(%ebx)
  8022ac:	72 27                	jb     8022d5 <pipewrite+0x58>
  8022ae:	83 ec 08             	sub    $0x8,%esp
  8022b1:	53                   	push   %ebx
  8022b2:	57                   	push   %edi
  8022b3:	e8 a1 fe ff ff       	call   802159 <_pipeisclosed>
  8022b8:	83 c4 10             	add    $0x10,%esp
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	74 07                	je     8022c6 <pipewrite+0x49>
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	eb 35                	jmp    8022fb <pipewrite+0x7e>
  8022c6:	e8 28 e9 ff ff       	call   800bf3 <sys_yield>
  8022cb:	8b 03                	mov    (%ebx),%eax
  8022cd:	83 c0 20             	add    $0x20,%eax
  8022d0:	39 43 04             	cmp    %eax,0x4(%ebx)
  8022d3:	73 d9                	jae    8022ae <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022d5:	8b 53 04             	mov    0x4(%ebx),%edx
  8022d8:	89 d0                	mov    %edx,%eax
  8022da:	85 d2                	test   %edx,%edx
  8022dc:	79 03                	jns    8022e1 <pipewrite+0x64>
  8022de:	8d 42 1f             	lea    0x1f(%edx),%eax
  8022e1:	83 e0 e0             	and    $0xffffffe0,%eax
  8022e4:	29 c2                	sub    %eax,%edx
  8022e6:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  8022e9:	8a 04 31             	mov    (%ecx,%esi,1),%al
  8022ec:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022f0:	ff 43 04             	incl   0x4(%ebx)
  8022f3:	46                   	inc    %esi
  8022f4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022f7:	72 ab                	jb     8022a4 <pipewrite+0x27>
	}
	
	return i;
  8022f9:	89 f0                	mov    %esi,%eax
}
  8022fb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8022fe:	5b                   	pop    %ebx
  8022ff:	5e                   	pop    %esi
  802300:	5f                   	pop    %edi
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	56                   	push   %esi
  802307:	53                   	push   %ebx
  802308:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80230b:	83 ec 0c             	sub    $0xc,%esp
  80230e:	ff 75 08             	pushl  0x8(%ebp)
  802311:	e8 b2 f0 ff ff       	call   8013c8 <fd2data>
  802316:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802318:	83 c4 08             	add    $0x8,%esp
  80231b:	68 13 2f 80 00       	push   $0x802f13
  802320:	53                   	push   %ebx
  802321:	e8 1a e5 ff ff       	call   800840 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802326:	8b 46 04             	mov    0x4(%esi),%eax
  802329:	2b 06                	sub    (%esi),%eax
  80232b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802331:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802338:	00 00 00 
	stat->st_dev = &devpipe;
  80233b:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  802342:	60 80 00 
	return 0;
}
  802345:	b8 00 00 00 00       	mov    $0x0,%eax
  80234a:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	53                   	push   %ebx
  802355:	83 ec 0c             	sub    $0xc,%esp
  802358:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80235b:	53                   	push   %ebx
  80235c:	6a 00                	push   $0x0
  80235e:	e8 34 e9 ff ff       	call   800c97 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802363:	89 1c 24             	mov    %ebx,(%esp)
  802366:	e8 5d f0 ff ff       	call   8013c8 <fd2data>
  80236b:	83 c4 08             	add    $0x8,%esp
  80236e:	50                   	push   %eax
  80236f:	6a 00                	push   $0x0
  802371:	e8 21 e9 ff ff       	call   800c97 <sys_page_unmap>
}
  802376:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802379:	c9                   	leave  
  80237a:	c3                   	ret    
	...

0080237c <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802388:	6a 01                	push   $0x1
  80238a:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  80238d:	50                   	push   %eax
  80238e:	e8 bd e7 ff ff       	call   800b50 <sys_cputs>
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <getchar>:

int
getchar(void)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80239b:	6a 01                	push   $0x1
  80239d:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8023a0:	50                   	push   %eax
  8023a1:	6a 00                	push   $0x0
  8023a3:	e8 35 f3 ff ff       	call   8016dd <read>
	if (r < 0)
  8023a8:	83 c4 10             	add    $0x10,%esp
		return r;
  8023ab:	89 c2                	mov    %eax,%edx
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	78 0d                	js     8023be <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  8023b1:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	7e 04                	jle    8023be <getchar+0x29>
	return c;
  8023ba:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  8023be:	89 d0                	mov    %edx,%eax
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <iscons>:


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
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023c8:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8023cb:	50                   	push   %eax
  8023cc:	ff 75 08             	pushl  0x8(%ebp)
  8023cf:	e8 76 f0 ff ff       	call   80144a <fd_lookup>
  8023d4:	83 c4 10             	add    $0x10,%esp
		return r;
  8023d7:	89 c2                	mov    %eax,%edx
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	78 11                	js     8023ee <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  8023dd:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8023e0:	8b 00                	mov    (%eax),%eax
  8023e2:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  8023e8:	0f 94 c0             	sete   %al
  8023eb:	0f b6 d0             	movzbl %al,%edx
}
  8023ee:	89 d0                	mov    %edx,%eax
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <opencons>:

int
opencons(void)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023f8:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8023fb:	50                   	push   %eax
  8023fc:	e8 ef ef ff ff       	call   8013f0 <fd_alloc>
  802401:	83 c4 10             	add    $0x10,%esp
		return r;
  802404:	89 c2                	mov    %eax,%edx
  802406:	85 c0                	test   %eax,%eax
  802408:	78 3c                	js     802446 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80240a:	83 ec 04             	sub    $0x4,%esp
  80240d:	68 07 04 00 00       	push   $0x407
  802412:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802415:	6a 00                	push   $0x0
  802417:	e8 f6 e7 ff ff       	call   800c12 <sys_page_alloc>
  80241c:	83 c4 10             	add    $0x10,%esp
		return r;
  80241f:	89 c2                	mov    %eax,%edx
  802421:	85 c0                	test   %eax,%eax
  802423:	78 21                	js     802446 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802425:	a1 60 60 80 00       	mov    0x806060,%eax
  80242a:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  80242d:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  80242f:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802432:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802439:	83 ec 0c             	sub    $0xc,%esp
  80243c:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80243f:	e8 9c ef ff ff       	call   8013e0 <fd2num>
  802444:	89 c2                	mov    %eax,%edx
}
  802446:	89 d0                	mov    %edx,%eax
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  802450:	b8 00 00 00 00       	mov    $0x0,%eax
  802455:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802459:	74 2a                	je     802485 <cons_read+0x3b>
  80245b:	eb 05                	jmp    802462 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80245d:	e8 91 e7 ff ff       	call   800bf3 <sys_yield>
  802462:	e8 0d e7 ff ff       	call   800b74 <sys_cgetc>
  802467:	89 c2                	mov    %eax,%edx
  802469:	85 c0                	test   %eax,%eax
  80246b:	74 f0                	je     80245d <cons_read+0x13>
	if (c < 0)
  80246d:	85 d2                	test   %edx,%edx
  80246f:	78 14                	js     802485 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
  802476:	83 fa 04             	cmp    $0x4,%edx
  802479:	74 0a                	je     802485 <cons_read+0x3b>
	*(char*)vbuf = c;
  80247b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247e:	88 10                	mov    %dl,(%eax)
	return 1;
  802480:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802485:	c9                   	leave  
  802486:	c3                   	ret    

00802487 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  802487:	55                   	push   %ebp
  802488:	89 e5                	mov    %esp,%ebp
  80248a:	57                   	push   %edi
  80248b:	56                   	push   %esi
  80248c:	53                   	push   %ebx
  80248d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  802493:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802496:	be 00 00 00 00       	mov    $0x0,%esi
  80249b:	39 fe                	cmp    %edi,%esi
  80249d:	73 3d                	jae    8024dc <cons_write+0x55>
		m = n - tot;
  80249f:	89 fb                	mov    %edi,%ebx
  8024a1:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8024a3:	83 fb 7f             	cmp    $0x7f,%ebx
  8024a6:	76 05                	jbe    8024ad <cons_write+0x26>
			m = sizeof(buf) - 1;
  8024a8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024ad:	83 ec 04             	sub    $0x4,%esp
  8024b0:	53                   	push   %ebx
  8024b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b4:	01 f0                	add    %esi,%eax
  8024b6:	50                   	push   %eax
  8024b7:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8024bd:	50                   	push   %eax
  8024be:	e8 f9 e4 ff ff       	call   8009bc <memmove>
		sys_cputs(buf, m);
  8024c3:	83 c4 08             	add    $0x8,%esp
  8024c6:	53                   	push   %ebx
  8024c7:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8024cd:	50                   	push   %eax
  8024ce:	e8 7d e6 ff ff       	call   800b50 <sys_cputs>
  8024d3:	83 c4 10             	add    $0x10,%esp
  8024d6:	01 de                	add    %ebx,%esi
  8024d8:	39 fe                	cmp    %edi,%esi
  8024da:	72 c3                	jb     80249f <cons_write+0x18>
	}
	return tot;
}
  8024dc:	89 f0                	mov    %esi,%eax
  8024de:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	c9                   	leave  
  8024e5:	c3                   	ret    

008024e6 <cons_close>:

int
cons_close(struct Fd *fd)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8024f6:	68 1f 2f 80 00       	push   $0x802f1f
  8024fb:	ff 75 0c             	pushl  0xc(%ebp)
  8024fe:	e8 3d e3 ff ff       	call   800840 <strcpy>
	return 0;
}
  802503:	b8 00 00 00 00       	mov    $0x0,%eax
  802508:	c9                   	leave  
  802509:	c3                   	ret    
	...

0080250c <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80250c:	55                   	push   %ebp
  80250d:	89 e5                	mov    %esp,%ebp
  80250f:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802512:	83 3d 88 60 80 00 00 	cmpl   $0x0,0x806088
  802519:	75 68                	jne    802583 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  80251b:	83 ec 04             	sub    $0x4,%esp
  80251e:	6a 07                	push   $0x7
  802520:	68 00 f0 bf ee       	push   $0xeebff000
  802525:	83 ec 04             	sub    $0x4,%esp
  802528:	e8 a7 e6 ff ff       	call   800bd4 <sys_getenvid>
  80252d:	89 04 24             	mov    %eax,(%esp)
  802530:	e8 dd e6 ff ff       	call   800c12 <sys_page_alloc>
  802535:	83 c4 10             	add    $0x10,%esp
  802538:	85 c0                	test   %eax,%eax
  80253a:	79 14                	jns    802550 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  80253c:	83 ec 04             	sub    $0x4,%esp
  80253f:	68 28 2f 80 00       	push   $0x802f28
  802544:	6a 21                	push   $0x21
  802546:	68 89 2f 80 00       	push   $0x802f89
  80254b:	e8 fc db ff ff       	call   80014c <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  802550:	83 ec 08             	sub    $0x8,%esp
  802553:	68 90 25 80 00       	push   $0x802590
  802558:	83 ec 04             	sub    $0x4,%esp
  80255b:	e8 74 e6 ff ff       	call   800bd4 <sys_getenvid>
  802560:	89 04 24             	mov    %eax,(%esp)
  802563:	e8 f5 e7 ff ff       	call   800d5d <sys_env_set_pgfault_upcall>
  802568:	83 c4 10             	add    $0x10,%esp
  80256b:	85 c0                	test   %eax,%eax
  80256d:	79 14                	jns    802583 <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	68 58 2f 80 00       	push   $0x802f58
  802577:	6a 24                	push   $0x24
  802579:	68 89 2f 80 00       	push   $0x802f89
  80257e:	e8 c9 db ff ff       	call   80014c <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	a3 88 60 80 00       	mov    %eax,0x806088
}
  80258b:	c9                   	leave  
  80258c:	c3                   	ret    
  80258d:	00 00                	add    %al,(%eax)
	...

00802590 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802590:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802591:	a1 88 60 80 00       	mov    0x806088,%eax
	call *%eax
  802596:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802598:	83 c4 04             	add    $0x4,%esp
	
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
  80259b:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  80259f:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  8025a3:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  8025a6:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  8025a9:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  8025ac:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  8025b0:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  8025b3:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  8025b7:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  8025b8:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  8025bb:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  8025bc:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  8025bd:	c3                   	ret    
	...

008025c0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8025c6:	89 c8                	mov    %ecx,%eax
  8025c8:	c1 e8 16             	shr    $0x16,%eax
  8025cb:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8025d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025d7:	a8 01                	test   $0x1,%al
  8025d9:	74 28                	je     802603 <pageref+0x43>
	pte = vpt[VPN(v)];
  8025db:	89 c8                	mov    %ecx,%eax
  8025dd:	c1 e8 0c             	shr    $0xc,%eax
  8025e0:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  8025e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ec:	a8 01                	test   $0x1,%al
  8025ee:	74 13                	je     802603 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  8025f0:	c1 e8 0c             	shr    $0xc,%eax
  8025f3:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8025f6:	c1 e0 02             	shl    $0x2,%eax
  8025f9:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802600:	0f b7 d0             	movzwl %ax,%edx
}
  802603:	89 d0                	mov    %edx,%eax
  802605:	c9                   	leave  
  802606:	c3                   	ret    
	...

00802608 <__udivdi3>:
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
  80260b:	57                   	push   %edi
  80260c:	56                   	push   %esi
  80260d:	83 ec 14             	sub    $0x14,%esp
  802610:	8b 55 14             	mov    0x14(%ebp),%edx
  802613:	8b 75 08             	mov    0x8(%ebp),%esi
  802616:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802619:	8b 45 10             	mov    0x10(%ebp),%eax
  80261c:	85 d2                	test   %edx,%edx
  80261e:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802621:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802624:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802627:	89 fe                	mov    %edi,%esi
  802629:	75 11                	jne    80263c <__udivdi3+0x34>
  80262b:	39 f8                	cmp    %edi,%eax
  80262d:	76 4d                	jbe    80267c <__udivdi3+0x74>
  80262f:	89 fa                	mov    %edi,%edx
  802631:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802634:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802637:	89 c7                	mov    %eax,%edi
  802639:	eb 09                	jmp    802644 <__udivdi3+0x3c>
  80263b:	90                   	nop    
  80263c:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  80263f:	76 17                	jbe    802658 <__udivdi3+0x50>
  802641:	31 ff                	xor    %edi,%edi
  802643:	90                   	nop    
  802644:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  80264b:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  80264e:	83 c4 14             	add    $0x14,%esp
  802651:	5e                   	pop    %esi
  802652:	89 f8                	mov    %edi,%eax
  802654:	5f                   	pop    %edi
  802655:	c9                   	leave  
  802656:	c3                   	ret    
  802657:	90                   	nop    
  802658:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  80265c:	89 c7                	mov    %eax,%edi
  80265e:	83 f7 1f             	xor    $0x1f,%edi
  802661:	75 4d                	jne    8026b0 <__udivdi3+0xa8>
  802663:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802666:	77 0a                	ja     802672 <__udivdi3+0x6a>
  802668:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80266b:	31 ff                	xor    %edi,%edi
  80266d:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802670:	72 d2                	jb     802644 <__udivdi3+0x3c>
  802672:	bf 01 00 00 00       	mov    $0x1,%edi
  802677:	eb cb                	jmp    802644 <__udivdi3+0x3c>
  802679:	8d 76 00             	lea    0x0(%esi),%esi
  80267c:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80267f:	85 c0                	test   %eax,%eax
  802681:	75 0e                	jne    802691 <__udivdi3+0x89>
  802683:	b8 01 00 00 00       	mov    $0x1,%eax
  802688:	31 c9                	xor    %ecx,%ecx
  80268a:	31 d2                	xor    %edx,%edx
  80268c:	f7 f1                	div    %ecx
  80268e:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802691:	89 f0                	mov    %esi,%eax
  802693:	31 d2                	xor    %edx,%edx
  802695:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802698:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80269b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80269e:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8026a1:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8026a4:	83 c4 14             	add    $0x14,%esp
  8026a7:	89 c7                	mov    %eax,%edi
  8026a9:	5e                   	pop    %esi
  8026aa:	89 f8                	mov    %edi,%eax
  8026ac:	5f                   	pop    %edi
  8026ad:	c9                   	leave  
  8026ae:	c3                   	ret    
  8026af:	90                   	nop    
  8026b0:	b8 20 00 00 00       	mov    $0x20,%eax
  8026b5:	29 f8                	sub    %edi,%eax
  8026b7:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  8026ba:	89 f9                	mov    %edi,%ecx
  8026bc:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8026bf:	d3 e2                	shl    %cl,%edx
  8026c1:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8026c4:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8026c7:	d3 e8                	shr    %cl,%eax
  8026c9:	09 c2                	or     %eax,%edx
  8026cb:	89 f9                	mov    %edi,%ecx
  8026cd:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8026d0:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8026d3:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8026d6:	89 f2                	mov    %esi,%edx
  8026d8:	d3 ea                	shr    %cl,%edx
  8026da:	89 f9                	mov    %edi,%ecx
  8026dc:	d3 e6                	shl    %cl,%esi
  8026de:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8026e1:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8026e4:	d3 e8                	shr    %cl,%eax
  8026e6:	09 c6                	or     %eax,%esi
  8026e8:	89 f9                	mov    %edi,%ecx
  8026ea:	89 f0                	mov    %esi,%eax
  8026ec:	f7 75 f4             	divl   0xfffffff4(%ebp)
  8026ef:	89 d6                	mov    %edx,%esi
  8026f1:	89 c7                	mov    %eax,%edi
  8026f3:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8026f6:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8026f9:	f7 e7                	mul    %edi
  8026fb:	39 f2                	cmp    %esi,%edx
  8026fd:	77 0f                	ja     80270e <__udivdi3+0x106>
  8026ff:	0f 85 3f ff ff ff    	jne    802644 <__udivdi3+0x3c>
  802705:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802708:	0f 86 36 ff ff ff    	jbe    802644 <__udivdi3+0x3c>
  80270e:	4f                   	dec    %edi
  80270f:	e9 30 ff ff ff       	jmp    802644 <__udivdi3+0x3c>

00802714 <__umoddi3>:
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
  802717:	57                   	push   %edi
  802718:	56                   	push   %esi
  802719:	83 ec 30             	sub    $0x30,%esp
  80271c:	8b 55 14             	mov    0x14(%ebp),%edx
  80271f:	8b 45 10             	mov    0x10(%ebp),%eax
  802722:	89 d7                	mov    %edx,%edi
  802724:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  802727:	89 c6                	mov    %eax,%esi
  802729:	8b 55 0c             	mov    0xc(%ebp),%edx
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	85 ff                	test   %edi,%edi
  802731:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802738:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80273f:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  802742:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802745:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802748:	75 3e                	jne    802788 <__umoddi3+0x74>
  80274a:	39 d6                	cmp    %edx,%esi
  80274c:	0f 86 a2 00 00 00    	jbe    8027f4 <__umoddi3+0xe0>
  802752:	f7 f6                	div    %esi
  802754:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802757:	85 c9                	test   %ecx,%ecx
  802759:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  80275c:	74 1b                	je     802779 <__umoddi3+0x65>
  80275e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802761:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802764:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80276b:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80276e:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802771:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802774:	89 10                	mov    %edx,(%eax)
  802776:	89 48 04             	mov    %ecx,0x4(%eax)
  802779:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80277c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80277f:	83 c4 30             	add    $0x30,%esp
  802782:	5e                   	pop    %esi
  802783:	5f                   	pop    %edi
  802784:	c9                   	leave  
  802785:	c3                   	ret    
  802786:	89 f6                	mov    %esi,%esi
  802788:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  80278b:	76 1f                	jbe    8027ac <__umoddi3+0x98>
  80278d:	8b 55 08             	mov    0x8(%ebp),%edx
  802790:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802793:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802796:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802799:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80279c:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80279f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  8027a2:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8027a5:	83 c4 30             	add    $0x30,%esp
  8027a8:	5e                   	pop    %esi
  8027a9:	5f                   	pop    %edi
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    
  8027ac:	0f bd c7             	bsr    %edi,%eax
  8027af:	83 f0 1f             	xor    $0x1f,%eax
  8027b2:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  8027b5:	75 61                	jne    802818 <__umoddi3+0x104>
  8027b7:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  8027ba:	77 05                	ja     8027c1 <__umoddi3+0xad>
  8027bc:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  8027bf:	72 10                	jb     8027d1 <__umoddi3+0xbd>
  8027c1:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8027c4:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8027c7:	29 f0                	sub    %esi,%eax
  8027c9:	19 fa                	sbb    %edi,%edx
  8027cb:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8027ce:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8027d1:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8027d4:	85 d2                	test   %edx,%edx
  8027d6:	74 a1                	je     802779 <__umoddi3+0x65>
  8027d8:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8027db:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8027de:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8027e1:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  8027e4:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8027e7:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8027ea:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8027ed:	89 01                	mov    %eax,(%ecx)
  8027ef:	89 51 04             	mov    %edx,0x4(%ecx)
  8027f2:	eb 85                	jmp    802779 <__umoddi3+0x65>
  8027f4:	85 f6                	test   %esi,%esi
  8027f6:	75 0b                	jne    802803 <__umoddi3+0xef>
  8027f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8027fd:	31 d2                	xor    %edx,%edx
  8027ff:	f7 f6                	div    %esi
  802801:	89 c6                	mov    %eax,%esi
  802803:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802806:	89 fa                	mov    %edi,%edx
  802808:	f7 f6                	div    %esi
  80280a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80280d:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802810:	f7 f6                	div    %esi
  802812:	e9 3d ff ff ff       	jmp    802754 <__umoddi3+0x40>
  802817:	90                   	nop    
  802818:	b8 20 00 00 00       	mov    $0x20,%eax
  80281d:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802820:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  802823:	89 fa                	mov    %edi,%edx
  802825:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802828:	d3 e2                	shl    %cl,%edx
  80282a:	89 f0                	mov    %esi,%eax
  80282c:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80282f:	d3 e8                	shr    %cl,%eax
  802831:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802834:	d3 e6                	shl    %cl,%esi
  802836:	89 d7                	mov    %edx,%edi
  802838:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80283b:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80283e:	09 c7                	or     %eax,%edi
  802840:	d3 ea                	shr    %cl,%edx
  802842:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802845:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802848:	d3 e0                	shl    %cl,%eax
  80284a:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80284d:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802850:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802853:	d3 e8                	shr    %cl,%eax
  802855:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802858:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80285b:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80285e:	f7 f7                	div    %edi
  802860:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802863:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802866:	f7 e6                	mul    %esi
  802868:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  80286b:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  80286e:	77 0a                	ja     80287a <__umoddi3+0x166>
  802870:	75 12                	jne    802884 <__umoddi3+0x170>
  802872:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802875:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802878:	76 0a                	jbe    802884 <__umoddi3+0x170>
  80287a:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  80287d:	29 f1                	sub    %esi,%ecx
  80287f:	19 fa                	sbb    %edi,%edx
  802881:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802884:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802887:	85 c0                	test   %eax,%eax
  802889:	0f 84 ea fe ff ff    	je     802779 <__umoddi3+0x65>
  80288f:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802892:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802895:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802898:	19 d1                	sbb    %edx,%ecx
  80289a:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  80289d:	89 ca                	mov    %ecx,%edx
  80289f:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8028a2:	d3 e2                	shl    %cl,%edx
  8028a4:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8028a7:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8028aa:	d3 e8                	shr    %cl,%eax
  8028ac:	09 c2                	or     %eax,%edx
  8028ae:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8028b1:	d3 e8                	shr    %cl,%eax
  8028b3:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8028b6:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8028b9:	e9 ad fe ff ff       	jmp    80276b <__umoddi3+0x57>
