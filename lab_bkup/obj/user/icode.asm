
obj/user/icode:     file format elf32-i386

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
  80002c:	e8 f7 00 00 00       	call   800128 <libmain>
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
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
	int fd, n, r;
	char buf[512+1];

	cprintf("icode startup\n");
  80003f:	68 60 2a 80 00       	push   $0x802a60
  800044:	e8 2b 02 00 00       	call   800274 <cprintf>

	cprintf("icode: open /motd\n");
  800049:	c7 04 24 6f 2a 80 00 	movl   $0x802a6f,(%esp)
  800050:	e8 1f 02 00 00       	call   800274 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800055:	83 c4 08             	add    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	68 82 2a 80 00       	push   $0x802a82
  80005f:	e8 f0 14 00 00       	call   801554 <open>
  800064:	89 c3                	mov    %eax,%ebx
  800066:	83 c4 10             	add    $0x10,%esp
  800069:	85 c0                	test   %eax,%eax
  80006b:	79 12                	jns    80007f <umain+0x4b>
		panic("icode: open /motd: %e", fd);
  80006d:	50                   	push   %eax
  80006e:	68 88 2a 80 00       	push   $0x802a88
  800073:	6a 0d                	push   $0xd
  800075:	68 9e 2a 80 00       	push   $0x802a9e
  80007a:	e8 05 01 00 00       	call   800184 <_panic>

	cprintf("icode: read /motd\n");
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 ab 2a 80 00       	push   $0x802aab
  800087:	e8 e8 01 00 00       	call   800274 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	8d b5 e8 fd ff ff    	lea    0xfffffde8(%ebp),%esi
  800095:	eb 0d                	jmp    8000a4 <umain+0x70>
		sys_cputs(buf, n);
  800097:	83 ec 08             	sub    $0x8,%esp
  80009a:	50                   	push   %eax
  80009b:	56                   	push   %esi
  80009c:	e8 e7 0a 00 00       	call   800b88 <sys_cputs>
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	83 ec 04             	sub    $0x4,%esp
  8000a7:	68 00 02 00 00       	push   $0x200
  8000ac:	56                   	push   %esi
  8000ad:	53                   	push   %ebx
  8000ae:	e8 06 12 00 00       	call   8012b9 <read>
  8000b3:	83 c4 10             	add    $0x10,%esp
  8000b6:	85 c0                	test   %eax,%eax
  8000b8:	7f dd                	jg     800097 <umain+0x63>

	cprintf("icode: close /motd\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 be 2a 80 00       	push   $0x802abe
  8000c2:	e8 ad 01 00 00       	call   800274 <cprintf>
	close(fd);
  8000c7:	89 1c 24             	mov    %ebx,(%esp)
  8000ca:	e8 77 10 00 00       	call   801146 <close>

	cprintf("icode: spawn /init\n");
  8000cf:	c7 04 24 d2 2a 80 00 	movl   $0x802ad2,(%esp)
  8000d6:	e8 99 01 00 00       	call   800274 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000e2:	68 e6 2a 80 00       	push   $0x802ae6
  8000e7:	68 ef 2a 80 00       	push   $0x802aef
  8000ec:	68 f9 2a 80 00       	push   $0x802af9
  8000f1:	68 f8 2a 80 00       	push   $0x802af8
  8000f6:	e8 01 1d 00 00       	call   801dfc <spawnl>
  8000fb:	83 c4 20             	add    $0x20,%esp
  8000fe:	85 c0                	test   %eax,%eax
  800100:	79 12                	jns    800114 <umain+0xe0>
		panic("icode: spawn /init: %e", r);
  800102:	50                   	push   %eax
  800103:	68 fe 2a 80 00       	push   $0x802afe
  800108:	6a 18                	push   $0x18
  80010a:	68 9e 2a 80 00       	push   $0x802a9e
  80010f:	e8 70 00 00 00       	call   800184 <_panic>

	cprintf("icode: exiting\n");
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 15 2b 80 00       	push   $0x802b15
  80011c:	e8 53 01 00 00       	call   800274 <cprintf>
}
  800121:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800124:	5b                   	pop    %ebx
  800125:	5e                   	pop    %esi
  800126:	c9                   	leave  
  800127:	c3                   	ret    

00800128 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	56                   	push   %esi
  80012c:	53                   	push   %ebx
  80012d:	8b 75 08             	mov    0x8(%ebp),%esi
  800130:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  800133:	e8 d4 0a 00 00       	call   800c0c <sys_getenvid>
  800138:	25 ff 03 00 00       	and    $0x3ff,%eax
  80013d:	c1 e0 07             	shl    $0x7,%eax
  800140:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800145:	a3 80 70 80 00       	mov    %eax,0x807080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014a:	85 f6                	test   %esi,%esi
  80014c:	7e 07                	jle    800155 <libmain+0x2d>
		binaryname = argv[0];
  80014e:	8b 03                	mov    (%ebx),%eax
  800150:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800155:	83 ec 08             	sub    $0x8,%esp
  800158:	53                   	push   %ebx
  800159:	56                   	push   %esi
  80015a:	e8 d5 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80015f:	e8 08 00 00 00       	call   80016c <exit>
}
  800164:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800167:	5b                   	pop    %ebx
  800168:	5e                   	pop    %esi
  800169:	c9                   	leave  
  80016a:	c3                   	ret    
	...

0080016c <exit>:
#include <inc/lib.h>

void
exit(void)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800172:	e8 fd 0f 00 00       	call   801174 <close_all>
	sys_env_destroy(0);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	6a 00                	push   $0x0
  80017c:	e8 4a 0a 00 00       	call   800bcb <sys_env_destroy>
}
  800181:	c9                   	leave  
  800182:	c3                   	ret    
	...

00800184 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	53                   	push   %ebx
  800188:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  80018b:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  80018e:	83 3d 84 70 80 00 00 	cmpl   $0x0,0x807084
  800195:	74 16                	je     8001ad <_panic+0x29>
		cprintf("%s: ", argv0);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 35 84 70 80 00    	pushl  0x807084
  8001a0:	68 3c 2b 80 00       	push   $0x802b3c
  8001a5:	e8 ca 00 00 00       	call   800274 <cprintf>
  8001aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001ad:	ff 75 0c             	pushl  0xc(%ebp)
  8001b0:	ff 75 08             	pushl  0x8(%ebp)
  8001b3:	ff 35 00 70 80 00    	pushl  0x807000
  8001b9:	68 41 2b 80 00       	push   $0x802b41
  8001be:	e8 b1 00 00 00       	call   800274 <cprintf>
	vcprintf(fmt, ap);
  8001c3:	83 c4 08             	add    $0x8,%esp
  8001c6:	53                   	push   %ebx
  8001c7:	ff 75 10             	pushl  0x10(%ebp)
  8001ca:	e8 54 00 00 00       	call   800223 <vcprintf>
	cprintf("\n");
  8001cf:	c7 04 24 f8 30 80 00 	movl   $0x8030f8,(%esp)
  8001d6:	e8 99 00 00 00       	call   800274 <cprintf>

	// Cause a breakpoint exception
	while (1)
  8001db:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  8001de:	cc                   	int3   
  8001df:	eb fd                	jmp    8001de <_panic+0x5a>
  8001e1:	00 00                	add    %al,(%eax)
	...

008001e4 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	53                   	push   %ebx
  8001e8:	83 ec 04             	sub    $0x4,%esp
  8001eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001ee:	8b 03                	mov    (%ebx),%eax
  8001f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f3:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  8001f7:	40                   	inc    %eax
  8001f8:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001fa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ff:	75 1a                	jne    80021b <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800201:	83 ec 08             	sub    $0x8,%esp
  800204:	68 ff 00 00 00       	push   $0xff
  800209:	8d 43 08             	lea    0x8(%ebx),%eax
  80020c:	50                   	push   %eax
  80020d:	e8 76 09 00 00       	call   800b88 <sys_cputs>
		b->idx = 0;
  800212:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800218:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  80021b:	ff 43 04             	incl   0x4(%ebx)
}
  80021e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800221:	c9                   	leave  
  800222:	c3                   	ret    

00800223 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800223:	55                   	push   %ebp
  800224:	89 e5                	mov    %esp,%ebp
  800226:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80022c:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  800233:	00 00 00 
	b.cnt = 0;
  800236:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  80023d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800240:	ff 75 0c             	pushl  0xc(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  80024c:	50                   	push   %eax
  80024d:	68 e4 01 80 00       	push   $0x8001e4
  800252:	e8 4f 01 00 00       	call   8003a6 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800257:	83 c4 08             	add    $0x8,%esp
  80025a:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  800260:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  800266:	50                   	push   %eax
  800267:	e8 1c 09 00 00       	call   800b88 <sys_cputs>

	return b.cnt;
  80026c:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80027a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80027d:	50                   	push   %eax
  80027e:	ff 75 08             	pushl  0x8(%ebp)
  800281:	e8 9d ff ff ff       	call   800223 <vcprintf>
	va_end(ap);

	return cnt;
}
  800286:	c9                   	leave  
  800287:	c3                   	ret    

00800288 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	57                   	push   %edi
  80028c:	56                   	push   %esi
  80028d:	53                   	push   %ebx
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	8b 75 10             	mov    0x10(%ebp),%esi
  800294:	8b 7d 14             	mov    0x14(%ebp),%edi
  800297:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80029a:	8b 45 18             	mov    0x18(%ebp),%eax
  80029d:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a2:	39 fa                	cmp    %edi,%edx
  8002a4:	77 39                	ja     8002df <printnum+0x57>
  8002a6:	72 04                	jb     8002ac <printnum+0x24>
  8002a8:	39 f0                	cmp    %esi,%eax
  8002aa:	77 33                	ja     8002df <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002ac:	83 ec 04             	sub    $0x4,%esp
  8002af:	ff 75 20             	pushl  0x20(%ebp)
  8002b2:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  8002b5:	50                   	push   %eax
  8002b6:	ff 75 18             	pushl  0x18(%ebp)
  8002b9:	8b 45 18             	mov    0x18(%ebp),%eax
  8002bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c1:	52                   	push   %edx
  8002c2:	50                   	push   %eax
  8002c3:	57                   	push   %edi
  8002c4:	56                   	push   %esi
  8002c5:	e8 ca 24 00 00       	call   802794 <__udivdi3>
  8002ca:	83 c4 10             	add    $0x10,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 ae ff ff ff       	call   800288 <printnum>
  8002da:	83 c4 20             	add    $0x20,%esp
  8002dd:	eb 19                	jmp    8002f8 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002df:	4b                   	dec    %ebx
  8002e0:	85 db                	test   %ebx,%ebx
  8002e2:	7e 14                	jle    8002f8 <printnum+0x70>
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ea:	ff 75 20             	pushl  0x20(%ebp)
  8002ed:	ff 55 08             	call   *0x8(%ebp)
  8002f0:	83 c4 10             	add    $0x10,%esp
  8002f3:	4b                   	dec    %ebx
  8002f4:	85 db                	test   %ebx,%ebx
  8002f6:	7f ec                	jg     8002e4 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002f8:	83 ec 08             	sub    $0x8,%esp
  8002fb:	ff 75 0c             	pushl  0xc(%ebp)
  8002fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800301:	ba 00 00 00 00       	mov    $0x0,%edx
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	52                   	push   %edx
  80030a:	50                   	push   %eax
  80030b:	57                   	push   %edi
  80030c:	56                   	push   %esi
  80030d:	e8 8e 25 00 00       	call   8028a0 <__umoddi3>
  800312:	83 c4 14             	add    $0x14,%esp
  800315:	0f be 80 57 2c 80 00 	movsbl 0x802c57(%eax),%eax
  80031c:	50                   	push   %eax
  80031d:	ff 55 08             	call   *0x8(%ebp)
}
  800320:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800323:	5b                   	pop    %ebx
  800324:	5e                   	pop    %esi
  800325:	5f                   	pop    %edi
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80032e:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800331:	83 f8 01             	cmp    $0x1,%eax
  800334:	7e 0f                	jle    800345 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  800336:	8b 01                	mov    (%ecx),%eax
  800338:	83 c0 08             	add    $0x8,%eax
  80033b:	89 01                	mov    %eax,(%ecx)
  80033d:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800340:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  800343:	eb 24                	jmp    800369 <getuint+0x41>
	else if (lflag)
  800345:	85 c0                	test   %eax,%eax
  800347:	74 11                	je     80035a <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800349:	8b 01                	mov    (%ecx),%eax
  80034b:	83 c0 04             	add    $0x4,%eax
  80034e:	89 01                	mov    %eax,(%ecx)
  800350:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800353:	ba 00 00 00 00       	mov    $0x0,%edx
  800358:	eb 0f                	jmp    800369 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  80035a:	8b 01                	mov    (%ecx),%eax
  80035c:	83 c0 04             	add    $0x4,%eax
  80035f:	89 01                	mov    %eax,(%ecx)
  800361:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800364:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	8b 55 08             	mov    0x8(%ebp),%edx
  800371:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800374:	83 f8 01             	cmp    $0x1,%eax
  800377:	7e 0f                	jle    800388 <getint+0x1d>
		return va_arg(*ap, long long);
  800379:	8b 02                	mov    (%edx),%eax
  80037b:	83 c0 08             	add    $0x8,%eax
  80037e:	89 02                	mov    %eax,(%edx)
  800380:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800383:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  800386:	eb 1c                	jmp    8003a4 <getint+0x39>
	else if (lflag)
  800388:	85 c0                	test   %eax,%eax
  80038a:	74 0d                	je     800399 <getint+0x2e>
		return va_arg(*ap, long);
  80038c:	8b 02                	mov    (%edx),%eax
  80038e:	83 c0 04             	add    $0x4,%eax
  800391:	89 02                	mov    %eax,(%edx)
  800393:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800396:	99                   	cltd   
  800397:	eb 0b                	jmp    8003a4 <getint+0x39>
	else
		return va_arg(*ap, int);
  800399:	8b 02                	mov    (%edx),%eax
  80039b:	83 c0 04             	add    $0x4,%eax
  80039e:	89 02                	mov    %eax,(%edx)
  8003a0:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003a3:	99                   	cltd   
}
  8003a4:	c9                   	leave  
  8003a5:	c3                   	ret    

008003a6 <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	57                   	push   %edi
  8003aa:	56                   	push   %esi
  8003ab:	53                   	push   %ebx
  8003ac:	83 ec 1c             	sub    $0x1c,%esp
  8003af:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  8003b2:	0f b6 13             	movzbl (%ebx),%edx
  8003b5:	43                   	inc    %ebx
  8003b6:	83 fa 25             	cmp    $0x25,%edx
  8003b9:	74 1e                	je     8003d9 <vprintfmt+0x33>
  8003bb:	85 d2                	test   %edx,%edx
  8003bd:	0f 84 d7 02 00 00    	je     80069a <vprintfmt+0x2f4>
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	ff 75 0c             	pushl  0xc(%ebp)
  8003c9:	52                   	push   %edx
  8003ca:	ff 55 08             	call   *0x8(%ebp)
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	0f b6 13             	movzbl (%ebx),%edx
  8003d3:	43                   	inc    %ebx
  8003d4:	83 fa 25             	cmp    $0x25,%edx
  8003d7:	75 e2                	jne    8003bb <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  8003d9:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  8003dd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  8003e4:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  8003e9:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  8003ee:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f5:	0f b6 13             	movzbl (%ebx),%edx
  8003f8:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  8003fb:	43                   	inc    %ebx
  8003fc:	83 f8 55             	cmp    $0x55,%eax
  8003ff:	0f 87 70 02 00 00    	ja     800675 <vprintfmt+0x2cf>
  800405:	ff 24 85 dc 2c 80 00 	jmp    *0x802cdc(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  80040c:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  800410:	eb e3                	jmp    8003f5 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800412:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  800416:	eb dd                	jmp    8003f5 <vprintfmt+0x4f>

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
  800418:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  80041d:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  800420:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  800424:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  800427:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  80042a:	83 f8 09             	cmp    $0x9,%eax
  80042d:	77 27                	ja     800456 <vprintfmt+0xb0>
  80042f:	43                   	inc    %ebx
  800430:	eb eb                	jmp    80041d <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800432:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800436:	8b 45 14             	mov    0x14(%ebp),%eax
  800439:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  80043c:	eb 18                	jmp    800456 <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  80043e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800442:	79 b1                	jns    8003f5 <vprintfmt+0x4f>
				width = 0;
  800444:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  80044b:	eb a8                	jmp    8003f5 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  80044d:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  800454:	eb 9f                	jmp    8003f5 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  800456:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80045a:	79 99                	jns    8003f5 <vprintfmt+0x4f>
				width = precision, precision = -1;
  80045c:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  80045f:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  800464:	eb 8f                	jmp    8003f5 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800466:	41                   	inc    %ecx
			goto reswitch;
  800467:	eb 8c                	jmp    8003f5 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800469:	83 ec 08             	sub    $0x8,%esp
  80046c:	ff 75 0c             	pushl  0xc(%ebp)
  80046f:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	ff 70 fc             	pushl  0xfffffffc(%eax)
  800479:	ff 55 08             	call   *0x8(%ebp)
			break;
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	e9 2e ff ff ff       	jmp    8003b2 <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800484:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  80048e:	85 c0                	test   %eax,%eax
  800490:	79 02                	jns    800494 <vprintfmt+0xee>
				err = -err;
  800492:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800494:	83 f8 0e             	cmp    $0xe,%eax
  800497:	7f 0b                	jg     8004a4 <vprintfmt+0xfe>
  800499:	8b 3c 85 a0 2c 80 00 	mov    0x802ca0(,%eax,4),%edi
  8004a0:	85 ff                	test   %edi,%edi
  8004a2:	75 19                	jne    8004bd <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8004a4:	50                   	push   %eax
  8004a5:	68 68 2c 80 00       	push   $0x802c68
  8004aa:	ff 75 0c             	pushl  0xc(%ebp)
  8004ad:	ff 75 08             	pushl  0x8(%ebp)
  8004b0:	e8 ed 01 00 00       	call   8006a2 <printfmt>
  8004b5:	83 c4 10             	add    $0x10,%esp
  8004b8:	e9 f5 fe ff ff       	jmp    8003b2 <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  8004bd:	57                   	push   %edi
  8004be:	68 e1 2f 80 00       	push   $0x802fe1
  8004c3:	ff 75 0c             	pushl  0xc(%ebp)
  8004c6:	ff 75 08             	pushl  0x8(%ebp)
  8004c9:	e8 d4 01 00 00       	call   8006a2 <printfmt>
  8004ce:	83 c4 10             	add    $0x10,%esp
			break;
  8004d1:	e9 dc fe ff ff       	jmp    8003b2 <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004d6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  8004e0:	85 ff                	test   %edi,%edi
  8004e2:	75 05                	jne    8004e9 <vprintfmt+0x143>
				p = "(null)";
  8004e4:	bf 71 2c 80 00       	mov    $0x802c71,%edi
			if (width > 0 && padc != '-')
  8004e9:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004ed:	7e 3b                	jle    80052a <vprintfmt+0x184>
  8004ef:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  8004f3:	74 35                	je     80052a <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f5:	83 ec 08             	sub    $0x8,%esp
  8004f8:	56                   	push   %esi
  8004f9:	57                   	push   %edi
  8004fa:	e8 56 03 00 00       	call   800855 <strnlen>
  8004ff:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  800502:	83 c4 10             	add    $0x10,%esp
  800505:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800509:	7e 1f                	jle    80052a <vprintfmt+0x184>
  80050b:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  80050f:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	ff 75 0c             	pushl  0xc(%ebp)
  800518:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  80051b:	ff 55 08             	call   *0x8(%ebp)
  80051e:	83 c4 10             	add    $0x10,%esp
  800521:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800524:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800528:	7f e8                	jg     800512 <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80052a:	0f be 17             	movsbl (%edi),%edx
  80052d:	47                   	inc    %edi
  80052e:	85 d2                	test   %edx,%edx
  800530:	74 44                	je     800576 <vprintfmt+0x1d0>
  800532:	85 f6                	test   %esi,%esi
  800534:	78 03                	js     800539 <vprintfmt+0x193>
  800536:	4e                   	dec    %esi
  800537:	78 3d                	js     800576 <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800539:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  80053d:	74 18                	je     800557 <vprintfmt+0x1b1>
  80053f:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  800542:	83 f8 5e             	cmp    $0x5e,%eax
  800545:	76 10                	jbe    800557 <vprintfmt+0x1b1>
					putch('?', putdat);
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	ff 75 0c             	pushl  0xc(%ebp)
  80054d:	6a 3f                	push   $0x3f
  80054f:	ff 55 08             	call   *0x8(%ebp)
  800552:	83 c4 10             	add    $0x10,%esp
  800555:	eb 0d                	jmp    800564 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	ff 75 0c             	pushl  0xc(%ebp)
  80055d:	52                   	push   %edx
  80055e:	ff 55 08             	call   *0x8(%ebp)
  800561:	83 c4 10             	add    $0x10,%esp
  800564:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800567:	0f be 17             	movsbl (%edi),%edx
  80056a:	47                   	inc    %edi
  80056b:	85 d2                	test   %edx,%edx
  80056d:	74 07                	je     800576 <vprintfmt+0x1d0>
  80056f:	85 f6                	test   %esi,%esi
  800571:	78 c6                	js     800539 <vprintfmt+0x193>
  800573:	4e                   	dec    %esi
  800574:	79 c3                	jns    800539 <vprintfmt+0x193>
			for (; width > 0; width--)
  800576:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80057a:	0f 8e 32 fe ff ff    	jle    8003b2 <vprintfmt+0xc>
				putch(' ', putdat);
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 0c             	pushl  0xc(%ebp)
  800586:	6a 20                	push   $0x20
  800588:	ff 55 08             	call   *0x8(%ebp)
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800591:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800595:	7f e9                	jg     800580 <vprintfmt+0x1da>
			break;
  800597:	e9 16 fe ff ff       	jmp    8003b2 <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80059c:	51                   	push   %ecx
  80059d:	8d 45 14             	lea    0x14(%ebp),%eax
  8005a0:	50                   	push   %eax
  8005a1:	e8 c5 fd ff ff       	call   80036b <getint>
  8005a6:	89 c6                	mov    %eax,%esi
  8005a8:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8005aa:	83 c4 08             	add    $0x8,%esp
  8005ad:	85 d2                	test   %edx,%edx
  8005af:	79 15                	jns    8005c6 <vprintfmt+0x220>
				putch('-', putdat);
  8005b1:	83 ec 08             	sub    $0x8,%esp
  8005b4:	ff 75 0c             	pushl  0xc(%ebp)
  8005b7:	6a 2d                	push   $0x2d
  8005b9:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005bc:	f7 de                	neg    %esi
  8005be:	83 d7 00             	adc    $0x0,%edi
  8005c1:	f7 df                	neg    %edi
  8005c3:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8005c6:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8005cb:	eb 75                	jmp    800642 <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005cd:	51                   	push   %ecx
  8005ce:	8d 45 14             	lea    0x14(%ebp),%eax
  8005d1:	50                   	push   %eax
  8005d2:	e8 51 fd ff ff       	call   800328 <getuint>
  8005d7:	89 c6                	mov    %eax,%esi
  8005d9:	89 d7                	mov    %edx,%edi
			base = 10;
  8005db:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8005e0:	83 c4 08             	add    $0x8,%esp
  8005e3:	eb 5d                	jmp    800642 <vprintfmt+0x29c>

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
  8005e5:	51                   	push   %ecx
  8005e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8005e9:	50                   	push   %eax
  8005ea:	e8 39 fd ff ff       	call   800328 <getuint>
  8005ef:	89 c6                	mov    %eax,%esi
  8005f1:	89 d7                	mov    %edx,%edi
			base = 8;
  8005f3:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  8005f8:	83 c4 08             	add    $0x8,%esp
  8005fb:	eb 45                	jmp    800642 <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	ff 75 0c             	pushl  0xc(%ebp)
  800603:	6a 30                	push   $0x30
  800605:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800608:	83 c4 08             	add    $0x8,%esp
  80060b:	ff 75 0c             	pushl  0xc(%ebp)
  80060e:	6a 78                	push   $0x78
  800610:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  800613:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  80061d:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800622:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	eb 16                	jmp    800642 <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80062c:	51                   	push   %ecx
  80062d:	8d 45 14             	lea    0x14(%ebp),%eax
  800630:	50                   	push   %eax
  800631:	e8 f2 fc ff ff       	call   800328 <getuint>
  800636:	89 c6                	mov    %eax,%esi
  800638:	89 d7                	mov    %edx,%edi
			base = 16;
  80063a:	ba 10 00 00 00       	mov    $0x10,%edx
  80063f:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800649:	50                   	push   %eax
  80064a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80064d:	52                   	push   %edx
  80064e:	57                   	push   %edi
  80064f:	56                   	push   %esi
  800650:	ff 75 0c             	pushl  0xc(%ebp)
  800653:	ff 75 08             	pushl  0x8(%ebp)
  800656:	e8 2d fc ff ff       	call   800288 <printnum>
			break;
  80065b:	83 c4 20             	add    $0x20,%esp
  80065e:	e9 4f fd ff ff       	jmp    8003b2 <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 0c             	pushl  0xc(%ebp)
  800669:	52                   	push   %edx
  80066a:	ff 55 08             	call   *0x8(%ebp)
			break;
  80066d:	83 c4 10             	add    $0x10,%esp
  800670:	e9 3d fd ff ff       	jmp    8003b2 <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	6a 25                	push   $0x25
  80067d:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800680:	4b                   	dec    %ebx
  800681:	83 c4 10             	add    $0x10,%esp
  800684:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800688:	0f 84 24 fd ff ff    	je     8003b2 <vprintfmt+0xc>
  80068e:	4b                   	dec    %ebx
  80068f:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800693:	75 f9                	jne    80068e <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  800695:	e9 18 fd ff ff       	jmp    8003b2 <vprintfmt+0xc>
		}
	}
}
  80069a:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80069d:	5b                   	pop    %ebx
  80069e:	5e                   	pop    %esi
  80069f:	5f                   	pop    %edi
  8006a0:	c9                   	leave  
  8006a1:	c3                   	ret    

008006a2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006a2:	55                   	push   %ebp
  8006a3:	89 e5                	mov    %esp,%ebp
  8006a5:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8006a8:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006ab:	50                   	push   %eax
  8006ac:	ff 75 10             	pushl  0x10(%ebp)
  8006af:	ff 75 0c             	pushl  0xc(%ebp)
  8006b2:	ff 75 08             	pushl  0x8(%ebp)
  8006b5:	e8 ec fc ff ff       	call   8003a6 <vprintfmt>
	va_end(ap);
}
  8006ba:	c9                   	leave  
  8006bb:	c3                   	ret    

008006bc <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  8006c2:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  8006c5:	8b 0a                	mov    (%edx),%ecx
  8006c7:	3b 4a 04             	cmp    0x4(%edx),%ecx
  8006ca:	73 07                	jae    8006d3 <sprintputch+0x17>
		*b->buf++ = ch;
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	88 01                	mov    %al,(%ecx)
  8006d1:	ff 02                	incl   (%edx)
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
  8006db:	8b 55 08             	mov    0x8(%ebp),%edx
  8006de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006e1:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  8006e4:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  8006e8:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8006eb:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  8006f2:	85 d2                	test   %edx,%edx
  8006f4:	74 04                	je     8006fa <vsnprintf+0x25>
  8006f6:	85 c9                	test   %ecx,%ecx
  8006f8:	7f 07                	jg     800701 <vsnprintf+0x2c>
		return -E_INVAL;
  8006fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006ff:	eb 1d                	jmp    80071e <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800701:	ff 75 14             	pushl  0x14(%ebp)
  800704:	ff 75 10             	pushl  0x10(%ebp)
  800707:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  80070a:	50                   	push   %eax
  80070b:	68 bc 06 80 00       	push   $0x8006bc
  800710:	e8 91 fc ff ff       	call   8003a6 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800715:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800718:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80071b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  80071e:	c9                   	leave  
  80071f:	c3                   	ret    

00800720 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800720:	55                   	push   %ebp
  800721:	89 e5                	mov    %esp,%ebp
  800723:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800726:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800729:	50                   	push   %eax
  80072a:	ff 75 10             	pushl  0x10(%ebp)
  80072d:	ff 75 0c             	pushl  0xc(%ebp)
  800730:	ff 75 08             	pushl  0x8(%ebp)
  800733:	e8 9d ff ff ff       	call   8006d5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800738:	c9                   	leave  
  800739:	c3                   	ret    
	...

0080073c <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  80073c:	55                   	push   %ebp
  80073d:	89 e5                	mov    %esp,%ebp
  80073f:	56                   	push   %esi
  800740:	53                   	push   %ebx
  800741:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800744:	83 ec 0c             	sub    $0xc,%esp
  800747:	56                   	push   %esi
  800748:	e8 ef 00 00 00       	call   80083c <strlen>
  char letter;
  int hexnum = 0;
  80074d:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  800752:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	89 c2                	mov    %eax,%edx
  80075c:	4a                   	dec    %edx
  80075d:	0f 88 d0 00 00 00    	js     800833 <strtoint+0xf7>
    letter = string[cidx];
  800763:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  800766:	85 d2                	test   %edx,%edx
  800768:	75 12                	jne    80077c <strtoint+0x40>
      if (letter != '0') {
  80076a:	3c 30                	cmp    $0x30,%al
  80076c:	0f 84 ba 00 00 00    	je     80082c <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800772:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800777:	e9 b9 00 00 00       	jmp    800835 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  80077c:	83 fa 01             	cmp    $0x1,%edx
  80077f:	75 12                	jne    800793 <strtoint+0x57>
      if (letter != 'x') {
  800781:	3c 78                	cmp    $0x78,%al
  800783:	0f 84 a3 00 00 00    	je     80082c <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800789:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80078e:	e9 a2 00 00 00       	jmp    800835 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  800793:	0f be c0             	movsbl %al,%eax
  800796:	83 e8 30             	sub    $0x30,%eax
  800799:	83 f8 36             	cmp    $0x36,%eax
  80079c:	0f 87 80 00 00 00    	ja     800822 <strtoint+0xe6>
  8007a2:	ff 24 85 34 2e 80 00 	jmp    *0x802e34(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8007a9:	01 cb                	add    %ecx,%ebx
          break;
  8007ab:	eb 7c                	jmp    800829 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8007ad:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8007b0:	eb 77                	jmp    800829 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8007b2:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8007b5:	01 c3                	add    %eax,%ebx
          break;
  8007b7:	eb 70                	jmp    800829 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  8007b9:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  8007bc:	eb 6b                	jmp    800829 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  8007be:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8007c1:	01 c3                	add    %eax,%ebx
          break;
  8007c3:	eb 64                	jmp    800829 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  8007c5:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8007c8:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8007cb:	eb 5c                	jmp    800829 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  8007cd:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8007d4:	29 c8                	sub    %ecx,%eax
  8007d6:	01 c3                	add    %eax,%ebx
          break;
  8007d8:	eb 4f                	jmp    800829 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8007da:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8007dd:	eb 4a                	jmp    800829 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8007df:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8007e2:	01 c3                	add    %eax,%ebx
          break;
  8007e4:	eb 43                	jmp    800829 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8007e6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8007e9:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8007ec:	eb 3b                	jmp    800829 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  8007ee:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8007f1:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  8007f4:	01 c3                	add    %eax,%ebx
          break;
  8007f6:	eb 31                	jmp    800829 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  8007f8:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8007fb:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  8007fe:	eb 29                	jmp    800829 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800800:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800803:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  800806:	01 c3                	add    %eax,%ebx
          break;
  800808:	eb 1f                	jmp    800829 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  80080a:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800811:	29 c8                	sub    %ecx,%eax
  800813:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800816:	eb 11                	jmp    800829 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800818:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80081b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80081e:	01 c3                	add    %eax,%ebx
          break;
  800820:	eb 07                	jmp    800829 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  800822:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800827:	eb 0c                	jmp    800835 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800829:	c1 e1 04             	shl    $0x4,%ecx
  80082c:	4a                   	dec    %edx
  80082d:	0f 89 30 ff ff ff    	jns    800763 <strtoint+0x27>
    }
  }

  return hexnum;
  800833:	89 d8                	mov    %ebx,%eax
}
  800835:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800838:	5b                   	pop    %ebx
  800839:	5e                   	pop    %esi
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    

0080083c <strlen>:





int
strlen(const char *s)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800842:	b8 00 00 00 00       	mov    $0x0,%eax
  800847:	80 3a 00             	cmpb   $0x0,(%edx)
  80084a:	74 07                	je     800853 <strlen+0x17>
		n++;
  80084c:	40                   	inc    %eax
  80084d:	42                   	inc    %edx
  80084e:	80 3a 00             	cmpb   $0x0,(%edx)
  800851:	75 f9                	jne    80084c <strlen+0x10>
	return n;
}
  800853:	c9                   	leave  
  800854:	c3                   	ret    

00800855 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
  800858:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085e:	b8 00 00 00 00       	mov    $0x0,%eax
  800863:	85 d2                	test   %edx,%edx
  800865:	74 0f                	je     800876 <strnlen+0x21>
  800867:	80 39 00             	cmpb   $0x0,(%ecx)
  80086a:	74 0a                	je     800876 <strnlen+0x21>
		n++;
  80086c:	40                   	inc    %eax
  80086d:	41                   	inc    %ecx
  80086e:	4a                   	dec    %edx
  80086f:	74 05                	je     800876 <strnlen+0x21>
  800871:	80 39 00             	cmpb   $0x0,(%ecx)
  800874:	75 f6                	jne    80086c <strnlen+0x17>
	return n;
}
  800876:	c9                   	leave  
  800877:	c3                   	ret    

00800878 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	53                   	push   %ebx
  80087c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087f:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  800882:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  800884:	8a 02                	mov    (%edx),%al
  800886:	42                   	inc    %edx
  800887:	88 01                	mov    %al,(%ecx)
  800889:	41                   	inc    %ecx
  80088a:	84 c0                	test   %al,%al
  80088c:	75 f6                	jne    800884 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80088e:	89 d8                	mov    %ebx,%eax
  800890:	5b                   	pop    %ebx
  800891:	c9                   	leave  
  800892:	c3                   	ret    

00800893 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	57                   	push   %edi
  800897:	56                   	push   %esi
  800898:	53                   	push   %ebx
  800899:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80089c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089f:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  8008a2:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  8008a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008a9:	39 f3                	cmp    %esi,%ebx
  8008ab:	73 10                	jae    8008bd <strncpy+0x2a>
		*dst++ = *src;
  8008ad:	8a 02                	mov    (%edx),%al
  8008af:	88 01                	mov    %al,(%ecx)
  8008b1:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008b2:	80 3a 01             	cmpb   $0x1,(%edx)
  8008b5:	83 da ff             	sbb    $0xffffffff,%edx
  8008b8:	43                   	inc    %ebx
  8008b9:	39 f3                	cmp    %esi,%ebx
  8008bb:	72 f0                	jb     8008ad <strncpy+0x1a>
	}
	return ret;
}
  8008bd:	89 f8                	mov    %edi,%eax
  8008bf:	5b                   	pop    %ebx
  8008c0:	5e                   	pop    %esi
  8008c1:	5f                   	pop    %edi
  8008c2:	c9                   	leave  
  8008c3:	c3                   	ret    

008008c4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	56                   	push   %esi
  8008c8:	53                   	push   %ebx
  8008c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cf:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  8008d2:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  8008d4:	85 d2                	test   %edx,%edx
  8008d6:	74 19                	je     8008f1 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008d8:	4a                   	dec    %edx
  8008d9:	74 13                	je     8008ee <strlcpy+0x2a>
  8008db:	80 39 00             	cmpb   $0x0,(%ecx)
  8008de:	74 0e                	je     8008ee <strlcpy+0x2a>
  8008e0:	8a 01                	mov    (%ecx),%al
  8008e2:	41                   	inc    %ecx
  8008e3:	88 03                	mov    %al,(%ebx)
  8008e5:	43                   	inc    %ebx
  8008e6:	4a                   	dec    %edx
  8008e7:	74 05                	je     8008ee <strlcpy+0x2a>
  8008e9:	80 39 00             	cmpb   $0x0,(%ecx)
  8008ec:	75 f2                	jne    8008e0 <strlcpy+0x1c>
		*dst = '\0';
  8008ee:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  8008f1:	89 d8                	mov    %ebx,%eax
  8008f3:	29 f0                	sub    %esi,%eax
}
  8008f5:	5b                   	pop    %ebx
  8008f6:	5e                   	pop    %esi
  8008f7:	c9                   	leave  
  8008f8:	c3                   	ret    

008008f9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f9:	55                   	push   %ebp
  8008fa:	89 e5                	mov    %esp,%ebp
  8008fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  800902:	80 3a 00             	cmpb   $0x0,(%edx)
  800905:	74 13                	je     80091a <strcmp+0x21>
  800907:	8a 02                	mov    (%edx),%al
  800909:	3a 01                	cmp    (%ecx),%al
  80090b:	75 0d                	jne    80091a <strcmp+0x21>
  80090d:	42                   	inc    %edx
  80090e:	41                   	inc    %ecx
  80090f:	80 3a 00             	cmpb   $0x0,(%edx)
  800912:	74 06                	je     80091a <strcmp+0x21>
  800914:	8a 02                	mov    (%edx),%al
  800916:	3a 01                	cmp    (%ecx),%al
  800918:	74 f3                	je     80090d <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80091a:	0f b6 02             	movzbl (%edx),%eax
  80091d:	0f b6 11             	movzbl (%ecx),%edx
  800920:	29 d0                	sub    %edx,%eax
}
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	53                   	push   %ebx
  800928:	8b 55 08             	mov    0x8(%ebp),%edx
  80092b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80092e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800931:	85 c9                	test   %ecx,%ecx
  800933:	74 1f                	je     800954 <strncmp+0x30>
  800935:	80 3a 00             	cmpb   $0x0,(%edx)
  800938:	74 16                	je     800950 <strncmp+0x2c>
  80093a:	8a 02                	mov    (%edx),%al
  80093c:	3a 03                	cmp    (%ebx),%al
  80093e:	75 10                	jne    800950 <strncmp+0x2c>
  800940:	42                   	inc    %edx
  800941:	43                   	inc    %ebx
  800942:	49                   	dec    %ecx
  800943:	74 0f                	je     800954 <strncmp+0x30>
  800945:	80 3a 00             	cmpb   $0x0,(%edx)
  800948:	74 06                	je     800950 <strncmp+0x2c>
  80094a:	8a 02                	mov    (%edx),%al
  80094c:	3a 03                	cmp    (%ebx),%al
  80094e:	74 f0                	je     800940 <strncmp+0x1c>
	if (n == 0)
  800950:	85 c9                	test   %ecx,%ecx
  800952:	75 07                	jne    80095b <strncmp+0x37>
		return 0;
  800954:	b8 00 00 00 00       	mov    $0x0,%eax
  800959:	eb 0a                	jmp    800965 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80095b:	0f b6 12             	movzbl (%edx),%edx
  80095e:	0f b6 03             	movzbl (%ebx),%eax
  800961:	29 c2                	sub    %eax,%edx
  800963:	89 d0                	mov    %edx,%eax
}
  800965:	5b                   	pop    %ebx
  800966:	c9                   	leave  
  800967:	c3                   	ret    

00800968 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800971:	80 38 00             	cmpb   $0x0,(%eax)
  800974:	74 0a                	je     800980 <strchr+0x18>
		if (*s == c)
  800976:	38 10                	cmp    %dl,(%eax)
  800978:	74 0b                	je     800985 <strchr+0x1d>
  80097a:	40                   	inc    %eax
  80097b:	80 38 00             	cmpb   $0x0,(%eax)
  80097e:	75 f6                	jne    800976 <strchr+0xe>
			return (char *) s;
	return 0;
  800980:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800985:	c9                   	leave  
  800986:	c3                   	ret    

00800987 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800990:	80 38 00             	cmpb   $0x0,(%eax)
  800993:	74 0a                	je     80099f <strfind+0x18>
		if (*s == c)
  800995:	38 10                	cmp    %dl,(%eax)
  800997:	74 06                	je     80099f <strfind+0x18>
  800999:	40                   	inc    %eax
  80099a:	80 38 00             	cmpb   $0x0,(%eax)
  80099d:	75 f6                	jne    800995 <strfind+0xe>
			break;
	return (char *) s;
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	57                   	push   %edi
  8009a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  8009ab:	89 f8                	mov    %edi,%eax
  8009ad:	85 c9                	test   %ecx,%ecx
  8009af:	74 40                	je     8009f1 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  8009b1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009b7:	75 30                	jne    8009e9 <memset+0x48>
  8009b9:	f6 c1 03             	test   $0x3,%cl
  8009bc:	75 2b                	jne    8009e9 <memset+0x48>
		c &= 0xFF;
  8009be:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	c1 e0 18             	shl    $0x18,%eax
  8009cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ce:	c1 e2 10             	shl    $0x10,%edx
  8009d1:	09 d0                	or     %edx,%eax
  8009d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d6:	c1 e2 08             	shl    $0x8,%edx
  8009d9:	09 d0                	or     %edx,%eax
  8009db:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  8009de:	c1 e9 02             	shr    $0x2,%ecx
  8009e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e4:	fc                   	cld    
  8009e5:	f3 ab                	repz stos %eax,%es:(%edi)
  8009e7:	eb 06                	jmp    8009ef <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	fc                   	cld    
  8009ed:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  8009ef:	89 f8                	mov    %edi,%eax
}
  8009f1:	5f                   	pop    %edi
  8009f2:	c9                   	leave  
  8009f3:	c3                   	ret    

008009f4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	57                   	push   %edi
  8009f8:	56                   	push   %esi
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  8009ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a02:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a04:	39 c6                	cmp    %eax,%esi
  800a06:	73 33                	jae    800a3b <memmove+0x47>
  800a08:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a0b:	39 c2                	cmp    %eax,%edx
  800a0d:	76 2c                	jbe    800a3b <memmove+0x47>
		s += n;
  800a0f:	89 d6                	mov    %edx,%esi
		d += n;
  800a11:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a14:	f6 c2 03             	test   $0x3,%dl
  800a17:	75 1b                	jne    800a34 <memmove+0x40>
  800a19:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a1f:	75 13                	jne    800a34 <memmove+0x40>
  800a21:	f6 c1 03             	test   $0x3,%cl
  800a24:	75 0e                	jne    800a34 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800a26:	83 ef 04             	sub    $0x4,%edi
  800a29:	83 ee 04             	sub    $0x4,%esi
  800a2c:	c1 e9 02             	shr    $0x2,%ecx
  800a2f:	fd                   	std    
  800a30:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800a32:	eb 27                	jmp    800a5b <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a34:	4f                   	dec    %edi
  800a35:	4e                   	dec    %esi
  800a36:	fd                   	std    
  800a37:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800a39:	eb 20                	jmp    800a5b <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3b:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a41:	75 15                	jne    800a58 <memmove+0x64>
  800a43:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a49:	75 0d                	jne    800a58 <memmove+0x64>
  800a4b:	f6 c1 03             	test   $0x3,%cl
  800a4e:	75 08                	jne    800a58 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800a50:	c1 e9 02             	shr    $0x2,%ecx
  800a53:	fc                   	cld    
  800a54:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800a56:	eb 03                	jmp    800a5b <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a58:	fc                   	cld    
  800a59:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a5b:	5e                   	pop    %esi
  800a5c:	5f                   	pop    %edi
  800a5d:	c9                   	leave  
  800a5e:	c3                   	ret    

00800a5f <memcpy>:

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
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a62:	ff 75 10             	pushl  0x10(%ebp)
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	ff 75 08             	pushl  0x8(%ebp)
  800a6b:	e8 84 ff ff ff       	call   8009f4 <memmove>
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800a76:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800a79:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a7c:	8b 55 10             	mov    0x10(%ebp),%edx
  800a7f:	4a                   	dec    %edx
  800a80:	83 fa ff             	cmp    $0xffffffff,%edx
  800a83:	74 1a                	je     800a9f <memcmp+0x2d>
  800a85:	8a 01                	mov    (%ecx),%al
  800a87:	3a 03                	cmp    (%ebx),%al
  800a89:	74 0c                	je     800a97 <memcmp+0x25>
  800a8b:	0f b6 d0             	movzbl %al,%edx
  800a8e:	0f b6 03             	movzbl (%ebx),%eax
  800a91:	29 c2                	sub    %eax,%edx
  800a93:	89 d0                	mov    %edx,%eax
  800a95:	eb 0d                	jmp    800aa4 <memcmp+0x32>
  800a97:	41                   	inc    %ecx
  800a98:	43                   	inc    %ebx
  800a99:	4a                   	dec    %edx
  800a9a:	83 fa ff             	cmp    $0xffffffff,%edx
  800a9d:	75 e6                	jne    800a85 <memcmp+0x13>
	}

	return 0;
  800a9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa4:	5b                   	pop    %ebx
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800aad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ab5:	39 d0                	cmp    %edx,%eax
  800ab7:	73 09                	jae    800ac2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ab9:	38 08                	cmp    %cl,(%eax)
  800abb:	74 05                	je     800ac2 <memfind+0x1b>
  800abd:	40                   	inc    %eax
  800abe:	39 d0                	cmp    %edx,%eax
  800ac0:	72 f7                	jb     800ab9 <memfind+0x12>
			break;
	return (void *) s;
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	57                   	push   %edi
  800ac8:	56                   	push   %esi
  800ac9:	53                   	push   %ebx
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800ad3:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800ad8:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800add:	80 3a 20             	cmpb   $0x20,(%edx)
  800ae0:	74 05                	je     800ae7 <strtol+0x23>
  800ae2:	80 3a 09             	cmpb   $0x9,(%edx)
  800ae5:	75 0b                	jne    800af2 <strtol+0x2e>
  800ae7:	42                   	inc    %edx
  800ae8:	80 3a 20             	cmpb   $0x20,(%edx)
  800aeb:	74 fa                	je     800ae7 <strtol+0x23>
  800aed:	80 3a 09             	cmpb   $0x9,(%edx)
  800af0:	74 f5                	je     800ae7 <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800af2:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800af5:	75 03                	jne    800afa <strtol+0x36>
		s++;
  800af7:	42                   	inc    %edx
  800af8:	eb 0b                	jmp    800b05 <strtol+0x41>
	else if (*s == '-')
  800afa:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800afd:	75 06                	jne    800b05 <strtol+0x41>
		s++, neg = 1;
  800aff:	42                   	inc    %edx
  800b00:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b05:	85 c9                	test   %ecx,%ecx
  800b07:	74 05                	je     800b0e <strtol+0x4a>
  800b09:	83 f9 10             	cmp    $0x10,%ecx
  800b0c:	75 15                	jne    800b23 <strtol+0x5f>
  800b0e:	80 3a 30             	cmpb   $0x30,(%edx)
  800b11:	75 10                	jne    800b23 <strtol+0x5f>
  800b13:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b17:	75 0a                	jne    800b23 <strtol+0x5f>
		s += 2, base = 16;
  800b19:	83 c2 02             	add    $0x2,%edx
  800b1c:	b9 10 00 00 00       	mov    $0x10,%ecx
  800b21:	eb 14                	jmp    800b37 <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800b23:	85 c9                	test   %ecx,%ecx
  800b25:	75 10                	jne    800b37 <strtol+0x73>
  800b27:	80 3a 30             	cmpb   $0x30,(%edx)
  800b2a:	75 05                	jne    800b31 <strtol+0x6d>
		s++, base = 8;
  800b2c:	42                   	inc    %edx
  800b2d:	b1 08                	mov    $0x8,%cl
  800b2f:	eb 06                	jmp    800b37 <strtol+0x73>
	else if (base == 0)
  800b31:	85 c9                	test   %ecx,%ecx
  800b33:	75 02                	jne    800b37 <strtol+0x73>
		base = 10;
  800b35:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b37:	8a 02                	mov    (%edx),%al
  800b39:	83 e8 30             	sub    $0x30,%eax
  800b3c:	3c 09                	cmp    $0x9,%al
  800b3e:	77 08                	ja     800b48 <strtol+0x84>
			dig = *s - '0';
  800b40:	0f be 02             	movsbl (%edx),%eax
  800b43:	83 e8 30             	sub    $0x30,%eax
  800b46:	eb 20                	jmp    800b68 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800b48:	8a 02                	mov    (%edx),%al
  800b4a:	83 e8 61             	sub    $0x61,%eax
  800b4d:	3c 19                	cmp    $0x19,%al
  800b4f:	77 08                	ja     800b59 <strtol+0x95>
			dig = *s - 'a' + 10;
  800b51:	0f be 02             	movsbl (%edx),%eax
  800b54:	83 e8 57             	sub    $0x57,%eax
  800b57:	eb 0f                	jmp    800b68 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800b59:	8a 02                	mov    (%edx),%al
  800b5b:	83 e8 41             	sub    $0x41,%eax
  800b5e:	3c 19                	cmp    $0x19,%al
  800b60:	77 12                	ja     800b74 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800b62:	0f be 02             	movsbl (%edx),%eax
  800b65:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800b68:	39 c8                	cmp    %ecx,%eax
  800b6a:	7d 08                	jge    800b74 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800b6c:	42                   	inc    %edx
  800b6d:	0f af d9             	imul   %ecx,%ebx
  800b70:	01 c3                	add    %eax,%ebx
  800b72:	eb c3                	jmp    800b37 <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b74:	85 f6                	test   %esi,%esi
  800b76:	74 02                	je     800b7a <strtol+0xb6>
		*endptr = (char *) s;
  800b78:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b7a:	89 d8                	mov    %ebx,%eax
  800b7c:	85 ff                	test   %edi,%edi
  800b7e:	74 02                	je     800b82 <strtol+0xbe>
  800b80:	f7 d8                	neg    %eax
}
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5f                   	pop    %edi
  800b85:	c9                   	leave  
  800b86:	c3                   	ret    
	...

00800b88 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	57                   	push   %edi
  800b8c:	56                   	push   %esi
  800b8d:	53                   	push   %ebx
  800b8e:	83 ec 04             	sub    $0x4,%esp
  800b91:	8b 55 08             	mov    0x8(%ebp),%edx
  800b94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b97:	bf 00 00 00 00       	mov    $0x0,%edi
  800b9c:	89 f8                	mov    %edi,%eax
  800b9e:	89 fb                	mov    %edi,%ebx
  800ba0:	89 fe                	mov    %edi,%esi
  800ba2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ba4:	83 c4 04             	add    $0x4,%esp
  800ba7:	5b                   	pop    %ebx
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <sys_cgetc>:

int
sys_cgetc(void)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	57                   	push   %edi
  800bb0:	56                   	push   %esi
  800bb1:	53                   	push   %ebx
  800bb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb7:	bf 00 00 00 00       	mov    $0x0,%edi
  800bbc:	89 fa                	mov    %edi,%edx
  800bbe:	89 f9                	mov    %edi,%ecx
  800bc0:	89 fb                	mov    %edi,%ebx
  800bc2:	89 fe                	mov    %edi,%esi
  800bc4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bc6:	5b                   	pop    %ebx
  800bc7:	5e                   	pop    %esi
  800bc8:	5f                   	pop    %edi
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	57                   	push   %edi
  800bcf:	56                   	push   %esi
  800bd0:	53                   	push   %ebx
  800bd1:	83 ec 0c             	sub    $0xc,%esp
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	b8 03 00 00 00       	mov    $0x3,%eax
  800bdc:	bf 00 00 00 00       	mov    $0x0,%edi
  800be1:	89 f9                	mov    %edi,%ecx
  800be3:	89 fb                	mov    %edi,%ebx
  800be5:	89 fe                	mov    %edi,%esi
  800be7:	cd 30                	int    $0x30
  800be9:	85 c0                	test   %eax,%eax
  800beb:	7e 17                	jle    800c04 <sys_env_destroy+0x39>
  800bed:	83 ec 0c             	sub    $0xc,%esp
  800bf0:	50                   	push   %eax
  800bf1:	6a 03                	push   $0x3
  800bf3:	68 10 2f 80 00       	push   $0x802f10
  800bf8:	6a 23                	push   $0x23
  800bfa:	68 2d 2f 80 00       	push   $0x802f2d
  800bff:	e8 80 f5 ff ff       	call   800184 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c04:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	c9                   	leave  
  800c0b:	c3                   	ret    

00800c0c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	b8 02 00 00 00       	mov    $0x2,%eax
  800c17:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1c:	89 fa                	mov    %edi,%edx
  800c1e:	89 f9                	mov    %edi,%ecx
  800c20:	89 fb                	mov    %edi,%ebx
  800c22:	89 fe                	mov    %edi,%esi
  800c24:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c26:	5b                   	pop    %ebx
  800c27:	5e                   	pop    %esi
  800c28:	5f                   	pop    %edi
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <sys_yield>:

void
sys_yield(void)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c36:	bf 00 00 00 00       	mov    $0x0,%edi
  800c3b:	89 fa                	mov    %edi,%edx
  800c3d:	89 f9                	mov    %edi,%ecx
  800c3f:	89 fb                	mov    %edi,%ebx
  800c41:	89 fe                	mov    %edi,%esi
  800c43:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    

00800c4a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
  800c50:	83 ec 0c             	sub    $0xc,%esp
  800c53:	8b 55 08             	mov    0x8(%ebp),%edx
  800c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c59:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5c:	b8 04 00 00 00       	mov    $0x4,%eax
  800c61:	bf 00 00 00 00       	mov    $0x0,%edi
  800c66:	89 fe                	mov    %edi,%esi
  800c68:	cd 30                	int    $0x30
  800c6a:	85 c0                	test   %eax,%eax
  800c6c:	7e 17                	jle    800c85 <sys_page_alloc+0x3b>
  800c6e:	83 ec 0c             	sub    $0xc,%esp
  800c71:	50                   	push   %eax
  800c72:	6a 04                	push   $0x4
  800c74:	68 10 2f 80 00       	push   $0x802f10
  800c79:	6a 23                	push   $0x23
  800c7b:	68 2d 2f 80 00       	push   $0x802f2d
  800c80:	e8 ff f4 ff ff       	call   800184 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c85:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c88:	5b                   	pop    %ebx
  800c89:	5e                   	pop    %esi
  800c8a:	5f                   	pop    %edi
  800c8b:	c9                   	leave  
  800c8c:	c3                   	ret    

00800c8d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
  800c93:	83 ec 0c             	sub    $0xc,%esp
  800c96:	8b 55 08             	mov    0x8(%ebp),%edx
  800c99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca2:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca5:	b8 05 00 00 00       	mov    $0x5,%eax
  800caa:	cd 30                	int    $0x30
  800cac:	85 c0                	test   %eax,%eax
  800cae:	7e 17                	jle    800cc7 <sys_page_map+0x3a>
  800cb0:	83 ec 0c             	sub    $0xc,%esp
  800cb3:	50                   	push   %eax
  800cb4:	6a 05                	push   $0x5
  800cb6:	68 10 2f 80 00       	push   $0x802f10
  800cbb:	6a 23                	push   $0x23
  800cbd:	68 2d 2f 80 00       	push   $0x802f2d
  800cc2:	e8 bd f4 ff ff       	call   800184 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cc7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800cca:	5b                   	pop    %ebx
  800ccb:	5e                   	pop    %esi
  800ccc:	5f                   	pop    %edi
  800ccd:	c9                   	leave  
  800cce:	c3                   	ret    

00800ccf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	57                   	push   %edi
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
  800cd5:	83 ec 0c             	sub    $0xc,%esp
  800cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cde:	b8 06 00 00 00       	mov    $0x6,%eax
  800ce3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce8:	89 fb                	mov    %edi,%ebx
  800cea:	89 fe                	mov    %edi,%esi
  800cec:	cd 30                	int    $0x30
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	7e 17                	jle    800d09 <sys_page_unmap+0x3a>
  800cf2:	83 ec 0c             	sub    $0xc,%esp
  800cf5:	50                   	push   %eax
  800cf6:	6a 06                	push   $0x6
  800cf8:	68 10 2f 80 00       	push   $0x802f10
  800cfd:	6a 23                	push   $0x23
  800cff:	68 2d 2f 80 00       	push   $0x802f2d
  800d04:	e8 7b f4 ff ff       	call   800184 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d09:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d0c:	5b                   	pop    %ebx
  800d0d:	5e                   	pop    %esi
  800d0e:	5f                   	pop    %edi
  800d0f:	c9                   	leave  
  800d10:	c3                   	ret    

00800d11 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	57                   	push   %edi
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
  800d17:	83 ec 0c             	sub    $0xc,%esp
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d20:	b8 08 00 00 00       	mov    $0x8,%eax
  800d25:	bf 00 00 00 00       	mov    $0x0,%edi
  800d2a:	89 fb                	mov    %edi,%ebx
  800d2c:	89 fe                	mov    %edi,%esi
  800d2e:	cd 30                	int    $0x30
  800d30:	85 c0                	test   %eax,%eax
  800d32:	7e 17                	jle    800d4b <sys_env_set_status+0x3a>
  800d34:	83 ec 0c             	sub    $0xc,%esp
  800d37:	50                   	push   %eax
  800d38:	6a 08                	push   $0x8
  800d3a:	68 10 2f 80 00       	push   $0x802f10
  800d3f:	6a 23                	push   $0x23
  800d41:	68 2d 2f 80 00       	push   $0x802f2d
  800d46:	e8 39 f4 ff ff       	call   800184 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d4b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	83 ec 0c             	sub    $0xc,%esp
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d62:	b8 09 00 00 00       	mov    $0x9,%eax
  800d67:	bf 00 00 00 00       	mov    $0x0,%edi
  800d6c:	89 fb                	mov    %edi,%ebx
  800d6e:	89 fe                	mov    %edi,%esi
  800d70:	cd 30                	int    $0x30
  800d72:	85 c0                	test   %eax,%eax
  800d74:	7e 17                	jle    800d8d <sys_env_set_trapframe+0x3a>
  800d76:	83 ec 0c             	sub    $0xc,%esp
  800d79:	50                   	push   %eax
  800d7a:	6a 09                	push   $0x9
  800d7c:	68 10 2f 80 00       	push   $0x802f10
  800d81:	6a 23                	push   $0x23
  800d83:	68 2d 2f 80 00       	push   $0x802f2d
  800d88:	e8 f7 f3 ff ff       	call   800184 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d8d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d90:	5b                   	pop    %ebx
  800d91:	5e                   	pop    %esi
  800d92:	5f                   	pop    %edi
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	57                   	push   %edi
  800d99:	56                   	push   %esi
  800d9a:	53                   	push   %ebx
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da9:	bf 00 00 00 00       	mov    $0x0,%edi
  800dae:	89 fb                	mov    %edi,%ebx
  800db0:	89 fe                	mov    %edi,%esi
  800db2:	cd 30                	int    $0x30
  800db4:	85 c0                	test   %eax,%eax
  800db6:	7e 17                	jle    800dcf <sys_env_set_pgfault_upcall+0x3a>
  800db8:	83 ec 0c             	sub    $0xc,%esp
  800dbb:	50                   	push   %eax
  800dbc:	6a 0a                	push   $0xa
  800dbe:	68 10 2f 80 00       	push   $0x802f10
  800dc3:	6a 23                	push   $0x23
  800dc5:	68 2d 2f 80 00       	push   $0x802f2d
  800dca:	e8 b5 f3 ff ff       	call   800184 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dcf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800dd2:	5b                   	pop    %ebx
  800dd3:	5e                   	pop    %esi
  800dd4:	5f                   	pop    %edi
  800dd5:	c9                   	leave  
  800dd6:	c3                   	ret    

00800dd7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	8b 55 08             	mov    0x8(%ebp),%edx
  800de0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de9:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dee:	be 00 00 00 00       	mov    $0x0,%esi
  800df3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5f                   	pop    %edi
  800df8:	c9                   	leave  
  800df9:	c3                   	ret    

00800dfa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 0c             	sub    $0xc,%esp
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e0b:	bf 00 00 00 00       	mov    $0x0,%edi
  800e10:	89 f9                	mov    %edi,%ecx
  800e12:	89 fb                	mov    %edi,%ebx
  800e14:	89 fe                	mov    %edi,%esi
  800e16:	cd 30                	int    $0x30
  800e18:	85 c0                	test   %eax,%eax
  800e1a:	7e 17                	jle    800e33 <sys_ipc_recv+0x39>
  800e1c:	83 ec 0c             	sub    $0xc,%esp
  800e1f:	50                   	push   %eax
  800e20:	6a 0d                	push   $0xd
  800e22:	68 10 2f 80 00       	push   $0x802f10
  800e27:	6a 23                	push   $0x23
  800e29:	68 2d 2f 80 00       	push   $0x802f2d
  800e2e:	e8 51 f3 ff ff       	call   800184 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e33:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e36:	5b                   	pop    %ebx
  800e37:	5e                   	pop    %esi
  800e38:	5f                   	pop    %edi
  800e39:	c9                   	leave  
  800e3a:	c3                   	ret    

00800e3b <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	57                   	push   %edi
  800e3f:	56                   	push   %esi
  800e40:	53                   	push   %ebx
  800e41:	83 ec 0c             	sub    $0xc,%esp
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e4f:	bf 00 00 00 00       	mov    $0x0,%edi
  800e54:	89 fb                	mov    %edi,%ebx
  800e56:	89 fe                	mov    %edi,%esi
  800e58:	cd 30                	int    $0x30
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	7e 17                	jle    800e75 <sys_transmit_packet+0x3a>
  800e5e:	83 ec 0c             	sub    $0xc,%esp
  800e61:	50                   	push   %eax
  800e62:	6a 10                	push   $0x10
  800e64:	68 10 2f 80 00       	push   $0x802f10
  800e69:	6a 23                	push   $0x23
  800e6b:	68 2d 2f 80 00       	push   $0x802f2d
  800e70:	e8 0f f3 ff ff       	call   800184 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800e75:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e78:	5b                   	pop    %ebx
  800e79:	5e                   	pop    %esi
  800e7a:	5f                   	pop    %edi
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	57                   	push   %edi
  800e81:	56                   	push   %esi
  800e82:	53                   	push   %ebx
  800e83:	83 ec 0c             	sub    $0xc,%esp
  800e86:	8b 55 08             	mov    0x8(%ebp),%edx
  800e89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8c:	b8 11 00 00 00       	mov    $0x11,%eax
  800e91:	bf 00 00 00 00       	mov    $0x0,%edi
  800e96:	89 fb                	mov    %edi,%ebx
  800e98:	89 fe                	mov    %edi,%esi
  800e9a:	cd 30                	int    $0x30
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	7e 17                	jle    800eb7 <sys_receive_packet+0x3a>
  800ea0:	83 ec 0c             	sub    $0xc,%esp
  800ea3:	50                   	push   %eax
  800ea4:	6a 11                	push   $0x11
  800ea6:	68 10 2f 80 00       	push   $0x802f10
  800eab:	6a 23                	push   $0x23
  800ead:	68 2d 2f 80 00       	push   $0x802f2d
  800eb2:	e8 cd f2 ff ff       	call   800184 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800eb7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800eba:	5b                   	pop    %ebx
  800ebb:	5e                   	pop    %esi
  800ebc:	5f                   	pop    %edi
  800ebd:	c9                   	leave  
  800ebe:	c3                   	ret    

00800ebf <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	57                   	push   %edi
  800ec3:	56                   	push   %esi
  800ec4:	53                   	push   %ebx
  800ec5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eca:	bf 00 00 00 00       	mov    $0x0,%edi
  800ecf:	89 fa                	mov    %edi,%edx
  800ed1:	89 f9                	mov    %edi,%ecx
  800ed3:	89 fb                	mov    %edi,%ebx
  800ed5:	89 fe                	mov    %edi,%esi
  800ed7:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ed9:	5b                   	pop    %ebx
  800eda:	5e                   	pop    %esi
  800edb:	5f                   	pop    %edi
  800edc:	c9                   	leave  
  800edd:	c3                   	ret    

00800ede <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	57                   	push   %edi
  800ee2:	56                   	push   %esi
  800ee3:	53                   	push   %ebx
  800ee4:	83 ec 0c             	sub    $0xc,%esp
  800ee7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eea:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eef:	bf 00 00 00 00       	mov    $0x0,%edi
  800ef4:	89 f9                	mov    %edi,%ecx
  800ef6:	89 fb                	mov    %edi,%ebx
  800ef8:	89 fe                	mov    %edi,%esi
  800efa:	cd 30                	int    $0x30
  800efc:	85 c0                	test   %eax,%eax
  800efe:	7e 17                	jle    800f17 <sys_map_receive_buffers+0x39>
  800f00:	83 ec 0c             	sub    $0xc,%esp
  800f03:	50                   	push   %eax
  800f04:	6a 0e                	push   $0xe
  800f06:	68 10 2f 80 00       	push   $0x802f10
  800f0b:	6a 23                	push   $0x23
  800f0d:	68 2d 2f 80 00       	push   $0x802f2d
  800f12:	e8 6d f2 ff ff       	call   800184 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800f17:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	c9                   	leave  
  800f1e:	c3                   	ret    

00800f1f <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
  800f25:	83 ec 0c             	sub    $0xc,%esp
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	b8 12 00 00 00       	mov    $0x12,%eax
  800f30:	bf 00 00 00 00       	mov    $0x0,%edi
  800f35:	89 f9                	mov    %edi,%ecx
  800f37:	89 fb                	mov    %edi,%ebx
  800f39:	89 fe                	mov    %edi,%esi
  800f3b:	cd 30                	int    $0x30
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	7e 17                	jle    800f58 <sys_receive_packet_zerocopy+0x39>
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	50                   	push   %eax
  800f45:	6a 12                	push   $0x12
  800f47:	68 10 2f 80 00       	push   $0x802f10
  800f4c:	6a 23                	push   $0x23
  800f4e:	68 2d 2f 80 00       	push   $0x802f2d
  800f53:	e8 2c f2 ff ff       	call   800184 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800f58:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f5b:	5b                   	pop    %ebx
  800f5c:	5e                   	pop    %esi
  800f5d:	5f                   	pop    %edi
  800f5e:	c9                   	leave  
  800f5f:	c3                   	ret    

00800f60 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	57                   	push   %edi
  800f64:	56                   	push   %esi
  800f65:	53                   	push   %ebx
  800f66:	83 ec 0c             	sub    $0xc,%esp
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	b8 13 00 00 00       	mov    $0x13,%eax
  800f74:	bf 00 00 00 00       	mov    $0x0,%edi
  800f79:	89 fb                	mov    %edi,%ebx
  800f7b:	89 fe                	mov    %edi,%esi
  800f7d:	cd 30                	int    $0x30
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	7e 17                	jle    800f9a <sys_env_set_priority+0x3a>
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	50                   	push   %eax
  800f87:	6a 13                	push   $0x13
  800f89:	68 10 2f 80 00       	push   $0x802f10
  800f8e:	6a 23                	push   $0x23
  800f90:	68 2d 2f 80 00       	push   $0x802f2d
  800f95:	e8 ea f1 ff ff       	call   800184 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  800f9a:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f9d:	5b                   	pop    %ebx
  800f9e:	5e                   	pop    %esi
  800f9f:	5f                   	pop    %edi
  800fa0:	c9                   	leave  
  800fa1:	c3                   	ret    
	...

00800fa4 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  800faa:	ff 75 08             	pushl  0x8(%ebp)
  800fad:	e8 0a 00 00 00       	call   800fbc <fd2num>
  800fb2:	c1 e0 16             	shl    $0x16,%eax
  800fb5:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <fd2num>:

int
fd2num(struct Fd *fd)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	05 00 00 40 30       	add    $0x30400000,%eax
  800fc7:	c1 e8 0c             	shr    $0xc,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <fd_alloc>:

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
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
  800fd2:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fd5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fda:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  800fdf:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  800fe4:	89 c8                	mov    %ecx,%eax
  800fe6:	c1 e0 0c             	shl    $0xc,%eax
  800fe9:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  800fef:	89 d0                	mov    %edx,%eax
  800ff1:	c1 e8 16             	shr    $0x16,%eax
  800ff4:	8b 04 86             	mov    (%esi,%eax,4),%eax
  800ff7:	a8 01                	test   $0x1,%al
  800ff9:	74 0c                	je     801007 <fd_alloc+0x3b>
  800ffb:	89 d0                	mov    %edx,%eax
  800ffd:	c1 e8 0c             	shr    $0xc,%eax
  801000:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  801003:	a8 01                	test   $0x1,%al
  801005:	75 09                	jne    801010 <fd_alloc+0x44>
			*fd_store = fd;
  801007:	89 17                	mov    %edx,(%edi)
			return 0;
  801009:	b8 00 00 00 00       	mov    $0x0,%eax
  80100e:	eb 11                	jmp    801021 <fd_alloc+0x55>
  801010:	41                   	inc    %ecx
  801011:	83 f9 1f             	cmp    $0x1f,%ecx
  801014:	7e ce                	jle    800fe4 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  801016:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  80101c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  80102c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801031:	83 f8 1f             	cmp    $0x1f,%eax
  801034:	77 3a                	ja     801070 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  801036:	c1 e0 0c             	shl    $0xc,%eax
  801039:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  80103f:	89 d0                	mov    %edx,%eax
  801041:	c1 e8 16             	shr    $0x16,%eax
  801044:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80104b:	a8 01                	test   $0x1,%al
  80104d:	74 10                	je     80105f <fd_lookup+0x39>
  80104f:	89 d0                	mov    %edx,%eax
  801051:	c1 e8 0c             	shr    $0xc,%eax
  801054:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80105b:	a8 01                	test   $0x1,%al
  80105d:	75 07                	jne    801066 <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  80105f:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801064:	eb 0a                	jmp    801070 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  801066:	8b 45 0c             	mov    0xc(%ebp),%eax
  801069:	89 10                	mov    %edx,(%eax)
	return 0;
  80106b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801070:	89 d0                	mov    %edx,%eax
  801072:	c9                   	leave  
  801073:	c3                   	ret    

00801074 <fd_close>:

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
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
  801077:	56                   	push   %esi
  801078:	53                   	push   %ebx
  801079:	83 ec 10             	sub    $0x10,%esp
  80107c:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80107f:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801082:	50                   	push   %eax
  801083:	56                   	push   %esi
  801084:	e8 33 ff ff ff       	call   800fbc <fd2num>
  801089:	89 04 24             	mov    %eax,(%esp)
  80108c:	e8 95 ff ff ff       	call   801026 <fd_lookup>
  801091:	89 c3                	mov    %eax,%ebx
  801093:	83 c4 08             	add    $0x8,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	78 05                	js     80109f <fd_close+0x2b>
  80109a:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  80109d:	74 0f                	je     8010ae <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80109f:	89 d8                	mov    %ebx,%eax
  8010a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a5:	75 3a                	jne    8010e1 <fd_close+0x6d>
  8010a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ac:	eb 33                	jmp    8010e1 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8010ae:	83 ec 08             	sub    $0x8,%esp
  8010b1:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8010b4:	50                   	push   %eax
  8010b5:	ff 36                	pushl  (%esi)
  8010b7:	e8 2c 00 00 00       	call   8010e8 <dev_lookup>
  8010bc:	89 c3                	mov    %eax,%ebx
  8010be:	83 c4 10             	add    $0x10,%esp
  8010c1:	85 c0                	test   %eax,%eax
  8010c3:	78 0f                	js     8010d4 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8010c5:	83 ec 0c             	sub    $0xc,%esp
  8010c8:	56                   	push   %esi
  8010c9:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8010cc:	ff 50 10             	call   *0x10(%eax)
  8010cf:	89 c3                	mov    %eax,%ebx
  8010d1:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010d4:	83 ec 08             	sub    $0x8,%esp
  8010d7:	56                   	push   %esi
  8010d8:	6a 00                	push   $0x0
  8010da:	e8 f0 fb ff ff       	call   800ccf <sys_page_unmap>
	return r;
  8010df:	89 d8                	mov    %ebx,%eax
}
  8010e1:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8010e4:	5b                   	pop    %ebx
  8010e5:	5e                   	pop    %esi
  8010e6:	c9                   	leave  
  8010e7:	c3                   	ret    

008010e8 <dev_lookup>:


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
  8010e8:	55                   	push   %ebp
  8010e9:	89 e5                	mov    %esp,%ebp
  8010eb:	56                   	push   %esi
  8010ec:	53                   	push   %ebx
  8010ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8010f0:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  8010f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f8:	83 3d 04 70 80 00 00 	cmpl   $0x0,0x807004
  8010ff:	74 1c                	je     80111d <dev_lookup+0x35>
  801101:	b9 04 70 80 00       	mov    $0x807004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  801106:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  801109:	39 18                	cmp    %ebx,(%eax)
  80110b:	75 09                	jne    801116 <dev_lookup+0x2e>
			*dev = devtab[i];
  80110d:	89 06                	mov    %eax,(%esi)
			return 0;
  80110f:	b8 00 00 00 00       	mov    $0x0,%eax
  801114:	eb 29                	jmp    80113f <dev_lookup+0x57>
  801116:	42                   	inc    %edx
  801117:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  80111b:	75 e9                	jne    801106 <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80111d:	83 ec 04             	sub    $0x4,%esp
  801120:	53                   	push   %ebx
  801121:	a1 80 70 80 00       	mov    0x807080,%eax
  801126:	8b 40 4c             	mov    0x4c(%eax),%eax
  801129:	50                   	push   %eax
  80112a:	68 3c 2f 80 00       	push   $0x802f3c
  80112f:	e8 40 f1 ff ff       	call   800274 <cprintf>
	*dev = 0;
  801134:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  80113a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80113f:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801142:	5b                   	pop    %ebx
  801143:	5e                   	pop    %esi
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <close>:

int
close(int fdnum)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80114c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80114f:	50                   	push   %eax
  801150:	ff 75 08             	pushl  0x8(%ebp)
  801153:	e8 ce fe ff ff       	call   801026 <fd_lookup>
  801158:	83 c4 08             	add    $0x8,%esp
		return r;
  80115b:	89 c2                	mov    %eax,%edx
  80115d:	85 c0                	test   %eax,%eax
  80115f:	78 0f                	js     801170 <close+0x2a>
	else
		return fd_close(fd, 1);
  801161:	83 ec 08             	sub    $0x8,%esp
  801164:	6a 01                	push   $0x1
  801166:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801169:	e8 06 ff ff ff       	call   801074 <fd_close>
  80116e:	89 c2                	mov    %eax,%edx
}
  801170:	89 d0                	mov    %edx,%eax
  801172:	c9                   	leave  
  801173:	c3                   	ret    

00801174 <close_all>:

void
close_all(void)
{
  801174:	55                   	push   %ebp
  801175:	89 e5                	mov    %esp,%ebp
  801177:	53                   	push   %ebx
  801178:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80117b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801180:	83 ec 0c             	sub    $0xc,%esp
  801183:	53                   	push   %ebx
  801184:	e8 bd ff ff ff       	call   801146 <close>
  801189:	83 c4 10             	add    $0x10,%esp
  80118c:	43                   	inc    %ebx
  80118d:	83 fb 1f             	cmp    $0x1f,%ebx
  801190:	7e ee                	jle    801180 <close_all+0xc>
}
  801192:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801195:	c9                   	leave  
  801196:	c3                   	ret    

00801197 <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	57                   	push   %edi
  80119b:	56                   	push   %esi
  80119c:	53                   	push   %ebx
  80119d:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011a0:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8011a3:	50                   	push   %eax
  8011a4:	ff 75 08             	pushl  0x8(%ebp)
  8011a7:	e8 7a fe ff ff       	call   801026 <fd_lookup>
  8011ac:	89 c6                	mov    %eax,%esi
  8011ae:	83 c4 08             	add    $0x8,%esp
  8011b1:	85 f6                	test   %esi,%esi
  8011b3:	0f 88 f8 00 00 00    	js     8012b1 <dup+0x11a>
		return r;
	close(newfdnum);
  8011b9:	83 ec 0c             	sub    $0xc,%esp
  8011bc:	ff 75 0c             	pushl  0xc(%ebp)
  8011bf:	e8 82 ff ff ff       	call   801146 <close>

	newfd = INDEX2FD(newfdnum);
  8011c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c7:	c1 e0 0c             	shl    $0xc,%eax
  8011ca:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8011cf:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8011d2:	83 c4 04             	add    $0x4,%esp
  8011d5:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8011d8:	e8 c7 fd ff ff       	call   800fa4 <fd2data>
  8011dd:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  8011df:	83 c4 04             	add    $0x4,%esp
  8011e2:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8011e5:	e8 ba fd ff ff       	call   800fa4 <fd2data>
  8011ea:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  8011ed:	89 f8                	mov    %edi,%eax
  8011ef:	c1 e8 16             	shr    $0x16,%eax
  8011f2:	83 c4 10             	add    $0x10,%esp
  8011f5:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	74 48                	je     801248 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801200:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  801205:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  801208:	89 d0                	mov    %edx,%eax
  80120a:	c1 e8 0c             	shr    $0xc,%eax
  80120d:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  801214:	a8 01                	test   $0x1,%al
  801216:	74 22                	je     80123a <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801218:	83 ec 0c             	sub    $0xc,%esp
  80121b:	25 07 0e 00 00       	and    $0xe07,%eax
  801220:	50                   	push   %eax
  801221:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801224:	01 d8                	add    %ebx,%eax
  801226:	50                   	push   %eax
  801227:	6a 00                	push   $0x0
  801229:	52                   	push   %edx
  80122a:	6a 00                	push   $0x0
  80122c:	e8 5c fa ff ff       	call   800c8d <sys_page_map>
  801231:	89 c6                	mov    %eax,%esi
  801233:	83 c4 20             	add    $0x20,%esp
  801236:	85 c0                	test   %eax,%eax
  801238:	78 3f                	js     801279 <dup+0xe2>
  80123a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801240:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801246:	7e bd                	jle    801205 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80124e:	89 d0                	mov    %edx,%eax
  801250:	c1 e8 0c             	shr    $0xc,%eax
  801253:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80125a:	25 07 0e 00 00       	and    $0xe07,%eax
  80125f:	50                   	push   %eax
  801260:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801263:	6a 00                	push   $0x0
  801265:	52                   	push   %edx
  801266:	6a 00                	push   $0x0
  801268:	e8 20 fa ff ff       	call   800c8d <sys_page_map>
  80126d:	89 c6                	mov    %eax,%esi
  80126f:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801272:	8b 45 0c             	mov    0xc(%ebp),%eax
  801275:	85 f6                	test   %esi,%esi
  801277:	79 38                	jns    8012b1 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801279:	83 ec 08             	sub    $0x8,%esp
  80127c:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80127f:	6a 00                	push   $0x0
  801281:	e8 49 fa ff ff       	call   800ccf <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  801286:	bb 00 00 00 00       	mov    $0x0,%ebx
  80128b:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  80128e:	83 ec 08             	sub    $0x8,%esp
  801291:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801294:	01 d8                	add    %ebx,%eax
  801296:	50                   	push   %eax
  801297:	6a 00                	push   $0x0
  801299:	e8 31 fa ff ff       	call   800ccf <sys_page_unmap>
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012a7:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8012ad:	7e df                	jle    80128e <dup+0xf7>
	return r;
  8012af:	89 f0                	mov    %esi,%eax
}
  8012b1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8012b4:	5b                   	pop    %ebx
  8012b5:	5e                   	pop    %esi
  8012b6:	5f                   	pop    %edi
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
  8012bc:	53                   	push   %ebx
  8012bd:	83 ec 14             	sub    $0x14,%esp
  8012c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c3:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8012c6:	50                   	push   %eax
  8012c7:	53                   	push   %ebx
  8012c8:	e8 59 fd ff ff       	call   801026 <fd_lookup>
  8012cd:	89 c2                	mov    %eax,%edx
  8012cf:	83 c4 08             	add    $0x8,%esp
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	78 1a                	js     8012f0 <read+0x37>
  8012d6:	83 ec 08             	sub    $0x8,%esp
  8012d9:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8012dc:	50                   	push   %eax
  8012dd:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8012e0:	ff 30                	pushl  (%eax)
  8012e2:	e8 01 fe ff ff       	call   8010e8 <dev_lookup>
  8012e7:	89 c2                	mov    %eax,%edx
  8012e9:	83 c4 10             	add    $0x10,%esp
  8012ec:	85 c0                	test   %eax,%eax
  8012ee:	79 04                	jns    8012f4 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8012f0:	89 d0                	mov    %edx,%eax
  8012f2:	eb 50                	jmp    801344 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012f4:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8012f7:	8b 40 08             	mov    0x8(%eax),%eax
  8012fa:	83 e0 03             	and    $0x3,%eax
  8012fd:	83 f8 01             	cmp    $0x1,%eax
  801300:	75 1e                	jne    801320 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801302:	83 ec 04             	sub    $0x4,%esp
  801305:	53                   	push   %ebx
  801306:	a1 80 70 80 00       	mov    0x807080,%eax
  80130b:	8b 40 4c             	mov    0x4c(%eax),%eax
  80130e:	50                   	push   %eax
  80130f:	68 7d 2f 80 00       	push   $0x802f7d
  801314:	e8 5b ef ff ff       	call   800274 <cprintf>
		return -E_INVAL;
  801319:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80131e:	eb 24                	jmp    801344 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801320:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801323:	ff 70 04             	pushl  0x4(%eax)
  801326:	ff 75 10             	pushl  0x10(%ebp)
  801329:	ff 75 0c             	pushl  0xc(%ebp)
  80132c:	50                   	push   %eax
  80132d:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801330:	ff 50 08             	call   *0x8(%eax)
  801333:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801335:	83 c4 10             	add    $0x10,%esp
  801338:	85 c0                	test   %eax,%eax
  80133a:	78 06                	js     801342 <read+0x89>
		fd->fd_offset += r;
  80133c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80133f:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801342:	89 d0                	mov    %edx,%eax
}
  801344:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	57                   	push   %edi
  80134d:	56                   	push   %esi
  80134e:	53                   	push   %ebx
  80134f:	83 ec 0c             	sub    $0xc,%esp
  801352:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801355:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801358:	bb 00 00 00 00       	mov    $0x0,%ebx
  80135d:	39 f3                	cmp    %esi,%ebx
  80135f:	73 25                	jae    801386 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801361:	83 ec 04             	sub    $0x4,%esp
  801364:	89 f0                	mov    %esi,%eax
  801366:	29 d8                	sub    %ebx,%eax
  801368:	50                   	push   %eax
  801369:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80136c:	50                   	push   %eax
  80136d:	ff 75 08             	pushl  0x8(%ebp)
  801370:	e8 44 ff ff ff       	call   8012b9 <read>
		if (m < 0)
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	85 c0                	test   %eax,%eax
  80137a:	78 0c                	js     801388 <readn+0x3f>
			return m;
		if (m == 0)
  80137c:	85 c0                	test   %eax,%eax
  80137e:	74 06                	je     801386 <readn+0x3d>
  801380:	01 c3                	add    %eax,%ebx
  801382:	39 f3                	cmp    %esi,%ebx
  801384:	72 db                	jb     801361 <readn+0x18>
			break;
	}
	return tot;
  801386:	89 d8                	mov    %ebx,%eax
}
  801388:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80138b:	5b                   	pop    %ebx
  80138c:	5e                   	pop    %esi
  80138d:	5f                   	pop    %edi
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	53                   	push   %ebx
  801394:	83 ec 14             	sub    $0x14,%esp
  801397:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139a:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80139d:	50                   	push   %eax
  80139e:	53                   	push   %ebx
  80139f:	e8 82 fc ff ff       	call   801026 <fd_lookup>
  8013a4:	89 c2                	mov    %eax,%edx
  8013a6:	83 c4 08             	add    $0x8,%esp
  8013a9:	85 c0                	test   %eax,%eax
  8013ab:	78 1a                	js     8013c7 <write+0x37>
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8013b3:	50                   	push   %eax
  8013b4:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013b7:	ff 30                	pushl  (%eax)
  8013b9:	e8 2a fd ff ff       	call   8010e8 <dev_lookup>
  8013be:	89 c2                	mov    %eax,%edx
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	79 04                	jns    8013cb <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8013c7:	89 d0                	mov    %edx,%eax
  8013c9:	eb 4b                	jmp    801416 <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013cb:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013ce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013d2:	75 1e                	jne    8013f2 <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	53                   	push   %ebx
  8013d8:	a1 80 70 80 00       	mov    0x807080,%eax
  8013dd:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013e0:	50                   	push   %eax
  8013e1:	68 99 2f 80 00       	push   $0x802f99
  8013e6:	e8 89 ee ff ff       	call   800274 <cprintf>
		return -E_INVAL;
  8013eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f0:	eb 24                	jmp    801416 <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8013f2:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8013f5:	ff 70 04             	pushl  0x4(%eax)
  8013f8:	ff 75 10             	pushl  0x10(%ebp)
  8013fb:	ff 75 0c             	pushl  0xc(%ebp)
  8013fe:	50                   	push   %eax
  8013ff:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801402:	ff 50 0c             	call   *0xc(%eax)
  801405:	89 c2                	mov    %eax,%edx
	if (r > 0)
  801407:	83 c4 10             	add    $0x10,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	7e 06                	jle    801414 <write+0x84>
		fd->fd_offset += r;
  80140e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801411:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801414:	89 d0                	mov    %edx,%eax
}
  801416:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <seek>:

int
seek(int fdnum, off_t offset)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801421:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	ff 75 08             	pushl  0x8(%ebp)
  801428:	e8 f9 fb ff ff       	call   801026 <fd_lookup>
  80142d:	83 c4 08             	add    $0x8,%esp
		return r;
  801430:	89 c2                	mov    %eax,%edx
  801432:	85 c0                	test   %eax,%eax
  801434:	78 0e                	js     801444 <seek+0x29>
	fd->fd_offset = offset;
  801436:	8b 55 0c             	mov    0xc(%ebp),%edx
  801439:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  80143c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80143f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801444:	89 d0                	mov    %edx,%eax
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	53                   	push   %ebx
  80144c:	83 ec 14             	sub    $0x14,%esp
  80144f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801452:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801455:	50                   	push   %eax
  801456:	53                   	push   %ebx
  801457:	e8 ca fb ff ff       	call   801026 <fd_lookup>
  80145c:	83 c4 08             	add    $0x8,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	78 4e                	js     8014b1 <ftruncate+0x69>
  801463:	83 ec 08             	sub    $0x8,%esp
  801466:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801469:	50                   	push   %eax
  80146a:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80146d:	ff 30                	pushl  (%eax)
  80146f:	e8 74 fc ff ff       	call   8010e8 <dev_lookup>
  801474:	83 c4 10             	add    $0x10,%esp
  801477:	85 c0                	test   %eax,%eax
  801479:	78 36                	js     8014b1 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80147b:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80147e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801482:	75 1e                	jne    8014a2 <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801484:	83 ec 04             	sub    $0x4,%esp
  801487:	53                   	push   %ebx
  801488:	a1 80 70 80 00       	mov    0x807080,%eax
  80148d:	8b 40 4c             	mov    0x4c(%eax),%eax
  801490:	50                   	push   %eax
  801491:	68 5c 2f 80 00       	push   $0x802f5c
  801496:	e8 d9 ed ff ff       	call   800274 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  80149b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a0:	eb 0f                	jmp    8014b1 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8014a2:	83 ec 08             	sub    $0x8,%esp
  8014a5:	ff 75 0c             	pushl  0xc(%ebp)
  8014a8:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8014ab:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8014ae:	ff 50 1c             	call   *0x1c(%eax)
}
  8014b1:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	53                   	push   %ebx
  8014ba:	83 ec 14             	sub    $0x14,%esp
  8014bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c0:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8014c3:	50                   	push   %eax
  8014c4:	ff 75 08             	pushl  0x8(%ebp)
  8014c7:	e8 5a fb ff ff       	call   801026 <fd_lookup>
  8014cc:	83 c4 08             	add    $0x8,%esp
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	78 42                	js     801515 <fstat+0x5f>
  8014d3:	83 ec 08             	sub    $0x8,%esp
  8014d6:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8014d9:	50                   	push   %eax
  8014da:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8014dd:	ff 30                	pushl  (%eax)
  8014df:	e8 04 fc ff ff       	call   8010e8 <dev_lookup>
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	78 2a                	js     801515 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  8014eb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014ee:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014f5:	00 00 00 
	stat->st_isdir = 0;
  8014f8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014ff:	00 00 00 
	stat->st_dev = dev;
  801502:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801505:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80150b:	83 ec 08             	sub    $0x8,%esp
  80150e:	53                   	push   %ebx
  80150f:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801512:	ff 50 14             	call   *0x14(%eax)
}
  801515:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	56                   	push   %esi
  80151e:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	6a 00                	push   $0x0
  801524:	ff 75 08             	pushl  0x8(%ebp)
  801527:	e8 28 00 00 00       	call   801554 <open>
  80152c:	89 c6                	mov    %eax,%esi
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	85 f6                	test   %esi,%esi
  801533:	78 18                	js     80154d <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801535:	83 ec 08             	sub    $0x8,%esp
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	56                   	push   %esi
  80153c:	e8 75 ff ff ff       	call   8014b6 <fstat>
  801541:	89 c3                	mov    %eax,%ebx
	close(fd);
  801543:	89 34 24             	mov    %esi,(%esp)
  801546:	e8 fb fb ff ff       	call   801146 <close>
	return r;
  80154b:	89 d8                	mov    %ebx,%eax
}
  80154d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801550:	5b                   	pop    %ebx
  801551:	5e                   	pop    %esi
  801552:	c9                   	leave  
  801553:	c3                   	ret    

00801554 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801554:	55                   	push   %ebp
  801555:	89 e5                	mov    %esp,%ebp
  801557:	53                   	push   %ebx
  801558:	83 ec 10             	sub    $0x10,%esp
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
  80155b:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80155e:	50                   	push   %eax
  80155f:	e8 68 fa ff ff       	call   800fcc <fd_alloc>
  801564:	89 c3                	mov    %eax,%ebx
  801566:	83 c4 10             	add    $0x10,%esp
  801569:	85 db                	test   %ebx,%ebx
  80156b:	78 36                	js     8015a3 <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  80156d:	83 ec 04             	sub    $0x4,%esp
  801570:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801573:	ff 75 0c             	pushl  0xc(%ebp)
  801576:	ff 75 08             	pushl  0x8(%ebp)
  801579:	e8 1b 05 00 00       	call   801a99 <fsipc_open>
  80157e:	89 c3                	mov    %eax,%ebx
  801580:	83 c4 10             	add    $0x10,%esp
  801583:	85 c0                	test   %eax,%eax
  801585:	79 11                	jns    801598 <open+0x44>
          fd_close(fd_store, 0);
  801587:	83 ec 08             	sub    $0x8,%esp
  80158a:	6a 00                	push   $0x0
  80158c:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80158f:	e8 e0 fa ff ff       	call   801074 <fd_close>
          return r;
  801594:	89 d8                	mov    %ebx,%eax
  801596:	eb 0b                	jmp    8015a3 <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801598:	83 ec 0c             	sub    $0xc,%esp
  80159b:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80159e:	e8 19 fa ff ff       	call   800fbc <fd2num>
}
  8015a3:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	53                   	push   %ebx
  8015ac:	83 ec 04             	sub    $0x4,%esp
  8015af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  8015b2:	6a 01                	push   $0x1
  8015b4:	6a 00                	push   $0x0
  8015b6:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  8015bc:	53                   	push   %ebx
  8015bd:	e8 e7 03 00 00       	call   8019a9 <funmap>
  8015c2:	83 c4 10             	add    $0x10,%esp
          return r;
  8015c5:	89 c2                	mov    %eax,%edx
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	78 19                	js     8015e4 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  8015cb:	83 ec 0c             	sub    $0xc,%esp
  8015ce:	ff 73 0c             	pushl  0xc(%ebx)
  8015d1:	e8 68 05 00 00       	call   801b3e <fsipc_close>
  8015d6:	83 c4 10             	add    $0x10,%esp
          return r;
  8015d9:	89 c2                	mov    %eax,%edx
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	78 05                	js     8015e4 <file_close+0x3c>
        }
        return 0;
  8015df:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8015e4:	89 d0                	mov    %edx,%eax
  8015e6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8015e9:	c9                   	leave  
  8015ea:	c3                   	ret    

008015eb <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	57                   	push   %edi
  8015ef:	56                   	push   %esi
  8015f0:	53                   	push   %ebx
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	8b 75 10             	mov    0x10(%ebp),%esi
  8015f7:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  801603:	b9 00 00 00 00       	mov    $0x0,%ecx
  801608:	39 d7                	cmp    %edx,%edi
  80160a:	0f 87 95 00 00 00    	ja     8016a5 <file_read+0xba>
	if (offset + n > size)
  801610:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801613:	39 d0                	cmp    %edx,%eax
  801615:	76 04                	jbe    80161b <file_read+0x30>
		n = size - offset;
  801617:	89 d6                	mov    %edx,%esi
  801619:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  80161b:	83 ec 0c             	sub    $0xc,%esp
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	e8 7e f9 ff ff       	call   800fa4 <fd2data>
  801626:	89 c3                	mov    %eax,%ebx
  801628:	01 fb                	add    %edi,%ebx
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	eb 41                	jmp    801670 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  80162f:	89 d8                	mov    %ebx,%eax
  801631:	c1 e8 16             	shr    $0x16,%eax
  801634:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80163b:	a8 01                	test   $0x1,%al
  80163d:	74 10                	je     80164f <file_read+0x64>
  80163f:	89 d8                	mov    %ebx,%eax
  801641:	c1 e8 0c             	shr    $0xc,%eax
  801644:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80164b:	a8 01                	test   $0x1,%al
  80164d:	75 1b                	jne    80166a <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  80164f:	83 ec 04             	sub    $0x4,%esp
  801652:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801655:	50                   	push   %eax
  801656:	57                   	push   %edi
  801657:	ff 75 08             	pushl  0x8(%ebp)
  80165a:	e8 d4 02 00 00       	call   801933 <fmap>
  80165f:	83 c4 10             	add    $0x10,%esp
              return r;
  801662:	89 c1                	mov    %eax,%ecx
  801664:	85 c0                	test   %eax,%eax
  801666:	78 3d                	js     8016a5 <file_read+0xba>
  801668:	eb 1c                	jmp    801686 <file_read+0x9b>
  80166a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801670:	83 ec 0c             	sub    $0xc,%esp
  801673:	ff 75 08             	pushl  0x8(%ebp)
  801676:	e8 29 f9 ff ff       	call   800fa4 <fd2data>
  80167b:	01 f8                	add    %edi,%eax
  80167d:	01 f0                	add    %esi,%eax
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	39 d8                	cmp    %ebx,%eax
  801684:	77 a9                	ja     80162f <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801686:	83 ec 04             	sub    $0x4,%esp
  801689:	56                   	push   %esi
  80168a:	83 ec 04             	sub    $0x4,%esp
  80168d:	ff 75 08             	pushl  0x8(%ebp)
  801690:	e8 0f f9 ff ff       	call   800fa4 <fd2data>
  801695:	83 c4 08             	add    $0x8,%esp
  801698:	01 f8                	add    %edi,%eax
  80169a:	50                   	push   %eax
  80169b:	ff 75 0c             	pushl  0xc(%ebp)
  80169e:	e8 51 f3 ff ff       	call   8009f4 <memmove>
	return n;
  8016a3:	89 f1                	mov    %esi,%ecx
}
  8016a5:	89 c8                	mov    %ecx,%eax
  8016a7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8016aa:	5b                   	pop    %ebx
  8016ab:	5e                   	pop    %esi
  8016ac:	5f                   	pop    %edi
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 18             	sub    $0x18,%esp
  8016b7:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ba:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8016bd:	50                   	push   %eax
  8016be:	ff 75 08             	pushl  0x8(%ebp)
  8016c1:	e8 60 f9 ff ff       	call   801026 <fd_lookup>
  8016c6:	83 c4 10             	add    $0x10,%esp
		return r;
  8016c9:	89 c2                	mov    %eax,%edx
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	0f 88 9f 00 00 00    	js     801772 <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  8016d3:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  8016d8:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8016dd:	3b 05 20 70 80 00    	cmp    0x807020,%eax
  8016e3:	0f 85 89 00 00 00    	jne    801772 <read_map+0xc3>
	va = fd2data(fd) + offset;
  8016e9:	83 ec 0c             	sub    $0xc,%esp
  8016ec:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  8016ef:	e8 b0 f8 ff ff       	call   800fa4 <fd2data>
  8016f4:	89 c3                	mov    %eax,%ebx
  8016f6:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  8016f8:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  8016fb:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801700:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801706:	7f 6a                	jg     801772 <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801708:	89 d8                	mov    %ebx,%eax
  80170a:	c1 e8 16             	shr    $0x16,%eax
  80170d:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801714:	a8 01                	test   $0x1,%al
  801716:	74 10                	je     801728 <read_map+0x79>
  801718:	89 d8                	mov    %ebx,%eax
  80171a:	c1 e8 0c             	shr    $0xc,%eax
  80171d:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801724:	a8 01                	test   $0x1,%al
  801726:	75 19                	jne    801741 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801728:	83 ec 04             	sub    $0x4,%esp
  80172b:	8d 46 01             	lea    0x1(%esi),%eax
  80172e:	50                   	push   %eax
  80172f:	56                   	push   %esi
  801730:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801733:	e8 fb 01 00 00       	call   801933 <fmap>
  801738:	83 c4 10             	add    $0x10,%esp
            return r;
  80173b:	89 c2                	mov    %eax,%edx
  80173d:	85 c0                	test   %eax,%eax
  80173f:	78 31                	js     801772 <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801741:	89 d8                	mov    %ebx,%eax
  801743:	c1 e8 16             	shr    $0x16,%eax
  801746:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80174d:	a8 01                	test   $0x1,%al
  80174f:	74 10                	je     801761 <read_map+0xb2>
  801751:	89 d8                	mov    %ebx,%eax
  801753:	c1 e8 0c             	shr    $0xc,%eax
  801756:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80175d:	a8 01                	test   $0x1,%al
  80175f:	75 07                	jne    801768 <read_map+0xb9>
		return -E_NO_DISK;
  801761:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801766:	eb 0a                	jmp    801772 <read_map+0xc3>

	*blk = (void*) va;
  801768:	8b 45 10             	mov    0x10(%ebp),%eax
  80176b:	89 18                	mov    %ebx,(%eax)
	return 0;
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801772:	89 d0                	mov    %edx,%eax
  801774:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801777:	5b                   	pop    %ebx
  801778:	5e                   	pop    %esi
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	57                   	push   %edi
  80177f:	56                   	push   %esi
  801780:	53                   	push   %ebx
  801781:	83 ec 0c             	sub    $0xc,%esp
  801784:	8b 75 08             	mov    0x8(%ebp),%esi
  801787:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  80178a:	8b 45 10             	mov    0x10(%ebp),%eax
  80178d:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801790:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801795:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  80179b:	0f 87 bd 00 00 00    	ja     80185e <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  8017a1:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  8017a7:	73 17                	jae    8017c0 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	52                   	push   %edx
  8017ad:	56                   	push   %esi
  8017ae:	e8 fb 00 00 00       	call   8018ae <file_trunc>
  8017b3:	83 c4 10             	add    $0x10,%esp
			return r;
  8017b6:	89 c1                	mov    %eax,%ecx
  8017b8:	85 c0                	test   %eax,%eax
  8017ba:	0f 88 9e 00 00 00    	js     80185e <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  8017c0:	83 ec 0c             	sub    $0xc,%esp
  8017c3:	56                   	push   %esi
  8017c4:	e8 db f7 ff ff       	call   800fa4 <fd2data>
  8017c9:	89 c3                	mov    %eax,%ebx
  8017cb:	01 fb                	add    %edi,%ebx
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	eb 42                	jmp    801814 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  8017d2:	89 d8                	mov    %ebx,%eax
  8017d4:	c1 e8 16             	shr    $0x16,%eax
  8017d7:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8017de:	a8 01                	test   $0x1,%al
  8017e0:	74 10                	je     8017f2 <file_write+0x77>
  8017e2:	89 d8                	mov    %ebx,%eax
  8017e4:	c1 e8 0c             	shr    $0xc,%eax
  8017e7:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8017ee:	a8 01                	test   $0x1,%al
  8017f0:	75 1c                	jne    80180e <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	8b 55 10             	mov    0x10(%ebp),%edx
  8017f8:	8d 04 17             	lea    (%edi,%edx,1),%eax
  8017fb:	50                   	push   %eax
  8017fc:	57                   	push   %edi
  8017fd:	56                   	push   %esi
  8017fe:	e8 30 01 00 00       	call   801933 <fmap>
  801803:	83 c4 10             	add    $0x10,%esp
              return r;
  801806:	89 c1                	mov    %eax,%ecx
  801808:	85 c0                	test   %eax,%eax
  80180a:	78 52                	js     80185e <file_write+0xe3>
  80180c:	eb 1b                	jmp    801829 <file_write+0xae>
  80180e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801814:	83 ec 0c             	sub    $0xc,%esp
  801817:	56                   	push   %esi
  801818:	e8 87 f7 ff ff       	call   800fa4 <fd2data>
  80181d:	01 f8                	add    %edi,%eax
  80181f:	03 45 10             	add    0x10(%ebp),%eax
  801822:	83 c4 10             	add    $0x10,%esp
  801825:	39 d8                	cmp    %ebx,%eax
  801827:	77 a9                	ja     8017d2 <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801829:	83 ec 0c             	sub    $0xc,%esp
  80182c:	68 b6 2f 80 00       	push   $0x802fb6
  801831:	e8 3e ea ff ff       	call   800274 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801836:	83 c4 0c             	add    $0xc,%esp
  801839:	ff 75 10             	pushl  0x10(%ebp)
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	56                   	push   %esi
  801840:	e8 5f f7 ff ff       	call   800fa4 <fd2data>
  801845:	01 f8                	add    %edi,%eax
  801847:	89 04 24             	mov    %eax,(%esp)
  80184a:	e8 a5 f1 ff ff       	call   8009f4 <memmove>
        cprintf("write done\n");
  80184f:	c7 04 24 c3 2f 80 00 	movl   $0x802fc3,(%esp)
  801856:	e8 19 ea ff ff       	call   800274 <cprintf>
	return n;
  80185b:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  80185e:	89 c8                	mov    %ecx,%eax
  801860:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801863:	5b                   	pop    %ebx
  801864:	5e                   	pop    %esi
  801865:	5f                   	pop    %edi
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	56                   	push   %esi
  80186c:	53                   	push   %ebx
  80186d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801870:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801873:	83 ec 08             	sub    $0x8,%esp
  801876:	8d 43 10             	lea    0x10(%ebx),%eax
  801879:	50                   	push   %eax
  80187a:	56                   	push   %esi
  80187b:	e8 f8 ef ff ff       	call   800878 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801880:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801886:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  80188c:	83 c4 10             	add    $0x10,%esp
  80188f:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801896:	0f 94 c0             	sete   %al
  801899:	0f b6 c0             	movzbl %al,%eax
  80189c:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  8018a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a7:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8018aa:	5b                   	pop    %ebx
  8018ab:	5e                   	pop    %esi
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	57                   	push   %edi
  8018b2:	56                   	push   %esi
  8018b3:	53                   	push   %ebx
  8018b4:	83 ec 0c             	sub    $0xc,%esp
  8018b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8018ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  8018bd:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  8018c2:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  8018c8:	7f 5f                	jg     801929 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  8018ca:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  8018d0:	83 ec 08             	sub    $0x8,%esp
  8018d3:	53                   	push   %ebx
  8018d4:	ff 76 0c             	pushl  0xc(%esi)
  8018d7:	e8 3a 02 00 00       	call   801b16 <fsipc_set_size>
  8018dc:	83 c4 10             	add    $0x10,%esp
		return r;
  8018df:	89 c2                	mov    %eax,%edx
  8018e1:	85 c0                	test   %eax,%eax
  8018e3:	78 44                	js     801929 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  8018e5:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  8018eb:	74 19                	je     801906 <file_trunc+0x58>
  8018ed:	68 f0 2f 80 00       	push   $0x802ff0
  8018f2:	68 cf 2f 80 00       	push   $0x802fcf
  8018f7:	68 dc 00 00 00       	push   $0xdc
  8018fc:	68 e4 2f 80 00       	push   $0x802fe4
  801901:	e8 7e e8 ff ff       	call   800184 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	53                   	push   %ebx
  80190a:	57                   	push   %edi
  80190b:	56                   	push   %esi
  80190c:	e8 22 00 00 00       	call   801933 <fmap>
  801911:	83 c4 10             	add    $0x10,%esp
		return r;
  801914:	89 c2                	mov    %eax,%edx
  801916:	85 c0                	test   %eax,%eax
  801918:	78 0f                	js     801929 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  80191a:	6a 00                	push   $0x0
  80191c:	53                   	push   %ebx
  80191d:	57                   	push   %edi
  80191e:	56                   	push   %esi
  80191f:	e8 85 00 00 00       	call   8019a9 <funmap>

	return 0;
  801924:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801929:	89 d0                	mov    %edx,%eax
  80192b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80192e:	5b                   	pop    %ebx
  80192f:	5e                   	pop    %esi
  801930:	5f                   	pop    %edi
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <fmap>:

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
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	57                   	push   %edi
  801937:	56                   	push   %esi
  801938:	53                   	push   %ebx
  801939:	83 ec 0c             	sub    $0xc,%esp
  80193c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80193f:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801942:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801945:	7d 55                	jge    80199c <fmap+0x69>
          fma = fd2data(fd);
  801947:	83 ec 0c             	sub    $0xc,%esp
  80194a:	57                   	push   %edi
  80194b:	e8 54 f6 ff ff       	call   800fa4 <fd2data>
  801950:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	8b 45 0c             	mov    0xc(%ebp),%eax
  801959:	05 ff 0f 00 00       	add    $0xfff,%eax
  80195e:	89 c3                	mov    %eax,%ebx
  801960:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801966:	39 f3                	cmp    %esi,%ebx
  801968:	7d 32                	jge    80199c <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  80196a:	83 ec 04             	sub    $0x4,%esp
  80196d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801970:	01 d8                	add    %ebx,%eax
  801972:	50                   	push   %eax
  801973:	53                   	push   %ebx
  801974:	ff 77 0c             	pushl  0xc(%edi)
  801977:	e8 6f 01 00 00       	call   801aeb <fsipc_map>
  80197c:	83 c4 10             	add    $0x10,%esp
  80197f:	85 c0                	test   %eax,%eax
  801981:	79 0f                	jns    801992 <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801983:	6a 00                	push   $0x0
  801985:	ff 75 0c             	pushl  0xc(%ebp)
  801988:	53                   	push   %ebx
  801989:	57                   	push   %edi
  80198a:	e8 1a 00 00 00       	call   8019a9 <funmap>
  80198f:	83 c4 10             	add    $0x10,%esp
  801992:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801998:	39 f3                	cmp    %esi,%ebx
  80199a:	7c ce                	jl     80196a <fmap+0x37>
            }
          }
        }

        return 0;
}
  80199c:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8019a4:	5b                   	pop    %ebx
  8019a5:	5e                   	pop    %esi
  8019a6:	5f                   	pop    %edi
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <funmap>:

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
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	57                   	push   %edi
  8019ad:	56                   	push   %esi
  8019ae:	53                   	push   %ebx
  8019af:	83 ec 0c             	sub    $0xc,%esp
  8019b2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  8019b8:	39 f3                	cmp    %esi,%ebx
  8019ba:	0f 8d 80 00 00 00    	jge    801a40 <funmap+0x97>
          fma = fd2data(fd);
  8019c0:	83 ec 0c             	sub    $0xc,%esp
  8019c3:	ff 75 08             	pushl  0x8(%ebp)
  8019c6:	e8 d9 f5 ff ff       	call   800fa4 <fd2data>
  8019cb:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8019d6:	89 c3                	mov    %eax,%ebx
  8019d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8019de:	39 f3                	cmp    %esi,%ebx
  8019e0:	7d 5e                	jge    801a40 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  8019e2:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8019e5:	89 c2                	mov    %eax,%edx
  8019e7:	c1 ea 0c             	shr    $0xc,%edx
  8019ea:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8019f1:	a8 01                	test   $0x1,%al
  8019f3:	74 41                	je     801a36 <funmap+0x8d>
              if (dirty) {
  8019f5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  8019f9:	74 21                	je     801a1c <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  8019fb:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801a02:	a8 40                	test   $0x40,%al
  801a04:	74 16                	je     801a1c <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801a06:	83 ec 08             	sub    $0x8,%esp
  801a09:	53                   	push   %ebx
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	ff 70 0c             	pushl  0xc(%eax)
  801a10:	e8 49 01 00 00       	call   801b5e <fsipc_dirty>
  801a15:	83 c4 10             	add    $0x10,%esp
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	78 29                	js     801a45 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801a22:	50                   	push   %eax
  801a23:	83 ec 04             	sub    $0x4,%esp
  801a26:	e8 e1 f1 ff ff       	call   800c0c <sys_getenvid>
  801a2b:	89 04 24             	mov    %eax,(%esp)
  801a2e:	e8 9c f2 ff ff       	call   800ccf <sys_page_unmap>
  801a33:	83 c4 10             	add    $0x10,%esp
  801a36:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a3c:	39 f3                	cmp    %esi,%ebx
  801a3e:	7c a2                	jl     8019e2 <funmap+0x39>
            }
          }
        }

        return 0;
  801a40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a45:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801a48:	5b                   	pop    %ebx
  801a49:	5e                   	pop    %esi
  801a4a:	5f                   	pop    %edi
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <remove>:

// Delete a file
int
remove(const char *path)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801a53:	ff 75 08             	pushl  0x8(%ebp)
  801a56:	e8 2b 01 00 00       	call   801b86 <fsipc_remove>
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801a63:	e8 64 01 00 00       	call   801bcc <fsipc_sync>
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    
	...

00801a6c <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801a72:	6a 07                	push   $0x7
  801a74:	ff 75 0c             	pushl  0xc(%ebp)
  801a77:	ff 75 08             	pushl  0x8(%ebp)
  801a7a:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801a7f:	50                   	push   %eax
  801a80:	e8 6e 0c 00 00       	call   8026f3 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801a85:	83 c4 0c             	add    $0xc,%esp
  801a88:	ff 75 14             	pushl  0x14(%ebp)
  801a8b:	ff 75 10             	pushl  0x10(%ebp)
  801a8e:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801a91:	50                   	push   %eax
  801a92:	e8 f9 0b 00 00       	call   802690 <ipc_recv>
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	56                   	push   %esi
  801a9d:	53                   	push   %ebx
  801a9e:	83 ec 1c             	sub    $0x1c,%esp
  801aa1:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801aa4:	bb 00 40 80 00       	mov    $0x804000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801aa9:	56                   	push   %esi
  801aaa:	e8 8d ed ff ff       	call   80083c <strlen>
  801aaf:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801ab2:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801ab7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801abc:	7f 24                	jg     801ae2 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	56                   	push   %esi
  801ac2:	53                   	push   %ebx
  801ac3:	e8 b0 ed ff ff       	call   800878 <strcpy>
	req->req_omode = omode;
  801ac8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acb:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801ad1:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801ad4:	50                   	push   %eax
  801ad5:	ff 75 10             	pushl  0x10(%ebp)
  801ad8:	53                   	push   %ebx
  801ad9:	6a 01                	push   $0x1
  801adb:	e8 8c ff ff ff       	call   801a6c <fsipc>
  801ae0:	89 c2                	mov    %eax,%edx
}
  801ae2:	89 d0                	mov    %edx,%eax
  801ae4:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5e                   	pop    %esi
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  801af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afc:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801b01:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801b04:	50                   	push   %eax
  801b05:	ff 75 10             	pushl  0x10(%ebp)
  801b08:	68 00 40 80 00       	push   $0x804000
  801b0d:	6a 02                	push   $0x2
  801b0f:	e8 58 ff ff ff       	call   801a6c <fsipc>

	//return -E_UNSPECIFIED;
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1f:	a3 00 40 80 00       	mov    %eax,0x804000
	req->req_size = size;
  801b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b27:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	68 00 40 80 00       	push   $0x804000
  801b35:	6a 03                	push   $0x3
  801b37:	e8 30 ff ff ff       	call   801a6c <fsipc>
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	68 00 40 80 00       	push   $0x804000
  801b55:	6a 04                	push   $0x4
  801b57:	e8 10 ff ff ff       	call   801a6c <fsipc>
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	68 00 40 80 00       	push   $0x804000
  801b7d:	6a 05                	push   $0x5
  801b7f:	e8 e8 fe ff ff       	call   801a6c <fsipc>
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	56                   	push   %esi
  801b8a:	53                   	push   %ebx
  801b8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801b8e:	be 00 40 80 00       	mov    $0x804000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801b93:	83 ec 0c             	sub    $0xc,%esp
  801b96:	53                   	push   %ebx
  801b97:	e8 a0 ec ff ff       	call   80083c <strlen>
  801b9c:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801b9f:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801ba4:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ba9:	7f 18                	jg     801bc3 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801bab:	83 ec 08             	sub    $0x8,%esp
  801bae:	53                   	push   %ebx
  801baf:	56                   	push   %esi
  801bb0:	e8 c3 ec ff ff       	call   800878 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	56                   	push   %esi
  801bba:	6a 06                	push   $0x6
  801bbc:	e8 ab fe ff ff       	call   801a6c <fsipc>
  801bc1:	89 c2                	mov    %eax,%edx
}
  801bc3:	89 d0                	mov    %edx,%eax
  801bc5:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801bc8:	5b                   	pop    %ebx
  801bc9:	5e                   	pop    %esi
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	68 00 40 80 00       	push   $0x804000
  801bdb:	6a 07                	push   $0x7
  801bdd:	e8 8a fe ff ff       	call   801a6c <fsipc>
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <spawn>:
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	57                   	push   %edi
  801be8:	56                   	push   %esi
  801be9:	53                   	push   %ebx
  801bea:	81 ec 74 02 00 00    	sub    $0x274,%esp
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
  801bf0:	6a 00                	push   $0x0
  801bf2:	ff 75 08             	pushl  0x8(%ebp)
  801bf5:	e8 5a f9 ff ff       	call   801554 <open>
  801bfa:	89 c3                	mov    %eax,%ebx
  801bfc:	83 c4 10             	add    $0x10,%esp
  801bff:	85 db                	test   %ebx,%ebx
  801c01:	0f 88 ed 01 00 00    	js     801df4 <spawn+0x210>
		return r;
	fd = r;
  801c07:	89 9d 90 fd ff ff    	mov    %ebx,0xfffffd90(%ebp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801c0d:	83 ec 04             	sub    $0x4,%esp
  801c10:	68 00 02 00 00       	push   $0x200
  801c15:	8d 85 e8 fd ff ff    	lea    0xfffffde8(%ebp),%eax
  801c1b:	50                   	push   %eax
  801c1c:	53                   	push   %ebx
  801c1d:	e8 97 f6 ff ff       	call   8012b9 <read>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	3d 00 02 00 00       	cmp    $0x200,%eax
  801c2a:	75 0c                	jne    801c38 <spawn+0x54>
  801c2c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,0xfffffde8(%ebp)
  801c33:	45 4c 46 
  801c36:	74 30                	je     801c68 <spawn+0x84>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  801c38:	83 ec 0c             	sub    $0xc,%esp
  801c3b:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  801c41:	e8 00 f5 ff ff       	call   801146 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801c46:	83 c4 0c             	add    $0xc,%esp
  801c49:	68 7f 45 4c 46       	push   $0x464c457f
  801c4e:	ff b5 e8 fd ff ff    	pushl  0xfffffde8(%ebp)
  801c54:	68 13 30 80 00       	push   $0x803013
  801c59:	e8 16 e6 ff ff       	call   800274 <cprintf>
		return -E_NOT_EXEC;
  801c5e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801c63:	e9 8c 01 00 00       	jmp    801df4 <spawn+0x210>
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801c68:	ba 07 00 00 00       	mov    $0x7,%edx
  801c6d:	89 d0                	mov    %edx,%eax
  801c6f:	cd 30                	int    $0x30
  801c71:	89 c3                	mov    %eax,%ebx
  801c73:	85 db                	test   %ebx,%ebx
  801c75:	0f 88 79 01 00 00    	js     801df4 <spawn+0x210>
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
	child = r;
  801c7b:	89 9d 94 fd ff ff    	mov    %ebx,0xfffffd94(%ebp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801c81:	89 d8                	mov    %ebx,%eax
  801c83:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c88:	c1 e0 07             	shl    $0x7,%eax
  801c8b:	8d 95 98 fd ff ff    	lea    0xfffffd98(%ebp),%edx
  801c91:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c96:	83 ec 04             	sub    $0x4,%esp
  801c99:	6a 44                	push   $0x44
  801c9b:	50                   	push   %eax
  801c9c:	52                   	push   %edx
  801c9d:	e8 bd ed ff ff       	call   800a5f <memcpy>
	child_tf.tf_eip = elf->e_entry;
  801ca2:	8b 85 00 fe ff ff    	mov    0xfffffe00(%ebp),%eax
  801ca8:	89 85 c8 fd ff ff    	mov    %eax,0xfffffdc8(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  801cae:	83 c4 0c             	add    $0xc,%esp
  801cb1:	8d 85 d4 fd ff ff    	lea    0xfffffdd4(%ebp),%eax
  801cb7:	50                   	push   %eax
  801cb8:	ff 75 0c             	pushl  0xc(%ebp)
  801cbb:	53                   	push   %ebx
  801cbc:	e8 4f 01 00 00       	call   801e10 <init_stack>
  801cc1:	89 c3                	mov    %eax,%ebx
  801cc3:	83 c4 10             	add    $0x10,%esp
  801cc6:	85 db                	test   %ebx,%ebx
  801cc8:	0f 88 26 01 00 00    	js     801df4 <spawn+0x210>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801cce:	8b 85 04 fe ff ff    	mov    0xfffffe04(%ebp),%eax
  801cd4:	8d b4 05 e8 fd ff ff 	lea    0xfffffde8(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801cdb:	bf 00 00 00 00       	mov    $0x0,%edi
  801ce0:	66 83 bd 14 fe ff ff 	cmpw   $0x0,0xfffffe14(%ebp)
  801ce7:	00 
  801ce8:	74 4f                	je     801d39 <spawn+0x155>
		if (ph->p_type != ELF_PROG_LOAD)
  801cea:	83 3e 01             	cmpl   $0x1,(%esi)
  801ced:	75 3b                	jne    801d2a <spawn+0x146>
			continue;
		perm = PTE_P | PTE_U;
  801cef:	b8 05 00 00 00       	mov    $0x5,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801cf4:	f6 46 18 02          	testb  $0x2,0x18(%esi)
  801cf8:	74 02                	je     801cfc <spawn+0x118>
			perm |= PTE_W;
  801cfa:	b0 07                	mov    $0x7,%al
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	50                   	push   %eax
  801d00:	ff 76 04             	pushl  0x4(%esi)
  801d03:	ff 76 10             	pushl  0x10(%esi)
  801d06:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  801d0c:	ff 76 14             	pushl  0x14(%esi)
  801d0f:	ff 76 08             	pushl  0x8(%esi)
  801d12:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  801d18:	e8 5f 02 00 00       	call   801f7c <map_segment>
  801d1d:	89 c3                	mov    %eax,%ebx
  801d1f:	83 c4 20             	add    $0x20,%esp
  801d22:	85 c0                	test   %eax,%eax
  801d24:	0f 88 ac 00 00 00    	js     801dd6 <spawn+0x1f2>
  801d2a:	47                   	inc    %edi
  801d2b:	83 c6 20             	add    $0x20,%esi
  801d2e:	0f b7 85 14 fe ff ff 	movzwl 0xfffffe14(%ebp),%eax
  801d35:	39 f8                	cmp    %edi,%eax
  801d37:	7f b1                	jg     801cea <spawn+0x106>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801d39:	83 ec 0c             	sub    $0xc,%esp
  801d3c:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  801d42:	e8 ff f3 ff ff       	call   801146 <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  801d47:	83 c4 04             	add    $0x4,%esp
  801d4a:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  801d50:	e8 9f 03 00 00       	call   8020f4 <copy_shared_pages>
  801d55:	83 c4 10             	add    $0x10,%esp
  801d58:	85 c0                	test   %eax,%eax
  801d5a:	79 15                	jns    801d71 <spawn+0x18d>
		panic("copy_shared_pages: %e", r);
  801d5c:	50                   	push   %eax
  801d5d:	68 2d 30 80 00       	push   $0x80302d
  801d62:	68 82 00 00 00       	push   $0x82
  801d67:	68 43 30 80 00       	push   $0x803043
  801d6c:	e8 13 e4 ff ff       	call   800184 <_panic>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801d71:	83 ec 08             	sub    $0x8,%esp
  801d74:	8d 85 98 fd ff ff    	lea    0xfffffd98(%ebp),%eax
  801d7a:	50                   	push   %eax
  801d7b:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  801d81:	e8 cd ef ff ff       	call   800d53 <sys_env_set_trapframe>
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	79 15                	jns    801da2 <spawn+0x1be>
		panic("sys_env_set_trapframe: %e", r);
  801d8d:	50                   	push   %eax
  801d8e:	68 4f 30 80 00       	push   $0x80304f
  801d93:	68 85 00 00 00       	push   $0x85
  801d98:	68 43 30 80 00       	push   $0x803043
  801d9d:	e8 e2 e3 ff ff       	call   800184 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801da2:	83 ec 08             	sub    $0x8,%esp
  801da5:	6a 01                	push   $0x1
  801da7:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  801dad:	e8 5f ef ff ff       	call   800d11 <sys_env_set_status>
  801db2:	89 c3                	mov    %eax,%ebx
  801db4:	83 c4 10             	add    $0x10,%esp
		panic("sys_env_set_status: %e", r);

	return child;
  801db7:	8b 85 94 fd ff ff    	mov    0xfffffd94(%ebp),%eax
  801dbd:	85 db                	test   %ebx,%ebx
  801dbf:	79 33                	jns    801df4 <spawn+0x210>
  801dc1:	53                   	push   %ebx
  801dc2:	68 69 30 80 00       	push   $0x803069
  801dc7:	68 88 00 00 00       	push   $0x88
  801dcc:	68 43 30 80 00       	push   $0x803043
  801dd1:	e8 ae e3 ff ff       	call   800184 <_panic>

error:
	sys_env_destroy(child);
  801dd6:	83 ec 0c             	sub    $0xc,%esp
  801dd9:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  801ddf:	e8 e7 ed ff ff       	call   800bcb <sys_env_destroy>
	close(fd);
  801de4:	83 c4 04             	add    $0x4,%esp
  801de7:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  801ded:	e8 54 f3 ff ff       	call   801146 <close>
	return r;
  801df2:	89 d8                	mov    %ebx,%eax
}
  801df4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801df7:	5b                   	pop    %ebx
  801df8:	5e                   	pop    %esi
  801df9:	5f                   	pop    %edi
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <spawnl>:

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 10             	sub    $0x10,%esp
	return spawn(prog, &arg0);
  801e02:	8d 45 0c             	lea    0xc(%ebp),%eax
  801e05:	50                   	push   %eax
  801e06:	ff 75 08             	pushl  0x8(%ebp)
  801e09:	e8 d6 fd ff ff       	call   801be4 <spawn>
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <init_stack>:


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
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	57                   	push   %edi
  801e14:	56                   	push   %esi
  801e15:	53                   	push   %ebx
  801e16:	83 ec 0c             	sub    $0xc,%esp
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801e19:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  801e1e:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
  801e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e28:	83 38 00             	cmpl   $0x0,(%eax)
  801e2b:	74 27                	je     801e54 <init_stack+0x44>
		string_size += strlen(argv[argc]) + 1;
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e36:	ff 34 90             	pushl  (%eax,%edx,4)
  801e39:	e8 fe e9 ff ff       	call   80083c <strlen>
  801e3e:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	ff 45 f0             	incl   0xfffffff0(%ebp)
  801e48:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4e:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  801e52:	75 d9                	jne    801e2d <init_stack+0x1d>

	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801e54:	b8 00 10 40 00       	mov    $0x401000,%eax
  801e59:	89 c7                	mov    %eax,%edi
  801e5b:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801e5d:	89 fa                	mov    %edi,%edx
  801e5f:	83 e2 fc             	and    $0xfffffffc,%edx
  801e62:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801e65:	c1 e0 02             	shl    $0x2,%eax
  801e68:	89 d6                	mov    %edx,%esi
  801e6a:	29 c6                	sub    %eax,%esi
  801e6c:	83 ee 04             	sub    $0x4,%esi
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801e6f:	8d 46 f8             	lea    0xfffffff8(%esi),%eax
		return -E_NO_MEM;
  801e72:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
  801e77:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801e7c:	0f 86 f0 00 00 00    	jbe    801f72 <init_stack+0x162>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	6a 07                	push   $0x7
  801e87:	68 00 00 40 00       	push   $0x400000
  801e8c:	6a 00                	push   $0x0
  801e8e:	e8 b7 ed ff ff       	call   800c4a <sys_page_alloc>
  801e93:	83 c4 10             	add    $0x10,%esp
		return r;
  801e96:	89 c2                	mov    %eax,%edx
  801e98:	85 c0                	test   %eax,%eax
  801e9a:	0f 88 d2 00 00 00    	js     801f72 <init_stack+0x162>


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
  801ea0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ea5:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
  801ea8:	7d 33                	jge    801edd <init_stack+0xcd>
		argv_store[i] = UTEMP2USTACK(string_store);
  801eaa:	8d 87 00 d0 7f ee    	lea    0xee7fd000(%edi),%eax
  801eb0:	89 04 9e             	mov    %eax,(%esi,%ebx,4)
		strcpy(string_store, argv[i]);
  801eb3:	83 ec 08             	sub    $0x8,%esp
  801eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb9:	ff 34 9a             	pushl  (%edx,%ebx,4)
  801ebc:	57                   	push   %edi
  801ebd:	e8 b6 e9 ff ff       	call   800878 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801ec2:	83 c4 04             	add    $0x4,%esp
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	ff 34 98             	pushl  (%eax,%ebx,4)
  801ecb:	e8 6c e9 ff ff       	call   80083c <strlen>
  801ed0:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	43                   	inc    %ebx
  801ed8:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
  801edb:	7c cd                	jl     801eaa <init_stack+0x9a>
	}
	argv_store[argc] = 0;
  801edd:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801ee0:	c7 04 96 00 00 00 00 	movl   $0x0,(%esi,%edx,4)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ee7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801eed:	74 19                	je     801f08 <init_stack+0xf8>
  801eef:	68 bc 30 80 00       	push   $0x8030bc
  801ef4:	68 cf 2f 80 00       	push   $0x802fcf
  801ef9:	68 d9 00 00 00       	push   $0xd9
  801efe:	68 43 30 80 00       	push   $0x803043
  801f03:	e8 7c e2 ff ff       	call   800184 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f08:	8d 86 00 d0 7f ee    	lea    0xee7fd000(%esi),%eax
  801f0e:	89 46 fc             	mov    %eax,0xfffffffc(%esi)
	argv_store[-2] = argc;
  801f11:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801f14:	89 46 f8             	mov    %eax,0xfffffff8(%esi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f17:	8d 96 f8 cf 7f ee    	lea    0xee7fcff8(%esi),%edx
  801f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f20:	89 10                	mov    %edx,(%eax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f22:	83 ec 0c             	sub    $0xc,%esp
  801f25:	6a 07                	push   $0x7
  801f27:	68 00 d0 bf ee       	push   $0xeebfd000
  801f2c:	ff 75 08             	pushl  0x8(%ebp)
  801f2f:	68 00 00 40 00       	push   $0x400000
  801f34:	6a 00                	push   $0x0
  801f36:	e8 52 ed ff ff       	call   800c8d <sys_page_map>
  801f3b:	89 c3                	mov    %eax,%ebx
  801f3d:	83 c4 20             	add    $0x20,%esp
  801f40:	85 c0                	test   %eax,%eax
  801f42:	78 1d                	js     801f61 <init_stack+0x151>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801f44:	83 ec 08             	sub    $0x8,%esp
  801f47:	68 00 00 40 00       	push   $0x400000
  801f4c:	6a 00                	push   $0x0
  801f4e:	e8 7c ed ff ff       	call   800ccf <sys_page_unmap>
  801f53:	89 c3                	mov    %eax,%ebx
  801f55:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  801f58:	ba 00 00 00 00       	mov    $0x0,%edx
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	79 11                	jns    801f72 <init_stack+0x162>

error:
	sys_page_unmap(0, UTEMP);
  801f61:	83 ec 08             	sub    $0x8,%esp
  801f64:	68 00 00 40 00       	push   $0x400000
  801f69:	6a 00                	push   $0x0
  801f6b:	e8 5f ed ff ff       	call   800ccf <sys_page_unmap>
	return r;
  801f70:	89 da                	mov    %ebx,%edx
}
  801f72:	89 d0                	mov    %edx,%eax
  801f74:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801f77:	5b                   	pop    %ebx
  801f78:	5e                   	pop    %esi
  801f79:	5f                   	pop    %edi
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz, 
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	57                   	push   %edi
  801f80:	56                   	push   %esi
  801f81:	53                   	push   %ebx
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f88:	8b 7d 18             	mov    0x18(%ebp),%edi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801f8b:	89 f3                	mov    %esi,%ebx
  801f8d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  801f93:	74 0a                	je     801f9f <map_segment+0x23>
		va -= i;
  801f95:	29 de                	sub    %ebx,%esi
		memsz += i;
  801f97:	01 5d 10             	add    %ebx,0x10(%ebp)
		filesz += i;
  801f9a:	01 df                	add    %ebx,%edi
		fileoffset -= i;
  801f9c:	29 5d 1c             	sub    %ebx,0x1c(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801f9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fa4:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801fa7:	0f 83 3a 01 00 00    	jae    8020e7 <map_segment+0x16b>
		if (i >= filesz) {
  801fad:	39 fb                	cmp    %edi,%ebx
  801faf:	72 22                	jb     801fd3 <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801fb1:	83 ec 04             	sub    $0x4,%esp
  801fb4:	ff 75 20             	pushl  0x20(%ebp)
  801fb7:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801fba:	50                   	push   %eax
  801fbb:	ff 75 08             	pushl  0x8(%ebp)
  801fbe:	e8 87 ec ff ff       	call   800c4a <sys_page_alloc>
  801fc3:	83 c4 10             	add    $0x10,%esp
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	0f 89 0a 01 00 00    	jns    8020d8 <map_segment+0x15c>
				return r;
  801fce:	e9 19 01 00 00       	jmp    8020ec <map_segment+0x170>
		} else {
			// from file
			if (perm & PTE_W) {
  801fd3:	f6 45 20 02          	testb  $0x2,0x20(%ebp)
  801fd7:	0f 84 ac 00 00 00    	je     802089 <map_segment+0x10d>
				// must make a copy so it can be writable
				if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801fdd:	83 ec 04             	sub    $0x4,%esp
  801fe0:	6a 07                	push   $0x7
  801fe2:	68 00 00 40 00       	push   $0x400000
  801fe7:	6a 00                	push   $0x0
  801fe9:	e8 5c ec ff ff       	call   800c4a <sys_page_alloc>
  801fee:	83 c4 10             	add    $0x10,%esp
  801ff1:	85 c0                	test   %eax,%eax
  801ff3:	0f 88 f3 00 00 00    	js     8020ec <map_segment+0x170>
					return r;
				if ((r = seek(fd, fileoffset + i)) < 0)
  801ff9:	83 ec 08             	sub    $0x8,%esp
  801ffc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801fff:	01 d8                	add    %ebx,%eax
  802001:	50                   	push   %eax
  802002:	ff 75 14             	pushl  0x14(%ebp)
  802005:	e8 11 f4 ff ff       	call   80141b <seek>
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	85 c0                	test   %eax,%eax
  80200f:	0f 88 d7 00 00 00    	js     8020ec <map_segment+0x170>
					return r;
				if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802015:	89 fa                	mov    %edi,%edx
  802017:	29 da                	sub    %ebx,%edx
  802019:	b8 00 10 00 00       	mov    $0x1000,%eax
  80201e:	39 d0                	cmp    %edx,%eax
  802020:	76 02                	jbe    802024 <map_segment+0xa8>
  802022:	89 d0                	mov    %edx,%eax
  802024:	83 ec 04             	sub    $0x4,%esp
  802027:	50                   	push   %eax
  802028:	68 00 00 40 00       	push   $0x400000
  80202d:	ff 75 14             	pushl  0x14(%ebp)
  802030:	e8 84 f2 ff ff       	call   8012b9 <read>
  802035:	83 c4 10             	add    $0x10,%esp
  802038:	85 c0                	test   %eax,%eax
  80203a:	0f 88 ac 00 00 00    	js     8020ec <map_segment+0x170>
					return r;
				if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802040:	83 ec 0c             	sub    $0xc,%esp
  802043:	ff 75 20             	pushl  0x20(%ebp)
  802046:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  802049:	50                   	push   %eax
  80204a:	ff 75 08             	pushl  0x8(%ebp)
  80204d:	68 00 00 40 00       	push   $0x400000
  802052:	6a 00                	push   $0x0
  802054:	e8 34 ec ff ff       	call   800c8d <sys_page_map>
  802059:	83 c4 20             	add    $0x20,%esp
  80205c:	85 c0                	test   %eax,%eax
  80205e:	79 15                	jns    802075 <map_segment+0xf9>
					panic("spawn: sys_page_map data: %e", r);
  802060:	50                   	push   %eax
  802061:	68 80 30 80 00       	push   $0x803080
  802066:	68 0e 01 00 00       	push   $0x10e
  80206b:	68 43 30 80 00       	push   $0x803043
  802070:	e8 0f e1 ff ff       	call   800184 <_panic>
				sys_page_unmap(0, UTEMP);
  802075:	83 ec 08             	sub    $0x8,%esp
  802078:	68 00 00 40 00       	push   $0x400000
  80207d:	6a 00                	push   $0x0
  80207f:	e8 4b ec ff ff       	call   800ccf <sys_page_unmap>
  802084:	83 c4 10             	add    $0x10,%esp
  802087:	eb 4f                	jmp    8020d8 <map_segment+0x15c>
			} else {
				// can map buffer cache read only
				if ((r = read_map(fd, fileoffset + i, &blk)) < 0)
  802089:	83 ec 04             	sub    $0x4,%esp
  80208c:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80208f:	50                   	push   %eax
  802090:	8b 45 1c             	mov    0x1c(%ebp),%eax
  802093:	01 d8                	add    %ebx,%eax
  802095:	50                   	push   %eax
  802096:	ff 75 14             	pushl  0x14(%ebp)
  802099:	e8 11 f6 ff ff       	call   8016af <read_map>
  80209e:	83 c4 10             	add    $0x10,%esp
  8020a1:	85 c0                	test   %eax,%eax
  8020a3:	78 47                	js     8020ec <map_segment+0x170>
					return r;
				if ((r = sys_page_map(0, blk, child, (void*) (va + i), perm)) < 0)
  8020a5:	83 ec 0c             	sub    $0xc,%esp
  8020a8:	ff 75 20             	pushl  0x20(%ebp)
  8020ab:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8020ae:	50                   	push   %eax
  8020af:	ff 75 08             	pushl  0x8(%ebp)
  8020b2:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8020b5:	6a 00                	push   $0x0
  8020b7:	e8 d1 eb ff ff       	call   800c8d <sys_page_map>
  8020bc:	83 c4 20             	add    $0x20,%esp
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	79 15                	jns    8020d8 <map_segment+0x15c>
					panic("spawn: sys_page_map text: %e", r);
  8020c3:	50                   	push   %eax
  8020c4:	68 9d 30 80 00       	push   $0x80309d
  8020c9:	68 15 01 00 00       	push   $0x115
  8020ce:	68 43 30 80 00       	push   $0x803043
  8020d3:	e8 ac e0 ff ff       	call   800184 <_panic>
  8020d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8020de:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8020e1:	0f 82 c6 fe ff ff    	jb     801fad <map_segment+0x31>
			}
		}
	}
	return 0;
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ec:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8020ef:	5b                   	pop    %ebx
  8020f0:	5e                   	pop    %esi
  8020f1:	5f                   	pop    %edi
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child) {
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	57                   	push   %edi
  8020f8:	56                   	push   %esi
  8020f9:	53                   	push   %ebx
  8020fa:	83 ec 0c             	sub    $0xc,%esp
  // LAB 7: Your code here.

  int i,j, r;
  void* va;

  for (i=0; i < VPD(UTOP); i++) {
  8020fd:	be 00 00 00 00       	mov    $0x0,%esi
    if (vpd[i] & PTE_P) {
  802102:	8b 04 b5 00 d0 7b ef 	mov    0xef7bd000(,%esi,4),%eax
  802109:	a8 01                	test   $0x1,%al
  80210b:	74 68                	je     802175 <copy_shared_pages+0x81>
      for (j=0; j<NPTENTRIES && i*NPDENTRIES+j < (UXSTACKTOP-PGSIZE)/PGSIZE; j++) { // make sure not to remap exception stack this way
  80210d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802112:	89 f0                	mov    %esi,%eax
  802114:	c1 e0 0a             	shl    $0xa,%eax
  802117:	89 c2                	mov    %eax,%edx
  802119:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  80211e:	77 55                	ja     802175 <copy_shared_pages+0x81>
  802120:	89 c7                	mov    %eax,%edi
        if ((vpt[i*NPDENTRIES+j] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  802122:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  802125:	8b 04 8d 00 00 40 ef 	mov    0xef400000(,%ecx,4),%eax
  80212c:	25 01 04 00 00       	and    $0x401,%eax
  802131:	3d 01 04 00 00       	cmp    $0x401,%eax
  802136:	75 28                	jne    802160 <copy_shared_pages+0x6c>
          va = (void *)((i*NPDENTRIES+j) << PGSHIFT);
  802138:	89 ca                	mov    %ecx,%edx
  80213a:	c1 e2 0c             	shl    $0xc,%edx
          if ((r = sys_page_map(0, va, child, va, vpt[i*NPDENTRIES+j] & PTE_USER)) < 0) {
  80213d:	83 ec 0c             	sub    $0xc,%esp
  802140:	8b 04 8d 00 00 40 ef 	mov    0xef400000(,%ecx,4),%eax
  802147:	25 07 0e 00 00       	and    $0xe07,%eax
  80214c:	50                   	push   %eax
  80214d:	52                   	push   %edx
  80214e:	ff 75 08             	pushl  0x8(%ebp)
  802151:	52                   	push   %edx
  802152:	6a 00                	push   $0x0
  802154:	e8 34 eb ff ff       	call   800c8d <sys_page_map>
  802159:	83 c4 20             	add    $0x20,%esp
  80215c:	85 c0                	test   %eax,%eax
  80215e:	78 23                	js     802183 <copy_shared_pages+0x8f>
  802160:	43                   	inc    %ebx
  802161:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  802167:	7f 0c                	jg     802175 <copy_shared_pages+0x81>
  802169:	89 fa                	mov    %edi,%edx
  80216b:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  80216e:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  802173:	76 ad                	jbe    802122 <copy_shared_pages+0x2e>
  802175:	46                   	inc    %esi
  802176:	81 fe ba 03 00 00    	cmp    $0x3ba,%esi
  80217c:	76 84                	jbe    802102 <copy_shared_pages+0xe>
            return r;
          }
        }
      }
    }
  }

  return 0;
  80217e:	b8 00 00 00 00       	mov    $0x0,%eax

}
  802183:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802186:	5b                   	pop    %ebx
  802187:	5e                   	pop    %esi
  802188:	5f                   	pop    %edi
  802189:	c9                   	leave  
  80218a:	c3                   	ret    
	...

0080218c <pipe>:
};

int
pipe(int pfd[2])
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	57                   	push   %edi
  802190:	56                   	push   %esi
  802191:	53                   	push   %ebx
  802192:	83 ec 18             	sub    $0x18,%esp
  802195:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802198:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80219b:	50                   	push   %eax
  80219c:	e8 2b ee ff ff       	call   800fcc <fd_alloc>
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	0f 88 25 01 00 00    	js     8022d3 <pipe+0x147>
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	68 07 04 00 00       	push   $0x407
  8021b6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8021b9:	6a 00                	push   $0x0
  8021bb:	e8 8a ea ff ff       	call   800c4a <sys_page_alloc>
  8021c0:	89 c3                	mov    %eax,%ebx
  8021c2:	83 c4 10             	add    $0x10,%esp
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	0f 88 06 01 00 00    	js     8022d3 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8021cd:	83 ec 0c             	sub    $0xc,%esp
  8021d0:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  8021d3:	50                   	push   %eax
  8021d4:	e8 f3 ed ff ff       	call   800fcc <fd_alloc>
  8021d9:	89 c3                	mov    %eax,%ebx
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	0f 88 dd 00 00 00    	js     8022c3 <pipe+0x137>
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	68 07 04 00 00       	push   $0x407
  8021ee:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8021f1:	6a 00                	push   $0x0
  8021f3:	e8 52 ea ff ff       	call   800c4a <sys_page_alloc>
  8021f8:	89 c3                	mov    %eax,%ebx
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	0f 88 be 00 00 00    	js     8022c3 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802205:	83 ec 0c             	sub    $0xc,%esp
  802208:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80220b:	e8 94 ed ff ff       	call   800fa4 <fd2data>
  802210:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802212:	83 c4 0c             	add    $0xc,%esp
  802215:	68 07 04 00 00       	push   $0x407
  80221a:	50                   	push   %eax
  80221b:	6a 00                	push   $0x0
  80221d:	e8 28 ea ff ff       	call   800c4a <sys_page_alloc>
  802222:	89 c3                	mov    %eax,%ebx
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	85 c0                	test   %eax,%eax
  802229:	0f 88 84 00 00 00    	js     8022b3 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80222f:	83 ec 0c             	sub    $0xc,%esp
  802232:	68 07 04 00 00       	push   $0x407
  802237:	83 ec 0c             	sub    $0xc,%esp
  80223a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80223d:	e8 62 ed ff ff       	call   800fa4 <fd2data>
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	50                   	push   %eax
  802246:	6a 00                	push   $0x0
  802248:	56                   	push   %esi
  802249:	6a 00                	push   $0x0
  80224b:	e8 3d ea ff ff       	call   800c8d <sys_page_map>
  802250:	89 c3                	mov    %eax,%ebx
  802252:	83 c4 20             	add    $0x20,%esp
  802255:	85 c0                	test   %eax,%eax
  802257:	78 4c                	js     8022a5 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802259:	8b 15 40 70 80 00    	mov    0x807040,%edx
  80225f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802262:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802264:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802267:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80226e:	8b 15 40 70 80 00    	mov    0x807040,%edx
  802274:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802277:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802279:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80227c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802283:	83 ec 0c             	sub    $0xc,%esp
  802286:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802289:	e8 2e ed ff ff       	call   800fbc <fd2num>
  80228e:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802290:	83 c4 04             	add    $0x4,%esp
  802293:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802296:	e8 21 ed ff ff       	call   800fbc <fd2num>
  80229b:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a3:	eb 30                	jmp    8022d5 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  8022a5:	83 ec 08             	sub    $0x8,%esp
  8022a8:	56                   	push   %esi
  8022a9:	6a 00                	push   $0x0
  8022ab:	e8 1f ea ff ff       	call   800ccf <sys_page_unmap>
  8022b0:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  8022b3:	83 ec 08             	sub    $0x8,%esp
  8022b6:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8022b9:	6a 00                	push   $0x0
  8022bb:	e8 0f ea ff ff       	call   800ccf <sys_page_unmap>
  8022c0:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8022c3:	83 ec 08             	sub    $0x8,%esp
  8022c6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8022c9:	6a 00                	push   $0x0
  8022cb:	e8 ff e9 ff ff       	call   800ccf <sys_page_unmap>
  8022d0:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  8022d3:	89 d8                	mov    %ebx,%eax
}
  8022d5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8022d8:	5b                   	pop    %ebx
  8022d9:	5e                   	pop    %esi
  8022da:	5f                   	pop    %edi
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	57                   	push   %edi
  8022e1:	56                   	push   %esi
  8022e2:	53                   	push   %ebx
  8022e3:	83 ec 0c             	sub    $0xc,%esp
  8022e6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8022e9:	a1 80 70 80 00       	mov    0x807080,%eax
  8022ee:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8022f1:	83 ec 0c             	sub    $0xc,%esp
  8022f4:	ff 75 08             	pushl  0x8(%ebp)
  8022f7:	e8 50 04 00 00       	call   80274c <pageref>
  8022fc:	89 c3                	mov    %eax,%ebx
  8022fe:	89 3c 24             	mov    %edi,(%esp)
  802301:	e8 46 04 00 00       	call   80274c <pageref>
  802306:	83 c4 10             	add    $0x10,%esp
  802309:	39 c3                	cmp    %eax,%ebx
  80230b:	0f 94 c0             	sete   %al
  80230e:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  802311:	8b 0d 80 70 80 00    	mov    0x807080,%ecx
  802317:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  80231a:	39 c6                	cmp    %eax,%esi
  80231c:	74 1b                	je     802339 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  80231e:	83 fa 01             	cmp    $0x1,%edx
  802321:	75 c6                	jne    8022e9 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802323:	6a 01                	push   $0x1
  802325:	8b 41 58             	mov    0x58(%ecx),%eax
  802328:	50                   	push   %eax
  802329:	56                   	push   %esi
  80232a:	68 e7 30 80 00       	push   $0x8030e7
  80232f:	e8 40 df ff ff       	call   800274 <cprintf>
  802334:	83 c4 10             	add    $0x10,%esp
  802337:	eb b0                	jmp    8022e9 <_pipeisclosed+0xc>
	}
}
  802339:	89 d0                	mov    %edx,%eax
  80233b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80233e:	5b                   	pop    %ebx
  80233f:	5e                   	pop    %esi
  802340:	5f                   	pop    %edi
  802341:	c9                   	leave  
  802342:	c3                   	ret    

00802343 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802349:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80234c:	50                   	push   %eax
  80234d:	ff 75 08             	pushl  0x8(%ebp)
  802350:	e8 d1 ec ff ff       	call   801026 <fd_lookup>
  802355:	83 c4 10             	add    $0x10,%esp
		return r;
  802358:	89 c2                	mov    %eax,%edx
  80235a:	85 c0                	test   %eax,%eax
  80235c:	78 19                	js     802377 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  80235e:	83 ec 0c             	sub    $0xc,%esp
  802361:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802364:	e8 3b ec ff ff       	call   800fa4 <fd2data>
	return _pipeisclosed(fd, p);
  802369:	83 c4 08             	add    $0x8,%esp
  80236c:	50                   	push   %eax
  80236d:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802370:	e8 68 ff ff ff       	call   8022dd <_pipeisclosed>
  802375:	89 c2                	mov    %eax,%edx
}
  802377:	89 d0                	mov    %edx,%eax
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	57                   	push   %edi
  80237f:	56                   	push   %esi
  802380:	53                   	push   %ebx
  802381:	83 ec 18             	sub    $0x18,%esp
  802384:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  802387:	57                   	push   %edi
  802388:	e8 17 ec ff ff       	call   800fa4 <fd2data>
  80238d:	89 c3                	mov    %eax,%ebx
	if (debug)
  80238f:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802392:	8b 45 0c             	mov    0xc(%ebp),%eax
  802395:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802398:	be 00 00 00 00       	mov    $0x0,%esi
  80239d:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023a0:	73 55                	jae    8023f7 <piperead+0x7c>
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
  8023a2:	8b 03                	mov    (%ebx),%eax
  8023a4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023a7:	75 2c                	jne    8023d5 <piperead+0x5a>
  8023a9:	85 f6                	test   %esi,%esi
  8023ab:	74 04                	je     8023b1 <piperead+0x36>
  8023ad:	89 f0                	mov    %esi,%eax
  8023af:	eb 48                	jmp    8023f9 <piperead+0x7e>
  8023b1:	83 ec 08             	sub    $0x8,%esp
  8023b4:	53                   	push   %ebx
  8023b5:	57                   	push   %edi
  8023b6:	e8 22 ff ff ff       	call   8022dd <_pipeisclosed>
  8023bb:	83 c4 10             	add    $0x10,%esp
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	74 07                	je     8023c9 <piperead+0x4e>
  8023c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c7:	eb 30                	jmp    8023f9 <piperead+0x7e>
  8023c9:	e8 5d e8 ff ff       	call   800c2b <sys_yield>
  8023ce:	8b 03                	mov    (%ebx),%eax
  8023d0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023d3:	74 d4                	je     8023a9 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023d5:	8b 13                	mov    (%ebx),%edx
  8023d7:	89 d0                	mov    %edx,%eax
  8023d9:	85 d2                	test   %edx,%edx
  8023db:	79 03                	jns    8023e0 <piperead+0x65>
  8023dd:	8d 42 1f             	lea    0x1f(%edx),%eax
  8023e0:	83 e0 e0             	and    $0xffffffe0,%eax
  8023e3:	29 c2                	sub    %eax,%edx
  8023e5:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  8023e9:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8023ec:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8023ef:	ff 03                	incl   (%ebx)
  8023f1:	46                   	inc    %esi
  8023f2:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023f5:	72 ab                	jb     8023a2 <piperead+0x27>
	}
	return i;
  8023f7:	89 f0                	mov    %esi,%eax
}
  8023f9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	c9                   	leave  
  802400:	c3                   	ret    

00802401 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	57                   	push   %edi
  802405:	56                   	push   %esi
  802406:	53                   	push   %ebx
  802407:	83 ec 18             	sub    $0x18,%esp
  80240a:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  80240d:	57                   	push   %edi
  80240e:	e8 91 eb ff ff       	call   800fa4 <fd2data>
  802413:	89 c3                	mov    %eax,%ebx
	if (debug)
  802415:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80241e:	be 00 00 00 00       	mov    $0x0,%esi
  802423:	3b 75 10             	cmp    0x10(%ebp),%esi
  802426:	73 55                	jae    80247d <pipewrite+0x7c>
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
  802428:	8b 03                	mov    (%ebx),%eax
  80242a:	83 c0 20             	add    $0x20,%eax
  80242d:	39 43 04             	cmp    %eax,0x4(%ebx)
  802430:	72 27                	jb     802459 <pipewrite+0x58>
  802432:	83 ec 08             	sub    $0x8,%esp
  802435:	53                   	push   %ebx
  802436:	57                   	push   %edi
  802437:	e8 a1 fe ff ff       	call   8022dd <_pipeisclosed>
  80243c:	83 c4 10             	add    $0x10,%esp
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 07                	je     80244a <pipewrite+0x49>
  802443:	b8 00 00 00 00       	mov    $0x0,%eax
  802448:	eb 35                	jmp    80247f <pipewrite+0x7e>
  80244a:	e8 dc e7 ff ff       	call   800c2b <sys_yield>
  80244f:	8b 03                	mov    (%ebx),%eax
  802451:	83 c0 20             	add    $0x20,%eax
  802454:	39 43 04             	cmp    %eax,0x4(%ebx)
  802457:	73 d9                	jae    802432 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802459:	8b 53 04             	mov    0x4(%ebx),%edx
  80245c:	89 d0                	mov    %edx,%eax
  80245e:	85 d2                	test   %edx,%edx
  802460:	79 03                	jns    802465 <pipewrite+0x64>
  802462:	8d 42 1f             	lea    0x1f(%edx),%eax
  802465:	83 e0 e0             	and    $0xffffffe0,%eax
  802468:	29 c2                	sub    %eax,%edx
  80246a:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  80246d:	8a 04 31             	mov    (%ecx,%esi,1),%al
  802470:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802474:	ff 43 04             	incl   0x4(%ebx)
  802477:	46                   	inc    %esi
  802478:	3b 75 10             	cmp    0x10(%ebp),%esi
  80247b:	72 ab                	jb     802428 <pipewrite+0x27>
	}
	
	return i;
  80247d:	89 f0                	mov    %esi,%eax
}
  80247f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802482:	5b                   	pop    %ebx
  802483:	5e                   	pop    %esi
  802484:	5f                   	pop    %edi
  802485:	c9                   	leave  
  802486:	c3                   	ret    

00802487 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  802487:	55                   	push   %ebp
  802488:	89 e5                	mov    %esp,%ebp
  80248a:	56                   	push   %esi
  80248b:	53                   	push   %ebx
  80248c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80248f:	83 ec 0c             	sub    $0xc,%esp
  802492:	ff 75 08             	pushl  0x8(%ebp)
  802495:	e8 0a eb ff ff       	call   800fa4 <fd2data>
  80249a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80249c:	83 c4 08             	add    $0x8,%esp
  80249f:	68 fa 30 80 00       	push   $0x8030fa
  8024a4:	53                   	push   %ebx
  8024a5:	e8 ce e3 ff ff       	call   800878 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024aa:	8b 46 04             	mov    0x4(%esi),%eax
  8024ad:	2b 06                	sub    (%esi),%eax
  8024af:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024b5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024bc:	00 00 00 
	stat->st_dev = &devpipe;
  8024bf:	c7 83 88 00 00 00 40 	movl   $0x807040,0x88(%ebx)
  8024c6:	70 80 00 
	return 0;
}
  8024c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ce:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	53                   	push   %ebx
  8024d9:	83 ec 0c             	sub    $0xc,%esp
  8024dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024df:	53                   	push   %ebx
  8024e0:	6a 00                	push   $0x0
  8024e2:	e8 e8 e7 ff ff       	call   800ccf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024e7:	89 1c 24             	mov    %ebx,(%esp)
  8024ea:	e8 b5 ea ff ff       	call   800fa4 <fd2data>
  8024ef:	83 c4 08             	add    $0x8,%esp
  8024f2:	50                   	push   %eax
  8024f3:	6a 00                	push   $0x0
  8024f5:	e8 d5 e7 ff ff       	call   800ccf <sys_page_unmap>
}
  8024fa:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    
	...

00802500 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80250c:	6a 01                	push   $0x1
  80250e:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802511:	50                   	push   %eax
  802512:	e8 71 e6 ff ff       	call   800b88 <sys_cputs>
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <getchar>:

int
getchar(void)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
  80251c:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80251f:	6a 01                	push   $0x1
  802521:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802524:	50                   	push   %eax
  802525:	6a 00                	push   $0x0
  802527:	e8 8d ed ff ff       	call   8012b9 <read>
	if (r < 0)
  80252c:	83 c4 10             	add    $0x10,%esp
		return r;
  80252f:	89 c2                	mov    %eax,%edx
  802531:	85 c0                	test   %eax,%eax
  802533:	78 0d                	js     802542 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  802535:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  80253a:	85 c0                	test   %eax,%eax
  80253c:	7e 04                	jle    802542 <getchar+0x29>
	return c;
  80253e:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  802542:	89 d0                	mov    %edx,%eax
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <iscons>:


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
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80254c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80254f:	50                   	push   %eax
  802550:	ff 75 08             	pushl  0x8(%ebp)
  802553:	e8 ce ea ff ff       	call   801026 <fd_lookup>
  802558:	83 c4 10             	add    $0x10,%esp
		return r;
  80255b:	89 c2                	mov    %eax,%edx
  80255d:	85 c0                	test   %eax,%eax
  80255f:	78 11                	js     802572 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  802561:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802564:	8b 00                	mov    (%eax),%eax
  802566:	3b 05 60 70 80 00    	cmp    0x807060,%eax
  80256c:	0f 94 c0             	sete   %al
  80256f:	0f b6 d0             	movzbl %al,%edx
}
  802572:	89 d0                	mov    %edx,%eax
  802574:	c9                   	leave  
  802575:	c3                   	ret    

00802576 <opencons>:

int
opencons(void)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80257c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80257f:	50                   	push   %eax
  802580:	e8 47 ea ff ff       	call   800fcc <fd_alloc>
  802585:	83 c4 10             	add    $0x10,%esp
		return r;
  802588:	89 c2                	mov    %eax,%edx
  80258a:	85 c0                	test   %eax,%eax
  80258c:	78 3c                	js     8025ca <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80258e:	83 ec 04             	sub    $0x4,%esp
  802591:	68 07 04 00 00       	push   $0x407
  802596:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802599:	6a 00                	push   $0x0
  80259b:	e8 aa e6 ff ff       	call   800c4a <sys_page_alloc>
  8025a0:	83 c4 10             	add    $0x10,%esp
		return r;
  8025a3:	89 c2                	mov    %eax,%edx
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	78 21                	js     8025ca <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8025a9:	a1 60 70 80 00       	mov    0x807060,%eax
  8025ae:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  8025b1:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  8025b3:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8025b6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025bd:	83 ec 0c             	sub    $0xc,%esp
  8025c0:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8025c3:	e8 f4 e9 ff ff       	call   800fbc <fd2num>
  8025c8:	89 c2                	mov    %eax,%edx
}
  8025ca:	89 d0                	mov    %edx,%eax
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    

008025ce <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8025ce:	55                   	push   %ebp
  8025cf:	89 e5                	mov    %esp,%ebp
  8025d1:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  8025d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025dd:	74 2a                	je     802609 <cons_read+0x3b>
  8025df:	eb 05                	jmp    8025e6 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8025e1:	e8 45 e6 ff ff       	call   800c2b <sys_yield>
  8025e6:	e8 c1 e5 ff ff       	call   800bac <sys_cgetc>
  8025eb:	89 c2                	mov    %eax,%edx
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	74 f0                	je     8025e1 <cons_read+0x13>
	if (c < 0)
  8025f1:	85 d2                	test   %edx,%edx
  8025f3:	78 14                	js     802609 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8025f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fa:	83 fa 04             	cmp    $0x4,%edx
  8025fd:	74 0a                	je     802609 <cons_read+0x3b>
	*(char*)vbuf = c;
  8025ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  802602:	88 10                	mov    %dl,(%eax)
	return 1;
  802604:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802609:	c9                   	leave  
  80260a:	c3                   	ret    

0080260b <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
  80260e:	57                   	push   %edi
  80260f:	56                   	push   %esi
  802610:	53                   	push   %ebx
  802611:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  802617:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80261a:	be 00 00 00 00       	mov    $0x0,%esi
  80261f:	39 fe                	cmp    %edi,%esi
  802621:	73 3d                	jae    802660 <cons_write+0x55>
		m = n - tot;
  802623:	89 fb                	mov    %edi,%ebx
  802625:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  802627:	83 fb 7f             	cmp    $0x7f,%ebx
  80262a:	76 05                	jbe    802631 <cons_write+0x26>
			m = sizeof(buf) - 1;
  80262c:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	53                   	push   %ebx
  802635:	8b 45 0c             	mov    0xc(%ebp),%eax
  802638:	01 f0                	add    %esi,%eax
  80263a:	50                   	push   %eax
  80263b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802641:	50                   	push   %eax
  802642:	e8 ad e3 ff ff       	call   8009f4 <memmove>
		sys_cputs(buf, m);
  802647:	83 c4 08             	add    $0x8,%esp
  80264a:	53                   	push   %ebx
  80264b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802651:	50                   	push   %eax
  802652:	e8 31 e5 ff ff       	call   800b88 <sys_cputs>
  802657:	83 c4 10             	add    $0x10,%esp
  80265a:	01 de                	add    %ebx,%esi
  80265c:	39 fe                	cmp    %edi,%esi
  80265e:	72 c3                	jb     802623 <cons_write+0x18>
	}
	return tot;
}
  802660:	89 f0                	mov    %esi,%eax
  802662:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802665:	5b                   	pop    %ebx
  802666:	5e                   	pop    %esi
  802667:	5f                   	pop    %edi
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <cons_close>:

int
cons_close(struct Fd *fd)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80266d:	b8 00 00 00 00       	mov    $0x0,%eax
  802672:	c9                   	leave  
  802673:	c3                   	ret    

00802674 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80267a:	68 06 31 80 00       	push   $0x803106
  80267f:	ff 75 0c             	pushl  0xc(%ebp)
  802682:	e8 f1 e1 ff ff       	call   800878 <strcpy>
	return 0;
}
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
  80268c:	c9                   	leave  
  80268d:	c3                   	ret    
	...

00802690 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	56                   	push   %esi
  802694:	53                   	push   %ebx
  802695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80269b:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80269e:	85 c0                	test   %eax,%eax
  8026a0:	75 12                	jne    8026b4 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  8026a2:	83 ec 0c             	sub    $0xc,%esp
  8026a5:	68 00 00 c0 ee       	push   $0xeec00000
  8026aa:	e8 4b e7 ff ff       	call   800dfa <sys_ipc_recv>
  8026af:	83 c4 10             	add    $0x10,%esp
  8026b2:	eb 0c                	jmp    8026c0 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  8026b4:	83 ec 0c             	sub    $0xc,%esp
  8026b7:	50                   	push   %eax
  8026b8:	e8 3d e7 ff ff       	call   800dfa <sys_ipc_recv>
  8026bd:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  8026c0:	89 c2                	mov    %eax,%edx
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	78 24                	js     8026ea <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  8026c6:	85 db                	test   %ebx,%ebx
  8026c8:	74 0a                	je     8026d4 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  8026ca:	a1 80 70 80 00       	mov    0x807080,%eax
  8026cf:	8b 40 74             	mov    0x74(%eax),%eax
  8026d2:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  8026d4:	85 f6                	test   %esi,%esi
  8026d6:	74 0a                	je     8026e2 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  8026d8:	a1 80 70 80 00       	mov    0x807080,%eax
  8026dd:	8b 40 78             	mov    0x78(%eax),%eax
  8026e0:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  8026e2:	a1 80 70 80 00       	mov    0x807080,%eax
  8026e7:	8b 50 70             	mov    0x70(%eax),%edx

}
  8026ea:	89 d0                	mov    %edx,%eax
  8026ec:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8026ef:	5b                   	pop    %ebx
  8026f0:	5e                   	pop    %esi
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <ipc_send>:

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
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
  8026f6:	57                   	push   %edi
  8026f7:	56                   	push   %esi
  8026f8:	53                   	push   %ebx
  8026f9:	83 ec 0c             	sub    $0xc,%esp
  8026fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8026ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802702:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802705:	85 db                	test   %ebx,%ebx
  802707:	75 0a                	jne    802713 <ipc_send+0x20>
    pg = (void *) UTOP;
  802709:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  80270e:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  802713:	56                   	push   %esi
  802714:	53                   	push   %ebx
  802715:	57                   	push   %edi
  802716:	ff 75 08             	pushl  0x8(%ebp)
  802719:	e8 b9 e6 ff ff       	call   800dd7 <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  80271e:	83 c4 10             	add    $0x10,%esp
  802721:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802724:	75 07                	jne    80272d <ipc_send+0x3a>
      sys_yield();
  802726:	e8 00 e5 ff ff       	call   800c2b <sys_yield>
  80272b:	eb e6                	jmp    802713 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  80272d:	85 c0                	test   %eax,%eax
  80272f:	79 12                	jns    802743 <ipc_send+0x50>
  802731:	50                   	push   %eax
  802732:	68 0d 31 80 00       	push   $0x80310d
  802737:	6a 49                	push   $0x49
  802739:	68 2a 31 80 00       	push   $0x80312a
  80273e:	e8 41 da ff ff       	call   800184 <_panic>
    else break;
  }
}
  802743:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802746:	5b                   	pop    %ebx
  802747:	5e                   	pop    %esi
  802748:	5f                   	pop    %edi
  802749:	c9                   	leave  
  80274a:	c3                   	ret    
	...

0080274c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80274c:	55                   	push   %ebp
  80274d:	89 e5                	mov    %esp,%ebp
  80274f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802752:	89 c8                	mov    %ecx,%eax
  802754:	c1 e8 16             	shr    $0x16,%eax
  802757:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  80275e:	ba 00 00 00 00       	mov    $0x0,%edx
  802763:	a8 01                	test   $0x1,%al
  802765:	74 28                	je     80278f <pageref+0x43>
	pte = vpt[VPN(v)];
  802767:	89 c8                	mov    %ecx,%eax
  802769:	c1 e8 0c             	shr    $0xc,%eax
  80276c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  802773:	ba 00 00 00 00       	mov    $0x0,%edx
  802778:	a8 01                	test   $0x1,%al
  80277a:	74 13                	je     80278f <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  80277c:	c1 e8 0c             	shr    $0xc,%eax
  80277f:	8d 04 40             	lea    (%eax,%eax,2),%eax
  802782:	c1 e0 02             	shl    $0x2,%eax
  802785:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  80278c:	0f b7 d0             	movzwl %ax,%edx
}
  80278f:	89 d0                	mov    %edx,%eax
  802791:	c9                   	leave  
  802792:	c3                   	ret    
	...

00802794 <__udivdi3>:
  802794:	55                   	push   %ebp
  802795:	89 e5                	mov    %esp,%ebp
  802797:	57                   	push   %edi
  802798:	56                   	push   %esi
  802799:	83 ec 14             	sub    $0x14,%esp
  80279c:	8b 55 14             	mov    0x14(%ebp),%edx
  80279f:	8b 75 08             	mov    0x8(%ebp),%esi
  8027a2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8027a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a8:	85 d2                	test   %edx,%edx
  8027aa:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8027ad:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8027b0:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8027b3:	89 fe                	mov    %edi,%esi
  8027b5:	75 11                	jne    8027c8 <__udivdi3+0x34>
  8027b7:	39 f8                	cmp    %edi,%eax
  8027b9:	76 4d                	jbe    802808 <__udivdi3+0x74>
  8027bb:	89 fa                	mov    %edi,%edx
  8027bd:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8027c0:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8027c3:	89 c7                	mov    %eax,%edi
  8027c5:	eb 09                	jmp    8027d0 <__udivdi3+0x3c>
  8027c7:	90                   	nop    
  8027c8:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  8027cb:	76 17                	jbe    8027e4 <__udivdi3+0x50>
  8027cd:	31 ff                	xor    %edi,%edi
  8027cf:	90                   	nop    
  8027d0:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  8027d7:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8027da:	83 c4 14             	add    $0x14,%esp
  8027dd:	5e                   	pop    %esi
  8027de:	89 f8                	mov    %edi,%eax
  8027e0:	5f                   	pop    %edi
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    
  8027e3:	90                   	nop    
  8027e4:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  8027e8:	89 c7                	mov    %eax,%edi
  8027ea:	83 f7 1f             	xor    $0x1f,%edi
  8027ed:	75 4d                	jne    80283c <__udivdi3+0xa8>
  8027ef:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8027f2:	77 0a                	ja     8027fe <__udivdi3+0x6a>
  8027f4:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8027f7:	31 ff                	xor    %edi,%edi
  8027f9:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  8027fc:	72 d2                	jb     8027d0 <__udivdi3+0x3c>
  8027fe:	bf 01 00 00 00       	mov    $0x1,%edi
  802803:	eb cb                	jmp    8027d0 <__udivdi3+0x3c>
  802805:	8d 76 00             	lea    0x0(%esi),%esi
  802808:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80280b:	85 c0                	test   %eax,%eax
  80280d:	75 0e                	jne    80281d <__udivdi3+0x89>
  80280f:	b8 01 00 00 00       	mov    $0x1,%eax
  802814:	31 c9                	xor    %ecx,%ecx
  802816:	31 d2                	xor    %edx,%edx
  802818:	f7 f1                	div    %ecx
  80281a:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80281d:	89 f0                	mov    %esi,%eax
  80281f:	31 d2                	xor    %edx,%edx
  802821:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802824:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  802827:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80282a:	f7 75 e4             	divl   0xffffffe4(%ebp)
  80282d:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802830:	83 c4 14             	add    $0x14,%esp
  802833:	89 c7                	mov    %eax,%edi
  802835:	5e                   	pop    %esi
  802836:	89 f8                	mov    %edi,%eax
  802838:	5f                   	pop    %edi
  802839:	c9                   	leave  
  80283a:	c3                   	ret    
  80283b:	90                   	nop    
  80283c:	b8 20 00 00 00       	mov    $0x20,%eax
  802841:	29 f8                	sub    %edi,%eax
  802843:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  802846:	89 f9                	mov    %edi,%ecx
  802848:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80284b:	d3 e2                	shl    %cl,%edx
  80284d:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802850:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802853:	d3 e8                	shr    %cl,%eax
  802855:	09 c2                	or     %eax,%edx
  802857:	89 f9                	mov    %edi,%ecx
  802859:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  80285c:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  80285f:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802862:	89 f2                	mov    %esi,%edx
  802864:	d3 ea                	shr    %cl,%edx
  802866:	89 f9                	mov    %edi,%ecx
  802868:	d3 e6                	shl    %cl,%esi
  80286a:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80286d:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802870:	d3 e8                	shr    %cl,%eax
  802872:	09 c6                	or     %eax,%esi
  802874:	89 f9                	mov    %edi,%ecx
  802876:	89 f0                	mov    %esi,%eax
  802878:	f7 75 f4             	divl   0xfffffff4(%ebp)
  80287b:	89 d6                	mov    %edx,%esi
  80287d:	89 c7                	mov    %eax,%edi
  80287f:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  802882:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802885:	f7 e7                	mul    %edi
  802887:	39 f2                	cmp    %esi,%edx
  802889:	77 0f                	ja     80289a <__udivdi3+0x106>
  80288b:	0f 85 3f ff ff ff    	jne    8027d0 <__udivdi3+0x3c>
  802891:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802894:	0f 86 36 ff ff ff    	jbe    8027d0 <__udivdi3+0x3c>
  80289a:	4f                   	dec    %edi
  80289b:	e9 30 ff ff ff       	jmp    8027d0 <__udivdi3+0x3c>

008028a0 <__umoddi3>:
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	57                   	push   %edi
  8028a4:	56                   	push   %esi
  8028a5:	83 ec 30             	sub    $0x30,%esp
  8028a8:	8b 55 14             	mov    0x14(%ebp),%edx
  8028ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8028ae:	89 d7                	mov    %edx,%edi
  8028b0:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  8028b3:	89 c6                	mov    %eax,%esi
  8028b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bb:	85 ff                	test   %edi,%edi
  8028bd:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  8028c4:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8028cb:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  8028ce:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8028d1:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8028d4:	75 3e                	jne    802914 <__umoddi3+0x74>
  8028d6:	39 d6                	cmp    %edx,%esi
  8028d8:	0f 86 a2 00 00 00    	jbe    802980 <__umoddi3+0xe0>
  8028de:	f7 f6                	div    %esi
  8028e0:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8028e3:	85 c9                	test   %ecx,%ecx
  8028e5:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  8028e8:	74 1b                	je     802905 <__umoddi3+0x65>
  8028ea:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8028ed:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8028f0:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8028f7:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8028fa:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  8028fd:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802900:	89 10                	mov    %edx,(%eax)
  802902:	89 48 04             	mov    %ecx,0x4(%eax)
  802905:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802908:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80290b:	83 c4 30             	add    $0x30,%esp
  80290e:	5e                   	pop    %esi
  80290f:	5f                   	pop    %edi
  802910:	c9                   	leave  
  802911:	c3                   	ret    
  802912:	89 f6                	mov    %esi,%esi
  802914:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  802917:	76 1f                	jbe    802938 <__umoddi3+0x98>
  802919:	8b 55 08             	mov    0x8(%ebp),%edx
  80291c:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  80291f:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802922:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802925:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802928:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80292b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  80292e:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802931:	83 c4 30             	add    $0x30,%esp
  802934:	5e                   	pop    %esi
  802935:	5f                   	pop    %edi
  802936:	c9                   	leave  
  802937:	c3                   	ret    
  802938:	0f bd c7             	bsr    %edi,%eax
  80293b:	83 f0 1f             	xor    $0x1f,%eax
  80293e:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  802941:	75 61                	jne    8029a4 <__umoddi3+0x104>
  802943:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  802946:	77 05                	ja     80294d <__umoddi3+0xad>
  802948:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  80294b:	72 10                	jb     80295d <__umoddi3+0xbd>
  80294d:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802950:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802953:	29 f0                	sub    %esi,%eax
  802955:	19 fa                	sbb    %edi,%edx
  802957:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80295a:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80295d:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802960:	85 d2                	test   %edx,%edx
  802962:	74 a1                	je     802905 <__umoddi3+0x65>
  802964:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802967:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80296a:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  80296d:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  802970:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802973:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802976:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802979:	89 01                	mov    %eax,(%ecx)
  80297b:	89 51 04             	mov    %edx,0x4(%ecx)
  80297e:	eb 85                	jmp    802905 <__umoddi3+0x65>
  802980:	85 f6                	test   %esi,%esi
  802982:	75 0b                	jne    80298f <__umoddi3+0xef>
  802984:	b8 01 00 00 00       	mov    $0x1,%eax
  802989:	31 d2                	xor    %edx,%edx
  80298b:	f7 f6                	div    %esi
  80298d:	89 c6                	mov    %eax,%esi
  80298f:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802992:	89 fa                	mov    %edi,%edx
  802994:	f7 f6                	div    %esi
  802996:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802999:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  80299c:	f7 f6                	div    %esi
  80299e:	e9 3d ff ff ff       	jmp    8028e0 <__umoddi3+0x40>
  8029a3:	90                   	nop    
  8029a4:	b8 20 00 00 00       	mov    $0x20,%eax
  8029a9:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  8029ac:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  8029af:	89 fa                	mov    %edi,%edx
  8029b1:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8029b4:	d3 e2                	shl    %cl,%edx
  8029b6:	89 f0                	mov    %esi,%eax
  8029b8:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8029bb:	d3 e8                	shr    %cl,%eax
  8029bd:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8029c0:	d3 e6                	shl    %cl,%esi
  8029c2:	89 d7                	mov    %edx,%edi
  8029c4:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8029c7:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8029ca:	09 c7                	or     %eax,%edi
  8029cc:	d3 ea                	shr    %cl,%edx
  8029ce:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8029d1:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8029d4:	d3 e0                	shl    %cl,%eax
  8029d6:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8029d9:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8029dc:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8029df:	d3 e8                	shr    %cl,%eax
  8029e1:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  8029e4:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8029e7:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8029ea:	f7 f7                	div    %edi
  8029ec:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8029ef:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  8029f2:	f7 e6                	mul    %esi
  8029f4:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  8029f7:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  8029fa:	77 0a                	ja     802a06 <__umoddi3+0x166>
  8029fc:	75 12                	jne    802a10 <__umoddi3+0x170>
  8029fe:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a01:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802a04:	76 0a                	jbe    802a10 <__umoddi3+0x170>
  802a06:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  802a09:	29 f1                	sub    %esi,%ecx
  802a0b:	19 fa                	sbb    %edi,%edx
  802a0d:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802a10:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	0f 84 ea fe ff ff    	je     802905 <__umoddi3+0x65>
  802a1b:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802a1e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802a21:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802a24:	19 d1                	sbb    %edx,%ecx
  802a26:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  802a29:	89 ca                	mov    %ecx,%edx
  802a2b:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802a2e:	d3 e2                	shl    %cl,%edx
  802a30:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802a33:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802a36:	d3 e8                	shr    %cl,%eax
  802a38:	09 c2                	or     %eax,%edx
  802a3a:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802a3d:	d3 e8                	shr    %cl,%eax
  802a3f:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802a42:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802a45:	e9 ad fe ff ff       	jmp    8028f7 <__umoddi3+0x57>
