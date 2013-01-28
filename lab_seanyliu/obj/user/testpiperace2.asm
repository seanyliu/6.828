
obj/user/testpiperace2:     file format elf32-i386

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
  80002c:	e8 8f 01 00 00       	call   8001c0 <libmain>
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
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int p[2], r, i;
	struct Fd *fd;
	volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 a0 29 80 00       	push   $0x8029a0
  800041:	e8 c6 02 00 00       	call   80030c <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 cb 1f 00 00       	call   80201c <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	79 12                	jns    80006a <umain+0x36>
		panic("pipe: %e", r);
  800058:	50                   	push   %eax
  800059:	68 ee 29 80 00       	push   $0x8029ee
  80005e:	6a 0d                	push   $0xd
  800060:	68 f7 29 80 00       	push   $0x8029f7
  800065:	e8 b2 01 00 00       	call   80021c <_panic>
	if ((r = fork()) < 0)
  80006a:	e8 e3 11 00 00       	call   801252 <fork>
  80006f:	89 c6                	mov    %eax,%esi
  800071:	85 c0                	test   %eax,%eax
  800073:	79 12                	jns    800087 <umain+0x53>
		panic("fork: %e", r);
  800075:	50                   	push   %eax
  800076:	68 0c 2a 80 00       	push   $0x802a0c
  80007b:	6a 0f                	push   $0xf
  80007d:	68 f7 29 80 00       	push   $0x8029f7
  800082:	e8 95 01 00 00       	call   80021c <_panic>
	if (r == 0) {
  800087:	85 c0                	test   %eax,%eax
  800089:	75 68                	jne    8000f3 <umain+0xbf>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  800091:	e8 e8 14 00 00       	call   80157e <close>
		for (i = 0; i < 200; i++) {
  800096:	bb 00 00 00 00       	mov    $0x0,%ebx
  80009b:	83 c4 10             	add    $0x10,%esp
			if (i % 10 == 0)
  80009e:	ba 0a 00 00 00       	mov    $0xa,%edx
  8000a3:	89 d8                	mov    %ebx,%eax
  8000a5:	89 d1                	mov    %edx,%ecx
  8000a7:	99                   	cltd   
  8000a8:	f7 f9                	idiv   %ecx
  8000aa:	85 d2                	test   %edx,%edx
  8000ac:	75 11                	jne    8000bf <umain+0x8b>
				cprintf("%d.", i);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	53                   	push   %ebx
  8000b2:	68 15 2a 80 00       	push   $0x802a15
  8000b7:	e8 50 02 00 00       	call   80030c <cprintf>
  8000bc:	83 c4 10             	add    $0x10,%esp
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	6a 0a                	push   $0xa
  8000c4:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8000c7:	e8 03 15 00 00       	call   8015cf <dup>
			sys_yield();
  8000cc:	e8 f2 0b 00 00       	call   800cc3 <sys_yield>
			close(10);
  8000d1:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  8000d8:	e8 a1 14 00 00       	call   80157e <close>
			sys_yield();
  8000dd:	e8 e1 0b 00 00       	call   800cc3 <sys_yield>
  8000e2:	83 c4 10             	add    $0x10,%esp
  8000e5:	43                   	inc    %ebx
  8000e6:	81 fb c7 00 00 00    	cmp    $0xc7,%ebx
  8000ec:	7e b0                	jle    80009e <umain+0x6a>
		}
		exit();
  8000ee:	e8 11 01 00 00       	call   800204 <exit>
	}

	// We hold both p[0] and p[1] open, so pipeisclosed should
	// never return false.
	// 
	// Now the ref count for p[0] will toggle between 2 and 3
	// as the child dups and closes it.
	// The ref count for p[1] is 1.
	// Thus the ref count for the underlying pipe structure 
	// will toggle between 3 and 4.
	//
	// If pipeisclosed checks pageref(p[0]) and gets 3, and
	// then the child closes, and then pipeisclosed checks
	// pageref(pipe structure) and gets 3, then it will return true
	// when it shouldn't.
	//
	// If pipeisclosed checks pageref(pipe structure) and gets 3,
	// and then the child dups, and then pipeisclosed checks
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  8000f3:	89 f3                	mov    %esi,%ebx
  8000f5:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8000fb:	89 d8                	mov    %ebx,%eax
  8000fd:	c1 e0 07             	shl    $0x7,%eax
  800100:	8d 98 00 00 c0 ee    	lea    0xeec00000(%eax),%ebx
	while (kid->env_status == ENV_RUNNABLE)
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
  800106:	8b 43 54             	mov    0x54(%ebx),%eax
  800109:	83 f8 01             	cmp    $0x1,%eax
  80010c:	75 37                	jne    800145 <umain+0x111>
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800114:	e8 ba 20 00 00       	call   8021d3 <pipeisclosed>
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	85 c0                	test   %eax,%eax
  80011e:	74 1d                	je     80013d <umain+0x109>
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 19 2a 80 00       	push   $0x802a19
  800128:	e8 df 01 00 00       	call   80030c <cprintf>
  80012d:	89 34 24             	mov    %esi,(%esp)
  800130:	e8 2e 0b 00 00       	call   800c63 <sys_env_destroy>
  800135:	e8 ca 00 00 00       	call   800204 <exit>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	8b 43 54             	mov    0x54(%ebx),%eax
  800140:	83 f8 01             	cmp    $0x1,%eax
  800143:	74 c9                	je     80010e <umain+0xda>
		}
	cprintf("child done with loop\n");
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	68 35 2a 80 00       	push   $0x802a35
  80014d:	e8 ba 01 00 00       	call   80030c <cprintf>
	if (pipeisclosed(p[0]))
  800152:	83 c4 04             	add    $0x4,%esp
  800155:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800158:	e8 76 20 00 00       	call   8021d3 <pipeisclosed>
  80015d:	83 c4 10             	add    $0x10,%esp
  800160:	85 c0                	test   %eax,%eax
  800162:	74 14                	je     800178 <umain+0x144>
		panic("somehow the other end of p[0] got closed!");
  800164:	83 ec 04             	sub    $0x4,%esp
  800167:	68 c4 29 80 00       	push   $0x8029c4
  80016c:	6a 40                	push   $0x40
  80016e:	68 f7 29 80 00       	push   $0x8029f7
  800173:	e8 a4 00 00 00       	call   80021c <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800178:	83 ec 08             	sub    $0x8,%esp
  80017b:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  80017e:	50                   	push   %eax
  80017f:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800182:	e8 d7 12 00 00       	call   80145e <fd_lookup>
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	85 c0                	test   %eax,%eax
  80018c:	79 12                	jns    8001a0 <umain+0x16c>
		panic("cannot look up p[0]: %e", r);
  80018e:	50                   	push   %eax
  80018f:	68 4b 2a 80 00       	push   $0x802a4b
  800194:	6a 42                	push   $0x42
  800196:	68 f7 29 80 00       	push   $0x8029f7
  80019b:	e8 7c 00 00 00       	call   80021c <_panic>
	(void) fd2data(fd);
  8001a0:	83 ec 0c             	sub    $0xc,%esp
  8001a3:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8001a6:	e8 31 12 00 00       	call   8013dc <fd2data>
	cprintf("race didn't happen\n");
  8001ab:	c7 04 24 63 2a 80 00 	movl   $0x802a63,(%esp)
  8001b2:	e8 55 01 00 00       	call   80030c <cprintf>
}
  8001b7:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8001ba:	5b                   	pop    %ebx
  8001bb:	5e                   	pop    %esi
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
	...

008001c0 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	56                   	push   %esi
  8001c4:	53                   	push   %ebx
  8001c5:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  8001cb:	e8 d4 0a 00 00       	call   800ca4 <sys_getenvid>
  8001d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d5:	c1 e0 07             	shl    $0x7,%eax
  8001d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001dd:	a3 80 70 80 00       	mov    %eax,0x807080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e2:	85 f6                	test   %esi,%esi
  8001e4:	7e 07                	jle    8001ed <libmain+0x2d>
		binaryname = argv[0];
  8001e6:	8b 03                	mov    (%ebx),%eax
  8001e8:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  8001ed:	83 ec 08             	sub    $0x8,%esp
  8001f0:	53                   	push   %ebx
  8001f1:	56                   	push   %esi
  8001f2:	e8 3d fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8001f7:	e8 08 00 00 00       	call   800204 <exit>
}
  8001fc:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8001ff:	5b                   	pop    %ebx
  800200:	5e                   	pop    %esi
  800201:	c9                   	leave  
  800202:	c3                   	ret    
	...

00800204 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80020a:	e8 9d 13 00 00       	call   8015ac <close_all>
	sys_env_destroy(0);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	6a 00                	push   $0x0
  800214:	e8 4a 0a 00 00       	call   800c63 <sys_env_destroy>
}
  800219:	c9                   	leave  
  80021a:	c3                   	ret    
	...

0080021c <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	53                   	push   %ebx
  800220:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  800223:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  800226:	83 3d 84 70 80 00 00 	cmpl   $0x0,0x807084
  80022d:	74 16                	je     800245 <_panic+0x29>
		cprintf("%s: ", argv0);
  80022f:	83 ec 08             	sub    $0x8,%esp
  800232:	ff 35 84 70 80 00    	pushl  0x807084
  800238:	68 8e 2a 80 00       	push   $0x802a8e
  80023d:	e8 ca 00 00 00       	call   80030c <cprintf>
  800242:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800245:	ff 75 0c             	pushl  0xc(%ebp)
  800248:	ff 75 08             	pushl  0x8(%ebp)
  80024b:	ff 35 00 70 80 00    	pushl  0x807000
  800251:	68 93 2a 80 00       	push   $0x802a93
  800256:	e8 b1 00 00 00       	call   80030c <cprintf>
	vcprintf(fmt, ap);
  80025b:	83 c4 08             	add    $0x8,%esp
  80025e:	53                   	push   %ebx
  80025f:	ff 75 10             	pushl  0x10(%ebp)
  800262:	e8 54 00 00 00       	call   8002bb <vcprintf>
	cprintf("\n");
  800267:	c7 04 24 89 30 80 00 	movl   $0x803089,(%esp)
  80026e:	e8 99 00 00 00       	call   80030c <cprintf>

	// Cause a breakpoint exception
	while (1)
  800273:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  800276:	cc                   	int3   
  800277:	eb fd                	jmp    800276 <_panic+0x5a>
  800279:	00 00                	add    %al,(%eax)
	...

0080027c <putch>:


static void
putch(int ch, struct printbuf *b)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	53                   	push   %ebx
  800280:	83 ec 04             	sub    $0x4,%esp
  800283:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800286:	8b 03                	mov    (%ebx),%eax
  800288:	8b 55 08             	mov    0x8(%ebp),%edx
  80028b:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  80028f:	40                   	inc    %eax
  800290:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800292:	3d ff 00 00 00       	cmp    $0xff,%eax
  800297:	75 1a                	jne    8002b3 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800299:	83 ec 08             	sub    $0x8,%esp
  80029c:	68 ff 00 00 00       	push   $0xff
  8002a1:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a4:	50                   	push   %eax
  8002a5:	e8 76 09 00 00       	call   800c20 <sys_cputs>
		b->idx = 0;
  8002aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002b0:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8002b3:	ff 43 04             	incl   0x4(%ebx)
}
  8002b6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8002b9:	c9                   	leave  
  8002ba:	c3                   	ret    

008002bb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002c4:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  8002cb:	00 00 00 
	b.cnt = 0;
  8002ce:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  8002d5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d8:	ff 75 0c             	pushl  0xc(%ebp)
  8002db:	ff 75 08             	pushl  0x8(%ebp)
  8002de:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  8002e4:	50                   	push   %eax
  8002e5:	68 7c 02 80 00       	push   $0x80027c
  8002ea:	e8 4f 01 00 00       	call   80043e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002ef:	83 c4 08             	add    $0x8,%esp
  8002f2:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  8002f8:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  8002fe:	50                   	push   %eax
  8002ff:	e8 1c 09 00 00       	call   800c20 <sys_cputs>

	return b.cnt;
  800304:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  80030a:	c9                   	leave  
  80030b:	c3                   	ret    

0080030c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800312:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800315:	50                   	push   %eax
  800316:	ff 75 08             	pushl  0x8(%ebp)
  800319:	e8 9d ff ff ff       	call   8002bb <vcprintf>
	va_end(ap);

	return cnt;
}
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 0c             	sub    $0xc,%esp
  800329:	8b 75 10             	mov    0x10(%ebp),%esi
  80032c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80032f:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800332:	8b 45 18             	mov    0x18(%ebp),%eax
  800335:	ba 00 00 00 00       	mov    $0x0,%edx
  80033a:	39 fa                	cmp    %edi,%edx
  80033c:	77 39                	ja     800377 <printnum+0x57>
  80033e:	72 04                	jb     800344 <printnum+0x24>
  800340:	39 f0                	cmp    %esi,%eax
  800342:	77 33                	ja     800377 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	ff 75 20             	pushl  0x20(%ebp)
  80034a:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  80034d:	50                   	push   %eax
  80034e:	ff 75 18             	pushl  0x18(%ebp)
  800351:	8b 45 18             	mov    0x18(%ebp),%eax
  800354:	ba 00 00 00 00       	mov    $0x0,%edx
  800359:	52                   	push   %edx
  80035a:	50                   	push   %eax
  80035b:	57                   	push   %edi
  80035c:	56                   	push   %esi
  80035d:	e8 76 23 00 00       	call   8026d8 <__udivdi3>
  800362:	83 c4 10             	add    $0x10,%esp
  800365:	52                   	push   %edx
  800366:	50                   	push   %eax
  800367:	ff 75 0c             	pushl  0xc(%ebp)
  80036a:	ff 75 08             	pushl  0x8(%ebp)
  80036d:	e8 ae ff ff ff       	call   800320 <printnum>
  800372:	83 c4 20             	add    $0x20,%esp
  800375:	eb 19                	jmp    800390 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800377:	4b                   	dec    %ebx
  800378:	85 db                	test   %ebx,%ebx
  80037a:	7e 14                	jle    800390 <printnum+0x70>
  80037c:	83 ec 08             	sub    $0x8,%esp
  80037f:	ff 75 0c             	pushl  0xc(%ebp)
  800382:	ff 75 20             	pushl  0x20(%ebp)
  800385:	ff 55 08             	call   *0x8(%ebp)
  800388:	83 c4 10             	add    $0x10,%esp
  80038b:	4b                   	dec    %ebx
  80038c:	85 db                	test   %ebx,%ebx
  80038e:	7f ec                	jg     80037c <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800390:	83 ec 08             	sub    $0x8,%esp
  800393:	ff 75 0c             	pushl  0xc(%ebp)
  800396:	8b 45 18             	mov    0x18(%ebp),%eax
  800399:	ba 00 00 00 00       	mov    $0x0,%edx
  80039e:	83 ec 04             	sub    $0x4,%esp
  8003a1:	52                   	push   %edx
  8003a2:	50                   	push   %eax
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	e8 3a 24 00 00       	call   8027e4 <__umoddi3>
  8003aa:	83 c4 14             	add    $0x14,%esp
  8003ad:	0f be 80 a9 2b 80 00 	movsbl 0x802ba9(%eax),%eax
  8003b4:	50                   	push   %eax
  8003b5:	ff 55 08             	call   *0x8(%ebp)
}
  8003b8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8003bb:	5b                   	pop    %ebx
  8003bc:	5e                   	pop    %esi
  8003bd:	5f                   	pop    %edi
  8003be:	c9                   	leave  
  8003bf:	c3                   	ret    

008003c0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003c6:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8003c9:	83 f8 01             	cmp    $0x1,%eax
  8003cc:	7e 0f                	jle    8003dd <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  8003ce:	8b 01                	mov    (%ecx),%eax
  8003d0:	83 c0 08             	add    $0x8,%eax
  8003d3:	89 01                	mov    %eax,(%ecx)
  8003d5:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8003d8:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8003db:	eb 24                	jmp    800401 <getuint+0x41>
	else if (lflag)
  8003dd:	85 c0                	test   %eax,%eax
  8003df:	74 11                	je     8003f2 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  8003e1:	8b 01                	mov    (%ecx),%eax
  8003e3:	83 c0 04             	add    $0x4,%eax
  8003e6:	89 01                	mov    %eax,(%ecx)
  8003e8:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f0:	eb 0f                	jmp    800401 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  8003f2:	8b 01                	mov    (%ecx),%eax
  8003f4:	83 c0 04             	add    $0x4,%eax
  8003f7:	89 01                	mov    %eax,(%ecx)
  8003f9:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8003fc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800401:	c9                   	leave  
  800402:	c3                   	ret    

00800403 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800403:	55                   	push   %ebp
  800404:	89 e5                	mov    %esp,%ebp
  800406:	8b 55 08             	mov    0x8(%ebp),%edx
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80040c:	83 f8 01             	cmp    $0x1,%eax
  80040f:	7e 0f                	jle    800420 <getint+0x1d>
		return va_arg(*ap, long long);
  800411:	8b 02                	mov    (%edx),%eax
  800413:	83 c0 08             	add    $0x8,%eax
  800416:	89 02                	mov    %eax,(%edx)
  800418:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80041b:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80041e:	eb 1c                	jmp    80043c <getint+0x39>
	else if (lflag)
  800420:	85 c0                	test   %eax,%eax
  800422:	74 0d                	je     800431 <getint+0x2e>
		return va_arg(*ap, long);
  800424:	8b 02                	mov    (%edx),%eax
  800426:	83 c0 04             	add    $0x4,%eax
  800429:	89 02                	mov    %eax,(%edx)
  80042b:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80042e:	99                   	cltd   
  80042f:	eb 0b                	jmp    80043c <getint+0x39>
	else
		return va_arg(*ap, int);
  800431:	8b 02                	mov    (%edx),%eax
  800433:	83 c0 04             	add    $0x4,%eax
  800436:	89 02                	mov    %eax,(%edx)
  800438:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80043b:	99                   	cltd   
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	57                   	push   %edi
  800442:	56                   	push   %esi
  800443:	53                   	push   %ebx
  800444:	83 ec 1c             	sub    $0x1c,%esp
  800447:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  80044a:	0f b6 13             	movzbl (%ebx),%edx
  80044d:	43                   	inc    %ebx
  80044e:	83 fa 25             	cmp    $0x25,%edx
  800451:	74 1e                	je     800471 <vprintfmt+0x33>
  800453:	85 d2                	test   %edx,%edx
  800455:	0f 84 d7 02 00 00    	je     800732 <vprintfmt+0x2f4>
  80045b:	83 ec 08             	sub    $0x8,%esp
  80045e:	ff 75 0c             	pushl  0xc(%ebp)
  800461:	52                   	push   %edx
  800462:	ff 55 08             	call   *0x8(%ebp)
  800465:	83 c4 10             	add    $0x10,%esp
  800468:	0f b6 13             	movzbl (%ebx),%edx
  80046b:	43                   	inc    %ebx
  80046c:	83 fa 25             	cmp    $0x25,%edx
  80046f:	75 e2                	jne    800453 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  800471:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  800475:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  80047c:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  800481:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  800486:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048d:	0f b6 13             	movzbl (%ebx),%edx
  800490:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  800493:	43                   	inc    %ebx
  800494:	83 f8 55             	cmp    $0x55,%eax
  800497:	0f 87 70 02 00 00    	ja     80070d <vprintfmt+0x2cf>
  80049d:	ff 24 85 3c 2c 80 00 	jmp    *0x802c3c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  8004a4:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  8004a8:	eb e3                	jmp    80048d <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004aa:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  8004ae:	eb dd                	jmp    80048d <vprintfmt+0x4f>

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
  8004b0:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  8004b5:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  8004b8:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  8004bc:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  8004bf:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  8004c2:	83 f8 09             	cmp    $0x9,%eax
  8004c5:	77 27                	ja     8004ee <vprintfmt+0xb0>
  8004c7:	43                   	inc    %ebx
  8004c8:	eb eb                	jmp    8004b5 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004ca:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d1:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  8004d4:	eb 18                	jmp    8004ee <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  8004d6:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004da:	79 b1                	jns    80048d <vprintfmt+0x4f>
				width = 0;
  8004dc:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  8004e3:	eb a8                	jmp    80048d <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  8004e5:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  8004ec:	eb 9f                	jmp    80048d <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  8004ee:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8004f2:	79 99                	jns    80048d <vprintfmt+0x4f>
				width = precision, precision = -1;
  8004f4:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8004f7:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  8004fc:	eb 8f                	jmp    80048d <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004fe:	41                   	inc    %ecx
			goto reswitch;
  8004ff:	eb 8c                	jmp    80048d <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800501:	83 ec 08             	sub    $0x8,%esp
  800504:	ff 75 0c             	pushl  0xc(%ebp)
  800507:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	ff 70 fc             	pushl  0xfffffffc(%eax)
  800511:	ff 55 08             	call   *0x8(%ebp)
			break;
  800514:	83 c4 10             	add    $0x10,%esp
  800517:	e9 2e ff ff ff       	jmp    80044a <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80051c:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800520:	8b 45 14             	mov    0x14(%ebp),%eax
  800523:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  800526:	85 c0                	test   %eax,%eax
  800528:	79 02                	jns    80052c <vprintfmt+0xee>
				err = -err;
  80052a:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80052c:	83 f8 0e             	cmp    $0xe,%eax
  80052f:	7f 0b                	jg     80053c <vprintfmt+0xfe>
  800531:	8b 3c 85 00 2c 80 00 	mov    0x802c00(,%eax,4),%edi
  800538:	85 ff                	test   %edi,%edi
  80053a:	75 19                	jne    800555 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  80053c:	50                   	push   %eax
  80053d:	68 ba 2b 80 00       	push   $0x802bba
  800542:	ff 75 0c             	pushl  0xc(%ebp)
  800545:	ff 75 08             	pushl  0x8(%ebp)
  800548:	e8 ed 01 00 00       	call   80073a <printfmt>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	e9 f5 fe ff ff       	jmp    80044a <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800555:	57                   	push   %edi
  800556:	68 41 30 80 00       	push   $0x803041
  80055b:	ff 75 0c             	pushl  0xc(%ebp)
  80055e:	ff 75 08             	pushl  0x8(%ebp)
  800561:	e8 d4 01 00 00       	call   80073a <printfmt>
  800566:	83 c4 10             	add    $0x10,%esp
			break;
  800569:	e9 dc fe ff ff       	jmp    80044a <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80056e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800572:	8b 45 14             	mov    0x14(%ebp),%eax
  800575:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  800578:	85 ff                	test   %edi,%edi
  80057a:	75 05                	jne    800581 <vprintfmt+0x143>
				p = "(null)";
  80057c:	bf c3 2b 80 00       	mov    $0x802bc3,%edi
			if (width > 0 && padc != '-')
  800581:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800585:	7e 3b                	jle    8005c2 <vprintfmt+0x184>
  800587:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  80058b:	74 35                	je     8005c2 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	56                   	push   %esi
  800591:	57                   	push   %edi
  800592:	e8 56 03 00 00       	call   8008ed <strnlen>
  800597:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  80059a:	83 c4 10             	add    $0x10,%esp
  80059d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005a1:	7e 1f                	jle    8005c2 <vprintfmt+0x184>
  8005a3:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8005a7:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  8005aa:	83 ec 08             	sub    $0x8,%esp
  8005ad:	ff 75 0c             	pushl  0xc(%ebp)
  8005b0:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  8005b3:	ff 55 08             	call   *0x8(%ebp)
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8005bc:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005c0:	7f e8                	jg     8005aa <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c2:	0f be 17             	movsbl (%edi),%edx
  8005c5:	47                   	inc    %edi
  8005c6:	85 d2                	test   %edx,%edx
  8005c8:	74 44                	je     80060e <vprintfmt+0x1d0>
  8005ca:	85 f6                	test   %esi,%esi
  8005cc:	78 03                	js     8005d1 <vprintfmt+0x193>
  8005ce:	4e                   	dec    %esi
  8005cf:	78 3d                	js     80060e <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  8005d1:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  8005d5:	74 18                	je     8005ef <vprintfmt+0x1b1>
  8005d7:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  8005da:	83 f8 5e             	cmp    $0x5e,%eax
  8005dd:	76 10                	jbe    8005ef <vprintfmt+0x1b1>
					putch('?', putdat);
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	6a 3f                	push   $0x3f
  8005e7:	ff 55 08             	call   *0x8(%ebp)
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	eb 0d                	jmp    8005fc <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  8005ef:	83 ec 08             	sub    $0x8,%esp
  8005f2:	ff 75 0c             	pushl  0xc(%ebp)
  8005f5:	52                   	push   %edx
  8005f6:	ff 55 08             	call   *0x8(%ebp)
  8005f9:	83 c4 10             	add    $0x10,%esp
  8005fc:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8005ff:	0f be 17             	movsbl (%edi),%edx
  800602:	47                   	inc    %edi
  800603:	85 d2                	test   %edx,%edx
  800605:	74 07                	je     80060e <vprintfmt+0x1d0>
  800607:	85 f6                	test   %esi,%esi
  800609:	78 c6                	js     8005d1 <vprintfmt+0x193>
  80060b:	4e                   	dec    %esi
  80060c:	79 c3                	jns    8005d1 <vprintfmt+0x193>
			for (; width > 0; width--)
  80060e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800612:	0f 8e 32 fe ff ff    	jle    80044a <vprintfmt+0xc>
				putch(' ', putdat);
  800618:	83 ec 08             	sub    $0x8,%esp
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	6a 20                	push   $0x20
  800620:	ff 55 08             	call   *0x8(%ebp)
  800623:	83 c4 10             	add    $0x10,%esp
  800626:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800629:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80062d:	7f e9                	jg     800618 <vprintfmt+0x1da>
			break;
  80062f:	e9 16 fe ff ff       	jmp    80044a <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800634:	51                   	push   %ecx
  800635:	8d 45 14             	lea    0x14(%ebp),%eax
  800638:	50                   	push   %eax
  800639:	e8 c5 fd ff ff       	call   800403 <getint>
  80063e:	89 c6                	mov    %eax,%esi
  800640:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  800642:	83 c4 08             	add    $0x8,%esp
  800645:	85 d2                	test   %edx,%edx
  800647:	79 15                	jns    80065e <vprintfmt+0x220>
				putch('-', putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	ff 75 0c             	pushl  0xc(%ebp)
  80064f:	6a 2d                	push   $0x2d
  800651:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800654:	f7 de                	neg    %esi
  800656:	83 d7 00             	adc    $0x0,%edi
  800659:	f7 df                	neg    %edi
  80065b:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80065e:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800663:	eb 75                	jmp    8006da <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800665:	51                   	push   %ecx
  800666:	8d 45 14             	lea    0x14(%ebp),%eax
  800669:	50                   	push   %eax
  80066a:	e8 51 fd ff ff       	call   8003c0 <getuint>
  80066f:	89 c6                	mov    %eax,%esi
  800671:	89 d7                	mov    %edx,%edi
			base = 10;
  800673:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800678:	83 c4 08             	add    $0x8,%esp
  80067b:	eb 5d                	jmp    8006da <vprintfmt+0x29c>

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
  80067d:	51                   	push   %ecx
  80067e:	8d 45 14             	lea    0x14(%ebp),%eax
  800681:	50                   	push   %eax
  800682:	e8 39 fd ff ff       	call   8003c0 <getuint>
  800687:	89 c6                	mov    %eax,%esi
  800689:	89 d7                	mov    %edx,%edi
			base = 8;
  80068b:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  800690:	83 c4 08             	add    $0x8,%esp
  800693:	eb 45                	jmp    8006da <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	ff 75 0c             	pushl  0xc(%ebp)
  80069b:	6a 30                	push   $0x30
  80069d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006a0:	83 c4 08             	add    $0x8,%esp
  8006a3:	ff 75 0c             	pushl  0xc(%ebp)
  8006a6:	6a 78                	push   $0x78
  8006a8:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  8006ab:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  8006b5:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006ba:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	eb 16                	jmp    8006da <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006c4:	51                   	push   %ecx
  8006c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006c8:	50                   	push   %eax
  8006c9:	e8 f2 fc ff ff       	call   8003c0 <getuint>
  8006ce:	89 c6                	mov    %eax,%esi
  8006d0:	89 d7                	mov    %edx,%edi
			base = 16;
  8006d2:	ba 10 00 00 00       	mov    $0x10,%edx
  8006d7:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006da:	83 ec 04             	sub    $0x4,%esp
  8006dd:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8006e1:	50                   	push   %eax
  8006e2:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8006e5:	52                   	push   %edx
  8006e6:	57                   	push   %edi
  8006e7:	56                   	push   %esi
  8006e8:	ff 75 0c             	pushl  0xc(%ebp)
  8006eb:	ff 75 08             	pushl  0x8(%ebp)
  8006ee:	e8 2d fc ff ff       	call   800320 <printnum>
			break;
  8006f3:	83 c4 20             	add    $0x20,%esp
  8006f6:	e9 4f fd ff ff       	jmp    80044a <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	52                   	push   %edx
  800702:	ff 55 08             	call   *0x8(%ebp)
			break;
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	e9 3d fd ff ff       	jmp    80044a <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	ff 75 0c             	pushl  0xc(%ebp)
  800713:	6a 25                	push   $0x25
  800715:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800718:	4b                   	dec    %ebx
  800719:	83 c4 10             	add    $0x10,%esp
  80071c:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800720:	0f 84 24 fd ff ff    	je     80044a <vprintfmt+0xc>
  800726:	4b                   	dec    %ebx
  800727:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  80072b:	75 f9                	jne    800726 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  80072d:	e9 18 fd ff ff       	jmp    80044a <vprintfmt+0xc>
		}
	}
}
  800732:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800735:	5b                   	pop    %ebx
  800736:	5e                   	pop    %esi
  800737:	5f                   	pop    %edi
  800738:	c9                   	leave  
  800739:	c3                   	ret    

0080073a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80073a:	55                   	push   %ebp
  80073b:	89 e5                	mov    %esp,%ebp
  80073d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800740:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800743:	50                   	push   %eax
  800744:	ff 75 10             	pushl  0x10(%ebp)
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 08             	pushl  0x8(%ebp)
  80074d:	e8 ec fc ff ff       	call   80043e <vprintfmt>
	va_end(ap);
}
  800752:	c9                   	leave  
  800753:	c3                   	ret    

00800754 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800754:	55                   	push   %ebp
  800755:	89 e5                	mov    %esp,%ebp
  800757:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  80075a:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  80075d:	8b 0a                	mov    (%edx),%ecx
  80075f:	3b 4a 04             	cmp    0x4(%edx),%ecx
  800762:	73 07                	jae    80076b <sprintputch+0x17>
		*b->buf++ = ch;
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	88 01                	mov    %al,(%ecx)
  800769:	ff 02                	incl   (%edx)
}
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp
  800773:	8b 55 08             	mov    0x8(%ebp),%edx
  800776:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800779:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  80077c:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800780:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  800783:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  80078a:	85 d2                	test   %edx,%edx
  80078c:	74 04                	je     800792 <vsnprintf+0x25>
  80078e:	85 c9                	test   %ecx,%ecx
  800790:	7f 07                	jg     800799 <vsnprintf+0x2c>
		return -E_INVAL;
  800792:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800797:	eb 1d                	jmp    8007b6 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800799:	ff 75 14             	pushl  0x14(%ebp)
  80079c:	ff 75 10             	pushl  0x10(%ebp)
  80079f:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  8007a2:	50                   	push   %eax
  8007a3:	68 54 07 80 00       	push   $0x800754
  8007a8:	e8 91 fc ff ff       	call   80043e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ad:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  8007b0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007b3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007be:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c1:	50                   	push   %eax
  8007c2:	ff 75 10             	pushl  0x10(%ebp)
  8007c5:	ff 75 0c             	pushl  0xc(%ebp)
  8007c8:	ff 75 08             	pushl  0x8(%ebp)
  8007cb:	e8 9d ff ff ff       	call   80076d <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    
	...

008007d4 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	56                   	push   %esi
  8007d8:	53                   	push   %ebx
  8007d9:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  8007dc:	83 ec 0c             	sub    $0xc,%esp
  8007df:	56                   	push   %esi
  8007e0:	e8 ef 00 00 00       	call   8008d4 <strlen>
  char letter;
  int hexnum = 0;
  8007e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  8007ea:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	89 c2                	mov    %eax,%edx
  8007f4:	4a                   	dec    %edx
  8007f5:	0f 88 d0 00 00 00    	js     8008cb <strtoint+0xf7>
    letter = string[cidx];
  8007fb:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  8007fe:	85 d2                	test   %edx,%edx
  800800:	75 12                	jne    800814 <strtoint+0x40>
      if (letter != '0') {
  800802:	3c 30                	cmp    $0x30,%al
  800804:	0f 84 ba 00 00 00    	je     8008c4 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80080a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80080f:	e9 b9 00 00 00       	jmp    8008cd <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800814:	83 fa 01             	cmp    $0x1,%edx
  800817:	75 12                	jne    80082b <strtoint+0x57>
      if (letter != 'x') {
  800819:	3c 78                	cmp    $0x78,%al
  80081b:	0f 84 a3 00 00 00    	je     8008c4 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800826:	e9 a2 00 00 00       	jmp    8008cd <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  80082b:	0f be c0             	movsbl %al,%eax
  80082e:	83 e8 30             	sub    $0x30,%eax
  800831:	83 f8 36             	cmp    $0x36,%eax
  800834:	0f 87 80 00 00 00    	ja     8008ba <strtoint+0xe6>
  80083a:	ff 24 85 94 2d 80 00 	jmp    *0x802d94(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  800841:	01 cb                	add    %ecx,%ebx
          break;
  800843:	eb 7c                	jmp    8008c1 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800845:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  800848:	eb 77                	jmp    8008c1 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  80084a:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80084d:	01 c3                	add    %eax,%ebx
          break;
  80084f:	eb 70                	jmp    8008c1 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  800851:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800854:	eb 6b                	jmp    8008c1 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  800856:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800859:	01 c3                	add    %eax,%ebx
          break;
  80085b:	eb 64                	jmp    8008c1 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  80085d:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800860:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800863:	eb 5c                	jmp    8008c1 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800865:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  80086c:	29 c8                	sub    %ecx,%eax
  80086e:	01 c3                	add    %eax,%ebx
          break;
  800870:	eb 4f                	jmp    8008c1 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  800872:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  800875:	eb 4a                	jmp    8008c1 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  800877:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  80087a:	01 c3                	add    %eax,%ebx
          break;
  80087c:	eb 43                	jmp    8008c1 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  80087e:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800881:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800884:	eb 3b                	jmp    8008c1 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800886:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800889:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  80088c:	01 c3                	add    %eax,%ebx
          break;
  80088e:	eb 31                	jmp    8008c1 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800890:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800893:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800896:	eb 29                	jmp    8008c1 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800898:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80089b:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  80089e:	01 c3                	add    %eax,%ebx
          break;
  8008a0:	eb 1f                	jmp    8008c1 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  8008a2:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8008a9:	29 c8                	sub    %ecx,%eax
  8008ab:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8008ae:	eb 11                	jmp    8008c1 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  8008b0:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8008b3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008b6:	01 c3                	add    %eax,%ebx
          break;
  8008b8:	eb 07                	jmp    8008c1 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  8008ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8008bf:	eb 0c                	jmp    8008cd <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  8008c1:	c1 e1 04             	shl    $0x4,%ecx
  8008c4:	4a                   	dec    %edx
  8008c5:	0f 89 30 ff ff ff    	jns    8007fb <strtoint+0x27>
    }
  }

  return hexnum;
  8008cb:	89 d8                	mov    %ebx,%eax
}
  8008cd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8008d0:	5b                   	pop    %ebx
  8008d1:	5e                   	pop    %esi
  8008d2:	c9                   	leave  
  8008d3:	c3                   	ret    

008008d4 <strlen>:





int
strlen(const char *s)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008da:	b8 00 00 00 00       	mov    $0x0,%eax
  8008df:	80 3a 00             	cmpb   $0x0,(%edx)
  8008e2:	74 07                	je     8008eb <strlen+0x17>
		n++;
  8008e4:	40                   	inc    %eax
  8008e5:	42                   	inc    %edx
  8008e6:	80 3a 00             	cmpb   $0x0,(%edx)
  8008e9:	75 f9                	jne    8008e4 <strlen+0x10>
	return n;
}
  8008eb:	c9                   	leave  
  8008ec:	c3                   	ret    

008008ed <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ed:	55                   	push   %ebp
  8008ee:	89 e5                	mov    %esp,%ebp
  8008f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fb:	85 d2                	test   %edx,%edx
  8008fd:	74 0f                	je     80090e <strnlen+0x21>
  8008ff:	80 39 00             	cmpb   $0x0,(%ecx)
  800902:	74 0a                	je     80090e <strnlen+0x21>
		n++;
  800904:	40                   	inc    %eax
  800905:	41                   	inc    %ecx
  800906:	4a                   	dec    %edx
  800907:	74 05                	je     80090e <strnlen+0x21>
  800909:	80 39 00             	cmpb   $0x0,(%ecx)
  80090c:	75 f6                	jne    800904 <strnlen+0x17>
	return n;
}
  80090e:	c9                   	leave  
  80090f:	c3                   	ret    

00800910 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	53                   	push   %ebx
  800914:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800917:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  80091a:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  80091c:	8a 02                	mov    (%edx),%al
  80091e:	42                   	inc    %edx
  80091f:	88 01                	mov    %al,(%ecx)
  800921:	41                   	inc    %ecx
  800922:	84 c0                	test   %al,%al
  800924:	75 f6                	jne    80091c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800926:	89 d8                	mov    %ebx,%eax
  800928:	5b                   	pop    %ebx
  800929:	c9                   	leave  
  80092a:	c3                   	ret    

0080092b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	57                   	push   %edi
  80092f:	56                   	push   %esi
  800930:	53                   	push   %ebx
  800931:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800934:	8b 55 0c             	mov    0xc(%ebp),%edx
  800937:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  80093a:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  80093c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800941:	39 f3                	cmp    %esi,%ebx
  800943:	73 10                	jae    800955 <strncpy+0x2a>
		*dst++ = *src;
  800945:	8a 02                	mov    (%edx),%al
  800947:	88 01                	mov    %al,(%ecx)
  800949:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094a:	80 3a 01             	cmpb   $0x1,(%edx)
  80094d:	83 da ff             	sbb    $0xffffffff,%edx
  800950:	43                   	inc    %ebx
  800951:	39 f3                	cmp    %esi,%ebx
  800953:	72 f0                	jb     800945 <strncpy+0x1a>
	}
	return ret;
}
  800955:	89 f8                	mov    %edi,%eax
  800957:	5b                   	pop    %ebx
  800958:	5e                   	pop    %esi
  800959:	5f                   	pop    %edi
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    

0080095c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	56                   	push   %esi
  800960:	53                   	push   %ebx
  800961:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800964:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800967:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  80096a:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  80096c:	85 d2                	test   %edx,%edx
  80096e:	74 19                	je     800989 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800970:	4a                   	dec    %edx
  800971:	74 13                	je     800986 <strlcpy+0x2a>
  800973:	80 39 00             	cmpb   $0x0,(%ecx)
  800976:	74 0e                	je     800986 <strlcpy+0x2a>
  800978:	8a 01                	mov    (%ecx),%al
  80097a:	41                   	inc    %ecx
  80097b:	88 03                	mov    %al,(%ebx)
  80097d:	43                   	inc    %ebx
  80097e:	4a                   	dec    %edx
  80097f:	74 05                	je     800986 <strlcpy+0x2a>
  800981:	80 39 00             	cmpb   $0x0,(%ecx)
  800984:	75 f2                	jne    800978 <strlcpy+0x1c>
		*dst = '\0';
  800986:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800989:	89 d8                	mov    %ebx,%eax
  80098b:	29 f0                	sub    %esi,%eax
}
  80098d:	5b                   	pop    %ebx
  80098e:	5e                   	pop    %esi
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	8b 55 08             	mov    0x8(%ebp),%edx
  800997:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  80099a:	80 3a 00             	cmpb   $0x0,(%edx)
  80099d:	74 13                	je     8009b2 <strcmp+0x21>
  80099f:	8a 02                	mov    (%edx),%al
  8009a1:	3a 01                	cmp    (%ecx),%al
  8009a3:	75 0d                	jne    8009b2 <strcmp+0x21>
  8009a5:	42                   	inc    %edx
  8009a6:	41                   	inc    %ecx
  8009a7:	80 3a 00             	cmpb   $0x0,(%edx)
  8009aa:	74 06                	je     8009b2 <strcmp+0x21>
  8009ac:	8a 02                	mov    (%edx),%al
  8009ae:	3a 01                	cmp    (%ecx),%al
  8009b0:	74 f3                	je     8009a5 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b2:	0f b6 02             	movzbl (%edx),%eax
  8009b5:	0f b6 11             	movzbl (%ecx),%edx
  8009b8:	29 d0                	sub    %edx,%eax
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	53                   	push   %ebx
  8009c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  8009c9:	85 c9                	test   %ecx,%ecx
  8009cb:	74 1f                	je     8009ec <strncmp+0x30>
  8009cd:	80 3a 00             	cmpb   $0x0,(%edx)
  8009d0:	74 16                	je     8009e8 <strncmp+0x2c>
  8009d2:	8a 02                	mov    (%edx),%al
  8009d4:	3a 03                	cmp    (%ebx),%al
  8009d6:	75 10                	jne    8009e8 <strncmp+0x2c>
  8009d8:	42                   	inc    %edx
  8009d9:	43                   	inc    %ebx
  8009da:	49                   	dec    %ecx
  8009db:	74 0f                	je     8009ec <strncmp+0x30>
  8009dd:	80 3a 00             	cmpb   $0x0,(%edx)
  8009e0:	74 06                	je     8009e8 <strncmp+0x2c>
  8009e2:	8a 02                	mov    (%edx),%al
  8009e4:	3a 03                	cmp    (%ebx),%al
  8009e6:	74 f0                	je     8009d8 <strncmp+0x1c>
	if (n == 0)
  8009e8:	85 c9                	test   %ecx,%ecx
  8009ea:	75 07                	jne    8009f3 <strncmp+0x37>
		return 0;
  8009ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f1:	eb 0a                	jmp    8009fd <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f3:	0f b6 12             	movzbl (%edx),%edx
  8009f6:	0f b6 03             	movzbl (%ebx),%eax
  8009f9:	29 c2                	sub    %eax,%edx
  8009fb:	89 d0                	mov    %edx,%eax
}
  8009fd:	5b                   	pop    %ebx
  8009fe:	c9                   	leave  
  8009ff:	c3                   	ret    

00800a00 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800a09:	80 38 00             	cmpb   $0x0,(%eax)
  800a0c:	74 0a                	je     800a18 <strchr+0x18>
		if (*s == c)
  800a0e:	38 10                	cmp    %dl,(%eax)
  800a10:	74 0b                	je     800a1d <strchr+0x1d>
  800a12:	40                   	inc    %eax
  800a13:	80 38 00             	cmpb   $0x0,(%eax)
  800a16:	75 f6                	jne    800a0e <strchr+0xe>
			return (char *) s;
	return 0;
  800a18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800a28:	80 38 00             	cmpb   $0x0,(%eax)
  800a2b:	74 0a                	je     800a37 <strfind+0x18>
		if (*s == c)
  800a2d:	38 10                	cmp    %dl,(%eax)
  800a2f:	74 06                	je     800a37 <strfind+0x18>
  800a31:	40                   	inc    %eax
  800a32:	80 38 00             	cmpb   $0x0,(%eax)
  800a35:	75 f6                	jne    800a2d <strfind+0xe>
			break;
	return (char *) s;
}
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    

00800a39 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	57                   	push   %edi
  800a3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800a43:	89 f8                	mov    %edi,%eax
  800a45:	85 c9                	test   %ecx,%ecx
  800a47:	74 40                	je     800a89 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800a49:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4f:	75 30                	jne    800a81 <memset+0x48>
  800a51:	f6 c1 03             	test   $0x3,%cl
  800a54:	75 2b                	jne    800a81 <memset+0x48>
		c &= 0xFF;
  800a56:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	c1 e0 18             	shl    $0x18,%eax
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	c1 e2 10             	shl    $0x10,%edx
  800a69:	09 d0                	or     %edx,%eax
  800a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6e:	c1 e2 08             	shl    $0x8,%edx
  800a71:	09 d0                	or     %edx,%eax
  800a73:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800a76:	c1 e9 02             	shr    $0x2,%ecx
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	fc                   	cld    
  800a7d:	f3 ab                	repz stos %eax,%es:(%edi)
  800a7f:	eb 06                	jmp    800a87 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	fc                   	cld    
  800a85:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800a87:	89 f8                	mov    %edi,%eax
}
  800a89:	5f                   	pop    %edi
  800a8a:	c9                   	leave  
  800a8b:	c3                   	ret    

00800a8c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	57                   	push   %edi
  800a90:	56                   	push   %esi
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800a97:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a9a:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a9c:	39 c6                	cmp    %eax,%esi
  800a9e:	73 33                	jae    800ad3 <memmove+0x47>
  800aa0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aa3:	39 c2                	cmp    %eax,%edx
  800aa5:	76 2c                	jbe    800ad3 <memmove+0x47>
		s += n;
  800aa7:	89 d6                	mov    %edx,%esi
		d += n;
  800aa9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aac:	f6 c2 03             	test   $0x3,%dl
  800aaf:	75 1b                	jne    800acc <memmove+0x40>
  800ab1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ab7:	75 13                	jne    800acc <memmove+0x40>
  800ab9:	f6 c1 03             	test   $0x3,%cl
  800abc:	75 0e                	jne    800acc <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800abe:	83 ef 04             	sub    $0x4,%edi
  800ac1:	83 ee 04             	sub    $0x4,%esi
  800ac4:	c1 e9 02             	shr    $0x2,%ecx
  800ac7:	fd                   	std    
  800ac8:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800aca:	eb 27                	jmp    800af3 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800acc:	4f                   	dec    %edi
  800acd:	4e                   	dec    %esi
  800ace:	fd                   	std    
  800acf:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800ad1:	eb 20                	jmp    800af3 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ad9:	75 15                	jne    800af0 <memmove+0x64>
  800adb:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ae1:	75 0d                	jne    800af0 <memmove+0x64>
  800ae3:	f6 c1 03             	test   $0x3,%cl
  800ae6:	75 08                	jne    800af0 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800ae8:	c1 e9 02             	shr    $0x2,%ecx
  800aeb:	fc                   	cld    
  800aec:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800aee:	eb 03                	jmp    800af3 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800af0:	fc                   	cld    
  800af1:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af3:	5e                   	pop    %esi
  800af4:	5f                   	pop    %edi
  800af5:	c9                   	leave  
  800af6:	c3                   	ret    

00800af7 <memcpy>:

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
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800afa:	ff 75 10             	pushl  0x10(%ebp)
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 84 ff ff ff       	call   800a8c <memmove>
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800b0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800b11:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b14:	8b 55 10             	mov    0x10(%ebp),%edx
  800b17:	4a                   	dec    %edx
  800b18:	83 fa ff             	cmp    $0xffffffff,%edx
  800b1b:	74 1a                	je     800b37 <memcmp+0x2d>
  800b1d:	8a 01                	mov    (%ecx),%al
  800b1f:	3a 03                	cmp    (%ebx),%al
  800b21:	74 0c                	je     800b2f <memcmp+0x25>
  800b23:	0f b6 d0             	movzbl %al,%edx
  800b26:	0f b6 03             	movzbl (%ebx),%eax
  800b29:	29 c2                	sub    %eax,%edx
  800b2b:	89 d0                	mov    %edx,%eax
  800b2d:	eb 0d                	jmp    800b3c <memcmp+0x32>
  800b2f:	41                   	inc    %ecx
  800b30:	43                   	inc    %ebx
  800b31:	4a                   	dec    %edx
  800b32:	83 fa ff             	cmp    $0xffffffff,%edx
  800b35:	75 e6                	jne    800b1d <memcmp+0x13>
	}

	return 0;
  800b37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3c:	5b                   	pop    %ebx
  800b3d:	c9                   	leave  
  800b3e:	c3                   	ret    

00800b3f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b48:	89 c2                	mov    %eax,%edx
  800b4a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b4d:	39 d0                	cmp    %edx,%eax
  800b4f:	73 09                	jae    800b5a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b51:	38 08                	cmp    %cl,(%eax)
  800b53:	74 05                	je     800b5a <memfind+0x1b>
  800b55:	40                   	inc    %eax
  800b56:	39 d0                	cmp    %edx,%eax
  800b58:	72 f7                	jb     800b51 <memfind+0x12>
			break;
	return (void *) s;
}
  800b5a:	c9                   	leave  
  800b5b:	c3                   	ret    

00800b5c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	57                   	push   %edi
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b68:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800b6b:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800b70:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800b75:	80 3a 20             	cmpb   $0x20,(%edx)
  800b78:	74 05                	je     800b7f <strtol+0x23>
  800b7a:	80 3a 09             	cmpb   $0x9,(%edx)
  800b7d:	75 0b                	jne    800b8a <strtol+0x2e>
  800b7f:	42                   	inc    %edx
  800b80:	80 3a 20             	cmpb   $0x20,(%edx)
  800b83:	74 fa                	je     800b7f <strtol+0x23>
  800b85:	80 3a 09             	cmpb   $0x9,(%edx)
  800b88:	74 f5                	je     800b7f <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800b8a:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800b8d:	75 03                	jne    800b92 <strtol+0x36>
		s++;
  800b8f:	42                   	inc    %edx
  800b90:	eb 0b                	jmp    800b9d <strtol+0x41>
	else if (*s == '-')
  800b92:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800b95:	75 06                	jne    800b9d <strtol+0x41>
		s++, neg = 1;
  800b97:	42                   	inc    %edx
  800b98:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b9d:	85 c9                	test   %ecx,%ecx
  800b9f:	74 05                	je     800ba6 <strtol+0x4a>
  800ba1:	83 f9 10             	cmp    $0x10,%ecx
  800ba4:	75 15                	jne    800bbb <strtol+0x5f>
  800ba6:	80 3a 30             	cmpb   $0x30,(%edx)
  800ba9:	75 10                	jne    800bbb <strtol+0x5f>
  800bab:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800baf:	75 0a                	jne    800bbb <strtol+0x5f>
		s += 2, base = 16;
  800bb1:	83 c2 02             	add    $0x2,%edx
  800bb4:	b9 10 00 00 00       	mov    $0x10,%ecx
  800bb9:	eb 14                	jmp    800bcf <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800bbb:	85 c9                	test   %ecx,%ecx
  800bbd:	75 10                	jne    800bcf <strtol+0x73>
  800bbf:	80 3a 30             	cmpb   $0x30,(%edx)
  800bc2:	75 05                	jne    800bc9 <strtol+0x6d>
		s++, base = 8;
  800bc4:	42                   	inc    %edx
  800bc5:	b1 08                	mov    $0x8,%cl
  800bc7:	eb 06                	jmp    800bcf <strtol+0x73>
	else if (base == 0)
  800bc9:	85 c9                	test   %ecx,%ecx
  800bcb:	75 02                	jne    800bcf <strtol+0x73>
		base = 10;
  800bcd:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bcf:	8a 02                	mov    (%edx),%al
  800bd1:	83 e8 30             	sub    $0x30,%eax
  800bd4:	3c 09                	cmp    $0x9,%al
  800bd6:	77 08                	ja     800be0 <strtol+0x84>
			dig = *s - '0';
  800bd8:	0f be 02             	movsbl (%edx),%eax
  800bdb:	83 e8 30             	sub    $0x30,%eax
  800bde:	eb 20                	jmp    800c00 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800be0:	8a 02                	mov    (%edx),%al
  800be2:	83 e8 61             	sub    $0x61,%eax
  800be5:	3c 19                	cmp    $0x19,%al
  800be7:	77 08                	ja     800bf1 <strtol+0x95>
			dig = *s - 'a' + 10;
  800be9:	0f be 02             	movsbl (%edx),%eax
  800bec:	83 e8 57             	sub    $0x57,%eax
  800bef:	eb 0f                	jmp    800c00 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800bf1:	8a 02                	mov    (%edx),%al
  800bf3:	83 e8 41             	sub    $0x41,%eax
  800bf6:	3c 19                	cmp    $0x19,%al
  800bf8:	77 12                	ja     800c0c <strtol+0xb0>
			dig = *s - 'A' + 10;
  800bfa:	0f be 02             	movsbl (%edx),%eax
  800bfd:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800c00:	39 c8                	cmp    %ecx,%eax
  800c02:	7d 08                	jge    800c0c <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800c04:	42                   	inc    %edx
  800c05:	0f af d9             	imul   %ecx,%ebx
  800c08:	01 c3                	add    %eax,%ebx
  800c0a:	eb c3                	jmp    800bcf <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c0c:	85 f6                	test   %esi,%esi
  800c0e:	74 02                	je     800c12 <strtol+0xb6>
		*endptr = (char *) s;
  800c10:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c12:	89 d8                	mov    %ebx,%eax
  800c14:	85 ff                	test   %edi,%edi
  800c16:	74 02                	je     800c1a <strtol+0xbe>
  800c18:	f7 d8                	neg    %eax
}
  800c1a:	5b                   	pop    %ebx
  800c1b:	5e                   	pop    %esi
  800c1c:	5f                   	pop    %edi
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    
	...

00800c20 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	57                   	push   %edi
  800c24:	56                   	push   %esi
  800c25:	53                   	push   %ebx
  800c26:	83 ec 04             	sub    $0x4,%esp
  800c29:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c34:	89 f8                	mov    %edi,%eax
  800c36:	89 fb                	mov    %edi,%ebx
  800c38:	89 fe                	mov    %edi,%esi
  800c3a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c3c:	83 c4 04             	add    $0x4,%esp
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
  800c4a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c4f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c54:	89 fa                	mov    %edi,%edx
  800c56:	89 f9                	mov    %edi,%ecx
  800c58:	89 fb                	mov    %edi,%ebx
  800c5a:	89 fe                	mov    %edi,%esi
  800c5c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c74:	bf 00 00 00 00       	mov    $0x0,%edi
  800c79:	89 f9                	mov    %edi,%ecx
  800c7b:	89 fb                	mov    %edi,%ebx
  800c7d:	89 fe                	mov    %edi,%esi
  800c7f:	cd 30                	int    $0x30
  800c81:	85 c0                	test   %eax,%eax
  800c83:	7e 17                	jle    800c9c <sys_env_destroy+0x39>
  800c85:	83 ec 0c             	sub    $0xc,%esp
  800c88:	50                   	push   %eax
  800c89:	6a 03                	push   $0x3
  800c8b:	68 70 2e 80 00       	push   $0x802e70
  800c90:	6a 23                	push   $0x23
  800c92:	68 8d 2e 80 00       	push   $0x802e8d
  800c97:	e8 80 f5 ff ff       	call   80021c <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c9c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
  800caa:	b8 02 00 00 00       	mov    $0x2,%eax
  800caf:	bf 00 00 00 00       	mov    $0x0,%edi
  800cb4:	89 fa                	mov    %edi,%edx
  800cb6:	89 f9                	mov    %edi,%ecx
  800cb8:	89 fb                	mov    %edi,%ebx
  800cba:	89 fe                	mov    %edi,%esi
  800cbc:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <sys_yield>:

void
sys_yield(void)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cce:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd3:	89 fa                	mov    %edi,%edx
  800cd5:	89 f9                	mov    %edi,%ecx
  800cd7:	89 fb                	mov    %edi,%ebx
  800cd9:	89 fe                	mov    %edi,%esi
  800cdb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cdd:	5b                   	pop    %ebx
  800cde:	5e                   	pop    %esi
  800cdf:	5f                   	pop    %edi
  800ce0:	c9                   	leave  
  800ce1:	c3                   	ret    

00800ce2 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 0c             	sub    $0xc,%esp
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf4:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf9:	bf 00 00 00 00       	mov    $0x0,%edi
  800cfe:	89 fe                	mov    %edi,%esi
  800d00:	cd 30                	int    $0x30
  800d02:	85 c0                	test   %eax,%eax
  800d04:	7e 17                	jle    800d1d <sys_page_alloc+0x3b>
  800d06:	83 ec 0c             	sub    $0xc,%esp
  800d09:	50                   	push   %eax
  800d0a:	6a 04                	push   $0x4
  800d0c:	68 70 2e 80 00       	push   $0x802e70
  800d11:	6a 23                	push   $0x23
  800d13:	68 8d 2e 80 00       	push   $0x802e8d
  800d18:	e8 ff f4 ff ff       	call   80021c <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d1d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 0c             	sub    $0xc,%esp
  800d2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d34:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d37:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d3a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d3d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d42:	cd 30                	int    $0x30
  800d44:	85 c0                	test   %eax,%eax
  800d46:	7e 17                	jle    800d5f <sys_page_map+0x3a>
  800d48:	83 ec 0c             	sub    $0xc,%esp
  800d4b:	50                   	push   %eax
  800d4c:	6a 05                	push   $0x5
  800d4e:	68 70 2e 80 00       	push   $0x802e70
  800d53:	6a 23                	push   $0x23
  800d55:	68 8d 2e 80 00       	push   $0x802e8d
  800d5a:	e8 bd f4 ff ff       	call   80021c <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d5f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	c9                   	leave  
  800d66:	c3                   	ret    

00800d67 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	57                   	push   %edi
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
  800d6d:	83 ec 0c             	sub    $0xc,%esp
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d76:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d80:	89 fb                	mov    %edi,%ebx
  800d82:	89 fe                	mov    %edi,%esi
  800d84:	cd 30                	int    $0x30
  800d86:	85 c0                	test   %eax,%eax
  800d88:	7e 17                	jle    800da1 <sys_page_unmap+0x3a>
  800d8a:	83 ec 0c             	sub    $0xc,%esp
  800d8d:	50                   	push   %eax
  800d8e:	6a 06                	push   $0x6
  800d90:	68 70 2e 80 00       	push   $0x802e70
  800d95:	6a 23                	push   $0x23
  800d97:	68 8d 2e 80 00       	push   $0x802e8d
  800d9c:	e8 7b f4 ff ff       	call   80021c <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    

00800da9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	8b 55 08             	mov    0x8(%ebp),%edx
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	b8 08 00 00 00       	mov    $0x8,%eax
  800dbd:	bf 00 00 00 00       	mov    $0x0,%edi
  800dc2:	89 fb                	mov    %edi,%ebx
  800dc4:	89 fe                	mov    %edi,%esi
  800dc6:	cd 30                	int    $0x30
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	7e 17                	jle    800de3 <sys_env_set_status+0x3a>
  800dcc:	83 ec 0c             	sub    $0xc,%esp
  800dcf:	50                   	push   %eax
  800dd0:	6a 08                	push   $0x8
  800dd2:	68 70 2e 80 00       	push   $0x802e70
  800dd7:	6a 23                	push   $0x23
  800dd9:	68 8d 2e 80 00       	push   $0x802e8d
  800dde:	e8 39 f4 ff ff       	call   80021c <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800de3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800de6:	5b                   	pop    %ebx
  800de7:	5e                   	pop    %esi
  800de8:	5f                   	pop    %edi
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	57                   	push   %edi
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
  800df1:	83 ec 0c             	sub    $0xc,%esp
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfa:	b8 09 00 00 00       	mov    $0x9,%eax
  800dff:	bf 00 00 00 00       	mov    $0x0,%edi
  800e04:	89 fb                	mov    %edi,%ebx
  800e06:	89 fe                	mov    %edi,%esi
  800e08:	cd 30                	int    $0x30
  800e0a:	85 c0                	test   %eax,%eax
  800e0c:	7e 17                	jle    800e25 <sys_env_set_trapframe+0x3a>
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	50                   	push   %eax
  800e12:	6a 09                	push   $0x9
  800e14:	68 70 2e 80 00       	push   $0x802e70
  800e19:	6a 23                	push   $0x23
  800e1b:	68 8d 2e 80 00       	push   $0x802e8d
  800e20:	e8 f7 f3 ff ff       	call   80021c <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e25:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e28:	5b                   	pop    %ebx
  800e29:	5e                   	pop    %esi
  800e2a:	5f                   	pop    %edi
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	57                   	push   %edi
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e41:	bf 00 00 00 00       	mov    $0x0,%edi
  800e46:	89 fb                	mov    %edi,%ebx
  800e48:	89 fe                	mov    %edi,%esi
  800e4a:	cd 30                	int    $0x30
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	7e 17                	jle    800e67 <sys_env_set_pgfault_upcall+0x3a>
  800e50:	83 ec 0c             	sub    $0xc,%esp
  800e53:	50                   	push   %eax
  800e54:	6a 0a                	push   $0xa
  800e56:	68 70 2e 80 00       	push   $0x802e70
  800e5b:	6a 23                	push   $0x23
  800e5d:	68 8d 2e 80 00       	push   $0x802e8d
  800e62:	e8 b5 f3 ff ff       	call   80021c <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e67:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e6a:	5b                   	pop    %ebx
  800e6b:	5e                   	pop    %esi
  800e6c:	5f                   	pop    %edi
  800e6d:	c9                   	leave  
  800e6e:	c3                   	ret    

00800e6f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e6f:	55                   	push   %ebp
  800e70:	89 e5                	mov    %esp,%ebp
  800e72:	57                   	push   %edi
  800e73:	56                   	push   %esi
  800e74:	53                   	push   %ebx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e81:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e86:	be 00 00 00 00       	mov    $0x0,%esi
  800e8b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e8d:	5b                   	pop    %ebx
  800e8e:	5e                   	pop    %esi
  800e8f:	5f                   	pop    %edi
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	57                   	push   %edi
  800e96:	56                   	push   %esi
  800e97:	53                   	push   %ebx
  800e98:	83 ec 0c             	sub    $0xc,%esp
  800e9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ea3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ea8:	89 f9                	mov    %edi,%ecx
  800eaa:	89 fb                	mov    %edi,%ebx
  800eac:	89 fe                	mov    %edi,%esi
  800eae:	cd 30                	int    $0x30
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	7e 17                	jle    800ecb <sys_ipc_recv+0x39>
  800eb4:	83 ec 0c             	sub    $0xc,%esp
  800eb7:	50                   	push   %eax
  800eb8:	6a 0d                	push   $0xd
  800eba:	68 70 2e 80 00       	push   $0x802e70
  800ebf:	6a 23                	push   $0x23
  800ec1:	68 8d 2e 80 00       	push   $0x802e8d
  800ec6:	e8 51 f3 ff ff       	call   80021c <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ecb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	c9                   	leave  
  800ed2:	c3                   	ret    

00800ed3 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	83 ec 0c             	sub    $0xc,%esp
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee2:	b8 10 00 00 00       	mov    $0x10,%eax
  800ee7:	bf 00 00 00 00       	mov    $0x0,%edi
  800eec:	89 fb                	mov    %edi,%ebx
  800eee:	89 fe                	mov    %edi,%esi
  800ef0:	cd 30                	int    $0x30
  800ef2:	85 c0                	test   %eax,%eax
  800ef4:	7e 17                	jle    800f0d <sys_transmit_packet+0x3a>
  800ef6:	83 ec 0c             	sub    $0xc,%esp
  800ef9:	50                   	push   %eax
  800efa:	6a 10                	push   $0x10
  800efc:	68 70 2e 80 00       	push   $0x802e70
  800f01:	6a 23                	push   $0x23
  800f03:	68 8d 2e 80 00       	push   $0x802e8d
  800f08:	e8 0f f3 ff ff       	call   80021c <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800f0d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f24:	b8 11 00 00 00       	mov    $0x11,%eax
  800f29:	bf 00 00 00 00       	mov    $0x0,%edi
  800f2e:	89 fb                	mov    %edi,%ebx
  800f30:	89 fe                	mov    %edi,%esi
  800f32:	cd 30                	int    $0x30
  800f34:	85 c0                	test   %eax,%eax
  800f36:	7e 17                	jle    800f4f <sys_receive_packet+0x3a>
  800f38:	83 ec 0c             	sub    $0xc,%esp
  800f3b:	50                   	push   %eax
  800f3c:	6a 11                	push   $0x11
  800f3e:	68 70 2e 80 00       	push   $0x802e70
  800f43:	6a 23                	push   $0x23
  800f45:	68 8d 2e 80 00       	push   $0x802e8d
  800f4a:	e8 cd f2 ff ff       	call   80021c <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800f4f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f52:	5b                   	pop    %ebx
  800f53:	5e                   	pop    %esi
  800f54:	5f                   	pop    %edi
  800f55:	c9                   	leave  
  800f56:	c3                   	ret    

00800f57 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	57                   	push   %edi
  800f5b:	56                   	push   %esi
  800f5c:	53                   	push   %ebx
  800f5d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f62:	bf 00 00 00 00       	mov    $0x0,%edi
  800f67:	89 fa                	mov    %edi,%edx
  800f69:	89 f9                	mov    %edi,%ecx
  800f6b:	89 fb                	mov    %edi,%ebx
  800f6d:	89 fe                	mov    %edi,%esi
  800f6f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	53                   	push   %ebx
  800f7c:	83 ec 0c             	sub    $0xc,%esp
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f87:	bf 00 00 00 00       	mov    $0x0,%edi
  800f8c:	89 f9                	mov    %edi,%ecx
  800f8e:	89 fb                	mov    %edi,%ebx
  800f90:	89 fe                	mov    %edi,%esi
  800f92:	cd 30                	int    $0x30
  800f94:	85 c0                	test   %eax,%eax
  800f96:	7e 17                	jle    800faf <sys_map_receive_buffers+0x39>
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	6a 0e                	push   $0xe
  800f9e:	68 70 2e 80 00       	push   $0x802e70
  800fa3:	6a 23                	push   $0x23
  800fa5:	68 8d 2e 80 00       	push   $0x802e8d
  800faa:	e8 6d f2 ff ff       	call   80021c <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800faf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	c9                   	leave  
  800fb6:	c3                   	ret    

00800fb7 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	57                   	push   %edi
  800fbb:	56                   	push   %esi
  800fbc:	53                   	push   %ebx
  800fbd:	83 ec 0c             	sub    $0xc,%esp
  800fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc3:	b8 12 00 00 00       	mov    $0x12,%eax
  800fc8:	bf 00 00 00 00       	mov    $0x0,%edi
  800fcd:	89 f9                	mov    %edi,%ecx
  800fcf:	89 fb                	mov    %edi,%ebx
  800fd1:	89 fe                	mov    %edi,%esi
  800fd3:	cd 30                	int    $0x30
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	7e 17                	jle    800ff0 <sys_receive_packet_zerocopy+0x39>
  800fd9:	83 ec 0c             	sub    $0xc,%esp
  800fdc:	50                   	push   %eax
  800fdd:	6a 12                	push   $0x12
  800fdf:	68 70 2e 80 00       	push   $0x802e70
  800fe4:	6a 23                	push   $0x23
  800fe6:	68 8d 2e 80 00       	push   $0x802e8d
  800feb:	e8 2c f2 ff ff       	call   80021c <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  800ff0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ff3:	5b                   	pop    %ebx
  800ff4:	5e                   	pop    %esi
  800ff5:	5f                   	pop    %edi
  800ff6:	c9                   	leave  
  800ff7:	c3                   	ret    

00800ff8 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	57                   	push   %edi
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
  800ffe:	83 ec 0c             	sub    $0xc,%esp
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801007:	b8 13 00 00 00       	mov    $0x13,%eax
  80100c:	bf 00 00 00 00       	mov    $0x0,%edi
  801011:	89 fb                	mov    %edi,%ebx
  801013:	89 fe                	mov    %edi,%esi
  801015:	cd 30                	int    $0x30
  801017:	85 c0                	test   %eax,%eax
  801019:	7e 17                	jle    801032 <sys_env_set_priority+0x3a>
  80101b:	83 ec 0c             	sub    $0xc,%esp
  80101e:	50                   	push   %eax
  80101f:	6a 13                	push   $0x13
  801021:	68 70 2e 80 00       	push   $0x802e70
  801026:	6a 23                	push   $0x23
  801028:	68 8d 2e 80 00       	push   $0x802e8d
  80102d:	e8 ea f1 ff ff       	call   80021c <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  801032:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801035:	5b                   	pop    %ebx
  801036:	5e                   	pop    %esi
  801037:	5f                   	pop    %edi
  801038:	c9                   	leave  
  801039:	c3                   	ret    
	...

0080103c <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	53                   	push   %ebx
  801040:	83 ec 04             	sub    $0x4,%esp
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801046:	8b 18                	mov    (%eax),%ebx
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
  801048:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80104c:	74 11                	je     80105f <pgfault+0x23>
  80104e:	89 d8                	mov    %ebx,%eax
  801050:	c1 e8 0c             	shr    $0xc,%eax
  801053:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80105a:	f6 c4 08             	test   $0x8,%ah
  80105d:	75 14                	jne    801073 <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  80105f:	83 ec 04             	sub    $0x4,%esp
  801062:	68 9c 2e 80 00       	push   $0x802e9c
  801067:	6a 1e                	push   $0x1e
  801069:	68 f0 2e 80 00       	push   $0x802ef0
  80106e:	e8 a9 f1 ff ff       	call   80021c <_panic>
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
  801073:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  801079:	83 ec 04             	sub    $0x4,%esp
  80107c:	6a 07                	push   $0x7
  80107e:	68 00 f0 7f 00       	push   $0x7ff000
  801083:	83 ec 04             	sub    $0x4,%esp
  801086:	e8 19 fc ff ff       	call   800ca4 <sys_getenvid>
  80108b:	89 04 24             	mov    %eax,(%esp)
  80108e:	e8 4f fc ff ff       	call   800ce2 <sys_page_alloc>
  801093:	83 c4 10             	add    $0x10,%esp
  801096:	85 c0                	test   %eax,%eax
  801098:	79 12                	jns    8010ac <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  80109a:	50                   	push   %eax
  80109b:	68 fb 2e 80 00       	push   $0x802efb
  8010a0:	6a 2d                	push   $0x2d
  8010a2:	68 f0 2e 80 00       	push   $0x802ef0
  8010a7:	e8 70 f1 ff ff       	call   80021c <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  8010ac:	83 ec 04             	sub    $0x4,%esp
  8010af:	68 00 10 00 00       	push   $0x1000
  8010b4:	53                   	push   %ebx
  8010b5:	68 00 f0 7f 00       	push   $0x7ff000
  8010ba:	e8 cd f9 ff ff       	call   800a8c <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  8010bf:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010c6:	53                   	push   %ebx
  8010c7:	83 ec 0c             	sub    $0xc,%esp
  8010ca:	e8 d5 fb ff ff       	call   800ca4 <sys_getenvid>
  8010cf:	83 c4 0c             	add    $0xc,%esp
  8010d2:	50                   	push   %eax
  8010d3:	68 00 f0 7f 00       	push   $0x7ff000
  8010d8:	83 ec 04             	sub    $0x4,%esp
  8010db:	e8 c4 fb ff ff       	call   800ca4 <sys_getenvid>
  8010e0:	89 04 24             	mov    %eax,(%esp)
  8010e3:	e8 3d fc ff ff       	call   800d25 <sys_page_map>
  8010e8:	83 c4 20             	add    $0x20,%esp
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	79 12                	jns    801101 <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  8010ef:	50                   	push   %eax
  8010f0:	68 16 2f 80 00       	push   $0x802f16
  8010f5:	6a 33                	push   $0x33
  8010f7:	68 f0 2e 80 00       	push   $0x802ef0
  8010fc:	e8 1b f1 ff ff       	call   80021c <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  801101:	83 ec 08             	sub    $0x8,%esp
  801104:	68 00 f0 7f 00       	push   $0x7ff000
  801109:	83 ec 04             	sub    $0x4,%esp
  80110c:	e8 93 fb ff ff       	call   800ca4 <sys_getenvid>
  801111:	89 04 24             	mov    %eax,(%esp)
  801114:	e8 4e fc ff ff       	call   800d67 <sys_page_unmap>
  801119:	83 c4 10             	add    $0x10,%esp
  80111c:	85 c0                	test   %eax,%eax
  80111e:	79 12                	jns    801132 <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  801120:	50                   	push   %eax
  801121:	68 2f 2f 80 00       	push   $0x802f2f
  801126:	6a 36                	push   $0x36
  801128:	68 f0 2e 80 00       	push   $0x802ef0
  80112d:	e8 ea f0 ff ff       	call   80021c <_panic>
        }

	//panic("pgfault not implemented");
}
  801132:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <duppage>:

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
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	53                   	push   %ebx
  80113b:	83 ec 04             	sub    $0x4,%esp
  80113e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801141:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  801144:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  801149:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  80114c:	f6 c4 04             	test   $0x4,%ah
  80114f:	74 36                	je     801187 <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  801151:	83 ec 0c             	sub    $0xc,%esp
  801154:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801157:	25 07 0e 00 00       	and    $0xe07,%eax
  80115c:	50                   	push   %eax
  80115d:	89 d8                	mov    %ebx,%eax
  80115f:	c1 e0 0c             	shl    $0xc,%eax
  801162:	50                   	push   %eax
  801163:	51                   	push   %ecx
  801164:	50                   	push   %eax
  801165:	83 ec 04             	sub    $0x4,%esp
  801168:	e8 37 fb ff ff       	call   800ca4 <sys_getenvid>
  80116d:	89 04 24             	mov    %eax,(%esp)
  801170:	e8 b0 fb ff ff       	call   800d25 <sys_page_map>
  801175:	83 c4 20             	add    $0x20,%esp
            return r;
  801178:	89 c2                	mov    %eax,%edx
  80117a:	85 c0                	test   %eax,%eax
  80117c:	0f 88 c9 00 00 00    	js     80124b <duppage+0x114>
  801182:	e9 bf 00 00 00       	jmp    801246 <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  801187:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  80118e:	a9 02 08 00 00       	test   $0x802,%eax
  801193:	74 7b                	je     801210 <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801195:	83 ec 0c             	sub    $0xc,%esp
  801198:	68 05 08 00 00       	push   $0x805
  80119d:	89 d8                	mov    %ebx,%eax
  80119f:	c1 e0 0c             	shl    $0xc,%eax
  8011a2:	50                   	push   %eax
  8011a3:	51                   	push   %ecx
  8011a4:	50                   	push   %eax
  8011a5:	83 ec 04             	sub    $0x4,%esp
  8011a8:	e8 f7 fa ff ff       	call   800ca4 <sys_getenvid>
  8011ad:	89 04 24             	mov    %eax,(%esp)
  8011b0:	e8 70 fb ff ff       	call   800d25 <sys_page_map>
  8011b5:	83 c4 20             	add    $0x20,%esp
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	79 12                	jns    8011ce <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  8011bc:	50                   	push   %eax
  8011bd:	68 4a 2f 80 00       	push   $0x802f4a
  8011c2:	6a 56                	push   $0x56
  8011c4:	68 f0 2e 80 00       	push   $0x802ef0
  8011c9:	e8 4e f0 ff ff       	call   80021c <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  8011ce:	83 ec 0c             	sub    $0xc,%esp
  8011d1:	68 05 08 00 00       	push   $0x805
  8011d6:	c1 e3 0c             	shl    $0xc,%ebx
  8011d9:	53                   	push   %ebx
  8011da:	83 ec 0c             	sub    $0xc,%esp
  8011dd:	e8 c2 fa ff ff       	call   800ca4 <sys_getenvid>
  8011e2:	83 c4 0c             	add    $0xc,%esp
  8011e5:	50                   	push   %eax
  8011e6:	53                   	push   %ebx
  8011e7:	83 ec 04             	sub    $0x4,%esp
  8011ea:	e8 b5 fa ff ff       	call   800ca4 <sys_getenvid>
  8011ef:	89 04 24             	mov    %eax,(%esp)
  8011f2:	e8 2e fb ff ff       	call   800d25 <sys_page_map>
  8011f7:	83 c4 20             	add    $0x20,%esp
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	79 48                	jns    801246 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  8011fe:	50                   	push   %eax
  8011ff:	68 4a 2f 80 00       	push   $0x802f4a
  801204:	6a 5b                	push   $0x5b
  801206:	68 f0 2e 80 00       	push   $0x802ef0
  80120b:	e8 0c f0 ff ff       	call   80021c <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  801210:	83 ec 0c             	sub    $0xc,%esp
  801213:	6a 05                	push   $0x5
  801215:	89 d8                	mov    %ebx,%eax
  801217:	c1 e0 0c             	shl    $0xc,%eax
  80121a:	50                   	push   %eax
  80121b:	51                   	push   %ecx
  80121c:	50                   	push   %eax
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	e8 7f fa ff ff       	call   800ca4 <sys_getenvid>
  801225:	89 04 24             	mov    %eax,(%esp)
  801228:	e8 f8 fa ff ff       	call   800d25 <sys_page_map>
  80122d:	83 c4 20             	add    $0x20,%esp
  801230:	85 c0                	test   %eax,%eax
  801232:	79 12                	jns    801246 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  801234:	50                   	push   %eax
  801235:	68 4a 2f 80 00       	push   $0x802f4a
  80123a:	6a 5f                	push   $0x5f
  80123c:	68 f0 2e 80 00       	push   $0x802ef0
  801241:	e8 d6 ef ff ff       	call   80021c <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  801246:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80124b:	89 d0                	mov    %edx,%eax
  80124d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <fork>:

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
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	57                   	push   %edi
  801256:	56                   	push   %esi
  801257:	53                   	push   %ebx
  801258:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  80125b:	68 3c 10 80 00       	push   $0x80103c
  801260:	e8 bb 12 00 00       	call   802520 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  801265:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  801268:	ba 07 00 00 00       	mov    $0x7,%edx
  80126d:	89 d0                	mov    %edx,%eax
  80126f:	cd 30                	int    $0x30
  801271:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  801274:	85 c0                	test   %eax,%eax
  801276:	79 15                	jns    80128d <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  801278:	50                   	push   %eax
  801279:	68 d0 2e 80 00       	push   $0x802ed0
  80127e:	68 85 00 00 00       	push   $0x85
  801283:	68 f0 2e 80 00       	push   $0x802ef0
  801288:	e8 8f ef ff ff       	call   80021c <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  80128d:	bf 00 00 00 00       	mov    $0x0,%edi
  801292:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801296:	75 21                	jne    8012b9 <fork+0x67>
  801298:	e8 07 fa ff ff       	call   800ca4 <sys_getenvid>
  80129d:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012a2:	c1 e0 07             	shl    $0x7,%eax
  8012a5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012aa:	a3 80 70 80 00       	mov    %eax,0x807080
  8012af:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b4:	e9 fd 00 00 00       	jmp    8013b6 <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  8012b9:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  8012c0:	a8 01                	test   $0x1,%al
  8012c2:	74 5f                	je     801323 <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  8012c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c9:	89 f8                	mov    %edi,%eax
  8012cb:	c1 e0 0a             	shl    $0xa,%eax
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  8012d5:	77 4c                	ja     801323 <fork+0xd1>
  8012d7:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  8012d9:	01 da                	add    %ebx,%edx
  8012db:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8012e2:	a8 01                	test   $0x1,%al
  8012e4:	74 28                	je     80130e <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  8012e6:	83 ec 08             	sub    $0x8,%esp
  8012e9:	52                   	push   %edx
  8012ea:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8012ed:	e8 45 fe ff ff       	call   801137 <duppage>
  8012f2:	83 c4 10             	add    $0x10,%esp
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	79 15                	jns    80130e <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  8012f9:	50                   	push   %eax
  8012fa:	68 63 2f 80 00       	push   $0x802f63
  8012ff:	68 95 00 00 00       	push   $0x95
  801304:	68 f0 2e 80 00       	push   $0x802ef0
  801309:	e8 0e ef ff ff       	call   80021c <_panic>
  80130e:	43                   	inc    %ebx
  80130f:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  801315:	7f 0c                	jg     801323 <fork+0xd1>
  801317:	89 f2                	mov    %esi,%edx
  801319:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80131c:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801321:	76 b6                	jbe    8012d9 <fork+0x87>
  801323:	47                   	inc    %edi
  801324:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  80132a:	76 8d                	jbe    8012b9 <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  80132c:	83 ec 04             	sub    $0x4,%esp
  80132f:	6a 07                	push   $0x7
  801331:	68 00 f0 bf ee       	push   $0xeebff000
  801336:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801339:	e8 a4 f9 ff ff       	call   800ce2 <sys_page_alloc>
  80133e:	83 c4 10             	add    $0x10,%esp
  801341:	85 c0                	test   %eax,%eax
  801343:	79 15                	jns    80135a <fork+0x108>
          panic("fork: %d", r);
  801345:	50                   	push   %eax
  801346:	68 7c 2f 80 00       	push   $0x802f7c
  80134b:	68 9d 00 00 00       	push   $0x9d
  801350:	68 f0 2e 80 00       	push   $0x802ef0
  801355:	e8 c2 ee ff ff       	call   80021c <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	a1 80 70 80 00       	mov    0x807080,%eax
  801362:	8b 40 64             	mov    0x64(%eax),%eax
  801365:	50                   	push   %eax
  801366:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801369:	e8 bf fa ff ff       	call   800e2d <sys_env_set_pgfault_upcall>
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	85 c0                	test   %eax,%eax
  801373:	79 15                	jns    80138a <fork+0x138>
          panic("fork: %d", r);
  801375:	50                   	push   %eax
  801376:	68 7c 2f 80 00       	push   $0x802f7c
  80137b:	68 a2 00 00 00       	push   $0xa2
  801380:	68 f0 2e 80 00       	push   $0x802ef0
  801385:	e8 92 ee ff ff       	call   80021c <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  80138a:	83 ec 08             	sub    $0x8,%esp
  80138d:	6a 01                	push   $0x1
  80138f:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801392:	e8 12 fa ff ff       	call   800da9 <sys_env_set_status>
  801397:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  80139a:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80139d:	85 c0                	test   %eax,%eax
  80139f:	79 15                	jns    8013b6 <fork+0x164>
  8013a1:	50                   	push   %eax
  8013a2:	68 7c 2f 80 00       	push   $0x802f7c
  8013a7:	68 a7 00 00 00       	push   $0xa7
  8013ac:	68 f0 2e 80 00       	push   $0x802ef0
  8013b1:	e8 66 ee ff ff       	call   80021c <_panic>
 
	//panic("fork not implemented");
}
  8013b6:	89 d0                	mov    %edx,%eax
  8013b8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8013bb:	5b                   	pop    %ebx
  8013bc:	5e                   	pop    %esi
  8013bd:	5f                   	pop    %edi
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <sfork>:



// Challenge!
int
sfork(void)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8013c6:	68 85 2f 80 00       	push   $0x802f85
  8013cb:	68 b5 00 00 00       	push   $0xb5
  8013d0:	68 f0 2e 80 00       	push   $0x802ef0
  8013d5:	e8 42 ee ff ff       	call   80021c <_panic>
	...

008013dc <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8013e2:	ff 75 08             	pushl  0x8(%ebp)
  8013e5:	e8 0a 00 00 00       	call   8013f4 <fd2num>
  8013ea:	c1 e0 16             	shl    $0x16,%eax
  8013ed:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <fd2num>:

int
fd2num(struct Fd *fd)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fa:	05 00 00 40 30       	add    $0x30400000,%eax
  8013ff:	c1 e8 0c             	shr    $0xc,%eax
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <fd_alloc>:

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
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	57                   	push   %edi
  801408:	56                   	push   %esi
  801409:	53                   	push   %ebx
  80140a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80140d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801412:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801417:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  80141c:	89 c8                	mov    %ecx,%eax
  80141e:	c1 e0 0c             	shl    $0xc,%eax
  801421:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801427:	89 d0                	mov    %edx,%eax
  801429:	c1 e8 16             	shr    $0x16,%eax
  80142c:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80142f:	a8 01                	test   $0x1,%al
  801431:	74 0c                	je     80143f <fd_alloc+0x3b>
  801433:	89 d0                	mov    %edx,%eax
  801435:	c1 e8 0c             	shr    $0xc,%eax
  801438:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  80143b:	a8 01                	test   $0x1,%al
  80143d:	75 09                	jne    801448 <fd_alloc+0x44>
			*fd_store = fd;
  80143f:	89 17                	mov    %edx,(%edi)
			return 0;
  801441:	b8 00 00 00 00       	mov    $0x0,%eax
  801446:	eb 11                	jmp    801459 <fd_alloc+0x55>
  801448:	41                   	inc    %ecx
  801449:	83 f9 1f             	cmp    $0x1f,%ecx
  80144c:	7e ce                	jle    80141c <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80144e:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801454:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801459:	5b                   	pop    %ebx
  80145a:	5e                   	pop    %esi
  80145b:	5f                   	pop    %edi
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801464:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801469:	83 f8 1f             	cmp    $0x1f,%eax
  80146c:	77 3a                	ja     8014a8 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80146e:	c1 e0 0c             	shl    $0xc,%eax
  801471:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801477:	89 d0                	mov    %edx,%eax
  801479:	c1 e8 16             	shr    $0x16,%eax
  80147c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801483:	a8 01                	test   $0x1,%al
  801485:	74 10                	je     801497 <fd_lookup+0x39>
  801487:	89 d0                	mov    %edx,%eax
  801489:	c1 e8 0c             	shr    $0xc,%eax
  80148c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801493:	a8 01                	test   $0x1,%al
  801495:	75 07                	jne    80149e <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801497:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80149c:	eb 0a                	jmp    8014a8 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  80149e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a1:	89 10                	mov    %edx,(%eax)
	return 0;
  8014a3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8014a8:	89 d0                	mov    %edx,%eax
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <fd_close>:

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
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	56                   	push   %esi
  8014b0:	53                   	push   %ebx
  8014b1:	83 ec 10             	sub    $0x10,%esp
  8014b4:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014b7:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8014ba:	50                   	push   %eax
  8014bb:	56                   	push   %esi
  8014bc:	e8 33 ff ff ff       	call   8013f4 <fd2num>
  8014c1:	89 04 24             	mov    %eax,(%esp)
  8014c4:	e8 95 ff ff ff       	call   80145e <fd_lookup>
  8014c9:	89 c3                	mov    %eax,%ebx
  8014cb:	83 c4 08             	add    $0x8,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	78 05                	js     8014d7 <fd_close+0x2b>
  8014d2:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8014d5:	74 0f                	je     8014e6 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8014d7:	89 d8                	mov    %ebx,%eax
  8014d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014dd:	75 3a                	jne    801519 <fd_close+0x6d>
  8014df:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e4:	eb 33                	jmp    801519 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8014e6:	83 ec 08             	sub    $0x8,%esp
  8014e9:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8014ec:	50                   	push   %eax
  8014ed:	ff 36                	pushl  (%esi)
  8014ef:	e8 2c 00 00 00       	call   801520 <dev_lookup>
  8014f4:	89 c3                	mov    %eax,%ebx
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	78 0f                	js     80150c <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8014fd:	83 ec 0c             	sub    $0xc,%esp
  801500:	56                   	push   %esi
  801501:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801504:	ff 50 10             	call   *0x10(%eax)
  801507:	89 c3                	mov    %eax,%ebx
  801509:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80150c:	83 ec 08             	sub    $0x8,%esp
  80150f:	56                   	push   %esi
  801510:	6a 00                	push   $0x0
  801512:	e8 50 f8 ff ff       	call   800d67 <sys_page_unmap>
	return r;
  801517:	89 d8                	mov    %ebx,%eax
}
  801519:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80151c:	5b                   	pop    %ebx
  80151d:	5e                   	pop    %esi
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <dev_lookup>:


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
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
  801525:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801528:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  80152b:	ba 00 00 00 00       	mov    $0x0,%edx
  801530:	83 3d 04 70 80 00 00 	cmpl   $0x0,0x807004
  801537:	74 1c                	je     801555 <dev_lookup+0x35>
  801539:	b9 04 70 80 00       	mov    $0x807004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80153e:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  801541:	39 18                	cmp    %ebx,(%eax)
  801543:	75 09                	jne    80154e <dev_lookup+0x2e>
			*dev = devtab[i];
  801545:	89 06                	mov    %eax,(%esi)
			return 0;
  801547:	b8 00 00 00 00       	mov    $0x0,%eax
  80154c:	eb 29                	jmp    801577 <dev_lookup+0x57>
  80154e:	42                   	inc    %edx
  80154f:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  801553:	75 e9                	jne    80153e <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801555:	83 ec 04             	sub    $0x4,%esp
  801558:	53                   	push   %ebx
  801559:	a1 80 70 80 00       	mov    0x807080,%eax
  80155e:	8b 40 4c             	mov    0x4c(%eax),%eax
  801561:	50                   	push   %eax
  801562:	68 9c 2f 80 00       	push   $0x802f9c
  801567:	e8 a0 ed ff ff       	call   80030c <cprintf>
	*dev = 0;
  80156c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  801572:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801577:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80157a:	5b                   	pop    %ebx
  80157b:	5e                   	pop    %esi
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    

0080157e <close>:

int
close(int fdnum)
{
  80157e:	55                   	push   %ebp
  80157f:	89 e5                	mov    %esp,%ebp
  801581:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801584:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801587:	50                   	push   %eax
  801588:	ff 75 08             	pushl  0x8(%ebp)
  80158b:	e8 ce fe ff ff       	call   80145e <fd_lookup>
  801590:	83 c4 08             	add    $0x8,%esp
		return r;
  801593:	89 c2                	mov    %eax,%edx
  801595:	85 c0                	test   %eax,%eax
  801597:	78 0f                	js     8015a8 <close+0x2a>
	else
		return fd_close(fd, 1);
  801599:	83 ec 08             	sub    $0x8,%esp
  80159c:	6a 01                	push   $0x1
  80159e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8015a1:	e8 06 ff ff ff       	call   8014ac <fd_close>
  8015a6:	89 c2                	mov    %eax,%edx
}
  8015a8:	89 d0                	mov    %edx,%eax
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <close_all>:

void
close_all(void)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	53                   	push   %ebx
  8015b0:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015b3:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015b8:	83 ec 0c             	sub    $0xc,%esp
  8015bb:	53                   	push   %ebx
  8015bc:	e8 bd ff ff ff       	call   80157e <close>
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	43                   	inc    %ebx
  8015c5:	83 fb 1f             	cmp    $0x1f,%ebx
  8015c8:	7e ee                	jle    8015b8 <close_all+0xc>
}
  8015ca:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8015cd:	c9                   	leave  
  8015ce:	c3                   	ret    

008015cf <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	57                   	push   %edi
  8015d3:	56                   	push   %esi
  8015d4:	53                   	push   %ebx
  8015d5:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015d8:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8015db:	50                   	push   %eax
  8015dc:	ff 75 08             	pushl  0x8(%ebp)
  8015df:	e8 7a fe ff ff       	call   80145e <fd_lookup>
  8015e4:	89 c6                	mov    %eax,%esi
  8015e6:	83 c4 08             	add    $0x8,%esp
  8015e9:	85 f6                	test   %esi,%esi
  8015eb:	0f 88 f8 00 00 00    	js     8016e9 <dup+0x11a>
		return r;
	close(newfdnum);
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	ff 75 0c             	pushl  0xc(%ebp)
  8015f7:	e8 82 ff ff ff       	call   80157e <close>

	newfd = INDEX2FD(newfdnum);
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	c1 e0 0c             	shl    $0xc,%eax
  801602:	2d 00 00 40 30       	sub    $0x30400000,%eax
  801607:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  80160a:	83 c4 04             	add    $0x4,%esp
  80160d:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801610:	e8 c7 fd ff ff       	call   8013dc <fd2data>
  801615:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801617:	83 c4 04             	add    $0x4,%esp
  80161a:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80161d:	e8 ba fd ff ff       	call   8013dc <fd2data>
  801622:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801625:	89 f8                	mov    %edi,%eax
  801627:	c1 e8 16             	shr    $0x16,%eax
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801634:	85 c0                	test   %eax,%eax
  801636:	74 48                	je     801680 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801638:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  80163d:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  801640:	89 d0                	mov    %edx,%eax
  801642:	c1 e8 0c             	shr    $0xc,%eax
  801645:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  80164c:	a8 01                	test   $0x1,%al
  80164e:	74 22                	je     801672 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	25 07 0e 00 00       	and    $0xe07,%eax
  801658:	50                   	push   %eax
  801659:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80165c:	01 d8                	add    %ebx,%eax
  80165e:	50                   	push   %eax
  80165f:	6a 00                	push   $0x0
  801661:	52                   	push   %edx
  801662:	6a 00                	push   $0x0
  801664:	e8 bc f6 ff ff       	call   800d25 <sys_page_map>
  801669:	89 c6                	mov    %eax,%esi
  80166b:	83 c4 20             	add    $0x20,%esp
  80166e:	85 c0                	test   %eax,%eax
  801670:	78 3f                	js     8016b1 <dup+0xe2>
  801672:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801678:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80167e:	7e bd                	jle    80163d <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801680:	83 ec 0c             	sub    $0xc,%esp
  801683:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801686:	89 d0                	mov    %edx,%eax
  801688:	c1 e8 0c             	shr    $0xc,%eax
  80168b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801692:	25 07 0e 00 00       	and    $0xe07,%eax
  801697:	50                   	push   %eax
  801698:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80169b:	6a 00                	push   $0x0
  80169d:	52                   	push   %edx
  80169e:	6a 00                	push   $0x0
  8016a0:	e8 80 f6 ff ff       	call   800d25 <sys_page_map>
  8016a5:	89 c6                	mov    %eax,%esi
  8016a7:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	85 f6                	test   %esi,%esi
  8016af:	79 38                	jns    8016e9 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  8016b1:	83 ec 08             	sub    $0x8,%esp
  8016b4:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8016b7:	6a 00                	push   $0x0
  8016b9:	e8 a9 f6 ff ff       	call   800d67 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8016be:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016c3:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8016c6:	83 ec 08             	sub    $0x8,%esp
  8016c9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8016cc:	01 d8                	add    %ebx,%eax
  8016ce:	50                   	push   %eax
  8016cf:	6a 00                	push   $0x0
  8016d1:	e8 91 f6 ff ff       	call   800d67 <sys_page_unmap>
  8016d6:	83 c4 10             	add    $0x10,%esp
  8016d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016df:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8016e5:	7e df                	jle    8016c6 <dup+0xf7>
	return r;
  8016e7:	89 f0                	mov    %esi,%eax
}
  8016e9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8016ec:	5b                   	pop    %ebx
  8016ed:	5e                   	pop    %esi
  8016ee:	5f                   	pop    %edi
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	53                   	push   %ebx
  8016f5:	83 ec 14             	sub    $0x14,%esp
  8016f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016fb:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8016fe:	50                   	push   %eax
  8016ff:	53                   	push   %ebx
  801700:	e8 59 fd ff ff       	call   80145e <fd_lookup>
  801705:	89 c2                	mov    %eax,%edx
  801707:	83 c4 08             	add    $0x8,%esp
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 1a                	js     801728 <read+0x37>
  80170e:	83 ec 08             	sub    $0x8,%esp
  801711:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801714:	50                   	push   %eax
  801715:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801718:	ff 30                	pushl  (%eax)
  80171a:	e8 01 fe ff ff       	call   801520 <dev_lookup>
  80171f:	89 c2                	mov    %eax,%edx
  801721:	83 c4 10             	add    $0x10,%esp
  801724:	85 c0                	test   %eax,%eax
  801726:	79 04                	jns    80172c <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801728:	89 d0                	mov    %edx,%eax
  80172a:	eb 50                	jmp    80177c <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80172c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80172f:	8b 40 08             	mov    0x8(%eax),%eax
  801732:	83 e0 03             	and    $0x3,%eax
  801735:	83 f8 01             	cmp    $0x1,%eax
  801738:	75 1e                	jne    801758 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	53                   	push   %ebx
  80173e:	a1 80 70 80 00       	mov    0x807080,%eax
  801743:	8b 40 4c             	mov    0x4c(%eax),%eax
  801746:	50                   	push   %eax
  801747:	68 dd 2f 80 00       	push   $0x802fdd
  80174c:	e8 bb eb ff ff       	call   80030c <cprintf>
		return -E_INVAL;
  801751:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801756:	eb 24                	jmp    80177c <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801758:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80175b:	ff 70 04             	pushl  0x4(%eax)
  80175e:	ff 75 10             	pushl  0x10(%ebp)
  801761:	ff 75 0c             	pushl  0xc(%ebp)
  801764:	50                   	push   %eax
  801765:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801768:	ff 50 08             	call   *0x8(%eax)
  80176b:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  80176d:	83 c4 10             	add    $0x10,%esp
  801770:	85 c0                	test   %eax,%eax
  801772:	78 06                	js     80177a <read+0x89>
		fd->fd_offset += r;
  801774:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801777:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80177a:	89 d0                	mov    %edx,%eax
}
  80177c:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80177f:	c9                   	leave  
  801780:	c3                   	ret    

00801781 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	57                   	push   %edi
  801785:	56                   	push   %esi
  801786:	53                   	push   %ebx
  801787:	83 ec 0c             	sub    $0xc,%esp
  80178a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80178d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801790:	bb 00 00 00 00       	mov    $0x0,%ebx
  801795:	39 f3                	cmp    %esi,%ebx
  801797:	73 25                	jae    8017be <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	89 f0                	mov    %esi,%eax
  80179e:	29 d8                	sub    %ebx,%eax
  8017a0:	50                   	push   %eax
  8017a1:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8017a4:	50                   	push   %eax
  8017a5:	ff 75 08             	pushl  0x8(%ebp)
  8017a8:	e8 44 ff ff ff       	call   8016f1 <read>
		if (m < 0)
  8017ad:	83 c4 10             	add    $0x10,%esp
  8017b0:	85 c0                	test   %eax,%eax
  8017b2:	78 0c                	js     8017c0 <readn+0x3f>
			return m;
		if (m == 0)
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	74 06                	je     8017be <readn+0x3d>
  8017b8:	01 c3                	add    %eax,%ebx
  8017ba:	39 f3                	cmp    %esi,%ebx
  8017bc:	72 db                	jb     801799 <readn+0x18>
			break;
	}
	return tot;
  8017be:	89 d8                	mov    %ebx,%eax
}
  8017c0:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8017c3:	5b                   	pop    %ebx
  8017c4:	5e                   	pop    %esi
  8017c5:	5f                   	pop    %edi
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	53                   	push   %ebx
  8017cc:	83 ec 14             	sub    $0x14,%esp
  8017cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d2:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8017d5:	50                   	push   %eax
  8017d6:	53                   	push   %ebx
  8017d7:	e8 82 fc ff ff       	call   80145e <fd_lookup>
  8017dc:	89 c2                	mov    %eax,%edx
  8017de:	83 c4 08             	add    $0x8,%esp
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	78 1a                	js     8017ff <write+0x37>
  8017e5:	83 ec 08             	sub    $0x8,%esp
  8017e8:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8017eb:	50                   	push   %eax
  8017ec:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017ef:	ff 30                	pushl  (%eax)
  8017f1:	e8 2a fd ff ff       	call   801520 <dev_lookup>
  8017f6:	89 c2                	mov    %eax,%edx
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	79 04                	jns    801803 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8017ff:	89 d0                	mov    %edx,%eax
  801801:	eb 4b                	jmp    80184e <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801803:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801806:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80180a:	75 1e                	jne    80182a <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	53                   	push   %ebx
  801810:	a1 80 70 80 00       	mov    0x807080,%eax
  801815:	8b 40 4c             	mov    0x4c(%eax),%eax
  801818:	50                   	push   %eax
  801819:	68 f9 2f 80 00       	push   $0x802ff9
  80181e:	e8 e9 ea ff ff       	call   80030c <cprintf>
		return -E_INVAL;
  801823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801828:	eb 24                	jmp    80184e <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  80182a:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80182d:	ff 70 04             	pushl  0x4(%eax)
  801830:	ff 75 10             	pushl  0x10(%ebp)
  801833:	ff 75 0c             	pushl  0xc(%ebp)
  801836:	50                   	push   %eax
  801837:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80183a:	ff 50 0c             	call   *0xc(%eax)
  80183d:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	85 c0                	test   %eax,%eax
  801844:	7e 06                	jle    80184c <write+0x84>
		fd->fd_offset += r;
  801846:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801849:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  80184c:	89 d0                	mov    %edx,%eax
}
  80184e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <seek>:

int
seek(int fdnum, off_t offset)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801859:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80185c:	50                   	push   %eax
  80185d:	ff 75 08             	pushl  0x8(%ebp)
  801860:	e8 f9 fb ff ff       	call   80145e <fd_lookup>
  801865:	83 c4 08             	add    $0x8,%esp
		return r;
  801868:	89 c2                	mov    %eax,%edx
  80186a:	85 c0                	test   %eax,%eax
  80186c:	78 0e                	js     80187c <seek+0x29>
	fd->fd_offset = offset;
  80186e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801871:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801874:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801877:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80187c:	89 d0                	mov    %edx,%eax
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	53                   	push   %ebx
  801884:	83 ec 14             	sub    $0x14,%esp
  801887:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80188a:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80188d:	50                   	push   %eax
  80188e:	53                   	push   %ebx
  80188f:	e8 ca fb ff ff       	call   80145e <fd_lookup>
  801894:	83 c4 08             	add    $0x8,%esp
  801897:	85 c0                	test   %eax,%eax
  801899:	78 4e                	js     8018e9 <ftruncate+0x69>
  80189b:	83 ec 08             	sub    $0x8,%esp
  80189e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8018a1:	50                   	push   %eax
  8018a2:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018a5:	ff 30                	pushl  (%eax)
  8018a7:	e8 74 fc ff ff       	call   801520 <dev_lookup>
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	78 36                	js     8018e9 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018b3:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018b6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018ba:	75 1e                	jne    8018da <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018bc:	83 ec 04             	sub    $0x4,%esp
  8018bf:	53                   	push   %ebx
  8018c0:	a1 80 70 80 00       	mov    0x807080,%eax
  8018c5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018c8:	50                   	push   %eax
  8018c9:	68 bc 2f 80 00       	push   $0x802fbc
  8018ce:	e8 39 ea ff ff       	call   80030c <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8018d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d8:	eb 0f                	jmp    8018e9 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8018da:	83 ec 08             	sub    $0x8,%esp
  8018dd:	ff 75 0c             	pushl  0xc(%ebp)
  8018e0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8018e3:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8018e6:	ff 50 1c             	call   *0x1c(%eax)
}
  8018e9:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	53                   	push   %ebx
  8018f2:	83 ec 14             	sub    $0x14,%esp
  8018f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f8:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8018fb:	50                   	push   %eax
  8018fc:	ff 75 08             	pushl  0x8(%ebp)
  8018ff:	e8 5a fb ff ff       	call   80145e <fd_lookup>
  801904:	83 c4 08             	add    $0x8,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	78 42                	js     80194d <fstat+0x5f>
  80190b:	83 ec 08             	sub    $0x8,%esp
  80190e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801911:	50                   	push   %eax
  801912:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801915:	ff 30                	pushl  (%eax)
  801917:	e8 04 fc ff ff       	call   801520 <dev_lookup>
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	85 c0                	test   %eax,%eax
  801921:	78 2a                	js     80194d <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  801923:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801926:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80192d:	00 00 00 
	stat->st_isdir = 0;
  801930:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801937:	00 00 00 
	stat->st_dev = dev;
  80193a:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  80193d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801943:	83 ec 08             	sub    $0x8,%esp
  801946:	53                   	push   %ebx
  801947:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  80194a:	ff 50 14             	call   *0x14(%eax)
}
  80194d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	56                   	push   %esi
  801956:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801957:	83 ec 08             	sub    $0x8,%esp
  80195a:	6a 00                	push   $0x0
  80195c:	ff 75 08             	pushl  0x8(%ebp)
  80195f:	e8 28 00 00 00       	call   80198c <open>
  801964:	89 c6                	mov    %eax,%esi
  801966:	83 c4 10             	add    $0x10,%esp
  801969:	85 f6                	test   %esi,%esi
  80196b:	78 18                	js     801985 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  80196d:	83 ec 08             	sub    $0x8,%esp
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	56                   	push   %esi
  801974:	e8 75 ff ff ff       	call   8018ee <fstat>
  801979:	89 c3                	mov    %eax,%ebx
	close(fd);
  80197b:	89 34 24             	mov    %esi,(%esp)
  80197e:	e8 fb fb ff ff       	call   80157e <close>
	return r;
  801983:	89 d8                	mov    %ebx,%eax
}
  801985:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801988:	5b                   	pop    %ebx
  801989:	5e                   	pop    %esi
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	53                   	push   %ebx
  801990:	83 ec 10             	sub    $0x10,%esp
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
  801993:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801996:	50                   	push   %eax
  801997:	e8 68 fa ff ff       	call   801404 <fd_alloc>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	85 db                	test   %ebx,%ebx
  8019a3:	78 36                	js     8019db <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  8019a5:	83 ec 04             	sub    $0x4,%esp
  8019a8:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	ff 75 08             	pushl  0x8(%ebp)
  8019b1:	e8 1b 05 00 00       	call   801ed1 <fsipc_open>
  8019b6:	89 c3                	mov    %eax,%ebx
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	79 11                	jns    8019d0 <open+0x44>
          fd_close(fd_store, 0);
  8019bf:	83 ec 08             	sub    $0x8,%esp
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8019c7:	e8 e0 fa ff ff       	call   8014ac <fd_close>
          return r;
  8019cc:	89 d8                	mov    %ebx,%eax
  8019ce:	eb 0b                	jmp    8019db <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  8019d0:	83 ec 0c             	sub    $0xc,%esp
  8019d3:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8019d6:	e8 19 fa ff ff       	call   8013f4 <fd2num>
}
  8019db:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 04             	sub    $0x4,%esp
  8019e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  8019ea:	6a 01                	push   $0x1
  8019ec:	6a 00                	push   $0x0
  8019ee:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  8019f4:	53                   	push   %ebx
  8019f5:	e8 e7 03 00 00       	call   801de1 <funmap>
  8019fa:	83 c4 10             	add    $0x10,%esp
          return r;
  8019fd:	89 c2                	mov    %eax,%edx
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	78 19                	js     801a1c <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  801a03:	83 ec 0c             	sub    $0xc,%esp
  801a06:	ff 73 0c             	pushl  0xc(%ebx)
  801a09:	e8 68 05 00 00       	call   801f76 <fsipc_close>
  801a0e:	83 c4 10             	add    $0x10,%esp
          return r;
  801a11:	89 c2                	mov    %eax,%edx
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 05                	js     801a1c <file_close+0x3c>
        }
        return 0;
  801a17:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a1c:	89 d0                	mov    %edx,%eax
  801a1e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	57                   	push   %edi
  801a27:	56                   	push   %esi
  801a28:	53                   	push   %ebx
  801a29:	83 ec 0c             	sub    $0xc,%esp
  801a2c:	8b 75 10             	mov    0x10(%ebp),%esi
  801a2f:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  801a3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a40:	39 d7                	cmp    %edx,%edi
  801a42:	0f 87 95 00 00 00    	ja     801add <file_read+0xba>
	if (offset + n > size)
  801a48:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801a4b:	39 d0                	cmp    %edx,%eax
  801a4d:	76 04                	jbe    801a53 <file_read+0x30>
		n = size - offset;
  801a4f:	89 d6                	mov    %edx,%esi
  801a51:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801a53:	83 ec 0c             	sub    $0xc,%esp
  801a56:	ff 75 08             	pushl  0x8(%ebp)
  801a59:	e8 7e f9 ff ff       	call   8013dc <fd2data>
  801a5e:	89 c3                	mov    %eax,%ebx
  801a60:	01 fb                	add    %edi,%ebx
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	eb 41                	jmp    801aa8 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801a67:	89 d8                	mov    %ebx,%eax
  801a69:	c1 e8 16             	shr    $0x16,%eax
  801a6c:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801a73:	a8 01                	test   $0x1,%al
  801a75:	74 10                	je     801a87 <file_read+0x64>
  801a77:	89 d8                	mov    %ebx,%eax
  801a79:	c1 e8 0c             	shr    $0xc,%eax
  801a7c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801a83:	a8 01                	test   $0x1,%al
  801a85:	75 1b                	jne    801aa2 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801a8d:	50                   	push   %eax
  801a8e:	57                   	push   %edi
  801a8f:	ff 75 08             	pushl  0x8(%ebp)
  801a92:	e8 d4 02 00 00       	call   801d6b <fmap>
  801a97:	83 c4 10             	add    $0x10,%esp
              return r;
  801a9a:	89 c1                	mov    %eax,%ecx
  801a9c:	85 c0                	test   %eax,%eax
  801a9e:	78 3d                	js     801add <file_read+0xba>
  801aa0:	eb 1c                	jmp    801abe <file_read+0x9b>
  801aa2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801aa8:	83 ec 0c             	sub    $0xc,%esp
  801aab:	ff 75 08             	pushl  0x8(%ebp)
  801aae:	e8 29 f9 ff ff       	call   8013dc <fd2data>
  801ab3:	01 f8                	add    %edi,%eax
  801ab5:	01 f0                	add    %esi,%eax
  801ab7:	83 c4 10             	add    $0x10,%esp
  801aba:	39 d8                	cmp    %ebx,%eax
  801abc:	77 a9                	ja     801a67 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801abe:	83 ec 04             	sub    $0x4,%esp
  801ac1:	56                   	push   %esi
  801ac2:	83 ec 04             	sub    $0x4,%esp
  801ac5:	ff 75 08             	pushl  0x8(%ebp)
  801ac8:	e8 0f f9 ff ff       	call   8013dc <fd2data>
  801acd:	83 c4 08             	add    $0x8,%esp
  801ad0:	01 f8                	add    %edi,%eax
  801ad2:	50                   	push   %eax
  801ad3:	ff 75 0c             	pushl  0xc(%ebp)
  801ad6:	e8 b1 ef ff ff       	call   800a8c <memmove>
	return n;
  801adb:	89 f1                	mov    %esi,%ecx
}
  801add:	89 c8                	mov    %ecx,%eax
  801adf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ae2:	5b                   	pop    %ebx
  801ae3:	5e                   	pop    %esi
  801ae4:	5f                   	pop    %edi
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	56                   	push   %esi
  801aeb:	53                   	push   %ebx
  801aec:	83 ec 18             	sub    $0x18,%esp
  801aef:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801af2:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801af5:	50                   	push   %eax
  801af6:	ff 75 08             	pushl  0x8(%ebp)
  801af9:	e8 60 f9 ff ff       	call   80145e <fd_lookup>
  801afe:	83 c4 10             	add    $0x10,%esp
		return r;
  801b01:	89 c2                	mov    %eax,%edx
  801b03:	85 c0                	test   %eax,%eax
  801b05:	0f 88 9f 00 00 00    	js     801baa <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801b0b:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801b0e:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  801b10:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801b15:	3b 05 20 70 80 00    	cmp    0x807020,%eax
  801b1b:	0f 85 89 00 00 00    	jne    801baa <read_map+0xc3>
	va = fd2data(fd) + offset;
  801b21:	83 ec 0c             	sub    $0xc,%esp
  801b24:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801b27:	e8 b0 f8 ff ff       	call   8013dc <fd2data>
  801b2c:	89 c3                	mov    %eax,%ebx
  801b2e:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801b30:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801b33:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801b38:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801b3e:	7f 6a                	jg     801baa <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801b40:	89 d8                	mov    %ebx,%eax
  801b42:	c1 e8 16             	shr    $0x16,%eax
  801b45:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801b4c:	a8 01                	test   $0x1,%al
  801b4e:	74 10                	je     801b60 <read_map+0x79>
  801b50:	89 d8                	mov    %ebx,%eax
  801b52:	c1 e8 0c             	shr    $0xc,%eax
  801b55:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b5c:	a8 01                	test   $0x1,%al
  801b5e:	75 19                	jne    801b79 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801b60:	83 ec 04             	sub    $0x4,%esp
  801b63:	8d 46 01             	lea    0x1(%esi),%eax
  801b66:	50                   	push   %eax
  801b67:	56                   	push   %esi
  801b68:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801b6b:	e8 fb 01 00 00       	call   801d6b <fmap>
  801b70:	83 c4 10             	add    $0x10,%esp
            return r;
  801b73:	89 c2                	mov    %eax,%edx
  801b75:	85 c0                	test   %eax,%eax
  801b77:	78 31                	js     801baa <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801b79:	89 d8                	mov    %ebx,%eax
  801b7b:	c1 e8 16             	shr    $0x16,%eax
  801b7e:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801b85:	a8 01                	test   $0x1,%al
  801b87:	74 10                	je     801b99 <read_map+0xb2>
  801b89:	89 d8                	mov    %ebx,%eax
  801b8b:	c1 e8 0c             	shr    $0xc,%eax
  801b8e:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b95:	a8 01                	test   $0x1,%al
  801b97:	75 07                	jne    801ba0 <read_map+0xb9>
		return -E_NO_DISK;
  801b99:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801b9e:	eb 0a                	jmp    801baa <read_map+0xc3>

	*blk = (void*) va;
  801ba0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba3:	89 18                	mov    %ebx,(%eax)
	return 0;
  801ba5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801baa:	89 d0                	mov    %edx,%eax
  801bac:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	57                   	push   %edi
  801bb7:	56                   	push   %esi
  801bb8:	53                   	push   %ebx
  801bb9:	83 ec 0c             	sub    $0xc,%esp
  801bbc:	8b 75 08             	mov    0x8(%ebp),%esi
  801bbf:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc5:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801bc8:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801bcd:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801bd3:	0f 87 bd 00 00 00    	ja     801c96 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801bd9:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801bdf:	73 17                	jae    801bf8 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801be1:	83 ec 08             	sub    $0x8,%esp
  801be4:	52                   	push   %edx
  801be5:	56                   	push   %esi
  801be6:	e8 fb 00 00 00       	call   801ce6 <file_trunc>
  801beb:	83 c4 10             	add    $0x10,%esp
			return r;
  801bee:	89 c1                	mov    %eax,%ecx
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	0f 88 9e 00 00 00    	js     801c96 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	56                   	push   %esi
  801bfc:	e8 db f7 ff ff       	call   8013dc <fd2data>
  801c01:	89 c3                	mov    %eax,%ebx
  801c03:	01 fb                	add    %edi,%ebx
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	eb 42                	jmp    801c4c <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801c0a:	89 d8                	mov    %ebx,%eax
  801c0c:	c1 e8 16             	shr    $0x16,%eax
  801c0f:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801c16:	a8 01                	test   $0x1,%al
  801c18:	74 10                	je     801c2a <file_write+0x77>
  801c1a:	89 d8                	mov    %ebx,%eax
  801c1c:	c1 e8 0c             	shr    $0xc,%eax
  801c1f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801c26:	a8 01                	test   $0x1,%al
  801c28:	75 1c                	jne    801c46 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801c2a:	83 ec 04             	sub    $0x4,%esp
  801c2d:	8b 55 10             	mov    0x10(%ebp),%edx
  801c30:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801c33:	50                   	push   %eax
  801c34:	57                   	push   %edi
  801c35:	56                   	push   %esi
  801c36:	e8 30 01 00 00       	call   801d6b <fmap>
  801c3b:	83 c4 10             	add    $0x10,%esp
              return r;
  801c3e:	89 c1                	mov    %eax,%ecx
  801c40:	85 c0                	test   %eax,%eax
  801c42:	78 52                	js     801c96 <file_write+0xe3>
  801c44:	eb 1b                	jmp    801c61 <file_write+0xae>
  801c46:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c4c:	83 ec 0c             	sub    $0xc,%esp
  801c4f:	56                   	push   %esi
  801c50:	e8 87 f7 ff ff       	call   8013dc <fd2data>
  801c55:	01 f8                	add    %edi,%eax
  801c57:	03 45 10             	add    0x10(%ebp),%eax
  801c5a:	83 c4 10             	add    $0x10,%esp
  801c5d:	39 d8                	cmp    %ebx,%eax
  801c5f:	77 a9                	ja     801c0a <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801c61:	83 ec 0c             	sub    $0xc,%esp
  801c64:	68 16 30 80 00       	push   $0x803016
  801c69:	e8 9e e6 ff ff       	call   80030c <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801c6e:	83 c4 0c             	add    $0xc,%esp
  801c71:	ff 75 10             	pushl  0x10(%ebp)
  801c74:	ff 75 0c             	pushl  0xc(%ebp)
  801c77:	56                   	push   %esi
  801c78:	e8 5f f7 ff ff       	call   8013dc <fd2data>
  801c7d:	01 f8                	add    %edi,%eax
  801c7f:	89 04 24             	mov    %eax,(%esp)
  801c82:	e8 05 ee ff ff       	call   800a8c <memmove>
        cprintf("write done\n");
  801c87:	c7 04 24 23 30 80 00 	movl   $0x803023,(%esp)
  801c8e:	e8 79 e6 ff ff       	call   80030c <cprintf>
	return n;
  801c93:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801c96:	89 c8                	mov    %ecx,%eax
  801c98:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5f                   	pop    %edi
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801ca8:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801cab:	83 ec 08             	sub    $0x8,%esp
  801cae:	8d 43 10             	lea    0x10(%ebx),%eax
  801cb1:	50                   	push   %eax
  801cb2:	56                   	push   %esi
  801cb3:	e8 58 ec ff ff       	call   800910 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801cb8:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801cbe:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801cce:	0f 94 c0             	sete   %al
  801cd1:	0f b6 c0             	movzbl %al,%eax
  801cd4:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdf:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801ce2:	5b                   	pop    %ebx
  801ce3:	5e                   	pop    %esi
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	57                   	push   %edi
  801cea:	56                   	push   %esi
  801ceb:	53                   	push   %ebx
  801cec:	83 ec 0c             	sub    $0xc,%esp
  801cef:	8b 75 08             	mov    0x8(%ebp),%esi
  801cf2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801cf5:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801cfa:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801d00:	7f 5f                	jg     801d61 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801d02:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801d08:	83 ec 08             	sub    $0x8,%esp
  801d0b:	53                   	push   %ebx
  801d0c:	ff 76 0c             	pushl  0xc(%esi)
  801d0f:	e8 3a 02 00 00       	call   801f4e <fsipc_set_size>
  801d14:	83 c4 10             	add    $0x10,%esp
		return r;
  801d17:	89 c2                	mov    %eax,%edx
  801d19:	85 c0                	test   %eax,%eax
  801d1b:	78 44                	js     801d61 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801d1d:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801d23:	74 19                	je     801d3e <file_trunc+0x58>
  801d25:	68 50 30 80 00       	push   $0x803050
  801d2a:	68 2f 30 80 00       	push   $0x80302f
  801d2f:	68 dc 00 00 00       	push   $0xdc
  801d34:	68 44 30 80 00       	push   $0x803044
  801d39:	e8 de e4 ff ff       	call   80021c <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801d3e:	83 ec 04             	sub    $0x4,%esp
  801d41:	53                   	push   %ebx
  801d42:	57                   	push   %edi
  801d43:	56                   	push   %esi
  801d44:	e8 22 00 00 00       	call   801d6b <fmap>
  801d49:	83 c4 10             	add    $0x10,%esp
		return r;
  801d4c:	89 c2                	mov    %eax,%edx
  801d4e:	85 c0                	test   %eax,%eax
  801d50:	78 0f                	js     801d61 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	53                   	push   %ebx
  801d55:	57                   	push   %edi
  801d56:	56                   	push   %esi
  801d57:	e8 85 00 00 00       	call   801de1 <funmap>

	return 0;
  801d5c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d61:	89 d0                	mov    %edx,%eax
  801d63:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5f                   	pop    %edi
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <fmap>:

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
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	57                   	push   %edi
  801d6f:	56                   	push   %esi
  801d70:	53                   	push   %ebx
  801d71:	83 ec 0c             	sub    $0xc,%esp
  801d74:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d77:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801d7a:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801d7d:	7d 55                	jge    801dd4 <fmap+0x69>
          fma = fd2data(fd);
  801d7f:	83 ec 0c             	sub    $0xc,%esp
  801d82:	57                   	push   %edi
  801d83:	e8 54 f6 ff ff       	call   8013dc <fd2data>
  801d88:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801d8b:	83 c4 10             	add    $0x10,%esp
  801d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d91:	05 ff 0f 00 00       	add    $0xfff,%eax
  801d96:	89 c3                	mov    %eax,%ebx
  801d98:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801d9e:	39 f3                	cmp    %esi,%ebx
  801da0:	7d 32                	jge    801dd4 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801da2:	83 ec 04             	sub    $0x4,%esp
  801da5:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801da8:	01 d8                	add    %ebx,%eax
  801daa:	50                   	push   %eax
  801dab:	53                   	push   %ebx
  801dac:	ff 77 0c             	pushl  0xc(%edi)
  801daf:	e8 6f 01 00 00       	call   801f23 <fsipc_map>
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	85 c0                	test   %eax,%eax
  801db9:	79 0f                	jns    801dca <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	ff 75 0c             	pushl  0xc(%ebp)
  801dc0:	53                   	push   %ebx
  801dc1:	57                   	push   %edi
  801dc2:	e8 1a 00 00 00       	call   801de1 <funmap>
  801dc7:	83 c4 10             	add    $0x10,%esp
  801dca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801dd0:	39 f3                	cmp    %esi,%ebx
  801dd2:	7c ce                	jl     801da2 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd9:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ddc:	5b                   	pop    %ebx
  801ddd:	5e                   	pop    %esi
  801dde:	5f                   	pop    %edi
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <funmap>:

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
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	57                   	push   %edi
  801de5:	56                   	push   %esi
  801de6:	53                   	push   %ebx
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ded:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801df0:	39 f3                	cmp    %esi,%ebx
  801df2:	0f 8d 80 00 00 00    	jge    801e78 <funmap+0x97>
          fma = fd2data(fd);
  801df8:	83 ec 0c             	sub    $0xc,%esp
  801dfb:	ff 75 08             	pushl  0x8(%ebp)
  801dfe:	e8 d9 f5 ff ff       	call   8013dc <fd2data>
  801e03:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801e05:	83 c4 10             	add    $0x10,%esp
  801e08:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801e0e:	89 c3                	mov    %eax,%ebx
  801e10:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801e16:	39 f3                	cmp    %esi,%ebx
  801e18:	7d 5e                	jge    801e78 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801e1a:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801e1d:	89 c2                	mov    %eax,%edx
  801e1f:	c1 ea 0c             	shr    $0xc,%edx
  801e22:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801e29:	a8 01                	test   $0x1,%al
  801e2b:	74 41                	je     801e6e <funmap+0x8d>
              if (dirty) {
  801e2d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801e31:	74 21                	je     801e54 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801e33:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801e3a:	a8 40                	test   $0x40,%al
  801e3c:	74 16                	je     801e54 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801e3e:	83 ec 08             	sub    $0x8,%esp
  801e41:	53                   	push   %ebx
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	ff 70 0c             	pushl  0xc(%eax)
  801e48:	e8 49 01 00 00       	call   801f96 <fsipc_dirty>
  801e4d:	83 c4 10             	add    $0x10,%esp
  801e50:	85 c0                	test   %eax,%eax
  801e52:	78 29                	js     801e7d <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801e54:	83 ec 08             	sub    $0x8,%esp
  801e57:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801e5a:	50                   	push   %eax
  801e5b:	83 ec 04             	sub    $0x4,%esp
  801e5e:	e8 41 ee ff ff       	call   800ca4 <sys_getenvid>
  801e63:	89 04 24             	mov    %eax,(%esp)
  801e66:	e8 fc ee ff ff       	call   800d67 <sys_page_unmap>
  801e6b:	83 c4 10             	add    $0x10,%esp
  801e6e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e74:	39 f3                	cmp    %esi,%ebx
  801e76:	7c a2                	jl     801e1a <funmap+0x39>
            }
          }
        }

        return 0;
  801e78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801e80:	5b                   	pop    %ebx
  801e81:	5e                   	pop    %esi
  801e82:	5f                   	pop    %edi
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <remove>:

// Delete a file
int
remove(const char *path)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801e8b:	ff 75 08             	pushl  0x8(%ebp)
  801e8e:	e8 2b 01 00 00       	call   801fbe <fsipc_remove>
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801e9b:	e8 64 01 00 00       	call   802004 <fsipc_sync>
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    
	...

00801ea4 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801eaa:	6a 07                	push   $0x7
  801eac:	ff 75 0c             	pushl  0xc(%ebp)
  801eaf:	ff 75 08             	pushl  0x8(%ebp)
  801eb2:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801eb7:	50                   	push   %eax
  801eb8:	e8 7a 07 00 00       	call   802637 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801ebd:	83 c4 0c             	add    $0xc,%esp
  801ec0:	ff 75 14             	pushl  0x14(%ebp)
  801ec3:	ff 75 10             	pushl  0x10(%ebp)
  801ec6:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801ec9:	50                   	push   %eax
  801eca:	e8 05 07 00 00       	call   8025d4 <ipc_recv>
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	56                   	push   %esi
  801ed5:	53                   	push   %ebx
  801ed6:	83 ec 1c             	sub    $0x1c,%esp
  801ed9:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801edc:	bb 00 40 80 00       	mov    $0x804000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801ee1:	56                   	push   %esi
  801ee2:	e8 ed e9 ff ff       	call   8008d4 <strlen>
  801ee7:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801eea:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801eef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ef4:	7f 24                	jg     801f1a <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801ef6:	83 ec 08             	sub    $0x8,%esp
  801ef9:	56                   	push   %esi
  801efa:	53                   	push   %ebx
  801efb:	e8 10 ea ff ff       	call   800910 <strcpy>
	req->req_omode = omode;
  801f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f03:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801f09:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801f0c:	50                   	push   %eax
  801f0d:	ff 75 10             	pushl  0x10(%ebp)
  801f10:	53                   	push   %ebx
  801f11:	6a 01                	push   $0x1
  801f13:	e8 8c ff ff ff       	call   801ea4 <fsipc>
  801f18:	89 c2                	mov    %eax,%edx
}
  801f1a:	89 d0                	mov    %edx,%eax
  801f1c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801f1f:	5b                   	pop    %ebx
  801f20:	5e                   	pop    %esi
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  801f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f34:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801f39:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801f3c:	50                   	push   %eax
  801f3d:	ff 75 10             	pushl  0x10(%ebp)
  801f40:	68 00 40 80 00       	push   $0x804000
  801f45:	6a 02                	push   $0x2
  801f47:	e8 58 ff ff ff       	call   801ea4 <fsipc>

	//return -E_UNSPECIFIED;
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	a3 00 40 80 00       	mov    %eax,0x804000
	req->req_size = size;
  801f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5f:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	68 00 40 80 00       	push   $0x804000
  801f6d:	6a 03                	push   $0x3
  801f6f:	e8 30 ff ff ff       	call   801ea4 <fsipc>
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7f:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	68 00 40 80 00       	push   $0x804000
  801f8d:	6a 04                	push   $0x4
  801f8f:	e8 10 ff ff ff       	call   801ea4 <fsipc>
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  801fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa7:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	68 00 40 80 00       	push   $0x804000
  801fb5:	6a 05                	push   $0x5
  801fb7:	e8 e8 fe ff ff       	call   801ea4 <fsipc>
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	56                   	push   %esi
  801fc2:	53                   	push   %ebx
  801fc3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  801fc6:	be 00 40 80 00       	mov    $0x804000,%esi
	if (strlen(path) >= MAXPATHLEN)
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	53                   	push   %ebx
  801fcf:	e8 00 e9 ff ff       	call   8008d4 <strlen>
  801fd4:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801fd7:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801fdc:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fe1:	7f 18                	jg     801ffb <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  801fe3:	83 ec 08             	sub    $0x8,%esp
  801fe6:	53                   	push   %ebx
  801fe7:	56                   	push   %esi
  801fe8:	e8 23 e9 ff ff       	call   800910 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	56                   	push   %esi
  801ff2:	6a 06                	push   $0x6
  801ff4:	e8 ab fe ff ff       	call   801ea4 <fsipc>
  801ff9:	89 c2                	mov    %eax,%edx
}
  801ffb:	89 d0                	mov    %edx,%eax
  801ffd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802000:	5b                   	pop    %ebx
  802001:	5e                   	pop    %esi
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	68 00 40 80 00       	push   $0x804000
  802013:	6a 07                	push   $0x7
  802015:	e8 8a fe ff ff       	call   801ea4 <fsipc>
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <pipe>:
};

int
pipe(int pfd[2])
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	57                   	push   %edi
  802020:	56                   	push   %esi
  802021:	53                   	push   %ebx
  802022:	83 ec 18             	sub    $0x18,%esp
  802025:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802028:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80202b:	50                   	push   %eax
  80202c:	e8 d3 f3 ff ff       	call   801404 <fd_alloc>
  802031:	89 c3                	mov    %eax,%ebx
  802033:	83 c4 10             	add    $0x10,%esp
  802036:	85 c0                	test   %eax,%eax
  802038:	0f 88 25 01 00 00    	js     802163 <pipe+0x147>
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	68 07 04 00 00       	push   $0x407
  802046:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802049:	6a 00                	push   $0x0
  80204b:	e8 92 ec ff ff       	call   800ce2 <sys_page_alloc>
  802050:	89 c3                	mov    %eax,%ebx
  802052:	83 c4 10             	add    $0x10,%esp
  802055:	85 c0                	test   %eax,%eax
  802057:	0f 88 06 01 00 00    	js     802163 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80205d:	83 ec 0c             	sub    $0xc,%esp
  802060:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  802063:	50                   	push   %eax
  802064:	e8 9b f3 ff ff       	call   801404 <fd_alloc>
  802069:	89 c3                	mov    %eax,%ebx
  80206b:	83 c4 10             	add    $0x10,%esp
  80206e:	85 c0                	test   %eax,%eax
  802070:	0f 88 dd 00 00 00    	js     802153 <pipe+0x137>
  802076:	83 ec 04             	sub    $0x4,%esp
  802079:	68 07 04 00 00       	push   $0x407
  80207e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802081:	6a 00                	push   $0x0
  802083:	e8 5a ec ff ff       	call   800ce2 <sys_page_alloc>
  802088:	89 c3                	mov    %eax,%ebx
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	85 c0                	test   %eax,%eax
  80208f:	0f 88 be 00 00 00    	js     802153 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802095:	83 ec 0c             	sub    $0xc,%esp
  802098:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80209b:	e8 3c f3 ff ff       	call   8013dc <fd2data>
  8020a0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020a2:	83 c4 0c             	add    $0xc,%esp
  8020a5:	68 07 04 00 00       	push   $0x407
  8020aa:	50                   	push   %eax
  8020ab:	6a 00                	push   $0x0
  8020ad:	e8 30 ec ff ff       	call   800ce2 <sys_page_alloc>
  8020b2:	89 c3                	mov    %eax,%ebx
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	0f 88 84 00 00 00    	js     802143 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020bf:	83 ec 0c             	sub    $0xc,%esp
  8020c2:	68 07 04 00 00       	push   $0x407
  8020c7:	83 ec 0c             	sub    $0xc,%esp
  8020ca:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8020cd:	e8 0a f3 ff ff       	call   8013dc <fd2data>
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	50                   	push   %eax
  8020d6:	6a 00                	push   $0x0
  8020d8:	56                   	push   %esi
  8020d9:	6a 00                	push   $0x0
  8020db:	e8 45 ec ff ff       	call   800d25 <sys_page_map>
  8020e0:	89 c3                	mov    %eax,%ebx
  8020e2:	83 c4 20             	add    $0x20,%esp
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	78 4c                	js     802135 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8020e9:	8b 15 40 70 80 00    	mov    0x807040,%edx
  8020ef:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8020f2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020f4:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8020f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8020fe:	8b 15 40 70 80 00    	mov    0x807040,%edx
  802104:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802107:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802109:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80210c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802113:	83 ec 0c             	sub    $0xc,%esp
  802116:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802119:	e8 d6 f2 ff ff       	call   8013f4 <fd2num>
  80211e:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802120:	83 c4 04             	add    $0x4,%esp
  802123:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802126:	e8 c9 f2 ff ff       	call   8013f4 <fd2num>
  80212b:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  80212e:	b8 00 00 00 00       	mov    $0x0,%eax
  802133:	eb 30                	jmp    802165 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  802135:	83 ec 08             	sub    $0x8,%esp
  802138:	56                   	push   %esi
  802139:	6a 00                	push   $0x0
  80213b:	e8 27 ec ff ff       	call   800d67 <sys_page_unmap>
  802140:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  802143:	83 ec 08             	sub    $0x8,%esp
  802146:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802149:	6a 00                	push   $0x0
  80214b:	e8 17 ec ff ff       	call   800d67 <sys_page_unmap>
  802150:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  802153:	83 ec 08             	sub    $0x8,%esp
  802156:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802159:	6a 00                	push   $0x0
  80215b:	e8 07 ec ff ff       	call   800d67 <sys_page_unmap>
  802160:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  802163:	89 d8                	mov    %ebx,%eax
}
  802165:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802168:	5b                   	pop    %ebx
  802169:	5e                   	pop    %esi
  80216a:	5f                   	pop    %edi
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	57                   	push   %edi
  802171:	56                   	push   %esi
  802172:	53                   	push   %ebx
  802173:	83 ec 0c             	sub    $0xc,%esp
  802176:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802179:	a1 80 70 80 00       	mov    0x807080,%eax
  80217e:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  802181:	83 ec 0c             	sub    $0xc,%esp
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	e8 04 05 00 00       	call   802690 <pageref>
  80218c:	89 c3                	mov    %eax,%ebx
  80218e:	89 3c 24             	mov    %edi,(%esp)
  802191:	e8 fa 04 00 00       	call   802690 <pageref>
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	39 c3                	cmp    %eax,%ebx
  80219b:	0f 94 c0             	sete   %al
  80219e:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  8021a1:	8b 0d 80 70 80 00    	mov    0x807080,%ecx
  8021a7:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  8021aa:	39 c6                	cmp    %eax,%esi
  8021ac:	74 1b                	je     8021c9 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  8021ae:	83 fa 01             	cmp    $0x1,%edx
  8021b1:	75 c6                	jne    802179 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8021b3:	6a 01                	push   $0x1
  8021b5:	8b 41 58             	mov    0x58(%ecx),%eax
  8021b8:	50                   	push   %eax
  8021b9:	56                   	push   %esi
  8021ba:	68 78 30 80 00       	push   $0x803078
  8021bf:	e8 48 e1 ff ff       	call   80030c <cprintf>
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	eb b0                	jmp    802179 <_pipeisclosed+0xc>
	}
}
  8021c9:	89 d0                	mov    %edx,%eax
  8021cb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8021ce:	5b                   	pop    %ebx
  8021cf:	5e                   	pop    %esi
  8021d0:	5f                   	pop    %edi
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021d9:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8021dc:	50                   	push   %eax
  8021dd:	ff 75 08             	pushl  0x8(%ebp)
  8021e0:	e8 79 f2 ff ff       	call   80145e <fd_lookup>
  8021e5:	83 c4 10             	add    $0x10,%esp
		return r;
  8021e8:	89 c2                	mov    %eax,%edx
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	78 19                	js     802207 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  8021ee:	83 ec 0c             	sub    $0xc,%esp
  8021f1:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8021f4:	e8 e3 f1 ff ff       	call   8013dc <fd2data>
	return _pipeisclosed(fd, p);
  8021f9:	83 c4 08             	add    $0x8,%esp
  8021fc:	50                   	push   %eax
  8021fd:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802200:	e8 68 ff ff ff       	call   80216d <_pipeisclosed>
  802205:	89 c2                	mov    %eax,%edx
}
  802207:	89 d0                	mov    %edx,%eax
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	57                   	push   %edi
  80220f:	56                   	push   %esi
  802210:	53                   	push   %ebx
  802211:	83 ec 18             	sub    $0x18,%esp
  802214:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  802217:	57                   	push   %edi
  802218:	e8 bf f1 ff ff       	call   8013dc <fd2data>
  80221d:	89 c3                	mov    %eax,%ebx
	if (debug)
  80221f:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802222:	8b 45 0c             	mov    0xc(%ebp),%eax
  802225:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802228:	be 00 00 00 00       	mov    $0x0,%esi
  80222d:	3b 75 10             	cmp    0x10(%ebp),%esi
  802230:	73 55                	jae    802287 <piperead+0x7c>
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
  802232:	8b 03                	mov    (%ebx),%eax
  802234:	3b 43 04             	cmp    0x4(%ebx),%eax
  802237:	75 2c                	jne    802265 <piperead+0x5a>
  802239:	85 f6                	test   %esi,%esi
  80223b:	74 04                	je     802241 <piperead+0x36>
  80223d:	89 f0                	mov    %esi,%eax
  80223f:	eb 48                	jmp    802289 <piperead+0x7e>
  802241:	83 ec 08             	sub    $0x8,%esp
  802244:	53                   	push   %ebx
  802245:	57                   	push   %edi
  802246:	e8 22 ff ff ff       	call   80216d <_pipeisclosed>
  80224b:	83 c4 10             	add    $0x10,%esp
  80224e:	85 c0                	test   %eax,%eax
  802250:	74 07                	je     802259 <piperead+0x4e>
  802252:	b8 00 00 00 00       	mov    $0x0,%eax
  802257:	eb 30                	jmp    802289 <piperead+0x7e>
  802259:	e8 65 ea ff ff       	call   800cc3 <sys_yield>
  80225e:	8b 03                	mov    (%ebx),%eax
  802260:	3b 43 04             	cmp    0x4(%ebx),%eax
  802263:	74 d4                	je     802239 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802265:	8b 13                	mov    (%ebx),%edx
  802267:	89 d0                	mov    %edx,%eax
  802269:	85 d2                	test   %edx,%edx
  80226b:	79 03                	jns    802270 <piperead+0x65>
  80226d:	8d 42 1f             	lea    0x1f(%edx),%eax
  802270:	83 e0 e0             	and    $0xffffffe0,%eax
  802273:	29 c2                	sub    %eax,%edx
  802275:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  802279:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80227c:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  80227f:	ff 03                	incl   (%ebx)
  802281:	46                   	inc    %esi
  802282:	3b 75 10             	cmp    0x10(%ebp),%esi
  802285:	72 ab                	jb     802232 <piperead+0x27>
	}
	return i;
  802287:	89 f0                	mov    %esi,%eax
}
  802289:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80228c:	5b                   	pop    %ebx
  80228d:	5e                   	pop    %esi
  80228e:	5f                   	pop    %edi
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	57                   	push   %edi
  802295:	56                   	push   %esi
  802296:	53                   	push   %ebx
  802297:	83 ec 18             	sub    $0x18,%esp
  80229a:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  80229d:	57                   	push   %edi
  80229e:	e8 39 f1 ff ff       	call   8013dc <fd2data>
  8022a3:	89 c3                	mov    %eax,%ebx
	if (debug)
  8022a5:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8022a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ab:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8022ae:	be 00 00 00 00       	mov    $0x0,%esi
  8022b3:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022b6:	73 55                	jae    80230d <pipewrite+0x7c>
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
  8022b8:	8b 03                	mov    (%ebx),%eax
  8022ba:	83 c0 20             	add    $0x20,%eax
  8022bd:	39 43 04             	cmp    %eax,0x4(%ebx)
  8022c0:	72 27                	jb     8022e9 <pipewrite+0x58>
  8022c2:	83 ec 08             	sub    $0x8,%esp
  8022c5:	53                   	push   %ebx
  8022c6:	57                   	push   %edi
  8022c7:	e8 a1 fe ff ff       	call   80216d <_pipeisclosed>
  8022cc:	83 c4 10             	add    $0x10,%esp
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	74 07                	je     8022da <pipewrite+0x49>
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	eb 35                	jmp    80230f <pipewrite+0x7e>
  8022da:	e8 e4 e9 ff ff       	call   800cc3 <sys_yield>
  8022df:	8b 03                	mov    (%ebx),%eax
  8022e1:	83 c0 20             	add    $0x20,%eax
  8022e4:	39 43 04             	cmp    %eax,0x4(%ebx)
  8022e7:	73 d9                	jae    8022c2 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022e9:	8b 53 04             	mov    0x4(%ebx),%edx
  8022ec:	89 d0                	mov    %edx,%eax
  8022ee:	85 d2                	test   %edx,%edx
  8022f0:	79 03                	jns    8022f5 <pipewrite+0x64>
  8022f2:	8d 42 1f             	lea    0x1f(%edx),%eax
  8022f5:	83 e0 e0             	and    $0xffffffe0,%eax
  8022f8:	29 c2                	sub    %eax,%edx
  8022fa:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  8022fd:	8a 04 31             	mov    (%ecx,%esi,1),%al
  802300:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802304:	ff 43 04             	incl   0x4(%ebx)
  802307:	46                   	inc    %esi
  802308:	3b 75 10             	cmp    0x10(%ebp),%esi
  80230b:	72 ab                	jb     8022b8 <pipewrite+0x27>
	}
	
	return i;
  80230d:	89 f0                	mov    %esi,%eax
}
  80230f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802312:	5b                   	pop    %ebx
  802313:	5e                   	pop    %esi
  802314:	5f                   	pop    %edi
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	56                   	push   %esi
  80231b:	53                   	push   %ebx
  80231c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80231f:	83 ec 0c             	sub    $0xc,%esp
  802322:	ff 75 08             	pushl  0x8(%ebp)
  802325:	e8 b2 f0 ff ff       	call   8013dc <fd2data>
  80232a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80232c:	83 c4 08             	add    $0x8,%esp
  80232f:	68 8b 30 80 00       	push   $0x80308b
  802334:	53                   	push   %ebx
  802335:	e8 d6 e5 ff ff       	call   800910 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80233a:	8b 46 04             	mov    0x4(%esi),%eax
  80233d:	2b 06                	sub    (%esi),%eax
  80233f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802345:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80234c:	00 00 00 
	stat->st_dev = &devpipe;
  80234f:	c7 83 88 00 00 00 40 	movl   $0x807040,0x88(%ebx)
  802356:	70 80 00 
	return 0;
}
  802359:	b8 00 00 00 00       	mov    $0x0,%eax
  80235e:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802361:	5b                   	pop    %ebx
  802362:	5e                   	pop    %esi
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	53                   	push   %ebx
  802369:	83 ec 0c             	sub    $0xc,%esp
  80236c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80236f:	53                   	push   %ebx
  802370:	6a 00                	push   $0x0
  802372:	e8 f0 e9 ff ff       	call   800d67 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802377:	89 1c 24             	mov    %ebx,(%esp)
  80237a:	e8 5d f0 ff ff       	call   8013dc <fd2data>
  80237f:	83 c4 08             	add    $0x8,%esp
  802382:	50                   	push   %eax
  802383:	6a 00                	push   $0x0
  802385:	e8 dd e9 ff ff       	call   800d67 <sys_page_unmap>
}
  80238a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    
	...

00802390 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  802396:	8b 45 08             	mov    0x8(%ebp),%eax
  802399:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80239c:	6a 01                	push   $0x1
  80239e:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8023a1:	50                   	push   %eax
  8023a2:	e8 79 e8 ff ff       	call   800c20 <sys_cputs>
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <getchar>:

int
getchar(void)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8023af:	6a 01                	push   $0x1
  8023b1:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8023b4:	50                   	push   %eax
  8023b5:	6a 00                	push   $0x0
  8023b7:	e8 35 f3 ff ff       	call   8016f1 <read>
	if (r < 0)
  8023bc:	83 c4 10             	add    $0x10,%esp
		return r;
  8023bf:	89 c2                	mov    %eax,%edx
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	78 0d                	js     8023d2 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  8023c5:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	7e 04                	jle    8023d2 <getchar+0x29>
	return c;
  8023ce:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  8023d2:	89 d0                	mov    %edx,%eax
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <iscons>:


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
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023dc:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8023df:	50                   	push   %eax
  8023e0:	ff 75 08             	pushl  0x8(%ebp)
  8023e3:	e8 76 f0 ff ff       	call   80145e <fd_lookup>
  8023e8:	83 c4 10             	add    $0x10,%esp
		return r;
  8023eb:	89 c2                	mov    %eax,%edx
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	78 11                	js     802402 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  8023f1:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8023f4:	8b 00                	mov    (%eax),%eax
  8023f6:	3b 05 60 70 80 00    	cmp    0x807060,%eax
  8023fc:	0f 94 c0             	sete   %al
  8023ff:	0f b6 d0             	movzbl %al,%edx
}
  802402:	89 d0                	mov    %edx,%eax
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <opencons>:

int
opencons(void)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80240c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80240f:	50                   	push   %eax
  802410:	e8 ef ef ff ff       	call   801404 <fd_alloc>
  802415:	83 c4 10             	add    $0x10,%esp
		return r;
  802418:	89 c2                	mov    %eax,%edx
  80241a:	85 c0                	test   %eax,%eax
  80241c:	78 3c                	js     80245a <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80241e:	83 ec 04             	sub    $0x4,%esp
  802421:	68 07 04 00 00       	push   $0x407
  802426:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802429:	6a 00                	push   $0x0
  80242b:	e8 b2 e8 ff ff       	call   800ce2 <sys_page_alloc>
  802430:	83 c4 10             	add    $0x10,%esp
		return r;
  802433:	89 c2                	mov    %eax,%edx
  802435:	85 c0                	test   %eax,%eax
  802437:	78 21                	js     80245a <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  802439:	a1 60 70 80 00       	mov    0x807060,%eax
  80243e:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  802441:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  802443:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802446:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80244d:	83 ec 0c             	sub    $0xc,%esp
  802450:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802453:	e8 9c ef ff ff       	call   8013f4 <fd2num>
  802458:	89 c2                	mov    %eax,%edx
}
  80245a:	89 d0                	mov    %edx,%eax
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  802464:	b8 00 00 00 00       	mov    $0x0,%eax
  802469:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80246d:	74 2a                	je     802499 <cons_read+0x3b>
  80246f:	eb 05                	jmp    802476 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802471:	e8 4d e8 ff ff       	call   800cc3 <sys_yield>
  802476:	e8 c9 e7 ff ff       	call   800c44 <sys_cgetc>
  80247b:	89 c2                	mov    %eax,%edx
  80247d:	85 c0                	test   %eax,%eax
  80247f:	74 f0                	je     802471 <cons_read+0x13>
	if (c < 0)
  802481:	85 d2                	test   %edx,%edx
  802483:	78 14                	js     802499 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802485:	b8 00 00 00 00       	mov    $0x0,%eax
  80248a:	83 fa 04             	cmp    $0x4,%edx
  80248d:	74 0a                	je     802499 <cons_read+0x3b>
	*(char*)vbuf = c;
  80248f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802492:	88 10                	mov    %dl,(%eax)
	return 1;
  802494:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802499:	c9                   	leave  
  80249a:	c3                   	ret    

0080249b <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80249b:	55                   	push   %ebp
  80249c:	89 e5                	mov    %esp,%ebp
  80249e:	57                   	push   %edi
  80249f:	56                   	push   %esi
  8024a0:	53                   	push   %ebx
  8024a1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  8024a7:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024aa:	be 00 00 00 00       	mov    $0x0,%esi
  8024af:	39 fe                	cmp    %edi,%esi
  8024b1:	73 3d                	jae    8024f0 <cons_write+0x55>
		m = n - tot;
  8024b3:	89 fb                	mov    %edi,%ebx
  8024b5:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8024b7:	83 fb 7f             	cmp    $0x7f,%ebx
  8024ba:	76 05                	jbe    8024c1 <cons_write+0x26>
			m = sizeof(buf) - 1;
  8024bc:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8024c1:	83 ec 04             	sub    $0x4,%esp
  8024c4:	53                   	push   %ebx
  8024c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c8:	01 f0                	add    %esi,%eax
  8024ca:	50                   	push   %eax
  8024cb:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8024d1:	50                   	push   %eax
  8024d2:	e8 b5 e5 ff ff       	call   800a8c <memmove>
		sys_cputs(buf, m);
  8024d7:	83 c4 08             	add    $0x8,%esp
  8024da:	53                   	push   %ebx
  8024db:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  8024e1:	50                   	push   %eax
  8024e2:	e8 39 e7 ff ff       	call   800c20 <sys_cputs>
  8024e7:	83 c4 10             	add    $0x10,%esp
  8024ea:	01 de                	add    %ebx,%esi
  8024ec:	39 fe                	cmp    %edi,%esi
  8024ee:	72 c3                	jb     8024b3 <cons_write+0x18>
	}
	return tot;
}
  8024f0:	89 f0                	mov    %esi,%eax
  8024f2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8024f5:	5b                   	pop    %ebx
  8024f6:	5e                   	pop    %esi
  8024f7:	5f                   	pop    %edi
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <cons_close>:

int
cons_close(struct Fd *fd)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8024fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802502:	c9                   	leave  
  802503:	c3                   	ret    

00802504 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80250a:	68 97 30 80 00       	push   $0x803097
  80250f:	ff 75 0c             	pushl  0xc(%ebp)
  802512:	e8 f9 e3 ff ff       	call   800910 <strcpy>
	return 0;
}
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
  80251c:	c9                   	leave  
  80251d:	c3                   	ret    
	...

00802520 <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
  802523:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802526:	83 3d 88 70 80 00 00 	cmpl   $0x0,0x807088
  80252d:	75 68                	jne    802597 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	6a 07                	push   $0x7
  802534:	68 00 f0 bf ee       	push   $0xeebff000
  802539:	83 ec 04             	sub    $0x4,%esp
  80253c:	e8 63 e7 ff ff       	call   800ca4 <sys_getenvid>
  802541:	89 04 24             	mov    %eax,(%esp)
  802544:	e8 99 e7 ff ff       	call   800ce2 <sys_page_alloc>
  802549:	83 c4 10             	add    $0x10,%esp
  80254c:	85 c0                	test   %eax,%eax
  80254e:	79 14                	jns    802564 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  802550:	83 ec 04             	sub    $0x4,%esp
  802553:	68 a0 30 80 00       	push   $0x8030a0
  802558:	6a 21                	push   $0x21
  80255a:	68 01 31 80 00       	push   $0x803101
  80255f:	e8 b8 dc ff ff       	call   80021c <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  802564:	83 ec 08             	sub    $0x8,%esp
  802567:	68 a4 25 80 00       	push   $0x8025a4
  80256c:	83 ec 04             	sub    $0x4,%esp
  80256f:	e8 30 e7 ff ff       	call   800ca4 <sys_getenvid>
  802574:	89 04 24             	mov    %eax,(%esp)
  802577:	e8 b1 e8 ff ff       	call   800e2d <sys_env_set_pgfault_upcall>
  80257c:	83 c4 10             	add    $0x10,%esp
  80257f:	85 c0                	test   %eax,%eax
  802581:	79 14                	jns    802597 <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  802583:	83 ec 04             	sub    $0x4,%esp
  802586:	68 d0 30 80 00       	push   $0x8030d0
  80258b:	6a 24                	push   $0x24
  80258d:	68 01 31 80 00       	push   $0x803101
  802592:	e8 85 dc ff ff       	call   80021c <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	a3 88 70 80 00       	mov    %eax,0x807088
}
  80259f:	c9                   	leave  
  8025a0:	c3                   	ret    
  8025a1:	00 00                	add    %al,(%eax)
	...

008025a4 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025a4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025a5:	a1 88 70 80 00       	mov    0x807088,%eax
	call *%eax
  8025aa:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8025ac:	83 c4 04             	add    $0x4,%esp
	
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
  8025af:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  8025b3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  8025b7:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  8025ba:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  8025bd:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  8025c0:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  8025c4:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  8025c7:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  8025cb:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  8025cc:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  8025cf:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  8025d0:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  8025d1:	c3                   	ret    
	...

008025d4 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	56                   	push   %esi
  8025d8:	53                   	push   %ebx
  8025d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8025dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025df:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	75 12                	jne    8025f8 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  8025e6:	83 ec 0c             	sub    $0xc,%esp
  8025e9:	68 00 00 c0 ee       	push   $0xeec00000
  8025ee:	e8 9f e8 ff ff       	call   800e92 <sys_ipc_recv>
  8025f3:	83 c4 10             	add    $0x10,%esp
  8025f6:	eb 0c                	jmp    802604 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  8025f8:	83 ec 0c             	sub    $0xc,%esp
  8025fb:	50                   	push   %eax
  8025fc:	e8 91 e8 ff ff       	call   800e92 <sys_ipc_recv>
  802601:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802604:	89 c2                	mov    %eax,%edx
  802606:	85 c0                	test   %eax,%eax
  802608:	78 24                	js     80262e <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  80260a:	85 db                	test   %ebx,%ebx
  80260c:	74 0a                	je     802618 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  80260e:	a1 80 70 80 00       	mov    0x807080,%eax
  802613:	8b 40 74             	mov    0x74(%eax),%eax
  802616:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802618:	85 f6                	test   %esi,%esi
  80261a:	74 0a                	je     802626 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  80261c:	a1 80 70 80 00       	mov    0x807080,%eax
  802621:	8b 40 78             	mov    0x78(%eax),%eax
  802624:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  802626:	a1 80 70 80 00       	mov    0x807080,%eax
  80262b:	8b 50 70             	mov    0x70(%eax),%edx

}
  80262e:	89 d0                	mov    %edx,%eax
  802630:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802633:	5b                   	pop    %ebx
  802634:	5e                   	pop    %esi
  802635:	c9                   	leave  
  802636:	c3                   	ret    

00802637 <ipc_send>:

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
  802637:	55                   	push   %ebp
  802638:	89 e5                	mov    %esp,%ebp
  80263a:	57                   	push   %edi
  80263b:	56                   	push   %esi
  80263c:	53                   	push   %ebx
  80263d:	83 ec 0c             	sub    $0xc,%esp
  802640:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802643:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802646:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802649:	85 db                	test   %ebx,%ebx
  80264b:	75 0a                	jne    802657 <ipc_send+0x20>
    pg = (void *) UTOP;
  80264d:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  802652:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  802657:	56                   	push   %esi
  802658:	53                   	push   %ebx
  802659:	57                   	push   %edi
  80265a:	ff 75 08             	pushl  0x8(%ebp)
  80265d:	e8 0d e8 ff ff       	call   800e6f <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  802662:	83 c4 10             	add    $0x10,%esp
  802665:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802668:	75 07                	jne    802671 <ipc_send+0x3a>
      sys_yield();
  80266a:	e8 54 e6 ff ff       	call   800cc3 <sys_yield>
  80266f:	eb e6                	jmp    802657 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  802671:	85 c0                	test   %eax,%eax
  802673:	79 12                	jns    802687 <ipc_send+0x50>
  802675:	50                   	push   %eax
  802676:	68 0f 31 80 00       	push   $0x80310f
  80267b:	6a 49                	push   $0x49
  80267d:	68 2c 31 80 00       	push   $0x80312c
  802682:	e8 95 db ff ff       	call   80021c <_panic>
    else break;
  }
}
  802687:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80268a:	5b                   	pop    %ebx
  80268b:	5e                   	pop    %esi
  80268c:	5f                   	pop    %edi
  80268d:	c9                   	leave  
  80268e:	c3                   	ret    
	...

00802690 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802696:	89 c8                	mov    %ecx,%eax
  802698:	c1 e8 16             	shr    $0x16,%eax
  80269b:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  8026a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a7:	a8 01                	test   $0x1,%al
  8026a9:	74 28                	je     8026d3 <pageref+0x43>
	pte = vpt[VPN(v)];
  8026ab:	89 c8                	mov    %ecx,%eax
  8026ad:	c1 e8 0c             	shr    $0xc,%eax
  8026b0:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  8026b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026bc:	a8 01                	test   $0x1,%al
  8026be:	74 13                	je     8026d3 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  8026c0:	c1 e8 0c             	shr    $0xc,%eax
  8026c3:	8d 04 40             	lea    (%eax,%eax,2),%eax
  8026c6:	c1 e0 02             	shl    $0x2,%eax
  8026c9:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  8026d0:	0f b7 d0             	movzwl %ax,%edx
}
  8026d3:	89 d0                	mov    %edx,%eax
  8026d5:	c9                   	leave  
  8026d6:	c3                   	ret    
	...

008026d8 <__udivdi3>:
  8026d8:	55                   	push   %ebp
  8026d9:	89 e5                	mov    %esp,%ebp
  8026db:	57                   	push   %edi
  8026dc:	56                   	push   %esi
  8026dd:	83 ec 14             	sub    $0x14,%esp
  8026e0:	8b 55 14             	mov    0x14(%ebp),%edx
  8026e3:	8b 75 08             	mov    0x8(%ebp),%esi
  8026e6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8026e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ec:	85 d2                	test   %edx,%edx
  8026ee:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  8026f1:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8026f4:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8026f7:	89 fe                	mov    %edi,%esi
  8026f9:	75 11                	jne    80270c <__udivdi3+0x34>
  8026fb:	39 f8                	cmp    %edi,%eax
  8026fd:	76 4d                	jbe    80274c <__udivdi3+0x74>
  8026ff:	89 fa                	mov    %edi,%edx
  802701:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802704:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802707:	89 c7                	mov    %eax,%edi
  802709:	eb 09                	jmp    802714 <__udivdi3+0x3c>
  80270b:	90                   	nop    
  80270c:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  80270f:	76 17                	jbe    802728 <__udivdi3+0x50>
  802711:	31 ff                	xor    %edi,%edi
  802713:	90                   	nop    
  802714:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  80271b:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  80271e:	83 c4 14             	add    $0x14,%esp
  802721:	5e                   	pop    %esi
  802722:	89 f8                	mov    %edi,%eax
  802724:	5f                   	pop    %edi
  802725:	c9                   	leave  
  802726:	c3                   	ret    
  802727:	90                   	nop    
  802728:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  80272c:	89 c7                	mov    %eax,%edi
  80272e:	83 f7 1f             	xor    $0x1f,%edi
  802731:	75 4d                	jne    802780 <__udivdi3+0xa8>
  802733:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802736:	77 0a                	ja     802742 <__udivdi3+0x6a>
  802738:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80273b:	31 ff                	xor    %edi,%edi
  80273d:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802740:	72 d2                	jb     802714 <__udivdi3+0x3c>
  802742:	bf 01 00 00 00       	mov    $0x1,%edi
  802747:	eb cb                	jmp    802714 <__udivdi3+0x3c>
  802749:	8d 76 00             	lea    0x0(%esi),%esi
  80274c:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	75 0e                	jne    802761 <__udivdi3+0x89>
  802753:	b8 01 00 00 00       	mov    $0x1,%eax
  802758:	31 c9                	xor    %ecx,%ecx
  80275a:	31 d2                	xor    %edx,%edx
  80275c:	f7 f1                	div    %ecx
  80275e:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802761:	89 f0                	mov    %esi,%eax
  802763:	31 d2                	xor    %edx,%edx
  802765:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802768:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80276b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80276e:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802771:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802774:	83 c4 14             	add    $0x14,%esp
  802777:	89 c7                	mov    %eax,%edi
  802779:	5e                   	pop    %esi
  80277a:	89 f8                	mov    %edi,%eax
  80277c:	5f                   	pop    %edi
  80277d:	c9                   	leave  
  80277e:	c3                   	ret    
  80277f:	90                   	nop    
  802780:	b8 20 00 00 00       	mov    $0x20,%eax
  802785:	29 f8                	sub    %edi,%eax
  802787:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  80278a:	89 f9                	mov    %edi,%ecx
  80278c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80278f:	d3 e2                	shl    %cl,%edx
  802791:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802794:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802797:	d3 e8                	shr    %cl,%eax
  802799:	09 c2                	or     %eax,%edx
  80279b:	89 f9                	mov    %edi,%ecx
  80279d:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8027a0:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8027a3:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8027a6:	89 f2                	mov    %esi,%edx
  8027a8:	d3 ea                	shr    %cl,%edx
  8027aa:	89 f9                	mov    %edi,%ecx
  8027ac:	d3 e6                	shl    %cl,%esi
  8027ae:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8027b1:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8027b4:	d3 e8                	shr    %cl,%eax
  8027b6:	09 c6                	or     %eax,%esi
  8027b8:	89 f9                	mov    %edi,%ecx
  8027ba:	89 f0                	mov    %esi,%eax
  8027bc:	f7 75 f4             	divl   0xfffffff4(%ebp)
  8027bf:	89 d6                	mov    %edx,%esi
  8027c1:	89 c7                	mov    %eax,%edi
  8027c3:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8027c6:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8027c9:	f7 e7                	mul    %edi
  8027cb:	39 f2                	cmp    %esi,%edx
  8027cd:	77 0f                	ja     8027de <__udivdi3+0x106>
  8027cf:	0f 85 3f ff ff ff    	jne    802714 <__udivdi3+0x3c>
  8027d5:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  8027d8:	0f 86 36 ff ff ff    	jbe    802714 <__udivdi3+0x3c>
  8027de:	4f                   	dec    %edi
  8027df:	e9 30 ff ff ff       	jmp    802714 <__udivdi3+0x3c>

008027e4 <__umoddi3>:
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
  8027e7:	57                   	push   %edi
  8027e8:	56                   	push   %esi
  8027e9:	83 ec 30             	sub    $0x30,%esp
  8027ec:	8b 55 14             	mov    0x14(%ebp),%edx
  8027ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8027f2:	89 d7                	mov    %edx,%edi
  8027f4:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  8027f7:	89 c6                	mov    %eax,%esi
  8027f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	85 ff                	test   %edi,%edi
  802801:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802808:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80280f:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  802812:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802815:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802818:	75 3e                	jne    802858 <__umoddi3+0x74>
  80281a:	39 d6                	cmp    %edx,%esi
  80281c:	0f 86 a2 00 00 00    	jbe    8028c4 <__umoddi3+0xe0>
  802822:	f7 f6                	div    %esi
  802824:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802827:	85 c9                	test   %ecx,%ecx
  802829:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  80282c:	74 1b                	je     802849 <__umoddi3+0x65>
  80282e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802831:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802834:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80283b:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80283e:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802841:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802844:	89 10                	mov    %edx,(%eax)
  802846:	89 48 04             	mov    %ecx,0x4(%eax)
  802849:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80284c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80284f:	83 c4 30             	add    $0x30,%esp
  802852:	5e                   	pop    %esi
  802853:	5f                   	pop    %edi
  802854:	c9                   	leave  
  802855:	c3                   	ret    
  802856:	89 f6                	mov    %esi,%esi
  802858:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  80285b:	76 1f                	jbe    80287c <__umoddi3+0x98>
  80285d:	8b 55 08             	mov    0x8(%ebp),%edx
  802860:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802863:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802866:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802869:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80286c:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80286f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  802872:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802875:	83 c4 30             	add    $0x30,%esp
  802878:	5e                   	pop    %esi
  802879:	5f                   	pop    %edi
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    
  80287c:	0f bd c7             	bsr    %edi,%eax
  80287f:	83 f0 1f             	xor    $0x1f,%eax
  802882:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  802885:	75 61                	jne    8028e8 <__umoddi3+0x104>
  802887:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  80288a:	77 05                	ja     802891 <__umoddi3+0xad>
  80288c:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  80288f:	72 10                	jb     8028a1 <__umoddi3+0xbd>
  802891:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802894:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802897:	29 f0                	sub    %esi,%eax
  802899:	19 fa                	sbb    %edi,%edx
  80289b:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80289e:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8028a1:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8028a4:	85 d2                	test   %edx,%edx
  8028a6:	74 a1                	je     802849 <__umoddi3+0x65>
  8028a8:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8028ab:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8028ae:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8028b1:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  8028b4:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8028b7:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8028ba:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8028bd:	89 01                	mov    %eax,(%ecx)
  8028bf:	89 51 04             	mov    %edx,0x4(%ecx)
  8028c2:	eb 85                	jmp    802849 <__umoddi3+0x65>
  8028c4:	85 f6                	test   %esi,%esi
  8028c6:	75 0b                	jne    8028d3 <__umoddi3+0xef>
  8028c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8028cd:	31 d2                	xor    %edx,%edx
  8028cf:	f7 f6                	div    %esi
  8028d1:	89 c6                	mov    %eax,%esi
  8028d3:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8028d6:	89 fa                	mov    %edi,%edx
  8028d8:	f7 f6                	div    %esi
  8028da:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8028dd:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8028e0:	f7 f6                	div    %esi
  8028e2:	e9 3d ff ff ff       	jmp    802824 <__umoddi3+0x40>
  8028e7:	90                   	nop    
  8028e8:	b8 20 00 00 00       	mov    $0x20,%eax
  8028ed:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  8028f0:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  8028f3:	89 fa                	mov    %edi,%edx
  8028f5:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8028f8:	d3 e2                	shl    %cl,%edx
  8028fa:	89 f0                	mov    %esi,%eax
  8028fc:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8028ff:	d3 e8                	shr    %cl,%eax
  802901:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802904:	d3 e6                	shl    %cl,%esi
  802906:	89 d7                	mov    %edx,%edi
  802908:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80290b:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80290e:	09 c7                	or     %eax,%edi
  802910:	d3 ea                	shr    %cl,%edx
  802912:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802915:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802918:	d3 e0                	shl    %cl,%eax
  80291a:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80291d:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802920:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802923:	d3 e8                	shr    %cl,%eax
  802925:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802928:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80292b:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80292e:	f7 f7                	div    %edi
  802930:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802933:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802936:	f7 e6                	mul    %esi
  802938:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  80293b:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  80293e:	77 0a                	ja     80294a <__umoddi3+0x166>
  802940:	75 12                	jne    802954 <__umoddi3+0x170>
  802942:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802945:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802948:	76 0a                	jbe    802954 <__umoddi3+0x170>
  80294a:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  80294d:	29 f1                	sub    %esi,%ecx
  80294f:	19 fa                	sbb    %edi,%edx
  802951:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802954:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	0f 84 ea fe ff ff    	je     802849 <__umoddi3+0x65>
  80295f:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802962:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802965:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802968:	19 d1                	sbb    %edx,%ecx
  80296a:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  80296d:	89 ca                	mov    %ecx,%edx
  80296f:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802972:	d3 e2                	shl    %cl,%edx
  802974:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802977:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80297a:	d3 e8                	shr    %cl,%eax
  80297c:	09 c2                	or     %eax,%edx
  80297e:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802981:	d3 e8                	shr    %cl,%eax
  802983:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802986:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802989:	e9 ad fe ff ff       	jmp    80283b <__umoddi3+0x57>
