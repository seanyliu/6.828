
obj/user/forktree:     file format elf32-i386

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
  80002c:	e8 af 00 00 00       	call   8000e0 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <forkchild>:
void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
  80003f:	8a 5d 0c             	mov    0xc(%ebp),%bl
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  800042:	56                   	push   %esi
  800043:	e8 4c 07 00 00       	call   800794 <strlen>
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	83 f8 02             	cmp    $0x2,%eax
  80004e:	7f 38                	jg     800088 <forkchild+0x54>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	0f be c3             	movsbl %bl,%eax
  800056:	50                   	push   %eax
  800057:	56                   	push   %esi
  800058:	68 c0 28 80 00       	push   $0x8028c0
  80005d:	6a 04                	push   $0x4
  80005f:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800062:	50                   	push   %eax
  800063:	e8 10 06 00 00       	call   800678 <snprintf>
	if (fork() == 0) {
  800068:	83 c4 20             	add    $0x20,%esp
  80006b:	e8 a2 10 00 00       	call   801112 <fork>
  800070:	85 c0                	test   %eax,%eax
  800072:	75 14                	jne    800088 <forkchild+0x54>
		forktree(nxt);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80007a:	50                   	push   %eax
  80007b:	e8 0f 00 00 00       	call   80008f <forktree>
		exit();
  800080:	e8 9f 00 00 00       	call   800124 <exit>
  800085:	83 c4 10             	add    $0x10,%esp
	}
}
  800088:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80008b:	5b                   	pop    %ebx
  80008c:	5e                   	pop    %esi
  80008d:	c9                   	leave  
  80008e:	c3                   	ret    

0080008f <forktree>:

void
forktree(const char *cur)
{
  80008f:	55                   	push   %ebp
  800090:	89 e5                	mov    %esp,%ebp
  800092:	53                   	push   %ebx
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  800099:	53                   	push   %ebx
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	e8 c2 0a 00 00       	call   800b64 <sys_getenvid>
  8000a2:	83 c4 08             	add    $0x8,%esp
  8000a5:	50                   	push   %eax
  8000a6:	68 c5 28 80 00       	push   $0x8028c5
  8000ab:	e8 1c 01 00 00       	call   8001cc <cprintf>

	forkchild(cur, '0');
  8000b0:	83 c4 08             	add    $0x8,%esp
  8000b3:	6a 30                	push   $0x30
  8000b5:	53                   	push   %ebx
  8000b6:	e8 79 ff ff ff       	call   800034 <forkchild>
	forkchild(cur, '1');
  8000bb:	83 c4 08             	add    $0x8,%esp
  8000be:	6a 31                	push   $0x31
  8000c0:	53                   	push   %ebx
  8000c1:	e8 6e ff ff ff       	call   800034 <forkchild>
}
  8000c6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <umain>:

void
umain(void)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d1:	68 d5 28 80 00       	push   $0x8028d5
  8000d6:	e8 b4 ff ff ff       	call   80008f <forktree>
}
  8000db:	c9                   	leave  
  8000dc:	c3                   	ret    
  8000dd:	00 00                	add    %al,(%eax)
	...

008000e0 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	8b 75 08             	mov    0x8(%ebp),%esi
  8000e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  8000eb:	e8 74 0a 00 00       	call   800b64 <sys_getenvid>
  8000f0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f5:	c1 e0 07             	shl    $0x7,%eax
  8000f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000fd:	a3 80 60 80 00       	mov    %eax,0x806080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800102:	85 f6                	test   %esi,%esi
  800104:	7e 07                	jle    80010d <libmain+0x2d>
		binaryname = argv[0];
  800106:	8b 03                	mov    (%ebx),%eax
  800108:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	56                   	push   %esi
  800112:	e8 b4 ff ff ff       	call   8000cb <umain>

	// exit gracefully
	exit();
  800117:	e8 08 00 00 00       	call   800124 <exit>
}
  80011c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80011f:	5b                   	pop    %ebx
  800120:	5e                   	pop    %esi
  800121:	c9                   	leave  
  800122:	c3                   	ret    
	...

00800124 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80012a:	e8 3d 13 00 00       	call   80146c <close_all>
	sys_env_destroy(0);
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	6a 00                	push   $0x0
  800134:	e8 ea 09 00 00       	call   800b23 <sys_env_destroy>
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    
	...

0080013c <putch>:


static void
putch(int ch, struct printbuf *b)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	53                   	push   %ebx
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800146:	8b 03                	mov    (%ebx),%eax
  800148:	8b 55 08             	mov    0x8(%ebp),%edx
  80014b:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  80014f:	40                   	inc    %eax
  800150:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800152:	3d ff 00 00 00       	cmp    $0xff,%eax
  800157:	75 1a                	jne    800173 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	68 ff 00 00 00       	push   $0xff
  800161:	8d 43 08             	lea    0x8(%ebx),%eax
  800164:	50                   	push   %eax
  800165:	e8 76 09 00 00       	call   800ae0 <sys_cputs>
		b->idx = 0;
  80016a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800170:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800173:	ff 43 04             	incl   0x4(%ebx)
}
  800176:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800179:	c9                   	leave  
  80017a:	c3                   	ret    

0080017b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800184:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  80018b:	00 00 00 
	b.cnt = 0;
  80018e:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800195:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800198:	ff 75 0c             	pushl  0xc(%ebp)
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  8001a4:	50                   	push   %eax
  8001a5:	68 3c 01 80 00       	push   $0x80013c
  8001aa:	e8 4f 01 00 00       	call   8002fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001af:	83 c4 08             	add    $0x8,%esp
  8001b2:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  8001b8:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  8001be:	50                   	push   %eax
  8001bf:	e8 1c 09 00 00       	call   800ae0 <sys_cputs>

	return b.cnt;
  8001c4:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  8001ca:	c9                   	leave  
  8001cb:	c3                   	ret    

008001cc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d5:	50                   	push   %eax
  8001d6:	ff 75 08             	pushl  0x8(%ebp)
  8001d9:	e8 9d ff ff ff       	call   80017b <vcprintf>
	va_end(ap);

	return cnt;
}
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

008001e0 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	57                   	push   %edi
  8001e4:	56                   	push   %esi
  8001e5:	53                   	push   %ebx
  8001e6:	83 ec 0c             	sub    $0xc,%esp
  8001e9:	8b 75 10             	mov    0x10(%ebp),%esi
  8001ec:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ef:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8001f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8001fa:	39 fa                	cmp    %edi,%edx
  8001fc:	77 39                	ja     800237 <printnum+0x57>
  8001fe:	72 04                	jb     800204 <printnum+0x24>
  800200:	39 f0                	cmp    %esi,%eax
  800202:	77 33                	ja     800237 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800204:	83 ec 04             	sub    $0x4,%esp
  800207:	ff 75 20             	pushl  0x20(%ebp)
  80020a:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  80020d:	50                   	push   %eax
  80020e:	ff 75 18             	pushl  0x18(%ebp)
  800211:	8b 45 18             	mov    0x18(%ebp),%eax
  800214:	ba 00 00 00 00       	mov    $0x0,%edx
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	57                   	push   %edi
  80021c:	56                   	push   %esi
  80021d:	e8 d6 23 00 00       	call   8025f8 <__udivdi3>
  800222:	83 c4 10             	add    $0x10,%esp
  800225:	52                   	push   %edx
  800226:	50                   	push   %eax
  800227:	ff 75 0c             	pushl  0xc(%ebp)
  80022a:	ff 75 08             	pushl  0x8(%ebp)
  80022d:	e8 ae ff ff ff       	call   8001e0 <printnum>
  800232:	83 c4 20             	add    $0x20,%esp
  800235:	eb 19                	jmp    800250 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800237:	4b                   	dec    %ebx
  800238:	85 db                	test   %ebx,%ebx
  80023a:	7e 14                	jle    800250 <printnum+0x70>
  80023c:	83 ec 08             	sub    $0x8,%esp
  80023f:	ff 75 0c             	pushl  0xc(%ebp)
  800242:	ff 75 20             	pushl  0x20(%ebp)
  800245:	ff 55 08             	call   *0x8(%ebp)
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	4b                   	dec    %ebx
  80024c:	85 db                	test   %ebx,%ebx
  80024e:	7f ec                	jg     80023c <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800250:	83 ec 08             	sub    $0x8,%esp
  800253:	ff 75 0c             	pushl  0xc(%ebp)
  800256:	8b 45 18             	mov    0x18(%ebp),%eax
  800259:	ba 00 00 00 00       	mov    $0x0,%edx
  80025e:	83 ec 04             	sub    $0x4,%esp
  800261:	52                   	push   %edx
  800262:	50                   	push   %eax
  800263:	57                   	push   %edi
  800264:	56                   	push   %esi
  800265:	e8 9a 24 00 00       	call   802704 <__umoddi3>
  80026a:	83 c4 14             	add    $0x14,%esp
  80026d:	0f be 80 e7 29 80 00 	movsbl 0x8029e7(%eax),%eax
  800274:	50                   	push   %eax
  800275:	ff 55 08             	call   *0x8(%ebp)
}
  800278:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80027b:	5b                   	pop    %ebx
  80027c:	5e                   	pop    %esi
  80027d:	5f                   	pop    %edi
  80027e:	c9                   	leave  
  80027f:	c3                   	ret    

00800280 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800286:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800289:	83 f8 01             	cmp    $0x1,%eax
  80028c:	7e 0f                	jle    80029d <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  80028e:	8b 01                	mov    (%ecx),%eax
  800290:	83 c0 08             	add    $0x8,%eax
  800293:	89 01                	mov    %eax,(%ecx)
  800295:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800298:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80029b:	eb 24                	jmp    8002c1 <getuint+0x41>
	else if (lflag)
  80029d:	85 c0                	test   %eax,%eax
  80029f:	74 11                	je     8002b2 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  8002a1:	8b 01                	mov    (%ecx),%eax
  8002a3:	83 c0 04             	add    $0x4,%eax
  8002a6:	89 01                	mov    %eax,(%ecx)
  8002a8:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8002ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8002b0:	eb 0f                	jmp    8002c1 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  8002b2:	8b 01                	mov    (%ecx),%eax
  8002b4:	83 c0 04             	add    $0x4,%eax
  8002b7:	89 01                	mov    %eax,(%ecx)
  8002b9:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8002bc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8002cc:	83 f8 01             	cmp    $0x1,%eax
  8002cf:	7e 0f                	jle    8002e0 <getint+0x1d>
		return va_arg(*ap, long long);
  8002d1:	8b 02                	mov    (%edx),%eax
  8002d3:	83 c0 08             	add    $0x8,%eax
  8002d6:	89 02                	mov    %eax,(%edx)
  8002d8:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8002db:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8002de:	eb 1c                	jmp    8002fc <getint+0x39>
	else if (lflag)
  8002e0:	85 c0                	test   %eax,%eax
  8002e2:	74 0d                	je     8002f1 <getint+0x2e>
		return va_arg(*ap, long);
  8002e4:	8b 02                	mov    (%edx),%eax
  8002e6:	83 c0 04             	add    $0x4,%eax
  8002e9:	89 02                	mov    %eax,(%edx)
  8002eb:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8002ee:	99                   	cltd   
  8002ef:	eb 0b                	jmp    8002fc <getint+0x39>
	else
		return va_arg(*ap, int);
  8002f1:	8b 02                	mov    (%edx),%eax
  8002f3:	83 c0 04             	add    $0x4,%eax
  8002f6:	89 02                	mov    %eax,(%edx)
  8002f8:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8002fb:	99                   	cltd   
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	57                   	push   %edi
  800302:	56                   	push   %esi
  800303:	53                   	push   %ebx
  800304:	83 ec 1c             	sub    $0x1c,%esp
  800307:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  80030a:	0f b6 13             	movzbl (%ebx),%edx
  80030d:	43                   	inc    %ebx
  80030e:	83 fa 25             	cmp    $0x25,%edx
  800311:	74 1e                	je     800331 <vprintfmt+0x33>
  800313:	85 d2                	test   %edx,%edx
  800315:	0f 84 d7 02 00 00    	je     8005f2 <vprintfmt+0x2f4>
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	52                   	push   %edx
  800322:	ff 55 08             	call   *0x8(%ebp)
  800325:	83 c4 10             	add    $0x10,%esp
  800328:	0f b6 13             	movzbl (%ebx),%edx
  80032b:	43                   	inc    %ebx
  80032c:	83 fa 25             	cmp    $0x25,%edx
  80032f:	75 e2                	jne    800313 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  800331:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  800335:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  80033c:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  800341:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  800346:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	0f b6 13             	movzbl (%ebx),%edx
  800350:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  800353:	43                   	inc    %ebx
  800354:	83 f8 55             	cmp    $0x55,%eax
  800357:	0f 87 70 02 00 00    	ja     8005cd <vprintfmt+0x2cf>
  80035d:	ff 24 85 7c 2a 80 00 	jmp    *0x802a7c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800364:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  800368:	eb e3                	jmp    80034d <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80036a:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  80036e:	eb dd                	jmp    80034d <vprintfmt+0x4f>

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
  800370:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800375:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  800378:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  80037c:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80037f:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  800382:	83 f8 09             	cmp    $0x9,%eax
  800385:	77 27                	ja     8003ae <vprintfmt+0xb0>
  800387:	43                   	inc    %ebx
  800388:	eb eb                	jmp    800375 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80038a:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80038e:	8b 45 14             	mov    0x14(%ebp),%eax
  800391:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800394:	eb 18                	jmp    8003ae <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  800396:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80039a:	79 b1                	jns    80034d <vprintfmt+0x4f>
				width = 0;
  80039c:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  8003a3:	eb a8                	jmp    80034d <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  8003a5:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  8003ac:	eb 9f                	jmp    80034d <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  8003ae:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8003b2:	79 99                	jns    80034d <vprintfmt+0x4f>
				width = precision, precision = -1;
  8003b4:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8003b7:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  8003bc:	eb 8f                	jmp    80034d <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003be:	41                   	inc    %ecx
			goto reswitch;
  8003bf:	eb 8c                	jmp    80034d <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003c1:	83 ec 08             	sub    $0x8,%esp
  8003c4:	ff 75 0c             	pushl  0xc(%ebp)
  8003c7:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8003cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ce:	ff 70 fc             	pushl  0xfffffffc(%eax)
  8003d1:	ff 55 08             	call   *0x8(%ebp)
			break;
  8003d4:	83 c4 10             	add    $0x10,%esp
  8003d7:	e9 2e ff ff ff       	jmp    80030a <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003dc:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8003e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e3:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  8003e6:	85 c0                	test   %eax,%eax
  8003e8:	79 02                	jns    8003ec <vprintfmt+0xee>
				err = -err;
  8003ea:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8003ec:	83 f8 0e             	cmp    $0xe,%eax
  8003ef:	7f 0b                	jg     8003fc <vprintfmt+0xfe>
  8003f1:	8b 3c 85 40 2a 80 00 	mov    0x802a40(,%eax,4),%edi
  8003f8:	85 ff                	test   %edi,%edi
  8003fa:	75 19                	jne    800415 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8003fc:	50                   	push   %eax
  8003fd:	68 f8 29 80 00       	push   $0x8029f8
  800402:	ff 75 0c             	pushl  0xc(%ebp)
  800405:	ff 75 08             	pushl  0x8(%ebp)
  800408:	e8 ed 01 00 00       	call   8005fa <printfmt>
  80040d:	83 c4 10             	add    $0x10,%esp
  800410:	e9 f5 fe ff ff       	jmp    80030a <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800415:	57                   	push   %edi
  800416:	68 81 2e 80 00       	push   $0x802e81
  80041b:	ff 75 0c             	pushl  0xc(%ebp)
  80041e:	ff 75 08             	pushl  0x8(%ebp)
  800421:	e8 d4 01 00 00       	call   8005fa <printfmt>
  800426:	83 c4 10             	add    $0x10,%esp
			break;
  800429:	e9 dc fe ff ff       	jmp    80030a <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80042e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  800438:	85 ff                	test   %edi,%edi
  80043a:	75 05                	jne    800441 <vprintfmt+0x143>
				p = "(null)";
  80043c:	bf 01 2a 80 00       	mov    $0x802a01,%edi
			if (width > 0 && padc != '-')
  800441:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800445:	7e 3b                	jle    800482 <vprintfmt+0x184>
  800447:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  80044b:	74 35                	je     800482 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	56                   	push   %esi
  800451:	57                   	push   %edi
  800452:	e8 56 03 00 00       	call   8007ad <strnlen>
  800457:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  80045a:	83 c4 10             	add    $0x10,%esp
  80045d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800461:	7e 1f                	jle    800482 <vprintfmt+0x184>
  800463:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800467:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	ff 75 0c             	pushl  0xc(%ebp)
  800470:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  800473:	ff 55 08             	call   *0x8(%ebp)
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80047c:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800480:	7f e8                	jg     80046a <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800482:	0f be 17             	movsbl (%edi),%edx
  800485:	47                   	inc    %edi
  800486:	85 d2                	test   %edx,%edx
  800488:	74 44                	je     8004ce <vprintfmt+0x1d0>
  80048a:	85 f6                	test   %esi,%esi
  80048c:	78 03                	js     800491 <vprintfmt+0x193>
  80048e:	4e                   	dec    %esi
  80048f:	78 3d                	js     8004ce <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800491:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800495:	74 18                	je     8004af <vprintfmt+0x1b1>
  800497:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80049a:	83 f8 5e             	cmp    $0x5e,%eax
  80049d:	76 10                	jbe    8004af <vprintfmt+0x1b1>
					putch('?', putdat);
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	ff 75 0c             	pushl  0xc(%ebp)
  8004a5:	6a 3f                	push   $0x3f
  8004a7:	ff 55 08             	call   *0x8(%ebp)
  8004aa:	83 c4 10             	add    $0x10,%esp
  8004ad:	eb 0d                	jmp    8004bc <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  8004af:	83 ec 08             	sub    $0x8,%esp
  8004b2:	ff 75 0c             	pushl  0xc(%ebp)
  8004b5:	52                   	push   %edx
  8004b6:	ff 55 08             	call   *0x8(%ebp)
  8004b9:	83 c4 10             	add    $0x10,%esp
  8004bc:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8004bf:	0f be 17             	movsbl (%edi),%edx
  8004c2:	47                   	inc    %edi
  8004c3:	85 d2                	test   %edx,%edx
  8004c5:	74 07                	je     8004ce <vprintfmt+0x1d0>
  8004c7:	85 f6                	test   %esi,%esi
  8004c9:	78 c6                	js     800491 <vprintfmt+0x193>
  8004cb:	4e                   	dec    %esi
  8004cc:	79 c3                	jns    800491 <vprintfmt+0x193>
			for (; width > 0; width--)
  8004ce:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004d2:	0f 8e 32 fe ff ff    	jle    80030a <vprintfmt+0xc>
				putch(' ', putdat);
  8004d8:	83 ec 08             	sub    $0x8,%esp
  8004db:	ff 75 0c             	pushl  0xc(%ebp)
  8004de:	6a 20                	push   $0x20
  8004e0:	ff 55 08             	call   *0x8(%ebp)
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8004e9:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004ed:	7f e9                	jg     8004d8 <vprintfmt+0x1da>
			break;
  8004ef:	e9 16 fe ff ff       	jmp    80030a <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8004f4:	51                   	push   %ecx
  8004f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8004f8:	50                   	push   %eax
  8004f9:	e8 c5 fd ff ff       	call   8002c3 <getint>
  8004fe:	89 c6                	mov    %eax,%esi
  800500:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  800502:	83 c4 08             	add    $0x8,%esp
  800505:	85 d2                	test   %edx,%edx
  800507:	79 15                	jns    80051e <vprintfmt+0x220>
				putch('-', putdat);
  800509:	83 ec 08             	sub    $0x8,%esp
  80050c:	ff 75 0c             	pushl  0xc(%ebp)
  80050f:	6a 2d                	push   $0x2d
  800511:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800514:	f7 de                	neg    %esi
  800516:	83 d7 00             	adc    $0x0,%edi
  800519:	f7 df                	neg    %edi
  80051b:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80051e:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800523:	eb 75                	jmp    80059a <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800525:	51                   	push   %ecx
  800526:	8d 45 14             	lea    0x14(%ebp),%eax
  800529:	50                   	push   %eax
  80052a:	e8 51 fd ff ff       	call   800280 <getuint>
  80052f:	89 c6                	mov    %eax,%esi
  800531:	89 d7                	mov    %edx,%edi
			base = 10;
  800533:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800538:	83 c4 08             	add    $0x8,%esp
  80053b:	eb 5d                	jmp    80059a <vprintfmt+0x29c>

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
  80053d:	51                   	push   %ecx
  80053e:	8d 45 14             	lea    0x14(%ebp),%eax
  800541:	50                   	push   %eax
  800542:	e8 39 fd ff ff       	call   800280 <getuint>
  800547:	89 c6                	mov    %eax,%esi
  800549:	89 d7                	mov    %edx,%edi
			base = 8;
  80054b:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  800550:	83 c4 08             	add    $0x8,%esp
  800553:	eb 45                	jmp    80059a <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	ff 75 0c             	pushl  0xc(%ebp)
  80055b:	6a 30                	push   $0x30
  80055d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800560:	83 c4 08             	add    $0x8,%esp
  800563:	ff 75 0c             	pushl  0xc(%ebp)
  800566:	6a 78                	push   $0x78
  800568:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80056b:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800575:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80057a:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  80057f:	83 c4 10             	add    $0x10,%esp
  800582:	eb 16                	jmp    80059a <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800584:	51                   	push   %ecx
  800585:	8d 45 14             	lea    0x14(%ebp),%eax
  800588:	50                   	push   %eax
  800589:	e8 f2 fc ff ff       	call   800280 <getuint>
  80058e:	89 c6                	mov    %eax,%esi
  800590:	89 d7                	mov    %edx,%edi
			base = 16;
  800592:	ba 10 00 00 00       	mov    $0x10,%edx
  800597:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8005a1:	50                   	push   %eax
  8005a2:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8005a5:	52                   	push   %edx
  8005a6:	57                   	push   %edi
  8005a7:	56                   	push   %esi
  8005a8:	ff 75 0c             	pushl  0xc(%ebp)
  8005ab:	ff 75 08             	pushl  0x8(%ebp)
  8005ae:	e8 2d fc ff ff       	call   8001e0 <printnum>
			break;
  8005b3:	83 c4 20             	add    $0x20,%esp
  8005b6:	e9 4f fd ff ff       	jmp    80030a <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8005bb:	83 ec 08             	sub    $0x8,%esp
  8005be:	ff 75 0c             	pushl  0xc(%ebp)
  8005c1:	52                   	push   %edx
  8005c2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005c5:	83 c4 10             	add    $0x10,%esp
  8005c8:	e9 3d fd ff ff       	jmp    80030a <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8005cd:	83 ec 08             	sub    $0x8,%esp
  8005d0:	ff 75 0c             	pushl  0xc(%ebp)
  8005d3:	6a 25                	push   $0x25
  8005d5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8005d8:	4b                   	dec    %ebx
  8005d9:	83 c4 10             	add    $0x10,%esp
  8005dc:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8005e0:	0f 84 24 fd ff ff    	je     80030a <vprintfmt+0xc>
  8005e6:	4b                   	dec    %ebx
  8005e7:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8005eb:	75 f9                	jne    8005e6 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8005ed:	e9 18 fd ff ff       	jmp    80030a <vprintfmt+0xc>
		}
	}
}
  8005f2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8005f5:	5b                   	pop    %ebx
  8005f6:	5e                   	pop    %esi
  8005f7:	5f                   	pop    %edi
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800600:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800603:	50                   	push   %eax
  800604:	ff 75 10             	pushl  0x10(%ebp)
  800607:	ff 75 0c             	pushl  0xc(%ebp)
  80060a:	ff 75 08             	pushl  0x8(%ebp)
  80060d:	e8 ec fc ff ff       	call   8002fe <vprintfmt>
	va_end(ap);
}
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  80061a:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  80061d:	8b 0a                	mov    (%edx),%ecx
  80061f:	3b 4a 04             	cmp    0x4(%edx),%ecx
  800622:	73 07                	jae    80062b <sprintputch+0x17>
		*b->buf++ = ch;
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	88 01                	mov    %al,(%ecx)
  800629:	ff 02                	incl   (%edx)
}
  80062b:	c9                   	leave  
  80062c:	c3                   	ret    

0080062d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80062d:	55                   	push   %ebp
  80062e:	89 e5                	mov    %esp,%ebp
  800630:	83 ec 18             	sub    $0x18,%esp
  800633:	8b 55 08             	mov    0x8(%ebp),%edx
  800636:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800639:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  80063c:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800640:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  800643:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  80064a:	85 d2                	test   %edx,%edx
  80064c:	74 04                	je     800652 <vsnprintf+0x25>
  80064e:	85 c9                	test   %ecx,%ecx
  800650:	7f 07                	jg     800659 <vsnprintf+0x2c>
		return -E_INVAL;
  800652:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800657:	eb 1d                	jmp    800676 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800659:	ff 75 14             	pushl  0x14(%ebp)
  80065c:	ff 75 10             	pushl  0x10(%ebp)
  80065f:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  800662:	50                   	push   %eax
  800663:	68 14 06 80 00       	push   $0x800614
  800668:	e8 91 fc ff ff       	call   8002fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80066d:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800670:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800673:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  800676:	c9                   	leave  
  800677:	c3                   	ret    

00800678 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80067e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800681:	50                   	push   %eax
  800682:	ff 75 10             	pushl  0x10(%ebp)
  800685:	ff 75 0c             	pushl  0xc(%ebp)
  800688:	ff 75 08             	pushl  0x8(%ebp)
  80068b:	e8 9d ff ff ff       	call   80062d <vsnprintf>
	va_end(ap);

	return rc;
}
  800690:	c9                   	leave  
  800691:	c3                   	ret    
	...

00800694 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800694:	55                   	push   %ebp
  800695:	89 e5                	mov    %esp,%ebp
  800697:	56                   	push   %esi
  800698:	53                   	push   %ebx
  800699:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  80069c:	83 ec 0c             	sub    $0xc,%esp
  80069f:	56                   	push   %esi
  8006a0:	e8 ef 00 00 00       	call   800794 <strlen>
  char letter;
  int hexnum = 0;
  8006a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  8006aa:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  8006af:	83 c4 10             	add    $0x10,%esp
  8006b2:	89 c2                	mov    %eax,%edx
  8006b4:	4a                   	dec    %edx
  8006b5:	0f 88 d0 00 00 00    	js     80078b <strtoint+0xf7>
    letter = string[cidx];
  8006bb:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  8006be:	85 d2                	test   %edx,%edx
  8006c0:	75 12                	jne    8006d4 <strtoint+0x40>
      if (letter != '0') {
  8006c2:	3c 30                	cmp    $0x30,%al
  8006c4:	0f 84 ba 00 00 00    	je     800784 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8006ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8006cf:	e9 b9 00 00 00       	jmp    80078d <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  8006d4:	83 fa 01             	cmp    $0x1,%edx
  8006d7:	75 12                	jne    8006eb <strtoint+0x57>
      if (letter != 'x') {
  8006d9:	3c 78                	cmp    $0x78,%al
  8006db:	0f 84 a3 00 00 00    	je     800784 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8006e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8006e6:	e9 a2 00 00 00       	jmp    80078d <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8006eb:	0f be c0             	movsbl %al,%eax
  8006ee:	83 e8 30             	sub    $0x30,%eax
  8006f1:	83 f8 36             	cmp    $0x36,%eax
  8006f4:	0f 87 80 00 00 00    	ja     80077a <strtoint+0xe6>
  8006fa:	ff 24 85 d4 2b 80 00 	jmp    *0x802bd4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  800701:	01 cb                	add    %ecx,%ebx
          break;
  800703:	eb 7c                	jmp    800781 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800705:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  800708:	eb 77                	jmp    800781 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  80070a:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80070d:	01 c3                	add    %eax,%ebx
          break;
  80070f:	eb 70                	jmp    800781 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  800711:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800714:	eb 6b                	jmp    800781 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  800716:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800719:	01 c3                	add    %eax,%ebx
          break;
  80071b:	eb 64                	jmp    800781 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  80071d:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800720:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800723:	eb 5c                	jmp    800781 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800725:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  80072c:	29 c8                	sub    %ecx,%eax
  80072e:	01 c3                	add    %eax,%ebx
          break;
  800730:	eb 4f                	jmp    800781 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  800732:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  800735:	eb 4a                	jmp    800781 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  800737:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  80073a:	01 c3                	add    %eax,%ebx
          break;
  80073c:	eb 43                	jmp    800781 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  80073e:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800741:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800744:	eb 3b                	jmp    800781 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800746:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800749:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  80074c:	01 c3                	add    %eax,%ebx
          break;
  80074e:	eb 31                	jmp    800781 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800750:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800753:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800756:	eb 29                	jmp    800781 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800758:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80075b:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  80075e:	01 c3                	add    %eax,%ebx
          break;
  800760:	eb 1f                	jmp    800781 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800762:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800769:	29 c8                	sub    %ecx,%eax
  80076b:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  80076e:	eb 11                	jmp    800781 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800770:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800773:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800776:	01 c3                	add    %eax,%ebx
          break;
  800778:	eb 07                	jmp    800781 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  80077a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80077f:	eb 0c                	jmp    80078d <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800781:	c1 e1 04             	shl    $0x4,%ecx
  800784:	4a                   	dec    %edx
  800785:	0f 89 30 ff ff ff    	jns    8006bb <strtoint+0x27>
    }
  }

  return hexnum;
  80078b:	89 d8                	mov    %ebx,%eax
}
  80078d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800790:	5b                   	pop    %ebx
  800791:	5e                   	pop    %esi
  800792:	c9                   	leave  
  800793:	c3                   	ret    

00800794 <strlen>:





int
strlen(const char *s)
{
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80079a:	b8 00 00 00 00       	mov    $0x0,%eax
  80079f:	80 3a 00             	cmpb   $0x0,(%edx)
  8007a2:	74 07                	je     8007ab <strlen+0x17>
		n++;
  8007a4:	40                   	inc    %eax
  8007a5:	42                   	inc    %edx
  8007a6:	80 3a 00             	cmpb   $0x0,(%edx)
  8007a9:	75 f9                	jne    8007a4 <strlen+0x10>
	return n;
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bb:	85 d2                	test   %edx,%edx
  8007bd:	74 0f                	je     8007ce <strnlen+0x21>
  8007bf:	80 39 00             	cmpb   $0x0,(%ecx)
  8007c2:	74 0a                	je     8007ce <strnlen+0x21>
		n++;
  8007c4:	40                   	inc    %eax
  8007c5:	41                   	inc    %ecx
  8007c6:	4a                   	dec    %edx
  8007c7:	74 05                	je     8007ce <strnlen+0x21>
  8007c9:	80 39 00             	cmpb   $0x0,(%ecx)
  8007cc:	75 f6                	jne    8007c4 <strnlen+0x17>
	return n;
}
  8007ce:	c9                   	leave  
  8007cf:	c3                   	ret    

008007d0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	53                   	push   %ebx
  8007d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  8007da:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  8007dc:	8a 02                	mov    (%edx),%al
  8007de:	42                   	inc    %edx
  8007df:	88 01                	mov    %al,(%ecx)
  8007e1:	41                   	inc    %ecx
  8007e2:	84 c0                	test   %al,%al
  8007e4:	75 f6                	jne    8007dc <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007e6:	89 d8                	mov    %ebx,%eax
  8007e8:	5b                   	pop    %ebx
  8007e9:	c9                   	leave  
  8007ea:	c3                   	ret    

008007eb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007eb:	55                   	push   %ebp
  8007ec:	89 e5                	mov    %esp,%ebp
  8007ee:	57                   	push   %edi
  8007ef:	56                   	push   %esi
  8007f0:	53                   	push   %ebx
  8007f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f7:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  8007fa:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  8007fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800801:	39 f3                	cmp    %esi,%ebx
  800803:	73 10                	jae    800815 <strncpy+0x2a>
		*dst++ = *src;
  800805:	8a 02                	mov    (%edx),%al
  800807:	88 01                	mov    %al,(%ecx)
  800809:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80080a:	80 3a 01             	cmpb   $0x1,(%edx)
  80080d:	83 da ff             	sbb    $0xffffffff,%edx
  800810:	43                   	inc    %ebx
  800811:	39 f3                	cmp    %esi,%ebx
  800813:	72 f0                	jb     800805 <strncpy+0x1a>
	}
	return ret;
}
  800815:	89 f8                	mov    %edi,%eax
  800817:	5b                   	pop    %ebx
  800818:	5e                   	pop    %esi
  800819:	5f                   	pop    %edi
  80081a:	c9                   	leave  
  80081b:	c3                   	ret    

0080081c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80081c:	55                   	push   %ebp
  80081d:	89 e5                	mov    %esp,%ebp
  80081f:	56                   	push   %esi
  800820:	53                   	push   %ebx
  800821:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800824:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800827:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  80082a:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  80082c:	85 d2                	test   %edx,%edx
  80082e:	74 19                	je     800849 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800830:	4a                   	dec    %edx
  800831:	74 13                	je     800846 <strlcpy+0x2a>
  800833:	80 39 00             	cmpb   $0x0,(%ecx)
  800836:	74 0e                	je     800846 <strlcpy+0x2a>
  800838:	8a 01                	mov    (%ecx),%al
  80083a:	41                   	inc    %ecx
  80083b:	88 03                	mov    %al,(%ebx)
  80083d:	43                   	inc    %ebx
  80083e:	4a                   	dec    %edx
  80083f:	74 05                	je     800846 <strlcpy+0x2a>
  800841:	80 39 00             	cmpb   $0x0,(%ecx)
  800844:	75 f2                	jne    800838 <strlcpy+0x1c>
		*dst = '\0';
  800846:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800849:	89 d8                	mov    %ebx,%eax
  80084b:	29 f0                	sub    %esi,%eax
}
  80084d:	5b                   	pop    %ebx
  80084e:	5e                   	pop    %esi
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	8b 55 08             	mov    0x8(%ebp),%edx
  800857:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  80085a:	80 3a 00             	cmpb   $0x0,(%edx)
  80085d:	74 13                	je     800872 <strcmp+0x21>
  80085f:	8a 02                	mov    (%edx),%al
  800861:	3a 01                	cmp    (%ecx),%al
  800863:	75 0d                	jne    800872 <strcmp+0x21>
  800865:	42                   	inc    %edx
  800866:	41                   	inc    %ecx
  800867:	80 3a 00             	cmpb   $0x0,(%edx)
  80086a:	74 06                	je     800872 <strcmp+0x21>
  80086c:	8a 02                	mov    (%edx),%al
  80086e:	3a 01                	cmp    (%ecx),%al
  800870:	74 f3                	je     800865 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800872:	0f b6 02             	movzbl (%edx),%eax
  800875:	0f b6 11             	movzbl (%ecx),%edx
  800878:	29 d0                	sub    %edx,%eax
}
  80087a:	c9                   	leave  
  80087b:	c3                   	ret    

0080087c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	53                   	push   %ebx
  800880:	8b 55 08             	mov    0x8(%ebp),%edx
  800883:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800886:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800889:	85 c9                	test   %ecx,%ecx
  80088b:	74 1f                	je     8008ac <strncmp+0x30>
  80088d:	80 3a 00             	cmpb   $0x0,(%edx)
  800890:	74 16                	je     8008a8 <strncmp+0x2c>
  800892:	8a 02                	mov    (%edx),%al
  800894:	3a 03                	cmp    (%ebx),%al
  800896:	75 10                	jne    8008a8 <strncmp+0x2c>
  800898:	42                   	inc    %edx
  800899:	43                   	inc    %ebx
  80089a:	49                   	dec    %ecx
  80089b:	74 0f                	je     8008ac <strncmp+0x30>
  80089d:	80 3a 00             	cmpb   $0x0,(%edx)
  8008a0:	74 06                	je     8008a8 <strncmp+0x2c>
  8008a2:	8a 02                	mov    (%edx),%al
  8008a4:	3a 03                	cmp    (%ebx),%al
  8008a6:	74 f0                	je     800898 <strncmp+0x1c>
	if (n == 0)
  8008a8:	85 c9                	test   %ecx,%ecx
  8008aa:	75 07                	jne    8008b3 <strncmp+0x37>
		return 0;
  8008ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b1:	eb 0a                	jmp    8008bd <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b3:	0f b6 12             	movzbl (%edx),%edx
  8008b6:	0f b6 03             	movzbl (%ebx),%eax
  8008b9:	29 c2                	sub    %eax,%edx
  8008bb:	89 d0                	mov    %edx,%eax
}
  8008bd:	5b                   	pop    %ebx
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8008c9:	80 38 00             	cmpb   $0x0,(%eax)
  8008cc:	74 0a                	je     8008d8 <strchr+0x18>
		if (*s == c)
  8008ce:	38 10                	cmp    %dl,(%eax)
  8008d0:	74 0b                	je     8008dd <strchr+0x1d>
  8008d2:	40                   	inc    %eax
  8008d3:	80 38 00             	cmpb   $0x0,(%eax)
  8008d6:	75 f6                	jne    8008ce <strchr+0xe>
			return (char *) s;
	return 0;
  8008d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008dd:	c9                   	leave  
  8008de:	c3                   	ret    

008008df <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8008e8:	80 38 00             	cmpb   $0x0,(%eax)
  8008eb:	74 0a                	je     8008f7 <strfind+0x18>
		if (*s == c)
  8008ed:	38 10                	cmp    %dl,(%eax)
  8008ef:	74 06                	je     8008f7 <strfind+0x18>
  8008f1:	40                   	inc    %eax
  8008f2:	80 38 00             	cmpb   $0x0,(%eax)
  8008f5:	75 f6                	jne    8008ed <strfind+0xe>
			break;
	return (char *) s;
}
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    

008008f9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	57                   	push   %edi
  8008fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800900:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800903:	89 f8                	mov    %edi,%eax
  800905:	85 c9                	test   %ecx,%ecx
  800907:	74 40                	je     800949 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800909:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80090f:	75 30                	jne    800941 <memset+0x48>
  800911:	f6 c1 03             	test   $0x3,%cl
  800914:	75 2b                	jne    800941 <memset+0x48>
		c &= 0xFF;
  800916:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	c1 e0 18             	shl    $0x18,%eax
  800923:	8b 55 0c             	mov    0xc(%ebp),%edx
  800926:	c1 e2 10             	shl    $0x10,%edx
  800929:	09 d0                	or     %edx,%eax
  80092b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092e:	c1 e2 08             	shl    $0x8,%edx
  800931:	09 d0                	or     %edx,%eax
  800933:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800936:	c1 e9 02             	shr    $0x2,%ecx
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	fc                   	cld    
  80093d:	f3 ab                	repz stos %eax,%es:(%edi)
  80093f:	eb 06                	jmp    800947 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	fc                   	cld    
  800945:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800947:	89 f8                	mov    %edi,%eax
}
  800949:	5f                   	pop    %edi
  80094a:	c9                   	leave  
  80094b:	c3                   	ret    

0080094c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	57                   	push   %edi
  800950:	56                   	push   %esi
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800957:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80095a:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80095c:	39 c6                	cmp    %eax,%esi
  80095e:	73 33                	jae    800993 <memmove+0x47>
  800960:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800963:	39 c2                	cmp    %eax,%edx
  800965:	76 2c                	jbe    800993 <memmove+0x47>
		s += n;
  800967:	89 d6                	mov    %edx,%esi
		d += n;
  800969:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096c:	f6 c2 03             	test   $0x3,%dl
  80096f:	75 1b                	jne    80098c <memmove+0x40>
  800971:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800977:	75 13                	jne    80098c <memmove+0x40>
  800979:	f6 c1 03             	test   $0x3,%cl
  80097c:	75 0e                	jne    80098c <memmove+0x40>
			asm volatile("std; rep movsl\n"
  80097e:	83 ef 04             	sub    $0x4,%edi
  800981:	83 ee 04             	sub    $0x4,%esi
  800984:	c1 e9 02             	shr    $0x2,%ecx
  800987:	fd                   	std    
  800988:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  80098a:	eb 27                	jmp    8009b3 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80098c:	4f                   	dec    %edi
  80098d:	4e                   	dec    %esi
  80098e:	fd                   	std    
  80098f:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800991:	eb 20                	jmp    8009b3 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800993:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800999:	75 15                	jne    8009b0 <memmove+0x64>
  80099b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009a1:	75 0d                	jne    8009b0 <memmove+0x64>
  8009a3:	f6 c1 03             	test   $0x3,%cl
  8009a6:	75 08                	jne    8009b0 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  8009a8:	c1 e9 02             	shr    $0x2,%ecx
  8009ab:	fc                   	cld    
  8009ac:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  8009ae:	eb 03                	jmp    8009b3 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009b0:	fc                   	cld    
  8009b1:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b3:	5e                   	pop    %esi
  8009b4:	5f                   	pop    %edi
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <memcpy>:

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
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009ba:	ff 75 10             	pushl  0x10(%ebp)
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 84 ff ff ff       	call   80094c <memmove>
}
  8009c8:	c9                   	leave  
  8009c9:	c3                   	ret    

008009ca <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  8009ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  8009d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009d4:	8b 55 10             	mov    0x10(%ebp),%edx
  8009d7:	4a                   	dec    %edx
  8009d8:	83 fa ff             	cmp    $0xffffffff,%edx
  8009db:	74 1a                	je     8009f7 <memcmp+0x2d>
  8009dd:	8a 01                	mov    (%ecx),%al
  8009df:	3a 03                	cmp    (%ebx),%al
  8009e1:	74 0c                	je     8009ef <memcmp+0x25>
  8009e3:	0f b6 d0             	movzbl %al,%edx
  8009e6:	0f b6 03             	movzbl (%ebx),%eax
  8009e9:	29 c2                	sub    %eax,%edx
  8009eb:	89 d0                	mov    %edx,%eax
  8009ed:	eb 0d                	jmp    8009fc <memcmp+0x32>
  8009ef:	41                   	inc    %ecx
  8009f0:	43                   	inc    %ebx
  8009f1:	4a                   	dec    %edx
  8009f2:	83 fa ff             	cmp    $0xffffffff,%edx
  8009f5:	75 e6                	jne    8009dd <memcmp+0x13>
	}

	return 0;
  8009f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009fc:	5b                   	pop    %ebx
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a08:	89 c2                	mov    %eax,%edx
  800a0a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a0d:	39 d0                	cmp    %edx,%eax
  800a0f:	73 09                	jae    800a1a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a11:	38 08                	cmp    %cl,(%eax)
  800a13:	74 05                	je     800a1a <memfind+0x1b>
  800a15:	40                   	inc    %eax
  800a16:	39 d0                	cmp    %edx,%eax
  800a18:	72 f7                	jb     800a11 <memfind+0x12>
			break;
	return (void *) s;
}
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

00800a1c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	57                   	push   %edi
  800a20:	56                   	push   %esi
  800a21:	53                   	push   %ebx
  800a22:	8b 55 08             	mov    0x8(%ebp),%edx
  800a25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a28:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800a2b:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800a30:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800a35:	80 3a 20             	cmpb   $0x20,(%edx)
  800a38:	74 05                	je     800a3f <strtol+0x23>
  800a3a:	80 3a 09             	cmpb   $0x9,(%edx)
  800a3d:	75 0b                	jne    800a4a <strtol+0x2e>
  800a3f:	42                   	inc    %edx
  800a40:	80 3a 20             	cmpb   $0x20,(%edx)
  800a43:	74 fa                	je     800a3f <strtol+0x23>
  800a45:	80 3a 09             	cmpb   $0x9,(%edx)
  800a48:	74 f5                	je     800a3f <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800a4a:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800a4d:	75 03                	jne    800a52 <strtol+0x36>
		s++;
  800a4f:	42                   	inc    %edx
  800a50:	eb 0b                	jmp    800a5d <strtol+0x41>
	else if (*s == '-')
  800a52:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800a55:	75 06                	jne    800a5d <strtol+0x41>
		s++, neg = 1;
  800a57:	42                   	inc    %edx
  800a58:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a5d:	85 c9                	test   %ecx,%ecx
  800a5f:	74 05                	je     800a66 <strtol+0x4a>
  800a61:	83 f9 10             	cmp    $0x10,%ecx
  800a64:	75 15                	jne    800a7b <strtol+0x5f>
  800a66:	80 3a 30             	cmpb   $0x30,(%edx)
  800a69:	75 10                	jne    800a7b <strtol+0x5f>
  800a6b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a6f:	75 0a                	jne    800a7b <strtol+0x5f>
		s += 2, base = 16;
  800a71:	83 c2 02             	add    $0x2,%edx
  800a74:	b9 10 00 00 00       	mov    $0x10,%ecx
  800a79:	eb 14                	jmp    800a8f <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800a7b:	85 c9                	test   %ecx,%ecx
  800a7d:	75 10                	jne    800a8f <strtol+0x73>
  800a7f:	80 3a 30             	cmpb   $0x30,(%edx)
  800a82:	75 05                	jne    800a89 <strtol+0x6d>
		s++, base = 8;
  800a84:	42                   	inc    %edx
  800a85:	b1 08                	mov    $0x8,%cl
  800a87:	eb 06                	jmp    800a8f <strtol+0x73>
	else if (base == 0)
  800a89:	85 c9                	test   %ecx,%ecx
  800a8b:	75 02                	jne    800a8f <strtol+0x73>
		base = 10;
  800a8d:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a8f:	8a 02                	mov    (%edx),%al
  800a91:	83 e8 30             	sub    $0x30,%eax
  800a94:	3c 09                	cmp    $0x9,%al
  800a96:	77 08                	ja     800aa0 <strtol+0x84>
			dig = *s - '0';
  800a98:	0f be 02             	movsbl (%edx),%eax
  800a9b:	83 e8 30             	sub    $0x30,%eax
  800a9e:	eb 20                	jmp    800ac0 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800aa0:	8a 02                	mov    (%edx),%al
  800aa2:	83 e8 61             	sub    $0x61,%eax
  800aa5:	3c 19                	cmp    $0x19,%al
  800aa7:	77 08                	ja     800ab1 <strtol+0x95>
			dig = *s - 'a' + 10;
  800aa9:	0f be 02             	movsbl (%edx),%eax
  800aac:	83 e8 57             	sub    $0x57,%eax
  800aaf:	eb 0f                	jmp    800ac0 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800ab1:	8a 02                	mov    (%edx),%al
  800ab3:	83 e8 41             	sub    $0x41,%eax
  800ab6:	3c 19                	cmp    $0x19,%al
  800ab8:	77 12                	ja     800acc <strtol+0xb0>
			dig = *s - 'A' + 10;
  800aba:	0f be 02             	movsbl (%edx),%eax
  800abd:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800ac0:	39 c8                	cmp    %ecx,%eax
  800ac2:	7d 08                	jge    800acc <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800ac4:	42                   	inc    %edx
  800ac5:	0f af d9             	imul   %ecx,%ebx
  800ac8:	01 c3                	add    %eax,%ebx
  800aca:	eb c3                	jmp    800a8f <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800acc:	85 f6                	test   %esi,%esi
  800ace:	74 02                	je     800ad2 <strtol+0xb6>
		*endptr = (char *) s;
  800ad0:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800ad2:	89 d8                	mov    %ebx,%eax
  800ad4:	85 ff                	test   %edi,%edi
  800ad6:	74 02                	je     800ada <strtol+0xbe>
  800ad8:	f7 d8                	neg    %eax
}
  800ada:	5b                   	pop    %ebx
  800adb:	5e                   	pop    %esi
  800adc:	5f                   	pop    %edi
  800add:	c9                   	leave  
  800ade:	c3                   	ret    
	...

00800ae0 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	57                   	push   %edi
  800ae4:	56                   	push   %esi
  800ae5:	53                   	push   %ebx
  800ae6:	83 ec 04             	sub    $0x4,%esp
  800ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aef:	bf 00 00 00 00       	mov    $0x0,%edi
  800af4:	89 f8                	mov    %edi,%eax
  800af6:	89 fb                	mov    %edi,%ebx
  800af8:	89 fe                	mov    %edi,%esi
  800afa:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800afc:	83 c4 04             	add    $0x4,%esp
  800aff:	5b                   	pop    %ebx
  800b00:	5e                   	pop    %esi
  800b01:	5f                   	pop    %edi
  800b02:	c9                   	leave  
  800b03:	c3                   	ret    

00800b04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	57                   	push   %edi
  800b08:	56                   	push   %esi
  800b09:	53                   	push   %ebx
  800b0a:	b8 01 00 00 00       	mov    $0x1,%eax
  800b0f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b14:	89 fa                	mov    %edi,%edx
  800b16:	89 f9                	mov    %edi,%ecx
  800b18:	89 fb                	mov    %edi,%ebx
  800b1a:	89 fe                	mov    %edi,%esi
  800b1c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b1e:	5b                   	pop    %ebx
  800b1f:	5e                   	pop    %esi
  800b20:	5f                   	pop    %edi
  800b21:	c9                   	leave  
  800b22:	c3                   	ret    

00800b23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	83 ec 0c             	sub    $0xc,%esp
  800b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2f:	b8 03 00 00 00       	mov    $0x3,%eax
  800b34:	bf 00 00 00 00       	mov    $0x0,%edi
  800b39:	89 f9                	mov    %edi,%ecx
  800b3b:	89 fb                	mov    %edi,%ebx
  800b3d:	89 fe                	mov    %edi,%esi
  800b3f:	cd 30                	int    $0x30
  800b41:	85 c0                	test   %eax,%eax
  800b43:	7e 17                	jle    800b5c <sys_env_destroy+0x39>
  800b45:	83 ec 0c             	sub    $0xc,%esp
  800b48:	50                   	push   %eax
  800b49:	6a 03                	push   $0x3
  800b4b:	68 b0 2c 80 00       	push   $0x802cb0
  800b50:	6a 23                	push   $0x23
  800b52:	68 cd 2c 80 00       	push   $0x802ccd
  800b57:	e8 84 18 00 00       	call   8023e0 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b5c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5f                   	pop    %edi
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    

00800b64 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	57                   	push   %edi
  800b68:	56                   	push   %esi
  800b69:	53                   	push   %ebx
  800b6a:	b8 02 00 00 00       	mov    $0x2,%eax
  800b6f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b74:	89 fa                	mov    %edi,%edx
  800b76:	89 f9                	mov    %edi,%ecx
  800b78:	89 fb                	mov    %edi,%ebx
  800b7a:	89 fe                	mov    %edi,%esi
  800b7c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b7e:	5b                   	pop    %ebx
  800b7f:	5e                   	pop    %esi
  800b80:	5f                   	pop    %edi
  800b81:	c9                   	leave  
  800b82:	c3                   	ret    

00800b83 <sys_yield>:

void
sys_yield(void)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b8e:	bf 00 00 00 00       	mov    $0x0,%edi
  800b93:	89 fa                	mov    %edi,%edx
  800b95:	89 f9                	mov    %edi,%ecx
  800b97:	89 fb                	mov    %edi,%ebx
  800b99:	89 fe                	mov    %edi,%esi
  800b9b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5f                   	pop    %edi
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	57                   	push   %edi
  800ba6:	56                   	push   %esi
  800ba7:	53                   	push   %ebx
  800ba8:	83 ec 0c             	sub    $0xc,%esp
  800bab:	8b 55 08             	mov    0x8(%ebp),%edx
  800bae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bb4:	b8 04 00 00 00       	mov    $0x4,%eax
  800bb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbe:	89 fe                	mov    %edi,%esi
  800bc0:	cd 30                	int    $0x30
  800bc2:	85 c0                	test   %eax,%eax
  800bc4:	7e 17                	jle    800bdd <sys_page_alloc+0x3b>
  800bc6:	83 ec 0c             	sub    $0xc,%esp
  800bc9:	50                   	push   %eax
  800bca:	6a 04                	push   $0x4
  800bcc:	68 b0 2c 80 00       	push   $0x802cb0
  800bd1:	6a 23                	push   $0x23
  800bd3:	68 cd 2c 80 00       	push   $0x802ccd
  800bd8:	e8 03 18 00 00       	call   8023e0 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bdd:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800be0:	5b                   	pop    %ebx
  800be1:	5e                   	pop    %esi
  800be2:	5f                   	pop    %edi
  800be3:	c9                   	leave  
  800be4:	c3                   	ret    

00800be5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	57                   	push   %edi
  800be9:	56                   	push   %esi
  800bea:	53                   	push   %ebx
  800beb:	83 ec 0c             	sub    $0xc,%esp
  800bee:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bfa:	8b 75 18             	mov    0x18(%ebp),%esi
  800bfd:	b8 05 00 00 00       	mov    $0x5,%eax
  800c02:	cd 30                	int    $0x30
  800c04:	85 c0                	test   %eax,%eax
  800c06:	7e 17                	jle    800c1f <sys_page_map+0x3a>
  800c08:	83 ec 0c             	sub    $0xc,%esp
  800c0b:	50                   	push   %eax
  800c0c:	6a 05                	push   $0x5
  800c0e:	68 b0 2c 80 00       	push   $0x802cb0
  800c13:	6a 23                	push   $0x23
  800c15:	68 cd 2c 80 00       	push   $0x802ccd
  800c1a:	e8 c1 17 00 00       	call   8023e0 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c1f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5f                   	pop    %edi
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
  800c2d:	83 ec 0c             	sub    $0xc,%esp
  800c30:	8b 55 08             	mov    0x8(%ebp),%edx
  800c33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c36:	b8 06 00 00 00       	mov    $0x6,%eax
  800c3b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c40:	89 fb                	mov    %edi,%ebx
  800c42:	89 fe                	mov    %edi,%esi
  800c44:	cd 30                	int    $0x30
  800c46:	85 c0                	test   %eax,%eax
  800c48:	7e 17                	jle    800c61 <sys_page_unmap+0x3a>
  800c4a:	83 ec 0c             	sub    $0xc,%esp
  800c4d:	50                   	push   %eax
  800c4e:	6a 06                	push   $0x6
  800c50:	68 b0 2c 80 00       	push   $0x802cb0
  800c55:	6a 23                	push   $0x23
  800c57:	68 cd 2c 80 00       	push   $0x802ccd
  800c5c:	e8 7f 17 00 00       	call   8023e0 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c61:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	57                   	push   %edi
  800c6d:	56                   	push   %esi
  800c6e:	53                   	push   %ebx
  800c6f:	83 ec 0c             	sub    $0xc,%esp
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	b8 08 00 00 00       	mov    $0x8,%eax
  800c7d:	bf 00 00 00 00       	mov    $0x0,%edi
  800c82:	89 fb                	mov    %edi,%ebx
  800c84:	89 fe                	mov    %edi,%esi
  800c86:	cd 30                	int    $0x30
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	7e 17                	jle    800ca3 <sys_env_set_status+0x3a>
  800c8c:	83 ec 0c             	sub    $0xc,%esp
  800c8f:	50                   	push   %eax
  800c90:	6a 08                	push   $0x8
  800c92:	68 b0 2c 80 00       	push   $0x802cb0
  800c97:	6a 23                	push   $0x23
  800c99:	68 cd 2c 80 00       	push   $0x802ccd
  800c9e:	e8 3d 17 00 00       	call   8023e0 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ca3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 0c             	sub    $0xc,%esp
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cba:	b8 09 00 00 00       	mov    $0x9,%eax
  800cbf:	bf 00 00 00 00       	mov    $0x0,%edi
  800cc4:	89 fb                	mov    %edi,%ebx
  800cc6:	89 fe                	mov    %edi,%esi
  800cc8:	cd 30                	int    $0x30
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	7e 17                	jle    800ce5 <sys_env_set_trapframe+0x3a>
  800cce:	83 ec 0c             	sub    $0xc,%esp
  800cd1:	50                   	push   %eax
  800cd2:	6a 09                	push   $0x9
  800cd4:	68 b0 2c 80 00       	push   $0x802cb0
  800cd9:	6a 23                	push   $0x23
  800cdb:	68 cd 2c 80 00       	push   $0x802ccd
  800ce0:	e8 fb 16 00 00       	call   8023e0 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ce5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ce8:	5b                   	pop    %ebx
  800ce9:	5e                   	pop    %esi
  800cea:	5f                   	pop    %edi
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	57                   	push   %edi
  800cf1:	56                   	push   %esi
  800cf2:	53                   	push   %ebx
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d01:	bf 00 00 00 00       	mov    $0x0,%edi
  800d06:	89 fb                	mov    %edi,%ebx
  800d08:	89 fe                	mov    %edi,%esi
  800d0a:	cd 30                	int    $0x30
  800d0c:	85 c0                	test   %eax,%eax
  800d0e:	7e 17                	jle    800d27 <sys_env_set_pgfault_upcall+0x3a>
  800d10:	83 ec 0c             	sub    $0xc,%esp
  800d13:	50                   	push   %eax
  800d14:	6a 0a                	push   $0xa
  800d16:	68 b0 2c 80 00       	push   $0x802cb0
  800d1b:	6a 23                	push   $0x23
  800d1d:	68 cd 2c 80 00       	push   $0x802ccd
  800d22:	e8 b9 16 00 00       	call   8023e0 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d27:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	c9                   	leave  
  800d2e:	c3                   	ret    

00800d2f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	57                   	push   %edi
  800d33:	56                   	push   %esi
  800d34:	53                   	push   %ebx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d41:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d46:	be 00 00 00 00       	mov    $0x0,%esi
  800d4b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d4d:	5b                   	pop    %ebx
  800d4e:	5e                   	pop    %esi
  800d4f:	5f                   	pop    %edi
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	57                   	push   %edi
  800d56:	56                   	push   %esi
  800d57:	53                   	push   %ebx
  800d58:	83 ec 0c             	sub    $0xc,%esp
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d63:	bf 00 00 00 00       	mov    $0x0,%edi
  800d68:	89 f9                	mov    %edi,%ecx
  800d6a:	89 fb                	mov    %edi,%ebx
  800d6c:	89 fe                	mov    %edi,%esi
  800d6e:	cd 30                	int    $0x30
  800d70:	85 c0                	test   %eax,%eax
  800d72:	7e 17                	jle    800d8b <sys_ipc_recv+0x39>
  800d74:	83 ec 0c             	sub    $0xc,%esp
  800d77:	50                   	push   %eax
  800d78:	6a 0d                	push   $0xd
  800d7a:	68 b0 2c 80 00       	push   $0x802cb0
  800d7f:	6a 23                	push   $0x23
  800d81:	68 cd 2c 80 00       	push   $0x802ccd
  800d86:	e8 55 16 00 00       	call   8023e0 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d8b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da2:	b8 10 00 00 00       	mov    $0x10,%eax
  800da7:	bf 00 00 00 00       	mov    $0x0,%edi
  800dac:	89 fb                	mov    %edi,%ebx
  800dae:	89 fe                	mov    %edi,%esi
  800db0:	cd 30                	int    $0x30
  800db2:	85 c0                	test   %eax,%eax
  800db4:	7e 17                	jle    800dcd <sys_transmit_packet+0x3a>
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	50                   	push   %eax
  800dba:	6a 10                	push   $0x10
  800dbc:	68 b0 2c 80 00       	push   $0x802cb0
  800dc1:	6a 23                	push   $0x23
  800dc3:	68 cd 2c 80 00       	push   $0x802ccd
  800dc8:	e8 13 16 00 00       	call   8023e0 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800dcd:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	c9                   	leave  
  800dd4:	c3                   	ret    

00800dd5 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	57                   	push   %edi
  800dd9:	56                   	push   %esi
  800dda:	53                   	push   %ebx
  800ddb:	83 ec 0c             	sub    $0xc,%esp
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de4:	b8 11 00 00 00       	mov    $0x11,%eax
  800de9:	bf 00 00 00 00       	mov    $0x0,%edi
  800dee:	89 fb                	mov    %edi,%ebx
  800df0:	89 fe                	mov    %edi,%esi
  800df2:	cd 30                	int    $0x30
  800df4:	85 c0                	test   %eax,%eax
  800df6:	7e 17                	jle    800e0f <sys_receive_packet+0x3a>
  800df8:	83 ec 0c             	sub    $0xc,%esp
  800dfb:	50                   	push   %eax
  800dfc:	6a 11                	push   $0x11
  800dfe:	68 b0 2c 80 00       	push   $0x802cb0
  800e03:	6a 23                	push   $0x23
  800e05:	68 cd 2c 80 00       	push   $0x802ccd
  800e0a:	e8 d1 15 00 00       	call   8023e0 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800e0f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	c9                   	leave  
  800e16:	c3                   	ret    

00800e17 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
  800e1d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e22:	bf 00 00 00 00       	mov    $0x0,%edi
  800e27:	89 fa                	mov    %edi,%edx
  800e29:	89 f9                	mov    %edi,%ecx
  800e2b:	89 fb                	mov    %edi,%ebx
  800e2d:	89 fe                	mov    %edi,%esi
  800e2f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	83 ec 0c             	sub    $0xc,%esp
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e47:	bf 00 00 00 00       	mov    $0x0,%edi
  800e4c:	89 f9                	mov    %edi,%ecx
  800e4e:	89 fb                	mov    %edi,%ebx
  800e50:	89 fe                	mov    %edi,%esi
  800e52:	cd 30                	int    $0x30
  800e54:	85 c0                	test   %eax,%eax
  800e56:	7e 17                	jle    800e6f <sys_map_receive_buffers+0x39>
  800e58:	83 ec 0c             	sub    $0xc,%esp
  800e5b:	50                   	push   %eax
  800e5c:	6a 0e                	push   $0xe
  800e5e:	68 b0 2c 80 00       	push   $0x802cb0
  800e63:	6a 23                	push   $0x23
  800e65:	68 cd 2c 80 00       	push   $0x802ccd
  800e6a:	e8 71 15 00 00       	call   8023e0 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800e6f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	57                   	push   %edi
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
  800e7d:	83 ec 0c             	sub    $0xc,%esp
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	b8 12 00 00 00       	mov    $0x12,%eax
  800e88:	bf 00 00 00 00       	mov    $0x0,%edi
  800e8d:	89 f9                	mov    %edi,%ecx
  800e8f:	89 fb                	mov    %edi,%ebx
  800e91:	89 fe                	mov    %edi,%esi
  800e93:	cd 30                	int    $0x30
  800e95:	85 c0                	test   %eax,%eax
  800e97:	7e 17                	jle    800eb0 <sys_receive_packet_zerocopy+0x39>
  800e99:	83 ec 0c             	sub    $0xc,%esp
  800e9c:	50                   	push   %eax
  800e9d:	6a 12                	push   $0x12
  800e9f:	68 b0 2c 80 00       	push   $0x802cb0
  800ea4:	6a 23                	push   $0x23
  800ea6:	68 cd 2c 80 00       	push   $0x802ccd
  800eab:	e8 30 15 00 00       	call   8023e0 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800eb0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
  800ebe:	83 ec 0c             	sub    $0xc,%esp
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec7:	b8 13 00 00 00       	mov    $0x13,%eax
  800ecc:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed1:	89 fb                	mov    %edi,%ebx
  800ed3:	89 fe                	mov    %edi,%esi
  800ed5:	cd 30                	int    $0x30
  800ed7:	85 c0                	test   %eax,%eax
  800ed9:	7e 17                	jle    800ef2 <sys_env_set_priority+0x3a>
  800edb:	83 ec 0c             	sub    $0xc,%esp
  800ede:	50                   	push   %eax
  800edf:	6a 13                	push   $0x13
  800ee1:	68 b0 2c 80 00       	push   $0x802cb0
  800ee6:	6a 23                	push   $0x23
  800ee8:	68 cd 2c 80 00       	push   $0x802ccd
  800eed:	e8 ee 14 00 00       	call   8023e0 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800ef2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    
	...

00800efc <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	53                   	push   %ebx
  800f00:	83 ec 04             	sub    $0x4,%esp
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f06:	8b 18                	mov    (%eax),%ebx
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
  800f08:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f0c:	74 11                	je     800f1f <pgfault+0x23>
  800f0e:	89 d8                	mov    %ebx,%eax
  800f10:	c1 e8 0c             	shr    $0xc,%eax
  800f13:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  800f1a:	f6 c4 08             	test   $0x8,%ah
  800f1d:	75 14                	jne    800f33 <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  800f1f:	83 ec 04             	sub    $0x4,%esp
  800f22:	68 dc 2c 80 00       	push   $0x802cdc
  800f27:	6a 1e                	push   $0x1e
  800f29:	68 30 2d 80 00       	push   $0x802d30
  800f2e:	e8 ad 14 00 00       	call   8023e0 <_panic>
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
  800f33:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  800f39:	83 ec 04             	sub    $0x4,%esp
  800f3c:	6a 07                	push   $0x7
  800f3e:	68 00 f0 7f 00       	push   $0x7ff000
  800f43:	83 ec 04             	sub    $0x4,%esp
  800f46:	e8 19 fc ff ff       	call   800b64 <sys_getenvid>
  800f4b:	89 04 24             	mov    %eax,(%esp)
  800f4e:	e8 4f fc ff ff       	call   800ba2 <sys_page_alloc>
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	85 c0                	test   %eax,%eax
  800f58:	79 12                	jns    800f6c <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  800f5a:	50                   	push   %eax
  800f5b:	68 3b 2d 80 00       	push   $0x802d3b
  800f60:	6a 2d                	push   $0x2d
  800f62:	68 30 2d 80 00       	push   $0x802d30
  800f67:	e8 74 14 00 00       	call   8023e0 <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  800f6c:	83 ec 04             	sub    $0x4,%esp
  800f6f:	68 00 10 00 00       	push   $0x1000
  800f74:	53                   	push   %ebx
  800f75:	68 00 f0 7f 00       	push   $0x7ff000
  800f7a:	e8 cd f9 ff ff       	call   80094c <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  800f7f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f86:	53                   	push   %ebx
  800f87:	83 ec 0c             	sub    $0xc,%esp
  800f8a:	e8 d5 fb ff ff       	call   800b64 <sys_getenvid>
  800f8f:	83 c4 0c             	add    $0xc,%esp
  800f92:	50                   	push   %eax
  800f93:	68 00 f0 7f 00       	push   $0x7ff000
  800f98:	83 ec 04             	sub    $0x4,%esp
  800f9b:	e8 c4 fb ff ff       	call   800b64 <sys_getenvid>
  800fa0:	89 04 24             	mov    %eax,(%esp)
  800fa3:	e8 3d fc ff ff       	call   800be5 <sys_page_map>
  800fa8:	83 c4 20             	add    $0x20,%esp
  800fab:	85 c0                	test   %eax,%eax
  800fad:	79 12                	jns    800fc1 <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  800faf:	50                   	push   %eax
  800fb0:	68 56 2d 80 00       	push   $0x802d56
  800fb5:	6a 33                	push   $0x33
  800fb7:	68 30 2d 80 00       	push   $0x802d30
  800fbc:	e8 1f 14 00 00       	call   8023e0 <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  800fc1:	83 ec 08             	sub    $0x8,%esp
  800fc4:	68 00 f0 7f 00       	push   $0x7ff000
  800fc9:	83 ec 04             	sub    $0x4,%esp
  800fcc:	e8 93 fb ff ff       	call   800b64 <sys_getenvid>
  800fd1:	89 04 24             	mov    %eax,(%esp)
  800fd4:	e8 4e fc ff ff       	call   800c27 <sys_page_unmap>
  800fd9:	83 c4 10             	add    $0x10,%esp
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	79 12                	jns    800ff2 <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  800fe0:	50                   	push   %eax
  800fe1:	68 6f 2d 80 00       	push   $0x802d6f
  800fe6:	6a 36                	push   $0x36
  800fe8:	68 30 2d 80 00       	push   $0x802d30
  800fed:	e8 ee 13 00 00       	call   8023e0 <_panic>
        }

	//panic("pgfault not implemented");
}
  800ff2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800ff5:	c9                   	leave  
  800ff6:	c3                   	ret    

00800ff7 <duppage>:

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
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	53                   	push   %ebx
  800ffb:	83 ec 04             	sub    $0x4,%esp
  800ffe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801001:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  801004:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  801009:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  80100c:	f6 c4 04             	test   $0x4,%ah
  80100f:	74 36                	je     801047 <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  801011:	83 ec 0c             	sub    $0xc,%esp
  801014:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801017:	25 07 0e 00 00       	and    $0xe07,%eax
  80101c:	50                   	push   %eax
  80101d:	89 d8                	mov    %ebx,%eax
  80101f:	c1 e0 0c             	shl    $0xc,%eax
  801022:	50                   	push   %eax
  801023:	51                   	push   %ecx
  801024:	50                   	push   %eax
  801025:	83 ec 04             	sub    $0x4,%esp
  801028:	e8 37 fb ff ff       	call   800b64 <sys_getenvid>
  80102d:	89 04 24             	mov    %eax,(%esp)
  801030:	e8 b0 fb ff ff       	call   800be5 <sys_page_map>
  801035:	83 c4 20             	add    $0x20,%esp
            return r;
  801038:	89 c2                	mov    %eax,%edx
  80103a:	85 c0                	test   %eax,%eax
  80103c:	0f 88 c9 00 00 00    	js     80110b <duppage+0x114>
  801042:	e9 bf 00 00 00       	jmp    801106 <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  801047:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  80104e:	a9 02 08 00 00       	test   $0x802,%eax
  801053:	74 7b                	je     8010d0 <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801055:	83 ec 0c             	sub    $0xc,%esp
  801058:	68 05 08 00 00       	push   $0x805
  80105d:	89 d8                	mov    %ebx,%eax
  80105f:	c1 e0 0c             	shl    $0xc,%eax
  801062:	50                   	push   %eax
  801063:	51                   	push   %ecx
  801064:	50                   	push   %eax
  801065:	83 ec 04             	sub    $0x4,%esp
  801068:	e8 f7 fa ff ff       	call   800b64 <sys_getenvid>
  80106d:	89 04 24             	mov    %eax,(%esp)
  801070:	e8 70 fb ff ff       	call   800be5 <sys_page_map>
  801075:	83 c4 20             	add    $0x20,%esp
  801078:	85 c0                	test   %eax,%eax
  80107a:	79 12                	jns    80108e <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  80107c:	50                   	push   %eax
  80107d:	68 8a 2d 80 00       	push   $0x802d8a
  801082:	6a 56                	push   $0x56
  801084:	68 30 2d 80 00       	push   $0x802d30
  801089:	e8 52 13 00 00       	call   8023e0 <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  80108e:	83 ec 0c             	sub    $0xc,%esp
  801091:	68 05 08 00 00       	push   $0x805
  801096:	c1 e3 0c             	shl    $0xc,%ebx
  801099:	53                   	push   %ebx
  80109a:	83 ec 0c             	sub    $0xc,%esp
  80109d:	e8 c2 fa ff ff       	call   800b64 <sys_getenvid>
  8010a2:	83 c4 0c             	add    $0xc,%esp
  8010a5:	50                   	push   %eax
  8010a6:	53                   	push   %ebx
  8010a7:	83 ec 04             	sub    $0x4,%esp
  8010aa:	e8 b5 fa ff ff       	call   800b64 <sys_getenvid>
  8010af:	89 04 24             	mov    %eax,(%esp)
  8010b2:	e8 2e fb ff ff       	call   800be5 <sys_page_map>
  8010b7:	83 c4 20             	add    $0x20,%esp
  8010ba:	85 c0                	test   %eax,%eax
  8010bc:	79 48                	jns    801106 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  8010be:	50                   	push   %eax
  8010bf:	68 8a 2d 80 00       	push   $0x802d8a
  8010c4:	6a 5b                	push   $0x5b
  8010c6:	68 30 2d 80 00       	push   $0x802d30
  8010cb:	e8 10 13 00 00       	call   8023e0 <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  8010d0:	83 ec 0c             	sub    $0xc,%esp
  8010d3:	6a 05                	push   $0x5
  8010d5:	89 d8                	mov    %ebx,%eax
  8010d7:	c1 e0 0c             	shl    $0xc,%eax
  8010da:	50                   	push   %eax
  8010db:	51                   	push   %ecx
  8010dc:	50                   	push   %eax
  8010dd:	83 ec 04             	sub    $0x4,%esp
  8010e0:	e8 7f fa ff ff       	call   800b64 <sys_getenvid>
  8010e5:	89 04 24             	mov    %eax,(%esp)
  8010e8:	e8 f8 fa ff ff       	call   800be5 <sys_page_map>
  8010ed:	83 c4 20             	add    $0x20,%esp
  8010f0:	85 c0                	test   %eax,%eax
  8010f2:	79 12                	jns    801106 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  8010f4:	50                   	push   %eax
  8010f5:	68 8a 2d 80 00       	push   $0x802d8a
  8010fa:	6a 5f                	push   $0x5f
  8010fc:	68 30 2d 80 00       	push   $0x802d30
  801101:	e8 da 12 00 00       	call   8023e0 <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  801106:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80110b:	89 d0                	mov    %edx,%eax
  80110d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <fork>:

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
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	57                   	push   %edi
  801116:	56                   	push   %esi
  801117:	53                   	push   %ebx
  801118:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  80111b:	68 fc 0e 80 00       	push   $0x800efc
  801120:	e8 1b 13 00 00       	call   802440 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  801125:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  801128:	ba 07 00 00 00       	mov    $0x7,%edx
  80112d:	89 d0                	mov    %edx,%eax
  80112f:	cd 30                	int    $0x30
  801131:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  801134:	85 c0                	test   %eax,%eax
  801136:	79 15                	jns    80114d <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  801138:	50                   	push   %eax
  801139:	68 10 2d 80 00       	push   $0x802d10
  80113e:	68 85 00 00 00       	push   $0x85
  801143:	68 30 2d 80 00       	push   $0x802d30
  801148:	e8 93 12 00 00       	call   8023e0 <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  80114d:	bf 00 00 00 00       	mov    $0x0,%edi
  801152:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801156:	75 21                	jne    801179 <fork+0x67>
  801158:	e8 07 fa ff ff       	call   800b64 <sys_getenvid>
  80115d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801162:	c1 e0 07             	shl    $0x7,%eax
  801165:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80116a:	a3 80 60 80 00       	mov    %eax,0x806080
  80116f:	ba 00 00 00 00       	mov    $0x0,%edx
  801174:	e9 fd 00 00 00       	jmp    801276 <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  801179:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  801180:	a8 01                	test   $0x1,%al
  801182:	74 5f                	je     8011e3 <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  801184:	bb 00 00 00 00       	mov    $0x0,%ebx
  801189:	89 f8                	mov    %edi,%eax
  80118b:	c1 e0 0a             	shl    $0xa,%eax
  80118e:	89 c2                	mov    %eax,%edx
  801190:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801195:	77 4c                	ja     8011e3 <fork+0xd1>
  801197:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  801199:	01 da                	add    %ebx,%edx
  80119b:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8011a2:	a8 01                	test   $0x1,%al
  8011a4:	74 28                	je     8011ce <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	52                   	push   %edx
  8011aa:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8011ad:	e8 45 fe ff ff       	call   800ff7 <duppage>
  8011b2:	83 c4 10             	add    $0x10,%esp
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	79 15                	jns    8011ce <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  8011b9:	50                   	push   %eax
  8011ba:	68 a3 2d 80 00       	push   $0x802da3
  8011bf:	68 95 00 00 00       	push   $0x95
  8011c4:	68 30 2d 80 00       	push   $0x802d30
  8011c9:	e8 12 12 00 00       	call   8023e0 <_panic>
  8011ce:	43                   	inc    %ebx
  8011cf:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  8011d5:	7f 0c                	jg     8011e3 <fork+0xd1>
  8011d7:	89 f2                	mov    %esi,%edx
  8011d9:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8011dc:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  8011e1:	76 b6                	jbe    801199 <fork+0x87>
  8011e3:	47                   	inc    %edi
  8011e4:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  8011ea:	76 8d                	jbe    801179 <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8011ec:	83 ec 04             	sub    $0x4,%esp
  8011ef:	6a 07                	push   $0x7
  8011f1:	68 00 f0 bf ee       	push   $0xeebff000
  8011f6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8011f9:	e8 a4 f9 ff ff       	call   800ba2 <sys_page_alloc>
  8011fe:	83 c4 10             	add    $0x10,%esp
  801201:	85 c0                	test   %eax,%eax
  801203:	79 15                	jns    80121a <fork+0x108>
          panic("fork: %d", r);
  801205:	50                   	push   %eax
  801206:	68 bc 2d 80 00       	push   $0x802dbc
  80120b:	68 9d 00 00 00       	push   $0x9d
  801210:	68 30 2d 80 00       	push   $0x802d30
  801215:	e8 c6 11 00 00       	call   8023e0 <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  80121a:	83 ec 08             	sub    $0x8,%esp
  80121d:	a1 80 60 80 00       	mov    0x806080,%eax
  801222:	8b 40 64             	mov    0x64(%eax),%eax
  801225:	50                   	push   %eax
  801226:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801229:	e8 bf fa ff ff       	call   800ced <sys_env_set_pgfault_upcall>
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	85 c0                	test   %eax,%eax
  801233:	79 15                	jns    80124a <fork+0x138>
          panic("fork: %d", r);
  801235:	50                   	push   %eax
  801236:	68 bc 2d 80 00       	push   $0x802dbc
  80123b:	68 a2 00 00 00       	push   $0xa2
  801240:	68 30 2d 80 00       	push   $0x802d30
  801245:	e8 96 11 00 00       	call   8023e0 <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  80124a:	83 ec 08             	sub    $0x8,%esp
  80124d:	6a 01                	push   $0x1
  80124f:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801252:	e8 12 fa ff ff       	call   800c69 <sys_env_set_status>
  801257:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  80125a:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80125d:	85 c0                	test   %eax,%eax
  80125f:	79 15                	jns    801276 <fork+0x164>
  801261:	50                   	push   %eax
  801262:	68 bc 2d 80 00       	push   $0x802dbc
  801267:	68 a7 00 00 00       	push   $0xa7
  80126c:	68 30 2d 80 00       	push   $0x802d30
  801271:	e8 6a 11 00 00       	call   8023e0 <_panic>
 
	//panic("fork not implemented");
}
  801276:	89 d0                	mov    %edx,%eax
  801278:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5e                   	pop    %esi
  80127d:	5f                   	pop    %edi
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <sfork>:



// Challenge!
int
sfork(void)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801286:	68 c5 2d 80 00       	push   $0x802dc5
  80128b:	68 b5 00 00 00       	push   $0xb5
  801290:	68 30 2d 80 00       	push   $0x802d30
  801295:	e8 46 11 00 00       	call   8023e0 <_panic>
	...

0080129c <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8012a2:	ff 75 08             	pushl  0x8(%ebp)
  8012a5:	e8 0a 00 00 00       	call   8012b4 <fd2num>
  8012aa:	c1 e0 16             	shl    $0x16,%eax
  8012ad:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <fd2num>:

int
fd2num(struct Fd *fd)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	05 00 00 40 30       	add    $0x30400000,%eax
  8012bf:	c1 e8 0c             	shr    $0xc,%eax
}
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    

008012c4 <fd_alloc>:

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
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	57                   	push   %edi
  8012c8:	56                   	push   %esi
  8012c9:	53                   	push   %ebx
  8012ca:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8012cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012d2:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  8012d7:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  8012dc:	89 c8                	mov    %ecx,%eax
  8012de:	c1 e0 0c             	shl    $0xc,%eax
  8012e1:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8012e7:	89 d0                	mov    %edx,%eax
  8012e9:	c1 e8 16             	shr    $0x16,%eax
  8012ec:	8b 04 86             	mov    (%esi,%eax,4),%eax
  8012ef:	a8 01                	test   $0x1,%al
  8012f1:	74 0c                	je     8012ff <fd_alloc+0x3b>
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	c1 e8 0c             	shr    $0xc,%eax
  8012f8:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  8012fb:	a8 01                	test   $0x1,%al
  8012fd:	75 09                	jne    801308 <fd_alloc+0x44>
			*fd_store = fd;
  8012ff:	89 17                	mov    %edx,(%edi)
			return 0;
  801301:	b8 00 00 00 00       	mov    $0x0,%eax
  801306:	eb 11                	jmp    801319 <fd_alloc+0x55>
  801308:	41                   	inc    %ecx
  801309:	83 f9 1f             	cmp    $0x1f,%ecx
  80130c:	7e ce                	jle    8012dc <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80130e:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801314:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801319:	5b                   	pop    %ebx
  80131a:	5e                   	pop    %esi
  80131b:	5f                   	pop    %edi
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801324:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801329:	83 f8 1f             	cmp    $0x1f,%eax
  80132c:	77 3a                	ja     801368 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80132e:	c1 e0 0c             	shl    $0xc,%eax
  801331:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801337:	89 d0                	mov    %edx,%eax
  801339:	c1 e8 16             	shr    $0x16,%eax
  80133c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801343:	a8 01                	test   $0x1,%al
  801345:	74 10                	je     801357 <fd_lookup+0x39>
  801347:	89 d0                	mov    %edx,%eax
  801349:	c1 e8 0c             	shr    $0xc,%eax
  80134c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801353:	a8 01                	test   $0x1,%al
  801355:	75 07                	jne    80135e <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801357:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80135c:	eb 0a                	jmp    801368 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	89 10                	mov    %edx,(%eax)
	return 0;
  801363:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801368:	89 d0                	mov    %edx,%eax
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <fd_close>:

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
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	56                   	push   %esi
  801370:	53                   	push   %ebx
  801371:	83 ec 10             	sub    $0x10,%esp
  801374:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801377:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80137a:	50                   	push   %eax
  80137b:	56                   	push   %esi
  80137c:	e8 33 ff ff ff       	call   8012b4 <fd2num>
  801381:	89 04 24             	mov    %eax,(%esp)
  801384:	e8 95 ff ff ff       	call   80131e <fd_lookup>
  801389:	89 c3                	mov    %eax,%ebx
  80138b:	83 c4 08             	add    $0x8,%esp
  80138e:	85 c0                	test   %eax,%eax
  801390:	78 05                	js     801397 <fd_close+0x2b>
  801392:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  801395:	74 0f                	je     8013a6 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801397:	89 d8                	mov    %ebx,%eax
  801399:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80139d:	75 3a                	jne    8013d9 <fd_close+0x6d>
  80139f:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a4:	eb 33                	jmp    8013d9 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8013a6:	83 ec 08             	sub    $0x8,%esp
  8013a9:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8013ac:	50                   	push   %eax
  8013ad:	ff 36                	pushl  (%esi)
  8013af:	e8 2c 00 00 00       	call   8013e0 <dev_lookup>
  8013b4:	89 c3                	mov    %eax,%ebx
  8013b6:	83 c4 10             	add    $0x10,%esp
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	78 0f                	js     8013cc <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8013bd:	83 ec 0c             	sub    $0xc,%esp
  8013c0:	56                   	push   %esi
  8013c1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8013c4:	ff 50 10             	call   *0x10(%eax)
  8013c7:	89 c3                	mov    %eax,%ebx
  8013c9:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8013cc:	83 ec 08             	sub    $0x8,%esp
  8013cf:	56                   	push   %esi
  8013d0:	6a 00                	push   $0x0
  8013d2:	e8 50 f8 ff ff       	call   800c27 <sys_page_unmap>
	return r;
  8013d7:	89 d8                	mov    %ebx,%eax
}
  8013d9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8013dc:	5b                   	pop    %ebx
  8013dd:	5e                   	pop    %esi
  8013de:	c9                   	leave  
  8013df:	c3                   	ret    

008013e0 <dev_lookup>:


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
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	56                   	push   %esi
  8013e4:	53                   	push   %ebx
  8013e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8013e8:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  8013eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f0:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  8013f7:	74 1c                	je     801415 <dev_lookup+0x35>
  8013f9:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  8013fe:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  801401:	39 18                	cmp    %ebx,(%eax)
  801403:	75 09                	jne    80140e <dev_lookup+0x2e>
			*dev = devtab[i];
  801405:	89 06                	mov    %eax,(%esi)
			return 0;
  801407:	b8 00 00 00 00       	mov    $0x0,%eax
  80140c:	eb 29                	jmp    801437 <dev_lookup+0x57>
  80140e:	42                   	inc    %edx
  80140f:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  801413:	75 e9                	jne    8013fe <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801415:	83 ec 04             	sub    $0x4,%esp
  801418:	53                   	push   %ebx
  801419:	a1 80 60 80 00       	mov    0x806080,%eax
  80141e:	8b 40 4c             	mov    0x4c(%eax),%eax
  801421:	50                   	push   %eax
  801422:	68 dc 2d 80 00       	push   $0x802ddc
  801427:	e8 a0 ed ff ff       	call   8001cc <cprintf>
	*dev = 0;
  80142c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  801432:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801437:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80143a:	5b                   	pop    %ebx
  80143b:	5e                   	pop    %esi
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <close>:

int
close(int fdnum)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801444:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801447:	50                   	push   %eax
  801448:	ff 75 08             	pushl  0x8(%ebp)
  80144b:	e8 ce fe ff ff       	call   80131e <fd_lookup>
  801450:	83 c4 08             	add    $0x8,%esp
		return r;
  801453:	89 c2                	mov    %eax,%edx
  801455:	85 c0                	test   %eax,%eax
  801457:	78 0f                	js     801468 <close+0x2a>
	else
		return fd_close(fd, 1);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	6a 01                	push   $0x1
  80145e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801461:	e8 06 ff ff ff       	call   80136c <fd_close>
  801466:	89 c2                	mov    %eax,%edx
}
  801468:	89 d0                	mov    %edx,%eax
  80146a:	c9                   	leave  
  80146b:	c3                   	ret    

0080146c <close_all>:

void
close_all(void)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	53                   	push   %ebx
  801470:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801473:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	53                   	push   %ebx
  80147c:	e8 bd ff ff ff       	call   80143e <close>
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	43                   	inc    %ebx
  801485:	83 fb 1f             	cmp    $0x1f,%ebx
  801488:	7e ee                	jle    801478 <close_all+0xc>
}
  80148a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	57                   	push   %edi
  801493:	56                   	push   %esi
  801494:	53                   	push   %ebx
  801495:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801498:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80149b:	50                   	push   %eax
  80149c:	ff 75 08             	pushl  0x8(%ebp)
  80149f:	e8 7a fe ff ff       	call   80131e <fd_lookup>
  8014a4:	89 c6                	mov    %eax,%esi
  8014a6:	83 c4 08             	add    $0x8,%esp
  8014a9:	85 f6                	test   %esi,%esi
  8014ab:	0f 88 f8 00 00 00    	js     8015a9 <dup+0x11a>
		return r;
	close(newfdnum);
  8014b1:	83 ec 0c             	sub    $0xc,%esp
  8014b4:	ff 75 0c             	pushl  0xc(%ebp)
  8014b7:	e8 82 ff ff ff       	call   80143e <close>

	newfd = INDEX2FD(newfdnum);
  8014bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014bf:	c1 e0 0c             	shl    $0xc,%eax
  8014c2:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8014c7:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8014ca:	83 c4 04             	add    $0x4,%esp
  8014cd:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8014d0:	e8 c7 fd ff ff       	call   80129c <fd2data>
  8014d5:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8014d7:	83 c4 04             	add    $0x4,%esp
  8014da:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8014dd:	e8 ba fd ff ff       	call   80129c <fd2data>
  8014e2:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  8014e5:	89 f8                	mov    %edi,%eax
  8014e7:	c1 e8 16             	shr    $0x16,%eax
  8014ea:	83 c4 10             	add    $0x10,%esp
  8014ed:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	74 48                	je     801540 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8014f8:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  8014fd:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  801500:	89 d0                	mov    %edx,%eax
  801502:	c1 e8 0c             	shr    $0xc,%eax
  801505:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  80150c:	a8 01                	test   $0x1,%al
  80150e:	74 22                	je     801532 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801510:	83 ec 0c             	sub    $0xc,%esp
  801513:	25 07 0e 00 00       	and    $0xe07,%eax
  801518:	50                   	push   %eax
  801519:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80151c:	01 d8                	add    %ebx,%eax
  80151e:	50                   	push   %eax
  80151f:	6a 00                	push   $0x0
  801521:	52                   	push   %edx
  801522:	6a 00                	push   $0x0
  801524:	e8 bc f6 ff ff       	call   800be5 <sys_page_map>
  801529:	89 c6                	mov    %eax,%esi
  80152b:	83 c4 20             	add    $0x20,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 3f                	js     801571 <dup+0xe2>
  801532:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801538:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80153e:	7e bd                	jle    8014fd <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801540:	83 ec 0c             	sub    $0xc,%esp
  801543:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801546:	89 d0                	mov    %edx,%eax
  801548:	c1 e8 0c             	shr    $0xc,%eax
  80154b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801552:	25 07 0e 00 00       	and    $0xe07,%eax
  801557:	50                   	push   %eax
  801558:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80155b:	6a 00                	push   $0x0
  80155d:	52                   	push   %edx
  80155e:	6a 00                	push   $0x0
  801560:	e8 80 f6 ff ff       	call   800be5 <sys_page_map>
  801565:	89 c6                	mov    %eax,%esi
  801567:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	85 f6                	test   %esi,%esi
  80156f:	79 38                	jns    8015a9 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801571:	83 ec 08             	sub    $0x8,%esp
  801574:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801577:	6a 00                	push   $0x0
  801579:	e8 a9 f6 ff ff       	call   800c27 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80157e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801583:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  801586:	83 ec 08             	sub    $0x8,%esp
  801589:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80158c:	01 d8                	add    %ebx,%eax
  80158e:	50                   	push   %eax
  80158f:	6a 00                	push   $0x0
  801591:	e8 91 f6 ff ff       	call   800c27 <sys_page_unmap>
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80159f:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8015a5:	7e df                	jle    801586 <dup+0xf7>
	return r;
  8015a7:	89 f0                	mov    %esi,%eax
}
  8015a9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8015ac:	5b                   	pop    %ebx
  8015ad:	5e                   	pop    %esi
  8015ae:	5f                   	pop    %edi
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	53                   	push   %ebx
  8015b5:	83 ec 14             	sub    $0x14,%esp
  8015b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015bb:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8015be:	50                   	push   %eax
  8015bf:	53                   	push   %ebx
  8015c0:	e8 59 fd ff ff       	call   80131e <fd_lookup>
  8015c5:	89 c2                	mov    %eax,%edx
  8015c7:	83 c4 08             	add    $0x8,%esp
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	78 1a                	js     8015e8 <read+0x37>
  8015ce:	83 ec 08             	sub    $0x8,%esp
  8015d1:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8015d4:	50                   	push   %eax
  8015d5:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8015d8:	ff 30                	pushl  (%eax)
  8015da:	e8 01 fe ff ff       	call   8013e0 <dev_lookup>
  8015df:	89 c2                	mov    %eax,%edx
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	85 c0                	test   %eax,%eax
  8015e6:	79 04                	jns    8015ec <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8015e8:	89 d0                	mov    %edx,%eax
  8015ea:	eb 50                	jmp    80163c <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015ec:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8015ef:	8b 40 08             	mov    0x8(%eax),%eax
  8015f2:	83 e0 03             	and    $0x3,%eax
  8015f5:	83 f8 01             	cmp    $0x1,%eax
  8015f8:	75 1e                	jne    801618 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8015fa:	83 ec 04             	sub    $0x4,%esp
  8015fd:	53                   	push   %ebx
  8015fe:	a1 80 60 80 00       	mov    0x806080,%eax
  801603:	8b 40 4c             	mov    0x4c(%eax),%eax
  801606:	50                   	push   %eax
  801607:	68 1d 2e 80 00       	push   $0x802e1d
  80160c:	e8 bb eb ff ff       	call   8001cc <cprintf>
		return -E_INVAL;
  801611:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801616:	eb 24                	jmp    80163c <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801618:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80161b:	ff 70 04             	pushl  0x4(%eax)
  80161e:	ff 75 10             	pushl  0x10(%ebp)
  801621:	ff 75 0c             	pushl  0xc(%ebp)
  801624:	50                   	push   %eax
  801625:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801628:	ff 50 08             	call   *0x8(%eax)
  80162b:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	85 c0                	test   %eax,%eax
  801632:	78 06                	js     80163a <read+0x89>
		fd->fd_offset += r;
  801634:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801637:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80163a:	89 d0                	mov    %edx,%eax
}
  80163c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	57                   	push   %edi
  801645:	56                   	push   %esi
  801646:	53                   	push   %ebx
  801647:	83 ec 0c             	sub    $0xc,%esp
  80164a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80164d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801650:	bb 00 00 00 00       	mov    $0x0,%ebx
  801655:	39 f3                	cmp    %esi,%ebx
  801657:	73 25                	jae    80167e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801659:	83 ec 04             	sub    $0x4,%esp
  80165c:	89 f0                	mov    %esi,%eax
  80165e:	29 d8                	sub    %ebx,%eax
  801660:	50                   	push   %eax
  801661:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801664:	50                   	push   %eax
  801665:	ff 75 08             	pushl  0x8(%ebp)
  801668:	e8 44 ff ff ff       	call   8015b1 <read>
		if (m < 0)
  80166d:	83 c4 10             	add    $0x10,%esp
  801670:	85 c0                	test   %eax,%eax
  801672:	78 0c                	js     801680 <readn+0x3f>
			return m;
		if (m == 0)
  801674:	85 c0                	test   %eax,%eax
  801676:	74 06                	je     80167e <readn+0x3d>
  801678:	01 c3                	add    %eax,%ebx
  80167a:	39 f3                	cmp    %esi,%ebx
  80167c:	72 db                	jb     801659 <readn+0x18>
			break;
	}
	return tot;
  80167e:	89 d8                	mov    %ebx,%eax
}
  801680:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801683:	5b                   	pop    %ebx
  801684:	5e                   	pop    %esi
  801685:	5f                   	pop    %edi
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	53                   	push   %ebx
  80168c:	83 ec 14             	sub    $0x14,%esp
  80168f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801692:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801695:	50                   	push   %eax
  801696:	53                   	push   %ebx
  801697:	e8 82 fc ff ff       	call   80131e <fd_lookup>
  80169c:	89 c2                	mov    %eax,%edx
  80169e:	83 c4 08             	add    $0x8,%esp
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	78 1a                	js     8016bf <write+0x37>
  8016a5:	83 ec 08             	sub    $0x8,%esp
  8016a8:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8016ab:	50                   	push   %eax
  8016ac:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016af:	ff 30                	pushl  (%eax)
  8016b1:	e8 2a fd ff ff       	call   8013e0 <dev_lookup>
  8016b6:	89 c2                	mov    %eax,%edx
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	79 04                	jns    8016c3 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8016bf:	89 d0                	mov    %edx,%eax
  8016c1:	eb 4b                	jmp    80170e <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c3:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016c6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016ca:	75 1e                	jne    8016ea <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	53                   	push   %ebx
  8016d0:	a1 80 60 80 00       	mov    0x806080,%eax
  8016d5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016d8:	50                   	push   %eax
  8016d9:	68 39 2e 80 00       	push   $0x802e39
  8016de:	e8 e9 ea ff ff       	call   8001cc <cprintf>
		return -E_INVAL;
  8016e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e8:	eb 24                	jmp    80170e <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8016ea:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8016ed:	ff 70 04             	pushl  0x4(%eax)
  8016f0:	ff 75 10             	pushl  0x10(%ebp)
  8016f3:	ff 75 0c             	pushl  0xc(%ebp)
  8016f6:	50                   	push   %eax
  8016f7:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8016fa:	ff 50 0c             	call   *0xc(%eax)
  8016fd:	89 c2                	mov    %eax,%edx
	if (r > 0)
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	85 c0                	test   %eax,%eax
  801704:	7e 06                	jle    80170c <write+0x84>
		fd->fd_offset += r;
  801706:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801709:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80170c:	89 d0                	mov    %edx,%eax
}
  80170e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <seek>:

int
seek(int fdnum, off_t offset)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801719:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80171c:	50                   	push   %eax
  80171d:	ff 75 08             	pushl  0x8(%ebp)
  801720:	e8 f9 fb ff ff       	call   80131e <fd_lookup>
  801725:	83 c4 08             	add    $0x8,%esp
		return r;
  801728:	89 c2                	mov    %eax,%edx
  80172a:	85 c0                	test   %eax,%eax
  80172c:	78 0e                	js     80173c <seek+0x29>
	fd->fd_offset = offset;
  80172e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801731:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801734:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801737:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80173c:	89 d0                	mov    %edx,%eax
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	53                   	push   %ebx
  801744:	83 ec 14             	sub    $0x14,%esp
  801747:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174a:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80174d:	50                   	push   %eax
  80174e:	53                   	push   %ebx
  80174f:	e8 ca fb ff ff       	call   80131e <fd_lookup>
  801754:	83 c4 08             	add    $0x8,%esp
  801757:	85 c0                	test   %eax,%eax
  801759:	78 4e                	js     8017a9 <ftruncate+0x69>
  80175b:	83 ec 08             	sub    $0x8,%esp
  80175e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801761:	50                   	push   %eax
  801762:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801765:	ff 30                	pushl  (%eax)
  801767:	e8 74 fc ff ff       	call   8013e0 <dev_lookup>
  80176c:	83 c4 10             	add    $0x10,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	78 36                	js     8017a9 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801773:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801776:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80177a:	75 1e                	jne    80179a <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80177c:	83 ec 04             	sub    $0x4,%esp
  80177f:	53                   	push   %ebx
  801780:	a1 80 60 80 00       	mov    0x806080,%eax
  801785:	8b 40 4c             	mov    0x4c(%eax),%eax
  801788:	50                   	push   %eax
  801789:	68 fc 2d 80 00       	push   $0x802dfc
  80178e:	e8 39 ea ff ff       	call   8001cc <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801793:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801798:	eb 0f                	jmp    8017a9 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  80179a:	83 ec 08             	sub    $0x8,%esp
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8017a3:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8017a6:	ff 50 1c             	call   *0x1c(%eax)
}
  8017a9:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 14             	sub    $0x14,%esp
  8017b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b8:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8017bb:	50                   	push   %eax
  8017bc:	ff 75 08             	pushl  0x8(%ebp)
  8017bf:	e8 5a fb ff ff       	call   80131e <fd_lookup>
  8017c4:	83 c4 08             	add    $0x8,%esp
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 42                	js     80180d <fstat+0x5f>
  8017cb:	83 ec 08             	sub    $0x8,%esp
  8017ce:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8017d1:	50                   	push   %eax
  8017d2:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017d5:	ff 30                	pushl  (%eax)
  8017d7:	e8 04 fc ff ff       	call   8013e0 <dev_lookup>
  8017dc:	83 c4 10             	add    $0x10,%esp
  8017df:	85 c0                	test   %eax,%eax
  8017e1:	78 2a                	js     80180d <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  8017e3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017e6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017ed:	00 00 00 
	stat->st_isdir = 0;
  8017f0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017f7:	00 00 00 
	stat->st_dev = dev;
  8017fa:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8017fd:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801803:	83 ec 08             	sub    $0x8,%esp
  801806:	53                   	push   %ebx
  801807:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80180a:	ff 50 14             	call   *0x14(%eax)
}
  80180d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	56                   	push   %esi
  801816:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801817:	83 ec 08             	sub    $0x8,%esp
  80181a:	6a 00                	push   $0x0
  80181c:	ff 75 08             	pushl  0x8(%ebp)
  80181f:	e8 28 00 00 00       	call   80184c <open>
  801824:	89 c6                	mov    %eax,%esi
  801826:	83 c4 10             	add    $0x10,%esp
  801829:	85 f6                	test   %esi,%esi
  80182b:	78 18                	js     801845 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  80182d:	83 ec 08             	sub    $0x8,%esp
  801830:	ff 75 0c             	pushl  0xc(%ebp)
  801833:	56                   	push   %esi
  801834:	e8 75 ff ff ff       	call   8017ae <fstat>
  801839:	89 c3                	mov    %eax,%ebx
	close(fd);
  80183b:	89 34 24             	mov    %esi,(%esp)
  80183e:	e8 fb fb ff ff       	call   80143e <close>
	return r;
  801843:	89 d8                	mov    %ebx,%eax
}
  801845:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801848:	5b                   	pop    %ebx
  801849:	5e                   	pop    %esi
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	53                   	push   %ebx
  801850:	83 ec 10             	sub    $0x10,%esp
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
  801853:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801856:	50                   	push   %eax
  801857:	e8 68 fa ff ff       	call   8012c4 <fd_alloc>
  80185c:	89 c3                	mov    %eax,%ebx
  80185e:	83 c4 10             	add    $0x10,%esp
  801861:	85 db                	test   %ebx,%ebx
  801863:	78 36                	js     80189b <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80186b:	ff 75 0c             	pushl  0xc(%ebp)
  80186e:	ff 75 08             	pushl  0x8(%ebp)
  801871:	e8 1b 05 00 00       	call   801d91 <fsipc_open>
  801876:	89 c3                	mov    %eax,%ebx
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	85 c0                	test   %eax,%eax
  80187d:	79 11                	jns    801890 <open+0x44>
          fd_close(fd_store, 0);
  80187f:	83 ec 08             	sub    $0x8,%esp
  801882:	6a 00                	push   $0x0
  801884:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801887:	e8 e0 fa ff ff       	call   80136c <fd_close>
          return r;
  80188c:	89 d8                	mov    %ebx,%eax
  80188e:	eb 0b                	jmp    80189b <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801890:	83 ec 0c             	sub    $0xc,%esp
  801893:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801896:	e8 19 fa ff ff       	call   8012b4 <fd2num>
}
  80189b:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  8018aa:	6a 01                	push   $0x1
  8018ac:	6a 00                	push   $0x0
  8018ae:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  8018b4:	53                   	push   %ebx
  8018b5:	e8 e7 03 00 00       	call   801ca1 <funmap>
  8018ba:	83 c4 10             	add    $0x10,%esp
          return r;
  8018bd:	89 c2                	mov    %eax,%edx
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 19                	js     8018dc <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  8018c3:	83 ec 0c             	sub    $0xc,%esp
  8018c6:	ff 73 0c             	pushl  0xc(%ebx)
  8018c9:	e8 68 05 00 00       	call   801e36 <fsipc_close>
  8018ce:	83 c4 10             	add    $0x10,%esp
          return r;
  8018d1:	89 c2                	mov    %eax,%edx
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 05                	js     8018dc <file_close+0x3c>
        }
        return 0;
  8018d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8018dc:	89 d0                	mov    %edx,%eax
  8018de:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	57                   	push   %edi
  8018e7:	56                   	push   %esi
  8018e8:	53                   	push   %ebx
  8018e9:	83 ec 0c             	sub    $0xc,%esp
  8018ec:	8b 75 10             	mov    0x10(%ebp),%esi
  8018ef:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  8018fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801900:	39 d7                	cmp    %edx,%edi
  801902:	0f 87 95 00 00 00    	ja     80199d <file_read+0xba>
	if (offset + n > size)
  801908:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80190b:	39 d0                	cmp    %edx,%eax
  80190d:	76 04                	jbe    801913 <file_read+0x30>
		n = size - offset;
  80190f:	89 d6                	mov    %edx,%esi
  801911:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801913:	83 ec 0c             	sub    $0xc,%esp
  801916:	ff 75 08             	pushl  0x8(%ebp)
  801919:	e8 7e f9 ff ff       	call   80129c <fd2data>
  80191e:	89 c3                	mov    %eax,%ebx
  801920:	01 fb                	add    %edi,%ebx
  801922:	83 c4 10             	add    $0x10,%esp
  801925:	eb 41                	jmp    801968 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801927:	89 d8                	mov    %ebx,%eax
  801929:	c1 e8 16             	shr    $0x16,%eax
  80192c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801933:	a8 01                	test   $0x1,%al
  801935:	74 10                	je     801947 <file_read+0x64>
  801937:	89 d8                	mov    %ebx,%eax
  801939:	c1 e8 0c             	shr    $0xc,%eax
  80193c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801943:	a8 01                	test   $0x1,%al
  801945:	75 1b                	jne    801962 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801947:	83 ec 04             	sub    $0x4,%esp
  80194a:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80194d:	50                   	push   %eax
  80194e:	57                   	push   %edi
  80194f:	ff 75 08             	pushl  0x8(%ebp)
  801952:	e8 d4 02 00 00       	call   801c2b <fmap>
  801957:	83 c4 10             	add    $0x10,%esp
              return r;
  80195a:	89 c1                	mov    %eax,%ecx
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 3d                	js     80199d <file_read+0xba>
  801960:	eb 1c                	jmp    80197e <file_read+0x9b>
  801962:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801968:	83 ec 0c             	sub    $0xc,%esp
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	e8 29 f9 ff ff       	call   80129c <fd2data>
  801973:	01 f8                	add    %edi,%eax
  801975:	01 f0                	add    %esi,%eax
  801977:	83 c4 10             	add    $0x10,%esp
  80197a:	39 d8                	cmp    %ebx,%eax
  80197c:	77 a9                	ja     801927 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  80197e:	83 ec 04             	sub    $0x4,%esp
  801981:	56                   	push   %esi
  801982:	83 ec 04             	sub    $0x4,%esp
  801985:	ff 75 08             	pushl  0x8(%ebp)
  801988:	e8 0f f9 ff ff       	call   80129c <fd2data>
  80198d:	83 c4 08             	add    $0x8,%esp
  801990:	01 f8                	add    %edi,%eax
  801992:	50                   	push   %eax
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	e8 b1 ef ff ff       	call   80094c <memmove>
	return n;
  80199b:	89 f1                	mov    %esi,%ecx
}
  80199d:	89 c8                	mov    %ecx,%eax
  80199f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8019a2:	5b                   	pop    %ebx
  8019a3:	5e                   	pop    %esi
  8019a4:	5f                   	pop    %edi
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
  8019aa:	56                   	push   %esi
  8019ab:	53                   	push   %ebx
  8019ac:	83 ec 18             	sub    $0x18,%esp
  8019af:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019b2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8019b5:	50                   	push   %eax
  8019b6:	ff 75 08             	pushl  0x8(%ebp)
  8019b9:	e8 60 f9 ff ff       	call   80131e <fd_lookup>
  8019be:	83 c4 10             	add    $0x10,%esp
		return r;
  8019c1:	89 c2                	mov    %eax,%edx
  8019c3:	85 c0                	test   %eax,%eax
  8019c5:	0f 88 9f 00 00 00    	js     801a6a <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  8019cb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8019ce:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  8019d0:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8019d5:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  8019db:	0f 85 89 00 00 00    	jne    801a6a <read_map+0xc3>
	va = fd2data(fd) + offset;
  8019e1:	83 ec 0c             	sub    $0xc,%esp
  8019e4:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8019e7:	e8 b0 f8 ff ff       	call   80129c <fd2data>
  8019ec:	89 c3                	mov    %eax,%ebx
  8019ee:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  8019f0:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  8019f3:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8019f8:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  8019fe:	7f 6a                	jg     801a6a <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801a00:	89 d8                	mov    %ebx,%eax
  801a02:	c1 e8 16             	shr    $0x16,%eax
  801a05:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801a0c:	a8 01                	test   $0x1,%al
  801a0e:	74 10                	je     801a20 <read_map+0x79>
  801a10:	89 d8                	mov    %ebx,%eax
  801a12:	c1 e8 0c             	shr    $0xc,%eax
  801a15:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a1c:	a8 01                	test   $0x1,%al
  801a1e:	75 19                	jne    801a39 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801a20:	83 ec 04             	sub    $0x4,%esp
  801a23:	8d 46 01             	lea    0x1(%esi),%eax
  801a26:	50                   	push   %eax
  801a27:	56                   	push   %esi
  801a28:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801a2b:	e8 fb 01 00 00       	call   801c2b <fmap>
  801a30:	83 c4 10             	add    $0x10,%esp
            return r;
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	85 c0                	test   %eax,%eax
  801a37:	78 31                	js     801a6a <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801a39:	89 d8                	mov    %ebx,%eax
  801a3b:	c1 e8 16             	shr    $0x16,%eax
  801a3e:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801a45:	a8 01                	test   $0x1,%al
  801a47:	74 10                	je     801a59 <read_map+0xb2>
  801a49:	89 d8                	mov    %ebx,%eax
  801a4b:	c1 e8 0c             	shr    $0xc,%eax
  801a4e:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a55:	a8 01                	test   $0x1,%al
  801a57:	75 07                	jne    801a60 <read_map+0xb9>
		return -E_NO_DISK;
  801a59:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801a5e:	eb 0a                	jmp    801a6a <read_map+0xc3>

	*blk = (void*) va;
  801a60:	8b 45 10             	mov    0x10(%ebp),%eax
  801a63:	89 18                	mov    %ebx,(%eax)
	return 0;
  801a65:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a6a:	89 d0                	mov    %edx,%eax
  801a6c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801a6f:	5b                   	pop    %ebx
  801a70:	5e                   	pop    %esi
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	57                   	push   %edi
  801a77:	56                   	push   %esi
  801a78:	53                   	push   %ebx
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	8b 75 08             	mov    0x8(%ebp),%esi
  801a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801a82:	8b 45 10             	mov    0x10(%ebp),%eax
  801a85:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801a88:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801a8d:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801a93:	0f 87 bd 00 00 00    	ja     801b56 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801a99:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801a9f:	73 17                	jae    801ab8 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801aa1:	83 ec 08             	sub    $0x8,%esp
  801aa4:	52                   	push   %edx
  801aa5:	56                   	push   %esi
  801aa6:	e8 fb 00 00 00       	call   801ba6 <file_trunc>
  801aab:	83 c4 10             	add    $0x10,%esp
			return r;
  801aae:	89 c1                	mov    %eax,%ecx
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	0f 88 9e 00 00 00    	js     801b56 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801ab8:	83 ec 0c             	sub    $0xc,%esp
  801abb:	56                   	push   %esi
  801abc:	e8 db f7 ff ff       	call   80129c <fd2data>
  801ac1:	89 c3                	mov    %eax,%ebx
  801ac3:	01 fb                	add    %edi,%ebx
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	eb 42                	jmp    801b0c <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801aca:	89 d8                	mov    %ebx,%eax
  801acc:	c1 e8 16             	shr    $0x16,%eax
  801acf:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801ad6:	a8 01                	test   $0x1,%al
  801ad8:	74 10                	je     801aea <file_write+0x77>
  801ada:	89 d8                	mov    %ebx,%eax
  801adc:	c1 e8 0c             	shr    $0xc,%eax
  801adf:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801ae6:	a8 01                	test   $0x1,%al
  801ae8:	75 1c                	jne    801b06 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801aea:	83 ec 04             	sub    $0x4,%esp
  801aed:	8b 55 10             	mov    0x10(%ebp),%edx
  801af0:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801af3:	50                   	push   %eax
  801af4:	57                   	push   %edi
  801af5:	56                   	push   %esi
  801af6:	e8 30 01 00 00       	call   801c2b <fmap>
  801afb:	83 c4 10             	add    $0x10,%esp
              return r;
  801afe:	89 c1                	mov    %eax,%ecx
  801b00:	85 c0                	test   %eax,%eax
  801b02:	78 52                	js     801b56 <file_write+0xe3>
  801b04:	eb 1b                	jmp    801b21 <file_write+0xae>
  801b06:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b0c:	83 ec 0c             	sub    $0xc,%esp
  801b0f:	56                   	push   %esi
  801b10:	e8 87 f7 ff ff       	call   80129c <fd2data>
  801b15:	01 f8                	add    %edi,%eax
  801b17:	03 45 10             	add    0x10(%ebp),%eax
  801b1a:	83 c4 10             	add    $0x10,%esp
  801b1d:	39 d8                	cmp    %ebx,%eax
  801b1f:	77 a9                	ja     801aca <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801b21:	83 ec 0c             	sub    $0xc,%esp
  801b24:	68 56 2e 80 00       	push   $0x802e56
  801b29:	e8 9e e6 ff ff       	call   8001cc <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801b2e:	83 c4 0c             	add    $0xc,%esp
  801b31:	ff 75 10             	pushl  0x10(%ebp)
  801b34:	ff 75 0c             	pushl  0xc(%ebp)
  801b37:	56                   	push   %esi
  801b38:	e8 5f f7 ff ff       	call   80129c <fd2data>
  801b3d:	01 f8                	add    %edi,%eax
  801b3f:	89 04 24             	mov    %eax,(%esp)
  801b42:	e8 05 ee ff ff       	call   80094c <memmove>
        cprintf("write done\n");
  801b47:	c7 04 24 63 2e 80 00 	movl   $0x802e63,(%esp)
  801b4e:	e8 79 e6 ff ff       	call   8001cc <cprintf>
	return n;
  801b53:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801b56:	89 c8                	mov    %ecx,%eax
  801b58:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5e                   	pop    %esi
  801b5d:	5f                   	pop    %edi
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	56                   	push   %esi
  801b64:	53                   	push   %ebx
  801b65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b68:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801b6b:	83 ec 08             	sub    $0x8,%esp
  801b6e:	8d 43 10             	lea    0x10(%ebx),%eax
  801b71:	50                   	push   %eax
  801b72:	56                   	push   %esi
  801b73:	e8 58 ec ff ff       	call   8007d0 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801b78:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801b7e:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801b84:	83 c4 10             	add    $0x10,%esp
  801b87:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801b8e:	0f 94 c0             	sete   %al
  801b91:	0f b6 c0             	movzbl %al,%eax
  801b94:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801b9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9f:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801ba2:	5b                   	pop    %ebx
  801ba3:	5e                   	pop    %esi
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
  801ba9:	57                   	push   %edi
  801baa:	56                   	push   %esi
  801bab:	53                   	push   %ebx
  801bac:	83 ec 0c             	sub    $0xc,%esp
  801baf:	8b 75 08             	mov    0x8(%ebp),%esi
  801bb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801bb5:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801bba:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801bc0:	7f 5f                	jg     801c21 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801bc2:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801bc8:	83 ec 08             	sub    $0x8,%esp
  801bcb:	53                   	push   %ebx
  801bcc:	ff 76 0c             	pushl  0xc(%esi)
  801bcf:	e8 3a 02 00 00       	call   801e0e <fsipc_set_size>
  801bd4:	83 c4 10             	add    $0x10,%esp
		return r;
  801bd7:	89 c2                	mov    %eax,%edx
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	78 44                	js     801c21 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801bdd:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801be3:	74 19                	je     801bfe <file_trunc+0x58>
  801be5:	68 90 2e 80 00       	push   $0x802e90
  801bea:	68 6f 2e 80 00       	push   $0x802e6f
  801bef:	68 dc 00 00 00       	push   $0xdc
  801bf4:	68 84 2e 80 00       	push   $0x802e84
  801bf9:	e8 e2 07 00 00       	call   8023e0 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801bfe:	83 ec 04             	sub    $0x4,%esp
  801c01:	53                   	push   %ebx
  801c02:	57                   	push   %edi
  801c03:	56                   	push   %esi
  801c04:	e8 22 00 00 00       	call   801c2b <fmap>
  801c09:	83 c4 10             	add    $0x10,%esp
		return r;
  801c0c:	89 c2                	mov    %eax,%edx
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	78 0f                	js     801c21 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	53                   	push   %ebx
  801c15:	57                   	push   %edi
  801c16:	56                   	push   %esi
  801c17:	e8 85 00 00 00       	call   801ca1 <funmap>

	return 0;
  801c1c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801c21:	89 d0                	mov    %edx,%eax
  801c23:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c26:	5b                   	pop    %ebx
  801c27:	5e                   	pop    %esi
  801c28:	5f                   	pop    %edi
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <fmap>:

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
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	57                   	push   %edi
  801c2f:	56                   	push   %esi
  801c30:	53                   	push   %ebx
  801c31:	83 ec 0c             	sub    $0xc,%esp
  801c34:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c37:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801c3a:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801c3d:	7d 55                	jge    801c94 <fmap+0x69>
          fma = fd2data(fd);
  801c3f:	83 ec 0c             	sub    $0xc,%esp
  801c42:	57                   	push   %edi
  801c43:	e8 54 f6 ff ff       	call   80129c <fd2data>
  801c48:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c51:	05 ff 0f 00 00       	add    $0xfff,%eax
  801c56:	89 c3                	mov    %eax,%ebx
  801c58:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801c5e:	39 f3                	cmp    %esi,%ebx
  801c60:	7d 32                	jge    801c94 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801c62:	83 ec 04             	sub    $0x4,%esp
  801c65:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801c68:	01 d8                	add    %ebx,%eax
  801c6a:	50                   	push   %eax
  801c6b:	53                   	push   %ebx
  801c6c:	ff 77 0c             	pushl  0xc(%edi)
  801c6f:	e8 6f 01 00 00       	call   801de3 <fsipc_map>
  801c74:	83 c4 10             	add    $0x10,%esp
  801c77:	85 c0                	test   %eax,%eax
  801c79:	79 0f                	jns    801c8a <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	53                   	push   %ebx
  801c81:	57                   	push   %edi
  801c82:	e8 1a 00 00 00       	call   801ca1 <funmap>
  801c87:	83 c4 10             	add    $0x10,%esp
  801c8a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c90:	39 f3                	cmp    %esi,%ebx
  801c92:	7c ce                	jl     801c62 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801c94:	b8 00 00 00 00       	mov    $0x0,%eax
  801c99:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c9c:	5b                   	pop    %ebx
  801c9d:	5e                   	pop    %esi
  801c9e:	5f                   	pop    %edi
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <funmap>:

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
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	57                   	push   %edi
  801ca5:	56                   	push   %esi
  801ca6:	53                   	push   %ebx
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801cb0:	39 f3                	cmp    %esi,%ebx
  801cb2:	0f 8d 80 00 00 00    	jge    801d38 <funmap+0x97>
          fma = fd2data(fd);
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	ff 75 08             	pushl  0x8(%ebp)
  801cbe:	e8 d9 f5 ff ff       	call   80129c <fd2data>
  801cc3:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801cc5:	83 c4 10             	add    $0x10,%esp
  801cc8:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801cce:	89 c3                	mov    %eax,%ebx
  801cd0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801cd6:	39 f3                	cmp    %esi,%ebx
  801cd8:	7d 5e                	jge    801d38 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801cda:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801cdd:	89 c2                	mov    %eax,%edx
  801cdf:	c1 ea 0c             	shr    $0xc,%edx
  801ce2:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801ce9:	a8 01                	test   $0x1,%al
  801ceb:	74 41                	je     801d2e <funmap+0x8d>
              if (dirty) {
  801ced:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801cf1:	74 21                	je     801d14 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801cf3:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801cfa:	a8 40                	test   $0x40,%al
  801cfc:	74 16                	je     801d14 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801cfe:	83 ec 08             	sub    $0x8,%esp
  801d01:	53                   	push   %ebx
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	ff 70 0c             	pushl  0xc(%eax)
  801d08:	e8 49 01 00 00       	call   801e56 <fsipc_dirty>
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	85 c0                	test   %eax,%eax
  801d12:	78 29                	js     801d3d <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801d14:	83 ec 08             	sub    $0x8,%esp
  801d17:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801d1a:	50                   	push   %eax
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	e8 41 ee ff ff       	call   800b64 <sys_getenvid>
  801d23:	89 04 24             	mov    %eax,(%esp)
  801d26:	e8 fc ee ff ff       	call   800c27 <sys_page_unmap>
  801d2b:	83 c4 10             	add    $0x10,%esp
  801d2e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d34:	39 f3                	cmp    %esi,%ebx
  801d36:	7c a2                	jl     801cda <funmap+0x39>
            }
          }
        }

        return 0;
  801d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d40:	5b                   	pop    %ebx
  801d41:	5e                   	pop    %esi
  801d42:	5f                   	pop    %edi
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <remove>:

// Delete a file
int
remove(const char *path)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801d4b:	ff 75 08             	pushl  0x8(%ebp)
  801d4e:	e8 2b 01 00 00       	call   801e7e <fsipc_remove>
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801d5b:	e8 64 01 00 00       	call   801ec4 <fsipc_sync>
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    
	...

00801d64 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801d6a:	6a 07                	push   $0x7
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	ff 75 08             	pushl  0x8(%ebp)
  801d72:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801d77:	50                   	push   %eax
  801d78:	e8 da 07 00 00       	call   802557 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801d7d:	83 c4 0c             	add    $0xc,%esp
  801d80:	ff 75 14             	pushl  0x14(%ebp)
  801d83:	ff 75 10             	pushl  0x10(%ebp)
  801d86:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801d89:	50                   	push   %eax
  801d8a:	e8 65 07 00 00       	call   8024f4 <ipc_recv>
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
  801d94:	56                   	push   %esi
  801d95:	53                   	push   %ebx
  801d96:	83 ec 1c             	sub    $0x1c,%esp
  801d99:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801d9c:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801da1:	56                   	push   %esi
  801da2:	e8 ed e9 ff ff       	call   800794 <strlen>
  801da7:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801daa:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801daf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801db4:	7f 24                	jg     801dda <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801db6:	83 ec 08             	sub    $0x8,%esp
  801db9:	56                   	push   %esi
  801dba:	53                   	push   %ebx
  801dbb:	e8 10 ea ff ff       	call   8007d0 <strcpy>
	req->req_omode = omode;
  801dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc3:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801dc9:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801dcc:	50                   	push   %eax
  801dcd:	ff 75 10             	pushl  0x10(%ebp)
  801dd0:	53                   	push   %ebx
  801dd1:	6a 01                	push   $0x1
  801dd3:	e8 8c ff ff ff       	call   801d64 <fsipc>
  801dd8:	89 c2                	mov    %eax,%edx
}
  801dda:	89 d0                	mov    %edx,%eax
  801ddc:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801ddf:	5b                   	pop    %ebx
  801de0:	5e                   	pop    %esi
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df4:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801df9:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801dfc:	50                   	push   %eax
  801dfd:	ff 75 10             	pushl  0x10(%ebp)
  801e00:	68 00 30 80 00       	push   $0x803000
  801e05:	6a 02                	push   $0x2
  801e07:	e8 58 ff ff ff       	call   801d64 <fsipc>

	//return -E_UNSPECIFIED;
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
  801e11:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  801e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1f:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	68 00 30 80 00       	push   $0x803000
  801e2d:	6a 03                	push   $0x3
  801e2f:	e8 30 ff ff ff       	call   801d64 <fsipc>
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	68 00 30 80 00       	push   $0x803000
  801e4d:	6a 04                	push   $0x4
  801e4f:	e8 10 ff ff ff       	call   801d64 <fsipc>
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5f:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e67:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	68 00 30 80 00       	push   $0x803000
  801e75:	6a 05                	push   $0x5
  801e77:	e8 e8 fe ff ff       	call   801d64 <fsipc>
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	56                   	push   %esi
  801e82:	53                   	push   %ebx
  801e83:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801e86:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801e8b:	83 ec 0c             	sub    $0xc,%esp
  801e8e:	53                   	push   %ebx
  801e8f:	e8 00 e9 ff ff       	call   800794 <strlen>
  801e94:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801e97:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801e9c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ea1:	7f 18                	jg     801ebb <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801ea3:	83 ec 08             	sub    $0x8,%esp
  801ea6:	53                   	push   %ebx
  801ea7:	56                   	push   %esi
  801ea8:	e8 23 e9 ff ff       	call   8007d0 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	56                   	push   %esi
  801eb2:	6a 06                	push   $0x6
  801eb4:	e8 ab fe ff ff       	call   801d64 <fsipc>
  801eb9:	89 c2                	mov    %eax,%edx
}
  801ebb:	89 d0                	mov    %edx,%eax
  801ebd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801ec0:	5b                   	pop    %ebx
  801ec1:	5e                   	pop    %esi
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	68 00 30 80 00       	push   $0x803000
  801ed3:	6a 07                	push   $0x7
  801ed5:	e8 8a fe ff ff       	call   801d64 <fsipc>
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <pipe>:
};

int
pipe(int pfd[2])
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	57                   	push   %edi
  801ee0:	56                   	push   %esi
  801ee1:	53                   	push   %ebx
  801ee2:	83 ec 18             	sub    $0x18,%esp
  801ee5:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ee8:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801eeb:	50                   	push   %eax
  801eec:	e8 d3 f3 ff ff       	call   8012c4 <fd_alloc>
  801ef1:	89 c3                	mov    %eax,%ebx
  801ef3:	83 c4 10             	add    $0x10,%esp
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	0f 88 25 01 00 00    	js     802023 <pipe+0x147>
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	68 07 04 00 00       	push   $0x407
  801f06:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801f09:	6a 00                	push   $0x0
  801f0b:	e8 92 ec ff ff       	call   800ba2 <sys_page_alloc>
  801f10:	89 c3                	mov    %eax,%ebx
  801f12:	83 c4 10             	add    $0x10,%esp
  801f15:	85 c0                	test   %eax,%eax
  801f17:	0f 88 06 01 00 00    	js     802023 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f1d:	83 ec 0c             	sub    $0xc,%esp
  801f20:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801f23:	50                   	push   %eax
  801f24:	e8 9b f3 ff ff       	call   8012c4 <fd_alloc>
  801f29:	89 c3                	mov    %eax,%ebx
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	0f 88 dd 00 00 00    	js     802013 <pipe+0x137>
  801f36:	83 ec 04             	sub    $0x4,%esp
  801f39:	68 07 04 00 00       	push   $0x407
  801f3e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801f41:	6a 00                	push   $0x0
  801f43:	e8 5a ec ff ff       	call   800ba2 <sys_page_alloc>
  801f48:	89 c3                	mov    %eax,%ebx
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	0f 88 be 00 00 00    	js     802013 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801f5b:	e8 3c f3 ff ff       	call   80129c <fd2data>
  801f60:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f62:	83 c4 0c             	add    $0xc,%esp
  801f65:	68 07 04 00 00       	push   $0x407
  801f6a:	50                   	push   %eax
  801f6b:	6a 00                	push   $0x0
  801f6d:	e8 30 ec ff ff       	call   800ba2 <sys_page_alloc>
  801f72:	89 c3                	mov    %eax,%ebx
  801f74:	83 c4 10             	add    $0x10,%esp
  801f77:	85 c0                	test   %eax,%eax
  801f79:	0f 88 84 00 00 00    	js     802003 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	68 07 04 00 00       	push   $0x407
  801f87:	83 ec 0c             	sub    $0xc,%esp
  801f8a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801f8d:	e8 0a f3 ff ff       	call   80129c <fd2data>
  801f92:	83 c4 10             	add    $0x10,%esp
  801f95:	50                   	push   %eax
  801f96:	6a 00                	push   $0x0
  801f98:	56                   	push   %esi
  801f99:	6a 00                	push   $0x0
  801f9b:	e8 45 ec ff ff       	call   800be5 <sys_page_map>
  801fa0:	89 c3                	mov    %eax,%ebx
  801fa2:	83 c4 20             	add    $0x20,%esp
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	78 4c                	js     801ff5 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801fa9:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801faf:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801fb2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801fb4:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801fb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fbe:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801fc4:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801fc7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fc9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801fcc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801fd9:	e8 d6 f2 ff ff       	call   8012b4 <fd2num>
  801fde:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801fe0:	83 c4 04             	add    $0x4,%esp
  801fe3:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801fe6:	e8 c9 f2 ff ff       	call   8012b4 <fd2num>
  801feb:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff3:	eb 30                	jmp    802025 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  801ff5:	83 ec 08             	sub    $0x8,%esp
  801ff8:	56                   	push   %esi
  801ff9:	6a 00                	push   $0x0
  801ffb:	e8 27 ec ff ff       	call   800c27 <sys_page_unmap>
  802000:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  802003:	83 ec 08             	sub    $0x8,%esp
  802006:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802009:	6a 00                	push   $0x0
  80200b:	e8 17 ec ff ff       	call   800c27 <sys_page_unmap>
  802010:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  802013:	83 ec 08             	sub    $0x8,%esp
  802016:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802019:	6a 00                	push   $0x0
  80201b:	e8 07 ec ff ff       	call   800c27 <sys_page_unmap>
  802020:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  802023:	89 d8                	mov    %ebx,%eax
}
  802025:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802028:	5b                   	pop    %ebx
  802029:	5e                   	pop    %esi
  80202a:	5f                   	pop    %edi
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	57                   	push   %edi
  802031:	56                   	push   %esi
  802032:	53                   	push   %ebx
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802039:	a1 80 60 80 00       	mov    0x806080,%eax
  80203e:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  802041:	83 ec 0c             	sub    $0xc,%esp
  802044:	ff 75 08             	pushl  0x8(%ebp)
  802047:	e8 64 05 00 00       	call   8025b0 <pageref>
  80204c:	89 c3                	mov    %eax,%ebx
  80204e:	89 3c 24             	mov    %edi,(%esp)
  802051:	e8 5a 05 00 00       	call   8025b0 <pageref>
  802056:	83 c4 10             	add    $0x10,%esp
  802059:	39 c3                	cmp    %eax,%ebx
  80205b:	0f 94 c0             	sete   %al
  80205e:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  802061:	8b 0d 80 60 80 00    	mov    0x806080,%ecx
  802067:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  80206a:	39 c6                	cmp    %eax,%esi
  80206c:	74 1b                	je     802089 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  80206e:	83 fa 01             	cmp    $0x1,%edx
  802071:	75 c6                	jne    802039 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802073:	6a 01                	push   $0x1
  802075:	8b 41 58             	mov    0x58(%ecx),%eax
  802078:	50                   	push   %eax
  802079:	56                   	push   %esi
  80207a:	68 b8 2e 80 00       	push   $0x802eb8
  80207f:	e8 48 e1 ff ff       	call   8001cc <cprintf>
  802084:	83 c4 10             	add    $0x10,%esp
  802087:	eb b0                	jmp    802039 <_pipeisclosed+0xc>
	}
}
  802089:	89 d0                	mov    %edx,%eax
  80208b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80208e:	5b                   	pop    %ebx
  80208f:	5e                   	pop    %esi
  802090:	5f                   	pop    %edi
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802099:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80209c:	50                   	push   %eax
  80209d:	ff 75 08             	pushl  0x8(%ebp)
  8020a0:	e8 79 f2 ff ff       	call   80131e <fd_lookup>
  8020a5:	83 c4 10             	add    $0x10,%esp
		return r;
  8020a8:	89 c2                	mov    %eax,%edx
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 19                	js     8020c7 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  8020ae:	83 ec 0c             	sub    $0xc,%esp
  8020b1:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8020b4:	e8 e3 f1 ff ff       	call   80129c <fd2data>
	return _pipeisclosed(fd, p);
  8020b9:	83 c4 08             	add    $0x8,%esp
  8020bc:	50                   	push   %eax
  8020bd:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8020c0:	e8 68 ff ff ff       	call   80202d <_pipeisclosed>
  8020c5:	89 c2                	mov    %eax,%edx
}
  8020c7:	89 d0                	mov    %edx,%eax
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	57                   	push   %edi
  8020cf:	56                   	push   %esi
  8020d0:	53                   	push   %ebx
  8020d1:	83 ec 18             	sub    $0x18,%esp
  8020d4:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  8020d7:	57                   	push   %edi
  8020d8:	e8 bf f1 ff ff       	call   80129c <fd2data>
  8020dd:	89 c3                	mov    %eax,%ebx
	if (debug)
  8020df:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8020e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e5:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8020e8:	be 00 00 00 00       	mov    $0x0,%esi
  8020ed:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020f0:	73 55                	jae    802147 <piperead+0x7c>
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
  8020f2:	8b 03                	mov    (%ebx),%eax
  8020f4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020f7:	75 2c                	jne    802125 <piperead+0x5a>
  8020f9:	85 f6                	test   %esi,%esi
  8020fb:	74 04                	je     802101 <piperead+0x36>
  8020fd:	89 f0                	mov    %esi,%eax
  8020ff:	eb 48                	jmp    802149 <piperead+0x7e>
  802101:	83 ec 08             	sub    $0x8,%esp
  802104:	53                   	push   %ebx
  802105:	57                   	push   %edi
  802106:	e8 22 ff ff ff       	call   80202d <_pipeisclosed>
  80210b:	83 c4 10             	add    $0x10,%esp
  80210e:	85 c0                	test   %eax,%eax
  802110:	74 07                	je     802119 <piperead+0x4e>
  802112:	b8 00 00 00 00       	mov    $0x0,%eax
  802117:	eb 30                	jmp    802149 <piperead+0x7e>
  802119:	e8 65 ea ff ff       	call   800b83 <sys_yield>
  80211e:	8b 03                	mov    (%ebx),%eax
  802120:	3b 43 04             	cmp    0x4(%ebx),%eax
  802123:	74 d4                	je     8020f9 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802125:	8b 13                	mov    (%ebx),%edx
  802127:	89 d0                	mov    %edx,%eax
  802129:	85 d2                	test   %edx,%edx
  80212b:	79 03                	jns    802130 <piperead+0x65>
  80212d:	8d 42 1f             	lea    0x1f(%edx),%eax
  802130:	83 e0 e0             	and    $0xffffffe0,%eax
  802133:	29 c2                	sub    %eax,%edx
  802135:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  802139:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80213c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80213f:	ff 03                	incl   (%ebx)
  802141:	46                   	inc    %esi
  802142:	3b 75 10             	cmp    0x10(%ebp),%esi
  802145:	72 ab                	jb     8020f2 <piperead+0x27>
	}
	return i;
  802147:	89 f0                	mov    %esi,%eax
}
  802149:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80214c:	5b                   	pop    %ebx
  80214d:	5e                   	pop    %esi
  80214e:	5f                   	pop    %edi
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	57                   	push   %edi
  802155:	56                   	push   %esi
  802156:	53                   	push   %ebx
  802157:	83 ec 18             	sub    $0x18,%esp
  80215a:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  80215d:	57                   	push   %edi
  80215e:	e8 39 f1 ff ff       	call   80129c <fd2data>
  802163:	89 c3                	mov    %eax,%ebx
	if (debug)
  802165:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80216e:	be 00 00 00 00       	mov    $0x0,%esi
  802173:	3b 75 10             	cmp    0x10(%ebp),%esi
  802176:	73 55                	jae    8021cd <pipewrite+0x7c>
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
  802178:	8b 03                	mov    (%ebx),%eax
  80217a:	83 c0 20             	add    $0x20,%eax
  80217d:	39 43 04             	cmp    %eax,0x4(%ebx)
  802180:	72 27                	jb     8021a9 <pipewrite+0x58>
  802182:	83 ec 08             	sub    $0x8,%esp
  802185:	53                   	push   %ebx
  802186:	57                   	push   %edi
  802187:	e8 a1 fe ff ff       	call   80202d <_pipeisclosed>
  80218c:	83 c4 10             	add    $0x10,%esp
  80218f:	85 c0                	test   %eax,%eax
  802191:	74 07                	je     80219a <pipewrite+0x49>
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	eb 35                	jmp    8021cf <pipewrite+0x7e>
  80219a:	e8 e4 e9 ff ff       	call   800b83 <sys_yield>
  80219f:	8b 03                	mov    (%ebx),%eax
  8021a1:	83 c0 20             	add    $0x20,%eax
  8021a4:	39 43 04             	cmp    %eax,0x4(%ebx)
  8021a7:	73 d9                	jae    802182 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021a9:	8b 53 04             	mov    0x4(%ebx),%edx
  8021ac:	89 d0                	mov    %edx,%eax
  8021ae:	85 d2                	test   %edx,%edx
  8021b0:	79 03                	jns    8021b5 <pipewrite+0x64>
  8021b2:	8d 42 1f             	lea    0x1f(%edx),%eax
  8021b5:	83 e0 e0             	and    $0xffffffe0,%eax
  8021b8:	29 c2                	sub    %eax,%edx
  8021ba:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  8021bd:	8a 04 31             	mov    (%ecx,%esi,1),%al
  8021c0:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8021c4:	ff 43 04             	incl   0x4(%ebx)
  8021c7:	46                   	inc    %esi
  8021c8:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021cb:	72 ab                	jb     802178 <pipewrite+0x27>
	}
	
	return i;
  8021cd:	89 f0                	mov    %esi,%eax
}
  8021cf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8021d2:	5b                   	pop    %ebx
  8021d3:	5e                   	pop    %esi
  8021d4:	5f                   	pop    %edi
  8021d5:	c9                   	leave  
  8021d6:	c3                   	ret    

008021d7 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  8021d7:	55                   	push   %ebp
  8021d8:	89 e5                	mov    %esp,%ebp
  8021da:	56                   	push   %esi
  8021db:	53                   	push   %ebx
  8021dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021df:	83 ec 0c             	sub    $0xc,%esp
  8021e2:	ff 75 08             	pushl  0x8(%ebp)
  8021e5:	e8 b2 f0 ff ff       	call   80129c <fd2data>
  8021ea:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021ec:	83 c4 08             	add    $0x8,%esp
  8021ef:	68 cb 2e 80 00       	push   $0x802ecb
  8021f4:	53                   	push   %ebx
  8021f5:	e8 d6 e5 ff ff       	call   8007d0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021fa:	8b 46 04             	mov    0x4(%esi),%eax
  8021fd:	2b 06                	sub    (%esi),%eax
  8021ff:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802205:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80220c:	00 00 00 
	stat->st_dev = &devpipe;
  80220f:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  802216:	60 80 00 
	return 0;
}
  802219:	b8 00 00 00 00       	mov    $0x0,%eax
  80221e:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802221:	5b                   	pop    %ebx
  802222:	5e                   	pop    %esi
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	53                   	push   %ebx
  802229:	83 ec 0c             	sub    $0xc,%esp
  80222c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80222f:	53                   	push   %ebx
  802230:	6a 00                	push   $0x0
  802232:	e8 f0 e9 ff ff       	call   800c27 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802237:	89 1c 24             	mov    %ebx,(%esp)
  80223a:	e8 5d f0 ff ff       	call   80129c <fd2data>
  80223f:	83 c4 08             	add    $0x8,%esp
  802242:	50                   	push   %eax
  802243:	6a 00                	push   $0x0
  802245:	e8 dd e9 ff ff       	call   800c27 <sys_page_unmap>
}
  80224a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    
	...

00802250 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80225c:	6a 01                	push   $0x1
  80225e:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802261:	50                   	push   %eax
  802262:	e8 79 e8 ff ff       	call   800ae0 <sys_cputs>
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <getchar>:

int
getchar(void)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
  80226c:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80226f:	6a 01                	push   $0x1
  802271:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802274:	50                   	push   %eax
  802275:	6a 00                	push   $0x0
  802277:	e8 35 f3 ff ff       	call   8015b1 <read>
	if (r < 0)
  80227c:	83 c4 10             	add    $0x10,%esp
		return r;
  80227f:	89 c2                	mov    %eax,%edx
  802281:	85 c0                	test   %eax,%eax
  802283:	78 0d                	js     802292 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  802285:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  80228a:	85 c0                	test   %eax,%eax
  80228c:	7e 04                	jle    802292 <getchar+0x29>
	return c;
  80228e:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  802292:	89 d0                	mov    %edx,%eax
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <iscons>:


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
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80229c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80229f:	50                   	push   %eax
  8022a0:	ff 75 08             	pushl  0x8(%ebp)
  8022a3:	e8 76 f0 ff ff       	call   80131e <fd_lookup>
  8022a8:	83 c4 10             	add    $0x10,%esp
		return r;
  8022ab:	89 c2                	mov    %eax,%edx
  8022ad:	85 c0                	test   %eax,%eax
  8022af:	78 11                	js     8022c2 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  8022b1:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8022b4:	8b 00                	mov    (%eax),%eax
  8022b6:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  8022bc:	0f 94 c0             	sete   %al
  8022bf:	0f b6 d0             	movzbl %al,%edx
}
  8022c2:	89 d0                	mov    %edx,%eax
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <opencons>:

int
opencons(void)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022cc:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8022cf:	50                   	push   %eax
  8022d0:	e8 ef ef ff ff       	call   8012c4 <fd_alloc>
  8022d5:	83 c4 10             	add    $0x10,%esp
		return r;
  8022d8:	89 c2                	mov    %eax,%edx
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	78 3c                	js     80231a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022de:	83 ec 04             	sub    $0x4,%esp
  8022e1:	68 07 04 00 00       	push   $0x407
  8022e6:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8022e9:	6a 00                	push   $0x0
  8022eb:	e8 b2 e8 ff ff       	call   800ba2 <sys_page_alloc>
  8022f0:	83 c4 10             	add    $0x10,%esp
		return r;
  8022f3:	89 c2                	mov    %eax,%edx
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	78 21                	js     80231a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8022f9:	a1 60 60 80 00       	mov    0x806060,%eax
  8022fe:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  802301:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  802303:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802306:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80230d:	83 ec 0c             	sub    $0xc,%esp
  802310:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802313:	e8 9c ef ff ff       	call   8012b4 <fd2num>
  802318:	89 c2                	mov    %eax,%edx
}
  80231a:	89 d0                	mov    %edx,%eax
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  802324:	b8 00 00 00 00       	mov    $0x0,%eax
  802329:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80232d:	74 2a                	je     802359 <cons_read+0x3b>
  80232f:	eb 05                	jmp    802336 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802331:	e8 4d e8 ff ff       	call   800b83 <sys_yield>
  802336:	e8 c9 e7 ff ff       	call   800b04 <sys_cgetc>
  80233b:	89 c2                	mov    %eax,%edx
  80233d:	85 c0                	test   %eax,%eax
  80233f:	74 f0                	je     802331 <cons_read+0x13>
	if (c < 0)
  802341:	85 d2                	test   %edx,%edx
  802343:	78 14                	js     802359 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802345:	b8 00 00 00 00       	mov    $0x0,%eax
  80234a:	83 fa 04             	cmp    $0x4,%edx
  80234d:	74 0a                	je     802359 <cons_read+0x3b>
	*(char*)vbuf = c;
  80234f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802352:	88 10                	mov    %dl,(%eax)
	return 1;
  802354:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802359:	c9                   	leave  
  80235a:	c3                   	ret    

0080235b <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	57                   	push   %edi
  80235f:	56                   	push   %esi
  802360:	53                   	push   %ebx
  802361:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  802367:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80236a:	be 00 00 00 00       	mov    $0x0,%esi
  80236f:	39 fe                	cmp    %edi,%esi
  802371:	73 3d                	jae    8023b0 <cons_write+0x55>
		m = n - tot;
  802373:	89 fb                	mov    %edi,%ebx
  802375:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  802377:	83 fb 7f             	cmp    $0x7f,%ebx
  80237a:	76 05                	jbe    802381 <cons_write+0x26>
			m = sizeof(buf) - 1;
  80237c:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802381:	83 ec 04             	sub    $0x4,%esp
  802384:	53                   	push   %ebx
  802385:	8b 45 0c             	mov    0xc(%ebp),%eax
  802388:	01 f0                	add    %esi,%eax
  80238a:	50                   	push   %eax
  80238b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802391:	50                   	push   %eax
  802392:	e8 b5 e5 ff ff       	call   80094c <memmove>
		sys_cputs(buf, m);
  802397:	83 c4 08             	add    $0x8,%esp
  80239a:	53                   	push   %ebx
  80239b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8023a1:	50                   	push   %eax
  8023a2:	e8 39 e7 ff ff       	call   800ae0 <sys_cputs>
  8023a7:	83 c4 10             	add    $0x10,%esp
  8023aa:	01 de                	add    %ebx,%esi
  8023ac:	39 fe                	cmp    %edi,%esi
  8023ae:	72 c3                	jb     802373 <cons_write+0x18>
	}
	return tot;
}
  8023b0:	89 f0                	mov    %esi,%eax
  8023b2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8023b5:	5b                   	pop    %ebx
  8023b6:	5e                   	pop    %esi
  8023b7:	5f                   	pop    %edi
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <cons_close>:

int
cons_close(struct Fd *fd)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8023ca:	68 d7 2e 80 00       	push   $0x802ed7
  8023cf:	ff 75 0c             	pushl  0xc(%ebp)
  8023d2:	e8 f9 e3 ff ff       	call   8007d0 <strcpy>
	return 0;
}
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    
	...

008023e0 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	53                   	push   %ebx
  8023e4:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  8023e7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  8023ea:	83 3d 84 60 80 00 00 	cmpl   $0x0,0x806084
  8023f1:	74 16                	je     802409 <_panic+0x29>
		cprintf("%s: ", argv0);
  8023f3:	83 ec 08             	sub    $0x8,%esp
  8023f6:	ff 35 84 60 80 00    	pushl  0x806084
  8023fc:	68 de 2e 80 00       	push   $0x802ede
  802401:	e8 c6 dd ff ff       	call   8001cc <cprintf>
  802406:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802409:	ff 75 0c             	pushl  0xc(%ebp)
  80240c:	ff 75 08             	pushl  0x8(%ebp)
  80240f:	ff 35 00 60 80 00    	pushl  0x806000
  802415:	68 e3 2e 80 00       	push   $0x802ee3
  80241a:	e8 ad dd ff ff       	call   8001cc <cprintf>
	vcprintf(fmt, ap);
  80241f:	83 c4 08             	add    $0x8,%esp
  802422:	53                   	push   %ebx
  802423:	ff 75 10             	pushl  0x10(%ebp)
  802426:	e8 50 dd ff ff       	call   80017b <vcprintf>
	cprintf("\n");
  80242b:	c7 04 24 d4 28 80 00 	movl   $0x8028d4,(%esp)
  802432:	e8 95 dd ff ff       	call   8001cc <cprintf>

	// Cause a breakpoint exception
	while (1)
  802437:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  80243a:	cc                   	int3   
  80243b:	eb fd                	jmp    80243a <_panic+0x5a>
  80243d:	00 00                	add    %al,(%eax)
	...

00802440 <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802446:	83 3d 88 60 80 00 00 	cmpl   $0x0,0x806088
  80244d:	75 68                	jne    8024b7 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  80244f:	83 ec 04             	sub    $0x4,%esp
  802452:	6a 07                	push   $0x7
  802454:	68 00 f0 bf ee       	push   $0xeebff000
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	e8 03 e7 ff ff       	call   800b64 <sys_getenvid>
  802461:	89 04 24             	mov    %eax,(%esp)
  802464:	e8 39 e7 ff ff       	call   800ba2 <sys_page_alloc>
  802469:	83 c4 10             	add    $0x10,%esp
  80246c:	85 c0                	test   %eax,%eax
  80246e:	79 14                	jns    802484 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  802470:	83 ec 04             	sub    $0x4,%esp
  802473:	68 00 2f 80 00       	push   $0x802f00
  802478:	6a 21                	push   $0x21
  80247a:	68 61 2f 80 00       	push   $0x802f61
  80247f:	e8 5c ff ff ff       	call   8023e0 <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  802484:	83 ec 08             	sub    $0x8,%esp
  802487:	68 c4 24 80 00       	push   $0x8024c4
  80248c:	83 ec 04             	sub    $0x4,%esp
  80248f:	e8 d0 e6 ff ff       	call   800b64 <sys_getenvid>
  802494:	89 04 24             	mov    %eax,(%esp)
  802497:	e8 51 e8 ff ff       	call   800ced <sys_env_set_pgfault_upcall>
  80249c:	83 c4 10             	add    $0x10,%esp
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	79 14                	jns    8024b7 <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  8024a3:	83 ec 04             	sub    $0x4,%esp
  8024a6:	68 30 2f 80 00       	push   $0x802f30
  8024ab:	6a 24                	push   $0x24
  8024ad:	68 61 2f 80 00       	push   $0x802f61
  8024b2:	e8 29 ff ff ff       	call   8023e0 <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	a3 88 60 80 00       	mov    %eax,0x806088
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    
  8024c1:	00 00                	add    %al,(%eax)
	...

008024c4 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8024c4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8024c5:	a1 88 60 80 00       	mov    0x806088,%eax
	call *%eax
  8024ca:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8024cc:	83 c4 04             	add    $0x4,%esp
	
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
  8024cf:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  8024d3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  8024d7:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  8024da:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  8024dd:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  8024e0:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  8024e4:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  8024e7:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  8024eb:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  8024ec:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  8024ef:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  8024f0:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  8024f1:	c3                   	ret    
	...

008024f4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	56                   	push   %esi
  8024f8:	53                   	push   %ebx
  8024f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8024fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ff:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  802502:	85 c0                	test   %eax,%eax
  802504:	75 12                	jne    802518 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  802506:	83 ec 0c             	sub    $0xc,%esp
  802509:	68 00 00 c0 ee       	push   $0xeec00000
  80250e:	e8 3f e8 ff ff       	call   800d52 <sys_ipc_recv>
  802513:	83 c4 10             	add    $0x10,%esp
  802516:	eb 0c                	jmp    802524 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802518:	83 ec 0c             	sub    $0xc,%esp
  80251b:	50                   	push   %eax
  80251c:	e8 31 e8 ff ff       	call   800d52 <sys_ipc_recv>
  802521:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802524:	89 c2                	mov    %eax,%edx
  802526:	85 c0                	test   %eax,%eax
  802528:	78 24                	js     80254e <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  80252a:	85 db                	test   %ebx,%ebx
  80252c:	74 0a                	je     802538 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  80252e:	a1 80 60 80 00       	mov    0x806080,%eax
  802533:	8b 40 74             	mov    0x74(%eax),%eax
  802536:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802538:	85 f6                	test   %esi,%esi
  80253a:	74 0a                	je     802546 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  80253c:	a1 80 60 80 00       	mov    0x806080,%eax
  802541:	8b 40 78             	mov    0x78(%eax),%eax
  802544:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  802546:	a1 80 60 80 00       	mov    0x806080,%eax
  80254b:	8b 50 70             	mov    0x70(%eax),%edx

}
  80254e:	89 d0                	mov    %edx,%eax
  802550:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802553:	5b                   	pop    %ebx
  802554:	5e                   	pop    %esi
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <ipc_send>:

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
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	57                   	push   %edi
  80255b:	56                   	push   %esi
  80255c:	53                   	push   %ebx
  80255d:	83 ec 0c             	sub    $0xc,%esp
  802560:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802563:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802566:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802569:	85 db                	test   %ebx,%ebx
  80256b:	75 0a                	jne    802577 <ipc_send+0x20>
    pg = (void *) UTOP;
  80256d:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  802572:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  802577:	56                   	push   %esi
  802578:	53                   	push   %ebx
  802579:	57                   	push   %edi
  80257a:	ff 75 08             	pushl  0x8(%ebp)
  80257d:	e8 ad e7 ff ff       	call   800d2f <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  802582:	83 c4 10             	add    $0x10,%esp
  802585:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802588:	75 07                	jne    802591 <ipc_send+0x3a>
      sys_yield();
  80258a:	e8 f4 e5 ff ff       	call   800b83 <sys_yield>
  80258f:	eb e6                	jmp    802577 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  802591:	85 c0                	test   %eax,%eax
  802593:	79 12                	jns    8025a7 <ipc_send+0x50>
  802595:	50                   	push   %eax
  802596:	68 6f 2f 80 00       	push   $0x802f6f
  80259b:	6a 49                	push   $0x49
  80259d:	68 8c 2f 80 00       	push   $0x802f8c
  8025a2:	e8 39 fe ff ff       	call   8023e0 <_panic>
    else break;
  }
}
  8025a7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8025aa:	5b                   	pop    %ebx
  8025ab:	5e                   	pop    %esi
  8025ac:	5f                   	pop    %edi
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    
	...

008025b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8025b6:	89 c8                	mov    %ecx,%eax
  8025b8:	c1 e8 16             	shr    $0x16,%eax
  8025bb:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8025c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025c7:	a8 01                	test   $0x1,%al
  8025c9:	74 28                	je     8025f3 <pageref+0x43>
	pte = vpt[VPN(v)];
  8025cb:	89 c8                	mov    %ecx,%eax
  8025cd:	c1 e8 0c             	shr    $0xc,%eax
  8025d0:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  8025d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8025dc:	a8 01                	test   $0x1,%al
  8025de:	74 13                	je     8025f3 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  8025e0:	c1 e8 0c             	shr    $0xc,%eax
  8025e3:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8025e6:	c1 e0 02             	shl    $0x2,%eax
  8025e9:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  8025f0:	0f b7 d0             	movzwl %ax,%edx
}
  8025f3:	89 d0                	mov    %edx,%eax
  8025f5:	c9                   	leave  
  8025f6:	c3                   	ret    
	...

008025f8 <__udivdi3>:
  8025f8:	55                   	push   %ebp
  8025f9:	89 e5                	mov    %esp,%ebp
  8025fb:	57                   	push   %edi
  8025fc:	56                   	push   %esi
  8025fd:	83 ec 14             	sub    $0x14,%esp
  802600:	8b 55 14             	mov    0x14(%ebp),%edx
  802603:	8b 75 08             	mov    0x8(%ebp),%esi
  802606:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802609:	8b 45 10             	mov    0x10(%ebp),%eax
  80260c:	85 d2                	test   %edx,%edx
  80260e:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802611:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802614:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802617:	89 fe                	mov    %edi,%esi
  802619:	75 11                	jne    80262c <__udivdi3+0x34>
  80261b:	39 f8                	cmp    %edi,%eax
  80261d:	76 4d                	jbe    80266c <__udivdi3+0x74>
  80261f:	89 fa                	mov    %edi,%edx
  802621:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802624:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802627:	89 c7                	mov    %eax,%edi
  802629:	eb 09                	jmp    802634 <__udivdi3+0x3c>
  80262b:	90                   	nop    
  80262c:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  80262f:	76 17                	jbe    802648 <__udivdi3+0x50>
  802631:	31 ff                	xor    %edi,%edi
  802633:	90                   	nop    
  802634:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  80263b:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  80263e:	83 c4 14             	add    $0x14,%esp
  802641:	5e                   	pop    %esi
  802642:	89 f8                	mov    %edi,%eax
  802644:	5f                   	pop    %edi
  802645:	c9                   	leave  
  802646:	c3                   	ret    
  802647:	90                   	nop    
  802648:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  80264c:	89 c7                	mov    %eax,%edi
  80264e:	83 f7 1f             	xor    $0x1f,%edi
  802651:	75 4d                	jne    8026a0 <__udivdi3+0xa8>
  802653:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802656:	77 0a                	ja     802662 <__udivdi3+0x6a>
  802658:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80265b:	31 ff                	xor    %edi,%edi
  80265d:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802660:	72 d2                	jb     802634 <__udivdi3+0x3c>
  802662:	bf 01 00 00 00       	mov    $0x1,%edi
  802667:	eb cb                	jmp    802634 <__udivdi3+0x3c>
  802669:	8d 76 00             	lea    0x0(%esi),%esi
  80266c:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	75 0e                	jne    802681 <__udivdi3+0x89>
  802673:	b8 01 00 00 00       	mov    $0x1,%eax
  802678:	31 c9                	xor    %ecx,%ecx
  80267a:	31 d2                	xor    %edx,%edx
  80267c:	f7 f1                	div    %ecx
  80267e:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802681:	89 f0                	mov    %esi,%eax
  802683:	31 d2                	xor    %edx,%edx
  802685:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802688:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80268b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80268e:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802691:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802694:	83 c4 14             	add    $0x14,%esp
  802697:	89 c7                	mov    %eax,%edi
  802699:	5e                   	pop    %esi
  80269a:	89 f8                	mov    %edi,%eax
  80269c:	5f                   	pop    %edi
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    
  80269f:	90                   	nop    
  8026a0:	b8 20 00 00 00       	mov    $0x20,%eax
  8026a5:	29 f8                	sub    %edi,%eax
  8026a7:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  8026aa:	89 f9                	mov    %edi,%ecx
  8026ac:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8026af:	d3 e2                	shl    %cl,%edx
  8026b1:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8026b4:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8026b7:	d3 e8                	shr    %cl,%eax
  8026b9:	09 c2                	or     %eax,%edx
  8026bb:	89 f9                	mov    %edi,%ecx
  8026bd:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8026c0:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8026c3:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8026c6:	89 f2                	mov    %esi,%edx
  8026c8:	d3 ea                	shr    %cl,%edx
  8026ca:	89 f9                	mov    %edi,%ecx
  8026cc:	d3 e6                	shl    %cl,%esi
  8026ce:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8026d1:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8026d4:	d3 e8                	shr    %cl,%eax
  8026d6:	09 c6                	or     %eax,%esi
  8026d8:	89 f9                	mov    %edi,%ecx
  8026da:	89 f0                	mov    %esi,%eax
  8026dc:	f7 75 f4             	divl   0xfffffff4(%ebp)
  8026df:	89 d6                	mov    %edx,%esi
  8026e1:	89 c7                	mov    %eax,%edi
  8026e3:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8026e6:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8026e9:	f7 e7                	mul    %edi
  8026eb:	39 f2                	cmp    %esi,%edx
  8026ed:	77 0f                	ja     8026fe <__udivdi3+0x106>
  8026ef:	0f 85 3f ff ff ff    	jne    802634 <__udivdi3+0x3c>
  8026f5:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  8026f8:	0f 86 36 ff ff ff    	jbe    802634 <__udivdi3+0x3c>
  8026fe:	4f                   	dec    %edi
  8026ff:	e9 30 ff ff ff       	jmp    802634 <__udivdi3+0x3c>

00802704 <__umoddi3>:
  802704:	55                   	push   %ebp
  802705:	89 e5                	mov    %esp,%ebp
  802707:	57                   	push   %edi
  802708:	56                   	push   %esi
  802709:	83 ec 30             	sub    $0x30,%esp
  80270c:	8b 55 14             	mov    0x14(%ebp),%edx
  80270f:	8b 45 10             	mov    0x10(%ebp),%eax
  802712:	89 d7                	mov    %edx,%edi
  802714:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  802717:	89 c6                	mov    %eax,%esi
  802719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	85 ff                	test   %edi,%edi
  802721:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802728:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80272f:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  802732:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802735:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802738:	75 3e                	jne    802778 <__umoddi3+0x74>
  80273a:	39 d6                	cmp    %edx,%esi
  80273c:	0f 86 a2 00 00 00    	jbe    8027e4 <__umoddi3+0xe0>
  802742:	f7 f6                	div    %esi
  802744:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802747:	85 c9                	test   %ecx,%ecx
  802749:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  80274c:	74 1b                	je     802769 <__umoddi3+0x65>
  80274e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802751:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802754:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80275b:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80275e:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802761:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802764:	89 10                	mov    %edx,(%eax)
  802766:	89 48 04             	mov    %ecx,0x4(%eax)
  802769:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80276c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80276f:	83 c4 30             	add    $0x30,%esp
  802772:	5e                   	pop    %esi
  802773:	5f                   	pop    %edi
  802774:	c9                   	leave  
  802775:	c3                   	ret    
  802776:	89 f6                	mov    %esi,%esi
  802778:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  80277b:	76 1f                	jbe    80279c <__umoddi3+0x98>
  80277d:	8b 55 08             	mov    0x8(%ebp),%edx
  802780:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802783:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802786:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802789:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80278c:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80278f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  802792:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802795:	83 c4 30             	add    $0x30,%esp
  802798:	5e                   	pop    %esi
  802799:	5f                   	pop    %edi
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    
  80279c:	0f bd c7             	bsr    %edi,%eax
  80279f:	83 f0 1f             	xor    $0x1f,%eax
  8027a2:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  8027a5:	75 61                	jne    802808 <__umoddi3+0x104>
  8027a7:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  8027aa:	77 05                	ja     8027b1 <__umoddi3+0xad>
  8027ac:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  8027af:	72 10                	jb     8027c1 <__umoddi3+0xbd>
  8027b1:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8027b4:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8027b7:	29 f0                	sub    %esi,%eax
  8027b9:	19 fa                	sbb    %edi,%edx
  8027bb:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8027be:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8027c1:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8027c4:	85 d2                	test   %edx,%edx
  8027c6:	74 a1                	je     802769 <__umoddi3+0x65>
  8027c8:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8027cb:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8027ce:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8027d1:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  8027d4:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8027d7:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8027da:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8027dd:	89 01                	mov    %eax,(%ecx)
  8027df:	89 51 04             	mov    %edx,0x4(%ecx)
  8027e2:	eb 85                	jmp    802769 <__umoddi3+0x65>
  8027e4:	85 f6                	test   %esi,%esi
  8027e6:	75 0b                	jne    8027f3 <__umoddi3+0xef>
  8027e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ed:	31 d2                	xor    %edx,%edx
  8027ef:	f7 f6                	div    %esi
  8027f1:	89 c6                	mov    %eax,%esi
  8027f3:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8027f6:	89 fa                	mov    %edi,%edx
  8027f8:	f7 f6                	div    %esi
  8027fa:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8027fd:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802800:	f7 f6                	div    %esi
  802802:	e9 3d ff ff ff       	jmp    802744 <__umoddi3+0x40>
  802807:	90                   	nop    
  802808:	b8 20 00 00 00       	mov    $0x20,%eax
  80280d:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802810:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  802813:	89 fa                	mov    %edi,%edx
  802815:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802818:	d3 e2                	shl    %cl,%edx
  80281a:	89 f0                	mov    %esi,%eax
  80281c:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80281f:	d3 e8                	shr    %cl,%eax
  802821:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802824:	d3 e6                	shl    %cl,%esi
  802826:	89 d7                	mov    %edx,%edi
  802828:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80282b:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80282e:	09 c7                	or     %eax,%edi
  802830:	d3 ea                	shr    %cl,%edx
  802832:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802835:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802838:	d3 e0                	shl    %cl,%eax
  80283a:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80283d:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802840:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802843:	d3 e8                	shr    %cl,%eax
  802845:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802848:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80284b:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80284e:	f7 f7                	div    %edi
  802850:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802853:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802856:	f7 e6                	mul    %esi
  802858:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  80285b:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  80285e:	77 0a                	ja     80286a <__umoddi3+0x166>
  802860:	75 12                	jne    802874 <__umoddi3+0x170>
  802862:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802865:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802868:	76 0a                	jbe    802874 <__umoddi3+0x170>
  80286a:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  80286d:	29 f1                	sub    %esi,%ecx
  80286f:	19 fa                	sbb    %edi,%edx
  802871:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802874:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	0f 84 ea fe ff ff    	je     802769 <__umoddi3+0x65>
  80287f:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802882:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802885:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802888:	19 d1                	sbb    %edx,%ecx
  80288a:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  80288d:	89 ca                	mov    %ecx,%edx
  80288f:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802892:	d3 e2                	shl    %cl,%edx
  802894:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802897:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80289a:	d3 e8                	shr    %cl,%eax
  80289c:	09 c2                	or     %eax,%edx
  80289e:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8028a1:	d3 e8                	shr    %cl,%eax
  8028a3:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8028a6:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8028a9:	e9 ad fe ff ff       	jmp    80275b <__umoddi3+0x57>
