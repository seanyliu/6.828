
obj/user/hello:     file format elf32-i386

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
  80002c:	e8 2b 00 00 00       	call   80005c <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
#include <inc/lib.h>

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  80003a:	68 e0 23 80 00       	push   $0x8023e0
  80003f:	e8 04 01 00 00       	call   800148 <cprintf>
	cprintf("i am environment %08x\n", env->env_id);
  800044:	83 c4 08             	add    $0x8,%esp
  800047:	a1 80 60 80 00       	mov    0x806080,%eax
  80004c:	8b 40 4c             	mov    0x4c(%eax),%eax
  80004f:	50                   	push   %eax
  800050:	68 ee 23 80 00       	push   $0x8023ee
  800055:	e8 ee 00 00 00       	call   800148 <cprintf>
}
  80005a:	c9                   	leave  
  80005b:	c3                   	ret    

0080005c <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	56                   	push   %esi
  800060:	53                   	push   %ebx
  800061:	8b 75 08             	mov    0x8(%ebp),%esi
  800064:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  800067:	e8 74 0a 00 00       	call   800ae0 <sys_getenvid>
  80006c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800071:	c1 e0 07             	shl    $0x7,%eax
  800074:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800079:	a3 80 60 80 00       	mov    %eax,0x806080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007e:	85 f6                	test   %esi,%esi
  800080:	7e 07                	jle    800089 <libmain+0x2d>
		binaryname = argv[0];
  800082:	8b 03                	mov    (%ebx),%eax
  800084:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	53                   	push   %ebx
  80008d:	56                   	push   %esi
  80008e:	e8 a1 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800093:	e8 08 00 00 00       	call   8000a0 <exit>
}
  800098:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80009b:	5b                   	pop    %ebx
  80009c:	5e                   	pop    %esi
  80009d:	c9                   	leave  
  80009e:	c3                   	ret    
	...

008000a0 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a6:	e8 9d 0f 00 00       	call   801048 <close_all>
	sys_env_destroy(0);
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	6a 00                	push   $0x0
  8000b0:	e8 ea 09 00 00       	call   800a9f <sys_env_destroy>
}
  8000b5:	c9                   	leave  
  8000b6:	c3                   	ret    
	...

008000b8 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	53                   	push   %ebx
  8000bc:	83 ec 04             	sub    $0x4,%esp
  8000bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000c2:	8b 03                	mov    (%ebx),%eax
  8000c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c7:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  8000cb:	40                   	inc    %eax
  8000cc:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8000ce:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d3:	75 1a                	jne    8000ef <putch+0x37>
		sys_cputs(b->buf, b->idx);
  8000d5:	83 ec 08             	sub    $0x8,%esp
  8000d8:	68 ff 00 00 00       	push   $0xff
  8000dd:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e0:	50                   	push   %eax
  8000e1:	e8 76 09 00 00       	call   800a5c <sys_cputs>
		b->idx = 0;
  8000e6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000ec:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8000ef:	ff 43 04             	incl   0x4(%ebx)
}
  8000f2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8000f5:	c9                   	leave  
  8000f6:	c3                   	ret    

008000f7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800100:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  800107:	00 00 00 
	b.cnt = 0;
  80010a:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800111:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800114:	ff 75 0c             	pushl  0xc(%ebp)
  800117:	ff 75 08             	pushl  0x8(%ebp)
  80011a:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800120:	50                   	push   %eax
  800121:	68 b8 00 80 00       	push   $0x8000b8
  800126:	e8 4f 01 00 00       	call   80027a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80012b:	83 c4 08             	add    $0x8,%esp
  80012e:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  800134:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	e8 1c 09 00 00       	call   800a5c <sys_cputs>

	return b.cnt;
  800140:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80014e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800151:	50                   	push   %eax
  800152:	ff 75 08             	pushl  0x8(%ebp)
  800155:	e8 9d ff ff ff       	call   8000f7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	57                   	push   %edi
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	8b 75 10             	mov    0x10(%ebp),%esi
  800168:	8b 7d 14             	mov    0x14(%ebp),%edi
  80016b:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80016e:	8b 45 18             	mov    0x18(%ebp),%eax
  800171:	ba 00 00 00 00       	mov    $0x0,%edx
  800176:	39 fa                	cmp    %edi,%edx
  800178:	77 39                	ja     8001b3 <printnum+0x57>
  80017a:	72 04                	jb     800180 <printnum+0x24>
  80017c:	39 f0                	cmp    %esi,%eax
  80017e:	77 33                	ja     8001b3 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800180:	83 ec 04             	sub    $0x4,%esp
  800183:	ff 75 20             	pushl  0x20(%ebp)
  800186:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  800189:	50                   	push   %eax
  80018a:	ff 75 18             	pushl  0x18(%ebp)
  80018d:	8b 45 18             	mov    0x18(%ebp),%eax
  800190:	ba 00 00 00 00       	mov    $0x0,%edx
  800195:	52                   	push   %edx
  800196:	50                   	push   %eax
  800197:	57                   	push   %edi
  800198:	56                   	push   %esi
  800199:	e8 82 1f 00 00       	call   802120 <__udivdi3>
  80019e:	83 c4 10             	add    $0x10,%esp
  8001a1:	52                   	push   %edx
  8001a2:	50                   	push   %eax
  8001a3:	ff 75 0c             	pushl  0xc(%ebp)
  8001a6:	ff 75 08             	pushl  0x8(%ebp)
  8001a9:	e8 ae ff ff ff       	call   80015c <printnum>
  8001ae:	83 c4 20             	add    $0x20,%esp
  8001b1:	eb 19                	jmp    8001cc <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001b3:	4b                   	dec    %ebx
  8001b4:	85 db                	test   %ebx,%ebx
  8001b6:	7e 14                	jle    8001cc <printnum+0x70>
  8001b8:	83 ec 08             	sub    $0x8,%esp
  8001bb:	ff 75 0c             	pushl  0xc(%ebp)
  8001be:	ff 75 20             	pushl  0x20(%ebp)
  8001c1:	ff 55 08             	call   *0x8(%ebp)
  8001c4:	83 c4 10             	add    $0x10,%esp
  8001c7:	4b                   	dec    %ebx
  8001c8:	85 db                	test   %ebx,%ebx
  8001ca:	7f ec                	jg     8001b8 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8001d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001da:	83 ec 04             	sub    $0x4,%esp
  8001dd:	52                   	push   %edx
  8001de:	50                   	push   %eax
  8001df:	57                   	push   %edi
  8001e0:	56                   	push   %esi
  8001e1:	e8 46 20 00 00       	call   80222c <__umoddi3>
  8001e6:	83 c4 14             	add    $0x14,%esp
  8001e9:	0f be 80 16 25 80 00 	movsbl 0x802516(%eax),%eax
  8001f0:	50                   	push   %eax
  8001f1:	ff 55 08             	call   *0x8(%ebp)
}
  8001f4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8001f7:	5b                   	pop    %ebx
  8001f8:	5e                   	pop    %esi
  8001f9:	5f                   	pop    %edi
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800202:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800205:	83 f8 01             	cmp    $0x1,%eax
  800208:	7e 0f                	jle    800219 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  80020a:	8b 01                	mov    (%ecx),%eax
  80020c:	83 c0 08             	add    $0x8,%eax
  80020f:	89 01                	mov    %eax,(%ecx)
  800211:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800214:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  800217:	eb 24                	jmp    80023d <getuint+0x41>
	else if (lflag)
  800219:	85 c0                	test   %eax,%eax
  80021b:	74 11                	je     80022e <getuint+0x32>
		return va_arg(*ap, unsigned long);
  80021d:	8b 01                	mov    (%ecx),%eax
  80021f:	83 c0 04             	add    $0x4,%eax
  800222:	89 01                	mov    %eax,(%ecx)
  800224:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800227:	ba 00 00 00 00       	mov    $0x0,%edx
  80022c:	eb 0f                	jmp    80023d <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  80022e:	8b 01                	mov    (%ecx),%eax
  800230:	83 c0 04             	add    $0x4,%eax
  800233:	89 01                	mov    %eax,(%ecx)
  800235:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800238:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80023d:	c9                   	leave  
  80023e:	c3                   	ret    

0080023f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	8b 55 08             	mov    0x8(%ebp),%edx
  800245:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800248:	83 f8 01             	cmp    $0x1,%eax
  80024b:	7e 0f                	jle    80025c <getint+0x1d>
		return va_arg(*ap, long long);
  80024d:	8b 02                	mov    (%edx),%eax
  80024f:	83 c0 08             	add    $0x8,%eax
  800252:	89 02                	mov    %eax,(%edx)
  800254:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800257:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80025a:	eb 1c                	jmp    800278 <getint+0x39>
	else if (lflag)
  80025c:	85 c0                	test   %eax,%eax
  80025e:	74 0d                	je     80026d <getint+0x2e>
		return va_arg(*ap, long);
  800260:	8b 02                	mov    (%edx),%eax
  800262:	83 c0 04             	add    $0x4,%eax
  800265:	89 02                	mov    %eax,(%edx)
  800267:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80026a:	99                   	cltd   
  80026b:	eb 0b                	jmp    800278 <getint+0x39>
	else
		return va_arg(*ap, int);
  80026d:	8b 02                	mov    (%edx),%eax
  80026f:	83 c0 04             	add    $0x4,%eax
  800272:	89 02                	mov    %eax,(%edx)
  800274:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800277:	99                   	cltd   
}
  800278:	c9                   	leave  
  800279:	c3                   	ret    

0080027a <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	57                   	push   %edi
  80027e:	56                   	push   %esi
  80027f:	53                   	push   %ebx
  800280:	83 ec 1c             	sub    $0x1c,%esp
  800283:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  800286:	0f b6 13             	movzbl (%ebx),%edx
  800289:	43                   	inc    %ebx
  80028a:	83 fa 25             	cmp    $0x25,%edx
  80028d:	74 1e                	je     8002ad <vprintfmt+0x33>
  80028f:	85 d2                	test   %edx,%edx
  800291:	0f 84 d7 02 00 00    	je     80056e <vprintfmt+0x2f4>
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	ff 75 0c             	pushl  0xc(%ebp)
  80029d:	52                   	push   %edx
  80029e:	ff 55 08             	call   *0x8(%ebp)
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	0f b6 13             	movzbl (%ebx),%edx
  8002a7:	43                   	inc    %ebx
  8002a8:	83 fa 25             	cmp    $0x25,%edx
  8002ab:	75 e2                	jne    80028f <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  8002ad:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  8002b1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  8002b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  8002bd:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  8002c2:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8002c9:	0f b6 13             	movzbl (%ebx),%edx
  8002cc:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  8002cf:	43                   	inc    %ebx
  8002d0:	83 f8 55             	cmp    $0x55,%eax
  8002d3:	0f 87 70 02 00 00    	ja     800549 <vprintfmt+0x2cf>
  8002d9:	ff 24 85 9c 25 80 00 	jmp    *0x80259c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  8002e0:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  8002e4:	eb e3                	jmp    8002c9 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8002e6:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  8002ea:	eb dd                	jmp    8002c9 <vprintfmt+0x4f>

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
  8002ec:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  8002f1:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  8002f4:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  8002f8:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  8002fb:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  8002fe:	83 f8 09             	cmp    $0x9,%eax
  800301:	77 27                	ja     80032a <vprintfmt+0xb0>
  800303:	43                   	inc    %ebx
  800304:	eb eb                	jmp    8002f1 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800306:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80030a:	8b 45 14             	mov    0x14(%ebp),%eax
  80030d:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800310:	eb 18                	jmp    80032a <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  800312:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800316:	79 b1                	jns    8002c9 <vprintfmt+0x4f>
				width = 0;
  800318:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  80031f:	eb a8                	jmp    8002c9 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800321:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  800328:	eb 9f                	jmp    8002c9 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  80032a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80032e:	79 99                	jns    8002c9 <vprintfmt+0x4f>
				width = precision, precision = -1;
  800330:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  800333:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  800338:	eb 8f                	jmp    8002c9 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80033a:	41                   	inc    %ecx
			goto reswitch;
  80033b:	eb 8c                	jmp    8002c9 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80033d:	83 ec 08             	sub    $0x8,%esp
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800347:	8b 45 14             	mov    0x14(%ebp),%eax
  80034a:	ff 70 fc             	pushl  0xfffffffc(%eax)
  80034d:	ff 55 08             	call   *0x8(%ebp)
			break;
  800350:	83 c4 10             	add    $0x10,%esp
  800353:	e9 2e ff ff ff       	jmp    800286 <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800358:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80035c:	8b 45 14             	mov    0x14(%ebp),%eax
  80035f:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  800362:	85 c0                	test   %eax,%eax
  800364:	79 02                	jns    800368 <vprintfmt+0xee>
				err = -err;
  800366:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800368:	83 f8 0e             	cmp    $0xe,%eax
  80036b:	7f 0b                	jg     800378 <vprintfmt+0xfe>
  80036d:	8b 3c 85 60 25 80 00 	mov    0x802560(,%eax,4),%edi
  800374:	85 ff                	test   %edi,%edi
  800376:	75 19                	jne    800391 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  800378:	50                   	push   %eax
  800379:	68 27 25 80 00       	push   $0x802527
  80037e:	ff 75 0c             	pushl  0xc(%ebp)
  800381:	ff 75 08             	pushl  0x8(%ebp)
  800384:	e8 ed 01 00 00       	call   800576 <printfmt>
  800389:	83 c4 10             	add    $0x10,%esp
  80038c:	e9 f5 fe ff ff       	jmp    800286 <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800391:	57                   	push   %edi
  800392:	68 a1 28 80 00       	push   $0x8028a1
  800397:	ff 75 0c             	pushl  0xc(%ebp)
  80039a:	ff 75 08             	pushl  0x8(%ebp)
  80039d:	e8 d4 01 00 00       	call   800576 <printfmt>
  8003a2:	83 c4 10             	add    $0x10,%esp
			break;
  8003a5:	e9 dc fe ff ff       	jmp    800286 <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8003aa:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8003ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b1:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  8003b4:	85 ff                	test   %edi,%edi
  8003b6:	75 05                	jne    8003bd <vprintfmt+0x143>
				p = "(null)";
  8003b8:	bf 30 25 80 00       	mov    $0x802530,%edi
			if (width > 0 && padc != '-')
  8003bd:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8003c1:	7e 3b                	jle    8003fe <vprintfmt+0x184>
  8003c3:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  8003c7:	74 35                	je     8003fe <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003c9:	83 ec 08             	sub    $0x8,%esp
  8003cc:	56                   	push   %esi
  8003cd:	57                   	push   %edi
  8003ce:	e8 56 03 00 00       	call   800729 <strnlen>
  8003d3:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  8003d6:	83 c4 10             	add    $0x10,%esp
  8003d9:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8003dd:	7e 1f                	jle    8003fe <vprintfmt+0x184>
  8003df:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8003e3:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  8003e6:	83 ec 08             	sub    $0x8,%esp
  8003e9:	ff 75 0c             	pushl  0xc(%ebp)
  8003ec:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  8003ef:	ff 55 08             	call   *0x8(%ebp)
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8003f8:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8003fc:	7f e8                	jg     8003e6 <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8003fe:	0f be 17             	movsbl (%edi),%edx
  800401:	47                   	inc    %edi
  800402:	85 d2                	test   %edx,%edx
  800404:	74 44                	je     80044a <vprintfmt+0x1d0>
  800406:	85 f6                	test   %esi,%esi
  800408:	78 03                	js     80040d <vprintfmt+0x193>
  80040a:	4e                   	dec    %esi
  80040b:	78 3d                	js     80044a <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  80040d:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800411:	74 18                	je     80042b <vprintfmt+0x1b1>
  800413:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  800416:	83 f8 5e             	cmp    $0x5e,%eax
  800419:	76 10                	jbe    80042b <vprintfmt+0x1b1>
					putch('?', putdat);
  80041b:	83 ec 08             	sub    $0x8,%esp
  80041e:	ff 75 0c             	pushl  0xc(%ebp)
  800421:	6a 3f                	push   $0x3f
  800423:	ff 55 08             	call   *0x8(%ebp)
  800426:	83 c4 10             	add    $0x10,%esp
  800429:	eb 0d                	jmp    800438 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  80042b:	83 ec 08             	sub    $0x8,%esp
  80042e:	ff 75 0c             	pushl  0xc(%ebp)
  800431:	52                   	push   %edx
  800432:	ff 55 08             	call   *0x8(%ebp)
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80043b:	0f be 17             	movsbl (%edi),%edx
  80043e:	47                   	inc    %edi
  80043f:	85 d2                	test   %edx,%edx
  800441:	74 07                	je     80044a <vprintfmt+0x1d0>
  800443:	85 f6                	test   %esi,%esi
  800445:	78 c6                	js     80040d <vprintfmt+0x193>
  800447:	4e                   	dec    %esi
  800448:	79 c3                	jns    80040d <vprintfmt+0x193>
			for (; width > 0; width--)
  80044a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80044e:	0f 8e 32 fe ff ff    	jle    800286 <vprintfmt+0xc>
				putch(' ', putdat);
  800454:	83 ec 08             	sub    $0x8,%esp
  800457:	ff 75 0c             	pushl  0xc(%ebp)
  80045a:	6a 20                	push   $0x20
  80045c:	ff 55 08             	call   *0x8(%ebp)
  80045f:	83 c4 10             	add    $0x10,%esp
  800462:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800465:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800469:	7f e9                	jg     800454 <vprintfmt+0x1da>
			break;
  80046b:	e9 16 fe ff ff       	jmp    800286 <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800470:	51                   	push   %ecx
  800471:	8d 45 14             	lea    0x14(%ebp),%eax
  800474:	50                   	push   %eax
  800475:	e8 c5 fd ff ff       	call   80023f <getint>
  80047a:	89 c6                	mov    %eax,%esi
  80047c:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  80047e:	83 c4 08             	add    $0x8,%esp
  800481:	85 d2                	test   %edx,%edx
  800483:	79 15                	jns    80049a <vprintfmt+0x220>
				putch('-', putdat);
  800485:	83 ec 08             	sub    $0x8,%esp
  800488:	ff 75 0c             	pushl  0xc(%ebp)
  80048b:	6a 2d                	push   $0x2d
  80048d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800490:	f7 de                	neg    %esi
  800492:	83 d7 00             	adc    $0x0,%edi
  800495:	f7 df                	neg    %edi
  800497:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80049a:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  80049f:	eb 75                	jmp    800516 <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8004a1:	51                   	push   %ecx
  8004a2:	8d 45 14             	lea    0x14(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 51 fd ff ff       	call   8001fc <getuint>
  8004ab:	89 c6                	mov    %eax,%esi
  8004ad:	89 d7                	mov    %edx,%edi
			base = 10;
  8004af:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8004b4:	83 c4 08             	add    $0x8,%esp
  8004b7:	eb 5d                	jmp    800516 <vprintfmt+0x29c>

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
  8004b9:	51                   	push   %ecx
  8004ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8004bd:	50                   	push   %eax
  8004be:	e8 39 fd ff ff       	call   8001fc <getuint>
  8004c3:	89 c6                	mov    %eax,%esi
  8004c5:	89 d7                	mov    %edx,%edi
			base = 8;
  8004c7:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  8004cc:	83 c4 08             	add    $0x8,%esp
  8004cf:	eb 45                	jmp    800516 <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  8004d1:	83 ec 08             	sub    $0x8,%esp
  8004d4:	ff 75 0c             	pushl  0xc(%ebp)
  8004d7:	6a 30                	push   $0x30
  8004d9:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8004dc:	83 c4 08             	add    $0x8,%esp
  8004df:	ff 75 0c             	pushl  0xc(%ebp)
  8004e2:	6a 78                	push   $0x78
  8004e4:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  8004e7:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  8004f1:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8004f6:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  8004fb:	83 c4 10             	add    $0x10,%esp
  8004fe:	eb 16                	jmp    800516 <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800500:	51                   	push   %ecx
  800501:	8d 45 14             	lea    0x14(%ebp),%eax
  800504:	50                   	push   %eax
  800505:	e8 f2 fc ff ff       	call   8001fc <getuint>
  80050a:	89 c6                	mov    %eax,%esi
  80050c:	89 d7                	mov    %edx,%edi
			base = 16;
  80050e:	ba 10 00 00 00       	mov    $0x10,%edx
  800513:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  800516:	83 ec 04             	sub    $0x4,%esp
  800519:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  80051d:	50                   	push   %eax
  80051e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800521:	52                   	push   %edx
  800522:	57                   	push   %edi
  800523:	56                   	push   %esi
  800524:	ff 75 0c             	pushl  0xc(%ebp)
  800527:	ff 75 08             	pushl  0x8(%ebp)
  80052a:	e8 2d fc ff ff       	call   80015c <printnum>
			break;
  80052f:	83 c4 20             	add    $0x20,%esp
  800532:	e9 4f fd ff ff       	jmp    800286 <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800537:	83 ec 08             	sub    $0x8,%esp
  80053a:	ff 75 0c             	pushl  0xc(%ebp)
  80053d:	52                   	push   %edx
  80053e:	ff 55 08             	call   *0x8(%ebp)
			break;
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	e9 3d fd ff ff       	jmp    800286 <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 0c             	pushl  0xc(%ebp)
  80054f:	6a 25                	push   $0x25
  800551:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800554:	4b                   	dec    %ebx
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  80055c:	0f 84 24 fd ff ff    	je     800286 <vprintfmt+0xc>
  800562:	4b                   	dec    %ebx
  800563:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800567:	75 f9                	jne    800562 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  800569:	e9 18 fd ff ff       	jmp    800286 <vprintfmt+0xc>
		}
	}
}
  80056e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800571:	5b                   	pop    %ebx
  800572:	5e                   	pop    %esi
  800573:	5f                   	pop    %edi
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  80057c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80057f:	50                   	push   %eax
  800580:	ff 75 10             	pushl  0x10(%ebp)
  800583:	ff 75 0c             	pushl  0xc(%ebp)
  800586:	ff 75 08             	pushl  0x8(%ebp)
  800589:	e8 ec fc ff ff       	call   80027a <vprintfmt>
	va_end(ap);
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  800596:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  800599:	8b 0a                	mov    (%edx),%ecx
  80059b:	3b 4a 04             	cmp    0x4(%edx),%ecx
  80059e:	73 07                	jae    8005a7 <sprintputch+0x17>
		*b->buf++ = ch;
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	88 01                	mov    %al,(%ecx)
  8005a5:	ff 02                	incl   (%edx)
}
  8005a7:	c9                   	leave  
  8005a8:	c3                   	ret    

008005a9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8005a9:	55                   	push   %ebp
  8005aa:	89 e5                	mov    %esp,%ebp
  8005ac:	83 ec 18             	sub    $0x18,%esp
  8005af:	8b 55 08             	mov    0x8(%ebp),%edx
  8005b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8005b5:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  8005b8:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  8005bc:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8005bf:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  8005c6:	85 d2                	test   %edx,%edx
  8005c8:	74 04                	je     8005ce <vsnprintf+0x25>
  8005ca:	85 c9                	test   %ecx,%ecx
  8005cc:	7f 07                	jg     8005d5 <vsnprintf+0x2c>
		return -E_INVAL;
  8005ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8005d3:	eb 1d                	jmp    8005f2 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8005d5:	ff 75 14             	pushl  0x14(%ebp)
  8005d8:	ff 75 10             	pushl  0x10(%ebp)
  8005db:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	68 90 05 80 00       	push   $0x800590
  8005e4:	e8 91 fc ff ff       	call   80027a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8005e9:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  8005ec:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8005ef:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8005fa:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8005fd:	50                   	push   %eax
  8005fe:	ff 75 10             	pushl  0x10(%ebp)
  800601:	ff 75 0c             	pushl  0xc(%ebp)
  800604:	ff 75 08             	pushl  0x8(%ebp)
  800607:	e8 9d ff ff ff       	call   8005a9 <vsnprintf>
	va_end(ap);

	return rc;
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    
	...

00800610 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800610:	55                   	push   %ebp
  800611:	89 e5                	mov    %esp,%ebp
  800613:	56                   	push   %esi
  800614:	53                   	push   %ebx
  800615:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800618:	83 ec 0c             	sub    $0xc,%esp
  80061b:	56                   	push   %esi
  80061c:	e8 ef 00 00 00       	call   800710 <strlen>
  char letter;
  int hexnum = 0;
  800621:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  800626:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  80062b:	83 c4 10             	add    $0x10,%esp
  80062e:	89 c2                	mov    %eax,%edx
  800630:	4a                   	dec    %edx
  800631:	0f 88 d0 00 00 00    	js     800707 <strtoint+0xf7>
    letter = string[cidx];
  800637:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  80063a:	85 d2                	test   %edx,%edx
  80063c:	75 12                	jne    800650 <strtoint+0x40>
      if (letter != '0') {
  80063e:	3c 30                	cmp    $0x30,%al
  800640:	0f 84 ba 00 00 00    	je     800700 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800646:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80064b:	e9 b9 00 00 00       	jmp    800709 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800650:	83 fa 01             	cmp    $0x1,%edx
  800653:	75 12                	jne    800667 <strtoint+0x57>
      if (letter != 'x') {
  800655:	3c 78                	cmp    $0x78,%al
  800657:	0f 84 a3 00 00 00    	je     800700 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80065d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800662:	e9 a2 00 00 00       	jmp    800709 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  800667:	0f be c0             	movsbl %al,%eax
  80066a:	83 e8 30             	sub    $0x30,%eax
  80066d:	83 f8 36             	cmp    $0x36,%eax
  800670:	0f 87 80 00 00 00    	ja     8006f6 <strtoint+0xe6>
  800676:	ff 24 85 f4 26 80 00 	jmp    *0x8026f4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  80067d:	01 cb                	add    %ecx,%ebx
          break;
  80067f:	eb 7c                	jmp    8006fd <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800681:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  800684:	eb 77                	jmp    8006fd <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  800686:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800689:	01 c3                	add    %eax,%ebx
          break;
  80068b:	eb 70                	jmp    8006fd <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  80068d:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800690:	eb 6b                	jmp    8006fd <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  800692:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800695:	01 c3                	add    %eax,%ebx
          break;
  800697:	eb 64                	jmp    8006fd <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  800699:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80069c:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  80069f:	eb 5c                	jmp    8006fd <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  8006a1:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8006a8:	29 c8                	sub    %ecx,%eax
  8006aa:	01 c3                	add    %eax,%ebx
          break;
  8006ac:	eb 4f                	jmp    8006fd <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8006ae:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8006b1:	eb 4a                	jmp    8006fd <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8006b3:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8006b6:	01 c3                	add    %eax,%ebx
          break;
  8006b8:	eb 43                	jmp    8006fd <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8006ba:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8006bd:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8006c0:	eb 3b                	jmp    8006fd <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  8006c2:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8006c5:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  8006c8:	01 c3                	add    %eax,%ebx
          break;
  8006ca:	eb 31                	jmp    8006fd <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  8006cc:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8006cf:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  8006d2:	eb 29                	jmp    8006fd <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  8006d4:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8006d7:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  8006da:	01 c3                	add    %eax,%ebx
          break;
  8006dc:	eb 1f                	jmp    8006fd <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  8006de:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8006e5:	29 c8                	sub    %ecx,%eax
  8006e7:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8006ea:	eb 11                	jmp    8006fd <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  8006ec:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8006ef:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8006f2:	01 c3                	add    %eax,%ebx
          break;
  8006f4:	eb 07                	jmp    8006fd <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  8006f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8006fb:	eb 0c                	jmp    800709 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  8006fd:	c1 e1 04             	shl    $0x4,%ecx
  800700:	4a                   	dec    %edx
  800701:	0f 89 30 ff ff ff    	jns    800637 <strtoint+0x27>
    }
  }

  return hexnum;
  800707:	89 d8                	mov    %ebx,%eax
}
  800709:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80070c:	5b                   	pop    %ebx
  80070d:	5e                   	pop    %esi
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <strlen>:





int
strlen(const char *s)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800716:	b8 00 00 00 00       	mov    $0x0,%eax
  80071b:	80 3a 00             	cmpb   $0x0,(%edx)
  80071e:	74 07                	je     800727 <strlen+0x17>
		n++;
  800720:	40                   	inc    %eax
  800721:	42                   	inc    %edx
  800722:	80 3a 00             	cmpb   $0x0,(%edx)
  800725:	75 f9                	jne    800720 <strlen+0x10>
	return n;
}
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80072f:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800732:	b8 00 00 00 00       	mov    $0x0,%eax
  800737:	85 d2                	test   %edx,%edx
  800739:	74 0f                	je     80074a <strnlen+0x21>
  80073b:	80 39 00             	cmpb   $0x0,(%ecx)
  80073e:	74 0a                	je     80074a <strnlen+0x21>
		n++;
  800740:	40                   	inc    %eax
  800741:	41                   	inc    %ecx
  800742:	4a                   	dec    %edx
  800743:	74 05                	je     80074a <strnlen+0x21>
  800745:	80 39 00             	cmpb   $0x0,(%ecx)
  800748:	75 f6                	jne    800740 <strnlen+0x17>
	return n;
}
  80074a:	c9                   	leave  
  80074b:	c3                   	ret    

0080074c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80074c:	55                   	push   %ebp
  80074d:	89 e5                	mov    %esp,%ebp
  80074f:	53                   	push   %ebx
  800750:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800753:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  800756:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  800758:	8a 02                	mov    (%edx),%al
  80075a:	42                   	inc    %edx
  80075b:	88 01                	mov    %al,(%ecx)
  80075d:	41                   	inc    %ecx
  80075e:	84 c0                	test   %al,%al
  800760:	75 f6                	jne    800758 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800762:	89 d8                	mov    %ebx,%eax
  800764:	5b                   	pop    %ebx
  800765:	c9                   	leave  
  800766:	c3                   	ret    

00800767 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	57                   	push   %edi
  80076b:	56                   	push   %esi
  80076c:	53                   	push   %ebx
  80076d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800770:	8b 55 0c             	mov    0xc(%ebp),%edx
  800773:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  800776:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  800778:	bb 00 00 00 00       	mov    $0x0,%ebx
  80077d:	39 f3                	cmp    %esi,%ebx
  80077f:	73 10                	jae    800791 <strncpy+0x2a>
		*dst++ = *src;
  800781:	8a 02                	mov    (%edx),%al
  800783:	88 01                	mov    %al,(%ecx)
  800785:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800786:	80 3a 01             	cmpb   $0x1,(%edx)
  800789:	83 da ff             	sbb    $0xffffffff,%edx
  80078c:	43                   	inc    %ebx
  80078d:	39 f3                	cmp    %esi,%ebx
  80078f:	72 f0                	jb     800781 <strncpy+0x1a>
	}
	return ret;
}
  800791:	89 f8                	mov    %edi,%eax
  800793:	5b                   	pop    %ebx
  800794:	5e                   	pop    %esi
  800795:	5f                   	pop    %edi
  800796:	c9                   	leave  
  800797:	c3                   	ret    

00800798 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	56                   	push   %esi
  80079c:	53                   	push   %ebx
  80079d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8007a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a3:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  8007a6:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  8007a8:	85 d2                	test   %edx,%edx
  8007aa:	74 19                	je     8007c5 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007ac:	4a                   	dec    %edx
  8007ad:	74 13                	je     8007c2 <strlcpy+0x2a>
  8007af:	80 39 00             	cmpb   $0x0,(%ecx)
  8007b2:	74 0e                	je     8007c2 <strlcpy+0x2a>
  8007b4:	8a 01                	mov    (%ecx),%al
  8007b6:	41                   	inc    %ecx
  8007b7:	88 03                	mov    %al,(%ebx)
  8007b9:	43                   	inc    %ebx
  8007ba:	4a                   	dec    %edx
  8007bb:	74 05                	je     8007c2 <strlcpy+0x2a>
  8007bd:	80 39 00             	cmpb   $0x0,(%ecx)
  8007c0:	75 f2                	jne    8007b4 <strlcpy+0x1c>
		*dst = '\0';
  8007c2:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  8007c5:	89 d8                	mov    %ebx,%eax
  8007c7:	29 f0                	sub    %esi,%eax
}
  8007c9:	5b                   	pop    %ebx
  8007ca:	5e                   	pop    %esi
  8007cb:	c9                   	leave  
  8007cc:	c3                   	ret    

008007cd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007cd:	55                   	push   %ebp
  8007ce:	89 e5                	mov    %esp,%ebp
  8007d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8007d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  8007d6:	80 3a 00             	cmpb   $0x0,(%edx)
  8007d9:	74 13                	je     8007ee <strcmp+0x21>
  8007db:	8a 02                	mov    (%edx),%al
  8007dd:	3a 01                	cmp    (%ecx),%al
  8007df:	75 0d                	jne    8007ee <strcmp+0x21>
  8007e1:	42                   	inc    %edx
  8007e2:	41                   	inc    %ecx
  8007e3:	80 3a 00             	cmpb   $0x0,(%edx)
  8007e6:	74 06                	je     8007ee <strcmp+0x21>
  8007e8:	8a 02                	mov    (%edx),%al
  8007ea:	3a 01                	cmp    (%ecx),%al
  8007ec:	74 f3                	je     8007e1 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8007ee:	0f b6 02             	movzbl (%edx),%eax
  8007f1:	0f b6 11             	movzbl (%ecx),%edx
  8007f4:	29 d0                	sub    %edx,%eax
}
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	53                   	push   %ebx
  8007fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8007ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800802:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800805:	85 c9                	test   %ecx,%ecx
  800807:	74 1f                	je     800828 <strncmp+0x30>
  800809:	80 3a 00             	cmpb   $0x0,(%edx)
  80080c:	74 16                	je     800824 <strncmp+0x2c>
  80080e:	8a 02                	mov    (%edx),%al
  800810:	3a 03                	cmp    (%ebx),%al
  800812:	75 10                	jne    800824 <strncmp+0x2c>
  800814:	42                   	inc    %edx
  800815:	43                   	inc    %ebx
  800816:	49                   	dec    %ecx
  800817:	74 0f                	je     800828 <strncmp+0x30>
  800819:	80 3a 00             	cmpb   $0x0,(%edx)
  80081c:	74 06                	je     800824 <strncmp+0x2c>
  80081e:	8a 02                	mov    (%edx),%al
  800820:	3a 03                	cmp    (%ebx),%al
  800822:	74 f0                	je     800814 <strncmp+0x1c>
	if (n == 0)
  800824:	85 c9                	test   %ecx,%ecx
  800826:	75 07                	jne    80082f <strncmp+0x37>
		return 0;
  800828:	b8 00 00 00 00       	mov    $0x0,%eax
  80082d:	eb 0a                	jmp    800839 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80082f:	0f b6 12             	movzbl (%edx),%edx
  800832:	0f b6 03             	movzbl (%ebx),%eax
  800835:	29 c2                	sub    %eax,%edx
  800837:	89 d0                	mov    %edx,%eax
}
  800839:	5b                   	pop    %ebx
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    

0080083c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	8b 45 08             	mov    0x8(%ebp),%eax
  800842:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800845:	80 38 00             	cmpb   $0x0,(%eax)
  800848:	74 0a                	je     800854 <strchr+0x18>
		if (*s == c)
  80084a:	38 10                	cmp    %dl,(%eax)
  80084c:	74 0b                	je     800859 <strchr+0x1d>
  80084e:	40                   	inc    %eax
  80084f:	80 38 00             	cmpb   $0x0,(%eax)
  800852:	75 f6                	jne    80084a <strchr+0xe>
			return (char *) s;
	return 0;
  800854:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800864:	80 38 00             	cmpb   $0x0,(%eax)
  800867:	74 0a                	je     800873 <strfind+0x18>
		if (*s == c)
  800869:	38 10                	cmp    %dl,(%eax)
  80086b:	74 06                	je     800873 <strfind+0x18>
  80086d:	40                   	inc    %eax
  80086e:	80 38 00             	cmpb   $0x0,(%eax)
  800871:	75 f6                	jne    800869 <strfind+0xe>
			break;
	return (char *) s;
}
  800873:	c9                   	leave  
  800874:	c3                   	ret    

00800875 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	57                   	push   %edi
  800879:	8b 7d 08             	mov    0x8(%ebp),%edi
  80087c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  80087f:	89 f8                	mov    %edi,%eax
  800881:	85 c9                	test   %ecx,%ecx
  800883:	74 40                	je     8008c5 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800885:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80088b:	75 30                	jne    8008bd <memset+0x48>
  80088d:	f6 c1 03             	test   $0x3,%cl
  800890:	75 2b                	jne    8008bd <memset+0x48>
		c &= 0xFF;
  800892:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	c1 e0 18             	shl    $0x18,%eax
  80089f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a2:	c1 e2 10             	shl    $0x10,%edx
  8008a5:	09 d0                	or     %edx,%eax
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008aa:	c1 e2 08             	shl    $0x8,%edx
  8008ad:	09 d0                	or     %edx,%eax
  8008af:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  8008b2:	c1 e9 02             	shr    $0x2,%ecx
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	fc                   	cld    
  8008b9:	f3 ab                	repz stos %eax,%es:(%edi)
  8008bb:	eb 06                	jmp    8008c3 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c0:	fc                   	cld    
  8008c1:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8008c3:	89 f8                	mov    %edi,%eax
}
  8008c5:	5f                   	pop    %edi
  8008c6:	c9                   	leave  
  8008c7:	c3                   	ret    

008008c8 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	57                   	push   %edi
  8008cc:	56                   	push   %esi
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8008d3:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  8008d6:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  8008d8:	39 c6                	cmp    %eax,%esi
  8008da:	73 33                	jae    80090f <memmove+0x47>
  8008dc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008df:	39 c2                	cmp    %eax,%edx
  8008e1:	76 2c                	jbe    80090f <memmove+0x47>
		s += n;
  8008e3:	89 d6                	mov    %edx,%esi
		d += n;
  8008e5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008e8:	f6 c2 03             	test   $0x3,%dl
  8008eb:	75 1b                	jne    800908 <memmove+0x40>
  8008ed:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008f3:	75 13                	jne    800908 <memmove+0x40>
  8008f5:	f6 c1 03             	test   $0x3,%cl
  8008f8:	75 0e                	jne    800908 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  8008fa:	83 ef 04             	sub    $0x4,%edi
  8008fd:	83 ee 04             	sub    $0x4,%esi
  800900:	c1 e9 02             	shr    $0x2,%ecx
  800903:	fd                   	std    
  800904:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800906:	eb 27                	jmp    80092f <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800908:	4f                   	dec    %edi
  800909:	4e                   	dec    %esi
  80090a:	fd                   	std    
  80090b:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  80090d:	eb 20                	jmp    80092f <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80090f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800915:	75 15                	jne    80092c <memmove+0x64>
  800917:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80091d:	75 0d                	jne    80092c <memmove+0x64>
  80091f:	f6 c1 03             	test   $0x3,%cl
  800922:	75 08                	jne    80092c <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800924:	c1 e9 02             	shr    $0x2,%ecx
  800927:	fc                   	cld    
  800928:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  80092a:	eb 03                	jmp    80092f <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80092c:	fc                   	cld    
  80092d:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80092f:	5e                   	pop    %esi
  800930:	5f                   	pop    %edi
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <memcpy>:

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
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800936:	ff 75 10             	pushl  0x10(%ebp)
  800939:	ff 75 0c             	pushl  0xc(%ebp)
  80093c:	ff 75 08             	pushl  0x8(%ebp)
  80093f:	e8 84 ff ff ff       	call   8008c8 <memmove>
}
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  80094a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  80094d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800950:	8b 55 10             	mov    0x10(%ebp),%edx
  800953:	4a                   	dec    %edx
  800954:	83 fa ff             	cmp    $0xffffffff,%edx
  800957:	74 1a                	je     800973 <memcmp+0x2d>
  800959:	8a 01                	mov    (%ecx),%al
  80095b:	3a 03                	cmp    (%ebx),%al
  80095d:	74 0c                	je     80096b <memcmp+0x25>
  80095f:	0f b6 d0             	movzbl %al,%edx
  800962:	0f b6 03             	movzbl (%ebx),%eax
  800965:	29 c2                	sub    %eax,%edx
  800967:	89 d0                	mov    %edx,%eax
  800969:	eb 0d                	jmp    800978 <memcmp+0x32>
  80096b:	41                   	inc    %ecx
  80096c:	43                   	inc    %ebx
  80096d:	4a                   	dec    %edx
  80096e:	83 fa ff             	cmp    $0xffffffff,%edx
  800971:	75 e6                	jne    800959 <memcmp+0x13>
	}

	return 0;
  800973:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800978:	5b                   	pop    %ebx
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800984:	89 c2                	mov    %eax,%edx
  800986:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800989:	39 d0                	cmp    %edx,%eax
  80098b:	73 09                	jae    800996 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  80098d:	38 08                	cmp    %cl,(%eax)
  80098f:	74 05                	je     800996 <memfind+0x1b>
  800991:	40                   	inc    %eax
  800992:	39 d0                	cmp    %edx,%eax
  800994:	72 f7                	jb     80098d <memfind+0x12>
			break;
	return (void *) s;
}
  800996:	c9                   	leave  
  800997:	c3                   	ret    

00800998 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	57                   	push   %edi
  80099c:	56                   	push   %esi
  80099d:	53                   	push   %ebx
  80099e:	8b 55 08             	mov    0x8(%ebp),%edx
  8009a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  8009a7:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  8009ac:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  8009b1:	80 3a 20             	cmpb   $0x20,(%edx)
  8009b4:	74 05                	je     8009bb <strtol+0x23>
  8009b6:	80 3a 09             	cmpb   $0x9,(%edx)
  8009b9:	75 0b                	jne    8009c6 <strtol+0x2e>
  8009bb:	42                   	inc    %edx
  8009bc:	80 3a 20             	cmpb   $0x20,(%edx)
  8009bf:	74 fa                	je     8009bb <strtol+0x23>
  8009c1:	80 3a 09             	cmpb   $0x9,(%edx)
  8009c4:	74 f5                	je     8009bb <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  8009c6:	80 3a 2b             	cmpb   $0x2b,(%edx)
  8009c9:	75 03                	jne    8009ce <strtol+0x36>
		s++;
  8009cb:	42                   	inc    %edx
  8009cc:	eb 0b                	jmp    8009d9 <strtol+0x41>
	else if (*s == '-')
  8009ce:	80 3a 2d             	cmpb   $0x2d,(%edx)
  8009d1:	75 06                	jne    8009d9 <strtol+0x41>
		s++, neg = 1;
  8009d3:	42                   	inc    %edx
  8009d4:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009d9:	85 c9                	test   %ecx,%ecx
  8009db:	74 05                	je     8009e2 <strtol+0x4a>
  8009dd:	83 f9 10             	cmp    $0x10,%ecx
  8009e0:	75 15                	jne    8009f7 <strtol+0x5f>
  8009e2:	80 3a 30             	cmpb   $0x30,(%edx)
  8009e5:	75 10                	jne    8009f7 <strtol+0x5f>
  8009e7:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8009eb:	75 0a                	jne    8009f7 <strtol+0x5f>
		s += 2, base = 16;
  8009ed:	83 c2 02             	add    $0x2,%edx
  8009f0:	b9 10 00 00 00       	mov    $0x10,%ecx
  8009f5:	eb 14                	jmp    800a0b <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  8009f7:	85 c9                	test   %ecx,%ecx
  8009f9:	75 10                	jne    800a0b <strtol+0x73>
  8009fb:	80 3a 30             	cmpb   $0x30,(%edx)
  8009fe:	75 05                	jne    800a05 <strtol+0x6d>
		s++, base = 8;
  800a00:	42                   	inc    %edx
  800a01:	b1 08                	mov    $0x8,%cl
  800a03:	eb 06                	jmp    800a0b <strtol+0x73>
	else if (base == 0)
  800a05:	85 c9                	test   %ecx,%ecx
  800a07:	75 02                	jne    800a0b <strtol+0x73>
		base = 10;
  800a09:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a0b:	8a 02                	mov    (%edx),%al
  800a0d:	83 e8 30             	sub    $0x30,%eax
  800a10:	3c 09                	cmp    $0x9,%al
  800a12:	77 08                	ja     800a1c <strtol+0x84>
			dig = *s - '0';
  800a14:	0f be 02             	movsbl (%edx),%eax
  800a17:	83 e8 30             	sub    $0x30,%eax
  800a1a:	eb 20                	jmp    800a3c <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800a1c:	8a 02                	mov    (%edx),%al
  800a1e:	83 e8 61             	sub    $0x61,%eax
  800a21:	3c 19                	cmp    $0x19,%al
  800a23:	77 08                	ja     800a2d <strtol+0x95>
			dig = *s - 'a' + 10;
  800a25:	0f be 02             	movsbl (%edx),%eax
  800a28:	83 e8 57             	sub    $0x57,%eax
  800a2b:	eb 0f                	jmp    800a3c <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800a2d:	8a 02                	mov    (%edx),%al
  800a2f:	83 e8 41             	sub    $0x41,%eax
  800a32:	3c 19                	cmp    $0x19,%al
  800a34:	77 12                	ja     800a48 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800a36:	0f be 02             	movsbl (%edx),%eax
  800a39:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800a3c:	39 c8                	cmp    %ecx,%eax
  800a3e:	7d 08                	jge    800a48 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800a40:	42                   	inc    %edx
  800a41:	0f af d9             	imul   %ecx,%ebx
  800a44:	01 c3                	add    %eax,%ebx
  800a46:	eb c3                	jmp    800a0b <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a48:	85 f6                	test   %esi,%esi
  800a4a:	74 02                	je     800a4e <strtol+0xb6>
		*endptr = (char *) s;
  800a4c:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800a4e:	89 d8                	mov    %ebx,%eax
  800a50:	85 ff                	test   %edi,%edi
  800a52:	74 02                	je     800a56 <strtol+0xbe>
  800a54:	f7 d8                	neg    %eax
}
  800a56:	5b                   	pop    %ebx
  800a57:	5e                   	pop    %esi
  800a58:	5f                   	pop    %edi
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    
	...

00800a5c <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	57                   	push   %edi
  800a60:	56                   	push   %esi
  800a61:	53                   	push   %ebx
  800a62:	83 ec 04             	sub    $0x4,%esp
  800a65:	8b 55 08             	mov    0x8(%ebp),%edx
  800a68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a6b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a70:	89 f8                	mov    %edi,%eax
  800a72:	89 fb                	mov    %edi,%ebx
  800a74:	89 fe                	mov    %edi,%esi
  800a76:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a78:	83 c4 04             	add    $0x4,%esp
  800a7b:	5b                   	pop    %ebx
  800a7c:	5e                   	pop    %esi
  800a7d:	5f                   	pop    %edi
  800a7e:	c9                   	leave  
  800a7f:	c3                   	ret    

00800a80 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	57                   	push   %edi
  800a84:	56                   	push   %esi
  800a85:	53                   	push   %ebx
  800a86:	b8 01 00 00 00       	mov    $0x1,%eax
  800a8b:	bf 00 00 00 00       	mov    $0x0,%edi
  800a90:	89 fa                	mov    %edi,%edx
  800a92:	89 f9                	mov    %edi,%ecx
  800a94:	89 fb                	mov    %edi,%ebx
  800a96:	89 fe                	mov    %edi,%esi
  800a98:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800a9a:	5b                   	pop    %ebx
  800a9b:	5e                   	pop    %esi
  800a9c:	5f                   	pop    %edi
  800a9d:	c9                   	leave  
  800a9e:	c3                   	ret    

00800a9f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	57                   	push   %edi
  800aa3:	56                   	push   %esi
  800aa4:	53                   	push   %ebx
  800aa5:	83 ec 0c             	sub    $0xc,%esp
  800aa8:	8b 55 08             	mov    0x8(%ebp),%edx
  800aab:	b8 03 00 00 00       	mov    $0x3,%eax
  800ab0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab5:	89 f9                	mov    %edi,%ecx
  800ab7:	89 fb                	mov    %edi,%ebx
  800ab9:	89 fe                	mov    %edi,%esi
  800abb:	cd 30                	int    $0x30
  800abd:	85 c0                	test   %eax,%eax
  800abf:	7e 17                	jle    800ad8 <sys_env_destroy+0x39>
  800ac1:	83 ec 0c             	sub    $0xc,%esp
  800ac4:	50                   	push   %eax
  800ac5:	6a 03                	push   $0x3
  800ac7:	68 d0 27 80 00       	push   $0x8027d0
  800acc:	6a 23                	push   $0x23
  800ace:	68 ed 27 80 00       	push   $0x8027ed
  800ad3:	e8 e4 14 00 00       	call   801fbc <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ad8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800adb:	5b                   	pop    %ebx
  800adc:	5e                   	pop    %esi
  800add:	5f                   	pop    %edi
  800ade:	c9                   	leave  
  800adf:	c3                   	ret    

00800ae0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	57                   	push   %edi
  800ae4:	56                   	push   %esi
  800ae5:	53                   	push   %ebx
  800ae6:	b8 02 00 00 00       	mov    $0x2,%eax
  800aeb:	bf 00 00 00 00       	mov    $0x0,%edi
  800af0:	89 fa                	mov    %edi,%edx
  800af2:	89 f9                	mov    %edi,%ecx
  800af4:	89 fb                	mov    %edi,%ebx
  800af6:	89 fe                	mov    %edi,%esi
  800af8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800afa:	5b                   	pop    %ebx
  800afb:	5e                   	pop    %esi
  800afc:	5f                   	pop    %edi
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <sys_yield>:

void
sys_yield(void)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	57                   	push   %edi
  800b03:	56                   	push   %esi
  800b04:	53                   	push   %ebx
  800b05:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b0a:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0f:	89 fa                	mov    %edi,%edx
  800b11:	89 f9                	mov    %edi,%ecx
  800b13:	89 fb                	mov    %edi,%ebx
  800b15:	89 fe                	mov    %edi,%esi
  800b17:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b19:	5b                   	pop    %ebx
  800b1a:	5e                   	pop    %esi
  800b1b:	5f                   	pop    %edi
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	57                   	push   %edi
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	83 ec 0c             	sub    $0xc,%esp
  800b27:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b30:	b8 04 00 00 00       	mov    $0x4,%eax
  800b35:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3a:	89 fe                	mov    %edi,%esi
  800b3c:	cd 30                	int    $0x30
  800b3e:	85 c0                	test   %eax,%eax
  800b40:	7e 17                	jle    800b59 <sys_page_alloc+0x3b>
  800b42:	83 ec 0c             	sub    $0xc,%esp
  800b45:	50                   	push   %eax
  800b46:	6a 04                	push   $0x4
  800b48:	68 d0 27 80 00       	push   $0x8027d0
  800b4d:	6a 23                	push   $0x23
  800b4f:	68 ed 27 80 00       	push   $0x8027ed
  800b54:	e8 63 14 00 00       	call   801fbc <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b59:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800b5c:	5b                   	pop    %ebx
  800b5d:	5e                   	pop    %esi
  800b5e:	5f                   	pop    %edi
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	57                   	push   %edi
  800b65:	56                   	push   %esi
  800b66:	53                   	push   %ebx
  800b67:	83 ec 0c             	sub    $0xc,%esp
  800b6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b70:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b76:	8b 75 18             	mov    0x18(%ebp),%esi
  800b79:	b8 05 00 00 00       	mov    $0x5,%eax
  800b7e:	cd 30                	int    $0x30
  800b80:	85 c0                	test   %eax,%eax
  800b82:	7e 17                	jle    800b9b <sys_page_map+0x3a>
  800b84:	83 ec 0c             	sub    $0xc,%esp
  800b87:	50                   	push   %eax
  800b88:	6a 05                	push   $0x5
  800b8a:	68 d0 27 80 00       	push   $0x8027d0
  800b8f:	6a 23                	push   $0x23
  800b91:	68 ed 27 80 00       	push   $0x8027ed
  800b96:	e8 21 14 00 00       	call   801fbc <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b9b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	c9                   	leave  
  800ba2:	c3                   	ret    

00800ba3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	83 ec 0c             	sub    $0xc,%esp
  800bac:	8b 55 08             	mov    0x8(%ebp),%edx
  800baf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb2:	b8 06 00 00 00       	mov    $0x6,%eax
  800bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbc:	89 fb                	mov    %edi,%ebx
  800bbe:	89 fe                	mov    %edi,%esi
  800bc0:	cd 30                	int    $0x30
  800bc2:	85 c0                	test   %eax,%eax
  800bc4:	7e 17                	jle    800bdd <sys_page_unmap+0x3a>
  800bc6:	83 ec 0c             	sub    $0xc,%esp
  800bc9:	50                   	push   %eax
  800bca:	6a 06                	push   $0x6
  800bcc:	68 d0 27 80 00       	push   $0x8027d0
  800bd1:	6a 23                	push   $0x23
  800bd3:	68 ed 27 80 00       	push   $0x8027ed
  800bd8:	e8 df 13 00 00       	call   801fbc <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bdd:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	c9                   	leave  
  800be4:	c3                   	ret    

00800be5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	57                   	push   %edi
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
  800beb:	83 ec 0c             	sub    $0xc,%esp
  800bee:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf4:	b8 08 00 00 00       	mov    $0x8,%eax
  800bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfe:	89 fb                	mov    %edi,%ebx
  800c00:	89 fe                	mov    %edi,%esi
  800c02:	cd 30                	int    $0x30
  800c04:	85 c0                	test   %eax,%eax
  800c06:	7e 17                	jle    800c1f <sys_env_set_status+0x3a>
  800c08:	83 ec 0c             	sub    $0xc,%esp
  800c0b:	50                   	push   %eax
  800c0c:	6a 08                	push   $0x8
  800c0e:	68 d0 27 80 00       	push   $0x8027d0
  800c13:	6a 23                	push   $0x23
  800c15:	68 ed 27 80 00       	push   $0x8027ed
  800c1a:	e8 9d 13 00 00       	call   801fbc <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c1f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5f                   	pop    %edi
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
  800c2d:	83 ec 0c             	sub    $0xc,%esp
  800c30:	8b 55 08             	mov    0x8(%ebp),%edx
  800c33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c36:	b8 09 00 00 00       	mov    $0x9,%eax
  800c3b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c40:	89 fb                	mov    %edi,%ebx
  800c42:	89 fe                	mov    %edi,%esi
  800c44:	cd 30                	int    $0x30
  800c46:	85 c0                	test   %eax,%eax
  800c48:	7e 17                	jle    800c61 <sys_env_set_trapframe+0x3a>
  800c4a:	83 ec 0c             	sub    $0xc,%esp
  800c4d:	50                   	push   %eax
  800c4e:	6a 09                	push   $0x9
  800c50:	68 d0 27 80 00       	push   $0x8027d0
  800c55:	6a 23                	push   $0x23
  800c57:	68 ed 27 80 00       	push   $0x8027ed
  800c5c:	e8 5b 13 00 00       	call   801fbc <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c61:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
  800c6f:	83 ec 0c             	sub    $0xc,%esp
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c7d:	bf 00 00 00 00       	mov    $0x0,%edi
  800c82:	89 fb                	mov    %edi,%ebx
  800c84:	89 fe                	mov    %edi,%esi
  800c86:	cd 30                	int    $0x30
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	7e 17                	jle    800ca3 <sys_env_set_pgfault_upcall+0x3a>
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	50                   	push   %eax
  800c90:	6a 0a                	push   $0xa
  800c92:	68 d0 27 80 00       	push   $0x8027d0
  800c97:	6a 23                	push   $0x23
  800c99:	68 ed 27 80 00       	push   $0x8027ed
  800c9e:	e8 19 13 00 00       	call   801fbc <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ca3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cba:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cbd:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cc2:	be 00 00 00 00       	mov    $0x0,%esi
  800cc7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	c9                   	leave  
  800ccd:	c3                   	ret    

00800cce <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	57                   	push   %edi
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	83 ec 0c             	sub    $0xc,%esp
  800cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cda:	b8 0d 00 00 00       	mov    $0xd,%eax
  800cdf:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce4:	89 f9                	mov    %edi,%ecx
  800ce6:	89 fb                	mov    %edi,%ebx
  800ce8:	89 fe                	mov    %edi,%esi
  800cea:	cd 30                	int    $0x30
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7e 17                	jle    800d07 <sys_ipc_recv+0x39>
  800cf0:	83 ec 0c             	sub    $0xc,%esp
  800cf3:	50                   	push   %eax
  800cf4:	6a 0d                	push   $0xd
  800cf6:	68 d0 27 80 00       	push   $0x8027d0
  800cfb:	6a 23                	push   $0x23
  800cfd:	68 ed 27 80 00       	push   $0x8027ed
  800d02:	e8 b5 12 00 00       	call   801fbc <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d07:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	c9                   	leave  
  800d0e:	c3                   	ret    

00800d0f <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
  800d15:	83 ec 0c             	sub    $0xc,%esp
  800d18:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1e:	b8 10 00 00 00       	mov    $0x10,%eax
  800d23:	bf 00 00 00 00       	mov    $0x0,%edi
  800d28:	89 fb                	mov    %edi,%ebx
  800d2a:	89 fe                	mov    %edi,%esi
  800d2c:	cd 30                	int    $0x30
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7e 17                	jle    800d49 <sys_transmit_packet+0x3a>
  800d32:	83 ec 0c             	sub    $0xc,%esp
  800d35:	50                   	push   %eax
  800d36:	6a 10                	push   $0x10
  800d38:	68 d0 27 80 00       	push   $0x8027d0
  800d3d:	6a 23                	push   $0x23
  800d3f:	68 ed 27 80 00       	push   $0x8027ed
  800d44:	e8 73 12 00 00       	call   801fbc <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800d49:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	c9                   	leave  
  800d50:	c3                   	ret    

00800d51 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
  800d57:	83 ec 0c             	sub    $0xc,%esp
  800d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d60:	b8 11 00 00 00       	mov    $0x11,%eax
  800d65:	bf 00 00 00 00       	mov    $0x0,%edi
  800d6a:	89 fb                	mov    %edi,%ebx
  800d6c:	89 fe                	mov    %edi,%esi
  800d6e:	cd 30                	int    $0x30
  800d70:	85 c0                	test   %eax,%eax
  800d72:	7e 17                	jle    800d8b <sys_receive_packet+0x3a>
  800d74:	83 ec 0c             	sub    $0xc,%esp
  800d77:	50                   	push   %eax
  800d78:	6a 11                	push   $0x11
  800d7a:	68 d0 27 80 00       	push   $0x8027d0
  800d7f:	6a 23                	push   $0x23
  800d81:	68 ed 27 80 00       	push   $0x8027ed
  800d86:	e8 31 12 00 00       	call   801fbc <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800d8b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d9e:	bf 00 00 00 00       	mov    $0x0,%edi
  800da3:	89 fa                	mov    %edi,%edx
  800da5:	89 f9                	mov    %edi,%ecx
  800da7:	89 fb                	mov    %edi,%ebx
  800da9:	89 fe                	mov    %edi,%esi
  800dab:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 0c             	sub    $0xc,%esp
  800dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbe:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dc3:	bf 00 00 00 00       	mov    $0x0,%edi
  800dc8:	89 f9                	mov    %edi,%ecx
  800dca:	89 fb                	mov    %edi,%ebx
  800dcc:	89 fe                	mov    %edi,%esi
  800dce:	cd 30                	int    $0x30
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	7e 17                	jle    800deb <sys_map_receive_buffers+0x39>
  800dd4:	83 ec 0c             	sub    $0xc,%esp
  800dd7:	50                   	push   %eax
  800dd8:	6a 0e                	push   $0xe
  800dda:	68 d0 27 80 00       	push   $0x8027d0
  800ddf:	6a 23                	push   $0x23
  800de1:	68 ed 27 80 00       	push   $0x8027ed
  800de6:	e8 d1 11 00 00       	call   801fbc <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800deb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	c9                   	leave  
  800df2:	c3                   	ret    

00800df3 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 0c             	sub    $0xc,%esp
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	b8 12 00 00 00       	mov    $0x12,%eax
  800e04:	bf 00 00 00 00       	mov    $0x0,%edi
  800e09:	89 f9                	mov    %edi,%ecx
  800e0b:	89 fb                	mov    %edi,%ebx
  800e0d:	89 fe                	mov    %edi,%esi
  800e0f:	cd 30                	int    $0x30
  800e11:	85 c0                	test   %eax,%eax
  800e13:	7e 17                	jle    800e2c <sys_receive_packet_zerocopy+0x39>
  800e15:	83 ec 0c             	sub    $0xc,%esp
  800e18:	50                   	push   %eax
  800e19:	6a 12                	push   $0x12
  800e1b:	68 d0 27 80 00       	push   $0x8027d0
  800e20:	6a 23                	push   $0x23
  800e22:	68 ed 27 80 00       	push   $0x8027ed
  800e27:	e8 90 11 00 00       	call   801fbc <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800e2c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	c9                   	leave  
  800e33:	c3                   	ret    

00800e34 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	83 ec 0c             	sub    $0xc,%esp
  800e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e43:	b8 13 00 00 00       	mov    $0x13,%eax
  800e48:	bf 00 00 00 00       	mov    $0x0,%edi
  800e4d:	89 fb                	mov    %edi,%ebx
  800e4f:	89 fe                	mov    %edi,%esi
  800e51:	cd 30                	int    $0x30
  800e53:	85 c0                	test   %eax,%eax
  800e55:	7e 17                	jle    800e6e <sys_env_set_priority+0x3a>
  800e57:	83 ec 0c             	sub    $0xc,%esp
  800e5a:	50                   	push   %eax
  800e5b:	6a 13                	push   $0x13
  800e5d:	68 d0 27 80 00       	push   $0x8027d0
  800e62:	6a 23                	push   $0x23
  800e64:	68 ed 27 80 00       	push   $0x8027ed
  800e69:	e8 4e 11 00 00       	call   801fbc <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800e6e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    
	...

00800e78 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800e7e:	ff 75 08             	pushl  0x8(%ebp)
  800e81:	e8 0a 00 00 00       	call   800e90 <fd2num>
  800e86:	c1 e0 16             	shl    $0x16,%eax
  800e89:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  800e8e:	c9                   	leave  
  800e8f:	c3                   	ret    

00800e90 <fd2num>:

int
fd2num(struct Fd *fd)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	05 00 00 40 30       	add    $0x30400000,%eax
  800e9b:	c1 e8 0c             	shr    $0xc,%eax
}
  800e9e:	c9                   	leave  
  800e9f:	c3                   	ret    

00800ea0 <fd_alloc>:

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
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ea9:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eae:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  800eb3:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  800eb8:	89 c8                	mov    %ecx,%eax
  800eba:	c1 e0 0c             	shl    $0xc,%eax
  800ebd:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  800ec3:	89 d0                	mov    %edx,%eax
  800ec5:	c1 e8 16             	shr    $0x16,%eax
  800ec8:	8b 04 86             	mov    (%esi,%eax,4),%eax
  800ecb:	a8 01                	test   $0x1,%al
  800ecd:	74 0c                	je     800edb <fd_alloc+0x3b>
  800ecf:	89 d0                	mov    %edx,%eax
  800ed1:	c1 e8 0c             	shr    $0xc,%eax
  800ed4:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  800ed7:	a8 01                	test   $0x1,%al
  800ed9:	75 09                	jne    800ee4 <fd_alloc+0x44>
			*fd_store = fd;
  800edb:	89 17                	mov    %edx,(%edi)
			return 0;
  800edd:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee2:	eb 11                	jmp    800ef5 <fd_alloc+0x55>
  800ee4:	41                   	inc    %ecx
  800ee5:	83 f9 1f             	cmp    $0x1f,%ecx
  800ee8:	7e ce                	jle    800eb8 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  800eea:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  800ef0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  800f00:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800f05:	83 f8 1f             	cmp    $0x1f,%eax
  800f08:	77 3a                	ja     800f44 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  800f0a:	c1 e0 0c             	shl    $0xc,%eax
  800f0d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  800f13:	89 d0                	mov    %edx,%eax
  800f15:	c1 e8 16             	shr    $0x16,%eax
  800f18:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  800f1f:	a8 01                	test   $0x1,%al
  800f21:	74 10                	je     800f33 <fd_lookup+0x39>
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e8 0c             	shr    $0xc,%eax
  800f28:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800f2f:	a8 01                	test   $0x1,%al
  800f31:	75 07                	jne    800f3a <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  800f33:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  800f38:	eb 0a                	jmp    800f44 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  800f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f3d:	89 10                	mov    %edx,(%eax)
	return 0;
  800f3f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f44:	89 d0                	mov    %edx,%eax
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <fd_close>:

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
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	56                   	push   %esi
  800f4c:	53                   	push   %ebx
  800f4d:	83 ec 10             	sub    $0x10,%esp
  800f50:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f53:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800f56:	50                   	push   %eax
  800f57:	56                   	push   %esi
  800f58:	e8 33 ff ff ff       	call   800e90 <fd2num>
  800f5d:	89 04 24             	mov    %eax,(%esp)
  800f60:	e8 95 ff ff ff       	call   800efa <fd_lookup>
  800f65:	89 c3                	mov    %eax,%ebx
  800f67:	83 c4 08             	add    $0x8,%esp
  800f6a:	85 c0                	test   %eax,%eax
  800f6c:	78 05                	js     800f73 <fd_close+0x2b>
  800f6e:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  800f71:	74 0f                	je     800f82 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  800f73:	89 d8                	mov    %ebx,%eax
  800f75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f79:	75 3a                	jne    800fb5 <fd_close+0x6d>
  800f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f80:	eb 33                	jmp    800fb5 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  800f82:	83 ec 08             	sub    $0x8,%esp
  800f85:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  800f88:	50                   	push   %eax
  800f89:	ff 36                	pushl  (%esi)
  800f8b:	e8 2c 00 00 00       	call   800fbc <dev_lookup>
  800f90:	89 c3                	mov    %eax,%ebx
  800f92:	83 c4 10             	add    $0x10,%esp
  800f95:	85 c0                	test   %eax,%eax
  800f97:	78 0f                	js     800fa8 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  800f99:	83 ec 0c             	sub    $0xc,%esp
  800f9c:	56                   	push   %esi
  800f9d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  800fa0:	ff 50 10             	call   *0x10(%eax)
  800fa3:	89 c3                	mov    %eax,%ebx
  800fa5:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	56                   	push   %esi
  800fac:	6a 00                	push   $0x0
  800fae:	e8 f0 fb ff ff       	call   800ba3 <sys_page_unmap>
	return r;
  800fb3:	89 d8                	mov    %ebx,%eax
}
  800fb5:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <dev_lookup>:


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
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
  800fc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800fc4:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  800fc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800fcc:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  800fd3:	74 1c                	je     800ff1 <dev_lookup+0x35>
  800fd5:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  800fda:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  800fdd:	39 18                	cmp    %ebx,(%eax)
  800fdf:	75 09                	jne    800fea <dev_lookup+0x2e>
			*dev = devtab[i];
  800fe1:	89 06                	mov    %eax,(%esi)
			return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe8:	eb 29                	jmp    801013 <dev_lookup+0x57>
  800fea:	42                   	inc    %edx
  800feb:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  800fef:	75 e9                	jne    800fda <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  800ff1:	83 ec 04             	sub    $0x4,%esp
  800ff4:	53                   	push   %ebx
  800ff5:	a1 80 60 80 00       	mov    0x806080,%eax
  800ffa:	8b 40 4c             	mov    0x4c(%eax),%eax
  800ffd:	50                   	push   %eax
  800ffe:	68 fc 27 80 00       	push   $0x8027fc
  801003:	e8 40 f1 ff ff       	call   800148 <cprintf>
	*dev = 0;
  801008:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  80100e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801013:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801016:	5b                   	pop    %ebx
  801017:	5e                   	pop    %esi
  801018:	c9                   	leave  
  801019:	c3                   	ret    

0080101a <close>:

int
close(int fdnum)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801020:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801023:	50                   	push   %eax
  801024:	ff 75 08             	pushl  0x8(%ebp)
  801027:	e8 ce fe ff ff       	call   800efa <fd_lookup>
  80102c:	83 c4 08             	add    $0x8,%esp
		return r;
  80102f:	89 c2                	mov    %eax,%edx
  801031:	85 c0                	test   %eax,%eax
  801033:	78 0f                	js     801044 <close+0x2a>
	else
		return fd_close(fd, 1);
  801035:	83 ec 08             	sub    $0x8,%esp
  801038:	6a 01                	push   $0x1
  80103a:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80103d:	e8 06 ff ff ff       	call   800f48 <fd_close>
  801042:	89 c2                	mov    %eax,%edx
}
  801044:	89 d0                	mov    %edx,%eax
  801046:	c9                   	leave  
  801047:	c3                   	ret    

00801048 <close_all>:

void
close_all(void)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	53                   	push   %ebx
  80104c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80104f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	53                   	push   %ebx
  801058:	e8 bd ff ff ff       	call   80101a <close>
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	43                   	inc    %ebx
  801061:	83 fb 1f             	cmp    $0x1f,%ebx
  801064:	7e ee                	jle    801054 <close_all+0xc>
}
  801066:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
  801071:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801074:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801077:	50                   	push   %eax
  801078:	ff 75 08             	pushl  0x8(%ebp)
  80107b:	e8 7a fe ff ff       	call   800efa <fd_lookup>
  801080:	89 c6                	mov    %eax,%esi
  801082:	83 c4 08             	add    $0x8,%esp
  801085:	85 f6                	test   %esi,%esi
  801087:	0f 88 f8 00 00 00    	js     801185 <dup+0x11a>
		return r;
	close(newfdnum);
  80108d:	83 ec 0c             	sub    $0xc,%esp
  801090:	ff 75 0c             	pushl  0xc(%ebp)
  801093:	e8 82 ff ff ff       	call   80101a <close>

	newfd = INDEX2FD(newfdnum);
  801098:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109b:	c1 e0 0c             	shl    $0xc,%eax
  80109e:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8010a3:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8010a6:	83 c4 04             	add    $0x4,%esp
  8010a9:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8010ac:	e8 c7 fd ff ff       	call   800e78 <fd2data>
  8010b1:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8010b3:	83 c4 04             	add    $0x4,%esp
  8010b6:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8010b9:	e8 ba fd ff ff       	call   800e78 <fd2data>
  8010be:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  8010c1:	89 f8                	mov    %edi,%eax
  8010c3:	c1 e8 16             	shr    $0x16,%eax
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	74 48                	je     80111c <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8010d4:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  8010d9:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  8010dc:	89 d0                	mov    %edx,%eax
  8010de:	c1 e8 0c             	shr    $0xc,%eax
  8010e1:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  8010e8:	a8 01                	test   $0x1,%al
  8010ea:	74 22                	je     80110e <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  8010ec:	83 ec 0c             	sub    $0xc,%esp
  8010ef:	25 07 0e 00 00       	and    $0xe07,%eax
  8010f4:	50                   	push   %eax
  8010f5:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8010f8:	01 d8                	add    %ebx,%eax
  8010fa:	50                   	push   %eax
  8010fb:	6a 00                	push   $0x0
  8010fd:	52                   	push   %edx
  8010fe:	6a 00                	push   $0x0
  801100:	e8 5c fa ff ff       	call   800b61 <sys_page_map>
  801105:	89 c6                	mov    %eax,%esi
  801107:	83 c4 20             	add    $0x20,%esp
  80110a:	85 c0                	test   %eax,%eax
  80110c:	78 3f                	js     80114d <dup+0xe2>
  80110e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801114:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80111a:	7e bd                	jle    8010d9 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80111c:	83 ec 0c             	sub    $0xc,%esp
  80111f:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801122:	89 d0                	mov    %edx,%eax
  801124:	c1 e8 0c             	shr    $0xc,%eax
  801127:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80112e:	25 07 0e 00 00       	and    $0xe07,%eax
  801133:	50                   	push   %eax
  801134:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801137:	6a 00                	push   $0x0
  801139:	52                   	push   %edx
  80113a:	6a 00                	push   $0x0
  80113c:	e8 20 fa ff ff       	call   800b61 <sys_page_map>
  801141:	89 c6                	mov    %eax,%esi
  801143:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801146:	8b 45 0c             	mov    0xc(%ebp),%eax
  801149:	85 f6                	test   %esi,%esi
  80114b:	79 38                	jns    801185 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  80114d:	83 ec 08             	sub    $0x8,%esp
  801150:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801153:	6a 00                	push   $0x0
  801155:	e8 49 fa ff ff       	call   800ba3 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80115a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80115f:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  801162:	83 ec 08             	sub    $0x8,%esp
  801165:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801168:	01 d8                	add    %ebx,%eax
  80116a:	50                   	push   %eax
  80116b:	6a 00                	push   $0x0
  80116d:	e8 31 fa ff ff       	call   800ba3 <sys_page_unmap>
  801172:	83 c4 10             	add    $0x10,%esp
  801175:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80117b:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801181:	7e df                	jle    801162 <dup+0xf7>
	return r;
  801183:	89 f0                	mov    %esi,%eax
}
  801185:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801188:	5b                   	pop    %ebx
  801189:	5e                   	pop    %esi
  80118a:	5f                   	pop    %edi
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	53                   	push   %ebx
  801191:	83 ec 14             	sub    $0x14,%esp
  801194:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801197:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80119a:	50                   	push   %eax
  80119b:	53                   	push   %ebx
  80119c:	e8 59 fd ff ff       	call   800efa <fd_lookup>
  8011a1:	89 c2                	mov    %eax,%edx
  8011a3:	83 c4 08             	add    $0x8,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	78 1a                	js     8011c4 <read+0x37>
  8011aa:	83 ec 08             	sub    $0x8,%esp
  8011ad:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8011b0:	50                   	push   %eax
  8011b1:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8011b4:	ff 30                	pushl  (%eax)
  8011b6:	e8 01 fe ff ff       	call   800fbc <dev_lookup>
  8011bb:	89 c2                	mov    %eax,%edx
  8011bd:	83 c4 10             	add    $0x10,%esp
  8011c0:	85 c0                	test   %eax,%eax
  8011c2:	79 04                	jns    8011c8 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8011c4:	89 d0                	mov    %edx,%eax
  8011c6:	eb 50                	jmp    801218 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011c8:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8011cb:	8b 40 08             	mov    0x8(%eax),%eax
  8011ce:	83 e0 03             	and    $0x3,%eax
  8011d1:	83 f8 01             	cmp    $0x1,%eax
  8011d4:	75 1e                	jne    8011f4 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8011d6:	83 ec 04             	sub    $0x4,%esp
  8011d9:	53                   	push   %ebx
  8011da:	a1 80 60 80 00       	mov    0x806080,%eax
  8011df:	8b 40 4c             	mov    0x4c(%eax),%eax
  8011e2:	50                   	push   %eax
  8011e3:	68 3d 28 80 00       	push   $0x80283d
  8011e8:	e8 5b ef ff ff       	call   800148 <cprintf>
		return -E_INVAL;
  8011ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f2:	eb 24                	jmp    801218 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  8011f4:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8011f7:	ff 70 04             	pushl  0x4(%eax)
  8011fa:	ff 75 10             	pushl  0x10(%ebp)
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	50                   	push   %eax
  801201:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801204:	ff 50 08             	call   *0x8(%eax)
  801207:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	85 c0                	test   %eax,%eax
  80120e:	78 06                	js     801216 <read+0x89>
		fd->fd_offset += r;
  801210:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801213:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801216:	89 d0                	mov    %edx,%eax
}
  801218:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80121b:	c9                   	leave  
  80121c:	c3                   	ret    

0080121d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	57                   	push   %edi
  801221:	56                   	push   %esi
  801222:	53                   	push   %ebx
  801223:	83 ec 0c             	sub    $0xc,%esp
  801226:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801229:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80122c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801231:	39 f3                	cmp    %esi,%ebx
  801233:	73 25                	jae    80125a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801235:	83 ec 04             	sub    $0x4,%esp
  801238:	89 f0                	mov    %esi,%eax
  80123a:	29 d8                	sub    %ebx,%eax
  80123c:	50                   	push   %eax
  80123d:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801240:	50                   	push   %eax
  801241:	ff 75 08             	pushl  0x8(%ebp)
  801244:	e8 44 ff ff ff       	call   80118d <read>
		if (m < 0)
  801249:	83 c4 10             	add    $0x10,%esp
  80124c:	85 c0                	test   %eax,%eax
  80124e:	78 0c                	js     80125c <readn+0x3f>
			return m;
		if (m == 0)
  801250:	85 c0                	test   %eax,%eax
  801252:	74 06                	je     80125a <readn+0x3d>
  801254:	01 c3                	add    %eax,%ebx
  801256:	39 f3                	cmp    %esi,%ebx
  801258:	72 db                	jb     801235 <readn+0x18>
			break;
	}
	return tot;
  80125a:	89 d8                	mov    %ebx,%eax
}
  80125c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80125f:	5b                   	pop    %ebx
  801260:	5e                   	pop    %esi
  801261:	5f                   	pop    %edi
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	53                   	push   %ebx
  801268:	83 ec 14             	sub    $0x14,%esp
  80126b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80126e:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801271:	50                   	push   %eax
  801272:	53                   	push   %ebx
  801273:	e8 82 fc ff ff       	call   800efa <fd_lookup>
  801278:	89 c2                	mov    %eax,%edx
  80127a:	83 c4 08             	add    $0x8,%esp
  80127d:	85 c0                	test   %eax,%eax
  80127f:	78 1a                	js     80129b <write+0x37>
  801281:	83 ec 08             	sub    $0x8,%esp
  801284:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801287:	50                   	push   %eax
  801288:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80128b:	ff 30                	pushl  (%eax)
  80128d:	e8 2a fd ff ff       	call   800fbc <dev_lookup>
  801292:	89 c2                	mov    %eax,%edx
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	85 c0                	test   %eax,%eax
  801299:	79 04                	jns    80129f <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  80129b:	89 d0                	mov    %edx,%eax
  80129d:	eb 4b                	jmp    8012ea <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80129f:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8012a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012a6:	75 1e                	jne    8012c6 <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8012a8:	83 ec 04             	sub    $0x4,%esp
  8012ab:	53                   	push   %ebx
  8012ac:	a1 80 60 80 00       	mov    0x806080,%eax
  8012b1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8012b4:	50                   	push   %eax
  8012b5:	68 59 28 80 00       	push   $0x802859
  8012ba:	e8 89 ee ff ff       	call   800148 <cprintf>
		return -E_INVAL;
  8012bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012c4:	eb 24                	jmp    8012ea <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8012c6:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8012c9:	ff 70 04             	pushl  0x4(%eax)
  8012cc:	ff 75 10             	pushl  0x10(%ebp)
  8012cf:	ff 75 0c             	pushl  0xc(%ebp)
  8012d2:	50                   	push   %eax
  8012d3:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8012d6:	ff 50 0c             	call   *0xc(%eax)
  8012d9:	89 c2                	mov    %eax,%edx
	if (r > 0)
  8012db:	83 c4 10             	add    $0x10,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	7e 06                	jle    8012e8 <write+0x84>
		fd->fd_offset += r;
  8012e2:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8012e5:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  8012e8:	89 d0                	mov    %edx,%eax
}
  8012ea:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <seek>:

int
seek(int fdnum, off_t offset)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012f5:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8012f8:	50                   	push   %eax
  8012f9:	ff 75 08             	pushl  0x8(%ebp)
  8012fc:	e8 f9 fb ff ff       	call   800efa <fd_lookup>
  801301:	83 c4 08             	add    $0x8,%esp
		return r;
  801304:	89 c2                	mov    %eax,%edx
  801306:	85 c0                	test   %eax,%eax
  801308:	78 0e                	js     801318 <seek+0x29>
	fd->fd_offset = offset;
  80130a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801310:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801313:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801318:	89 d0                	mov    %edx,%eax
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	53                   	push   %ebx
  801320:	83 ec 14             	sub    $0x14,%esp
  801323:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801326:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801329:	50                   	push   %eax
  80132a:	53                   	push   %ebx
  80132b:	e8 ca fb ff ff       	call   800efa <fd_lookup>
  801330:	83 c4 08             	add    $0x8,%esp
  801333:	85 c0                	test   %eax,%eax
  801335:	78 4e                	js     801385 <ftruncate+0x69>
  801337:	83 ec 08             	sub    $0x8,%esp
  80133a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80133d:	50                   	push   %eax
  80133e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801341:	ff 30                	pushl  (%eax)
  801343:	e8 74 fc ff ff       	call   800fbc <dev_lookup>
  801348:	83 c4 10             	add    $0x10,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	78 36                	js     801385 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80134f:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801352:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801356:	75 1e                	jne    801376 <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801358:	83 ec 04             	sub    $0x4,%esp
  80135b:	53                   	push   %ebx
  80135c:	a1 80 60 80 00       	mov    0x806080,%eax
  801361:	8b 40 4c             	mov    0x4c(%eax),%eax
  801364:	50                   	push   %eax
  801365:	68 1c 28 80 00       	push   $0x80281c
  80136a:	e8 d9 ed ff ff       	call   800148 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  80136f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801374:	eb 0f                	jmp    801385 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801376:	83 ec 08             	sub    $0x8,%esp
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80137f:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801382:	ff 50 1c             	call   *0x1c(%eax)
}
  801385:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801388:	c9                   	leave  
  801389:	c3                   	ret    

0080138a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	53                   	push   %ebx
  80138e:	83 ec 14             	sub    $0x14,%esp
  801391:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801394:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	ff 75 08             	pushl  0x8(%ebp)
  80139b:	e8 5a fb ff ff       	call   800efa <fd_lookup>
  8013a0:	83 c4 08             	add    $0x8,%esp
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	78 42                	js     8013e9 <fstat+0x5f>
  8013a7:	83 ec 08             	sub    $0x8,%esp
  8013aa:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8013ad:	50                   	push   %eax
  8013ae:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013b1:	ff 30                	pushl  (%eax)
  8013b3:	e8 04 fc ff ff       	call   800fbc <dev_lookup>
  8013b8:	83 c4 10             	add    $0x10,%esp
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	78 2a                	js     8013e9 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  8013bf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013c2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013c9:	00 00 00 
	stat->st_isdir = 0;
  8013cc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013d3:	00 00 00 
	stat->st_dev = dev;
  8013d6:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8013d9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	53                   	push   %ebx
  8013e3:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8013e6:	ff 50 14             	call   *0x14(%eax)
}
  8013e9:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8013ec:	c9                   	leave  
  8013ed:	c3                   	ret    

008013ee <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013ee:	55                   	push   %ebp
  8013ef:	89 e5                	mov    %esp,%ebp
  8013f1:	56                   	push   %esi
  8013f2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013f3:	83 ec 08             	sub    $0x8,%esp
  8013f6:	6a 00                	push   $0x0
  8013f8:	ff 75 08             	pushl  0x8(%ebp)
  8013fb:	e8 28 00 00 00       	call   801428 <open>
  801400:	89 c6                	mov    %eax,%esi
  801402:	83 c4 10             	add    $0x10,%esp
  801405:	85 f6                	test   %esi,%esi
  801407:	78 18                	js     801421 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801409:	83 ec 08             	sub    $0x8,%esp
  80140c:	ff 75 0c             	pushl  0xc(%ebp)
  80140f:	56                   	push   %esi
  801410:	e8 75 ff ff ff       	call   80138a <fstat>
  801415:	89 c3                	mov    %eax,%ebx
	close(fd);
  801417:	89 34 24             	mov    %esi,(%esp)
  80141a:	e8 fb fb ff ff       	call   80101a <close>
	return r;
  80141f:	89 d8                	mov    %ebx,%eax
}
  801421:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801424:	5b                   	pop    %ebx
  801425:	5e                   	pop    %esi
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	53                   	push   %ebx
  80142c:	83 ec 10             	sub    $0x10,%esp
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
  80142f:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801432:	50                   	push   %eax
  801433:	e8 68 fa ff ff       	call   800ea0 <fd_alloc>
  801438:	89 c3                	mov    %eax,%ebx
  80143a:	83 c4 10             	add    $0x10,%esp
  80143d:	85 db                	test   %ebx,%ebx
  80143f:	78 36                	js     801477 <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801441:	83 ec 04             	sub    $0x4,%esp
  801444:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801447:	ff 75 0c             	pushl  0xc(%ebp)
  80144a:	ff 75 08             	pushl  0x8(%ebp)
  80144d:	e8 1b 05 00 00       	call   80196d <fsipc_open>
  801452:	89 c3                	mov    %eax,%ebx
  801454:	83 c4 10             	add    $0x10,%esp
  801457:	85 c0                	test   %eax,%eax
  801459:	79 11                	jns    80146c <open+0x44>
          fd_close(fd_store, 0);
  80145b:	83 ec 08             	sub    $0x8,%esp
  80145e:	6a 00                	push   $0x0
  801460:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801463:	e8 e0 fa ff ff       	call   800f48 <fd_close>
          return r;
  801468:	89 d8                	mov    %ebx,%eax
  80146a:	eb 0b                	jmp    801477 <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  80146c:	83 ec 0c             	sub    $0xc,%esp
  80146f:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801472:	e8 19 fa ff ff       	call   800e90 <fd2num>
}
  801477:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80147a:	c9                   	leave  
  80147b:	c3                   	ret    

0080147c <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	53                   	push   %ebx
  801480:	83 ec 04             	sub    $0x4,%esp
  801483:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  801486:	6a 01                	push   $0x1
  801488:	6a 00                	push   $0x0
  80148a:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801490:	53                   	push   %ebx
  801491:	e8 e7 03 00 00       	call   80187d <funmap>
  801496:	83 c4 10             	add    $0x10,%esp
          return r;
  801499:	89 c2                	mov    %eax,%edx
  80149b:	85 c0                	test   %eax,%eax
  80149d:	78 19                	js     8014b8 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  80149f:	83 ec 0c             	sub    $0xc,%esp
  8014a2:	ff 73 0c             	pushl  0xc(%ebx)
  8014a5:	e8 68 05 00 00       	call   801a12 <fsipc_close>
  8014aa:	83 c4 10             	add    $0x10,%esp
          return r;
  8014ad:	89 c2                	mov    %eax,%edx
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	78 05                	js     8014b8 <file_close+0x3c>
        }
        return 0;
  8014b3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8014b8:	89 d0                	mov    %edx,%eax
  8014ba:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8014bd:	c9                   	leave  
  8014be:	c3                   	ret    

008014bf <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	57                   	push   %edi
  8014c3:	56                   	push   %esi
  8014c4:	53                   	push   %ebx
  8014c5:	83 ec 0c             	sub    $0xc,%esp
  8014c8:	8b 75 10             	mov    0x10(%ebp),%esi
  8014cb:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8014ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  8014d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014dc:	39 d7                	cmp    %edx,%edi
  8014de:	0f 87 95 00 00 00    	ja     801579 <file_read+0xba>
	if (offset + n > size)
  8014e4:	8d 04 37             	lea    (%edi,%esi,1),%eax
  8014e7:	39 d0                	cmp    %edx,%eax
  8014e9:	76 04                	jbe    8014ef <file_read+0x30>
		n = size - offset;
  8014eb:	89 d6                	mov    %edx,%esi
  8014ed:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8014ef:	83 ec 0c             	sub    $0xc,%esp
  8014f2:	ff 75 08             	pushl  0x8(%ebp)
  8014f5:	e8 7e f9 ff ff       	call   800e78 <fd2data>
  8014fa:	89 c3                	mov    %eax,%ebx
  8014fc:	01 fb                	add    %edi,%ebx
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	eb 41                	jmp    801544 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801503:	89 d8                	mov    %ebx,%eax
  801505:	c1 e8 16             	shr    $0x16,%eax
  801508:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80150f:	a8 01                	test   $0x1,%al
  801511:	74 10                	je     801523 <file_read+0x64>
  801513:	89 d8                	mov    %ebx,%eax
  801515:	c1 e8 0c             	shr    $0xc,%eax
  801518:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80151f:	a8 01                	test   $0x1,%al
  801521:	75 1b                	jne    80153e <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801523:	83 ec 04             	sub    $0x4,%esp
  801526:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801529:	50                   	push   %eax
  80152a:	57                   	push   %edi
  80152b:	ff 75 08             	pushl  0x8(%ebp)
  80152e:	e8 d4 02 00 00       	call   801807 <fmap>
  801533:	83 c4 10             	add    $0x10,%esp
              return r;
  801536:	89 c1                	mov    %eax,%ecx
  801538:	85 c0                	test   %eax,%eax
  80153a:	78 3d                	js     801579 <file_read+0xba>
  80153c:	eb 1c                	jmp    80155a <file_read+0x9b>
  80153e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	ff 75 08             	pushl  0x8(%ebp)
  80154a:	e8 29 f9 ff ff       	call   800e78 <fd2data>
  80154f:	01 f8                	add    %edi,%eax
  801551:	01 f0                	add    %esi,%eax
  801553:	83 c4 10             	add    $0x10,%esp
  801556:	39 d8                	cmp    %ebx,%eax
  801558:	77 a9                	ja     801503 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  80155a:	83 ec 04             	sub    $0x4,%esp
  80155d:	56                   	push   %esi
  80155e:	83 ec 04             	sub    $0x4,%esp
  801561:	ff 75 08             	pushl  0x8(%ebp)
  801564:	e8 0f f9 ff ff       	call   800e78 <fd2data>
  801569:	83 c4 08             	add    $0x8,%esp
  80156c:	01 f8                	add    %edi,%eax
  80156e:	50                   	push   %eax
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	e8 51 f3 ff ff       	call   8008c8 <memmove>
	return n;
  801577:	89 f1                	mov    %esi,%ecx
}
  801579:	89 c8                	mov    %ecx,%eax
  80157b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80157e:	5b                   	pop    %ebx
  80157f:	5e                   	pop    %esi
  801580:	5f                   	pop    %edi
  801581:	c9                   	leave  
  801582:	c3                   	ret    

00801583 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
  801588:	83 ec 18             	sub    $0x18,%esp
  80158b:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801591:	50                   	push   %eax
  801592:	ff 75 08             	pushl  0x8(%ebp)
  801595:	e8 60 f9 ff ff       	call   800efa <fd_lookup>
  80159a:	83 c4 10             	add    $0x10,%esp
		return r;
  80159d:	89 c2                	mov    %eax,%edx
  80159f:	85 c0                	test   %eax,%eax
  8015a1:	0f 88 9f 00 00 00    	js     801646 <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  8015a7:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8015aa:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  8015ac:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8015b1:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  8015b7:	0f 85 89 00 00 00    	jne    801646 <read_map+0xc3>
	va = fd2data(fd) + offset;
  8015bd:	83 ec 0c             	sub    $0xc,%esp
  8015c0:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8015c3:	e8 b0 f8 ff ff       	call   800e78 <fd2data>
  8015c8:	89 c3                	mov    %eax,%ebx
  8015ca:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  8015cc:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  8015cf:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8015d4:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  8015da:	7f 6a                	jg     801646 <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  8015dc:	89 d8                	mov    %ebx,%eax
  8015de:	c1 e8 16             	shr    $0x16,%eax
  8015e1:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8015e8:	a8 01                	test   $0x1,%al
  8015ea:	74 10                	je     8015fc <read_map+0x79>
  8015ec:	89 d8                	mov    %ebx,%eax
  8015ee:	c1 e8 0c             	shr    $0xc,%eax
  8015f1:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8015f8:	a8 01                	test   $0x1,%al
  8015fa:	75 19                	jne    801615 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  8015fc:	83 ec 04             	sub    $0x4,%esp
  8015ff:	8d 46 01             	lea    0x1(%esi),%eax
  801602:	50                   	push   %eax
  801603:	56                   	push   %esi
  801604:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801607:	e8 fb 01 00 00       	call   801807 <fmap>
  80160c:	83 c4 10             	add    $0x10,%esp
            return r;
  80160f:	89 c2                	mov    %eax,%edx
  801611:	85 c0                	test   %eax,%eax
  801613:	78 31                	js     801646 <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801615:	89 d8                	mov    %ebx,%eax
  801617:	c1 e8 16             	shr    $0x16,%eax
  80161a:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801621:	a8 01                	test   $0x1,%al
  801623:	74 10                	je     801635 <read_map+0xb2>
  801625:	89 d8                	mov    %ebx,%eax
  801627:	c1 e8 0c             	shr    $0xc,%eax
  80162a:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801631:	a8 01                	test   $0x1,%al
  801633:	75 07                	jne    80163c <read_map+0xb9>
		return -E_NO_DISK;
  801635:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  80163a:	eb 0a                	jmp    801646 <read_map+0xc3>

	*blk = (void*) va;
  80163c:	8b 45 10             	mov    0x10(%ebp),%eax
  80163f:	89 18                	mov    %ebx,(%eax)
	return 0;
  801641:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801646:	89 d0                	mov    %edx,%eax
  801648:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80164b:	5b                   	pop    %ebx
  80164c:	5e                   	pop    %esi
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	57                   	push   %edi
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
  801655:	83 ec 0c             	sub    $0xc,%esp
  801658:	8b 75 08             	mov    0x8(%ebp),%esi
  80165b:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801664:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801669:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  80166f:	0f 87 bd 00 00 00    	ja     801732 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801675:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  80167b:	73 17                	jae    801694 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  80167d:	83 ec 08             	sub    $0x8,%esp
  801680:	52                   	push   %edx
  801681:	56                   	push   %esi
  801682:	e8 fb 00 00 00       	call   801782 <file_trunc>
  801687:	83 c4 10             	add    $0x10,%esp
			return r;
  80168a:	89 c1                	mov    %eax,%ecx
  80168c:	85 c0                	test   %eax,%eax
  80168e:	0f 88 9e 00 00 00    	js     801732 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801694:	83 ec 0c             	sub    $0xc,%esp
  801697:	56                   	push   %esi
  801698:	e8 db f7 ff ff       	call   800e78 <fd2data>
  80169d:	89 c3                	mov    %eax,%ebx
  80169f:	01 fb                	add    %edi,%ebx
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	eb 42                	jmp    8016e8 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8016a6:	89 d8                	mov    %ebx,%eax
  8016a8:	c1 e8 16             	shr    $0x16,%eax
  8016ab:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8016b2:	a8 01                	test   $0x1,%al
  8016b4:	74 10                	je     8016c6 <file_write+0x77>
  8016b6:	89 d8                	mov    %ebx,%eax
  8016b8:	c1 e8 0c             	shr    $0xc,%eax
  8016bb:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8016c2:	a8 01                	test   $0x1,%al
  8016c4:	75 1c                	jne    8016e2 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8016c6:	83 ec 04             	sub    $0x4,%esp
  8016c9:	8b 55 10             	mov    0x10(%ebp),%edx
  8016cc:	8d 04 17             	lea    (%edi,%edx,1),%eax
  8016cf:	50                   	push   %eax
  8016d0:	57                   	push   %edi
  8016d1:	56                   	push   %esi
  8016d2:	e8 30 01 00 00       	call   801807 <fmap>
  8016d7:	83 c4 10             	add    $0x10,%esp
              return r;
  8016da:	89 c1                	mov    %eax,%ecx
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 52                	js     801732 <file_write+0xe3>
  8016e0:	eb 1b                	jmp    8016fd <file_write+0xae>
  8016e2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016e8:	83 ec 0c             	sub    $0xc,%esp
  8016eb:	56                   	push   %esi
  8016ec:	e8 87 f7 ff ff       	call   800e78 <fd2data>
  8016f1:	01 f8                	add    %edi,%eax
  8016f3:	03 45 10             	add    0x10(%ebp),%eax
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	39 d8                	cmp    %ebx,%eax
  8016fb:	77 a9                	ja     8016a6 <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  8016fd:	83 ec 0c             	sub    $0xc,%esp
  801700:	68 76 28 80 00       	push   $0x802876
  801705:	e8 3e ea ff ff       	call   800148 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  80170a:	83 c4 0c             	add    $0xc,%esp
  80170d:	ff 75 10             	pushl  0x10(%ebp)
  801710:	ff 75 0c             	pushl  0xc(%ebp)
  801713:	56                   	push   %esi
  801714:	e8 5f f7 ff ff       	call   800e78 <fd2data>
  801719:	01 f8                	add    %edi,%eax
  80171b:	89 04 24             	mov    %eax,(%esp)
  80171e:	e8 a5 f1 ff ff       	call   8008c8 <memmove>
        cprintf("write done\n");
  801723:	c7 04 24 83 28 80 00 	movl   $0x802883,(%esp)
  80172a:	e8 19 ea ff ff       	call   800148 <cprintf>
	return n;
  80172f:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801732:	89 c8                	mov    %ecx,%eax
  801734:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801737:	5b                   	pop    %ebx
  801738:	5e                   	pop    %esi
  801739:	5f                   	pop    %edi
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801744:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801747:	83 ec 08             	sub    $0x8,%esp
  80174a:	8d 43 10             	lea    0x10(%ebx),%eax
  80174d:	50                   	push   %eax
  80174e:	56                   	push   %esi
  80174f:	e8 f8 ef ff ff       	call   80074c <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801754:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  80175a:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  80176a:	0f 94 c0             	sete   %al
  80176d:	0f b6 c0             	movzbl %al,%eax
  801770:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801776:	b8 00 00 00 00       	mov    $0x0,%eax
  80177b:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80177e:	5b                   	pop    %ebx
  80177f:	5e                   	pop    %esi
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	57                   	push   %edi
  801786:	56                   	push   %esi
  801787:	53                   	push   %ebx
  801788:	83 ec 0c             	sub    $0xc,%esp
  80178b:	8b 75 08             	mov    0x8(%ebp),%esi
  80178e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801791:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801796:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  80179c:	7f 5f                	jg     8017fd <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  80179e:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	53                   	push   %ebx
  8017a8:	ff 76 0c             	pushl  0xc(%esi)
  8017ab:	e8 3a 02 00 00       	call   8019ea <fsipc_set_size>
  8017b0:	83 c4 10             	add    $0x10,%esp
		return r;
  8017b3:	89 c2                	mov    %eax,%edx
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	78 44                	js     8017fd <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  8017b9:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  8017bf:	74 19                	je     8017da <file_trunc+0x58>
  8017c1:	68 b0 28 80 00       	push   $0x8028b0
  8017c6:	68 8f 28 80 00       	push   $0x80288f
  8017cb:	68 dc 00 00 00       	push   $0xdc
  8017d0:	68 a4 28 80 00       	push   $0x8028a4
  8017d5:	e8 e2 07 00 00       	call   801fbc <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  8017da:	83 ec 04             	sub    $0x4,%esp
  8017dd:	53                   	push   %ebx
  8017de:	57                   	push   %edi
  8017df:	56                   	push   %esi
  8017e0:	e8 22 00 00 00       	call   801807 <fmap>
  8017e5:	83 c4 10             	add    $0x10,%esp
		return r;
  8017e8:	89 c2                	mov    %eax,%edx
  8017ea:	85 c0                	test   %eax,%eax
  8017ec:	78 0f                	js     8017fd <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	53                   	push   %ebx
  8017f1:	57                   	push   %edi
  8017f2:	56                   	push   %esi
  8017f3:	e8 85 00 00 00       	call   80187d <funmap>

	return 0;
  8017f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017fd:	89 d0                	mov    %edx,%eax
  8017ff:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801802:	5b                   	pop    %ebx
  801803:	5e                   	pop    %esi
  801804:	5f                   	pop    %edi
  801805:	c9                   	leave  
  801806:	c3                   	ret    

00801807 <fmap>:

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
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	57                   	push   %edi
  80180b:	56                   	push   %esi
  80180c:	53                   	push   %ebx
  80180d:	83 ec 0c             	sub    $0xc,%esp
  801810:	8b 7d 08             	mov    0x8(%ebp),%edi
  801813:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801816:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801819:	7d 55                	jge    801870 <fmap+0x69>
          fma = fd2data(fd);
  80181b:	83 ec 0c             	sub    $0xc,%esp
  80181e:	57                   	push   %edi
  80181f:	e8 54 f6 ff ff       	call   800e78 <fd2data>
  801824:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801827:	83 c4 10             	add    $0x10,%esp
  80182a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182d:	05 ff 0f 00 00       	add    $0xfff,%eax
  801832:	89 c3                	mov    %eax,%ebx
  801834:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80183a:	39 f3                	cmp    %esi,%ebx
  80183c:	7d 32                	jge    801870 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  80183e:	83 ec 04             	sub    $0x4,%esp
  801841:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801844:	01 d8                	add    %ebx,%eax
  801846:	50                   	push   %eax
  801847:	53                   	push   %ebx
  801848:	ff 77 0c             	pushl  0xc(%edi)
  80184b:	e8 6f 01 00 00       	call   8019bf <fsipc_map>
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	85 c0                	test   %eax,%eax
  801855:	79 0f                	jns    801866 <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801857:	6a 00                	push   $0x0
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	53                   	push   %ebx
  80185d:	57                   	push   %edi
  80185e:	e8 1a 00 00 00       	call   80187d <funmap>
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80186c:	39 f3                	cmp    %esi,%ebx
  80186e:	7c ce                	jl     80183e <fmap+0x37>
            }
          }
        }

        return 0;
}
  801870:	b8 00 00 00 00       	mov    $0x0,%eax
  801875:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801878:	5b                   	pop    %ebx
  801879:	5e                   	pop    %esi
  80187a:	5f                   	pop    %edi
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <funmap>:

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
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	57                   	push   %edi
  801881:	56                   	push   %esi
  801882:	53                   	push   %ebx
  801883:	83 ec 0c             	sub    $0xc,%esp
  801886:	8b 75 0c             	mov    0xc(%ebp),%esi
  801889:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  80188c:	39 f3                	cmp    %esi,%ebx
  80188e:	0f 8d 80 00 00 00    	jge    801914 <funmap+0x97>
          fma = fd2data(fd);
  801894:	83 ec 0c             	sub    $0xc,%esp
  801897:	ff 75 08             	pushl  0x8(%ebp)
  80189a:	e8 d9 f5 ff ff       	call   800e78 <fd2data>
  80189f:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  8018a1:	83 c4 10             	add    $0x10,%esp
  8018a4:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8018aa:	89 c3                	mov    %eax,%ebx
  8018ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8018b2:	39 f3                	cmp    %esi,%ebx
  8018b4:	7d 5e                	jge    801914 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  8018b6:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8018b9:	89 c2                	mov    %eax,%edx
  8018bb:	c1 ea 0c             	shr    $0xc,%edx
  8018be:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8018c5:	a8 01                	test   $0x1,%al
  8018c7:	74 41                	je     80190a <funmap+0x8d>
              if (dirty) {
  8018c9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  8018cd:	74 21                	je     8018f0 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  8018cf:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8018d6:	a8 40                	test   $0x40,%al
  8018d8:	74 16                	je     8018f0 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  8018da:	83 ec 08             	sub    $0x8,%esp
  8018dd:	53                   	push   %ebx
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	ff 70 0c             	pushl  0xc(%eax)
  8018e4:	e8 49 01 00 00       	call   801a32 <fsipc_dirty>
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 29                	js     801919 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  8018f0:	83 ec 08             	sub    $0x8,%esp
  8018f3:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8018f6:	50                   	push   %eax
  8018f7:	83 ec 04             	sub    $0x4,%esp
  8018fa:	e8 e1 f1 ff ff       	call   800ae0 <sys_getenvid>
  8018ff:	89 04 24             	mov    %eax,(%esp)
  801902:	e8 9c f2 ff ff       	call   800ba3 <sys_page_unmap>
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801910:	39 f3                	cmp    %esi,%ebx
  801912:	7c a2                	jl     8018b6 <funmap+0x39>
            }
          }
        }

        return 0;
  801914:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801919:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80191c:	5b                   	pop    %ebx
  80191d:	5e                   	pop    %esi
  80191e:	5f                   	pop    %edi
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <remove>:

// Delete a file
int
remove(const char *path)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801927:	ff 75 08             	pushl  0x8(%ebp)
  80192a:	e8 2b 01 00 00       	call   801a5a <fsipc_remove>
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801937:	e8 64 01 00 00       	call   801aa0 <fsipc_sync>
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    
	...

00801940 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801946:	6a 07                	push   $0x7
  801948:	ff 75 0c             	pushl  0xc(%ebp)
  80194b:	ff 75 08             	pushl  0x8(%ebp)
  80194e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801953:	50                   	push   %eax
  801954:	e8 26 07 00 00       	call   80207f <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801959:	83 c4 0c             	add    $0xc,%esp
  80195c:	ff 75 14             	pushl  0x14(%ebp)
  80195f:	ff 75 10             	pushl  0x10(%ebp)
  801962:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801965:	50                   	push   %eax
  801966:	e8 b1 06 00 00       	call   80201c <ipc_recv>
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	56                   	push   %esi
  801971:	53                   	push   %ebx
  801972:	83 ec 1c             	sub    $0x1c,%esp
  801975:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801978:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  80197d:	56                   	push   %esi
  80197e:	e8 8d ed ff ff       	call   800710 <strlen>
  801983:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801986:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80198b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801990:	7f 24                	jg     8019b6 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801992:	83 ec 08             	sub    $0x8,%esp
  801995:	56                   	push   %esi
  801996:	53                   	push   %ebx
  801997:	e8 b0 ed ff ff       	call   80074c <strcpy>
	req->req_omode = omode;
  80199c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199f:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  8019a5:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8019a8:	50                   	push   %eax
  8019a9:	ff 75 10             	pushl  0x10(%ebp)
  8019ac:	53                   	push   %ebx
  8019ad:	6a 01                	push   $0x1
  8019af:	e8 8c ff ff ff       	call   801940 <fsipc>
  8019b4:	89 c2                	mov    %eax,%edx
}
  8019b6:	89 d0                	mov    %edx,%eax
  8019b8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8019bb:	5b                   	pop    %ebx
  8019bc:	5e                   	pop    %esi
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  8019cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d0:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  8019d5:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8019d8:	50                   	push   %eax
  8019d9:	ff 75 10             	pushl  0x10(%ebp)
  8019dc:	68 00 30 80 00       	push   $0x803000
  8019e1:	6a 02                	push   $0x2
  8019e3:	e8 58 ff ff ff       	call   801940 <fsipc>

	//return -E_UNSPECIFIED;
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  8019f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fb:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	68 00 30 80 00       	push   $0x803000
  801a09:	6a 03                	push   $0x3
  801a0b:	e8 30 ff ff ff       	call   801940 <fsipc>
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	68 00 30 80 00       	push   $0x803000
  801a29:	6a 04                	push   $0x4
  801a2b:	e8 10 ff ff ff       	call   801940 <fsipc>
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a43:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	68 00 30 80 00       	push   $0x803000
  801a51:	6a 05                	push   $0x5
  801a53:	e8 e8 fe ff ff       	call   801940 <fsipc>
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	56                   	push   %esi
  801a5e:	53                   	push   %ebx
  801a5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801a62:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801a67:	83 ec 0c             	sub    $0xc,%esp
  801a6a:	53                   	push   %ebx
  801a6b:	e8 a0 ec ff ff       	call   800710 <strlen>
  801a70:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801a73:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801a78:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a7d:	7f 18                	jg     801a97 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801a7f:	83 ec 08             	sub    $0x8,%esp
  801a82:	53                   	push   %ebx
  801a83:	56                   	push   %esi
  801a84:	e8 c3 ec ff ff       	call   80074c <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	56                   	push   %esi
  801a8e:	6a 06                	push   $0x6
  801a90:	e8 ab fe ff ff       	call   801940 <fsipc>
  801a95:	89 c2                	mov    %eax,%edx
}
  801a97:	89 d0                	mov    %edx,%eax
  801a99:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801a9c:	5b                   	pop    %ebx
  801a9d:	5e                   	pop    %esi
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	68 00 30 80 00       	push   $0x803000
  801aaf:	6a 07                	push   $0x7
  801ab1:	e8 8a fe ff ff       	call   801940 <fsipc>
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <pipe>:
};

int
pipe(int pfd[2])
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
  801abb:	57                   	push   %edi
  801abc:	56                   	push   %esi
  801abd:	53                   	push   %ebx
  801abe:	83 ec 18             	sub    $0x18,%esp
  801ac1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ac4:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801ac7:	50                   	push   %eax
  801ac8:	e8 d3 f3 ff ff       	call   800ea0 <fd_alloc>
  801acd:	89 c3                	mov    %eax,%ebx
  801acf:	83 c4 10             	add    $0x10,%esp
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	0f 88 25 01 00 00    	js     801bff <pipe+0x147>
  801ada:	83 ec 04             	sub    $0x4,%esp
  801add:	68 07 04 00 00       	push   $0x407
  801ae2:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801ae5:	6a 00                	push   $0x0
  801ae7:	e8 32 f0 ff ff       	call   800b1e <sys_page_alloc>
  801aec:	89 c3                	mov    %eax,%ebx
  801aee:	83 c4 10             	add    $0x10,%esp
  801af1:	85 c0                	test   %eax,%eax
  801af3:	0f 88 06 01 00 00    	js     801bff <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801af9:	83 ec 0c             	sub    $0xc,%esp
  801afc:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801aff:	50                   	push   %eax
  801b00:	e8 9b f3 ff ff       	call   800ea0 <fd_alloc>
  801b05:	89 c3                	mov    %eax,%ebx
  801b07:	83 c4 10             	add    $0x10,%esp
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	0f 88 dd 00 00 00    	js     801bef <pipe+0x137>
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	68 07 04 00 00       	push   $0x407
  801b1a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801b1d:	6a 00                	push   $0x0
  801b1f:	e8 fa ef ff ff       	call   800b1e <sys_page_alloc>
  801b24:	89 c3                	mov    %eax,%ebx
  801b26:	83 c4 10             	add    $0x10,%esp
  801b29:	85 c0                	test   %eax,%eax
  801b2b:	0f 88 be 00 00 00    	js     801bef <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b31:	83 ec 0c             	sub    $0xc,%esp
  801b34:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801b37:	e8 3c f3 ff ff       	call   800e78 <fd2data>
  801b3c:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b3e:	83 c4 0c             	add    $0xc,%esp
  801b41:	68 07 04 00 00       	push   $0x407
  801b46:	50                   	push   %eax
  801b47:	6a 00                	push   $0x0
  801b49:	e8 d0 ef ff ff       	call   800b1e <sys_page_alloc>
  801b4e:	89 c3                	mov    %eax,%ebx
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	85 c0                	test   %eax,%eax
  801b55:	0f 88 84 00 00 00    	js     801bdf <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b5b:	83 ec 0c             	sub    $0xc,%esp
  801b5e:	68 07 04 00 00       	push   $0x407
  801b63:	83 ec 0c             	sub    $0xc,%esp
  801b66:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801b69:	e8 0a f3 ff ff       	call   800e78 <fd2data>
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	50                   	push   %eax
  801b72:	6a 00                	push   $0x0
  801b74:	56                   	push   %esi
  801b75:	6a 00                	push   $0x0
  801b77:	e8 e5 ef ff ff       	call   800b61 <sys_page_map>
  801b7c:	89 c3                	mov    %eax,%ebx
  801b7e:	83 c4 20             	add    $0x20,%esp
  801b81:	85 c0                	test   %eax,%eax
  801b83:	78 4c                	js     801bd1 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801b85:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801b8b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801b8e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b90:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801b93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801b9a:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801ba0:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801ba3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ba5:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801ba8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  801baf:	83 ec 0c             	sub    $0xc,%esp
  801bb2:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801bb5:	e8 d6 f2 ff ff       	call   800e90 <fd2num>
  801bba:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801bbc:	83 c4 04             	add    $0x4,%esp
  801bbf:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801bc2:	e8 c9 f2 ff ff       	call   800e90 <fd2num>
  801bc7:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801bca:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcf:	eb 30                	jmp    801c01 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  801bd1:	83 ec 08             	sub    $0x8,%esp
  801bd4:	56                   	push   %esi
  801bd5:	6a 00                	push   $0x0
  801bd7:	e8 c7 ef ff ff       	call   800ba3 <sys_page_unmap>
  801bdc:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801bdf:	83 ec 08             	sub    $0x8,%esp
  801be2:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801be5:	6a 00                	push   $0x0
  801be7:	e8 b7 ef ff ff       	call   800ba3 <sys_page_unmap>
  801bec:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801bef:	83 ec 08             	sub    $0x8,%esp
  801bf2:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801bf5:	6a 00                	push   $0x0
  801bf7:	e8 a7 ef ff ff       	call   800ba3 <sys_page_unmap>
  801bfc:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  801bff:	89 d8                	mov    %ebx,%eax
}
  801c01:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c04:	5b                   	pop    %ebx
  801c05:	5e                   	pop    %esi
  801c06:	5f                   	pop    %edi
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	57                   	push   %edi
  801c0d:	56                   	push   %esi
  801c0e:	53                   	push   %ebx
  801c0f:	83 ec 0c             	sub    $0xc,%esp
  801c12:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801c15:	a1 80 60 80 00       	mov    0x806080,%eax
  801c1a:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801c1d:	83 ec 0c             	sub    $0xc,%esp
  801c20:	ff 75 08             	pushl  0x8(%ebp)
  801c23:	e8 b0 04 00 00       	call   8020d8 <pageref>
  801c28:	89 c3                	mov    %eax,%ebx
  801c2a:	89 3c 24             	mov    %edi,(%esp)
  801c2d:	e8 a6 04 00 00       	call   8020d8 <pageref>
  801c32:	83 c4 10             	add    $0x10,%esp
  801c35:	39 c3                	cmp    %eax,%ebx
  801c37:	0f 94 c0             	sete   %al
  801c3a:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  801c3d:	8b 0d 80 60 80 00    	mov    0x806080,%ecx
  801c43:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  801c46:	39 c6                	cmp    %eax,%esi
  801c48:	74 1b                	je     801c65 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  801c4a:	83 fa 01             	cmp    $0x1,%edx
  801c4d:	75 c6                	jne    801c15 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801c4f:	6a 01                	push   $0x1
  801c51:	8b 41 58             	mov    0x58(%ecx),%eax
  801c54:	50                   	push   %eax
  801c55:	56                   	push   %esi
  801c56:	68 d8 28 80 00       	push   $0x8028d8
  801c5b:	e8 e8 e4 ff ff       	call   800148 <cprintf>
  801c60:	83 c4 10             	add    $0x10,%esp
  801c63:	eb b0                	jmp    801c15 <_pipeisclosed+0xc>
	}
}
  801c65:	89 d0                	mov    %edx,%eax
  801c67:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c6a:	5b                   	pop    %ebx
  801c6b:	5e                   	pop    %esi
  801c6c:	5f                   	pop    %edi
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c75:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801c78:	50                   	push   %eax
  801c79:	ff 75 08             	pushl  0x8(%ebp)
  801c7c:	e8 79 f2 ff ff       	call   800efa <fd_lookup>
  801c81:	83 c4 10             	add    $0x10,%esp
		return r;
  801c84:	89 c2                	mov    %eax,%edx
  801c86:	85 c0                	test   %eax,%eax
  801c88:	78 19                	js     801ca3 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  801c8a:	83 ec 0c             	sub    $0xc,%esp
  801c8d:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801c90:	e8 e3 f1 ff ff       	call   800e78 <fd2data>
	return _pipeisclosed(fd, p);
  801c95:	83 c4 08             	add    $0x8,%esp
  801c98:	50                   	push   %eax
  801c99:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801c9c:	e8 68 ff ff ff       	call   801c09 <_pipeisclosed>
  801ca1:	89 c2                	mov    %eax,%edx
}
  801ca3:	89 d0                	mov    %edx,%eax
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	57                   	push   %edi
  801cab:	56                   	push   %esi
  801cac:	53                   	push   %ebx
  801cad:	83 ec 18             	sub    $0x18,%esp
  801cb0:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  801cb3:	57                   	push   %edi
  801cb4:	e8 bf f1 ff ff       	call   800e78 <fd2data>
  801cb9:	89 c3                	mov    %eax,%ebx
	if (debug)
  801cbb:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc1:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801cc4:	be 00 00 00 00       	mov    $0x0,%esi
  801cc9:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ccc:	73 55                	jae    801d23 <piperead+0x7c>
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
  801cce:	8b 03                	mov    (%ebx),%eax
  801cd0:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cd3:	75 2c                	jne    801d01 <piperead+0x5a>
  801cd5:	85 f6                	test   %esi,%esi
  801cd7:	74 04                	je     801cdd <piperead+0x36>
  801cd9:	89 f0                	mov    %esi,%eax
  801cdb:	eb 48                	jmp    801d25 <piperead+0x7e>
  801cdd:	83 ec 08             	sub    $0x8,%esp
  801ce0:	53                   	push   %ebx
  801ce1:	57                   	push   %edi
  801ce2:	e8 22 ff ff ff       	call   801c09 <_pipeisclosed>
  801ce7:	83 c4 10             	add    $0x10,%esp
  801cea:	85 c0                	test   %eax,%eax
  801cec:	74 07                	je     801cf5 <piperead+0x4e>
  801cee:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf3:	eb 30                	jmp    801d25 <piperead+0x7e>
  801cf5:	e8 05 ee ff ff       	call   800aff <sys_yield>
  801cfa:	8b 03                	mov    (%ebx),%eax
  801cfc:	3b 43 04             	cmp    0x4(%ebx),%eax
  801cff:	74 d4                	je     801cd5 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801d01:	8b 13                	mov    (%ebx),%edx
  801d03:	89 d0                	mov    %edx,%eax
  801d05:	85 d2                	test   %edx,%edx
  801d07:	79 03                	jns    801d0c <piperead+0x65>
  801d09:	8d 42 1f             	lea    0x1f(%edx),%eax
  801d0c:	83 e0 e0             	and    $0xffffffe0,%eax
  801d0f:	29 c2                	sub    %eax,%edx
  801d11:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  801d15:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801d18:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801d1b:	ff 03                	incl   (%ebx)
  801d1d:	46                   	inc    %esi
  801d1e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d21:	72 ab                	jb     801cce <piperead+0x27>
	}
	return i;
  801d23:	89 f0                	mov    %esi,%eax
}
  801d25:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5e                   	pop    %esi
  801d2a:	5f                   	pop    %edi
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	57                   	push   %edi
  801d31:	56                   	push   %esi
  801d32:	53                   	push   %ebx
  801d33:	83 ec 18             	sub    $0x18,%esp
  801d36:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  801d39:	57                   	push   %edi
  801d3a:	e8 39 f1 ff ff       	call   800e78 <fd2data>
  801d3f:	89 c3                	mov    %eax,%ebx
	if (debug)
  801d41:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d47:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801d4a:	be 00 00 00 00       	mov    $0x0,%esi
  801d4f:	3b 75 10             	cmp    0x10(%ebp),%esi
  801d52:	73 55                	jae    801da9 <pipewrite+0x7c>
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
  801d54:	8b 03                	mov    (%ebx),%eax
  801d56:	83 c0 20             	add    $0x20,%eax
  801d59:	39 43 04             	cmp    %eax,0x4(%ebx)
  801d5c:	72 27                	jb     801d85 <pipewrite+0x58>
  801d5e:	83 ec 08             	sub    $0x8,%esp
  801d61:	53                   	push   %ebx
  801d62:	57                   	push   %edi
  801d63:	e8 a1 fe ff ff       	call   801c09 <_pipeisclosed>
  801d68:	83 c4 10             	add    $0x10,%esp
  801d6b:	85 c0                	test   %eax,%eax
  801d6d:	74 07                	je     801d76 <pipewrite+0x49>
  801d6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d74:	eb 35                	jmp    801dab <pipewrite+0x7e>
  801d76:	e8 84 ed ff ff       	call   800aff <sys_yield>
  801d7b:	8b 03                	mov    (%ebx),%eax
  801d7d:	83 c0 20             	add    $0x20,%eax
  801d80:	39 43 04             	cmp    %eax,0x4(%ebx)
  801d83:	73 d9                	jae    801d5e <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d85:	8b 53 04             	mov    0x4(%ebx),%edx
  801d88:	89 d0                	mov    %edx,%eax
  801d8a:	85 d2                	test   %edx,%edx
  801d8c:	79 03                	jns    801d91 <pipewrite+0x64>
  801d8e:	8d 42 1f             	lea    0x1f(%edx),%eax
  801d91:	83 e0 e0             	and    $0xffffffe0,%eax
  801d94:	29 c2                	sub    %eax,%edx
  801d96:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  801d99:	8a 04 31             	mov    (%ecx,%esi,1),%al
  801d9c:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801da0:	ff 43 04             	incl   0x4(%ebx)
  801da3:	46                   	inc    %esi
  801da4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801da7:	72 ab                	jb     801d54 <pipewrite+0x27>
	}
	
	return i;
  801da9:	89 f0                	mov    %esi,%eax
}
  801dab:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801dae:	5b                   	pop    %ebx
  801daf:	5e                   	pop    %esi
  801db0:	5f                   	pop    %edi
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dbb:	83 ec 0c             	sub    $0xc,%esp
  801dbe:	ff 75 08             	pushl  0x8(%ebp)
  801dc1:	e8 b2 f0 ff ff       	call   800e78 <fd2data>
  801dc6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dc8:	83 c4 08             	add    $0x8,%esp
  801dcb:	68 eb 28 80 00       	push   $0x8028eb
  801dd0:	53                   	push   %ebx
  801dd1:	e8 76 e9 ff ff       	call   80074c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dd6:	8b 46 04             	mov    0x4(%esi),%eax
  801dd9:	2b 06                	sub    (%esi),%eax
  801ddb:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801de1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801de8:	00 00 00 
	stat->st_dev = &devpipe;
  801deb:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  801df2:	60 80 00 
	return 0;
}
  801df5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfa:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801dfd:	5b                   	pop    %ebx
  801dfe:	5e                   	pop    %esi
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	53                   	push   %ebx
  801e05:	83 ec 0c             	sub    $0xc,%esp
  801e08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e0b:	53                   	push   %ebx
  801e0c:	6a 00                	push   $0x0
  801e0e:	e8 90 ed ff ff       	call   800ba3 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e13:	89 1c 24             	mov    %ebx,(%esp)
  801e16:	e8 5d f0 ff ff       	call   800e78 <fd2data>
  801e1b:	83 c4 08             	add    $0x8,%esp
  801e1e:	50                   	push   %eax
  801e1f:	6a 00                	push   $0x0
  801e21:	e8 7d ed ff ff       	call   800ba3 <sys_page_unmap>
}
  801e26:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    
	...

00801e2c <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801e38:	6a 01                	push   $0x1
  801e3a:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  801e3d:	50                   	push   %eax
  801e3e:	e8 19 ec ff ff       	call   800a5c <sys_cputs>
}
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <getchar>:

int
getchar(void)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801e4b:	6a 01                	push   $0x1
  801e4d:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  801e50:	50                   	push   %eax
  801e51:	6a 00                	push   $0x0
  801e53:	e8 35 f3 ff ff       	call   80118d <read>
	if (r < 0)
  801e58:	83 c4 10             	add    $0x10,%esp
		return r;
  801e5b:	89 c2                	mov    %eax,%edx
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	78 0d                	js     801e6e <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  801e61:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  801e66:	85 c0                	test   %eax,%eax
  801e68:	7e 04                	jle    801e6e <getchar+0x29>
	return c;
  801e6a:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  801e6e:	89 d0                	mov    %edx,%eax
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <iscons>:


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
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e78:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801e7b:	50                   	push   %eax
  801e7c:	ff 75 08             	pushl  0x8(%ebp)
  801e7f:	e8 76 f0 ff ff       	call   800efa <fd_lookup>
  801e84:	83 c4 10             	add    $0x10,%esp
		return r;
  801e87:	89 c2                	mov    %eax,%edx
  801e89:	85 c0                	test   %eax,%eax
  801e8b:	78 11                	js     801e9e <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  801e8d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801e90:	8b 00                	mov    (%eax),%eax
  801e92:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  801e98:	0f 94 c0             	sete   %al
  801e9b:	0f b6 d0             	movzbl %al,%edx
}
  801e9e:	89 d0                	mov    %edx,%eax
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <opencons>:

int
opencons(void)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801ea8:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801eab:	50                   	push   %eax
  801eac:	e8 ef ef ff ff       	call   800ea0 <fd_alloc>
  801eb1:	83 c4 10             	add    $0x10,%esp
		return r;
  801eb4:	89 c2                	mov    %eax,%edx
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	78 3c                	js     801ef6 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801eba:	83 ec 04             	sub    $0x4,%esp
  801ebd:	68 07 04 00 00       	push   $0x407
  801ec2:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801ec5:	6a 00                	push   $0x0
  801ec7:	e8 52 ec ff ff       	call   800b1e <sys_page_alloc>
  801ecc:	83 c4 10             	add    $0x10,%esp
		return r;
  801ecf:	89 c2                	mov    %eax,%edx
  801ed1:	85 c0                	test   %eax,%eax
  801ed3:	78 21                	js     801ef6 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  801ed5:	a1 60 60 80 00       	mov    0x806060,%eax
  801eda:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  801edd:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  801edf:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801ee2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ee9:	83 ec 0c             	sub    $0xc,%esp
  801eec:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801eef:	e8 9c ef ff ff       	call   800e90 <fd2num>
  801ef4:	89 c2                	mov    %eax,%edx
}
  801ef6:	89 d0                	mov    %edx,%eax
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  801f00:	b8 00 00 00 00       	mov    $0x0,%eax
  801f05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f09:	74 2a                	je     801f35 <cons_read+0x3b>
  801f0b:	eb 05                	jmp    801f12 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801f0d:	e8 ed eb ff ff       	call   800aff <sys_yield>
  801f12:	e8 69 eb ff ff       	call   800a80 <sys_cgetc>
  801f17:	89 c2                	mov    %eax,%edx
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	74 f0                	je     801f0d <cons_read+0x13>
	if (c < 0)
  801f1d:	85 d2                	test   %edx,%edx
  801f1f:	78 14                	js     801f35 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  801f21:	b8 00 00 00 00       	mov    $0x0,%eax
  801f26:	83 fa 04             	cmp    $0x4,%edx
  801f29:	74 0a                	je     801f35 <cons_read+0x3b>
	*(char*)vbuf = c;
  801f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2e:	88 10                	mov    %dl,(%eax)
	return 1;
  801f30:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
  801f3a:	57                   	push   %edi
  801f3b:	56                   	push   %esi
  801f3c:	53                   	push   %ebx
  801f3d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  801f43:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801f46:	be 00 00 00 00       	mov    $0x0,%esi
  801f4b:	39 fe                	cmp    %edi,%esi
  801f4d:	73 3d                	jae    801f8c <cons_write+0x55>
		m = n - tot;
  801f4f:	89 fb                	mov    %edi,%ebx
  801f51:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  801f53:	83 fb 7f             	cmp    $0x7f,%ebx
  801f56:	76 05                	jbe    801f5d <cons_write+0x26>
			m = sizeof(buf) - 1;
  801f58:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801f5d:	83 ec 04             	sub    $0x4,%esp
  801f60:	53                   	push   %ebx
  801f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f64:	01 f0                	add    %esi,%eax
  801f66:	50                   	push   %eax
  801f67:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  801f6d:	50                   	push   %eax
  801f6e:	e8 55 e9 ff ff       	call   8008c8 <memmove>
		sys_cputs(buf, m);
  801f73:	83 c4 08             	add    $0x8,%esp
  801f76:	53                   	push   %ebx
  801f77:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  801f7d:	50                   	push   %eax
  801f7e:	e8 d9 ea ff ff       	call   800a5c <sys_cputs>
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	01 de                	add    %ebx,%esi
  801f88:	39 fe                	cmp    %edi,%esi
  801f8a:	72 c3                	jb     801f4f <cons_write+0x18>
	}
	return tot;
}
  801f8c:	89 f0                	mov    %esi,%eax
  801f8e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801f91:	5b                   	pop    %ebx
  801f92:	5e                   	pop    %esi
  801f93:	5f                   	pop    %edi
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <cons_close>:

int
cons_close(struct Fd *fd)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fa6:	68 f7 28 80 00       	push   $0x8028f7
  801fab:	ff 75 0c             	pushl  0xc(%ebp)
  801fae:	e8 99 e7 ff ff       	call   80074c <strcpy>
	return 0;
}
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    
	...

00801fbc <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
  801fbf:	53                   	push   %ebx
  801fc0:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  801fc3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  801fc6:	83 3d 84 60 80 00 00 	cmpl   $0x0,0x806084
  801fcd:	74 16                	je     801fe5 <_panic+0x29>
		cprintf("%s: ", argv0);
  801fcf:	83 ec 08             	sub    $0x8,%esp
  801fd2:	ff 35 84 60 80 00    	pushl  0x806084
  801fd8:	68 fe 28 80 00       	push   $0x8028fe
  801fdd:	e8 66 e1 ff ff       	call   800148 <cprintf>
  801fe2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801fe5:	ff 75 0c             	pushl  0xc(%ebp)
  801fe8:	ff 75 08             	pushl  0x8(%ebp)
  801feb:	ff 35 00 60 80 00    	pushl  0x806000
  801ff1:	68 03 29 80 00       	push   $0x802903
  801ff6:	e8 4d e1 ff ff       	call   800148 <cprintf>
	vcprintf(fmt, ap);
  801ffb:	83 c4 08             	add    $0x8,%esp
  801ffe:	53                   	push   %ebx
  801fff:	ff 75 10             	pushl  0x10(%ebp)
  802002:	e8 f0 e0 ff ff       	call   8000f7 <vcprintf>
	cprintf("\n");
  802007:	c7 04 24 e9 28 80 00 	movl   $0x8028e9,(%esp)
  80200e:	e8 35 e1 ff ff       	call   800148 <cprintf>

	// Cause a breakpoint exception
	while (1)
  802013:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  802016:	cc                   	int3   
  802017:	eb fd                	jmp    802016 <_panic+0x5a>
  802019:	00 00                	add    %al,(%eax)
	...

0080201c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	56                   	push   %esi
  802020:	53                   	push   %ebx
  802021:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802024:	8b 45 0c             	mov    0xc(%ebp),%eax
  802027:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80202a:	85 c0                	test   %eax,%eax
  80202c:	75 12                	jne    802040 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  80202e:	83 ec 0c             	sub    $0xc,%esp
  802031:	68 00 00 c0 ee       	push   $0xeec00000
  802036:	e8 93 ec ff ff       	call   800cce <sys_ipc_recv>
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	eb 0c                	jmp    80204c <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802040:	83 ec 0c             	sub    $0xc,%esp
  802043:	50                   	push   %eax
  802044:	e8 85 ec ff ff       	call   800cce <sys_ipc_recv>
  802049:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  80204c:	89 c2                	mov    %eax,%edx
  80204e:	85 c0                	test   %eax,%eax
  802050:	78 24                	js     802076 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  802052:	85 db                	test   %ebx,%ebx
  802054:	74 0a                	je     802060 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  802056:	a1 80 60 80 00       	mov    0x806080,%eax
  80205b:	8b 40 74             	mov    0x74(%eax),%eax
  80205e:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802060:	85 f6                	test   %esi,%esi
  802062:	74 0a                	je     80206e <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802064:	a1 80 60 80 00       	mov    0x806080,%eax
  802069:	8b 40 78             	mov    0x78(%eax),%eax
  80206c:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  80206e:	a1 80 60 80 00       	mov    0x806080,%eax
  802073:	8b 50 70             	mov    0x70(%eax),%edx

}
  802076:	89 d0                	mov    %edx,%eax
  802078:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80207b:	5b                   	pop    %ebx
  80207c:	5e                   	pop    %esi
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <ipc_send>:

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
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	57                   	push   %edi
  802083:	56                   	push   %esi
  802084:	53                   	push   %ebx
  802085:	83 ec 0c             	sub    $0xc,%esp
  802088:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80208b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80208e:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802091:	85 db                	test   %ebx,%ebx
  802093:	75 0a                	jne    80209f <ipc_send+0x20>
    pg = (void *) UTOP;
  802095:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  80209a:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  80209f:	56                   	push   %esi
  8020a0:	53                   	push   %ebx
  8020a1:	57                   	push   %edi
  8020a2:	ff 75 08             	pushl  0x8(%ebp)
  8020a5:	e8 01 ec ff ff       	call   800cab <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  8020aa:	83 c4 10             	add    $0x10,%esp
  8020ad:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020b0:	75 07                	jne    8020b9 <ipc_send+0x3a>
      sys_yield();
  8020b2:	e8 48 ea ff ff       	call   800aff <sys_yield>
  8020b7:	eb e6                	jmp    80209f <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	79 12                	jns    8020cf <ipc_send+0x50>
  8020bd:	50                   	push   %eax
  8020be:	68 1f 29 80 00       	push   $0x80291f
  8020c3:	6a 49                	push   $0x49
  8020c5:	68 3c 29 80 00       	push   $0x80293c
  8020ca:	e8 ed fe ff ff       	call   801fbc <_panic>
    else break;
  }
}
  8020cf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8020d2:	5b                   	pop    %ebx
  8020d3:	5e                   	pop    %esi
  8020d4:	5f                   	pop    %edi
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    
	...

008020d8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8020de:	89 c8                	mov    %ecx,%eax
  8020e0:	c1 e8 16             	shr    $0x16,%eax
  8020e3:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8020ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ef:	a8 01                	test   $0x1,%al
  8020f1:	74 28                	je     80211b <pageref+0x43>
	pte = vpt[VPN(v)];
  8020f3:	89 c8                	mov    %ecx,%eax
  8020f5:	c1 e8 0c             	shr    $0xc,%eax
  8020f8:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  8020ff:	ba 00 00 00 00       	mov    $0x0,%edx
  802104:	a8 01                	test   $0x1,%al
  802106:	74 13                	je     80211b <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  802108:	c1 e8 0c             	shr    $0xc,%eax
  80210b:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80210e:	c1 e0 02             	shl    $0x2,%eax
  802111:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802118:	0f b7 d0             	movzwl %ax,%edx
}
  80211b:	89 d0                	mov    %edx,%eax
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    
	...

00802120 <__udivdi3>:
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	57                   	push   %edi
  802124:	56                   	push   %esi
  802125:	83 ec 14             	sub    $0x14,%esp
  802128:	8b 55 14             	mov    0x14(%ebp),%edx
  80212b:	8b 75 08             	mov    0x8(%ebp),%esi
  80212e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802131:	8b 45 10             	mov    0x10(%ebp),%eax
  802134:	85 d2                	test   %edx,%edx
  802136:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802139:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80213c:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  80213f:	89 fe                	mov    %edi,%esi
  802141:	75 11                	jne    802154 <__udivdi3+0x34>
  802143:	39 f8                	cmp    %edi,%eax
  802145:	76 4d                	jbe    802194 <__udivdi3+0x74>
  802147:	89 fa                	mov    %edi,%edx
  802149:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80214c:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80214f:	89 c7                	mov    %eax,%edi
  802151:	eb 09                	jmp    80215c <__udivdi3+0x3c>
  802153:	90                   	nop    
  802154:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  802157:	76 17                	jbe    802170 <__udivdi3+0x50>
  802159:	31 ff                	xor    %edi,%edi
  80215b:	90                   	nop    
  80215c:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  802163:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802166:	83 c4 14             	add    $0x14,%esp
  802169:	5e                   	pop    %esi
  80216a:	89 f8                	mov    %edi,%eax
  80216c:	5f                   	pop    %edi
  80216d:	c9                   	leave  
  80216e:	c3                   	ret    
  80216f:	90                   	nop    
  802170:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802174:	89 c7                	mov    %eax,%edi
  802176:	83 f7 1f             	xor    $0x1f,%edi
  802179:	75 4d                	jne    8021c8 <__udivdi3+0xa8>
  80217b:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  80217e:	77 0a                	ja     80218a <__udivdi3+0x6a>
  802180:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802183:	31 ff                	xor    %edi,%edi
  802185:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802188:	72 d2                	jb     80215c <__udivdi3+0x3c>
  80218a:	bf 01 00 00 00       	mov    $0x1,%edi
  80218f:	eb cb                	jmp    80215c <__udivdi3+0x3c>
  802191:	8d 76 00             	lea    0x0(%esi),%esi
  802194:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802197:	85 c0                	test   %eax,%eax
  802199:	75 0e                	jne    8021a9 <__udivdi3+0x89>
  80219b:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a0:	31 c9                	xor    %ecx,%ecx
  8021a2:	31 d2                	xor    %edx,%edx
  8021a4:	f7 f1                	div    %ecx
  8021a6:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8021a9:	89 f0                	mov    %esi,%eax
  8021ab:	31 d2                	xor    %edx,%edx
  8021ad:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8021b0:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8021b3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8021b6:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8021b9:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8021bc:	83 c4 14             	add    $0x14,%esp
  8021bf:	89 c7                	mov    %eax,%edi
  8021c1:	5e                   	pop    %esi
  8021c2:	89 f8                	mov    %edi,%eax
  8021c4:	5f                   	pop    %edi
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    
  8021c7:	90                   	nop    
  8021c8:	b8 20 00 00 00       	mov    $0x20,%eax
  8021cd:	29 f8                	sub    %edi,%eax
  8021cf:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  8021d2:	89 f9                	mov    %edi,%ecx
  8021d4:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8021d7:	d3 e2                	shl    %cl,%edx
  8021d9:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8021dc:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8021df:	d3 e8                	shr    %cl,%eax
  8021e1:	09 c2                	or     %eax,%edx
  8021e3:	89 f9                	mov    %edi,%ecx
  8021e5:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8021e8:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8021eb:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8021ee:	89 f2                	mov    %esi,%edx
  8021f0:	d3 ea                	shr    %cl,%edx
  8021f2:	89 f9                	mov    %edi,%ecx
  8021f4:	d3 e6                	shl    %cl,%esi
  8021f6:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8021f9:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8021fc:	d3 e8                	shr    %cl,%eax
  8021fe:	09 c6                	or     %eax,%esi
  802200:	89 f9                	mov    %edi,%ecx
  802202:	89 f0                	mov    %esi,%eax
  802204:	f7 75 f4             	divl   0xfffffff4(%ebp)
  802207:	89 d6                	mov    %edx,%esi
  802209:	89 c7                	mov    %eax,%edi
  80220b:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  80220e:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802211:	f7 e7                	mul    %edi
  802213:	39 f2                	cmp    %esi,%edx
  802215:	77 0f                	ja     802226 <__udivdi3+0x106>
  802217:	0f 85 3f ff ff ff    	jne    80215c <__udivdi3+0x3c>
  80221d:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802220:	0f 86 36 ff ff ff    	jbe    80215c <__udivdi3+0x3c>
  802226:	4f                   	dec    %edi
  802227:	e9 30 ff ff ff       	jmp    80215c <__udivdi3+0x3c>

0080222c <__umoddi3>:
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	57                   	push   %edi
  802230:	56                   	push   %esi
  802231:	83 ec 30             	sub    $0x30,%esp
  802234:	8b 55 14             	mov    0x14(%ebp),%edx
  802237:	8b 45 10             	mov    0x10(%ebp),%eax
  80223a:	89 d7                	mov    %edx,%edi
  80223c:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  80223f:	89 c6                	mov    %eax,%esi
  802241:	8b 55 0c             	mov    0xc(%ebp),%edx
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	85 ff                	test   %edi,%edi
  802249:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802250:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802257:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  80225a:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80225d:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802260:	75 3e                	jne    8022a0 <__umoddi3+0x74>
  802262:	39 d6                	cmp    %edx,%esi
  802264:	0f 86 a2 00 00 00    	jbe    80230c <__umoddi3+0xe0>
  80226a:	f7 f6                	div    %esi
  80226c:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80226f:	85 c9                	test   %ecx,%ecx
  802271:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802274:	74 1b                	je     802291 <__umoddi3+0x65>
  802276:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802279:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  80227c:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802283:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802286:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802289:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  80228c:	89 10                	mov    %edx,(%eax)
  80228e:	89 48 04             	mov    %ecx,0x4(%eax)
  802291:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802294:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802297:	83 c4 30             	add    $0x30,%esp
  80229a:	5e                   	pop    %esi
  80229b:	5f                   	pop    %edi
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    
  80229e:	89 f6                	mov    %esi,%esi
  8022a0:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  8022a3:	76 1f                	jbe    8022c4 <__umoddi3+0x98>
  8022a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a8:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8022ab:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8022ae:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  8022b1:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8022b4:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8022b7:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  8022ba:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8022bd:	83 c4 30             	add    $0x30,%esp
  8022c0:	5e                   	pop    %esi
  8022c1:	5f                   	pop    %edi
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    
  8022c4:	0f bd c7             	bsr    %edi,%eax
  8022c7:	83 f0 1f             	xor    $0x1f,%eax
  8022ca:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  8022cd:	75 61                	jne    802330 <__umoddi3+0x104>
  8022cf:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  8022d2:	77 05                	ja     8022d9 <__umoddi3+0xad>
  8022d4:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  8022d7:	72 10                	jb     8022e9 <__umoddi3+0xbd>
  8022d9:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8022dc:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8022df:	29 f0                	sub    %esi,%eax
  8022e1:	19 fa                	sbb    %edi,%edx
  8022e3:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8022e6:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8022e9:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8022ec:	85 d2                	test   %edx,%edx
  8022ee:	74 a1                	je     802291 <__umoddi3+0x65>
  8022f0:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8022f3:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8022f6:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8022f9:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  8022fc:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8022ff:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802302:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802305:	89 01                	mov    %eax,(%ecx)
  802307:	89 51 04             	mov    %edx,0x4(%ecx)
  80230a:	eb 85                	jmp    802291 <__umoddi3+0x65>
  80230c:	85 f6                	test   %esi,%esi
  80230e:	75 0b                	jne    80231b <__umoddi3+0xef>
  802310:	b8 01 00 00 00       	mov    $0x1,%eax
  802315:	31 d2                	xor    %edx,%edx
  802317:	f7 f6                	div    %esi
  802319:	89 c6                	mov    %eax,%esi
  80231b:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80231e:	89 fa                	mov    %edi,%edx
  802320:	f7 f6                	div    %esi
  802322:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802325:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802328:	f7 f6                	div    %esi
  80232a:	e9 3d ff ff ff       	jmp    80226c <__umoddi3+0x40>
  80232f:	90                   	nop    
  802330:	b8 20 00 00 00       	mov    $0x20,%eax
  802335:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802338:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  80233b:	89 fa                	mov    %edi,%edx
  80233d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802340:	d3 e2                	shl    %cl,%edx
  802342:	89 f0                	mov    %esi,%eax
  802344:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802347:	d3 e8                	shr    %cl,%eax
  802349:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80234c:	d3 e6                	shl    %cl,%esi
  80234e:	89 d7                	mov    %edx,%edi
  802350:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802353:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802356:	09 c7                	or     %eax,%edi
  802358:	d3 ea                	shr    %cl,%edx
  80235a:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80235d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802360:	d3 e0                	shl    %cl,%eax
  802362:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802365:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802368:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80236b:	d3 e8                	shr    %cl,%eax
  80236d:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802370:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802373:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802376:	f7 f7                	div    %edi
  802378:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80237b:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  80237e:	f7 e6                	mul    %esi
  802380:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  802383:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  802386:	77 0a                	ja     802392 <__umoddi3+0x166>
  802388:	75 12                	jne    80239c <__umoddi3+0x170>
  80238a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80238d:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802390:	76 0a                	jbe    80239c <__umoddi3+0x170>
  802392:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802395:	29 f1                	sub    %esi,%ecx
  802397:	19 fa                	sbb    %edi,%edx
  802399:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  80239c:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80239f:	85 c0                	test   %eax,%eax
  8023a1:	0f 84 ea fe ff ff    	je     802291 <__umoddi3+0x65>
  8023a7:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8023aa:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8023ad:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  8023b0:	19 d1                	sbb    %edx,%ecx
  8023b2:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  8023b5:	89 ca                	mov    %ecx,%edx
  8023b7:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8023ba:	d3 e2                	shl    %cl,%edx
  8023bc:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8023bf:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8023c2:	d3 e8                	shr    %cl,%eax
  8023c4:	09 c2                	or     %eax,%edx
  8023c6:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8023c9:	d3 e8                	shr    %cl,%eax
  8023cb:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8023ce:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8023d1:	e9 ad fe ff ff       	jmp    802283 <__umoddi3+0x57>
