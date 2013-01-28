
obj/user/testpiperace:     file format elf32-i386

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
  80002c:	e8 bf 01 00 00       	call   8001f0 <libmain>
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
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003d:	68 c0 29 80 00       	push   $0x8029c0
  800042:	e8 f5 02 00 00       	call   80033c <cprintf>
	if ((r = pipe(p)) < 0)
  800047:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  80004a:	89 04 24             	mov    %eax,(%esp)
  80004d:	e8 fe 20 00 00       	call   802150 <pipe>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	85 c0                	test   %eax,%eax
  800057:	79 12                	jns    80006b <umain+0x37>
		panic("pipe: %e", r);
  800059:	50                   	push   %eax
  80005a:	68 d9 29 80 00       	push   $0x8029d9
  80005f:	6a 0d                	push   $0xd
  800061:	68 e2 29 80 00       	push   $0x8029e2
  800066:	e8 e1 01 00 00       	call   80024c <_panic>
	max = 200;
  80006b:	bf c8 00 00 00       	mov    $0xc8,%edi
	if ((r = fork()) < 0)
  800070:	e8 0d 12 00 00       	call   801282 <fork>
  800075:	89 c6                	mov    %eax,%esi
  800077:	85 c0                	test   %eax,%eax
  800079:	79 12                	jns    80008d <umain+0x59>
		panic("fork: %e", r);
  80007b:	50                   	push   %eax
  80007c:	68 f6 29 80 00       	push   $0x8029f6
  800081:	6a 10                	push   $0x10
  800083:	68 e2 29 80 00       	push   $0x8029e2
  800088:	e8 bf 01 00 00       	call   80024c <_panic>
	if (r == 0) {
  80008d:	85 c0                	test   %eax,%eax
  80008f:	75 59                	jne    8000ea <umain+0xb6>
		close(p[1]);
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	ff 75 ec             	pushl  0xffffffec(%ebp)
  800097:	e8 ce 15 00 00       	call   80166a <close>
		//
		// Now the ref count for p[0] will toggle between 2 and 3
		// as the parent dups and closes it (there's a close implicit in dup).
		// 
		// The ref count for p[1] is 1.
		// Thus the ref count for the underlying pipe structure 
		// will toggle between 3 and 4.
		//
		// If a clock interrupt catches close between unmapping
		// the pipe structure and unmapping the fd, we'll have
		// a ref count for p[0] of 3, a ref count for p[1] of 1,
		// and a ref count for the pipe structure of 3, which is 
		// a no-no.
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  80009c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8000a1:	83 c4 10             	add    $0x10,%esp
  8000a4:	39 fe                	cmp    %edi,%esi
  8000a6:	7d 31                	jge    8000d9 <umain+0xa5>
			if(pipeisclosed(p[0])){
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8000ae:	e8 54 22 00 00       	call   802307 <pipeisclosed>
  8000b3:	83 c4 10             	add    $0x10,%esp
  8000b6:	85 c0                	test   %eax,%eax
  8000b8:	74 15                	je     8000cf <umain+0x9b>
				cprintf("RACE: pipe appears closed\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 ff 29 80 00       	push   $0x8029ff
  8000c2:	e8 75 02 00 00       	call   80033c <cprintf>
				exit();
  8000c7:	e8 68 01 00 00       	call   800234 <exit>
  8000cc:	83 c4 10             	add    $0x10,%esp
			}
			sys_yield();
  8000cf:	e8 1f 0c 00 00       	call   800cf3 <sys_yield>
  8000d4:	43                   	inc    %ebx
  8000d5:	39 fb                	cmp    %edi,%ebx
  8000d7:	7c cf                	jl     8000a8 <umain+0x74>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	6a 00                	push   $0x0
  8000de:	6a 00                	push   $0x0
  8000e0:	6a 00                	push   $0x0
  8000e2:	e8 25 13 00 00       	call   80140c <ipc_recv>
  8000e7:	83 c4 10             	add    $0x10,%esp
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  8000ea:	83 ec 08             	sub    $0x8,%esp
  8000ed:	56                   	push   %esi
  8000ee:	68 1a 2a 80 00       	push   $0x802a1a
  8000f3:	e8 44 02 00 00       	call   80033c <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  8000f8:	89 f3                	mov    %esi,%ebx
  8000fa:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800100:	89 d8                	mov    %ebx,%eax
  800102:	c1 e0 07             	shl    $0x7,%eax
	cprintf("kid is %d\n", kid-envs);
  800105:	83 c4 08             	add    $0x8,%esp
  800108:	8d 98 00 00 c0 ee    	lea    0xeec00000(%eax),%ebx
  80010e:	c1 e8 07             	shr    $0x7,%eax
  800111:	50                   	push   %eax
  800112:	68 25 2a 80 00       	push   $0x802a25
  800117:	e8 20 02 00 00       	call   80033c <cprintf>
	dup(p[0], 10);
  80011c:	83 c4 08             	add    $0x8,%esp
  80011f:	6a 0a                	push   $0xa
  800121:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800124:	e8 92 15 00 00       	call   8016bb <dup>
	while (kid->env_status == ENV_RUNNABLE)
  800129:	83 c4 10             	add    $0x10,%esp
		dup(p[0], 10);
  80012c:	8b 43 54             	mov    0x54(%ebx),%eax
  80012f:	83 f8 01             	cmp    $0x1,%eax
  800132:	75 18                	jne    80014c <umain+0x118>
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	6a 0a                	push   $0xa
  800139:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80013c:	e8 7a 15 00 00       	call   8016bb <dup>
  800141:	83 c4 10             	add    $0x10,%esp
  800144:	8b 43 54             	mov    0x54(%ebx),%eax
  800147:	83 f8 01             	cmp    $0x1,%eax
  80014a:	74 e8                	je     800134 <umain+0x100>

	cprintf("child done with loop\n");
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	68 30 2a 80 00       	push   $0x802a30
  800154:	e8 e3 01 00 00       	call   80033c <cprintf>
	if (pipeisclosed(p[0]))
  800159:	83 c4 04             	add    $0x4,%esp
  80015c:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80015f:	e8 a3 21 00 00       	call   802307 <pipeisclosed>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	85 c0                	test   %eax,%eax
  800169:	74 14                	je     80017f <umain+0x14b>
		panic("somehow the other end of p[0] got closed!");
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 8c 2a 80 00       	push   $0x802a8c
  800173:	6a 3a                	push   $0x3a
  800175:	68 e2 29 80 00       	push   $0x8029e2
  80017a:	e8 cd 00 00 00       	call   80024c <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	8d 45 e4             	lea    0xffffffe4(%ebp),%eax
  800185:	50                   	push   %eax
  800186:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800189:	e8 bc 13 00 00       	call   80154a <fd_lookup>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	85 c0                	test   %eax,%eax
  800193:	79 12                	jns    8001a7 <umain+0x173>
		panic("cannot look up p[0]: %e", r);
  800195:	50                   	push   %eax
  800196:	68 46 2a 80 00       	push   $0x802a46
  80019b:	6a 3c                	push   $0x3c
  80019d:	68 e2 29 80 00       	push   $0x8029e2
  8001a2:	e8 a5 00 00 00       	call   80024c <_panic>
	va = fd2data(fd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  8001ad:	e8 16 13 00 00       	call   8014c8 <fd2data>
	if (pageref(va) != 3+1)
  8001b2:	89 04 24             	mov    %eax,(%esp)
  8001b5:	e8 4e 1f 00 00       	call   802108 <pageref>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	83 f8 04             	cmp    $0x4,%eax
  8001c0:	74 12                	je     8001d4 <umain+0x1a0>
		cprintf("\nchild detected race\n");
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	68 5e 2a 80 00       	push   $0x802a5e
  8001ca:	e8 6d 01 00 00       	call   80033c <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
  8001d2:	eb 11                	jmp    8001e5 <umain+0x1b1>
	else
		cprintf("\nrace didn't happen\n", max);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	57                   	push   %edi
  8001d8:	68 74 2a 80 00       	push   $0x802a74
  8001dd:	e8 5a 01 00 00       	call   80033c <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
}
  8001e5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8001e8:	5b                   	pop    %ebx
  8001e9:	5e                   	pop    %esi
  8001ea:	5f                   	pop    %edi
  8001eb:	c9                   	leave  
  8001ec:	c3                   	ret    
  8001ed:	00 00                	add    %al,(%eax)
	...

008001f0 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	56                   	push   %esi
  8001f4:	53                   	push   %ebx
  8001f5:	8b 75 08             	mov    0x8(%ebp),%esi
  8001f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  8001fb:	e8 d4 0a 00 00       	call   800cd4 <sys_getenvid>
  800200:	25 ff 03 00 00       	and    $0x3ff,%eax
  800205:	c1 e0 07             	shl    $0x7,%eax
  800208:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020d:	a3 80 70 80 00       	mov    %eax,0x807080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800212:	85 f6                	test   %esi,%esi
  800214:	7e 07                	jle    80021d <libmain+0x2d>
		binaryname = argv[0];
  800216:	8b 03                	mov    (%ebx),%eax
  800218:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  80021d:	83 ec 08             	sub    $0x8,%esp
  800220:	53                   	push   %ebx
  800221:	56                   	push   %esi
  800222:	e8 0d fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800227:	e8 08 00 00 00       	call   800234 <exit>
}
  80022c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80022f:	5b                   	pop    %ebx
  800230:	5e                   	pop    %esi
  800231:	c9                   	leave  
  800232:	c3                   	ret    
	...

00800234 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800234:	55                   	push   %ebp
  800235:	89 e5                	mov    %esp,%ebp
  800237:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80023a:	e8 59 14 00 00       	call   801698 <close_all>
	sys_env_destroy(0);
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	6a 00                	push   $0x0
  800244:	e8 4a 0a 00 00       	call   800c93 <sys_env_destroy>
}
  800249:	c9                   	leave  
  80024a:	c3                   	ret    
	...

0080024c <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	53                   	push   %ebx
  800250:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  800253:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  800256:	83 3d 84 70 80 00 00 	cmpl   $0x0,0x807084
  80025d:	74 16                	je     800275 <_panic+0x29>
		cprintf("%s: ", argv0);
  80025f:	83 ec 08             	sub    $0x8,%esp
  800262:	ff 35 84 70 80 00    	pushl  0x807084
  800268:	68 cd 2a 80 00       	push   $0x802acd
  80026d:	e8 ca 00 00 00       	call   80033c <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800275:	ff 75 0c             	pushl  0xc(%ebp)
  800278:	ff 75 08             	pushl  0x8(%ebp)
  80027b:	ff 35 00 70 80 00    	pushl  0x807000
  800281:	68 d2 2a 80 00       	push   $0x802ad2
  800286:	e8 b1 00 00 00       	call   80033c <cprintf>
	vcprintf(fmt, ap);
  80028b:	83 c4 08             	add    $0x8,%esp
  80028e:	53                   	push   %ebx
  80028f:	ff 75 10             	pushl  0x10(%ebp)
  800292:	e8 54 00 00 00       	call   8002eb <vcprintf>
	cprintf("\n");
  800297:	c7 04 24 d7 29 80 00 	movl   $0x8029d7,(%esp)
  80029e:	e8 99 00 00 00       	call   80033c <cprintf>

	// Cause a breakpoint exception
	while (1)
  8002a3:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  8002a6:	cc                   	int3   
  8002a7:	eb fd                	jmp    8002a6 <_panic+0x5a>
  8002a9:	00 00                	add    %al,(%eax)
	...

008002ac <putch>:


static void
putch(int ch, struct printbuf *b)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b6:	8b 03                	mov    (%ebx),%eax
  8002b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bb:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  8002bf:	40                   	inc    %eax
  8002c0:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002c2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c7:	75 1a                	jne    8002e3 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	68 ff 00 00 00       	push   $0xff
  8002d1:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d4:	50                   	push   %eax
  8002d5:	e8 76 09 00 00       	call   800c50 <sys_cputs>
		b->idx = 0;
  8002da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002e0:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8002e3:	ff 43 04             	incl   0x4(%ebx)
}
  8002e6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8002e9:	c9                   	leave  
  8002ea:	c3                   	ret    

008002eb <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002eb:	55                   	push   %ebp
  8002ec:	89 e5                	mov    %esp,%ebp
  8002ee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f4:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  8002fb:	00 00 00 
	b.cnt = 0;
  8002fe:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800305:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800308:	ff 75 0c             	pushl  0xc(%ebp)
  80030b:	ff 75 08             	pushl  0x8(%ebp)
  80030e:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800314:	50                   	push   %eax
  800315:	68 ac 02 80 00       	push   $0x8002ac
  80031a:	e8 4f 01 00 00       	call   80046e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80031f:	83 c4 08             	add    $0x8,%esp
  800322:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  800328:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  80032e:	50                   	push   %eax
  80032f:	e8 1c 09 00 00       	call   800c50 <sys_cputs>

	return b.cnt;
  800334:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  80033a:	c9                   	leave  
  80033b:	c3                   	ret    

0080033c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800342:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800345:	50                   	push   %eax
  800346:	ff 75 08             	pushl  0x8(%ebp)
  800349:	e8 9d ff ff ff       	call   8002eb <vcprintf>
	va_end(ap);

	return cnt;
}
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	57                   	push   %edi
  800354:	56                   	push   %esi
  800355:	53                   	push   %ebx
  800356:	83 ec 0c             	sub    $0xc,%esp
  800359:	8b 75 10             	mov    0x10(%ebp),%esi
  80035c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80035f:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800362:	8b 45 18             	mov    0x18(%ebp),%eax
  800365:	ba 00 00 00 00       	mov    $0x0,%edx
  80036a:	39 fa                	cmp    %edi,%edx
  80036c:	77 39                	ja     8003a7 <printnum+0x57>
  80036e:	72 04                	jb     800374 <printnum+0x24>
  800370:	39 f0                	cmp    %esi,%eax
  800372:	77 33                	ja     8003a7 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800374:	83 ec 04             	sub    $0x4,%esp
  800377:	ff 75 20             	pushl  0x20(%ebp)
  80037a:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  80037d:	50                   	push   %eax
  80037e:	ff 75 18             	pushl  0x18(%ebp)
  800381:	8b 45 18             	mov    0x18(%ebp),%eax
  800384:	ba 00 00 00 00       	mov    $0x0,%edx
  800389:	52                   	push   %edx
  80038a:	50                   	push   %eax
  80038b:	57                   	push   %edi
  80038c:	56                   	push   %esi
  80038d:	e8 76 23 00 00       	call   802708 <__udivdi3>
  800392:	83 c4 10             	add    $0x10,%esp
  800395:	52                   	push   %edx
  800396:	50                   	push   %eax
  800397:	ff 75 0c             	pushl  0xc(%ebp)
  80039a:	ff 75 08             	pushl  0x8(%ebp)
  80039d:	e8 ae ff ff ff       	call   800350 <printnum>
  8003a2:	83 c4 20             	add    $0x20,%esp
  8003a5:	eb 19                	jmp    8003c0 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003a7:	4b                   	dec    %ebx
  8003a8:	85 db                	test   %ebx,%ebx
  8003aa:	7e 14                	jle    8003c0 <printnum+0x70>
  8003ac:	83 ec 08             	sub    $0x8,%esp
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 20             	pushl  0x20(%ebp)
  8003b5:	ff 55 08             	call   *0x8(%ebp)
  8003b8:	83 c4 10             	add    $0x10,%esp
  8003bb:	4b                   	dec    %ebx
  8003bc:	85 db                	test   %ebx,%ebx
  8003be:	7f ec                	jg     8003ac <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ce:	83 ec 04             	sub    $0x4,%esp
  8003d1:	52                   	push   %edx
  8003d2:	50                   	push   %eax
  8003d3:	57                   	push   %edi
  8003d4:	56                   	push   %esi
  8003d5:	e8 3a 24 00 00       	call   802814 <__umoddi3>
  8003da:	83 c4 14             	add    $0x14,%esp
  8003dd:	0f be 80 e8 2b 80 00 	movsbl 0x802be8(%eax),%eax
  8003e4:	50                   	push   %eax
  8003e5:	ff 55 08             	call   *0x8(%ebp)
}
  8003e8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8003eb:	5b                   	pop    %ebx
  8003ec:	5e                   	pop    %esi
  8003ed:	5f                   	pop    %edi
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

008003f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003f6:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8003f9:	83 f8 01             	cmp    $0x1,%eax
  8003fc:	7e 0f                	jle    80040d <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  8003fe:	8b 01                	mov    (%ecx),%eax
  800400:	83 c0 08             	add    $0x8,%eax
  800403:	89 01                	mov    %eax,(%ecx)
  800405:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800408:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80040b:	eb 24                	jmp    800431 <getuint+0x41>
	else if (lflag)
  80040d:	85 c0                	test   %eax,%eax
  80040f:	74 11                	je     800422 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800411:	8b 01                	mov    (%ecx),%eax
  800413:	83 c0 04             	add    $0x4,%eax
  800416:	89 01                	mov    %eax,(%ecx)
  800418:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80041b:	ba 00 00 00 00       	mov    $0x0,%edx
  800420:	eb 0f                	jmp    800431 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  800422:	8b 01                	mov    (%ecx),%eax
  800424:	83 c0 04             	add    $0x4,%eax
  800427:	89 01                	mov    %eax,(%ecx)
  800429:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80042c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	8b 55 08             	mov    0x8(%ebp),%edx
  800439:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80043c:	83 f8 01             	cmp    $0x1,%eax
  80043f:	7e 0f                	jle    800450 <getint+0x1d>
		return va_arg(*ap, long long);
  800441:	8b 02                	mov    (%edx),%eax
  800443:	83 c0 08             	add    $0x8,%eax
  800446:	89 02                	mov    %eax,(%edx)
  800448:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80044b:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80044e:	eb 1c                	jmp    80046c <getint+0x39>
	else if (lflag)
  800450:	85 c0                	test   %eax,%eax
  800452:	74 0d                	je     800461 <getint+0x2e>
		return va_arg(*ap, long);
  800454:	8b 02                	mov    (%edx),%eax
  800456:	83 c0 04             	add    $0x4,%eax
  800459:	89 02                	mov    %eax,(%edx)
  80045b:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80045e:	99                   	cltd   
  80045f:	eb 0b                	jmp    80046c <getint+0x39>
	else
		return va_arg(*ap, int);
  800461:	8b 02                	mov    (%edx),%eax
  800463:	83 c0 04             	add    $0x4,%eax
  800466:	89 02                	mov    %eax,(%edx)
  800468:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80046b:	99                   	cltd   
}
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	57                   	push   %edi
  800472:	56                   	push   %esi
  800473:	53                   	push   %ebx
  800474:	83 ec 1c             	sub    $0x1c,%esp
  800477:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  80047a:	0f b6 13             	movzbl (%ebx),%edx
  80047d:	43                   	inc    %ebx
  80047e:	83 fa 25             	cmp    $0x25,%edx
  800481:	74 1e                	je     8004a1 <vprintfmt+0x33>
  800483:	85 d2                	test   %edx,%edx
  800485:	0f 84 d7 02 00 00    	je     800762 <vprintfmt+0x2f4>
  80048b:	83 ec 08             	sub    $0x8,%esp
  80048e:	ff 75 0c             	pushl  0xc(%ebp)
  800491:	52                   	push   %edx
  800492:	ff 55 08             	call   *0x8(%ebp)
  800495:	83 c4 10             	add    $0x10,%esp
  800498:	0f b6 13             	movzbl (%ebx),%edx
  80049b:	43                   	inc    %ebx
  80049c:	83 fa 25             	cmp    $0x25,%edx
  80049f:	75 e2                	jne    800483 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  8004a1:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  8004a5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  8004ac:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  8004b1:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  8004b6:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004bd:	0f b6 13             	movzbl (%ebx),%edx
  8004c0:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  8004c3:	43                   	inc    %ebx
  8004c4:	83 f8 55             	cmp    $0x55,%eax
  8004c7:	0f 87 70 02 00 00    	ja     80073d <vprintfmt+0x2cf>
  8004cd:	ff 24 85 7c 2c 80 00 	jmp    *0x802c7c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  8004d4:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  8004d8:	eb e3                	jmp    8004bd <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004da:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  8004de:	eb dd                	jmp    8004bd <vprintfmt+0x4f>

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
  8004e0:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  8004e5:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  8004e8:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  8004ec:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  8004ef:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  8004f2:	83 f8 09             	cmp    $0x9,%eax
  8004f5:	77 27                	ja     80051e <vprintfmt+0xb0>
  8004f7:	43                   	inc    %ebx
  8004f8:	eb eb                	jmp    8004e5 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004fa:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8004fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800501:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800504:	eb 18                	jmp    80051e <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  800506:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80050a:	79 b1                	jns    8004bd <vprintfmt+0x4f>
				width = 0;
  80050c:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800513:	eb a8                	jmp    8004bd <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800515:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  80051c:	eb 9f                	jmp    8004bd <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  80051e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800522:	79 99                	jns    8004bd <vprintfmt+0x4f>
				width = precision, precision = -1;
  800524:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  800527:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  80052c:	eb 8f                	jmp    8004bd <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80052e:	41                   	inc    %ecx
			goto reswitch;
  80052f:	eb 8c                	jmp    8004bd <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	ff 70 fc             	pushl  0xfffffffc(%eax)
  800541:	ff 55 08             	call   *0x8(%ebp)
			break;
  800544:	83 c4 10             	add    $0x10,%esp
  800547:	e9 2e ff ff ff       	jmp    80047a <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80054c:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  800556:	85 c0                	test   %eax,%eax
  800558:	79 02                	jns    80055c <vprintfmt+0xee>
				err = -err;
  80055a:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80055c:	83 f8 0e             	cmp    $0xe,%eax
  80055f:	7f 0b                	jg     80056c <vprintfmt+0xfe>
  800561:	8b 3c 85 40 2c 80 00 	mov    0x802c40(,%eax,4),%edi
  800568:	85 ff                	test   %edi,%edi
  80056a:	75 19                	jne    800585 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  80056c:	50                   	push   %eax
  80056d:	68 f9 2b 80 00       	push   $0x802bf9
  800572:	ff 75 0c             	pushl  0xc(%ebp)
  800575:	ff 75 08             	pushl  0x8(%ebp)
  800578:	e8 ed 01 00 00       	call   80076a <printfmt>
  80057d:	83 c4 10             	add    $0x10,%esp
  800580:	e9 f5 fe ff ff       	jmp    80047a <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800585:	57                   	push   %edi
  800586:	68 a9 30 80 00       	push   $0x8030a9
  80058b:	ff 75 0c             	pushl  0xc(%ebp)
  80058e:	ff 75 08             	pushl  0x8(%ebp)
  800591:	e8 d4 01 00 00       	call   80076a <printfmt>
  800596:	83 c4 10             	add    $0x10,%esp
			break;
  800599:	e9 dc fe ff ff       	jmp    80047a <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80059e:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  8005a8:	85 ff                	test   %edi,%edi
  8005aa:	75 05                	jne    8005b1 <vprintfmt+0x143>
				p = "(null)";
  8005ac:	bf 02 2c 80 00       	mov    $0x802c02,%edi
			if (width > 0 && padc != '-')
  8005b1:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005b5:	7e 3b                	jle    8005f2 <vprintfmt+0x184>
  8005b7:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  8005bb:	74 35                	je     8005f2 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005bd:	83 ec 08             	sub    $0x8,%esp
  8005c0:	56                   	push   %esi
  8005c1:	57                   	push   %edi
  8005c2:	e8 56 03 00 00       	call   80091d <strnlen>
  8005c7:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  8005ca:	83 c4 10             	add    $0x10,%esp
  8005cd:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005d1:	7e 1f                	jle    8005f2 <vprintfmt+0x184>
  8005d3:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8005d7:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	ff 75 0c             	pushl  0xc(%ebp)
  8005e0:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  8005e3:	ff 55 08             	call   *0x8(%ebp)
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8005ec:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8005f0:	7f e8                	jg     8005da <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f2:	0f be 17             	movsbl (%edi),%edx
  8005f5:	47                   	inc    %edi
  8005f6:	85 d2                	test   %edx,%edx
  8005f8:	74 44                	je     80063e <vprintfmt+0x1d0>
  8005fa:	85 f6                	test   %esi,%esi
  8005fc:	78 03                	js     800601 <vprintfmt+0x193>
  8005fe:	4e                   	dec    %esi
  8005ff:	78 3d                	js     80063e <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800601:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800605:	74 18                	je     80061f <vprintfmt+0x1b1>
  800607:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80060a:	83 f8 5e             	cmp    $0x5e,%eax
  80060d:	76 10                	jbe    80061f <vprintfmt+0x1b1>
					putch('?', putdat);
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	ff 75 0c             	pushl  0xc(%ebp)
  800615:	6a 3f                	push   $0x3f
  800617:	ff 55 08             	call   *0x8(%ebp)
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	eb 0d                	jmp    80062c <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  80061f:	83 ec 08             	sub    $0x8,%esp
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	52                   	push   %edx
  800626:	ff 55 08             	call   *0x8(%ebp)
  800629:	83 c4 10             	add    $0x10,%esp
  80062c:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80062f:	0f be 17             	movsbl (%edi),%edx
  800632:	47                   	inc    %edi
  800633:	85 d2                	test   %edx,%edx
  800635:	74 07                	je     80063e <vprintfmt+0x1d0>
  800637:	85 f6                	test   %esi,%esi
  800639:	78 c6                	js     800601 <vprintfmt+0x193>
  80063b:	4e                   	dec    %esi
  80063c:	79 c3                	jns    800601 <vprintfmt+0x193>
			for (; width > 0; width--)
  80063e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800642:	0f 8e 32 fe ff ff    	jle    80047a <vprintfmt+0xc>
				putch(' ', putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 0c             	pushl  0xc(%ebp)
  80064e:	6a 20                	push   $0x20
  800650:	ff 55 08             	call   *0x8(%ebp)
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800659:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80065d:	7f e9                	jg     800648 <vprintfmt+0x1da>
			break;
  80065f:	e9 16 fe ff ff       	jmp    80047a <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800664:	51                   	push   %ecx
  800665:	8d 45 14             	lea    0x14(%ebp),%eax
  800668:	50                   	push   %eax
  800669:	e8 c5 fd ff ff       	call   800433 <getint>
  80066e:	89 c6                	mov    %eax,%esi
  800670:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  800672:	83 c4 08             	add    $0x8,%esp
  800675:	85 d2                	test   %edx,%edx
  800677:	79 15                	jns    80068e <vprintfmt+0x220>
				putch('-', putdat);
  800679:	83 ec 08             	sub    $0x8,%esp
  80067c:	ff 75 0c             	pushl  0xc(%ebp)
  80067f:	6a 2d                	push   $0x2d
  800681:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800684:	f7 de                	neg    %esi
  800686:	83 d7 00             	adc    $0x0,%edi
  800689:	f7 df                	neg    %edi
  80068b:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80068e:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800693:	eb 75                	jmp    80070a <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800695:	51                   	push   %ecx
  800696:	8d 45 14             	lea    0x14(%ebp),%eax
  800699:	50                   	push   %eax
  80069a:	e8 51 fd ff ff       	call   8003f0 <getuint>
  80069f:	89 c6                	mov    %eax,%esi
  8006a1:	89 d7                	mov    %edx,%edi
			base = 10;
  8006a3:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8006a8:	83 c4 08             	add    $0x8,%esp
  8006ab:	eb 5d                	jmp    80070a <vprintfmt+0x29c>

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
  8006ad:	51                   	push   %ecx
  8006ae:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b1:	50                   	push   %eax
  8006b2:	e8 39 fd ff ff       	call   8003f0 <getuint>
  8006b7:	89 c6                	mov    %eax,%esi
  8006b9:	89 d7                	mov    %edx,%edi
			base = 8;
  8006bb:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  8006c0:	83 c4 08             	add    $0x8,%esp
  8006c3:	eb 45                	jmp    80070a <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  8006c5:	83 ec 08             	sub    $0x8,%esp
  8006c8:	ff 75 0c             	pushl  0xc(%ebp)
  8006cb:	6a 30                	push   $0x30
  8006cd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006d0:	83 c4 08             	add    $0x8,%esp
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	6a 78                	push   $0x78
  8006d8:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  8006db:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  8006e5:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006ea:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  8006ef:	83 c4 10             	add    $0x10,%esp
  8006f2:	eb 16                	jmp    80070a <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006f4:	51                   	push   %ecx
  8006f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f8:	50                   	push   %eax
  8006f9:	e8 f2 fc ff ff       	call   8003f0 <getuint>
  8006fe:	89 c6                	mov    %eax,%esi
  800700:	89 d7                	mov    %edx,%edi
			base = 16;
  800702:	ba 10 00 00 00       	mov    $0x10,%edx
  800707:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800711:	50                   	push   %eax
  800712:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800715:	52                   	push   %edx
  800716:	57                   	push   %edi
  800717:	56                   	push   %esi
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	ff 75 08             	pushl  0x8(%ebp)
  80071e:	e8 2d fc ff ff       	call   800350 <printnum>
			break;
  800723:	83 c4 20             	add    $0x20,%esp
  800726:	e9 4f fd ff ff       	jmp    80047a <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	52                   	push   %edx
  800732:	ff 55 08             	call   *0x8(%ebp)
			break;
  800735:	83 c4 10             	add    $0x10,%esp
  800738:	e9 3d fd ff ff       	jmp    80047a <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 0c             	pushl  0xc(%ebp)
  800743:	6a 25                	push   $0x25
  800745:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800748:	4b                   	dec    %ebx
  800749:	83 c4 10             	add    $0x10,%esp
  80074c:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800750:	0f 84 24 fd ff ff    	je     80047a <vprintfmt+0xc>
  800756:	4b                   	dec    %ebx
  800757:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  80075b:	75 f9                	jne    800756 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  80075d:	e9 18 fd ff ff       	jmp    80047a <vprintfmt+0xc>
		}
	}
}
  800762:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800765:	5b                   	pop    %ebx
  800766:	5e                   	pop    %esi
  800767:	5f                   	pop    %edi
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800770:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800773:	50                   	push   %eax
  800774:	ff 75 10             	pushl  0x10(%ebp)
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	ff 75 08             	pushl  0x8(%ebp)
  80077d:	e8 ec fc ff ff       	call   80046e <vprintfmt>
	va_end(ap);
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  80078a:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  80078d:	8b 0a                	mov    (%edx),%ecx
  80078f:	3b 4a 04             	cmp    0x4(%edx),%ecx
  800792:	73 07                	jae    80079b <sprintputch+0x17>
		*b->buf++ = ch;
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	88 01                	mov    %al,(%ecx)
  800799:	ff 02                	incl   (%edx)
}
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	83 ec 18             	sub    $0x18,%esp
  8007a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007a9:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  8007ac:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  8007b0:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8007b3:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  8007ba:	85 d2                	test   %edx,%edx
  8007bc:	74 04                	je     8007c2 <vsnprintf+0x25>
  8007be:	85 c9                	test   %ecx,%ecx
  8007c0:	7f 07                	jg     8007c9 <vsnprintf+0x2c>
		return -E_INVAL;
  8007c2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007c7:	eb 1d                	jmp    8007e6 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c9:	ff 75 14             	pushl  0x14(%ebp)
  8007cc:	ff 75 10             	pushl  0x10(%ebp)
  8007cf:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  8007d2:	50                   	push   %eax
  8007d3:	68 84 07 80 00       	push   $0x800784
  8007d8:	e8 91 fc ff ff       	call   80046e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007dd:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  8007e0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007e3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  8007e6:	c9                   	leave  
  8007e7:	c3                   	ret    

008007e8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007ee:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f1:	50                   	push   %eax
  8007f2:	ff 75 10             	pushl  0x10(%ebp)
  8007f5:	ff 75 0c             	pushl  0xc(%ebp)
  8007f8:	ff 75 08             	pushl  0x8(%ebp)
  8007fb:	e8 9d ff ff ff       	call   80079d <vsnprintf>
	va_end(ap);

	return rc;
}
  800800:	c9                   	leave  
  800801:	c3                   	ret    
	...

00800804 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800804:	55                   	push   %ebp
  800805:	89 e5                	mov    %esp,%ebp
  800807:	56                   	push   %esi
  800808:	53                   	push   %ebx
  800809:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  80080c:	83 ec 0c             	sub    $0xc,%esp
  80080f:	56                   	push   %esi
  800810:	e8 ef 00 00 00       	call   800904 <strlen>
  char letter;
  int hexnum = 0;
  800815:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80081a:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	89 c2                	mov    %eax,%edx
  800824:	4a                   	dec    %edx
  800825:	0f 88 d0 00 00 00    	js     8008fb <strtoint+0xf7>
    letter = string[cidx];
  80082b:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  80082e:	85 d2                	test   %edx,%edx
  800830:	75 12                	jne    800844 <strtoint+0x40>
      if (letter != '0') {
  800832:	3c 30                	cmp    $0x30,%al
  800834:	0f 84 ba 00 00 00    	je     8008f4 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80083a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80083f:	e9 b9 00 00 00       	jmp    8008fd <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800844:	83 fa 01             	cmp    $0x1,%edx
  800847:	75 12                	jne    80085b <strtoint+0x57>
      if (letter != 'x') {
  800849:	3c 78                	cmp    $0x78,%al
  80084b:	0f 84 a3 00 00 00    	je     8008f4 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800856:	e9 a2 00 00 00       	jmp    8008fd <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  80085b:	0f be c0             	movsbl %al,%eax
  80085e:	83 e8 30             	sub    $0x30,%eax
  800861:	83 f8 36             	cmp    $0x36,%eax
  800864:	0f 87 80 00 00 00    	ja     8008ea <strtoint+0xe6>
  80086a:	ff 24 85 d4 2d 80 00 	jmp    *0x802dd4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  800871:	01 cb                	add    %ecx,%ebx
          break;
  800873:	eb 7c                	jmp    8008f1 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800875:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  800878:	eb 77                	jmp    8008f1 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  80087a:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80087d:	01 c3                	add    %eax,%ebx
          break;
  80087f:	eb 70                	jmp    8008f1 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  800881:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800884:	eb 6b                	jmp    8008f1 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  800886:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800889:	01 c3                	add    %eax,%ebx
          break;
  80088b:	eb 64                	jmp    8008f1 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  80088d:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800890:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800893:	eb 5c                	jmp    8008f1 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800895:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  80089c:	29 c8                	sub    %ecx,%eax
  80089e:	01 c3                	add    %eax,%ebx
          break;
  8008a0:	eb 4f                	jmp    8008f1 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8008a2:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8008a5:	eb 4a                	jmp    8008f1 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8008a7:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8008aa:	01 c3                	add    %eax,%ebx
          break;
  8008ac:	eb 43                	jmp    8008f1 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8008ae:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8008b1:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8008b4:	eb 3b                	jmp    8008f1 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  8008b6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8008b9:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  8008bc:	01 c3                	add    %eax,%ebx
          break;
  8008be:	eb 31                	jmp    8008f1 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  8008c0:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8008c3:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  8008c6:	eb 29                	jmp    8008f1 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  8008c8:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8008cb:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  8008ce:	01 c3                	add    %eax,%ebx
          break;
  8008d0:	eb 1f                	jmp    8008f1 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  8008d2:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8008d9:	29 c8                	sub    %ecx,%eax
  8008db:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8008de:	eb 11                	jmp    8008f1 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  8008e0:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8008e3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8008e6:	01 c3                	add    %eax,%ebx
          break;
  8008e8:	eb 07                	jmp    8008f1 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  8008ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8008ef:	eb 0c                	jmp    8008fd <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  8008f1:	c1 e1 04             	shl    $0x4,%ecx
  8008f4:	4a                   	dec    %edx
  8008f5:	0f 89 30 ff ff ff    	jns    80082b <strtoint+0x27>
    }
  }

  return hexnum;
  8008fb:	89 d8                	mov    %ebx,%eax
}
  8008fd:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800900:	5b                   	pop    %ebx
  800901:	5e                   	pop    %esi
  800902:	c9                   	leave  
  800903:	c3                   	ret    

00800904 <strlen>:





int
strlen(const char *s)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80090a:	b8 00 00 00 00       	mov    $0x0,%eax
  80090f:	80 3a 00             	cmpb   $0x0,(%edx)
  800912:	74 07                	je     80091b <strlen+0x17>
		n++;
  800914:	40                   	inc    %eax
  800915:	42                   	inc    %edx
  800916:	80 3a 00             	cmpb   $0x0,(%edx)
  800919:	75 f9                	jne    800914 <strlen+0x10>
	return n;
}
  80091b:	c9                   	leave  
  80091c:	c3                   	ret    

0080091d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800923:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800926:	b8 00 00 00 00       	mov    $0x0,%eax
  80092b:	85 d2                	test   %edx,%edx
  80092d:	74 0f                	je     80093e <strnlen+0x21>
  80092f:	80 39 00             	cmpb   $0x0,(%ecx)
  800932:	74 0a                	je     80093e <strnlen+0x21>
		n++;
  800934:	40                   	inc    %eax
  800935:	41                   	inc    %ecx
  800936:	4a                   	dec    %edx
  800937:	74 05                	je     80093e <strnlen+0x21>
  800939:	80 39 00             	cmpb   $0x0,(%ecx)
  80093c:	75 f6                	jne    800934 <strnlen+0x17>
	return n;
}
  80093e:	c9                   	leave  
  80093f:	c3                   	ret    

00800940 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	53                   	push   %ebx
  800944:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  80094a:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  80094c:	8a 02                	mov    (%edx),%al
  80094e:	42                   	inc    %edx
  80094f:	88 01                	mov    %al,(%ecx)
  800951:	41                   	inc    %ecx
  800952:	84 c0                	test   %al,%al
  800954:	75 f6                	jne    80094c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800956:	89 d8                	mov    %ebx,%eax
  800958:	5b                   	pop    %ebx
  800959:	c9                   	leave  
  80095a:	c3                   	ret    

0080095b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	57                   	push   %edi
  80095f:	56                   	push   %esi
  800960:	53                   	push   %ebx
  800961:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800964:	8b 55 0c             	mov    0xc(%ebp),%edx
  800967:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  80096a:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  80096c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800971:	39 f3                	cmp    %esi,%ebx
  800973:	73 10                	jae    800985 <strncpy+0x2a>
		*dst++ = *src;
  800975:	8a 02                	mov    (%edx),%al
  800977:	88 01                	mov    %al,(%ecx)
  800979:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80097a:	80 3a 01             	cmpb   $0x1,(%edx)
  80097d:	83 da ff             	sbb    $0xffffffff,%edx
  800980:	43                   	inc    %ebx
  800981:	39 f3                	cmp    %esi,%ebx
  800983:	72 f0                	jb     800975 <strncpy+0x1a>
	}
	return ret;
}
  800985:	89 f8                	mov    %edi,%eax
  800987:	5b                   	pop    %ebx
  800988:	5e                   	pop    %esi
  800989:	5f                   	pop    %edi
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    

0080098c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	56                   	push   %esi
  800990:	53                   	push   %ebx
  800991:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800994:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800997:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  80099a:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  80099c:	85 d2                	test   %edx,%edx
  80099e:	74 19                	je     8009b9 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009a0:	4a                   	dec    %edx
  8009a1:	74 13                	je     8009b6 <strlcpy+0x2a>
  8009a3:	80 39 00             	cmpb   $0x0,(%ecx)
  8009a6:	74 0e                	je     8009b6 <strlcpy+0x2a>
  8009a8:	8a 01                	mov    (%ecx),%al
  8009aa:	41                   	inc    %ecx
  8009ab:	88 03                	mov    %al,(%ebx)
  8009ad:	43                   	inc    %ebx
  8009ae:	4a                   	dec    %edx
  8009af:	74 05                	je     8009b6 <strlcpy+0x2a>
  8009b1:	80 39 00             	cmpb   $0x0,(%ecx)
  8009b4:	75 f2                	jne    8009a8 <strlcpy+0x1c>
		*dst = '\0';
  8009b6:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  8009b9:	89 d8                	mov    %ebx,%eax
  8009bb:	29 f0                	sub    %esi,%eax
}
  8009bd:	5b                   	pop    %ebx
  8009be:	5e                   	pop    %esi
  8009bf:	c9                   	leave  
  8009c0:	c3                   	ret    

008009c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009c1:	55                   	push   %ebp
  8009c2:	89 e5                	mov    %esp,%ebp
  8009c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  8009ca:	80 3a 00             	cmpb   $0x0,(%edx)
  8009cd:	74 13                	je     8009e2 <strcmp+0x21>
  8009cf:	8a 02                	mov    (%edx),%al
  8009d1:	3a 01                	cmp    (%ecx),%al
  8009d3:	75 0d                	jne    8009e2 <strcmp+0x21>
  8009d5:	42                   	inc    %edx
  8009d6:	41                   	inc    %ecx
  8009d7:	80 3a 00             	cmpb   $0x0,(%edx)
  8009da:	74 06                	je     8009e2 <strcmp+0x21>
  8009dc:	8a 02                	mov    (%edx),%al
  8009de:	3a 01                	cmp    (%ecx),%al
  8009e0:	74 f3                	je     8009d5 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e2:	0f b6 02             	movzbl (%edx),%eax
  8009e5:	0f b6 11             	movzbl (%ecx),%edx
  8009e8:	29 d0                	sub    %edx,%eax
}
  8009ea:	c9                   	leave  
  8009eb:	c3                   	ret    

008009ec <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	53                   	push   %ebx
  8009f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  8009f9:	85 c9                	test   %ecx,%ecx
  8009fb:	74 1f                	je     800a1c <strncmp+0x30>
  8009fd:	80 3a 00             	cmpb   $0x0,(%edx)
  800a00:	74 16                	je     800a18 <strncmp+0x2c>
  800a02:	8a 02                	mov    (%edx),%al
  800a04:	3a 03                	cmp    (%ebx),%al
  800a06:	75 10                	jne    800a18 <strncmp+0x2c>
  800a08:	42                   	inc    %edx
  800a09:	43                   	inc    %ebx
  800a0a:	49                   	dec    %ecx
  800a0b:	74 0f                	je     800a1c <strncmp+0x30>
  800a0d:	80 3a 00             	cmpb   $0x0,(%edx)
  800a10:	74 06                	je     800a18 <strncmp+0x2c>
  800a12:	8a 02                	mov    (%edx),%al
  800a14:	3a 03                	cmp    (%ebx),%al
  800a16:	74 f0                	je     800a08 <strncmp+0x1c>
	if (n == 0)
  800a18:	85 c9                	test   %ecx,%ecx
  800a1a:	75 07                	jne    800a23 <strncmp+0x37>
		return 0;
  800a1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a21:	eb 0a                	jmp    800a2d <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a23:	0f b6 12             	movzbl (%edx),%edx
  800a26:	0f b6 03             	movzbl (%ebx),%eax
  800a29:	29 c2                	sub    %eax,%edx
  800a2b:	89 d0                	mov    %edx,%eax
}
  800a2d:	5b                   	pop    %ebx
  800a2e:	c9                   	leave  
  800a2f:	c3                   	ret    

00800a30 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800a39:	80 38 00             	cmpb   $0x0,(%eax)
  800a3c:	74 0a                	je     800a48 <strchr+0x18>
		if (*s == c)
  800a3e:	38 10                	cmp    %dl,(%eax)
  800a40:	74 0b                	je     800a4d <strchr+0x1d>
  800a42:	40                   	inc    %eax
  800a43:	80 38 00             	cmpb   $0x0,(%eax)
  800a46:	75 f6                	jne    800a3e <strchr+0xe>
			return (char *) s;
	return 0;
  800a48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800a58:	80 38 00             	cmpb   $0x0,(%eax)
  800a5b:	74 0a                	je     800a67 <strfind+0x18>
		if (*s == c)
  800a5d:	38 10                	cmp    %dl,(%eax)
  800a5f:	74 06                	je     800a67 <strfind+0x18>
  800a61:	40                   	inc    %eax
  800a62:	80 38 00             	cmpb   $0x0,(%eax)
  800a65:	75 f6                	jne    800a5d <strfind+0xe>
			break;
	return (char *) s;
}
  800a67:	c9                   	leave  
  800a68:	c3                   	ret    

00800a69 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	57                   	push   %edi
  800a6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a70:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800a73:	89 f8                	mov    %edi,%eax
  800a75:	85 c9                	test   %ecx,%ecx
  800a77:	74 40                	je     800ab9 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800a79:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a7f:	75 30                	jne    800ab1 <memset+0x48>
  800a81:	f6 c1 03             	test   $0x3,%cl
  800a84:	75 2b                	jne    800ab1 <memset+0x48>
		c &= 0xFF;
  800a86:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a90:	c1 e0 18             	shl    $0x18,%eax
  800a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a96:	c1 e2 10             	shl    $0x10,%edx
  800a99:	09 d0                	or     %edx,%eax
  800a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9e:	c1 e2 08             	shl    $0x8,%edx
  800aa1:	09 d0                	or     %edx,%eax
  800aa3:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800aa6:	c1 e9 02             	shr    $0x2,%ecx
  800aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aac:	fc                   	cld    
  800aad:	f3 ab                	repz stos %eax,%es:(%edi)
  800aaf:	eb 06                	jmp    800ab7 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab4:	fc                   	cld    
  800ab5:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800ab7:	89 f8                	mov    %edi,%eax
}
  800ab9:	5f                   	pop    %edi
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	57                   	push   %edi
  800ac0:	56                   	push   %esi
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800ac7:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800aca:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800acc:	39 c6                	cmp    %eax,%esi
  800ace:	73 33                	jae    800b03 <memmove+0x47>
  800ad0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad3:	39 c2                	cmp    %eax,%edx
  800ad5:	76 2c                	jbe    800b03 <memmove+0x47>
		s += n;
  800ad7:	89 d6                	mov    %edx,%esi
		d += n;
  800ad9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800adc:	f6 c2 03             	test   $0x3,%dl
  800adf:	75 1b                	jne    800afc <memmove+0x40>
  800ae1:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ae7:	75 13                	jne    800afc <memmove+0x40>
  800ae9:	f6 c1 03             	test   $0x3,%cl
  800aec:	75 0e                	jne    800afc <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800aee:	83 ef 04             	sub    $0x4,%edi
  800af1:	83 ee 04             	sub    $0x4,%esi
  800af4:	c1 e9 02             	shr    $0x2,%ecx
  800af7:	fd                   	std    
  800af8:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800afa:	eb 27                	jmp    800b23 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800afc:	4f                   	dec    %edi
  800afd:	4e                   	dec    %esi
  800afe:	fd                   	std    
  800aff:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800b01:	eb 20                	jmp    800b23 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b03:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b09:	75 15                	jne    800b20 <memmove+0x64>
  800b0b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b11:	75 0d                	jne    800b20 <memmove+0x64>
  800b13:	f6 c1 03             	test   $0x3,%cl
  800b16:	75 08                	jne    800b20 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800b18:	c1 e9 02             	shr    $0x2,%ecx
  800b1b:	fc                   	cld    
  800b1c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800b1e:	eb 03                	jmp    800b23 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b20:	fc                   	cld    
  800b21:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b23:	5e                   	pop    %esi
  800b24:	5f                   	pop    %edi
  800b25:	c9                   	leave  
  800b26:	c3                   	ret    

00800b27 <memcpy>:

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
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b2a:	ff 75 10             	pushl  0x10(%ebp)
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	ff 75 08             	pushl  0x8(%ebp)
  800b33:	e8 84 ff ff ff       	call   800abc <memmove>
}
  800b38:	c9                   	leave  
  800b39:	c3                   	ret    

00800b3a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800b3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800b41:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b44:	8b 55 10             	mov    0x10(%ebp),%edx
  800b47:	4a                   	dec    %edx
  800b48:	83 fa ff             	cmp    $0xffffffff,%edx
  800b4b:	74 1a                	je     800b67 <memcmp+0x2d>
  800b4d:	8a 01                	mov    (%ecx),%al
  800b4f:	3a 03                	cmp    (%ebx),%al
  800b51:	74 0c                	je     800b5f <memcmp+0x25>
  800b53:	0f b6 d0             	movzbl %al,%edx
  800b56:	0f b6 03             	movzbl (%ebx),%eax
  800b59:	29 c2                	sub    %eax,%edx
  800b5b:	89 d0                	mov    %edx,%eax
  800b5d:	eb 0d                	jmp    800b6c <memcmp+0x32>
  800b5f:	41                   	inc    %ecx
  800b60:	43                   	inc    %ebx
  800b61:	4a                   	dec    %edx
  800b62:	83 fa ff             	cmp    $0xffffffff,%edx
  800b65:	75 e6                	jne    800b4d <memcmp+0x13>
	}

	return 0;
  800b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b6c:	5b                   	pop    %ebx
  800b6d:	c9                   	leave  
  800b6e:	c3                   	ret    

00800b6f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b78:	89 c2                	mov    %eax,%edx
  800b7a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7d:	39 d0                	cmp    %edx,%eax
  800b7f:	73 09                	jae    800b8a <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b81:	38 08                	cmp    %cl,(%eax)
  800b83:	74 05                	je     800b8a <memfind+0x1b>
  800b85:	40                   	inc    %eax
  800b86:	39 d0                	cmp    %edx,%eax
  800b88:	72 f7                	jb     800b81 <memfind+0x12>
			break;
	return (void *) s;
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	57                   	push   %edi
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
  800b92:	8b 55 08             	mov    0x8(%ebp),%edx
  800b95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b98:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800b9b:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800ba0:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800ba5:	80 3a 20             	cmpb   $0x20,(%edx)
  800ba8:	74 05                	je     800baf <strtol+0x23>
  800baa:	80 3a 09             	cmpb   $0x9,(%edx)
  800bad:	75 0b                	jne    800bba <strtol+0x2e>
  800baf:	42                   	inc    %edx
  800bb0:	80 3a 20             	cmpb   $0x20,(%edx)
  800bb3:	74 fa                	je     800baf <strtol+0x23>
  800bb5:	80 3a 09             	cmpb   $0x9,(%edx)
  800bb8:	74 f5                	je     800baf <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800bba:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800bbd:	75 03                	jne    800bc2 <strtol+0x36>
		s++;
  800bbf:	42                   	inc    %edx
  800bc0:	eb 0b                	jmp    800bcd <strtol+0x41>
	else if (*s == '-')
  800bc2:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800bc5:	75 06                	jne    800bcd <strtol+0x41>
		s++, neg = 1;
  800bc7:	42                   	inc    %edx
  800bc8:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bcd:	85 c9                	test   %ecx,%ecx
  800bcf:	74 05                	je     800bd6 <strtol+0x4a>
  800bd1:	83 f9 10             	cmp    $0x10,%ecx
  800bd4:	75 15                	jne    800beb <strtol+0x5f>
  800bd6:	80 3a 30             	cmpb   $0x30,(%edx)
  800bd9:	75 10                	jne    800beb <strtol+0x5f>
  800bdb:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bdf:	75 0a                	jne    800beb <strtol+0x5f>
		s += 2, base = 16;
  800be1:	83 c2 02             	add    $0x2,%edx
  800be4:	b9 10 00 00 00       	mov    $0x10,%ecx
  800be9:	eb 14                	jmp    800bff <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800beb:	85 c9                	test   %ecx,%ecx
  800bed:	75 10                	jne    800bff <strtol+0x73>
  800bef:	80 3a 30             	cmpb   $0x30,(%edx)
  800bf2:	75 05                	jne    800bf9 <strtol+0x6d>
		s++, base = 8;
  800bf4:	42                   	inc    %edx
  800bf5:	b1 08                	mov    $0x8,%cl
  800bf7:	eb 06                	jmp    800bff <strtol+0x73>
	else if (base == 0)
  800bf9:	85 c9                	test   %ecx,%ecx
  800bfb:	75 02                	jne    800bff <strtol+0x73>
		base = 10;
  800bfd:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bff:	8a 02                	mov    (%edx),%al
  800c01:	83 e8 30             	sub    $0x30,%eax
  800c04:	3c 09                	cmp    $0x9,%al
  800c06:	77 08                	ja     800c10 <strtol+0x84>
			dig = *s - '0';
  800c08:	0f be 02             	movsbl (%edx),%eax
  800c0b:	83 e8 30             	sub    $0x30,%eax
  800c0e:	eb 20                	jmp    800c30 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800c10:	8a 02                	mov    (%edx),%al
  800c12:	83 e8 61             	sub    $0x61,%eax
  800c15:	3c 19                	cmp    $0x19,%al
  800c17:	77 08                	ja     800c21 <strtol+0x95>
			dig = *s - 'a' + 10;
  800c19:	0f be 02             	movsbl (%edx),%eax
  800c1c:	83 e8 57             	sub    $0x57,%eax
  800c1f:	eb 0f                	jmp    800c30 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800c21:	8a 02                	mov    (%edx),%al
  800c23:	83 e8 41             	sub    $0x41,%eax
  800c26:	3c 19                	cmp    $0x19,%al
  800c28:	77 12                	ja     800c3c <strtol+0xb0>
			dig = *s - 'A' + 10;
  800c2a:	0f be 02             	movsbl (%edx),%eax
  800c2d:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800c30:	39 c8                	cmp    %ecx,%eax
  800c32:	7d 08                	jge    800c3c <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800c34:	42                   	inc    %edx
  800c35:	0f af d9             	imul   %ecx,%ebx
  800c38:	01 c3                	add    %eax,%ebx
  800c3a:	eb c3                	jmp    800bff <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c3c:	85 f6                	test   %esi,%esi
  800c3e:	74 02                	je     800c42 <strtol+0xb6>
		*endptr = (char *) s;
  800c40:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c42:	89 d8                	mov    %ebx,%eax
  800c44:	85 ff                	test   %edi,%edi
  800c46:	74 02                	je     800c4a <strtol+0xbe>
  800c48:	f7 d8                	neg    %eax
}
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    
	...

00800c50 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	57                   	push   %edi
  800c54:	56                   	push   %esi
  800c55:	53                   	push   %ebx
  800c56:	83 ec 04             	sub    $0x4,%esp
  800c59:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c5f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c64:	89 f8                	mov    %edi,%eax
  800c66:	89 fb                	mov    %edi,%ebx
  800c68:	89 fe                	mov    %edi,%esi
  800c6a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c6c:	83 c4 04             	add    $0x4,%esp
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
  800c7a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c7f:	bf 00 00 00 00       	mov    $0x0,%edi
  800c84:	89 fa                	mov    %edi,%edx
  800c86:	89 f9                	mov    %edi,%ecx
  800c88:	89 fb                	mov    %edi,%ebx
  800c8a:	89 fe                	mov    %edi,%esi
  800c8c:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5f                   	pop    %edi
  800c91:	c9                   	leave  
  800c92:	c3                   	ret    

00800c93 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	83 ec 0c             	sub    $0xc,%esp
  800c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9f:	b8 03 00 00 00       	mov    $0x3,%eax
  800ca4:	bf 00 00 00 00       	mov    $0x0,%edi
  800ca9:	89 f9                	mov    %edi,%ecx
  800cab:	89 fb                	mov    %edi,%ebx
  800cad:	89 fe                	mov    %edi,%esi
  800caf:	cd 30                	int    $0x30
  800cb1:	85 c0                	test   %eax,%eax
  800cb3:	7e 17                	jle    800ccc <sys_env_destroy+0x39>
  800cb5:	83 ec 0c             	sub    $0xc,%esp
  800cb8:	50                   	push   %eax
  800cb9:	6a 03                	push   $0x3
  800cbb:	68 b0 2e 80 00       	push   $0x802eb0
  800cc0:	6a 23                	push   $0x23
  800cc2:	68 cd 2e 80 00       	push   $0x802ecd
  800cc7:	e8 80 f5 ff ff       	call   80024c <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ccc:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
  800cda:	b8 02 00 00 00       	mov    $0x2,%eax
  800cdf:	bf 00 00 00 00       	mov    $0x0,%edi
  800ce4:	89 fa                	mov    %edi,%edx
  800ce6:	89 f9                	mov    %edi,%ecx
  800ce8:	89 fb                	mov    %edi,%ebx
  800cea:	89 fe                	mov    %edi,%esi
  800cec:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <sys_yield>:

void
sys_yield(void)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cfe:	bf 00 00 00 00       	mov    $0x0,%edi
  800d03:	89 fa                	mov    %edi,%edx
  800d05:	89 f9                	mov    %edi,%ecx
  800d07:	89 fb                	mov    %edi,%ebx
  800d09:	89 fe                	mov    %edi,%esi
  800d0b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	c9                   	leave  
  800d11:	c3                   	ret    

00800d12 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	57                   	push   %edi
  800d16:	56                   	push   %esi
  800d17:	53                   	push   %ebx
  800d18:	83 ec 0c             	sub    $0xc,%esp
  800d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d21:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d24:	b8 04 00 00 00       	mov    $0x4,%eax
  800d29:	bf 00 00 00 00       	mov    $0x0,%edi
  800d2e:	89 fe                	mov    %edi,%esi
  800d30:	cd 30                	int    $0x30
  800d32:	85 c0                	test   %eax,%eax
  800d34:	7e 17                	jle    800d4d <sys_page_alloc+0x3b>
  800d36:	83 ec 0c             	sub    $0xc,%esp
  800d39:	50                   	push   %eax
  800d3a:	6a 04                	push   $0x4
  800d3c:	68 b0 2e 80 00       	push   $0x802eb0
  800d41:	6a 23                	push   $0x23
  800d43:	68 cd 2e 80 00       	push   $0x802ecd
  800d48:	e8 ff f4 ff ff       	call   80024c <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
  800d5b:	83 ec 0c             	sub    $0xc,%esp
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d67:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d6a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d6d:	b8 05 00 00 00       	mov    $0x5,%eax
  800d72:	cd 30                	int    $0x30
  800d74:	85 c0                	test   %eax,%eax
  800d76:	7e 17                	jle    800d8f <sys_page_map+0x3a>
  800d78:	83 ec 0c             	sub    $0xc,%esp
  800d7b:	50                   	push   %eax
  800d7c:	6a 05                	push   $0x5
  800d7e:	68 b0 2e 80 00       	push   $0x802eb0
  800d83:	6a 23                	push   $0x23
  800d85:	68 cd 2e 80 00       	push   $0x802ecd
  800d8a:	e8 bd f4 ff ff       	call   80024c <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d8f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d92:	5b                   	pop    %ebx
  800d93:	5e                   	pop    %esi
  800d94:	5f                   	pop    %edi
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 0c             	sub    $0xc,%esp
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da6:	b8 06 00 00 00       	mov    $0x6,%eax
  800dab:	bf 00 00 00 00       	mov    $0x0,%edi
  800db0:	89 fb                	mov    %edi,%ebx
  800db2:	89 fe                	mov    %edi,%esi
  800db4:	cd 30                	int    $0x30
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7e 17                	jle    800dd1 <sys_page_unmap+0x3a>
  800dba:	83 ec 0c             	sub    $0xc,%esp
  800dbd:	50                   	push   %eax
  800dbe:	6a 06                	push   $0x6
  800dc0:	68 b0 2e 80 00       	push   $0x802eb0
  800dc5:	6a 23                	push   $0x23
  800dc7:	68 cd 2e 80 00       	push   $0x802ecd
  800dcc:	e8 7b f4 ff ff       	call   80024c <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd1:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	c9                   	leave  
  800dd8:	c3                   	ret    

00800dd9 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 0c             	sub    $0xc,%esp
  800de2:	8b 55 08             	mov    0x8(%ebp),%edx
  800de5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ded:	bf 00 00 00 00       	mov    $0x0,%edi
  800df2:	89 fb                	mov    %edi,%ebx
  800df4:	89 fe                	mov    %edi,%esi
  800df6:	cd 30                	int    $0x30
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	7e 17                	jle    800e13 <sys_env_set_status+0x3a>
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	50                   	push   %eax
  800e00:	6a 08                	push   $0x8
  800e02:	68 b0 2e 80 00       	push   $0x802eb0
  800e07:	6a 23                	push   $0x23
  800e09:	68 cd 2e 80 00       	push   $0x802ecd
  800e0e:	e8 39 f4 ff ff       	call   80024c <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e13:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800e34:	89 fb                	mov    %edi,%ebx
  800e36:	89 fe                	mov    %edi,%esi
  800e38:	cd 30                	int    $0x30
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	7e 17                	jle    800e55 <sys_env_set_trapframe+0x3a>
  800e3e:	83 ec 0c             	sub    $0xc,%esp
  800e41:	50                   	push   %eax
  800e42:	6a 09                	push   $0x9
  800e44:	68 b0 2e 80 00       	push   $0x802eb0
  800e49:	6a 23                	push   $0x23
  800e4b:	68 cd 2e 80 00       	push   $0x802ecd
  800e50:	e8 f7 f3 ff ff       	call   80024c <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e55:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e58:	5b                   	pop    %ebx
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
  800e63:	83 ec 0c             	sub    $0xc,%esp
  800e66:	8b 55 08             	mov    0x8(%ebp),%edx
  800e69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e71:	bf 00 00 00 00       	mov    $0x0,%edi
  800e76:	89 fb                	mov    %edi,%ebx
  800e78:	89 fe                	mov    %edi,%esi
  800e7a:	cd 30                	int    $0x30
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	7e 17                	jle    800e97 <sys_env_set_pgfault_upcall+0x3a>
  800e80:	83 ec 0c             	sub    $0xc,%esp
  800e83:	50                   	push   %eax
  800e84:	6a 0a                	push   $0xa
  800e86:	68 b0 2e 80 00       	push   $0x802eb0
  800e8b:	6a 23                	push   $0x23
  800e8d:	68 cd 2e 80 00       	push   $0x802ecd
  800e92:	e8 b5 f3 ff ff       	call   80024c <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e97:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e9a:	5b                   	pop    %ebx
  800e9b:	5e                   	pop    %esi
  800e9c:	5f                   	pop    %edi
  800e9d:	c9                   	leave  
  800e9e:	c3                   	ret    

00800e9f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e9f:	55                   	push   %ebp
  800ea0:	89 e5                	mov    %esp,%ebp
  800ea2:	57                   	push   %edi
  800ea3:	56                   	push   %esi
  800ea4:	53                   	push   %ebx
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb6:	be 00 00 00 00       	mov    $0x0,%esi
  800ebb:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ebd:	5b                   	pop    %ebx
  800ebe:	5e                   	pop    %esi
  800ebf:	5f                   	pop    %edi
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	57                   	push   %edi
  800ec6:	56                   	push   %esi
  800ec7:	53                   	push   %ebx
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ece:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ed3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ed8:	89 f9                	mov    %edi,%ecx
  800eda:	89 fb                	mov    %edi,%ebx
  800edc:	89 fe                	mov    %edi,%esi
  800ede:	cd 30                	int    $0x30
  800ee0:	85 c0                	test   %eax,%eax
  800ee2:	7e 17                	jle    800efb <sys_ipc_recv+0x39>
  800ee4:	83 ec 0c             	sub    $0xc,%esp
  800ee7:	50                   	push   %eax
  800ee8:	6a 0d                	push   $0xd
  800eea:	68 b0 2e 80 00       	push   $0x802eb0
  800eef:	6a 23                	push   $0x23
  800ef1:	68 cd 2e 80 00       	push   $0x802ecd
  800ef6:	e8 51 f3 ff ff       	call   80024c <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800efb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	c9                   	leave  
  800f02:	c3                   	ret    

00800f03 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f12:	b8 10 00 00 00       	mov    $0x10,%eax
  800f17:	bf 00 00 00 00       	mov    $0x0,%edi
  800f1c:	89 fb                	mov    %edi,%ebx
  800f1e:	89 fe                	mov    %edi,%esi
  800f20:	cd 30                	int    $0x30
  800f22:	85 c0                	test   %eax,%eax
  800f24:	7e 17                	jle    800f3d <sys_transmit_packet+0x3a>
  800f26:	83 ec 0c             	sub    $0xc,%esp
  800f29:	50                   	push   %eax
  800f2a:	6a 10                	push   $0x10
  800f2c:	68 b0 2e 80 00       	push   $0x802eb0
  800f31:	6a 23                	push   $0x23
  800f33:	68 cd 2e 80 00       	push   $0x802ecd
  800f38:	e8 0f f3 ff ff       	call   80024c <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800f3d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	c9                   	leave  
  800f44:	c3                   	ret    

00800f45 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800f45:	55                   	push   %ebp
  800f46:	89 e5                	mov    %esp,%ebp
  800f48:	57                   	push   %edi
  800f49:	56                   	push   %esi
  800f4a:	53                   	push   %ebx
  800f4b:	83 ec 0c             	sub    $0xc,%esp
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f54:	b8 11 00 00 00       	mov    $0x11,%eax
  800f59:	bf 00 00 00 00       	mov    $0x0,%edi
  800f5e:	89 fb                	mov    %edi,%ebx
  800f60:	89 fe                	mov    %edi,%esi
  800f62:	cd 30                	int    $0x30
  800f64:	85 c0                	test   %eax,%eax
  800f66:	7e 17                	jle    800f7f <sys_receive_packet+0x3a>
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	50                   	push   %eax
  800f6c:	6a 11                	push   $0x11
  800f6e:	68 b0 2e 80 00       	push   $0x802eb0
  800f73:	6a 23                	push   $0x23
  800f75:	68 cd 2e 80 00       	push   $0x802ecd
  800f7a:	e8 cd f2 ff ff       	call   80024c <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800f7f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	c9                   	leave  
  800f86:	c3                   	ret    

00800f87 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
  800f8d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f92:	bf 00 00 00 00       	mov    $0x0,%edi
  800f97:	89 fa                	mov    %edi,%edx
  800f99:	89 f9                	mov    %edi,%ecx
  800f9b:	89 fb                	mov    %edi,%ebx
  800f9d:	89 fe                	mov    %edi,%esi
  800f9f:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	c9                   	leave  
  800fa5:	c3                   	ret    

00800fa6 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
  800fac:	83 ec 0c             	sub    $0xc,%esp
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fb7:	bf 00 00 00 00       	mov    $0x0,%edi
  800fbc:	89 f9                	mov    %edi,%ecx
  800fbe:	89 fb                	mov    %edi,%ebx
  800fc0:	89 fe                	mov    %edi,%esi
  800fc2:	cd 30                	int    $0x30
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	7e 17                	jle    800fdf <sys_map_receive_buffers+0x39>
  800fc8:	83 ec 0c             	sub    $0xc,%esp
  800fcb:	50                   	push   %eax
  800fcc:	6a 0e                	push   $0xe
  800fce:	68 b0 2e 80 00       	push   $0x802eb0
  800fd3:	6a 23                	push   $0x23
  800fd5:	68 cd 2e 80 00       	push   $0x802ecd
  800fda:	e8 6d f2 ff ff       	call   80024c <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  800fdf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fe2:	5b                   	pop    %ebx
  800fe3:	5e                   	pop    %esi
  800fe4:	5f                   	pop    %edi
  800fe5:	c9                   	leave  
  800fe6:	c3                   	ret    

00800fe7 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	57                   	push   %edi
  800feb:	56                   	push   %esi
  800fec:	53                   	push   %ebx
  800fed:	83 ec 0c             	sub    $0xc,%esp
  800ff0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff3:	b8 12 00 00 00       	mov    $0x12,%eax
  800ff8:	bf 00 00 00 00       	mov    $0x0,%edi
  800ffd:	89 f9                	mov    %edi,%ecx
  800fff:	89 fb                	mov    %edi,%ebx
  801001:	89 fe                	mov    %edi,%esi
  801003:	cd 30                	int    $0x30
  801005:	85 c0                	test   %eax,%eax
  801007:	7e 17                	jle    801020 <sys_receive_packet_zerocopy+0x39>
  801009:	83 ec 0c             	sub    $0xc,%esp
  80100c:	50                   	push   %eax
  80100d:	6a 12                	push   $0x12
  80100f:	68 b0 2e 80 00       	push   $0x802eb0
  801014:	6a 23                	push   $0x23
  801016:	68 cd 2e 80 00       	push   $0x802ecd
  80101b:	e8 2c f2 ff ff       	call   80024c <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  801020:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801023:	5b                   	pop    %ebx
  801024:	5e                   	pop    %esi
  801025:	5f                   	pop    %edi
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	57                   	push   %edi
  80102c:	56                   	push   %esi
  80102d:	53                   	push   %ebx
  80102e:	83 ec 0c             	sub    $0xc,%esp
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801037:	b8 13 00 00 00       	mov    $0x13,%eax
  80103c:	bf 00 00 00 00       	mov    $0x0,%edi
  801041:	89 fb                	mov    %edi,%ebx
  801043:	89 fe                	mov    %edi,%esi
  801045:	cd 30                	int    $0x30
  801047:	85 c0                	test   %eax,%eax
  801049:	7e 17                	jle    801062 <sys_env_set_priority+0x3a>
  80104b:	83 ec 0c             	sub    $0xc,%esp
  80104e:	50                   	push   %eax
  80104f:	6a 13                	push   $0x13
  801051:	68 b0 2e 80 00       	push   $0x802eb0
  801056:	6a 23                	push   $0x23
  801058:	68 cd 2e 80 00       	push   $0x802ecd
  80105d:	e8 ea f1 ff ff       	call   80024c <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  801062:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5f                   	pop    %edi
  801068:	c9                   	leave  
  801069:	c3                   	ret    
	...

0080106c <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	53                   	push   %ebx
  801070:	83 ec 04             	sub    $0x4,%esp
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801076:	8b 18                	mov    (%eax),%ebx
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
  801078:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80107c:	74 11                	je     80108f <pgfault+0x23>
  80107e:	89 d8                	mov    %ebx,%eax
  801080:	c1 e8 0c             	shr    $0xc,%eax
  801083:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80108a:	f6 c4 08             	test   $0x8,%ah
  80108d:	75 14                	jne    8010a3 <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  80108f:	83 ec 04             	sub    $0x4,%esp
  801092:	68 dc 2e 80 00       	push   $0x802edc
  801097:	6a 1e                	push   $0x1e
  801099:	68 30 2f 80 00       	push   $0x802f30
  80109e:	e8 a9 f1 ff ff       	call   80024c <_panic>
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
  8010a3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  8010a9:	83 ec 04             	sub    $0x4,%esp
  8010ac:	6a 07                	push   $0x7
  8010ae:	68 00 f0 7f 00       	push   $0x7ff000
  8010b3:	83 ec 04             	sub    $0x4,%esp
  8010b6:	e8 19 fc ff ff       	call   800cd4 <sys_getenvid>
  8010bb:	89 04 24             	mov    %eax,(%esp)
  8010be:	e8 4f fc ff ff       	call   800d12 <sys_page_alloc>
  8010c3:	83 c4 10             	add    $0x10,%esp
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	79 12                	jns    8010dc <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  8010ca:	50                   	push   %eax
  8010cb:	68 3b 2f 80 00       	push   $0x802f3b
  8010d0:	6a 2d                	push   $0x2d
  8010d2:	68 30 2f 80 00       	push   $0x802f30
  8010d7:	e8 70 f1 ff ff       	call   80024c <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  8010dc:	83 ec 04             	sub    $0x4,%esp
  8010df:	68 00 10 00 00       	push   $0x1000
  8010e4:	53                   	push   %ebx
  8010e5:	68 00 f0 7f 00       	push   $0x7ff000
  8010ea:	e8 cd f9 ff ff       	call   800abc <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  8010ef:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8010f6:	53                   	push   %ebx
  8010f7:	83 ec 0c             	sub    $0xc,%esp
  8010fa:	e8 d5 fb ff ff       	call   800cd4 <sys_getenvid>
  8010ff:	83 c4 0c             	add    $0xc,%esp
  801102:	50                   	push   %eax
  801103:	68 00 f0 7f 00       	push   $0x7ff000
  801108:	83 ec 04             	sub    $0x4,%esp
  80110b:	e8 c4 fb ff ff       	call   800cd4 <sys_getenvid>
  801110:	89 04 24             	mov    %eax,(%esp)
  801113:	e8 3d fc ff ff       	call   800d55 <sys_page_map>
  801118:	83 c4 20             	add    $0x20,%esp
  80111b:	85 c0                	test   %eax,%eax
  80111d:	79 12                	jns    801131 <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  80111f:	50                   	push   %eax
  801120:	68 56 2f 80 00       	push   $0x802f56
  801125:	6a 33                	push   $0x33
  801127:	68 30 2f 80 00       	push   $0x802f30
  80112c:	e8 1b f1 ff ff       	call   80024c <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  801131:	83 ec 08             	sub    $0x8,%esp
  801134:	68 00 f0 7f 00       	push   $0x7ff000
  801139:	83 ec 04             	sub    $0x4,%esp
  80113c:	e8 93 fb ff ff       	call   800cd4 <sys_getenvid>
  801141:	89 04 24             	mov    %eax,(%esp)
  801144:	e8 4e fc ff ff       	call   800d97 <sys_page_unmap>
  801149:	83 c4 10             	add    $0x10,%esp
  80114c:	85 c0                	test   %eax,%eax
  80114e:	79 12                	jns    801162 <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  801150:	50                   	push   %eax
  801151:	68 6f 2f 80 00       	push   $0x802f6f
  801156:	6a 36                	push   $0x36
  801158:	68 30 2f 80 00       	push   $0x802f30
  80115d:	e8 ea f0 ff ff       	call   80024c <_panic>
        }

	//panic("pgfault not implemented");
}
  801162:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801165:	c9                   	leave  
  801166:	c3                   	ret    

00801167 <duppage>:

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
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	53                   	push   %ebx
  80116b:	83 ec 04             	sub    $0x4,%esp
  80116e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801171:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  801174:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  801179:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  80117c:	f6 c4 04             	test   $0x4,%ah
  80117f:	74 36                	je     8011b7 <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  801181:	83 ec 0c             	sub    $0xc,%esp
  801184:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801187:	25 07 0e 00 00       	and    $0xe07,%eax
  80118c:	50                   	push   %eax
  80118d:	89 d8                	mov    %ebx,%eax
  80118f:	c1 e0 0c             	shl    $0xc,%eax
  801192:	50                   	push   %eax
  801193:	51                   	push   %ecx
  801194:	50                   	push   %eax
  801195:	83 ec 04             	sub    $0x4,%esp
  801198:	e8 37 fb ff ff       	call   800cd4 <sys_getenvid>
  80119d:	89 04 24             	mov    %eax,(%esp)
  8011a0:	e8 b0 fb ff ff       	call   800d55 <sys_page_map>
  8011a5:	83 c4 20             	add    $0x20,%esp
            return r;
  8011a8:	89 c2                	mov    %eax,%edx
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	0f 88 c9 00 00 00    	js     80127b <duppage+0x114>
  8011b2:	e9 bf 00 00 00       	jmp    801276 <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  8011b7:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  8011be:	a9 02 08 00 00       	test   $0x802,%eax
  8011c3:	74 7b                	je     801240 <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  8011c5:	83 ec 0c             	sub    $0xc,%esp
  8011c8:	68 05 08 00 00       	push   $0x805
  8011cd:	89 d8                	mov    %ebx,%eax
  8011cf:	c1 e0 0c             	shl    $0xc,%eax
  8011d2:	50                   	push   %eax
  8011d3:	51                   	push   %ecx
  8011d4:	50                   	push   %eax
  8011d5:	83 ec 04             	sub    $0x4,%esp
  8011d8:	e8 f7 fa ff ff       	call   800cd4 <sys_getenvid>
  8011dd:	89 04 24             	mov    %eax,(%esp)
  8011e0:	e8 70 fb ff ff       	call   800d55 <sys_page_map>
  8011e5:	83 c4 20             	add    $0x20,%esp
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	79 12                	jns    8011fe <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  8011ec:	50                   	push   %eax
  8011ed:	68 8a 2f 80 00       	push   $0x802f8a
  8011f2:	6a 56                	push   $0x56
  8011f4:	68 30 2f 80 00       	push   $0x802f30
  8011f9:	e8 4e f0 ff ff       	call   80024c <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  8011fe:	83 ec 0c             	sub    $0xc,%esp
  801201:	68 05 08 00 00       	push   $0x805
  801206:	c1 e3 0c             	shl    $0xc,%ebx
  801209:	53                   	push   %ebx
  80120a:	83 ec 0c             	sub    $0xc,%esp
  80120d:	e8 c2 fa ff ff       	call   800cd4 <sys_getenvid>
  801212:	83 c4 0c             	add    $0xc,%esp
  801215:	50                   	push   %eax
  801216:	53                   	push   %ebx
  801217:	83 ec 04             	sub    $0x4,%esp
  80121a:	e8 b5 fa ff ff       	call   800cd4 <sys_getenvid>
  80121f:	89 04 24             	mov    %eax,(%esp)
  801222:	e8 2e fb ff ff       	call   800d55 <sys_page_map>
  801227:	83 c4 20             	add    $0x20,%esp
  80122a:	85 c0                	test   %eax,%eax
  80122c:	79 48                	jns    801276 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  80122e:	50                   	push   %eax
  80122f:	68 8a 2f 80 00       	push   $0x802f8a
  801234:	6a 5b                	push   $0x5b
  801236:	68 30 2f 80 00       	push   $0x802f30
  80123b:	e8 0c f0 ff ff       	call   80024c <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	6a 05                	push   $0x5
  801245:	89 d8                	mov    %ebx,%eax
  801247:	c1 e0 0c             	shl    $0xc,%eax
  80124a:	50                   	push   %eax
  80124b:	51                   	push   %ecx
  80124c:	50                   	push   %eax
  80124d:	83 ec 04             	sub    $0x4,%esp
  801250:	e8 7f fa ff ff       	call   800cd4 <sys_getenvid>
  801255:	89 04 24             	mov    %eax,(%esp)
  801258:	e8 f8 fa ff ff       	call   800d55 <sys_page_map>
  80125d:	83 c4 20             	add    $0x20,%esp
  801260:	85 c0                	test   %eax,%eax
  801262:	79 12                	jns    801276 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  801264:	50                   	push   %eax
  801265:	68 8a 2f 80 00       	push   $0x802f8a
  80126a:	6a 5f                	push   $0x5f
  80126c:	68 30 2f 80 00       	push   $0x802f30
  801271:	e8 d6 ef ff ff       	call   80024c <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  801276:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80127b:	89 d0                	mov    %edx,%eax
  80127d:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <fork>:

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
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	57                   	push   %edi
  801286:	56                   	push   %esi
  801287:	53                   	push   %ebx
  801288:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  80128b:	68 6c 10 80 00       	push   $0x80106c
  801290:	e8 bf 13 00 00       	call   802654 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  801295:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  801298:	ba 07 00 00 00       	mov    $0x7,%edx
  80129d:	89 d0                	mov    %edx,%eax
  80129f:	cd 30                	int    $0x30
  8012a1:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	79 15                	jns    8012bd <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  8012a8:	50                   	push   %eax
  8012a9:	68 10 2f 80 00       	push   $0x802f10
  8012ae:	68 85 00 00 00       	push   $0x85
  8012b3:	68 30 2f 80 00       	push   $0x802f30
  8012b8:	e8 8f ef ff ff       	call   80024c <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  8012bd:	bf 00 00 00 00       	mov    $0x0,%edi
  8012c2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8012c6:	75 21                	jne    8012e9 <fork+0x67>
  8012c8:	e8 07 fa ff ff       	call   800cd4 <sys_getenvid>
  8012cd:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012d2:	c1 e0 07             	shl    $0x7,%eax
  8012d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012da:	a3 80 70 80 00       	mov    %eax,0x807080
  8012df:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e4:	e9 fd 00 00 00       	jmp    8013e6 <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  8012e9:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  8012f0:	a8 01                	test   $0x1,%al
  8012f2:	74 5f                	je     801353 <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  8012f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f9:	89 f8                	mov    %edi,%eax
  8012fb:	c1 e0 0a             	shl    $0xa,%eax
  8012fe:	89 c2                	mov    %eax,%edx
  801300:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801305:	77 4c                	ja     801353 <fork+0xd1>
  801307:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  801309:	01 da                	add    %ebx,%edx
  80130b:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801312:	a8 01                	test   $0x1,%al
  801314:	74 28                	je     80133e <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	52                   	push   %edx
  80131a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80131d:	e8 45 fe ff ff       	call   801167 <duppage>
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	79 15                	jns    80133e <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  801329:	50                   	push   %eax
  80132a:	68 a3 2f 80 00       	push   $0x802fa3
  80132f:	68 95 00 00 00       	push   $0x95
  801334:	68 30 2f 80 00       	push   $0x802f30
  801339:	e8 0e ef ff ff       	call   80024c <_panic>
  80133e:	43                   	inc    %ebx
  80133f:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  801345:	7f 0c                	jg     801353 <fork+0xd1>
  801347:	89 f2                	mov    %esi,%edx
  801349:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80134c:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801351:	76 b6                	jbe    801309 <fork+0x87>
  801353:	47                   	inc    %edi
  801354:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  80135a:	76 8d                	jbe    8012e9 <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  80135c:	83 ec 04             	sub    $0x4,%esp
  80135f:	6a 07                	push   $0x7
  801361:	68 00 f0 bf ee       	push   $0xeebff000
  801366:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801369:	e8 a4 f9 ff ff       	call   800d12 <sys_page_alloc>
  80136e:	83 c4 10             	add    $0x10,%esp
  801371:	85 c0                	test   %eax,%eax
  801373:	79 15                	jns    80138a <fork+0x108>
          panic("fork: %d", r);
  801375:	50                   	push   %eax
  801376:	68 bc 2f 80 00       	push   $0x802fbc
  80137b:	68 9d 00 00 00       	push   $0x9d
  801380:	68 30 2f 80 00       	push   $0x802f30
  801385:	e8 c2 ee ff ff       	call   80024c <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  80138a:	83 ec 08             	sub    $0x8,%esp
  80138d:	a1 80 70 80 00       	mov    0x807080,%eax
  801392:	8b 40 64             	mov    0x64(%eax),%eax
  801395:	50                   	push   %eax
  801396:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801399:	e8 bf fa ff ff       	call   800e5d <sys_env_set_pgfault_upcall>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	79 15                	jns    8013ba <fork+0x138>
          panic("fork: %d", r);
  8013a5:	50                   	push   %eax
  8013a6:	68 bc 2f 80 00       	push   $0x802fbc
  8013ab:	68 a2 00 00 00       	push   $0xa2
  8013b0:	68 30 2f 80 00       	push   $0x802f30
  8013b5:	e8 92 ee ff ff       	call   80024c <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	6a 01                	push   $0x1
  8013bf:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8013c2:	e8 12 fa ff ff       	call   800dd9 <sys_env_set_status>
  8013c7:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  8013ca:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	79 15                	jns    8013e6 <fork+0x164>
  8013d1:	50                   	push   %eax
  8013d2:	68 bc 2f 80 00       	push   $0x802fbc
  8013d7:	68 a7 00 00 00       	push   $0xa7
  8013dc:	68 30 2f 80 00       	push   $0x802f30
  8013e1:	e8 66 ee ff ff       	call   80024c <_panic>
 
	//panic("fork not implemented");
}
  8013e6:	89 d0                	mov    %edx,%eax
  8013e8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8013eb:	5b                   	pop    %ebx
  8013ec:	5e                   	pop    %esi
  8013ed:	5f                   	pop    %edi
  8013ee:	c9                   	leave  
  8013ef:	c3                   	ret    

008013f0 <sfork>:



// Challenge!
int
sfork(void)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8013f6:	68 c5 2f 80 00       	push   $0x802fc5
  8013fb:	68 b5 00 00 00       	push   $0xb5
  801400:	68 30 2f 80 00       	push   $0x802f30
  801405:	e8 42 ee ff ff       	call   80024c <_panic>
	...

0080140c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	56                   	push   %esi
  801410:	53                   	push   %ebx
  801411:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  80141a:	85 c0                	test   %eax,%eax
  80141c:	75 12                	jne    801430 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  80141e:	83 ec 0c             	sub    $0xc,%esp
  801421:	68 00 00 c0 ee       	push   $0xeec00000
  801426:	e8 97 fa ff ff       	call   800ec2 <sys_ipc_recv>
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	eb 0c                	jmp    80143c <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  801430:	83 ec 0c             	sub    $0xc,%esp
  801433:	50                   	push   %eax
  801434:	e8 89 fa ff ff       	call   800ec2 <sys_ipc_recv>
  801439:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  80143c:	89 c2                	mov    %eax,%edx
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 24                	js     801466 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  801442:	85 db                	test   %ebx,%ebx
  801444:	74 0a                	je     801450 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  801446:	a1 80 70 80 00       	mov    0x807080,%eax
  80144b:	8b 40 74             	mov    0x74(%eax),%eax
  80144e:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  801450:	85 f6                	test   %esi,%esi
  801452:	74 0a                	je     80145e <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  801454:	a1 80 70 80 00       	mov    0x807080,%eax
  801459:	8b 40 78             	mov    0x78(%eax),%eax
  80145c:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  80145e:	a1 80 70 80 00       	mov    0x807080,%eax
  801463:	8b 50 70             	mov    0x70(%eax),%edx

}
  801466:	89 d0                	mov    %edx,%eax
  801468:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80146b:	5b                   	pop    %ebx
  80146c:	5e                   	pop    %esi
  80146d:	c9                   	leave  
  80146e:	c3                   	ret    

0080146f <ipc_send>:

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
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	57                   	push   %edi
  801473:	56                   	push   %esi
  801474:	53                   	push   %ebx
  801475:	83 ec 0c             	sub    $0xc,%esp
  801478:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80147b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80147e:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  801481:	85 db                	test   %ebx,%ebx
  801483:	75 0a                	jne    80148f <ipc_send+0x20>
    pg = (void *) UTOP;
  801485:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  80148a:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  80148f:	56                   	push   %esi
  801490:	53                   	push   %ebx
  801491:	57                   	push   %edi
  801492:	ff 75 08             	pushl  0x8(%ebp)
  801495:	e8 05 fa ff ff       	call   800e9f <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014a0:	75 07                	jne    8014a9 <ipc_send+0x3a>
      sys_yield();
  8014a2:	e8 4c f8 ff ff       	call   800cf3 <sys_yield>
  8014a7:	eb e6                	jmp    80148f <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	79 12                	jns    8014bf <ipc_send+0x50>
  8014ad:	50                   	push   %eax
  8014ae:	68 db 2f 80 00       	push   $0x802fdb
  8014b3:	6a 49                	push   $0x49
  8014b5:	68 f8 2f 80 00       	push   $0x802ff8
  8014ba:	e8 8d ed ff ff       	call   80024c <_panic>
    else break;
  }
}
  8014bf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8014c2:	5b                   	pop    %ebx
  8014c3:	5e                   	pop    %esi
  8014c4:	5f                   	pop    %edi
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    
	...

008014c8 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8014c8:	55                   	push   %ebp
  8014c9:	89 e5                	mov    %esp,%ebp
  8014cb:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8014ce:	ff 75 08             	pushl  0x8(%ebp)
  8014d1:	e8 0a 00 00 00       	call   8014e0 <fd2num>
  8014d6:	c1 e0 16             	shl    $0x16,%eax
  8014d9:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <fd2num>:

int
fd2num(struct Fd *fd)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	05 00 00 40 30       	add    $0x30400000,%eax
  8014eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <fd_alloc>:

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
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	57                   	push   %edi
  8014f4:	56                   	push   %esi
  8014f5:	53                   	push   %ebx
  8014f6:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014fe:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801503:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  801508:	89 c8                	mov    %ecx,%eax
  80150a:	c1 e0 0c             	shl    $0xc,%eax
  80150d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801513:	89 d0                	mov    %edx,%eax
  801515:	c1 e8 16             	shr    $0x16,%eax
  801518:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80151b:	a8 01                	test   $0x1,%al
  80151d:	74 0c                	je     80152b <fd_alloc+0x3b>
  80151f:	89 d0                	mov    %edx,%eax
  801521:	c1 e8 0c             	shr    $0xc,%eax
  801524:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  801527:	a8 01                	test   $0x1,%al
  801529:	75 09                	jne    801534 <fd_alloc+0x44>
			*fd_store = fd;
  80152b:	89 17                	mov    %edx,(%edi)
			return 0;
  80152d:	b8 00 00 00 00       	mov    $0x0,%eax
  801532:	eb 11                	jmp    801545 <fd_alloc+0x55>
  801534:	41                   	inc    %ecx
  801535:	83 f9 1f             	cmp    $0x1f,%ecx
  801538:	7e ce                	jle    801508 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80153a:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801540:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801545:	5b                   	pop    %ebx
  801546:	5e                   	pop    %esi
  801547:	5f                   	pop    %edi
  801548:	c9                   	leave  
  801549:	c3                   	ret    

0080154a <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80154a:	55                   	push   %ebp
  80154b:	89 e5                	mov    %esp,%ebp
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801550:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801555:	83 f8 1f             	cmp    $0x1f,%eax
  801558:	77 3a                	ja     801594 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80155a:	c1 e0 0c             	shl    $0xc,%eax
  80155d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801563:	89 d0                	mov    %edx,%eax
  801565:	c1 e8 16             	shr    $0x16,%eax
  801568:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80156f:	a8 01                	test   $0x1,%al
  801571:	74 10                	je     801583 <fd_lookup+0x39>
  801573:	89 d0                	mov    %edx,%eax
  801575:	c1 e8 0c             	shr    $0xc,%eax
  801578:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80157f:	a8 01                	test   $0x1,%al
  801581:	75 07                	jne    80158a <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801583:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801588:	eb 0a                	jmp    801594 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  80158a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158d:	89 10                	mov    %edx,(%eax)
	return 0;
  80158f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801594:	89 d0                	mov    %edx,%eax
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <fd_close>:

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
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	56                   	push   %esi
  80159c:	53                   	push   %ebx
  80159d:	83 ec 10             	sub    $0x10,%esp
  8015a0:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015a3:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8015a6:	50                   	push   %eax
  8015a7:	56                   	push   %esi
  8015a8:	e8 33 ff ff ff       	call   8014e0 <fd2num>
  8015ad:	89 04 24             	mov    %eax,(%esp)
  8015b0:	e8 95 ff ff ff       	call   80154a <fd_lookup>
  8015b5:	89 c3                	mov    %eax,%ebx
  8015b7:	83 c4 08             	add    $0x8,%esp
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	78 05                	js     8015c3 <fd_close+0x2b>
  8015be:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8015c1:	74 0f                	je     8015d2 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8015c3:	89 d8                	mov    %ebx,%eax
  8015c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c9:	75 3a                	jne    801605 <fd_close+0x6d>
  8015cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d0:	eb 33                	jmp    801605 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8015d2:	83 ec 08             	sub    $0x8,%esp
  8015d5:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8015d8:	50                   	push   %eax
  8015d9:	ff 36                	pushl  (%esi)
  8015db:	e8 2c 00 00 00       	call   80160c <dev_lookup>
  8015e0:	89 c3                	mov    %eax,%ebx
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	85 c0                	test   %eax,%eax
  8015e7:	78 0f                	js     8015f8 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  8015e9:	83 ec 0c             	sub    $0xc,%esp
  8015ec:	56                   	push   %esi
  8015ed:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8015f0:	ff 50 10             	call   *0x10(%eax)
  8015f3:	89 c3                	mov    %eax,%ebx
  8015f5:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015f8:	83 ec 08             	sub    $0x8,%esp
  8015fb:	56                   	push   %esi
  8015fc:	6a 00                	push   $0x0
  8015fe:	e8 94 f7 ff ff       	call   800d97 <sys_page_unmap>
	return r;
  801603:	89 d8                	mov    %ebx,%eax
}
  801605:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801608:	5b                   	pop    %ebx
  801609:	5e                   	pop    %esi
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <dev_lookup>:


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
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	56                   	push   %esi
  801610:	53                   	push   %ebx
  801611:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801614:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  801617:	ba 00 00 00 00       	mov    $0x0,%edx
  80161c:	83 3d 04 70 80 00 00 	cmpl   $0x0,0x807004
  801623:	74 1c                	je     801641 <dev_lookup+0x35>
  801625:	b9 04 70 80 00       	mov    $0x807004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80162a:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  80162d:	39 18                	cmp    %ebx,(%eax)
  80162f:	75 09                	jne    80163a <dev_lookup+0x2e>
			*dev = devtab[i];
  801631:	89 06                	mov    %eax,(%esi)
			return 0;
  801633:	b8 00 00 00 00       	mov    $0x0,%eax
  801638:	eb 29                	jmp    801663 <dev_lookup+0x57>
  80163a:	42                   	inc    %edx
  80163b:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  80163f:	75 e9                	jne    80162a <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	53                   	push   %ebx
  801645:	a1 80 70 80 00       	mov    0x807080,%eax
  80164a:	8b 40 4c             	mov    0x4c(%eax),%eax
  80164d:	50                   	push   %eax
  80164e:	68 04 30 80 00       	push   $0x803004
  801653:	e8 e4 ec ff ff       	call   80033c <cprintf>
	*dev = 0;
  801658:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  80165e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801663:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801666:	5b                   	pop    %ebx
  801667:	5e                   	pop    %esi
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <close>:

int
close(int fdnum)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801670:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801673:	50                   	push   %eax
  801674:	ff 75 08             	pushl  0x8(%ebp)
  801677:	e8 ce fe ff ff       	call   80154a <fd_lookup>
  80167c:	83 c4 08             	add    $0x8,%esp
		return r;
  80167f:	89 c2                	mov    %eax,%edx
  801681:	85 c0                	test   %eax,%eax
  801683:	78 0f                	js     801694 <close+0x2a>
	else
		return fd_close(fd, 1);
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	6a 01                	push   $0x1
  80168a:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80168d:	e8 06 ff ff ff       	call   801598 <fd_close>
  801692:	89 c2                	mov    %eax,%edx
}
  801694:	89 d0                	mov    %edx,%eax
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <close_all>:

void
close_all(void)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	53                   	push   %ebx
  80169c:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80169f:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016a4:	83 ec 0c             	sub    $0xc,%esp
  8016a7:	53                   	push   %ebx
  8016a8:	e8 bd ff ff ff       	call   80166a <close>
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	43                   	inc    %ebx
  8016b1:	83 fb 1f             	cmp    $0x1f,%ebx
  8016b4:	7e ee                	jle    8016a4 <close_all+0xc>
}
  8016b6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	57                   	push   %edi
  8016bf:	56                   	push   %esi
  8016c0:	53                   	push   %ebx
  8016c1:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016c4:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8016c7:	50                   	push   %eax
  8016c8:	ff 75 08             	pushl  0x8(%ebp)
  8016cb:	e8 7a fe ff ff       	call   80154a <fd_lookup>
  8016d0:	89 c6                	mov    %eax,%esi
  8016d2:	83 c4 08             	add    $0x8,%esp
  8016d5:	85 f6                	test   %esi,%esi
  8016d7:	0f 88 f8 00 00 00    	js     8017d5 <dup+0x11a>
		return r;
	close(newfdnum);
  8016dd:	83 ec 0c             	sub    $0xc,%esp
  8016e0:	ff 75 0c             	pushl  0xc(%ebp)
  8016e3:	e8 82 ff ff ff       	call   80166a <close>

	newfd = INDEX2FD(newfdnum);
  8016e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016eb:	c1 e0 0c             	shl    $0xc,%eax
  8016ee:	2d 00 00 40 30       	sub    $0x30400000,%eax
  8016f3:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  8016f6:	83 c4 04             	add    $0x4,%esp
  8016f9:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8016fc:	e8 c7 fd ff ff       	call   8014c8 <fd2data>
  801701:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801703:	83 c4 04             	add    $0x4,%esp
  801706:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801709:	e8 ba fd ff ff       	call   8014c8 <fd2data>
  80170e:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801711:	89 f8                	mov    %edi,%eax
  801713:	c1 e8 16             	shr    $0x16,%eax
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801720:	85 c0                	test   %eax,%eax
  801722:	74 48                	je     80176c <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801724:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  801729:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  80172c:	89 d0                	mov    %edx,%eax
  80172e:	c1 e8 0c             	shr    $0xc,%eax
  801731:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  801738:	a8 01                	test   $0x1,%al
  80173a:	74 22                	je     80175e <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  80173c:	83 ec 0c             	sub    $0xc,%esp
  80173f:	25 07 0e 00 00       	and    $0xe07,%eax
  801744:	50                   	push   %eax
  801745:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801748:	01 d8                	add    %ebx,%eax
  80174a:	50                   	push   %eax
  80174b:	6a 00                	push   $0x0
  80174d:	52                   	push   %edx
  80174e:	6a 00                	push   $0x0
  801750:	e8 00 f6 ff ff       	call   800d55 <sys_page_map>
  801755:	89 c6                	mov    %eax,%esi
  801757:	83 c4 20             	add    $0x20,%esp
  80175a:	85 c0                	test   %eax,%eax
  80175c:	78 3f                	js     80179d <dup+0xe2>
  80175e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801764:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80176a:	7e bd                	jle    801729 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80176c:	83 ec 0c             	sub    $0xc,%esp
  80176f:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801772:	89 d0                	mov    %edx,%eax
  801774:	c1 e8 0c             	shr    $0xc,%eax
  801777:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80177e:	25 07 0e 00 00       	and    $0xe07,%eax
  801783:	50                   	push   %eax
  801784:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801787:	6a 00                	push   $0x0
  801789:	52                   	push   %edx
  80178a:	6a 00                	push   $0x0
  80178c:	e8 c4 f5 ff ff       	call   800d55 <sys_page_map>
  801791:	89 c6                	mov    %eax,%esi
  801793:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  801796:	8b 45 0c             	mov    0xc(%ebp),%eax
  801799:	85 f6                	test   %esi,%esi
  80179b:	79 38                	jns    8017d5 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  80179d:	83 ec 08             	sub    $0x8,%esp
  8017a0:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8017a3:	6a 00                	push   $0x0
  8017a5:	e8 ed f5 ff ff       	call   800d97 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8017aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017af:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8017b2:	83 ec 08             	sub    $0x8,%esp
  8017b5:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8017b8:	01 d8                	add    %ebx,%eax
  8017ba:	50                   	push   %eax
  8017bb:	6a 00                	push   $0x0
  8017bd:	e8 d5 f5 ff ff       	call   800d97 <sys_page_unmap>
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8017cb:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8017d1:	7e df                	jle    8017b2 <dup+0xf7>
	return r;
  8017d3:	89 f0                	mov    %esi,%eax
}
  8017d5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5f                   	pop    %edi
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 14             	sub    $0x14,%esp
  8017e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e7:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8017ea:	50                   	push   %eax
  8017eb:	53                   	push   %ebx
  8017ec:	e8 59 fd ff ff       	call   80154a <fd_lookup>
  8017f1:	89 c2                	mov    %eax,%edx
  8017f3:	83 c4 08             	add    $0x8,%esp
  8017f6:	85 c0                	test   %eax,%eax
  8017f8:	78 1a                	js     801814 <read+0x37>
  8017fa:	83 ec 08             	sub    $0x8,%esp
  8017fd:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801800:	50                   	push   %eax
  801801:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801804:	ff 30                	pushl  (%eax)
  801806:	e8 01 fe ff ff       	call   80160c <dev_lookup>
  80180b:	89 c2                	mov    %eax,%edx
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	85 c0                	test   %eax,%eax
  801812:	79 04                	jns    801818 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801814:	89 d0                	mov    %edx,%eax
  801816:	eb 50                	jmp    801868 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801818:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80181b:	8b 40 08             	mov    0x8(%eax),%eax
  80181e:	83 e0 03             	and    $0x3,%eax
  801821:	83 f8 01             	cmp    $0x1,%eax
  801824:	75 1e                	jne    801844 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801826:	83 ec 04             	sub    $0x4,%esp
  801829:	53                   	push   %ebx
  80182a:	a1 80 70 80 00       	mov    0x807080,%eax
  80182f:	8b 40 4c             	mov    0x4c(%eax),%eax
  801832:	50                   	push   %eax
  801833:	68 45 30 80 00       	push   $0x803045
  801838:	e8 ff ea ff ff       	call   80033c <cprintf>
		return -E_INVAL;
  80183d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801842:	eb 24                	jmp    801868 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801844:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801847:	ff 70 04             	pushl  0x4(%eax)
  80184a:	ff 75 10             	pushl  0x10(%ebp)
  80184d:	ff 75 0c             	pushl  0xc(%ebp)
  801850:	50                   	push   %eax
  801851:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801854:	ff 50 08             	call   *0x8(%eax)
  801857:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	85 c0                	test   %eax,%eax
  80185e:	78 06                	js     801866 <read+0x89>
		fd->fd_offset += r;
  801860:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801863:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801866:	89 d0                	mov    %edx,%eax
}
  801868:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	57                   	push   %edi
  801871:	56                   	push   %esi
  801872:	53                   	push   %ebx
  801873:	83 ec 0c             	sub    $0xc,%esp
  801876:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801879:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80187c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801881:	39 f3                	cmp    %esi,%ebx
  801883:	73 25                	jae    8018aa <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	89 f0                	mov    %esi,%eax
  80188a:	29 d8                	sub    %ebx,%eax
  80188c:	50                   	push   %eax
  80188d:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801890:	50                   	push   %eax
  801891:	ff 75 08             	pushl  0x8(%ebp)
  801894:	e8 44 ff ff ff       	call   8017dd <read>
		if (m < 0)
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 0c                	js     8018ac <readn+0x3f>
			return m;
		if (m == 0)
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	74 06                	je     8018aa <readn+0x3d>
  8018a4:	01 c3                	add    %eax,%ebx
  8018a6:	39 f3                	cmp    %esi,%ebx
  8018a8:	72 db                	jb     801885 <readn+0x18>
			break;
	}
	return tot;
  8018aa:	89 d8                	mov    %ebx,%eax
}
  8018ac:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8018af:	5b                   	pop    %ebx
  8018b0:	5e                   	pop    %esi
  8018b1:	5f                   	pop    %edi
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	53                   	push   %ebx
  8018b8:	83 ec 14             	sub    $0x14,%esp
  8018bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018be:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8018c1:	50                   	push   %eax
  8018c2:	53                   	push   %ebx
  8018c3:	e8 82 fc ff ff       	call   80154a <fd_lookup>
  8018c8:	89 c2                	mov    %eax,%edx
  8018ca:	83 c4 08             	add    $0x8,%esp
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	78 1a                	js     8018eb <write+0x37>
  8018d1:	83 ec 08             	sub    $0x8,%esp
  8018d4:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8018d7:	50                   	push   %eax
  8018d8:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018db:	ff 30                	pushl  (%eax)
  8018dd:	e8 2a fd ff ff       	call   80160c <dev_lookup>
  8018e2:	89 c2                	mov    %eax,%edx
  8018e4:	83 c4 10             	add    $0x10,%esp
  8018e7:	85 c0                	test   %eax,%eax
  8018e9:	79 04                	jns    8018ef <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8018eb:	89 d0                	mov    %edx,%eax
  8018ed:	eb 4b                	jmp    80193a <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ef:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018f2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018f6:	75 1e                	jne    801916 <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	53                   	push   %ebx
  8018fc:	a1 80 70 80 00       	mov    0x807080,%eax
  801901:	8b 40 4c             	mov    0x4c(%eax),%eax
  801904:	50                   	push   %eax
  801905:	68 61 30 80 00       	push   $0x803061
  80190a:	e8 2d ea ff ff       	call   80033c <cprintf>
		return -E_INVAL;
  80190f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801914:	eb 24                	jmp    80193a <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801916:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801919:	ff 70 04             	pushl  0x4(%eax)
  80191c:	ff 75 10             	pushl  0x10(%ebp)
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	50                   	push   %eax
  801923:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801926:	ff 50 0c             	call   *0xc(%eax)
  801929:	89 c2                	mov    %eax,%edx
	if (r > 0)
  80192b:	83 c4 10             	add    $0x10,%esp
  80192e:	85 c0                	test   %eax,%eax
  801930:	7e 06                	jle    801938 <write+0x84>
		fd->fd_offset += r;
  801932:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801935:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801938:	89 d0                	mov    %edx,%eax
}
  80193a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <seek>:

int
seek(int fdnum, off_t offset)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801945:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801948:	50                   	push   %eax
  801949:	ff 75 08             	pushl  0x8(%ebp)
  80194c:	e8 f9 fb ff ff       	call   80154a <fd_lookup>
  801951:	83 c4 08             	add    $0x8,%esp
		return r;
  801954:	89 c2                	mov    %eax,%edx
  801956:	85 c0                	test   %eax,%eax
  801958:	78 0e                	js     801968 <seek+0x29>
	fd->fd_offset = offset;
  80195a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801960:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801963:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801968:	89 d0                	mov    %edx,%eax
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	53                   	push   %ebx
  801970:	83 ec 14             	sub    $0x14,%esp
  801973:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801976:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801979:	50                   	push   %eax
  80197a:	53                   	push   %ebx
  80197b:	e8 ca fb ff ff       	call   80154a <fd_lookup>
  801980:	83 c4 08             	add    $0x8,%esp
  801983:	85 c0                	test   %eax,%eax
  801985:	78 4e                	js     8019d5 <ftruncate+0x69>
  801987:	83 ec 08             	sub    $0x8,%esp
  80198a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80198d:	50                   	push   %eax
  80198e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801991:	ff 30                	pushl  (%eax)
  801993:	e8 74 fc ff ff       	call   80160c <dev_lookup>
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	85 c0                	test   %eax,%eax
  80199d:	78 36                	js     8019d5 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80199f:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8019a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019a6:	75 1e                	jne    8019c6 <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019a8:	83 ec 04             	sub    $0x4,%esp
  8019ab:	53                   	push   %ebx
  8019ac:	a1 80 70 80 00       	mov    0x807080,%eax
  8019b1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019b4:	50                   	push   %eax
  8019b5:	68 24 30 80 00       	push   $0x803024
  8019ba:	e8 7d e9 ff ff       	call   80033c <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  8019bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019c4:	eb 0f                	jmp    8019d5 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  8019c6:	83 ec 08             	sub    $0x8,%esp
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8019cf:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8019d2:	ff 50 1c             	call   *0x1c(%eax)
}
  8019d5:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	53                   	push   %ebx
  8019de:	83 ec 14             	sub    $0x14,%esp
  8019e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019e4:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  8019e7:	50                   	push   %eax
  8019e8:	ff 75 08             	pushl  0x8(%ebp)
  8019eb:	e8 5a fb ff ff       	call   80154a <fd_lookup>
  8019f0:	83 c4 08             	add    $0x8,%esp
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	78 42                	js     801a39 <fstat+0x5f>
  8019f7:	83 ec 08             	sub    $0x8,%esp
  8019fa:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8019fd:	50                   	push   %eax
  8019fe:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801a01:	ff 30                	pushl  (%eax)
  801a03:	e8 04 fc ff ff       	call   80160c <dev_lookup>
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	78 2a                	js     801a39 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  801a0f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a12:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a19:	00 00 00 
	stat->st_isdir = 0;
  801a1c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a23:	00 00 00 
	stat->st_dev = dev;
  801a26:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801a29:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	53                   	push   %ebx
  801a33:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801a36:	ff 50 14             	call   *0x14(%eax)
}
  801a39:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	56                   	push   %esi
  801a42:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a43:	83 ec 08             	sub    $0x8,%esp
  801a46:	6a 00                	push   $0x0
  801a48:	ff 75 08             	pushl  0x8(%ebp)
  801a4b:	e8 28 00 00 00       	call   801a78 <open>
  801a50:	89 c6                	mov    %eax,%esi
  801a52:	83 c4 10             	add    $0x10,%esp
  801a55:	85 f6                	test   %esi,%esi
  801a57:	78 18                	js     801a71 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801a59:	83 ec 08             	sub    $0x8,%esp
  801a5c:	ff 75 0c             	pushl  0xc(%ebp)
  801a5f:	56                   	push   %esi
  801a60:	e8 75 ff ff ff       	call   8019da <fstat>
  801a65:	89 c3                	mov    %eax,%ebx
	close(fd);
  801a67:	89 34 24             	mov    %esi,(%esp)
  801a6a:	e8 fb fb ff ff       	call   80166a <close>
	return r;
  801a6f:	89 d8                	mov    %ebx,%eax
}
  801a71:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801a74:	5b                   	pop    %ebx
  801a75:	5e                   	pop    %esi
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
  801a7b:	53                   	push   %ebx
  801a7c:	83 ec 10             	sub    $0x10,%esp
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
  801a7f:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801a82:	50                   	push   %eax
  801a83:	e8 68 fa ff ff       	call   8014f0 <fd_alloc>
  801a88:	89 c3                	mov    %eax,%ebx
  801a8a:	83 c4 10             	add    $0x10,%esp
  801a8d:	85 db                	test   %ebx,%ebx
  801a8f:	78 36                	js     801ac7 <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801a91:	83 ec 04             	sub    $0x4,%esp
  801a94:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801a97:	ff 75 0c             	pushl  0xc(%ebp)
  801a9a:	ff 75 08             	pushl  0x8(%ebp)
  801a9d:	e8 1b 05 00 00       	call   801fbd <fsipc_open>
  801aa2:	89 c3                	mov    %eax,%ebx
  801aa4:	83 c4 10             	add    $0x10,%esp
  801aa7:	85 c0                	test   %eax,%eax
  801aa9:	79 11                	jns    801abc <open+0x44>
          fd_close(fd_store, 0);
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	6a 00                	push   $0x0
  801ab0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801ab3:	e8 e0 fa ff ff       	call   801598 <fd_close>
          return r;
  801ab8:	89 d8                	mov    %ebx,%eax
  801aba:	eb 0b                	jmp    801ac7 <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801abc:	83 ec 0c             	sub    $0xc,%esp
  801abf:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801ac2:	e8 19 fa ff ff       	call   8014e0 <fd2num>
}
  801ac7:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	53                   	push   %ebx
  801ad0:	83 ec 04             	sub    $0x4,%esp
  801ad3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  801ad6:	6a 01                	push   $0x1
  801ad8:	6a 00                	push   $0x0
  801ada:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801ae0:	53                   	push   %ebx
  801ae1:	e8 e7 03 00 00       	call   801ecd <funmap>
  801ae6:	83 c4 10             	add    $0x10,%esp
          return r;
  801ae9:	89 c2                	mov    %eax,%edx
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	78 19                	js     801b08 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  801aef:	83 ec 0c             	sub    $0xc,%esp
  801af2:	ff 73 0c             	pushl  0xc(%ebx)
  801af5:	e8 68 05 00 00       	call   802062 <fsipc_close>
  801afa:	83 c4 10             	add    $0x10,%esp
          return r;
  801afd:	89 c2                	mov    %eax,%edx
  801aff:	85 c0                	test   %eax,%eax
  801b01:	78 05                	js     801b08 <file_close+0x3c>
        }
        return 0;
  801b03:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b08:	89 d0                	mov    %edx,%eax
  801b0a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	57                   	push   %edi
  801b13:	56                   	push   %esi
  801b14:	53                   	push   %ebx
  801b15:	83 ec 0c             	sub    $0xc,%esp
  801b18:	8b 75 10             	mov    0x10(%ebp),%esi
  801b1b:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  801b27:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b2c:	39 d7                	cmp    %edx,%edi
  801b2e:	0f 87 95 00 00 00    	ja     801bc9 <file_read+0xba>
	if (offset + n > size)
  801b34:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801b37:	39 d0                	cmp    %edx,%eax
  801b39:	76 04                	jbe    801b3f <file_read+0x30>
		n = size - offset;
  801b3b:	89 d6                	mov    %edx,%esi
  801b3d:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801b3f:	83 ec 0c             	sub    $0xc,%esp
  801b42:	ff 75 08             	pushl  0x8(%ebp)
  801b45:	e8 7e f9 ff ff       	call   8014c8 <fd2data>
  801b4a:	89 c3                	mov    %eax,%ebx
  801b4c:	01 fb                	add    %edi,%ebx
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	eb 41                	jmp    801b94 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801b53:	89 d8                	mov    %ebx,%eax
  801b55:	c1 e8 16             	shr    $0x16,%eax
  801b58:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801b5f:	a8 01                	test   $0x1,%al
  801b61:	74 10                	je     801b73 <file_read+0x64>
  801b63:	89 d8                	mov    %ebx,%eax
  801b65:	c1 e8 0c             	shr    $0xc,%eax
  801b68:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b6f:	a8 01                	test   $0x1,%al
  801b71:	75 1b                	jne    801b8e <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801b73:	83 ec 04             	sub    $0x4,%esp
  801b76:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801b79:	50                   	push   %eax
  801b7a:	57                   	push   %edi
  801b7b:	ff 75 08             	pushl  0x8(%ebp)
  801b7e:	e8 d4 02 00 00       	call   801e57 <fmap>
  801b83:	83 c4 10             	add    $0x10,%esp
              return r;
  801b86:	89 c1                	mov    %eax,%ecx
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	78 3d                	js     801bc9 <file_read+0xba>
  801b8c:	eb 1c                	jmp    801baa <file_read+0x9b>
  801b8e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b94:	83 ec 0c             	sub    $0xc,%esp
  801b97:	ff 75 08             	pushl  0x8(%ebp)
  801b9a:	e8 29 f9 ff ff       	call   8014c8 <fd2data>
  801b9f:	01 f8                	add    %edi,%eax
  801ba1:	01 f0                	add    %esi,%eax
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	39 d8                	cmp    %ebx,%eax
  801ba8:	77 a9                	ja     801b53 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801baa:	83 ec 04             	sub    $0x4,%esp
  801bad:	56                   	push   %esi
  801bae:	83 ec 04             	sub    $0x4,%esp
  801bb1:	ff 75 08             	pushl  0x8(%ebp)
  801bb4:	e8 0f f9 ff ff       	call   8014c8 <fd2data>
  801bb9:	83 c4 08             	add    $0x8,%esp
  801bbc:	01 f8                	add    %edi,%eax
  801bbe:	50                   	push   %eax
  801bbf:	ff 75 0c             	pushl  0xc(%ebp)
  801bc2:	e8 f5 ee ff ff       	call   800abc <memmove>
	return n;
  801bc7:	89 f1                	mov    %esi,%ecx
}
  801bc9:	89 c8                	mov    %ecx,%eax
  801bcb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801bce:	5b                   	pop    %ebx
  801bcf:	5e                   	pop    %esi
  801bd0:	5f                   	pop    %edi
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	56                   	push   %esi
  801bd7:	53                   	push   %ebx
  801bd8:	83 ec 18             	sub    $0x18,%esp
  801bdb:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bde:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801be1:	50                   	push   %eax
  801be2:	ff 75 08             	pushl  0x8(%ebp)
  801be5:	e8 60 f9 ff ff       	call   80154a <fd_lookup>
  801bea:	83 c4 10             	add    $0x10,%esp
		return r;
  801bed:	89 c2                	mov    %eax,%edx
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	0f 88 9f 00 00 00    	js     801c96 <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801bf7:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801bfa:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  801bfc:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801c01:	3b 05 20 70 80 00    	cmp    0x807020,%eax
  801c07:	0f 85 89 00 00 00    	jne    801c96 <read_map+0xc3>
	va = fd2data(fd) + offset;
  801c0d:	83 ec 0c             	sub    $0xc,%esp
  801c10:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801c13:	e8 b0 f8 ff ff       	call   8014c8 <fd2data>
  801c18:	89 c3                	mov    %eax,%ebx
  801c1a:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801c1c:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801c1f:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801c24:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801c2a:	7f 6a                	jg     801c96 <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801c2c:	89 d8                	mov    %ebx,%eax
  801c2e:	c1 e8 16             	shr    $0x16,%eax
  801c31:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801c38:	a8 01                	test   $0x1,%al
  801c3a:	74 10                	je     801c4c <read_map+0x79>
  801c3c:	89 d8                	mov    %ebx,%eax
  801c3e:	c1 e8 0c             	shr    $0xc,%eax
  801c41:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801c48:	a8 01                	test   $0x1,%al
  801c4a:	75 19                	jne    801c65 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	8d 46 01             	lea    0x1(%esi),%eax
  801c52:	50                   	push   %eax
  801c53:	56                   	push   %esi
  801c54:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801c57:	e8 fb 01 00 00       	call   801e57 <fmap>
  801c5c:	83 c4 10             	add    $0x10,%esp
            return r;
  801c5f:	89 c2                	mov    %eax,%edx
  801c61:	85 c0                	test   %eax,%eax
  801c63:	78 31                	js     801c96 <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801c65:	89 d8                	mov    %ebx,%eax
  801c67:	c1 e8 16             	shr    $0x16,%eax
  801c6a:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801c71:	a8 01                	test   $0x1,%al
  801c73:	74 10                	je     801c85 <read_map+0xb2>
  801c75:	89 d8                	mov    %ebx,%eax
  801c77:	c1 e8 0c             	shr    $0xc,%eax
  801c7a:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801c81:	a8 01                	test   $0x1,%al
  801c83:	75 07                	jne    801c8c <read_map+0xb9>
		return -E_NO_DISK;
  801c85:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801c8a:	eb 0a                	jmp    801c96 <read_map+0xc3>

	*blk = (void*) va;
  801c8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8f:	89 18                	mov    %ebx,(%eax)
	return 0;
  801c91:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801c96:	89 d0                	mov    %edx,%eax
  801c98:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	57                   	push   %edi
  801ca3:	56                   	push   %esi
  801ca4:	53                   	push   %ebx
  801ca5:	83 ec 0c             	sub    $0xc,%esp
  801ca8:	8b 75 08             	mov    0x8(%ebp),%esi
  801cab:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801cae:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb1:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801cb4:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801cb9:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801cbf:	0f 87 bd 00 00 00    	ja     801d82 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801cc5:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801ccb:	73 17                	jae    801ce4 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801ccd:	83 ec 08             	sub    $0x8,%esp
  801cd0:	52                   	push   %edx
  801cd1:	56                   	push   %esi
  801cd2:	e8 fb 00 00 00       	call   801dd2 <file_trunc>
  801cd7:	83 c4 10             	add    $0x10,%esp
			return r;
  801cda:	89 c1                	mov    %eax,%ecx
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	0f 88 9e 00 00 00    	js     801d82 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801ce4:	83 ec 0c             	sub    $0xc,%esp
  801ce7:	56                   	push   %esi
  801ce8:	e8 db f7 ff ff       	call   8014c8 <fd2data>
  801ced:	89 c3                	mov    %eax,%ebx
  801cef:	01 fb                	add    %edi,%ebx
  801cf1:	83 c4 10             	add    $0x10,%esp
  801cf4:	eb 42                	jmp    801d38 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801cf6:	89 d8                	mov    %ebx,%eax
  801cf8:	c1 e8 16             	shr    $0x16,%eax
  801cfb:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801d02:	a8 01                	test   $0x1,%al
  801d04:	74 10                	je     801d16 <file_write+0x77>
  801d06:	89 d8                	mov    %ebx,%eax
  801d08:	c1 e8 0c             	shr    $0xc,%eax
  801d0b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801d12:	a8 01                	test   $0x1,%al
  801d14:	75 1c                	jne    801d32 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801d16:	83 ec 04             	sub    $0x4,%esp
  801d19:	8b 55 10             	mov    0x10(%ebp),%edx
  801d1c:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801d1f:	50                   	push   %eax
  801d20:	57                   	push   %edi
  801d21:	56                   	push   %esi
  801d22:	e8 30 01 00 00       	call   801e57 <fmap>
  801d27:	83 c4 10             	add    $0x10,%esp
              return r;
  801d2a:	89 c1                	mov    %eax,%ecx
  801d2c:	85 c0                	test   %eax,%eax
  801d2e:	78 52                	js     801d82 <file_write+0xe3>
  801d30:	eb 1b                	jmp    801d4d <file_write+0xae>
  801d32:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	56                   	push   %esi
  801d3c:	e8 87 f7 ff ff       	call   8014c8 <fd2data>
  801d41:	01 f8                	add    %edi,%eax
  801d43:	03 45 10             	add    0x10(%ebp),%eax
  801d46:	83 c4 10             	add    $0x10,%esp
  801d49:	39 d8                	cmp    %ebx,%eax
  801d4b:	77 a9                	ja     801cf6 <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801d4d:	83 ec 0c             	sub    $0xc,%esp
  801d50:	68 7e 30 80 00       	push   $0x80307e
  801d55:	e8 e2 e5 ff ff       	call   80033c <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801d5a:	83 c4 0c             	add    $0xc,%esp
  801d5d:	ff 75 10             	pushl  0x10(%ebp)
  801d60:	ff 75 0c             	pushl  0xc(%ebp)
  801d63:	56                   	push   %esi
  801d64:	e8 5f f7 ff ff       	call   8014c8 <fd2data>
  801d69:	01 f8                	add    %edi,%eax
  801d6b:	89 04 24             	mov    %eax,(%esp)
  801d6e:	e8 49 ed ff ff       	call   800abc <memmove>
        cprintf("write done\n");
  801d73:	c7 04 24 8b 30 80 00 	movl   $0x80308b,(%esp)
  801d7a:	e8 bd e5 ff ff       	call   80033c <cprintf>
	return n;
  801d7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801d82:	89 c8                	mov    %ecx,%eax
  801d84:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d87:	5b                   	pop    %ebx
  801d88:	5e                   	pop    %esi
  801d89:	5f                   	pop    %edi
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	56                   	push   %esi
  801d90:	53                   	push   %ebx
  801d91:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d94:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801d97:	83 ec 08             	sub    $0x8,%esp
  801d9a:	8d 43 10             	lea    0x10(%ebx),%eax
  801d9d:	50                   	push   %eax
  801d9e:	56                   	push   %esi
  801d9f:	e8 9c eb ff ff       	call   800940 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801da4:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801daa:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801db0:	83 c4 10             	add    $0x10,%esp
  801db3:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801dba:	0f 94 c0             	sete   %al
  801dbd:	0f b6 c0             	movzbl %al,%eax
  801dc0:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801dc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcb:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801dce:	5b                   	pop    %ebx
  801dcf:	5e                   	pop    %esi
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	57                   	push   %edi
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 0c             	sub    $0xc,%esp
  801ddb:	8b 75 08             	mov    0x8(%ebp),%esi
  801dde:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801de1:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801de6:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801dec:	7f 5f                	jg     801e4d <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801dee:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801df4:	83 ec 08             	sub    $0x8,%esp
  801df7:	53                   	push   %ebx
  801df8:	ff 76 0c             	pushl  0xc(%esi)
  801dfb:	e8 3a 02 00 00       	call   80203a <fsipc_set_size>
  801e00:	83 c4 10             	add    $0x10,%esp
		return r;
  801e03:	89 c2                	mov    %eax,%edx
  801e05:	85 c0                	test   %eax,%eax
  801e07:	78 44                	js     801e4d <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801e09:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801e0f:	74 19                	je     801e2a <file_trunc+0x58>
  801e11:	68 b8 30 80 00       	push   $0x8030b8
  801e16:	68 97 30 80 00       	push   $0x803097
  801e1b:	68 dc 00 00 00       	push   $0xdc
  801e20:	68 ac 30 80 00       	push   $0x8030ac
  801e25:	e8 22 e4 ff ff       	call   80024c <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801e2a:	83 ec 04             	sub    $0x4,%esp
  801e2d:	53                   	push   %ebx
  801e2e:	57                   	push   %edi
  801e2f:	56                   	push   %esi
  801e30:	e8 22 00 00 00       	call   801e57 <fmap>
  801e35:	83 c4 10             	add    $0x10,%esp
		return r;
  801e38:	89 c2                	mov    %eax,%edx
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	78 0f                	js     801e4d <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	53                   	push   %ebx
  801e41:	57                   	push   %edi
  801e42:	56                   	push   %esi
  801e43:	e8 85 00 00 00       	call   801ecd <funmap>

	return 0;
  801e48:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801e4d:	89 d0                	mov    %edx,%eax
  801e4f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801e52:	5b                   	pop    %ebx
  801e53:	5e                   	pop    %esi
  801e54:	5f                   	pop    %edi
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <fmap>:

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
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	57                   	push   %edi
  801e5b:	56                   	push   %esi
  801e5c:	53                   	push   %ebx
  801e5d:	83 ec 0c             	sub    $0xc,%esp
  801e60:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e63:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801e66:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801e69:	7d 55                	jge    801ec0 <fmap+0x69>
          fma = fd2data(fd);
  801e6b:	83 ec 0c             	sub    $0xc,%esp
  801e6e:	57                   	push   %edi
  801e6f:	e8 54 f6 ff ff       	call   8014c8 <fd2data>
  801e74:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801e77:	83 c4 10             	add    $0x10,%esp
  801e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7d:	05 ff 0f 00 00       	add    $0xfff,%eax
  801e82:	89 c3                	mov    %eax,%ebx
  801e84:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801e8a:	39 f3                	cmp    %esi,%ebx
  801e8c:	7d 32                	jge    801ec0 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801e8e:	83 ec 04             	sub    $0x4,%esp
  801e91:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801e94:	01 d8                	add    %ebx,%eax
  801e96:	50                   	push   %eax
  801e97:	53                   	push   %ebx
  801e98:	ff 77 0c             	pushl  0xc(%edi)
  801e9b:	e8 6f 01 00 00       	call   80200f <fsipc_map>
  801ea0:	83 c4 10             	add    $0x10,%esp
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	79 0f                	jns    801eb6 <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	ff 75 0c             	pushl  0xc(%ebp)
  801eac:	53                   	push   %ebx
  801ead:	57                   	push   %edi
  801eae:	e8 1a 00 00 00       	call   801ecd <funmap>
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ebc:	39 f3                	cmp    %esi,%ebx
  801ebe:	7c ce                	jl     801e8e <fmap+0x37>
            }
          }
        }

        return 0;
}
  801ec0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801ec8:	5b                   	pop    %ebx
  801ec9:	5e                   	pop    %esi
  801eca:	5f                   	pop    %edi
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <funmap>:

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
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	57                   	push   %edi
  801ed1:	56                   	push   %esi
  801ed2:	53                   	push   %ebx
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ed9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801edc:	39 f3                	cmp    %esi,%ebx
  801ede:	0f 8d 80 00 00 00    	jge    801f64 <funmap+0x97>
          fma = fd2data(fd);
  801ee4:	83 ec 0c             	sub    $0xc,%esp
  801ee7:	ff 75 08             	pushl  0x8(%ebp)
  801eea:	e8 d9 f5 ff ff       	call   8014c8 <fd2data>
  801eef:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801ef1:	83 c4 10             	add    $0x10,%esp
  801ef4:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801efa:	89 c3                	mov    %eax,%ebx
  801efc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801f02:	39 f3                	cmp    %esi,%ebx
  801f04:	7d 5e                	jge    801f64 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801f06:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801f09:	89 c2                	mov    %eax,%edx
  801f0b:	c1 ea 0c             	shr    $0xc,%edx
  801f0e:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801f15:	a8 01                	test   $0x1,%al
  801f17:	74 41                	je     801f5a <funmap+0x8d>
              if (dirty) {
  801f19:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801f1d:	74 21                	je     801f40 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801f1f:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801f26:	a8 40                	test   $0x40,%al
  801f28:	74 16                	je     801f40 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801f2a:	83 ec 08             	sub    $0x8,%esp
  801f2d:	53                   	push   %ebx
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	ff 70 0c             	pushl  0xc(%eax)
  801f34:	e8 49 01 00 00       	call   802082 <fsipc_dirty>
  801f39:	83 c4 10             	add    $0x10,%esp
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	78 29                	js     801f69 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801f40:	83 ec 08             	sub    $0x8,%esp
  801f43:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801f46:	50                   	push   %eax
  801f47:	83 ec 04             	sub    $0x4,%esp
  801f4a:	e8 85 ed ff ff       	call   800cd4 <sys_getenvid>
  801f4f:	89 04 24             	mov    %eax,(%esp)
  801f52:	e8 40 ee ff ff       	call   800d97 <sys_page_unmap>
  801f57:	83 c4 10             	add    $0x10,%esp
  801f5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f60:	39 f3                	cmp    %esi,%ebx
  801f62:	7c a2                	jl     801f06 <funmap+0x39>
            }
          }
        }

        return 0;
  801f64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f69:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801f6c:	5b                   	pop    %ebx
  801f6d:	5e                   	pop    %esi
  801f6e:	5f                   	pop    %edi
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <remove>:

// Delete a file
int
remove(const char *path)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801f77:	ff 75 08             	pushl  0x8(%ebp)
  801f7a:	e8 2b 01 00 00       	call   8020aa <fsipc_remove>
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801f87:	e8 64 01 00 00       	call   8020f0 <fsipc_sync>
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    
	...

00801f90 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801f96:	6a 07                	push   $0x7
  801f98:	ff 75 0c             	pushl  0xc(%ebp)
  801f9b:	ff 75 08             	pushl  0x8(%ebp)
  801f9e:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801fa3:	50                   	push   %eax
  801fa4:	e8 c6 f4 ff ff       	call   80146f <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801fa9:	83 c4 0c             	add    $0xc,%esp
  801fac:	ff 75 14             	pushl  0x14(%ebp)
  801faf:	ff 75 10             	pushl  0x10(%ebp)
  801fb2:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801fb5:	50                   	push   %eax
  801fb6:	e8 51 f4 ff ff       	call   80140c <ipc_recv>
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	56                   	push   %esi
  801fc1:	53                   	push   %ebx
  801fc2:	83 ec 1c             	sub    $0x1c,%esp
  801fc5:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801fc8:	bb 00 40 80 00       	mov    $0x804000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801fcd:	56                   	push   %esi
  801fce:	e8 31 e9 ff ff       	call   800904 <strlen>
  801fd3:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801fd6:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801fdb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fe0:	7f 24                	jg     802006 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801fe2:	83 ec 08             	sub    $0x8,%esp
  801fe5:	56                   	push   %esi
  801fe6:	53                   	push   %ebx
  801fe7:	e8 54 e9 ff ff       	call   800940 <strcpy>
	req->req_omode = omode;
  801fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fef:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801ff5:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801ff8:	50                   	push   %eax
  801ff9:	ff 75 10             	pushl  0x10(%ebp)
  801ffc:	53                   	push   %ebx
  801ffd:	6a 01                	push   $0x1
  801fff:	e8 8c ff ff ff       	call   801f90 <fsipc>
  802004:	89 c2                	mov    %eax,%edx
}
  802006:	89 d0                	mov    %edx,%eax
  802008:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80200b:	5b                   	pop    %ebx
  80200c:	5e                   	pop    %esi
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  80201d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802020:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  802025:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802028:	50                   	push   %eax
  802029:	ff 75 10             	pushl  0x10(%ebp)
  80202c:	68 00 40 80 00       	push   $0x804000
  802031:	6a 02                	push   $0x2
  802033:	e8 58 ff ff ff       	call   801f90 <fsipc>

	//return -E_UNSPECIFIED;
}
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	a3 00 40 80 00       	mov    %eax,0x804000
	req->req_size = size;
  802048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204b:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	68 00 40 80 00       	push   $0x804000
  802059:	6a 03                	push   $0x3
  80205b:	e8 30 ff ff ff       	call   801f90 <fsipc>
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  802068:	8b 45 08             	mov    0x8(%ebp),%eax
  80206b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	68 00 40 80 00       	push   $0x804000
  802079:	6a 04                	push   $0x4
  80207b:	e8 10 ff ff ff       	call   801f90 <fsipc>
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  802090:	8b 45 0c             	mov    0xc(%ebp),%eax
  802093:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	68 00 40 80 00       	push   $0x804000
  8020a1:	6a 05                	push   $0x5
  8020a3:	e8 e8 fe ff ff       	call   801f90 <fsipc>
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	56                   	push   %esi
  8020ae:	53                   	push   %ebx
  8020af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  8020b2:	be 00 40 80 00       	mov    $0x804000,%esi
	if (strlen(path) >= MAXPATHLEN)
  8020b7:	83 ec 0c             	sub    $0xc,%esp
  8020ba:	53                   	push   %ebx
  8020bb:	e8 44 e8 ff ff       	call   800904 <strlen>
  8020c0:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  8020c3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8020c8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020cd:	7f 18                	jg     8020e7 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  8020cf:	83 ec 08             	sub    $0x8,%esp
  8020d2:	53                   	push   %ebx
  8020d3:	56                   	push   %esi
  8020d4:	e8 67 e8 ff ff       	call   800940 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	56                   	push   %esi
  8020de:	6a 06                	push   $0x6
  8020e0:	e8 ab fe ff ff       	call   801f90 <fsipc>
  8020e5:	89 c2                	mov    %eax,%edx
}
  8020e7:	89 d0                	mov    %edx,%eax
  8020e9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8020ec:	5b                   	pop    %ebx
  8020ed:	5e                   	pop    %esi
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	68 00 40 80 00       	push   $0x804000
  8020ff:	6a 07                	push   $0x7
  802101:	e8 8a fe ff ff       	call   801f90 <fsipc>
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80210e:	89 c8                	mov    %ecx,%eax
  802110:	c1 e8 16             	shr    $0x16,%eax
  802113:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  80211a:	ba 00 00 00 00       	mov    $0x0,%edx
  80211f:	a8 01                	test   $0x1,%al
  802121:	74 28                	je     80214b <pageref+0x43>
	pte = vpt[VPN(v)];
  802123:	89 c8                	mov    %ecx,%eax
  802125:	c1 e8 0c             	shr    $0xc,%eax
  802128:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  80212f:	ba 00 00 00 00       	mov    $0x0,%edx
  802134:	a8 01                	test   $0x1,%al
  802136:	74 13                	je     80214b <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  802138:	c1 e8 0c             	shr    $0xc,%eax
  80213b:	8d 04 40             	lea    (%eax,%eax,2),%eax
  80213e:	c1 e0 02             	shl    $0x2,%eax
  802141:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802148:	0f b7 d0             	movzwl %ax,%edx
}
  80214b:	89 d0                	mov    %edx,%eax
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    
	...

00802150 <pipe>:
};

int
pipe(int pfd[2])
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	57                   	push   %edi
  802154:	56                   	push   %esi
  802155:	53                   	push   %ebx
  802156:	83 ec 18             	sub    $0x18,%esp
  802159:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80215c:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80215f:	50                   	push   %eax
  802160:	e8 8b f3 ff ff       	call   8014f0 <fd_alloc>
  802165:	89 c3                	mov    %eax,%ebx
  802167:	83 c4 10             	add    $0x10,%esp
  80216a:	85 c0                	test   %eax,%eax
  80216c:	0f 88 25 01 00 00    	js     802297 <pipe+0x147>
  802172:	83 ec 04             	sub    $0x4,%esp
  802175:	68 07 04 00 00       	push   $0x407
  80217a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80217d:	6a 00                	push   $0x0
  80217f:	e8 8e eb ff ff       	call   800d12 <sys_page_alloc>
  802184:	89 c3                	mov    %eax,%ebx
  802186:	83 c4 10             	add    $0x10,%esp
  802189:	85 c0                	test   %eax,%eax
  80218b:	0f 88 06 01 00 00    	js     802297 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802191:	83 ec 0c             	sub    $0xc,%esp
  802194:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  802197:	50                   	push   %eax
  802198:	e8 53 f3 ff ff       	call   8014f0 <fd_alloc>
  80219d:	89 c3                	mov    %eax,%ebx
  80219f:	83 c4 10             	add    $0x10,%esp
  8021a2:	85 c0                	test   %eax,%eax
  8021a4:	0f 88 dd 00 00 00    	js     802287 <pipe+0x137>
  8021aa:	83 ec 04             	sub    $0x4,%esp
  8021ad:	68 07 04 00 00       	push   $0x407
  8021b2:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8021b5:	6a 00                	push   $0x0
  8021b7:	e8 56 eb ff ff       	call   800d12 <sys_page_alloc>
  8021bc:	89 c3                	mov    %eax,%ebx
  8021be:	83 c4 10             	add    $0x10,%esp
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	0f 88 be 00 00 00    	js     802287 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8021c9:	83 ec 0c             	sub    $0xc,%esp
  8021cc:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8021cf:	e8 f4 f2 ff ff       	call   8014c8 <fd2data>
  8021d4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021d6:	83 c4 0c             	add    $0xc,%esp
  8021d9:	68 07 04 00 00       	push   $0x407
  8021de:	50                   	push   %eax
  8021df:	6a 00                	push   $0x0
  8021e1:	e8 2c eb ff ff       	call   800d12 <sys_page_alloc>
  8021e6:	89 c3                	mov    %eax,%ebx
  8021e8:	83 c4 10             	add    $0x10,%esp
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	0f 88 84 00 00 00    	js     802277 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021f3:	83 ec 0c             	sub    $0xc,%esp
  8021f6:	68 07 04 00 00       	push   $0x407
  8021fb:	83 ec 0c             	sub    $0xc,%esp
  8021fe:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802201:	e8 c2 f2 ff ff       	call   8014c8 <fd2data>
  802206:	83 c4 10             	add    $0x10,%esp
  802209:	50                   	push   %eax
  80220a:	6a 00                	push   $0x0
  80220c:	56                   	push   %esi
  80220d:	6a 00                	push   $0x0
  80220f:	e8 41 eb ff ff       	call   800d55 <sys_page_map>
  802214:	89 c3                	mov    %eax,%ebx
  802216:	83 c4 20             	add    $0x20,%esp
  802219:	85 c0                	test   %eax,%eax
  80221b:	78 4c                	js     802269 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80221d:	8b 15 40 70 80 00    	mov    0x807040,%edx
  802223:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802226:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802228:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80222b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802232:	8b 15 40 70 80 00    	mov    0x807040,%edx
  802238:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80223b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80223d:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802240:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802247:	83 ec 0c             	sub    $0xc,%esp
  80224a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80224d:	e8 8e f2 ff ff       	call   8014e0 <fd2num>
  802252:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802254:	83 c4 04             	add    $0x4,%esp
  802257:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80225a:	e8 81 f2 ff ff       	call   8014e0 <fd2num>
  80225f:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  802262:	b8 00 00 00 00       	mov    $0x0,%eax
  802267:	eb 30                	jmp    802299 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  802269:	83 ec 08             	sub    $0x8,%esp
  80226c:	56                   	push   %esi
  80226d:	6a 00                	push   $0x0
  80226f:	e8 23 eb ff ff       	call   800d97 <sys_page_unmap>
  802274:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  802277:	83 ec 08             	sub    $0x8,%esp
  80227a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80227d:	6a 00                	push   $0x0
  80227f:	e8 13 eb ff ff       	call   800d97 <sys_page_unmap>
  802284:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  802287:	83 ec 08             	sub    $0x8,%esp
  80228a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80228d:	6a 00                	push   $0x0
  80228f:	e8 03 eb ff ff       	call   800d97 <sys_page_unmap>
  802294:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  802297:	89 d8                	mov    %ebx,%eax
}
  802299:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80229c:	5b                   	pop    %ebx
  80229d:	5e                   	pop    %esi
  80229e:	5f                   	pop    %edi
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	57                   	push   %edi
  8022a5:	56                   	push   %esi
  8022a6:	53                   	push   %ebx
  8022a7:	83 ec 0c             	sub    $0xc,%esp
  8022aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8022ad:	a1 80 70 80 00       	mov    0x807080,%eax
  8022b2:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  8022b5:	83 ec 0c             	sub    $0xc,%esp
  8022b8:	ff 75 08             	pushl  0x8(%ebp)
  8022bb:	e8 48 fe ff ff       	call   802108 <pageref>
  8022c0:	89 c3                	mov    %eax,%ebx
  8022c2:	89 3c 24             	mov    %edi,(%esp)
  8022c5:	e8 3e fe ff ff       	call   802108 <pageref>
  8022ca:	83 c4 10             	add    $0x10,%esp
  8022cd:	39 c3                	cmp    %eax,%ebx
  8022cf:	0f 94 c0             	sete   %al
  8022d2:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  8022d5:	8b 0d 80 70 80 00    	mov    0x807080,%ecx
  8022db:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  8022de:	39 c6                	cmp    %eax,%esi
  8022e0:	74 1b                	je     8022fd <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  8022e2:	83 fa 01             	cmp    $0x1,%edx
  8022e5:	75 c6                	jne    8022ad <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8022e7:	6a 01                	push   $0x1
  8022e9:	8b 41 58             	mov    0x58(%ecx),%eax
  8022ec:	50                   	push   %eax
  8022ed:	56                   	push   %esi
  8022ee:	68 e0 30 80 00       	push   $0x8030e0
  8022f3:	e8 44 e0 ff ff       	call   80033c <cprintf>
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	eb b0                	jmp    8022ad <_pipeisclosed+0xc>
	}
}
  8022fd:	89 d0                	mov    %edx,%eax
  8022ff:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802302:	5b                   	pop    %ebx
  802303:	5e                   	pop    %esi
  802304:	5f                   	pop    %edi
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
  80230a:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80230d:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802310:	50                   	push   %eax
  802311:	ff 75 08             	pushl  0x8(%ebp)
  802314:	e8 31 f2 ff ff       	call   80154a <fd_lookup>
  802319:	83 c4 10             	add    $0x10,%esp
		return r;
  80231c:	89 c2                	mov    %eax,%edx
  80231e:	85 c0                	test   %eax,%eax
  802320:	78 19                	js     80233b <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  802322:	83 ec 0c             	sub    $0xc,%esp
  802325:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802328:	e8 9b f1 ff ff       	call   8014c8 <fd2data>
	return _pipeisclosed(fd, p);
  80232d:	83 c4 08             	add    $0x8,%esp
  802330:	50                   	push   %eax
  802331:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802334:	e8 68 ff ff ff       	call   8022a1 <_pipeisclosed>
  802339:	89 c2                	mov    %eax,%edx
}
  80233b:	89 d0                	mov    %edx,%eax
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	57                   	push   %edi
  802343:	56                   	push   %esi
  802344:	53                   	push   %ebx
  802345:	83 ec 18             	sub    $0x18,%esp
  802348:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  80234b:	57                   	push   %edi
  80234c:	e8 77 f1 ff ff       	call   8014c8 <fd2data>
  802351:	89 c3                	mov    %eax,%ebx
	if (debug)
  802353:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802356:	8b 45 0c             	mov    0xc(%ebp),%eax
  802359:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80235c:	be 00 00 00 00       	mov    $0x0,%esi
  802361:	3b 75 10             	cmp    0x10(%ebp),%esi
  802364:	73 55                	jae    8023bb <piperead+0x7c>
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
  802366:	8b 03                	mov    (%ebx),%eax
  802368:	3b 43 04             	cmp    0x4(%ebx),%eax
  80236b:	75 2c                	jne    802399 <piperead+0x5a>
  80236d:	85 f6                	test   %esi,%esi
  80236f:	74 04                	je     802375 <piperead+0x36>
  802371:	89 f0                	mov    %esi,%eax
  802373:	eb 48                	jmp    8023bd <piperead+0x7e>
  802375:	83 ec 08             	sub    $0x8,%esp
  802378:	53                   	push   %ebx
  802379:	57                   	push   %edi
  80237a:	e8 22 ff ff ff       	call   8022a1 <_pipeisclosed>
  80237f:	83 c4 10             	add    $0x10,%esp
  802382:	85 c0                	test   %eax,%eax
  802384:	74 07                	je     80238d <piperead+0x4e>
  802386:	b8 00 00 00 00       	mov    $0x0,%eax
  80238b:	eb 30                	jmp    8023bd <piperead+0x7e>
  80238d:	e8 61 e9 ff ff       	call   800cf3 <sys_yield>
  802392:	8b 03                	mov    (%ebx),%eax
  802394:	3b 43 04             	cmp    0x4(%ebx),%eax
  802397:	74 d4                	je     80236d <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802399:	8b 13                	mov    (%ebx),%edx
  80239b:	89 d0                	mov    %edx,%eax
  80239d:	85 d2                	test   %edx,%edx
  80239f:	79 03                	jns    8023a4 <piperead+0x65>
  8023a1:	8d 42 1f             	lea    0x1f(%edx),%eax
  8023a4:	83 e0 e0             	and    $0xffffffe0,%eax
  8023a7:	29 c2                	sub    %eax,%edx
  8023a9:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  8023ad:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8023b0:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8023b3:	ff 03                	incl   (%ebx)
  8023b5:	46                   	inc    %esi
  8023b6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023b9:	72 ab                	jb     802366 <piperead+0x27>
	}
	return i;
  8023bb:	89 f0                	mov    %esi,%eax
}
  8023bd:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8023c0:	5b                   	pop    %ebx
  8023c1:	5e                   	pop    %esi
  8023c2:	5f                   	pop    %edi
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	57                   	push   %edi
  8023c9:	56                   	push   %esi
  8023ca:	53                   	push   %ebx
  8023cb:	83 ec 18             	sub    $0x18,%esp
  8023ce:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  8023d1:	57                   	push   %edi
  8023d2:	e8 f1 f0 ff ff       	call   8014c8 <fd2data>
  8023d7:	89 c3                	mov    %eax,%ebx
	if (debug)
  8023d9:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8023dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023df:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8023e2:	be 00 00 00 00       	mov    $0x0,%esi
  8023e7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023ea:	73 55                	jae    802441 <pipewrite+0x7c>
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
  8023ec:	8b 03                	mov    (%ebx),%eax
  8023ee:	83 c0 20             	add    $0x20,%eax
  8023f1:	39 43 04             	cmp    %eax,0x4(%ebx)
  8023f4:	72 27                	jb     80241d <pipewrite+0x58>
  8023f6:	83 ec 08             	sub    $0x8,%esp
  8023f9:	53                   	push   %ebx
  8023fa:	57                   	push   %edi
  8023fb:	e8 a1 fe ff ff       	call   8022a1 <_pipeisclosed>
  802400:	83 c4 10             	add    $0x10,%esp
  802403:	85 c0                	test   %eax,%eax
  802405:	74 07                	je     80240e <pipewrite+0x49>
  802407:	b8 00 00 00 00       	mov    $0x0,%eax
  80240c:	eb 35                	jmp    802443 <pipewrite+0x7e>
  80240e:	e8 e0 e8 ff ff       	call   800cf3 <sys_yield>
  802413:	8b 03                	mov    (%ebx),%eax
  802415:	83 c0 20             	add    $0x20,%eax
  802418:	39 43 04             	cmp    %eax,0x4(%ebx)
  80241b:	73 d9                	jae    8023f6 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80241d:	8b 53 04             	mov    0x4(%ebx),%edx
  802420:	89 d0                	mov    %edx,%eax
  802422:	85 d2                	test   %edx,%edx
  802424:	79 03                	jns    802429 <pipewrite+0x64>
  802426:	8d 42 1f             	lea    0x1f(%edx),%eax
  802429:	83 e0 e0             	and    $0xffffffe0,%eax
  80242c:	29 c2                	sub    %eax,%edx
  80242e:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  802431:	8a 04 31             	mov    (%ecx,%esi,1),%al
  802434:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802438:	ff 43 04             	incl   0x4(%ebx)
  80243b:	46                   	inc    %esi
  80243c:	3b 75 10             	cmp    0x10(%ebp),%esi
  80243f:	72 ab                	jb     8023ec <pipewrite+0x27>
	}
	
	return i;
  802441:	89 f0                	mov    %esi,%eax
}
  802443:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802446:	5b                   	pop    %ebx
  802447:	5e                   	pop    %esi
  802448:	5f                   	pop    %edi
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	56                   	push   %esi
  80244f:	53                   	push   %ebx
  802450:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	ff 75 08             	pushl  0x8(%ebp)
  802459:	e8 6a f0 ff ff       	call   8014c8 <fd2data>
  80245e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802460:	83 c4 08             	add    $0x8,%esp
  802463:	68 f3 30 80 00       	push   $0x8030f3
  802468:	53                   	push   %ebx
  802469:	e8 d2 e4 ff ff       	call   800940 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80246e:	8b 46 04             	mov    0x4(%esi),%eax
  802471:	2b 06                	sub    (%esi),%eax
  802473:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802479:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802480:	00 00 00 
	stat->st_dev = &devpipe;
  802483:	c7 83 88 00 00 00 40 	movl   $0x807040,0x88(%ebx)
  80248a:	70 80 00 
	return 0;
}
  80248d:	b8 00 00 00 00       	mov    $0x0,%eax
  802492:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802495:	5b                   	pop    %ebx
  802496:	5e                   	pop    %esi
  802497:	c9                   	leave  
  802498:	c3                   	ret    

00802499 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
  80249c:	53                   	push   %ebx
  80249d:	83 ec 0c             	sub    $0xc,%esp
  8024a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024a3:	53                   	push   %ebx
  8024a4:	6a 00                	push   $0x0
  8024a6:	e8 ec e8 ff ff       	call   800d97 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024ab:	89 1c 24             	mov    %ebx,(%esp)
  8024ae:	e8 15 f0 ff ff       	call   8014c8 <fd2data>
  8024b3:	83 c4 08             	add    $0x8,%esp
  8024b6:	50                   	push   %eax
  8024b7:	6a 00                	push   $0x0
  8024b9:	e8 d9 e8 ff ff       	call   800d97 <sys_page_unmap>
}
  8024be:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    
	...

008024c4 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8024d0:	6a 01                	push   $0x1
  8024d2:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8024d5:	50                   	push   %eax
  8024d6:	e8 75 e7 ff ff       	call   800c50 <sys_cputs>
}
  8024db:	c9                   	leave  
  8024dc:	c3                   	ret    

008024dd <getchar>:

int
getchar(void)
{
  8024dd:	55                   	push   %ebp
  8024de:	89 e5                	mov    %esp,%ebp
  8024e0:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8024e3:	6a 01                	push   $0x1
  8024e5:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  8024e8:	50                   	push   %eax
  8024e9:	6a 00                	push   $0x0
  8024eb:	e8 ed f2 ff ff       	call   8017dd <read>
	if (r < 0)
  8024f0:	83 c4 10             	add    $0x10,%esp
		return r;
  8024f3:	89 c2                	mov    %eax,%edx
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	78 0d                	js     802506 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  8024f9:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  8024fe:	85 c0                	test   %eax,%eax
  802500:	7e 04                	jle    802506 <getchar+0x29>
	return c;
  802502:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  802506:	89 d0                	mov    %edx,%eax
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <iscons>:


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
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802510:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802513:	50                   	push   %eax
  802514:	ff 75 08             	pushl  0x8(%ebp)
  802517:	e8 2e f0 ff ff       	call   80154a <fd_lookup>
  80251c:	83 c4 10             	add    $0x10,%esp
		return r;
  80251f:	89 c2                	mov    %eax,%edx
  802521:	85 c0                	test   %eax,%eax
  802523:	78 11                	js     802536 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  802525:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802528:	8b 00                	mov    (%eax),%eax
  80252a:	3b 05 60 70 80 00    	cmp    0x807060,%eax
  802530:	0f 94 c0             	sete   %al
  802533:	0f b6 d0             	movzbl %al,%edx
}
  802536:	89 d0                	mov    %edx,%eax
  802538:	c9                   	leave  
  802539:	c3                   	ret    

0080253a <opencons>:

int
opencons(void)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802540:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802543:	50                   	push   %eax
  802544:	e8 a7 ef ff ff       	call   8014f0 <fd_alloc>
  802549:	83 c4 10             	add    $0x10,%esp
		return r;
  80254c:	89 c2                	mov    %eax,%edx
  80254e:	85 c0                	test   %eax,%eax
  802550:	78 3c                	js     80258e <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802552:	83 ec 04             	sub    $0x4,%esp
  802555:	68 07 04 00 00       	push   $0x407
  80255a:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80255d:	6a 00                	push   $0x0
  80255f:	e8 ae e7 ff ff       	call   800d12 <sys_page_alloc>
  802564:	83 c4 10             	add    $0x10,%esp
		return r;
  802567:	89 c2                	mov    %eax,%edx
  802569:	85 c0                	test   %eax,%eax
  80256b:	78 21                	js     80258e <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  80256d:	a1 60 70 80 00       	mov    0x807060,%eax
  802572:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  802575:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  802577:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  80257a:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802581:	83 ec 0c             	sub    $0xc,%esp
  802584:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802587:	e8 54 ef ff ff       	call   8014e0 <fd2num>
  80258c:	89 c2                	mov    %eax,%edx
}
  80258e:	89 d0                	mov    %edx,%eax
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  802598:	b8 00 00 00 00       	mov    $0x0,%eax
  80259d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025a1:	74 2a                	je     8025cd <cons_read+0x3b>
  8025a3:	eb 05                	jmp    8025aa <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8025a5:	e8 49 e7 ff ff       	call   800cf3 <sys_yield>
  8025aa:	e8 c5 e6 ff ff       	call   800c74 <sys_cgetc>
  8025af:	89 c2                	mov    %eax,%edx
  8025b1:	85 c0                	test   %eax,%eax
  8025b3:	74 f0                	je     8025a5 <cons_read+0x13>
	if (c < 0)
  8025b5:	85 d2                	test   %edx,%edx
  8025b7:	78 14                	js     8025cd <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8025b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025be:	83 fa 04             	cmp    $0x4,%edx
  8025c1:	74 0a                	je     8025cd <cons_read+0x3b>
	*(char*)vbuf = c;
  8025c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c6:	88 10                	mov    %dl,(%eax)
	return 1;
  8025c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	57                   	push   %edi
  8025d3:	56                   	push   %esi
  8025d4:	53                   	push   %ebx
  8025d5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  8025db:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025de:	be 00 00 00 00       	mov    $0x0,%esi
  8025e3:	39 fe                	cmp    %edi,%esi
  8025e5:	73 3d                	jae    802624 <cons_write+0x55>
		m = n - tot;
  8025e7:	89 fb                	mov    %edi,%ebx
  8025e9:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  8025eb:	83 fb 7f             	cmp    $0x7f,%ebx
  8025ee:	76 05                	jbe    8025f5 <cons_write+0x26>
			m = sizeof(buf) - 1;
  8025f0:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8025f5:	83 ec 04             	sub    $0x4,%esp
  8025f8:	53                   	push   %ebx
  8025f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025fc:	01 f0                	add    %esi,%eax
  8025fe:	50                   	push   %eax
  8025ff:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802605:	50                   	push   %eax
  802606:	e8 b1 e4 ff ff       	call   800abc <memmove>
		sys_cputs(buf, m);
  80260b:	83 c4 08             	add    $0x8,%esp
  80260e:	53                   	push   %ebx
  80260f:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802615:	50                   	push   %eax
  802616:	e8 35 e6 ff ff       	call   800c50 <sys_cputs>
  80261b:	83 c4 10             	add    $0x10,%esp
  80261e:	01 de                	add    %ebx,%esi
  802620:	39 fe                	cmp    %edi,%esi
  802622:	72 c3                	jb     8025e7 <cons_write+0x18>
	}
	return tot;
}
  802624:	89 f0                	mov    %esi,%eax
  802626:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802629:	5b                   	pop    %ebx
  80262a:	5e                   	pop    %esi
  80262b:	5f                   	pop    %edi
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <cons_close>:

int
cons_close(struct Fd *fd)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802631:	b8 00 00 00 00       	mov    $0x0,%eax
  802636:	c9                   	leave  
  802637:	c3                   	ret    

00802638 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80263e:	68 ff 30 80 00       	push   $0x8030ff
  802643:	ff 75 0c             	pushl  0xc(%ebp)
  802646:	e8 f5 e2 ff ff       	call   800940 <strcpy>
	return 0;
}
  80264b:	b8 00 00 00 00       	mov    $0x0,%eax
  802650:	c9                   	leave  
  802651:	c3                   	ret    
	...

00802654 <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
  802657:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80265a:	83 3d 88 70 80 00 00 	cmpl   $0x0,0x807088
  802661:	75 68                	jne    8026cb <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  802663:	83 ec 04             	sub    $0x4,%esp
  802666:	6a 07                	push   $0x7
  802668:	68 00 f0 bf ee       	push   $0xeebff000
  80266d:	83 ec 04             	sub    $0x4,%esp
  802670:	e8 5f e6 ff ff       	call   800cd4 <sys_getenvid>
  802675:	89 04 24             	mov    %eax,(%esp)
  802678:	e8 95 e6 ff ff       	call   800d12 <sys_page_alloc>
  80267d:	83 c4 10             	add    $0x10,%esp
  802680:	85 c0                	test   %eax,%eax
  802682:	79 14                	jns    802698 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	68 08 31 80 00       	push   $0x803108
  80268c:	6a 21                	push   $0x21
  80268e:	68 69 31 80 00       	push   $0x803169
  802693:	e8 b4 db ff ff       	call   80024c <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  802698:	83 ec 08             	sub    $0x8,%esp
  80269b:	68 d8 26 80 00       	push   $0x8026d8
  8026a0:	83 ec 04             	sub    $0x4,%esp
  8026a3:	e8 2c e6 ff ff       	call   800cd4 <sys_getenvid>
  8026a8:	89 04 24             	mov    %eax,(%esp)
  8026ab:	e8 ad e7 ff ff       	call   800e5d <sys_env_set_pgfault_upcall>
  8026b0:	83 c4 10             	add    $0x10,%esp
  8026b3:	85 c0                	test   %eax,%eax
  8026b5:	79 14                	jns    8026cb <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  8026b7:	83 ec 04             	sub    $0x4,%esp
  8026ba:	68 38 31 80 00       	push   $0x803138
  8026bf:	6a 24                	push   $0x24
  8026c1:	68 69 31 80 00       	push   $0x803169
  8026c6:	e8 81 db ff ff       	call   80024c <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	a3 88 70 80 00       	mov    %eax,0x807088
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    
  8026d5:	00 00                	add    %al,(%eax)
	...

008026d8 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8026d8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8026d9:	a1 88 70 80 00       	mov    0x807088,%eax
	call *%eax
  8026de:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8026e0:	83 c4 04             	add    $0x4,%esp
	
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
  8026e3:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  8026e7:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  8026eb:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  8026ee:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  8026f1:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  8026f4:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  8026f8:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  8026fb:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  8026ff:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  802700:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  802703:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  802704:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  802705:	c3                   	ret    
	...

00802708 <__udivdi3>:
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	57                   	push   %edi
  80270c:	56                   	push   %esi
  80270d:	83 ec 14             	sub    $0x14,%esp
  802710:	8b 55 14             	mov    0x14(%ebp),%edx
  802713:	8b 75 08             	mov    0x8(%ebp),%esi
  802716:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802719:	8b 45 10             	mov    0x10(%ebp),%eax
  80271c:	85 d2                	test   %edx,%edx
  80271e:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802721:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802724:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802727:	89 fe                	mov    %edi,%esi
  802729:	75 11                	jne    80273c <__udivdi3+0x34>
  80272b:	39 f8                	cmp    %edi,%eax
  80272d:	76 4d                	jbe    80277c <__udivdi3+0x74>
  80272f:	89 fa                	mov    %edi,%edx
  802731:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802734:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802737:	89 c7                	mov    %eax,%edi
  802739:	eb 09                	jmp    802744 <__udivdi3+0x3c>
  80273b:	90                   	nop    
  80273c:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  80273f:	76 17                	jbe    802758 <__udivdi3+0x50>
  802741:	31 ff                	xor    %edi,%edi
  802743:	90                   	nop    
  802744:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  80274b:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  80274e:	83 c4 14             	add    $0x14,%esp
  802751:	5e                   	pop    %esi
  802752:	89 f8                	mov    %edi,%eax
  802754:	5f                   	pop    %edi
  802755:	c9                   	leave  
  802756:	c3                   	ret    
  802757:	90                   	nop    
  802758:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  80275c:	89 c7                	mov    %eax,%edi
  80275e:	83 f7 1f             	xor    $0x1f,%edi
  802761:	75 4d                	jne    8027b0 <__udivdi3+0xa8>
  802763:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802766:	77 0a                	ja     802772 <__udivdi3+0x6a>
  802768:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80276b:	31 ff                	xor    %edi,%edi
  80276d:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802770:	72 d2                	jb     802744 <__udivdi3+0x3c>
  802772:	bf 01 00 00 00       	mov    $0x1,%edi
  802777:	eb cb                	jmp    802744 <__udivdi3+0x3c>
  802779:	8d 76 00             	lea    0x0(%esi),%esi
  80277c:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	75 0e                	jne    802791 <__udivdi3+0x89>
  802783:	b8 01 00 00 00       	mov    $0x1,%eax
  802788:	31 c9                	xor    %ecx,%ecx
  80278a:	31 d2                	xor    %edx,%edx
  80278c:	f7 f1                	div    %ecx
  80278e:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802791:	89 f0                	mov    %esi,%eax
  802793:	31 d2                	xor    %edx,%edx
  802795:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802798:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  80279b:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80279e:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8027a1:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8027a4:	83 c4 14             	add    $0x14,%esp
  8027a7:	89 c7                	mov    %eax,%edi
  8027a9:	5e                   	pop    %esi
  8027aa:	89 f8                	mov    %edi,%eax
  8027ac:	5f                   	pop    %edi
  8027ad:	c9                   	leave  
  8027ae:	c3                   	ret    
  8027af:	90                   	nop    
  8027b0:	b8 20 00 00 00       	mov    $0x20,%eax
  8027b5:	29 f8                	sub    %edi,%eax
  8027b7:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  8027ba:	89 f9                	mov    %edi,%ecx
  8027bc:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8027bf:	d3 e2                	shl    %cl,%edx
  8027c1:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8027c4:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8027c7:	d3 e8                	shr    %cl,%eax
  8027c9:	09 c2                	or     %eax,%edx
  8027cb:	89 f9                	mov    %edi,%ecx
  8027cd:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  8027d0:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8027d3:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8027d6:	89 f2                	mov    %esi,%edx
  8027d8:	d3 ea                	shr    %cl,%edx
  8027da:	89 f9                	mov    %edi,%ecx
  8027dc:	d3 e6                	shl    %cl,%esi
  8027de:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8027e1:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  8027e4:	d3 e8                	shr    %cl,%eax
  8027e6:	09 c6                	or     %eax,%esi
  8027e8:	89 f9                	mov    %edi,%ecx
  8027ea:	89 f0                	mov    %esi,%eax
  8027ec:	f7 75 f4             	divl   0xfffffff4(%ebp)
  8027ef:	89 d6                	mov    %edx,%esi
  8027f1:	89 c7                	mov    %eax,%edi
  8027f3:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  8027f6:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8027f9:	f7 e7                	mul    %edi
  8027fb:	39 f2                	cmp    %esi,%edx
  8027fd:	77 0f                	ja     80280e <__udivdi3+0x106>
  8027ff:	0f 85 3f ff ff ff    	jne    802744 <__udivdi3+0x3c>
  802805:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802808:	0f 86 36 ff ff ff    	jbe    802744 <__udivdi3+0x3c>
  80280e:	4f                   	dec    %edi
  80280f:	e9 30 ff ff ff       	jmp    802744 <__udivdi3+0x3c>

00802814 <__umoddi3>:
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	57                   	push   %edi
  802818:	56                   	push   %esi
  802819:	83 ec 30             	sub    $0x30,%esp
  80281c:	8b 55 14             	mov    0x14(%ebp),%edx
  80281f:	8b 45 10             	mov    0x10(%ebp),%eax
  802822:	89 d7                	mov    %edx,%edi
  802824:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  802827:	89 c6                	mov    %eax,%esi
  802829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	85 ff                	test   %edi,%edi
  802831:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802838:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80283f:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  802842:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802845:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802848:	75 3e                	jne    802888 <__umoddi3+0x74>
  80284a:	39 d6                	cmp    %edx,%esi
  80284c:	0f 86 a2 00 00 00    	jbe    8028f4 <__umoddi3+0xe0>
  802852:	f7 f6                	div    %esi
  802854:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802857:	85 c9                	test   %ecx,%ecx
  802859:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  80285c:	74 1b                	je     802879 <__umoddi3+0x65>
  80285e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802861:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802864:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80286b:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80286e:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802871:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802874:	89 10                	mov    %edx,(%eax)
  802876:	89 48 04             	mov    %ecx,0x4(%eax)
  802879:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  80287c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80287f:	83 c4 30             	add    $0x30,%esp
  802882:	5e                   	pop    %esi
  802883:	5f                   	pop    %edi
  802884:	c9                   	leave  
  802885:	c3                   	ret    
  802886:	89 f6                	mov    %esi,%esi
  802888:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  80288b:	76 1f                	jbe    8028ac <__umoddi3+0x98>
  80288d:	8b 55 08             	mov    0x8(%ebp),%edx
  802890:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802893:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802896:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802899:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80289c:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80289f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  8028a2:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8028a5:	83 c4 30             	add    $0x30,%esp
  8028a8:	5e                   	pop    %esi
  8028a9:	5f                   	pop    %edi
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    
  8028ac:	0f bd c7             	bsr    %edi,%eax
  8028af:	83 f0 1f             	xor    $0x1f,%eax
  8028b2:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  8028b5:	75 61                	jne    802918 <__umoddi3+0x104>
  8028b7:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  8028ba:	77 05                	ja     8028c1 <__umoddi3+0xad>
  8028bc:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  8028bf:	72 10                	jb     8028d1 <__umoddi3+0xbd>
  8028c1:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8028c4:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8028c7:	29 f0                	sub    %esi,%eax
  8028c9:	19 fa                	sbb    %edi,%edx
  8028cb:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8028ce:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8028d1:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8028d4:	85 d2                	test   %edx,%edx
  8028d6:	74 a1                	je     802879 <__umoddi3+0x65>
  8028d8:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8028db:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  8028de:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8028e1:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  8028e4:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8028e7:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8028ea:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8028ed:	89 01                	mov    %eax,(%ecx)
  8028ef:	89 51 04             	mov    %edx,0x4(%ecx)
  8028f2:	eb 85                	jmp    802879 <__umoddi3+0x65>
  8028f4:	85 f6                	test   %esi,%esi
  8028f6:	75 0b                	jne    802903 <__umoddi3+0xef>
  8028f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8028fd:	31 d2                	xor    %edx,%edx
  8028ff:	f7 f6                	div    %esi
  802901:	89 c6                	mov    %eax,%esi
  802903:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802906:	89 fa                	mov    %edi,%edx
  802908:	f7 f6                	div    %esi
  80290a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80290d:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802910:	f7 f6                	div    %esi
  802912:	e9 3d ff ff ff       	jmp    802854 <__umoddi3+0x40>
  802917:	90                   	nop    
  802918:	b8 20 00 00 00       	mov    $0x20,%eax
  80291d:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802920:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  802923:	89 fa                	mov    %edi,%edx
  802925:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802928:	d3 e2                	shl    %cl,%edx
  80292a:	89 f0                	mov    %esi,%eax
  80292c:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80292f:	d3 e8                	shr    %cl,%eax
  802931:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802934:	d3 e6                	shl    %cl,%esi
  802936:	89 d7                	mov    %edx,%edi
  802938:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80293b:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80293e:	09 c7                	or     %eax,%edi
  802940:	d3 ea                	shr    %cl,%edx
  802942:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802945:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802948:	d3 e0                	shl    %cl,%eax
  80294a:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80294d:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  802950:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802953:	d3 e8                	shr    %cl,%eax
  802955:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  802958:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80295b:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80295e:	f7 f7                	div    %edi
  802960:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802963:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  802966:	f7 e6                	mul    %esi
  802968:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  80296b:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  80296e:	77 0a                	ja     80297a <__umoddi3+0x166>
  802970:	75 12                	jne    802984 <__umoddi3+0x170>
  802972:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802975:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  802978:	76 0a                	jbe    802984 <__umoddi3+0x170>
  80297a:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  80297d:	29 f1                	sub    %esi,%ecx
  80297f:	19 fa                	sbb    %edi,%edx
  802981:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  802984:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	0f 84 ea fe ff ff    	je     802879 <__umoddi3+0x65>
  80298f:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802992:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802995:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  802998:	19 d1                	sbb    %edx,%ecx
  80299a:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  80299d:	89 ca                	mov    %ecx,%edx
  80299f:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8029a2:	d3 e2                	shl    %cl,%edx
  8029a4:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8029a7:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8029aa:	d3 e8                	shr    %cl,%eax
  8029ac:	09 c2                	or     %eax,%edx
  8029ae:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  8029b1:	d3 e8                	shr    %cl,%eax
  8029b3:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8029b6:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8029b9:	e9 ad fe ff ff       	jmp    80286b <__umoddi3+0x57>
