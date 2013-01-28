
obj/user/num:     file format elf32-i386

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
  80002c:	e8 4b 01 00 00       	call   80017c <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <num>:
int line = 0;

void
num(int f, char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 0c             	sub    $0xc,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800043:	8d 5d f3             	lea    0xfffffff3(%ebp),%ebx
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800046:	eb 6c                	jmp    8000b4 <num+0x80>
		if (bol) {
  800048:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80004f:	74 28                	je     800079 <num+0x45>
			fprintf(1, "%5d ", ++line);
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	a1 80 60 80 00       	mov    0x806080,%eax
  800059:	40                   	inc    %eax
  80005a:	a3 80 60 80 00       	mov    %eax,0x806080
  80005f:	50                   	push   %eax
  800060:	68 20 26 80 00       	push   $0x802620
  800065:	6a 01                	push   $0x1
  800067:	e8 41 1b 00 00       	call   801bad <fprintf>
			bol = 0;
  80006c:	c7 05 00 60 80 00 00 	movl   $0x0,0x806000
  800073:	00 00 00 
  800076:	83 c4 10             	add    $0x10,%esp
		}
		if ((r = write(1, &c, 1)) != 1)
  800079:	83 ec 04             	sub    $0x4,%esp
  80007c:	6a 01                	push   $0x1
  80007e:	53                   	push   %ebx
  80007f:	6a 01                	push   $0x1
  800081:	e8 5e 13 00 00       	call   8013e4 <write>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	83 f8 01             	cmp    $0x1,%eax
  80008c:	74 16                	je     8000a4 <num+0x70>
			panic("write error copying %s: %e", s, r);
  80008e:	83 ec 0c             	sub    $0xc,%esp
  800091:	50                   	push   %eax
  800092:	57                   	push   %edi
  800093:	68 25 26 80 00       	push   $0x802625
  800098:	6a 13                	push   $0x13
  80009a:	68 40 26 80 00       	push   $0x802640
  80009f:	e8 34 01 00 00       	call   8001d8 <_panic>
		if (c == '\n')
  8000a4:	80 7d f3 0a          	cmpb   $0xa,0xfffffff3(%ebp)
  8000a8:	75 0a                	jne    8000b4 <num+0x80>
			bol = 1;
  8000aa:	c7 05 00 60 80 00 01 	movl   $0x1,0x806000
  8000b1:	00 00 00 
  8000b4:	83 ec 04             	sub    $0x4,%esp
  8000b7:	6a 01                	push   $0x1
  8000b9:	53                   	push   %ebx
  8000ba:	56                   	push   %esi
  8000bb:	e8 4d 12 00 00       	call   80130d <read>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	7f 81                	jg     800048 <num+0x14>
	}
	if (n < 0)
  8000c7:	85 c0                	test   %eax,%eax
  8000c9:	79 16                	jns    8000e1 <num+0xad>
		panic("error reading %s: %e", s, n);
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	50                   	push   %eax
  8000cf:	57                   	push   %edi
  8000d0:	68 4b 26 80 00       	push   $0x80264b
  8000d5:	6a 18                	push   $0x18
  8000d7:	68 40 26 80 00       	push   $0x802640
  8000dc:	e8 f7 00 00 00       	call   8001d8 <_panic>
}
  8000e1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	c9                   	leave  
  8000e8:	c3                   	ret    

008000e9 <umain>:

void
umain(int argc, char **argv)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	argv0 = "num";
  8000f5:	c7 05 88 60 80 00 60 	movl   $0x802660,0x806088
  8000fc:	26 80 00 
	if (argc == 1)
  8000ff:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800103:	75 14                	jne    800119 <umain+0x30>
		num(0, "<stdin>");
  800105:	83 ec 08             	sub    $0x8,%esp
  800108:	68 64 26 80 00       	push   $0x802664
  80010d:	6a 00                	push   $0x0
  80010f:	e8 20 ff ff ff       	call   800034 <num>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	eb 55                	jmp    80016e <umain+0x85>
	else
		for (i = 1; i < argc; i++) {
  800119:	be 01 00 00 00       	mov    $0x1,%esi
  80011e:	3b 75 08             	cmp    0x8(%ebp),%esi
  800121:	7d 4b                	jge    80016e <umain+0x85>
			f = open(argv[i], O_RDONLY);
  800123:	83 ec 08             	sub    $0x8,%esp
  800126:	6a 00                	push   $0x0
  800128:	ff 34 b7             	pushl  (%edi,%esi,4)
  80012b:	e8 78 14 00 00       	call   8015a8 <open>
  800130:	89 c3                	mov    %eax,%ebx
			if (f < 0)
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	85 c0                	test   %eax,%eax
  800137:	79 18                	jns    800151 <umain+0x68>
				panic("can't open %s: %e", argv[i], f);
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	50                   	push   %eax
  80013d:	ff 34 b7             	pushl  (%edi,%esi,4)
  800140:	68 6c 26 80 00       	push   $0x80266c
  800145:	6a 27                	push   $0x27
  800147:	68 40 26 80 00       	push   $0x802640
  80014c:	e8 87 00 00 00       	call   8001d8 <_panic>
			else {
				num(f, argv[i]);
  800151:	83 ec 08             	sub    $0x8,%esp
  800154:	ff 34 b7             	pushl  (%edi,%esi,4)
  800157:	50                   	push   %eax
  800158:	e8 d7 fe ff ff       	call   800034 <num>
				close(f);
  80015d:	89 1c 24             	mov    %ebx,(%esp)
  800160:	e8 35 10 00 00       	call   80119a <close>
  800165:	83 c4 10             	add    $0x10,%esp
  800168:	46                   	inc    %esi
  800169:	3b 75 08             	cmp    0x8(%ebp),%esi
  80016c:	7c b5                	jl     800123 <umain+0x3a>
			}
		}
	exit();
  80016e:	e8 4d 00 00 00       	call   8001c0 <exit>
}
  800173:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5f                   	pop    %edi
  800179:	c9                   	leave  
  80017a:	c3                   	ret    
	...

0080017c <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	56                   	push   %esi
  800180:	53                   	push   %ebx
  800181:	8b 75 08             	mov    0x8(%ebp),%esi
  800184:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  800187:	e8 d4 0a 00 00       	call   800c60 <sys_getenvid>
  80018c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800191:	c1 e0 07             	shl    $0x7,%eax
  800194:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800199:	a3 84 60 80 00       	mov    %eax,0x806084

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019e:	85 f6                	test   %esi,%esi
  8001a0:	7e 07                	jle    8001a9 <libmain+0x2d>
		binaryname = argv[0];
  8001a2:	8b 03                	mov    (%ebx),%eax
  8001a4:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	umain(argc, argv);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	53                   	push   %ebx
  8001ad:	56                   	push   %esi
  8001ae:	e8 36 ff ff ff       	call   8000e9 <umain>

	// exit gracefully
	exit();
  8001b3:	e8 08 00 00 00       	call   8001c0 <exit>
}
  8001b8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8001bb:	5b                   	pop    %ebx
  8001bc:	5e                   	pop    %esi
  8001bd:	c9                   	leave  
  8001be:	c3                   	ret    
	...

008001c0 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001c6:	e8 fd 0f 00 00       	call   8011c8 <close_all>
	sys_env_destroy(0);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	6a 00                	push   $0x0
  8001d0:	e8 4a 0a 00 00       	call   800c1f <sys_env_destroy>
}
  8001d5:	c9                   	leave  
  8001d6:	c3                   	ret    
	...

008001d8 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001d8:	55                   	push   %ebp
  8001d9:	89 e5                	mov    %esp,%ebp
  8001db:	53                   	push   %ebx
  8001dc:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  8001df:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  8001e2:	83 3d 88 60 80 00 00 	cmpl   $0x0,0x806088
  8001e9:	74 16                	je     800201 <_panic+0x29>
		cprintf("%s: ", argv0);
  8001eb:	83 ec 08             	sub    $0x8,%esp
  8001ee:	ff 35 88 60 80 00    	pushl  0x806088
  8001f4:	68 95 26 80 00       	push   $0x802695
  8001f9:	e8 ca 00 00 00       	call   8002c8 <cprintf>
  8001fe:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800201:	ff 75 0c             	pushl  0xc(%ebp)
  800204:	ff 75 08             	pushl  0x8(%ebp)
  800207:	ff 35 04 60 80 00    	pushl  0x806004
  80020d:	68 9a 26 80 00       	push   $0x80269a
  800212:	e8 b1 00 00 00       	call   8002c8 <cprintf>
	vcprintf(fmt, ap);
  800217:	83 c4 08             	add    $0x8,%esp
  80021a:	53                   	push   %ebx
  80021b:	ff 75 10             	pushl  0x10(%ebp)
  80021e:	e8 54 00 00 00       	call   800277 <vcprintf>
	cprintf("\n");
  800223:	c7 04 24 89 2b 80 00 	movl   $0x802b89,(%esp)
  80022a:	e8 99 00 00 00       	call   8002c8 <cprintf>

	// Cause a breakpoint exception
	while (1)
  80022f:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  800232:	cc                   	int3   
  800233:	eb fd                	jmp    800232 <_panic+0x5a>
  800235:	00 00                	add    %al,(%eax)
	...

00800238 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	53                   	push   %ebx
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800242:	8b 03                	mov    (%ebx),%eax
  800244:	8b 55 08             	mov    0x8(%ebp),%edx
  800247:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  80024b:	40                   	inc    %eax
  80024c:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80024e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800253:	75 1a                	jne    80026f <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	68 ff 00 00 00       	push   $0xff
  80025d:	8d 43 08             	lea    0x8(%ebx),%eax
  800260:	50                   	push   %eax
  800261:	e8 76 09 00 00       	call   800bdc <sys_cputs>
		b->idx = 0;
  800266:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80026c:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80026f:	ff 43 04             	incl   0x4(%ebx)
}
  800272:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800280:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  800287:	00 00 00 
	b.cnt = 0;
  80028a:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800291:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800294:	ff 75 0c             	pushl  0xc(%ebp)
  800297:	ff 75 08             	pushl  0x8(%ebp)
  80029a:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  8002a0:	50                   	push   %eax
  8002a1:	68 38 02 80 00       	push   $0x800238
  8002a6:	e8 4f 01 00 00       	call   8003fa <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ab:	83 c4 08             	add    $0x8,%esp
  8002ae:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  8002b4:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	e8 1c 09 00 00       	call   800bdc <sys_cputs>

	return b.cnt;
  8002c0:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ce:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d1:	50                   	push   %eax
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 9d ff ff ff       	call   800277 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002da:	c9                   	leave  
  8002db:	c3                   	ret    

008002dc <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	57                   	push   %edi
  8002e0:	56                   	push   %esi
  8002e1:	53                   	push   %ebx
  8002e2:	83 ec 0c             	sub    $0xc,%esp
  8002e5:	8b 75 10             	mov    0x10(%ebp),%esi
  8002e8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002eb:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002ee:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f6:	39 fa                	cmp    %edi,%edx
  8002f8:	77 39                	ja     800333 <printnum+0x57>
  8002fa:	72 04                	jb     800300 <printnum+0x24>
  8002fc:	39 f0                	cmp    %esi,%eax
  8002fe:	77 33                	ja     800333 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800300:	83 ec 04             	sub    $0x4,%esp
  800303:	ff 75 20             	pushl  0x20(%ebp)
  800306:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  800309:	50                   	push   %eax
  80030a:	ff 75 18             	pushl  0x18(%ebp)
  80030d:	8b 45 18             	mov    0x18(%ebp),%eax
  800310:	ba 00 00 00 00       	mov    $0x0,%edx
  800315:	52                   	push   %edx
  800316:	50                   	push   %eax
  800317:	57                   	push   %edi
  800318:	56                   	push   %esi
  800319:	e8 3e 20 00 00       	call   80235c <__udivdi3>
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	52                   	push   %edx
  800322:	50                   	push   %eax
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 ae ff ff ff       	call   8002dc <printnum>
  80032e:	83 c4 20             	add    $0x20,%esp
  800331:	eb 19                	jmp    80034c <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800333:	4b                   	dec    %ebx
  800334:	85 db                	test   %ebx,%ebx
  800336:	7e 14                	jle    80034c <printnum+0x70>
  800338:	83 ec 08             	sub    $0x8,%esp
  80033b:	ff 75 0c             	pushl  0xc(%ebp)
  80033e:	ff 75 20             	pushl  0x20(%ebp)
  800341:	ff 55 08             	call   *0x8(%ebp)
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	4b                   	dec    %ebx
  800348:	85 db                	test   %ebx,%ebx
  80034a:	7f ec                	jg     800338 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034c:	83 ec 08             	sub    $0x8,%esp
  80034f:	ff 75 0c             	pushl  0xc(%ebp)
  800352:	8b 45 18             	mov    0x18(%ebp),%eax
  800355:	ba 00 00 00 00       	mov    $0x0,%edx
  80035a:	83 ec 04             	sub    $0x4,%esp
  80035d:	52                   	push   %edx
  80035e:	50                   	push   %eax
  80035f:	57                   	push   %edi
  800360:	56                   	push   %esi
  800361:	e8 02 21 00 00       	call   802468 <__umoddi3>
  800366:	83 c4 14             	add    $0x14,%esp
  800369:	0f be 80 b0 27 80 00 	movsbl 0x8027b0(%eax),%eax
  800370:	50                   	push   %eax
  800371:	ff 55 08             	call   *0x8(%ebp)
}
  800374:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800377:	5b                   	pop    %ebx
  800378:	5e                   	pop    %esi
  800379:	5f                   	pop    %edi
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800382:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800385:	83 f8 01             	cmp    $0x1,%eax
  800388:	7e 0f                	jle    800399 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  80038a:	8b 01                	mov    (%ecx),%eax
  80038c:	83 c0 08             	add    $0x8,%eax
  80038f:	89 01                	mov    %eax,(%ecx)
  800391:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800394:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  800397:	eb 24                	jmp    8003bd <getuint+0x41>
	else if (lflag)
  800399:	85 c0                	test   %eax,%eax
  80039b:	74 11                	je     8003ae <getuint+0x32>
		return va_arg(*ap, unsigned long);
  80039d:	8b 01                	mov    (%ecx),%eax
  80039f:	83 c0 04             	add    $0x4,%eax
  8003a2:	89 01                	mov    %eax,(%ecx)
  8003a4:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ac:	eb 0f                	jmp    8003bd <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  8003ae:	8b 01                	mov    (%ecx),%eax
  8003b0:	83 c0 04             	add    $0x4,%eax
  8003b3:	89 01                	mov    %eax,(%ecx)
  8003b5:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8003c8:	83 f8 01             	cmp    $0x1,%eax
  8003cb:	7e 0f                	jle    8003dc <getint+0x1d>
		return va_arg(*ap, long long);
  8003cd:	8b 02                	mov    (%edx),%eax
  8003cf:	83 c0 08             	add    $0x8,%eax
  8003d2:	89 02                	mov    %eax,(%edx)
  8003d4:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8003d7:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8003da:	eb 1c                	jmp    8003f8 <getint+0x39>
	else if (lflag)
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	74 0d                	je     8003ed <getint+0x2e>
		return va_arg(*ap, long);
  8003e0:	8b 02                	mov    (%edx),%eax
  8003e2:	83 c0 04             	add    $0x4,%eax
  8003e5:	89 02                	mov    %eax,(%edx)
  8003e7:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003ea:	99                   	cltd   
  8003eb:	eb 0b                	jmp    8003f8 <getint+0x39>
	else
		return va_arg(*ap, int);
  8003ed:	8b 02                	mov    (%edx),%eax
  8003ef:	83 c0 04             	add    $0x4,%eax
  8003f2:	89 02                	mov    %eax,(%edx)
  8003f4:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003f7:	99                   	cltd   
}
  8003f8:	c9                   	leave  
  8003f9:	c3                   	ret    

008003fa <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	57                   	push   %edi
  8003fe:	56                   	push   %esi
  8003ff:	53                   	push   %ebx
  800400:	83 ec 1c             	sub    $0x1c,%esp
  800403:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  800406:	0f b6 13             	movzbl (%ebx),%edx
  800409:	43                   	inc    %ebx
  80040a:	83 fa 25             	cmp    $0x25,%edx
  80040d:	74 1e                	je     80042d <vprintfmt+0x33>
  80040f:	85 d2                	test   %edx,%edx
  800411:	0f 84 d7 02 00 00    	je     8006ee <vprintfmt+0x2f4>
  800417:	83 ec 08             	sub    $0x8,%esp
  80041a:	ff 75 0c             	pushl  0xc(%ebp)
  80041d:	52                   	push   %edx
  80041e:	ff 55 08             	call   *0x8(%ebp)
  800421:	83 c4 10             	add    $0x10,%esp
  800424:	0f b6 13             	movzbl (%ebx),%edx
  800427:	43                   	inc    %ebx
  800428:	83 fa 25             	cmp    $0x25,%edx
  80042b:	75 e2                	jne    80040f <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  80042d:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  800431:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  800438:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  80043d:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  800442:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800449:	0f b6 13             	movzbl (%ebx),%edx
  80044c:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  80044f:	43                   	inc    %ebx
  800450:	83 f8 55             	cmp    $0x55,%eax
  800453:	0f 87 70 02 00 00    	ja     8006c9 <vprintfmt+0x2cf>
  800459:	ff 24 85 3c 28 80 00 	jmp    *0x80283c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800460:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  800464:	eb e3                	jmp    800449 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800466:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  80046a:	eb dd                	jmp    800449 <vprintfmt+0x4f>

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
  80046c:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800471:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  800474:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  800478:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80047b:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  80047e:	83 f8 09             	cmp    $0x9,%eax
  800481:	77 27                	ja     8004aa <vprintfmt+0xb0>
  800483:	43                   	inc    %ebx
  800484:	eb eb                	jmp    800471 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800486:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80048a:	8b 45 14             	mov    0x14(%ebp),%eax
  80048d:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800490:	eb 18                	jmp    8004aa <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  800492:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800496:	79 b1                	jns    800449 <vprintfmt+0x4f>
				width = 0;
  800498:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  80049f:	eb a8                	jmp    800449 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  8004a1:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  8004a8:	eb 9f                	jmp    800449 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  8004aa:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004ae:	79 99                	jns    800449 <vprintfmt+0x4f>
				width = precision, precision = -1;
  8004b0:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8004b3:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  8004b8:	eb 8f                	jmp    800449 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004ba:	41                   	inc    %ecx
			goto reswitch;
  8004bb:	eb 8c                	jmp    800449 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004bd:	83 ec 08             	sub    $0x8,%esp
  8004c0:	ff 75 0c             	pushl  0xc(%ebp)
  8004c3:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ca:	ff 70 fc             	pushl  0xfffffffc(%eax)
  8004cd:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004d0:	83 c4 10             	add    $0x10,%esp
  8004d3:	e9 2e ff ff ff       	jmp    800406 <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004d8:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004df:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  8004e2:	85 c0                	test   %eax,%eax
  8004e4:	79 02                	jns    8004e8 <vprintfmt+0xee>
				err = -err;
  8004e6:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004e8:	83 f8 0e             	cmp    $0xe,%eax
  8004eb:	7f 0b                	jg     8004f8 <vprintfmt+0xfe>
  8004ed:	8b 3c 85 00 28 80 00 	mov    0x802800(,%eax,4),%edi
  8004f4:	85 ff                	test   %edi,%edi
  8004f6:	75 19                	jne    800511 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8004f8:	50                   	push   %eax
  8004f9:	68 c1 27 80 00       	push   $0x8027c1
  8004fe:	ff 75 0c             	pushl  0xc(%ebp)
  800501:	ff 75 08             	pushl  0x8(%ebp)
  800504:	e8 ed 01 00 00       	call   8006f6 <printfmt>
  800509:	83 c4 10             	add    $0x10,%esp
  80050c:	e9 f5 fe ff ff       	jmp    800406 <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800511:	57                   	push   %edi
  800512:	68 41 2b 80 00       	push   $0x802b41
  800517:	ff 75 0c             	pushl  0xc(%ebp)
  80051a:	ff 75 08             	pushl  0x8(%ebp)
  80051d:	e8 d4 01 00 00       	call   8006f6 <printfmt>
  800522:	83 c4 10             	add    $0x10,%esp
			break;
  800525:	e9 dc fe ff ff       	jmp    800406 <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80052a:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80052e:	8b 45 14             	mov    0x14(%ebp),%eax
  800531:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  800534:	85 ff                	test   %edi,%edi
  800536:	75 05                	jne    80053d <vprintfmt+0x143>
				p = "(null)";
  800538:	bf ca 27 80 00       	mov    $0x8027ca,%edi
			if (width > 0 && padc != '-')
  80053d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800541:	7e 3b                	jle    80057e <vprintfmt+0x184>
  800543:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  800547:	74 35                	je     80057e <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	56                   	push   %esi
  80054d:	57                   	push   %edi
  80054e:	e8 56 03 00 00       	call   8008a9 <strnlen>
  800553:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80055d:	7e 1f                	jle    80057e <vprintfmt+0x184>
  80055f:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800563:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 0c             	pushl  0xc(%ebp)
  80056c:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  80056f:	ff 55 08             	call   *0x8(%ebp)
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800578:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80057c:	7f e8                	jg     800566 <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80057e:	0f be 17             	movsbl (%edi),%edx
  800581:	47                   	inc    %edi
  800582:	85 d2                	test   %edx,%edx
  800584:	74 44                	je     8005ca <vprintfmt+0x1d0>
  800586:	85 f6                	test   %esi,%esi
  800588:	78 03                	js     80058d <vprintfmt+0x193>
  80058a:	4e                   	dec    %esi
  80058b:	78 3d                	js     8005ca <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  80058d:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800591:	74 18                	je     8005ab <vprintfmt+0x1b1>
  800593:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  800596:	83 f8 5e             	cmp    $0x5e,%eax
  800599:	76 10                	jbe    8005ab <vprintfmt+0x1b1>
					putch('?', putdat);
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 0c             	pushl  0xc(%ebp)
  8005a1:	6a 3f                	push   $0x3f
  8005a3:	ff 55 08             	call   *0x8(%ebp)
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	eb 0d                	jmp    8005b8 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 0c             	pushl  0xc(%ebp)
  8005b1:	52                   	push   %edx
  8005b2:	ff 55 08             	call   *0x8(%ebp)
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8005bb:	0f be 17             	movsbl (%edi),%edx
  8005be:	47                   	inc    %edi
  8005bf:	85 d2                	test   %edx,%edx
  8005c1:	74 07                	je     8005ca <vprintfmt+0x1d0>
  8005c3:	85 f6                	test   %esi,%esi
  8005c5:	78 c6                	js     80058d <vprintfmt+0x193>
  8005c7:	4e                   	dec    %esi
  8005c8:	79 c3                	jns    80058d <vprintfmt+0x193>
			for (; width > 0; width--)
  8005ca:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005ce:	0f 8e 32 fe ff ff    	jle    800406 <vprintfmt+0xc>
				putch(' ', putdat);
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	ff 75 0c             	pushl  0xc(%ebp)
  8005da:	6a 20                	push   $0x20
  8005dc:	ff 55 08             	call   *0x8(%ebp)
  8005df:	83 c4 10             	add    $0x10,%esp
  8005e2:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8005e5:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005e9:	7f e9                	jg     8005d4 <vprintfmt+0x1da>
			break;
  8005eb:	e9 16 fe ff ff       	jmp    800406 <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005f0:	51                   	push   %ecx
  8005f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8005f4:	50                   	push   %eax
  8005f5:	e8 c5 fd ff ff       	call   8003bf <getint>
  8005fa:	89 c6                	mov    %eax,%esi
  8005fc:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8005fe:	83 c4 08             	add    $0x8,%esp
  800601:	85 d2                	test   %edx,%edx
  800603:	79 15                	jns    80061a <vprintfmt+0x220>
				putch('-', putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	6a 2d                	push   $0x2d
  80060d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800610:	f7 de                	neg    %esi
  800612:	83 d7 00             	adc    $0x0,%edi
  800615:	f7 df                	neg    %edi
  800617:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80061a:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  80061f:	eb 75                	jmp    800696 <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800621:	51                   	push   %ecx
  800622:	8d 45 14             	lea    0x14(%ebp),%eax
  800625:	50                   	push   %eax
  800626:	e8 51 fd ff ff       	call   80037c <getuint>
  80062b:	89 c6                	mov    %eax,%esi
  80062d:	89 d7                	mov    %edx,%edi
			base = 10;
  80062f:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800634:	83 c4 08             	add    $0x8,%esp
  800637:	eb 5d                	jmp    800696 <vprintfmt+0x29c>

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
  800639:	51                   	push   %ecx
  80063a:	8d 45 14             	lea    0x14(%ebp),%eax
  80063d:	50                   	push   %eax
  80063e:	e8 39 fd ff ff       	call   80037c <getuint>
  800643:	89 c6                	mov    %eax,%esi
  800645:	89 d7                	mov    %edx,%edi
			base = 8;
  800647:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  80064c:	83 c4 08             	add    $0x8,%esp
  80064f:	eb 45                	jmp    800696 <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800651:	83 ec 08             	sub    $0x8,%esp
  800654:	ff 75 0c             	pushl  0xc(%ebp)
  800657:	6a 30                	push   $0x30
  800659:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80065c:	83 c4 08             	add    $0x8,%esp
  80065f:	ff 75 0c             	pushl  0xc(%ebp)
  800662:	6a 78                	push   $0x78
  800664:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800667:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800671:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800676:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  80067b:	83 c4 10             	add    $0x10,%esp
  80067e:	eb 16                	jmp    800696 <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800680:	51                   	push   %ecx
  800681:	8d 45 14             	lea    0x14(%ebp),%eax
  800684:	50                   	push   %eax
  800685:	e8 f2 fc ff ff       	call   80037c <getuint>
  80068a:	89 c6                	mov    %eax,%esi
  80068c:	89 d7                	mov    %edx,%edi
			base = 16;
  80068e:	ba 10 00 00 00       	mov    $0x10,%edx
  800693:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  800696:	83 ec 04             	sub    $0x4,%esp
  800699:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  80069d:	50                   	push   %eax
  80069e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8006a1:	52                   	push   %edx
  8006a2:	57                   	push   %edi
  8006a3:	56                   	push   %esi
  8006a4:	ff 75 0c             	pushl  0xc(%ebp)
  8006a7:	ff 75 08             	pushl  0x8(%ebp)
  8006aa:	e8 2d fc ff ff       	call   8002dc <printnum>
			break;
  8006af:	83 c4 20             	add    $0x20,%esp
  8006b2:	e9 4f fd ff ff       	jmp    800406 <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006b7:	83 ec 08             	sub    $0x8,%esp
  8006ba:	ff 75 0c             	pushl  0xc(%ebp)
  8006bd:	52                   	push   %edx
  8006be:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006c1:	83 c4 10             	add    $0x10,%esp
  8006c4:	e9 3d fd ff ff       	jmp    800406 <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	6a 25                	push   $0x25
  8006d1:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d4:	4b                   	dec    %ebx
  8006d5:	83 c4 10             	add    $0x10,%esp
  8006d8:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8006dc:	0f 84 24 fd ff ff    	je     800406 <vprintfmt+0xc>
  8006e2:	4b                   	dec    %ebx
  8006e3:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8006e7:	75 f9                	jne    8006e2 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8006e9:	e9 18 fd ff ff       	jmp    800406 <vprintfmt+0xc>
		}
	}
}
  8006ee:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8006f1:	5b                   	pop    %ebx
  8006f2:	5e                   	pop    %esi
  8006f3:	5f                   	pop    %edi
  8006f4:	c9                   	leave  
  8006f5:	c3                   	ret    

008006f6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8006fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006ff:	50                   	push   %eax
  800700:	ff 75 10             	pushl  0x10(%ebp)
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	ff 75 08             	pushl  0x8(%ebp)
  800709:	e8 ec fc ff ff       	call   8003fa <vprintfmt>
	va_end(ap);
}
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  800716:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  800719:	8b 0a                	mov    (%edx),%ecx
  80071b:	3b 4a 04             	cmp    0x4(%edx),%ecx
  80071e:	73 07                	jae    800727 <sprintputch+0x17>
		*b->buf++ = ch;
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	88 01                	mov    %al,(%ecx)
  800725:	ff 02                	incl   (%edx)
}
  800727:	c9                   	leave  
  800728:	c3                   	ret    

00800729 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800729:	55                   	push   %ebp
  80072a:	89 e5                	mov    %esp,%ebp
  80072c:	83 ec 18             	sub    $0x18,%esp
  80072f:	8b 55 08             	mov    0x8(%ebp),%edx
  800732:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800735:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  800738:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  80073c:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80073f:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  800746:	85 d2                	test   %edx,%edx
  800748:	74 04                	je     80074e <vsnprintf+0x25>
  80074a:	85 c9                	test   %ecx,%ecx
  80074c:	7f 07                	jg     800755 <vsnprintf+0x2c>
		return -E_INVAL;
  80074e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800753:	eb 1d                	jmp    800772 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800755:	ff 75 14             	pushl  0x14(%ebp)
  800758:	ff 75 10             	pushl  0x10(%ebp)
  80075b:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  80075e:	50                   	push   %eax
  80075f:	68 10 07 80 00       	push   $0x800710
  800764:	e8 91 fc ff ff       	call   8003fa <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800769:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  80076c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80076f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  800772:	c9                   	leave  
  800773:	c3                   	ret    

00800774 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800774:	55                   	push   %ebp
  800775:	89 e5                	mov    %esp,%ebp
  800777:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80077a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80077d:	50                   	push   %eax
  80077e:	ff 75 10             	pushl  0x10(%ebp)
  800781:	ff 75 0c             	pushl  0xc(%ebp)
  800784:	ff 75 08             	pushl  0x8(%ebp)
  800787:	e8 9d ff ff ff       	call   800729 <vsnprintf>
	va_end(ap);

	return rc;
}
  80078c:	c9                   	leave  
  80078d:	c3                   	ret    
	...

00800790 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	56                   	push   %esi
  800794:	53                   	push   %ebx
  800795:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800798:	83 ec 0c             	sub    $0xc,%esp
  80079b:	56                   	push   %esi
  80079c:	e8 ef 00 00 00       	call   800890 <strlen>
  char letter;
  int hexnum = 0;
  8007a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  8007a6:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  8007ab:	83 c4 10             	add    $0x10,%esp
  8007ae:	89 c2                	mov    %eax,%edx
  8007b0:	4a                   	dec    %edx
  8007b1:	0f 88 d0 00 00 00    	js     800887 <strtoint+0xf7>
    letter = string[cidx];
  8007b7:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  8007ba:	85 d2                	test   %edx,%edx
  8007bc:	75 12                	jne    8007d0 <strtoint+0x40>
      if (letter != '0') {
  8007be:	3c 30                	cmp    $0x30,%al
  8007c0:	0f 84 ba 00 00 00    	je     800880 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8007c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8007cb:	e9 b9 00 00 00       	jmp    800889 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  8007d0:	83 fa 01             	cmp    $0x1,%edx
  8007d3:	75 12                	jne    8007e7 <strtoint+0x57>
      if (letter != 'x') {
  8007d5:	3c 78                	cmp    $0x78,%al
  8007d7:	0f 84 a3 00 00 00    	je     800880 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8007dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8007e2:	e9 a2 00 00 00       	jmp    800889 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8007e7:	0f be c0             	movsbl %al,%eax
  8007ea:	83 e8 30             	sub    $0x30,%eax
  8007ed:	83 f8 36             	cmp    $0x36,%eax
  8007f0:	0f 87 80 00 00 00    	ja     800876 <strtoint+0xe6>
  8007f6:	ff 24 85 94 29 80 00 	jmp    *0x802994(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8007fd:	01 cb                	add    %ecx,%ebx
          break;
  8007ff:	eb 7c                	jmp    80087d <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800801:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  800804:	eb 77                	jmp    80087d <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  800806:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800809:	01 c3                	add    %eax,%ebx
          break;
  80080b:	eb 70                	jmp    80087d <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  80080d:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800810:	eb 6b                	jmp    80087d <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  800812:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800815:	01 c3                	add    %eax,%ebx
          break;
  800817:	eb 64                	jmp    80087d <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  800819:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80081c:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  80081f:	eb 5c                	jmp    80087d <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800821:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800828:	29 c8                	sub    %ecx,%eax
  80082a:	01 c3                	add    %eax,%ebx
          break;
  80082c:	eb 4f                	jmp    80087d <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  80082e:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  800831:	eb 4a                	jmp    80087d <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  800833:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  800836:	01 c3                	add    %eax,%ebx
          break;
  800838:	eb 43                	jmp    80087d <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  80083a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  80083d:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800840:	eb 3b                	jmp    80087d <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800842:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800845:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  800848:	01 c3                	add    %eax,%ebx
          break;
  80084a:	eb 31                	jmp    80087d <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  80084c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80084f:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800852:	eb 29                	jmp    80087d <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800854:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800857:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  80085a:	01 c3                	add    %eax,%ebx
          break;
  80085c:	eb 1f                	jmp    80087d <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  80085e:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800865:	29 c8                	sub    %ecx,%eax
  800867:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  80086a:	eb 11                	jmp    80087d <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  80086c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80086f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800872:	01 c3                	add    %eax,%ebx
          break;
  800874:	eb 07                	jmp    80087d <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  800876:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80087b:	eb 0c                	jmp    800889 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  80087d:	c1 e1 04             	shl    $0x4,%ecx
  800880:	4a                   	dec    %edx
  800881:	0f 89 30 ff ff ff    	jns    8007b7 <strtoint+0x27>
    }
  }

  return hexnum;
  800887:	89 d8                	mov    %ebx,%eax
}
  800889:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80088c:	5b                   	pop    %ebx
  80088d:	5e                   	pop    %esi
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <strlen>:





int
strlen(const char *s)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800896:	b8 00 00 00 00       	mov    $0x0,%eax
  80089b:	80 3a 00             	cmpb   $0x0,(%edx)
  80089e:	74 07                	je     8008a7 <strlen+0x17>
		n++;
  8008a0:	40                   	inc    %eax
  8008a1:	42                   	inc    %edx
  8008a2:	80 3a 00             	cmpb   $0x0,(%edx)
  8008a5:	75 f9                	jne    8008a0 <strlen+0x10>
	return n;
}
  8008a7:	c9                   	leave  
  8008a8:	c3                   	ret    

008008a9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008af:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b7:	85 d2                	test   %edx,%edx
  8008b9:	74 0f                	je     8008ca <strnlen+0x21>
  8008bb:	80 39 00             	cmpb   $0x0,(%ecx)
  8008be:	74 0a                	je     8008ca <strnlen+0x21>
		n++;
  8008c0:	40                   	inc    %eax
  8008c1:	41                   	inc    %ecx
  8008c2:	4a                   	dec    %edx
  8008c3:	74 05                	je     8008ca <strnlen+0x21>
  8008c5:	80 39 00             	cmpb   $0x0,(%ecx)
  8008c8:	75 f6                	jne    8008c0 <strnlen+0x17>
	return n;
}
  8008ca:	c9                   	leave  
  8008cb:	c3                   	ret    

008008cc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	53                   	push   %ebx
  8008d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d3:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  8008d6:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  8008d8:	8a 02                	mov    (%edx),%al
  8008da:	42                   	inc    %edx
  8008db:	88 01                	mov    %al,(%ecx)
  8008dd:	41                   	inc    %ecx
  8008de:	84 c0                	test   %al,%al
  8008e0:	75 f6                	jne    8008d8 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008e2:	89 d8                	mov    %ebx,%eax
  8008e4:	5b                   	pop    %ebx
  8008e5:	c9                   	leave  
  8008e6:	c3                   	ret    

008008e7 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	57                   	push   %edi
  8008eb:	56                   	push   %esi
  8008ec:	53                   	push   %ebx
  8008ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f3:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  8008f6:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  8008f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008fd:	39 f3                	cmp    %esi,%ebx
  8008ff:	73 10                	jae    800911 <strncpy+0x2a>
		*dst++ = *src;
  800901:	8a 02                	mov    (%edx),%al
  800903:	88 01                	mov    %al,(%ecx)
  800905:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800906:	80 3a 01             	cmpb   $0x1,(%edx)
  800909:	83 da ff             	sbb    $0xffffffff,%edx
  80090c:	43                   	inc    %ebx
  80090d:	39 f3                	cmp    %esi,%ebx
  80090f:	72 f0                	jb     800901 <strncpy+0x1a>
	}
	return ret;
}
  800911:	89 f8                	mov    %edi,%eax
  800913:	5b                   	pop    %ebx
  800914:	5e                   	pop    %esi
  800915:	5f                   	pop    %edi
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	56                   	push   %esi
  80091c:	53                   	push   %ebx
  80091d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800920:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800923:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  800926:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  800928:	85 d2                	test   %edx,%edx
  80092a:	74 19                	je     800945 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80092c:	4a                   	dec    %edx
  80092d:	74 13                	je     800942 <strlcpy+0x2a>
  80092f:	80 39 00             	cmpb   $0x0,(%ecx)
  800932:	74 0e                	je     800942 <strlcpy+0x2a>
  800934:	8a 01                	mov    (%ecx),%al
  800936:	41                   	inc    %ecx
  800937:	88 03                	mov    %al,(%ebx)
  800939:	43                   	inc    %ebx
  80093a:	4a                   	dec    %edx
  80093b:	74 05                	je     800942 <strlcpy+0x2a>
  80093d:	80 39 00             	cmpb   $0x0,(%ecx)
  800940:	75 f2                	jne    800934 <strlcpy+0x1c>
		*dst = '\0';
  800942:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800945:	89 d8                	mov    %ebx,%eax
  800947:	29 f0                	sub    %esi,%eax
}
  800949:	5b                   	pop    %ebx
  80094a:	5e                   	pop    %esi
  80094b:	c9                   	leave  
  80094c:	c3                   	ret    

0080094d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	8b 55 08             	mov    0x8(%ebp),%edx
  800953:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  800956:	80 3a 00             	cmpb   $0x0,(%edx)
  800959:	74 13                	je     80096e <strcmp+0x21>
  80095b:	8a 02                	mov    (%edx),%al
  80095d:	3a 01                	cmp    (%ecx),%al
  80095f:	75 0d                	jne    80096e <strcmp+0x21>
  800961:	42                   	inc    %edx
  800962:	41                   	inc    %ecx
  800963:	80 3a 00             	cmpb   $0x0,(%edx)
  800966:	74 06                	je     80096e <strcmp+0x21>
  800968:	8a 02                	mov    (%edx),%al
  80096a:	3a 01                	cmp    (%ecx),%al
  80096c:	74 f3                	je     800961 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80096e:	0f b6 02             	movzbl (%edx),%eax
  800971:	0f b6 11             	movzbl (%ecx),%edx
  800974:	29 d0                	sub    %edx,%eax
}
  800976:	c9                   	leave  
  800977:	c3                   	ret    

00800978 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	53                   	push   %ebx
  80097c:	8b 55 08             	mov    0x8(%ebp),%edx
  80097f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800982:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800985:	85 c9                	test   %ecx,%ecx
  800987:	74 1f                	je     8009a8 <strncmp+0x30>
  800989:	80 3a 00             	cmpb   $0x0,(%edx)
  80098c:	74 16                	je     8009a4 <strncmp+0x2c>
  80098e:	8a 02                	mov    (%edx),%al
  800990:	3a 03                	cmp    (%ebx),%al
  800992:	75 10                	jne    8009a4 <strncmp+0x2c>
  800994:	42                   	inc    %edx
  800995:	43                   	inc    %ebx
  800996:	49                   	dec    %ecx
  800997:	74 0f                	je     8009a8 <strncmp+0x30>
  800999:	80 3a 00             	cmpb   $0x0,(%edx)
  80099c:	74 06                	je     8009a4 <strncmp+0x2c>
  80099e:	8a 02                	mov    (%edx),%al
  8009a0:	3a 03                	cmp    (%ebx),%al
  8009a2:	74 f0                	je     800994 <strncmp+0x1c>
	if (n == 0)
  8009a4:	85 c9                	test   %ecx,%ecx
  8009a6:	75 07                	jne    8009af <strncmp+0x37>
		return 0;
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ad:	eb 0a                	jmp    8009b9 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009af:	0f b6 12             	movzbl (%edx),%edx
  8009b2:	0f b6 03             	movzbl (%ebx),%eax
  8009b5:	29 c2                	sub    %eax,%edx
  8009b7:	89 d0                	mov    %edx,%eax
}
  8009b9:	5b                   	pop    %ebx
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c2:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8009c5:	80 38 00             	cmpb   $0x0,(%eax)
  8009c8:	74 0a                	je     8009d4 <strchr+0x18>
		if (*s == c)
  8009ca:	38 10                	cmp    %dl,(%eax)
  8009cc:	74 0b                	je     8009d9 <strchr+0x1d>
  8009ce:	40                   	inc    %eax
  8009cf:	80 38 00             	cmpb   $0x0,(%eax)
  8009d2:	75 f6                	jne    8009ca <strchr+0xe>
			return (char *) s;
	return 0;
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d9:	c9                   	leave  
  8009da:	c3                   	ret    

008009db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8009e4:	80 38 00             	cmpb   $0x0,(%eax)
  8009e7:	74 0a                	je     8009f3 <strfind+0x18>
		if (*s == c)
  8009e9:	38 10                	cmp    %dl,(%eax)
  8009eb:	74 06                	je     8009f3 <strfind+0x18>
  8009ed:	40                   	inc    %eax
  8009ee:	80 38 00             	cmpb   $0x0,(%eax)
  8009f1:	75 f6                	jne    8009e9 <strfind+0xe>
			break;
	return (char *) s;
}
  8009f3:	c9                   	leave  
  8009f4:	c3                   	ret    

008009f5 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	57                   	push   %edi
  8009f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  8009ff:	89 f8                	mov    %edi,%eax
  800a01:	85 c9                	test   %ecx,%ecx
  800a03:	74 40                	je     800a45 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800a05:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a0b:	75 30                	jne    800a3d <memset+0x48>
  800a0d:	f6 c1 03             	test   $0x3,%cl
  800a10:	75 2b                	jne    800a3d <memset+0x48>
		c &= 0xFF;
  800a12:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1c:	c1 e0 18             	shl    $0x18,%eax
  800a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a22:	c1 e2 10             	shl    $0x10,%edx
  800a25:	09 d0                	or     %edx,%eax
  800a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2a:	c1 e2 08             	shl    $0x8,%edx
  800a2d:	09 d0                	or     %edx,%eax
  800a2f:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800a32:	c1 e9 02             	shr    $0x2,%ecx
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a38:	fc                   	cld    
  800a39:	f3 ab                	repz stos %eax,%es:(%edi)
  800a3b:	eb 06                	jmp    800a43 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a40:	fc                   	cld    
  800a41:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800a43:	89 f8                	mov    %edi,%eax
}
  800a45:	5f                   	pop    %edi
  800a46:	c9                   	leave  
  800a47:	c3                   	ret    

00800a48 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	57                   	push   %edi
  800a4c:	56                   	push   %esi
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800a53:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a56:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a58:	39 c6                	cmp    %eax,%esi
  800a5a:	73 33                	jae    800a8f <memmove+0x47>
  800a5c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a5f:	39 c2                	cmp    %eax,%edx
  800a61:	76 2c                	jbe    800a8f <memmove+0x47>
		s += n;
  800a63:	89 d6                	mov    %edx,%esi
		d += n;
  800a65:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a68:	f6 c2 03             	test   $0x3,%dl
  800a6b:	75 1b                	jne    800a88 <memmove+0x40>
  800a6d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a73:	75 13                	jne    800a88 <memmove+0x40>
  800a75:	f6 c1 03             	test   $0x3,%cl
  800a78:	75 0e                	jne    800a88 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800a7a:	83 ef 04             	sub    $0x4,%edi
  800a7d:	83 ee 04             	sub    $0x4,%esi
  800a80:	c1 e9 02             	shr    $0x2,%ecx
  800a83:	fd                   	std    
  800a84:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800a86:	eb 27                	jmp    800aaf <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a88:	4f                   	dec    %edi
  800a89:	4e                   	dec    %esi
  800a8a:	fd                   	std    
  800a8b:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800a8d:	eb 20                	jmp    800aaf <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a95:	75 15                	jne    800aac <memmove+0x64>
  800a97:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a9d:	75 0d                	jne    800aac <memmove+0x64>
  800a9f:	f6 c1 03             	test   $0x3,%cl
  800aa2:	75 08                	jne    800aac <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800aa4:	c1 e9 02             	shr    $0x2,%ecx
  800aa7:	fc                   	cld    
  800aa8:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800aaa:	eb 03                	jmp    800aaf <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aac:	fc                   	cld    
  800aad:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aaf:	5e                   	pop    %esi
  800ab0:	5f                   	pop    %edi
  800ab1:	c9                   	leave  
  800ab2:	c3                   	ret    

00800ab3 <memcpy>:

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
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800ab6:	ff 75 10             	pushl  0x10(%ebp)
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	ff 75 08             	pushl  0x8(%ebp)
  800abf:	e8 84 ff ff ff       	call   800a48 <memmove>
}
  800ac4:	c9                   	leave  
  800ac5:	c3                   	ret    

00800ac6 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800aca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800acd:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ad0:	8b 55 10             	mov    0x10(%ebp),%edx
  800ad3:	4a                   	dec    %edx
  800ad4:	83 fa ff             	cmp    $0xffffffff,%edx
  800ad7:	74 1a                	je     800af3 <memcmp+0x2d>
  800ad9:	8a 01                	mov    (%ecx),%al
  800adb:	3a 03                	cmp    (%ebx),%al
  800add:	74 0c                	je     800aeb <memcmp+0x25>
  800adf:	0f b6 d0             	movzbl %al,%edx
  800ae2:	0f b6 03             	movzbl (%ebx),%eax
  800ae5:	29 c2                	sub    %eax,%edx
  800ae7:	89 d0                	mov    %edx,%eax
  800ae9:	eb 0d                	jmp    800af8 <memcmp+0x32>
  800aeb:	41                   	inc    %ecx
  800aec:	43                   	inc    %ebx
  800aed:	4a                   	dec    %edx
  800aee:	83 fa ff             	cmp    $0xffffffff,%edx
  800af1:	75 e6                	jne    800ad9 <memcmp+0x13>
	}

	return 0;
  800af3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af8:	5b                   	pop    %ebx
  800af9:	c9                   	leave  
  800afa:	c3                   	ret    

00800afb <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b04:	89 c2                	mov    %eax,%edx
  800b06:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b09:	39 d0                	cmp    %edx,%eax
  800b0b:	73 09                	jae    800b16 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b0d:	38 08                	cmp    %cl,(%eax)
  800b0f:	74 05                	je     800b16 <memfind+0x1b>
  800b11:	40                   	inc    %eax
  800b12:	39 d0                	cmp    %edx,%eax
  800b14:	72 f7                	jb     800b0d <memfind+0x12>
			break;
	return (void *) s;
}
  800b16:	c9                   	leave  
  800b17:	c3                   	ret    

00800b18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	57                   	push   %edi
  800b1c:	56                   	push   %esi
  800b1d:	53                   	push   %ebx
  800b1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b21:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b24:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800b27:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800b2c:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800b31:	80 3a 20             	cmpb   $0x20,(%edx)
  800b34:	74 05                	je     800b3b <strtol+0x23>
  800b36:	80 3a 09             	cmpb   $0x9,(%edx)
  800b39:	75 0b                	jne    800b46 <strtol+0x2e>
  800b3b:	42                   	inc    %edx
  800b3c:	80 3a 20             	cmpb   $0x20,(%edx)
  800b3f:	74 fa                	je     800b3b <strtol+0x23>
  800b41:	80 3a 09             	cmpb   $0x9,(%edx)
  800b44:	74 f5                	je     800b3b <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800b46:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800b49:	75 03                	jne    800b4e <strtol+0x36>
		s++;
  800b4b:	42                   	inc    %edx
  800b4c:	eb 0b                	jmp    800b59 <strtol+0x41>
	else if (*s == '-')
  800b4e:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800b51:	75 06                	jne    800b59 <strtol+0x41>
		s++, neg = 1;
  800b53:	42                   	inc    %edx
  800b54:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b59:	85 c9                	test   %ecx,%ecx
  800b5b:	74 05                	je     800b62 <strtol+0x4a>
  800b5d:	83 f9 10             	cmp    $0x10,%ecx
  800b60:	75 15                	jne    800b77 <strtol+0x5f>
  800b62:	80 3a 30             	cmpb   $0x30,(%edx)
  800b65:	75 10                	jne    800b77 <strtol+0x5f>
  800b67:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b6b:	75 0a                	jne    800b77 <strtol+0x5f>
		s += 2, base = 16;
  800b6d:	83 c2 02             	add    $0x2,%edx
  800b70:	b9 10 00 00 00       	mov    $0x10,%ecx
  800b75:	eb 14                	jmp    800b8b <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800b77:	85 c9                	test   %ecx,%ecx
  800b79:	75 10                	jne    800b8b <strtol+0x73>
  800b7b:	80 3a 30             	cmpb   $0x30,(%edx)
  800b7e:	75 05                	jne    800b85 <strtol+0x6d>
		s++, base = 8;
  800b80:	42                   	inc    %edx
  800b81:	b1 08                	mov    $0x8,%cl
  800b83:	eb 06                	jmp    800b8b <strtol+0x73>
	else if (base == 0)
  800b85:	85 c9                	test   %ecx,%ecx
  800b87:	75 02                	jne    800b8b <strtol+0x73>
		base = 10;
  800b89:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b8b:	8a 02                	mov    (%edx),%al
  800b8d:	83 e8 30             	sub    $0x30,%eax
  800b90:	3c 09                	cmp    $0x9,%al
  800b92:	77 08                	ja     800b9c <strtol+0x84>
			dig = *s - '0';
  800b94:	0f be 02             	movsbl (%edx),%eax
  800b97:	83 e8 30             	sub    $0x30,%eax
  800b9a:	eb 20                	jmp    800bbc <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800b9c:	8a 02                	mov    (%edx),%al
  800b9e:	83 e8 61             	sub    $0x61,%eax
  800ba1:	3c 19                	cmp    $0x19,%al
  800ba3:	77 08                	ja     800bad <strtol+0x95>
			dig = *s - 'a' + 10;
  800ba5:	0f be 02             	movsbl (%edx),%eax
  800ba8:	83 e8 57             	sub    $0x57,%eax
  800bab:	eb 0f                	jmp    800bbc <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800bad:	8a 02                	mov    (%edx),%al
  800baf:	83 e8 41             	sub    $0x41,%eax
  800bb2:	3c 19                	cmp    $0x19,%al
  800bb4:	77 12                	ja     800bc8 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800bb6:	0f be 02             	movsbl (%edx),%eax
  800bb9:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800bbc:	39 c8                	cmp    %ecx,%eax
  800bbe:	7d 08                	jge    800bc8 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800bc0:	42                   	inc    %edx
  800bc1:	0f af d9             	imul   %ecx,%ebx
  800bc4:	01 c3                	add    %eax,%ebx
  800bc6:	eb c3                	jmp    800b8b <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bc8:	85 f6                	test   %esi,%esi
  800bca:	74 02                	je     800bce <strtol+0xb6>
		*endptr = (char *) s;
  800bcc:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bce:	89 d8                	mov    %ebx,%eax
  800bd0:	85 ff                	test   %edi,%edi
  800bd2:	74 02                	je     800bd6 <strtol+0xbe>
  800bd4:	f7 d8                	neg    %eax
}
  800bd6:	5b                   	pop    %ebx
  800bd7:	5e                   	pop    %esi
  800bd8:	5f                   	pop    %edi
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    
	...

00800bdc <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	83 ec 04             	sub    $0x4,%esp
  800be5:	8b 55 08             	mov    0x8(%ebp),%edx
  800be8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800beb:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf0:	89 f8                	mov    %edi,%eax
  800bf2:	89 fb                	mov    %edi,%ebx
  800bf4:	89 fe                	mov    %edi,%esi
  800bf6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bf8:	83 c4 04             	add    $0x4,%esp
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5f                   	pop    %edi
  800bfe:	c9                   	leave  
  800bff:	c3                   	ret    

00800c00 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c00:	55                   	push   %ebp
  800c01:	89 e5                	mov    %esp,%ebp
  800c03:	57                   	push   %edi
  800c04:	56                   	push   %esi
  800c05:	53                   	push   %ebx
  800c06:	b8 01 00 00 00       	mov    $0x1,%eax
  800c0b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c10:	89 fa                	mov    %edi,%edx
  800c12:	89 f9                	mov    %edi,%ecx
  800c14:	89 fb                	mov    %edi,%ebx
  800c16:	89 fe                	mov    %edi,%esi
  800c18:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
  800c25:	83 ec 0c             	sub    $0xc,%esp
  800c28:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c30:	bf 00 00 00 00       	mov    $0x0,%edi
  800c35:	89 f9                	mov    %edi,%ecx
  800c37:	89 fb                	mov    %edi,%ebx
  800c39:	89 fe                	mov    %edi,%esi
  800c3b:	cd 30                	int    $0x30
  800c3d:	85 c0                	test   %eax,%eax
  800c3f:	7e 17                	jle    800c58 <sys_env_destroy+0x39>
  800c41:	83 ec 0c             	sub    $0xc,%esp
  800c44:	50                   	push   %eax
  800c45:	6a 03                	push   $0x3
  800c47:	68 70 2a 80 00       	push   $0x802a70
  800c4c:	6a 23                	push   $0x23
  800c4e:	68 8d 2a 80 00       	push   $0x802a8d
  800c53:	e8 80 f5 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c58:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c5b:	5b                   	pop    %ebx
  800c5c:	5e                   	pop    %esi
  800c5d:	5f                   	pop    %edi
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
  800c66:	b8 02 00 00 00       	mov    $0x2,%eax
  800c6b:	bf 00 00 00 00       	mov    $0x0,%edi
  800c70:	89 fa                	mov    %edi,%edx
  800c72:	89 f9                	mov    %edi,%ecx
  800c74:	89 fb                	mov    %edi,%ebx
  800c76:	89 fe                	mov    %edi,%esi
  800c78:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c7a:	5b                   	pop    %ebx
  800c7b:	5e                   	pop    %esi
  800c7c:	5f                   	pop    %edi
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <sys_yield>:

void
sys_yield(void)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	57                   	push   %edi
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c8a:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8f:	89 fa                	mov    %edi,%edx
  800c91:	89 f9                	mov    %edi,%ecx
  800c93:	89 fb                	mov    %edi,%ebx
  800c95:	89 fe                	mov    %edi,%esi
  800c97:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	5f                   	pop    %edi
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	57                   	push   %edi
  800ca2:	56                   	push   %esi
  800ca3:	53                   	push   %ebx
  800ca4:	83 ec 0c             	sub    $0xc,%esp
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cb0:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb5:	bf 00 00 00 00       	mov    $0x0,%edi
  800cba:	89 fe                	mov    %edi,%esi
  800cbc:	cd 30                	int    $0x30
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	7e 17                	jle    800cd9 <sys_page_alloc+0x3b>
  800cc2:	83 ec 0c             	sub    $0xc,%esp
  800cc5:	50                   	push   %eax
  800cc6:	6a 04                	push   $0x4
  800cc8:	68 70 2a 80 00       	push   $0x802a70
  800ccd:	6a 23                	push   $0x23
  800ccf:	68 8d 2a 80 00       	push   $0x802a8d
  800cd4:	e8 ff f4 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cd9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5f                   	pop    %edi
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    

00800ce1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	57                   	push   %edi
  800ce5:	56                   	push   %esi
  800ce6:	53                   	push   %ebx
  800ce7:	83 ec 0c             	sub    $0xc,%esp
  800cea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ced:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf6:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf9:	b8 05 00 00 00       	mov    $0x5,%eax
  800cfe:	cd 30                	int    $0x30
  800d00:	85 c0                	test   %eax,%eax
  800d02:	7e 17                	jle    800d1b <sys_page_map+0x3a>
  800d04:	83 ec 0c             	sub    $0xc,%esp
  800d07:	50                   	push   %eax
  800d08:	6a 05                	push   $0x5
  800d0a:	68 70 2a 80 00       	push   $0x802a70
  800d0f:	6a 23                	push   $0x23
  800d11:	68 8d 2a 80 00       	push   $0x802a8d
  800d16:	e8 bd f4 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d1b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	c9                   	leave  
  800d22:	c3                   	ret    

00800d23 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d32:	b8 06 00 00 00       	mov    $0x6,%eax
  800d37:	bf 00 00 00 00       	mov    $0x0,%edi
  800d3c:	89 fb                	mov    %edi,%ebx
  800d3e:	89 fe                	mov    %edi,%esi
  800d40:	cd 30                	int    $0x30
  800d42:	85 c0                	test   %eax,%eax
  800d44:	7e 17                	jle    800d5d <sys_page_unmap+0x3a>
  800d46:	83 ec 0c             	sub    $0xc,%esp
  800d49:	50                   	push   %eax
  800d4a:	6a 06                	push   $0x6
  800d4c:	68 70 2a 80 00       	push   $0x802a70
  800d51:	6a 23                	push   $0x23
  800d53:	68 8d 2a 80 00       	push   $0x802a8d
  800d58:	e8 7b f4 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d5d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d60:	5b                   	pop    %ebx
  800d61:	5e                   	pop    %esi
  800d62:	5f                   	pop    %edi
  800d63:	c9                   	leave  
  800d64:	c3                   	ret    

00800d65 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	57                   	push   %edi
  800d69:	56                   	push   %esi
  800d6a:	53                   	push   %ebx
  800d6b:	83 ec 0c             	sub    $0xc,%esp
  800d6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d74:	b8 08 00 00 00       	mov    $0x8,%eax
  800d79:	bf 00 00 00 00       	mov    $0x0,%edi
  800d7e:	89 fb                	mov    %edi,%ebx
  800d80:	89 fe                	mov    %edi,%esi
  800d82:	cd 30                	int    $0x30
  800d84:	85 c0                	test   %eax,%eax
  800d86:	7e 17                	jle    800d9f <sys_env_set_status+0x3a>
  800d88:	83 ec 0c             	sub    $0xc,%esp
  800d8b:	50                   	push   %eax
  800d8c:	6a 08                	push   $0x8
  800d8e:	68 70 2a 80 00       	push   $0x802a70
  800d93:	6a 23                	push   $0x23
  800d95:	68 8d 2a 80 00       	push   $0x802a8d
  800d9a:	e8 39 f4 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d9f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800da2:	5b                   	pop    %ebx
  800da3:	5e                   	pop    %esi
  800da4:	5f                   	pop    %edi
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	b8 09 00 00 00       	mov    $0x9,%eax
  800dbb:	bf 00 00 00 00       	mov    $0x0,%edi
  800dc0:	89 fb                	mov    %edi,%ebx
  800dc2:	89 fe                	mov    %edi,%esi
  800dc4:	cd 30                	int    $0x30
  800dc6:	85 c0                	test   %eax,%eax
  800dc8:	7e 17                	jle    800de1 <sys_env_set_trapframe+0x3a>
  800dca:	83 ec 0c             	sub    $0xc,%esp
  800dcd:	50                   	push   %eax
  800dce:	6a 09                	push   $0x9
  800dd0:	68 70 2a 80 00       	push   $0x802a70
  800dd5:	6a 23                	push   $0x23
  800dd7:	68 8d 2a 80 00       	push   $0x802a8d
  800ddc:	e8 f7 f3 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800de1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df8:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dfd:	bf 00 00 00 00       	mov    $0x0,%edi
  800e02:	89 fb                	mov    %edi,%ebx
  800e04:	89 fe                	mov    %edi,%esi
  800e06:	cd 30                	int    $0x30
  800e08:	85 c0                	test   %eax,%eax
  800e0a:	7e 17                	jle    800e23 <sys_env_set_pgfault_upcall+0x3a>
  800e0c:	83 ec 0c             	sub    $0xc,%esp
  800e0f:	50                   	push   %eax
  800e10:	6a 0a                	push   $0xa
  800e12:	68 70 2a 80 00       	push   $0x802a70
  800e17:	6a 23                	push   $0x23
  800e19:	68 8d 2a 80 00       	push   $0x802a8d
  800e1e:	e8 b5 f3 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e23:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e26:	5b                   	pop    %ebx
  800e27:	5e                   	pop    %esi
  800e28:	5f                   	pop    %edi
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
  800e2e:	57                   	push   %edi
  800e2f:	56                   	push   %esi
  800e30:	53                   	push   %ebx
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e37:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3a:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e3d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e42:	be 00 00 00 00       	mov    $0x0,%esi
  800e47:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	c9                   	leave  
  800e4d:	c3                   	ret    

00800e4e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e4e:	55                   	push   %ebp
  800e4f:	89 e5                	mov    %esp,%ebp
  800e51:	57                   	push   %edi
  800e52:	56                   	push   %esi
  800e53:	53                   	push   %ebx
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e5f:	bf 00 00 00 00       	mov    $0x0,%edi
  800e64:	89 f9                	mov    %edi,%ecx
  800e66:	89 fb                	mov    %edi,%ebx
  800e68:	89 fe                	mov    %edi,%esi
  800e6a:	cd 30                	int    $0x30
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7e 17                	jle    800e87 <sys_ipc_recv+0x39>
  800e70:	83 ec 0c             	sub    $0xc,%esp
  800e73:	50                   	push   %eax
  800e74:	6a 0d                	push   $0xd
  800e76:	68 70 2a 80 00       	push   $0x802a70
  800e7b:	6a 23                	push   $0x23
  800e7d:	68 8d 2a 80 00       	push   $0x802a8d
  800e82:	e8 51 f3 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e87:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e8a:	5b                   	pop    %ebx
  800e8b:	5e                   	pop    %esi
  800e8c:	5f                   	pop    %edi
  800e8d:	c9                   	leave  
  800e8e:	c3                   	ret    

00800e8f <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
  800e95:	83 ec 0c             	sub    $0xc,%esp
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9e:	b8 10 00 00 00       	mov    $0x10,%eax
  800ea3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ea8:	89 fb                	mov    %edi,%ebx
  800eaa:	89 fe                	mov    %edi,%esi
  800eac:	cd 30                	int    $0x30
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	7e 17                	jle    800ec9 <sys_transmit_packet+0x3a>
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	50                   	push   %eax
  800eb6:	6a 10                	push   $0x10
  800eb8:	68 70 2a 80 00       	push   $0x802a70
  800ebd:	6a 23                	push   $0x23
  800ebf:	68 8d 2a 80 00       	push   $0x802a8d
  800ec4:	e8 0f f3 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800ec9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	c9                   	leave  
  800ed0:	c3                   	ret    

00800ed1 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	57                   	push   %edi
  800ed5:	56                   	push   %esi
  800ed6:	53                   	push   %ebx
  800ed7:	83 ec 0c             	sub    $0xc,%esp
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee0:	b8 11 00 00 00       	mov    $0x11,%eax
  800ee5:	bf 00 00 00 00       	mov    $0x0,%edi
  800eea:	89 fb                	mov    %edi,%ebx
  800eec:	89 fe                	mov    %edi,%esi
  800eee:	cd 30                	int    $0x30
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	7e 17                	jle    800f0b <sys_receive_packet+0x3a>
  800ef4:	83 ec 0c             	sub    $0xc,%esp
  800ef7:	50                   	push   %eax
  800ef8:	6a 11                	push   $0x11
  800efa:	68 70 2a 80 00       	push   $0x802a70
  800eff:	6a 23                	push   $0x23
  800f01:	68 8d 2a 80 00       	push   $0x802a8d
  800f06:	e8 cd f2 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800f0b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	c9                   	leave  
  800f12:	c3                   	ret    

00800f13 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f1e:	bf 00 00 00 00       	mov    $0x0,%edi
  800f23:	89 fa                	mov    %edi,%edx
  800f25:	89 f9                	mov    %edi,%ecx
  800f27:	89 fb                	mov    %edi,%ebx
  800f29:	89 fe                	mov    %edi,%esi
  800f2b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
  800f38:	83 ec 0c             	sub    $0xc,%esp
  800f3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f43:	bf 00 00 00 00       	mov    $0x0,%edi
  800f48:	89 f9                	mov    %edi,%ecx
  800f4a:	89 fb                	mov    %edi,%ebx
  800f4c:	89 fe                	mov    %edi,%esi
  800f4e:	cd 30                	int    $0x30
  800f50:	85 c0                	test   %eax,%eax
  800f52:	7e 17                	jle    800f6b <sys_map_receive_buffers+0x39>
  800f54:	83 ec 0c             	sub    $0xc,%esp
  800f57:	50                   	push   %eax
  800f58:	6a 0e                	push   $0xe
  800f5a:	68 70 2a 80 00       	push   $0x802a70
  800f5f:	6a 23                	push   $0x23
  800f61:	68 8d 2a 80 00       	push   $0x802a8d
  800f66:	e8 6d f2 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800f6b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
  800f79:	83 ec 0c             	sub    $0xc,%esp
  800f7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7f:	b8 12 00 00 00       	mov    $0x12,%eax
  800f84:	bf 00 00 00 00       	mov    $0x0,%edi
  800f89:	89 f9                	mov    %edi,%ecx
  800f8b:	89 fb                	mov    %edi,%ebx
  800f8d:	89 fe                	mov    %edi,%esi
  800f8f:	cd 30                	int    $0x30
  800f91:	85 c0                	test   %eax,%eax
  800f93:	7e 17                	jle    800fac <sys_receive_packet_zerocopy+0x39>
  800f95:	83 ec 0c             	sub    $0xc,%esp
  800f98:	50                   	push   %eax
  800f99:	6a 12                	push   $0x12
  800f9b:	68 70 2a 80 00       	push   $0x802a70
  800fa0:	6a 23                	push   $0x23
  800fa2:	68 8d 2a 80 00       	push   $0x802a8d
  800fa7:	e8 2c f2 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800fac:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800faf:	5b                   	pop    %ebx
  800fb0:	5e                   	pop    %esi
  800fb1:	5f                   	pop    %edi
  800fb2:	c9                   	leave  
  800fb3:	c3                   	ret    

00800fb4 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800fb4:	55                   	push   %ebp
  800fb5:	89 e5                	mov    %esp,%ebp
  800fb7:	57                   	push   %edi
  800fb8:	56                   	push   %esi
  800fb9:	53                   	push   %ebx
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc3:	b8 13 00 00 00       	mov    $0x13,%eax
  800fc8:	bf 00 00 00 00       	mov    $0x0,%edi
  800fcd:	89 fb                	mov    %edi,%ebx
  800fcf:	89 fe                	mov    %edi,%esi
  800fd1:	cd 30                	int    $0x30
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	7e 17                	jle    800fee <sys_env_set_priority+0x3a>
  800fd7:	83 ec 0c             	sub    $0xc,%esp
  800fda:	50                   	push   %eax
  800fdb:	6a 13                	push   $0x13
  800fdd:	68 70 2a 80 00       	push   $0x802a70
  800fe2:	6a 23                	push   $0x23
  800fe4:	68 8d 2a 80 00       	push   $0x802a8d
  800fe9:	e8 ea f1 ff ff       	call   8001d8 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800fee:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    
	...

00800ff8 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800ffe:	ff 75 08             	pushl  0x8(%ebp)
  801001:	e8 0a 00 00 00       	call   801010 <fd2num>
  801006:	c1 e0 16             	shl    $0x16,%eax
  801009:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  80100e:	c9                   	leave  
  80100f:	c3                   	ret    

00801010 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	05 00 00 40 30       	add    $0x30400000,%eax
  80101b:	c1 e8 0c             	shr    $0xc,%eax
}
  80101e:	c9                   	leave  
  80101f:	c3                   	ret    

00801020 <fd_alloc>:

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
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	57                   	push   %edi
  801024:	56                   	push   %esi
  801025:	53                   	push   %ebx
  801026:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801029:	b9 00 00 00 00       	mov    $0x0,%ecx
  80102e:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801033:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  801038:	89 c8                	mov    %ecx,%eax
  80103a:	c1 e0 0c             	shl    $0xc,%eax
  80103d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801043:	89 d0                	mov    %edx,%eax
  801045:	c1 e8 16             	shr    $0x16,%eax
  801048:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80104b:	a8 01                	test   $0x1,%al
  80104d:	74 0c                	je     80105b <fd_alloc+0x3b>
  80104f:	89 d0                	mov    %edx,%eax
  801051:	c1 e8 0c             	shr    $0xc,%eax
  801054:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  801057:	a8 01                	test   $0x1,%al
  801059:	75 09                	jne    801064 <fd_alloc+0x44>
			*fd_store = fd;
  80105b:	89 17                	mov    %edx,(%edi)
			return 0;
  80105d:	b8 00 00 00 00       	mov    $0x0,%eax
  801062:	eb 11                	jmp    801075 <fd_alloc+0x55>
  801064:	41                   	inc    %ecx
  801065:	83 f9 1f             	cmp    $0x1f,%ecx
  801068:	7e ce                	jle    801038 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80106a:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801070:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801075:	5b                   	pop    %ebx
  801076:	5e                   	pop    %esi
  801077:	5f                   	pop    %edi
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801080:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801085:	83 f8 1f             	cmp    $0x1f,%eax
  801088:	77 3a                	ja     8010c4 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80108a:	c1 e0 0c             	shl    $0xc,%eax
  80108d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801093:	89 d0                	mov    %edx,%eax
  801095:	c1 e8 16             	shr    $0x16,%eax
  801098:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80109f:	a8 01                	test   $0x1,%al
  8010a1:	74 10                	je     8010b3 <fd_lookup+0x39>
  8010a3:	89 d0                	mov    %edx,%eax
  8010a5:	c1 e8 0c             	shr    $0xc,%eax
  8010a8:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8010af:	a8 01                	test   $0x1,%al
  8010b1:	75 07                	jne    8010ba <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  8010b3:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8010b8:	eb 0a                	jmp    8010c4 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	89 10                	mov    %edx,(%eax)
	return 0;
  8010bf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010c4:	89 d0                	mov    %edx,%eax
  8010c6:	c9                   	leave  
  8010c7:	c3                   	ret    

008010c8 <fd_close>:

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
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	56                   	push   %esi
  8010cc:	53                   	push   %ebx
  8010cd:	83 ec 10             	sub    $0x10,%esp
  8010d0:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010d3:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8010d6:	50                   	push   %eax
  8010d7:	56                   	push   %esi
  8010d8:	e8 33 ff ff ff       	call   801010 <fd2num>
  8010dd:	89 04 24             	mov    %eax,(%esp)
  8010e0:	e8 95 ff ff ff       	call   80107a <fd_lookup>
  8010e5:	89 c3                	mov    %eax,%ebx
  8010e7:	83 c4 08             	add    $0x8,%esp
  8010ea:	85 c0                	test   %eax,%eax
  8010ec:	78 05                	js     8010f3 <fd_close+0x2b>
  8010ee:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8010f1:	74 0f                	je     801102 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8010f3:	89 d8                	mov    %ebx,%eax
  8010f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f9:	75 3a                	jne    801135 <fd_close+0x6d>
  8010fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801100:	eb 33                	jmp    801135 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  801102:	83 ec 08             	sub    $0x8,%esp
  801105:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801108:	50                   	push   %eax
  801109:	ff 36                	pushl  (%esi)
  80110b:	e8 2c 00 00 00       	call   80113c <dev_lookup>
  801110:	89 c3                	mov    %eax,%ebx
  801112:	83 c4 10             	add    $0x10,%esp
  801115:	85 c0                	test   %eax,%eax
  801117:	78 0f                	js     801128 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	56                   	push   %esi
  80111d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801120:	ff 50 10             	call   *0x10(%eax)
  801123:	89 c3                	mov    %eax,%ebx
  801125:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	56                   	push   %esi
  80112c:	6a 00                	push   $0x0
  80112e:	e8 f0 fb ff ff       	call   800d23 <sys_page_unmap>
	return r;
  801133:	89 d8                	mov    %ebx,%eax
}
  801135:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801138:	5b                   	pop    %ebx
  801139:	5e                   	pop    %esi
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <dev_lookup>:


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
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	56                   	push   %esi
  801140:	53                   	push   %ebx
  801141:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801144:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  801147:	ba 00 00 00 00       	mov    $0x0,%edx
  80114c:	83 3d 08 60 80 00 00 	cmpl   $0x0,0x806008
  801153:	74 1c                	je     801171 <dev_lookup+0x35>
  801155:	b9 08 60 80 00       	mov    $0x806008,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80115a:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  80115d:	39 18                	cmp    %ebx,(%eax)
  80115f:	75 09                	jne    80116a <dev_lookup+0x2e>
			*dev = devtab[i];
  801161:	89 06                	mov    %eax,(%esi)
			return 0;
  801163:	b8 00 00 00 00       	mov    $0x0,%eax
  801168:	eb 29                	jmp    801193 <dev_lookup+0x57>
  80116a:	42                   	inc    %edx
  80116b:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  80116f:	75 e9                	jne    80115a <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801171:	83 ec 04             	sub    $0x4,%esp
  801174:	53                   	push   %ebx
  801175:	a1 84 60 80 00       	mov    0x806084,%eax
  80117a:	8b 40 4c             	mov    0x4c(%eax),%eax
  80117d:	50                   	push   %eax
  80117e:	68 9c 2a 80 00       	push   $0x802a9c
  801183:	e8 40 f1 ff ff       	call   8002c8 <cprintf>
	*dev = 0;
  801188:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  80118e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801193:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801196:	5b                   	pop    %ebx
  801197:	5e                   	pop    %esi
  801198:	c9                   	leave  
  801199:	c3                   	ret    

0080119a <close>:

int
close(int fdnum)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011a0:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8011a3:	50                   	push   %eax
  8011a4:	ff 75 08             	pushl  0x8(%ebp)
  8011a7:	e8 ce fe ff ff       	call   80107a <fd_lookup>
  8011ac:	83 c4 08             	add    $0x8,%esp
		return r;
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	78 0f                	js     8011c4 <close+0x2a>
	else
		return fd_close(fd, 1);
  8011b5:	83 ec 08             	sub    $0x8,%esp
  8011b8:	6a 01                	push   $0x1
  8011ba:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8011bd:	e8 06 ff ff ff       	call   8010c8 <fd_close>
  8011c2:	89 c2                	mov    %eax,%edx
}
  8011c4:	89 d0                	mov    %edx,%eax
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <close_all>:

void
close_all(void)
{
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011cf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011d4:	83 ec 0c             	sub    $0xc,%esp
  8011d7:	53                   	push   %ebx
  8011d8:	e8 bd ff ff ff       	call   80119a <close>
  8011dd:	83 c4 10             	add    $0x10,%esp
  8011e0:	43                   	inc    %ebx
  8011e1:	83 fb 1f             	cmp    $0x1f,%ebx
  8011e4:	7e ee                	jle    8011d4 <close_all+0xc>
}
  8011e6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	57                   	push   %edi
  8011ef:	56                   	push   %esi
  8011f0:	53                   	push   %ebx
  8011f1:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011f4:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8011f7:	50                   	push   %eax
  8011f8:	ff 75 08             	pushl  0x8(%ebp)
  8011fb:	e8 7a fe ff ff       	call   80107a <fd_lookup>
  801200:	89 c6                	mov    %eax,%esi
  801202:	83 c4 08             	add    $0x8,%esp
  801205:	85 f6                	test   %esi,%esi
  801207:	0f 88 f8 00 00 00    	js     801305 <dup+0x11a>
		return r;
	close(newfdnum);
  80120d:	83 ec 0c             	sub    $0xc,%esp
  801210:	ff 75 0c             	pushl  0xc(%ebp)
  801213:	e8 82 ff ff ff       	call   80119a <close>

	newfd = INDEX2FD(newfdnum);
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	c1 e0 0c             	shl    $0xc,%eax
  80121e:	2d 00 00 40 30       	sub    $0x30400000,%eax
  801223:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  801226:	83 c4 04             	add    $0x4,%esp
  801229:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80122c:	e8 c7 fd ff ff       	call   800ff8 <fd2data>
  801231:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801233:	83 c4 04             	add    $0x4,%esp
  801236:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801239:	e8 ba fd ff ff       	call   800ff8 <fd2data>
  80123e:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801241:	89 f8                	mov    %edi,%eax
  801243:	c1 e8 16             	shr    $0x16,%eax
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801250:	85 c0                	test   %eax,%eax
  801252:	74 48                	je     80129c <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801254:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  801259:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  80125c:	89 d0                	mov    %edx,%eax
  80125e:	c1 e8 0c             	shr    $0xc,%eax
  801261:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  801268:	a8 01                	test   $0x1,%al
  80126a:	74 22                	je     80128e <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	25 07 0e 00 00       	and    $0xe07,%eax
  801274:	50                   	push   %eax
  801275:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801278:	01 d8                	add    %ebx,%eax
  80127a:	50                   	push   %eax
  80127b:	6a 00                	push   $0x0
  80127d:	52                   	push   %edx
  80127e:	6a 00                	push   $0x0
  801280:	e8 5c fa ff ff       	call   800ce1 <sys_page_map>
  801285:	89 c6                	mov    %eax,%esi
  801287:	83 c4 20             	add    $0x20,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	78 3f                	js     8012cd <dup+0xe2>
  80128e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801294:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80129a:	7e bd                	jle    801259 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80129c:	83 ec 0c             	sub    $0xc,%esp
  80129f:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8012a2:	89 d0                	mov    %edx,%eax
  8012a4:	c1 e8 0c             	shr    $0xc,%eax
  8012a7:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8012ae:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b3:	50                   	push   %eax
  8012b4:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8012b7:	6a 00                	push   $0x0
  8012b9:	52                   	push   %edx
  8012ba:	6a 00                	push   $0x0
  8012bc:	e8 20 fa ff ff       	call   800ce1 <sys_page_map>
  8012c1:	89 c6                	mov    %eax,%esi
  8012c3:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	85 f6                	test   %esi,%esi
  8012cb:	79 38                	jns    801305 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  8012cd:	83 ec 08             	sub    $0x8,%esp
  8012d0:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8012d3:	6a 00                	push   $0x0
  8012d5:	e8 49 fa ff ff       	call   800d23 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8012da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012df:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8012e8:	01 d8                	add    %ebx,%eax
  8012ea:	50                   	push   %eax
  8012eb:	6a 00                	push   $0x0
  8012ed:	e8 31 fa ff ff       	call   800d23 <sys_page_unmap>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012fb:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801301:	7e df                	jle    8012e2 <dup+0xf7>
	return r;
  801303:	89 f0                	mov    %esi,%eax
}
  801305:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801308:	5b                   	pop    %ebx
  801309:	5e                   	pop    %esi
  80130a:	5f                   	pop    %edi
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
  801310:	53                   	push   %ebx
  801311:	83 ec 14             	sub    $0x14,%esp
  801314:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801317:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80131a:	50                   	push   %eax
  80131b:	53                   	push   %ebx
  80131c:	e8 59 fd ff ff       	call   80107a <fd_lookup>
  801321:	89 c2                	mov    %eax,%edx
  801323:	83 c4 08             	add    $0x8,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	78 1a                	js     801344 <read+0x37>
  80132a:	83 ec 08             	sub    $0x8,%esp
  80132d:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801330:	50                   	push   %eax
  801331:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801334:	ff 30                	pushl  (%eax)
  801336:	e8 01 fe ff ff       	call   80113c <dev_lookup>
  80133b:	89 c2                	mov    %eax,%edx
  80133d:	83 c4 10             	add    $0x10,%esp
  801340:	85 c0                	test   %eax,%eax
  801342:	79 04                	jns    801348 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801344:	89 d0                	mov    %edx,%eax
  801346:	eb 50                	jmp    801398 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801348:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80134b:	8b 40 08             	mov    0x8(%eax),%eax
  80134e:	83 e0 03             	and    $0x3,%eax
  801351:	83 f8 01             	cmp    $0x1,%eax
  801354:	75 1e                	jne    801374 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801356:	83 ec 04             	sub    $0x4,%esp
  801359:	53                   	push   %ebx
  80135a:	a1 84 60 80 00       	mov    0x806084,%eax
  80135f:	8b 40 4c             	mov    0x4c(%eax),%eax
  801362:	50                   	push   %eax
  801363:	68 dd 2a 80 00       	push   $0x802add
  801368:	e8 5b ef ff ff       	call   8002c8 <cprintf>
		return -E_INVAL;
  80136d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801372:	eb 24                	jmp    801398 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801374:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801377:	ff 70 04             	pushl  0x4(%eax)
  80137a:	ff 75 10             	pushl  0x10(%ebp)
  80137d:	ff 75 0c             	pushl  0xc(%ebp)
  801380:	50                   	push   %eax
  801381:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801384:	ff 50 08             	call   *0x8(%eax)
  801387:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801389:	83 c4 10             	add    $0x10,%esp
  80138c:	85 c0                	test   %eax,%eax
  80138e:	78 06                	js     801396 <read+0x89>
		fd->fd_offset += r;
  801390:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801393:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801396:	89 d0                	mov    %edx,%eax
}
  801398:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80139b:	c9                   	leave  
  80139c:	c3                   	ret    

0080139d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80139d:	55                   	push   %ebp
  80139e:	89 e5                	mov    %esp,%ebp
  8013a0:	57                   	push   %edi
  8013a1:	56                   	push   %esi
  8013a2:	53                   	push   %ebx
  8013a3:	83 ec 0c             	sub    $0xc,%esp
  8013a6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8013a9:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ac:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b1:	39 f3                	cmp    %esi,%ebx
  8013b3:	73 25                	jae    8013da <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013b5:	83 ec 04             	sub    $0x4,%esp
  8013b8:	89 f0                	mov    %esi,%eax
  8013ba:	29 d8                	sub    %ebx,%eax
  8013bc:	50                   	push   %eax
  8013bd:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8013c0:	50                   	push   %eax
  8013c1:	ff 75 08             	pushl  0x8(%ebp)
  8013c4:	e8 44 ff ff ff       	call   80130d <read>
		if (m < 0)
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 0c                	js     8013dc <readn+0x3f>
			return m;
		if (m == 0)
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	74 06                	je     8013da <readn+0x3d>
  8013d4:	01 c3                	add    %eax,%ebx
  8013d6:	39 f3                	cmp    %esi,%ebx
  8013d8:	72 db                	jb     8013b5 <readn+0x18>
			break;
	}
	return tot;
  8013da:	89 d8                	mov    %ebx,%eax
}
  8013dc:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8013df:	5b                   	pop    %ebx
  8013e0:	5e                   	pop    %esi
  8013e1:	5f                   	pop    %edi
  8013e2:	c9                   	leave  
  8013e3:	c3                   	ret    

008013e4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	53                   	push   %ebx
  8013e8:	83 ec 14             	sub    $0x14,%esp
  8013eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ee:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8013f1:	50                   	push   %eax
  8013f2:	53                   	push   %ebx
  8013f3:	e8 82 fc ff ff       	call   80107a <fd_lookup>
  8013f8:	89 c2                	mov    %eax,%edx
  8013fa:	83 c4 08             	add    $0x8,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 1a                	js     80141b <write+0x37>
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801407:	50                   	push   %eax
  801408:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80140b:	ff 30                	pushl  (%eax)
  80140d:	e8 2a fd ff ff       	call   80113c <dev_lookup>
  801412:	89 c2                	mov    %eax,%edx
  801414:	83 c4 10             	add    $0x10,%esp
  801417:	85 c0                	test   %eax,%eax
  801419:	79 04                	jns    80141f <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  80141b:	89 d0                	mov    %edx,%eax
  80141d:	eb 4b                	jmp    80146a <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80141f:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801422:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801426:	75 1e                	jne    801446 <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801428:	83 ec 04             	sub    $0x4,%esp
  80142b:	53                   	push   %ebx
  80142c:	a1 84 60 80 00       	mov    0x806084,%eax
  801431:	8b 40 4c             	mov    0x4c(%eax),%eax
  801434:	50                   	push   %eax
  801435:	68 f9 2a 80 00       	push   $0x802af9
  80143a:	e8 89 ee ff ff       	call   8002c8 <cprintf>
		return -E_INVAL;
  80143f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801444:	eb 24                	jmp    80146a <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801446:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801449:	ff 70 04             	pushl  0x4(%eax)
  80144c:	ff 75 10             	pushl  0x10(%ebp)
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	50                   	push   %eax
  801453:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801456:	ff 50 0c             	call   *0xc(%eax)
  801459:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	85 c0                	test   %eax,%eax
  801460:	7e 06                	jle    801468 <write+0x84>
		fd->fd_offset += r;
  801462:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801465:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801468:	89 d0                	mov    %edx,%eax
}
  80146a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <seek>:

int
seek(int fdnum, off_t offset)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801475:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801478:	50                   	push   %eax
  801479:	ff 75 08             	pushl  0x8(%ebp)
  80147c:	e8 f9 fb ff ff       	call   80107a <fd_lookup>
  801481:	83 c4 08             	add    $0x8,%esp
		return r;
  801484:	89 c2                	mov    %eax,%edx
  801486:	85 c0                	test   %eax,%eax
  801488:	78 0e                	js     801498 <seek+0x29>
	fd->fd_offset = offset;
  80148a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801490:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801493:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801498:	89 d0                	mov    %edx,%eax
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	53                   	push   %ebx
  8014a0:	83 ec 14             	sub    $0x14,%esp
  8014a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a6:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8014a9:	50                   	push   %eax
  8014aa:	53                   	push   %ebx
  8014ab:	e8 ca fb ff ff       	call   80107a <fd_lookup>
  8014b0:	83 c4 08             	add    $0x8,%esp
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	78 4e                	js     801505 <ftruncate+0x69>
  8014b7:	83 ec 08             	sub    $0x8,%esp
  8014ba:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8014bd:	50                   	push   %eax
  8014be:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8014c1:	ff 30                	pushl  (%eax)
  8014c3:	e8 74 fc ff ff       	call   80113c <dev_lookup>
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	78 36                	js     801505 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014cf:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8014d2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d6:	75 1e                	jne    8014f6 <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014d8:	83 ec 04             	sub    $0x4,%esp
  8014db:	53                   	push   %ebx
  8014dc:	a1 84 60 80 00       	mov    0x806084,%eax
  8014e1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014e4:	50                   	push   %eax
  8014e5:	68 bc 2a 80 00       	push   $0x802abc
  8014ea:	e8 d9 ed ff ff       	call   8002c8 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8014ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f4:	eb 0f                	jmp    801505 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8014f6:	83 ec 08             	sub    $0x8,%esp
  8014f9:	ff 75 0c             	pushl  0xc(%ebp)
  8014fc:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8014ff:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801502:	ff 50 1c             	call   *0x1c(%eax)
}
  801505:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	53                   	push   %ebx
  80150e:	83 ec 14             	sub    $0x14,%esp
  801511:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801514:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801517:	50                   	push   %eax
  801518:	ff 75 08             	pushl  0x8(%ebp)
  80151b:	e8 5a fb ff ff       	call   80107a <fd_lookup>
  801520:	83 c4 08             	add    $0x8,%esp
  801523:	85 c0                	test   %eax,%eax
  801525:	78 42                	js     801569 <fstat+0x5f>
  801527:	83 ec 08             	sub    $0x8,%esp
  80152a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80152d:	50                   	push   %eax
  80152e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801531:	ff 30                	pushl  (%eax)
  801533:	e8 04 fc ff ff       	call   80113c <dev_lookup>
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 2a                	js     801569 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  80153f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801542:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801549:	00 00 00 
	stat->st_isdir = 0;
  80154c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801553:	00 00 00 
	stat->st_dev = dev;
  801556:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801559:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80155f:	83 ec 08             	sub    $0x8,%esp
  801562:	53                   	push   %ebx
  801563:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801566:	ff 50 14             	call   *0x14(%eax)
}
  801569:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	56                   	push   %esi
  801572:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801573:	83 ec 08             	sub    $0x8,%esp
  801576:	6a 00                	push   $0x0
  801578:	ff 75 08             	pushl  0x8(%ebp)
  80157b:	e8 28 00 00 00       	call   8015a8 <open>
  801580:	89 c6                	mov    %eax,%esi
  801582:	83 c4 10             	add    $0x10,%esp
  801585:	85 f6                	test   %esi,%esi
  801587:	78 18                	js     8015a1 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801589:	83 ec 08             	sub    $0x8,%esp
  80158c:	ff 75 0c             	pushl  0xc(%ebp)
  80158f:	56                   	push   %esi
  801590:	e8 75 ff ff ff       	call   80150a <fstat>
  801595:	89 c3                	mov    %eax,%ebx
	close(fd);
  801597:	89 34 24             	mov    %esi,(%esp)
  80159a:	e8 fb fb ff ff       	call   80119a <close>
	return r;
  80159f:	89 d8                	mov    %ebx,%eax
}
  8015a1:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8015a4:	5b                   	pop    %ebx
  8015a5:	5e                   	pop    %esi
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	53                   	push   %ebx
  8015ac:	83 ec 10             	sub    $0x10,%esp
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
  8015af:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8015b2:	50                   	push   %eax
  8015b3:	e8 68 fa ff ff       	call   801020 <fd_alloc>
  8015b8:	89 c3                	mov    %eax,%ebx
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	85 db                	test   %ebx,%ebx
  8015bf:	78 36                	js     8015f7 <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  8015c1:	83 ec 04             	sub    $0x4,%esp
  8015c4:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8015c7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ca:	ff 75 08             	pushl  0x8(%ebp)
  8015cd:	e8 37 06 00 00       	call   801c09 <fsipc_open>
  8015d2:	89 c3                	mov    %eax,%ebx
  8015d4:	83 c4 10             	add    $0x10,%esp
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	79 11                	jns    8015ec <open+0x44>
          fd_close(fd_store, 0);
  8015db:	83 ec 08             	sub    $0x8,%esp
  8015de:	6a 00                	push   $0x0
  8015e0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8015e3:	e8 e0 fa ff ff       	call   8010c8 <fd_close>
          return r;
  8015e8:	89 d8                	mov    %ebx,%eax
  8015ea:	eb 0b                	jmp    8015f7 <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  8015ec:	83 ec 0c             	sub    $0xc,%esp
  8015ef:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8015f2:	e8 19 fa ff ff       	call   801010 <fd2num>
}
  8015f7:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8015fa:	c9                   	leave  
  8015fb:	c3                   	ret    

008015fc <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	53                   	push   %ebx
  801600:	83 ec 04             	sub    $0x4,%esp
  801603:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  801606:	6a 01                	push   $0x1
  801608:	6a 00                	push   $0x0
  80160a:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801610:	53                   	push   %ebx
  801611:	e8 e7 03 00 00       	call   8019fd <funmap>
  801616:	83 c4 10             	add    $0x10,%esp
          return r;
  801619:	89 c2                	mov    %eax,%edx
  80161b:	85 c0                	test   %eax,%eax
  80161d:	78 19                	js     801638 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  80161f:	83 ec 0c             	sub    $0xc,%esp
  801622:	ff 73 0c             	pushl  0xc(%ebx)
  801625:	e8 84 06 00 00       	call   801cae <fsipc_close>
  80162a:	83 c4 10             	add    $0x10,%esp
          return r;
  80162d:	89 c2                	mov    %eax,%edx
  80162f:	85 c0                	test   %eax,%eax
  801631:	78 05                	js     801638 <file_close+0x3c>
        }
        return 0;
  801633:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801638:	89 d0                	mov    %edx,%eax
  80163a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	57                   	push   %edi
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
  801645:	83 ec 0c             	sub    $0xc,%esp
  801648:	8b 75 10             	mov    0x10(%ebp),%esi
  80164b:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  801657:	b9 00 00 00 00       	mov    $0x0,%ecx
  80165c:	39 d7                	cmp    %edx,%edi
  80165e:	0f 87 95 00 00 00    	ja     8016f9 <file_read+0xba>
	if (offset + n > size)
  801664:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801667:	39 d0                	cmp    %edx,%eax
  801669:	76 04                	jbe    80166f <file_read+0x30>
		n = size - offset;
  80166b:	89 d6                	mov    %edx,%esi
  80166d:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  80166f:	83 ec 0c             	sub    $0xc,%esp
  801672:	ff 75 08             	pushl  0x8(%ebp)
  801675:	e8 7e f9 ff ff       	call   800ff8 <fd2data>
  80167a:	89 c3                	mov    %eax,%ebx
  80167c:	01 fb                	add    %edi,%ebx
  80167e:	83 c4 10             	add    $0x10,%esp
  801681:	eb 41                	jmp    8016c4 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801683:	89 d8                	mov    %ebx,%eax
  801685:	c1 e8 16             	shr    $0x16,%eax
  801688:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80168f:	a8 01                	test   $0x1,%al
  801691:	74 10                	je     8016a3 <file_read+0x64>
  801693:	89 d8                	mov    %ebx,%eax
  801695:	c1 e8 0c             	shr    $0xc,%eax
  801698:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80169f:	a8 01                	test   $0x1,%al
  8016a1:	75 1b                	jne    8016be <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8d 04 37             	lea    (%edi,%esi,1),%eax
  8016a9:	50                   	push   %eax
  8016aa:	57                   	push   %edi
  8016ab:	ff 75 08             	pushl  0x8(%ebp)
  8016ae:	e8 d4 02 00 00       	call   801987 <fmap>
  8016b3:	83 c4 10             	add    $0x10,%esp
              return r;
  8016b6:	89 c1                	mov    %eax,%ecx
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	78 3d                	js     8016f9 <file_read+0xba>
  8016bc:	eb 1c                	jmp    8016da <file_read+0x9b>
  8016be:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016c4:	83 ec 0c             	sub    $0xc,%esp
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	e8 29 f9 ff ff       	call   800ff8 <fd2data>
  8016cf:	01 f8                	add    %edi,%eax
  8016d1:	01 f0                	add    %esi,%eax
  8016d3:	83 c4 10             	add    $0x10,%esp
  8016d6:	39 d8                	cmp    %ebx,%eax
  8016d8:	77 a9                	ja     801683 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	56                   	push   %esi
  8016de:	83 ec 04             	sub    $0x4,%esp
  8016e1:	ff 75 08             	pushl  0x8(%ebp)
  8016e4:	e8 0f f9 ff ff       	call   800ff8 <fd2data>
  8016e9:	83 c4 08             	add    $0x8,%esp
  8016ec:	01 f8                	add    %edi,%eax
  8016ee:	50                   	push   %eax
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	e8 51 f3 ff ff       	call   800a48 <memmove>
	return n;
  8016f7:	89 f1                	mov    %esi,%ecx
}
  8016f9:	89 c8                	mov    %ecx,%eax
  8016fb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8016fe:	5b                   	pop    %ebx
  8016ff:	5e                   	pop    %esi
  801700:	5f                   	pop    %edi
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	56                   	push   %esi
  801707:	53                   	push   %ebx
  801708:	83 ec 18             	sub    $0x18,%esp
  80170b:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80170e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801711:	50                   	push   %eax
  801712:	ff 75 08             	pushl  0x8(%ebp)
  801715:	e8 60 f9 ff ff       	call   80107a <fd_lookup>
  80171a:	83 c4 10             	add    $0x10,%esp
		return r;
  80171d:	89 c2                	mov    %eax,%edx
  80171f:	85 c0                	test   %eax,%eax
  801721:	0f 88 9f 00 00 00    	js     8017c6 <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801727:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80172a:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  80172c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801731:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  801737:	0f 85 89 00 00 00    	jne    8017c6 <read_map+0xc3>
	va = fd2data(fd) + offset;
  80173d:	83 ec 0c             	sub    $0xc,%esp
  801740:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801743:	e8 b0 f8 ff ff       	call   800ff8 <fd2data>
  801748:	89 c3                	mov    %eax,%ebx
  80174a:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  80174c:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  80174f:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801754:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  80175a:	7f 6a                	jg     8017c6 <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  80175c:	89 d8                	mov    %ebx,%eax
  80175e:	c1 e8 16             	shr    $0x16,%eax
  801761:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801768:	a8 01                	test   $0x1,%al
  80176a:	74 10                	je     80177c <read_map+0x79>
  80176c:	89 d8                	mov    %ebx,%eax
  80176e:	c1 e8 0c             	shr    $0xc,%eax
  801771:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801778:	a8 01                	test   $0x1,%al
  80177a:	75 19                	jne    801795 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  80177c:	83 ec 04             	sub    $0x4,%esp
  80177f:	8d 46 01             	lea    0x1(%esi),%eax
  801782:	50                   	push   %eax
  801783:	56                   	push   %esi
  801784:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801787:	e8 fb 01 00 00       	call   801987 <fmap>
  80178c:	83 c4 10             	add    $0x10,%esp
            return r;
  80178f:	89 c2                	mov    %eax,%edx
  801791:	85 c0                	test   %eax,%eax
  801793:	78 31                	js     8017c6 <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801795:	89 d8                	mov    %ebx,%eax
  801797:	c1 e8 16             	shr    $0x16,%eax
  80179a:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8017a1:	a8 01                	test   $0x1,%al
  8017a3:	74 10                	je     8017b5 <read_map+0xb2>
  8017a5:	89 d8                	mov    %ebx,%eax
  8017a7:	c1 e8 0c             	shr    $0xc,%eax
  8017aa:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8017b1:	a8 01                	test   $0x1,%al
  8017b3:	75 07                	jne    8017bc <read_map+0xb9>
		return -E_NO_DISK;
  8017b5:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8017ba:	eb 0a                	jmp    8017c6 <read_map+0xc3>

	*blk = (void*) va;
  8017bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bf:	89 18                	mov    %ebx,(%eax)
	return 0;
  8017c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017c6:	89 d0                	mov    %edx,%eax
  8017c8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8017cb:	5b                   	pop    %ebx
  8017cc:	5e                   	pop    %esi
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	57                   	push   %edi
  8017d3:	56                   	push   %esi
  8017d4:	53                   	push   %ebx
  8017d5:	83 ec 0c             	sub    $0xc,%esp
  8017d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8017db:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  8017de:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e1:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  8017e4:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  8017e9:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8017ef:	0f 87 bd 00 00 00    	ja     8018b2 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  8017f5:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  8017fb:	73 17                	jae    801814 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	52                   	push   %edx
  801801:	56                   	push   %esi
  801802:	e8 fb 00 00 00       	call   801902 <file_trunc>
  801807:	83 c4 10             	add    $0x10,%esp
			return r;
  80180a:	89 c1                	mov    %eax,%ecx
  80180c:	85 c0                	test   %eax,%eax
  80180e:	0f 88 9e 00 00 00    	js     8018b2 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801814:	83 ec 0c             	sub    $0xc,%esp
  801817:	56                   	push   %esi
  801818:	e8 db f7 ff ff       	call   800ff8 <fd2data>
  80181d:	89 c3                	mov    %eax,%ebx
  80181f:	01 fb                	add    %edi,%ebx
  801821:	83 c4 10             	add    $0x10,%esp
  801824:	eb 42                	jmp    801868 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801826:	89 d8                	mov    %ebx,%eax
  801828:	c1 e8 16             	shr    $0x16,%eax
  80182b:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801832:	a8 01                	test   $0x1,%al
  801834:	74 10                	je     801846 <file_write+0x77>
  801836:	89 d8                	mov    %ebx,%eax
  801838:	c1 e8 0c             	shr    $0xc,%eax
  80183b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801842:	a8 01                	test   $0x1,%al
  801844:	75 1c                	jne    801862 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801846:	83 ec 04             	sub    $0x4,%esp
  801849:	8b 55 10             	mov    0x10(%ebp),%edx
  80184c:	8d 04 17             	lea    (%edi,%edx,1),%eax
  80184f:	50                   	push   %eax
  801850:	57                   	push   %edi
  801851:	56                   	push   %esi
  801852:	e8 30 01 00 00       	call   801987 <fmap>
  801857:	83 c4 10             	add    $0x10,%esp
              return r;
  80185a:	89 c1                	mov    %eax,%ecx
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 52                	js     8018b2 <file_write+0xe3>
  801860:	eb 1b                	jmp    80187d <file_write+0xae>
  801862:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801868:	83 ec 0c             	sub    $0xc,%esp
  80186b:	56                   	push   %esi
  80186c:	e8 87 f7 ff ff       	call   800ff8 <fd2data>
  801871:	01 f8                	add    %edi,%eax
  801873:	03 45 10             	add    0x10(%ebp),%eax
  801876:	83 c4 10             	add    $0x10,%esp
  801879:	39 d8                	cmp    %ebx,%eax
  80187b:	77 a9                	ja     801826 <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  80187d:	83 ec 0c             	sub    $0xc,%esp
  801880:	68 16 2b 80 00       	push   $0x802b16
  801885:	e8 3e ea ff ff       	call   8002c8 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  80188a:	83 c4 0c             	add    $0xc,%esp
  80188d:	ff 75 10             	pushl  0x10(%ebp)
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	56                   	push   %esi
  801894:	e8 5f f7 ff ff       	call   800ff8 <fd2data>
  801899:	01 f8                	add    %edi,%eax
  80189b:	89 04 24             	mov    %eax,(%esp)
  80189e:	e8 a5 f1 ff ff       	call   800a48 <memmove>
        cprintf("write done\n");
  8018a3:	c7 04 24 23 2b 80 00 	movl   $0x802b23,(%esp)
  8018aa:	e8 19 ea ff ff       	call   8002c8 <cprintf>
	return n;
  8018af:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  8018b2:	89 c8                	mov    %ecx,%eax
  8018b4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8018b7:	5b                   	pop    %ebx
  8018b8:	5e                   	pop    %esi
  8018b9:	5f                   	pop    %edi
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8018c4:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  8018c7:	83 ec 08             	sub    $0x8,%esp
  8018ca:	8d 43 10             	lea    0x10(%ebx),%eax
  8018cd:	50                   	push   %eax
  8018ce:	56                   	push   %esi
  8018cf:	e8 f8 ef ff ff       	call   8008cc <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  8018d4:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  8018da:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  8018ea:	0f 94 c0             	sete   %al
  8018ed:	0f b6 c0             	movzbl %al,%eax
  8018f0:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  8018f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fb:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8018fe:	5b                   	pop    %ebx
  8018ff:	5e                   	pop    %esi
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	57                   	push   %edi
  801906:	56                   	push   %esi
  801907:	53                   	push   %ebx
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	8b 75 08             	mov    0x8(%ebp),%esi
  80190e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801911:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801916:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  80191c:	7f 5f                	jg     80197d <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  80191e:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801924:	83 ec 08             	sub    $0x8,%esp
  801927:	53                   	push   %ebx
  801928:	ff 76 0c             	pushl  0xc(%esi)
  80192b:	e8 56 03 00 00       	call   801c86 <fsipc_set_size>
  801930:	83 c4 10             	add    $0x10,%esp
		return r;
  801933:	89 c2                	mov    %eax,%edx
  801935:	85 c0                	test   %eax,%eax
  801937:	78 44                	js     80197d <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801939:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  80193f:	74 19                	je     80195a <file_trunc+0x58>
  801941:	68 50 2b 80 00       	push   $0x802b50
  801946:	68 2f 2b 80 00       	push   $0x802b2f
  80194b:	68 dc 00 00 00       	push   $0xdc
  801950:	68 44 2b 80 00       	push   $0x802b44
  801955:	e8 7e e8 ff ff       	call   8001d8 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  80195a:	83 ec 04             	sub    $0x4,%esp
  80195d:	53                   	push   %ebx
  80195e:	57                   	push   %edi
  80195f:	56                   	push   %esi
  801960:	e8 22 00 00 00       	call   801987 <fmap>
  801965:	83 c4 10             	add    $0x10,%esp
		return r;
  801968:	89 c2                	mov    %eax,%edx
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 0f                	js     80197d <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  80196e:	6a 00                	push   $0x0
  801970:	53                   	push   %ebx
  801971:	57                   	push   %edi
  801972:	56                   	push   %esi
  801973:	e8 85 00 00 00       	call   8019fd <funmap>

	return 0;
  801978:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80197d:	89 d0                	mov    %edx,%eax
  80197f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801982:	5b                   	pop    %ebx
  801983:	5e                   	pop    %esi
  801984:	5f                   	pop    %edi
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <fmap>:

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
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	57                   	push   %edi
  80198b:	56                   	push   %esi
  80198c:	53                   	push   %ebx
  80198d:	83 ec 0c             	sub    $0xc,%esp
  801990:	8b 7d 08             	mov    0x8(%ebp),%edi
  801993:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801996:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801999:	7d 55                	jge    8019f0 <fmap+0x69>
          fma = fd2data(fd);
  80199b:	83 ec 0c             	sub    $0xc,%esp
  80199e:	57                   	push   %edi
  80199f:	e8 54 f6 ff ff       	call   800ff8 <fd2data>
  8019a4:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	05 ff 0f 00 00       	add    $0xfff,%eax
  8019b2:	89 c3                	mov    %eax,%ebx
  8019b4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8019ba:	39 f3                	cmp    %esi,%ebx
  8019bc:	7d 32                	jge    8019f0 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  8019be:	83 ec 04             	sub    $0x4,%esp
  8019c1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8019c4:	01 d8                	add    %ebx,%eax
  8019c6:	50                   	push   %eax
  8019c7:	53                   	push   %ebx
  8019c8:	ff 77 0c             	pushl  0xc(%edi)
  8019cb:	e8 8b 02 00 00       	call   801c5b <fsipc_map>
  8019d0:	83 c4 10             	add    $0x10,%esp
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	79 0f                	jns    8019e6 <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	53                   	push   %ebx
  8019dd:	57                   	push   %edi
  8019de:	e8 1a 00 00 00       	call   8019fd <funmap>
  8019e3:	83 c4 10             	add    $0x10,%esp
  8019e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8019ec:	39 f3                	cmp    %esi,%ebx
  8019ee:	7c ce                	jl     8019be <fmap+0x37>
            }
          }
        }

        return 0;
}
  8019f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8019f8:	5b                   	pop    %ebx
  8019f9:	5e                   	pop    %esi
  8019fa:	5f                   	pop    %edi
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <funmap>:

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
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	57                   	push   %edi
  801a01:	56                   	push   %esi
  801a02:	53                   	push   %ebx
  801a03:	83 ec 0c             	sub    $0xc,%esp
  801a06:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a09:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801a0c:	39 f3                	cmp    %esi,%ebx
  801a0e:	0f 8d 80 00 00 00    	jge    801a94 <funmap+0x97>
          fma = fd2data(fd);
  801a14:	83 ec 0c             	sub    $0xc,%esp
  801a17:	ff 75 08             	pushl  0x8(%ebp)
  801a1a:	e8 d9 f5 ff ff       	call   800ff8 <fd2data>
  801a1f:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801a21:	83 c4 10             	add    $0x10,%esp
  801a24:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801a2a:	89 c3                	mov    %eax,%ebx
  801a2c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801a32:	39 f3                	cmp    %esi,%ebx
  801a34:	7d 5e                	jge    801a94 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801a36:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801a39:	89 c2                	mov    %eax,%edx
  801a3b:	c1 ea 0c             	shr    $0xc,%edx
  801a3e:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801a45:	a8 01                	test   $0x1,%al
  801a47:	74 41                	je     801a8a <funmap+0x8d>
              if (dirty) {
  801a49:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801a4d:	74 21                	je     801a70 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801a4f:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801a56:	a8 40                	test   $0x40,%al
  801a58:	74 16                	je     801a70 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801a5a:	83 ec 08             	sub    $0x8,%esp
  801a5d:	53                   	push   %ebx
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	ff 70 0c             	pushl  0xc(%eax)
  801a64:	e8 65 02 00 00       	call   801cce <fsipc_dirty>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 29                	js     801a99 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801a70:	83 ec 08             	sub    $0x8,%esp
  801a73:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801a76:	50                   	push   %eax
  801a77:	83 ec 04             	sub    $0x4,%esp
  801a7a:	e8 e1 f1 ff ff       	call   800c60 <sys_getenvid>
  801a7f:	89 04 24             	mov    %eax,(%esp)
  801a82:	e8 9c f2 ff ff       	call   800d23 <sys_page_unmap>
  801a87:	83 c4 10             	add    $0x10,%esp
  801a8a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a90:	39 f3                	cmp    %esi,%ebx
  801a92:	7c a2                	jl     801a36 <funmap+0x39>
            }
          }
        }

        return 0;
  801a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a99:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801a9c:	5b                   	pop    %ebx
  801a9d:	5e                   	pop    %esi
  801a9e:	5f                   	pop    %edi
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <remove>:

// Delete a file
int
remove(const char *path)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801aa7:	ff 75 08             	pushl  0x8(%ebp)
  801aaa:	e8 47 02 00 00       	call   801cf6 <fsipc_remove>
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801ab7:	e8 80 02 00 00       	call   801d3c <fsipc_sync>
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    
	...

00801ac0 <writebuf>:


static void
writebuf(struct printbuf *b)
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	53                   	push   %ebx
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (b->error > 0) {
  801aca:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
  801ace:	7e 2c                	jle    801afc <writebuf+0x3c>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801ad0:	83 ec 04             	sub    $0x4,%esp
  801ad3:	ff 73 04             	pushl  0x4(%ebx)
  801ad6:	8d 43 10             	lea    0x10(%ebx),%eax
  801ad9:	50                   	push   %eax
  801ada:	ff 33                	pushl  (%ebx)
  801adc:	e8 03 f9 ff ff       	call   8013e4 <write>
		if (result > 0)
  801ae1:	83 c4 10             	add    $0x10,%esp
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	7e 03                	jle    801aeb <writebuf+0x2b>
			b->result += result;
  801ae8:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801aeb:	39 43 04             	cmp    %eax,0x4(%ebx)
  801aee:	74 0c                	je     801afc <writebuf+0x3c>
			b->error = (result < 0 ? result : 0);
  801af0:	85 c0                	test   %eax,%eax
  801af2:	7e 05                	jle    801af9 <writebuf+0x39>
  801af4:	b8 00 00 00 00       	mov    $0x0,%eax
  801af9:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801afc:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <putch>:

static void
putch(int ch, void *thunk)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	53                   	push   %ebx
  801b05:	83 ec 04             	sub    $0x4,%esp
  801b08:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801b0b:	8b 43 04             	mov    0x4(%ebx),%eax
  801b0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b11:	88 54 18 10          	mov    %dl,0x10(%eax,%ebx,1)
  801b15:	40                   	inc    %eax
  801b16:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801b19:	3d 00 01 00 00       	cmp    $0x100,%eax
  801b1e:	75 13                	jne    801b33 <putch+0x32>
		writebuf(b);
  801b20:	83 ec 0c             	sub    $0xc,%esp
  801b23:	53                   	push   %ebx
  801b24:	e8 97 ff ff ff       	call   801ac0 <writebuf>
		b->idx = 0;
  801b29:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  801b30:	83 c4 10             	add    $0x10,%esp
	}
}
  801b33:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	53                   	push   %ebx
  801b3c:	81 ec 14 01 00 00    	sub    $0x114,%esp
	struct printbuf b;

	b.fd = fd;
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	89 85 e8 fe ff ff    	mov    %eax,0xfffffee8(%ebp)
	b.idx = 0;
  801b4b:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  801b52:	00 00 00 
	b.result = 0;
  801b55:	c7 85 f0 fe ff ff 00 	movl   $0x0,0xfffffef0(%ebp)
  801b5c:	00 00 00 
	b.error = 1;
  801b5f:	c7 85 f4 fe ff ff 01 	movl   $0x1,0xfffffef4(%ebp)
  801b66:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b69:	ff 75 10             	pushl  0x10(%ebp)
  801b6c:	ff 75 0c             	pushl  0xc(%ebp)
  801b6f:	8d 9d e8 fe ff ff    	lea    0xfffffee8(%ebp),%ebx
  801b75:	53                   	push   %ebx
  801b76:	68 01 1b 80 00       	push   $0x801b01
  801b7b:	e8 7a e8 ff ff       	call   8003fa <vprintfmt>
	if (b.idx > 0)
  801b80:	83 c4 10             	add    $0x10,%esp
  801b83:	83 bd ec fe ff ff 00 	cmpl   $0x0,0xfffffeec(%ebp)
  801b8a:	7e 0c                	jle    801b98 <vfprintf+0x60>
		writebuf(&b);
  801b8c:	83 ec 0c             	sub    $0xc,%esp
  801b8f:	53                   	push   %ebx
  801b90:	e8 2b ff ff ff       	call   801ac0 <writebuf>
  801b95:	83 c4 10             	add    $0x10,%esp

	return (b.result ? b.result : b.error);
  801b98:	8b 85 f0 fe ff ff    	mov    0xfffffef0(%ebp),%eax
  801b9e:	85 c0                	test   %eax,%eax
  801ba0:	75 06                	jne    801ba8 <vfprintf+0x70>
  801ba2:	8b 85 f4 fe ff ff    	mov    0xfffffef4(%ebp),%eax
}
  801ba8:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801bb3:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801bb6:	50                   	push   %eax
  801bb7:	ff 75 0c             	pushl  0xc(%ebp)
  801bba:	ff 75 08             	pushl  0x8(%ebp)
  801bbd:	e8 76 ff ff ff       	call   801b38 <vfprintf>
	va_end(ap);

	return cnt;
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <printf>:

int
printf(const char *fmt, ...)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801bca:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801bcd:	50                   	push   %eax
  801bce:	ff 75 08             	pushl  0x8(%ebp)
  801bd1:	6a 01                	push   $0x1
  801bd3:	e8 60 ff ff ff       	call   801b38 <vfprintf>
	va_end(ap);

	return cnt;
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    
	...

00801bdc <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801be2:	6a 07                	push   $0x7
  801be4:	ff 75 0c             	pushl  0xc(%ebp)
  801be7:	ff 75 08             	pushl  0x8(%ebp)
  801bea:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801bef:	50                   	push   %eax
  801bf0:	e8 c6 06 00 00       	call   8022bb <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801bf5:	83 c4 0c             	add    $0xc,%esp
  801bf8:	ff 75 14             	pushl  0x14(%ebp)
  801bfb:	ff 75 10             	pushl  0x10(%ebp)
  801bfe:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801c01:	50                   	push   %eax
  801c02:	e8 51 06 00 00       	call   802258 <ipc_recv>
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	56                   	push   %esi
  801c0d:	53                   	push   %ebx
  801c0e:	83 ec 1c             	sub    $0x1c,%esp
  801c11:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801c14:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801c19:	56                   	push   %esi
  801c1a:	e8 71 ec ff ff       	call   800890 <strlen>
  801c1f:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801c22:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801c27:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c2c:	7f 24                	jg     801c52 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801c2e:	83 ec 08             	sub    $0x8,%esp
  801c31:	56                   	push   %esi
  801c32:	53                   	push   %ebx
  801c33:	e8 94 ec ff ff       	call   8008cc <strcpy>
	req->req_omode = omode;
  801c38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3b:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801c41:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801c44:	50                   	push   %eax
  801c45:	ff 75 10             	pushl  0x10(%ebp)
  801c48:	53                   	push   %ebx
  801c49:	6a 01                	push   $0x1
  801c4b:	e8 8c ff ff ff       	call   801bdc <fsipc>
  801c50:	89 c2                	mov    %eax,%edx
}
  801c52:	89 d0                	mov    %edx,%eax
  801c54:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6c:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801c71:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801c74:	50                   	push   %eax
  801c75:	ff 75 10             	pushl  0x10(%ebp)
  801c78:	68 00 30 80 00       	push   $0x803000
  801c7d:	6a 02                	push   $0x2
  801c7f:	e8 58 ff ff ff       	call   801bdc <fsipc>

	//return -E_UNSPECIFIED;
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  801c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c97:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	68 00 30 80 00       	push   $0x803000
  801ca5:	6a 03                	push   $0x3
  801ca7:	e8 30 ff ff ff       	call   801bdc <fsipc>
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	68 00 30 80 00       	push   $0x803000
  801cc5:	6a 04                	push   $0x4
  801cc7:	e8 10 ff ff ff       	call   801bdc <fsipc>
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdf:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	68 00 30 80 00       	push   $0x803000
  801ced:	6a 05                	push   $0x5
  801cef:	e8 e8 fe ff ff       	call   801bdc <fsipc>
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	56                   	push   %esi
  801cfa:	53                   	push   %ebx
  801cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801cfe:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801d03:	83 ec 0c             	sub    $0xc,%esp
  801d06:	53                   	push   %ebx
  801d07:	e8 84 eb ff ff       	call   800890 <strlen>
  801d0c:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801d0f:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801d14:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d19:	7f 18                	jg     801d33 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801d1b:	83 ec 08             	sub    $0x8,%esp
  801d1e:	53                   	push   %ebx
  801d1f:	56                   	push   %esi
  801d20:	e8 a7 eb ff ff       	call   8008cc <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	56                   	push   %esi
  801d2a:	6a 06                	push   $0x6
  801d2c:	e8 ab fe ff ff       	call   801bdc <fsipc>
  801d31:	89 c2                	mov    %eax,%edx
}
  801d33:	89 d0                	mov    %edx,%eax
  801d35:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801d38:	5b                   	pop    %ebx
  801d39:	5e                   	pop    %esi
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	68 00 30 80 00       	push   $0x803000
  801d4b:	6a 07                	push   $0x7
  801d4d:	e8 8a fe ff ff       	call   801bdc <fsipc>
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <pipe>:
};

int
pipe(int pfd[2])
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	57                   	push   %edi
  801d58:	56                   	push   %esi
  801d59:	53                   	push   %ebx
  801d5a:	83 ec 18             	sub    $0x18,%esp
  801d5d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d60:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801d63:	50                   	push   %eax
  801d64:	e8 b7 f2 ff ff       	call   801020 <fd_alloc>
  801d69:	89 c3                	mov    %eax,%ebx
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	0f 88 25 01 00 00    	js     801e9b <pipe+0x147>
  801d76:	83 ec 04             	sub    $0x4,%esp
  801d79:	68 07 04 00 00       	push   $0x407
  801d7e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801d81:	6a 00                	push   $0x0
  801d83:	e8 16 ef ff ff       	call   800c9e <sys_page_alloc>
  801d88:	89 c3                	mov    %eax,%ebx
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	0f 88 06 01 00 00    	js     801e9b <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801d95:	83 ec 0c             	sub    $0xc,%esp
  801d98:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801d9b:	50                   	push   %eax
  801d9c:	e8 7f f2 ff ff       	call   801020 <fd_alloc>
  801da1:	89 c3                	mov    %eax,%ebx
  801da3:	83 c4 10             	add    $0x10,%esp
  801da6:	85 c0                	test   %eax,%eax
  801da8:	0f 88 dd 00 00 00    	js     801e8b <pipe+0x137>
  801dae:	83 ec 04             	sub    $0x4,%esp
  801db1:	68 07 04 00 00       	push   $0x407
  801db6:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801db9:	6a 00                	push   $0x0
  801dbb:	e8 de ee ff ff       	call   800c9e <sys_page_alloc>
  801dc0:	89 c3                	mov    %eax,%ebx
  801dc2:	83 c4 10             	add    $0x10,%esp
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	0f 88 be 00 00 00    	js     801e8b <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801dcd:	83 ec 0c             	sub    $0xc,%esp
  801dd0:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801dd3:	e8 20 f2 ff ff       	call   800ff8 <fd2data>
  801dd8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dda:	83 c4 0c             	add    $0xc,%esp
  801ddd:	68 07 04 00 00       	push   $0x407
  801de2:	50                   	push   %eax
  801de3:	6a 00                	push   $0x0
  801de5:	e8 b4 ee ff ff       	call   800c9e <sys_page_alloc>
  801dea:	89 c3                	mov    %eax,%ebx
  801dec:	83 c4 10             	add    $0x10,%esp
  801def:	85 c0                	test   %eax,%eax
  801df1:	0f 88 84 00 00 00    	js     801e7b <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	68 07 04 00 00       	push   $0x407
  801dff:	83 ec 0c             	sub    $0xc,%esp
  801e02:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801e05:	e8 ee f1 ff ff       	call   800ff8 <fd2data>
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	50                   	push   %eax
  801e0e:	6a 00                	push   $0x0
  801e10:	56                   	push   %esi
  801e11:	6a 00                	push   $0x0
  801e13:	e8 c9 ee ff ff       	call   800ce1 <sys_page_map>
  801e18:	89 c3                	mov    %eax,%ebx
  801e1a:	83 c4 20             	add    $0x20,%esp
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	78 4c                	js     801e6d <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801e21:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801e27:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801e2a:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e2c:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801e2f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801e36:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801e3c:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801e3f:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e41:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801e44:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  801e4b:	83 ec 0c             	sub    $0xc,%esp
  801e4e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801e51:	e8 ba f1 ff ff       	call   801010 <fd2num>
  801e56:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801e58:	83 c4 04             	add    $0x4,%esp
  801e5b:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801e5e:	e8 ad f1 ff ff       	call   801010 <fd2num>
  801e63:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	eb 30                	jmp    801e9d <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  801e6d:	83 ec 08             	sub    $0x8,%esp
  801e70:	56                   	push   %esi
  801e71:	6a 00                	push   $0x0
  801e73:	e8 ab ee ff ff       	call   800d23 <sys_page_unmap>
  801e78:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801e7b:	83 ec 08             	sub    $0x8,%esp
  801e7e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801e81:	6a 00                	push   $0x0
  801e83:	e8 9b ee ff ff       	call   800d23 <sys_page_unmap>
  801e88:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801e8b:	83 ec 08             	sub    $0x8,%esp
  801e8e:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801e91:	6a 00                	push   $0x0
  801e93:	e8 8b ee ff ff       	call   800d23 <sys_page_unmap>
  801e98:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  801e9b:	89 d8                	mov    %ebx,%eax
}
  801e9d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ea0:	5b                   	pop    %ebx
  801ea1:	5e                   	pop    %esi
  801ea2:	5f                   	pop    %edi
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
  801ea8:	57                   	push   %edi
  801ea9:	56                   	push   %esi
  801eaa:	53                   	push   %ebx
  801eab:	83 ec 0c             	sub    $0xc,%esp
  801eae:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801eb1:	a1 84 60 80 00       	mov    0x806084,%eax
  801eb6:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801eb9:	83 ec 0c             	sub    $0xc,%esp
  801ebc:	ff 75 08             	pushl  0x8(%ebp)
  801ebf:	e8 50 04 00 00       	call   802314 <pageref>
  801ec4:	89 c3                	mov    %eax,%ebx
  801ec6:	89 3c 24             	mov    %edi,(%esp)
  801ec9:	e8 46 04 00 00       	call   802314 <pageref>
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	39 c3                	cmp    %eax,%ebx
  801ed3:	0f 94 c0             	sete   %al
  801ed6:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  801ed9:	8b 0d 84 60 80 00    	mov    0x806084,%ecx
  801edf:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  801ee2:	39 c6                	cmp    %eax,%esi
  801ee4:	74 1b                	je     801f01 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  801ee6:	83 fa 01             	cmp    $0x1,%edx
  801ee9:	75 c6                	jne    801eb1 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801eeb:	6a 01                	push   $0x1
  801eed:	8b 41 58             	mov    0x58(%ecx),%eax
  801ef0:	50                   	push   %eax
  801ef1:	56                   	push   %esi
  801ef2:	68 78 2b 80 00       	push   $0x802b78
  801ef7:	e8 cc e3 ff ff       	call   8002c8 <cprintf>
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	eb b0                	jmp    801eb1 <_pipeisclosed+0xc>
	}
}
  801f01:	89 d0                	mov    %edx,%eax
  801f03:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801f06:	5b                   	pop    %ebx
  801f07:	5e                   	pop    %esi
  801f08:	5f                   	pop    %edi
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f11:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801f14:	50                   	push   %eax
  801f15:	ff 75 08             	pushl  0x8(%ebp)
  801f18:	e8 5d f1 ff ff       	call   80107a <fd_lookup>
  801f1d:	83 c4 10             	add    $0x10,%esp
		return r;
  801f20:	89 c2                	mov    %eax,%edx
  801f22:	85 c0                	test   %eax,%eax
  801f24:	78 19                	js     801f3f <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801f2c:	e8 c7 f0 ff ff       	call   800ff8 <fd2data>
	return _pipeisclosed(fd, p);
  801f31:	83 c4 08             	add    $0x8,%esp
  801f34:	50                   	push   %eax
  801f35:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801f38:	e8 68 ff ff ff       	call   801ea5 <_pipeisclosed>
  801f3d:	89 c2                	mov    %eax,%edx
}
  801f3f:	89 d0                	mov    %edx,%eax
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	57                   	push   %edi
  801f47:	56                   	push   %esi
  801f48:	53                   	push   %ebx
  801f49:	83 ec 18             	sub    $0x18,%esp
  801f4c:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  801f4f:	57                   	push   %edi
  801f50:	e8 a3 f0 ff ff       	call   800ff8 <fd2data>
  801f55:	89 c3                	mov    %eax,%ebx
	if (debug)
  801f57:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5d:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801f60:	be 00 00 00 00       	mov    $0x0,%esi
  801f65:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f68:	73 55                	jae    801fbf <piperead+0x7c>
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
  801f6a:	8b 03                	mov    (%ebx),%eax
  801f6c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f6f:	75 2c                	jne    801f9d <piperead+0x5a>
  801f71:	85 f6                	test   %esi,%esi
  801f73:	74 04                	je     801f79 <piperead+0x36>
  801f75:	89 f0                	mov    %esi,%eax
  801f77:	eb 48                	jmp    801fc1 <piperead+0x7e>
  801f79:	83 ec 08             	sub    $0x8,%esp
  801f7c:	53                   	push   %ebx
  801f7d:	57                   	push   %edi
  801f7e:	e8 22 ff ff ff       	call   801ea5 <_pipeisclosed>
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	85 c0                	test   %eax,%eax
  801f88:	74 07                	je     801f91 <piperead+0x4e>
  801f8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8f:	eb 30                	jmp    801fc1 <piperead+0x7e>
  801f91:	e8 e9 ec ff ff       	call   800c7f <sys_yield>
  801f96:	8b 03                	mov    (%ebx),%eax
  801f98:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f9b:	74 d4                	je     801f71 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f9d:	8b 13                	mov    (%ebx),%edx
  801f9f:	89 d0                	mov    %edx,%eax
  801fa1:	85 d2                	test   %edx,%edx
  801fa3:	79 03                	jns    801fa8 <piperead+0x65>
  801fa5:	8d 42 1f             	lea    0x1f(%edx),%eax
  801fa8:	83 e0 e0             	and    $0xffffffe0,%eax
  801fab:	29 c2                	sub    %eax,%edx
  801fad:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  801fb1:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801fb4:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801fb7:	ff 03                	incl   (%ebx)
  801fb9:	46                   	inc    %esi
  801fba:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fbd:	72 ab                	jb     801f6a <piperead+0x27>
	}
	return i;
  801fbf:	89 f0                	mov    %esi,%eax
}
  801fc1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801fc4:	5b                   	pop    %ebx
  801fc5:	5e                   	pop    %esi
  801fc6:	5f                   	pop    %edi
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	57                   	push   %edi
  801fcd:	56                   	push   %esi
  801fce:	53                   	push   %ebx
  801fcf:	83 ec 18             	sub    $0x18,%esp
  801fd2:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  801fd5:	57                   	push   %edi
  801fd6:	e8 1d f0 ff ff       	call   800ff8 <fd2data>
  801fdb:	89 c3                	mov    %eax,%ebx
	if (debug)
  801fdd:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe3:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801fe6:	be 00 00 00 00       	mov    $0x0,%esi
  801feb:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fee:	73 55                	jae    802045 <pipewrite+0x7c>
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
  801ff0:	8b 03                	mov    (%ebx),%eax
  801ff2:	83 c0 20             	add    $0x20,%eax
  801ff5:	39 43 04             	cmp    %eax,0x4(%ebx)
  801ff8:	72 27                	jb     802021 <pipewrite+0x58>
  801ffa:	83 ec 08             	sub    $0x8,%esp
  801ffd:	53                   	push   %ebx
  801ffe:	57                   	push   %edi
  801fff:	e8 a1 fe ff ff       	call   801ea5 <_pipeisclosed>
  802004:	83 c4 10             	add    $0x10,%esp
  802007:	85 c0                	test   %eax,%eax
  802009:	74 07                	je     802012 <pipewrite+0x49>
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
  802010:	eb 35                	jmp    802047 <pipewrite+0x7e>
  802012:	e8 68 ec ff ff       	call   800c7f <sys_yield>
  802017:	8b 03                	mov    (%ebx),%eax
  802019:	83 c0 20             	add    $0x20,%eax
  80201c:	39 43 04             	cmp    %eax,0x4(%ebx)
  80201f:	73 d9                	jae    801ffa <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802021:	8b 53 04             	mov    0x4(%ebx),%edx
  802024:	89 d0                	mov    %edx,%eax
  802026:	85 d2                	test   %edx,%edx
  802028:	79 03                	jns    80202d <pipewrite+0x64>
  80202a:	8d 42 1f             	lea    0x1f(%edx),%eax
  80202d:	83 e0 e0             	and    $0xffffffe0,%eax
  802030:	29 c2                	sub    %eax,%edx
  802032:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  802035:	8a 04 31             	mov    (%ecx,%esi,1),%al
  802038:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  80203c:	ff 43 04             	incl   0x4(%ebx)
  80203f:	46                   	inc    %esi
  802040:	3b 75 10             	cmp    0x10(%ebp),%esi
  802043:	72 ab                	jb     801ff0 <pipewrite+0x27>
	}
	
	return i;
  802045:	89 f0                	mov    %esi,%eax
}
  802047:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80204a:	5b                   	pop    %ebx
  80204b:	5e                   	pop    %esi
  80204c:	5f                   	pop    %edi
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
  802054:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802057:	83 ec 0c             	sub    $0xc,%esp
  80205a:	ff 75 08             	pushl  0x8(%ebp)
  80205d:	e8 96 ef ff ff       	call   800ff8 <fd2data>
  802062:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802064:	83 c4 08             	add    $0x8,%esp
  802067:	68 8b 2b 80 00       	push   $0x802b8b
  80206c:	53                   	push   %ebx
  80206d:	e8 5a e8 ff ff       	call   8008cc <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802072:	8b 46 04             	mov    0x4(%esi),%eax
  802075:	2b 06                	sub    (%esi),%eax
  802077:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80207d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802084:	00 00 00 
	stat->st_dev = &devpipe;
  802087:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  80208e:	60 80 00 
	return 0;
}
  802091:	b8 00 00 00 00       	mov    $0x0,%eax
  802096:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802099:	5b                   	pop    %ebx
  80209a:	5e                   	pop    %esi
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	53                   	push   %ebx
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020a7:	53                   	push   %ebx
  8020a8:	6a 00                	push   $0x0
  8020aa:	e8 74 ec ff ff       	call   800d23 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020af:	89 1c 24             	mov    %ebx,(%esp)
  8020b2:	e8 41 ef ff ff       	call   800ff8 <fd2data>
  8020b7:	83 c4 08             	add    $0x8,%esp
  8020ba:	50                   	push   %eax
  8020bb:	6a 00                	push   $0x0
  8020bd:	e8 61 ec ff ff       	call   800d23 <sys_page_unmap>
}
  8020c2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    
	...

008020c8 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8020d4:	6a 01                	push   $0x1
  8020d6:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8020d9:	50                   	push   %eax
  8020da:	e8 fd ea ff ff       	call   800bdc <sys_cputs>
}
  8020df:	c9                   	leave  
  8020e0:	c3                   	ret    

008020e1 <getchar>:

int
getchar(void)
{
  8020e1:	55                   	push   %ebp
  8020e2:	89 e5                	mov    %esp,%ebp
  8020e4:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8020e7:	6a 01                	push   $0x1
  8020e9:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8020ec:	50                   	push   %eax
  8020ed:	6a 00                	push   $0x0
  8020ef:	e8 19 f2 ff ff       	call   80130d <read>
	if (r < 0)
  8020f4:	83 c4 10             	add    $0x10,%esp
		return r;
  8020f7:	89 c2                	mov    %eax,%edx
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	78 0d                	js     80210a <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  8020fd:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  802102:	85 c0                	test   %eax,%eax
  802104:	7e 04                	jle    80210a <getchar+0x29>
	return c;
  802106:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  80210a:	89 d0                	mov    %edx,%eax
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <iscons>:


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
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802114:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802117:	50                   	push   %eax
  802118:	ff 75 08             	pushl  0x8(%ebp)
  80211b:	e8 5a ef ff ff       	call   80107a <fd_lookup>
  802120:	83 c4 10             	add    $0x10,%esp
		return r;
  802123:	89 c2                	mov    %eax,%edx
  802125:	85 c0                	test   %eax,%eax
  802127:	78 11                	js     80213a <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  802129:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  80212c:	8b 00                	mov    (%eax),%eax
  80212e:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  802134:	0f 94 c0             	sete   %al
  802137:	0f b6 d0             	movzbl %al,%edx
}
  80213a:	89 d0                	mov    %edx,%eax
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <opencons>:

int
opencons(void)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802144:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802147:	50                   	push   %eax
  802148:	e8 d3 ee ff ff       	call   801020 <fd_alloc>
  80214d:	83 c4 10             	add    $0x10,%esp
		return r;
  802150:	89 c2                	mov    %eax,%edx
  802152:	85 c0                	test   %eax,%eax
  802154:	78 3c                	js     802192 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802156:	83 ec 04             	sub    $0x4,%esp
  802159:	68 07 04 00 00       	push   $0x407
  80215e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802161:	6a 00                	push   $0x0
  802163:	e8 36 eb ff ff       	call   800c9e <sys_page_alloc>
  802168:	83 c4 10             	add    $0x10,%esp
		return r;
  80216b:	89 c2                	mov    %eax,%edx
  80216d:	85 c0                	test   %eax,%eax
  80216f:	78 21                	js     802192 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802171:	a1 60 60 80 00       	mov    0x806060,%eax
  802176:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  802179:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  80217b:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  80217e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802185:	83 ec 0c             	sub    $0xc,%esp
  802188:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80218b:	e8 80 ee ff ff       	call   801010 <fd2num>
  802190:	89 c2                	mov    %eax,%edx
}
  802192:	89 d0                	mov    %edx,%eax
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  80219c:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021a5:	74 2a                	je     8021d1 <cons_read+0x3b>
  8021a7:	eb 05                	jmp    8021ae <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021a9:	e8 d1 ea ff ff       	call   800c7f <sys_yield>
  8021ae:	e8 4d ea ff ff       	call   800c00 <sys_cgetc>
  8021b3:	89 c2                	mov    %eax,%edx
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	74 f0                	je     8021a9 <cons_read+0x13>
	if (c < 0)
  8021b9:	85 d2                	test   %edx,%edx
  8021bb:	78 14                	js     8021d1 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c2:	83 fa 04             	cmp    $0x4,%edx
  8021c5:	74 0a                	je     8021d1 <cons_read+0x3b>
	*(char*)vbuf = c;
  8021c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ca:	88 10                	mov    %dl,(%eax)
	return 1;
  8021cc:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	57                   	push   %edi
  8021d7:	56                   	push   %esi
  8021d8:	53                   	push   %ebx
  8021d9:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  8021df:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021e2:	be 00 00 00 00       	mov    $0x0,%esi
  8021e7:	39 fe                	cmp    %edi,%esi
  8021e9:	73 3d                	jae    802228 <cons_write+0x55>
		m = n - tot;
  8021eb:	89 fb                	mov    %edi,%ebx
  8021ed:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8021ef:	83 fb 7f             	cmp    $0x7f,%ebx
  8021f2:	76 05                	jbe    8021f9 <cons_write+0x26>
			m = sizeof(buf) - 1;
  8021f4:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021f9:	83 ec 04             	sub    $0x4,%esp
  8021fc:	53                   	push   %ebx
  8021fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802200:	01 f0                	add    %esi,%eax
  802202:	50                   	push   %eax
  802203:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802209:	50                   	push   %eax
  80220a:	e8 39 e8 ff ff       	call   800a48 <memmove>
		sys_cputs(buf, m);
  80220f:	83 c4 08             	add    $0x8,%esp
  802212:	53                   	push   %ebx
  802213:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802219:	50                   	push   %eax
  80221a:	e8 bd e9 ff ff       	call   800bdc <sys_cputs>
  80221f:	83 c4 10             	add    $0x10,%esp
  802222:	01 de                	add    %ebx,%esi
  802224:	39 fe                	cmp    %edi,%esi
  802226:	72 c3                	jb     8021eb <cons_write+0x18>
	}
	return tot;
}
  802228:	89 f0                	mov    %esi,%eax
  80222a:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80222d:	5b                   	pop    %ebx
  80222e:	5e                   	pop    %esi
  80222f:	5f                   	pop    %edi
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <cons_close>:

int
cons_close(struct Fd *fd)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802235:	b8 00 00 00 00       	mov    $0x0,%eax
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
  80223f:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802242:	68 97 2b 80 00       	push   $0x802b97
  802247:	ff 75 0c             	pushl  0xc(%ebp)
  80224a:	e8 7d e6 ff ff       	call   8008cc <strcpy>
	return 0;
}
  80224f:	b8 00 00 00 00       	mov    $0x0,%eax
  802254:	c9                   	leave  
  802255:	c3                   	ret    
	...

00802258 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	56                   	push   %esi
  80225c:	53                   	push   %ebx
  80225d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802260:	8b 45 0c             	mov    0xc(%ebp),%eax
  802263:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  802266:	85 c0                	test   %eax,%eax
  802268:	75 12                	jne    80227c <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  80226a:	83 ec 0c             	sub    $0xc,%esp
  80226d:	68 00 00 c0 ee       	push   $0xeec00000
  802272:	e8 d7 eb ff ff       	call   800e4e <sys_ipc_recv>
  802277:	83 c4 10             	add    $0x10,%esp
  80227a:	eb 0c                	jmp    802288 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  80227c:	83 ec 0c             	sub    $0xc,%esp
  80227f:	50                   	push   %eax
  802280:	e8 c9 eb ff ff       	call   800e4e <sys_ipc_recv>
  802285:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802288:	89 c2                	mov    %eax,%edx
  80228a:	85 c0                	test   %eax,%eax
  80228c:	78 24                	js     8022b2 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  80228e:	85 db                	test   %ebx,%ebx
  802290:	74 0a                	je     80229c <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  802292:	a1 84 60 80 00       	mov    0x806084,%eax
  802297:	8b 40 74             	mov    0x74(%eax),%eax
  80229a:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  80229c:	85 f6                	test   %esi,%esi
  80229e:	74 0a                	je     8022aa <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  8022a0:	a1 84 60 80 00       	mov    0x806084,%eax
  8022a5:	8b 40 78             	mov    0x78(%eax),%eax
  8022a8:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  8022aa:	a1 84 60 80 00       	mov    0x806084,%eax
  8022af:	8b 50 70             	mov    0x70(%eax),%edx

}
  8022b2:	89 d0                	mov    %edx,%eax
  8022b4:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8022b7:	5b                   	pop    %ebx
  8022b8:	5e                   	pop    %esi
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <ipc_send>:

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
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	57                   	push   %edi
  8022bf:	56                   	push   %esi
  8022c0:	53                   	push   %ebx
  8022c1:	83 ec 0c             	sub    $0xc,%esp
  8022c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022ca:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  8022cd:	85 db                	test   %ebx,%ebx
  8022cf:	75 0a                	jne    8022db <ipc_send+0x20>
    pg = (void *) UTOP;
  8022d1:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  8022d6:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  8022db:	56                   	push   %esi
  8022dc:	53                   	push   %ebx
  8022dd:	57                   	push   %edi
  8022de:	ff 75 08             	pushl  0x8(%ebp)
  8022e1:	e8 45 eb ff ff       	call   800e2b <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  8022e6:	83 c4 10             	add    $0x10,%esp
  8022e9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022ec:	75 07                	jne    8022f5 <ipc_send+0x3a>
      sys_yield();
  8022ee:	e8 8c e9 ff ff       	call   800c7f <sys_yield>
  8022f3:	eb e6                	jmp    8022db <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	79 12                	jns    80230b <ipc_send+0x50>
  8022f9:	50                   	push   %eax
  8022fa:	68 9e 2b 80 00       	push   $0x802b9e
  8022ff:	6a 49                	push   $0x49
  802301:	68 bb 2b 80 00       	push   $0x802bbb
  802306:	e8 cd de ff ff       	call   8001d8 <_panic>
    else break;
  }
}
  80230b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80230e:	5b                   	pop    %ebx
  80230f:	5e                   	pop    %esi
  802310:	5f                   	pop    %edi
  802311:	c9                   	leave  
  802312:	c3                   	ret    
	...

00802314 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80231a:	89 c8                	mov    %ecx,%eax
  80231c:	c1 e8 16             	shr    $0x16,%eax
  80231f:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  802326:	ba 00 00 00 00       	mov    $0x0,%edx
  80232b:	a8 01                	test   $0x1,%al
  80232d:	74 28                	je     802357 <pageref+0x43>
	pte = vpt[VPN(v)];
  80232f:	89 c8                	mov    %ecx,%eax
  802331:	c1 e8 0c             	shr    $0xc,%eax
  802334:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  80233b:	ba 00 00 00 00       	mov    $0x0,%edx
  802340:	a8 01                	test   $0x1,%al
  802342:	74 13                	je     802357 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  802344:	c1 e8 0c             	shr    $0xc,%eax
  802347:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80234a:	c1 e0 02             	shl    $0x2,%eax
  80234d:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802354:	0f b7 d0             	movzwl %ax,%edx
}
  802357:	89 d0                	mov    %edx,%eax
  802359:	c9                   	leave  
  80235a:	c3                   	ret    
	...

0080235c <__udivdi3>:
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	57                   	push   %edi
  802360:	56                   	push   %esi
  802361:	83 ec 14             	sub    $0x14,%esp
  802364:	8b 55 14             	mov    0x14(%ebp),%edx
  802367:	8b 75 08             	mov    0x8(%ebp),%esi
  80236a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80236d:	8b 45 10             	mov    0x10(%ebp),%eax
  802370:	85 d2                	test   %edx,%edx
  802372:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802375:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802378:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  80237b:	89 fe                	mov    %edi,%esi
  80237d:	75 11                	jne    802390 <__udivdi3+0x34>
  80237f:	39 f8                	cmp    %edi,%eax
  802381:	76 4d                	jbe    8023d0 <__udivdi3+0x74>
  802383:	89 fa                	mov    %edi,%edx
  802385:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802388:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80238b:	89 c7                	mov    %eax,%edi
  80238d:	eb 09                	jmp    802398 <__udivdi3+0x3c>
  80238f:	90                   	nop    
  802390:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  802393:	76 17                	jbe    8023ac <__udivdi3+0x50>
  802395:	31 ff                	xor    %edi,%edi
  802397:	90                   	nop    
  802398:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  80239f:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8023a2:	83 c4 14             	add    $0x14,%esp
  8023a5:	5e                   	pop    %esi
  8023a6:	89 f8                	mov    %edi,%eax
  8023a8:	5f                   	pop    %edi
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    
  8023ab:	90                   	nop    
  8023ac:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  8023b0:	89 c7                	mov    %eax,%edi
  8023b2:	83 f7 1f             	xor    $0x1f,%edi
  8023b5:	75 4d                	jne    802404 <__udivdi3+0xa8>
  8023b7:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8023ba:	77 0a                	ja     8023c6 <__udivdi3+0x6a>
  8023bc:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8023bf:	31 ff                	xor    %edi,%edi
  8023c1:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  8023c4:	72 d2                	jb     802398 <__udivdi3+0x3c>
  8023c6:	bf 01 00 00 00       	mov    $0x1,%edi
  8023cb:	eb cb                	jmp    802398 <__udivdi3+0x3c>
  8023cd:	8d 76 00             	lea    0x0(%esi),%esi
  8023d0:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	75 0e                	jne    8023e5 <__udivdi3+0x89>
  8023d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023dc:	31 c9                	xor    %ecx,%ecx
  8023de:	31 d2                	xor    %edx,%edx
  8023e0:	f7 f1                	div    %ecx
  8023e2:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8023e5:	89 f0                	mov    %esi,%eax
  8023e7:	31 d2                	xor    %edx,%edx
  8023e9:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8023ec:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8023ef:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8023f2:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8023f5:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8023f8:	83 c4 14             	add    $0x14,%esp
  8023fb:	89 c7                	mov    %eax,%edi
  8023fd:	5e                   	pop    %esi
  8023fe:	89 f8                	mov    %edi,%eax
  802400:	5f                   	pop    %edi
  802401:	c9                   	leave  
  802402:	c3                   	ret    
  802403:	90                   	nop    
  802404:	b8 20 00 00 00       	mov    $0x20,%eax
  802409:	29 f8                	sub    %edi,%eax
  80240b:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  80240e:	89 f9                	mov    %edi,%ecx
  802410:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802413:	d3 e2                	shl    %cl,%edx
  802415:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802418:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80241b:	d3 e8                	shr    %cl,%eax
  80241d:	09 c2                	or     %eax,%edx
  80241f:	89 f9                	mov    %edi,%ecx
  802421:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  802424:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802427:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80242a:	89 f2                	mov    %esi,%edx
  80242c:	d3 ea                	shr    %cl,%edx
  80242e:	89 f9                	mov    %edi,%ecx
  802430:	d3 e6                	shl    %cl,%esi
  802432:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802435:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802438:	d3 e8                	shr    %cl,%eax
  80243a:	09 c6                	or     %eax,%esi
  80243c:	89 f9                	mov    %edi,%ecx
  80243e:	89 f0                	mov    %esi,%eax
  802440:	f7 75 f4             	divl   0xfffffff4(%ebp)
  802443:	89 d6                	mov    %edx,%esi
  802445:	89 c7                	mov    %eax,%edi
  802447:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  80244a:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80244d:	f7 e7                	mul    %edi
  80244f:	39 f2                	cmp    %esi,%edx
  802451:	77 0f                	ja     802462 <__udivdi3+0x106>
  802453:	0f 85 3f ff ff ff    	jne    802398 <__udivdi3+0x3c>
  802459:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  80245c:	0f 86 36 ff ff ff    	jbe    802398 <__udivdi3+0x3c>
  802462:	4f                   	dec    %edi
  802463:	e9 30 ff ff ff       	jmp    802398 <__udivdi3+0x3c>

00802468 <__umoddi3>:
  802468:	55                   	push   %ebp
  802469:	89 e5                	mov    %esp,%ebp
  80246b:	57                   	push   %edi
  80246c:	56                   	push   %esi
  80246d:	83 ec 30             	sub    $0x30,%esp
  802470:	8b 55 14             	mov    0x14(%ebp),%edx
  802473:	8b 45 10             	mov    0x10(%ebp),%eax
  802476:	89 d7                	mov    %edx,%edi
  802478:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  80247b:	89 c6                	mov    %eax,%esi
  80247d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	85 ff                	test   %edi,%edi
  802485:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  80248c:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802493:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  802496:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802499:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80249c:	75 3e                	jne    8024dc <__umoddi3+0x74>
  80249e:	39 d6                	cmp    %edx,%esi
  8024a0:	0f 86 a2 00 00 00    	jbe    802548 <__umoddi3+0xe0>
  8024a6:	f7 f6                	div    %esi
  8024a8:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8024ab:	85 c9                	test   %ecx,%ecx
  8024ad:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  8024b0:	74 1b                	je     8024cd <__umoddi3+0x65>
  8024b2:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8024b5:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8024b8:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8024bf:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8024c2:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  8024c5:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  8024c8:	89 10                	mov    %edx,(%eax)
  8024ca:	89 48 04             	mov    %ecx,0x4(%eax)
  8024cd:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8024d0:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8024d3:	83 c4 30             	add    $0x30,%esp
  8024d6:	5e                   	pop    %esi
  8024d7:	5f                   	pop    %edi
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    
  8024da:	89 f6                	mov    %esi,%esi
  8024dc:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  8024df:	76 1f                	jbe    802500 <__umoddi3+0x98>
  8024e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024e4:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8024e7:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8024ea:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  8024ed:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8024f0:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8024f3:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  8024f6:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8024f9:	83 c4 30             	add    $0x30,%esp
  8024fc:	5e                   	pop    %esi
  8024fd:	5f                   	pop    %edi
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    
  802500:	0f bd c7             	bsr    %edi,%eax
  802503:	83 f0 1f             	xor    $0x1f,%eax
  802506:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  802509:	75 61                	jne    80256c <__umoddi3+0x104>
  80250b:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  80250e:	77 05                	ja     802515 <__umoddi3+0xad>
  802510:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  802513:	72 10                	jb     802525 <__umoddi3+0xbd>
  802515:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802518:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80251b:	29 f0                	sub    %esi,%eax
  80251d:	19 fa                	sbb    %edi,%edx
  80251f:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802522:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802525:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802528:	85 d2                	test   %edx,%edx
  80252a:	74 a1                	je     8024cd <__umoddi3+0x65>
  80252c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80252f:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802532:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802535:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  802538:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80253b:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80253e:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802541:	89 01                	mov    %eax,(%ecx)
  802543:	89 51 04             	mov    %edx,0x4(%ecx)
  802546:	eb 85                	jmp    8024cd <__umoddi3+0x65>
  802548:	85 f6                	test   %esi,%esi
  80254a:	75 0b                	jne    802557 <__umoddi3+0xef>
  80254c:	b8 01 00 00 00       	mov    $0x1,%eax
  802551:	31 d2                	xor    %edx,%edx
  802553:	f7 f6                	div    %esi
  802555:	89 c6                	mov    %eax,%esi
  802557:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80255a:	89 fa                	mov    %edi,%edx
  80255c:	f7 f6                	div    %esi
  80255e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802561:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802564:	f7 f6                	div    %esi
  802566:	e9 3d ff ff ff       	jmp    8024a8 <__umoddi3+0x40>
  80256b:	90                   	nop    
  80256c:	b8 20 00 00 00       	mov    $0x20,%eax
  802571:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802574:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  802577:	89 fa                	mov    %edi,%edx
  802579:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80257c:	d3 e2                	shl    %cl,%edx
  80257e:	89 f0                	mov    %esi,%eax
  802580:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802583:	d3 e8                	shr    %cl,%eax
  802585:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802588:	d3 e6                	shl    %cl,%esi
  80258a:	89 d7                	mov    %edx,%edi
  80258c:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80258f:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802592:	09 c7                	or     %eax,%edi
  802594:	d3 ea                	shr    %cl,%edx
  802596:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802599:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80259c:	d3 e0                	shl    %cl,%eax
  80259e:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8025a1:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8025a4:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8025a7:	d3 e8                	shr    %cl,%eax
  8025a9:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  8025ac:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8025af:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8025b2:	f7 f7                	div    %edi
  8025b4:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8025b7:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  8025ba:	f7 e6                	mul    %esi
  8025bc:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  8025bf:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  8025c2:	77 0a                	ja     8025ce <__umoddi3+0x166>
  8025c4:	75 12                	jne    8025d8 <__umoddi3+0x170>
  8025c6:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8025c9:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  8025cc:	76 0a                	jbe    8025d8 <__umoddi3+0x170>
  8025ce:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  8025d1:	29 f1                	sub    %esi,%ecx
  8025d3:	19 fa                	sbb    %edi,%edx
  8025d5:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  8025d8:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	0f 84 ea fe ff ff    	je     8024cd <__umoddi3+0x65>
  8025e3:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8025e6:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8025e9:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  8025ec:	19 d1                	sbb    %edx,%ecx
  8025ee:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  8025f1:	89 ca                	mov    %ecx,%edx
  8025f3:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8025f6:	d3 e2                	shl    %cl,%edx
  8025f8:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8025fb:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8025fe:	d3 e8                	shr    %cl,%eax
  802600:	09 c2                	or     %eax,%edx
  802602:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802605:	d3 e8                	shr    %cl,%eax
  802607:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80260a:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80260d:	e9 ad fe ff ff       	jmp    8024bf <__umoddi3+0x57>
