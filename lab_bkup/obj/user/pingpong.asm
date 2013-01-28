
obj/user/pingpong:     file format elf32-i386

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
  80002c:	e8 93 00 00 00       	call   8000c4 <libmain>
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
  800037:	53                   	push   %ebx
  800038:	83 ec 04             	sub    $0x4,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003b:	e8 b6 10 00 00       	call   8010f6 <fork>
  800040:	89 45 f8             	mov    %eax,0xfffffff8(%ebp)
  800043:	85 c0                	test   %eax,%eax
  800045:	74 2b                	je     800072 <umain+0x3e>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800047:	83 ec 04             	sub    $0x4,%esp
  80004a:	50                   	push   %eax
  80004b:	83 ec 08             	sub    $0x8,%esp
  80004e:	e8 f5 0a 00 00       	call   800b48 <sys_getenvid>
  800053:	83 c4 08             	add    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 a0 28 80 00       	push   $0x8028a0
  80005c:	e8 4f 01 00 00       	call   8001b0 <cprintf>
		ipc_send(who, 0, 0, 0);
  800061:	6a 00                	push   $0x0
  800063:	6a 00                	push   $0x0
  800065:	6a 00                	push   $0x0
  800067:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80006a:	e8 74 12 00 00       	call   8012e3 <ipc_send>
  80006f:	83 c4 20             	add    $0x20,%esp
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800072:	83 ec 04             	sub    $0x4,%esp
  800075:	6a 00                	push   $0x0
  800077:	6a 00                	push   $0x0
  800079:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80007c:	50                   	push   %eax
  80007d:	e8 fe 11 00 00       	call   801280 <ipc_recv>
  800082:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  800084:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  800087:	50                   	push   %eax
  800088:	83 ec 08             	sub    $0x8,%esp
  80008b:	e8 b8 0a 00 00       	call   800b48 <sys_getenvid>
  800090:	83 c4 08             	add    $0x8,%esp
  800093:	50                   	push   %eax
  800094:	68 b6 28 80 00       	push   $0x8028b6
  800099:	e8 12 01 00 00       	call   8001b0 <cprintf>
		if (i == 10)
  80009e:	83 c4 20             	add    $0x20,%esp
  8000a1:	83 fb 0a             	cmp    $0xa,%ebx
  8000a4:	74 16                	je     8000bc <umain+0x88>
			return;
		i++;
  8000a6:	43                   	inc    %ebx
		ipc_send(who, i, 0, 0);
  8000a7:	6a 00                	push   $0x0
  8000a9:	6a 00                	push   $0x0
  8000ab:	53                   	push   %ebx
  8000ac:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8000af:	e8 2f 12 00 00       	call   8012e3 <ipc_send>
		if (i == 10)
  8000b4:	83 c4 10             	add    $0x10,%esp
  8000b7:	83 fb 0a             	cmp    $0xa,%ebx
  8000ba:	75 b6                	jne    800072 <umain+0x3e>
			return;
	}
		
}
  8000bc:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8000bf:	c9                   	leave  
  8000c0:	c3                   	ret    
  8000c1:	00 00                	add    %al,(%eax)
	...

008000c4 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	56                   	push   %esi
  8000c8:	53                   	push   %ebx
  8000c9:	8b 75 08             	mov    0x8(%ebp),%esi
  8000cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  8000cf:	e8 74 0a 00 00       	call   800b48 <sys_getenvid>
  8000d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d9:	c1 e0 07             	shl    $0x7,%eax
  8000dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e1:	a3 80 60 80 00       	mov    %eax,0x806080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e6:	85 f6                	test   %esi,%esi
  8000e8:	7e 07                	jle    8000f1 <libmain+0x2d>
		binaryname = argv[0];
  8000ea:	8b 03                	mov    (%ebx),%eax
  8000ec:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  8000f1:	83 ec 08             	sub    $0x8,%esp
  8000f4:	53                   	push   %ebx
  8000f5:	56                   	push   %esi
  8000f6:	e8 39 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000fb:	e8 08 00 00 00       	call   800108 <exit>
}
  800100:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800103:	5b                   	pop    %ebx
  800104:	5e                   	pop    %esi
  800105:	c9                   	leave  
  800106:	c3                   	ret    
	...

00800108 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80010e:	e8 f9 13 00 00       	call   80150c <close_all>
	sys_env_destroy(0);
  800113:	83 ec 0c             	sub    $0xc,%esp
  800116:	6a 00                	push   $0x0
  800118:	e8 ea 09 00 00       	call   800b07 <sys_env_destroy>
}
  80011d:	c9                   	leave  
  80011e:	c3                   	ret    
	...

00800120 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	53                   	push   %ebx
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012a:	8b 03                	mov    (%ebx),%eax
  80012c:	8b 55 08             	mov    0x8(%ebp),%edx
  80012f:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  800133:	40                   	inc    %eax
  800134:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800136:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013b:	75 1a                	jne    800157 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  80013d:	83 ec 08             	sub    $0x8,%esp
  800140:	68 ff 00 00 00       	push   $0xff
  800145:	8d 43 08             	lea    0x8(%ebx),%eax
  800148:	50                   	push   %eax
  800149:	e8 76 09 00 00       	call   800ac4 <sys_cputs>
		b->idx = 0;
  80014e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800154:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800157:	ff 43 04             	incl   0x4(%ebx)
}
  80015a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80015d:	c9                   	leave  
  80015e:	c3                   	ret    

0080015f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800168:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  80016f:	00 00 00 
	b.cnt = 0;
  800172:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800179:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017c:	ff 75 0c             	pushl  0xc(%ebp)
  80017f:	ff 75 08             	pushl  0x8(%ebp)
  800182:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800188:	50                   	push   %eax
  800189:	68 20 01 80 00       	push   $0x800120
  80018e:	e8 4f 01 00 00       	call   8002e2 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800193:	83 c4 08             	add    $0x8,%esp
  800196:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  80019c:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  8001a2:	50                   	push   %eax
  8001a3:	e8 1c 09 00 00       	call   800ac4 <sys_cputs>

	return b.cnt;
  8001a8:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

008001b0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b9:	50                   	push   %eax
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 9d ff ff ff       	call   80015f <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c2:	c9                   	leave  
  8001c3:	c3                   	ret    

008001c4 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	57                   	push   %edi
  8001c8:	56                   	push   %esi
  8001c9:	53                   	push   %ebx
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	8b 75 10             	mov    0x10(%ebp),%esi
  8001d0:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d3:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8001d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8001de:	39 fa                	cmp    %edi,%edx
  8001e0:	77 39                	ja     80021b <printnum+0x57>
  8001e2:	72 04                	jb     8001e8 <printnum+0x24>
  8001e4:	39 f0                	cmp    %esi,%eax
  8001e6:	77 33                	ja     80021b <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e8:	83 ec 04             	sub    $0x4,%esp
  8001eb:	ff 75 20             	pushl  0x20(%ebp)
  8001ee:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  8001f1:	50                   	push   %eax
  8001f2:	ff 75 18             	pushl  0x18(%ebp)
  8001f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8001f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fd:	52                   	push   %edx
  8001fe:	50                   	push   %eax
  8001ff:	57                   	push   %edi
  800200:	56                   	push   %esi
  800201:	e8 d6 23 00 00       	call   8025dc <__udivdi3>
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	52                   	push   %edx
  80020a:	50                   	push   %eax
  80020b:	ff 75 0c             	pushl  0xc(%ebp)
  80020e:	ff 75 08             	pushl  0x8(%ebp)
  800211:	e8 ae ff ff ff       	call   8001c4 <printnum>
  800216:	83 c4 20             	add    $0x20,%esp
  800219:	eb 19                	jmp    800234 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80021b:	4b                   	dec    %ebx
  80021c:	85 db                	test   %ebx,%ebx
  80021e:	7e 14                	jle    800234 <printnum+0x70>
  800220:	83 ec 08             	sub    $0x8,%esp
  800223:	ff 75 0c             	pushl  0xc(%ebp)
  800226:	ff 75 20             	pushl  0x20(%ebp)
  800229:	ff 55 08             	call   *0x8(%ebp)
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	4b                   	dec    %ebx
  800230:	85 db                	test   %ebx,%ebx
  800232:	7f ec                	jg     800220 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	ff 75 0c             	pushl  0xc(%ebp)
  80023a:	8b 45 18             	mov    0x18(%ebp),%eax
  80023d:	ba 00 00 00 00       	mov    $0x0,%edx
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	52                   	push   %edx
  800246:	50                   	push   %eax
  800247:	57                   	push   %edi
  800248:	56                   	push   %esi
  800249:	e8 9a 24 00 00       	call   8026e8 <__umoddi3>
  80024e:	83 c4 14             	add    $0x14,%esp
  800251:	0f be 80 da 29 80 00 	movsbl 0x8029da(%eax),%eax
  800258:	50                   	push   %eax
  800259:	ff 55 08             	call   *0x8(%ebp)
}
  80025c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80025f:	5b                   	pop    %ebx
  800260:	5e                   	pop    %esi
  800261:	5f                   	pop    %edi
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80026a:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80026d:	83 f8 01             	cmp    $0x1,%eax
  800270:	7e 0f                	jle    800281 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  800272:	8b 01                	mov    (%ecx),%eax
  800274:	83 c0 08             	add    $0x8,%eax
  800277:	89 01                	mov    %eax,(%ecx)
  800279:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80027c:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80027f:	eb 24                	jmp    8002a5 <getuint+0x41>
	else if (lflag)
  800281:	85 c0                	test   %eax,%eax
  800283:	74 11                	je     800296 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800285:	8b 01                	mov    (%ecx),%eax
  800287:	83 c0 04             	add    $0x4,%eax
  80028a:	89 01                	mov    %eax,(%ecx)
  80028c:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80028f:	ba 00 00 00 00       	mov    $0x0,%edx
  800294:	eb 0f                	jmp    8002a5 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  800296:	8b 01                	mov    (%ecx),%eax
  800298:	83 c0 04             	add    $0x4,%eax
  80029b:	89 01                	mov    %eax,(%ecx)
  80029d:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8002a0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8002b0:	83 f8 01             	cmp    $0x1,%eax
  8002b3:	7e 0f                	jle    8002c4 <getint+0x1d>
		return va_arg(*ap, long long);
  8002b5:	8b 02                	mov    (%edx),%eax
  8002b7:	83 c0 08             	add    $0x8,%eax
  8002ba:	89 02                	mov    %eax,(%edx)
  8002bc:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8002bf:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8002c2:	eb 1c                	jmp    8002e0 <getint+0x39>
	else if (lflag)
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	74 0d                	je     8002d5 <getint+0x2e>
		return va_arg(*ap, long);
  8002c8:	8b 02                	mov    (%edx),%eax
  8002ca:	83 c0 04             	add    $0x4,%eax
  8002cd:	89 02                	mov    %eax,(%edx)
  8002cf:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8002d2:	99                   	cltd   
  8002d3:	eb 0b                	jmp    8002e0 <getint+0x39>
	else
		return va_arg(*ap, int);
  8002d5:	8b 02                	mov    (%edx),%eax
  8002d7:	83 c0 04             	add    $0x4,%eax
  8002da:	89 02                	mov    %eax,(%edx)
  8002dc:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8002df:	99                   	cltd   
}
  8002e0:	c9                   	leave  
  8002e1:	c3                   	ret    

008002e2 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002e2:	55                   	push   %ebp
  8002e3:	89 e5                	mov    %esp,%ebp
  8002e5:	57                   	push   %edi
  8002e6:	56                   	push   %esi
  8002e7:	53                   	push   %ebx
  8002e8:	83 ec 1c             	sub    $0x1c,%esp
  8002eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  8002ee:	0f b6 13             	movzbl (%ebx),%edx
  8002f1:	43                   	inc    %ebx
  8002f2:	83 fa 25             	cmp    $0x25,%edx
  8002f5:	74 1e                	je     800315 <vprintfmt+0x33>
  8002f7:	85 d2                	test   %edx,%edx
  8002f9:	0f 84 d7 02 00 00    	je     8005d6 <vprintfmt+0x2f4>
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	ff 75 0c             	pushl  0xc(%ebp)
  800305:	52                   	push   %edx
  800306:	ff 55 08             	call   *0x8(%ebp)
  800309:	83 c4 10             	add    $0x10,%esp
  80030c:	0f b6 13             	movzbl (%ebx),%edx
  80030f:	43                   	inc    %ebx
  800310:	83 fa 25             	cmp    $0x25,%edx
  800313:	75 e2                	jne    8002f7 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  800315:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  800319:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  800320:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  800325:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  80032a:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800331:	0f b6 13             	movzbl (%ebx),%edx
  800334:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  800337:	43                   	inc    %ebx
  800338:	83 f8 55             	cmp    $0x55,%eax
  80033b:	0f 87 70 02 00 00    	ja     8005b1 <vprintfmt+0x2cf>
  800341:	ff 24 85 5c 2a 80 00 	jmp    *0x802a5c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800348:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  80034c:	eb e3                	jmp    800331 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80034e:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  800352:	eb dd                	jmp    800331 <vprintfmt+0x4f>

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
  800354:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800359:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  80035c:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  800360:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800363:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  800366:	83 f8 09             	cmp    $0x9,%eax
  800369:	77 27                	ja     800392 <vprintfmt+0xb0>
  80036b:	43                   	inc    %ebx
  80036c:	eb eb                	jmp    800359 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80036e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800372:	8b 45 14             	mov    0x14(%ebp),%eax
  800375:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800378:	eb 18                	jmp    800392 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  80037a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80037e:	79 b1                	jns    800331 <vprintfmt+0x4f>
				width = 0;
  800380:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800387:	eb a8                	jmp    800331 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800389:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  800390:	eb 9f                	jmp    800331 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  800392:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800396:	79 99                	jns    800331 <vprintfmt+0x4f>
				width = precision, precision = -1;
  800398:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  80039b:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  8003a0:	eb 8f                	jmp    800331 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003a2:	41                   	inc    %ecx
			goto reswitch;
  8003a3:	eb 8c                	jmp    800331 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003a5:	83 ec 08             	sub    $0x8,%esp
  8003a8:	ff 75 0c             	pushl  0xc(%ebp)
  8003ab:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8003af:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b2:	ff 70 fc             	pushl  0xfffffffc(%eax)
  8003b5:	ff 55 08             	call   *0x8(%ebp)
			break;
  8003b8:	83 c4 10             	add    $0x10,%esp
  8003bb:	e9 2e ff ff ff       	jmp    8002ee <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003c0:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8003c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c7:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	79 02                	jns    8003d0 <vprintfmt+0xee>
				err = -err;
  8003ce:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8003d0:	83 f8 0e             	cmp    $0xe,%eax
  8003d3:	7f 0b                	jg     8003e0 <vprintfmt+0xfe>
  8003d5:	8b 3c 85 20 2a 80 00 	mov    0x802a20(,%eax,4),%edi
  8003dc:	85 ff                	test   %edi,%edi
  8003de:	75 19                	jne    8003f9 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8003e0:	50                   	push   %eax
  8003e1:	68 eb 29 80 00       	push   $0x8029eb
  8003e6:	ff 75 0c             	pushl  0xc(%ebp)
  8003e9:	ff 75 08             	pushl  0x8(%ebp)
  8003ec:	e8 ed 01 00 00       	call   8005de <printfmt>
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	e9 f5 fe ff ff       	jmp    8002ee <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  8003f9:	57                   	push   %edi
  8003fa:	68 89 2e 80 00       	push   $0x802e89
  8003ff:	ff 75 0c             	pushl  0xc(%ebp)
  800402:	ff 75 08             	pushl  0x8(%ebp)
  800405:	e8 d4 01 00 00       	call   8005de <printfmt>
  80040a:	83 c4 10             	add    $0x10,%esp
			break;
  80040d:	e9 dc fe ff ff       	jmp    8002ee <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800412:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800416:	8b 45 14             	mov    0x14(%ebp),%eax
  800419:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  80041c:	85 ff                	test   %edi,%edi
  80041e:	75 05                	jne    800425 <vprintfmt+0x143>
				p = "(null)";
  800420:	bf f4 29 80 00       	mov    $0x8029f4,%edi
			if (width > 0 && padc != '-')
  800425:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800429:	7e 3b                	jle    800466 <vprintfmt+0x184>
  80042b:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  80042f:	74 35                	je     800466 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	56                   	push   %esi
  800435:	57                   	push   %edi
  800436:	e8 56 03 00 00       	call   800791 <strnlen>
  80043b:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  80043e:	83 c4 10             	add    $0x10,%esp
  800441:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800445:	7e 1f                	jle    800466 <vprintfmt+0x184>
  800447:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  80044b:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  80044e:	83 ec 08             	sub    $0x8,%esp
  800451:	ff 75 0c             	pushl  0xc(%ebp)
  800454:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  800457:	ff 55 08             	call   *0x8(%ebp)
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800460:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800464:	7f e8                	jg     80044e <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800466:	0f be 17             	movsbl (%edi),%edx
  800469:	47                   	inc    %edi
  80046a:	85 d2                	test   %edx,%edx
  80046c:	74 44                	je     8004b2 <vprintfmt+0x1d0>
  80046e:	85 f6                	test   %esi,%esi
  800470:	78 03                	js     800475 <vprintfmt+0x193>
  800472:	4e                   	dec    %esi
  800473:	78 3d                	js     8004b2 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800475:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800479:	74 18                	je     800493 <vprintfmt+0x1b1>
  80047b:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80047e:	83 f8 5e             	cmp    $0x5e,%eax
  800481:	76 10                	jbe    800493 <vprintfmt+0x1b1>
					putch('?', putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	ff 75 0c             	pushl  0xc(%ebp)
  800489:	6a 3f                	push   $0x3f
  80048b:	ff 55 08             	call   *0x8(%ebp)
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	eb 0d                	jmp    8004a0 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  800493:	83 ec 08             	sub    $0x8,%esp
  800496:	ff 75 0c             	pushl  0xc(%ebp)
  800499:	52                   	push   %edx
  80049a:	ff 55 08             	call   *0x8(%ebp)
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8004a3:	0f be 17             	movsbl (%edi),%edx
  8004a6:	47                   	inc    %edi
  8004a7:	85 d2                	test   %edx,%edx
  8004a9:	74 07                	je     8004b2 <vprintfmt+0x1d0>
  8004ab:	85 f6                	test   %esi,%esi
  8004ad:	78 c6                	js     800475 <vprintfmt+0x193>
  8004af:	4e                   	dec    %esi
  8004b0:	79 c3                	jns    800475 <vprintfmt+0x193>
			for (; width > 0; width--)
  8004b2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004b6:	0f 8e 32 fe ff ff    	jle    8002ee <vprintfmt+0xc>
				putch(' ', putdat);
  8004bc:	83 ec 08             	sub    $0x8,%esp
  8004bf:	ff 75 0c             	pushl  0xc(%ebp)
  8004c2:	6a 20                	push   $0x20
  8004c4:	ff 55 08             	call   *0x8(%ebp)
  8004c7:	83 c4 10             	add    $0x10,%esp
  8004ca:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8004cd:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004d1:	7f e9                	jg     8004bc <vprintfmt+0x1da>
			break;
  8004d3:	e9 16 fe ff ff       	jmp    8002ee <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8004d8:	51                   	push   %ecx
  8004d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8004dc:	50                   	push   %eax
  8004dd:	e8 c5 fd ff ff       	call   8002a7 <getint>
  8004e2:	89 c6                	mov    %eax,%esi
  8004e4:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8004e6:	83 c4 08             	add    $0x8,%esp
  8004e9:	85 d2                	test   %edx,%edx
  8004eb:	79 15                	jns    800502 <vprintfmt+0x220>
				putch('-', putdat);
  8004ed:	83 ec 08             	sub    $0x8,%esp
  8004f0:	ff 75 0c             	pushl  0xc(%ebp)
  8004f3:	6a 2d                	push   $0x2d
  8004f5:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8004f8:	f7 de                	neg    %esi
  8004fa:	83 d7 00             	adc    $0x0,%edi
  8004fd:	f7 df                	neg    %edi
  8004ff:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  800502:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800507:	eb 75                	jmp    80057e <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800509:	51                   	push   %ecx
  80050a:	8d 45 14             	lea    0x14(%ebp),%eax
  80050d:	50                   	push   %eax
  80050e:	e8 51 fd ff ff       	call   800264 <getuint>
  800513:	89 c6                	mov    %eax,%esi
  800515:	89 d7                	mov    %edx,%edi
			base = 10;
  800517:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  80051c:	83 c4 08             	add    $0x8,%esp
  80051f:	eb 5d                	jmp    80057e <vprintfmt+0x29c>

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
  800521:	51                   	push   %ecx
  800522:	8d 45 14             	lea    0x14(%ebp),%eax
  800525:	50                   	push   %eax
  800526:	e8 39 fd ff ff       	call   800264 <getuint>
  80052b:	89 c6                	mov    %eax,%esi
  80052d:	89 d7                	mov    %edx,%edi
			base = 8;
  80052f:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  800534:	83 c4 08             	add    $0x8,%esp
  800537:	eb 45                	jmp    80057e <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800539:	83 ec 08             	sub    $0x8,%esp
  80053c:	ff 75 0c             	pushl  0xc(%ebp)
  80053f:	6a 30                	push   $0x30
  800541:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800544:	83 c4 08             	add    $0x8,%esp
  800547:	ff 75 0c             	pushl  0xc(%ebp)
  80054a:	6a 78                	push   $0x78
  80054c:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80054f:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800553:	8b 45 14             	mov    0x14(%ebp),%eax
  800556:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800559:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80055e:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  800563:	83 c4 10             	add    $0x10,%esp
  800566:	eb 16                	jmp    80057e <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800568:	51                   	push   %ecx
  800569:	8d 45 14             	lea    0x14(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	e8 f2 fc ff ff       	call   800264 <getuint>
  800572:	89 c6                	mov    %eax,%esi
  800574:	89 d7                	mov    %edx,%edi
			base = 16;
  800576:	ba 10 00 00 00       	mov    $0x10,%edx
  80057b:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80057e:	83 ec 04             	sub    $0x4,%esp
  800581:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800585:	50                   	push   %eax
  800586:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800589:	52                   	push   %edx
  80058a:	57                   	push   %edi
  80058b:	56                   	push   %esi
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	e8 2d fc ff ff       	call   8001c4 <printnum>
			break;
  800597:	83 c4 20             	add    $0x20,%esp
  80059a:	e9 4f fd ff ff       	jmp    8002ee <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80059f:	83 ec 08             	sub    $0x8,%esp
  8005a2:	ff 75 0c             	pushl  0xc(%ebp)
  8005a5:	52                   	push   %edx
  8005a6:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005a9:	83 c4 10             	add    $0x10,%esp
  8005ac:	e9 3d fd ff ff       	jmp    8002ee <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	ff 75 0c             	pushl  0xc(%ebp)
  8005b7:	6a 25                	push   $0x25
  8005b9:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8005bc:	4b                   	dec    %ebx
  8005bd:	83 c4 10             	add    $0x10,%esp
  8005c0:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8005c4:	0f 84 24 fd ff ff    	je     8002ee <vprintfmt+0xc>
  8005ca:	4b                   	dec    %ebx
  8005cb:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8005cf:	75 f9                	jne    8005ca <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8005d1:	e9 18 fd ff ff       	jmp    8002ee <vprintfmt+0xc>
		}
	}
}
  8005d6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8005d9:	5b                   	pop    %ebx
  8005da:	5e                   	pop    %esi
  8005db:	5f                   	pop    %edi
  8005dc:	c9                   	leave  
  8005dd:	c3                   	ret    

008005de <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005de:	55                   	push   %ebp
  8005df:	89 e5                	mov    %esp,%ebp
  8005e1:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8005e4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005e7:	50                   	push   %eax
  8005e8:	ff 75 10             	pushl  0x10(%ebp)
  8005eb:	ff 75 0c             	pushl  0xc(%ebp)
  8005ee:	ff 75 08             	pushl  0x8(%ebp)
  8005f1:	e8 ec fc ff ff       	call   8002e2 <vprintfmt>
	va_end(ap);
}
  8005f6:	c9                   	leave  
  8005f7:	c3                   	ret    

008005f8 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005f8:	55                   	push   %ebp
  8005f9:	89 e5                	mov    %esp,%ebp
  8005fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  8005fe:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  800601:	8b 0a                	mov    (%edx),%ecx
  800603:	3b 4a 04             	cmp    0x4(%edx),%ecx
  800606:	73 07                	jae    80060f <sprintputch+0x17>
		*b->buf++ = ch;
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	88 01                	mov    %al,(%ecx)
  80060d:	ff 02                	incl   (%edx)
}
  80060f:	c9                   	leave  
  800610:	c3                   	ret    

00800611 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800611:	55                   	push   %ebp
  800612:	89 e5                	mov    %esp,%ebp
  800614:	83 ec 18             	sub    $0x18,%esp
  800617:	8b 55 08             	mov    0x8(%ebp),%edx
  80061a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80061d:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  800620:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800624:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  800627:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  80062e:	85 d2                	test   %edx,%edx
  800630:	74 04                	je     800636 <vsnprintf+0x25>
  800632:	85 c9                	test   %ecx,%ecx
  800634:	7f 07                	jg     80063d <vsnprintf+0x2c>
		return -E_INVAL;
  800636:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80063b:	eb 1d                	jmp    80065a <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80063d:	ff 75 14             	pushl  0x14(%ebp)
  800640:	ff 75 10             	pushl  0x10(%ebp)
  800643:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  800646:	50                   	push   %eax
  800647:	68 f8 05 80 00       	push   $0x8005f8
  80064c:	e8 91 fc ff ff       	call   8002e2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800651:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800654:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800657:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  80065a:	c9                   	leave  
  80065b:	c3                   	ret    

0080065c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800662:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800665:	50                   	push   %eax
  800666:	ff 75 10             	pushl  0x10(%ebp)
  800669:	ff 75 0c             	pushl  0xc(%ebp)
  80066c:	ff 75 08             	pushl  0x8(%ebp)
  80066f:	e8 9d ff ff ff       	call   800611 <vsnprintf>
	va_end(ap);

	return rc;
}
  800674:	c9                   	leave  
  800675:	c3                   	ret    
	...

00800678 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	56                   	push   %esi
  80067c:	53                   	push   %ebx
  80067d:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800680:	83 ec 0c             	sub    $0xc,%esp
  800683:	56                   	push   %esi
  800684:	e8 ef 00 00 00       	call   800778 <strlen>
  char letter;
  int hexnum = 0;
  800689:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80068e:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	89 c2                	mov    %eax,%edx
  800698:	4a                   	dec    %edx
  800699:	0f 88 d0 00 00 00    	js     80076f <strtoint+0xf7>
    letter = string[cidx];
  80069f:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  8006a2:	85 d2                	test   %edx,%edx
  8006a4:	75 12                	jne    8006b8 <strtoint+0x40>
      if (letter != '0') {
  8006a6:	3c 30                	cmp    $0x30,%al
  8006a8:	0f 84 ba 00 00 00    	je     800768 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8006ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8006b3:	e9 b9 00 00 00       	jmp    800771 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  8006b8:	83 fa 01             	cmp    $0x1,%edx
  8006bb:	75 12                	jne    8006cf <strtoint+0x57>
      if (letter != 'x') {
  8006bd:	3c 78                	cmp    $0x78,%al
  8006bf:	0f 84 a3 00 00 00    	je     800768 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8006c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8006ca:	e9 a2 00 00 00       	jmp    800771 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8006cf:	0f be c0             	movsbl %al,%eax
  8006d2:	83 e8 30             	sub    $0x30,%eax
  8006d5:	83 f8 36             	cmp    $0x36,%eax
  8006d8:	0f 87 80 00 00 00    	ja     80075e <strtoint+0xe6>
  8006de:	ff 24 85 b4 2b 80 00 	jmp    *0x802bb4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8006e5:	01 cb                	add    %ecx,%ebx
          break;
  8006e7:	eb 7c                	jmp    800765 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8006e9:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8006ec:	eb 77                	jmp    800765 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8006ee:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8006f1:	01 c3                	add    %eax,%ebx
          break;
  8006f3:	eb 70                	jmp    800765 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  8006f5:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  8006f8:	eb 6b                	jmp    800765 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  8006fa:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8006fd:	01 c3                	add    %eax,%ebx
          break;
  8006ff:	eb 64                	jmp    800765 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  800701:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800704:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800707:	eb 5c                	jmp    800765 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800709:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800710:	29 c8                	sub    %ecx,%eax
  800712:	01 c3                	add    %eax,%ebx
          break;
  800714:	eb 4f                	jmp    800765 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  800716:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  800719:	eb 4a                	jmp    800765 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  80071b:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  80071e:	01 c3                	add    %eax,%ebx
          break;
  800720:	eb 43                	jmp    800765 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  800722:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800725:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800728:	eb 3b                	jmp    800765 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  80072a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  80072d:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  800730:	01 c3                	add    %eax,%ebx
          break;
  800732:	eb 31                	jmp    800765 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800734:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800737:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  80073a:	eb 29                	jmp    800765 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  80073c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80073f:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  800742:	01 c3                	add    %eax,%ebx
          break;
  800744:	eb 1f                	jmp    800765 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800746:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  80074d:	29 c8                	sub    %ecx,%eax
  80074f:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800752:	eb 11                	jmp    800765 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800754:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800757:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80075a:	01 c3                	add    %eax,%ebx
          break;
  80075c:	eb 07                	jmp    800765 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  80075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800763:	eb 0c                	jmp    800771 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800765:	c1 e1 04             	shl    $0x4,%ecx
  800768:	4a                   	dec    %edx
  800769:	0f 89 30 ff ff ff    	jns    80069f <strtoint+0x27>
    }
  }

  return hexnum;
  80076f:	89 d8                	mov    %ebx,%eax
}
  800771:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800774:	5b                   	pop    %ebx
  800775:	5e                   	pop    %esi
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <strlen>:





int
strlen(const char *s)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80077e:	b8 00 00 00 00       	mov    $0x0,%eax
  800783:	80 3a 00             	cmpb   $0x0,(%edx)
  800786:	74 07                	je     80078f <strlen+0x17>
		n++;
  800788:	40                   	inc    %eax
  800789:	42                   	inc    %edx
  80078a:	80 3a 00             	cmpb   $0x0,(%edx)
  80078d:	75 f9                	jne    800788 <strlen+0x10>
	return n;
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800797:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	85 d2                	test   %edx,%edx
  8007a1:	74 0f                	je     8007b2 <strnlen+0x21>
  8007a3:	80 39 00             	cmpb   $0x0,(%ecx)
  8007a6:	74 0a                	je     8007b2 <strnlen+0x21>
		n++;
  8007a8:	40                   	inc    %eax
  8007a9:	41                   	inc    %ecx
  8007aa:	4a                   	dec    %edx
  8007ab:	74 05                	je     8007b2 <strnlen+0x21>
  8007ad:	80 39 00             	cmpb   $0x0,(%ecx)
  8007b0:	75 f6                	jne    8007a8 <strnlen+0x17>
	return n;
}
  8007b2:	c9                   	leave  
  8007b3:	c3                   	ret    

008007b4 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	53                   	push   %ebx
  8007b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  8007be:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  8007c0:	8a 02                	mov    (%edx),%al
  8007c2:	42                   	inc    %edx
  8007c3:	88 01                	mov    %al,(%ecx)
  8007c5:	41                   	inc    %ecx
  8007c6:	84 c0                	test   %al,%al
  8007c8:	75 f6                	jne    8007c0 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007ca:	89 d8                	mov    %ebx,%eax
  8007cc:	5b                   	pop    %ebx
  8007cd:	c9                   	leave  
  8007ce:	c3                   	ret    

008007cf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	57                   	push   %edi
  8007d3:	56                   	push   %esi
  8007d4:	53                   	push   %ebx
  8007d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007db:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  8007de:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  8007e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007e5:	39 f3                	cmp    %esi,%ebx
  8007e7:	73 10                	jae    8007f9 <strncpy+0x2a>
		*dst++ = *src;
  8007e9:	8a 02                	mov    (%edx),%al
  8007eb:	88 01                	mov    %al,(%ecx)
  8007ed:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ee:	80 3a 01             	cmpb   $0x1,(%edx)
  8007f1:	83 da ff             	sbb    $0xffffffff,%edx
  8007f4:	43                   	inc    %ebx
  8007f5:	39 f3                	cmp    %esi,%ebx
  8007f7:	72 f0                	jb     8007e9 <strncpy+0x1a>
	}
	return ret;
}
  8007f9:	89 f8                	mov    %edi,%eax
  8007fb:	5b                   	pop    %ebx
  8007fc:	5e                   	pop    %esi
  8007fd:	5f                   	pop    %edi
  8007fe:	c9                   	leave  
  8007ff:	c3                   	ret    

00800800 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	56                   	push   %esi
  800804:	53                   	push   %ebx
  800805:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800808:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80080b:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  80080e:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  800810:	85 d2                	test   %edx,%edx
  800812:	74 19                	je     80082d <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800814:	4a                   	dec    %edx
  800815:	74 13                	je     80082a <strlcpy+0x2a>
  800817:	80 39 00             	cmpb   $0x0,(%ecx)
  80081a:	74 0e                	je     80082a <strlcpy+0x2a>
  80081c:	8a 01                	mov    (%ecx),%al
  80081e:	41                   	inc    %ecx
  80081f:	88 03                	mov    %al,(%ebx)
  800821:	43                   	inc    %ebx
  800822:	4a                   	dec    %edx
  800823:	74 05                	je     80082a <strlcpy+0x2a>
  800825:	80 39 00             	cmpb   $0x0,(%ecx)
  800828:	75 f2                	jne    80081c <strlcpy+0x1c>
		*dst = '\0';
  80082a:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  80082d:	89 d8                	mov    %ebx,%eax
  80082f:	29 f0                	sub    %esi,%eax
}
  800831:	5b                   	pop    %ebx
  800832:	5e                   	pop    %esi
  800833:	c9                   	leave  
  800834:	c3                   	ret    

00800835 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	8b 55 08             	mov    0x8(%ebp),%edx
  80083b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  80083e:	80 3a 00             	cmpb   $0x0,(%edx)
  800841:	74 13                	je     800856 <strcmp+0x21>
  800843:	8a 02                	mov    (%edx),%al
  800845:	3a 01                	cmp    (%ecx),%al
  800847:	75 0d                	jne    800856 <strcmp+0x21>
  800849:	42                   	inc    %edx
  80084a:	41                   	inc    %ecx
  80084b:	80 3a 00             	cmpb   $0x0,(%edx)
  80084e:	74 06                	je     800856 <strcmp+0x21>
  800850:	8a 02                	mov    (%edx),%al
  800852:	3a 01                	cmp    (%ecx),%al
  800854:	74 f3                	je     800849 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800856:	0f b6 02             	movzbl (%edx),%eax
  800859:	0f b6 11             	movzbl (%ecx),%edx
  80085c:	29 d0                	sub    %edx,%eax
}
  80085e:	c9                   	leave  
  80085f:	c3                   	ret    

00800860 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	53                   	push   %ebx
  800864:	8b 55 08             	mov    0x8(%ebp),%edx
  800867:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80086a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  80086d:	85 c9                	test   %ecx,%ecx
  80086f:	74 1f                	je     800890 <strncmp+0x30>
  800871:	80 3a 00             	cmpb   $0x0,(%edx)
  800874:	74 16                	je     80088c <strncmp+0x2c>
  800876:	8a 02                	mov    (%edx),%al
  800878:	3a 03                	cmp    (%ebx),%al
  80087a:	75 10                	jne    80088c <strncmp+0x2c>
  80087c:	42                   	inc    %edx
  80087d:	43                   	inc    %ebx
  80087e:	49                   	dec    %ecx
  80087f:	74 0f                	je     800890 <strncmp+0x30>
  800881:	80 3a 00             	cmpb   $0x0,(%edx)
  800884:	74 06                	je     80088c <strncmp+0x2c>
  800886:	8a 02                	mov    (%edx),%al
  800888:	3a 03                	cmp    (%ebx),%al
  80088a:	74 f0                	je     80087c <strncmp+0x1c>
	if (n == 0)
  80088c:	85 c9                	test   %ecx,%ecx
  80088e:	75 07                	jne    800897 <strncmp+0x37>
		return 0;
  800890:	b8 00 00 00 00       	mov    $0x0,%eax
  800895:	eb 0a                	jmp    8008a1 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800897:	0f b6 12             	movzbl (%edx),%edx
  80089a:	0f b6 03             	movzbl (%ebx),%eax
  80089d:	29 c2                	sub    %eax,%edx
  80089f:	89 d0                	mov    %edx,%eax
}
  8008a1:	5b                   	pop    %ebx
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    

008008a4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8008ad:	80 38 00             	cmpb   $0x0,(%eax)
  8008b0:	74 0a                	je     8008bc <strchr+0x18>
		if (*s == c)
  8008b2:	38 10                	cmp    %dl,(%eax)
  8008b4:	74 0b                	je     8008c1 <strchr+0x1d>
  8008b6:	40                   	inc    %eax
  8008b7:	80 38 00             	cmpb   $0x0,(%eax)
  8008ba:	75 f6                	jne    8008b2 <strchr+0xe>
			return (char *) s;
	return 0;
  8008bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8008cc:	80 38 00             	cmpb   $0x0,(%eax)
  8008cf:	74 0a                	je     8008db <strfind+0x18>
		if (*s == c)
  8008d1:	38 10                	cmp    %dl,(%eax)
  8008d3:	74 06                	je     8008db <strfind+0x18>
  8008d5:	40                   	inc    %eax
  8008d6:	80 38 00             	cmpb   $0x0,(%eax)
  8008d9:	75 f6                	jne    8008d1 <strfind+0xe>
			break;
	return (char *) s;
}
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	57                   	push   %edi
  8008e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  8008e7:	89 f8                	mov    %edi,%eax
  8008e9:	85 c9                	test   %ecx,%ecx
  8008eb:	74 40                	je     80092d <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  8008ed:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008f3:	75 30                	jne    800925 <memset+0x48>
  8008f5:	f6 c1 03             	test   $0x3,%cl
  8008f8:	75 2b                	jne    800925 <memset+0x48>
		c &= 0xFF;
  8008fa:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800901:	8b 45 0c             	mov    0xc(%ebp),%eax
  800904:	c1 e0 18             	shl    $0x18,%eax
  800907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090a:	c1 e2 10             	shl    $0x10,%edx
  80090d:	09 d0                	or     %edx,%eax
  80090f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800912:	c1 e2 08             	shl    $0x8,%edx
  800915:	09 d0                	or     %edx,%eax
  800917:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  80091a:	c1 e9 02             	shr    $0x2,%ecx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	fc                   	cld    
  800921:	f3 ab                	repz stos %eax,%es:(%edi)
  800923:	eb 06                	jmp    80092b <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	fc                   	cld    
  800929:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  80092b:	89 f8                	mov    %edi,%eax
}
  80092d:	5f                   	pop    %edi
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    

00800930 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	57                   	push   %edi
  800934:	56                   	push   %esi
  800935:	8b 45 08             	mov    0x8(%ebp),%eax
  800938:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  80093b:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80093e:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800940:	39 c6                	cmp    %eax,%esi
  800942:	73 33                	jae    800977 <memmove+0x47>
  800944:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800947:	39 c2                	cmp    %eax,%edx
  800949:	76 2c                	jbe    800977 <memmove+0x47>
		s += n;
  80094b:	89 d6                	mov    %edx,%esi
		d += n;
  80094d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800950:	f6 c2 03             	test   $0x3,%dl
  800953:	75 1b                	jne    800970 <memmove+0x40>
  800955:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80095b:	75 13                	jne    800970 <memmove+0x40>
  80095d:	f6 c1 03             	test   $0x3,%cl
  800960:	75 0e                	jne    800970 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800962:	83 ef 04             	sub    $0x4,%edi
  800965:	83 ee 04             	sub    $0x4,%esi
  800968:	c1 e9 02             	shr    $0x2,%ecx
  80096b:	fd                   	std    
  80096c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  80096e:	eb 27                	jmp    800997 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800970:	4f                   	dec    %edi
  800971:	4e                   	dec    %esi
  800972:	fd                   	std    
  800973:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800975:	eb 20                	jmp    800997 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800977:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80097d:	75 15                	jne    800994 <memmove+0x64>
  80097f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800985:	75 0d                	jne    800994 <memmove+0x64>
  800987:	f6 c1 03             	test   $0x3,%cl
  80098a:	75 08                	jne    800994 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  80098c:	c1 e9 02             	shr    $0x2,%ecx
  80098f:	fc                   	cld    
  800990:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800992:	eb 03                	jmp    800997 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800994:	fc                   	cld    
  800995:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800997:	5e                   	pop    %esi
  800998:	5f                   	pop    %edi
  800999:	c9                   	leave  
  80099a:	c3                   	ret    

0080099b <memcpy>:

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
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80099e:	ff 75 10             	pushl  0x10(%ebp)
  8009a1:	ff 75 0c             	pushl  0xc(%ebp)
  8009a4:	ff 75 08             	pushl  0x8(%ebp)
  8009a7:	e8 84 ff ff ff       	call   800930 <memmove>
}
  8009ac:	c9                   	leave  
  8009ad:	c3                   	ret    

008009ae <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  8009b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  8009b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009b8:	8b 55 10             	mov    0x10(%ebp),%edx
  8009bb:	4a                   	dec    %edx
  8009bc:	83 fa ff             	cmp    $0xffffffff,%edx
  8009bf:	74 1a                	je     8009db <memcmp+0x2d>
  8009c1:	8a 01                	mov    (%ecx),%al
  8009c3:	3a 03                	cmp    (%ebx),%al
  8009c5:	74 0c                	je     8009d3 <memcmp+0x25>
  8009c7:	0f b6 d0             	movzbl %al,%edx
  8009ca:	0f b6 03             	movzbl (%ebx),%eax
  8009cd:	29 c2                	sub    %eax,%edx
  8009cf:	89 d0                	mov    %edx,%eax
  8009d1:	eb 0d                	jmp    8009e0 <memcmp+0x32>
  8009d3:	41                   	inc    %ecx
  8009d4:	43                   	inc    %ebx
  8009d5:	4a                   	dec    %edx
  8009d6:	83 fa ff             	cmp    $0xffffffff,%edx
  8009d9:	75 e6                	jne    8009c1 <memcmp+0x13>
	}

	return 0;
  8009db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e0:	5b                   	pop    %ebx
  8009e1:	c9                   	leave  
  8009e2:	c3                   	ret    

008009e3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009e3:	55                   	push   %ebp
  8009e4:	89 e5                	mov    %esp,%ebp
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ec:	89 c2                	mov    %eax,%edx
  8009ee:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009f1:	39 d0                	cmp    %edx,%eax
  8009f3:	73 09                	jae    8009fe <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009f5:	38 08                	cmp    %cl,(%eax)
  8009f7:	74 05                	je     8009fe <memfind+0x1b>
  8009f9:	40                   	inc    %eax
  8009fa:	39 d0                	cmp    %edx,%eax
  8009fc:	72 f7                	jb     8009f5 <memfind+0x12>
			break;
	return (void *) s;
}
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	57                   	push   %edi
  800a04:	56                   	push   %esi
  800a05:	53                   	push   %ebx
  800a06:	8b 55 08             	mov    0x8(%ebp),%edx
  800a09:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800a0f:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800a14:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800a19:	80 3a 20             	cmpb   $0x20,(%edx)
  800a1c:	74 05                	je     800a23 <strtol+0x23>
  800a1e:	80 3a 09             	cmpb   $0x9,(%edx)
  800a21:	75 0b                	jne    800a2e <strtol+0x2e>
  800a23:	42                   	inc    %edx
  800a24:	80 3a 20             	cmpb   $0x20,(%edx)
  800a27:	74 fa                	je     800a23 <strtol+0x23>
  800a29:	80 3a 09             	cmpb   $0x9,(%edx)
  800a2c:	74 f5                	je     800a23 <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800a2e:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800a31:	75 03                	jne    800a36 <strtol+0x36>
		s++;
  800a33:	42                   	inc    %edx
  800a34:	eb 0b                	jmp    800a41 <strtol+0x41>
	else if (*s == '-')
  800a36:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800a39:	75 06                	jne    800a41 <strtol+0x41>
		s++, neg = 1;
  800a3b:	42                   	inc    %edx
  800a3c:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a41:	85 c9                	test   %ecx,%ecx
  800a43:	74 05                	je     800a4a <strtol+0x4a>
  800a45:	83 f9 10             	cmp    $0x10,%ecx
  800a48:	75 15                	jne    800a5f <strtol+0x5f>
  800a4a:	80 3a 30             	cmpb   $0x30,(%edx)
  800a4d:	75 10                	jne    800a5f <strtol+0x5f>
  800a4f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a53:	75 0a                	jne    800a5f <strtol+0x5f>
		s += 2, base = 16;
  800a55:	83 c2 02             	add    $0x2,%edx
  800a58:	b9 10 00 00 00       	mov    $0x10,%ecx
  800a5d:	eb 14                	jmp    800a73 <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800a5f:	85 c9                	test   %ecx,%ecx
  800a61:	75 10                	jne    800a73 <strtol+0x73>
  800a63:	80 3a 30             	cmpb   $0x30,(%edx)
  800a66:	75 05                	jne    800a6d <strtol+0x6d>
		s++, base = 8;
  800a68:	42                   	inc    %edx
  800a69:	b1 08                	mov    $0x8,%cl
  800a6b:	eb 06                	jmp    800a73 <strtol+0x73>
	else if (base == 0)
  800a6d:	85 c9                	test   %ecx,%ecx
  800a6f:	75 02                	jne    800a73 <strtol+0x73>
		base = 10;
  800a71:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a73:	8a 02                	mov    (%edx),%al
  800a75:	83 e8 30             	sub    $0x30,%eax
  800a78:	3c 09                	cmp    $0x9,%al
  800a7a:	77 08                	ja     800a84 <strtol+0x84>
			dig = *s - '0';
  800a7c:	0f be 02             	movsbl (%edx),%eax
  800a7f:	83 e8 30             	sub    $0x30,%eax
  800a82:	eb 20                	jmp    800aa4 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800a84:	8a 02                	mov    (%edx),%al
  800a86:	83 e8 61             	sub    $0x61,%eax
  800a89:	3c 19                	cmp    $0x19,%al
  800a8b:	77 08                	ja     800a95 <strtol+0x95>
			dig = *s - 'a' + 10;
  800a8d:	0f be 02             	movsbl (%edx),%eax
  800a90:	83 e8 57             	sub    $0x57,%eax
  800a93:	eb 0f                	jmp    800aa4 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800a95:	8a 02                	mov    (%edx),%al
  800a97:	83 e8 41             	sub    $0x41,%eax
  800a9a:	3c 19                	cmp    $0x19,%al
  800a9c:	77 12                	ja     800ab0 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800a9e:	0f be 02             	movsbl (%edx),%eax
  800aa1:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800aa4:	39 c8                	cmp    %ecx,%eax
  800aa6:	7d 08                	jge    800ab0 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800aa8:	42                   	inc    %edx
  800aa9:	0f af d9             	imul   %ecx,%ebx
  800aac:	01 c3                	add    %eax,%ebx
  800aae:	eb c3                	jmp    800a73 <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ab0:	85 f6                	test   %esi,%esi
  800ab2:	74 02                	je     800ab6 <strtol+0xb6>
		*endptr = (char *) s;
  800ab4:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800ab6:	89 d8                	mov    %ebx,%eax
  800ab8:	85 ff                	test   %edi,%edi
  800aba:	74 02                	je     800abe <strtol+0xbe>
  800abc:	f7 d8                	neg    %eax
}
  800abe:	5b                   	pop    %ebx
  800abf:	5e                   	pop    %esi
  800ac0:	5f                   	pop    %edi
  800ac1:	c9                   	leave  
  800ac2:	c3                   	ret    
	...

00800ac4 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	57                   	push   %edi
  800ac8:	56                   	push   %esi
  800ac9:	53                   	push   %ebx
  800aca:	83 ec 04             	sub    $0x4,%esp
  800acd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ad8:	89 f8                	mov    %edi,%eax
  800ada:	89 fb                	mov    %edi,%ebx
  800adc:	89 fe                	mov    %edi,%esi
  800ade:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ae0:	83 c4 04             	add    $0x4,%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5f                   	pop    %edi
  800ae6:	c9                   	leave  
  800ae7:	c3                   	ret    

00800ae8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	57                   	push   %edi
  800aec:	56                   	push   %esi
  800aed:	53                   	push   %ebx
  800aee:	b8 01 00 00 00       	mov    $0x1,%eax
  800af3:	bf 00 00 00 00       	mov    $0x0,%edi
  800af8:	89 fa                	mov    %edi,%edx
  800afa:	89 f9                	mov    %edi,%ecx
  800afc:	89 fb                	mov    %edi,%ebx
  800afe:	89 fe                	mov    %edi,%esi
  800b00:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b02:	5b                   	pop    %ebx
  800b03:	5e                   	pop    %esi
  800b04:	5f                   	pop    %edi
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	57                   	push   %edi
  800b0b:	56                   	push   %esi
  800b0c:	53                   	push   %ebx
  800b0d:	83 ec 0c             	sub    $0xc,%esp
  800b10:	8b 55 08             	mov    0x8(%ebp),%edx
  800b13:	b8 03 00 00 00       	mov    $0x3,%eax
  800b18:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1d:	89 f9                	mov    %edi,%ecx
  800b1f:	89 fb                	mov    %edi,%ebx
  800b21:	89 fe                	mov    %edi,%esi
  800b23:	cd 30                	int    $0x30
  800b25:	85 c0                	test   %eax,%eax
  800b27:	7e 17                	jle    800b40 <sys_env_destroy+0x39>
  800b29:	83 ec 0c             	sub    $0xc,%esp
  800b2c:	50                   	push   %eax
  800b2d:	6a 03                	push   $0x3
  800b2f:	68 90 2c 80 00       	push   $0x802c90
  800b34:	6a 23                	push   $0x23
  800b36:	68 ad 2c 80 00       	push   $0x802cad
  800b3b:	e8 40 19 00 00       	call   802480 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b40:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800b43:	5b                   	pop    %ebx
  800b44:	5e                   	pop    %esi
  800b45:	5f                   	pop    %edi
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	57                   	push   %edi
  800b4c:	56                   	push   %esi
  800b4d:	53                   	push   %ebx
  800b4e:	b8 02 00 00 00       	mov    $0x2,%eax
  800b53:	bf 00 00 00 00       	mov    $0x0,%edi
  800b58:	89 fa                	mov    %edi,%edx
  800b5a:	89 f9                	mov    %edi,%ecx
  800b5c:	89 fb                	mov    %edi,%ebx
  800b5e:	89 fe                	mov    %edi,%esi
  800b60:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5f                   	pop    %edi
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sys_yield>:

void
sys_yield(void)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	57                   	push   %edi
  800b6b:	56                   	push   %esi
  800b6c:	53                   	push   %ebx
  800b6d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b72:	bf 00 00 00 00       	mov    $0x0,%edi
  800b77:	89 fa                	mov    %edi,%edx
  800b79:	89 f9                	mov    %edi,%ecx
  800b7b:	89 fb                	mov    %edi,%ebx
  800b7d:	89 fe                	mov    %edi,%esi
  800b7f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b81:	5b                   	pop    %ebx
  800b82:	5e                   	pop    %esi
  800b83:	5f                   	pop    %edi
  800b84:	c9                   	leave  
  800b85:	c3                   	ret    

00800b86 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	57                   	push   %edi
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
  800b8c:	83 ec 0c             	sub    $0xc,%esp
  800b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b98:	b8 04 00 00 00       	mov    $0x4,%eax
  800b9d:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba2:	89 fe                	mov    %edi,%esi
  800ba4:	cd 30                	int    $0x30
  800ba6:	85 c0                	test   %eax,%eax
  800ba8:	7e 17                	jle    800bc1 <sys_page_alloc+0x3b>
  800baa:	83 ec 0c             	sub    $0xc,%esp
  800bad:	50                   	push   %eax
  800bae:	6a 04                	push   $0x4
  800bb0:	68 90 2c 80 00       	push   $0x802c90
  800bb5:	6a 23                	push   $0x23
  800bb7:	68 ad 2c 80 00       	push   $0x802cad
  800bbc:	e8 bf 18 00 00       	call   802480 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bc1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800bc4:	5b                   	pop    %ebx
  800bc5:	5e                   	pop    %esi
  800bc6:	5f                   	pop    %edi
  800bc7:	c9                   	leave  
  800bc8:	c3                   	ret    

00800bc9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	57                   	push   %edi
  800bcd:	56                   	push   %esi
  800bce:	53                   	push   %ebx
  800bcf:	83 ec 0c             	sub    $0xc,%esp
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bdb:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bde:	8b 75 18             	mov    0x18(%ebp),%esi
  800be1:	b8 05 00 00 00       	mov    $0x5,%eax
  800be6:	cd 30                	int    $0x30
  800be8:	85 c0                	test   %eax,%eax
  800bea:	7e 17                	jle    800c03 <sys_page_map+0x3a>
  800bec:	83 ec 0c             	sub    $0xc,%esp
  800bef:	50                   	push   %eax
  800bf0:	6a 05                	push   $0x5
  800bf2:	68 90 2c 80 00       	push   $0x802c90
  800bf7:	6a 23                	push   $0x23
  800bf9:	68 ad 2c 80 00       	push   $0x802cad
  800bfe:	e8 7d 18 00 00       	call   802480 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c03:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c06:	5b                   	pop    %ebx
  800c07:	5e                   	pop    %esi
  800c08:	5f                   	pop    %edi
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	57                   	push   %edi
  800c0f:	56                   	push   %esi
  800c10:	53                   	push   %ebx
  800c11:	83 ec 0c             	sub    $0xc,%esp
  800c14:	8b 55 08             	mov    0x8(%ebp),%edx
  800c17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1a:	b8 06 00 00 00       	mov    $0x6,%eax
  800c1f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c24:	89 fb                	mov    %edi,%ebx
  800c26:	89 fe                	mov    %edi,%esi
  800c28:	cd 30                	int    $0x30
  800c2a:	85 c0                	test   %eax,%eax
  800c2c:	7e 17                	jle    800c45 <sys_page_unmap+0x3a>
  800c2e:	83 ec 0c             	sub    $0xc,%esp
  800c31:	50                   	push   %eax
  800c32:	6a 06                	push   $0x6
  800c34:	68 90 2c 80 00       	push   $0x802c90
  800c39:	6a 23                	push   $0x23
  800c3b:	68 ad 2c 80 00       	push   $0x802cad
  800c40:	e8 3b 18 00 00       	call   802480 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c45:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5f                   	pop    %edi
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
  800c50:	57                   	push   %edi
  800c51:	56                   	push   %esi
  800c52:	53                   	push   %ebx
  800c53:	83 ec 0c             	sub    $0xc,%esp
  800c56:	8b 55 08             	mov    0x8(%ebp),%edx
  800c59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5c:	b8 08 00 00 00       	mov    $0x8,%eax
  800c61:	bf 00 00 00 00       	mov    $0x0,%edi
  800c66:	89 fb                	mov    %edi,%ebx
  800c68:	89 fe                	mov    %edi,%esi
  800c6a:	cd 30                	int    $0x30
  800c6c:	85 c0                	test   %eax,%eax
  800c6e:	7e 17                	jle    800c87 <sys_env_set_status+0x3a>
  800c70:	83 ec 0c             	sub    $0xc,%esp
  800c73:	50                   	push   %eax
  800c74:	6a 08                	push   $0x8
  800c76:	68 90 2c 80 00       	push   $0x802c90
  800c7b:	6a 23                	push   $0x23
  800c7d:	68 ad 2c 80 00       	push   $0x802cad
  800c82:	e8 f9 17 00 00       	call   802480 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c87:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5f                   	pop    %edi
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	57                   	push   %edi
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	83 ec 0c             	sub    $0xc,%esp
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800ca3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca8:	89 fb                	mov    %edi,%ebx
  800caa:	89 fe                	mov    %edi,%esi
  800cac:	cd 30                	int    $0x30
  800cae:	85 c0                	test   %eax,%eax
  800cb0:	7e 17                	jle    800cc9 <sys_env_set_trapframe+0x3a>
  800cb2:	83 ec 0c             	sub    $0xc,%esp
  800cb5:	50                   	push   %eax
  800cb6:	6a 09                	push   $0x9
  800cb8:	68 90 2c 80 00       	push   $0x802c90
  800cbd:	6a 23                	push   $0x23
  800cbf:	68 ad 2c 80 00       	push   $0x802cad
  800cc4:	e8 b7 17 00 00       	call   802480 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cc9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ccc:	5b                   	pop    %ebx
  800ccd:	5e                   	pop    %esi
  800cce:	5f                   	pop    %edi
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
  800cd4:	57                   	push   %edi
  800cd5:	56                   	push   %esi
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 0c             	sub    $0xc,%esp
  800cda:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ce5:	bf 00 00 00 00       	mov    $0x0,%edi
  800cea:	89 fb                	mov    %edi,%ebx
  800cec:	89 fe                	mov    %edi,%esi
  800cee:	cd 30                	int    $0x30
  800cf0:	85 c0                	test   %eax,%eax
  800cf2:	7e 17                	jle    800d0b <sys_env_set_pgfault_upcall+0x3a>
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	50                   	push   %eax
  800cf8:	6a 0a                	push   $0xa
  800cfa:	68 90 2c 80 00       	push   $0x802c90
  800cff:	6a 23                	push   $0x23
  800d01:	68 ad 2c 80 00       	push   $0x802cad
  800d06:	e8 75 17 00 00       	call   802480 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d0b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5f                   	pop    %edi
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d22:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d25:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d2a:	be 00 00 00 00       	mov    $0x0,%esi
  800d2f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
  800d3c:	83 ec 0c             	sub    $0xc,%esp
  800d3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d42:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d47:	bf 00 00 00 00       	mov    $0x0,%edi
  800d4c:	89 f9                	mov    %edi,%ecx
  800d4e:	89 fb                	mov    %edi,%ebx
  800d50:	89 fe                	mov    %edi,%esi
  800d52:	cd 30                	int    $0x30
  800d54:	85 c0                	test   %eax,%eax
  800d56:	7e 17                	jle    800d6f <sys_ipc_recv+0x39>
  800d58:	83 ec 0c             	sub    $0xc,%esp
  800d5b:	50                   	push   %eax
  800d5c:	6a 0d                	push   $0xd
  800d5e:	68 90 2c 80 00       	push   $0x802c90
  800d63:	6a 23                	push   $0x23
  800d65:	68 ad 2c 80 00       	push   $0x802cad
  800d6a:	e8 11 17 00 00       	call   802480 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d6f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5f                   	pop    %edi
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
  800d7d:	83 ec 0c             	sub    $0xc,%esp
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d86:	b8 10 00 00 00       	mov    $0x10,%eax
  800d8b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d90:	89 fb                	mov    %edi,%ebx
  800d92:	89 fe                	mov    %edi,%esi
  800d94:	cd 30                	int    $0x30
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7e 17                	jle    800db1 <sys_transmit_packet+0x3a>
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	50                   	push   %eax
  800d9e:	6a 10                	push   $0x10
  800da0:	68 90 2c 80 00       	push   $0x802c90
  800da5:	6a 23                	push   $0x23
  800da7:	68 ad 2c 80 00       	push   $0x802cad
  800dac:	e8 cf 16 00 00       	call   802480 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800db1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5f                   	pop    %edi
  800db7:	c9                   	leave  
  800db8:	c3                   	ret    

00800db9 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	b8 11 00 00 00       	mov    $0x11,%eax
  800dcd:	bf 00 00 00 00       	mov    $0x0,%edi
  800dd2:	89 fb                	mov    %edi,%ebx
  800dd4:	89 fe                	mov    %edi,%esi
  800dd6:	cd 30                	int    $0x30
  800dd8:	85 c0                	test   %eax,%eax
  800dda:	7e 17                	jle    800df3 <sys_receive_packet+0x3a>
  800ddc:	83 ec 0c             	sub    $0xc,%esp
  800ddf:	50                   	push   %eax
  800de0:	6a 11                	push   $0x11
  800de2:	68 90 2c 80 00       	push   $0x802c90
  800de7:	6a 23                	push   $0x23
  800de9:	68 ad 2c 80 00       	push   $0x802cad
  800dee:	e8 8d 16 00 00       	call   802480 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800df3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	c9                   	leave  
  800dfa:	c3                   	ret    

00800dfb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e06:	bf 00 00 00 00       	mov    $0x0,%edi
  800e0b:	89 fa                	mov    %edi,%edx
  800e0d:	89 f9                	mov    %edi,%ecx
  800e0f:	89 fb                	mov    %edi,%ebx
  800e11:	89 fe                	mov    %edi,%esi
  800e13:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	c9                   	leave  
  800e19:	c3                   	ret    

00800e1a <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 0c             	sub    $0xc,%esp
  800e23:	8b 55 08             	mov    0x8(%ebp),%edx
  800e26:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e2b:	bf 00 00 00 00       	mov    $0x0,%edi
  800e30:	89 f9                	mov    %edi,%ecx
  800e32:	89 fb                	mov    %edi,%ebx
  800e34:	89 fe                	mov    %edi,%esi
  800e36:	cd 30                	int    $0x30
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	7e 17                	jle    800e53 <sys_map_receive_buffers+0x39>
  800e3c:	83 ec 0c             	sub    $0xc,%esp
  800e3f:	50                   	push   %eax
  800e40:	6a 0e                	push   $0xe
  800e42:	68 90 2c 80 00       	push   $0x802c90
  800e47:	6a 23                	push   $0x23
  800e49:	68 ad 2c 80 00       	push   $0x802cad
  800e4e:	e8 2d 16 00 00       	call   802480 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800e53:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5f                   	pop    %edi
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
  800e61:	83 ec 0c             	sub    $0xc,%esp
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	b8 12 00 00 00       	mov    $0x12,%eax
  800e6c:	bf 00 00 00 00       	mov    $0x0,%edi
  800e71:	89 f9                	mov    %edi,%ecx
  800e73:	89 fb                	mov    %edi,%ebx
  800e75:	89 fe                	mov    %edi,%esi
  800e77:	cd 30                	int    $0x30
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	7e 17                	jle    800e94 <sys_receive_packet_zerocopy+0x39>
  800e7d:	83 ec 0c             	sub    $0xc,%esp
  800e80:	50                   	push   %eax
  800e81:	6a 12                	push   $0x12
  800e83:	68 90 2c 80 00       	push   $0x802c90
  800e88:	6a 23                	push   $0x23
  800e8a:	68 ad 2c 80 00       	push   $0x802cad
  800e8f:	e8 ec 15 00 00       	call   802480 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800e94:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	57                   	push   %edi
  800ea0:	56                   	push   %esi
  800ea1:	53                   	push   %ebx
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	b8 13 00 00 00       	mov    $0x13,%eax
  800eb0:	bf 00 00 00 00       	mov    $0x0,%edi
  800eb5:	89 fb                	mov    %edi,%ebx
  800eb7:	89 fe                	mov    %edi,%esi
  800eb9:	cd 30                	int    $0x30
  800ebb:	85 c0                	test   %eax,%eax
  800ebd:	7e 17                	jle    800ed6 <sys_env_set_priority+0x3a>
  800ebf:	83 ec 0c             	sub    $0xc,%esp
  800ec2:	50                   	push   %eax
  800ec3:	6a 13                	push   $0x13
  800ec5:	68 90 2c 80 00       	push   $0x802c90
  800eca:	6a 23                	push   $0x23
  800ecc:	68 ad 2c 80 00       	push   $0x802cad
  800ed1:	e8 aa 15 00 00       	call   802480 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800ed6:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ed9:	5b                   	pop    %ebx
  800eda:	5e                   	pop    %esi
  800edb:	5f                   	pop    %edi
  800edc:	c9                   	leave  
  800edd:	c3                   	ret    
	...

00800ee0 <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	53                   	push   %ebx
  800ee4:	83 ec 04             	sub    $0x4,%esp
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800eea:	8b 18                	mov    (%eax),%ebx
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
  800eec:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ef0:	74 11                	je     800f03 <pgfault+0x23>
  800ef2:	89 d8                	mov    %ebx,%eax
  800ef4:	c1 e8 0c             	shr    $0xc,%eax
  800ef7:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800efe:	f6 c4 08             	test   $0x8,%ah
  800f01:	75 14                	jne    800f17 <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  800f03:	83 ec 04             	sub    $0x4,%esp
  800f06:	68 bc 2c 80 00       	push   $0x802cbc
  800f0b:	6a 1e                	push   $0x1e
  800f0d:	68 10 2d 80 00       	push   $0x802d10
  800f12:	e8 69 15 00 00       	call   802480 <_panic>
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
  800f17:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  800f1d:	83 ec 04             	sub    $0x4,%esp
  800f20:	6a 07                	push   $0x7
  800f22:	68 00 f0 7f 00       	push   $0x7ff000
  800f27:	83 ec 04             	sub    $0x4,%esp
  800f2a:	e8 19 fc ff ff       	call   800b48 <sys_getenvid>
  800f2f:	89 04 24             	mov    %eax,(%esp)
  800f32:	e8 4f fc ff ff       	call   800b86 <sys_page_alloc>
  800f37:	83 c4 10             	add    $0x10,%esp
  800f3a:	85 c0                	test   %eax,%eax
  800f3c:	79 12                	jns    800f50 <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  800f3e:	50                   	push   %eax
  800f3f:	68 1b 2d 80 00       	push   $0x802d1b
  800f44:	6a 2d                	push   $0x2d
  800f46:	68 10 2d 80 00       	push   $0x802d10
  800f4b:	e8 30 15 00 00       	call   802480 <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  800f50:	83 ec 04             	sub    $0x4,%esp
  800f53:	68 00 10 00 00       	push   $0x1000
  800f58:	53                   	push   %ebx
  800f59:	68 00 f0 7f 00       	push   $0x7ff000
  800f5e:	e8 cd f9 ff ff       	call   800930 <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  800f63:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f6a:	53                   	push   %ebx
  800f6b:	83 ec 0c             	sub    $0xc,%esp
  800f6e:	e8 d5 fb ff ff       	call   800b48 <sys_getenvid>
  800f73:	83 c4 0c             	add    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	68 00 f0 7f 00       	push   $0x7ff000
  800f7c:	83 ec 04             	sub    $0x4,%esp
  800f7f:	e8 c4 fb ff ff       	call   800b48 <sys_getenvid>
  800f84:	89 04 24             	mov    %eax,(%esp)
  800f87:	e8 3d fc ff ff       	call   800bc9 <sys_page_map>
  800f8c:	83 c4 20             	add    $0x20,%esp
  800f8f:	85 c0                	test   %eax,%eax
  800f91:	79 12                	jns    800fa5 <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  800f93:	50                   	push   %eax
  800f94:	68 36 2d 80 00       	push   $0x802d36
  800f99:	6a 33                	push   $0x33
  800f9b:	68 10 2d 80 00       	push   $0x802d10
  800fa0:	e8 db 14 00 00       	call   802480 <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  800fa5:	83 ec 08             	sub    $0x8,%esp
  800fa8:	68 00 f0 7f 00       	push   $0x7ff000
  800fad:	83 ec 04             	sub    $0x4,%esp
  800fb0:	e8 93 fb ff ff       	call   800b48 <sys_getenvid>
  800fb5:	89 04 24             	mov    %eax,(%esp)
  800fb8:	e8 4e fc ff ff       	call   800c0b <sys_page_unmap>
  800fbd:	83 c4 10             	add    $0x10,%esp
  800fc0:	85 c0                	test   %eax,%eax
  800fc2:	79 12                	jns    800fd6 <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  800fc4:	50                   	push   %eax
  800fc5:	68 4f 2d 80 00       	push   $0x802d4f
  800fca:	6a 36                	push   $0x36
  800fcc:	68 10 2d 80 00       	push   $0x802d10
  800fd1:	e8 aa 14 00 00       	call   802480 <_panic>
        }

	//panic("pgfault not implemented");
}
  800fd6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <duppage>:

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
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 04             	sub    $0x4,%esp
  800fe2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  800fe8:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  800fed:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  800ff0:	f6 c4 04             	test   $0x4,%ah
  800ff3:	74 36                	je     80102b <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  800ff5:	83 ec 0c             	sub    $0xc,%esp
  800ff8:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  800ffb:	25 07 0e 00 00       	and    $0xe07,%eax
  801000:	50                   	push   %eax
  801001:	89 d8                	mov    %ebx,%eax
  801003:	c1 e0 0c             	shl    $0xc,%eax
  801006:	50                   	push   %eax
  801007:	51                   	push   %ecx
  801008:	50                   	push   %eax
  801009:	83 ec 04             	sub    $0x4,%esp
  80100c:	e8 37 fb ff ff       	call   800b48 <sys_getenvid>
  801011:	89 04 24             	mov    %eax,(%esp)
  801014:	e8 b0 fb ff ff       	call   800bc9 <sys_page_map>
  801019:	83 c4 20             	add    $0x20,%esp
            return r;
  80101c:	89 c2                	mov    %eax,%edx
  80101e:	85 c0                	test   %eax,%eax
  801020:	0f 88 c9 00 00 00    	js     8010ef <duppage+0x114>
  801026:	e9 bf 00 00 00       	jmp    8010ea <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  80102b:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  801032:	a9 02 08 00 00       	test   $0x802,%eax
  801037:	74 7b                	je     8010b4 <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801039:	83 ec 0c             	sub    $0xc,%esp
  80103c:	68 05 08 00 00       	push   $0x805
  801041:	89 d8                	mov    %ebx,%eax
  801043:	c1 e0 0c             	shl    $0xc,%eax
  801046:	50                   	push   %eax
  801047:	51                   	push   %ecx
  801048:	50                   	push   %eax
  801049:	83 ec 04             	sub    $0x4,%esp
  80104c:	e8 f7 fa ff ff       	call   800b48 <sys_getenvid>
  801051:	89 04 24             	mov    %eax,(%esp)
  801054:	e8 70 fb ff ff       	call   800bc9 <sys_page_map>
  801059:	83 c4 20             	add    $0x20,%esp
  80105c:	85 c0                	test   %eax,%eax
  80105e:	79 12                	jns    801072 <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  801060:	50                   	push   %eax
  801061:	68 6a 2d 80 00       	push   $0x802d6a
  801066:	6a 56                	push   $0x56
  801068:	68 10 2d 80 00       	push   $0x802d10
  80106d:	e8 0e 14 00 00       	call   802480 <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801072:	83 ec 0c             	sub    $0xc,%esp
  801075:	68 05 08 00 00       	push   $0x805
  80107a:	c1 e3 0c             	shl    $0xc,%ebx
  80107d:	53                   	push   %ebx
  80107e:	83 ec 0c             	sub    $0xc,%esp
  801081:	e8 c2 fa ff ff       	call   800b48 <sys_getenvid>
  801086:	83 c4 0c             	add    $0xc,%esp
  801089:	50                   	push   %eax
  80108a:	53                   	push   %ebx
  80108b:	83 ec 04             	sub    $0x4,%esp
  80108e:	e8 b5 fa ff ff       	call   800b48 <sys_getenvid>
  801093:	89 04 24             	mov    %eax,(%esp)
  801096:	e8 2e fb ff ff       	call   800bc9 <sys_page_map>
  80109b:	83 c4 20             	add    $0x20,%esp
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	79 48                	jns    8010ea <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  8010a2:	50                   	push   %eax
  8010a3:	68 6a 2d 80 00       	push   $0x802d6a
  8010a8:	6a 5b                	push   $0x5b
  8010aa:	68 10 2d 80 00       	push   $0x802d10
  8010af:	e8 cc 13 00 00       	call   802480 <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  8010b4:	83 ec 0c             	sub    $0xc,%esp
  8010b7:	6a 05                	push   $0x5
  8010b9:	89 d8                	mov    %ebx,%eax
  8010bb:	c1 e0 0c             	shl    $0xc,%eax
  8010be:	50                   	push   %eax
  8010bf:	51                   	push   %ecx
  8010c0:	50                   	push   %eax
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	e8 7f fa ff ff       	call   800b48 <sys_getenvid>
  8010c9:	89 04 24             	mov    %eax,(%esp)
  8010cc:	e8 f8 fa ff ff       	call   800bc9 <sys_page_map>
  8010d1:	83 c4 20             	add    $0x20,%esp
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	79 12                	jns    8010ea <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  8010d8:	50                   	push   %eax
  8010d9:	68 6a 2d 80 00       	push   $0x802d6a
  8010de:	6a 5f                	push   $0x5f
  8010e0:	68 10 2d 80 00       	push   $0x802d10
  8010e5:	e8 96 13 00 00       	call   802480 <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  8010ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010ef:	89 d0                	mov    %edx,%eax
  8010f1:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <fork>:

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
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	57                   	push   %edi
  8010fa:	56                   	push   %esi
  8010fb:	53                   	push   %ebx
  8010fc:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  8010ff:	68 e0 0e 80 00       	push   $0x800ee0
  801104:	e8 d7 13 00 00       	call   8024e0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  801109:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  80110c:	ba 07 00 00 00       	mov    $0x7,%edx
  801111:	89 d0                	mov    %edx,%eax
  801113:	cd 30                	int    $0x30
  801115:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  801118:	85 c0                	test   %eax,%eax
  80111a:	79 15                	jns    801131 <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  80111c:	50                   	push   %eax
  80111d:	68 f0 2c 80 00       	push   $0x802cf0
  801122:	68 85 00 00 00       	push   $0x85
  801127:	68 10 2d 80 00       	push   $0x802d10
  80112c:	e8 4f 13 00 00       	call   802480 <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  801131:	bf 00 00 00 00       	mov    $0x0,%edi
  801136:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80113a:	75 21                	jne    80115d <fork+0x67>
  80113c:	e8 07 fa ff ff       	call   800b48 <sys_getenvid>
  801141:	25 ff 03 00 00       	and    $0x3ff,%eax
  801146:	c1 e0 07             	shl    $0x7,%eax
  801149:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80114e:	a3 80 60 80 00       	mov    %eax,0x806080
  801153:	ba 00 00 00 00       	mov    $0x0,%edx
  801158:	e9 fd 00 00 00       	jmp    80125a <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  80115d:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  801164:	a8 01                	test   $0x1,%al
  801166:	74 5f                	je     8011c7 <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  801168:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116d:	89 f8                	mov    %edi,%eax
  80116f:	c1 e0 0a             	shl    $0xa,%eax
  801172:	89 c2                	mov    %eax,%edx
  801174:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801179:	77 4c                	ja     8011c7 <fork+0xd1>
  80117b:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  80117d:	01 da                	add    %ebx,%edx
  80117f:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801186:	a8 01                	test   $0x1,%al
  801188:	74 28                	je     8011b2 <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  80118a:	83 ec 08             	sub    $0x8,%esp
  80118d:	52                   	push   %edx
  80118e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801191:	e8 45 fe ff ff       	call   800fdb <duppage>
  801196:	83 c4 10             	add    $0x10,%esp
  801199:	85 c0                	test   %eax,%eax
  80119b:	79 15                	jns    8011b2 <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  80119d:	50                   	push   %eax
  80119e:	68 83 2d 80 00       	push   $0x802d83
  8011a3:	68 95 00 00 00       	push   $0x95
  8011a8:	68 10 2d 80 00       	push   $0x802d10
  8011ad:	e8 ce 12 00 00       	call   802480 <_panic>
  8011b2:	43                   	inc    %ebx
  8011b3:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  8011b9:	7f 0c                	jg     8011c7 <fork+0xd1>
  8011bb:	89 f2                	mov    %esi,%edx
  8011bd:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8011c0:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  8011c5:	76 b6                	jbe    80117d <fork+0x87>
  8011c7:	47                   	inc    %edi
  8011c8:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  8011ce:	76 8d                	jbe    80115d <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8011d0:	83 ec 04             	sub    $0x4,%esp
  8011d3:	6a 07                	push   $0x7
  8011d5:	68 00 f0 bf ee       	push   $0xeebff000
  8011da:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8011dd:	e8 a4 f9 ff ff       	call   800b86 <sys_page_alloc>
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	79 15                	jns    8011fe <fork+0x108>
          panic("fork: %d", r);
  8011e9:	50                   	push   %eax
  8011ea:	68 9c 2d 80 00       	push   $0x802d9c
  8011ef:	68 9d 00 00 00       	push   $0x9d
  8011f4:	68 10 2d 80 00       	push   $0x802d10
  8011f9:	e8 82 12 00 00       	call   802480 <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  8011fe:	83 ec 08             	sub    $0x8,%esp
  801201:	a1 80 60 80 00       	mov    0x806080,%eax
  801206:	8b 40 64             	mov    0x64(%eax),%eax
  801209:	50                   	push   %eax
  80120a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80120d:	e8 bf fa ff ff       	call   800cd1 <sys_env_set_pgfault_upcall>
  801212:	83 c4 10             	add    $0x10,%esp
  801215:	85 c0                	test   %eax,%eax
  801217:	79 15                	jns    80122e <fork+0x138>
          panic("fork: %d", r);
  801219:	50                   	push   %eax
  80121a:	68 9c 2d 80 00       	push   $0x802d9c
  80121f:	68 a2 00 00 00       	push   $0xa2
  801224:	68 10 2d 80 00       	push   $0x802d10
  801229:	e8 52 12 00 00       	call   802480 <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  80122e:	83 ec 08             	sub    $0x8,%esp
  801231:	6a 01                	push   $0x1
  801233:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801236:	e8 12 fa ff ff       	call   800c4d <sys_env_set_status>
  80123b:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  80123e:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801241:	85 c0                	test   %eax,%eax
  801243:	79 15                	jns    80125a <fork+0x164>
  801245:	50                   	push   %eax
  801246:	68 9c 2d 80 00       	push   $0x802d9c
  80124b:	68 a7 00 00 00       	push   $0xa7
  801250:	68 10 2d 80 00       	push   $0x802d10
  801255:	e8 26 12 00 00       	call   802480 <_panic>
 
	//panic("fork not implemented");
}
  80125a:	89 d0                	mov    %edx,%eax
  80125c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80125f:	5b                   	pop    %ebx
  801260:	5e                   	pop    %esi
  801261:	5f                   	pop    %edi
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <sfork>:



// Challenge!
int
sfork(void)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80126a:	68 a5 2d 80 00       	push   $0x802da5
  80126f:	68 b5 00 00 00       	push   $0xb5
  801274:	68 10 2d 80 00       	push   $0x802d10
  801279:	e8 02 12 00 00       	call   802480 <_panic>
	...

00801280 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	56                   	push   %esi
  801284:	53                   	push   %ebx
  801285:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801288:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128b:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80128e:	85 c0                	test   %eax,%eax
  801290:	75 12                	jne    8012a4 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  801292:	83 ec 0c             	sub    $0xc,%esp
  801295:	68 00 00 c0 ee       	push   $0xeec00000
  80129a:	e8 97 fa ff ff       	call   800d36 <sys_ipc_recv>
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	eb 0c                	jmp    8012b0 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  8012a4:	83 ec 0c             	sub    $0xc,%esp
  8012a7:	50                   	push   %eax
  8012a8:	e8 89 fa ff ff       	call   800d36 <sys_ipc_recv>
  8012ad:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  8012b0:	89 c2                	mov    %eax,%edx
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	78 24                	js     8012da <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  8012b6:	85 db                	test   %ebx,%ebx
  8012b8:	74 0a                	je     8012c4 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  8012ba:	a1 80 60 80 00       	mov    0x806080,%eax
  8012bf:	8b 40 74             	mov    0x74(%eax),%eax
  8012c2:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  8012c4:	85 f6                	test   %esi,%esi
  8012c6:	74 0a                	je     8012d2 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  8012c8:	a1 80 60 80 00       	mov    0x806080,%eax
  8012cd:	8b 40 78             	mov    0x78(%eax),%eax
  8012d0:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  8012d2:	a1 80 60 80 00       	mov    0x806080,%eax
  8012d7:	8b 50 70             	mov    0x70(%eax),%edx

}
  8012da:	89 d0                	mov    %edx,%eax
  8012dc:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8012df:	5b                   	pop    %ebx
  8012e0:	5e                   	pop    %esi
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <ipc_send>:

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
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	57                   	push   %edi
  8012e7:	56                   	push   %esi
  8012e8:	53                   	push   %ebx
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8012ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012f2:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	75 0a                	jne    801303 <ipc_send+0x20>
    pg = (void *) UTOP;
  8012f9:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  8012fe:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  801303:	56                   	push   %esi
  801304:	53                   	push   %ebx
  801305:	57                   	push   %edi
  801306:	ff 75 08             	pushl  0x8(%ebp)
  801309:	e8 05 fa ff ff       	call   800d13 <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  80130e:	83 c4 10             	add    $0x10,%esp
  801311:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801314:	75 07                	jne    80131d <ipc_send+0x3a>
      sys_yield();
  801316:	e8 4c f8 ff ff       	call   800b67 <sys_yield>
  80131b:	eb e6                	jmp    801303 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  80131d:	85 c0                	test   %eax,%eax
  80131f:	79 12                	jns    801333 <ipc_send+0x50>
  801321:	50                   	push   %eax
  801322:	68 bb 2d 80 00       	push   $0x802dbb
  801327:	6a 49                	push   $0x49
  801329:	68 d8 2d 80 00       	push   $0x802dd8
  80132e:	e8 4d 11 00 00       	call   802480 <_panic>
    else break;
  }
}
  801333:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801336:	5b                   	pop    %ebx
  801337:	5e                   	pop    %esi
  801338:	5f                   	pop    %edi
  801339:	c9                   	leave  
  80133a:	c3                   	ret    
	...

0080133c <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801342:	ff 75 08             	pushl  0x8(%ebp)
  801345:	e8 0a 00 00 00       	call   801354 <fd2num>
  80134a:	c1 e0 16             	shl    $0x16,%eax
  80134d:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	05 00 00 40 30       	add    $0x30400000,%eax
  80135f:	c1 e8 0c             	shr    $0xc,%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <fd_alloc>:

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
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	57                   	push   %edi
  801368:	56                   	push   %esi
  801369:	53                   	push   %ebx
  80136a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80136d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801372:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801377:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  80137c:	89 c8                	mov    %ecx,%eax
  80137e:	c1 e0 0c             	shl    $0xc,%eax
  801381:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801387:	89 d0                	mov    %edx,%eax
  801389:	c1 e8 16             	shr    $0x16,%eax
  80138c:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80138f:	a8 01                	test   $0x1,%al
  801391:	74 0c                	je     80139f <fd_alloc+0x3b>
  801393:	89 d0                	mov    %edx,%eax
  801395:	c1 e8 0c             	shr    $0xc,%eax
  801398:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  80139b:	a8 01                	test   $0x1,%al
  80139d:	75 09                	jne    8013a8 <fd_alloc+0x44>
			*fd_store = fd;
  80139f:	89 17                	mov    %edx,(%edi)
			return 0;
  8013a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a6:	eb 11                	jmp    8013b9 <fd_alloc+0x55>
  8013a8:	41                   	inc    %ecx
  8013a9:	83 f9 1f             	cmp    $0x1f,%ecx
  8013ac:	7e ce                	jle    80137c <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  8013ae:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  8013b4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013b9:	5b                   	pop    %ebx
  8013ba:	5e                   	pop    %esi
  8013bb:	5f                   	pop    %edi
  8013bc:	c9                   	leave  
  8013bd:	c3                   	ret    

008013be <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  8013c4:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8013c9:	83 f8 1f             	cmp    $0x1f,%eax
  8013cc:	77 3a                	ja     801408 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  8013ce:	c1 e0 0c             	shl    $0xc,%eax
  8013d1:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8013d7:	89 d0                	mov    %edx,%eax
  8013d9:	c1 e8 16             	shr    $0x16,%eax
  8013dc:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8013e3:	a8 01                	test   $0x1,%al
  8013e5:	74 10                	je     8013f7 <fd_lookup+0x39>
  8013e7:	89 d0                	mov    %edx,%eax
  8013e9:	c1 e8 0c             	shr    $0xc,%eax
  8013ec:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8013f3:	a8 01                	test   $0x1,%al
  8013f5:	75 07                	jne    8013fe <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  8013f7:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8013fc:	eb 0a                	jmp    801408 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  8013fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801401:	89 10                	mov    %edx,(%eax)
	return 0;
  801403:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801408:	89 d0                	mov    %edx,%eax
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <fd_close>:

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
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	56                   	push   %esi
  801410:	53                   	push   %ebx
  801411:	83 ec 10             	sub    $0x10,%esp
  801414:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801417:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80141a:	50                   	push   %eax
  80141b:	56                   	push   %esi
  80141c:	e8 33 ff ff ff       	call   801354 <fd2num>
  801421:	89 04 24             	mov    %eax,(%esp)
  801424:	e8 95 ff ff ff       	call   8013be <fd_lookup>
  801429:	89 c3                	mov    %eax,%ebx
  80142b:	83 c4 08             	add    $0x8,%esp
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 05                	js     801437 <fd_close+0x2b>
  801432:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  801435:	74 0f                	je     801446 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801437:	89 d8                	mov    %ebx,%eax
  801439:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80143d:	75 3a                	jne    801479 <fd_close+0x6d>
  80143f:	b8 00 00 00 00       	mov    $0x0,%eax
  801444:	eb 33                	jmp    801479 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80144c:	50                   	push   %eax
  80144d:	ff 36                	pushl  (%esi)
  80144f:	e8 2c 00 00 00       	call   801480 <dev_lookup>
  801454:	89 c3                	mov    %eax,%ebx
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	85 c0                	test   %eax,%eax
  80145b:	78 0f                	js     80146c <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  80145d:	83 ec 0c             	sub    $0xc,%esp
  801460:	56                   	push   %esi
  801461:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801464:	ff 50 10             	call   *0x10(%eax)
  801467:	89 c3                	mov    %eax,%ebx
  801469:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80146c:	83 ec 08             	sub    $0x8,%esp
  80146f:	56                   	push   %esi
  801470:	6a 00                	push   $0x0
  801472:	e8 94 f7 ff ff       	call   800c0b <sys_page_unmap>
	return r;
  801477:	89 d8                	mov    %ebx,%eax
}
  801479:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80147c:	5b                   	pop    %ebx
  80147d:	5e                   	pop    %esi
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <dev_lookup>:


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
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	56                   	push   %esi
  801484:	53                   	push   %ebx
  801485:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801488:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  80148b:	ba 00 00 00 00       	mov    $0x0,%edx
  801490:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  801497:	74 1c                	je     8014b5 <dev_lookup+0x35>
  801499:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80149e:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  8014a1:	39 18                	cmp    %ebx,(%eax)
  8014a3:	75 09                	jne    8014ae <dev_lookup+0x2e>
			*dev = devtab[i];
  8014a5:	89 06                	mov    %eax,(%esi)
			return 0;
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ac:	eb 29                	jmp    8014d7 <dev_lookup+0x57>
  8014ae:	42                   	inc    %edx
  8014af:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  8014b3:	75 e9                	jne    80149e <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8014b5:	83 ec 04             	sub    $0x4,%esp
  8014b8:	53                   	push   %ebx
  8014b9:	a1 80 60 80 00       	mov    0x806080,%eax
  8014be:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014c1:	50                   	push   %eax
  8014c2:	68 e4 2d 80 00       	push   $0x802de4
  8014c7:	e8 e4 ec ff ff       	call   8001b0 <cprintf>
	*dev = 0;
  8014cc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  8014d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014d7:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <close>:

int
close(int fdnum)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e4:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8014e7:	50                   	push   %eax
  8014e8:	ff 75 08             	pushl  0x8(%ebp)
  8014eb:	e8 ce fe ff ff       	call   8013be <fd_lookup>
  8014f0:	83 c4 08             	add    $0x8,%esp
		return r;
  8014f3:	89 c2                	mov    %eax,%edx
  8014f5:	85 c0                	test   %eax,%eax
  8014f7:	78 0f                	js     801508 <close+0x2a>
	else
		return fd_close(fd, 1);
  8014f9:	83 ec 08             	sub    $0x8,%esp
  8014fc:	6a 01                	push   $0x1
  8014fe:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801501:	e8 06 ff ff ff       	call   80140c <fd_close>
  801506:	89 c2                	mov    %eax,%edx
}
  801508:	89 d0                	mov    %edx,%eax
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <close_all>:

void
close_all(void)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	53                   	push   %ebx
  801510:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801513:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801518:	83 ec 0c             	sub    $0xc,%esp
  80151b:	53                   	push   %ebx
  80151c:	e8 bd ff ff ff       	call   8014de <close>
  801521:	83 c4 10             	add    $0x10,%esp
  801524:	43                   	inc    %ebx
  801525:	83 fb 1f             	cmp    $0x1f,%ebx
  801528:	7e ee                	jle    801518 <close_all+0xc>
}
  80152a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
  801532:	57                   	push   %edi
  801533:	56                   	push   %esi
  801534:	53                   	push   %ebx
  801535:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801538:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	ff 75 08             	pushl  0x8(%ebp)
  80153f:	e8 7a fe ff ff       	call   8013be <fd_lookup>
  801544:	89 c6                	mov    %eax,%esi
  801546:	83 c4 08             	add    $0x8,%esp
  801549:	85 f6                	test   %esi,%esi
  80154b:	0f 88 f8 00 00 00    	js     801649 <dup+0x11a>
		return r;
	close(newfdnum);
  801551:	83 ec 0c             	sub    $0xc,%esp
  801554:	ff 75 0c             	pushl  0xc(%ebp)
  801557:	e8 82 ff ff ff       	call   8014de <close>

	newfd = INDEX2FD(newfdnum);
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	c1 e0 0c             	shl    $0xc,%eax
  801562:	2d 00 00 40 30       	sub    $0x30400000,%eax
  801567:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  80156a:	83 c4 04             	add    $0x4,%esp
  80156d:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801570:	e8 c7 fd ff ff       	call   80133c <fd2data>
  801575:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801577:	83 c4 04             	add    $0x4,%esp
  80157a:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80157d:	e8 ba fd ff ff       	call   80133c <fd2data>
  801582:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801585:	89 f8                	mov    %edi,%eax
  801587:	c1 e8 16             	shr    $0x16,%eax
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801594:	85 c0                	test   %eax,%eax
  801596:	74 48                	je     8015e0 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801598:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  80159d:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  8015a0:	89 d0                	mov    %edx,%eax
  8015a2:	c1 e8 0c             	shr    $0xc,%eax
  8015a5:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  8015ac:	a8 01                	test   $0x1,%al
  8015ae:	74 22                	je     8015d2 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  8015b0:	83 ec 0c             	sub    $0xc,%esp
  8015b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8015b8:	50                   	push   %eax
  8015b9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8015bc:	01 d8                	add    %ebx,%eax
  8015be:	50                   	push   %eax
  8015bf:	6a 00                	push   $0x0
  8015c1:	52                   	push   %edx
  8015c2:	6a 00                	push   $0x0
  8015c4:	e8 00 f6 ff ff       	call   800bc9 <sys_page_map>
  8015c9:	89 c6                	mov    %eax,%esi
  8015cb:	83 c4 20             	add    $0x20,%esp
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	78 3f                	js     801611 <dup+0xe2>
  8015d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8015d8:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8015de:	7e bd                	jle    80159d <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8015e0:	83 ec 0c             	sub    $0xc,%esp
  8015e3:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8015e6:	89 d0                	mov    %edx,%eax
  8015e8:	c1 e8 0c             	shr    $0xc,%eax
  8015eb:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8015f2:	25 07 0e 00 00       	and    $0xe07,%eax
  8015f7:	50                   	push   %eax
  8015f8:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8015fb:	6a 00                	push   $0x0
  8015fd:	52                   	push   %edx
  8015fe:	6a 00                	push   $0x0
  801600:	e8 c4 f5 ff ff       	call   800bc9 <sys_page_map>
  801605:	89 c6                	mov    %eax,%esi
  801607:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80160a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160d:	85 f6                	test   %esi,%esi
  80160f:	79 38                	jns    801649 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801611:	83 ec 08             	sub    $0x8,%esp
  801614:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801617:	6a 00                	push   $0x0
  801619:	e8 ed f5 ff ff       	call   800c0b <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80161e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801623:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80162c:	01 d8                	add    %ebx,%eax
  80162e:	50                   	push   %eax
  80162f:	6a 00                	push   $0x0
  801631:	e8 d5 f5 ff ff       	call   800c0b <sys_page_unmap>
  801636:	83 c4 10             	add    $0x10,%esp
  801639:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80163f:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801645:	7e df                	jle    801626 <dup+0xf7>
	return r;
  801647:	89 f0                	mov    %esi,%eax
}
  801649:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80164c:	5b                   	pop    %ebx
  80164d:	5e                   	pop    %esi
  80164e:	5f                   	pop    %edi
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	53                   	push   %ebx
  801655:	83 ec 14             	sub    $0x14,%esp
  801658:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80165b:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80165e:	50                   	push   %eax
  80165f:	53                   	push   %ebx
  801660:	e8 59 fd ff ff       	call   8013be <fd_lookup>
  801665:	89 c2                	mov    %eax,%edx
  801667:	83 c4 08             	add    $0x8,%esp
  80166a:	85 c0                	test   %eax,%eax
  80166c:	78 1a                	js     801688 <read+0x37>
  80166e:	83 ec 08             	sub    $0x8,%esp
  801671:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801674:	50                   	push   %eax
  801675:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801678:	ff 30                	pushl  (%eax)
  80167a:	e8 01 fe ff ff       	call   801480 <dev_lookup>
  80167f:	89 c2                	mov    %eax,%edx
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	79 04                	jns    80168c <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801688:	89 d0                	mov    %edx,%eax
  80168a:	eb 50                	jmp    8016dc <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80168c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80168f:	8b 40 08             	mov    0x8(%eax),%eax
  801692:	83 e0 03             	and    $0x3,%eax
  801695:	83 f8 01             	cmp    $0x1,%eax
  801698:	75 1e                	jne    8016b8 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	53                   	push   %ebx
  80169e:	a1 80 60 80 00       	mov    0x806080,%eax
  8016a3:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016a6:	50                   	push   %eax
  8016a7:	68 25 2e 80 00       	push   $0x802e25
  8016ac:	e8 ff ea ff ff       	call   8001b0 <cprintf>
		return -E_INVAL;
  8016b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b6:	eb 24                	jmp    8016dc <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  8016b8:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016bb:	ff 70 04             	pushl  0x4(%eax)
  8016be:	ff 75 10             	pushl  0x10(%ebp)
  8016c1:	ff 75 0c             	pushl  0xc(%ebp)
  8016c4:	50                   	push   %eax
  8016c5:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8016c8:	ff 50 08             	call   *0x8(%eax)
  8016cb:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	85 c0                	test   %eax,%eax
  8016d2:	78 06                	js     8016da <read+0x89>
		fd->fd_offset += r;
  8016d4:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016d7:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  8016da:	89 d0                	mov    %edx,%eax
}
  8016dc:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	57                   	push   %edi
  8016e5:	56                   	push   %esi
  8016e6:	53                   	push   %ebx
  8016e7:	83 ec 0c             	sub    $0xc,%esp
  8016ea:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016ed:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f5:	39 f3                	cmp    %esi,%ebx
  8016f7:	73 25                	jae    80171e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016f9:	83 ec 04             	sub    $0x4,%esp
  8016fc:	89 f0                	mov    %esi,%eax
  8016fe:	29 d8                	sub    %ebx,%eax
  801700:	50                   	push   %eax
  801701:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801704:	50                   	push   %eax
  801705:	ff 75 08             	pushl  0x8(%ebp)
  801708:	e8 44 ff ff ff       	call   801651 <read>
		if (m < 0)
  80170d:	83 c4 10             	add    $0x10,%esp
  801710:	85 c0                	test   %eax,%eax
  801712:	78 0c                	js     801720 <readn+0x3f>
			return m;
		if (m == 0)
  801714:	85 c0                	test   %eax,%eax
  801716:	74 06                	je     80171e <readn+0x3d>
  801718:	01 c3                	add    %eax,%ebx
  80171a:	39 f3                	cmp    %esi,%ebx
  80171c:	72 db                	jb     8016f9 <readn+0x18>
			break;
	}
	return tot;
  80171e:	89 d8                	mov    %ebx,%eax
}
  801720:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801723:	5b                   	pop    %ebx
  801724:	5e                   	pop    %esi
  801725:	5f                   	pop    %edi
  801726:	c9                   	leave  
  801727:	c3                   	ret    

00801728 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801728:	55                   	push   %ebp
  801729:	89 e5                	mov    %esp,%ebp
  80172b:	53                   	push   %ebx
  80172c:	83 ec 14             	sub    $0x14,%esp
  80172f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801732:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801735:	50                   	push   %eax
  801736:	53                   	push   %ebx
  801737:	e8 82 fc ff ff       	call   8013be <fd_lookup>
  80173c:	89 c2                	mov    %eax,%edx
  80173e:	83 c4 08             	add    $0x8,%esp
  801741:	85 c0                	test   %eax,%eax
  801743:	78 1a                	js     80175f <write+0x37>
  801745:	83 ec 08             	sub    $0x8,%esp
  801748:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80174b:	50                   	push   %eax
  80174c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80174f:	ff 30                	pushl  (%eax)
  801751:	e8 2a fd ff ff       	call   801480 <dev_lookup>
  801756:	89 c2                	mov    %eax,%edx
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	85 c0                	test   %eax,%eax
  80175d:	79 04                	jns    801763 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  80175f:	89 d0                	mov    %edx,%eax
  801761:	eb 4b                	jmp    8017ae <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801763:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801766:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80176a:	75 1e                	jne    80178a <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	53                   	push   %ebx
  801770:	a1 80 60 80 00       	mov    0x806080,%eax
  801775:	8b 40 4c             	mov    0x4c(%eax),%eax
  801778:	50                   	push   %eax
  801779:	68 41 2e 80 00       	push   $0x802e41
  80177e:	e8 2d ea ff ff       	call   8001b0 <cprintf>
		return -E_INVAL;
  801783:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801788:	eb 24                	jmp    8017ae <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  80178a:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80178d:	ff 70 04             	pushl  0x4(%eax)
  801790:	ff 75 10             	pushl  0x10(%ebp)
  801793:	ff 75 0c             	pushl  0xc(%ebp)
  801796:	50                   	push   %eax
  801797:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80179a:	ff 50 0c             	call   *0xc(%eax)
  80179d:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	7e 06                	jle    8017ac <write+0x84>
		fd->fd_offset += r;
  8017a6:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017a9:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  8017ac:	89 d0                	mov    %edx,%eax
}
  8017ae:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017b9:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8017bc:	50                   	push   %eax
  8017bd:	ff 75 08             	pushl  0x8(%ebp)
  8017c0:	e8 f9 fb ff ff       	call   8013be <fd_lookup>
  8017c5:	83 c4 08             	add    $0x8,%esp
		return r;
  8017c8:	89 c2                	mov    %eax,%edx
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	78 0e                	js     8017dc <seek+0x29>
	fd->fd_offset = offset;
  8017ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d1:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8017d4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017dc:	89 d0                	mov    %edx,%eax
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 14             	sub    $0x14,%esp
  8017e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ea:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8017ed:	50                   	push   %eax
  8017ee:	53                   	push   %ebx
  8017ef:	e8 ca fb ff ff       	call   8013be <fd_lookup>
  8017f4:	83 c4 08             	add    $0x8,%esp
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 4e                	js     801849 <ftruncate+0x69>
  8017fb:	83 ec 08             	sub    $0x8,%esp
  8017fe:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801801:	50                   	push   %eax
  801802:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801805:	ff 30                	pushl  (%eax)
  801807:	e8 74 fc ff ff       	call   801480 <dev_lookup>
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 36                	js     801849 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801813:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801816:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80181a:	75 1e                	jne    80183a <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80181c:	83 ec 04             	sub    $0x4,%esp
  80181f:	53                   	push   %ebx
  801820:	a1 80 60 80 00       	mov    0x806080,%eax
  801825:	8b 40 4c             	mov    0x4c(%eax),%eax
  801828:	50                   	push   %eax
  801829:	68 04 2e 80 00       	push   $0x802e04
  80182e:	e8 7d e9 ff ff       	call   8001b0 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801833:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801838:	eb 0f                	jmp    801849 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	ff 75 0c             	pushl  0xc(%ebp)
  801840:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801843:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801846:	ff 50 1c             	call   *0x1c(%eax)
}
  801849:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	53                   	push   %ebx
  801852:	83 ec 14             	sub    $0x14,%esp
  801855:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801858:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80185b:	50                   	push   %eax
  80185c:	ff 75 08             	pushl  0x8(%ebp)
  80185f:	e8 5a fb ff ff       	call   8013be <fd_lookup>
  801864:	83 c4 08             	add    $0x8,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 42                	js     8018ad <fstat+0x5f>
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801871:	50                   	push   %eax
  801872:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801875:	ff 30                	pushl  (%eax)
  801877:	e8 04 fc ff ff       	call   801480 <dev_lookup>
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	85 c0                	test   %eax,%eax
  801881:	78 2a                	js     8018ad <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  801883:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801886:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80188d:	00 00 00 
	stat->st_isdir = 0;
  801890:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801897:	00 00 00 
	stat->st_dev = dev;
  80189a:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80189d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018a3:	83 ec 08             	sub    $0x8,%esp
  8018a6:	53                   	push   %ebx
  8018a7:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8018aa:	ff 50 14             	call   *0x14(%eax)
}
  8018ad:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8018b0:	c9                   	leave  
  8018b1:	c3                   	ret    

008018b2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	56                   	push   %esi
  8018b6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018b7:	83 ec 08             	sub    $0x8,%esp
  8018ba:	6a 00                	push   $0x0
  8018bc:	ff 75 08             	pushl  0x8(%ebp)
  8018bf:	e8 28 00 00 00       	call   8018ec <open>
  8018c4:	89 c6                	mov    %eax,%esi
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	85 f6                	test   %esi,%esi
  8018cb:	78 18                	js     8018e5 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  8018cd:	83 ec 08             	sub    $0x8,%esp
  8018d0:	ff 75 0c             	pushl  0xc(%ebp)
  8018d3:	56                   	push   %esi
  8018d4:	e8 75 ff ff ff       	call   80184e <fstat>
  8018d9:	89 c3                	mov    %eax,%ebx
	close(fd);
  8018db:	89 34 24             	mov    %esi,(%esp)
  8018de:	e8 fb fb ff ff       	call   8014de <close>
	return r;
  8018e3:	89 d8                	mov    %ebx,%eax
}
  8018e5:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8018e8:	5b                   	pop    %ebx
  8018e9:	5e                   	pop    %esi
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 10             	sub    $0x10,%esp
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
  8018f3:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8018f6:	50                   	push   %eax
  8018f7:	e8 68 fa ff ff       	call   801364 <fd_alloc>
  8018fc:	89 c3                	mov    %eax,%ebx
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	85 db                	test   %ebx,%ebx
  801903:	78 36                	js     80193b <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80190b:	ff 75 0c             	pushl  0xc(%ebp)
  80190e:	ff 75 08             	pushl  0x8(%ebp)
  801911:	e8 1b 05 00 00       	call   801e31 <fsipc_open>
  801916:	89 c3                	mov    %eax,%ebx
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	85 c0                	test   %eax,%eax
  80191d:	79 11                	jns    801930 <open+0x44>
          fd_close(fd_store, 0);
  80191f:	83 ec 08             	sub    $0x8,%esp
  801922:	6a 00                	push   $0x0
  801924:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801927:	e8 e0 fa ff ff       	call   80140c <fd_close>
          return r;
  80192c:	89 d8                	mov    %ebx,%eax
  80192e:	eb 0b                	jmp    80193b <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801930:	83 ec 0c             	sub    $0xc,%esp
  801933:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801936:	e8 19 fa ff ff       	call   801354 <fd2num>
}
  80193b:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	53                   	push   %ebx
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  80194a:	6a 01                	push   $0x1
  80194c:	6a 00                	push   $0x0
  80194e:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801954:	53                   	push   %ebx
  801955:	e8 e7 03 00 00       	call   801d41 <funmap>
  80195a:	83 c4 10             	add    $0x10,%esp
          return r;
  80195d:	89 c2                	mov    %eax,%edx
  80195f:	85 c0                	test   %eax,%eax
  801961:	78 19                	js     80197c <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  801963:	83 ec 0c             	sub    $0xc,%esp
  801966:	ff 73 0c             	pushl  0xc(%ebx)
  801969:	e8 68 05 00 00       	call   801ed6 <fsipc_close>
  80196e:	83 c4 10             	add    $0x10,%esp
          return r;
  801971:	89 c2                	mov    %eax,%edx
  801973:	85 c0                	test   %eax,%eax
  801975:	78 05                	js     80197c <file_close+0x3c>
        }
        return 0;
  801977:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80197c:	89 d0                	mov    %edx,%eax
  80197e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	57                   	push   %edi
  801987:	56                   	push   %esi
  801988:	53                   	push   %ebx
  801989:	83 ec 0c             	sub    $0xc,%esp
  80198c:	8b 75 10             	mov    0x10(%ebp),%esi
  80198f:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  80199b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019a0:	39 d7                	cmp    %edx,%edi
  8019a2:	0f 87 95 00 00 00    	ja     801a3d <file_read+0xba>
	if (offset + n > size)
  8019a8:	8d 04 37             	lea    (%edi,%esi,1),%eax
  8019ab:	39 d0                	cmp    %edx,%eax
  8019ad:	76 04                	jbe    8019b3 <file_read+0x30>
		n = size - offset;
  8019af:	89 d6                	mov    %edx,%esi
  8019b1:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8019b3:	83 ec 0c             	sub    $0xc,%esp
  8019b6:	ff 75 08             	pushl  0x8(%ebp)
  8019b9:	e8 7e f9 ff ff       	call   80133c <fd2data>
  8019be:	89 c3                	mov    %eax,%ebx
  8019c0:	01 fb                	add    %edi,%ebx
  8019c2:	83 c4 10             	add    $0x10,%esp
  8019c5:	eb 41                	jmp    801a08 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8019c7:	89 d8                	mov    %ebx,%eax
  8019c9:	c1 e8 16             	shr    $0x16,%eax
  8019cc:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8019d3:	a8 01                	test   $0x1,%al
  8019d5:	74 10                	je     8019e7 <file_read+0x64>
  8019d7:	89 d8                	mov    %ebx,%eax
  8019d9:	c1 e8 0c             	shr    $0xc,%eax
  8019dc:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8019e3:	a8 01                	test   $0x1,%al
  8019e5:	75 1b                	jne    801a02 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8019e7:	83 ec 04             	sub    $0x4,%esp
  8019ea:	8d 04 37             	lea    (%edi,%esi,1),%eax
  8019ed:	50                   	push   %eax
  8019ee:	57                   	push   %edi
  8019ef:	ff 75 08             	pushl  0x8(%ebp)
  8019f2:	e8 d4 02 00 00       	call   801ccb <fmap>
  8019f7:	83 c4 10             	add    $0x10,%esp
              return r;
  8019fa:	89 c1                	mov    %eax,%ecx
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 3d                	js     801a3d <file_read+0xba>
  801a00:	eb 1c                	jmp    801a1e <file_read+0x9b>
  801a02:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a08:	83 ec 0c             	sub    $0xc,%esp
  801a0b:	ff 75 08             	pushl  0x8(%ebp)
  801a0e:	e8 29 f9 ff ff       	call   80133c <fd2data>
  801a13:	01 f8                	add    %edi,%eax
  801a15:	01 f0                	add    %esi,%eax
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	39 d8                	cmp    %ebx,%eax
  801a1c:	77 a9                	ja     8019c7 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801a1e:	83 ec 04             	sub    $0x4,%esp
  801a21:	56                   	push   %esi
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	ff 75 08             	pushl  0x8(%ebp)
  801a28:	e8 0f f9 ff ff       	call   80133c <fd2data>
  801a2d:	83 c4 08             	add    $0x8,%esp
  801a30:	01 f8                	add    %edi,%eax
  801a32:	50                   	push   %eax
  801a33:	ff 75 0c             	pushl  0xc(%ebp)
  801a36:	e8 f5 ee ff ff       	call   800930 <memmove>
	return n;
  801a3b:	89 f1                	mov    %esi,%ecx
}
  801a3d:	89 c8                	mov    %ecx,%eax
  801a3f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801a42:	5b                   	pop    %ebx
  801a43:	5e                   	pop    %esi
  801a44:	5f                   	pop    %edi
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	56                   	push   %esi
  801a4b:	53                   	push   %ebx
  801a4c:	83 ec 18             	sub    $0x18,%esp
  801a4f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a52:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801a55:	50                   	push   %eax
  801a56:	ff 75 08             	pushl  0x8(%ebp)
  801a59:	e8 60 f9 ff ff       	call   8013be <fd_lookup>
  801a5e:	83 c4 10             	add    $0x10,%esp
		return r;
  801a61:	89 c2                	mov    %eax,%edx
  801a63:	85 c0                	test   %eax,%eax
  801a65:	0f 88 9f 00 00 00    	js     801b0a <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801a6b:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801a6e:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  801a70:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801a75:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  801a7b:	0f 85 89 00 00 00    	jne    801b0a <read_map+0xc3>
	va = fd2data(fd) + offset;
  801a81:	83 ec 0c             	sub    $0xc,%esp
  801a84:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801a87:	e8 b0 f8 ff ff       	call   80133c <fd2data>
  801a8c:	89 c3                	mov    %eax,%ebx
  801a8e:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801a90:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801a93:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801a98:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801a9e:	7f 6a                	jg     801b0a <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801aa0:	89 d8                	mov    %ebx,%eax
  801aa2:	c1 e8 16             	shr    $0x16,%eax
  801aa5:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801aac:	a8 01                	test   $0x1,%al
  801aae:	74 10                	je     801ac0 <read_map+0x79>
  801ab0:	89 d8                	mov    %ebx,%eax
  801ab2:	c1 e8 0c             	shr    $0xc,%eax
  801ab5:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801abc:	a8 01                	test   $0x1,%al
  801abe:	75 19                	jne    801ad9 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	8d 46 01             	lea    0x1(%esi),%eax
  801ac6:	50                   	push   %eax
  801ac7:	56                   	push   %esi
  801ac8:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801acb:	e8 fb 01 00 00       	call   801ccb <fmap>
  801ad0:	83 c4 10             	add    $0x10,%esp
            return r;
  801ad3:	89 c2                	mov    %eax,%edx
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 31                	js     801b0a <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801ad9:	89 d8                	mov    %ebx,%eax
  801adb:	c1 e8 16             	shr    $0x16,%eax
  801ade:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801ae5:	a8 01                	test   $0x1,%al
  801ae7:	74 10                	je     801af9 <read_map+0xb2>
  801ae9:	89 d8                	mov    %ebx,%eax
  801aeb:	c1 e8 0c             	shr    $0xc,%eax
  801aee:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801af5:	a8 01                	test   $0x1,%al
  801af7:	75 07                	jne    801b00 <read_map+0xb9>
		return -E_NO_DISK;
  801af9:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801afe:	eb 0a                	jmp    801b0a <read_map+0xc3>

	*blk = (void*) va;
  801b00:	8b 45 10             	mov    0x10(%ebp),%eax
  801b03:	89 18                	mov    %ebx,(%eax)
	return 0;
  801b05:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b0a:	89 d0                	mov    %edx,%eax
  801b0c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801b0f:	5b                   	pop    %ebx
  801b10:	5e                   	pop    %esi
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	57                   	push   %edi
  801b17:	56                   	push   %esi
  801b18:	53                   	push   %ebx
  801b19:	83 ec 0c             	sub    $0xc,%esp
  801b1c:	8b 75 08             	mov    0x8(%ebp),%esi
  801b1f:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801b22:	8b 45 10             	mov    0x10(%ebp),%eax
  801b25:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801b28:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801b2d:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801b33:	0f 87 bd 00 00 00    	ja     801bf6 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801b39:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801b3f:	73 17                	jae    801b58 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801b41:	83 ec 08             	sub    $0x8,%esp
  801b44:	52                   	push   %edx
  801b45:	56                   	push   %esi
  801b46:	e8 fb 00 00 00       	call   801c46 <file_trunc>
  801b4b:	83 c4 10             	add    $0x10,%esp
			return r;
  801b4e:	89 c1                	mov    %eax,%ecx
  801b50:	85 c0                	test   %eax,%eax
  801b52:	0f 88 9e 00 00 00    	js     801bf6 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801b58:	83 ec 0c             	sub    $0xc,%esp
  801b5b:	56                   	push   %esi
  801b5c:	e8 db f7 ff ff       	call   80133c <fd2data>
  801b61:	89 c3                	mov    %eax,%ebx
  801b63:	01 fb                	add    %edi,%ebx
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	eb 42                	jmp    801bac <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801b6a:	89 d8                	mov    %ebx,%eax
  801b6c:	c1 e8 16             	shr    $0x16,%eax
  801b6f:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801b76:	a8 01                	test   $0x1,%al
  801b78:	74 10                	je     801b8a <file_write+0x77>
  801b7a:	89 d8                	mov    %ebx,%eax
  801b7c:	c1 e8 0c             	shr    $0xc,%eax
  801b7f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b86:	a8 01                	test   $0x1,%al
  801b88:	75 1c                	jne    801ba6 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801b8a:	83 ec 04             	sub    $0x4,%esp
  801b8d:	8b 55 10             	mov    0x10(%ebp),%edx
  801b90:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801b93:	50                   	push   %eax
  801b94:	57                   	push   %edi
  801b95:	56                   	push   %esi
  801b96:	e8 30 01 00 00       	call   801ccb <fmap>
  801b9b:	83 c4 10             	add    $0x10,%esp
              return r;
  801b9e:	89 c1                	mov    %eax,%ecx
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	78 52                	js     801bf6 <file_write+0xe3>
  801ba4:	eb 1b                	jmp    801bc1 <file_write+0xae>
  801ba6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801bac:	83 ec 0c             	sub    $0xc,%esp
  801baf:	56                   	push   %esi
  801bb0:	e8 87 f7 ff ff       	call   80133c <fd2data>
  801bb5:	01 f8                	add    %edi,%eax
  801bb7:	03 45 10             	add    0x10(%ebp),%eax
  801bba:	83 c4 10             	add    $0x10,%esp
  801bbd:	39 d8                	cmp    %ebx,%eax
  801bbf:	77 a9                	ja     801b6a <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801bc1:	83 ec 0c             	sub    $0xc,%esp
  801bc4:	68 5e 2e 80 00       	push   $0x802e5e
  801bc9:	e8 e2 e5 ff ff       	call   8001b0 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801bce:	83 c4 0c             	add    $0xc,%esp
  801bd1:	ff 75 10             	pushl  0x10(%ebp)
  801bd4:	ff 75 0c             	pushl  0xc(%ebp)
  801bd7:	56                   	push   %esi
  801bd8:	e8 5f f7 ff ff       	call   80133c <fd2data>
  801bdd:	01 f8                	add    %edi,%eax
  801bdf:	89 04 24             	mov    %eax,(%esp)
  801be2:	e8 49 ed ff ff       	call   800930 <memmove>
        cprintf("write done\n");
  801be7:	c7 04 24 6b 2e 80 00 	movl   $0x802e6b,(%esp)
  801bee:	e8 bd e5 ff ff       	call   8001b0 <cprintf>
	return n;
  801bf3:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801bf6:	89 c8                	mov    %ecx,%eax
  801bf8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5f                   	pop    %edi
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	56                   	push   %esi
  801c04:	53                   	push   %ebx
  801c05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c08:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801c0b:	83 ec 08             	sub    $0x8,%esp
  801c0e:	8d 43 10             	lea    0x10(%ebx),%eax
  801c11:	50                   	push   %eax
  801c12:	56                   	push   %esi
  801c13:	e8 9c eb ff ff       	call   8007b4 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801c18:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801c1e:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801c24:	83 c4 10             	add    $0x10,%esp
  801c27:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801c2e:	0f 94 c0             	sete   %al
  801c31:	0f b6 c0             	movzbl %al,%eax
  801c34:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801c3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3f:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801c42:	5b                   	pop    %ebx
  801c43:	5e                   	pop    %esi
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	57                   	push   %edi
  801c4a:	56                   	push   %esi
  801c4b:	53                   	push   %ebx
  801c4c:	83 ec 0c             	sub    $0xc,%esp
  801c4f:	8b 75 08             	mov    0x8(%ebp),%esi
  801c52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801c55:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801c5a:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801c60:	7f 5f                	jg     801cc1 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801c62:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801c68:	83 ec 08             	sub    $0x8,%esp
  801c6b:	53                   	push   %ebx
  801c6c:	ff 76 0c             	pushl  0xc(%esi)
  801c6f:	e8 3a 02 00 00       	call   801eae <fsipc_set_size>
  801c74:	83 c4 10             	add    $0x10,%esp
		return r;
  801c77:	89 c2                	mov    %eax,%edx
  801c79:	85 c0                	test   %eax,%eax
  801c7b:	78 44                	js     801cc1 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801c7d:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801c83:	74 19                	je     801c9e <file_trunc+0x58>
  801c85:	68 98 2e 80 00       	push   $0x802e98
  801c8a:	68 77 2e 80 00       	push   $0x802e77
  801c8f:	68 dc 00 00 00       	push   $0xdc
  801c94:	68 8c 2e 80 00       	push   $0x802e8c
  801c99:	e8 e2 07 00 00       	call   802480 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	53                   	push   %ebx
  801ca2:	57                   	push   %edi
  801ca3:	56                   	push   %esi
  801ca4:	e8 22 00 00 00       	call   801ccb <fmap>
  801ca9:	83 c4 10             	add    $0x10,%esp
		return r;
  801cac:	89 c2                	mov    %eax,%edx
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	78 0f                	js     801cc1 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	53                   	push   %ebx
  801cb5:	57                   	push   %edi
  801cb6:	56                   	push   %esi
  801cb7:	e8 85 00 00 00       	call   801d41 <funmap>

	return 0;
  801cbc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801cc1:	89 d0                	mov    %edx,%eax
  801cc3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801cc6:	5b                   	pop    %ebx
  801cc7:	5e                   	pop    %esi
  801cc8:	5f                   	pop    %edi
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <fmap>:

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
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	57                   	push   %edi
  801ccf:	56                   	push   %esi
  801cd0:	53                   	push   %ebx
  801cd1:	83 ec 0c             	sub    $0xc,%esp
  801cd4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cd7:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801cda:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801cdd:	7d 55                	jge    801d34 <fmap+0x69>
          fma = fd2data(fd);
  801cdf:	83 ec 0c             	sub    $0xc,%esp
  801ce2:	57                   	push   %edi
  801ce3:	e8 54 f6 ff ff       	call   80133c <fd2data>
  801ce8:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801ceb:	83 c4 10             	add    $0x10,%esp
  801cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf1:	05 ff 0f 00 00       	add    $0xfff,%eax
  801cf6:	89 c3                	mov    %eax,%ebx
  801cf8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801cfe:	39 f3                	cmp    %esi,%ebx
  801d00:	7d 32                	jge    801d34 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801d08:	01 d8                	add    %ebx,%eax
  801d0a:	50                   	push   %eax
  801d0b:	53                   	push   %ebx
  801d0c:	ff 77 0c             	pushl  0xc(%edi)
  801d0f:	e8 6f 01 00 00       	call   801e83 <fsipc_map>
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	85 c0                	test   %eax,%eax
  801d19:	79 0f                	jns    801d2a <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	ff 75 0c             	pushl  0xc(%ebp)
  801d20:	53                   	push   %ebx
  801d21:	57                   	push   %edi
  801d22:	e8 1a 00 00 00       	call   801d41 <funmap>
  801d27:	83 c4 10             	add    $0x10,%esp
  801d2a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d30:	39 f3                	cmp    %esi,%ebx
  801d32:	7c ce                	jl     801d02 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
  801d39:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d3c:	5b                   	pop    %ebx
  801d3d:	5e                   	pop    %esi
  801d3e:	5f                   	pop    %edi
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <funmap>:

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
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	57                   	push   %edi
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d4d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801d50:	39 f3                	cmp    %esi,%ebx
  801d52:	0f 8d 80 00 00 00    	jge    801dd8 <funmap+0x97>
          fma = fd2data(fd);
  801d58:	83 ec 0c             	sub    $0xc,%esp
  801d5b:	ff 75 08             	pushl  0x8(%ebp)
  801d5e:	e8 d9 f5 ff ff       	call   80133c <fd2data>
  801d63:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801d65:	83 c4 10             	add    $0x10,%esp
  801d68:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801d6e:	89 c3                	mov    %eax,%ebx
  801d70:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801d76:	39 f3                	cmp    %esi,%ebx
  801d78:	7d 5e                	jge    801dd8 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801d7a:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801d7d:	89 c2                	mov    %eax,%edx
  801d7f:	c1 ea 0c             	shr    $0xc,%edx
  801d82:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801d89:	a8 01                	test   $0x1,%al
  801d8b:	74 41                	je     801dce <funmap+0x8d>
              if (dirty) {
  801d8d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801d91:	74 21                	je     801db4 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801d93:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801d9a:	a8 40                	test   $0x40,%al
  801d9c:	74 16                	je     801db4 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801d9e:	83 ec 08             	sub    $0x8,%esp
  801da1:	53                   	push   %ebx
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	ff 70 0c             	pushl  0xc(%eax)
  801da8:	e8 49 01 00 00       	call   801ef6 <fsipc_dirty>
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	85 c0                	test   %eax,%eax
  801db2:	78 29                	js     801ddd <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801db4:	83 ec 08             	sub    $0x8,%esp
  801db7:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801dba:	50                   	push   %eax
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	e8 85 ed ff ff       	call   800b48 <sys_getenvid>
  801dc3:	89 04 24             	mov    %eax,(%esp)
  801dc6:	e8 40 ee ff ff       	call   800c0b <sys_page_unmap>
  801dcb:	83 c4 10             	add    $0x10,%esp
  801dce:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801dd4:	39 f3                	cmp    %esi,%ebx
  801dd6:	7c a2                	jl     801d7a <funmap+0x39>
            }
          }
        }

        return 0;
  801dd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ddd:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801de0:	5b                   	pop    %ebx
  801de1:	5e                   	pop    %esi
  801de2:	5f                   	pop    %edi
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <remove>:

// Delete a file
int
remove(const char *path)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801deb:	ff 75 08             	pushl  0x8(%ebp)
  801dee:	e8 2b 01 00 00       	call   801f1e <fsipc_remove>
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801dfb:	e8 64 01 00 00       	call   801f64 <fsipc_sync>
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    
	...

00801e04 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801e0a:	6a 07                	push   $0x7
  801e0c:	ff 75 0c             	pushl  0xc(%ebp)
  801e0f:	ff 75 08             	pushl  0x8(%ebp)
  801e12:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801e17:	50                   	push   %eax
  801e18:	e8 c6 f4 ff ff       	call   8012e3 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801e1d:	83 c4 0c             	add    $0xc,%esp
  801e20:	ff 75 14             	pushl  0x14(%ebp)
  801e23:	ff 75 10             	pushl  0x10(%ebp)
  801e26:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801e29:	50                   	push   %eax
  801e2a:	e8 51 f4 ff ff       	call   801280 <ipc_recv>
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	56                   	push   %esi
  801e35:	53                   	push   %ebx
  801e36:	83 ec 1c             	sub    $0x1c,%esp
  801e39:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801e3c:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801e41:	56                   	push   %esi
  801e42:	e8 31 e9 ff ff       	call   800778 <strlen>
  801e47:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801e4a:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801e4f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e54:	7f 24                	jg     801e7a <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801e56:	83 ec 08             	sub    $0x8,%esp
  801e59:	56                   	push   %esi
  801e5a:	53                   	push   %ebx
  801e5b:	e8 54 e9 ff ff       	call   8007b4 <strcpy>
	req->req_omode = omode;
  801e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e63:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801e69:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801e6c:	50                   	push   %eax
  801e6d:	ff 75 10             	pushl  0x10(%ebp)
  801e70:	53                   	push   %ebx
  801e71:	6a 01                	push   $0x1
  801e73:	e8 8c ff ff ff       	call   801e04 <fsipc>
  801e78:	89 c2                	mov    %eax,%edx
}
  801e7a:	89 d0                	mov    %edx,%eax
  801e7c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e94:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801e99:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801e9c:	50                   	push   %eax
  801e9d:	ff 75 10             	pushl  0x10(%ebp)
  801ea0:	68 00 30 80 00       	push   $0x803000
  801ea5:	6a 02                	push   $0x2
  801ea7:	e8 58 ff ff ff       	call   801e04 <fsipc>

	//return -E_UNSPECIFIED;
}
  801eac:	c9                   	leave  
  801ead:	c3                   	ret    

00801eae <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  801ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebf:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	68 00 30 80 00       	push   $0x803000
  801ecd:	6a 03                	push   $0x3
  801ecf:	e8 30 ff ff ff       	call   801e04 <fsipc>
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 00                	push   $0x0
  801ee8:	68 00 30 80 00       	push   $0x803000
  801eed:	6a 04                	push   $0x4
  801eef:	e8 10 ff ff ff       	call   801e04 <fsipc>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f07:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	68 00 30 80 00       	push   $0x803000
  801f15:	6a 05                	push   $0x5
  801f17:	e8 e8 fe ff ff       	call   801e04 <fsipc>
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	56                   	push   %esi
  801f22:	53                   	push   %ebx
  801f23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801f26:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	53                   	push   %ebx
  801f2f:	e8 44 e8 ff ff       	call   800778 <strlen>
  801f34:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801f37:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801f3c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f41:	7f 18                	jg     801f5b <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801f43:	83 ec 08             	sub    $0x8,%esp
  801f46:	53                   	push   %ebx
  801f47:	56                   	push   %esi
  801f48:	e8 67 e8 ff ff       	call   8007b4 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	56                   	push   %esi
  801f52:	6a 06                	push   $0x6
  801f54:	e8 ab fe ff ff       	call   801e04 <fsipc>
  801f59:	89 c2                	mov    %eax,%edx
}
  801f5b:	89 d0                	mov    %edx,%eax
  801f5d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801f60:	5b                   	pop    %ebx
  801f61:	5e                   	pop    %esi
  801f62:	c9                   	leave  
  801f63:	c3                   	ret    

00801f64 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	68 00 30 80 00       	push   $0x803000
  801f73:	6a 07                	push   $0x7
  801f75:	e8 8a fe ff ff       	call   801e04 <fsipc>
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <pipe>:
};

int
pipe(int pfd[2])
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	57                   	push   %edi
  801f80:	56                   	push   %esi
  801f81:	53                   	push   %ebx
  801f82:	83 ec 18             	sub    $0x18,%esp
  801f85:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f88:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801f8b:	50                   	push   %eax
  801f8c:	e8 d3 f3 ff ff       	call   801364 <fd_alloc>
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	85 c0                	test   %eax,%eax
  801f98:	0f 88 25 01 00 00    	js     8020c3 <pipe+0x147>
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	68 07 04 00 00       	push   $0x407
  801fa6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801fa9:	6a 00                	push   $0x0
  801fab:	e8 d6 eb ff ff       	call   800b86 <sys_page_alloc>
  801fb0:	89 c3                	mov    %eax,%ebx
  801fb2:	83 c4 10             	add    $0x10,%esp
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	0f 88 06 01 00 00    	js     8020c3 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801fc3:	50                   	push   %eax
  801fc4:	e8 9b f3 ff ff       	call   801364 <fd_alloc>
  801fc9:	89 c3                	mov    %eax,%ebx
  801fcb:	83 c4 10             	add    $0x10,%esp
  801fce:	85 c0                	test   %eax,%eax
  801fd0:	0f 88 dd 00 00 00    	js     8020b3 <pipe+0x137>
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	68 07 04 00 00       	push   $0x407
  801fde:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801fe1:	6a 00                	push   $0x0
  801fe3:	e8 9e eb ff ff       	call   800b86 <sys_page_alloc>
  801fe8:	89 c3                	mov    %eax,%ebx
  801fea:	83 c4 10             	add    $0x10,%esp
  801fed:	85 c0                	test   %eax,%eax
  801fef:	0f 88 be 00 00 00    	js     8020b3 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801ff5:	83 ec 0c             	sub    $0xc,%esp
  801ff8:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801ffb:	e8 3c f3 ff ff       	call   80133c <fd2data>
  802000:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802002:	83 c4 0c             	add    $0xc,%esp
  802005:	68 07 04 00 00       	push   $0x407
  80200a:	50                   	push   %eax
  80200b:	6a 00                	push   $0x0
  80200d:	e8 74 eb ff ff       	call   800b86 <sys_page_alloc>
  802012:	89 c3                	mov    %eax,%ebx
  802014:	83 c4 10             	add    $0x10,%esp
  802017:	85 c0                	test   %eax,%eax
  802019:	0f 88 84 00 00 00    	js     8020a3 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201f:	83 ec 0c             	sub    $0xc,%esp
  802022:	68 07 04 00 00       	push   $0x407
  802027:	83 ec 0c             	sub    $0xc,%esp
  80202a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80202d:	e8 0a f3 ff ff       	call   80133c <fd2data>
  802032:	83 c4 10             	add    $0x10,%esp
  802035:	50                   	push   %eax
  802036:	6a 00                	push   $0x0
  802038:	56                   	push   %esi
  802039:	6a 00                	push   $0x0
  80203b:	e8 89 eb ff ff       	call   800bc9 <sys_page_map>
  802040:	89 c3                	mov    %eax,%ebx
  802042:	83 c4 20             	add    $0x20,%esp
  802045:	85 c0                	test   %eax,%eax
  802047:	78 4c                	js     802095 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802049:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80204f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802052:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802054:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802057:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80205e:	8b 15 40 60 80 00    	mov    0x806040,%edx
  802064:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802067:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802069:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80206c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802079:	e8 d6 f2 ff ff       	call   801354 <fd2num>
  80207e:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802080:	83 c4 04             	add    $0x4,%esp
  802083:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802086:	e8 c9 f2 ff ff       	call   801354 <fd2num>
  80208b:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	eb 30                	jmp    8020c5 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  802095:	83 ec 08             	sub    $0x8,%esp
  802098:	56                   	push   %esi
  802099:	6a 00                	push   $0x0
  80209b:	e8 6b eb ff ff       	call   800c0b <sys_page_unmap>
  8020a0:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  8020a3:	83 ec 08             	sub    $0x8,%esp
  8020a6:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8020a9:	6a 00                	push   $0x0
  8020ab:	e8 5b eb ff ff       	call   800c0b <sys_page_unmap>
  8020b0:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8020b3:	83 ec 08             	sub    $0x8,%esp
  8020b6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8020b9:	6a 00                	push   $0x0
  8020bb:	e8 4b eb ff ff       	call   800c0b <sys_page_unmap>
  8020c0:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  8020c3:	89 d8                	mov    %ebx,%eax
}
  8020c5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8020c8:	5b                   	pop    %ebx
  8020c9:	5e                   	pop    %esi
  8020ca:	5f                   	pop    %edi
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	57                   	push   %edi
  8020d1:	56                   	push   %esi
  8020d2:	53                   	push   %ebx
  8020d3:	83 ec 0c             	sub    $0xc,%esp
  8020d6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8020d9:	a1 80 60 80 00       	mov    0x806080,%eax
  8020de:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8020e1:	83 ec 0c             	sub    $0xc,%esp
  8020e4:	ff 75 08             	pushl  0x8(%ebp)
  8020e7:	e8 a8 04 00 00       	call   802594 <pageref>
  8020ec:	89 c3                	mov    %eax,%ebx
  8020ee:	89 3c 24             	mov    %edi,(%esp)
  8020f1:	e8 9e 04 00 00       	call   802594 <pageref>
  8020f6:	83 c4 10             	add    $0x10,%esp
  8020f9:	39 c3                	cmp    %eax,%ebx
  8020fb:	0f 94 c0             	sete   %al
  8020fe:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  802101:	8b 0d 80 60 80 00    	mov    0x806080,%ecx
  802107:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  80210a:	39 c6                	cmp    %eax,%esi
  80210c:	74 1b                	je     802129 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  80210e:	83 fa 01             	cmp    $0x1,%edx
  802111:	75 c6                	jne    8020d9 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802113:	6a 01                	push   $0x1
  802115:	8b 41 58             	mov    0x58(%ecx),%eax
  802118:	50                   	push   %eax
  802119:	56                   	push   %esi
  80211a:	68 c0 2e 80 00       	push   $0x802ec0
  80211f:	e8 8c e0 ff ff       	call   8001b0 <cprintf>
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	eb b0                	jmp    8020d9 <_pipeisclosed+0xc>
	}
}
  802129:	89 d0                	mov    %edx,%eax
  80212b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80212e:	5b                   	pop    %ebx
  80212f:	5e                   	pop    %esi
  802130:	5f                   	pop    %edi
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802139:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80213c:	50                   	push   %eax
  80213d:	ff 75 08             	pushl  0x8(%ebp)
  802140:	e8 79 f2 ff ff       	call   8013be <fd_lookup>
  802145:	83 c4 10             	add    $0x10,%esp
		return r;
  802148:	89 c2                	mov    %eax,%edx
  80214a:	85 c0                	test   %eax,%eax
  80214c:	78 19                	js     802167 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  80214e:	83 ec 0c             	sub    $0xc,%esp
  802151:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802154:	e8 e3 f1 ff ff       	call   80133c <fd2data>
	return _pipeisclosed(fd, p);
  802159:	83 c4 08             	add    $0x8,%esp
  80215c:	50                   	push   %eax
  80215d:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802160:	e8 68 ff ff ff       	call   8020cd <_pipeisclosed>
  802165:	89 c2                	mov    %eax,%edx
}
  802167:	89 d0                	mov    %edx,%eax
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	57                   	push   %edi
  80216f:	56                   	push   %esi
  802170:	53                   	push   %ebx
  802171:	83 ec 18             	sub    $0x18,%esp
  802174:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  802177:	57                   	push   %edi
  802178:	e8 bf f1 ff ff       	call   80133c <fd2data>
  80217d:	89 c3                	mov    %eax,%ebx
	if (debug)
  80217f:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802182:	8b 45 0c             	mov    0xc(%ebp),%eax
  802185:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802188:	be 00 00 00 00       	mov    $0x0,%esi
  80218d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802190:	73 55                	jae    8021e7 <piperead+0x7c>
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
  802192:	8b 03                	mov    (%ebx),%eax
  802194:	3b 43 04             	cmp    0x4(%ebx),%eax
  802197:	75 2c                	jne    8021c5 <piperead+0x5a>
  802199:	85 f6                	test   %esi,%esi
  80219b:	74 04                	je     8021a1 <piperead+0x36>
  80219d:	89 f0                	mov    %esi,%eax
  80219f:	eb 48                	jmp    8021e9 <piperead+0x7e>
  8021a1:	83 ec 08             	sub    $0x8,%esp
  8021a4:	53                   	push   %ebx
  8021a5:	57                   	push   %edi
  8021a6:	e8 22 ff ff ff       	call   8020cd <_pipeisclosed>
  8021ab:	83 c4 10             	add    $0x10,%esp
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	74 07                	je     8021b9 <piperead+0x4e>
  8021b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b7:	eb 30                	jmp    8021e9 <piperead+0x7e>
  8021b9:	e8 a9 e9 ff ff       	call   800b67 <sys_yield>
  8021be:	8b 03                	mov    (%ebx),%eax
  8021c0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021c3:	74 d4                	je     802199 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021c5:	8b 13                	mov    (%ebx),%edx
  8021c7:	89 d0                	mov    %edx,%eax
  8021c9:	85 d2                	test   %edx,%edx
  8021cb:	79 03                	jns    8021d0 <piperead+0x65>
  8021cd:	8d 42 1f             	lea    0x1f(%edx),%eax
  8021d0:	83 e0 e0             	and    $0xffffffe0,%eax
  8021d3:	29 c2                	sub    %eax,%edx
  8021d5:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  8021d9:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8021dc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8021df:	ff 03                	incl   (%ebx)
  8021e1:	46                   	inc    %esi
  8021e2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021e5:	72 ab                	jb     802192 <piperead+0x27>
	}
	return i;
  8021e7:	89 f0                	mov    %esi,%eax
}
  8021e9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8021ec:	5b                   	pop    %ebx
  8021ed:	5e                   	pop    %esi
  8021ee:	5f                   	pop    %edi
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	57                   	push   %edi
  8021f5:	56                   	push   %esi
  8021f6:	53                   	push   %ebx
  8021f7:	83 ec 18             	sub    $0x18,%esp
  8021fa:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  8021fd:	57                   	push   %edi
  8021fe:	e8 39 f1 ff ff       	call   80133c <fd2data>
  802203:	89 c3                	mov    %eax,%ebx
	if (debug)
  802205:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80220e:	be 00 00 00 00       	mov    $0x0,%esi
  802213:	3b 75 10             	cmp    0x10(%ebp),%esi
  802216:	73 55                	jae    80226d <pipewrite+0x7c>
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
  802218:	8b 03                	mov    (%ebx),%eax
  80221a:	83 c0 20             	add    $0x20,%eax
  80221d:	39 43 04             	cmp    %eax,0x4(%ebx)
  802220:	72 27                	jb     802249 <pipewrite+0x58>
  802222:	83 ec 08             	sub    $0x8,%esp
  802225:	53                   	push   %ebx
  802226:	57                   	push   %edi
  802227:	e8 a1 fe ff ff       	call   8020cd <_pipeisclosed>
  80222c:	83 c4 10             	add    $0x10,%esp
  80222f:	85 c0                	test   %eax,%eax
  802231:	74 07                	je     80223a <pipewrite+0x49>
  802233:	b8 00 00 00 00       	mov    $0x0,%eax
  802238:	eb 35                	jmp    80226f <pipewrite+0x7e>
  80223a:	e8 28 e9 ff ff       	call   800b67 <sys_yield>
  80223f:	8b 03                	mov    (%ebx),%eax
  802241:	83 c0 20             	add    $0x20,%eax
  802244:	39 43 04             	cmp    %eax,0x4(%ebx)
  802247:	73 d9                	jae    802222 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802249:	8b 53 04             	mov    0x4(%ebx),%edx
  80224c:	89 d0                	mov    %edx,%eax
  80224e:	85 d2                	test   %edx,%edx
  802250:	79 03                	jns    802255 <pipewrite+0x64>
  802252:	8d 42 1f             	lea    0x1f(%edx),%eax
  802255:	83 e0 e0             	and    $0xffffffe0,%eax
  802258:	29 c2                	sub    %eax,%edx
  80225a:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  80225d:	8a 04 31             	mov    (%ecx,%esi,1),%al
  802260:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802264:	ff 43 04             	incl   0x4(%ebx)
  802267:	46                   	inc    %esi
  802268:	3b 75 10             	cmp    0x10(%ebp),%esi
  80226b:	72 ab                	jb     802218 <pipewrite+0x27>
	}
	
	return i;
  80226d:	89 f0                	mov    %esi,%eax
}
  80226f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802272:	5b                   	pop    %ebx
  802273:	5e                   	pop    %esi
  802274:	5f                   	pop    %edi
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	56                   	push   %esi
  80227b:	53                   	push   %ebx
  80227c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80227f:	83 ec 0c             	sub    $0xc,%esp
  802282:	ff 75 08             	pushl  0x8(%ebp)
  802285:	e8 b2 f0 ff ff       	call   80133c <fd2data>
  80228a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80228c:	83 c4 08             	add    $0x8,%esp
  80228f:	68 d3 2e 80 00       	push   $0x802ed3
  802294:	53                   	push   %ebx
  802295:	e8 1a e5 ff ff       	call   8007b4 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80229a:	8b 46 04             	mov    0x4(%esi),%eax
  80229d:	2b 06                	sub    (%esi),%eax
  80229f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022a5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022ac:	00 00 00 
	stat->st_dev = &devpipe;
  8022af:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  8022b6:	60 80 00 
	return 0;
}
  8022b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022be:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8022c1:	5b                   	pop    %ebx
  8022c2:	5e                   	pop    %esi
  8022c3:	c9                   	leave  
  8022c4:	c3                   	ret    

008022c5 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	53                   	push   %ebx
  8022c9:	83 ec 0c             	sub    $0xc,%esp
  8022cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022cf:	53                   	push   %ebx
  8022d0:	6a 00                	push   $0x0
  8022d2:	e8 34 e9 ff ff       	call   800c0b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022d7:	89 1c 24             	mov    %ebx,(%esp)
  8022da:	e8 5d f0 ff ff       	call   80133c <fd2data>
  8022df:	83 c4 08             	add    $0x8,%esp
  8022e2:	50                   	push   %eax
  8022e3:	6a 00                	push   $0x0
  8022e5:	e8 21 e9 ff ff       	call   800c0b <sys_page_unmap>
}
  8022ea:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    
	...

008022f0 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022fc:	6a 01                	push   $0x1
  8022fe:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802301:	50                   	push   %eax
  802302:	e8 bd e7 ff ff       	call   800ac4 <sys_cputs>
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <getchar>:

int
getchar(void)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80230f:	6a 01                	push   $0x1
  802311:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802314:	50                   	push   %eax
  802315:	6a 00                	push   $0x0
  802317:	e8 35 f3 ff ff       	call   801651 <read>
	if (r < 0)
  80231c:	83 c4 10             	add    $0x10,%esp
		return r;
  80231f:	89 c2                	mov    %eax,%edx
  802321:	85 c0                	test   %eax,%eax
  802323:	78 0d                	js     802332 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  802325:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  80232a:	85 c0                	test   %eax,%eax
  80232c:	7e 04                	jle    802332 <getchar+0x29>
	return c;
  80232e:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  802332:	89 d0                	mov    %edx,%eax
  802334:	c9                   	leave  
  802335:	c3                   	ret    

00802336 <iscons>:


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
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80233c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80233f:	50                   	push   %eax
  802340:	ff 75 08             	pushl  0x8(%ebp)
  802343:	e8 76 f0 ff ff       	call   8013be <fd_lookup>
  802348:	83 c4 10             	add    $0x10,%esp
		return r;
  80234b:	89 c2                	mov    %eax,%edx
  80234d:	85 c0                	test   %eax,%eax
  80234f:	78 11                	js     802362 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  802351:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  80235c:	0f 94 c0             	sete   %al
  80235f:	0f b6 d0             	movzbl %al,%edx
}
  802362:	89 d0                	mov    %edx,%eax
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <opencons>:

int
opencons(void)
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
  802369:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80236c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80236f:	50                   	push   %eax
  802370:	e8 ef ef ff ff       	call   801364 <fd_alloc>
  802375:	83 c4 10             	add    $0x10,%esp
		return r;
  802378:	89 c2                	mov    %eax,%edx
  80237a:	85 c0                	test   %eax,%eax
  80237c:	78 3c                	js     8023ba <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80237e:	83 ec 04             	sub    $0x4,%esp
  802381:	68 07 04 00 00       	push   $0x407
  802386:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802389:	6a 00                	push   $0x0
  80238b:	e8 f6 e7 ff ff       	call   800b86 <sys_page_alloc>
  802390:	83 c4 10             	add    $0x10,%esp
		return r;
  802393:	89 c2                	mov    %eax,%edx
  802395:	85 c0                	test   %eax,%eax
  802397:	78 21                	js     8023ba <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802399:	a1 60 60 80 00       	mov    0x806060,%eax
  80239e:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  8023a1:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  8023a3:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8023a6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023ad:	83 ec 0c             	sub    $0xc,%esp
  8023b0:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8023b3:	e8 9c ef ff ff       	call   801354 <fd2num>
  8023b8:	89 c2                	mov    %eax,%edx
}
  8023ba:	89 d0                	mov    %edx,%eax
  8023bc:	c9                   	leave  
  8023bd:	c3                   	ret    

008023be <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  8023c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023cd:	74 2a                	je     8023f9 <cons_read+0x3b>
  8023cf:	eb 05                	jmp    8023d6 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8023d1:	e8 91 e7 ff ff       	call   800b67 <sys_yield>
  8023d6:	e8 0d e7 ff ff       	call   800ae8 <sys_cgetc>
  8023db:	89 c2                	mov    %eax,%edx
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	74 f0                	je     8023d1 <cons_read+0x13>
	if (c < 0)
  8023e1:	85 d2                	test   %edx,%edx
  8023e3:	78 14                	js     8023f9 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ea:	83 fa 04             	cmp    $0x4,%edx
  8023ed:	74 0a                	je     8023f9 <cons_read+0x3b>
	*(char*)vbuf = c;
  8023ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f2:	88 10                	mov    %dl,(%eax)
	return 1;
  8023f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	57                   	push   %edi
  8023ff:	56                   	push   %esi
  802400:	53                   	push   %ebx
  802401:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  802407:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80240a:	be 00 00 00 00       	mov    $0x0,%esi
  80240f:	39 fe                	cmp    %edi,%esi
  802411:	73 3d                	jae    802450 <cons_write+0x55>
		m = n - tot;
  802413:	89 fb                	mov    %edi,%ebx
  802415:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  802417:	83 fb 7f             	cmp    $0x7f,%ebx
  80241a:	76 05                	jbe    802421 <cons_write+0x26>
			m = sizeof(buf) - 1;
  80241c:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802421:	83 ec 04             	sub    $0x4,%esp
  802424:	53                   	push   %ebx
  802425:	8b 45 0c             	mov    0xc(%ebp),%eax
  802428:	01 f0                	add    %esi,%eax
  80242a:	50                   	push   %eax
  80242b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802431:	50                   	push   %eax
  802432:	e8 f9 e4 ff ff       	call   800930 <memmove>
		sys_cputs(buf, m);
  802437:	83 c4 08             	add    $0x8,%esp
  80243a:	53                   	push   %ebx
  80243b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802441:	50                   	push   %eax
  802442:	e8 7d e6 ff ff       	call   800ac4 <sys_cputs>
  802447:	83 c4 10             	add    $0x10,%esp
  80244a:	01 de                	add    %ebx,%esi
  80244c:	39 fe                	cmp    %edi,%esi
  80244e:	72 c3                	jb     802413 <cons_write+0x18>
	}
	return tot;
}
  802450:	89 f0                	mov    %esi,%eax
  802452:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802455:	5b                   	pop    %ebx
  802456:	5e                   	pop    %esi
  802457:	5f                   	pop    %edi
  802458:	c9                   	leave  
  802459:	c3                   	ret    

0080245a <cons_close>:

int
cons_close(struct Fd *fd)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80245d:	b8 00 00 00 00       	mov    $0x0,%eax
  802462:	c9                   	leave  
  802463:	c3                   	ret    

00802464 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80246a:	68 df 2e 80 00       	push   $0x802edf
  80246f:	ff 75 0c             	pushl  0xc(%ebp)
  802472:	e8 3d e3 ff ff       	call   8007b4 <strcpy>
	return 0;
}
  802477:	b8 00 00 00 00       	mov    $0x0,%eax
  80247c:	c9                   	leave  
  80247d:	c3                   	ret    
	...

00802480 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	53                   	push   %ebx
  802484:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  802487:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  80248a:	83 3d 84 60 80 00 00 	cmpl   $0x0,0x806084
  802491:	74 16                	je     8024a9 <_panic+0x29>
		cprintf("%s: ", argv0);
  802493:	83 ec 08             	sub    $0x8,%esp
  802496:	ff 35 84 60 80 00    	pushl  0x806084
  80249c:	68 e6 2e 80 00       	push   $0x802ee6
  8024a1:	e8 0a dd ff ff       	call   8001b0 <cprintf>
  8024a6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8024a9:	ff 75 0c             	pushl  0xc(%ebp)
  8024ac:	ff 75 08             	pushl  0x8(%ebp)
  8024af:	ff 35 00 60 80 00    	pushl  0x806000
  8024b5:	68 eb 2e 80 00       	push   $0x802eeb
  8024ba:	e8 f1 dc ff ff       	call   8001b0 <cprintf>
	vcprintf(fmt, ap);
  8024bf:	83 c4 08             	add    $0x8,%esp
  8024c2:	53                   	push   %ebx
  8024c3:	ff 75 10             	pushl  0x10(%ebp)
  8024c6:	e8 94 dc ff ff       	call   80015f <vcprintf>
	cprintf("\n");
  8024cb:	c7 04 24 d1 2e 80 00 	movl   $0x802ed1,(%esp)
  8024d2:	e8 d9 dc ff ff       	call   8001b0 <cprintf>

	// Cause a breakpoint exception
	while (1)
  8024d7:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  8024da:	cc                   	int3   
  8024db:	eb fd                	jmp    8024da <_panic+0x5a>
  8024dd:	00 00                	add    %al,(%eax)
	...

008024e0 <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8024e6:	83 3d 88 60 80 00 00 	cmpl   $0x0,0x806088
  8024ed:	75 68                	jne    802557 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  8024ef:	83 ec 04             	sub    $0x4,%esp
  8024f2:	6a 07                	push   $0x7
  8024f4:	68 00 f0 bf ee       	push   $0xeebff000
  8024f9:	83 ec 04             	sub    $0x4,%esp
  8024fc:	e8 47 e6 ff ff       	call   800b48 <sys_getenvid>
  802501:	89 04 24             	mov    %eax,(%esp)
  802504:	e8 7d e6 ff ff       	call   800b86 <sys_page_alloc>
  802509:	83 c4 10             	add    $0x10,%esp
  80250c:	85 c0                	test   %eax,%eax
  80250e:	79 14                	jns    802524 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 08 2f 80 00       	push   $0x802f08
  802518:	6a 21                	push   $0x21
  80251a:	68 69 2f 80 00       	push   $0x802f69
  80251f:	e8 5c ff ff ff       	call   802480 <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  802524:	83 ec 08             	sub    $0x8,%esp
  802527:	68 64 25 80 00       	push   $0x802564
  80252c:	83 ec 04             	sub    $0x4,%esp
  80252f:	e8 14 e6 ff ff       	call   800b48 <sys_getenvid>
  802534:	89 04 24             	mov    %eax,(%esp)
  802537:	e8 95 e7 ff ff       	call   800cd1 <sys_env_set_pgfault_upcall>
  80253c:	83 c4 10             	add    $0x10,%esp
  80253f:	85 c0                	test   %eax,%eax
  802541:	79 14                	jns    802557 <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  802543:	83 ec 04             	sub    $0x4,%esp
  802546:	68 38 2f 80 00       	push   $0x802f38
  80254b:	6a 24                	push   $0x24
  80254d:	68 69 2f 80 00       	push   $0x802f69
  802552:	e8 29 ff ff ff       	call   802480 <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802557:	8b 45 08             	mov    0x8(%ebp),%eax
  80255a:	a3 88 60 80 00       	mov    %eax,0x806088
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    
  802561:	00 00                	add    %al,(%eax)
	...

00802564 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802564:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802565:	a1 88 60 80 00       	mov    0x806088,%eax
	call *%eax
  80256a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80256c:	83 c4 04             	add    $0x4,%esp
	
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
  80256f:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  802573:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  802577:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  80257a:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  80257d:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  802580:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  802584:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  802587:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  80258b:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  80258c:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  80258f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  802590:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  802591:	c3                   	ret    
	...

00802594 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802594:	55                   	push   %ebp
  802595:	89 e5                	mov    %esp,%ebp
  802597:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80259a:	89 c8                	mov    %ecx,%eax
  80259c:	c1 e8 16             	shr    $0x16,%eax
  80259f:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8025a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8025ab:	a8 01                	test   $0x1,%al
  8025ad:	74 28                	je     8025d7 <pageref+0x43>
	pte = vpt[VPN(v)];
  8025af:	89 c8                	mov    %ecx,%eax
  8025b1:	c1 e8 0c             	shr    $0xc,%eax
  8025b4:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  8025bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c0:	a8 01                	test   $0x1,%al
  8025c2:	74 13                	je     8025d7 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  8025c4:	c1 e8 0c             	shr    $0xc,%eax
  8025c7:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8025ca:	c1 e0 02             	shl    $0x2,%eax
  8025cd:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  8025d4:	0f b7 d0             	movzwl %ax,%edx
}
  8025d7:	89 d0                	mov    %edx,%eax
  8025d9:	c9                   	leave  
  8025da:	c3                   	ret    
	...

008025dc <__udivdi3>:
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	57                   	push   %edi
  8025e0:	56                   	push   %esi
  8025e1:	83 ec 14             	sub    $0x14,%esp
  8025e4:	8b 55 14             	mov    0x14(%ebp),%edx
  8025e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8025ea:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8025ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f0:	85 d2                	test   %edx,%edx
  8025f2:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8025f5:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8025f8:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8025fb:	89 fe                	mov    %edi,%esi
  8025fd:	75 11                	jne    802610 <__udivdi3+0x34>
  8025ff:	39 f8                	cmp    %edi,%eax
  802601:	76 4d                	jbe    802650 <__udivdi3+0x74>
  802603:	89 fa                	mov    %edi,%edx
  802605:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802608:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80260b:	89 c7                	mov    %eax,%edi
  80260d:	eb 09                	jmp    802618 <__udivdi3+0x3c>
  80260f:	90                   	nop    
  802610:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  802613:	76 17                	jbe    80262c <__udivdi3+0x50>
  802615:	31 ff                	xor    %edi,%edi
  802617:	90                   	nop    
  802618:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  80261f:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802622:	83 c4 14             	add    $0x14,%esp
  802625:	5e                   	pop    %esi
  802626:	89 f8                	mov    %edi,%eax
  802628:	5f                   	pop    %edi
  802629:	c9                   	leave  
  80262a:	c3                   	ret    
  80262b:	90                   	nop    
  80262c:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802630:	89 c7                	mov    %eax,%edi
  802632:	83 f7 1f             	xor    $0x1f,%edi
  802635:	75 4d                	jne    802684 <__udivdi3+0xa8>
  802637:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  80263a:	77 0a                	ja     802646 <__udivdi3+0x6a>
  80263c:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80263f:	31 ff                	xor    %edi,%edi
  802641:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802644:	72 d2                	jb     802618 <__udivdi3+0x3c>
  802646:	bf 01 00 00 00       	mov    $0x1,%edi
  80264b:	eb cb                	jmp    802618 <__udivdi3+0x3c>
  80264d:	8d 76 00             	lea    0x0(%esi),%esi
  802650:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	75 0e                	jne    802665 <__udivdi3+0x89>
  802657:	b8 01 00 00 00       	mov    $0x1,%eax
  80265c:	31 c9                	xor    %ecx,%ecx
  80265e:	31 d2                	xor    %edx,%edx
  802660:	f7 f1                	div    %ecx
  802662:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802665:	89 f0                	mov    %esi,%eax
  802667:	31 d2                	xor    %edx,%edx
  802669:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80266c:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80266f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802672:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802675:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802678:	83 c4 14             	add    $0x14,%esp
  80267b:	89 c7                	mov    %eax,%edi
  80267d:	5e                   	pop    %esi
  80267e:	89 f8                	mov    %edi,%eax
  802680:	5f                   	pop    %edi
  802681:	c9                   	leave  
  802682:	c3                   	ret    
  802683:	90                   	nop    
  802684:	b8 20 00 00 00       	mov    $0x20,%eax
  802689:	29 f8                	sub    %edi,%eax
  80268b:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  80268e:	89 f9                	mov    %edi,%ecx
  802690:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802693:	d3 e2                	shl    %cl,%edx
  802695:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802698:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80269b:	d3 e8                	shr    %cl,%eax
  80269d:	09 c2                	or     %eax,%edx
  80269f:	89 f9                	mov    %edi,%ecx
  8026a1:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8026a4:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8026a7:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8026aa:	89 f2                	mov    %esi,%edx
  8026ac:	d3 ea                	shr    %cl,%edx
  8026ae:	89 f9                	mov    %edi,%ecx
  8026b0:	d3 e6                	shl    %cl,%esi
  8026b2:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8026b5:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8026b8:	d3 e8                	shr    %cl,%eax
  8026ba:	09 c6                	or     %eax,%esi
  8026bc:	89 f9                	mov    %edi,%ecx
  8026be:	89 f0                	mov    %esi,%eax
  8026c0:	f7 75 f4             	divl   0xfffffff4(%ebp)
  8026c3:	89 d6                	mov    %edx,%esi
  8026c5:	89 c7                	mov    %eax,%edi
  8026c7:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8026ca:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8026cd:	f7 e7                	mul    %edi
  8026cf:	39 f2                	cmp    %esi,%edx
  8026d1:	77 0f                	ja     8026e2 <__udivdi3+0x106>
  8026d3:	0f 85 3f ff ff ff    	jne    802618 <__udivdi3+0x3c>
  8026d9:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  8026dc:	0f 86 36 ff ff ff    	jbe    802618 <__udivdi3+0x3c>
  8026e2:	4f                   	dec    %edi
  8026e3:	e9 30 ff ff ff       	jmp    802618 <__udivdi3+0x3c>

008026e8 <__umoddi3>:
  8026e8:	55                   	push   %ebp
  8026e9:	89 e5                	mov    %esp,%ebp
  8026eb:	57                   	push   %edi
  8026ec:	56                   	push   %esi
  8026ed:	83 ec 30             	sub    $0x30,%esp
  8026f0:	8b 55 14             	mov    0x14(%ebp),%edx
  8026f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8026f6:	89 d7                	mov    %edx,%edi
  8026f8:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  8026fb:	89 c6                	mov    %eax,%esi
  8026fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802700:	8b 45 08             	mov    0x8(%ebp),%eax
  802703:	85 ff                	test   %edi,%edi
  802705:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  80270c:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802713:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  802716:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802719:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80271c:	75 3e                	jne    80275c <__umoddi3+0x74>
  80271e:	39 d6                	cmp    %edx,%esi
  802720:	0f 86 a2 00 00 00    	jbe    8027c8 <__umoddi3+0xe0>
  802726:	f7 f6                	div    %esi
  802728:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80272b:	85 c9                	test   %ecx,%ecx
  80272d:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802730:	74 1b                	je     80274d <__umoddi3+0x65>
  802732:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802735:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802738:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80273f:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802742:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802745:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802748:	89 10                	mov    %edx,(%eax)
  80274a:	89 48 04             	mov    %ecx,0x4(%eax)
  80274d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802750:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802753:	83 c4 30             	add    $0x30,%esp
  802756:	5e                   	pop    %esi
  802757:	5f                   	pop    %edi
  802758:	c9                   	leave  
  802759:	c3                   	ret    
  80275a:	89 f6                	mov    %esi,%esi
  80275c:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  80275f:	76 1f                	jbe    802780 <__umoddi3+0x98>
  802761:	8b 55 08             	mov    0x8(%ebp),%edx
  802764:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802767:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80276a:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  80276d:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802770:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802773:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  802776:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802779:	83 c4 30             	add    $0x30,%esp
  80277c:	5e                   	pop    %esi
  80277d:	5f                   	pop    %edi
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    
  802780:	0f bd c7             	bsr    %edi,%eax
  802783:	83 f0 1f             	xor    $0x1f,%eax
  802786:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  802789:	75 61                	jne    8027ec <__umoddi3+0x104>
  80278b:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  80278e:	77 05                	ja     802795 <__umoddi3+0xad>
  802790:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  802793:	72 10                	jb     8027a5 <__umoddi3+0xbd>
  802795:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802798:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80279b:	29 f0                	sub    %esi,%eax
  80279d:	19 fa                	sbb    %edi,%edx
  80279f:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8027a2:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8027a5:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8027a8:	85 d2                	test   %edx,%edx
  8027aa:	74 a1                	je     80274d <__umoddi3+0x65>
  8027ac:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8027af:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8027b2:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8027b5:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  8027b8:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8027bb:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8027be:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8027c1:	89 01                	mov    %eax,(%ecx)
  8027c3:	89 51 04             	mov    %edx,0x4(%ecx)
  8027c6:	eb 85                	jmp    80274d <__umoddi3+0x65>
  8027c8:	85 f6                	test   %esi,%esi
  8027ca:	75 0b                	jne    8027d7 <__umoddi3+0xef>
  8027cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d1:	31 d2                	xor    %edx,%edx
  8027d3:	f7 f6                	div    %esi
  8027d5:	89 c6                	mov    %eax,%esi
  8027d7:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8027da:	89 fa                	mov    %edi,%edx
  8027dc:	f7 f6                	div    %esi
  8027de:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8027e1:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8027e4:	f7 f6                	div    %esi
  8027e6:	e9 3d ff ff ff       	jmp    802728 <__umoddi3+0x40>
  8027eb:	90                   	nop    
  8027ec:	b8 20 00 00 00       	mov    $0x20,%eax
  8027f1:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  8027f4:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  8027f7:	89 fa                	mov    %edi,%edx
  8027f9:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8027fc:	d3 e2                	shl    %cl,%edx
  8027fe:	89 f0                	mov    %esi,%eax
  802800:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802803:	d3 e8                	shr    %cl,%eax
  802805:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802808:	d3 e6                	shl    %cl,%esi
  80280a:	89 d7                	mov    %edx,%edi
  80280c:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80280f:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802812:	09 c7                	or     %eax,%edi
  802814:	d3 ea                	shr    %cl,%edx
  802816:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802819:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80281c:	d3 e0                	shl    %cl,%eax
  80281e:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802821:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802824:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802827:	d3 e8                	shr    %cl,%eax
  802829:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  80282c:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80282f:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802832:	f7 f7                	div    %edi
  802834:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802837:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  80283a:	f7 e6                	mul    %esi
  80283c:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  80283f:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  802842:	77 0a                	ja     80284e <__umoddi3+0x166>
  802844:	75 12                	jne    802858 <__umoddi3+0x170>
  802846:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802849:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  80284c:	76 0a                	jbe    802858 <__umoddi3+0x170>
  80284e:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802851:	29 f1                	sub    %esi,%ecx
  802853:	19 fa                	sbb    %edi,%edx
  802855:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802858:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80285b:	85 c0                	test   %eax,%eax
  80285d:	0f 84 ea fe ff ff    	je     80274d <__umoddi3+0x65>
  802863:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802866:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802869:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  80286c:	19 d1                	sbb    %edx,%ecx
  80286e:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  802871:	89 ca                	mov    %ecx,%edx
  802873:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802876:	d3 e2                	shl    %cl,%edx
  802878:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80287b:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80287e:	d3 e8                	shr    %cl,%eax
  802880:	09 c2                	or     %eax,%edx
  802882:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802885:	d3 e8                	shr    %cl,%eax
  802887:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80288a:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80288d:	e9 ad fe ff ff       	jmp    80273f <__umoddi3+0x57>
