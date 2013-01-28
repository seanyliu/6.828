
obj/user/cat:     file format elf32-i386

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
  80002c:	e8 0f 01 00 00       	call   800140 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <cat>:
char buf[8192];

void
cat(int f, char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 0c             	sub    $0xc,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800043:	eb 2d                	jmp    800072 <cat+0x3e>
		if ((r = write(1, buf, n)) != n)
  800045:	83 ec 04             	sub    $0x4,%esp
  800048:	53                   	push   %ebx
  800049:	68 80 60 80 00       	push   $0x806080
  80004e:	6a 01                	push   $0x1
  800050:	e8 53 13 00 00       	call   8013a8 <write>
  800055:	83 c4 10             	add    $0x10,%esp
  800058:	39 d8                	cmp    %ebx,%eax
  80005a:	74 16                	je     800072 <cat+0x3e>
			panic("write error copying %s: %e", s, r);
  80005c:	83 ec 0c             	sub    $0xc,%esp
  80005f:	50                   	push   %eax
  800060:	57                   	push   %edi
  800061:	68 c0 24 80 00       	push   $0x8024c0
  800066:	6a 0d                	push   $0xd
  800068:	68 db 24 80 00       	push   $0x8024db
  80006d:	e8 2a 01 00 00       	call   80019c <_panic>
  800072:	83 ec 04             	sub    $0x4,%esp
  800075:	68 00 20 00 00       	push   $0x2000
  80007a:	68 80 60 80 00       	push   $0x806080
  80007f:	56                   	push   %esi
  800080:	e8 4c 12 00 00       	call   8012d1 <read>
  800085:	89 c3                	mov    %eax,%ebx
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	85 c0                	test   %eax,%eax
  80008c:	7f b7                	jg     800045 <cat+0x11>
	if (n < 0)
  80008e:	85 c0                	test   %eax,%eax
  800090:	79 16                	jns    8000a8 <cat+0x74>
		panic("error reading %s: %e", s, n);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	50                   	push   %eax
  800096:	57                   	push   %edi
  800097:	68 e6 24 80 00       	push   $0x8024e6
  80009c:	6a 0f                	push   $0xf
  80009e:	68 db 24 80 00       	push   $0x8024db
  8000a3:	e8 f4 00 00 00       	call   80019c <_panic>
}
  8000a8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8000ab:	5b                   	pop    %ebx
  8000ac:	5e                   	pop    %esi
  8000ad:	5f                   	pop    %edi
  8000ae:	c9                   	leave  
  8000af:	c3                   	ret    

008000b0 <umain>:

void
umain(int argc, char **argv)
{
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	57                   	push   %edi
  8000b4:	56                   	push   %esi
  8000b5:	53                   	push   %ebx
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	argv0 = "cat";
  8000bc:	c7 05 84 80 80 00 fb 	movl   $0x8024fb,0x808084
  8000c3:	24 80 00 
	if (argc == 1)
  8000c6:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ca:	75 14                	jne    8000e0 <umain+0x30>
		cat(0, "<stdin>");
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	68 ff 24 80 00       	push   $0x8024ff
  8000d4:	6a 00                	push   $0x0
  8000d6:	e8 59 ff ff ff       	call   800034 <cat>
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	eb 55                	jmp    800135 <umain+0x85>
	else
		for (i = 1; i < argc; i++) {
  8000e0:	be 01 00 00 00       	mov    $0x1,%esi
  8000e5:	3b 75 08             	cmp    0x8(%ebp),%esi
  8000e8:	7d 4b                	jge    800135 <umain+0x85>
			f = open(argv[i], O_RDONLY);
  8000ea:	83 ec 08             	sub    $0x8,%esp
  8000ed:	6a 00                	push   $0x0
  8000ef:	ff 34 b7             	pushl  (%edi,%esi,4)
  8000f2:	e8 75 14 00 00       	call   80156c <open>
  8000f7:	89 c3                	mov    %eax,%ebx
			if (f < 0)
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	85 c0                	test   %eax,%eax
  8000fe:	79 18                	jns    800118 <umain+0x68>
				panic("can't open %s: %e", argv[i], f);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	50                   	push   %eax
  800104:	ff 34 b7             	pushl  (%edi,%esi,4)
  800107:	68 07 25 80 00       	push   $0x802507
  80010c:	6a 1e                	push   $0x1e
  80010e:	68 db 24 80 00       	push   $0x8024db
  800113:	e8 84 00 00 00       	call   80019c <_panic>
			else {
				cat(f, argv[i]);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	ff 34 b7             	pushl  (%edi,%esi,4)
  80011e:	50                   	push   %eax
  80011f:	e8 10 ff ff ff       	call   800034 <cat>
				close(f);
  800124:	89 1c 24             	mov    %ebx,(%esp)
  800127:	e8 32 10 00 00       	call   80115e <close>
  80012c:	83 c4 10             	add    $0x10,%esp
  80012f:	46                   	inc    %esi
  800130:	3b 75 08             	cmp    0x8(%ebp),%esi
  800133:	7c b5                	jl     8000ea <umain+0x3a>
			}
		}
}
  800135:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800138:	5b                   	pop    %ebx
  800139:	5e                   	pop    %esi
  80013a:	5f                   	pop    %edi
  80013b:	c9                   	leave  
  80013c:	c3                   	ret    
  80013d:	00 00                	add    %al,(%eax)
	...

00800140 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800140:	55                   	push   %ebp
  800141:	89 e5                	mov    %esp,%ebp
  800143:	56                   	push   %esi
  800144:	53                   	push   %ebx
  800145:	8b 75 08             	mov    0x8(%ebp),%esi
  800148:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  80014b:	e8 d4 0a 00 00       	call   800c24 <sys_getenvid>
  800150:	25 ff 03 00 00       	and    $0x3ff,%eax
  800155:	c1 e0 07             	shl    $0x7,%eax
  800158:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015d:	a3 80 80 80 00       	mov    %eax,0x808080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800162:	85 f6                	test   %esi,%esi
  800164:	7e 07                	jle    80016d <libmain+0x2d>
		binaryname = argv[0];
  800166:	8b 03                	mov    (%ebx),%eax
  800168:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  80016d:	83 ec 08             	sub    $0x8,%esp
  800170:	53                   	push   %ebx
  800171:	56                   	push   %esi
  800172:	e8 39 ff ff ff       	call   8000b0 <umain>

	// exit gracefully
	exit();
  800177:	e8 08 00 00 00       	call   800184 <exit>
}
  80017c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80017f:	5b                   	pop    %ebx
  800180:	5e                   	pop    %esi
  800181:	c9                   	leave  
  800182:	c3                   	ret    
	...

00800184 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80018a:	e8 fd 0f 00 00       	call   80118c <close_all>
	sys_env_destroy(0);
  80018f:	83 ec 0c             	sub    $0xc,%esp
  800192:	6a 00                	push   $0x0
  800194:	e8 4a 0a 00 00       	call   800be3 <sys_env_destroy>
}
  800199:	c9                   	leave  
  80019a:	c3                   	ret    
	...

0080019c <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	53                   	push   %ebx
  8001a0:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  8001a3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  8001a6:	83 3d 84 80 80 00 00 	cmpl   $0x0,0x808084
  8001ad:	74 16                	je     8001c5 <_panic+0x29>
		cprintf("%s: ", argv0);
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	ff 35 84 80 80 00    	pushl  0x808084
  8001b8:	68 30 25 80 00       	push   $0x802530
  8001bd:	e8 ca 00 00 00       	call   80028c <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001c5:	ff 75 0c             	pushl  0xc(%ebp)
  8001c8:	ff 75 08             	pushl  0x8(%ebp)
  8001cb:	ff 35 00 60 80 00    	pushl  0x806000
  8001d1:	68 35 25 80 00       	push   $0x802535
  8001d6:	e8 b1 00 00 00       	call   80028c <cprintf>
	vcprintf(fmt, ap);
  8001db:	83 c4 08             	add    $0x8,%esp
  8001de:	53                   	push   %ebx
  8001df:	ff 75 10             	pushl  0x10(%ebp)
  8001e2:	e8 54 00 00 00       	call   80023b <vcprintf>
	cprintf("\n");
  8001e7:	c7 04 24 29 2a 80 00 	movl   $0x802a29,(%esp)
  8001ee:	e8 99 00 00 00       	call   80028c <cprintf>

	// Cause a breakpoint exception
	while (1)
  8001f3:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  8001f6:	cc                   	int3   
  8001f7:	eb fd                	jmp    8001f6 <_panic+0x5a>
  8001f9:	00 00                	add    %al,(%eax)
	...

008001fc <putch>:


static void
putch(int ch, struct printbuf *b)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	53                   	push   %ebx
  800200:	83 ec 04             	sub    $0x4,%esp
  800203:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800206:	8b 03                	mov    (%ebx),%eax
  800208:	8b 55 08             	mov    0x8(%ebp),%edx
  80020b:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  80020f:	40                   	inc    %eax
  800210:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800212:	3d ff 00 00 00       	cmp    $0xff,%eax
  800217:	75 1a                	jne    800233 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	68 ff 00 00 00       	push   $0xff
  800221:	8d 43 08             	lea    0x8(%ebx),%eax
  800224:	50                   	push   %eax
  800225:	e8 76 09 00 00       	call   800ba0 <sys_cputs>
		b->idx = 0;
  80022a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800230:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800233:	ff 43 04             	incl   0x4(%ebx)
}
  800236:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800239:	c9                   	leave  
  80023a:	c3                   	ret    

0080023b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800244:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  80024b:	00 00 00 
	b.cnt = 0;
  80024e:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800255:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800258:	ff 75 0c             	pushl  0xc(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800264:	50                   	push   %eax
  800265:	68 fc 01 80 00       	push   $0x8001fc
  80026a:	e8 4f 01 00 00       	call   8003be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026f:	83 c4 08             	add    $0x8,%esp
  800272:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  800278:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  80027e:	50                   	push   %eax
  80027f:	e8 1c 09 00 00       	call   800ba0 <sys_cputs>

	return b.cnt;
  800284:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  80028a:	c9                   	leave  
  80028b:	c3                   	ret    

0080028c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800292:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800295:	50                   	push   %eax
  800296:	ff 75 08             	pushl  0x8(%ebp)
  800299:	e8 9d ff ff ff       	call   80023b <vcprintf>
	va_end(ap);

	return cnt;
}
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

008002a0 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 0c             	sub    $0xc,%esp
  8002a9:	8b 75 10             	mov    0x10(%ebp),%esi
  8002ac:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002af:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8002b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ba:	39 fa                	cmp    %edi,%edx
  8002bc:	77 39                	ja     8002f7 <printnum+0x57>
  8002be:	72 04                	jb     8002c4 <printnum+0x24>
  8002c0:	39 f0                	cmp    %esi,%eax
  8002c2:	77 33                	ja     8002f7 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c4:	83 ec 04             	sub    $0x4,%esp
  8002c7:	ff 75 20             	pushl  0x20(%ebp)
  8002ca:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  8002cd:	50                   	push   %eax
  8002ce:	ff 75 18             	pushl  0x18(%ebp)
  8002d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8002d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d9:	52                   	push   %edx
  8002da:	50                   	push   %eax
  8002db:	57                   	push   %edi
  8002dc:	56                   	push   %esi
  8002dd:	e8 22 1f 00 00       	call   802204 <__udivdi3>
  8002e2:	83 c4 10             	add    $0x10,%esp
  8002e5:	52                   	push   %edx
  8002e6:	50                   	push   %eax
  8002e7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ea:	ff 75 08             	pushl  0x8(%ebp)
  8002ed:	e8 ae ff ff ff       	call   8002a0 <printnum>
  8002f2:	83 c4 20             	add    $0x20,%esp
  8002f5:	eb 19                	jmp    800310 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002f7:	4b                   	dec    %ebx
  8002f8:	85 db                	test   %ebx,%ebx
  8002fa:	7e 14                	jle    800310 <printnum+0x70>
  8002fc:	83 ec 08             	sub    $0x8,%esp
  8002ff:	ff 75 0c             	pushl  0xc(%ebp)
  800302:	ff 75 20             	pushl  0x20(%ebp)
  800305:	ff 55 08             	call   *0x8(%ebp)
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	4b                   	dec    %ebx
  80030c:	85 db                	test   %ebx,%ebx
  80030e:	7f ec                	jg     8002fc <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	ff 75 0c             	pushl  0xc(%ebp)
  800316:	8b 45 18             	mov    0x18(%ebp),%eax
  800319:	ba 00 00 00 00       	mov    $0x0,%edx
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	52                   	push   %edx
  800322:	50                   	push   %eax
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	e8 e6 1f 00 00       	call   802310 <__umoddi3>
  80032a:	83 c4 14             	add    $0x14,%esp
  80032d:	0f be 80 4b 26 80 00 	movsbl 0x80264b(%eax),%eax
  800334:	50                   	push   %eax
  800335:	ff 55 08             	call   *0x8(%ebp)
}
  800338:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80033b:	5b                   	pop    %ebx
  80033c:	5e                   	pop    %esi
  80033d:	5f                   	pop    %edi
  80033e:	c9                   	leave  
  80033f:	c3                   	ret    

00800340 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800346:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800349:	83 f8 01             	cmp    $0x1,%eax
  80034c:	7e 0f                	jle    80035d <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  80034e:	8b 01                	mov    (%ecx),%eax
  800350:	83 c0 08             	add    $0x8,%eax
  800353:	89 01                	mov    %eax,(%ecx)
  800355:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800358:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80035b:	eb 24                	jmp    800381 <getuint+0x41>
	else if (lflag)
  80035d:	85 c0                	test   %eax,%eax
  80035f:	74 11                	je     800372 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800361:	8b 01                	mov    (%ecx),%eax
  800363:	83 c0 04             	add    $0x4,%eax
  800366:	89 01                	mov    %eax,(%ecx)
  800368:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80036b:	ba 00 00 00 00       	mov    $0x0,%edx
  800370:	eb 0f                	jmp    800381 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  800372:	8b 01                	mov    (%ecx),%eax
  800374:	83 c0 04             	add    $0x4,%eax
  800377:	89 01                	mov    %eax,(%ecx)
  800379:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80037c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800381:	c9                   	leave  
  800382:	c3                   	ret    

00800383 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	8b 55 08             	mov    0x8(%ebp),%edx
  800389:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80038c:	83 f8 01             	cmp    $0x1,%eax
  80038f:	7e 0f                	jle    8003a0 <getint+0x1d>
		return va_arg(*ap, long long);
  800391:	8b 02                	mov    (%edx),%eax
  800393:	83 c0 08             	add    $0x8,%eax
  800396:	89 02                	mov    %eax,(%edx)
  800398:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80039b:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80039e:	eb 1c                	jmp    8003bc <getint+0x39>
	else if (lflag)
  8003a0:	85 c0                	test   %eax,%eax
  8003a2:	74 0d                	je     8003b1 <getint+0x2e>
		return va_arg(*ap, long);
  8003a4:	8b 02                	mov    (%edx),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 02                	mov    %eax,(%edx)
  8003ab:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003ae:	99                   	cltd   
  8003af:	eb 0b                	jmp    8003bc <getint+0x39>
	else
		return va_arg(*ap, int);
  8003b1:	8b 02                	mov    (%edx),%eax
  8003b3:	83 c0 04             	add    $0x4,%eax
  8003b6:	89 02                	mov    %eax,(%edx)
  8003b8:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003bb:	99                   	cltd   
}
  8003bc:	c9                   	leave  
  8003bd:	c3                   	ret    

008003be <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	57                   	push   %edi
  8003c2:	56                   	push   %esi
  8003c3:	53                   	push   %ebx
  8003c4:	83 ec 1c             	sub    $0x1c,%esp
  8003c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  8003ca:	0f b6 13             	movzbl (%ebx),%edx
  8003cd:	43                   	inc    %ebx
  8003ce:	83 fa 25             	cmp    $0x25,%edx
  8003d1:	74 1e                	je     8003f1 <vprintfmt+0x33>
  8003d3:	85 d2                	test   %edx,%edx
  8003d5:	0f 84 d7 02 00 00    	je     8006b2 <vprintfmt+0x2f4>
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 0c             	pushl  0xc(%ebp)
  8003e1:	52                   	push   %edx
  8003e2:	ff 55 08             	call   *0x8(%ebp)
  8003e5:	83 c4 10             	add    $0x10,%esp
  8003e8:	0f b6 13             	movzbl (%ebx),%edx
  8003eb:	43                   	inc    %ebx
  8003ec:	83 fa 25             	cmp    $0x25,%edx
  8003ef:	75 e2                	jne    8003d3 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  8003f1:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  8003f5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  8003fc:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  800401:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  800406:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040d:	0f b6 13             	movzbl (%ebx),%edx
  800410:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  800413:	43                   	inc    %ebx
  800414:	83 f8 55             	cmp    $0x55,%eax
  800417:	0f 87 70 02 00 00    	ja     80068d <vprintfmt+0x2cf>
  80041d:	ff 24 85 dc 26 80 00 	jmp    *0x8026dc(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800424:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  800428:	eb e3                	jmp    80040d <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80042a:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  80042e:	eb dd                	jmp    80040d <vprintfmt+0x4f>

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
  800430:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800435:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  800438:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  80043c:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80043f:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  800442:	83 f8 09             	cmp    $0x9,%eax
  800445:	77 27                	ja     80046e <vprintfmt+0xb0>
  800447:	43                   	inc    %ebx
  800448:	eb eb                	jmp    800435 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80044a:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80044e:	8b 45 14             	mov    0x14(%ebp),%eax
  800451:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800454:	eb 18                	jmp    80046e <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  800456:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80045a:	79 b1                	jns    80040d <vprintfmt+0x4f>
				width = 0;
  80045c:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800463:	eb a8                	jmp    80040d <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800465:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  80046c:	eb 9f                	jmp    80040d <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  80046e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800472:	79 99                	jns    80040d <vprintfmt+0x4f>
				width = precision, precision = -1;
  800474:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  800477:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  80047c:	eb 8f                	jmp    80040d <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80047e:	41                   	inc    %ecx
			goto reswitch;
  80047f:	eb 8c                	jmp    80040d <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	ff 75 0c             	pushl  0xc(%ebp)
  800487:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80048b:	8b 45 14             	mov    0x14(%ebp),%eax
  80048e:	ff 70 fc             	pushl  0xfffffffc(%eax)
  800491:	ff 55 08             	call   *0x8(%ebp)
			break;
  800494:	83 c4 10             	add    $0x10,%esp
  800497:	e9 2e ff ff ff       	jmp    8003ca <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80049c:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a3:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  8004a6:	85 c0                	test   %eax,%eax
  8004a8:	79 02                	jns    8004ac <vprintfmt+0xee>
				err = -err;
  8004aa:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004ac:	83 f8 0e             	cmp    $0xe,%eax
  8004af:	7f 0b                	jg     8004bc <vprintfmt+0xfe>
  8004b1:	8b 3c 85 a0 26 80 00 	mov    0x8026a0(,%eax,4),%edi
  8004b8:	85 ff                	test   %edi,%edi
  8004ba:	75 19                	jne    8004d5 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8004bc:	50                   	push   %eax
  8004bd:	68 5c 26 80 00       	push   $0x80265c
  8004c2:	ff 75 0c             	pushl  0xc(%ebp)
  8004c5:	ff 75 08             	pushl  0x8(%ebp)
  8004c8:	e8 ed 01 00 00       	call   8006ba <printfmt>
  8004cd:	83 c4 10             	add    $0x10,%esp
  8004d0:	e9 f5 fe ff ff       	jmp    8003ca <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  8004d5:	57                   	push   %edi
  8004d6:	68 e1 29 80 00       	push   $0x8029e1
  8004db:	ff 75 0c             	pushl  0xc(%ebp)
  8004de:	ff 75 08             	pushl  0x8(%ebp)
  8004e1:	e8 d4 01 00 00       	call   8006ba <printfmt>
  8004e6:	83 c4 10             	add    $0x10,%esp
			break;
  8004e9:	e9 dc fe ff ff       	jmp    8003ca <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004ee:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f5:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  8004f8:	85 ff                	test   %edi,%edi
  8004fa:	75 05                	jne    800501 <vprintfmt+0x143>
				p = "(null)";
  8004fc:	bf 65 26 80 00       	mov    $0x802665,%edi
			if (width > 0 && padc != '-')
  800501:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800505:	7e 3b                	jle    800542 <vprintfmt+0x184>
  800507:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  80050b:	74 35                	je     800542 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  80050d:	83 ec 08             	sub    $0x8,%esp
  800510:	56                   	push   %esi
  800511:	57                   	push   %edi
  800512:	e8 56 03 00 00       	call   80086d <strnlen>
  800517:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  80051a:	83 c4 10             	add    $0x10,%esp
  80051d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800521:	7e 1f                	jle    800542 <vprintfmt+0x184>
  800523:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800527:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  800533:	ff 55 08             	call   *0x8(%ebp)
  800536:	83 c4 10             	add    $0x10,%esp
  800539:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80053c:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800540:	7f e8                	jg     80052a <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800542:	0f be 17             	movsbl (%edi),%edx
  800545:	47                   	inc    %edi
  800546:	85 d2                	test   %edx,%edx
  800548:	74 44                	je     80058e <vprintfmt+0x1d0>
  80054a:	85 f6                	test   %esi,%esi
  80054c:	78 03                	js     800551 <vprintfmt+0x193>
  80054e:	4e                   	dec    %esi
  80054f:	78 3d                	js     80058e <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800551:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800555:	74 18                	je     80056f <vprintfmt+0x1b1>
  800557:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80055a:	83 f8 5e             	cmp    $0x5e,%eax
  80055d:	76 10                	jbe    80056f <vprintfmt+0x1b1>
					putch('?', putdat);
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	ff 75 0c             	pushl  0xc(%ebp)
  800565:	6a 3f                	push   $0x3f
  800567:	ff 55 08             	call   *0x8(%ebp)
  80056a:	83 c4 10             	add    $0x10,%esp
  80056d:	eb 0d                	jmp    80057c <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  80056f:	83 ec 08             	sub    $0x8,%esp
  800572:	ff 75 0c             	pushl  0xc(%ebp)
  800575:	52                   	push   %edx
  800576:	ff 55 08             	call   *0x8(%ebp)
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80057f:	0f be 17             	movsbl (%edi),%edx
  800582:	47                   	inc    %edi
  800583:	85 d2                	test   %edx,%edx
  800585:	74 07                	je     80058e <vprintfmt+0x1d0>
  800587:	85 f6                	test   %esi,%esi
  800589:	78 c6                	js     800551 <vprintfmt+0x193>
  80058b:	4e                   	dec    %esi
  80058c:	79 c3                	jns    800551 <vprintfmt+0x193>
			for (; width > 0; width--)
  80058e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800592:	0f 8e 32 fe ff ff    	jle    8003ca <vprintfmt+0xc>
				putch(' ', putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	6a 20                	push   $0x20
  8005a0:	ff 55 08             	call   *0x8(%ebp)
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8005a9:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005ad:	7f e9                	jg     800598 <vprintfmt+0x1da>
			break;
  8005af:	e9 16 fe ff ff       	jmp    8003ca <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005b4:	51                   	push   %ecx
  8005b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8005b8:	50                   	push   %eax
  8005b9:	e8 c5 fd ff ff       	call   800383 <getint>
  8005be:	89 c6                	mov    %eax,%esi
  8005c0:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8005c2:	83 c4 08             	add    $0x8,%esp
  8005c5:	85 d2                	test   %edx,%edx
  8005c7:	79 15                	jns    8005de <vprintfmt+0x220>
				putch('-', putdat);
  8005c9:	83 ec 08             	sub    $0x8,%esp
  8005cc:	ff 75 0c             	pushl  0xc(%ebp)
  8005cf:	6a 2d                	push   $0x2d
  8005d1:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005d4:	f7 de                	neg    %esi
  8005d6:	83 d7 00             	adc    $0x0,%edi
  8005d9:	f7 df                	neg    %edi
  8005db:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005de:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8005e3:	eb 75                	jmp    80065a <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005e5:	51                   	push   %ecx
  8005e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e9:	50                   	push   %eax
  8005ea:	e8 51 fd ff ff       	call   800340 <getuint>
  8005ef:	89 c6                	mov    %eax,%esi
  8005f1:	89 d7                	mov    %edx,%edi
			base = 10;
  8005f3:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8005f8:	83 c4 08             	add    $0x8,%esp
  8005fb:	eb 5d                	jmp    80065a <vprintfmt+0x29c>

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
  8005fd:	51                   	push   %ecx
  8005fe:	8d 45 14             	lea    0x14(%ebp),%eax
  800601:	50                   	push   %eax
  800602:	e8 39 fd ff ff       	call   800340 <getuint>
  800607:	89 c6                	mov    %eax,%esi
  800609:	89 d7                	mov    %edx,%edi
			base = 8;
  80060b:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  800610:	83 c4 08             	add    $0x8,%esp
  800613:	eb 45                	jmp    80065a <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800615:	83 ec 08             	sub    $0x8,%esp
  800618:	ff 75 0c             	pushl  0xc(%ebp)
  80061b:	6a 30                	push   $0x30
  80061d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800620:	83 c4 08             	add    $0x8,%esp
  800623:	ff 75 0c             	pushl  0xc(%ebp)
  800626:	6a 78                	push   $0x78
  800628:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80062b:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800635:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80063a:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	eb 16                	jmp    80065a <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800644:	51                   	push   %ecx
  800645:	8d 45 14             	lea    0x14(%ebp),%eax
  800648:	50                   	push   %eax
  800649:	e8 f2 fc ff ff       	call   800340 <getuint>
  80064e:	89 c6                	mov    %eax,%esi
  800650:	89 d7                	mov    %edx,%edi
			base = 16;
  800652:	ba 10 00 00 00       	mov    $0x10,%edx
  800657:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800661:	50                   	push   %eax
  800662:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800665:	52                   	push   %edx
  800666:	57                   	push   %edi
  800667:	56                   	push   %esi
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	ff 75 08             	pushl  0x8(%ebp)
  80066e:	e8 2d fc ff ff       	call   8002a0 <printnum>
			break;
  800673:	83 c4 20             	add    $0x20,%esp
  800676:	e9 4f fd ff ff       	jmp    8003ca <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80067b:	83 ec 08             	sub    $0x8,%esp
  80067e:	ff 75 0c             	pushl  0xc(%ebp)
  800681:	52                   	push   %edx
  800682:	ff 55 08             	call   *0x8(%ebp)
			break;
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	e9 3d fd ff ff       	jmp    8003ca <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80068d:	83 ec 08             	sub    $0x8,%esp
  800690:	ff 75 0c             	pushl  0xc(%ebp)
  800693:	6a 25                	push   $0x25
  800695:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800698:	4b                   	dec    %ebx
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8006a0:	0f 84 24 fd ff ff    	je     8003ca <vprintfmt+0xc>
  8006a6:	4b                   	dec    %ebx
  8006a7:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8006ab:	75 f9                	jne    8006a6 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8006ad:	e9 18 fd ff ff       	jmp    8003ca <vprintfmt+0xc>
		}
	}
}
  8006b2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8006b5:	5b                   	pop    %ebx
  8006b6:	5e                   	pop    %esi
  8006b7:	5f                   	pop    %edi
  8006b8:	c9                   	leave  
  8006b9:	c3                   	ret    

008006ba <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006ba:	55                   	push   %ebp
  8006bb:	89 e5                	mov    %esp,%ebp
  8006bd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8006c0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006c3:	50                   	push   %eax
  8006c4:	ff 75 10             	pushl  0x10(%ebp)
  8006c7:	ff 75 0c             	pushl  0xc(%ebp)
  8006ca:	ff 75 08             	pushl  0x8(%ebp)
  8006cd:	e8 ec fc ff ff       	call   8003be <vprintfmt>
	va_end(ap);
}
  8006d2:	c9                   	leave  
  8006d3:	c3                   	ret    

008006d4 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  8006da:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  8006dd:	8b 0a                	mov    (%edx),%ecx
  8006df:	3b 4a 04             	cmp    0x4(%edx),%ecx
  8006e2:	73 07                	jae    8006eb <sprintputch+0x17>
		*b->buf++ = ch;
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	88 01                	mov    %al,(%ecx)
  8006e9:	ff 02                	incl   (%edx)
}
  8006eb:	c9                   	leave  
  8006ec:	c3                   	ret    

008006ed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
  8006f0:	83 ec 18             	sub    $0x18,%esp
  8006f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8006f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006f9:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  8006fc:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800700:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  800703:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  80070a:	85 d2                	test   %edx,%edx
  80070c:	74 04                	je     800712 <vsnprintf+0x25>
  80070e:	85 c9                	test   %ecx,%ecx
  800710:	7f 07                	jg     800719 <vsnprintf+0x2c>
		return -E_INVAL;
  800712:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800717:	eb 1d                	jmp    800736 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800719:	ff 75 14             	pushl  0x14(%ebp)
  80071c:	ff 75 10             	pushl  0x10(%ebp)
  80071f:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  800722:	50                   	push   %eax
  800723:	68 d4 06 80 00       	push   $0x8006d4
  800728:	e8 91 fc ff ff       	call   8003be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80072d:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800730:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800733:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  800736:	c9                   	leave  
  800737:	c3                   	ret    

00800738 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800738:	55                   	push   %ebp
  800739:	89 e5                	mov    %esp,%ebp
  80073b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80073e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800741:	50                   	push   %eax
  800742:	ff 75 10             	pushl  0x10(%ebp)
  800745:	ff 75 0c             	pushl  0xc(%ebp)
  800748:	ff 75 08             	pushl  0x8(%ebp)
  80074b:	e8 9d ff ff ff       	call   8006ed <vsnprintf>
	va_end(ap);

	return rc;
}
  800750:	c9                   	leave  
  800751:	c3                   	ret    
	...

00800754 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	56                   	push   %esi
  800758:	53                   	push   %ebx
  800759:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  80075c:	83 ec 0c             	sub    $0xc,%esp
  80075f:	56                   	push   %esi
  800760:	e8 ef 00 00 00       	call   800854 <strlen>
  char letter;
  int hexnum = 0;
  800765:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80076a:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	89 c2                	mov    %eax,%edx
  800774:	4a                   	dec    %edx
  800775:	0f 88 d0 00 00 00    	js     80084b <strtoint+0xf7>
    letter = string[cidx];
  80077b:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  80077e:	85 d2                	test   %edx,%edx
  800780:	75 12                	jne    800794 <strtoint+0x40>
      if (letter != '0') {
  800782:	3c 30                	cmp    $0x30,%al
  800784:	0f 84 ba 00 00 00    	je     800844 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80078a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80078f:	e9 b9 00 00 00       	jmp    80084d <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800794:	83 fa 01             	cmp    $0x1,%edx
  800797:	75 12                	jne    8007ab <strtoint+0x57>
      if (letter != 'x') {
  800799:	3c 78                	cmp    $0x78,%al
  80079b:	0f 84 a3 00 00 00    	je     800844 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8007a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8007a6:	e9 a2 00 00 00       	jmp    80084d <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8007ab:	0f be c0             	movsbl %al,%eax
  8007ae:	83 e8 30             	sub    $0x30,%eax
  8007b1:	83 f8 36             	cmp    $0x36,%eax
  8007b4:	0f 87 80 00 00 00    	ja     80083a <strtoint+0xe6>
  8007ba:	ff 24 85 34 28 80 00 	jmp    *0x802834(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8007c1:	01 cb                	add    %ecx,%ebx
          break;
  8007c3:	eb 7c                	jmp    800841 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8007c5:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8007c8:	eb 77                	jmp    800841 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8007ca:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8007cd:	01 c3                	add    %eax,%ebx
          break;
  8007cf:	eb 70                	jmp    800841 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  8007d1:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  8007d4:	eb 6b                	jmp    800841 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  8007d6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8007d9:	01 c3                	add    %eax,%ebx
          break;
  8007db:	eb 64                	jmp    800841 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  8007dd:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8007e0:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8007e3:	eb 5c                	jmp    800841 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  8007e5:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8007ec:	29 c8                	sub    %ecx,%eax
  8007ee:	01 c3                	add    %eax,%ebx
          break;
  8007f0:	eb 4f                	jmp    800841 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8007f2:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8007f5:	eb 4a                	jmp    800841 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8007f7:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8007fa:	01 c3                	add    %eax,%ebx
          break;
  8007fc:	eb 43                	jmp    800841 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8007fe:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800801:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800804:	eb 3b                	jmp    800841 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800806:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800809:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  80080c:	01 c3                	add    %eax,%ebx
          break;
  80080e:	eb 31                	jmp    800841 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800810:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800813:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800816:	eb 29                	jmp    800841 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800818:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80081b:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  80081e:	01 c3                	add    %eax,%ebx
          break;
  800820:	eb 1f                	jmp    800841 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800822:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800829:	29 c8                	sub    %ecx,%eax
  80082b:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  80082e:	eb 11                	jmp    800841 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800830:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800833:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800836:	01 c3                	add    %eax,%ebx
          break;
  800838:	eb 07                	jmp    800841 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  80083a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80083f:	eb 0c                	jmp    80084d <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800841:	c1 e1 04             	shl    $0x4,%ecx
  800844:	4a                   	dec    %edx
  800845:	0f 89 30 ff ff ff    	jns    80077b <strtoint+0x27>
    }
  }

  return hexnum;
  80084b:	89 d8                	mov    %ebx,%eax
}
  80084d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800850:	5b                   	pop    %ebx
  800851:	5e                   	pop    %esi
  800852:	c9                   	leave  
  800853:	c3                   	ret    

00800854 <strlen>:





int
strlen(const char *s)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80085a:	b8 00 00 00 00       	mov    $0x0,%eax
  80085f:	80 3a 00             	cmpb   $0x0,(%edx)
  800862:	74 07                	je     80086b <strlen+0x17>
		n++;
  800864:	40                   	inc    %eax
  800865:	42                   	inc    %edx
  800866:	80 3a 00             	cmpb   $0x0,(%edx)
  800869:	75 f9                	jne    800864 <strlen+0x10>
	return n;
}
  80086b:	c9                   	leave  
  80086c:	c3                   	ret    

0080086d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800873:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	85 d2                	test   %edx,%edx
  80087d:	74 0f                	je     80088e <strnlen+0x21>
  80087f:	80 39 00             	cmpb   $0x0,(%ecx)
  800882:	74 0a                	je     80088e <strnlen+0x21>
		n++;
  800884:	40                   	inc    %eax
  800885:	41                   	inc    %ecx
  800886:	4a                   	dec    %edx
  800887:	74 05                	je     80088e <strnlen+0x21>
  800889:	80 39 00             	cmpb   $0x0,(%ecx)
  80088c:	75 f6                	jne    800884 <strnlen+0x17>
	return n;
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	53                   	push   %ebx
  800894:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800897:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  80089a:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  80089c:	8a 02                	mov    (%edx),%al
  80089e:	42                   	inc    %edx
  80089f:	88 01                	mov    %al,(%ecx)
  8008a1:	41                   	inc    %ecx
  8008a2:	84 c0                	test   %al,%al
  8008a4:	75 f6                	jne    80089c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a6:	89 d8                	mov    %ebx,%eax
  8008a8:	5b                   	pop    %ebx
  8008a9:	c9                   	leave  
  8008aa:	c3                   	ret    

008008ab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	57                   	push   %edi
  8008af:	56                   	push   %esi
  8008b0:	53                   	push   %ebx
  8008b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008b7:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  8008ba:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  8008bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c1:	39 f3                	cmp    %esi,%ebx
  8008c3:	73 10                	jae    8008d5 <strncpy+0x2a>
		*dst++ = *src;
  8008c5:	8a 02                	mov    (%edx),%al
  8008c7:	88 01                	mov    %al,(%ecx)
  8008c9:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ca:	80 3a 01             	cmpb   $0x1,(%edx)
  8008cd:	83 da ff             	sbb    $0xffffffff,%edx
  8008d0:	43                   	inc    %ebx
  8008d1:	39 f3                	cmp    %esi,%ebx
  8008d3:	72 f0                	jb     8008c5 <strncpy+0x1a>
	}
	return ret;
}
  8008d5:	89 f8                	mov    %edi,%eax
  8008d7:	5b                   	pop    %ebx
  8008d8:	5e                   	pop    %esi
  8008d9:	5f                   	pop    %edi
  8008da:	c9                   	leave  
  8008db:	c3                   	ret    

008008dc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	56                   	push   %esi
  8008e0:	53                   	push   %ebx
  8008e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e7:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  8008ea:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  8008ec:	85 d2                	test   %edx,%edx
  8008ee:	74 19                	je     800909 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f0:	4a                   	dec    %edx
  8008f1:	74 13                	je     800906 <strlcpy+0x2a>
  8008f3:	80 39 00             	cmpb   $0x0,(%ecx)
  8008f6:	74 0e                	je     800906 <strlcpy+0x2a>
  8008f8:	8a 01                	mov    (%ecx),%al
  8008fa:	41                   	inc    %ecx
  8008fb:	88 03                	mov    %al,(%ebx)
  8008fd:	43                   	inc    %ebx
  8008fe:	4a                   	dec    %edx
  8008ff:	74 05                	je     800906 <strlcpy+0x2a>
  800901:	80 39 00             	cmpb   $0x0,(%ecx)
  800904:	75 f2                	jne    8008f8 <strlcpy+0x1c>
		*dst = '\0';
  800906:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800909:	89 d8                	mov    %ebx,%eax
  80090b:	29 f0                	sub    %esi,%eax
}
  80090d:	5b                   	pop    %ebx
  80090e:	5e                   	pop    %esi
  80090f:	c9                   	leave  
  800910:	c3                   	ret    

00800911 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	8b 55 08             	mov    0x8(%ebp),%edx
  800917:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  80091a:	80 3a 00             	cmpb   $0x0,(%edx)
  80091d:	74 13                	je     800932 <strcmp+0x21>
  80091f:	8a 02                	mov    (%edx),%al
  800921:	3a 01                	cmp    (%ecx),%al
  800923:	75 0d                	jne    800932 <strcmp+0x21>
  800925:	42                   	inc    %edx
  800926:	41                   	inc    %ecx
  800927:	80 3a 00             	cmpb   $0x0,(%edx)
  80092a:	74 06                	je     800932 <strcmp+0x21>
  80092c:	8a 02                	mov    (%edx),%al
  80092e:	3a 01                	cmp    (%ecx),%al
  800930:	74 f3                	je     800925 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800932:	0f b6 02             	movzbl (%edx),%eax
  800935:	0f b6 11             	movzbl (%ecx),%edx
  800938:	29 d0                	sub    %edx,%eax
}
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	53                   	push   %ebx
  800940:	8b 55 08             	mov    0x8(%ebp),%edx
  800943:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800946:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800949:	85 c9                	test   %ecx,%ecx
  80094b:	74 1f                	je     80096c <strncmp+0x30>
  80094d:	80 3a 00             	cmpb   $0x0,(%edx)
  800950:	74 16                	je     800968 <strncmp+0x2c>
  800952:	8a 02                	mov    (%edx),%al
  800954:	3a 03                	cmp    (%ebx),%al
  800956:	75 10                	jne    800968 <strncmp+0x2c>
  800958:	42                   	inc    %edx
  800959:	43                   	inc    %ebx
  80095a:	49                   	dec    %ecx
  80095b:	74 0f                	je     80096c <strncmp+0x30>
  80095d:	80 3a 00             	cmpb   $0x0,(%edx)
  800960:	74 06                	je     800968 <strncmp+0x2c>
  800962:	8a 02                	mov    (%edx),%al
  800964:	3a 03                	cmp    (%ebx),%al
  800966:	74 f0                	je     800958 <strncmp+0x1c>
	if (n == 0)
  800968:	85 c9                	test   %ecx,%ecx
  80096a:	75 07                	jne    800973 <strncmp+0x37>
		return 0;
  80096c:	b8 00 00 00 00       	mov    $0x0,%eax
  800971:	eb 0a                	jmp    80097d <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800973:	0f b6 12             	movzbl (%edx),%edx
  800976:	0f b6 03             	movzbl (%ebx),%eax
  800979:	29 c2                	sub    %eax,%edx
  80097b:	89 d0                	mov    %edx,%eax
}
  80097d:	5b                   	pop    %ebx
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800989:	80 38 00             	cmpb   $0x0,(%eax)
  80098c:	74 0a                	je     800998 <strchr+0x18>
		if (*s == c)
  80098e:	38 10                	cmp    %dl,(%eax)
  800990:	74 0b                	je     80099d <strchr+0x1d>
  800992:	40                   	inc    %eax
  800993:	80 38 00             	cmpb   $0x0,(%eax)
  800996:	75 f6                	jne    80098e <strchr+0xe>
			return (char *) s;
	return 0;
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099d:	c9                   	leave  
  80099e:	c3                   	ret    

0080099f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8009a8:	80 38 00             	cmpb   $0x0,(%eax)
  8009ab:	74 0a                	je     8009b7 <strfind+0x18>
		if (*s == c)
  8009ad:	38 10                	cmp    %dl,(%eax)
  8009af:	74 06                	je     8009b7 <strfind+0x18>
  8009b1:	40                   	inc    %eax
  8009b2:	80 38 00             	cmpb   $0x0,(%eax)
  8009b5:	75 f6                	jne    8009ad <strfind+0xe>
			break;
	return (char *) s;
}
  8009b7:	c9                   	leave  
  8009b8:	c3                   	ret    

008009b9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	57                   	push   %edi
  8009bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  8009c3:	89 f8                	mov    %edi,%eax
  8009c5:	85 c9                	test   %ecx,%ecx
  8009c7:	74 40                	je     800a09 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009cf:	75 30                	jne    800a01 <memset+0x48>
  8009d1:	f6 c1 03             	test   $0x3,%cl
  8009d4:	75 2b                	jne    800a01 <memset+0x48>
		c &= 0xFF;
  8009d6:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e0:	c1 e0 18             	shl    $0x18,%eax
  8009e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e6:	c1 e2 10             	shl    $0x10,%edx
  8009e9:	09 d0                	or     %edx,%eax
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ee:	c1 e2 08             	shl    $0x8,%edx
  8009f1:	09 d0                	or     %edx,%eax
  8009f3:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  8009f6:	c1 e9 02             	shr    $0x2,%ecx
  8009f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fc:	fc                   	cld    
  8009fd:	f3 ab                	repz stos %eax,%es:(%edi)
  8009ff:	eb 06                	jmp    800a07 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a04:	fc                   	cld    
  800a05:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800a07:	89 f8                	mov    %edi,%eax
}
  800a09:	5f                   	pop    %edi
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	57                   	push   %edi
  800a10:	56                   	push   %esi
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800a17:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a1a:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a1c:	39 c6                	cmp    %eax,%esi
  800a1e:	73 33                	jae    800a53 <memmove+0x47>
  800a20:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a23:	39 c2                	cmp    %eax,%edx
  800a25:	76 2c                	jbe    800a53 <memmove+0x47>
		s += n;
  800a27:	89 d6                	mov    %edx,%esi
		d += n;
  800a29:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2c:	f6 c2 03             	test   $0x3,%dl
  800a2f:	75 1b                	jne    800a4c <memmove+0x40>
  800a31:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a37:	75 13                	jne    800a4c <memmove+0x40>
  800a39:	f6 c1 03             	test   $0x3,%cl
  800a3c:	75 0e                	jne    800a4c <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800a3e:	83 ef 04             	sub    $0x4,%edi
  800a41:	83 ee 04             	sub    $0x4,%esi
  800a44:	c1 e9 02             	shr    $0x2,%ecx
  800a47:	fd                   	std    
  800a48:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800a4a:	eb 27                	jmp    800a73 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a4c:	4f                   	dec    %edi
  800a4d:	4e                   	dec    %esi
  800a4e:	fd                   	std    
  800a4f:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800a51:	eb 20                	jmp    800a73 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a53:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a59:	75 15                	jne    800a70 <memmove+0x64>
  800a5b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a61:	75 0d                	jne    800a70 <memmove+0x64>
  800a63:	f6 c1 03             	test   $0x3,%cl
  800a66:	75 08                	jne    800a70 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800a68:	c1 e9 02             	shr    $0x2,%ecx
  800a6b:	fc                   	cld    
  800a6c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800a6e:	eb 03                	jmp    800a73 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a70:	fc                   	cld    
  800a71:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a73:	5e                   	pop    %esi
  800a74:	5f                   	pop    %edi
  800a75:	c9                   	leave  
  800a76:	c3                   	ret    

00800a77 <memcpy>:

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
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a7a:	ff 75 10             	pushl  0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 84 ff ff ff       	call   800a0c <memmove>
}
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800a8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800a91:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a94:	8b 55 10             	mov    0x10(%ebp),%edx
  800a97:	4a                   	dec    %edx
  800a98:	83 fa ff             	cmp    $0xffffffff,%edx
  800a9b:	74 1a                	je     800ab7 <memcmp+0x2d>
  800a9d:	8a 01                	mov    (%ecx),%al
  800a9f:	3a 03                	cmp    (%ebx),%al
  800aa1:	74 0c                	je     800aaf <memcmp+0x25>
  800aa3:	0f b6 d0             	movzbl %al,%edx
  800aa6:	0f b6 03             	movzbl (%ebx),%eax
  800aa9:	29 c2                	sub    %eax,%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	eb 0d                	jmp    800abc <memcmp+0x32>
  800aaf:	41                   	inc    %ecx
  800ab0:	43                   	inc    %ebx
  800ab1:	4a                   	dec    %edx
  800ab2:	83 fa ff             	cmp    $0xffffffff,%edx
  800ab5:	75 e6                	jne    800a9d <memcmp+0x13>
	}

	return 0;
  800ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abc:	5b                   	pop    %ebx
  800abd:	c9                   	leave  
  800abe:	c3                   	ret    

00800abf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800acd:	39 d0                	cmp    %edx,%eax
  800acf:	73 09                	jae    800ada <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad1:	38 08                	cmp    %cl,(%eax)
  800ad3:	74 05                	je     800ada <memfind+0x1b>
  800ad5:	40                   	inc    %eax
  800ad6:	39 d0                	cmp    %edx,%eax
  800ad8:	72 f7                	jb     800ad1 <memfind+0x12>
			break;
	return (void *) s;
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	57                   	push   %edi
  800ae0:	56                   	push   %esi
  800ae1:	53                   	push   %ebx
  800ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800aeb:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800af0:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800af5:	80 3a 20             	cmpb   $0x20,(%edx)
  800af8:	74 05                	je     800aff <strtol+0x23>
  800afa:	80 3a 09             	cmpb   $0x9,(%edx)
  800afd:	75 0b                	jne    800b0a <strtol+0x2e>
  800aff:	42                   	inc    %edx
  800b00:	80 3a 20             	cmpb   $0x20,(%edx)
  800b03:	74 fa                	je     800aff <strtol+0x23>
  800b05:	80 3a 09             	cmpb   $0x9,(%edx)
  800b08:	74 f5                	je     800aff <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800b0a:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800b0d:	75 03                	jne    800b12 <strtol+0x36>
		s++;
  800b0f:	42                   	inc    %edx
  800b10:	eb 0b                	jmp    800b1d <strtol+0x41>
	else if (*s == '-')
  800b12:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800b15:	75 06                	jne    800b1d <strtol+0x41>
		s++, neg = 1;
  800b17:	42                   	inc    %edx
  800b18:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b1d:	85 c9                	test   %ecx,%ecx
  800b1f:	74 05                	je     800b26 <strtol+0x4a>
  800b21:	83 f9 10             	cmp    $0x10,%ecx
  800b24:	75 15                	jne    800b3b <strtol+0x5f>
  800b26:	80 3a 30             	cmpb   $0x30,(%edx)
  800b29:	75 10                	jne    800b3b <strtol+0x5f>
  800b2b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b2f:	75 0a                	jne    800b3b <strtol+0x5f>
		s += 2, base = 16;
  800b31:	83 c2 02             	add    $0x2,%edx
  800b34:	b9 10 00 00 00       	mov    $0x10,%ecx
  800b39:	eb 14                	jmp    800b4f <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800b3b:	85 c9                	test   %ecx,%ecx
  800b3d:	75 10                	jne    800b4f <strtol+0x73>
  800b3f:	80 3a 30             	cmpb   $0x30,(%edx)
  800b42:	75 05                	jne    800b49 <strtol+0x6d>
		s++, base = 8;
  800b44:	42                   	inc    %edx
  800b45:	b1 08                	mov    $0x8,%cl
  800b47:	eb 06                	jmp    800b4f <strtol+0x73>
	else if (base == 0)
  800b49:	85 c9                	test   %ecx,%ecx
  800b4b:	75 02                	jne    800b4f <strtol+0x73>
		base = 10;
  800b4d:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b4f:	8a 02                	mov    (%edx),%al
  800b51:	83 e8 30             	sub    $0x30,%eax
  800b54:	3c 09                	cmp    $0x9,%al
  800b56:	77 08                	ja     800b60 <strtol+0x84>
			dig = *s - '0';
  800b58:	0f be 02             	movsbl (%edx),%eax
  800b5b:	83 e8 30             	sub    $0x30,%eax
  800b5e:	eb 20                	jmp    800b80 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800b60:	8a 02                	mov    (%edx),%al
  800b62:	83 e8 61             	sub    $0x61,%eax
  800b65:	3c 19                	cmp    $0x19,%al
  800b67:	77 08                	ja     800b71 <strtol+0x95>
			dig = *s - 'a' + 10;
  800b69:	0f be 02             	movsbl (%edx),%eax
  800b6c:	83 e8 57             	sub    $0x57,%eax
  800b6f:	eb 0f                	jmp    800b80 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800b71:	8a 02                	mov    (%edx),%al
  800b73:	83 e8 41             	sub    $0x41,%eax
  800b76:	3c 19                	cmp    $0x19,%al
  800b78:	77 12                	ja     800b8c <strtol+0xb0>
			dig = *s - 'A' + 10;
  800b7a:	0f be 02             	movsbl (%edx),%eax
  800b7d:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800b80:	39 c8                	cmp    %ecx,%eax
  800b82:	7d 08                	jge    800b8c <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800b84:	42                   	inc    %edx
  800b85:	0f af d9             	imul   %ecx,%ebx
  800b88:	01 c3                	add    %eax,%ebx
  800b8a:	eb c3                	jmp    800b4f <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b8c:	85 f6                	test   %esi,%esi
  800b8e:	74 02                	je     800b92 <strtol+0xb6>
		*endptr = (char *) s;
  800b90:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b92:	89 d8                	mov    %ebx,%eax
  800b94:	85 ff                	test   %edi,%edi
  800b96:	74 02                	je     800b9a <strtol+0xbe>
  800b98:	f7 d8                	neg    %eax
}
  800b9a:	5b                   	pop    %ebx
  800b9b:	5e                   	pop    %esi
  800b9c:	5f                   	pop    %edi
  800b9d:	c9                   	leave  
  800b9e:	c3                   	ret    
	...

00800ba0 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	57                   	push   %edi
  800ba4:	56                   	push   %esi
  800ba5:	53                   	push   %ebx
  800ba6:	83 ec 04             	sub    $0x4,%esp
  800ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800baf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bb4:	89 f8                	mov    %edi,%eax
  800bb6:	89 fb                	mov    %edi,%ebx
  800bb8:	89 fe                	mov    %edi,%esi
  800bba:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bbc:	83 c4 04             	add    $0x4,%esp
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	c9                   	leave  
  800bc3:	c3                   	ret    

00800bc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
  800bca:	b8 01 00 00 00       	mov    $0x1,%eax
  800bcf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd4:	89 fa                	mov    %edi,%edx
  800bd6:	89 f9                	mov    %edi,%ecx
  800bd8:	89 fb                	mov    %edi,%ebx
  800bda:	89 fe                	mov    %edi,%esi
  800bdc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	83 ec 0c             	sub    $0xc,%esp
  800bec:	8b 55 08             	mov    0x8(%ebp),%edx
  800bef:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf4:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf9:	89 f9                	mov    %edi,%ecx
  800bfb:	89 fb                	mov    %edi,%ebx
  800bfd:	89 fe                	mov    %edi,%esi
  800bff:	cd 30                	int    $0x30
  800c01:	85 c0                	test   %eax,%eax
  800c03:	7e 17                	jle    800c1c <sys_env_destroy+0x39>
  800c05:	83 ec 0c             	sub    $0xc,%esp
  800c08:	50                   	push   %eax
  800c09:	6a 03                	push   $0x3
  800c0b:	68 10 29 80 00       	push   $0x802910
  800c10:	6a 23                	push   $0x23
  800c12:	68 2d 29 80 00       	push   $0x80292d
  800c17:	e8 80 f5 ff ff       	call   80019c <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c1c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
  800c2a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c34:	89 fa                	mov    %edi,%edx
  800c36:	89 f9                	mov    %edi,%ecx
  800c38:	89 fb                	mov    %edi,%ebx
  800c3a:	89 fe                	mov    %edi,%esi
  800c3c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <sys_yield>:

void
sys_yield(void)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c4e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c53:	89 fa                	mov    %edi,%edx
  800c55:	89 f9                	mov    %edi,%ecx
  800c57:	89 fb                	mov    %edi,%ebx
  800c59:	89 fe                	mov    %edi,%esi
  800c5b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c5d:	5b                   	pop    %ebx
  800c5e:	5e                   	pop    %esi
  800c5f:	5f                   	pop    %edi
  800c60:	c9                   	leave  
  800c61:	c3                   	ret    

00800c62 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
  800c68:	83 ec 0c             	sub    $0xc,%esp
  800c6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c74:	b8 04 00 00 00       	mov    $0x4,%eax
  800c79:	bf 00 00 00 00       	mov    $0x0,%edi
  800c7e:	89 fe                	mov    %edi,%esi
  800c80:	cd 30                	int    $0x30
  800c82:	85 c0                	test   %eax,%eax
  800c84:	7e 17                	jle    800c9d <sys_page_alloc+0x3b>
  800c86:	83 ec 0c             	sub    $0xc,%esp
  800c89:	50                   	push   %eax
  800c8a:	6a 04                	push   $0x4
  800c8c:	68 10 29 80 00       	push   $0x802910
  800c91:	6a 23                	push   $0x23
  800c93:	68 2d 29 80 00       	push   $0x80292d
  800c98:	e8 ff f4 ff ff       	call   80019c <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c9d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	c9                   	leave  
  800ca4:	c3                   	ret    

00800ca5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cba:	8b 75 18             	mov    0x18(%ebp),%esi
  800cbd:	b8 05 00 00 00       	mov    $0x5,%eax
  800cc2:	cd 30                	int    $0x30
  800cc4:	85 c0                	test   %eax,%eax
  800cc6:	7e 17                	jle    800cdf <sys_page_map+0x3a>
  800cc8:	83 ec 0c             	sub    $0xc,%esp
  800ccb:	50                   	push   %eax
  800ccc:	6a 05                	push   $0x5
  800cce:	68 10 29 80 00       	push   $0x802910
  800cd3:	6a 23                	push   $0x23
  800cd5:	68 2d 29 80 00       	push   $0x80292d
  800cda:	e8 bd f4 ff ff       	call   80019c <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cdf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	c9                   	leave  
  800ce6:	c3                   	ret    

00800ce7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
  800ced:	83 ec 0c             	sub    $0xc,%esp
  800cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf6:	b8 06 00 00 00       	mov    $0x6,%eax
  800cfb:	bf 00 00 00 00       	mov    $0x0,%edi
  800d00:	89 fb                	mov    %edi,%ebx
  800d02:	89 fe                	mov    %edi,%esi
  800d04:	cd 30                	int    $0x30
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7e 17                	jle    800d21 <sys_page_unmap+0x3a>
  800d0a:	83 ec 0c             	sub    $0xc,%esp
  800d0d:	50                   	push   %eax
  800d0e:	6a 06                	push   $0x6
  800d10:	68 10 29 80 00       	push   $0x802910
  800d15:	6a 23                	push   $0x23
  800d17:	68 2d 29 80 00       	push   $0x80292d
  800d1c:	e8 7b f4 ff ff       	call   80019c <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d21:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	8b 55 08             	mov    0x8(%ebp),%edx
  800d35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d38:	b8 08 00 00 00       	mov    $0x8,%eax
  800d3d:	bf 00 00 00 00       	mov    $0x0,%edi
  800d42:	89 fb                	mov    %edi,%ebx
  800d44:	89 fe                	mov    %edi,%esi
  800d46:	cd 30                	int    $0x30
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	7e 17                	jle    800d63 <sys_env_set_status+0x3a>
  800d4c:	83 ec 0c             	sub    $0xc,%esp
  800d4f:	50                   	push   %eax
  800d50:	6a 08                	push   $0x8
  800d52:	68 10 29 80 00       	push   $0x802910
  800d57:	6a 23                	push   $0x23
  800d59:	68 2d 29 80 00       	push   $0x80292d
  800d5e:	e8 39 f4 ff ff       	call   80019c <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d63:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5f                   	pop    %edi
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	57                   	push   %edi
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	83 ec 0c             	sub    $0xc,%esp
  800d74:	8b 55 08             	mov    0x8(%ebp),%edx
  800d77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d7f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d84:	89 fb                	mov    %edi,%ebx
  800d86:	89 fe                	mov    %edi,%esi
  800d88:	cd 30                	int    $0x30
  800d8a:	85 c0                	test   %eax,%eax
  800d8c:	7e 17                	jle    800da5 <sys_env_set_trapframe+0x3a>
  800d8e:	83 ec 0c             	sub    $0xc,%esp
  800d91:	50                   	push   %eax
  800d92:	6a 09                	push   $0x9
  800d94:	68 10 29 80 00       	push   $0x802910
  800d99:	6a 23                	push   $0x23
  800d9b:	68 2d 29 80 00       	push   $0x80292d
  800da0:	e8 f7 f3 ff ff       	call   80019c <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800da5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	c9                   	leave  
  800dac:	c3                   	ret    

00800dad <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 0c             	sub    $0xc,%esp
  800db6:	8b 55 08             	mov    0x8(%ebp),%edx
  800db9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc1:	bf 00 00 00 00       	mov    $0x0,%edi
  800dc6:	89 fb                	mov    %edi,%ebx
  800dc8:	89 fe                	mov    %edi,%esi
  800dca:	cd 30                	int    $0x30
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7e 17                	jle    800de7 <sys_env_set_pgfault_upcall+0x3a>
  800dd0:	83 ec 0c             	sub    $0xc,%esp
  800dd3:	50                   	push   %eax
  800dd4:	6a 0a                	push   $0xa
  800dd6:	68 10 29 80 00       	push   $0x802910
  800ddb:	6a 23                	push   $0x23
  800ddd:	68 2d 29 80 00       	push   $0x80292d
  800de2:	e8 b5 f3 ff ff       	call   80019c <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800de7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800dea:	5b                   	pop    %ebx
  800deb:	5e                   	pop    %esi
  800dec:	5f                   	pop    %edi
  800ded:	c9                   	leave  
  800dee:	c3                   	ret    

00800def <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800def:	55                   	push   %ebp
  800df0:	89 e5                	mov    %esp,%ebp
  800df2:	57                   	push   %edi
  800df3:	56                   	push   %esi
  800df4:	53                   	push   %ebx
  800df5:	8b 55 08             	mov    0x8(%ebp),%edx
  800df8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e06:	be 00 00 00 00       	mov    $0x0,%esi
  800e0b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e0d:	5b                   	pop    %ebx
  800e0e:	5e                   	pop    %esi
  800e0f:	5f                   	pop    %edi
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	57                   	push   %edi
  800e16:	56                   	push   %esi
  800e17:	53                   	push   %ebx
  800e18:	83 ec 0c             	sub    $0xc,%esp
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e23:	bf 00 00 00 00       	mov    $0x0,%edi
  800e28:	89 f9                	mov    %edi,%ecx
  800e2a:	89 fb                	mov    %edi,%ebx
  800e2c:	89 fe                	mov    %edi,%esi
  800e2e:	cd 30                	int    $0x30
  800e30:	85 c0                	test   %eax,%eax
  800e32:	7e 17                	jle    800e4b <sys_ipc_recv+0x39>
  800e34:	83 ec 0c             	sub    $0xc,%esp
  800e37:	50                   	push   %eax
  800e38:	6a 0d                	push   $0xd
  800e3a:	68 10 29 80 00       	push   $0x802910
  800e3f:	6a 23                	push   $0x23
  800e41:	68 2d 29 80 00       	push   $0x80292d
  800e46:	e8 51 f3 ff ff       	call   80019c <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e4b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	c9                   	leave  
  800e52:	c3                   	ret    

00800e53 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	57                   	push   %edi
  800e57:	56                   	push   %esi
  800e58:	53                   	push   %ebx
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e62:	b8 10 00 00 00       	mov    $0x10,%eax
  800e67:	bf 00 00 00 00       	mov    $0x0,%edi
  800e6c:	89 fb                	mov    %edi,%ebx
  800e6e:	89 fe                	mov    %edi,%esi
  800e70:	cd 30                	int    $0x30
  800e72:	85 c0                	test   %eax,%eax
  800e74:	7e 17                	jle    800e8d <sys_transmit_packet+0x3a>
  800e76:	83 ec 0c             	sub    $0xc,%esp
  800e79:	50                   	push   %eax
  800e7a:	6a 10                	push   $0x10
  800e7c:	68 10 29 80 00       	push   $0x802910
  800e81:	6a 23                	push   $0x23
  800e83:	68 2d 29 80 00       	push   $0x80292d
  800e88:	e8 0f f3 ff ff       	call   80019c <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800e8d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	57                   	push   %edi
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
  800e9b:	83 ec 0c             	sub    $0xc,%esp
  800e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea4:	b8 11 00 00 00       	mov    $0x11,%eax
  800ea9:	bf 00 00 00 00       	mov    $0x0,%edi
  800eae:	89 fb                	mov    %edi,%ebx
  800eb0:	89 fe                	mov    %edi,%esi
  800eb2:	cd 30                	int    $0x30
  800eb4:	85 c0                	test   %eax,%eax
  800eb6:	7e 17                	jle    800ecf <sys_receive_packet+0x3a>
  800eb8:	83 ec 0c             	sub    $0xc,%esp
  800ebb:	50                   	push   %eax
  800ebc:	6a 11                	push   $0x11
  800ebe:	68 10 29 80 00       	push   $0x802910
  800ec3:	6a 23                	push   $0x23
  800ec5:	68 2d 29 80 00       	push   $0x80292d
  800eca:	e8 cd f2 ff ff       	call   80019c <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800ecf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ed2:	5b                   	pop    %ebx
  800ed3:	5e                   	pop    %esi
  800ed4:	5f                   	pop    %edi
  800ed5:	c9                   	leave  
  800ed6:	c3                   	ret    

00800ed7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	57                   	push   %edi
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
  800edd:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ee2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ee7:	89 fa                	mov    %edi,%edx
  800ee9:	89 f9                	mov    %edi,%ecx
  800eeb:	89 fb                	mov    %edi,%ebx
  800eed:	89 fe                	mov    %edi,%esi
  800eef:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	c9                   	leave  
  800ef5:	c3                   	ret    

00800ef6 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	57                   	push   %edi
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
  800efc:	83 ec 0c             	sub    $0xc,%esp
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f07:	bf 00 00 00 00       	mov    $0x0,%edi
  800f0c:	89 f9                	mov    %edi,%ecx
  800f0e:	89 fb                	mov    %edi,%ebx
  800f10:	89 fe                	mov    %edi,%esi
  800f12:	cd 30                	int    $0x30
  800f14:	85 c0                	test   %eax,%eax
  800f16:	7e 17                	jle    800f2f <sys_map_receive_buffers+0x39>
  800f18:	83 ec 0c             	sub    $0xc,%esp
  800f1b:	50                   	push   %eax
  800f1c:	6a 0e                	push   $0xe
  800f1e:	68 10 29 80 00       	push   $0x802910
  800f23:	6a 23                	push   $0x23
  800f25:	68 2d 29 80 00       	push   $0x80292d
  800f2a:	e8 6d f2 ff ff       	call   80019c <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800f2f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	c9                   	leave  
  800f36:	c3                   	ret    

00800f37 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
  800f3d:	83 ec 0c             	sub    $0xc,%esp
  800f40:	8b 55 08             	mov    0x8(%ebp),%edx
  800f43:	b8 12 00 00 00       	mov    $0x12,%eax
  800f48:	bf 00 00 00 00       	mov    $0x0,%edi
  800f4d:	89 f9                	mov    %edi,%ecx
  800f4f:	89 fb                	mov    %edi,%ebx
  800f51:	89 fe                	mov    %edi,%esi
  800f53:	cd 30                	int    $0x30
  800f55:	85 c0                	test   %eax,%eax
  800f57:	7e 17                	jle    800f70 <sys_receive_packet_zerocopy+0x39>
  800f59:	83 ec 0c             	sub    $0xc,%esp
  800f5c:	50                   	push   %eax
  800f5d:	6a 12                	push   $0x12
  800f5f:	68 10 29 80 00       	push   $0x802910
  800f64:	6a 23                	push   $0x23
  800f66:	68 2d 29 80 00       	push   $0x80292d
  800f6b:	e8 2c f2 ff ff       	call   80019c <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800f70:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f73:	5b                   	pop    %ebx
  800f74:	5e                   	pop    %esi
  800f75:	5f                   	pop    %edi
  800f76:	c9                   	leave  
  800f77:	c3                   	ret    

00800f78 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	57                   	push   %edi
  800f7c:	56                   	push   %esi
  800f7d:	53                   	push   %ebx
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f87:	b8 13 00 00 00       	mov    $0x13,%eax
  800f8c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f91:	89 fb                	mov    %edi,%ebx
  800f93:	89 fe                	mov    %edi,%esi
  800f95:	cd 30                	int    $0x30
  800f97:	85 c0                	test   %eax,%eax
  800f99:	7e 17                	jle    800fb2 <sys_env_set_priority+0x3a>
  800f9b:	83 ec 0c             	sub    $0xc,%esp
  800f9e:	50                   	push   %eax
  800f9f:	6a 13                	push   $0x13
  800fa1:	68 10 29 80 00       	push   $0x802910
  800fa6:	6a 23                	push   $0x23
  800fa8:	68 2d 29 80 00       	push   $0x80292d
  800fad:	e8 ea f1 ff ff       	call   80019c <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800fb2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fb5:	5b                   	pop    %ebx
  800fb6:	5e                   	pop    %esi
  800fb7:	5f                   	pop    %edi
  800fb8:	c9                   	leave  
  800fb9:	c3                   	ret    
	...

00800fbc <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800fc2:	ff 75 08             	pushl  0x8(%ebp)
  800fc5:	e8 0a 00 00 00       	call   800fd4 <fd2num>
  800fca:	c1 e0 16             	shl    $0x16,%eax
  800fcd:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  800fd2:	c9                   	leave  
  800fd3:	c3                   	ret    

00800fd4 <fd2num>:

int
fd2num(struct Fd *fd)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	05 00 00 40 30       	add    $0x30400000,%eax
  800fdf:	c1 e8 0c             	shr    $0xc,%eax
}
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <fd_alloc>:

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
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fed:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff2:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  800ff7:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  800ffc:	89 c8                	mov    %ecx,%eax
  800ffe:	c1 e0 0c             	shl    $0xc,%eax
  801001:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801007:	89 d0                	mov    %edx,%eax
  801009:	c1 e8 16             	shr    $0x16,%eax
  80100c:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80100f:	a8 01                	test   $0x1,%al
  801011:	74 0c                	je     80101f <fd_alloc+0x3b>
  801013:	89 d0                	mov    %edx,%eax
  801015:	c1 e8 0c             	shr    $0xc,%eax
  801018:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  80101b:	a8 01                	test   $0x1,%al
  80101d:	75 09                	jne    801028 <fd_alloc+0x44>
			*fd_store = fd;
  80101f:	89 17                	mov    %edx,(%edi)
			return 0;
  801021:	b8 00 00 00 00       	mov    $0x0,%eax
  801026:	eb 11                	jmp    801039 <fd_alloc+0x55>
  801028:	41                   	inc    %ecx
  801029:	83 f9 1f             	cmp    $0x1f,%ecx
  80102c:	7e ce                	jle    800ffc <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80102e:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801034:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801044:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801049:	83 f8 1f             	cmp    $0x1f,%eax
  80104c:	77 3a                	ja     801088 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80104e:	c1 e0 0c             	shl    $0xc,%eax
  801051:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801057:	89 d0                	mov    %edx,%eax
  801059:	c1 e8 16             	shr    $0x16,%eax
  80105c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801063:	a8 01                	test   $0x1,%al
  801065:	74 10                	je     801077 <fd_lookup+0x39>
  801067:	89 d0                	mov    %edx,%eax
  801069:	c1 e8 0c             	shr    $0xc,%eax
  80106c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801073:	a8 01                	test   $0x1,%al
  801075:	75 07                	jne    80107e <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801077:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80107c:	eb 0a                	jmp    801088 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	89 10                	mov    %edx,(%eax)
	return 0;
  801083:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801088:	89 d0                	mov    %edx,%eax
  80108a:	c9                   	leave  
  80108b:	c3                   	ret    

0080108c <fd_close>:

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
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	56                   	push   %esi
  801090:	53                   	push   %ebx
  801091:	83 ec 10             	sub    $0x10,%esp
  801094:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801097:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80109a:	50                   	push   %eax
  80109b:	56                   	push   %esi
  80109c:	e8 33 ff ff ff       	call   800fd4 <fd2num>
  8010a1:	89 04 24             	mov    %eax,(%esp)
  8010a4:	e8 95 ff ff ff       	call   80103e <fd_lookup>
  8010a9:	89 c3                	mov    %eax,%ebx
  8010ab:	83 c4 08             	add    $0x8,%esp
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	78 05                	js     8010b7 <fd_close+0x2b>
  8010b2:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8010b5:	74 0f                	je     8010c6 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8010b7:	89 d8                	mov    %ebx,%eax
  8010b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010bd:	75 3a                	jne    8010f9 <fd_close+0x6d>
  8010bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c4:	eb 33                	jmp    8010f9 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8010c6:	83 ec 08             	sub    $0x8,%esp
  8010c9:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8010cc:	50                   	push   %eax
  8010cd:	ff 36                	pushl  (%esi)
  8010cf:	e8 2c 00 00 00       	call   801100 <dev_lookup>
  8010d4:	89 c3                	mov    %eax,%ebx
  8010d6:	83 c4 10             	add    $0x10,%esp
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	78 0f                	js     8010ec <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8010dd:	83 ec 0c             	sub    $0xc,%esp
  8010e0:	56                   	push   %esi
  8010e1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8010e4:	ff 50 10             	call   *0x10(%eax)
  8010e7:	89 c3                	mov    %eax,%ebx
  8010e9:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	56                   	push   %esi
  8010f0:	6a 00                	push   $0x0
  8010f2:	e8 f0 fb ff ff       	call   800ce7 <sys_page_unmap>
	return r;
  8010f7:	89 d8                	mov    %ebx,%eax
}
  8010f9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8010fc:	5b                   	pop    %ebx
  8010fd:	5e                   	pop    %esi
  8010fe:	c9                   	leave  
  8010ff:	c3                   	ret    

00801100 <dev_lookup>:


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
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	56                   	push   %esi
  801104:	53                   	push   %ebx
  801105:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801108:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  80110b:	ba 00 00 00 00       	mov    $0x0,%edx
  801110:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  801117:	74 1c                	je     801135 <dev_lookup+0x35>
  801119:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80111e:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  801121:	39 18                	cmp    %ebx,(%eax)
  801123:	75 09                	jne    80112e <dev_lookup+0x2e>
			*dev = devtab[i];
  801125:	89 06                	mov    %eax,(%esi)
			return 0;
  801127:	b8 00 00 00 00       	mov    $0x0,%eax
  80112c:	eb 29                	jmp    801157 <dev_lookup+0x57>
  80112e:	42                   	inc    %edx
  80112f:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  801133:	75 e9                	jne    80111e <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801135:	83 ec 04             	sub    $0x4,%esp
  801138:	53                   	push   %ebx
  801139:	a1 80 80 80 00       	mov    0x808080,%eax
  80113e:	8b 40 4c             	mov    0x4c(%eax),%eax
  801141:	50                   	push   %eax
  801142:	68 3c 29 80 00       	push   $0x80293c
  801147:	e8 40 f1 ff ff       	call   80028c <cprintf>
	*dev = 0;
  80114c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  801152:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801157:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80115a:	5b                   	pop    %ebx
  80115b:	5e                   	pop    %esi
  80115c:	c9                   	leave  
  80115d:	c3                   	ret    

0080115e <close>:

int
close(int fdnum)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801164:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801167:	50                   	push   %eax
  801168:	ff 75 08             	pushl  0x8(%ebp)
  80116b:	e8 ce fe ff ff       	call   80103e <fd_lookup>
  801170:	83 c4 08             	add    $0x8,%esp
		return r;
  801173:	89 c2                	mov    %eax,%edx
  801175:	85 c0                	test   %eax,%eax
  801177:	78 0f                	js     801188 <close+0x2a>
	else
		return fd_close(fd, 1);
  801179:	83 ec 08             	sub    $0x8,%esp
  80117c:	6a 01                	push   $0x1
  80117e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801181:	e8 06 ff ff ff       	call   80108c <fd_close>
  801186:	89 c2                	mov    %eax,%edx
}
  801188:	89 d0                	mov    %edx,%eax
  80118a:	c9                   	leave  
  80118b:	c3                   	ret    

0080118c <close_all>:

void
close_all(void)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	53                   	push   %ebx
  801190:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801193:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	53                   	push   %ebx
  80119c:	e8 bd ff ff ff       	call   80115e <close>
  8011a1:	83 c4 10             	add    $0x10,%esp
  8011a4:	43                   	inc    %ebx
  8011a5:	83 fb 1f             	cmp    $0x1f,%ebx
  8011a8:	7e ee                	jle    801198 <close_all+0xc>
}
  8011aa:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    

008011af <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
  8011b2:	57                   	push   %edi
  8011b3:	56                   	push   %esi
  8011b4:	53                   	push   %ebx
  8011b5:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011b8:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8011bb:	50                   	push   %eax
  8011bc:	ff 75 08             	pushl  0x8(%ebp)
  8011bf:	e8 7a fe ff ff       	call   80103e <fd_lookup>
  8011c4:	89 c6                	mov    %eax,%esi
  8011c6:	83 c4 08             	add    $0x8,%esp
  8011c9:	85 f6                	test   %esi,%esi
  8011cb:	0f 88 f8 00 00 00    	js     8012c9 <dup+0x11a>
		return r;
	close(newfdnum);
  8011d1:	83 ec 0c             	sub    $0xc,%esp
  8011d4:	ff 75 0c             	pushl  0xc(%ebp)
  8011d7:	e8 82 ff ff ff       	call   80115e <close>

	newfd = INDEX2FD(newfdnum);
  8011dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011df:	c1 e0 0c             	shl    $0xc,%eax
  8011e2:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8011e7:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8011ea:	83 c4 04             	add    $0x4,%esp
  8011ed:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8011f0:	e8 c7 fd ff ff       	call   800fbc <fd2data>
  8011f5:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8011fd:	e8 ba fd ff ff       	call   800fbc <fd2data>
  801202:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801205:	89 f8                	mov    %edi,%eax
  801207:	c1 e8 16             	shr    $0x16,%eax
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801214:	85 c0                	test   %eax,%eax
  801216:	74 48                	je     801260 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801218:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  80121d:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  801220:	89 d0                	mov    %edx,%eax
  801222:	c1 e8 0c             	shr    $0xc,%eax
  801225:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  80122c:	a8 01                	test   $0x1,%al
  80122e:	74 22                	je     801252 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801230:	83 ec 0c             	sub    $0xc,%esp
  801233:	25 07 0e 00 00       	and    $0xe07,%eax
  801238:	50                   	push   %eax
  801239:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80123c:	01 d8                	add    %ebx,%eax
  80123e:	50                   	push   %eax
  80123f:	6a 00                	push   $0x0
  801241:	52                   	push   %edx
  801242:	6a 00                	push   $0x0
  801244:	e8 5c fa ff ff       	call   800ca5 <sys_page_map>
  801249:	89 c6                	mov    %eax,%esi
  80124b:	83 c4 20             	add    $0x20,%esp
  80124e:	85 c0                	test   %eax,%eax
  801250:	78 3f                	js     801291 <dup+0xe2>
  801252:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801258:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80125e:	7e bd                	jle    80121d <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801260:	83 ec 0c             	sub    $0xc,%esp
  801263:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801266:	89 d0                	mov    %edx,%eax
  801268:	c1 e8 0c             	shr    $0xc,%eax
  80126b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801272:	25 07 0e 00 00       	and    $0xe07,%eax
  801277:	50                   	push   %eax
  801278:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80127b:	6a 00                	push   $0x0
  80127d:	52                   	push   %edx
  80127e:	6a 00                	push   $0x0
  801280:	e8 20 fa ff ff       	call   800ca5 <sys_page_map>
  801285:	89 c6                	mov    %eax,%esi
  801287:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	85 f6                	test   %esi,%esi
  80128f:	79 38                	jns    8012c9 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801291:	83 ec 08             	sub    $0x8,%esp
  801294:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801297:	6a 00                	push   $0x0
  801299:	e8 49 fa ff ff       	call   800ce7 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80129e:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a3:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8012a6:	83 ec 08             	sub    $0x8,%esp
  8012a9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8012ac:	01 d8                	add    %ebx,%eax
  8012ae:	50                   	push   %eax
  8012af:	6a 00                	push   $0x0
  8012b1:	e8 31 fa ff ff       	call   800ce7 <sys_page_unmap>
  8012b6:	83 c4 10             	add    $0x10,%esp
  8012b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012bf:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8012c5:	7e df                	jle    8012a6 <dup+0xf7>
	return r;
  8012c7:	89 f0                	mov    %esi,%eax
}
  8012c9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8012cc:	5b                   	pop    %ebx
  8012cd:	5e                   	pop    %esi
  8012ce:	5f                   	pop    %edi
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	53                   	push   %ebx
  8012d5:	83 ec 14             	sub    $0x14,%esp
  8012d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012db:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8012de:	50                   	push   %eax
  8012df:	53                   	push   %ebx
  8012e0:	e8 59 fd ff ff       	call   80103e <fd_lookup>
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	83 c4 08             	add    $0x8,%esp
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	78 1a                	js     801308 <read+0x37>
  8012ee:	83 ec 08             	sub    $0x8,%esp
  8012f1:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8012f4:	50                   	push   %eax
  8012f5:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8012f8:	ff 30                	pushl  (%eax)
  8012fa:	e8 01 fe ff ff       	call   801100 <dev_lookup>
  8012ff:	89 c2                	mov    %eax,%edx
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	85 c0                	test   %eax,%eax
  801306:	79 04                	jns    80130c <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801308:	89 d0                	mov    %edx,%eax
  80130a:	eb 50                	jmp    80135c <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80130c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80130f:	8b 40 08             	mov    0x8(%eax),%eax
  801312:	83 e0 03             	and    $0x3,%eax
  801315:	83 f8 01             	cmp    $0x1,%eax
  801318:	75 1e                	jne    801338 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  80131a:	83 ec 04             	sub    $0x4,%esp
  80131d:	53                   	push   %ebx
  80131e:	a1 80 80 80 00       	mov    0x808080,%eax
  801323:	8b 40 4c             	mov    0x4c(%eax),%eax
  801326:	50                   	push   %eax
  801327:	68 7d 29 80 00       	push   $0x80297d
  80132c:	e8 5b ef ff ff       	call   80028c <cprintf>
		return -E_INVAL;
  801331:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801336:	eb 24                	jmp    80135c <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801338:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80133b:	ff 70 04             	pushl  0x4(%eax)
  80133e:	ff 75 10             	pushl  0x10(%ebp)
  801341:	ff 75 0c             	pushl  0xc(%ebp)
  801344:	50                   	push   %eax
  801345:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801348:	ff 50 08             	call   *0x8(%eax)
  80134b:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  80134d:	83 c4 10             	add    $0x10,%esp
  801350:	85 c0                	test   %eax,%eax
  801352:	78 06                	js     80135a <read+0x89>
		fd->fd_offset += r;
  801354:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801357:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80135a:	89 d0                	mov    %edx,%eax
}
  80135c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	57                   	push   %edi
  801365:	56                   	push   %esi
  801366:	53                   	push   %ebx
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80136d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801370:	bb 00 00 00 00       	mov    $0x0,%ebx
  801375:	39 f3                	cmp    %esi,%ebx
  801377:	73 25                	jae    80139e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801379:	83 ec 04             	sub    $0x4,%esp
  80137c:	89 f0                	mov    %esi,%eax
  80137e:	29 d8                	sub    %ebx,%eax
  801380:	50                   	push   %eax
  801381:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801384:	50                   	push   %eax
  801385:	ff 75 08             	pushl  0x8(%ebp)
  801388:	e8 44 ff ff ff       	call   8012d1 <read>
		if (m < 0)
  80138d:	83 c4 10             	add    $0x10,%esp
  801390:	85 c0                	test   %eax,%eax
  801392:	78 0c                	js     8013a0 <readn+0x3f>
			return m;
		if (m == 0)
  801394:	85 c0                	test   %eax,%eax
  801396:	74 06                	je     80139e <readn+0x3d>
  801398:	01 c3                	add    %eax,%ebx
  80139a:	39 f3                	cmp    %esi,%ebx
  80139c:	72 db                	jb     801379 <readn+0x18>
			break;
	}
	return tot;
  80139e:	89 d8                	mov    %ebx,%eax
}
  8013a0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8013a3:	5b                   	pop    %ebx
  8013a4:	5e                   	pop    %esi
  8013a5:	5f                   	pop    %edi
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	53                   	push   %ebx
  8013ac:	83 ec 14             	sub    $0x14,%esp
  8013af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b2:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8013b5:	50                   	push   %eax
  8013b6:	53                   	push   %ebx
  8013b7:	e8 82 fc ff ff       	call   80103e <fd_lookup>
  8013bc:	89 c2                	mov    %eax,%edx
  8013be:	83 c4 08             	add    $0x8,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	78 1a                	js     8013df <write+0x37>
  8013c5:	83 ec 08             	sub    $0x8,%esp
  8013c8:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8013cb:	50                   	push   %eax
  8013cc:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013cf:	ff 30                	pushl  (%eax)
  8013d1:	e8 2a fd ff ff       	call   801100 <dev_lookup>
  8013d6:	89 c2                	mov    %eax,%edx
  8013d8:	83 c4 10             	add    $0x10,%esp
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	79 04                	jns    8013e3 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8013df:	89 d0                	mov    %edx,%eax
  8013e1:	eb 4b                	jmp    80142e <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013e3:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013e6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ea:	75 1e                	jne    80140a <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8013ec:	83 ec 04             	sub    $0x4,%esp
  8013ef:	53                   	push   %ebx
  8013f0:	a1 80 80 80 00       	mov    0x808080,%eax
  8013f5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013f8:	50                   	push   %eax
  8013f9:	68 99 29 80 00       	push   $0x802999
  8013fe:	e8 89 ee ff ff       	call   80028c <cprintf>
		return -E_INVAL;
  801403:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801408:	eb 24                	jmp    80142e <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  80140a:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80140d:	ff 70 04             	pushl  0x4(%eax)
  801410:	ff 75 10             	pushl  0x10(%ebp)
  801413:	ff 75 0c             	pushl  0xc(%ebp)
  801416:	50                   	push   %eax
  801417:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80141a:	ff 50 0c             	call   *0xc(%eax)
  80141d:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80141f:	83 c4 10             	add    $0x10,%esp
  801422:	85 c0                	test   %eax,%eax
  801424:	7e 06                	jle    80142c <write+0x84>
		fd->fd_offset += r;
  801426:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801429:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80142c:	89 d0                	mov    %edx,%eax
}
  80142e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <seek>:

int
seek(int fdnum, off_t offset)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801439:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80143c:	50                   	push   %eax
  80143d:	ff 75 08             	pushl  0x8(%ebp)
  801440:	e8 f9 fb ff ff       	call   80103e <fd_lookup>
  801445:	83 c4 08             	add    $0x8,%esp
		return r;
  801448:	89 c2                	mov    %eax,%edx
  80144a:	85 c0                	test   %eax,%eax
  80144c:	78 0e                	js     80145c <seek+0x29>
	fd->fd_offset = offset;
  80144e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801451:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801454:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801457:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80145c:	89 d0                	mov    %edx,%eax
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	53                   	push   %ebx
  801464:	83 ec 14             	sub    $0x14,%esp
  801467:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146a:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80146d:	50                   	push   %eax
  80146e:	53                   	push   %ebx
  80146f:	e8 ca fb ff ff       	call   80103e <fd_lookup>
  801474:	83 c4 08             	add    $0x8,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	78 4e                	js     8014c9 <ftruncate+0x69>
  80147b:	83 ec 08             	sub    $0x8,%esp
  80147e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801481:	50                   	push   %eax
  801482:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801485:	ff 30                	pushl  (%eax)
  801487:	e8 74 fc ff ff       	call   801100 <dev_lookup>
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	85 c0                	test   %eax,%eax
  801491:	78 36                	js     8014c9 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801493:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801496:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149a:	75 1e                	jne    8014ba <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80149c:	83 ec 04             	sub    $0x4,%esp
  80149f:	53                   	push   %ebx
  8014a0:	a1 80 80 80 00       	mov    0x808080,%eax
  8014a5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014a8:	50                   	push   %eax
  8014a9:	68 5c 29 80 00       	push   $0x80295c
  8014ae:	e8 d9 ed ff ff       	call   80028c <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8014b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b8:	eb 0f                	jmp    8014c9 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8014ba:	83 ec 08             	sub    $0x8,%esp
  8014bd:	ff 75 0c             	pushl  0xc(%ebp)
  8014c0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8014c3:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8014c6:	ff 50 1c             	call   *0x1c(%eax)
}
  8014c9:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    

008014ce <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014ce:	55                   	push   %ebp
  8014cf:	89 e5                	mov    %esp,%ebp
  8014d1:	53                   	push   %ebx
  8014d2:	83 ec 14             	sub    $0x14,%esp
  8014d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d8:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8014db:	50                   	push   %eax
  8014dc:	ff 75 08             	pushl  0x8(%ebp)
  8014df:	e8 5a fb ff ff       	call   80103e <fd_lookup>
  8014e4:	83 c4 08             	add    $0x8,%esp
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	78 42                	js     80152d <fstat+0x5f>
  8014eb:	83 ec 08             	sub    $0x8,%esp
  8014ee:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8014f1:	50                   	push   %eax
  8014f2:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8014f5:	ff 30                	pushl  (%eax)
  8014f7:	e8 04 fc ff ff       	call   801100 <dev_lookup>
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	85 c0                	test   %eax,%eax
  801501:	78 2a                	js     80152d <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  801503:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801506:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80150d:	00 00 00 
	stat->st_isdir = 0;
  801510:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801517:	00 00 00 
	stat->st_dev = dev;
  80151a:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80151d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801523:	83 ec 08             	sub    $0x8,%esp
  801526:	53                   	push   %ebx
  801527:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80152a:	ff 50 14             	call   *0x14(%eax)
}
  80152d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	56                   	push   %esi
  801536:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801537:	83 ec 08             	sub    $0x8,%esp
  80153a:	6a 00                	push   $0x0
  80153c:	ff 75 08             	pushl  0x8(%ebp)
  80153f:	e8 28 00 00 00       	call   80156c <open>
  801544:	89 c6                	mov    %eax,%esi
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 f6                	test   %esi,%esi
  80154b:	78 18                	js     801565 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  80154d:	83 ec 08             	sub    $0x8,%esp
  801550:	ff 75 0c             	pushl  0xc(%ebp)
  801553:	56                   	push   %esi
  801554:	e8 75 ff ff ff       	call   8014ce <fstat>
  801559:	89 c3                	mov    %eax,%ebx
	close(fd);
  80155b:	89 34 24             	mov    %esi,(%esp)
  80155e:	e8 fb fb ff ff       	call   80115e <close>
	return r;
  801563:	89 d8                	mov    %ebx,%eax
}
  801565:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801568:	5b                   	pop    %ebx
  801569:	5e                   	pop    %esi
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	53                   	push   %ebx
  801570:	83 ec 10             	sub    $0x10,%esp
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
  801573:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801576:	50                   	push   %eax
  801577:	e8 68 fa ff ff       	call   800fe4 <fd_alloc>
  80157c:	89 c3                	mov    %eax,%ebx
  80157e:	83 c4 10             	add    $0x10,%esp
  801581:	85 db                	test   %ebx,%ebx
  801583:	78 36                	js     8015bb <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	ff 75 08             	pushl  0x8(%ebp)
  801591:	e8 1b 05 00 00       	call   801ab1 <fsipc_open>
  801596:	89 c3                	mov    %eax,%ebx
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	85 c0                	test   %eax,%eax
  80159d:	79 11                	jns    8015b0 <open+0x44>
          fd_close(fd_store, 0);
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	6a 00                	push   $0x0
  8015a4:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8015a7:	e8 e0 fa ff ff       	call   80108c <fd_close>
          return r;
  8015ac:	89 d8                	mov    %ebx,%eax
  8015ae:	eb 0b                	jmp    8015bb <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  8015b0:	83 ec 0c             	sub    $0xc,%esp
  8015b3:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8015b6:	e8 19 fa ff ff       	call   800fd4 <fd2num>
}
  8015bb:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	53                   	push   %ebx
  8015c4:	83 ec 04             	sub    $0x4,%esp
  8015c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  8015ca:	6a 01                	push   $0x1
  8015cc:	6a 00                	push   $0x0
  8015ce:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  8015d4:	53                   	push   %ebx
  8015d5:	e8 e7 03 00 00       	call   8019c1 <funmap>
  8015da:	83 c4 10             	add    $0x10,%esp
          return r;
  8015dd:	89 c2                	mov    %eax,%edx
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 19                	js     8015fc <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  8015e3:	83 ec 0c             	sub    $0xc,%esp
  8015e6:	ff 73 0c             	pushl  0xc(%ebx)
  8015e9:	e8 68 05 00 00       	call   801b56 <fsipc_close>
  8015ee:	83 c4 10             	add    $0x10,%esp
          return r;
  8015f1:	89 c2                	mov    %eax,%edx
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	78 05                	js     8015fc <file_close+0x3c>
        }
        return 0;
  8015f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8015fc:	89 d0                	mov    %edx,%eax
  8015fe:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801601:	c9                   	leave  
  801602:	c3                   	ret    

00801603 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801603:	55                   	push   %ebp
  801604:	89 e5                	mov    %esp,%ebp
  801606:	57                   	push   %edi
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	83 ec 0c             	sub    $0xc,%esp
  80160c:	8b 75 10             	mov    0x10(%ebp),%esi
  80160f:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  80161b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801620:	39 d7                	cmp    %edx,%edi
  801622:	0f 87 95 00 00 00    	ja     8016bd <file_read+0xba>
	if (offset + n > size)
  801628:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80162b:	39 d0                	cmp    %edx,%eax
  80162d:	76 04                	jbe    801633 <file_read+0x30>
		n = size - offset;
  80162f:	89 d6                	mov    %edx,%esi
  801631:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801633:	83 ec 0c             	sub    $0xc,%esp
  801636:	ff 75 08             	pushl  0x8(%ebp)
  801639:	e8 7e f9 ff ff       	call   800fbc <fd2data>
  80163e:	89 c3                	mov    %eax,%ebx
  801640:	01 fb                	add    %edi,%ebx
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	eb 41                	jmp    801688 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801647:	89 d8                	mov    %ebx,%eax
  801649:	c1 e8 16             	shr    $0x16,%eax
  80164c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801653:	a8 01                	test   $0x1,%al
  801655:	74 10                	je     801667 <file_read+0x64>
  801657:	89 d8                	mov    %ebx,%eax
  801659:	c1 e8 0c             	shr    $0xc,%eax
  80165c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801663:	a8 01                	test   $0x1,%al
  801665:	75 1b                	jne    801682 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801667:	83 ec 04             	sub    $0x4,%esp
  80166a:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80166d:	50                   	push   %eax
  80166e:	57                   	push   %edi
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	e8 d4 02 00 00       	call   80194b <fmap>
  801677:	83 c4 10             	add    $0x10,%esp
              return r;
  80167a:	89 c1                	mov    %eax,%ecx
  80167c:	85 c0                	test   %eax,%eax
  80167e:	78 3d                	js     8016bd <file_read+0xba>
  801680:	eb 1c                	jmp    80169e <file_read+0x9b>
  801682:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801688:	83 ec 0c             	sub    $0xc,%esp
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 29 f9 ff ff       	call   800fbc <fd2data>
  801693:	01 f8                	add    %edi,%eax
  801695:	01 f0                	add    %esi,%eax
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	39 d8                	cmp    %ebx,%eax
  80169c:	77 a9                	ja     801647 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	56                   	push   %esi
  8016a2:	83 ec 04             	sub    $0x4,%esp
  8016a5:	ff 75 08             	pushl  0x8(%ebp)
  8016a8:	e8 0f f9 ff ff       	call   800fbc <fd2data>
  8016ad:	83 c4 08             	add    $0x8,%esp
  8016b0:	01 f8                	add    %edi,%eax
  8016b2:	50                   	push   %eax
  8016b3:	ff 75 0c             	pushl  0xc(%ebp)
  8016b6:	e8 51 f3 ff ff       	call   800a0c <memmove>
	return n;
  8016bb:	89 f1                	mov    %esi,%ecx
}
  8016bd:	89 c8                	mov    %ecx,%eax
  8016bf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8016c2:	5b                   	pop    %ebx
  8016c3:	5e                   	pop    %esi
  8016c4:	5f                   	pop    %edi
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	56                   	push   %esi
  8016cb:	53                   	push   %ebx
  8016cc:	83 ec 18             	sub    $0x18,%esp
  8016cf:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016d2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8016d5:	50                   	push   %eax
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	e8 60 f9 ff ff       	call   80103e <fd_lookup>
  8016de:	83 c4 10             	add    $0x10,%esp
		return r;
  8016e1:	89 c2                	mov    %eax,%edx
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	0f 88 9f 00 00 00    	js     80178a <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  8016eb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8016ee:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  8016f0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8016f5:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  8016fb:	0f 85 89 00 00 00    	jne    80178a <read_map+0xc3>
	va = fd2data(fd) + offset;
  801701:	83 ec 0c             	sub    $0xc,%esp
  801704:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801707:	e8 b0 f8 ff ff       	call   800fbc <fd2data>
  80170c:	89 c3                	mov    %eax,%ebx
  80170e:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801710:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801713:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801718:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  80171e:	7f 6a                	jg     80178a <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801720:	89 d8                	mov    %ebx,%eax
  801722:	c1 e8 16             	shr    $0x16,%eax
  801725:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80172c:	a8 01                	test   $0x1,%al
  80172e:	74 10                	je     801740 <read_map+0x79>
  801730:	89 d8                	mov    %ebx,%eax
  801732:	c1 e8 0c             	shr    $0xc,%eax
  801735:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80173c:	a8 01                	test   $0x1,%al
  80173e:	75 19                	jne    801759 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	8d 46 01             	lea    0x1(%esi),%eax
  801746:	50                   	push   %eax
  801747:	56                   	push   %esi
  801748:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  80174b:	e8 fb 01 00 00       	call   80194b <fmap>
  801750:	83 c4 10             	add    $0x10,%esp
            return r;
  801753:	89 c2                	mov    %eax,%edx
  801755:	85 c0                	test   %eax,%eax
  801757:	78 31                	js     80178a <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801759:	89 d8                	mov    %ebx,%eax
  80175b:	c1 e8 16             	shr    $0x16,%eax
  80175e:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801765:	a8 01                	test   $0x1,%al
  801767:	74 10                	je     801779 <read_map+0xb2>
  801769:	89 d8                	mov    %ebx,%eax
  80176b:	c1 e8 0c             	shr    $0xc,%eax
  80176e:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801775:	a8 01                	test   $0x1,%al
  801777:	75 07                	jne    801780 <read_map+0xb9>
		return -E_NO_DISK;
  801779:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  80177e:	eb 0a                	jmp    80178a <read_map+0xc3>

	*blk = (void*) va;
  801780:	8b 45 10             	mov    0x10(%ebp),%eax
  801783:	89 18                	mov    %ebx,(%eax)
	return 0;
  801785:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80178a:	89 d0                	mov    %edx,%eax
  80178c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80178f:	5b                   	pop    %ebx
  801790:	5e                   	pop    %esi
  801791:	c9                   	leave  
  801792:	c3                   	ret    

00801793 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	57                   	push   %edi
  801797:	56                   	push   %esi
  801798:	53                   	push   %ebx
  801799:	83 ec 0c             	sub    $0xc,%esp
  80179c:	8b 75 08             	mov    0x8(%ebp),%esi
  80179f:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  8017a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a5:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  8017a8:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  8017ad:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8017b3:	0f 87 bd 00 00 00    	ja     801876 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  8017b9:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  8017bf:	73 17                	jae    8017d8 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  8017c1:	83 ec 08             	sub    $0x8,%esp
  8017c4:	52                   	push   %edx
  8017c5:	56                   	push   %esi
  8017c6:	e8 fb 00 00 00       	call   8018c6 <file_trunc>
  8017cb:	83 c4 10             	add    $0x10,%esp
			return r;
  8017ce:	89 c1                	mov    %eax,%ecx
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	0f 88 9e 00 00 00    	js     801876 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8017d8:	83 ec 0c             	sub    $0xc,%esp
  8017db:	56                   	push   %esi
  8017dc:	e8 db f7 ff ff       	call   800fbc <fd2data>
  8017e1:	89 c3                	mov    %eax,%ebx
  8017e3:	01 fb                	add    %edi,%ebx
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	eb 42                	jmp    80182c <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8017ea:	89 d8                	mov    %ebx,%eax
  8017ec:	c1 e8 16             	shr    $0x16,%eax
  8017ef:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8017f6:	a8 01                	test   $0x1,%al
  8017f8:	74 10                	je     80180a <file_write+0x77>
  8017fa:	89 d8                	mov    %ebx,%eax
  8017fc:	c1 e8 0c             	shr    $0xc,%eax
  8017ff:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801806:	a8 01                	test   $0x1,%al
  801808:	75 1c                	jne    801826 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	8b 55 10             	mov    0x10(%ebp),%edx
  801810:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801813:	50                   	push   %eax
  801814:	57                   	push   %edi
  801815:	56                   	push   %esi
  801816:	e8 30 01 00 00       	call   80194b <fmap>
  80181b:	83 c4 10             	add    $0x10,%esp
              return r;
  80181e:	89 c1                	mov    %eax,%ecx
  801820:	85 c0                	test   %eax,%eax
  801822:	78 52                	js     801876 <file_write+0xe3>
  801824:	eb 1b                	jmp    801841 <file_write+0xae>
  801826:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80182c:	83 ec 0c             	sub    $0xc,%esp
  80182f:	56                   	push   %esi
  801830:	e8 87 f7 ff ff       	call   800fbc <fd2data>
  801835:	01 f8                	add    %edi,%eax
  801837:	03 45 10             	add    0x10(%ebp),%eax
  80183a:	83 c4 10             	add    $0x10,%esp
  80183d:	39 d8                	cmp    %ebx,%eax
  80183f:	77 a9                	ja     8017ea <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801841:	83 ec 0c             	sub    $0xc,%esp
  801844:	68 b6 29 80 00       	push   $0x8029b6
  801849:	e8 3e ea ff ff       	call   80028c <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  80184e:	83 c4 0c             	add    $0xc,%esp
  801851:	ff 75 10             	pushl  0x10(%ebp)
  801854:	ff 75 0c             	pushl  0xc(%ebp)
  801857:	56                   	push   %esi
  801858:	e8 5f f7 ff ff       	call   800fbc <fd2data>
  80185d:	01 f8                	add    %edi,%eax
  80185f:	89 04 24             	mov    %eax,(%esp)
  801862:	e8 a5 f1 ff ff       	call   800a0c <memmove>
        cprintf("write done\n");
  801867:	c7 04 24 c3 29 80 00 	movl   $0x8029c3,(%esp)
  80186e:	e8 19 ea ff ff       	call   80028c <cprintf>
	return n;
  801873:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801876:	89 c8                	mov    %ecx,%eax
  801878:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80187b:	5b                   	pop    %ebx
  80187c:	5e                   	pop    %esi
  80187d:	5f                   	pop    %edi
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
  801885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801888:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	8d 43 10             	lea    0x10(%ebx),%eax
  801891:	50                   	push   %eax
  801892:	56                   	push   %esi
  801893:	e8 f8 ef ff ff       	call   800890 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801898:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  80189e:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  8018ae:	0f 94 c0             	sete   %al
  8018b1:	0f b6 c0             	movzbl %al,%eax
  8018b4:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  8018ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bf:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5e                   	pop    %esi
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	57                   	push   %edi
  8018ca:	56                   	push   %esi
  8018cb:	53                   	push   %ebx
  8018cc:	83 ec 0c             	sub    $0xc,%esp
  8018cf:	8b 75 08             	mov    0x8(%ebp),%esi
  8018d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  8018d5:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8018da:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  8018e0:	7f 5f                	jg     801941 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  8018e2:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  8018e8:	83 ec 08             	sub    $0x8,%esp
  8018eb:	53                   	push   %ebx
  8018ec:	ff 76 0c             	pushl  0xc(%esi)
  8018ef:	e8 3a 02 00 00       	call   801b2e <fsipc_set_size>
  8018f4:	83 c4 10             	add    $0x10,%esp
		return r;
  8018f7:	89 c2                	mov    %eax,%edx
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	78 44                	js     801941 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  8018fd:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801903:	74 19                	je     80191e <file_trunc+0x58>
  801905:	68 f0 29 80 00       	push   $0x8029f0
  80190a:	68 cf 29 80 00       	push   $0x8029cf
  80190f:	68 dc 00 00 00       	push   $0xdc
  801914:	68 e4 29 80 00       	push   $0x8029e4
  801919:	e8 7e e8 ff ff       	call   80019c <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	53                   	push   %ebx
  801922:	57                   	push   %edi
  801923:	56                   	push   %esi
  801924:	e8 22 00 00 00       	call   80194b <fmap>
  801929:	83 c4 10             	add    $0x10,%esp
		return r;
  80192c:	89 c2                	mov    %eax,%edx
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 0f                	js     801941 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801932:	6a 00                	push   $0x0
  801934:	53                   	push   %ebx
  801935:	57                   	push   %edi
  801936:	56                   	push   %esi
  801937:	e8 85 00 00 00       	call   8019c1 <funmap>

	return 0;
  80193c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801941:	89 d0                	mov    %edx,%eax
  801943:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801946:	5b                   	pop    %ebx
  801947:	5e                   	pop    %esi
  801948:	5f                   	pop    %edi
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <fmap>:

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
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	57                   	push   %edi
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
  801951:	83 ec 0c             	sub    $0xc,%esp
  801954:	8b 7d 08             	mov    0x8(%ebp),%edi
  801957:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  80195a:	39 75 0c             	cmp    %esi,0xc(%ebp)
  80195d:	7d 55                	jge    8019b4 <fmap+0x69>
          fma = fd2data(fd);
  80195f:	83 ec 0c             	sub    $0xc,%esp
  801962:	57                   	push   %edi
  801963:	e8 54 f6 ff ff       	call   800fbc <fd2data>
  801968:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	05 ff 0f 00 00       	add    $0xfff,%eax
  801976:	89 c3                	mov    %eax,%ebx
  801978:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80197e:	39 f3                	cmp    %esi,%ebx
  801980:	7d 32                	jge    8019b4 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801988:	01 d8                	add    %ebx,%eax
  80198a:	50                   	push   %eax
  80198b:	53                   	push   %ebx
  80198c:	ff 77 0c             	pushl  0xc(%edi)
  80198f:	e8 6f 01 00 00       	call   801b03 <fsipc_map>
  801994:	83 c4 10             	add    $0x10,%esp
  801997:	85 c0                	test   %eax,%eax
  801999:	79 0f                	jns    8019aa <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	53                   	push   %ebx
  8019a1:	57                   	push   %edi
  8019a2:	e8 1a 00 00 00       	call   8019c1 <funmap>
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8019b0:	39 f3                	cmp    %esi,%ebx
  8019b2:	7c ce                	jl     801982 <fmap+0x37>
            }
          }
        }

        return 0;
}
  8019b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8019bc:	5b                   	pop    %ebx
  8019bd:	5e                   	pop    %esi
  8019be:	5f                   	pop    %edi
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <funmap>:

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
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	57                   	push   %edi
  8019c5:	56                   	push   %esi
  8019c6:	53                   	push   %ebx
  8019c7:	83 ec 0c             	sub    $0xc,%esp
  8019ca:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  8019d0:	39 f3                	cmp    %esi,%ebx
  8019d2:	0f 8d 80 00 00 00    	jge    801a58 <funmap+0x97>
          fma = fd2data(fd);
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	ff 75 08             	pushl  0x8(%ebp)
  8019de:	e8 d9 f5 ff ff       	call   800fbc <fd2data>
  8019e3:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  8019e5:	83 c4 10             	add    $0x10,%esp
  8019e8:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8019ee:	89 c3                	mov    %eax,%ebx
  8019f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8019f6:	39 f3                	cmp    %esi,%ebx
  8019f8:	7d 5e                	jge    801a58 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  8019fa:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8019fd:	89 c2                	mov    %eax,%edx
  8019ff:	c1 ea 0c             	shr    $0xc,%edx
  801a02:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801a09:	a8 01                	test   $0x1,%al
  801a0b:	74 41                	je     801a4e <funmap+0x8d>
              if (dirty) {
  801a0d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801a11:	74 21                	je     801a34 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801a13:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801a1a:	a8 40                	test   $0x40,%al
  801a1c:	74 16                	je     801a34 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801a1e:	83 ec 08             	sub    $0x8,%esp
  801a21:	53                   	push   %ebx
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	ff 70 0c             	pushl  0xc(%eax)
  801a28:	e8 49 01 00 00       	call   801b76 <fsipc_dirty>
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	85 c0                	test   %eax,%eax
  801a32:	78 29                	js     801a5d <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801a34:	83 ec 08             	sub    $0x8,%esp
  801a37:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801a3a:	50                   	push   %eax
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	e8 e1 f1 ff ff       	call   800c24 <sys_getenvid>
  801a43:	89 04 24             	mov    %eax,(%esp)
  801a46:	e8 9c f2 ff ff       	call   800ce7 <sys_page_unmap>
  801a4b:	83 c4 10             	add    $0x10,%esp
  801a4e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a54:	39 f3                	cmp    %esi,%ebx
  801a56:	7c a2                	jl     8019fa <funmap+0x39>
            }
          }
        }

        return 0;
  801a58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801a60:	5b                   	pop    %ebx
  801a61:	5e                   	pop    %esi
  801a62:	5f                   	pop    %edi
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <remove>:

// Delete a file
int
remove(const char *path)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	e8 2b 01 00 00       	call   801b9e <fsipc_remove>
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801a7b:	e8 64 01 00 00       	call   801be4 <fsipc_sync>
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    
	...

00801a84 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801a8a:	6a 07                	push   $0x7
  801a8c:	ff 75 0c             	pushl  0xc(%ebp)
  801a8f:	ff 75 08             	pushl  0x8(%ebp)
  801a92:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801a97:	50                   	push   %eax
  801a98:	e8 c6 06 00 00       	call   802163 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801a9d:	83 c4 0c             	add    $0xc,%esp
  801aa0:	ff 75 14             	pushl  0x14(%ebp)
  801aa3:	ff 75 10             	pushl  0x10(%ebp)
  801aa6:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801aa9:	50                   	push   %eax
  801aaa:	e8 51 06 00 00       	call   802100 <ipc_recv>
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	56                   	push   %esi
  801ab5:	53                   	push   %ebx
  801ab6:	83 ec 1c             	sub    $0x1c,%esp
  801ab9:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801abc:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801ac1:	56                   	push   %esi
  801ac2:	e8 8d ed ff ff       	call   800854 <strlen>
  801ac7:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801aca:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801acf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ad4:	7f 24                	jg     801afa <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801ad6:	83 ec 08             	sub    $0x8,%esp
  801ad9:	56                   	push   %esi
  801ada:	53                   	push   %ebx
  801adb:	e8 b0 ed ff ff       	call   800890 <strcpy>
	req->req_omode = omode;
  801ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae3:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801ae9:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801aec:	50                   	push   %eax
  801aed:	ff 75 10             	pushl  0x10(%ebp)
  801af0:	53                   	push   %ebx
  801af1:	6a 01                	push   $0x1
  801af3:	e8 8c ff ff ff       	call   801a84 <fsipc>
  801af8:	89 c2                	mov    %eax,%edx
}
  801afa:	89 d0                	mov    %edx,%eax
  801afc:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801aff:	5b                   	pop    %ebx
  801b00:	5e                   	pop    %esi
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
  801b06:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b14:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801b19:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801b1c:	50                   	push   %eax
  801b1d:	ff 75 10             	pushl  0x10(%ebp)
  801b20:	68 00 30 80 00       	push   $0x803000
  801b25:	6a 02                	push   $0x2
  801b27:	e8 58 ff ff ff       	call   801a84 <fsipc>

	//return -E_UNSPECIFIED;
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  801b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3f:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	68 00 30 80 00       	push   $0x803000
  801b4d:	6a 03                	push   $0x3
  801b4f:	e8 30 ff ff ff       	call   801a84 <fsipc>
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	68 00 30 80 00       	push   $0x803000
  801b6d:	6a 04                	push   $0x4
  801b6f:	e8 10 ff ff ff       	call   801a84 <fsipc>
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b87:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	68 00 30 80 00       	push   $0x803000
  801b95:	6a 05                	push   $0x5
  801b97:	e8 e8 fe ff ff       	call   801a84 <fsipc>
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	56                   	push   %esi
  801ba2:	53                   	push   %ebx
  801ba3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801ba6:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801bab:	83 ec 0c             	sub    $0xc,%esp
  801bae:	53                   	push   %ebx
  801baf:	e8 a0 ec ff ff       	call   800854 <strlen>
  801bb4:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801bb7:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801bbc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bc1:	7f 18                	jg     801bdb <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801bc3:	83 ec 08             	sub    $0x8,%esp
  801bc6:	53                   	push   %ebx
  801bc7:	56                   	push   %esi
  801bc8:	e8 c3 ec ff ff       	call   800890 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	56                   	push   %esi
  801bd2:	6a 06                	push   $0x6
  801bd4:	e8 ab fe ff ff       	call   801a84 <fsipc>
  801bd9:	89 c2                	mov    %eax,%edx
}
  801bdb:	89 d0                	mov    %edx,%eax
  801bdd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	68 00 30 80 00       	push   $0x803000
  801bf3:	6a 07                	push   $0x7
  801bf5:	e8 8a fe ff ff       	call   801a84 <fsipc>
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <pipe>:
};

int
pipe(int pfd[2])
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	57                   	push   %edi
  801c00:	56                   	push   %esi
  801c01:	53                   	push   %ebx
  801c02:	83 ec 18             	sub    $0x18,%esp
  801c05:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801c08:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801c0b:	50                   	push   %eax
  801c0c:	e8 d3 f3 ff ff       	call   800fe4 <fd_alloc>
  801c11:	89 c3                	mov    %eax,%ebx
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	85 c0                	test   %eax,%eax
  801c18:	0f 88 25 01 00 00    	js     801d43 <pipe+0x147>
  801c1e:	83 ec 04             	sub    $0x4,%esp
  801c21:	68 07 04 00 00       	push   $0x407
  801c26:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801c29:	6a 00                	push   $0x0
  801c2b:	e8 32 f0 ff ff       	call   800c62 <sys_page_alloc>
  801c30:	89 c3                	mov    %eax,%ebx
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	85 c0                	test   %eax,%eax
  801c37:	0f 88 06 01 00 00    	js     801d43 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801c3d:	83 ec 0c             	sub    $0xc,%esp
  801c40:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801c43:	50                   	push   %eax
  801c44:	e8 9b f3 ff ff       	call   800fe4 <fd_alloc>
  801c49:	89 c3                	mov    %eax,%ebx
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	0f 88 dd 00 00 00    	js     801d33 <pipe+0x137>
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	68 07 04 00 00       	push   $0x407
  801c5e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801c61:	6a 00                	push   $0x0
  801c63:	e8 fa ef ff ff       	call   800c62 <sys_page_alloc>
  801c68:	89 c3                	mov    %eax,%ebx
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	0f 88 be 00 00 00    	js     801d33 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801c75:	83 ec 0c             	sub    $0xc,%esp
  801c78:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801c7b:	e8 3c f3 ff ff       	call   800fbc <fd2data>
  801c80:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c82:	83 c4 0c             	add    $0xc,%esp
  801c85:	68 07 04 00 00       	push   $0x407
  801c8a:	50                   	push   %eax
  801c8b:	6a 00                	push   $0x0
  801c8d:	e8 d0 ef ff ff       	call   800c62 <sys_page_alloc>
  801c92:	89 c3                	mov    %eax,%ebx
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	85 c0                	test   %eax,%eax
  801c99:	0f 88 84 00 00 00    	js     801d23 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c9f:	83 ec 0c             	sub    $0xc,%esp
  801ca2:	68 07 04 00 00       	push   $0x407
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801cad:	e8 0a f3 ff ff       	call   800fbc <fd2data>
  801cb2:	83 c4 10             	add    $0x10,%esp
  801cb5:	50                   	push   %eax
  801cb6:	6a 00                	push   $0x0
  801cb8:	56                   	push   %esi
  801cb9:	6a 00                	push   $0x0
  801cbb:	e8 e5 ef ff ff       	call   800ca5 <sys_page_map>
  801cc0:	89 c3                	mov    %eax,%ebx
  801cc2:	83 c4 20             	add    $0x20,%esp
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	78 4c                	js     801d15 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801cc9:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801ccf:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801cd2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801cd4:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801cd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801cde:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801ce4:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801ce7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ce9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801cec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  801cf3:	83 ec 0c             	sub    $0xc,%esp
  801cf6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801cf9:	e8 d6 f2 ff ff       	call   800fd4 <fd2num>
  801cfe:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801d00:	83 c4 04             	add    $0x4,%esp
  801d03:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801d06:	e8 c9 f2 ff ff       	call   800fd4 <fd2num>
  801d0b:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801d0e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d13:	eb 30                	jmp    801d45 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  801d15:	83 ec 08             	sub    $0x8,%esp
  801d18:	56                   	push   %esi
  801d19:	6a 00                	push   $0x0
  801d1b:	e8 c7 ef ff ff       	call   800ce7 <sys_page_unmap>
  801d20:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801d23:	83 ec 08             	sub    $0x8,%esp
  801d26:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801d29:	6a 00                	push   $0x0
  801d2b:	e8 b7 ef ff ff       	call   800ce7 <sys_page_unmap>
  801d30:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801d33:	83 ec 08             	sub    $0x8,%esp
  801d36:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801d39:	6a 00                	push   $0x0
  801d3b:	e8 a7 ef ff ff       	call   800ce7 <sys_page_unmap>
  801d40:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  801d43:	89 d8                	mov    %ebx,%eax
}
  801d45:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d48:	5b                   	pop    %ebx
  801d49:	5e                   	pop    %esi
  801d4a:	5f                   	pop    %edi
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	57                   	push   %edi
  801d51:	56                   	push   %esi
  801d52:	53                   	push   %ebx
  801d53:	83 ec 0c             	sub    $0xc,%esp
  801d56:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801d59:	a1 80 80 80 00       	mov    0x808080,%eax
  801d5e:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801d61:	83 ec 0c             	sub    $0xc,%esp
  801d64:	ff 75 08             	pushl  0x8(%ebp)
  801d67:	e8 50 04 00 00       	call   8021bc <pageref>
  801d6c:	89 c3                	mov    %eax,%ebx
  801d6e:	89 3c 24             	mov    %edi,(%esp)
  801d71:	e8 46 04 00 00       	call   8021bc <pageref>
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	39 c3                	cmp    %eax,%ebx
  801d7b:	0f 94 c0             	sete   %al
  801d7e:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  801d81:	8b 0d 80 80 80 00    	mov    0x808080,%ecx
  801d87:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  801d8a:	39 c6                	cmp    %eax,%esi
  801d8c:	74 1b                	je     801da9 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  801d8e:	83 fa 01             	cmp    $0x1,%edx
  801d91:	75 c6                	jne    801d59 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801d93:	6a 01                	push   $0x1
  801d95:	8b 41 58             	mov    0x58(%ecx),%eax
  801d98:	50                   	push   %eax
  801d99:	56                   	push   %esi
  801d9a:	68 18 2a 80 00       	push   $0x802a18
  801d9f:	e8 e8 e4 ff ff       	call   80028c <cprintf>
  801da4:	83 c4 10             	add    $0x10,%esp
  801da7:	eb b0                	jmp    801d59 <_pipeisclosed+0xc>
	}
}
  801da9:	89 d0                	mov    %edx,%eax
  801dab:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801dae:	5b                   	pop    %ebx
  801daf:	5e                   	pop    %esi
  801db0:	5f                   	pop    %edi
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801db9:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801dbc:	50                   	push   %eax
  801dbd:	ff 75 08             	pushl  0x8(%ebp)
  801dc0:	e8 79 f2 ff ff       	call   80103e <fd_lookup>
  801dc5:	83 c4 10             	add    $0x10,%esp
		return r;
  801dc8:	89 c2                	mov    %eax,%edx
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	78 19                	js     801de7 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  801dce:	83 ec 0c             	sub    $0xc,%esp
  801dd1:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801dd4:	e8 e3 f1 ff ff       	call   800fbc <fd2data>
	return _pipeisclosed(fd, p);
  801dd9:	83 c4 08             	add    $0x8,%esp
  801ddc:	50                   	push   %eax
  801ddd:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801de0:	e8 68 ff ff ff       	call   801d4d <_pipeisclosed>
  801de5:	89 c2                	mov    %eax,%edx
}
  801de7:	89 d0                	mov    %edx,%eax
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	57                   	push   %edi
  801def:	56                   	push   %esi
  801df0:	53                   	push   %ebx
  801df1:	83 ec 18             	sub    $0x18,%esp
  801df4:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  801df7:	57                   	push   %edi
  801df8:	e8 bf f1 ff ff       	call   800fbc <fd2data>
  801dfd:	89 c3                	mov    %eax,%ebx
	if (debug)
  801dff:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801e08:	be 00 00 00 00       	mov    $0x0,%esi
  801e0d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e10:	73 55                	jae    801e67 <piperead+0x7c>
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
  801e12:	8b 03                	mov    (%ebx),%eax
  801e14:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e17:	75 2c                	jne    801e45 <piperead+0x5a>
  801e19:	85 f6                	test   %esi,%esi
  801e1b:	74 04                	je     801e21 <piperead+0x36>
  801e1d:	89 f0                	mov    %esi,%eax
  801e1f:	eb 48                	jmp    801e69 <piperead+0x7e>
  801e21:	83 ec 08             	sub    $0x8,%esp
  801e24:	53                   	push   %ebx
  801e25:	57                   	push   %edi
  801e26:	e8 22 ff ff ff       	call   801d4d <_pipeisclosed>
  801e2b:	83 c4 10             	add    $0x10,%esp
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	74 07                	je     801e39 <piperead+0x4e>
  801e32:	b8 00 00 00 00       	mov    $0x0,%eax
  801e37:	eb 30                	jmp    801e69 <piperead+0x7e>
  801e39:	e8 05 ee ff ff       	call   800c43 <sys_yield>
  801e3e:	8b 03                	mov    (%ebx),%eax
  801e40:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e43:	74 d4                	je     801e19 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e45:	8b 13                	mov    (%ebx),%edx
  801e47:	89 d0                	mov    %edx,%eax
  801e49:	85 d2                	test   %edx,%edx
  801e4b:	79 03                	jns    801e50 <piperead+0x65>
  801e4d:	8d 42 1f             	lea    0x1f(%edx),%eax
  801e50:	83 e0 e0             	and    $0xffffffe0,%eax
  801e53:	29 c2                	sub    %eax,%edx
  801e55:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  801e59:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801e5c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801e5f:	ff 03                	incl   (%ebx)
  801e61:	46                   	inc    %esi
  801e62:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e65:	72 ab                	jb     801e12 <piperead+0x27>
	}
	return i;
  801e67:	89 f0                	mov    %esi,%eax
}
  801e69:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801e6c:	5b                   	pop    %ebx
  801e6d:	5e                   	pop    %esi
  801e6e:	5f                   	pop    %edi
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	57                   	push   %edi
  801e75:	56                   	push   %esi
  801e76:	53                   	push   %ebx
  801e77:	83 ec 18             	sub    $0x18,%esp
  801e7a:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  801e7d:	57                   	push   %edi
  801e7e:	e8 39 f1 ff ff       	call   800fbc <fd2data>
  801e83:	89 c3                	mov    %eax,%ebx
	if (debug)
  801e85:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801e8e:	be 00 00 00 00       	mov    $0x0,%esi
  801e93:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e96:	73 55                	jae    801eed <pipewrite+0x7c>
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
  801e98:	8b 03                	mov    (%ebx),%eax
  801e9a:	83 c0 20             	add    $0x20,%eax
  801e9d:	39 43 04             	cmp    %eax,0x4(%ebx)
  801ea0:	72 27                	jb     801ec9 <pipewrite+0x58>
  801ea2:	83 ec 08             	sub    $0x8,%esp
  801ea5:	53                   	push   %ebx
  801ea6:	57                   	push   %edi
  801ea7:	e8 a1 fe ff ff       	call   801d4d <_pipeisclosed>
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	74 07                	je     801eba <pipewrite+0x49>
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb8:	eb 35                	jmp    801eef <pipewrite+0x7e>
  801eba:	e8 84 ed ff ff       	call   800c43 <sys_yield>
  801ebf:	8b 03                	mov    (%ebx),%eax
  801ec1:	83 c0 20             	add    $0x20,%eax
  801ec4:	39 43 04             	cmp    %eax,0x4(%ebx)
  801ec7:	73 d9                	jae    801ea2 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ec9:	8b 53 04             	mov    0x4(%ebx),%edx
  801ecc:	89 d0                	mov    %edx,%eax
  801ece:	85 d2                	test   %edx,%edx
  801ed0:	79 03                	jns    801ed5 <pipewrite+0x64>
  801ed2:	8d 42 1f             	lea    0x1f(%edx),%eax
  801ed5:	83 e0 e0             	and    $0xffffffe0,%eax
  801ed8:	29 c2                	sub    %eax,%edx
  801eda:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  801edd:	8a 04 31             	mov    (%ecx,%esi,1),%al
  801ee0:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ee4:	ff 43 04             	incl   0x4(%ebx)
  801ee7:	46                   	inc    %esi
  801ee8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eeb:	72 ab                	jb     801e98 <pipewrite+0x27>
	}
	
	return i;
  801eed:	89 f0                	mov    %esi,%eax
}
  801eef:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ef2:	5b                   	pop    %ebx
  801ef3:	5e                   	pop    %esi
  801ef4:	5f                   	pop    %edi
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	56                   	push   %esi
  801efb:	53                   	push   %ebx
  801efc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801eff:	83 ec 0c             	sub    $0xc,%esp
  801f02:	ff 75 08             	pushl  0x8(%ebp)
  801f05:	e8 b2 f0 ff ff       	call   800fbc <fd2data>
  801f0a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f0c:	83 c4 08             	add    $0x8,%esp
  801f0f:	68 2b 2a 80 00       	push   $0x802a2b
  801f14:	53                   	push   %ebx
  801f15:	e8 76 e9 ff ff       	call   800890 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f1a:	8b 46 04             	mov    0x4(%esi),%eax
  801f1d:	2b 06                	sub    (%esi),%eax
  801f1f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f25:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f2c:	00 00 00 
	stat->st_dev = &devpipe;
  801f2f:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  801f36:	60 80 00 
	return 0;
}
  801f39:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3e:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801f41:	5b                   	pop    %ebx
  801f42:	5e                   	pop    %esi
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	53                   	push   %ebx
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f4f:	53                   	push   %ebx
  801f50:	6a 00                	push   $0x0
  801f52:	e8 90 ed ff ff       	call   800ce7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f57:	89 1c 24             	mov    %ebx,(%esp)
  801f5a:	e8 5d f0 ff ff       	call   800fbc <fd2data>
  801f5f:	83 c4 08             	add    $0x8,%esp
  801f62:	50                   	push   %eax
  801f63:	6a 00                	push   $0x0
  801f65:	e8 7d ed ff ff       	call   800ce7 <sys_page_unmap>
}
  801f6a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    
	...

00801f70 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801f7c:	6a 01                	push   $0x1
  801f7e:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  801f81:	50                   	push   %eax
  801f82:	e8 19 ec ff ff       	call   800ba0 <sys_cputs>
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <getchar>:

int
getchar(void)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801f8f:	6a 01                	push   $0x1
  801f91:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  801f94:	50                   	push   %eax
  801f95:	6a 00                	push   $0x0
  801f97:	e8 35 f3 ff ff       	call   8012d1 <read>
	if (r < 0)
  801f9c:	83 c4 10             	add    $0x10,%esp
		return r;
  801f9f:	89 c2                	mov    %eax,%edx
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	78 0d                	js     801fb2 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  801fa5:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  801faa:	85 c0                	test   %eax,%eax
  801fac:	7e 04                	jle    801fb2 <getchar+0x29>
	return c;
  801fae:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  801fb2:	89 d0                	mov    %edx,%eax
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <iscons>:


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
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fbc:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801fbf:	50                   	push   %eax
  801fc0:	ff 75 08             	pushl  0x8(%ebp)
  801fc3:	e8 76 f0 ff ff       	call   80103e <fd_lookup>
  801fc8:	83 c4 10             	add    $0x10,%esp
		return r;
  801fcb:	89 c2                	mov    %eax,%edx
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	78 11                	js     801fe2 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  801fd1:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801fd4:	8b 00                	mov    (%eax),%eax
  801fd6:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  801fdc:	0f 94 c0             	sete   %al
  801fdf:	0f b6 d0             	movzbl %al,%edx
}
  801fe2:	89 d0                	mov    %edx,%eax
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <opencons>:

int
opencons(void)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801fec:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801fef:	50                   	push   %eax
  801ff0:	e8 ef ef ff ff       	call   800fe4 <fd_alloc>
  801ff5:	83 c4 10             	add    $0x10,%esp
		return r;
  801ff8:	89 c2                	mov    %eax,%edx
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	78 3c                	js     80203a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801ffe:	83 ec 04             	sub    $0x4,%esp
  802001:	68 07 04 00 00       	push   $0x407
  802006:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802009:	6a 00                	push   $0x0
  80200b:	e8 52 ec ff ff       	call   800c62 <sys_page_alloc>
  802010:	83 c4 10             	add    $0x10,%esp
		return r;
  802013:	89 c2                	mov    %eax,%edx
  802015:	85 c0                	test   %eax,%eax
  802017:	78 21                	js     80203a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802019:	a1 60 60 80 00       	mov    0x806060,%eax
  80201e:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  802021:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  802023:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802026:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80202d:	83 ec 0c             	sub    $0xc,%esp
  802030:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802033:	e8 9c ef ff ff       	call   800fd4 <fd2num>
  802038:	89 c2                	mov    %eax,%edx
}
  80203a:	89 d0                	mov    %edx,%eax
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
  802049:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80204d:	74 2a                	je     802079 <cons_read+0x3b>
  80204f:	eb 05                	jmp    802056 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802051:	e8 ed eb ff ff       	call   800c43 <sys_yield>
  802056:	e8 69 eb ff ff       	call   800bc4 <sys_cgetc>
  80205b:	89 c2                	mov    %eax,%edx
  80205d:	85 c0                	test   %eax,%eax
  80205f:	74 f0                	je     802051 <cons_read+0x13>
	if (c < 0)
  802061:	85 d2                	test   %edx,%edx
  802063:	78 14                	js     802079 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	83 fa 04             	cmp    $0x4,%edx
  80206d:	74 0a                	je     802079 <cons_read+0x3b>
	*(char*)vbuf = c;
  80206f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802072:	88 10                	mov    %dl,(%eax)
	return 1;
  802074:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	57                   	push   %edi
  80207f:	56                   	push   %esi
  802080:	53                   	push   %ebx
  802081:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  802087:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80208a:	be 00 00 00 00       	mov    $0x0,%esi
  80208f:	39 fe                	cmp    %edi,%esi
  802091:	73 3d                	jae    8020d0 <cons_write+0x55>
		m = n - tot;
  802093:	89 fb                	mov    %edi,%ebx
  802095:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  802097:	83 fb 7f             	cmp    $0x7f,%ebx
  80209a:	76 05                	jbe    8020a1 <cons_write+0x26>
			m = sizeof(buf) - 1;
  80209c:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020a1:	83 ec 04             	sub    $0x4,%esp
  8020a4:	53                   	push   %ebx
  8020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a8:	01 f0                	add    %esi,%eax
  8020aa:	50                   	push   %eax
  8020ab:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8020b1:	50                   	push   %eax
  8020b2:	e8 55 e9 ff ff       	call   800a0c <memmove>
		sys_cputs(buf, m);
  8020b7:	83 c4 08             	add    $0x8,%esp
  8020ba:	53                   	push   %ebx
  8020bb:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8020c1:	50                   	push   %eax
  8020c2:	e8 d9 ea ff ff       	call   800ba0 <sys_cputs>
  8020c7:	83 c4 10             	add    $0x10,%esp
  8020ca:	01 de                	add    %ebx,%esi
  8020cc:	39 fe                	cmp    %edi,%esi
  8020ce:	72 c3                	jb     802093 <cons_write+0x18>
	}
	return tot;
}
  8020d0:	89 f0                	mov    %esi,%eax
  8020d2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8020d5:	5b                   	pop    %ebx
  8020d6:	5e                   	pop    %esi
  8020d7:	5f                   	pop    %edi
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <cons_close>:

int
cons_close(struct Fd *fd)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020ea:	68 37 2a 80 00       	push   $0x802a37
  8020ef:	ff 75 0c             	pushl  0xc(%ebp)
  8020f2:	e8 99 e7 ff ff       	call   800890 <strcpy>
	return 0;
}
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    
	...

00802100 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	56                   	push   %esi
  802104:	53                   	push   %ebx
  802105:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210b:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80210e:	85 c0                	test   %eax,%eax
  802110:	75 12                	jne    802124 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  802112:	83 ec 0c             	sub    $0xc,%esp
  802115:	68 00 00 c0 ee       	push   $0xeec00000
  80211a:	e8 f3 ec ff ff       	call   800e12 <sys_ipc_recv>
  80211f:	83 c4 10             	add    $0x10,%esp
  802122:	eb 0c                	jmp    802130 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802124:	83 ec 0c             	sub    $0xc,%esp
  802127:	50                   	push   %eax
  802128:	e8 e5 ec ff ff       	call   800e12 <sys_ipc_recv>
  80212d:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802130:	89 c2                	mov    %eax,%edx
  802132:	85 c0                	test   %eax,%eax
  802134:	78 24                	js     80215a <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  802136:	85 db                	test   %ebx,%ebx
  802138:	74 0a                	je     802144 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  80213a:	a1 80 80 80 00       	mov    0x808080,%eax
  80213f:	8b 40 74             	mov    0x74(%eax),%eax
  802142:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802144:	85 f6                	test   %esi,%esi
  802146:	74 0a                	je     802152 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802148:	a1 80 80 80 00       	mov    0x808080,%eax
  80214d:	8b 40 78             	mov    0x78(%eax),%eax
  802150:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  802152:	a1 80 80 80 00       	mov    0x808080,%eax
  802157:	8b 50 70             	mov    0x70(%eax),%edx

}
  80215a:	89 d0                	mov    %edx,%eax
  80215c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80215f:	5b                   	pop    %ebx
  802160:	5e                   	pop    %esi
  802161:	c9                   	leave  
  802162:	c3                   	ret    

00802163 <ipc_send>:

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
  802163:	55                   	push   %ebp
  802164:	89 e5                	mov    %esp,%ebp
  802166:	57                   	push   %edi
  802167:	56                   	push   %esi
  802168:	53                   	push   %ebx
  802169:	83 ec 0c             	sub    $0xc,%esp
  80216c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80216f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802172:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802175:	85 db                	test   %ebx,%ebx
  802177:	75 0a                	jne    802183 <ipc_send+0x20>
    pg = (void *) UTOP;
  802179:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  80217e:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  802183:	56                   	push   %esi
  802184:	53                   	push   %ebx
  802185:	57                   	push   %edi
  802186:	ff 75 08             	pushl  0x8(%ebp)
  802189:	e8 61 ec ff ff       	call   800def <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802194:	75 07                	jne    80219d <ipc_send+0x3a>
      sys_yield();
  802196:	e8 a8 ea ff ff       	call   800c43 <sys_yield>
  80219b:	eb e6                	jmp    802183 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  80219d:	85 c0                	test   %eax,%eax
  80219f:	79 12                	jns    8021b3 <ipc_send+0x50>
  8021a1:	50                   	push   %eax
  8021a2:	68 3e 2a 80 00       	push   $0x802a3e
  8021a7:	6a 49                	push   $0x49
  8021a9:	68 5b 2a 80 00       	push   $0x802a5b
  8021ae:	e8 e9 df ff ff       	call   80019c <_panic>
    else break;
  }
}
  8021b3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8021b6:	5b                   	pop    %ebx
  8021b7:	5e                   	pop    %esi
  8021b8:	5f                   	pop    %edi
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    
	...

008021bc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8021c2:	89 c8                	mov    %ecx,%eax
  8021c4:	c1 e8 16             	shr    $0x16,%eax
  8021c7:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8021ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8021d3:	a8 01                	test   $0x1,%al
  8021d5:	74 28                	je     8021ff <pageref+0x43>
	pte = vpt[VPN(v)];
  8021d7:	89 c8                	mov    %ecx,%eax
  8021d9:	c1 e8 0c             	shr    $0xc,%eax
  8021dc:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  8021e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8021e8:	a8 01                	test   $0x1,%al
  8021ea:	74 13                	je     8021ff <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  8021ec:	c1 e8 0c             	shr    $0xc,%eax
  8021ef:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8021f2:	c1 e0 02             	shl    $0x2,%eax
  8021f5:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  8021fc:	0f b7 d0             	movzwl %ax,%edx
}
  8021ff:	89 d0                	mov    %edx,%eax
  802201:	c9                   	leave  
  802202:	c3                   	ret    
	...

00802204 <__udivdi3>:
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	57                   	push   %edi
  802208:	56                   	push   %esi
  802209:	83 ec 14             	sub    $0x14,%esp
  80220c:	8b 55 14             	mov    0x14(%ebp),%edx
  80220f:	8b 75 08             	mov    0x8(%ebp),%esi
  802212:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802215:	8b 45 10             	mov    0x10(%ebp),%eax
  802218:	85 d2                	test   %edx,%edx
  80221a:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  80221d:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802220:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802223:	89 fe                	mov    %edi,%esi
  802225:	75 11                	jne    802238 <__udivdi3+0x34>
  802227:	39 f8                	cmp    %edi,%eax
  802229:	76 4d                	jbe    802278 <__udivdi3+0x74>
  80222b:	89 fa                	mov    %edi,%edx
  80222d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802230:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802233:	89 c7                	mov    %eax,%edi
  802235:	eb 09                	jmp    802240 <__udivdi3+0x3c>
  802237:	90                   	nop    
  802238:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  80223b:	76 17                	jbe    802254 <__udivdi3+0x50>
  80223d:	31 ff                	xor    %edi,%edi
  80223f:	90                   	nop    
  802240:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  802247:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  80224a:	83 c4 14             	add    $0x14,%esp
  80224d:	5e                   	pop    %esi
  80224e:	89 f8                	mov    %edi,%eax
  802250:	5f                   	pop    %edi
  802251:	c9                   	leave  
  802252:	c3                   	ret    
  802253:	90                   	nop    
  802254:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802258:	89 c7                	mov    %eax,%edi
  80225a:	83 f7 1f             	xor    $0x1f,%edi
  80225d:	75 4d                	jne    8022ac <__udivdi3+0xa8>
  80225f:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802262:	77 0a                	ja     80226e <__udivdi3+0x6a>
  802264:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802267:	31 ff                	xor    %edi,%edi
  802269:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  80226c:	72 d2                	jb     802240 <__udivdi3+0x3c>
  80226e:	bf 01 00 00 00       	mov    $0x1,%edi
  802273:	eb cb                	jmp    802240 <__udivdi3+0x3c>
  802275:	8d 76 00             	lea    0x0(%esi),%esi
  802278:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80227b:	85 c0                	test   %eax,%eax
  80227d:	75 0e                	jne    80228d <__udivdi3+0x89>
  80227f:	b8 01 00 00 00       	mov    $0x1,%eax
  802284:	31 c9                	xor    %ecx,%ecx
  802286:	31 d2                	xor    %edx,%edx
  802288:	f7 f1                	div    %ecx
  80228a:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80228d:	89 f0                	mov    %esi,%eax
  80228f:	31 d2                	xor    %edx,%edx
  802291:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802294:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  802297:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80229a:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80229d:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8022a0:	83 c4 14             	add    $0x14,%esp
  8022a3:	89 c7                	mov    %eax,%edi
  8022a5:	5e                   	pop    %esi
  8022a6:	89 f8                	mov    %edi,%eax
  8022a8:	5f                   	pop    %edi
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    
  8022ab:	90                   	nop    
  8022ac:	b8 20 00 00 00       	mov    $0x20,%eax
  8022b1:	29 f8                	sub    %edi,%eax
  8022b3:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  8022b6:	89 f9                	mov    %edi,%ecx
  8022b8:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8022bb:	d3 e2                	shl    %cl,%edx
  8022bd:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8022c0:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8022c3:	d3 e8                	shr    %cl,%eax
  8022c5:	09 c2                	or     %eax,%edx
  8022c7:	89 f9                	mov    %edi,%ecx
  8022c9:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8022cc:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8022cf:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8022d2:	89 f2                	mov    %esi,%edx
  8022d4:	d3 ea                	shr    %cl,%edx
  8022d6:	89 f9                	mov    %edi,%ecx
  8022d8:	d3 e6                	shl    %cl,%esi
  8022da:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8022dd:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8022e0:	d3 e8                	shr    %cl,%eax
  8022e2:	09 c6                	or     %eax,%esi
  8022e4:	89 f9                	mov    %edi,%ecx
  8022e6:	89 f0                	mov    %esi,%eax
  8022e8:	f7 75 f4             	divl   0xfffffff4(%ebp)
  8022eb:	89 d6                	mov    %edx,%esi
  8022ed:	89 c7                	mov    %eax,%edi
  8022ef:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8022f2:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8022f5:	f7 e7                	mul    %edi
  8022f7:	39 f2                	cmp    %esi,%edx
  8022f9:	77 0f                	ja     80230a <__udivdi3+0x106>
  8022fb:	0f 85 3f ff ff ff    	jne    802240 <__udivdi3+0x3c>
  802301:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802304:	0f 86 36 ff ff ff    	jbe    802240 <__udivdi3+0x3c>
  80230a:	4f                   	dec    %edi
  80230b:	e9 30 ff ff ff       	jmp    802240 <__udivdi3+0x3c>

00802310 <__umoddi3>:
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	57                   	push   %edi
  802314:	56                   	push   %esi
  802315:	83 ec 30             	sub    $0x30,%esp
  802318:	8b 55 14             	mov    0x14(%ebp),%edx
  80231b:	8b 45 10             	mov    0x10(%ebp),%eax
  80231e:	89 d7                	mov    %edx,%edi
  802320:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  802323:	89 c6                	mov    %eax,%esi
  802325:	8b 55 0c             	mov    0xc(%ebp),%edx
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	85 ff                	test   %edi,%edi
  80232d:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802334:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80233b:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  80233e:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802341:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802344:	75 3e                	jne    802384 <__umoddi3+0x74>
  802346:	39 d6                	cmp    %edx,%esi
  802348:	0f 86 a2 00 00 00    	jbe    8023f0 <__umoddi3+0xe0>
  80234e:	f7 f6                	div    %esi
  802350:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802353:	85 c9                	test   %ecx,%ecx
  802355:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802358:	74 1b                	je     802375 <__umoddi3+0x65>
  80235a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80235d:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802360:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802367:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80236a:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  80236d:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802370:	89 10                	mov    %edx,(%eax)
  802372:	89 48 04             	mov    %ecx,0x4(%eax)
  802375:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802378:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80237b:	83 c4 30             	add    $0x30,%esp
  80237e:	5e                   	pop    %esi
  80237f:	5f                   	pop    %edi
  802380:	c9                   	leave  
  802381:	c3                   	ret    
  802382:	89 f6                	mov    %esi,%esi
  802384:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  802387:	76 1f                	jbe    8023a8 <__umoddi3+0x98>
  802389:	8b 55 08             	mov    0x8(%ebp),%edx
  80238c:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  80238f:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802392:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802395:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802398:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80239b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  80239e:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8023a1:	83 c4 30             	add    $0x30,%esp
  8023a4:	5e                   	pop    %esi
  8023a5:	5f                   	pop    %edi
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    
  8023a8:	0f bd c7             	bsr    %edi,%eax
  8023ab:	83 f0 1f             	xor    $0x1f,%eax
  8023ae:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  8023b1:	75 61                	jne    802414 <__umoddi3+0x104>
  8023b3:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  8023b6:	77 05                	ja     8023bd <__umoddi3+0xad>
  8023b8:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  8023bb:	72 10                	jb     8023cd <__umoddi3+0xbd>
  8023bd:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8023c0:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8023c3:	29 f0                	sub    %esi,%eax
  8023c5:	19 fa                	sbb    %edi,%edx
  8023c7:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8023ca:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8023cd:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8023d0:	85 d2                	test   %edx,%edx
  8023d2:	74 a1                	je     802375 <__umoddi3+0x65>
  8023d4:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8023d7:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8023da:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8023dd:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  8023e0:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8023e3:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8023e6:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8023e9:	89 01                	mov    %eax,(%ecx)
  8023eb:	89 51 04             	mov    %edx,0x4(%ecx)
  8023ee:	eb 85                	jmp    802375 <__umoddi3+0x65>
  8023f0:	85 f6                	test   %esi,%esi
  8023f2:	75 0b                	jne    8023ff <__umoddi3+0xef>
  8023f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f9:	31 d2                	xor    %edx,%edx
  8023fb:	f7 f6                	div    %esi
  8023fd:	89 c6                	mov    %eax,%esi
  8023ff:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802402:	89 fa                	mov    %edi,%edx
  802404:	f7 f6                	div    %esi
  802406:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802409:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80240c:	f7 f6                	div    %esi
  80240e:	e9 3d ff ff ff       	jmp    802350 <__umoddi3+0x40>
  802413:	90                   	nop    
  802414:	b8 20 00 00 00       	mov    $0x20,%eax
  802419:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  80241c:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  80241f:	89 fa                	mov    %edi,%edx
  802421:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802424:	d3 e2                	shl    %cl,%edx
  802426:	89 f0                	mov    %esi,%eax
  802428:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80242b:	d3 e8                	shr    %cl,%eax
  80242d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802430:	d3 e6                	shl    %cl,%esi
  802432:	89 d7                	mov    %edx,%edi
  802434:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802437:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80243a:	09 c7                	or     %eax,%edi
  80243c:	d3 ea                	shr    %cl,%edx
  80243e:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802441:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802444:	d3 e0                	shl    %cl,%eax
  802446:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802449:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80244c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80244f:	d3 e8                	shr    %cl,%eax
  802451:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802454:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802457:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80245a:	f7 f7                	div    %edi
  80245c:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80245f:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802462:	f7 e6                	mul    %esi
  802464:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  802467:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  80246a:	77 0a                	ja     802476 <__umoddi3+0x166>
  80246c:	75 12                	jne    802480 <__umoddi3+0x170>
  80246e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802471:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802474:	76 0a                	jbe    802480 <__umoddi3+0x170>
  802476:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802479:	29 f1                	sub    %esi,%ecx
  80247b:	19 fa                	sbb    %edi,%edx
  80247d:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802480:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802483:	85 c0                	test   %eax,%eax
  802485:	0f 84 ea fe ff ff    	je     802375 <__umoddi3+0x65>
  80248b:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  80248e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802491:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802494:	19 d1                	sbb    %edx,%ecx
  802496:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  802499:	89 ca                	mov    %ecx,%edx
  80249b:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80249e:	d3 e2                	shl    %cl,%edx
  8024a0:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8024a3:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8024a6:	d3 e8                	shr    %cl,%eax
  8024a8:	09 c2                	or     %eax,%edx
  8024aa:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8024ad:	d3 e8                	shr    %cl,%eax
  8024af:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8024b2:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8024b5:	e9 ad fe ff ff       	jmp    802367 <__umoddi3+0x57>
