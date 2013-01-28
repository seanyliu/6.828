
obj/user/lsfd:     file format elf32-i386

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
  80002c:	e8 1f 01 00 00       	call   800150 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  80003a:	68 00 26 80 00       	push   $0x802600
  80003f:	e8 58 02 00 00       	call   80029c <cprintf>
	exit();
  800044:	e8 4b 01 00 00       	call   800194 <exit>
}
  800049:	c9                   	leave  
  80004a:	c3                   	ret    

0080004b <umain>:

void
umain(int argc, char **argv)
{
  80004b:	55                   	push   %ebp
  80004c:	89 e5                	mov    %esp,%ebp
  80004e:	57                   	push   %edi
  80004f:	56                   	push   %esi
  800050:	53                   	push   %ebx
  800051:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  800057:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, usefprint = 0;
  80005a:	bf 00 00 00 00       	mov    $0x0,%edi
	struct Stat st;

	ARGBEGIN{
  80005f:	85 f6                	test   %esi,%esi
  800061:	75 03                	jne    800066 <umain+0x1b>
  800063:	8d 75 08             	lea    0x8(%ebp),%esi
  800066:	83 3d 84 60 80 00 00 	cmpl   $0x0,0x806084
  80006d:	75 07                	jne    800076 <umain+0x2b>
  80006f:	8b 06                	mov    (%esi),%eax
  800071:	a3 84 60 80 00       	mov    %eax,0x806084
  800076:	83 c6 04             	add    $0x4,%esi
  800079:	ff 4d 08             	decl   0x8(%ebp)
  80007c:	83 3e 00             	cmpl   $0x0,(%esi)
  80007f:	74 61                	je     8000e2 <umain+0x97>
  800081:	8b 06                	mov    (%esi),%eax
  800083:	80 38 2d             	cmpb   $0x2d,(%eax)
  800086:	75 5a                	jne    8000e2 <umain+0x97>
  800088:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80008c:	74 54                	je     8000e2 <umain+0x97>
  80008e:	8b 06                	mov    (%esi),%eax
  800090:	8d 58 01             	lea    0x1(%eax),%ebx
  800093:	80 78 01 2d          	cmpb   $0x2d,0x1(%eax)
  800097:	75 0b                	jne    8000a4 <umain+0x59>
  800099:	80 7b 01 00          	cmpb   $0x0,0x1(%ebx)
  80009d:	75 05                	jne    8000a4 <umain+0x59>
  80009f:	ff 4d 08             	decl   0x8(%ebp)
  8000a2:	eb 3e                	jmp    8000e2 <umain+0x97>
	default:
		usage();
	case '1':
		usefprint = 1;
		break;
  8000a4:	80 3b 00             	cmpb   $0x0,(%ebx)
  8000a7:	74 21                	je     8000ca <umain+0x7f>
  8000a9:	8a 03                	mov    (%ebx),%al
  8000ab:	43                   	inc    %ebx
  8000ac:	84 c0                	test   %al,%al
  8000ae:	74 1a                	je     8000ca <umain+0x7f>
  8000b0:	3c 31                	cmp    $0x31,%al
  8000b2:	74 05                	je     8000b9 <umain+0x6e>
  8000b4:	e8 7b ff ff ff       	call   800034 <usage>
  8000b9:	bf 01 00 00 00       	mov    $0x1,%edi
  8000be:	80 3b 00             	cmpb   $0x0,(%ebx)
  8000c1:	74 07                	je     8000ca <umain+0x7f>
  8000c3:	8a 03                	mov    (%ebx),%al
  8000c5:	43                   	inc    %ebx
  8000c6:	84 c0                	test   %al,%al
  8000c8:	75 e6                	jne    8000b0 <umain+0x65>
  8000ca:	ff 4d 08             	decl   0x8(%ebp)
  8000cd:	83 c6 04             	add    $0x4,%esi
  8000d0:	83 3e 00             	cmpl   $0x0,(%esi)
  8000d3:	74 0d                	je     8000e2 <umain+0x97>
  8000d5:	8b 06                	mov    (%esi),%eax
  8000d7:	80 38 2d             	cmpb   $0x2d,(%eax)
  8000da:	75 06                	jne    8000e2 <umain+0x97>
  8000dc:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  8000e0:	75 ac                	jne    80008e <umain+0x43>
	}ARGEND

	for (i = 0; i < 32; i++)
  8000e2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8000e7:	8d b5 58 ff ff ff    	lea    0xffffff58(%ebp),%esi
		if (fstat(i, &st) >= 0) {
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	56                   	push   %esi
  8000f1:	53                   	push   %ebx
  8000f2:	e8 e7 13 00 00       	call   8014de <fstat>
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	78 44                	js     800142 <umain+0xf7>
			if (usefprint)
  8000fe:	85 ff                	test   %edi,%edi
  800100:	74 22                	je     800124 <umain+0xd9>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  800108:	ff 70 04             	pushl  0x4(%eax)
  80010b:	ff 75 d8             	pushl  0xffffffd8(%ebp)
  80010e:	ff 75 dc             	pushl  0xffffffdc(%ebp)
  800111:	56                   	push   %esi
  800112:	53                   	push   %ebx
  800113:	68 14 26 80 00       	push   $0x802614
  800118:	6a 01                	push   $0x1
  80011a:	e8 62 1a 00 00       	call   801b81 <fprintf>
  80011f:	83 c4 20             	add    $0x20,%esp
  800122:	eb 1e                	jmp    800142 <umain+0xf7>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);	
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800124:	83 ec 08             	sub    $0x8,%esp
  800127:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80012a:	ff 70 04             	pushl  0x4(%eax)
  80012d:	ff 75 d8             	pushl  0xffffffd8(%ebp)
  800130:	ff 75 dc             	pushl  0xffffffdc(%ebp)
  800133:	56                   	push   %esi
  800134:	53                   	push   %ebx
  800135:	68 14 26 80 00       	push   $0x802614
  80013a:	e8 5d 01 00 00       	call   80029c <cprintf>
  80013f:	83 c4 20             	add    $0x20,%esp
  800142:	43                   	inc    %ebx
  800143:	83 fb 1f             	cmp    $0x1f,%ebx
  800146:	7e a5                	jle    8000ed <umain+0xa2>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800148:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80014b:	5b                   	pop    %ebx
  80014c:	5e                   	pop    %esi
  80014d:	5f                   	pop    %edi
  80014e:	c9                   	leave  
  80014f:	c3                   	ret    

00800150 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	56                   	push   %esi
  800154:	53                   	push   %ebx
  800155:	8b 75 08             	mov    0x8(%ebp),%esi
  800158:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  80015b:	e8 d4 0a 00 00       	call   800c34 <sys_getenvid>
  800160:	25 ff 03 00 00       	and    $0x3ff,%eax
  800165:	c1 e0 07             	shl    $0x7,%eax
  800168:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80016d:	a3 80 60 80 00       	mov    %eax,0x806080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800172:	85 f6                	test   %esi,%esi
  800174:	7e 07                	jle    80017d <libmain+0x2d>
		binaryname = argv[0];
  800176:	8b 03                	mov    (%ebx),%eax
  800178:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  80017d:	83 ec 08             	sub    $0x8,%esp
  800180:	53                   	push   %ebx
  800181:	56                   	push   %esi
  800182:	e8 c4 fe ff ff       	call   80004b <umain>

	// exit gracefully
	exit();
  800187:	e8 08 00 00 00       	call   800194 <exit>
}
  80018c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80018f:	5b                   	pop    %ebx
  800190:	5e                   	pop    %esi
  800191:	c9                   	leave  
  800192:	c3                   	ret    
	...

00800194 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80019a:	e8 fd 0f 00 00       	call   80119c <close_all>
	sys_env_destroy(0);
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	6a 00                	push   $0x0
  8001a4:	e8 4a 0a 00 00       	call   800bf3 <sys_env_destroy>
}
  8001a9:	c9                   	leave  
  8001aa:	c3                   	ret    
	...

008001ac <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	53                   	push   %ebx
  8001b0:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  8001b3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  8001b6:	83 3d 84 60 80 00 00 	cmpl   $0x0,0x806084
  8001bd:	74 16                	je     8001d5 <_panic+0x29>
		cprintf("%s: ", argv0);
  8001bf:	83 ec 08             	sub    $0x8,%esp
  8001c2:	ff 35 84 60 80 00    	pushl  0x806084
  8001c8:	68 53 26 80 00       	push   $0x802653
  8001cd:	e8 ca 00 00 00       	call   80029c <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d5:	ff 75 0c             	pushl  0xc(%ebp)
  8001d8:	ff 75 08             	pushl  0x8(%ebp)
  8001db:	ff 35 00 60 80 00    	pushl  0x806000
  8001e1:	68 58 26 80 00       	push   $0x802658
  8001e6:	e8 b1 00 00 00       	call   80029c <cprintf>
	vcprintf(fmt, ap);
  8001eb:	83 c4 08             	add    $0x8,%esp
  8001ee:	53                   	push   %ebx
  8001ef:	ff 75 10             	pushl  0x10(%ebp)
  8001f2:	e8 54 00 00 00       	call   80024b <vcprintf>
	cprintf("\n");
  8001f7:	c7 04 24 10 26 80 00 	movl   $0x802610,(%esp)
  8001fe:	e8 99 00 00 00       	call   80029c <cprintf>

	// Cause a breakpoint exception
	while (1)
  800203:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  800206:	cc                   	int3   
  800207:	eb fd                	jmp    800206 <_panic+0x5a>
  800209:	00 00                	add    %al,(%eax)
	...

0080020c <putch>:


static void
putch(int ch, struct printbuf *b)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	53                   	push   %ebx
  800210:	83 ec 04             	sub    $0x4,%esp
  800213:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800216:	8b 03                	mov    (%ebx),%eax
  800218:	8b 55 08             	mov    0x8(%ebp),%edx
  80021b:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  80021f:	40                   	inc    %eax
  800220:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800222:	3d ff 00 00 00       	cmp    $0xff,%eax
  800227:	75 1a                	jne    800243 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800229:	83 ec 08             	sub    $0x8,%esp
  80022c:	68 ff 00 00 00       	push   $0xff
  800231:	8d 43 08             	lea    0x8(%ebx),%eax
  800234:	50                   	push   %eax
  800235:	e8 76 09 00 00       	call   800bb0 <sys_cputs>
		b->idx = 0;
  80023a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800240:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800243:	ff 43 04             	incl   0x4(%ebx)
}
  800246:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800254:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  80025b:	00 00 00 
	b.cnt = 0;
  80025e:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800265:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800268:	ff 75 0c             	pushl  0xc(%ebp)
  80026b:	ff 75 08             	pushl  0x8(%ebp)
  80026e:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800274:	50                   	push   %eax
  800275:	68 0c 02 80 00       	push   $0x80020c
  80027a:	e8 4f 01 00 00       	call   8003ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80027f:	83 c4 08             	add    $0x8,%esp
  800282:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  800288:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  80028e:	50                   	push   %eax
  80028f:	e8 1c 09 00 00       	call   800bb0 <sys_cputs>

	return b.cnt;
  800294:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  80029a:	c9                   	leave  
  80029b:	c3                   	ret    

0080029c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 08             	pushl  0x8(%ebp)
  8002a9:	e8 9d ff ff ff       	call   80024b <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ae:	c9                   	leave  
  8002af:	c3                   	ret    

008002b0 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	57                   	push   %edi
  8002b4:	56                   	push   %esi
  8002b5:	53                   	push   %ebx
  8002b6:	83 ec 0c             	sub    $0xc,%esp
  8002b9:	8b 75 10             	mov    0x10(%ebp),%esi
  8002bc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002bf:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c2:	8b 45 18             	mov    0x18(%ebp),%eax
  8002c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ca:	39 fa                	cmp    %edi,%edx
  8002cc:	77 39                	ja     800307 <printnum+0x57>
  8002ce:	72 04                	jb     8002d4 <printnum+0x24>
  8002d0:	39 f0                	cmp    %esi,%eax
  8002d2:	77 33                	ja     800307 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d4:	83 ec 04             	sub    $0x4,%esp
  8002d7:	ff 75 20             	pushl  0x20(%ebp)
  8002da:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  8002dd:	50                   	push   %eax
  8002de:	ff 75 18             	pushl  0x18(%ebp)
  8002e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	57                   	push   %edi
  8002ec:	56                   	push   %esi
  8002ed:	e8 3e 20 00 00       	call   802330 <__udivdi3>
  8002f2:	83 c4 10             	add    $0x10,%esp
  8002f5:	52                   	push   %edx
  8002f6:	50                   	push   %eax
  8002f7:	ff 75 0c             	pushl  0xc(%ebp)
  8002fa:	ff 75 08             	pushl  0x8(%ebp)
  8002fd:	e8 ae ff ff ff       	call   8002b0 <printnum>
  800302:	83 c4 20             	add    $0x20,%esp
  800305:	eb 19                	jmp    800320 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800307:	4b                   	dec    %ebx
  800308:	85 db                	test   %ebx,%ebx
  80030a:	7e 14                	jle    800320 <printnum+0x70>
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	ff 75 0c             	pushl  0xc(%ebp)
  800312:	ff 75 20             	pushl  0x20(%ebp)
  800315:	ff 55 08             	call   *0x8(%ebp)
  800318:	83 c4 10             	add    $0x10,%esp
  80031b:	4b                   	dec    %ebx
  80031c:	85 db                	test   %ebx,%ebx
  80031e:	7f ec                	jg     80030c <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	8b 45 18             	mov    0x18(%ebp),%eax
  800329:	ba 00 00 00 00       	mov    $0x0,%edx
  80032e:	83 ec 04             	sub    $0x4,%esp
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	57                   	push   %edi
  800334:	56                   	push   %esi
  800335:	e8 02 21 00 00       	call   80243c <__umoddi3>
  80033a:	83 c4 14             	add    $0x14,%esp
  80033d:	0f be 80 6e 27 80 00 	movsbl 0x80276e(%eax),%eax
  800344:	50                   	push   %eax
  800345:	ff 55 08             	call   *0x8(%ebp)
}
  800348:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80034b:	5b                   	pop    %ebx
  80034c:	5e                   	pop    %esi
  80034d:	5f                   	pop    %edi
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800359:	83 f8 01             	cmp    $0x1,%eax
  80035c:	7e 0f                	jle    80036d <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  80035e:	8b 01                	mov    (%ecx),%eax
  800360:	83 c0 08             	add    $0x8,%eax
  800363:	89 01                	mov    %eax,(%ecx)
  800365:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800368:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80036b:	eb 24                	jmp    800391 <getuint+0x41>
	else if (lflag)
  80036d:	85 c0                	test   %eax,%eax
  80036f:	74 11                	je     800382 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800371:	8b 01                	mov    (%ecx),%eax
  800373:	83 c0 04             	add    $0x4,%eax
  800376:	89 01                	mov    %eax,(%ecx)
  800378:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80037b:	ba 00 00 00 00       	mov    $0x0,%edx
  800380:	eb 0f                	jmp    800391 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  800382:	8b 01                	mov    (%ecx),%eax
  800384:	83 c0 04             	add    $0x4,%eax
  800387:	89 01                	mov    %eax,(%ecx)
  800389:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80038c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800391:	c9                   	leave  
  800392:	c3                   	ret    

00800393 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	8b 55 08             	mov    0x8(%ebp),%edx
  800399:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80039c:	83 f8 01             	cmp    $0x1,%eax
  80039f:	7e 0f                	jle    8003b0 <getint+0x1d>
		return va_arg(*ap, long long);
  8003a1:	8b 02                	mov    (%edx),%eax
  8003a3:	83 c0 08             	add    $0x8,%eax
  8003a6:	89 02                	mov    %eax,(%edx)
  8003a8:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8003ab:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8003ae:	eb 1c                	jmp    8003cc <getint+0x39>
	else if (lflag)
  8003b0:	85 c0                	test   %eax,%eax
  8003b2:	74 0d                	je     8003c1 <getint+0x2e>
		return va_arg(*ap, long);
  8003b4:	8b 02                	mov    (%edx),%eax
  8003b6:	83 c0 04             	add    $0x4,%eax
  8003b9:	89 02                	mov    %eax,(%edx)
  8003bb:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003be:	99                   	cltd   
  8003bf:	eb 0b                	jmp    8003cc <getint+0x39>
	else
		return va_arg(*ap, int);
  8003c1:	8b 02                	mov    (%edx),%eax
  8003c3:	83 c0 04             	add    $0x4,%eax
  8003c6:	89 02                	mov    %eax,(%edx)
  8003c8:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003cb:	99                   	cltd   
}
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	57                   	push   %edi
  8003d2:	56                   	push   %esi
  8003d3:	53                   	push   %ebx
  8003d4:	83 ec 1c             	sub    $0x1c,%esp
  8003d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  8003da:	0f b6 13             	movzbl (%ebx),%edx
  8003dd:	43                   	inc    %ebx
  8003de:	83 fa 25             	cmp    $0x25,%edx
  8003e1:	74 1e                	je     800401 <vprintfmt+0x33>
  8003e3:	85 d2                	test   %edx,%edx
  8003e5:	0f 84 d7 02 00 00    	je     8006c2 <vprintfmt+0x2f4>
  8003eb:	83 ec 08             	sub    $0x8,%esp
  8003ee:	ff 75 0c             	pushl  0xc(%ebp)
  8003f1:	52                   	push   %edx
  8003f2:	ff 55 08             	call   *0x8(%ebp)
  8003f5:	83 c4 10             	add    $0x10,%esp
  8003f8:	0f b6 13             	movzbl (%ebx),%edx
  8003fb:	43                   	inc    %ebx
  8003fc:	83 fa 25             	cmp    $0x25,%edx
  8003ff:	75 e2                	jne    8003e3 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  800401:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  800405:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  80040c:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  800411:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  800416:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041d:	0f b6 13             	movzbl (%ebx),%edx
  800420:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  800423:	43                   	inc    %ebx
  800424:	83 f8 55             	cmp    $0x55,%eax
  800427:	0f 87 70 02 00 00    	ja     80069d <vprintfmt+0x2cf>
  80042d:	ff 24 85 fc 27 80 00 	jmp    *0x8027fc(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800434:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  800438:	eb e3                	jmp    80041d <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80043a:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  80043e:	eb dd                	jmp    80041d <vprintfmt+0x4f>

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
  800440:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800445:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  800448:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  80044c:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80044f:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  800452:	83 f8 09             	cmp    $0x9,%eax
  800455:	77 27                	ja     80047e <vprintfmt+0xb0>
  800457:	43                   	inc    %ebx
  800458:	eb eb                	jmp    800445 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80045a:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80045e:	8b 45 14             	mov    0x14(%ebp),%eax
  800461:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800464:	eb 18                	jmp    80047e <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  800466:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80046a:	79 b1                	jns    80041d <vprintfmt+0x4f>
				width = 0;
  80046c:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800473:	eb a8                	jmp    80041d <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800475:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  80047c:	eb 9f                	jmp    80041d <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  80047e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800482:	79 99                	jns    80041d <vprintfmt+0x4f>
				width = precision, precision = -1;
  800484:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  800487:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  80048c:	eb 8f                	jmp    80041d <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80048e:	41                   	inc    %ecx
			goto reswitch;
  80048f:	eb 8c                	jmp    80041d <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	ff 75 0c             	pushl  0xc(%ebp)
  800497:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80049b:	8b 45 14             	mov    0x14(%ebp),%eax
  80049e:	ff 70 fc             	pushl  0xfffffffc(%eax)
  8004a1:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004a4:	83 c4 10             	add    $0x10,%esp
  8004a7:	e9 2e ff ff ff       	jmp    8003da <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004ac:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b3:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  8004b6:	85 c0                	test   %eax,%eax
  8004b8:	79 02                	jns    8004bc <vprintfmt+0xee>
				err = -err;
  8004ba:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004bc:	83 f8 0e             	cmp    $0xe,%eax
  8004bf:	7f 0b                	jg     8004cc <vprintfmt+0xfe>
  8004c1:	8b 3c 85 c0 27 80 00 	mov    0x8027c0(,%eax,4),%edi
  8004c8:	85 ff                	test   %edi,%edi
  8004ca:	75 19                	jne    8004e5 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8004cc:	50                   	push   %eax
  8004cd:	68 7f 27 80 00       	push   $0x80277f
  8004d2:	ff 75 0c             	pushl  0xc(%ebp)
  8004d5:	ff 75 08             	pushl  0x8(%ebp)
  8004d8:	e8 ed 01 00 00       	call   8006ca <printfmt>
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	e9 f5 fe ff ff       	jmp    8003da <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  8004e5:	57                   	push   %edi
  8004e6:	68 01 2b 80 00       	push   $0x802b01
  8004eb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ee:	ff 75 08             	pushl  0x8(%ebp)
  8004f1:	e8 d4 01 00 00       	call   8006ca <printfmt>
  8004f6:	83 c4 10             	add    $0x10,%esp
			break;
  8004f9:	e9 dc fe ff ff       	jmp    8003da <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004fe:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800502:	8b 45 14             	mov    0x14(%ebp),%eax
  800505:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  800508:	85 ff                	test   %edi,%edi
  80050a:	75 05                	jne    800511 <vprintfmt+0x143>
				p = "(null)";
  80050c:	bf 88 27 80 00       	mov    $0x802788,%edi
			if (width > 0 && padc != '-')
  800511:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800515:	7e 3b                	jle    800552 <vprintfmt+0x184>
  800517:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  80051b:	74 35                	je     800552 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051d:	83 ec 08             	sub    $0x8,%esp
  800520:	56                   	push   %esi
  800521:	57                   	push   %edi
  800522:	e8 56 03 00 00       	call   80087d <strnlen>
  800527:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  80052a:	83 c4 10             	add    $0x10,%esp
  80052d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800531:	7e 1f                	jle    800552 <vprintfmt+0x184>
  800533:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800537:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	ff 75 0c             	pushl  0xc(%ebp)
  800540:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  800543:	ff 55 08             	call   *0x8(%ebp)
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80054c:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800550:	7f e8                	jg     80053a <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800552:	0f be 17             	movsbl (%edi),%edx
  800555:	47                   	inc    %edi
  800556:	85 d2                	test   %edx,%edx
  800558:	74 44                	je     80059e <vprintfmt+0x1d0>
  80055a:	85 f6                	test   %esi,%esi
  80055c:	78 03                	js     800561 <vprintfmt+0x193>
  80055e:	4e                   	dec    %esi
  80055f:	78 3d                	js     80059e <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800561:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800565:	74 18                	je     80057f <vprintfmt+0x1b1>
  800567:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80056a:	83 f8 5e             	cmp    $0x5e,%eax
  80056d:	76 10                	jbe    80057f <vprintfmt+0x1b1>
					putch('?', putdat);
  80056f:	83 ec 08             	sub    $0x8,%esp
  800572:	ff 75 0c             	pushl  0xc(%ebp)
  800575:	6a 3f                	push   $0x3f
  800577:	ff 55 08             	call   *0x8(%ebp)
  80057a:	83 c4 10             	add    $0x10,%esp
  80057d:	eb 0d                	jmp    80058c <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  80057f:	83 ec 08             	sub    $0x8,%esp
  800582:	ff 75 0c             	pushl  0xc(%ebp)
  800585:	52                   	push   %edx
  800586:	ff 55 08             	call   *0x8(%ebp)
  800589:	83 c4 10             	add    $0x10,%esp
  80058c:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80058f:	0f be 17             	movsbl (%edi),%edx
  800592:	47                   	inc    %edi
  800593:	85 d2                	test   %edx,%edx
  800595:	74 07                	je     80059e <vprintfmt+0x1d0>
  800597:	85 f6                	test   %esi,%esi
  800599:	78 c6                	js     800561 <vprintfmt+0x193>
  80059b:	4e                   	dec    %esi
  80059c:	79 c3                	jns    800561 <vprintfmt+0x193>
			for (; width > 0; width--)
  80059e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005a2:	0f 8e 32 fe ff ff    	jle    8003da <vprintfmt+0xc>
				putch(' ', putdat);
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	ff 75 0c             	pushl  0xc(%ebp)
  8005ae:	6a 20                	push   $0x20
  8005b0:	ff 55 08             	call   *0x8(%ebp)
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8005b9:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005bd:	7f e9                	jg     8005a8 <vprintfmt+0x1da>
			break;
  8005bf:	e9 16 fe ff ff       	jmp    8003da <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005c4:	51                   	push   %ecx
  8005c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8005c8:	50                   	push   %eax
  8005c9:	e8 c5 fd ff ff       	call   800393 <getint>
  8005ce:	89 c6                	mov    %eax,%esi
  8005d0:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8005d2:	83 c4 08             	add    $0x8,%esp
  8005d5:	85 d2                	test   %edx,%edx
  8005d7:	79 15                	jns    8005ee <vprintfmt+0x220>
				putch('-', putdat);
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	6a 2d                	push   $0x2d
  8005e1:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005e4:	f7 de                	neg    %esi
  8005e6:	83 d7 00             	adc    $0x0,%edi
  8005e9:	f7 df                	neg    %edi
  8005eb:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005ee:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8005f3:	eb 75                	jmp    80066a <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005f5:	51                   	push   %ecx
  8005f6:	8d 45 14             	lea    0x14(%ebp),%eax
  8005f9:	50                   	push   %eax
  8005fa:	e8 51 fd ff ff       	call   800350 <getuint>
  8005ff:	89 c6                	mov    %eax,%esi
  800601:	89 d7                	mov    %edx,%edi
			base = 10;
  800603:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800608:	83 c4 08             	add    $0x8,%esp
  80060b:	eb 5d                	jmp    80066a <vprintfmt+0x29c>

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
  80060d:	51                   	push   %ecx
  80060e:	8d 45 14             	lea    0x14(%ebp),%eax
  800611:	50                   	push   %eax
  800612:	e8 39 fd ff ff       	call   800350 <getuint>
  800617:	89 c6                	mov    %eax,%esi
  800619:	89 d7                	mov    %edx,%edi
			base = 8;
  80061b:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  800620:	83 c4 08             	add    $0x8,%esp
  800623:	eb 45                	jmp    80066a <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	6a 30                	push   $0x30
  80062d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800630:	83 c4 08             	add    $0x8,%esp
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	6a 78                	push   $0x78
  800638:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80063b:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800645:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80064a:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	eb 16                	jmp    80066a <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800654:	51                   	push   %ecx
  800655:	8d 45 14             	lea    0x14(%ebp),%eax
  800658:	50                   	push   %eax
  800659:	e8 f2 fc ff ff       	call   800350 <getuint>
  80065e:	89 c6                	mov    %eax,%esi
  800660:	89 d7                	mov    %edx,%edi
			base = 16;
  800662:	ba 10 00 00 00       	mov    $0x10,%edx
  800667:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80066a:	83 ec 04             	sub    $0x4,%esp
  80066d:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800671:	50                   	push   %eax
  800672:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800675:	52                   	push   %edx
  800676:	57                   	push   %edi
  800677:	56                   	push   %esi
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	ff 75 08             	pushl  0x8(%ebp)
  80067e:	e8 2d fc ff ff       	call   8002b0 <printnum>
			break;
  800683:	83 c4 20             	add    $0x20,%esp
  800686:	e9 4f fd ff ff       	jmp    8003da <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	ff 75 0c             	pushl  0xc(%ebp)
  800691:	52                   	push   %edx
  800692:	ff 55 08             	call   *0x8(%ebp)
			break;
  800695:	83 c4 10             	add    $0x10,%esp
  800698:	e9 3d fd ff ff       	jmp    8003da <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	6a 25                	push   $0x25
  8006a5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a8:	4b                   	dec    %ebx
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8006b0:	0f 84 24 fd ff ff    	je     8003da <vprintfmt+0xc>
  8006b6:	4b                   	dec    %ebx
  8006b7:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8006bb:	75 f9                	jne    8006b6 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8006bd:	e9 18 fd ff ff       	jmp    8003da <vprintfmt+0xc>
		}
	}
}
  8006c2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8006c5:	5b                   	pop    %ebx
  8006c6:	5e                   	pop    %esi
  8006c7:	5f                   	pop    %edi
  8006c8:	c9                   	leave  
  8006c9:	c3                   	ret    

008006ca <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006ca:	55                   	push   %ebp
  8006cb:	89 e5                	mov    %esp,%ebp
  8006cd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8006d0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006d3:	50                   	push   %eax
  8006d4:	ff 75 10             	pushl  0x10(%ebp)
  8006d7:	ff 75 0c             	pushl  0xc(%ebp)
  8006da:	ff 75 08             	pushl  0x8(%ebp)
  8006dd:	e8 ec fc ff ff       	call   8003ce <vprintfmt>
	va_end(ap);
}
  8006e2:	c9                   	leave  
  8006e3:	c3                   	ret    

008006e4 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006e4:	55                   	push   %ebp
  8006e5:	89 e5                	mov    %esp,%ebp
  8006e7:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  8006ea:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  8006ed:	8b 0a                	mov    (%edx),%ecx
  8006ef:	3b 4a 04             	cmp    0x4(%edx),%ecx
  8006f2:	73 07                	jae    8006fb <sprintputch+0x17>
		*b->buf++ = ch;
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	88 01                	mov    %al,(%ecx)
  8006f9:	ff 02                	incl   (%edx)
}
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
  800700:	83 ec 18             	sub    $0x18,%esp
  800703:	8b 55 08             	mov    0x8(%ebp),%edx
  800706:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800709:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  80070c:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800710:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  800713:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  80071a:	85 d2                	test   %edx,%edx
  80071c:	74 04                	je     800722 <vsnprintf+0x25>
  80071e:	85 c9                	test   %ecx,%ecx
  800720:	7f 07                	jg     800729 <vsnprintf+0x2c>
		return -E_INVAL;
  800722:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800727:	eb 1d                	jmp    800746 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800729:	ff 75 14             	pushl  0x14(%ebp)
  80072c:	ff 75 10             	pushl  0x10(%ebp)
  80072f:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  800732:	50                   	push   %eax
  800733:	68 e4 06 80 00       	push   $0x8006e4
  800738:	e8 91 fc ff ff       	call   8003ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80073d:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800740:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800743:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  800746:	c9                   	leave  
  800747:	c3                   	ret    

00800748 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800748:	55                   	push   %ebp
  800749:	89 e5                	mov    %esp,%ebp
  80074b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80074e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800751:	50                   	push   %eax
  800752:	ff 75 10             	pushl  0x10(%ebp)
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	ff 75 08             	pushl  0x8(%ebp)
  80075b:	e8 9d ff ff ff       	call   8006fd <vsnprintf>
	va_end(ap);

	return rc;
}
  800760:	c9                   	leave  
  800761:	c3                   	ret    
	...

00800764 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	56                   	push   %esi
  800768:	53                   	push   %ebx
  800769:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  80076c:	83 ec 0c             	sub    $0xc,%esp
  80076f:	56                   	push   %esi
  800770:	e8 ef 00 00 00       	call   800864 <strlen>
  char letter;
  int hexnum = 0;
  800775:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80077a:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  80077f:	83 c4 10             	add    $0x10,%esp
  800782:	89 c2                	mov    %eax,%edx
  800784:	4a                   	dec    %edx
  800785:	0f 88 d0 00 00 00    	js     80085b <strtoint+0xf7>
    letter = string[cidx];
  80078b:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  80078e:	85 d2                	test   %edx,%edx
  800790:	75 12                	jne    8007a4 <strtoint+0x40>
      if (letter != '0') {
  800792:	3c 30                	cmp    $0x30,%al
  800794:	0f 84 ba 00 00 00    	je     800854 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80079a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80079f:	e9 b9 00 00 00       	jmp    80085d <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  8007a4:	83 fa 01             	cmp    $0x1,%edx
  8007a7:	75 12                	jne    8007bb <strtoint+0x57>
      if (letter != 'x') {
  8007a9:	3c 78                	cmp    $0x78,%al
  8007ab:	0f 84 a3 00 00 00    	je     800854 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8007b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8007b6:	e9 a2 00 00 00       	jmp    80085d <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8007bb:	0f be c0             	movsbl %al,%eax
  8007be:	83 e8 30             	sub    $0x30,%eax
  8007c1:	83 f8 36             	cmp    $0x36,%eax
  8007c4:	0f 87 80 00 00 00    	ja     80084a <strtoint+0xe6>
  8007ca:	ff 24 85 54 29 80 00 	jmp    *0x802954(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8007d1:	01 cb                	add    %ecx,%ebx
          break;
  8007d3:	eb 7c                	jmp    800851 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8007d5:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8007d8:	eb 77                	jmp    800851 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8007da:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8007dd:	01 c3                	add    %eax,%ebx
          break;
  8007df:	eb 70                	jmp    800851 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  8007e1:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  8007e4:	eb 6b                	jmp    800851 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  8007e6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8007e9:	01 c3                	add    %eax,%ebx
          break;
  8007eb:	eb 64                	jmp    800851 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  8007ed:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8007f0:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8007f3:	eb 5c                	jmp    800851 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  8007f5:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8007fc:	29 c8                	sub    %ecx,%eax
  8007fe:	01 c3                	add    %eax,%ebx
          break;
  800800:	eb 4f                	jmp    800851 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  800802:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  800805:	eb 4a                	jmp    800851 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  800807:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  80080a:	01 c3                	add    %eax,%ebx
          break;
  80080c:	eb 43                	jmp    800851 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  80080e:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800811:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800814:	eb 3b                	jmp    800851 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800816:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800819:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  80081c:	01 c3                	add    %eax,%ebx
          break;
  80081e:	eb 31                	jmp    800851 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800820:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800823:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800826:	eb 29                	jmp    800851 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800828:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80082b:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  80082e:	01 c3                	add    %eax,%ebx
          break;
  800830:	eb 1f                	jmp    800851 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800832:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800839:	29 c8                	sub    %ecx,%eax
  80083b:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  80083e:	eb 11                	jmp    800851 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800840:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800843:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800846:	01 c3                	add    %eax,%ebx
          break;
  800848:	eb 07                	jmp    800851 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  80084a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80084f:	eb 0c                	jmp    80085d <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800851:	c1 e1 04             	shl    $0x4,%ecx
  800854:	4a                   	dec    %edx
  800855:	0f 89 30 ff ff ff    	jns    80078b <strtoint+0x27>
    }
  }

  return hexnum;
  80085b:	89 d8                	mov    %ebx,%eax
}
  80085d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800860:	5b                   	pop    %ebx
  800861:	5e                   	pop    %esi
  800862:	c9                   	leave  
  800863:	c3                   	ret    

00800864 <strlen>:





int
strlen(const char *s)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80086a:	b8 00 00 00 00       	mov    $0x0,%eax
  80086f:	80 3a 00             	cmpb   $0x0,(%edx)
  800872:	74 07                	je     80087b <strlen+0x17>
		n++;
  800874:	40                   	inc    %eax
  800875:	42                   	inc    %edx
  800876:	80 3a 00             	cmpb   $0x0,(%edx)
  800879:	75 f9                	jne    800874 <strlen+0x10>
	return n;
}
  80087b:	c9                   	leave  
  80087c:	c3                   	ret    

0080087d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800883:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800886:	b8 00 00 00 00       	mov    $0x0,%eax
  80088b:	85 d2                	test   %edx,%edx
  80088d:	74 0f                	je     80089e <strnlen+0x21>
  80088f:	80 39 00             	cmpb   $0x0,(%ecx)
  800892:	74 0a                	je     80089e <strnlen+0x21>
		n++;
  800894:	40                   	inc    %eax
  800895:	41                   	inc    %ecx
  800896:	4a                   	dec    %edx
  800897:	74 05                	je     80089e <strnlen+0x21>
  800899:	80 39 00             	cmpb   $0x0,(%ecx)
  80089c:	75 f6                	jne    800894 <strnlen+0x17>
	return n;
}
  80089e:	c9                   	leave  
  80089f:	c3                   	ret    

008008a0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	53                   	push   %ebx
  8008a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  8008aa:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  8008ac:	8a 02                	mov    (%edx),%al
  8008ae:	42                   	inc    %edx
  8008af:	88 01                	mov    %al,(%ecx)
  8008b1:	41                   	inc    %ecx
  8008b2:	84 c0                	test   %al,%al
  8008b4:	75 f6                	jne    8008ac <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008b6:	89 d8                	mov    %ebx,%eax
  8008b8:	5b                   	pop    %ebx
  8008b9:	c9                   	leave  
  8008ba:	c3                   	ret    

008008bb <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	57                   	push   %edi
  8008bf:	56                   	push   %esi
  8008c0:	53                   	push   %ebx
  8008c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c7:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  8008ca:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  8008cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008d1:	39 f3                	cmp    %esi,%ebx
  8008d3:	73 10                	jae    8008e5 <strncpy+0x2a>
		*dst++ = *src;
  8008d5:	8a 02                	mov    (%edx),%al
  8008d7:	88 01                	mov    %al,(%ecx)
  8008d9:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008da:	80 3a 01             	cmpb   $0x1,(%edx)
  8008dd:	83 da ff             	sbb    $0xffffffff,%edx
  8008e0:	43                   	inc    %ebx
  8008e1:	39 f3                	cmp    %esi,%ebx
  8008e3:	72 f0                	jb     8008d5 <strncpy+0x1a>
	}
	return ret;
}
  8008e5:	89 f8                	mov    %edi,%eax
  8008e7:	5b                   	pop    %ebx
  8008e8:	5e                   	pop    %esi
  8008e9:	5f                   	pop    %edi
  8008ea:	c9                   	leave  
  8008eb:	c3                   	ret    

008008ec <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	56                   	push   %esi
  8008f0:	53                   	push   %ebx
  8008f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f7:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  8008fa:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  8008fc:	85 d2                	test   %edx,%edx
  8008fe:	74 19                	je     800919 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800900:	4a                   	dec    %edx
  800901:	74 13                	je     800916 <strlcpy+0x2a>
  800903:	80 39 00             	cmpb   $0x0,(%ecx)
  800906:	74 0e                	je     800916 <strlcpy+0x2a>
  800908:	8a 01                	mov    (%ecx),%al
  80090a:	41                   	inc    %ecx
  80090b:	88 03                	mov    %al,(%ebx)
  80090d:	43                   	inc    %ebx
  80090e:	4a                   	dec    %edx
  80090f:	74 05                	je     800916 <strlcpy+0x2a>
  800911:	80 39 00             	cmpb   $0x0,(%ecx)
  800914:	75 f2                	jne    800908 <strlcpy+0x1c>
		*dst = '\0';
  800916:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800919:	89 d8                	mov    %ebx,%eax
  80091b:	29 f0                	sub    %esi,%eax
}
  80091d:	5b                   	pop    %ebx
  80091e:	5e                   	pop    %esi
  80091f:	c9                   	leave  
  800920:	c3                   	ret    

00800921 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	8b 55 08             	mov    0x8(%ebp),%edx
  800927:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  80092a:	80 3a 00             	cmpb   $0x0,(%edx)
  80092d:	74 13                	je     800942 <strcmp+0x21>
  80092f:	8a 02                	mov    (%edx),%al
  800931:	3a 01                	cmp    (%ecx),%al
  800933:	75 0d                	jne    800942 <strcmp+0x21>
  800935:	42                   	inc    %edx
  800936:	41                   	inc    %ecx
  800937:	80 3a 00             	cmpb   $0x0,(%edx)
  80093a:	74 06                	je     800942 <strcmp+0x21>
  80093c:	8a 02                	mov    (%edx),%al
  80093e:	3a 01                	cmp    (%ecx),%al
  800940:	74 f3                	je     800935 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800942:	0f b6 02             	movzbl (%edx),%eax
  800945:	0f b6 11             	movzbl (%ecx),%edx
  800948:	29 d0                	sub    %edx,%eax
}
  80094a:	c9                   	leave  
  80094b:	c3                   	ret    

0080094c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	53                   	push   %ebx
  800950:	8b 55 08             	mov    0x8(%ebp),%edx
  800953:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800956:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800959:	85 c9                	test   %ecx,%ecx
  80095b:	74 1f                	je     80097c <strncmp+0x30>
  80095d:	80 3a 00             	cmpb   $0x0,(%edx)
  800960:	74 16                	je     800978 <strncmp+0x2c>
  800962:	8a 02                	mov    (%edx),%al
  800964:	3a 03                	cmp    (%ebx),%al
  800966:	75 10                	jne    800978 <strncmp+0x2c>
  800968:	42                   	inc    %edx
  800969:	43                   	inc    %ebx
  80096a:	49                   	dec    %ecx
  80096b:	74 0f                	je     80097c <strncmp+0x30>
  80096d:	80 3a 00             	cmpb   $0x0,(%edx)
  800970:	74 06                	je     800978 <strncmp+0x2c>
  800972:	8a 02                	mov    (%edx),%al
  800974:	3a 03                	cmp    (%ebx),%al
  800976:	74 f0                	je     800968 <strncmp+0x1c>
	if (n == 0)
  800978:	85 c9                	test   %ecx,%ecx
  80097a:	75 07                	jne    800983 <strncmp+0x37>
		return 0;
  80097c:	b8 00 00 00 00       	mov    $0x0,%eax
  800981:	eb 0a                	jmp    80098d <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800983:	0f b6 12             	movzbl (%edx),%edx
  800986:	0f b6 03             	movzbl (%ebx),%eax
  800989:	29 c2                	sub    %eax,%edx
  80098b:	89 d0                	mov    %edx,%eax
}
  80098d:	5b                   	pop    %ebx
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800999:	80 38 00             	cmpb   $0x0,(%eax)
  80099c:	74 0a                	je     8009a8 <strchr+0x18>
		if (*s == c)
  80099e:	38 10                	cmp    %dl,(%eax)
  8009a0:	74 0b                	je     8009ad <strchr+0x1d>
  8009a2:	40                   	inc    %eax
  8009a3:	80 38 00             	cmpb   $0x0,(%eax)
  8009a6:	75 f6                	jne    80099e <strchr+0xe>
			return (char *) s;
	return 0;
  8009a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ad:	c9                   	leave  
  8009ae:	c3                   	ret    

008009af <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  8009b8:	80 38 00             	cmpb   $0x0,(%eax)
  8009bb:	74 0a                	je     8009c7 <strfind+0x18>
		if (*s == c)
  8009bd:	38 10                	cmp    %dl,(%eax)
  8009bf:	74 06                	je     8009c7 <strfind+0x18>
  8009c1:	40                   	inc    %eax
  8009c2:	80 38 00             	cmpb   $0x0,(%eax)
  8009c5:	75 f6                	jne    8009bd <strfind+0xe>
			break;
	return (char *) s;
}
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	57                   	push   %edi
  8009cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  8009d3:	89 f8                	mov    %edi,%eax
  8009d5:	85 c9                	test   %ecx,%ecx
  8009d7:	74 40                	je     800a19 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009df:	75 30                	jne    800a11 <memset+0x48>
  8009e1:	f6 c1 03             	test   $0x3,%cl
  8009e4:	75 2b                	jne    800a11 <memset+0x48>
		c &= 0xFF;
  8009e6:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f0:	c1 e0 18             	shl    $0x18,%eax
  8009f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f6:	c1 e2 10             	shl    $0x10,%edx
  8009f9:	09 d0                	or     %edx,%eax
  8009fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fe:	c1 e2 08             	shl    $0x8,%edx
  800a01:	09 d0                	or     %edx,%eax
  800a03:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800a06:	c1 e9 02             	shr    $0x2,%ecx
  800a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0c:	fc                   	cld    
  800a0d:	f3 ab                	repz stos %eax,%es:(%edi)
  800a0f:	eb 06                	jmp    800a17 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a14:	fc                   	cld    
  800a15:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800a17:	89 f8                	mov    %edi,%eax
}
  800a19:	5f                   	pop    %edi
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

00800a1c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	57                   	push   %edi
  800a20:	56                   	push   %esi
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800a27:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a2a:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a2c:	39 c6                	cmp    %eax,%esi
  800a2e:	73 33                	jae    800a63 <memmove+0x47>
  800a30:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a33:	39 c2                	cmp    %eax,%edx
  800a35:	76 2c                	jbe    800a63 <memmove+0x47>
		s += n;
  800a37:	89 d6                	mov    %edx,%esi
		d += n;
  800a39:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3c:	f6 c2 03             	test   $0x3,%dl
  800a3f:	75 1b                	jne    800a5c <memmove+0x40>
  800a41:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a47:	75 13                	jne    800a5c <memmove+0x40>
  800a49:	f6 c1 03             	test   $0x3,%cl
  800a4c:	75 0e                	jne    800a5c <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800a4e:	83 ef 04             	sub    $0x4,%edi
  800a51:	83 ee 04             	sub    $0x4,%esi
  800a54:	c1 e9 02             	shr    $0x2,%ecx
  800a57:	fd                   	std    
  800a58:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800a5a:	eb 27                	jmp    800a83 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a5c:	4f                   	dec    %edi
  800a5d:	4e                   	dec    %esi
  800a5e:	fd                   	std    
  800a5f:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800a61:	eb 20                	jmp    800a83 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a63:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a69:	75 15                	jne    800a80 <memmove+0x64>
  800a6b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a71:	75 0d                	jne    800a80 <memmove+0x64>
  800a73:	f6 c1 03             	test   $0x3,%cl
  800a76:	75 08                	jne    800a80 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800a78:	c1 e9 02             	shr    $0x2,%ecx
  800a7b:	fc                   	cld    
  800a7c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800a7e:	eb 03                	jmp    800a83 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a80:	fc                   	cld    
  800a81:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a83:	5e                   	pop    %esi
  800a84:	5f                   	pop    %edi
  800a85:	c9                   	leave  
  800a86:	c3                   	ret    

00800a87 <memcpy>:

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
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a8a:	ff 75 10             	pushl  0x10(%ebp)
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	ff 75 08             	pushl  0x8(%ebp)
  800a93:	e8 84 ff ff ff       	call   800a1c <memmove>
}
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    

00800a9a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800a9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800aa1:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aa4:	8b 55 10             	mov    0x10(%ebp),%edx
  800aa7:	4a                   	dec    %edx
  800aa8:	83 fa ff             	cmp    $0xffffffff,%edx
  800aab:	74 1a                	je     800ac7 <memcmp+0x2d>
  800aad:	8a 01                	mov    (%ecx),%al
  800aaf:	3a 03                	cmp    (%ebx),%al
  800ab1:	74 0c                	je     800abf <memcmp+0x25>
  800ab3:	0f b6 d0             	movzbl %al,%edx
  800ab6:	0f b6 03             	movzbl (%ebx),%eax
  800ab9:	29 c2                	sub    %eax,%edx
  800abb:	89 d0                	mov    %edx,%eax
  800abd:	eb 0d                	jmp    800acc <memcmp+0x32>
  800abf:	41                   	inc    %ecx
  800ac0:	43                   	inc    %ebx
  800ac1:	4a                   	dec    %edx
  800ac2:	83 fa ff             	cmp    $0xffffffff,%edx
  800ac5:	75 e6                	jne    800aad <memcmp+0x13>
	}

	return 0;
  800ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800acc:	5b                   	pop    %ebx
  800acd:	c9                   	leave  
  800ace:	c3                   	ret    

00800acf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ad8:	89 c2                	mov    %eax,%edx
  800ada:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800add:	39 d0                	cmp    %edx,%eax
  800adf:	73 09                	jae    800aea <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae1:	38 08                	cmp    %cl,(%eax)
  800ae3:	74 05                	je     800aea <memfind+0x1b>
  800ae5:	40                   	inc    %eax
  800ae6:	39 d0                	cmp    %edx,%eax
  800ae8:	72 f7                	jb     800ae1 <memfind+0x12>
			break;
	return (void *) s;
}
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	57                   	push   %edi
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 55 08             	mov    0x8(%ebp),%edx
  800af5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800afb:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800b00:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800b05:	80 3a 20             	cmpb   $0x20,(%edx)
  800b08:	74 05                	je     800b0f <strtol+0x23>
  800b0a:	80 3a 09             	cmpb   $0x9,(%edx)
  800b0d:	75 0b                	jne    800b1a <strtol+0x2e>
  800b0f:	42                   	inc    %edx
  800b10:	80 3a 20             	cmpb   $0x20,(%edx)
  800b13:	74 fa                	je     800b0f <strtol+0x23>
  800b15:	80 3a 09             	cmpb   $0x9,(%edx)
  800b18:	74 f5                	je     800b0f <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800b1a:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800b1d:	75 03                	jne    800b22 <strtol+0x36>
		s++;
  800b1f:	42                   	inc    %edx
  800b20:	eb 0b                	jmp    800b2d <strtol+0x41>
	else if (*s == '-')
  800b22:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800b25:	75 06                	jne    800b2d <strtol+0x41>
		s++, neg = 1;
  800b27:	42                   	inc    %edx
  800b28:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2d:	85 c9                	test   %ecx,%ecx
  800b2f:	74 05                	je     800b36 <strtol+0x4a>
  800b31:	83 f9 10             	cmp    $0x10,%ecx
  800b34:	75 15                	jne    800b4b <strtol+0x5f>
  800b36:	80 3a 30             	cmpb   $0x30,(%edx)
  800b39:	75 10                	jne    800b4b <strtol+0x5f>
  800b3b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b3f:	75 0a                	jne    800b4b <strtol+0x5f>
		s += 2, base = 16;
  800b41:	83 c2 02             	add    $0x2,%edx
  800b44:	b9 10 00 00 00       	mov    $0x10,%ecx
  800b49:	eb 14                	jmp    800b5f <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800b4b:	85 c9                	test   %ecx,%ecx
  800b4d:	75 10                	jne    800b5f <strtol+0x73>
  800b4f:	80 3a 30             	cmpb   $0x30,(%edx)
  800b52:	75 05                	jne    800b59 <strtol+0x6d>
		s++, base = 8;
  800b54:	42                   	inc    %edx
  800b55:	b1 08                	mov    $0x8,%cl
  800b57:	eb 06                	jmp    800b5f <strtol+0x73>
	else if (base == 0)
  800b59:	85 c9                	test   %ecx,%ecx
  800b5b:	75 02                	jne    800b5f <strtol+0x73>
		base = 10;
  800b5d:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b5f:	8a 02                	mov    (%edx),%al
  800b61:	83 e8 30             	sub    $0x30,%eax
  800b64:	3c 09                	cmp    $0x9,%al
  800b66:	77 08                	ja     800b70 <strtol+0x84>
			dig = *s - '0';
  800b68:	0f be 02             	movsbl (%edx),%eax
  800b6b:	83 e8 30             	sub    $0x30,%eax
  800b6e:	eb 20                	jmp    800b90 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800b70:	8a 02                	mov    (%edx),%al
  800b72:	83 e8 61             	sub    $0x61,%eax
  800b75:	3c 19                	cmp    $0x19,%al
  800b77:	77 08                	ja     800b81 <strtol+0x95>
			dig = *s - 'a' + 10;
  800b79:	0f be 02             	movsbl (%edx),%eax
  800b7c:	83 e8 57             	sub    $0x57,%eax
  800b7f:	eb 0f                	jmp    800b90 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800b81:	8a 02                	mov    (%edx),%al
  800b83:	83 e8 41             	sub    $0x41,%eax
  800b86:	3c 19                	cmp    $0x19,%al
  800b88:	77 12                	ja     800b9c <strtol+0xb0>
			dig = *s - 'A' + 10;
  800b8a:	0f be 02             	movsbl (%edx),%eax
  800b8d:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800b90:	39 c8                	cmp    %ecx,%eax
  800b92:	7d 08                	jge    800b9c <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800b94:	42                   	inc    %edx
  800b95:	0f af d9             	imul   %ecx,%ebx
  800b98:	01 c3                	add    %eax,%ebx
  800b9a:	eb c3                	jmp    800b5f <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b9c:	85 f6                	test   %esi,%esi
  800b9e:	74 02                	je     800ba2 <strtol+0xb6>
		*endptr = (char *) s;
  800ba0:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800ba2:	89 d8                	mov    %ebx,%eax
  800ba4:	85 ff                	test   %edi,%edi
  800ba6:	74 02                	je     800baa <strtol+0xbe>
  800ba8:	f7 d8                	neg    %eax
}
  800baa:	5b                   	pop    %ebx
  800bab:	5e                   	pop    %esi
  800bac:	5f                   	pop    %edi
  800bad:	c9                   	leave  
  800bae:	c3                   	ret    
	...

00800bb0 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	57                   	push   %edi
  800bb4:	56                   	push   %esi
  800bb5:	53                   	push   %ebx
  800bb6:	83 ec 04             	sub    $0x4,%esp
  800bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bbf:	bf 00 00 00 00       	mov    $0x0,%edi
  800bc4:	89 f8                	mov    %edi,%eax
  800bc6:	89 fb                	mov    %edi,%ebx
  800bc8:	89 fe                	mov    %edi,%esi
  800bca:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcc:	83 c4 04             	add    $0x4,%esp
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
  800bda:	b8 01 00 00 00       	mov    $0x1,%eax
  800bdf:	bf 00 00 00 00       	mov    $0x0,%edi
  800be4:	89 fa                	mov    %edi,%edx
  800be6:	89 f9                	mov    %edi,%ecx
  800be8:	89 fb                	mov    %edi,%ebx
  800bea:	89 fe                	mov    %edi,%esi
  800bec:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 0c             	sub    $0xc,%esp
  800bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bff:	b8 03 00 00 00       	mov    $0x3,%eax
  800c04:	bf 00 00 00 00       	mov    $0x0,%edi
  800c09:	89 f9                	mov    %edi,%ecx
  800c0b:	89 fb                	mov    %edi,%ebx
  800c0d:	89 fe                	mov    %edi,%esi
  800c0f:	cd 30                	int    $0x30
  800c11:	85 c0                	test   %eax,%eax
  800c13:	7e 17                	jle    800c2c <sys_env_destroy+0x39>
  800c15:	83 ec 0c             	sub    $0xc,%esp
  800c18:	50                   	push   %eax
  800c19:	6a 03                	push   $0x3
  800c1b:	68 30 2a 80 00       	push   $0x802a30
  800c20:	6a 23                	push   $0x23
  800c22:	68 4d 2a 80 00       	push   $0x802a4d
  800c27:	e8 80 f5 ff ff       	call   8001ac <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c2c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
  800c3a:	b8 02 00 00 00       	mov    $0x2,%eax
  800c3f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c44:	89 fa                	mov    %edi,%edx
  800c46:	89 f9                	mov    %edi,%ecx
  800c48:	89 fb                	mov    %edi,%ebx
  800c4a:	89 fe                	mov    %edi,%esi
  800c4c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <sys_yield>:

void
sys_yield(void)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c5e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c63:	89 fa                	mov    %edi,%edx
  800c65:	89 f9                	mov    %edi,%ecx
  800c67:	89 fb                	mov    %edi,%ebx
  800c69:	89 fe                	mov    %edi,%esi
  800c6b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5f                   	pop    %edi
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
  800c78:	83 ec 0c             	sub    $0xc,%esp
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c84:	b8 04 00 00 00       	mov    $0x4,%eax
  800c89:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8e:	89 fe                	mov    %edi,%esi
  800c90:	cd 30                	int    $0x30
  800c92:	85 c0                	test   %eax,%eax
  800c94:	7e 17                	jle    800cad <sys_page_alloc+0x3b>
  800c96:	83 ec 0c             	sub    $0xc,%esp
  800c99:	50                   	push   %eax
  800c9a:	6a 04                	push   $0x4
  800c9c:	68 30 2a 80 00       	push   $0x802a30
  800ca1:	6a 23                	push   $0x23
  800ca3:	68 4d 2a 80 00       	push   $0x802a4d
  800ca8:	e8 ff f4 ff ff       	call   8001ac <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cad:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
  800cbb:	83 ec 0c             	sub    $0xc,%esp
  800cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cc7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cca:	8b 75 18             	mov    0x18(%ebp),%esi
  800ccd:	b8 05 00 00 00       	mov    $0x5,%eax
  800cd2:	cd 30                	int    $0x30
  800cd4:	85 c0                	test   %eax,%eax
  800cd6:	7e 17                	jle    800cef <sys_page_map+0x3a>
  800cd8:	83 ec 0c             	sub    $0xc,%esp
  800cdb:	50                   	push   %eax
  800cdc:	6a 05                	push   $0x5
  800cde:	68 30 2a 80 00       	push   $0x802a30
  800ce3:	6a 23                	push   $0x23
  800ce5:	68 4d 2a 80 00       	push   $0x802a4d
  800cea:	e8 bd f4 ff ff       	call   8001ac <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cef:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	c9                   	leave  
  800cf6:	c3                   	ret    

00800cf7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	83 ec 0c             	sub    $0xc,%esp
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d06:	b8 06 00 00 00       	mov    $0x6,%eax
  800d0b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d10:	89 fb                	mov    %edi,%ebx
  800d12:	89 fe                	mov    %edi,%esi
  800d14:	cd 30                	int    $0x30
  800d16:	85 c0                	test   %eax,%eax
  800d18:	7e 17                	jle    800d31 <sys_page_unmap+0x3a>
  800d1a:	83 ec 0c             	sub    $0xc,%esp
  800d1d:	50                   	push   %eax
  800d1e:	6a 06                	push   $0x6
  800d20:	68 30 2a 80 00       	push   $0x802a30
  800d25:	6a 23                	push   $0x23
  800d27:	68 4d 2a 80 00       	push   $0x802a4d
  800d2c:	e8 7b f4 ff ff       	call   8001ac <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d31:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	c9                   	leave  
  800d38:	c3                   	ret    

00800d39 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	8b 55 08             	mov    0x8(%ebp),%edx
  800d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d48:	b8 08 00 00 00       	mov    $0x8,%eax
  800d4d:	bf 00 00 00 00       	mov    $0x0,%edi
  800d52:	89 fb                	mov    %edi,%ebx
  800d54:	89 fe                	mov    %edi,%esi
  800d56:	cd 30                	int    $0x30
  800d58:	85 c0                	test   %eax,%eax
  800d5a:	7e 17                	jle    800d73 <sys_env_set_status+0x3a>
  800d5c:	83 ec 0c             	sub    $0xc,%esp
  800d5f:	50                   	push   %eax
  800d60:	6a 08                	push   $0x8
  800d62:	68 30 2a 80 00       	push   $0x802a30
  800d67:	6a 23                	push   $0x23
  800d69:	68 4d 2a 80 00       	push   $0x802a4d
  800d6e:	e8 39 f4 ff ff       	call   8001ac <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d73:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	c9                   	leave  
  800d7a:	c3                   	ret    

00800d7b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	57                   	push   %edi
  800d7f:	56                   	push   %esi
  800d80:	53                   	push   %ebx
  800d81:	83 ec 0c             	sub    $0xc,%esp
  800d84:	8b 55 08             	mov    0x8(%ebp),%edx
  800d87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8a:	b8 09 00 00 00       	mov    $0x9,%eax
  800d8f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d94:	89 fb                	mov    %edi,%ebx
  800d96:	89 fe                	mov    %edi,%esi
  800d98:	cd 30                	int    $0x30
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	7e 17                	jle    800db5 <sys_env_set_trapframe+0x3a>
  800d9e:	83 ec 0c             	sub    $0xc,%esp
  800da1:	50                   	push   %eax
  800da2:	6a 09                	push   $0x9
  800da4:	68 30 2a 80 00       	push   $0x802a30
  800da9:	6a 23                	push   $0x23
  800dab:	68 4d 2a 80 00       	push   $0x802a4d
  800db0:	e8 f7 f3 ff ff       	call   8001ac <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800db5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	c9                   	leave  
  800dbc:	c3                   	ret    

00800dbd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	57                   	push   %edi
  800dc1:	56                   	push   %esi
  800dc2:	53                   	push   %ebx
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd1:	bf 00 00 00 00       	mov    $0x0,%edi
  800dd6:	89 fb                	mov    %edi,%ebx
  800dd8:	89 fe                	mov    %edi,%esi
  800dda:	cd 30                	int    $0x30
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	7e 17                	jle    800df7 <sys_env_set_pgfault_upcall+0x3a>
  800de0:	83 ec 0c             	sub    $0xc,%esp
  800de3:	50                   	push   %eax
  800de4:	6a 0a                	push   $0xa
  800de6:	68 30 2a 80 00       	push   $0x802a30
  800deb:	6a 23                	push   $0x23
  800ded:	68 4d 2a 80 00       	push   $0x802a4d
  800df2:	e8 b5 f3 ff ff       	call   8001ac <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800df7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800dfa:	5b                   	pop    %ebx
  800dfb:	5e                   	pop    %esi
  800dfc:	5f                   	pop    %edi
  800dfd:	c9                   	leave  
  800dfe:	c3                   	ret    

00800dff <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dff:	55                   	push   %ebp
  800e00:	89 e5                	mov    %esp,%ebp
  800e02:	57                   	push   %edi
  800e03:	56                   	push   %esi
  800e04:	53                   	push   %ebx
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e11:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e16:	be 00 00 00 00       	mov    $0x0,%esi
  800e1b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e1d:	5b                   	pop    %ebx
  800e1e:	5e                   	pop    %esi
  800e1f:	5f                   	pop    %edi
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
  800e28:	83 ec 0c             	sub    $0xc,%esp
  800e2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e33:	bf 00 00 00 00       	mov    $0x0,%edi
  800e38:	89 f9                	mov    %edi,%ecx
  800e3a:	89 fb                	mov    %edi,%ebx
  800e3c:	89 fe                	mov    %edi,%esi
  800e3e:	cd 30                	int    $0x30
  800e40:	85 c0                	test   %eax,%eax
  800e42:	7e 17                	jle    800e5b <sys_ipc_recv+0x39>
  800e44:	83 ec 0c             	sub    $0xc,%esp
  800e47:	50                   	push   %eax
  800e48:	6a 0d                	push   $0xd
  800e4a:	68 30 2a 80 00       	push   $0x802a30
  800e4f:	6a 23                	push   $0x23
  800e51:	68 4d 2a 80 00       	push   $0x802a4d
  800e56:	e8 51 f3 ff ff       	call   8001ac <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e5b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	c9                   	leave  
  800e62:	c3                   	ret    

00800e63 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 0c             	sub    $0xc,%esp
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	b8 10 00 00 00       	mov    $0x10,%eax
  800e77:	bf 00 00 00 00       	mov    $0x0,%edi
  800e7c:	89 fb                	mov    %edi,%ebx
  800e7e:	89 fe                	mov    %edi,%esi
  800e80:	cd 30                	int    $0x30
  800e82:	85 c0                	test   %eax,%eax
  800e84:	7e 17                	jle    800e9d <sys_transmit_packet+0x3a>
  800e86:	83 ec 0c             	sub    $0xc,%esp
  800e89:	50                   	push   %eax
  800e8a:	6a 10                	push   $0x10
  800e8c:	68 30 2a 80 00       	push   $0x802a30
  800e91:	6a 23                	push   $0x23
  800e93:	68 4d 2a 80 00       	push   $0x802a4d
  800e98:	e8 0f f3 ff ff       	call   8001ac <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800e9d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
  800eab:	83 ec 0c             	sub    $0xc,%esp
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb4:	b8 11 00 00 00       	mov    $0x11,%eax
  800eb9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ebe:	89 fb                	mov    %edi,%ebx
  800ec0:	89 fe                	mov    %edi,%esi
  800ec2:	cd 30                	int    $0x30
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	7e 17                	jle    800edf <sys_receive_packet+0x3a>
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	50                   	push   %eax
  800ecc:	6a 11                	push   $0x11
  800ece:	68 30 2a 80 00       	push   $0x802a30
  800ed3:	6a 23                	push   $0x23
  800ed5:	68 4d 2a 80 00       	push   $0x802a4d
  800eda:	e8 cd f2 ff ff       	call   8001ac <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800edf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	c9                   	leave  
  800ee6:	c3                   	ret    

00800ee7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
  800eed:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ef2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ef7:	89 fa                	mov    %edi,%edx
  800ef9:	89 f9                	mov    %edi,%ecx
  800efb:	89 fb                	mov    %edi,%ebx
  800efd:	89 fe                	mov    %edi,%esi
  800eff:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	c9                   	leave  
  800f05:	c3                   	ret    

00800f06 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	57                   	push   %edi
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
  800f0c:	83 ec 0c             	sub    $0xc,%esp
  800f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f12:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f17:	bf 00 00 00 00       	mov    $0x0,%edi
  800f1c:	89 f9                	mov    %edi,%ecx
  800f1e:	89 fb                	mov    %edi,%ebx
  800f20:	89 fe                	mov    %edi,%esi
  800f22:	cd 30                	int    $0x30
  800f24:	85 c0                	test   %eax,%eax
  800f26:	7e 17                	jle    800f3f <sys_map_receive_buffers+0x39>
  800f28:	83 ec 0c             	sub    $0xc,%esp
  800f2b:	50                   	push   %eax
  800f2c:	6a 0e                	push   $0xe
  800f2e:	68 30 2a 80 00       	push   $0x802a30
  800f33:	6a 23                	push   $0x23
  800f35:	68 4d 2a 80 00       	push   $0x802a4d
  800f3a:	e8 6d f2 ff ff       	call   8001ac <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800f3f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f42:	5b                   	pop    %ebx
  800f43:	5e                   	pop    %esi
  800f44:	5f                   	pop    %edi
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	57                   	push   %edi
  800f4b:	56                   	push   %esi
  800f4c:	53                   	push   %ebx
  800f4d:	83 ec 0c             	sub    $0xc,%esp
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	b8 12 00 00 00       	mov    $0x12,%eax
  800f58:	bf 00 00 00 00       	mov    $0x0,%edi
  800f5d:	89 f9                	mov    %edi,%ecx
  800f5f:	89 fb                	mov    %edi,%ebx
  800f61:	89 fe                	mov    %edi,%esi
  800f63:	cd 30                	int    $0x30
  800f65:	85 c0                	test   %eax,%eax
  800f67:	7e 17                	jle    800f80 <sys_receive_packet_zerocopy+0x39>
  800f69:	83 ec 0c             	sub    $0xc,%esp
  800f6c:	50                   	push   %eax
  800f6d:	6a 12                	push   $0x12
  800f6f:	68 30 2a 80 00       	push   $0x802a30
  800f74:	6a 23                	push   $0x23
  800f76:	68 4d 2a 80 00       	push   $0x802a4d
  800f7b:	e8 2c f2 ff ff       	call   8001ac <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800f80:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f83:	5b                   	pop    %ebx
  800f84:	5e                   	pop    %esi
  800f85:	5f                   	pop    %edi
  800f86:	c9                   	leave  
  800f87:	c3                   	ret    

00800f88 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800f88:	55                   	push   %ebp
  800f89:	89 e5                	mov    %esp,%ebp
  800f8b:	57                   	push   %edi
  800f8c:	56                   	push   %esi
  800f8d:	53                   	push   %ebx
  800f8e:	83 ec 0c             	sub    $0xc,%esp
  800f91:	8b 55 08             	mov    0x8(%ebp),%edx
  800f94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f97:	b8 13 00 00 00       	mov    $0x13,%eax
  800f9c:	bf 00 00 00 00       	mov    $0x0,%edi
  800fa1:	89 fb                	mov    %edi,%ebx
  800fa3:	89 fe                	mov    %edi,%esi
  800fa5:	cd 30                	int    $0x30
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	7e 17                	jle    800fc2 <sys_env_set_priority+0x3a>
  800fab:	83 ec 0c             	sub    $0xc,%esp
  800fae:	50                   	push   %eax
  800faf:	6a 13                	push   $0x13
  800fb1:	68 30 2a 80 00       	push   $0x802a30
  800fb6:	6a 23                	push   $0x23
  800fb8:	68 4d 2a 80 00       	push   $0x802a4d
  800fbd:	e8 ea f1 ff ff       	call   8001ac <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800fc2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fc5:	5b                   	pop    %ebx
  800fc6:	5e                   	pop    %esi
  800fc7:	5f                   	pop    %edi
  800fc8:	c9                   	leave  
  800fc9:	c3                   	ret    
	...

00800fcc <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800fd2:	ff 75 08             	pushl  0x8(%ebp)
  800fd5:	e8 0a 00 00 00       	call   800fe4 <fd2num>
  800fda:	c1 e0 16             	shl    $0x16,%eax
  800fdd:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  800fe2:	c9                   	leave  
  800fe3:	c3                   	ret    

00800fe4 <fd2num>:

int
fd2num(struct Fd *fd)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	05 00 00 40 30       	add    $0x30400000,%eax
  800fef:	c1 e8 0c             	shr    $0xc,%eax
}
  800ff2:	c9                   	leave  
  800ff3:	c3                   	ret    

00800ff4 <fd_alloc>:

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
  800ff4:	55                   	push   %ebp
  800ff5:	89 e5                	mov    %esp,%ebp
  800ff7:	57                   	push   %edi
  800ff8:	56                   	push   %esi
  800ff9:	53                   	push   %ebx
  800ffa:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ffd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801002:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801007:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  80100c:	89 c8                	mov    %ecx,%eax
  80100e:	c1 e0 0c             	shl    $0xc,%eax
  801011:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801017:	89 d0                	mov    %edx,%eax
  801019:	c1 e8 16             	shr    $0x16,%eax
  80101c:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80101f:	a8 01                	test   $0x1,%al
  801021:	74 0c                	je     80102f <fd_alloc+0x3b>
  801023:	89 d0                	mov    %edx,%eax
  801025:	c1 e8 0c             	shr    $0xc,%eax
  801028:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  80102b:	a8 01                	test   $0x1,%al
  80102d:	75 09                	jne    801038 <fd_alloc+0x44>
			*fd_store = fd;
  80102f:	89 17                	mov    %edx,(%edi)
			return 0;
  801031:	b8 00 00 00 00       	mov    $0x0,%eax
  801036:	eb 11                	jmp    801049 <fd_alloc+0x55>
  801038:	41                   	inc    %ecx
  801039:	83 f9 1f             	cmp    $0x1f,%ecx
  80103c:	7e ce                	jle    80100c <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80103e:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801044:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801049:	5b                   	pop    %ebx
  80104a:	5e                   	pop    %esi
  80104b:	5f                   	pop    %edi
  80104c:	c9                   	leave  
  80104d:	c3                   	ret    

0080104e <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801054:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801059:	83 f8 1f             	cmp    $0x1f,%eax
  80105c:	77 3a                	ja     801098 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80105e:	c1 e0 0c             	shl    $0xc,%eax
  801061:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801067:	89 d0                	mov    %edx,%eax
  801069:	c1 e8 16             	shr    $0x16,%eax
  80106c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801073:	a8 01                	test   $0x1,%al
  801075:	74 10                	je     801087 <fd_lookup+0x39>
  801077:	89 d0                	mov    %edx,%eax
  801079:	c1 e8 0c             	shr    $0xc,%eax
  80107c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801083:	a8 01                	test   $0x1,%al
  801085:	75 07                	jne    80108e <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801087:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80108c:	eb 0a                	jmp    801098 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	89 10                	mov    %edx,(%eax)
	return 0;
  801093:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801098:	89 d0                	mov    %edx,%eax
  80109a:	c9                   	leave  
  80109b:	c3                   	ret    

0080109c <fd_close>:

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
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	56                   	push   %esi
  8010a0:	53                   	push   %ebx
  8010a1:	83 ec 10             	sub    $0x10,%esp
  8010a4:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010a7:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8010aa:	50                   	push   %eax
  8010ab:	56                   	push   %esi
  8010ac:	e8 33 ff ff ff       	call   800fe4 <fd2num>
  8010b1:	89 04 24             	mov    %eax,(%esp)
  8010b4:	e8 95 ff ff ff       	call   80104e <fd_lookup>
  8010b9:	89 c3                	mov    %eax,%ebx
  8010bb:	83 c4 08             	add    $0x8,%esp
  8010be:	85 c0                	test   %eax,%eax
  8010c0:	78 05                	js     8010c7 <fd_close+0x2b>
  8010c2:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8010c5:	74 0f                	je     8010d6 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8010c7:	89 d8                	mov    %ebx,%eax
  8010c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010cd:	75 3a                	jne    801109 <fd_close+0x6d>
  8010cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d4:	eb 33                	jmp    801109 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8010d6:	83 ec 08             	sub    $0x8,%esp
  8010d9:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	ff 36                	pushl  (%esi)
  8010df:	e8 2c 00 00 00       	call   801110 <dev_lookup>
  8010e4:	89 c3                	mov    %eax,%ebx
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	78 0f                	js     8010fc <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8010ed:	83 ec 0c             	sub    $0xc,%esp
  8010f0:	56                   	push   %esi
  8010f1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8010f4:	ff 50 10             	call   *0x10(%eax)
  8010f7:	89 c3                	mov    %eax,%ebx
  8010f9:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010fc:	83 ec 08             	sub    $0x8,%esp
  8010ff:	56                   	push   %esi
  801100:	6a 00                	push   $0x0
  801102:	e8 f0 fb ff ff       	call   800cf7 <sys_page_unmap>
	return r;
  801107:	89 d8                	mov    %ebx,%eax
}
  801109:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80110c:	5b                   	pop    %ebx
  80110d:	5e                   	pop    %esi
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <dev_lookup>:


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
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	56                   	push   %esi
  801114:	53                   	push   %ebx
  801115:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801118:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  80111b:	ba 00 00 00 00       	mov    $0x0,%edx
  801120:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  801127:	74 1c                	je     801145 <dev_lookup+0x35>
  801129:	b9 04 60 80 00       	mov    $0x806004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80112e:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  801131:	39 18                	cmp    %ebx,(%eax)
  801133:	75 09                	jne    80113e <dev_lookup+0x2e>
			*dev = devtab[i];
  801135:	89 06                	mov    %eax,(%esi)
			return 0;
  801137:	b8 00 00 00 00       	mov    $0x0,%eax
  80113c:	eb 29                	jmp    801167 <dev_lookup+0x57>
  80113e:	42                   	inc    %edx
  80113f:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  801143:	75 e9                	jne    80112e <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801145:	83 ec 04             	sub    $0x4,%esp
  801148:	53                   	push   %ebx
  801149:	a1 80 60 80 00       	mov    0x806080,%eax
  80114e:	8b 40 4c             	mov    0x4c(%eax),%eax
  801151:	50                   	push   %eax
  801152:	68 5c 2a 80 00       	push   $0x802a5c
  801157:	e8 40 f1 ff ff       	call   80029c <cprintf>
	*dev = 0;
  80115c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  801162:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801167:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80116a:	5b                   	pop    %ebx
  80116b:	5e                   	pop    %esi
  80116c:	c9                   	leave  
  80116d:	c3                   	ret    

0080116e <close>:

int
close(int fdnum)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801174:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801177:	50                   	push   %eax
  801178:	ff 75 08             	pushl  0x8(%ebp)
  80117b:	e8 ce fe ff ff       	call   80104e <fd_lookup>
  801180:	83 c4 08             	add    $0x8,%esp
		return r;
  801183:	89 c2                	mov    %eax,%edx
  801185:	85 c0                	test   %eax,%eax
  801187:	78 0f                	js     801198 <close+0x2a>
	else
		return fd_close(fd, 1);
  801189:	83 ec 08             	sub    $0x8,%esp
  80118c:	6a 01                	push   $0x1
  80118e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801191:	e8 06 ff ff ff       	call   80109c <fd_close>
  801196:	89 c2                	mov    %eax,%edx
}
  801198:	89 d0                	mov    %edx,%eax
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <close_all>:

void
close_all(void)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	53                   	push   %ebx
  8011a0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011a3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011a8:	83 ec 0c             	sub    $0xc,%esp
  8011ab:	53                   	push   %ebx
  8011ac:	e8 bd ff ff ff       	call   80116e <close>
  8011b1:	83 c4 10             	add    $0x10,%esp
  8011b4:	43                   	inc    %ebx
  8011b5:	83 fb 1f             	cmp    $0x1f,%ebx
  8011b8:	7e ee                	jle    8011a8 <close_all+0xc>
}
  8011ba:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	57                   	push   %edi
  8011c3:	56                   	push   %esi
  8011c4:	53                   	push   %ebx
  8011c5:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011c8:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8011cb:	50                   	push   %eax
  8011cc:	ff 75 08             	pushl  0x8(%ebp)
  8011cf:	e8 7a fe ff ff       	call   80104e <fd_lookup>
  8011d4:	89 c6                	mov    %eax,%esi
  8011d6:	83 c4 08             	add    $0x8,%esp
  8011d9:	85 f6                	test   %esi,%esi
  8011db:	0f 88 f8 00 00 00    	js     8012d9 <dup+0x11a>
		return r;
	close(newfdnum);
  8011e1:	83 ec 0c             	sub    $0xc,%esp
  8011e4:	ff 75 0c             	pushl  0xc(%ebp)
  8011e7:	e8 82 ff ff ff       	call   80116e <close>

	newfd = INDEX2FD(newfdnum);
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	c1 e0 0c             	shl    $0xc,%eax
  8011f2:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8011f7:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8011fa:	83 c4 04             	add    $0x4,%esp
  8011fd:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801200:	e8 c7 fd ff ff       	call   800fcc <fd2data>
  801205:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801207:	83 c4 04             	add    $0x4,%esp
  80120a:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80120d:	e8 ba fd ff ff       	call   800fcc <fd2data>
  801212:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801215:	89 f8                	mov    %edi,%eax
  801217:	c1 e8 16             	shr    $0x16,%eax
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801224:	85 c0                	test   %eax,%eax
  801226:	74 48                	je     801270 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801228:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  80122d:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  801230:	89 d0                	mov    %edx,%eax
  801232:	c1 e8 0c             	shr    $0xc,%eax
  801235:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  80123c:	a8 01                	test   $0x1,%al
  80123e:	74 22                	je     801262 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	25 07 0e 00 00       	and    $0xe07,%eax
  801248:	50                   	push   %eax
  801249:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80124c:	01 d8                	add    %ebx,%eax
  80124e:	50                   	push   %eax
  80124f:	6a 00                	push   $0x0
  801251:	52                   	push   %edx
  801252:	6a 00                	push   $0x0
  801254:	e8 5c fa ff ff       	call   800cb5 <sys_page_map>
  801259:	89 c6                	mov    %eax,%esi
  80125b:	83 c4 20             	add    $0x20,%esp
  80125e:	85 c0                	test   %eax,%eax
  801260:	78 3f                	js     8012a1 <dup+0xe2>
  801262:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801268:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80126e:	7e bd                	jle    80122d <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801276:	89 d0                	mov    %edx,%eax
  801278:	c1 e8 0c             	shr    $0xc,%eax
  80127b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801282:	25 07 0e 00 00       	and    $0xe07,%eax
  801287:	50                   	push   %eax
  801288:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80128b:	6a 00                	push   $0x0
  80128d:	52                   	push   %edx
  80128e:	6a 00                	push   $0x0
  801290:	e8 20 fa ff ff       	call   800cb5 <sys_page_map>
  801295:	89 c6                	mov    %eax,%esi
  801297:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80129a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129d:	85 f6                	test   %esi,%esi
  80129f:	79 38                	jns    8012d9 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  8012a1:	83 ec 08             	sub    $0x8,%esp
  8012a4:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8012a7:	6a 00                	push   $0x0
  8012a9:	e8 49 fa ff ff       	call   800cf7 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8012ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b3:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8012b6:	83 ec 08             	sub    $0x8,%esp
  8012b9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8012bc:	01 d8                	add    %ebx,%eax
  8012be:	50                   	push   %eax
  8012bf:	6a 00                	push   $0x0
  8012c1:	e8 31 fa ff ff       	call   800cf7 <sys_page_unmap>
  8012c6:	83 c4 10             	add    $0x10,%esp
  8012c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012cf:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8012d5:	7e df                	jle    8012b6 <dup+0xf7>
	return r;
  8012d7:	89 f0                	mov    %esi,%eax
}
  8012d9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8012dc:	5b                   	pop    %ebx
  8012dd:	5e                   	pop    %esi
  8012de:	5f                   	pop    %edi
  8012df:	c9                   	leave  
  8012e0:	c3                   	ret    

008012e1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	53                   	push   %ebx
  8012e5:	83 ec 14             	sub    $0x14,%esp
  8012e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012eb:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8012ee:	50                   	push   %eax
  8012ef:	53                   	push   %ebx
  8012f0:	e8 59 fd ff ff       	call   80104e <fd_lookup>
  8012f5:	89 c2                	mov    %eax,%edx
  8012f7:	83 c4 08             	add    $0x8,%esp
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 1a                	js     801318 <read+0x37>
  8012fe:	83 ec 08             	sub    $0x8,%esp
  801301:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801304:	50                   	push   %eax
  801305:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801308:	ff 30                	pushl  (%eax)
  80130a:	e8 01 fe ff ff       	call   801110 <dev_lookup>
  80130f:	89 c2                	mov    %eax,%edx
  801311:	83 c4 10             	add    $0x10,%esp
  801314:	85 c0                	test   %eax,%eax
  801316:	79 04                	jns    80131c <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801318:	89 d0                	mov    %edx,%eax
  80131a:	eb 50                	jmp    80136c <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80131c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80131f:	8b 40 08             	mov    0x8(%eax),%eax
  801322:	83 e0 03             	and    $0x3,%eax
  801325:	83 f8 01             	cmp    $0x1,%eax
  801328:	75 1e                	jne    801348 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  80132a:	83 ec 04             	sub    $0x4,%esp
  80132d:	53                   	push   %ebx
  80132e:	a1 80 60 80 00       	mov    0x806080,%eax
  801333:	8b 40 4c             	mov    0x4c(%eax),%eax
  801336:	50                   	push   %eax
  801337:	68 9d 2a 80 00       	push   $0x802a9d
  80133c:	e8 5b ef ff ff       	call   80029c <cprintf>
		return -E_INVAL;
  801341:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801346:	eb 24                	jmp    80136c <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801348:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80134b:	ff 70 04             	pushl  0x4(%eax)
  80134e:	ff 75 10             	pushl  0x10(%ebp)
  801351:	ff 75 0c             	pushl  0xc(%ebp)
  801354:	50                   	push   %eax
  801355:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801358:	ff 50 08             	call   *0x8(%eax)
  80135b:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  80135d:	83 c4 10             	add    $0x10,%esp
  801360:	85 c0                	test   %eax,%eax
  801362:	78 06                	js     80136a <read+0x89>
		fd->fd_offset += r;
  801364:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801367:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80136a:	89 d0                	mov    %edx,%eax
}
  80136c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	57                   	push   %edi
  801375:	56                   	push   %esi
  801376:	53                   	push   %ebx
  801377:	83 ec 0c             	sub    $0xc,%esp
  80137a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80137d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801380:	bb 00 00 00 00       	mov    $0x0,%ebx
  801385:	39 f3                	cmp    %esi,%ebx
  801387:	73 25                	jae    8013ae <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	89 f0                	mov    %esi,%eax
  80138e:	29 d8                	sub    %ebx,%eax
  801390:	50                   	push   %eax
  801391:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801394:	50                   	push   %eax
  801395:	ff 75 08             	pushl  0x8(%ebp)
  801398:	e8 44 ff ff ff       	call   8012e1 <read>
		if (m < 0)
  80139d:	83 c4 10             	add    $0x10,%esp
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	78 0c                	js     8013b0 <readn+0x3f>
			return m;
		if (m == 0)
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	74 06                	je     8013ae <readn+0x3d>
  8013a8:	01 c3                	add    %eax,%ebx
  8013aa:	39 f3                	cmp    %esi,%ebx
  8013ac:	72 db                	jb     801389 <readn+0x18>
			break;
	}
	return tot;
  8013ae:	89 d8                	mov    %ebx,%eax
}
  8013b0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8013b3:	5b                   	pop    %ebx
  8013b4:	5e                   	pop    %esi
  8013b5:	5f                   	pop    %edi
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	53                   	push   %ebx
  8013bc:	83 ec 14             	sub    $0x14,%esp
  8013bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c2:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	53                   	push   %ebx
  8013c7:	e8 82 fc ff ff       	call   80104e <fd_lookup>
  8013cc:	89 c2                	mov    %eax,%edx
  8013ce:	83 c4 08             	add    $0x8,%esp
  8013d1:	85 c0                	test   %eax,%eax
  8013d3:	78 1a                	js     8013ef <write+0x37>
  8013d5:	83 ec 08             	sub    $0x8,%esp
  8013d8:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8013db:	50                   	push   %eax
  8013dc:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013df:	ff 30                	pushl  (%eax)
  8013e1:	e8 2a fd ff ff       	call   801110 <dev_lookup>
  8013e6:	89 c2                	mov    %eax,%edx
  8013e8:	83 c4 10             	add    $0x10,%esp
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	79 04                	jns    8013f3 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8013ef:	89 d0                	mov    %edx,%eax
  8013f1:	eb 4b                	jmp    80143e <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013f3:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013f6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013fa:	75 1e                	jne    80141a <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8013fc:	83 ec 04             	sub    $0x4,%esp
  8013ff:	53                   	push   %ebx
  801400:	a1 80 60 80 00       	mov    0x806080,%eax
  801405:	8b 40 4c             	mov    0x4c(%eax),%eax
  801408:	50                   	push   %eax
  801409:	68 b9 2a 80 00       	push   $0x802ab9
  80140e:	e8 89 ee ff ff       	call   80029c <cprintf>
		return -E_INVAL;
  801413:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801418:	eb 24                	jmp    80143e <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  80141a:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80141d:	ff 70 04             	pushl  0x4(%eax)
  801420:	ff 75 10             	pushl  0x10(%ebp)
  801423:	ff 75 0c             	pushl  0xc(%ebp)
  801426:	50                   	push   %eax
  801427:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80142a:	ff 50 0c             	call   *0xc(%eax)
  80142d:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80142f:	83 c4 10             	add    $0x10,%esp
  801432:	85 c0                	test   %eax,%eax
  801434:	7e 06                	jle    80143c <write+0x84>
		fd->fd_offset += r;
  801436:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801439:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80143c:	89 d0                	mov    %edx,%eax
}
  80143e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <seek>:

int
seek(int fdnum, off_t offset)
{
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801449:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80144c:	50                   	push   %eax
  80144d:	ff 75 08             	pushl  0x8(%ebp)
  801450:	e8 f9 fb ff ff       	call   80104e <fd_lookup>
  801455:	83 c4 08             	add    $0x8,%esp
		return r;
  801458:	89 c2                	mov    %eax,%edx
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 0e                	js     80146c <seek+0x29>
	fd->fd_offset = offset;
  80145e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801461:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801464:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801467:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80146c:	89 d0                	mov    %edx,%eax
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	53                   	push   %ebx
  801474:	83 ec 14             	sub    $0x14,%esp
  801477:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147a:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80147d:	50                   	push   %eax
  80147e:	53                   	push   %ebx
  80147f:	e8 ca fb ff ff       	call   80104e <fd_lookup>
  801484:	83 c4 08             	add    $0x8,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 4e                	js     8014d9 <ftruncate+0x69>
  80148b:	83 ec 08             	sub    $0x8,%esp
  80148e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801491:	50                   	push   %eax
  801492:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801495:	ff 30                	pushl  (%eax)
  801497:	e8 74 fc ff ff       	call   801110 <dev_lookup>
  80149c:	83 c4 10             	add    $0x10,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	78 36                	js     8014d9 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a3:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8014a6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014aa:	75 1e                	jne    8014ca <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	53                   	push   %ebx
  8014b0:	a1 80 60 80 00       	mov    0x806080,%eax
  8014b5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014b8:	50                   	push   %eax
  8014b9:	68 7c 2a 80 00       	push   $0x802a7c
  8014be:	e8 d9 ed ff ff       	call   80029c <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8014c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c8:	eb 0f                	jmp    8014d9 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8014ca:	83 ec 08             	sub    $0x8,%esp
  8014cd:	ff 75 0c             	pushl  0xc(%ebp)
  8014d0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8014d3:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8014d6:	ff 50 1c             	call   *0x1c(%eax)
}
  8014d9:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	53                   	push   %ebx
  8014e2:	83 ec 14             	sub    $0x14,%esp
  8014e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e8:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8014eb:	50                   	push   %eax
  8014ec:	ff 75 08             	pushl  0x8(%ebp)
  8014ef:	e8 5a fb ff ff       	call   80104e <fd_lookup>
  8014f4:	83 c4 08             	add    $0x8,%esp
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	78 42                	js     80153d <fstat+0x5f>
  8014fb:	83 ec 08             	sub    $0x8,%esp
  8014fe:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801501:	50                   	push   %eax
  801502:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801505:	ff 30                	pushl  (%eax)
  801507:	e8 04 fc ff ff       	call   801110 <dev_lookup>
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	85 c0                	test   %eax,%eax
  801511:	78 2a                	js     80153d <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  801513:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801516:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80151d:	00 00 00 
	stat->st_isdir = 0;
  801520:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801527:	00 00 00 
	stat->st_dev = dev;
  80152a:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80152d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801533:	83 ec 08             	sub    $0x8,%esp
  801536:	53                   	push   %ebx
  801537:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80153a:	ff 50 14             	call   *0x14(%eax)
}
  80153d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
  801545:	56                   	push   %esi
  801546:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	6a 00                	push   $0x0
  80154c:	ff 75 08             	pushl  0x8(%ebp)
  80154f:	e8 28 00 00 00       	call   80157c <open>
  801554:	89 c6                	mov    %eax,%esi
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	85 f6                	test   %esi,%esi
  80155b:	78 18                	js     801575 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  80155d:	83 ec 08             	sub    $0x8,%esp
  801560:	ff 75 0c             	pushl  0xc(%ebp)
  801563:	56                   	push   %esi
  801564:	e8 75 ff ff ff       	call   8014de <fstat>
  801569:	89 c3                	mov    %eax,%ebx
	close(fd);
  80156b:	89 34 24             	mov    %esi,(%esp)
  80156e:	e8 fb fb ff ff       	call   80116e <close>
	return r;
  801573:	89 d8                	mov    %ebx,%eax
}
  801575:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801578:	5b                   	pop    %ebx
  801579:	5e                   	pop    %esi
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	53                   	push   %ebx
  801580:	83 ec 10             	sub    $0x10,%esp
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
  801583:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801586:	50                   	push   %eax
  801587:	e8 68 fa ff ff       	call   800ff4 <fd_alloc>
  80158c:	89 c3                	mov    %eax,%ebx
  80158e:	83 c4 10             	add    $0x10,%esp
  801591:	85 db                	test   %ebx,%ebx
  801593:	78 36                	js     8015cb <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801595:	83 ec 04             	sub    $0x4,%esp
  801598:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	ff 75 08             	pushl  0x8(%ebp)
  8015a1:	e8 37 06 00 00       	call   801bdd <fsipc_open>
  8015a6:	89 c3                	mov    %eax,%ebx
  8015a8:	83 c4 10             	add    $0x10,%esp
  8015ab:	85 c0                	test   %eax,%eax
  8015ad:	79 11                	jns    8015c0 <open+0x44>
          fd_close(fd_store, 0);
  8015af:	83 ec 08             	sub    $0x8,%esp
  8015b2:	6a 00                	push   $0x0
  8015b4:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8015b7:	e8 e0 fa ff ff       	call   80109c <fd_close>
          return r;
  8015bc:	89 d8                	mov    %ebx,%eax
  8015be:	eb 0b                	jmp    8015cb <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8015c6:	e8 19 fa ff ff       	call   800fe4 <fd2num>
}
  8015cb:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 04             	sub    $0x4,%esp
  8015d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  8015da:	6a 01                	push   $0x1
  8015dc:	6a 00                	push   $0x0
  8015de:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  8015e4:	53                   	push   %ebx
  8015e5:	e8 e7 03 00 00       	call   8019d1 <funmap>
  8015ea:	83 c4 10             	add    $0x10,%esp
          return r;
  8015ed:	89 c2                	mov    %eax,%edx
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	78 19                	js     80160c <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  8015f3:	83 ec 0c             	sub    $0xc,%esp
  8015f6:	ff 73 0c             	pushl  0xc(%ebx)
  8015f9:	e8 84 06 00 00       	call   801c82 <fsipc_close>
  8015fe:	83 c4 10             	add    $0x10,%esp
          return r;
  801601:	89 c2                	mov    %eax,%edx
  801603:	85 c0                	test   %eax,%eax
  801605:	78 05                	js     80160c <file_close+0x3c>
        }
        return 0;
  801607:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80160c:	89 d0                	mov    %edx,%eax
  80160e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801611:	c9                   	leave  
  801612:	c3                   	ret    

00801613 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	57                   	push   %edi
  801617:	56                   	push   %esi
  801618:	53                   	push   %ebx
  801619:	83 ec 0c             	sub    $0xc,%esp
  80161c:	8b 75 10             	mov    0x10(%ebp),%esi
  80161f:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801622:	8b 45 08             	mov    0x8(%ebp),%eax
  801625:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  80162b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801630:	39 d7                	cmp    %edx,%edi
  801632:	0f 87 95 00 00 00    	ja     8016cd <file_read+0xba>
	if (offset + n > size)
  801638:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80163b:	39 d0                	cmp    %edx,%eax
  80163d:	76 04                	jbe    801643 <file_read+0x30>
		n = size - offset;
  80163f:	89 d6                	mov    %edx,%esi
  801641:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801643:	83 ec 0c             	sub    $0xc,%esp
  801646:	ff 75 08             	pushl  0x8(%ebp)
  801649:	e8 7e f9 ff ff       	call   800fcc <fd2data>
  80164e:	89 c3                	mov    %eax,%ebx
  801650:	01 fb                	add    %edi,%ebx
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	eb 41                	jmp    801698 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801657:	89 d8                	mov    %ebx,%eax
  801659:	c1 e8 16             	shr    $0x16,%eax
  80165c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801663:	a8 01                	test   $0x1,%al
  801665:	74 10                	je     801677 <file_read+0x64>
  801667:	89 d8                	mov    %ebx,%eax
  801669:	c1 e8 0c             	shr    $0xc,%eax
  80166c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801673:	a8 01                	test   $0x1,%al
  801675:	75 1b                	jne    801692 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801677:	83 ec 04             	sub    $0x4,%esp
  80167a:	8d 04 37             	lea    (%edi,%esi,1),%eax
  80167d:	50                   	push   %eax
  80167e:	57                   	push   %edi
  80167f:	ff 75 08             	pushl  0x8(%ebp)
  801682:	e8 d4 02 00 00       	call   80195b <fmap>
  801687:	83 c4 10             	add    $0x10,%esp
              return r;
  80168a:	89 c1                	mov    %eax,%ecx
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 3d                	js     8016cd <file_read+0xba>
  801690:	eb 1c                	jmp    8016ae <file_read+0x9b>
  801692:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801698:	83 ec 0c             	sub    $0xc,%esp
  80169b:	ff 75 08             	pushl  0x8(%ebp)
  80169e:	e8 29 f9 ff ff       	call   800fcc <fd2data>
  8016a3:	01 f8                	add    %edi,%eax
  8016a5:	01 f0                	add    %esi,%eax
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	39 d8                	cmp    %ebx,%eax
  8016ac:	77 a9                	ja     801657 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	56                   	push   %esi
  8016b2:	83 ec 04             	sub    $0x4,%esp
  8016b5:	ff 75 08             	pushl  0x8(%ebp)
  8016b8:	e8 0f f9 ff ff       	call   800fcc <fd2data>
  8016bd:	83 c4 08             	add    $0x8,%esp
  8016c0:	01 f8                	add    %edi,%eax
  8016c2:	50                   	push   %eax
  8016c3:	ff 75 0c             	pushl  0xc(%ebp)
  8016c6:	e8 51 f3 ff ff       	call   800a1c <memmove>
	return n;
  8016cb:	89 f1                	mov    %esi,%ecx
}
  8016cd:	89 c8                	mov    %ecx,%eax
  8016cf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8016d2:	5b                   	pop    %ebx
  8016d3:	5e                   	pop    %esi
  8016d4:	5f                   	pop    %edi
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	56                   	push   %esi
  8016db:	53                   	push   %ebx
  8016dc:	83 ec 18             	sub    $0x18,%esp
  8016df:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016e2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8016e5:	50                   	push   %eax
  8016e6:	ff 75 08             	pushl  0x8(%ebp)
  8016e9:	e8 60 f9 ff ff       	call   80104e <fd_lookup>
  8016ee:	83 c4 10             	add    $0x10,%esp
		return r;
  8016f1:	89 c2                	mov    %eax,%edx
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	0f 88 9f 00 00 00    	js     80179a <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  8016fb:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8016fe:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  801700:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801705:	3b 05 20 60 80 00    	cmp    0x806020,%eax
  80170b:	0f 85 89 00 00 00    	jne    80179a <read_map+0xc3>
	va = fd2data(fd) + offset;
  801711:	83 ec 0c             	sub    $0xc,%esp
  801714:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801717:	e8 b0 f8 ff ff       	call   800fcc <fd2data>
  80171c:	89 c3                	mov    %eax,%ebx
  80171e:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801720:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801723:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801728:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  80172e:	7f 6a                	jg     80179a <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801730:	89 d8                	mov    %ebx,%eax
  801732:	c1 e8 16             	shr    $0x16,%eax
  801735:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80173c:	a8 01                	test   $0x1,%al
  80173e:	74 10                	je     801750 <read_map+0x79>
  801740:	89 d8                	mov    %ebx,%eax
  801742:	c1 e8 0c             	shr    $0xc,%eax
  801745:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80174c:	a8 01                	test   $0x1,%al
  80174e:	75 19                	jne    801769 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	8d 46 01             	lea    0x1(%esi),%eax
  801756:	50                   	push   %eax
  801757:	56                   	push   %esi
  801758:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  80175b:	e8 fb 01 00 00       	call   80195b <fmap>
  801760:	83 c4 10             	add    $0x10,%esp
            return r;
  801763:	89 c2                	mov    %eax,%edx
  801765:	85 c0                	test   %eax,%eax
  801767:	78 31                	js     80179a <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801769:	89 d8                	mov    %ebx,%eax
  80176b:	c1 e8 16             	shr    $0x16,%eax
  80176e:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801775:	a8 01                	test   $0x1,%al
  801777:	74 10                	je     801789 <read_map+0xb2>
  801779:	89 d8                	mov    %ebx,%eax
  80177b:	c1 e8 0c             	shr    $0xc,%eax
  80177e:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801785:	a8 01                	test   $0x1,%al
  801787:	75 07                	jne    801790 <read_map+0xb9>
		return -E_NO_DISK;
  801789:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  80178e:	eb 0a                	jmp    80179a <read_map+0xc3>

	*blk = (void*) va;
  801790:	8b 45 10             	mov    0x10(%ebp),%eax
  801793:	89 18                	mov    %ebx,(%eax)
	return 0;
  801795:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80179a:	89 d0                	mov    %edx,%eax
  80179c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	57                   	push   %edi
  8017a7:	56                   	push   %esi
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 0c             	sub    $0xc,%esp
  8017ac:	8b 75 08             	mov    0x8(%ebp),%esi
  8017af:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  8017b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b5:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  8017b8:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  8017bd:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8017c3:	0f 87 bd 00 00 00    	ja     801886 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  8017c9:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  8017cf:	73 17                	jae    8017e8 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  8017d1:	83 ec 08             	sub    $0x8,%esp
  8017d4:	52                   	push   %edx
  8017d5:	56                   	push   %esi
  8017d6:	e8 fb 00 00 00       	call   8018d6 <file_trunc>
  8017db:	83 c4 10             	add    $0x10,%esp
			return r;
  8017de:	89 c1                	mov    %eax,%ecx
  8017e0:	85 c0                	test   %eax,%eax
  8017e2:	0f 88 9e 00 00 00    	js     801886 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8017e8:	83 ec 0c             	sub    $0xc,%esp
  8017eb:	56                   	push   %esi
  8017ec:	e8 db f7 ff ff       	call   800fcc <fd2data>
  8017f1:	89 c3                	mov    %eax,%ebx
  8017f3:	01 fb                	add    %edi,%ebx
  8017f5:	83 c4 10             	add    $0x10,%esp
  8017f8:	eb 42                	jmp    80183c <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8017fa:	89 d8                	mov    %ebx,%eax
  8017fc:	c1 e8 16             	shr    $0x16,%eax
  8017ff:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801806:	a8 01                	test   $0x1,%al
  801808:	74 10                	je     80181a <file_write+0x77>
  80180a:	89 d8                	mov    %ebx,%eax
  80180c:	c1 e8 0c             	shr    $0xc,%eax
  80180f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801816:	a8 01                	test   $0x1,%al
  801818:	75 1c                	jne    801836 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  80181a:	83 ec 04             	sub    $0x4,%esp
  80181d:	8b 55 10             	mov    0x10(%ebp),%edx
  801820:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801823:	50                   	push   %eax
  801824:	57                   	push   %edi
  801825:	56                   	push   %esi
  801826:	e8 30 01 00 00       	call   80195b <fmap>
  80182b:	83 c4 10             	add    $0x10,%esp
              return r;
  80182e:	89 c1                	mov    %eax,%ecx
  801830:	85 c0                	test   %eax,%eax
  801832:	78 52                	js     801886 <file_write+0xe3>
  801834:	eb 1b                	jmp    801851 <file_write+0xae>
  801836:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80183c:	83 ec 0c             	sub    $0xc,%esp
  80183f:	56                   	push   %esi
  801840:	e8 87 f7 ff ff       	call   800fcc <fd2data>
  801845:	01 f8                	add    %edi,%eax
  801847:	03 45 10             	add    0x10(%ebp),%eax
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	39 d8                	cmp    %ebx,%eax
  80184f:	77 a9                	ja     8017fa <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801851:	83 ec 0c             	sub    $0xc,%esp
  801854:	68 d6 2a 80 00       	push   $0x802ad6
  801859:	e8 3e ea ff ff       	call   80029c <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  80185e:	83 c4 0c             	add    $0xc,%esp
  801861:	ff 75 10             	pushl  0x10(%ebp)
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	56                   	push   %esi
  801868:	e8 5f f7 ff ff       	call   800fcc <fd2data>
  80186d:	01 f8                	add    %edi,%eax
  80186f:	89 04 24             	mov    %eax,(%esp)
  801872:	e8 a5 f1 ff ff       	call   800a1c <memmove>
        cprintf("write done\n");
  801877:	c7 04 24 e3 2a 80 00 	movl   $0x802ae3,(%esp)
  80187e:	e8 19 ea ff ff       	call   80029c <cprintf>
	return n;
  801883:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801886:	89 c8                	mov    %ecx,%eax
  801888:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5f                   	pop    %edi
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	56                   	push   %esi
  801894:	53                   	push   %ebx
  801895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801898:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	8d 43 10             	lea    0x10(%ebx),%eax
  8018a1:	50                   	push   %eax
  8018a2:	56                   	push   %esi
  8018a3:	e8 f8 ef ff ff       	call   8008a0 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  8018a8:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  8018ae:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  8018be:	0f 94 c0             	sete   %al
  8018c1:	0f b6 c0             	movzbl %al,%eax
  8018c4:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  8018ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8018cf:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8018d2:	5b                   	pop    %ebx
  8018d3:	5e                   	pop    %esi
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	57                   	push   %edi
  8018da:	56                   	push   %esi
  8018db:	53                   	push   %ebx
  8018dc:	83 ec 0c             	sub    $0xc,%esp
  8018df:	8b 75 08             	mov    0x8(%ebp),%esi
  8018e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  8018e5:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8018ea:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  8018f0:	7f 5f                	jg     801951 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  8018f2:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  8018f8:	83 ec 08             	sub    $0x8,%esp
  8018fb:	53                   	push   %ebx
  8018fc:	ff 76 0c             	pushl  0xc(%esi)
  8018ff:	e8 56 03 00 00       	call   801c5a <fsipc_set_size>
  801904:	83 c4 10             	add    $0x10,%esp
		return r;
  801907:	89 c2                	mov    %eax,%edx
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 44                	js     801951 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  80190d:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801913:	74 19                	je     80192e <file_trunc+0x58>
  801915:	68 10 2b 80 00       	push   $0x802b10
  80191a:	68 ef 2a 80 00       	push   $0x802aef
  80191f:	68 dc 00 00 00       	push   $0xdc
  801924:	68 04 2b 80 00       	push   $0x802b04
  801929:	e8 7e e8 ff ff       	call   8001ac <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  80192e:	83 ec 04             	sub    $0x4,%esp
  801931:	53                   	push   %ebx
  801932:	57                   	push   %edi
  801933:	56                   	push   %esi
  801934:	e8 22 00 00 00       	call   80195b <fmap>
  801939:	83 c4 10             	add    $0x10,%esp
		return r;
  80193c:	89 c2                	mov    %eax,%edx
  80193e:	85 c0                	test   %eax,%eax
  801940:	78 0f                	js     801951 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801942:	6a 00                	push   $0x0
  801944:	53                   	push   %ebx
  801945:	57                   	push   %edi
  801946:	56                   	push   %esi
  801947:	e8 85 00 00 00       	call   8019d1 <funmap>

	return 0;
  80194c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801951:	89 d0                	mov    %edx,%eax
  801953:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5f                   	pop    %edi
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <fmap>:

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
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	57                   	push   %edi
  80195f:	56                   	push   %esi
  801960:	53                   	push   %ebx
  801961:	83 ec 0c             	sub    $0xc,%esp
  801964:	8b 7d 08             	mov    0x8(%ebp),%edi
  801967:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  80196a:	39 75 0c             	cmp    %esi,0xc(%ebp)
  80196d:	7d 55                	jge    8019c4 <fmap+0x69>
          fma = fd2data(fd);
  80196f:	83 ec 0c             	sub    $0xc,%esp
  801972:	57                   	push   %edi
  801973:	e8 54 f6 ff ff       	call   800fcc <fd2data>
  801978:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  80197b:	83 c4 10             	add    $0x10,%esp
  80197e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801981:	05 ff 0f 00 00       	add    $0xfff,%eax
  801986:	89 c3                	mov    %eax,%ebx
  801988:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80198e:	39 f3                	cmp    %esi,%ebx
  801990:	7d 32                	jge    8019c4 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801998:	01 d8                	add    %ebx,%eax
  80199a:	50                   	push   %eax
  80199b:	53                   	push   %ebx
  80199c:	ff 77 0c             	pushl  0xc(%edi)
  80199f:	e8 8b 02 00 00       	call   801c2f <fsipc_map>
  8019a4:	83 c4 10             	add    $0x10,%esp
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	79 0f                	jns    8019ba <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	53                   	push   %ebx
  8019b1:	57                   	push   %edi
  8019b2:	e8 1a 00 00 00       	call   8019d1 <funmap>
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8019c0:	39 f3                	cmp    %esi,%ebx
  8019c2:	7c ce                	jl     801992 <fmap+0x37>
            }
          }
        }

        return 0;
}
  8019c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8019cc:	5b                   	pop    %ebx
  8019cd:	5e                   	pop    %esi
  8019ce:	5f                   	pop    %edi
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <funmap>:

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
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	57                   	push   %edi
  8019d5:	56                   	push   %esi
  8019d6:	53                   	push   %ebx
  8019d7:	83 ec 0c             	sub    $0xc,%esp
  8019da:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  8019e0:	39 f3                	cmp    %esi,%ebx
  8019e2:	0f 8d 80 00 00 00    	jge    801a68 <funmap+0x97>
          fma = fd2data(fd);
  8019e8:	83 ec 0c             	sub    $0xc,%esp
  8019eb:	ff 75 08             	pushl  0x8(%ebp)
  8019ee:	e8 d9 f5 ff ff       	call   800fcc <fd2data>
  8019f3:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  8019f5:	83 c4 10             	add    $0x10,%esp
  8019f8:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8019fe:	89 c3                	mov    %eax,%ebx
  801a00:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801a06:	39 f3                	cmp    %esi,%ebx
  801a08:	7d 5e                	jge    801a68 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801a0a:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801a0d:	89 c2                	mov    %eax,%edx
  801a0f:	c1 ea 0c             	shr    $0xc,%edx
  801a12:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801a19:	a8 01                	test   $0x1,%al
  801a1b:	74 41                	je     801a5e <funmap+0x8d>
              if (dirty) {
  801a1d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801a21:	74 21                	je     801a44 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801a23:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801a2a:	a8 40                	test   $0x40,%al
  801a2c:	74 16                	je     801a44 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801a2e:	83 ec 08             	sub    $0x8,%esp
  801a31:	53                   	push   %ebx
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	ff 70 0c             	pushl  0xc(%eax)
  801a38:	e8 65 02 00 00       	call   801ca2 <fsipc_dirty>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 29                	js     801a6d <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801a44:	83 ec 08             	sub    $0x8,%esp
  801a47:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801a4a:	50                   	push   %eax
  801a4b:	83 ec 04             	sub    $0x4,%esp
  801a4e:	e8 e1 f1 ff ff       	call   800c34 <sys_getenvid>
  801a53:	89 04 24             	mov    %eax,(%esp)
  801a56:	e8 9c f2 ff ff       	call   800cf7 <sys_page_unmap>
  801a5b:	83 c4 10             	add    $0x10,%esp
  801a5e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a64:	39 f3                	cmp    %esi,%ebx
  801a66:	7c a2                	jl     801a0a <funmap+0x39>
            }
          }
        }

        return 0;
  801a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801a70:	5b                   	pop    %ebx
  801a71:	5e                   	pop    %esi
  801a72:	5f                   	pop    %edi
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <remove>:

// Delete a file
int
remove(const char *path)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801a7b:	ff 75 08             	pushl  0x8(%ebp)
  801a7e:	e8 47 02 00 00       	call   801cca <fsipc_remove>
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801a8b:	e8 80 02 00 00       	call   801d10 <fsipc_sync>
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    
	...

00801a94 <writebuf>:


static void
writebuf(struct printbuf *b)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	53                   	push   %ebx
  801a98:	83 ec 04             	sub    $0x4,%esp
  801a9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (b->error > 0) {
  801a9e:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
  801aa2:	7e 2c                	jle    801ad0 <writebuf+0x3c>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801aa4:	83 ec 04             	sub    $0x4,%esp
  801aa7:	ff 73 04             	pushl  0x4(%ebx)
  801aaa:	8d 43 10             	lea    0x10(%ebx),%eax
  801aad:	50                   	push   %eax
  801aae:	ff 33                	pushl  (%ebx)
  801ab0:	e8 03 f9 ff ff       	call   8013b8 <write>
		if (result > 0)
  801ab5:	83 c4 10             	add    $0x10,%esp
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	7e 03                	jle    801abf <writebuf+0x2b>
			b->result += result;
  801abc:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801abf:	39 43 04             	cmp    %eax,0x4(%ebx)
  801ac2:	74 0c                	je     801ad0 <writebuf+0x3c>
			b->error = (result < 0 ? result : 0);
  801ac4:	85 c0                	test   %eax,%eax
  801ac6:	7e 05                	jle    801acd <writebuf+0x39>
  801ac8:	b8 00 00 00 00       	mov    $0x0,%eax
  801acd:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801ad0:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <putch>:

static void
putch(int ch, void *thunk)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	53                   	push   %ebx
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801adf:	8b 43 04             	mov    0x4(%ebx),%eax
  801ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ae5:	88 54 18 10          	mov    %dl,0x10(%eax,%ebx,1)
  801ae9:	40                   	inc    %eax
  801aea:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801aed:	3d 00 01 00 00       	cmp    $0x100,%eax
  801af2:	75 13                	jne    801b07 <putch+0x32>
		writebuf(b);
  801af4:	83 ec 0c             	sub    $0xc,%esp
  801af7:	53                   	push   %ebx
  801af8:	e8 97 ff ff ff       	call   801a94 <writebuf>
		b->idx = 0;
  801afd:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  801b04:	83 c4 10             	add    $0x10,%esp
	}
}
  801b07:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	53                   	push   %ebx
  801b10:	81 ec 14 01 00 00    	sub    $0x114,%esp
	struct printbuf b;

	b.fd = fd;
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	89 85 e8 fe ff ff    	mov    %eax,0xfffffee8(%ebp)
	b.idx = 0;
  801b1f:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  801b26:	00 00 00 
	b.result = 0;
  801b29:	c7 85 f0 fe ff ff 00 	movl   $0x0,0xfffffef0(%ebp)
  801b30:	00 00 00 
	b.error = 1;
  801b33:	c7 85 f4 fe ff ff 01 	movl   $0x1,0xfffffef4(%ebp)
  801b3a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801b3d:	ff 75 10             	pushl  0x10(%ebp)
  801b40:	ff 75 0c             	pushl  0xc(%ebp)
  801b43:	8d 9d e8 fe ff ff    	lea    0xfffffee8(%ebp),%ebx
  801b49:	53                   	push   %ebx
  801b4a:	68 d5 1a 80 00       	push   $0x801ad5
  801b4f:	e8 7a e8 ff ff       	call   8003ce <vprintfmt>
	if (b.idx > 0)
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	83 bd ec fe ff ff 00 	cmpl   $0x0,0xfffffeec(%ebp)
  801b5e:	7e 0c                	jle    801b6c <vfprintf+0x60>
		writebuf(&b);
  801b60:	83 ec 0c             	sub    $0xc,%esp
  801b63:	53                   	push   %ebx
  801b64:	e8 2b ff ff ff       	call   801a94 <writebuf>
  801b69:	83 c4 10             	add    $0x10,%esp

	return (b.result ? b.result : b.error);
  801b6c:	8b 85 f0 fe ff ff    	mov    0xfffffef0(%ebp),%eax
  801b72:	85 c0                	test   %eax,%eax
  801b74:	75 06                	jne    801b7c <vfprintf+0x70>
  801b76:	8b 85 f4 fe ff ff    	mov    0xfffffef4(%ebp),%eax
}
  801b7c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b87:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801b8a:	50                   	push   %eax
  801b8b:	ff 75 0c             	pushl  0xc(%ebp)
  801b8e:	ff 75 08             	pushl  0x8(%ebp)
  801b91:	e8 76 ff ff ff       	call   801b0c <vfprintf>
	va_end(ap);

	return cnt;
}
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <printf>:

int
printf(const char *fmt, ...)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b9e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801ba1:	50                   	push   %eax
  801ba2:	ff 75 08             	pushl  0x8(%ebp)
  801ba5:	6a 01                	push   $0x1
  801ba7:	e8 60 ff ff ff       	call   801b0c <vfprintf>
	va_end(ap);

	return cnt;
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    
	...

00801bb0 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801bb6:	6a 07                	push   $0x7
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801bc3:	50                   	push   %eax
  801bc4:	e8 c6 06 00 00       	call   80228f <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801bc9:	83 c4 0c             	add    $0xc,%esp
  801bcc:	ff 75 14             	pushl  0x14(%ebp)
  801bcf:	ff 75 10             	pushl  0x10(%ebp)
  801bd2:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801bd5:	50                   	push   %eax
  801bd6:	e8 51 06 00 00       	call   80222c <ipc_recv>
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	56                   	push   %esi
  801be1:	53                   	push   %ebx
  801be2:	83 ec 1c             	sub    $0x1c,%esp
  801be5:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801be8:	bb 00 30 80 00       	mov    $0x803000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801bed:	56                   	push   %esi
  801bee:	e8 71 ec ff ff       	call   800864 <strlen>
  801bf3:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801bf6:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801bfb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c00:	7f 24                	jg     801c26 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801c02:	83 ec 08             	sub    $0x8,%esp
  801c05:	56                   	push   %esi
  801c06:	53                   	push   %ebx
  801c07:	e8 94 ec ff ff       	call   8008a0 <strcpy>
	req->req_omode = omode;
  801c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0f:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801c15:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801c18:	50                   	push   %eax
  801c19:	ff 75 10             	pushl  0x10(%ebp)
  801c1c:	53                   	push   %ebx
  801c1d:	6a 01                	push   $0x1
  801c1f:	e8 8c ff ff ff       	call   801bb0 <fsipc>
  801c24:	89 c2                	mov    %eax,%edx
}
  801c26:	89 d0                	mov    %edx,%eax
  801c28:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5e                   	pop    %esi
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c40:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801c45:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801c48:	50                   	push   %eax
  801c49:	ff 75 10             	pushl  0x10(%ebp)
  801c4c:	68 00 30 80 00       	push   $0x803000
  801c51:	6a 02                	push   $0x2
  801c53:	e8 58 ff ff ff       	call   801bb0 <fsipc>

	//return -E_UNSPECIFIED;
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	a3 00 30 80 00       	mov    %eax,0x803000
	req->req_size = size;
  801c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6b:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	68 00 30 80 00       	push   $0x803000
  801c79:	6a 03                	push   $0x3
  801c7b:	e8 30 ff ff ff       	call   801bb0 <fsipc>
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801c88:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	68 00 30 80 00       	push   $0x803000
  801c99:	6a 04                	push   $0x4
  801c9b:	e8 10 ff ff ff       	call   801bb0 <fsipc>
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cab:	a3 00 30 80 00       	mov    %eax,0x803000
        req->req_offset = offset;
  801cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb3:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	68 00 30 80 00       	push   $0x803000
  801cc1:	6a 05                	push   $0x5
  801cc3:	e8 e8 fe ff ff       	call   801bb0 <fsipc>
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801cd2:	be 00 30 80 00       	mov    $0x803000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	53                   	push   %ebx
  801cdb:	e8 84 eb ff ff       	call   800864 <strlen>
  801ce0:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801ce3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801ce8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ced:	7f 18                	jg     801d07 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801cef:	83 ec 08             	sub    $0x8,%esp
  801cf2:	53                   	push   %ebx
  801cf3:	56                   	push   %esi
  801cf4:	e8 a7 eb ff ff       	call   8008a0 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	56                   	push   %esi
  801cfe:	6a 06                	push   $0x6
  801d00:	e8 ab fe ff ff       	call   801bb0 <fsipc>
  801d05:	89 c2                	mov    %eax,%edx
}
  801d07:	89 d0                	mov    %edx,%eax
  801d09:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801d0c:	5b                   	pop    %ebx
  801d0d:	5e                   	pop    %esi
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	68 00 30 80 00       	push   $0x803000
  801d1f:	6a 07                	push   $0x7
  801d21:	e8 8a fe ff ff       	call   801bb0 <fsipc>
}
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <pipe>:
};

int
pipe(int pfd[2])
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	57                   	push   %edi
  801d2c:	56                   	push   %esi
  801d2d:	53                   	push   %ebx
  801d2e:	83 ec 18             	sub    $0x18,%esp
  801d31:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801d34:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  801d37:	50                   	push   %eax
  801d38:	e8 b7 f2 ff ff       	call   800ff4 <fd_alloc>
  801d3d:	89 c3                	mov    %eax,%ebx
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	85 c0                	test   %eax,%eax
  801d44:	0f 88 25 01 00 00    	js     801e6f <pipe+0x147>
  801d4a:	83 ec 04             	sub    $0x4,%esp
  801d4d:	68 07 04 00 00       	push   $0x407
  801d52:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801d55:	6a 00                	push   $0x0
  801d57:	e8 16 ef ff ff       	call   800c72 <sys_page_alloc>
  801d5c:	89 c3                	mov    %eax,%ebx
  801d5e:	83 c4 10             	add    $0x10,%esp
  801d61:	85 c0                	test   %eax,%eax
  801d63:	0f 88 06 01 00 00    	js     801e6f <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801d69:	83 ec 0c             	sub    $0xc,%esp
  801d6c:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  801d6f:	50                   	push   %eax
  801d70:	e8 7f f2 ff ff       	call   800ff4 <fd_alloc>
  801d75:	89 c3                	mov    %eax,%ebx
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	0f 88 dd 00 00 00    	js     801e5f <pipe+0x137>
  801d82:	83 ec 04             	sub    $0x4,%esp
  801d85:	68 07 04 00 00       	push   $0x407
  801d8a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801d8d:	6a 00                	push   $0x0
  801d8f:	e8 de ee ff ff       	call   800c72 <sys_page_alloc>
  801d94:	89 c3                	mov    %eax,%ebx
  801d96:	83 c4 10             	add    $0x10,%esp
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	0f 88 be 00 00 00    	js     801e5f <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801da1:	83 ec 0c             	sub    $0xc,%esp
  801da4:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801da7:	e8 20 f2 ff ff       	call   800fcc <fd2data>
  801dac:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dae:	83 c4 0c             	add    $0xc,%esp
  801db1:	68 07 04 00 00       	push   $0x407
  801db6:	50                   	push   %eax
  801db7:	6a 00                	push   $0x0
  801db9:	e8 b4 ee ff ff       	call   800c72 <sys_page_alloc>
  801dbe:	89 c3                	mov    %eax,%ebx
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	0f 88 84 00 00 00    	js     801e4f <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801dcb:	83 ec 0c             	sub    $0xc,%esp
  801dce:	68 07 04 00 00       	push   $0x407
  801dd3:	83 ec 0c             	sub    $0xc,%esp
  801dd6:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801dd9:	e8 ee f1 ff ff       	call   800fcc <fd2data>
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	50                   	push   %eax
  801de2:	6a 00                	push   $0x0
  801de4:	56                   	push   %esi
  801de5:	6a 00                	push   $0x0
  801de7:	e8 c9 ee ff ff       	call   800cb5 <sys_page_map>
  801dec:	89 c3                	mov    %eax,%ebx
  801dee:	83 c4 20             	add    $0x20,%esp
  801df1:	85 c0                	test   %eax,%eax
  801df3:	78 4c                	js     801e41 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801df5:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801dfb:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801dfe:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801e00:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801e03:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801e0a:	8b 15 40 60 80 00    	mov    0x806040,%edx
  801e10:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801e13:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801e15:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801e18:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  801e1f:	83 ec 0c             	sub    $0xc,%esp
  801e22:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801e25:	e8 ba f1 ff ff       	call   800fe4 <fd2num>
  801e2a:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801e2c:	83 c4 04             	add    $0x4,%esp
  801e2f:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801e32:	e8 ad f1 ff ff       	call   800fe4 <fd2num>
  801e37:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3f:	eb 30                	jmp    801e71 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  801e41:	83 ec 08             	sub    $0x8,%esp
  801e44:	56                   	push   %esi
  801e45:	6a 00                	push   $0x0
  801e47:	e8 ab ee ff ff       	call   800cf7 <sys_page_unmap>
  801e4c:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  801e4f:	83 ec 08             	sub    $0x8,%esp
  801e52:	ff 75 ec             	pushl  0xffffffec(%ebp)
  801e55:	6a 00                	push   $0x0
  801e57:	e8 9b ee ff ff       	call   800cf7 <sys_page_unmap>
  801e5c:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  801e5f:	83 ec 08             	sub    $0x8,%esp
  801e62:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801e65:	6a 00                	push   $0x0
  801e67:	e8 8b ee ff ff       	call   800cf7 <sys_page_unmap>
  801e6c:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  801e6f:	89 d8                	mov    %ebx,%eax
}
  801e71:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801e74:	5b                   	pop    %ebx
  801e75:	5e                   	pop    %esi
  801e76:	5f                   	pop    %edi
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	57                   	push   %edi
  801e7d:	56                   	push   %esi
  801e7e:	53                   	push   %ebx
  801e7f:	83 ec 0c             	sub    $0xc,%esp
  801e82:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801e85:	a1 80 60 80 00       	mov    0x806080,%eax
  801e8a:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  801e8d:	83 ec 0c             	sub    $0xc,%esp
  801e90:	ff 75 08             	pushl  0x8(%ebp)
  801e93:	e8 50 04 00 00       	call   8022e8 <pageref>
  801e98:	89 c3                	mov    %eax,%ebx
  801e9a:	89 3c 24             	mov    %edi,(%esp)
  801e9d:	e8 46 04 00 00       	call   8022e8 <pageref>
  801ea2:	83 c4 10             	add    $0x10,%esp
  801ea5:	39 c3                	cmp    %eax,%ebx
  801ea7:	0f 94 c0             	sete   %al
  801eaa:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  801ead:	8b 0d 80 60 80 00    	mov    0x806080,%ecx
  801eb3:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  801eb6:	39 c6                	cmp    %eax,%esi
  801eb8:	74 1b                	je     801ed5 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  801eba:	83 fa 01             	cmp    $0x1,%edx
  801ebd:	75 c6                	jne    801e85 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801ebf:	6a 01                	push   $0x1
  801ec1:	8b 41 58             	mov    0x58(%ecx),%eax
  801ec4:	50                   	push   %eax
  801ec5:	56                   	push   %esi
  801ec6:	68 38 2b 80 00       	push   $0x802b38
  801ecb:	e8 cc e3 ff ff       	call   80029c <cprintf>
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	eb b0                	jmp    801e85 <_pipeisclosed+0xc>
	}
}
  801ed5:	89 d0                	mov    %edx,%eax
  801ed7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801eda:	5b                   	pop    %ebx
  801edb:	5e                   	pop    %esi
  801edc:	5f                   	pop    %edi
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ee5:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801ee8:	50                   	push   %eax
  801ee9:	ff 75 08             	pushl  0x8(%ebp)
  801eec:	e8 5d f1 ff ff       	call   80104e <fd_lookup>
  801ef1:	83 c4 10             	add    $0x10,%esp
		return r;
  801ef4:	89 c2                	mov    %eax,%edx
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	78 19                	js     801f13 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801f00:	e8 c7 f0 ff ff       	call   800fcc <fd2data>
	return _pipeisclosed(fd, p);
  801f05:	83 c4 08             	add    $0x8,%esp
  801f08:	50                   	push   %eax
  801f09:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801f0c:	e8 68 ff ff ff       	call   801e79 <_pipeisclosed>
  801f11:	89 c2                	mov    %eax,%edx
}
  801f13:	89 d0                	mov    %edx,%eax
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	57                   	push   %edi
  801f1b:	56                   	push   %esi
  801f1c:	53                   	push   %ebx
  801f1d:	83 ec 18             	sub    $0x18,%esp
  801f20:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  801f23:	57                   	push   %edi
  801f24:	e8 a3 f0 ff ff       	call   800fcc <fd2data>
  801f29:	89 c3                	mov    %eax,%ebx
	if (debug)
  801f2b:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f31:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801f34:	be 00 00 00 00       	mov    $0x0,%esi
  801f39:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f3c:	73 55                	jae    801f93 <piperead+0x7c>
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
  801f3e:	8b 03                	mov    (%ebx),%eax
  801f40:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f43:	75 2c                	jne    801f71 <piperead+0x5a>
  801f45:	85 f6                	test   %esi,%esi
  801f47:	74 04                	je     801f4d <piperead+0x36>
  801f49:	89 f0                	mov    %esi,%eax
  801f4b:	eb 48                	jmp    801f95 <piperead+0x7e>
  801f4d:	83 ec 08             	sub    $0x8,%esp
  801f50:	53                   	push   %ebx
  801f51:	57                   	push   %edi
  801f52:	e8 22 ff ff ff       	call   801e79 <_pipeisclosed>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	85 c0                	test   %eax,%eax
  801f5c:	74 07                	je     801f65 <piperead+0x4e>
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f63:	eb 30                	jmp    801f95 <piperead+0x7e>
  801f65:	e8 e9 ec ff ff       	call   800c53 <sys_yield>
  801f6a:	8b 03                	mov    (%ebx),%eax
  801f6c:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f6f:	74 d4                	je     801f45 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f71:	8b 13                	mov    (%ebx),%edx
  801f73:	89 d0                	mov    %edx,%eax
  801f75:	85 d2                	test   %edx,%edx
  801f77:	79 03                	jns    801f7c <piperead+0x65>
  801f79:	8d 42 1f             	lea    0x1f(%edx),%eax
  801f7c:	83 e0 e0             	and    $0xffffffe0,%eax
  801f7f:	29 c2                	sub    %eax,%edx
  801f81:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  801f85:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801f88:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801f8b:	ff 03                	incl   (%ebx)
  801f8d:	46                   	inc    %esi
  801f8e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f91:	72 ab                	jb     801f3e <piperead+0x27>
	}
	return i;
  801f93:	89 f0                	mov    %esi,%eax
}
  801f95:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801f98:	5b                   	pop    %ebx
  801f99:	5e                   	pop    %esi
  801f9a:	5f                   	pop    %edi
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	57                   	push   %edi
  801fa1:	56                   	push   %esi
  801fa2:	53                   	push   %ebx
  801fa3:	83 ec 18             	sub    $0x18,%esp
  801fa6:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  801fa9:	57                   	push   %edi
  801faa:	e8 1d f0 ff ff       	call   800fcc <fd2data>
  801faf:	89 c3                	mov    %eax,%ebx
	if (debug)
  801fb1:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  801fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb7:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  801fba:	be 00 00 00 00       	mov    $0x0,%esi
  801fbf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc2:	73 55                	jae    802019 <pipewrite+0x7c>
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
  801fc4:	8b 03                	mov    (%ebx),%eax
  801fc6:	83 c0 20             	add    $0x20,%eax
  801fc9:	39 43 04             	cmp    %eax,0x4(%ebx)
  801fcc:	72 27                	jb     801ff5 <pipewrite+0x58>
  801fce:	83 ec 08             	sub    $0x8,%esp
  801fd1:	53                   	push   %ebx
  801fd2:	57                   	push   %edi
  801fd3:	e8 a1 fe ff ff       	call   801e79 <_pipeisclosed>
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	85 c0                	test   %eax,%eax
  801fdd:	74 07                	je     801fe6 <pipewrite+0x49>
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	eb 35                	jmp    80201b <pipewrite+0x7e>
  801fe6:	e8 68 ec ff ff       	call   800c53 <sys_yield>
  801feb:	8b 03                	mov    (%ebx),%eax
  801fed:	83 c0 20             	add    $0x20,%eax
  801ff0:	39 43 04             	cmp    %eax,0x4(%ebx)
  801ff3:	73 d9                	jae    801fce <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ff5:	8b 53 04             	mov    0x4(%ebx),%edx
  801ff8:	89 d0                	mov    %edx,%eax
  801ffa:	85 d2                	test   %edx,%edx
  801ffc:	79 03                	jns    802001 <pipewrite+0x64>
  801ffe:	8d 42 1f             	lea    0x1f(%edx),%eax
  802001:	83 e0 e0             	and    $0xffffffe0,%eax
  802004:	29 c2                	sub    %eax,%edx
  802006:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  802009:	8a 04 31             	mov    (%ecx,%esi,1),%al
  80200c:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802010:	ff 43 04             	incl   0x4(%ebx)
  802013:	46                   	inc    %esi
  802014:	3b 75 10             	cmp    0x10(%ebp),%esi
  802017:	72 ab                	jb     801fc4 <pipewrite+0x27>
	}
	
	return i;
  802019:	89 f0                	mov    %esi,%eax
}
  80201b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80201e:	5b                   	pop    %ebx
  80201f:	5e                   	pop    %esi
  802020:	5f                   	pop    %edi
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	56                   	push   %esi
  802027:	53                   	push   %ebx
  802028:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80202b:	83 ec 0c             	sub    $0xc,%esp
  80202e:	ff 75 08             	pushl  0x8(%ebp)
  802031:	e8 96 ef ff ff       	call   800fcc <fd2data>
  802036:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802038:	83 c4 08             	add    $0x8,%esp
  80203b:	68 4b 2b 80 00       	push   $0x802b4b
  802040:	53                   	push   %ebx
  802041:	e8 5a e8 ff ff       	call   8008a0 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802046:	8b 46 04             	mov    0x4(%esi),%eax
  802049:	2b 06                	sub    (%esi),%eax
  80204b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802051:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802058:	00 00 00 
	stat->st_dev = &devpipe;
  80205b:	c7 83 88 00 00 00 40 	movl   $0x806040,0x88(%ebx)
  802062:	60 80 00 
	return 0;
}
  802065:	b8 00 00 00 00       	mov    $0x0,%eax
  80206a:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	53                   	push   %ebx
  802075:	83 ec 0c             	sub    $0xc,%esp
  802078:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80207b:	53                   	push   %ebx
  80207c:	6a 00                	push   $0x0
  80207e:	e8 74 ec ff ff       	call   800cf7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802083:	89 1c 24             	mov    %ebx,(%esp)
  802086:	e8 41 ef ff ff       	call   800fcc <fd2data>
  80208b:	83 c4 08             	add    $0x8,%esp
  80208e:	50                   	push   %eax
  80208f:	6a 00                	push   $0x0
  802091:	e8 61 ec ff ff       	call   800cf7 <sys_page_unmap>
}
  802096:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802099:	c9                   	leave  
  80209a:	c3                   	ret    
	...

0080209c <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8020a8:	6a 01                	push   $0x1
  8020aa:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8020ad:	50                   	push   %eax
  8020ae:	e8 fd ea ff ff       	call   800bb0 <sys_cputs>
}
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <getchar>:

int
getchar(void)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8020bb:	6a 01                	push   $0x1
  8020bd:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8020c0:	50                   	push   %eax
  8020c1:	6a 00                	push   $0x0
  8020c3:	e8 19 f2 ff ff       	call   8012e1 <read>
	if (r < 0)
  8020c8:	83 c4 10             	add    $0x10,%esp
		return r;
  8020cb:	89 c2                	mov    %eax,%edx
  8020cd:	85 c0                	test   %eax,%eax
  8020cf:	78 0d                	js     8020de <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  8020d1:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  8020d6:	85 c0                	test   %eax,%eax
  8020d8:	7e 04                	jle    8020de <getchar+0x29>
	return c;
  8020da:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  8020de:	89 d0                	mov    %edx,%eax
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <iscons>:


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
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020e8:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8020eb:	50                   	push   %eax
  8020ec:	ff 75 08             	pushl  0x8(%ebp)
  8020ef:	e8 5a ef ff ff       	call   80104e <fd_lookup>
  8020f4:	83 c4 10             	add    $0x10,%esp
		return r;
  8020f7:	89 c2                	mov    %eax,%edx
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	78 11                	js     80210e <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  8020fd:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802100:	8b 00                	mov    (%eax),%eax
  802102:	3b 05 60 60 80 00    	cmp    0x806060,%eax
  802108:	0f 94 c0             	sete   %al
  80210b:	0f b6 d0             	movzbl %al,%edx
}
  80210e:	89 d0                	mov    %edx,%eax
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <opencons>:

int
opencons(void)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
  802115:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802118:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80211b:	50                   	push   %eax
  80211c:	e8 d3 ee ff ff       	call   800ff4 <fd_alloc>
  802121:	83 c4 10             	add    $0x10,%esp
		return r;
  802124:	89 c2                	mov    %eax,%edx
  802126:	85 c0                	test   %eax,%eax
  802128:	78 3c                	js     802166 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80212a:	83 ec 04             	sub    $0x4,%esp
  80212d:	68 07 04 00 00       	push   $0x407
  802132:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802135:	6a 00                	push   $0x0
  802137:	e8 36 eb ff ff       	call   800c72 <sys_page_alloc>
  80213c:	83 c4 10             	add    $0x10,%esp
		return r;
  80213f:	89 c2                	mov    %eax,%edx
  802141:	85 c0                	test   %eax,%eax
  802143:	78 21                	js     802166 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802145:	a1 60 60 80 00       	mov    0x806060,%eax
  80214a:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  80214d:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  80214f:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802152:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802159:	83 ec 0c             	sub    $0xc,%esp
  80215c:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80215f:	e8 80 ee ff ff       	call   800fe4 <fd2num>
  802164:	89 c2                	mov    %eax,%edx
}
  802166:	89 d0                	mov    %edx,%eax
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  802170:	b8 00 00 00 00       	mov    $0x0,%eax
  802175:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802179:	74 2a                	je     8021a5 <cons_read+0x3b>
  80217b:	eb 05                	jmp    802182 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80217d:	e8 d1 ea ff ff       	call   800c53 <sys_yield>
  802182:	e8 4d ea ff ff       	call   800bd4 <sys_cgetc>
  802187:	89 c2                	mov    %eax,%edx
  802189:	85 c0                	test   %eax,%eax
  80218b:	74 f0                	je     80217d <cons_read+0x13>
	if (c < 0)
  80218d:	85 d2                	test   %edx,%edx
  80218f:	78 14                	js     8021a5 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802191:	b8 00 00 00 00       	mov    $0x0,%eax
  802196:	83 fa 04             	cmp    $0x4,%edx
  802199:	74 0a                	je     8021a5 <cons_read+0x3b>
	*(char*)vbuf = c;
  80219b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219e:	88 10                	mov    %dl,(%eax)
	return 1;
  8021a0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	57                   	push   %edi
  8021ab:	56                   	push   %esi
  8021ac:	53                   	push   %ebx
  8021ad:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  8021b3:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021b6:	be 00 00 00 00       	mov    $0x0,%esi
  8021bb:	39 fe                	cmp    %edi,%esi
  8021bd:	73 3d                	jae    8021fc <cons_write+0x55>
		m = n - tot;
  8021bf:	89 fb                	mov    %edi,%ebx
  8021c1:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8021c3:	83 fb 7f             	cmp    $0x7f,%ebx
  8021c6:	76 05                	jbe    8021cd <cons_write+0x26>
			m = sizeof(buf) - 1;
  8021c8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8021cd:	83 ec 04             	sub    $0x4,%esp
  8021d0:	53                   	push   %ebx
  8021d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d4:	01 f0                	add    %esi,%eax
  8021d6:	50                   	push   %eax
  8021d7:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8021dd:	50                   	push   %eax
  8021de:	e8 39 e8 ff ff       	call   800a1c <memmove>
		sys_cputs(buf, m);
  8021e3:	83 c4 08             	add    $0x8,%esp
  8021e6:	53                   	push   %ebx
  8021e7:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8021ed:	50                   	push   %eax
  8021ee:	e8 bd e9 ff ff       	call   800bb0 <sys_cputs>
  8021f3:	83 c4 10             	add    $0x10,%esp
  8021f6:	01 de                	add    %ebx,%esi
  8021f8:	39 fe                	cmp    %edi,%esi
  8021fa:	72 c3                	jb     8021bf <cons_write+0x18>
	}
	return tot;
}
  8021fc:	89 f0                	mov    %esi,%eax
  8021fe:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802201:	5b                   	pop    %ebx
  802202:	5e                   	pop    %esi
  802203:	5f                   	pop    %edi
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <cons_close>:

int
cons_close(struct Fd *fd)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
  802213:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802216:	68 57 2b 80 00       	push   $0x802b57
  80221b:	ff 75 0c             	pushl  0xc(%ebp)
  80221e:	e8 7d e6 ff ff       	call   8008a0 <strcpy>
	return 0;
}
  802223:	b8 00 00 00 00       	mov    $0x0,%eax
  802228:	c9                   	leave  
  802229:	c3                   	ret    
	...

0080222c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	56                   	push   %esi
  802230:	53                   	push   %ebx
  802231:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802234:	8b 45 0c             	mov    0xc(%ebp),%eax
  802237:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80223a:	85 c0                	test   %eax,%eax
  80223c:	75 12                	jne    802250 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  80223e:	83 ec 0c             	sub    $0xc,%esp
  802241:	68 00 00 c0 ee       	push   $0xeec00000
  802246:	e8 d7 eb ff ff       	call   800e22 <sys_ipc_recv>
  80224b:	83 c4 10             	add    $0x10,%esp
  80224e:	eb 0c                	jmp    80225c <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802250:	83 ec 0c             	sub    $0xc,%esp
  802253:	50                   	push   %eax
  802254:	e8 c9 eb ff ff       	call   800e22 <sys_ipc_recv>
  802259:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  80225c:	89 c2                	mov    %eax,%edx
  80225e:	85 c0                	test   %eax,%eax
  802260:	78 24                	js     802286 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  802262:	85 db                	test   %ebx,%ebx
  802264:	74 0a                	je     802270 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  802266:	a1 80 60 80 00       	mov    0x806080,%eax
  80226b:	8b 40 74             	mov    0x74(%eax),%eax
  80226e:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802270:	85 f6                	test   %esi,%esi
  802272:	74 0a                	je     80227e <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802274:	a1 80 60 80 00       	mov    0x806080,%eax
  802279:	8b 40 78             	mov    0x78(%eax),%eax
  80227c:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  80227e:	a1 80 60 80 00       	mov    0x806080,%eax
  802283:	8b 50 70             	mov    0x70(%eax),%edx

}
  802286:	89 d0                	mov    %edx,%eax
  802288:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80228b:	5b                   	pop    %ebx
  80228c:	5e                   	pop    %esi
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <ipc_send>:

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
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
  802292:	57                   	push   %edi
  802293:	56                   	push   %esi
  802294:	53                   	push   %ebx
  802295:	83 ec 0c             	sub    $0xc,%esp
  802298:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80229b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80229e:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  8022a1:	85 db                	test   %ebx,%ebx
  8022a3:	75 0a                	jne    8022af <ipc_send+0x20>
    pg = (void *) UTOP;
  8022a5:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  8022aa:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  8022af:	56                   	push   %esi
  8022b0:	53                   	push   %ebx
  8022b1:	57                   	push   %edi
  8022b2:	ff 75 08             	pushl  0x8(%ebp)
  8022b5:	e8 45 eb ff ff       	call   800dff <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  8022ba:	83 c4 10             	add    $0x10,%esp
  8022bd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022c0:	75 07                	jne    8022c9 <ipc_send+0x3a>
      sys_yield();
  8022c2:	e8 8c e9 ff ff       	call   800c53 <sys_yield>
  8022c7:	eb e6                	jmp    8022af <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	79 12                	jns    8022df <ipc_send+0x50>
  8022cd:	50                   	push   %eax
  8022ce:	68 5e 2b 80 00       	push   $0x802b5e
  8022d3:	6a 49                	push   $0x49
  8022d5:	68 7b 2b 80 00       	push   $0x802b7b
  8022da:	e8 cd de ff ff       	call   8001ac <_panic>
    else break;
  }
}
  8022df:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8022e2:	5b                   	pop    %ebx
  8022e3:	5e                   	pop    %esi
  8022e4:	5f                   	pop    %edi
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    
	...

008022e8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8022ee:	89 c8                	mov    %ecx,%eax
  8022f0:	c1 e8 16             	shr    $0x16,%eax
  8022f3:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8022fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ff:	a8 01                	test   $0x1,%al
  802301:	74 28                	je     80232b <pageref+0x43>
	pte = vpt[VPN(v)];
  802303:	89 c8                	mov    %ecx,%eax
  802305:	c1 e8 0c             	shr    $0xc,%eax
  802308:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  80230f:	ba 00 00 00 00       	mov    $0x0,%edx
  802314:	a8 01                	test   $0x1,%al
  802316:	74 13                	je     80232b <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  802318:	c1 e8 0c             	shr    $0xc,%eax
  80231b:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80231e:	c1 e0 02             	shl    $0x2,%eax
  802321:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802328:	0f b7 d0             	movzwl %ax,%edx
}
  80232b:	89 d0                	mov    %edx,%eax
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    
	...

00802330 <__udivdi3>:
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	57                   	push   %edi
  802334:	56                   	push   %esi
  802335:	83 ec 14             	sub    $0x14,%esp
  802338:	8b 55 14             	mov    0x14(%ebp),%edx
  80233b:	8b 75 08             	mov    0x8(%ebp),%esi
  80233e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802341:	8b 45 10             	mov    0x10(%ebp),%eax
  802344:	85 d2                	test   %edx,%edx
  802346:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802349:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80234c:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  80234f:	89 fe                	mov    %edi,%esi
  802351:	75 11                	jne    802364 <__udivdi3+0x34>
  802353:	39 f8                	cmp    %edi,%eax
  802355:	76 4d                	jbe    8023a4 <__udivdi3+0x74>
  802357:	89 fa                	mov    %edi,%edx
  802359:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80235c:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80235f:	89 c7                	mov    %eax,%edi
  802361:	eb 09                	jmp    80236c <__udivdi3+0x3c>
  802363:	90                   	nop    
  802364:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  802367:	76 17                	jbe    802380 <__udivdi3+0x50>
  802369:	31 ff                	xor    %edi,%edi
  80236b:	90                   	nop    
  80236c:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  802373:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802376:	83 c4 14             	add    $0x14,%esp
  802379:	5e                   	pop    %esi
  80237a:	89 f8                	mov    %edi,%eax
  80237c:	5f                   	pop    %edi
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    
  80237f:	90                   	nop    
  802380:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802384:	89 c7                	mov    %eax,%edi
  802386:	83 f7 1f             	xor    $0x1f,%edi
  802389:	75 4d                	jne    8023d8 <__udivdi3+0xa8>
  80238b:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  80238e:	77 0a                	ja     80239a <__udivdi3+0x6a>
  802390:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802393:	31 ff                	xor    %edi,%edi
  802395:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802398:	72 d2                	jb     80236c <__udivdi3+0x3c>
  80239a:	bf 01 00 00 00       	mov    $0x1,%edi
  80239f:	eb cb                	jmp    80236c <__udivdi3+0x3c>
  8023a1:	8d 76 00             	lea    0x0(%esi),%esi
  8023a4:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	75 0e                	jne    8023b9 <__udivdi3+0x89>
  8023ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b0:	31 c9                	xor    %ecx,%ecx
  8023b2:	31 d2                	xor    %edx,%edx
  8023b4:	f7 f1                	div    %ecx
  8023b6:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8023b9:	89 f0                	mov    %esi,%eax
  8023bb:	31 d2                	xor    %edx,%edx
  8023bd:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8023c0:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8023c3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8023c6:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8023c9:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8023cc:	83 c4 14             	add    $0x14,%esp
  8023cf:	89 c7                	mov    %eax,%edi
  8023d1:	5e                   	pop    %esi
  8023d2:	89 f8                	mov    %edi,%eax
  8023d4:	5f                   	pop    %edi
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    
  8023d7:	90                   	nop    
  8023d8:	b8 20 00 00 00       	mov    $0x20,%eax
  8023dd:	29 f8                	sub    %edi,%eax
  8023df:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  8023e2:	89 f9                	mov    %edi,%ecx
  8023e4:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8023e7:	d3 e2                	shl    %cl,%edx
  8023e9:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8023ec:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8023ef:	d3 e8                	shr    %cl,%eax
  8023f1:	09 c2                	or     %eax,%edx
  8023f3:	89 f9                	mov    %edi,%ecx
  8023f5:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8023f8:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8023fb:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8023fe:	89 f2                	mov    %esi,%edx
  802400:	d3 ea                	shr    %cl,%edx
  802402:	89 f9                	mov    %edi,%ecx
  802404:	d3 e6                	shl    %cl,%esi
  802406:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802409:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  80240c:	d3 e8                	shr    %cl,%eax
  80240e:	09 c6                	or     %eax,%esi
  802410:	89 f9                	mov    %edi,%ecx
  802412:	89 f0                	mov    %esi,%eax
  802414:	f7 75 f4             	divl   0xfffffff4(%ebp)
  802417:	89 d6                	mov    %edx,%esi
  802419:	89 c7                	mov    %eax,%edi
  80241b:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  80241e:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802421:	f7 e7                	mul    %edi
  802423:	39 f2                	cmp    %esi,%edx
  802425:	77 0f                	ja     802436 <__udivdi3+0x106>
  802427:	0f 85 3f ff ff ff    	jne    80236c <__udivdi3+0x3c>
  80242d:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802430:	0f 86 36 ff ff ff    	jbe    80236c <__udivdi3+0x3c>
  802436:	4f                   	dec    %edi
  802437:	e9 30 ff ff ff       	jmp    80236c <__udivdi3+0x3c>

0080243c <__umoddi3>:
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	57                   	push   %edi
  802440:	56                   	push   %esi
  802441:	83 ec 30             	sub    $0x30,%esp
  802444:	8b 55 14             	mov    0x14(%ebp),%edx
  802447:	8b 45 10             	mov    0x10(%ebp),%eax
  80244a:	89 d7                	mov    %edx,%edi
  80244c:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  80244f:	89 c6                	mov    %eax,%esi
  802451:	8b 55 0c             	mov    0xc(%ebp),%edx
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	85 ff                	test   %edi,%edi
  802459:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802460:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802467:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  80246a:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80246d:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802470:	75 3e                	jne    8024b0 <__umoddi3+0x74>
  802472:	39 d6                	cmp    %edx,%esi
  802474:	0f 86 a2 00 00 00    	jbe    80251c <__umoddi3+0xe0>
  80247a:	f7 f6                	div    %esi
  80247c:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80247f:	85 c9                	test   %ecx,%ecx
  802481:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802484:	74 1b                	je     8024a1 <__umoddi3+0x65>
  802486:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802489:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  80248c:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802493:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802496:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802499:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  80249c:	89 10                	mov    %edx,(%eax)
  80249e:	89 48 04             	mov    %ecx,0x4(%eax)
  8024a1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8024a4:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8024a7:	83 c4 30             	add    $0x30,%esp
  8024aa:	5e                   	pop    %esi
  8024ab:	5f                   	pop    %edi
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    
  8024ae:	89 f6                	mov    %esi,%esi
  8024b0:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  8024b3:	76 1f                	jbe    8024d4 <__umoddi3+0x98>
  8024b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8024b8:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8024bb:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8024be:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  8024c1:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8024c4:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8024c7:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  8024ca:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8024cd:	83 c4 30             	add    $0x30,%esp
  8024d0:	5e                   	pop    %esi
  8024d1:	5f                   	pop    %edi
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    
  8024d4:	0f bd c7             	bsr    %edi,%eax
  8024d7:	83 f0 1f             	xor    $0x1f,%eax
  8024da:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  8024dd:	75 61                	jne    802540 <__umoddi3+0x104>
  8024df:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  8024e2:	77 05                	ja     8024e9 <__umoddi3+0xad>
  8024e4:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  8024e7:	72 10                	jb     8024f9 <__umoddi3+0xbd>
  8024e9:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8024ec:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8024ef:	29 f0                	sub    %esi,%eax
  8024f1:	19 fa                	sbb    %edi,%edx
  8024f3:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8024f6:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8024f9:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8024fc:	85 d2                	test   %edx,%edx
  8024fe:	74 a1                	je     8024a1 <__umoddi3+0x65>
  802500:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802503:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802506:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802509:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  80250c:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80250f:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802512:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802515:	89 01                	mov    %eax,(%ecx)
  802517:	89 51 04             	mov    %edx,0x4(%ecx)
  80251a:	eb 85                	jmp    8024a1 <__umoddi3+0x65>
  80251c:	85 f6                	test   %esi,%esi
  80251e:	75 0b                	jne    80252b <__umoddi3+0xef>
  802520:	b8 01 00 00 00       	mov    $0x1,%eax
  802525:	31 d2                	xor    %edx,%edx
  802527:	f7 f6                	div    %esi
  802529:	89 c6                	mov    %eax,%esi
  80252b:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80252e:	89 fa                	mov    %edi,%edx
  802530:	f7 f6                	div    %esi
  802532:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802535:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802538:	f7 f6                	div    %esi
  80253a:	e9 3d ff ff ff       	jmp    80247c <__umoddi3+0x40>
  80253f:	90                   	nop    
  802540:	b8 20 00 00 00       	mov    $0x20,%eax
  802545:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802548:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  80254b:	89 fa                	mov    %edi,%edx
  80254d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802550:	d3 e2                	shl    %cl,%edx
  802552:	89 f0                	mov    %esi,%eax
  802554:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802557:	d3 e8                	shr    %cl,%eax
  802559:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80255c:	d3 e6                	shl    %cl,%esi
  80255e:	89 d7                	mov    %edx,%edi
  802560:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802563:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802566:	09 c7                	or     %eax,%edi
  802568:	d3 ea                	shr    %cl,%edx
  80256a:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80256d:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802570:	d3 e0                	shl    %cl,%eax
  802572:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802575:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802578:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80257b:	d3 e8                	shr    %cl,%eax
  80257d:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802580:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  802583:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802586:	f7 f7                	div    %edi
  802588:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80258b:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  80258e:	f7 e6                	mul    %esi
  802590:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  802593:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  802596:	77 0a                	ja     8025a2 <__umoddi3+0x166>
  802598:	75 12                	jne    8025ac <__umoddi3+0x170>
  80259a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80259d:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  8025a0:	76 0a                	jbe    8025ac <__umoddi3+0x170>
  8025a2:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  8025a5:	29 f1                	sub    %esi,%ecx
  8025a7:	19 fa                	sbb    %edi,%edx
  8025a9:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  8025ac:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	0f 84 ea fe ff ff    	je     8024a1 <__umoddi3+0x65>
  8025b7:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8025ba:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8025bd:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  8025c0:	19 d1                	sbb    %edx,%ecx
  8025c2:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  8025c5:	89 ca                	mov    %ecx,%edx
  8025c7:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8025ca:	d3 e2                	shl    %cl,%edx
  8025cc:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8025cf:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8025d2:	d3 e8                	shr    %cl,%eax
  8025d4:	09 c2                	or     %eax,%edx
  8025d6:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8025d9:	d3 e8                	shr    %cl,%eax
  8025db:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8025de:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8025e1:	e9 ad fe ff ff       	jmp    802493 <__umoddi3+0x57>
