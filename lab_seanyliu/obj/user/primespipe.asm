
obj/user/primespipe:     file format elf32-i386

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
  80002c:	e8 0f 02 00 00       	call   800240 <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:
#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 1c             	sub    $0x1c,%esp
  80003d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800040:	83 ec 04             	sub    $0x4,%esp
  800043:	6a 04                	push   $0x4
  800045:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  800048:	50                   	push   %eax
  800049:	53                   	push   %ebx
  80004a:	e8 b2 17 00 00       	call   801801 <readn>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	83 f8 04             	cmp    $0x4,%eax
  800055:	74 21                	je     800078 <primeproc+0x44>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  800057:	83 ec 0c             	sub    $0xc,%esp
  80005a:	89 c2                	mov    %eax,%edx
  80005c:	85 c0                	test   %eax,%eax
  80005e:	7e 05                	jle    800065 <primeproc+0x31>
  800060:	ba 00 00 00 00       	mov    $0x0,%edx
  800065:	52                   	push   %edx
  800066:	50                   	push   %eax
  800067:	68 20 2a 80 00       	push   $0x802a20
  80006c:	6a 15                	push   $0x15
  80006e:	68 4f 2a 80 00       	push   $0x802a4f
  800073:	e8 24 02 00 00       	call   80029c <_panic>

	cprintf("%d\n", p);
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80007e:	68 61 2a 80 00       	push   $0x802a61
  800083:	e8 04 03 00 00       	call   80038c <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800088:	8d 45 e0             	lea    0xffffffe0(%ebp),%eax
  80008b:	89 04 24             	mov    %eax,(%esp)
  80008e:	e8 09 20 00 00       	call   80209c <pipe>
  800093:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	85 c0                	test   %eax,%eax
  80009b:	79 12                	jns    8000af <primeproc+0x7b>
		panic("pipe: %e", i);
  80009d:	50                   	push   %eax
  80009e:	68 65 2a 80 00       	push   $0x802a65
  8000a3:	6a 1b                	push   $0x1b
  8000a5:	68 4f 2a 80 00       	push   $0x802a4f
  8000aa:	e8 ed 01 00 00       	call   80029c <_panic>
	if ((id = fork()) < 0)
  8000af:	e8 1e 12 00 00       	call   8012d2 <fork>
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	79 12                	jns    8000ca <primeproc+0x96>
		panic("fork: %e", id);
  8000b8:	50                   	push   %eax
  8000b9:	68 6e 2a 80 00       	push   $0x802a6e
  8000be:	6a 1d                	push   $0x1d
  8000c0:	68 4f 2a 80 00       	push   $0x802a4f
  8000c5:	e8 d2 01 00 00       	call   80029c <_panic>
	if (id == 0) {
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	75 1f                	jne    8000ed <primeproc+0xb9>
		close(fd);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	53                   	push   %ebx
  8000d2:	e8 27 15 00 00       	call   8015fe <close>
		close(pfd[1]);
  8000d7:	83 c4 04             	add    $0x4,%esp
  8000da:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  8000dd:	e8 1c 15 00 00       	call   8015fe <close>
		fd = pfd[0];
  8000e2:	8b 5d e0             	mov    0xffffffe0(%ebp),%ebx
		goto top;
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	e9 53 ff ff ff       	jmp    800040 <primeproc+0xc>
	}

	close(pfd[0]);
  8000ed:	83 ec 0c             	sub    $0xc,%esp
  8000f0:	ff 75 e0             	pushl  0xffffffe0(%ebp)
  8000f3:	e8 06 15 00 00       	call   8015fe <close>
	wfd = pfd[1];
  8000f8:	8b 7d e4             	mov    0xffffffe4(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
  8000fb:	83 c4 10             	add    $0x10,%esp
  8000fe:	8d 75 dc             	lea    0xffffffdc(%ebp),%esi
		if ((r=readn(fd, &i, 4)) != 4)
  800101:	83 ec 04             	sub    $0x4,%esp
  800104:	6a 04                	push   $0x4
  800106:	56                   	push   %esi
  800107:	53                   	push   %ebx
  800108:	e8 f4 16 00 00       	call   801801 <readn>
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	83 f8 04             	cmp    $0x4,%eax
  800113:	74 25                	je     80013a <primeproc+0x106>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800115:	83 ec 04             	sub    $0x4,%esp
  800118:	89 c2                	mov    %eax,%edx
  80011a:	85 c0                	test   %eax,%eax
  80011c:	7e 05                	jle    800123 <primeproc+0xef>
  80011e:	ba 00 00 00 00       	mov    $0x0,%edx
  800123:	52                   	push   %edx
  800124:	50                   	push   %eax
  800125:	53                   	push   %ebx
  800126:	ff 75 ec             	pushl  0xffffffec(%ebp)
  800129:	68 77 2a 80 00       	push   $0x802a77
  80012e:	6a 2b                	push   $0x2b
  800130:	68 4f 2a 80 00       	push   $0x802a4f
  800135:	e8 62 01 00 00       	call   80029c <_panic>
		if (i%p)
  80013a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80013d:	99                   	cltd   
  80013e:	f7 7d ec             	idivl  0xffffffec(%ebp)
  800141:	85 d2                	test   %edx,%edx
  800143:	74 bc                	je     800101 <primeproc+0xcd>
			if ((r=write(wfd, &i, 4)) != 4)
  800145:	83 ec 04             	sub    $0x4,%esp
  800148:	6a 04                	push   $0x4
  80014a:	56                   	push   %esi
  80014b:	57                   	push   %edi
  80014c:	e8 f7 16 00 00       	call   801848 <write>
  800151:	83 c4 10             	add    $0x10,%esp
  800154:	83 f8 04             	cmp    $0x4,%eax
  800157:	74 a8                	je     800101 <primeproc+0xcd>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  800159:	83 ec 08             	sub    $0x8,%esp
  80015c:	89 c2                	mov    %eax,%edx
  80015e:	85 c0                	test   %eax,%eax
  800160:	7e 05                	jle    800167 <primeproc+0x133>
  800162:	ba 00 00 00 00       	mov    $0x0,%edx
  800167:	52                   	push   %edx
  800168:	50                   	push   %eax
  800169:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80016c:	68 93 2a 80 00       	push   $0x802a93
  800171:	6a 2e                	push   $0x2e
  800173:	68 4f 2a 80 00       	push   $0x802a4f
  800178:	e8 1f 01 00 00       	call   80029c <_panic>

0080017d <umain>:
	}
}

void
umain(void)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 24             	sub    $0x24,%esp
	int i, id, p[2], r;

	argv0 = "primespipe";
  800183:	c7 05 84 70 80 00 ad 	movl   $0x802aad,0x807084
  80018a:	2a 80 00 

	if ((i=pipe(p)) < 0)
  80018d:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  800190:	50                   	push   %eax
  800191:	e8 06 1f 00 00       	call   80209c <pipe>
  800196:	89 45 f4             	mov    %eax,0xfffffff4(%ebp)
  800199:	83 c4 10             	add    $0x10,%esp
  80019c:	85 c0                	test   %eax,%eax
  80019e:	79 12                	jns    8001b2 <umain+0x35>
		panic("pipe: %e", i);
  8001a0:	50                   	push   %eax
  8001a1:	68 65 2a 80 00       	push   $0x802a65
  8001a6:	6a 3a                	push   $0x3a
  8001a8:	68 4f 2a 80 00       	push   $0x802a4f
  8001ad:	e8 ea 00 00 00       	call   80029c <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  8001b2:	e8 1b 11 00 00       	call   8012d2 <fork>
  8001b7:	85 c0                	test   %eax,%eax
  8001b9:	79 12                	jns    8001cd <umain+0x50>
		panic("fork: %e", id);
  8001bb:	50                   	push   %eax
  8001bc:	68 6e 2a 80 00       	push   $0x802a6e
  8001c1:	6a 3e                	push   $0x3e
  8001c3:	68 4f 2a 80 00       	push   $0x802a4f
  8001c8:	e8 cf 00 00 00       	call   80029c <_panic>

	if (id == 0) {
  8001cd:	85 c0                	test   %eax,%eax
  8001cf:	75 19                	jne    8001ea <umain+0x6d>
		close(p[1]);
  8001d1:	83 ec 0c             	sub    $0xc,%esp
  8001d4:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8001d7:	e8 22 14 00 00       	call   8015fe <close>
		primeproc(p[0]);
  8001dc:	83 c4 04             	add    $0x4,%esp
  8001df:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8001e2:	e8 4d fe ff ff       	call   800034 <primeproc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	}

	close(p[0]);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8001f0:	e8 09 14 00 00       	call   8015fe <close>

	// feed all the integers through
	for (i=2;; i++)
  8001f5:	c7 45 f4 02 00 00 00 	movl   $0x2,0xfffffff4(%ebp)
  8001fc:	83 c4 10             	add    $0x10,%esp
		if ((r=write(p[1], &i, 4)) != 4)
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	6a 04                	push   $0x4
  800204:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  800207:	50                   	push   %eax
  800208:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  80020b:	e8 38 16 00 00       	call   801848 <write>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	83 f8 04             	cmp    $0x4,%eax
  800216:	74 21                	je     800239 <umain+0xbc>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	89 c2                	mov    %eax,%edx
  80021d:	85 c0                	test   %eax,%eax
  80021f:	7e 05                	jle    800226 <umain+0xa9>
  800221:	ba 00 00 00 00       	mov    $0x0,%edx
  800226:	52                   	push   %edx
  800227:	50                   	push   %eax
  800228:	68 b8 2a 80 00       	push   $0x802ab8
  80022d:	6a 4a                	push   $0x4a
  80022f:	68 4f 2a 80 00       	push   $0x802a4f
  800234:	e8 63 00 00 00       	call   80029c <_panic>
  800239:	ff 45 f4             	incl   0xfffffff4(%ebp)
  80023c:	eb c1                	jmp    8001ff <umain+0x82>
	...

00800240 <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
  800245:	8b 75 08             	mov    0x8(%ebp),%esi
  800248:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  80024b:	e8 d4 0a 00 00       	call   800d24 <sys_getenvid>
  800250:	25 ff 03 00 00       	and    $0x3ff,%eax
  800255:	c1 e0 07             	shl    $0x7,%eax
  800258:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025d:	a3 80 70 80 00       	mov    %eax,0x807080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800262:	85 f6                	test   %esi,%esi
  800264:	7e 07                	jle    80026d <libmain+0x2d>
		binaryname = argv[0];
  800266:	8b 03                	mov    (%ebx),%eax
  800268:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  80026d:	83 ec 08             	sub    $0x8,%esp
  800270:	53                   	push   %ebx
  800271:	56                   	push   %esi
  800272:	e8 06 ff ff ff       	call   80017d <umain>

	// exit gracefully
	exit();
  800277:	e8 08 00 00 00       	call   800284 <exit>
}
  80027c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80027f:	5b                   	pop    %ebx
  800280:	5e                   	pop    %esi
  800281:	c9                   	leave  
  800282:	c3                   	ret    
	...

00800284 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80028a:	e8 9d 13 00 00       	call   80162c <close_all>
	sys_env_destroy(0);
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	6a 00                	push   $0x0
  800294:	e8 4a 0a 00 00       	call   800ce3 <sys_env_destroy>
}
  800299:	c9                   	leave  
  80029a:	c3                   	ret    
	...

0080029c <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	53                   	push   %ebx
  8002a0:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  8002a3:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  8002a6:	83 3d 84 70 80 00 00 	cmpl   $0x0,0x807084
  8002ad:	74 16                	je     8002c5 <_panic+0x29>
		cprintf("%s: ", argv0);
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	ff 35 84 70 80 00    	pushl  0x807084
  8002b8:	68 e7 2a 80 00       	push   $0x802ae7
  8002bd:	e8 ca 00 00 00       	call   80038c <cprintf>
  8002c2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002c5:	ff 75 0c             	pushl  0xc(%ebp)
  8002c8:	ff 75 08             	pushl  0x8(%ebp)
  8002cb:	ff 35 00 70 80 00    	pushl  0x807000
  8002d1:	68 ec 2a 80 00       	push   $0x802aec
  8002d6:	e8 b1 00 00 00       	call   80038c <cprintf>
	vcprintf(fmt, ap);
  8002db:	83 c4 08             	add    $0x8,%esp
  8002de:	53                   	push   %ebx
  8002df:	ff 75 10             	pushl  0x10(%ebp)
  8002e2:	e8 54 00 00 00       	call   80033b <vcprintf>
	cprintf("\n");
  8002e7:	c7 04 24 63 2a 80 00 	movl   $0x802a63,(%esp)
  8002ee:	e8 99 00 00 00       	call   80038c <cprintf>

	// Cause a breakpoint exception
	while (1)
  8002f3:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  8002f6:	cc                   	int3   
  8002f7:	eb fd                	jmp    8002f6 <_panic+0x5a>
  8002f9:	00 00                	add    %al,(%eax)
	...

008002fc <putch>:


static void
putch(int ch, struct printbuf *b)
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	53                   	push   %ebx
  800300:	83 ec 04             	sub    $0x4,%esp
  800303:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800306:	8b 03                	mov    (%ebx),%eax
  800308:	8b 55 08             	mov    0x8(%ebp),%edx
  80030b:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  80030f:	40                   	inc    %eax
  800310:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800312:	3d ff 00 00 00       	cmp    $0xff,%eax
  800317:	75 1a                	jne    800333 <putch+0x37>
		sys_cputs(b->buf, b->idx);
  800319:	83 ec 08             	sub    $0x8,%esp
  80031c:	68 ff 00 00 00       	push   $0xff
  800321:	8d 43 08             	lea    0x8(%ebx),%eax
  800324:	50                   	push   %eax
  800325:	e8 76 09 00 00       	call   800ca0 <sys_cputs>
		b->idx = 0;
  80032a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800330:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  800333:	ff 43 04             	incl   0x4(%ebx)
}
  800336:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  800339:	c9                   	leave  
  80033a:	c3                   	ret    

0080033b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80033b:	55                   	push   %ebp
  80033c:	89 e5                	mov    %esp,%ebp
  80033e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800344:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  80034b:	00 00 00 
	b.cnt = 0;
  80034e:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  800355:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800358:	ff 75 0c             	pushl  0xc(%ebp)
  80035b:	ff 75 08             	pushl  0x8(%ebp)
  80035e:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  800364:	50                   	push   %eax
  800365:	68 fc 02 80 00       	push   $0x8002fc
  80036a:	e8 4f 01 00 00       	call   8004be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80036f:	83 c4 08             	add    $0x8,%esp
  800372:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  800378:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  80037e:	50                   	push   %eax
  80037f:	e8 1c 09 00 00       	call   800ca0 <sys_cputs>

	return b.cnt;
  800384:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800392:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800395:	50                   	push   %eax
  800396:	ff 75 08             	pushl  0x8(%ebp)
  800399:	e8 9d ff ff ff       	call   80033b <vcprintf>
	va_end(ap);

	return cnt;
}
  80039e:	c9                   	leave  
  80039f:	c3                   	ret    

008003a0 <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	8b 75 10             	mov    0x10(%ebp),%esi
  8003ac:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003af:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ba:	39 fa                	cmp    %edi,%edx
  8003bc:	77 39                	ja     8003f7 <printnum+0x57>
  8003be:	72 04                	jb     8003c4 <printnum+0x24>
  8003c0:	39 f0                	cmp    %esi,%eax
  8003c2:	77 33                	ja     8003f7 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c4:	83 ec 04             	sub    $0x4,%esp
  8003c7:	ff 75 20             	pushl  0x20(%ebp)
  8003ca:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  8003cd:	50                   	push   %eax
  8003ce:	ff 75 18             	pushl  0x18(%ebp)
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d9:	52                   	push   %edx
  8003da:	50                   	push   %eax
  8003db:	57                   	push   %edi
  8003dc:	56                   	push   %esi
  8003dd:	e8 76 23 00 00       	call   802758 <__udivdi3>
  8003e2:	83 c4 10             	add    $0x10,%esp
  8003e5:	52                   	push   %edx
  8003e6:	50                   	push   %eax
  8003e7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ea:	ff 75 08             	pushl  0x8(%ebp)
  8003ed:	e8 ae ff ff ff       	call   8003a0 <printnum>
  8003f2:	83 c4 20             	add    $0x20,%esp
  8003f5:	eb 19                	jmp    800410 <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f7:	4b                   	dec    %ebx
  8003f8:	85 db                	test   %ebx,%ebx
  8003fa:	7e 14                	jle    800410 <printnum+0x70>
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 0c             	pushl  0xc(%ebp)
  800402:	ff 75 20             	pushl  0x20(%ebp)
  800405:	ff 55 08             	call   *0x8(%ebp)
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	4b                   	dec    %ebx
  80040c:	85 db                	test   %ebx,%ebx
  80040e:	7f ec                	jg     8003fc <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800410:	83 ec 08             	sub    $0x8,%esp
  800413:	ff 75 0c             	pushl  0xc(%ebp)
  800416:	8b 45 18             	mov    0x18(%ebp),%eax
  800419:	ba 00 00 00 00       	mov    $0x0,%edx
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	52                   	push   %edx
  800422:	50                   	push   %eax
  800423:	57                   	push   %edi
  800424:	56                   	push   %esi
  800425:	e8 3a 24 00 00       	call   802864 <__umoddi3>
  80042a:	83 c4 14             	add    $0x14,%esp
  80042d:	0f be 80 02 2c 80 00 	movsbl 0x802c02(%eax),%eax
  800434:	50                   	push   %eax
  800435:	ff 55 08             	call   *0x8(%ebp)
}
  800438:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80043b:	5b                   	pop    %ebx
  80043c:	5e                   	pop    %esi
  80043d:	5f                   	pop    %edi
  80043e:	c9                   	leave  
  80043f:	c3                   	ret    

00800440 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800446:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800449:	83 f8 01             	cmp    $0x1,%eax
  80044c:	7e 0f                	jle    80045d <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  80044e:	8b 01                	mov    (%ecx),%eax
  800450:	83 c0 08             	add    $0x8,%eax
  800453:	89 01                	mov    %eax,(%ecx)
  800455:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800458:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80045b:	eb 24                	jmp    800481 <getuint+0x41>
	else if (lflag)
  80045d:	85 c0                	test   %eax,%eax
  80045f:	74 11                	je     800472 <getuint+0x32>
		return va_arg(*ap, unsigned long);
  800461:	8b 01                	mov    (%ecx),%eax
  800463:	83 c0 04             	add    $0x4,%eax
  800466:	89 01                	mov    %eax,(%ecx)
  800468:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80046b:	ba 00 00 00 00       	mov    $0x0,%edx
  800470:	eb 0f                	jmp    800481 <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  800472:	8b 01                	mov    (%ecx),%eax
  800474:	83 c0 04             	add    $0x4,%eax
  800477:	89 01                	mov    %eax,(%ecx)
  800479:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80047c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	8b 55 08             	mov    0x8(%ebp),%edx
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  80048c:	83 f8 01             	cmp    $0x1,%eax
  80048f:	7e 0f                	jle    8004a0 <getint+0x1d>
		return va_arg(*ap, long long);
  800491:	8b 02                	mov    (%edx),%eax
  800493:	83 c0 08             	add    $0x8,%eax
  800496:	89 02                	mov    %eax,(%edx)
  800498:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  80049b:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80049e:	eb 1c                	jmp    8004bc <getint+0x39>
	else if (lflag)
  8004a0:	85 c0                	test   %eax,%eax
  8004a2:	74 0d                	je     8004b1 <getint+0x2e>
		return va_arg(*ap, long);
  8004a4:	8b 02                	mov    (%edx),%eax
  8004a6:	83 c0 04             	add    $0x4,%eax
  8004a9:	89 02                	mov    %eax,(%edx)
  8004ab:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8004ae:	99                   	cltd   
  8004af:	eb 0b                	jmp    8004bc <getint+0x39>
	else
		return va_arg(*ap, int);
  8004b1:	8b 02                	mov    (%edx),%eax
  8004b3:	83 c0 04             	add    $0x4,%eax
  8004b6:	89 02                	mov    %eax,(%edx)
  8004b8:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8004bb:	99                   	cltd   
}
  8004bc:	c9                   	leave  
  8004bd:	c3                   	ret    

008004be <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	57                   	push   %edi
  8004c2:	56                   	push   %esi
  8004c3:	53                   	push   %ebx
  8004c4:	83 ec 1c             	sub    $0x1c,%esp
  8004c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  8004ca:	0f b6 13             	movzbl (%ebx),%edx
  8004cd:	43                   	inc    %ebx
  8004ce:	83 fa 25             	cmp    $0x25,%edx
  8004d1:	74 1e                	je     8004f1 <vprintfmt+0x33>
  8004d3:	85 d2                	test   %edx,%edx
  8004d5:	0f 84 d7 02 00 00    	je     8007b2 <vprintfmt+0x2f4>
  8004db:	83 ec 08             	sub    $0x8,%esp
  8004de:	ff 75 0c             	pushl  0xc(%ebp)
  8004e1:	52                   	push   %edx
  8004e2:	ff 55 08             	call   *0x8(%ebp)
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	0f b6 13             	movzbl (%ebx),%edx
  8004eb:	43                   	inc    %ebx
  8004ec:	83 fa 25             	cmp    $0x25,%edx
  8004ef:	75 e2                	jne    8004d3 <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  8004f1:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  8004f5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  8004fc:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  800501:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  800506:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050d:	0f b6 13             	movzbl (%ebx),%edx
  800510:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  800513:	43                   	inc    %ebx
  800514:	83 f8 55             	cmp    $0x55,%eax
  800517:	0f 87 70 02 00 00    	ja     80078d <vprintfmt+0x2cf>
  80051d:	ff 24 85 9c 2c 80 00 	jmp    *0x802c9c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  800524:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  800528:	eb e3                	jmp    80050d <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80052a:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  80052e:	eb dd                	jmp    80050d <vprintfmt+0x4f>

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
  800530:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  800535:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  800538:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  80053c:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  80053f:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  800542:	83 f8 09             	cmp    $0x9,%eax
  800545:	77 27                	ja     80056e <vprintfmt+0xb0>
  800547:	43                   	inc    %ebx
  800548:	eb eb                	jmp    800535 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80054a:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  800554:	eb 18                	jmp    80056e <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  800556:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80055a:	79 b1                	jns    80050d <vprintfmt+0x4f>
				width = 0;
  80055c:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  800563:	eb a8                	jmp    80050d <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  800565:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  80056c:	eb 9f                	jmp    80050d <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  80056e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800572:	79 99                	jns    80050d <vprintfmt+0x4f>
				width = precision, precision = -1;
  800574:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  800577:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  80057c:	eb 8f                	jmp    80050d <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80057e:	41                   	inc    %ecx
			goto reswitch;
  80057f:	eb 8c                	jmp    80050d <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800581:	83 ec 08             	sub    $0x8,%esp
  800584:	ff 75 0c             	pushl  0xc(%ebp)
  800587:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80058b:	8b 45 14             	mov    0x14(%ebp),%eax
  80058e:	ff 70 fc             	pushl  0xfffffffc(%eax)
  800591:	ff 55 08             	call   *0x8(%ebp)
			break;
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	e9 2e ff ff ff       	jmp    8004ca <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80059c:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  8005a6:	85 c0                	test   %eax,%eax
  8005a8:	79 02                	jns    8005ac <vprintfmt+0xee>
				err = -err;
  8005aa:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005ac:	83 f8 0e             	cmp    $0xe,%eax
  8005af:	7f 0b                	jg     8005bc <vprintfmt+0xfe>
  8005b1:	8b 3c 85 60 2c 80 00 	mov    0x802c60(,%eax,4),%edi
  8005b8:	85 ff                	test   %edi,%edi
  8005ba:	75 19                	jne    8005d5 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  8005bc:	50                   	push   %eax
  8005bd:	68 13 2c 80 00       	push   $0x802c13
  8005c2:	ff 75 0c             	pushl  0xc(%ebp)
  8005c5:	ff 75 08             	pushl  0x8(%ebp)
  8005c8:	e8 ed 01 00 00       	call   8007ba <printfmt>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	e9 f5 fe ff ff       	jmp    8004ca <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  8005d5:	57                   	push   %edi
  8005d6:	68 a1 30 80 00       	push   $0x8030a1
  8005db:	ff 75 0c             	pushl  0xc(%ebp)
  8005de:	ff 75 08             	pushl  0x8(%ebp)
  8005e1:	e8 d4 01 00 00       	call   8007ba <printfmt>
  8005e6:	83 c4 10             	add    $0x10,%esp
			break;
  8005e9:	e9 dc fe ff ff       	jmp    8004ca <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005ee:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  8005f8:	85 ff                	test   %edi,%edi
  8005fa:	75 05                	jne    800601 <vprintfmt+0x143>
				p = "(null)";
  8005fc:	bf 1c 2c 80 00       	mov    $0x802c1c,%edi
			if (width > 0 && padc != '-')
  800601:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800605:	7e 3b                	jle    800642 <vprintfmt+0x184>
  800607:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  80060b:	74 35                	je     800642 <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  80060d:	83 ec 08             	sub    $0x8,%esp
  800610:	56                   	push   %esi
  800611:	57                   	push   %edi
  800612:	e8 56 03 00 00       	call   80096d <strnlen>
  800617:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800621:	7e 1f                	jle    800642 <vprintfmt+0x184>
  800623:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800627:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  800633:	ff 55 08             	call   *0x8(%ebp)
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80063c:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800640:	7f e8                	jg     80062a <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800642:	0f be 17             	movsbl (%edi),%edx
  800645:	47                   	inc    %edi
  800646:	85 d2                	test   %edx,%edx
  800648:	74 44                	je     80068e <vprintfmt+0x1d0>
  80064a:	85 f6                	test   %esi,%esi
  80064c:	78 03                	js     800651 <vprintfmt+0x193>
  80064e:	4e                   	dec    %esi
  80064f:	78 3d                	js     80068e <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  800651:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  800655:	74 18                	je     80066f <vprintfmt+0x1b1>
  800657:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  80065a:	83 f8 5e             	cmp    $0x5e,%eax
  80065d:	76 10                	jbe    80066f <vprintfmt+0x1b1>
					putch('?', putdat);
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	6a 3f                	push   $0x3f
  800667:	ff 55 08             	call   *0x8(%ebp)
  80066a:	83 c4 10             	add    $0x10,%esp
  80066d:	eb 0d                	jmp    80067c <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  80066f:	83 ec 08             	sub    $0x8,%esp
  800672:	ff 75 0c             	pushl  0xc(%ebp)
  800675:	52                   	push   %edx
  800676:	ff 55 08             	call   *0x8(%ebp)
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80067f:	0f be 17             	movsbl (%edi),%edx
  800682:	47                   	inc    %edi
  800683:	85 d2                	test   %edx,%edx
  800685:	74 07                	je     80068e <vprintfmt+0x1d0>
  800687:	85 f6                	test   %esi,%esi
  800689:	78 c6                	js     800651 <vprintfmt+0x193>
  80068b:	4e                   	dec    %esi
  80068c:	79 c3                	jns    800651 <vprintfmt+0x193>
			for (; width > 0; width--)
  80068e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800692:	0f 8e 32 fe ff ff    	jle    8004ca <vprintfmt+0xc>
				putch(' ', putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	ff 75 0c             	pushl  0xc(%ebp)
  80069e:	6a 20                	push   $0x20
  8006a0:	ff 55 08             	call   *0x8(%ebp)
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8006a9:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8006ad:	7f e9                	jg     800698 <vprintfmt+0x1da>
			break;
  8006af:	e9 16 fe ff ff       	jmp    8004ca <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006b4:	51                   	push   %ecx
  8006b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b8:	50                   	push   %eax
  8006b9:	e8 c5 fd ff ff       	call   800483 <getint>
  8006be:	89 c6                	mov    %eax,%esi
  8006c0:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  8006c2:	83 c4 08             	add    $0x8,%esp
  8006c5:	85 d2                	test   %edx,%edx
  8006c7:	79 15                	jns    8006de <vprintfmt+0x220>
				putch('-', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	6a 2d                	push   $0x2d
  8006d1:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006d4:	f7 de                	neg    %esi
  8006d6:	83 d7 00             	adc    $0x0,%edi
  8006d9:	f7 df                	neg    %edi
  8006db:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  8006de:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8006e3:	eb 75                	jmp    80075a <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e5:	51                   	push   %ecx
  8006e6:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e9:	50                   	push   %eax
  8006ea:	e8 51 fd ff ff       	call   800440 <getuint>
  8006ef:	89 c6                	mov    %eax,%esi
  8006f1:	89 d7                	mov    %edx,%edi
			base = 10;
  8006f3:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  8006f8:	83 c4 08             	add    $0x8,%esp
  8006fb:	eb 5d                	jmp    80075a <vprintfmt+0x29c>

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
  8006fd:	51                   	push   %ecx
  8006fe:	8d 45 14             	lea    0x14(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	e8 39 fd ff ff       	call   800440 <getuint>
  800707:	89 c6                	mov    %eax,%esi
  800709:	89 d7                	mov    %edx,%edi
			base = 8;
  80070b:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  800710:	83 c4 08             	add    $0x8,%esp
  800713:	eb 45                	jmp    80075a <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	ff 75 0c             	pushl  0xc(%ebp)
  80071b:	6a 30                	push   $0x30
  80071d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800720:	83 c4 08             	add    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	6a 78                	push   $0x78
  800728:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  80072b:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  800735:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80073a:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	eb 16                	jmp    80075a <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800744:	51                   	push   %ecx
  800745:	8d 45 14             	lea    0x14(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	e8 f2 fc ff ff       	call   800440 <getuint>
  80074e:	89 c6                	mov    %eax,%esi
  800750:	89 d7                	mov    %edx,%edi
			base = 16;
  800752:	ba 10 00 00 00       	mov    $0x10,%edx
  800757:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  80075a:	83 ec 04             	sub    $0x4,%esp
  80075d:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  800761:	50                   	push   %eax
  800762:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  800765:	52                   	push   %edx
  800766:	57                   	push   %edi
  800767:	56                   	push   %esi
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	ff 75 08             	pushl  0x8(%ebp)
  80076e:	e8 2d fc ff ff       	call   8003a0 <printnum>
			break;
  800773:	83 c4 20             	add    $0x20,%esp
  800776:	e9 4f fd ff ff       	jmp    8004ca <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80077b:	83 ec 08             	sub    $0x8,%esp
  80077e:	ff 75 0c             	pushl  0xc(%ebp)
  800781:	52                   	push   %edx
  800782:	ff 55 08             	call   *0x8(%ebp)
			break;
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	e9 3d fd ff ff       	jmp    8004ca <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 25                	push   $0x25
  800795:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800798:	4b                   	dec    %ebx
  800799:	83 c4 10             	add    $0x10,%esp
  80079c:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8007a0:	0f 84 24 fd ff ff    	je     8004ca <vprintfmt+0xc>
  8007a6:	4b                   	dec    %ebx
  8007a7:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  8007ab:	75 f9                	jne    8007a6 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  8007ad:	e9 18 fd ff ff       	jmp    8004ca <vprintfmt+0xc>
		}
	}
}
  8007b2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8007b5:	5b                   	pop    %ebx
  8007b6:	5e                   	pop    %esi
  8007b7:	5f                   	pop    %edi
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  8007c0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007c3:	50                   	push   %eax
  8007c4:	ff 75 10             	pushl  0x10(%ebp)
  8007c7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ca:	ff 75 08             	pushl  0x8(%ebp)
  8007cd:	e8 ec fc ff ff       	call   8004be <vprintfmt>
	va_end(ap);
}
  8007d2:	c9                   	leave  
  8007d3:	c3                   	ret    

008007d4 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007d4:	55                   	push   %ebp
  8007d5:	89 e5                	mov    %esp,%ebp
  8007d7:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  8007da:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  8007dd:	8b 0a                	mov    (%edx),%ecx
  8007df:	3b 4a 04             	cmp    0x4(%edx),%ecx
  8007e2:	73 07                	jae    8007eb <sprintputch+0x17>
		*b->buf++ = ch;
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	88 01                	mov    %al,(%ecx)
  8007e9:	ff 02                	incl   (%edx)
}
  8007eb:	c9                   	leave  
  8007ec:	c3                   	ret    

008007ed <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	83 ec 18             	sub    $0x18,%esp
  8007f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8007f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007f9:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  8007fc:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800800:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  800803:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  80080a:	85 d2                	test   %edx,%edx
  80080c:	74 04                	je     800812 <vsnprintf+0x25>
  80080e:	85 c9                	test   %ecx,%ecx
  800810:	7f 07                	jg     800819 <vsnprintf+0x2c>
		return -E_INVAL;
  800812:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800817:	eb 1d                	jmp    800836 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800819:	ff 75 14             	pushl  0x14(%ebp)
  80081c:	ff 75 10             	pushl  0x10(%ebp)
  80081f:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  800822:	50                   	push   %eax
  800823:	68 d4 07 80 00       	push   $0x8007d4
  800828:	e8 91 fc ff ff       	call   8004be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80082d:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800830:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800833:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  800836:	c9                   	leave  
  800837:	c3                   	ret    

00800838 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80083e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800841:	50                   	push   %eax
  800842:	ff 75 10             	pushl  0x10(%ebp)
  800845:	ff 75 0c             	pushl  0xc(%ebp)
  800848:	ff 75 08             	pushl  0x8(%ebp)
  80084b:	e8 9d ff ff ff       	call   8007ed <vsnprintf>
	va_end(ap);

	return rc;
}
  800850:	c9                   	leave  
  800851:	c3                   	ret    
	...

00800854 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	56                   	push   %esi
  800858:	53                   	push   %ebx
  800859:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	56                   	push   %esi
  800860:	e8 ef 00 00 00       	call   800954 <strlen>
  char letter;
  int hexnum = 0;
  800865:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  80086a:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  80086f:	83 c4 10             	add    $0x10,%esp
  800872:	89 c2                	mov    %eax,%edx
  800874:	4a                   	dec    %edx
  800875:	0f 88 d0 00 00 00    	js     80094b <strtoint+0xf7>
    letter = string[cidx];
  80087b:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  80087e:	85 d2                	test   %edx,%edx
  800880:	75 12                	jne    800894 <strtoint+0x40>
      if (letter != '0') {
  800882:	3c 30                	cmp    $0x30,%al
  800884:	0f 84 ba 00 00 00    	je     800944 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  80088a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80088f:	e9 b9 00 00 00       	jmp    80094d <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800894:	83 fa 01             	cmp    $0x1,%edx
  800897:	75 12                	jne    8008ab <strtoint+0x57>
      if (letter != 'x') {
  800899:	3c 78                	cmp    $0x78,%al
  80089b:	0f 84 a3 00 00 00    	je     800944 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  8008a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8008a6:	e9 a2 00 00 00       	jmp    80094d <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  8008ab:	0f be c0             	movsbl %al,%eax
  8008ae:	83 e8 30             	sub    $0x30,%eax
  8008b1:	83 f8 36             	cmp    $0x36,%eax
  8008b4:	0f 87 80 00 00 00    	ja     80093a <strtoint+0xe6>
  8008ba:	ff 24 85 f4 2d 80 00 	jmp    *0x802df4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  8008c1:	01 cb                	add    %ecx,%ebx
          break;
  8008c3:	eb 7c                	jmp    800941 <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  8008c5:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  8008c8:	eb 77                	jmp    800941 <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  8008ca:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8008cd:	01 c3                	add    %eax,%ebx
          break;
  8008cf:	eb 70                	jmp    800941 <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  8008d1:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  8008d4:	eb 6b                	jmp    800941 <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  8008d6:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  8008d9:	01 c3                	add    %eax,%ebx
          break;
  8008db:	eb 64                	jmp    800941 <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  8008dd:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  8008e0:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  8008e3:	eb 5c                	jmp    800941 <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  8008e5:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  8008ec:	29 c8                	sub    %ecx,%eax
  8008ee:	01 c3                	add    %eax,%ebx
          break;
  8008f0:	eb 4f                	jmp    800941 <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  8008f2:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  8008f5:	eb 4a                	jmp    800941 <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  8008f7:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  8008fa:	01 c3                	add    %eax,%ebx
          break;
  8008fc:	eb 43                	jmp    800941 <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  8008fe:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800901:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800904:	eb 3b                	jmp    800941 <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800906:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800909:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  80090c:	01 c3                	add    %eax,%ebx
          break;
  80090e:	eb 31                	jmp    800941 <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800910:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800913:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800916:	eb 29                	jmp    800941 <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800918:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  80091b:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  80091e:	01 c3                	add    %eax,%ebx
          break;
  800920:	eb 1f                	jmp    800941 <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800922:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800929:	29 c8                	sub    %ecx,%eax
  80092b:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  80092e:	eb 11                	jmp    800941 <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800930:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800933:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800936:	01 c3                	add    %eax,%ebx
          break;
  800938:	eb 07                	jmp    800941 <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  80093a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80093f:	eb 0c                	jmp    80094d <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800941:	c1 e1 04             	shl    $0x4,%ecx
  800944:	4a                   	dec    %edx
  800945:	0f 89 30 ff ff ff    	jns    80087b <strtoint+0x27>
    }
  }

  return hexnum;
  80094b:	89 d8                	mov    %ebx,%eax
}
  80094d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800950:	5b                   	pop    %ebx
  800951:	5e                   	pop    %esi
  800952:	c9                   	leave  
  800953:	c3                   	ret    

00800954 <strlen>:





int
strlen(const char *s)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80095a:	b8 00 00 00 00       	mov    $0x0,%eax
  80095f:	80 3a 00             	cmpb   $0x0,(%edx)
  800962:	74 07                	je     80096b <strlen+0x17>
		n++;
  800964:	40                   	inc    %eax
  800965:	42                   	inc    %edx
  800966:	80 3a 00             	cmpb   $0x0,(%edx)
  800969:	75 f9                	jne    800964 <strlen+0x10>
	return n;
}
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    

0080096d <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
  80097b:	85 d2                	test   %edx,%edx
  80097d:	74 0f                	je     80098e <strnlen+0x21>
  80097f:	80 39 00             	cmpb   $0x0,(%ecx)
  800982:	74 0a                	je     80098e <strnlen+0x21>
		n++;
  800984:	40                   	inc    %eax
  800985:	41                   	inc    %ecx
  800986:	4a                   	dec    %edx
  800987:	74 05                	je     80098e <strnlen+0x21>
  800989:	80 39 00             	cmpb   $0x0,(%ecx)
  80098c:	75 f6                	jne    800984 <strnlen+0x17>
	return n;
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	53                   	push   %ebx
  800994:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  80099a:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  80099c:	8a 02                	mov    (%edx),%al
  80099e:	42                   	inc    %edx
  80099f:	88 01                	mov    %al,(%ecx)
  8009a1:	41                   	inc    %ecx
  8009a2:	84 c0                	test   %al,%al
  8009a4:	75 f6                	jne    80099c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009a6:	89 d8                	mov    %ebx,%eax
  8009a8:	5b                   	pop    %ebx
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	57                   	push   %edi
  8009af:	56                   	push   %esi
  8009b0:	53                   	push   %ebx
  8009b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b7:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  8009ba:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  8009bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009c1:	39 f3                	cmp    %esi,%ebx
  8009c3:	73 10                	jae    8009d5 <strncpy+0x2a>
		*dst++ = *src;
  8009c5:	8a 02                	mov    (%edx),%al
  8009c7:	88 01                	mov    %al,(%ecx)
  8009c9:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ca:	80 3a 01             	cmpb   $0x1,(%edx)
  8009cd:	83 da ff             	sbb    $0xffffffff,%edx
  8009d0:	43                   	inc    %ebx
  8009d1:	39 f3                	cmp    %esi,%ebx
  8009d3:	72 f0                	jb     8009c5 <strncpy+0x1a>
	}
	return ret;
}
  8009d5:	89 f8                	mov    %edi,%eax
  8009d7:	5b                   	pop    %ebx
  8009d8:	5e                   	pop    %esi
  8009d9:	5f                   	pop    %edi
  8009da:	c9                   	leave  
  8009db:	c3                   	ret    

008009dc <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	56                   	push   %esi
  8009e0:	53                   	push   %ebx
  8009e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e7:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  8009ea:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  8009ec:	85 d2                	test   %edx,%edx
  8009ee:	74 19                	je     800a09 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009f0:	4a                   	dec    %edx
  8009f1:	74 13                	je     800a06 <strlcpy+0x2a>
  8009f3:	80 39 00             	cmpb   $0x0,(%ecx)
  8009f6:	74 0e                	je     800a06 <strlcpy+0x2a>
  8009f8:	8a 01                	mov    (%ecx),%al
  8009fa:	41                   	inc    %ecx
  8009fb:	88 03                	mov    %al,(%ebx)
  8009fd:	43                   	inc    %ebx
  8009fe:	4a                   	dec    %edx
  8009ff:	74 05                	je     800a06 <strlcpy+0x2a>
  800a01:	80 39 00             	cmpb   $0x0,(%ecx)
  800a04:	75 f2                	jne    8009f8 <strlcpy+0x1c>
		*dst = '\0';
  800a06:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800a09:	89 d8                	mov    %ebx,%eax
  800a0b:	29 f0                	sub    %esi,%eax
}
  800a0d:	5b                   	pop    %ebx
  800a0e:	5e                   	pop    %esi
  800a0f:	c9                   	leave  
  800a10:	c3                   	ret    

00800a11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	8b 55 08             	mov    0x8(%ebp),%edx
  800a17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  800a1a:	80 3a 00             	cmpb   $0x0,(%edx)
  800a1d:	74 13                	je     800a32 <strcmp+0x21>
  800a1f:	8a 02                	mov    (%edx),%al
  800a21:	3a 01                	cmp    (%ecx),%al
  800a23:	75 0d                	jne    800a32 <strcmp+0x21>
  800a25:	42                   	inc    %edx
  800a26:	41                   	inc    %ecx
  800a27:	80 3a 00             	cmpb   $0x0,(%edx)
  800a2a:	74 06                	je     800a32 <strcmp+0x21>
  800a2c:	8a 02                	mov    (%edx),%al
  800a2e:	3a 01                	cmp    (%ecx),%al
  800a30:	74 f3                	je     800a25 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a32:	0f b6 02             	movzbl (%edx),%eax
  800a35:	0f b6 11             	movzbl (%ecx),%edx
  800a38:	29 d0                	sub    %edx,%eax
}
  800a3a:	c9                   	leave  
  800a3b:	c3                   	ret    

00800a3c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	53                   	push   %ebx
  800a40:	8b 55 08             	mov    0x8(%ebp),%edx
  800a43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a46:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800a49:	85 c9                	test   %ecx,%ecx
  800a4b:	74 1f                	je     800a6c <strncmp+0x30>
  800a4d:	80 3a 00             	cmpb   $0x0,(%edx)
  800a50:	74 16                	je     800a68 <strncmp+0x2c>
  800a52:	8a 02                	mov    (%edx),%al
  800a54:	3a 03                	cmp    (%ebx),%al
  800a56:	75 10                	jne    800a68 <strncmp+0x2c>
  800a58:	42                   	inc    %edx
  800a59:	43                   	inc    %ebx
  800a5a:	49                   	dec    %ecx
  800a5b:	74 0f                	je     800a6c <strncmp+0x30>
  800a5d:	80 3a 00             	cmpb   $0x0,(%edx)
  800a60:	74 06                	je     800a68 <strncmp+0x2c>
  800a62:	8a 02                	mov    (%edx),%al
  800a64:	3a 03                	cmp    (%ebx),%al
  800a66:	74 f0                	je     800a58 <strncmp+0x1c>
	if (n == 0)
  800a68:	85 c9                	test   %ecx,%ecx
  800a6a:	75 07                	jne    800a73 <strncmp+0x37>
		return 0;
  800a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800a71:	eb 0a                	jmp    800a7d <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a73:	0f b6 12             	movzbl (%edx),%edx
  800a76:	0f b6 03             	movzbl (%ebx),%eax
  800a79:	29 c2                	sub    %eax,%edx
  800a7b:	89 d0                	mov    %edx,%eax
}
  800a7d:	5b                   	pop    %ebx
  800a7e:	c9                   	leave  
  800a7f:	c3                   	ret    

00800a80 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800a89:	80 38 00             	cmpb   $0x0,(%eax)
  800a8c:	74 0a                	je     800a98 <strchr+0x18>
		if (*s == c)
  800a8e:	38 10                	cmp    %dl,(%eax)
  800a90:	74 0b                	je     800a9d <strchr+0x1d>
  800a92:	40                   	inc    %eax
  800a93:	80 38 00             	cmpb   $0x0,(%eax)
  800a96:	75 f6                	jne    800a8e <strchr+0xe>
			return (char *) s;
	return 0;
  800a98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9d:	c9                   	leave  
  800a9e:	c3                   	ret    

00800a9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800aa8:	80 38 00             	cmpb   $0x0,(%eax)
  800aab:	74 0a                	je     800ab7 <strfind+0x18>
		if (*s == c)
  800aad:	38 10                	cmp    %dl,(%eax)
  800aaf:	74 06                	je     800ab7 <strfind+0x18>
  800ab1:	40                   	inc    %eax
  800ab2:	80 38 00             	cmpb   $0x0,(%eax)
  800ab5:	75 f6                	jne    800aad <strfind+0xe>
			break;
	return (char *) s;
}
  800ab7:	c9                   	leave  
  800ab8:	c3                   	ret    

00800ab9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	57                   	push   %edi
  800abd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800ac3:	89 f8                	mov    %edi,%eax
  800ac5:	85 c9                	test   %ecx,%ecx
  800ac7:	74 40                	je     800b09 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800acf:	75 30                	jne    800b01 <memset+0x48>
  800ad1:	f6 c1 03             	test   $0x3,%cl
  800ad4:	75 2b                	jne    800b01 <memset+0x48>
		c &= 0xFF;
  800ad6:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	c1 e0 18             	shl    $0x18,%eax
  800ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae6:	c1 e2 10             	shl    $0x10,%edx
  800ae9:	09 d0                	or     %edx,%eax
  800aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aee:	c1 e2 08             	shl    $0x8,%edx
  800af1:	09 d0                	or     %edx,%eax
  800af3:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800af6:	c1 e9 02             	shr    $0x2,%ecx
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	fc                   	cld    
  800afd:	f3 ab                	repz stos %eax,%es:(%edi)
  800aff:	eb 06                	jmp    800b07 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	fc                   	cld    
  800b05:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800b07:	89 f8                	mov    %edi,%eax
}
  800b09:	5f                   	pop    %edi
  800b0a:	c9                   	leave  
  800b0b:	c3                   	ret    

00800b0c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	57                   	push   %edi
  800b10:	56                   	push   %esi
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b17:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b1a:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b1c:	39 c6                	cmp    %eax,%esi
  800b1e:	73 33                	jae    800b53 <memmove+0x47>
  800b20:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b23:	39 c2                	cmp    %eax,%edx
  800b25:	76 2c                	jbe    800b53 <memmove+0x47>
		s += n;
  800b27:	89 d6                	mov    %edx,%esi
		d += n;
  800b29:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2c:	f6 c2 03             	test   $0x3,%dl
  800b2f:	75 1b                	jne    800b4c <memmove+0x40>
  800b31:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b37:	75 13                	jne    800b4c <memmove+0x40>
  800b39:	f6 c1 03             	test   $0x3,%cl
  800b3c:	75 0e                	jne    800b4c <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800b3e:	83 ef 04             	sub    $0x4,%edi
  800b41:	83 ee 04             	sub    $0x4,%esi
  800b44:	c1 e9 02             	shr    $0x2,%ecx
  800b47:	fd                   	std    
  800b48:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800b4a:	eb 27                	jmp    800b73 <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b4c:	4f                   	dec    %edi
  800b4d:	4e                   	dec    %esi
  800b4e:	fd                   	std    
  800b4f:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800b51:	eb 20                	jmp    800b73 <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b53:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b59:	75 15                	jne    800b70 <memmove+0x64>
  800b5b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b61:	75 0d                	jne    800b70 <memmove+0x64>
  800b63:	f6 c1 03             	test   $0x3,%cl
  800b66:	75 08                	jne    800b70 <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800b68:	c1 e9 02             	shr    $0x2,%ecx
  800b6b:	fc                   	cld    
  800b6c:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800b6e:	eb 03                	jmp    800b73 <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b70:	fc                   	cld    
  800b71:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b73:	5e                   	pop    %esi
  800b74:	5f                   	pop    %edi
  800b75:	c9                   	leave  
  800b76:	c3                   	ret    

00800b77 <memcpy>:

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
  800b77:	55                   	push   %ebp
  800b78:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b7a:	ff 75 10             	pushl  0x10(%ebp)
  800b7d:	ff 75 0c             	pushl  0xc(%ebp)
  800b80:	ff 75 08             	pushl  0x8(%ebp)
  800b83:	e8 84 ff ff ff       	call   800b0c <memmove>
}
  800b88:	c9                   	leave  
  800b89:	c3                   	ret    

00800b8a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800b8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800b91:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b94:	8b 55 10             	mov    0x10(%ebp),%edx
  800b97:	4a                   	dec    %edx
  800b98:	83 fa ff             	cmp    $0xffffffff,%edx
  800b9b:	74 1a                	je     800bb7 <memcmp+0x2d>
  800b9d:	8a 01                	mov    (%ecx),%al
  800b9f:	3a 03                	cmp    (%ebx),%al
  800ba1:	74 0c                	je     800baf <memcmp+0x25>
  800ba3:	0f b6 d0             	movzbl %al,%edx
  800ba6:	0f b6 03             	movzbl (%ebx),%eax
  800ba9:	29 c2                	sub    %eax,%edx
  800bab:	89 d0                	mov    %edx,%eax
  800bad:	eb 0d                	jmp    800bbc <memcmp+0x32>
  800baf:	41                   	inc    %ecx
  800bb0:	43                   	inc    %ebx
  800bb1:	4a                   	dec    %edx
  800bb2:	83 fa ff             	cmp    $0xffffffff,%edx
  800bb5:	75 e6                	jne    800b9d <memcmp+0x13>
	}

	return 0;
  800bb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbc:	5b                   	pop    %ebx
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bc8:	89 c2                	mov    %eax,%edx
  800bca:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bcd:	39 d0                	cmp    %edx,%eax
  800bcf:	73 09                	jae    800bda <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bd1:	38 08                	cmp    %cl,(%eax)
  800bd3:	74 05                	je     800bda <memfind+0x1b>
  800bd5:	40                   	inc    %eax
  800bd6:	39 d0                	cmp    %edx,%eax
  800bd8:	72 f7                	jb     800bd1 <memfind+0x12>
			break;
	return (void *) s;
}
  800bda:	c9                   	leave  
  800bdb:	c3                   	ret    

00800bdc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
  800be2:	8b 55 08             	mov    0x8(%ebp),%edx
  800be5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800beb:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800bf0:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800bf5:	80 3a 20             	cmpb   $0x20,(%edx)
  800bf8:	74 05                	je     800bff <strtol+0x23>
  800bfa:	80 3a 09             	cmpb   $0x9,(%edx)
  800bfd:	75 0b                	jne    800c0a <strtol+0x2e>
  800bff:	42                   	inc    %edx
  800c00:	80 3a 20             	cmpb   $0x20,(%edx)
  800c03:	74 fa                	je     800bff <strtol+0x23>
  800c05:	80 3a 09             	cmpb   $0x9,(%edx)
  800c08:	74 f5                	je     800bff <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800c0a:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800c0d:	75 03                	jne    800c12 <strtol+0x36>
		s++;
  800c0f:	42                   	inc    %edx
  800c10:	eb 0b                	jmp    800c1d <strtol+0x41>
	else if (*s == '-')
  800c12:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800c15:	75 06                	jne    800c1d <strtol+0x41>
		s++, neg = 1;
  800c17:	42                   	inc    %edx
  800c18:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1d:	85 c9                	test   %ecx,%ecx
  800c1f:	74 05                	je     800c26 <strtol+0x4a>
  800c21:	83 f9 10             	cmp    $0x10,%ecx
  800c24:	75 15                	jne    800c3b <strtol+0x5f>
  800c26:	80 3a 30             	cmpb   $0x30,(%edx)
  800c29:	75 10                	jne    800c3b <strtol+0x5f>
  800c2b:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c2f:	75 0a                	jne    800c3b <strtol+0x5f>
		s += 2, base = 16;
  800c31:	83 c2 02             	add    $0x2,%edx
  800c34:	b9 10 00 00 00       	mov    $0x10,%ecx
  800c39:	eb 14                	jmp    800c4f <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800c3b:	85 c9                	test   %ecx,%ecx
  800c3d:	75 10                	jne    800c4f <strtol+0x73>
  800c3f:	80 3a 30             	cmpb   $0x30,(%edx)
  800c42:	75 05                	jne    800c49 <strtol+0x6d>
		s++, base = 8;
  800c44:	42                   	inc    %edx
  800c45:	b1 08                	mov    $0x8,%cl
  800c47:	eb 06                	jmp    800c4f <strtol+0x73>
	else if (base == 0)
  800c49:	85 c9                	test   %ecx,%ecx
  800c4b:	75 02                	jne    800c4f <strtol+0x73>
		base = 10;
  800c4d:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c4f:	8a 02                	mov    (%edx),%al
  800c51:	83 e8 30             	sub    $0x30,%eax
  800c54:	3c 09                	cmp    $0x9,%al
  800c56:	77 08                	ja     800c60 <strtol+0x84>
			dig = *s - '0';
  800c58:	0f be 02             	movsbl (%edx),%eax
  800c5b:	83 e8 30             	sub    $0x30,%eax
  800c5e:	eb 20                	jmp    800c80 <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800c60:	8a 02                	mov    (%edx),%al
  800c62:	83 e8 61             	sub    $0x61,%eax
  800c65:	3c 19                	cmp    $0x19,%al
  800c67:	77 08                	ja     800c71 <strtol+0x95>
			dig = *s - 'a' + 10;
  800c69:	0f be 02             	movsbl (%edx),%eax
  800c6c:	83 e8 57             	sub    $0x57,%eax
  800c6f:	eb 0f                	jmp    800c80 <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800c71:	8a 02                	mov    (%edx),%al
  800c73:	83 e8 41             	sub    $0x41,%eax
  800c76:	3c 19                	cmp    $0x19,%al
  800c78:	77 12                	ja     800c8c <strtol+0xb0>
			dig = *s - 'A' + 10;
  800c7a:	0f be 02             	movsbl (%edx),%eax
  800c7d:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800c80:	39 c8                	cmp    %ecx,%eax
  800c82:	7d 08                	jge    800c8c <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800c84:	42                   	inc    %edx
  800c85:	0f af d9             	imul   %ecx,%ebx
  800c88:	01 c3                	add    %eax,%ebx
  800c8a:	eb c3                	jmp    800c4f <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c8c:	85 f6                	test   %esi,%esi
  800c8e:	74 02                	je     800c92 <strtol+0xb6>
		*endptr = (char *) s;
  800c90:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c92:	89 d8                	mov    %ebx,%eax
  800c94:	85 ff                	test   %edi,%edi
  800c96:	74 02                	je     800c9a <strtol+0xbe>
  800c98:	f7 d8                	neg    %eax
}
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5f                   	pop    %edi
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    
	...

00800ca0 <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	57                   	push   %edi
  800ca4:	56                   	push   %esi
  800ca5:	53                   	push   %ebx
  800ca6:	83 ec 04             	sub    $0x4,%esp
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800caf:	bf 00 00 00 00       	mov    $0x0,%edi
  800cb4:	89 f8                	mov    %edi,%eax
  800cb6:	89 fb                	mov    %edi,%ebx
  800cb8:	89 fe                	mov    %edi,%esi
  800cba:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cbc:	83 c4 04             	add    $0x4,%esp
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
  800cca:	b8 01 00 00 00       	mov    $0x1,%eax
  800ccf:	bf 00 00 00 00       	mov    $0x0,%edi
  800cd4:	89 fa                	mov    %edi,%edx
  800cd6:	89 f9                	mov    %edi,%ecx
  800cd8:	89 fb                	mov    %edi,%ebx
  800cda:	89 fe                	mov    %edi,%esi
  800cdc:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	c9                   	leave  
  800ce2:	c3                   	ret    

00800ce3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
  800ce9:	83 ec 0c             	sub    $0xc,%esp
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf4:	bf 00 00 00 00       	mov    $0x0,%edi
  800cf9:	89 f9                	mov    %edi,%ecx
  800cfb:	89 fb                	mov    %edi,%ebx
  800cfd:	89 fe                	mov    %edi,%esi
  800cff:	cd 30                	int    $0x30
  800d01:	85 c0                	test   %eax,%eax
  800d03:	7e 17                	jle    800d1c <sys_env_destroy+0x39>
  800d05:	83 ec 0c             	sub    $0xc,%esp
  800d08:	50                   	push   %eax
  800d09:	6a 03                	push   $0x3
  800d0b:	68 d0 2e 80 00       	push   $0x802ed0
  800d10:	6a 23                	push   $0x23
  800d12:	68 ed 2e 80 00       	push   $0x802eed
  800d17:	e8 80 f5 ff ff       	call   80029c <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d1c:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	c9                   	leave  
  800d23:	c3                   	ret    

00800d24 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
  800d2a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d2f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d34:	89 fa                	mov    %edi,%edx
  800d36:	89 f9                	mov    %edi,%ecx
  800d38:	89 fb                	mov    %edi,%ebx
  800d3a:	89 fe                	mov    %edi,%esi
  800d3c:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <sys_yield>:

void
sys_yield(void)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d4e:	bf 00 00 00 00       	mov    $0x0,%edi
  800d53:	89 fa                	mov    %edi,%edx
  800d55:	89 f9                	mov    %edi,%ecx
  800d57:	89 fb                	mov    %edi,%ebx
  800d59:	89 fe                	mov    %edi,%esi
  800d5b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d5d:	5b                   	pop    %ebx
  800d5e:	5e                   	pop    %esi
  800d5f:	5f                   	pop    %edi
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
  800d68:	83 ec 0c             	sub    $0xc,%esp
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d74:	b8 04 00 00 00       	mov    $0x4,%eax
  800d79:	bf 00 00 00 00       	mov    $0x0,%edi
  800d7e:	89 fe                	mov    %edi,%esi
  800d80:	cd 30                	int    $0x30
  800d82:	85 c0                	test   %eax,%eax
  800d84:	7e 17                	jle    800d9d <sys_page_alloc+0x3b>
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	50                   	push   %eax
  800d8a:	6a 04                	push   $0x4
  800d8c:	68 d0 2e 80 00       	push   $0x802ed0
  800d91:	6a 23                	push   $0x23
  800d93:	68 ed 2e 80 00       	push   $0x802eed
  800d98:	e8 ff f4 ff ff       	call   80029c <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d9d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800da0:	5b                   	pop    %ebx
  800da1:	5e                   	pop    %esi
  800da2:	5f                   	pop    %edi
  800da3:	c9                   	leave  
  800da4:	c3                   	ret    

00800da5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	57                   	push   %edi
  800da9:	56                   	push   %esi
  800daa:	53                   	push   %ebx
  800dab:	83 ec 0c             	sub    $0xc,%esp
  800dae:	8b 55 08             	mov    0x8(%ebp),%edx
  800db1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800db7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dba:	8b 75 18             	mov    0x18(%ebp),%esi
  800dbd:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc2:	cd 30                	int    $0x30
  800dc4:	85 c0                	test   %eax,%eax
  800dc6:	7e 17                	jle    800ddf <sys_page_map+0x3a>
  800dc8:	83 ec 0c             	sub    $0xc,%esp
  800dcb:	50                   	push   %eax
  800dcc:	6a 05                	push   $0x5
  800dce:	68 d0 2e 80 00       	push   $0x802ed0
  800dd3:	6a 23                	push   $0x23
  800dd5:	68 ed 2e 80 00       	push   $0x802eed
  800dda:	e8 bd f4 ff ff       	call   80029c <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ddf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	c9                   	leave  
  800de6:	c3                   	ret    

00800de7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	8b 55 08             	mov    0x8(%ebp),%edx
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	b8 06 00 00 00       	mov    $0x6,%eax
  800dfb:	bf 00 00 00 00       	mov    $0x0,%edi
  800e00:	89 fb                	mov    %edi,%ebx
  800e02:	89 fe                	mov    %edi,%esi
  800e04:	cd 30                	int    $0x30
  800e06:	85 c0                	test   %eax,%eax
  800e08:	7e 17                	jle    800e21 <sys_page_unmap+0x3a>
  800e0a:	83 ec 0c             	sub    $0xc,%esp
  800e0d:	50                   	push   %eax
  800e0e:	6a 06                	push   $0x6
  800e10:	68 d0 2e 80 00       	push   $0x802ed0
  800e15:	6a 23                	push   $0x23
  800e17:	68 ed 2e 80 00       	push   $0x802eed
  800e1c:	e8 7b f4 ff ff       	call   80029c <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e21:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e24:	5b                   	pop    %ebx
  800e25:	5e                   	pop    %esi
  800e26:	5f                   	pop    %edi
  800e27:	c9                   	leave  
  800e28:	c3                   	ret    

00800e29 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e38:	b8 08 00 00 00       	mov    $0x8,%eax
  800e3d:	bf 00 00 00 00       	mov    $0x0,%edi
  800e42:	89 fb                	mov    %edi,%ebx
  800e44:	89 fe                	mov    %edi,%esi
  800e46:	cd 30                	int    $0x30
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	7e 17                	jle    800e63 <sys_env_set_status+0x3a>
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	50                   	push   %eax
  800e50:	6a 08                	push   $0x8
  800e52:	68 d0 2e 80 00       	push   $0x802ed0
  800e57:	6a 23                	push   $0x23
  800e59:	68 ed 2e 80 00       	push   $0x802eed
  800e5e:	e8 39 f4 ff ff       	call   80029c <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e63:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	c9                   	leave  
  800e6a:	c3                   	ret    

00800e6b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
  800e71:	83 ec 0c             	sub    $0xc,%esp
  800e74:	8b 55 08             	mov    0x8(%ebp),%edx
  800e77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e7f:	bf 00 00 00 00       	mov    $0x0,%edi
  800e84:	89 fb                	mov    %edi,%ebx
  800e86:	89 fe                	mov    %edi,%esi
  800e88:	cd 30                	int    $0x30
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	7e 17                	jle    800ea5 <sys_env_set_trapframe+0x3a>
  800e8e:	83 ec 0c             	sub    $0xc,%esp
  800e91:	50                   	push   %eax
  800e92:	6a 09                	push   $0x9
  800e94:	68 d0 2e 80 00       	push   $0x802ed0
  800e99:	6a 23                	push   $0x23
  800e9b:	68 ed 2e 80 00       	push   $0x802eed
  800ea0:	e8 f7 f3 ff ff       	call   80029c <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ea5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	c9                   	leave  
  800eac:	c3                   	ret    

00800ead <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 0c             	sub    $0xc,%esp
  800eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ec6:	89 fb                	mov    %edi,%ebx
  800ec8:	89 fe                	mov    %edi,%esi
  800eca:	cd 30                	int    $0x30
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	7e 17                	jle    800ee7 <sys_env_set_pgfault_upcall+0x3a>
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	50                   	push   %eax
  800ed4:	6a 0a                	push   $0xa
  800ed6:	68 d0 2e 80 00       	push   $0x802ed0
  800edb:	6a 23                	push   $0x23
  800edd:	68 ed 2e 80 00       	push   $0x802eed
  800ee2:	e8 b5 f3 ff ff       	call   80029c <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ee7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800eea:	5b                   	pop    %ebx
  800eeb:	5e                   	pop    %esi
  800eec:	5f                   	pop    %edi
  800eed:	c9                   	leave  
  800eee:	c3                   	ret    

00800eef <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
  800ef5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800efe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f06:	be 00 00 00 00       	mov    $0x0,%esi
  800f0b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
  800f18:	83 ec 0c             	sub    $0xc,%esp
  800f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1e:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f23:	bf 00 00 00 00       	mov    $0x0,%edi
  800f28:	89 f9                	mov    %edi,%ecx
  800f2a:	89 fb                	mov    %edi,%ebx
  800f2c:	89 fe                	mov    %edi,%esi
  800f2e:	cd 30                	int    $0x30
  800f30:	85 c0                	test   %eax,%eax
  800f32:	7e 17                	jle    800f4b <sys_ipc_recv+0x39>
  800f34:	83 ec 0c             	sub    $0xc,%esp
  800f37:	50                   	push   %eax
  800f38:	6a 0d                	push   $0xd
  800f3a:	68 d0 2e 80 00       	push   $0x802ed0
  800f3f:	6a 23                	push   $0x23
  800f41:	68 ed 2e 80 00       	push   $0x802eed
  800f46:	e8 51 f3 ff ff       	call   80029c <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f4b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5f                   	pop    %edi
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
  800f59:	83 ec 0c             	sub    $0xc,%esp
  800f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f62:	b8 10 00 00 00       	mov    $0x10,%eax
  800f67:	bf 00 00 00 00       	mov    $0x0,%edi
  800f6c:	89 fb                	mov    %edi,%ebx
  800f6e:	89 fe                	mov    %edi,%esi
  800f70:	cd 30                	int    $0x30
  800f72:	85 c0                	test   %eax,%eax
  800f74:	7e 17                	jle    800f8d <sys_transmit_packet+0x3a>
  800f76:	83 ec 0c             	sub    $0xc,%esp
  800f79:	50                   	push   %eax
  800f7a:	6a 10                	push   $0x10
  800f7c:	68 d0 2e 80 00       	push   $0x802ed0
  800f81:	6a 23                	push   $0x23
  800f83:	68 ed 2e 80 00       	push   $0x802eed
  800f88:	e8 0f f3 ff ff       	call   80029c <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  800f8d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800f90:	5b                   	pop    %ebx
  800f91:	5e                   	pop    %esi
  800f92:	5f                   	pop    %edi
  800f93:	c9                   	leave  
  800f94:	c3                   	ret    

00800f95 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	57                   	push   %edi
  800f99:	56                   	push   %esi
  800f9a:	53                   	push   %ebx
  800f9b:	83 ec 0c             	sub    $0xc,%esp
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa4:	b8 11 00 00 00       	mov    $0x11,%eax
  800fa9:	bf 00 00 00 00       	mov    $0x0,%edi
  800fae:	89 fb                	mov    %edi,%ebx
  800fb0:	89 fe                	mov    %edi,%esi
  800fb2:	cd 30                	int    $0x30
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	7e 17                	jle    800fcf <sys_receive_packet+0x3a>
  800fb8:	83 ec 0c             	sub    $0xc,%esp
  800fbb:	50                   	push   %eax
  800fbc:	6a 11                	push   $0x11
  800fbe:	68 d0 2e 80 00       	push   $0x802ed0
  800fc3:	6a 23                	push   $0x23
  800fc5:	68 ed 2e 80 00       	push   $0x802eed
  800fca:	e8 cd f2 ff ff       	call   80029c <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  800fcf:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fd2:	5b                   	pop    %ebx
  800fd3:	5e                   	pop    %esi
  800fd4:	5f                   	pop    %edi
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	57                   	push   %edi
  800fdb:	56                   	push   %esi
  800fdc:	53                   	push   %ebx
  800fdd:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fe2:	bf 00 00 00 00       	mov    $0x0,%edi
  800fe7:	89 fa                	mov    %edi,%edx
  800fe9:	89 f9                	mov    %edi,%ecx
  800feb:	89 fb                	mov    %edi,%ebx
  800fed:	89 fe                	mov    %edi,%esi
  800fef:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
  800ffc:	83 ec 0c             	sub    $0xc,%esp
  800fff:	8b 55 08             	mov    0x8(%ebp),%edx
  801002:	b8 0e 00 00 00       	mov    $0xe,%eax
  801007:	bf 00 00 00 00       	mov    $0x0,%edi
  80100c:	89 f9                	mov    %edi,%ecx
  80100e:	89 fb                	mov    %edi,%ebx
  801010:	89 fe                	mov    %edi,%esi
  801012:	cd 30                	int    $0x30
  801014:	85 c0                	test   %eax,%eax
  801016:	7e 17                	jle    80102f <sys_map_receive_buffers+0x39>
  801018:	83 ec 0c             	sub    $0xc,%esp
  80101b:	50                   	push   %eax
  80101c:	6a 0e                	push   $0xe
  80101e:	68 d0 2e 80 00       	push   $0x802ed0
  801023:	6a 23                	push   $0x23
  801025:	68 ed 2e 80 00       	push   $0x802eed
  80102a:	e8 6d f2 ff ff       	call   80029c <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  80102f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801032:	5b                   	pop    %ebx
  801033:	5e                   	pop    %esi
  801034:	5f                   	pop    %edi
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	57                   	push   %edi
  80103b:	56                   	push   %esi
  80103c:	53                   	push   %ebx
  80103d:	83 ec 0c             	sub    $0xc,%esp
  801040:	8b 55 08             	mov    0x8(%ebp),%edx
  801043:	b8 12 00 00 00       	mov    $0x12,%eax
  801048:	bf 00 00 00 00       	mov    $0x0,%edi
  80104d:	89 f9                	mov    %edi,%ecx
  80104f:	89 fb                	mov    %edi,%ebx
  801051:	89 fe                	mov    %edi,%esi
  801053:	cd 30                	int    $0x30
  801055:	85 c0                	test   %eax,%eax
  801057:	7e 17                	jle    801070 <sys_receive_packet_zerocopy+0x39>
  801059:	83 ec 0c             	sub    $0xc,%esp
  80105c:	50                   	push   %eax
  80105d:	6a 12                	push   $0x12
  80105f:	68 d0 2e 80 00       	push   $0x802ed0
  801064:	6a 23                	push   $0x23
  801066:	68 ed 2e 80 00       	push   $0x802eed
  80106b:	e8 2c f2 ff ff       	call   80029c <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  801070:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801073:	5b                   	pop    %ebx
  801074:	5e                   	pop    %esi
  801075:	5f                   	pop    %edi
  801076:	c9                   	leave  
  801077:	c3                   	ret    

00801078 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	57                   	push   %edi
  80107c:	56                   	push   %esi
  80107d:	53                   	push   %ebx
  80107e:	83 ec 0c             	sub    $0xc,%esp
  801081:	8b 55 08             	mov    0x8(%ebp),%edx
  801084:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801087:	b8 13 00 00 00       	mov    $0x13,%eax
  80108c:	bf 00 00 00 00       	mov    $0x0,%edi
  801091:	89 fb                	mov    %edi,%ebx
  801093:	89 fe                	mov    %edi,%esi
  801095:	cd 30                	int    $0x30
  801097:	85 c0                	test   %eax,%eax
  801099:	7e 17                	jle    8010b2 <sys_env_set_priority+0x3a>
  80109b:	83 ec 0c             	sub    $0xc,%esp
  80109e:	50                   	push   %eax
  80109f:	6a 13                	push   $0x13
  8010a1:	68 d0 2e 80 00       	push   $0x802ed0
  8010a6:	6a 23                	push   $0x23
  8010a8:	68 ed 2e 80 00       	push   $0x802eed
  8010ad:	e8 ea f1 ff ff       	call   80029c <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  8010b2:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010b5:	5b                   	pop    %ebx
  8010b6:	5e                   	pop    %esi
  8010b7:	5f                   	pop    %edi
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    
	...

008010bc <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	53                   	push   %ebx
  8010c0:	83 ec 04             	sub    $0x4,%esp
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010c6:	8b 18                	mov    (%eax),%ebx
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
  8010c8:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010cc:	74 11                	je     8010df <pgfault+0x23>
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	c1 e8 0c             	shr    $0xc,%eax
  8010d3:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  8010da:	f6 c4 08             	test   $0x8,%ah
  8010dd:	75 14                	jne    8010f3 <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  8010df:	83 ec 04             	sub    $0x4,%esp
  8010e2:	68 fc 2e 80 00       	push   $0x802efc
  8010e7:	6a 1e                	push   $0x1e
  8010e9:	68 50 2f 80 00       	push   $0x802f50
  8010ee:	e8 a9 f1 ff ff       	call   80029c <_panic>
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
  8010f3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	6a 07                	push   $0x7
  8010fe:	68 00 f0 7f 00       	push   $0x7ff000
  801103:	83 ec 04             	sub    $0x4,%esp
  801106:	e8 19 fc ff ff       	call   800d24 <sys_getenvid>
  80110b:	89 04 24             	mov    %eax,(%esp)
  80110e:	e8 4f fc ff ff       	call   800d62 <sys_page_alloc>
  801113:	83 c4 10             	add    $0x10,%esp
  801116:	85 c0                	test   %eax,%eax
  801118:	79 12                	jns    80112c <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  80111a:	50                   	push   %eax
  80111b:	68 5b 2f 80 00       	push   $0x802f5b
  801120:	6a 2d                	push   $0x2d
  801122:	68 50 2f 80 00       	push   $0x802f50
  801127:	e8 70 f1 ff ff       	call   80029c <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	68 00 10 00 00       	push   $0x1000
  801134:	53                   	push   %ebx
  801135:	68 00 f0 7f 00       	push   $0x7ff000
  80113a:	e8 cd f9 ff ff       	call   800b0c <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  80113f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801146:	53                   	push   %ebx
  801147:	83 ec 0c             	sub    $0xc,%esp
  80114a:	e8 d5 fb ff ff       	call   800d24 <sys_getenvid>
  80114f:	83 c4 0c             	add    $0xc,%esp
  801152:	50                   	push   %eax
  801153:	68 00 f0 7f 00       	push   $0x7ff000
  801158:	83 ec 04             	sub    $0x4,%esp
  80115b:	e8 c4 fb ff ff       	call   800d24 <sys_getenvid>
  801160:	89 04 24             	mov    %eax,(%esp)
  801163:	e8 3d fc ff ff       	call   800da5 <sys_page_map>
  801168:	83 c4 20             	add    $0x20,%esp
  80116b:	85 c0                	test   %eax,%eax
  80116d:	79 12                	jns    801181 <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  80116f:	50                   	push   %eax
  801170:	68 76 2f 80 00       	push   $0x802f76
  801175:	6a 33                	push   $0x33
  801177:	68 50 2f 80 00       	push   $0x802f50
  80117c:	e8 1b f1 ff ff       	call   80029c <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  801181:	83 ec 08             	sub    $0x8,%esp
  801184:	68 00 f0 7f 00       	push   $0x7ff000
  801189:	83 ec 04             	sub    $0x4,%esp
  80118c:	e8 93 fb ff ff       	call   800d24 <sys_getenvid>
  801191:	89 04 24             	mov    %eax,(%esp)
  801194:	e8 4e fc ff ff       	call   800de7 <sys_page_unmap>
  801199:	83 c4 10             	add    $0x10,%esp
  80119c:	85 c0                	test   %eax,%eax
  80119e:	79 12                	jns    8011b2 <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  8011a0:	50                   	push   %eax
  8011a1:	68 8f 2f 80 00       	push   $0x802f8f
  8011a6:	6a 36                	push   $0x36
  8011a8:	68 50 2f 80 00       	push   $0x802f50
  8011ad:	e8 ea f0 ff ff       	call   80029c <_panic>
        }

	//panic("pgfault not implemented");
}
  8011b2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <duppage>:

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
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 04             	sub    $0x4,%esp
  8011be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  8011c4:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  8011c9:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  8011cc:	f6 c4 04             	test   $0x4,%ah
  8011cf:	74 36                	je     801207 <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  8011d1:	83 ec 0c             	sub    $0xc,%esp
  8011d4:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  8011d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011dc:	50                   	push   %eax
  8011dd:	89 d8                	mov    %ebx,%eax
  8011df:	c1 e0 0c             	shl    $0xc,%eax
  8011e2:	50                   	push   %eax
  8011e3:	51                   	push   %ecx
  8011e4:	50                   	push   %eax
  8011e5:	83 ec 04             	sub    $0x4,%esp
  8011e8:	e8 37 fb ff ff       	call   800d24 <sys_getenvid>
  8011ed:	89 04 24             	mov    %eax,(%esp)
  8011f0:	e8 b0 fb ff ff       	call   800da5 <sys_page_map>
  8011f5:	83 c4 20             	add    $0x20,%esp
            return r;
  8011f8:	89 c2                	mov    %eax,%edx
  8011fa:	85 c0                	test   %eax,%eax
  8011fc:	0f 88 c9 00 00 00    	js     8012cb <duppage+0x114>
  801202:	e9 bf 00 00 00       	jmp    8012c6 <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  801207:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  80120e:	a9 02 08 00 00       	test   $0x802,%eax
  801213:	74 7b                	je     801290 <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  801215:	83 ec 0c             	sub    $0xc,%esp
  801218:	68 05 08 00 00       	push   $0x805
  80121d:	89 d8                	mov    %ebx,%eax
  80121f:	c1 e0 0c             	shl    $0xc,%eax
  801222:	50                   	push   %eax
  801223:	51                   	push   %ecx
  801224:	50                   	push   %eax
  801225:	83 ec 04             	sub    $0x4,%esp
  801228:	e8 f7 fa ff ff       	call   800d24 <sys_getenvid>
  80122d:	89 04 24             	mov    %eax,(%esp)
  801230:	e8 70 fb ff ff       	call   800da5 <sys_page_map>
  801235:	83 c4 20             	add    $0x20,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	79 12                	jns    80124e <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  80123c:	50                   	push   %eax
  80123d:	68 aa 2f 80 00       	push   $0x802faa
  801242:	6a 56                	push   $0x56
  801244:	68 50 2f 80 00       	push   $0x802f50
  801249:	e8 4e f0 ff ff       	call   80029c <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	68 05 08 00 00       	push   $0x805
  801256:	c1 e3 0c             	shl    $0xc,%ebx
  801259:	53                   	push   %ebx
  80125a:	83 ec 0c             	sub    $0xc,%esp
  80125d:	e8 c2 fa ff ff       	call   800d24 <sys_getenvid>
  801262:	83 c4 0c             	add    $0xc,%esp
  801265:	50                   	push   %eax
  801266:	53                   	push   %ebx
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	e8 b5 fa ff ff       	call   800d24 <sys_getenvid>
  80126f:	89 04 24             	mov    %eax,(%esp)
  801272:	e8 2e fb ff ff       	call   800da5 <sys_page_map>
  801277:	83 c4 20             	add    $0x20,%esp
  80127a:	85 c0                	test   %eax,%eax
  80127c:	79 48                	jns    8012c6 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  80127e:	50                   	push   %eax
  80127f:	68 aa 2f 80 00       	push   $0x802faa
  801284:	6a 5b                	push   $0x5b
  801286:	68 50 2f 80 00       	push   $0x802f50
  80128b:	e8 0c f0 ff ff       	call   80029c <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  801290:	83 ec 0c             	sub    $0xc,%esp
  801293:	6a 05                	push   $0x5
  801295:	89 d8                	mov    %ebx,%eax
  801297:	c1 e0 0c             	shl    $0xc,%eax
  80129a:	50                   	push   %eax
  80129b:	51                   	push   %ecx
  80129c:	50                   	push   %eax
  80129d:	83 ec 04             	sub    $0x4,%esp
  8012a0:	e8 7f fa ff ff       	call   800d24 <sys_getenvid>
  8012a5:	89 04 24             	mov    %eax,(%esp)
  8012a8:	e8 f8 fa ff ff       	call   800da5 <sys_page_map>
  8012ad:	83 c4 20             	add    $0x20,%esp
  8012b0:	85 c0                	test   %eax,%eax
  8012b2:	79 12                	jns    8012c6 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  8012b4:	50                   	push   %eax
  8012b5:	68 aa 2f 80 00       	push   $0x802faa
  8012ba:	6a 5f                	push   $0x5f
  8012bc:	68 50 2f 80 00       	push   $0x802f50
  8012c1:	e8 d6 ef ff ff       	call   80029c <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  8012c6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8012cb:	89 d0                	mov    %edx,%eax
  8012cd:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8012d0:	c9                   	leave  
  8012d1:	c3                   	ret    

008012d2 <fork>:

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
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	57                   	push   %edi
  8012d6:	56                   	push   %esi
  8012d7:	53                   	push   %ebx
  8012d8:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  8012db:	68 bc 10 80 00       	push   $0x8010bc
  8012e0:	e8 bb 12 00 00       	call   8025a0 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  8012e5:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  8012e8:	ba 07 00 00 00       	mov    $0x7,%edx
  8012ed:	89 d0                	mov    %edx,%eax
  8012ef:	cd 30                	int    $0x30
  8012f1:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	79 15                	jns    80130d <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  8012f8:	50                   	push   %eax
  8012f9:	68 30 2f 80 00       	push   $0x802f30
  8012fe:	68 85 00 00 00       	push   $0x85
  801303:	68 50 2f 80 00       	push   $0x802f50
  801308:	e8 8f ef ff ff       	call   80029c <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  80130d:	bf 00 00 00 00       	mov    $0x0,%edi
  801312:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  801316:	75 21                	jne    801339 <fork+0x67>
  801318:	e8 07 fa ff ff       	call   800d24 <sys_getenvid>
  80131d:	25 ff 03 00 00       	and    $0x3ff,%eax
  801322:	c1 e0 07             	shl    $0x7,%eax
  801325:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80132a:	a3 80 70 80 00       	mov    %eax,0x807080
  80132f:	ba 00 00 00 00       	mov    $0x0,%edx
  801334:	e9 fd 00 00 00       	jmp    801436 <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  801339:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  801340:	a8 01                	test   $0x1,%al
  801342:	74 5f                	je     8013a3 <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  801344:	bb 00 00 00 00       	mov    $0x0,%ebx
  801349:	89 f8                	mov    %edi,%eax
  80134b:	c1 e0 0a             	shl    $0xa,%eax
  80134e:	89 c2                	mov    %eax,%edx
  801350:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  801355:	77 4c                	ja     8013a3 <fork+0xd1>
  801357:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  801359:	01 da                	add    %ebx,%edx
  80135b:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801362:	a8 01                	test   $0x1,%al
  801364:	74 28                	je     80138e <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  801366:	83 ec 08             	sub    $0x8,%esp
  801369:	52                   	push   %edx
  80136a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80136d:	e8 45 fe ff ff       	call   8011b7 <duppage>
  801372:	83 c4 10             	add    $0x10,%esp
  801375:	85 c0                	test   %eax,%eax
  801377:	79 15                	jns    80138e <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  801379:	50                   	push   %eax
  80137a:	68 c3 2f 80 00       	push   $0x802fc3
  80137f:	68 95 00 00 00       	push   $0x95
  801384:	68 50 2f 80 00       	push   $0x802f50
  801389:	e8 0e ef ff ff       	call   80029c <_panic>
  80138e:	43                   	inc    %ebx
  80138f:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  801395:	7f 0c                	jg     8013a3 <fork+0xd1>
  801397:	89 f2                	mov    %esi,%edx
  801399:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80139c:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  8013a1:	76 b6                	jbe    801359 <fork+0x87>
  8013a3:	47                   	inc    %edi
  8013a4:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  8013aa:	76 8d                	jbe    801339 <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8013ac:	83 ec 04             	sub    $0x4,%esp
  8013af:	6a 07                	push   $0x7
  8013b1:	68 00 f0 bf ee       	push   $0xeebff000
  8013b6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8013b9:	e8 a4 f9 ff ff       	call   800d62 <sys_page_alloc>
  8013be:	83 c4 10             	add    $0x10,%esp
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	79 15                	jns    8013da <fork+0x108>
          panic("fork: %d", r);
  8013c5:	50                   	push   %eax
  8013c6:	68 dc 2f 80 00       	push   $0x802fdc
  8013cb:	68 9d 00 00 00       	push   $0x9d
  8013d0:	68 50 2f 80 00       	push   $0x802f50
  8013d5:	e8 c2 ee ff ff       	call   80029c <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  8013da:	83 ec 08             	sub    $0x8,%esp
  8013dd:	a1 80 70 80 00       	mov    0x807080,%eax
  8013e2:	8b 40 64             	mov    0x64(%eax),%eax
  8013e5:	50                   	push   %eax
  8013e6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8013e9:	e8 bf fa ff ff       	call   800ead <sys_env_set_pgfault_upcall>
  8013ee:	83 c4 10             	add    $0x10,%esp
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	79 15                	jns    80140a <fork+0x138>
          panic("fork: %d", r);
  8013f5:	50                   	push   %eax
  8013f6:	68 dc 2f 80 00       	push   $0x802fdc
  8013fb:	68 a2 00 00 00       	push   $0xa2
  801400:	68 50 2f 80 00       	push   $0x802f50
  801405:	e8 92 ee ff ff       	call   80029c <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  80140a:	83 ec 08             	sub    $0x8,%esp
  80140d:	6a 01                	push   $0x1
  80140f:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801412:	e8 12 fa ff ff       	call   800e29 <sys_env_set_status>
  801417:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  80141a:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80141d:	85 c0                	test   %eax,%eax
  80141f:	79 15                	jns    801436 <fork+0x164>
  801421:	50                   	push   %eax
  801422:	68 dc 2f 80 00       	push   $0x802fdc
  801427:	68 a7 00 00 00       	push   $0xa7
  80142c:	68 50 2f 80 00       	push   $0x802f50
  801431:	e8 66 ee ff ff       	call   80029c <_panic>
 
	//panic("fork not implemented");
}
  801436:	89 d0                	mov    %edx,%eax
  801438:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80143b:	5b                   	pop    %ebx
  80143c:	5e                   	pop    %esi
  80143d:	5f                   	pop    %edi
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <sfork>:



// Challenge!
int
sfork(void)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801446:	68 e5 2f 80 00       	push   $0x802fe5
  80144b:	68 b5 00 00 00       	push   $0xb5
  801450:	68 50 2f 80 00       	push   $0x802f50
  801455:	e8 42 ee ff ff       	call   80029c <_panic>
	...

0080145c <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  801462:	ff 75 08             	pushl  0x8(%ebp)
  801465:	e8 0a 00 00 00       	call   801474 <fd2num>
  80146a:	c1 e0 16             	shl    $0x16,%eax
  80146d:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	05 00 00 40 30       	add    $0x30400000,%eax
  80147f:	c1 e8 0c             	shr    $0xc,%eax
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <fd_alloc>:

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
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	57                   	push   %edi
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
  80148a:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  80148d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801492:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801497:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  80149c:	89 c8                	mov    %ecx,%eax
  80149e:	c1 e0 0c             	shl    $0xc,%eax
  8014a1:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8014a7:	89 d0                	mov    %edx,%eax
  8014a9:	c1 e8 16             	shr    $0x16,%eax
  8014ac:	8b 04 86             	mov    (%esi,%eax,4),%eax
  8014af:	a8 01                	test   $0x1,%al
  8014b1:	74 0c                	je     8014bf <fd_alloc+0x3b>
  8014b3:	89 d0                	mov    %edx,%eax
  8014b5:	c1 e8 0c             	shr    $0xc,%eax
  8014b8:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  8014bb:	a8 01                	test   $0x1,%al
  8014bd:	75 09                	jne    8014c8 <fd_alloc+0x44>
			*fd_store = fd;
  8014bf:	89 17                	mov    %edx,(%edi)
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 11                	jmp    8014d9 <fd_alloc+0x55>
  8014c8:	41                   	inc    %ecx
  8014c9:	83 f9 1f             	cmp    $0x1f,%ecx
  8014cc:	7e ce                	jle    80149c <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  8014ce:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  8014d4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014d9:	5b                   	pop    %ebx
  8014da:	5e                   	pop    %esi
  8014db:	5f                   	pop    %edi
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  8014e4:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8014e9:	83 f8 1f             	cmp    $0x1f,%eax
  8014ec:	77 3a                	ja     801528 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  8014ee:	c1 e0 0c             	shl    $0xc,%eax
  8014f1:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8014f7:	89 d0                	mov    %edx,%eax
  8014f9:	c1 e8 16             	shr    $0x16,%eax
  8014fc:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801503:	a8 01                	test   $0x1,%al
  801505:	74 10                	je     801517 <fd_lookup+0x39>
  801507:	89 d0                	mov    %edx,%eax
  801509:	c1 e8 0c             	shr    $0xc,%eax
  80150c:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801513:	a8 01                	test   $0x1,%al
  801515:	75 07                	jne    80151e <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801517:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  80151c:	eb 0a                	jmp    801528 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  80151e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801521:	89 10                	mov    %edx,(%eax)
	return 0;
  801523:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801528:	89 d0                	mov    %edx,%eax
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <fd_close>:

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
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	56                   	push   %esi
  801530:	53                   	push   %ebx
  801531:	83 ec 10             	sub    $0x10,%esp
  801534:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801537:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80153a:	50                   	push   %eax
  80153b:	56                   	push   %esi
  80153c:	e8 33 ff ff ff       	call   801474 <fd2num>
  801541:	89 04 24             	mov    %eax,(%esp)
  801544:	e8 95 ff ff ff       	call   8014de <fd_lookup>
  801549:	89 c3                	mov    %eax,%ebx
  80154b:	83 c4 08             	add    $0x8,%esp
  80154e:	85 c0                	test   %eax,%eax
  801550:	78 05                	js     801557 <fd_close+0x2b>
  801552:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  801555:	74 0f                	je     801566 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801557:	89 d8                	mov    %ebx,%eax
  801559:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155d:	75 3a                	jne    801599 <fd_close+0x6d>
  80155f:	b8 00 00 00 00       	mov    $0x0,%eax
  801564:	eb 33                	jmp    801599 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  801566:	83 ec 08             	sub    $0x8,%esp
  801569:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80156c:	50                   	push   %eax
  80156d:	ff 36                	pushl  (%esi)
  80156f:	e8 2c 00 00 00       	call   8015a0 <dev_lookup>
  801574:	89 c3                	mov    %eax,%ebx
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	85 c0                	test   %eax,%eax
  80157b:	78 0f                	js     80158c <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  80157d:	83 ec 0c             	sub    $0xc,%esp
  801580:	56                   	push   %esi
  801581:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801584:	ff 50 10             	call   *0x10(%eax)
  801587:	89 c3                	mov    %eax,%ebx
  801589:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80158c:	83 ec 08             	sub    $0x8,%esp
  80158f:	56                   	push   %esi
  801590:	6a 00                	push   $0x0
  801592:	e8 50 f8 ff ff       	call   800de7 <sys_page_unmap>
	return r;
  801597:	89 d8                	mov    %ebx,%eax
}
  801599:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80159c:	5b                   	pop    %ebx
  80159d:	5e                   	pop    %esi
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <dev_lookup>:


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
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	56                   	push   %esi
  8015a4:	53                   	push   %ebx
  8015a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8015a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  8015ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b0:	83 3d 04 70 80 00 00 	cmpl   $0x0,0x807004
  8015b7:	74 1c                	je     8015d5 <dev_lookup+0x35>
  8015b9:	b9 04 70 80 00       	mov    $0x807004,%ecx
		if (devtab[i]->dev_id == dev_id) {
  8015be:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  8015c1:	39 18                	cmp    %ebx,(%eax)
  8015c3:	75 09                	jne    8015ce <dev_lookup+0x2e>
			*dev = devtab[i];
  8015c5:	89 06                	mov    %eax,(%esi)
			return 0;
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cc:	eb 29                	jmp    8015f7 <dev_lookup+0x57>
  8015ce:	42                   	inc    %edx
  8015cf:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  8015d3:	75 e9                	jne    8015be <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8015d5:	83 ec 04             	sub    $0x4,%esp
  8015d8:	53                   	push   %ebx
  8015d9:	a1 80 70 80 00       	mov    0x807080,%eax
  8015de:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015e1:	50                   	push   %eax
  8015e2:	68 fc 2f 80 00       	push   $0x802ffc
  8015e7:	e8 a0 ed ff ff       	call   80038c <cprintf>
	*dev = 0;
  8015ec:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  8015f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015f7:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5e                   	pop    %esi
  8015fc:	c9                   	leave  
  8015fd:	c3                   	ret    

008015fe <close>:

int
close(int fdnum)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801604:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801607:	50                   	push   %eax
  801608:	ff 75 08             	pushl  0x8(%ebp)
  80160b:	e8 ce fe ff ff       	call   8014de <fd_lookup>
  801610:	83 c4 08             	add    $0x8,%esp
		return r;
  801613:	89 c2                	mov    %eax,%edx
  801615:	85 c0                	test   %eax,%eax
  801617:	78 0f                	js     801628 <close+0x2a>
	else
		return fd_close(fd, 1);
  801619:	83 ec 08             	sub    $0x8,%esp
  80161c:	6a 01                	push   $0x1
  80161e:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  801621:	e8 06 ff ff ff       	call   80152c <fd_close>
  801626:	89 c2                	mov    %eax,%edx
}
  801628:	89 d0                	mov    %edx,%eax
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <close_all>:

void
close_all(void)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	53                   	push   %ebx
  801630:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801633:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801638:	83 ec 0c             	sub    $0xc,%esp
  80163b:	53                   	push   %ebx
  80163c:	e8 bd ff ff ff       	call   8015fe <close>
  801641:	83 c4 10             	add    $0x10,%esp
  801644:	43                   	inc    %ebx
  801645:	83 fb 1f             	cmp    $0x1f,%ebx
  801648:	7e ee                	jle    801638 <close_all+0xc>
}
  80164a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	57                   	push   %edi
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
  801655:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801658:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  80165b:	50                   	push   %eax
  80165c:	ff 75 08             	pushl  0x8(%ebp)
  80165f:	e8 7a fe ff ff       	call   8014de <fd_lookup>
  801664:	89 c6                	mov    %eax,%esi
  801666:	83 c4 08             	add    $0x8,%esp
  801669:	85 f6                	test   %esi,%esi
  80166b:	0f 88 f8 00 00 00    	js     801769 <dup+0x11a>
		return r;
	close(newfdnum);
  801671:	83 ec 0c             	sub    $0xc,%esp
  801674:	ff 75 0c             	pushl  0xc(%ebp)
  801677:	e8 82 ff ff ff       	call   8015fe <close>

	newfd = INDEX2FD(newfdnum);
  80167c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167f:	c1 e0 0c             	shl    $0xc,%eax
  801682:	2d 00 00 40 30       	sub    $0x30400000,%eax
  801687:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  80168a:	83 c4 04             	add    $0x4,%esp
  80168d:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801690:	e8 c7 fd ff ff       	call   80145c <fd2data>
  801695:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801697:	83 c4 04             	add    $0x4,%esp
  80169a:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80169d:	e8 ba fd ff ff       	call   80145c <fd2data>
  8016a2:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  8016a5:	89 f8                	mov    %edi,%eax
  8016a7:	c1 e8 16             	shr    $0x16,%eax
  8016aa:	83 c4 10             	add    $0x10,%esp
  8016ad:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	74 48                	je     801700 <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  8016b8:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  8016bd:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  8016c0:	89 d0                	mov    %edx,%eax
  8016c2:	c1 e8 0c             	shr    $0xc,%eax
  8016c5:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  8016cc:	a8 01                	test   $0x1,%al
  8016ce:	74 22                	je     8016f2 <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  8016d0:	83 ec 0c             	sub    $0xc,%esp
  8016d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8016d8:	50                   	push   %eax
  8016d9:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8016dc:	01 d8                	add    %ebx,%eax
  8016de:	50                   	push   %eax
  8016df:	6a 00                	push   $0x0
  8016e1:	52                   	push   %edx
  8016e2:	6a 00                	push   $0x0
  8016e4:	e8 bc f6 ff ff       	call   800da5 <sys_page_map>
  8016e9:	89 c6                	mov    %eax,%esi
  8016eb:	83 c4 20             	add    $0x20,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 3f                	js     801731 <dup+0xe2>
  8016f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016f8:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8016fe:	7e bd                	jle    8016bd <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801700:	83 ec 0c             	sub    $0xc,%esp
  801703:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801706:	89 d0                	mov    %edx,%eax
  801708:	c1 e8 0c             	shr    $0xc,%eax
  80170b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801712:	25 07 0e 00 00       	and    $0xe07,%eax
  801717:	50                   	push   %eax
  801718:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  80171b:	6a 00                	push   $0x0
  80171d:	52                   	push   %edx
  80171e:	6a 00                	push   $0x0
  801720:	e8 80 f6 ff ff       	call   800da5 <sys_page_map>
  801725:	89 c6                	mov    %eax,%esi
  801727:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  80172a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172d:	85 f6                	test   %esi,%esi
  80172f:	79 38                	jns    801769 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  801731:	83 ec 08             	sub    $0x8,%esp
  801734:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801737:	6a 00                	push   $0x0
  801739:	e8 a9 f6 ff ff       	call   800de7 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  80173e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801743:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  801746:	83 ec 08             	sub    $0x8,%esp
  801749:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80174c:	01 d8                	add    %ebx,%eax
  80174e:	50                   	push   %eax
  80174f:	6a 00                	push   $0x0
  801751:	e8 91 f6 ff ff       	call   800de7 <sys_page_unmap>
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80175f:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  801765:	7e df                	jle    801746 <dup+0xf7>
	return r;
  801767:	89 f0                	mov    %esi,%eax
}
  801769:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80176c:	5b                   	pop    %ebx
  80176d:	5e                   	pop    %esi
  80176e:	5f                   	pop    %edi
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	53                   	push   %ebx
  801775:	83 ec 14             	sub    $0x14,%esp
  801778:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177b:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80177e:	50                   	push   %eax
  80177f:	53                   	push   %ebx
  801780:	e8 59 fd ff ff       	call   8014de <fd_lookup>
  801785:	89 c2                	mov    %eax,%edx
  801787:	83 c4 08             	add    $0x8,%esp
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 1a                	js     8017a8 <read+0x37>
  80178e:	83 ec 08             	sub    $0x8,%esp
  801791:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801794:	50                   	push   %eax
  801795:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801798:	ff 30                	pushl  (%eax)
  80179a:	e8 01 fe ff ff       	call   8015a0 <dev_lookup>
  80179f:	89 c2                	mov    %eax,%edx
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	79 04                	jns    8017ac <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  8017a8:	89 d0                	mov    %edx,%eax
  8017aa:	eb 50                	jmp    8017fc <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017ac:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017af:	8b 40 08             	mov    0x8(%eax),%eax
  8017b2:	83 e0 03             	and    $0x3,%eax
  8017b5:	83 f8 01             	cmp    $0x1,%eax
  8017b8:	75 1e                	jne    8017d8 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8017ba:	83 ec 04             	sub    $0x4,%esp
  8017bd:	53                   	push   %ebx
  8017be:	a1 80 70 80 00       	mov    0x807080,%eax
  8017c3:	8b 40 4c             	mov    0x4c(%eax),%eax
  8017c6:	50                   	push   %eax
  8017c7:	68 3d 30 80 00       	push   $0x80303d
  8017cc:	e8 bb eb ff ff       	call   80038c <cprintf>
		return -E_INVAL;
  8017d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d6:	eb 24                	jmp    8017fc <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  8017d8:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017db:	ff 70 04             	pushl  0x4(%eax)
  8017de:	ff 75 10             	pushl  0x10(%ebp)
  8017e1:	ff 75 0c             	pushl  0xc(%ebp)
  8017e4:	50                   	push   %eax
  8017e5:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8017e8:	ff 50 08             	call   *0x8(%eax)
  8017eb:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	78 06                	js     8017fa <read+0x89>
		fd->fd_offset += r;
  8017f4:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8017f7:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  8017fa:	89 d0                	mov    %edx,%eax
}
  8017fc:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	57                   	push   %edi
  801805:	56                   	push   %esi
  801806:	53                   	push   %ebx
  801807:	83 ec 0c             	sub    $0xc,%esp
  80180a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80180d:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801810:	bb 00 00 00 00       	mov    $0x0,%ebx
  801815:	39 f3                	cmp    %esi,%ebx
  801817:	73 25                	jae    80183e <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801819:	83 ec 04             	sub    $0x4,%esp
  80181c:	89 f0                	mov    %esi,%eax
  80181e:	29 d8                	sub    %ebx,%eax
  801820:	50                   	push   %eax
  801821:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801824:	50                   	push   %eax
  801825:	ff 75 08             	pushl  0x8(%ebp)
  801828:	e8 44 ff ff ff       	call   801771 <read>
		if (m < 0)
  80182d:	83 c4 10             	add    $0x10,%esp
  801830:	85 c0                	test   %eax,%eax
  801832:	78 0c                	js     801840 <readn+0x3f>
			return m;
		if (m == 0)
  801834:	85 c0                	test   %eax,%eax
  801836:	74 06                	je     80183e <readn+0x3d>
  801838:	01 c3                	add    %eax,%ebx
  80183a:	39 f3                	cmp    %esi,%ebx
  80183c:	72 db                	jb     801819 <readn+0x18>
			break;
	}
	return tot;
  80183e:	89 d8                	mov    %ebx,%eax
}
  801840:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5f                   	pop    %edi
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	53                   	push   %ebx
  80184c:	83 ec 14             	sub    $0x14,%esp
  80184f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801852:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801855:	50                   	push   %eax
  801856:	53                   	push   %ebx
  801857:	e8 82 fc ff ff       	call   8014de <fd_lookup>
  80185c:	89 c2                	mov    %eax,%edx
  80185e:	83 c4 08             	add    $0x8,%esp
  801861:	85 c0                	test   %eax,%eax
  801863:	78 1a                	js     80187f <write+0x37>
  801865:	83 ec 08             	sub    $0x8,%esp
  801868:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  80186b:	50                   	push   %eax
  80186c:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  80186f:	ff 30                	pushl  (%eax)
  801871:	e8 2a fd ff ff       	call   8015a0 <dev_lookup>
  801876:	89 c2                	mov    %eax,%edx
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	85 c0                	test   %eax,%eax
  80187d:	79 04                	jns    801883 <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  80187f:	89 d0                	mov    %edx,%eax
  801881:	eb 4b                	jmp    8018ce <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801883:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801886:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80188a:	75 1e                	jne    8018aa <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  80188c:	83 ec 04             	sub    $0x4,%esp
  80188f:	53                   	push   %ebx
  801890:	a1 80 70 80 00       	mov    0x807080,%eax
  801895:	8b 40 4c             	mov    0x4c(%eax),%eax
  801898:	50                   	push   %eax
  801899:	68 59 30 80 00       	push   $0x803059
  80189e:	e8 e9 ea ff ff       	call   80038c <cprintf>
		return -E_INVAL;
  8018a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018a8:	eb 24                	jmp    8018ce <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  8018aa:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018ad:	ff 70 04             	pushl  0x4(%eax)
  8018b0:	ff 75 10             	pushl  0x10(%ebp)
  8018b3:	ff 75 0c             	pushl  0xc(%ebp)
  8018b6:	50                   	push   %eax
  8018b7:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8018ba:	ff 50 0c             	call   *0xc(%eax)
  8018bd:	89 c2                	mov    %eax,%edx
	if (r > 0)
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	7e 06                	jle    8018cc <write+0x84>
		fd->fd_offset += r;
  8018c6:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  8018c9:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  8018cc:	89 d0                	mov    %edx,%eax
}
  8018ce:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018d9:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8018dc:	50                   	push   %eax
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	e8 f9 fb ff ff       	call   8014de <fd_lookup>
  8018e5:	83 c4 08             	add    $0x8,%esp
		return r;
  8018e8:	89 c2                	mov    %eax,%edx
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	78 0e                	js     8018fc <seek+0x29>
	fd->fd_offset = offset;
  8018ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f1:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8018f4:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8018fc:	89 d0                	mov    %edx,%eax
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	53                   	push   %ebx
  801904:	83 ec 14             	sub    $0x14,%esp
  801907:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80190a:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80190d:	50                   	push   %eax
  80190e:	53                   	push   %ebx
  80190f:	e8 ca fb ff ff       	call   8014de <fd_lookup>
  801914:	83 c4 08             	add    $0x8,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	78 4e                	js     801969 <ftruncate+0x69>
  80191b:	83 ec 08             	sub    $0x8,%esp
  80191e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801921:	50                   	push   %eax
  801922:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801925:	ff 30                	pushl  (%eax)
  801927:	e8 74 fc ff ff       	call   8015a0 <dev_lookup>
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	85 c0                	test   %eax,%eax
  801931:	78 36                	js     801969 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801933:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801936:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80193a:	75 1e                	jne    80195a <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	53                   	push   %ebx
  801940:	a1 80 70 80 00       	mov    0x807080,%eax
  801945:	8b 40 4c             	mov    0x4c(%eax),%eax
  801948:	50                   	push   %eax
  801949:	68 1c 30 80 00       	push   $0x80301c
  80194e:	e8 39 ea ff ff       	call   80038c <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801953:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801958:	eb 0f                	jmp    801969 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  80195a:	83 ec 08             	sub    $0x8,%esp
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801963:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801966:	ff 50 1c             	call   *0x1c(%eax)
}
  801969:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	53                   	push   %ebx
  801972:	83 ec 14             	sub    $0x14,%esp
  801975:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801978:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  80197b:	50                   	push   %eax
  80197c:	ff 75 08             	pushl  0x8(%ebp)
  80197f:	e8 5a fb ff ff       	call   8014de <fd_lookup>
  801984:	83 c4 08             	add    $0x8,%esp
  801987:	85 c0                	test   %eax,%eax
  801989:	78 42                	js     8019cd <fstat+0x5f>
  80198b:	83 ec 08             	sub    $0x8,%esp
  80198e:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801991:	50                   	push   %eax
  801992:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801995:	ff 30                	pushl  (%eax)
  801997:	e8 04 fc ff ff       	call   8015a0 <dev_lookup>
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	78 2a                	js     8019cd <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  8019a3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019a6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019ad:	00 00 00 
	stat->st_isdir = 0;
  8019b0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019b7:	00 00 00 
	stat->st_dev = dev;
  8019ba:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  8019bd:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	53                   	push   %ebx
  8019c7:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  8019ca:	ff 50 14             	call   *0x14(%eax)
}
  8019cd:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	56                   	push   %esi
  8019d6:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019d7:	83 ec 08             	sub    $0x8,%esp
  8019da:	6a 00                	push   $0x0
  8019dc:	ff 75 08             	pushl  0x8(%ebp)
  8019df:	e8 28 00 00 00       	call   801a0c <open>
  8019e4:	89 c6                	mov    %eax,%esi
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	85 f6                	test   %esi,%esi
  8019eb:	78 18                	js     801a05 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  8019ed:	83 ec 08             	sub    $0x8,%esp
  8019f0:	ff 75 0c             	pushl  0xc(%ebp)
  8019f3:	56                   	push   %esi
  8019f4:	e8 75 ff ff ff       	call   80196e <fstat>
  8019f9:	89 c3                	mov    %eax,%ebx
	close(fd);
  8019fb:	89 34 24             	mov    %esi,(%esp)
  8019fe:	e8 fb fb ff ff       	call   8015fe <close>
	return r;
  801a03:	89 d8                	mov    %ebx,%eax
}
  801a05:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801a08:	5b                   	pop    %ebx
  801a09:	5e                   	pop    %esi
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	53                   	push   %ebx
  801a10:	83 ec 10             	sub    $0x10,%esp
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
  801a13:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801a16:	50                   	push   %eax
  801a17:	e8 68 fa ff ff       	call   801484 <fd_alloc>
  801a1c:	89 c3                	mov    %eax,%ebx
  801a1e:	83 c4 10             	add    $0x10,%esp
  801a21:	85 db                	test   %ebx,%ebx
  801a23:	78 36                	js     801a5b <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801a25:	83 ec 04             	sub    $0x4,%esp
  801a28:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801a2b:	ff 75 0c             	pushl  0xc(%ebp)
  801a2e:	ff 75 08             	pushl  0x8(%ebp)
  801a31:	e8 1b 05 00 00       	call   801f51 <fsipc_open>
  801a36:	89 c3                	mov    %eax,%ebx
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	79 11                	jns    801a50 <open+0x44>
          fd_close(fd_store, 0);
  801a3f:	83 ec 08             	sub    $0x8,%esp
  801a42:	6a 00                	push   $0x0
  801a44:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801a47:	e8 e0 fa ff ff       	call   80152c <fd_close>
          return r;
  801a4c:	89 d8                	mov    %ebx,%eax
  801a4e:	eb 0b                	jmp    801a5b <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801a50:	83 ec 0c             	sub    $0xc,%esp
  801a53:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801a56:	e8 19 fa ff ff       	call   801474 <fd2num>
}
  801a5b:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	53                   	push   %ebx
  801a64:	83 ec 04             	sub    $0x4,%esp
  801a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  801a6a:	6a 01                	push   $0x1
  801a6c:	6a 00                	push   $0x0
  801a6e:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801a74:	53                   	push   %ebx
  801a75:	e8 e7 03 00 00       	call   801e61 <funmap>
  801a7a:	83 c4 10             	add    $0x10,%esp
          return r;
  801a7d:	89 c2                	mov    %eax,%edx
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 19                	js     801a9c <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  801a83:	83 ec 0c             	sub    $0xc,%esp
  801a86:	ff 73 0c             	pushl  0xc(%ebx)
  801a89:	e8 68 05 00 00       	call   801ff6 <fsipc_close>
  801a8e:	83 c4 10             	add    $0x10,%esp
          return r;
  801a91:	89 c2                	mov    %eax,%edx
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 05                	js     801a9c <file_close+0x3c>
        }
        return 0;
  801a97:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801a9c:	89 d0                	mov    %edx,%eax
  801a9e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	57                   	push   %edi
  801aa7:	56                   	push   %esi
  801aa8:	53                   	push   %ebx
  801aa9:	83 ec 0c             	sub    $0xc,%esp
  801aac:	8b 75 10             	mov    0x10(%ebp),%esi
  801aaf:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  801abb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801ac0:	39 d7                	cmp    %edx,%edi
  801ac2:	0f 87 95 00 00 00    	ja     801b5d <file_read+0xba>
	if (offset + n > size)
  801ac8:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801acb:	39 d0                	cmp    %edx,%eax
  801acd:	76 04                	jbe    801ad3 <file_read+0x30>
		n = size - offset;
  801acf:	89 d6                	mov    %edx,%esi
  801ad1:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	ff 75 08             	pushl  0x8(%ebp)
  801ad9:	e8 7e f9 ff ff       	call   80145c <fd2data>
  801ade:	89 c3                	mov    %eax,%ebx
  801ae0:	01 fb                	add    %edi,%ebx
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	eb 41                	jmp    801b28 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801ae7:	89 d8                	mov    %ebx,%eax
  801ae9:	c1 e8 16             	shr    $0x16,%eax
  801aec:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801af3:	a8 01                	test   $0x1,%al
  801af5:	74 10                	je     801b07 <file_read+0x64>
  801af7:	89 d8                	mov    %ebx,%eax
  801af9:	c1 e8 0c             	shr    $0xc,%eax
  801afc:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801b03:	a8 01                	test   $0x1,%al
  801b05:	75 1b                	jne    801b22 <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801b07:	83 ec 04             	sub    $0x4,%esp
  801b0a:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801b0d:	50                   	push   %eax
  801b0e:	57                   	push   %edi
  801b0f:	ff 75 08             	pushl  0x8(%ebp)
  801b12:	e8 d4 02 00 00       	call   801deb <fmap>
  801b17:	83 c4 10             	add    $0x10,%esp
              return r;
  801b1a:	89 c1                	mov    %eax,%ecx
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 3d                	js     801b5d <file_read+0xba>
  801b20:	eb 1c                	jmp    801b3e <file_read+0x9b>
  801b22:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801b28:	83 ec 0c             	sub    $0xc,%esp
  801b2b:	ff 75 08             	pushl  0x8(%ebp)
  801b2e:	e8 29 f9 ff ff       	call   80145c <fd2data>
  801b33:	01 f8                	add    %edi,%eax
  801b35:	01 f0                	add    %esi,%eax
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	39 d8                	cmp    %ebx,%eax
  801b3c:	77 a9                	ja     801ae7 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801b3e:	83 ec 04             	sub    $0x4,%esp
  801b41:	56                   	push   %esi
  801b42:	83 ec 04             	sub    $0x4,%esp
  801b45:	ff 75 08             	pushl  0x8(%ebp)
  801b48:	e8 0f f9 ff ff       	call   80145c <fd2data>
  801b4d:	83 c4 08             	add    $0x8,%esp
  801b50:	01 f8                	add    %edi,%eax
  801b52:	50                   	push   %eax
  801b53:	ff 75 0c             	pushl  0xc(%ebp)
  801b56:	e8 b1 ef ff ff       	call   800b0c <memmove>
	return n;
  801b5b:	89 f1                	mov    %esi,%ecx
}
  801b5d:	89 c8                	mov    %ecx,%eax
  801b5f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801b62:	5b                   	pop    %ebx
  801b63:	5e                   	pop    %esi
  801b64:	5f                   	pop    %edi
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	56                   	push   %esi
  801b6b:	53                   	push   %ebx
  801b6c:	83 ec 18             	sub    $0x18,%esp
  801b6f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b72:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801b75:	50                   	push   %eax
  801b76:	ff 75 08             	pushl  0x8(%ebp)
  801b79:	e8 60 f9 ff ff       	call   8014de <fd_lookup>
  801b7e:	83 c4 10             	add    $0x10,%esp
		return r;
  801b81:	89 c2                	mov    %eax,%edx
  801b83:	85 c0                	test   %eax,%eax
  801b85:	0f 88 9f 00 00 00    	js     801c2a <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801b8b:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801b8e:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  801b90:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801b95:	3b 05 20 70 80 00    	cmp    0x807020,%eax
  801b9b:	0f 85 89 00 00 00    	jne    801c2a <read_map+0xc3>
	va = fd2data(fd) + offset;
  801ba1:	83 ec 0c             	sub    $0xc,%esp
  801ba4:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801ba7:	e8 b0 f8 ff ff       	call   80145c <fd2data>
  801bac:	89 c3                	mov    %eax,%ebx
  801bae:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801bb0:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801bb3:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801bb8:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801bbe:	7f 6a                	jg     801c2a <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801bc0:	89 d8                	mov    %ebx,%eax
  801bc2:	c1 e8 16             	shr    $0x16,%eax
  801bc5:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801bcc:	a8 01                	test   $0x1,%al
  801bce:	74 10                	je     801be0 <read_map+0x79>
  801bd0:	89 d8                	mov    %ebx,%eax
  801bd2:	c1 e8 0c             	shr    $0xc,%eax
  801bd5:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801bdc:	a8 01                	test   $0x1,%al
  801bde:	75 19                	jne    801bf9 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	8d 46 01             	lea    0x1(%esi),%eax
  801be6:	50                   	push   %eax
  801be7:	56                   	push   %esi
  801be8:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801beb:	e8 fb 01 00 00       	call   801deb <fmap>
  801bf0:	83 c4 10             	add    $0x10,%esp
            return r;
  801bf3:	89 c2                	mov    %eax,%edx
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	78 31                	js     801c2a <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801bf9:	89 d8                	mov    %ebx,%eax
  801bfb:	c1 e8 16             	shr    $0x16,%eax
  801bfe:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801c05:	a8 01                	test   $0x1,%al
  801c07:	74 10                	je     801c19 <read_map+0xb2>
  801c09:	89 d8                	mov    %ebx,%eax
  801c0b:	c1 e8 0c             	shr    $0xc,%eax
  801c0e:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801c15:	a8 01                	test   $0x1,%al
  801c17:	75 07                	jne    801c20 <read_map+0xb9>
		return -E_NO_DISK;
  801c19:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801c1e:	eb 0a                	jmp    801c2a <read_map+0xc3>

	*blk = (void*) va;
  801c20:	8b 45 10             	mov    0x10(%ebp),%eax
  801c23:	89 18                	mov    %ebx,(%eax)
	return 0;
  801c25:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801c2a:	89 d0                	mov    %edx,%eax
  801c2c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	57                   	push   %edi
  801c37:	56                   	push   %esi
  801c38:	53                   	push   %ebx
  801c39:	83 ec 0c             	sub    $0xc,%esp
  801c3c:	8b 75 08             	mov    0x8(%ebp),%esi
  801c3f:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801c42:	8b 45 10             	mov    0x10(%ebp),%eax
  801c45:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801c48:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801c4d:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801c53:	0f 87 bd 00 00 00    	ja     801d16 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801c59:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801c5f:	73 17                	jae    801c78 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801c61:	83 ec 08             	sub    $0x8,%esp
  801c64:	52                   	push   %edx
  801c65:	56                   	push   %esi
  801c66:	e8 fb 00 00 00       	call   801d66 <file_trunc>
  801c6b:	83 c4 10             	add    $0x10,%esp
			return r;
  801c6e:	89 c1                	mov    %eax,%ecx
  801c70:	85 c0                	test   %eax,%eax
  801c72:	0f 88 9e 00 00 00    	js     801d16 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801c78:	83 ec 0c             	sub    $0xc,%esp
  801c7b:	56                   	push   %esi
  801c7c:	e8 db f7 ff ff       	call   80145c <fd2data>
  801c81:	89 c3                	mov    %eax,%ebx
  801c83:	01 fb                	add    %edi,%ebx
  801c85:	83 c4 10             	add    $0x10,%esp
  801c88:	eb 42                	jmp    801ccc <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801c8a:	89 d8                	mov    %ebx,%eax
  801c8c:	c1 e8 16             	shr    $0x16,%eax
  801c8f:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801c96:	a8 01                	test   $0x1,%al
  801c98:	74 10                	je     801caa <file_write+0x77>
  801c9a:	89 d8                	mov    %ebx,%eax
  801c9c:	c1 e8 0c             	shr    $0xc,%eax
  801c9f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801ca6:	a8 01                	test   $0x1,%al
  801ca8:	75 1c                	jne    801cc6 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	8b 55 10             	mov    0x10(%ebp),%edx
  801cb0:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801cb3:	50                   	push   %eax
  801cb4:	57                   	push   %edi
  801cb5:	56                   	push   %esi
  801cb6:	e8 30 01 00 00       	call   801deb <fmap>
  801cbb:	83 c4 10             	add    $0x10,%esp
              return r;
  801cbe:	89 c1                	mov    %eax,%ecx
  801cc0:	85 c0                	test   %eax,%eax
  801cc2:	78 52                	js     801d16 <file_write+0xe3>
  801cc4:	eb 1b                	jmp    801ce1 <file_write+0xae>
  801cc6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ccc:	83 ec 0c             	sub    $0xc,%esp
  801ccf:	56                   	push   %esi
  801cd0:	e8 87 f7 ff ff       	call   80145c <fd2data>
  801cd5:	01 f8                	add    %edi,%eax
  801cd7:	03 45 10             	add    0x10(%ebp),%eax
  801cda:	83 c4 10             	add    $0x10,%esp
  801cdd:	39 d8                	cmp    %ebx,%eax
  801cdf:	77 a9                	ja     801c8a <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801ce1:	83 ec 0c             	sub    $0xc,%esp
  801ce4:	68 76 30 80 00       	push   $0x803076
  801ce9:	e8 9e e6 ff ff       	call   80038c <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801cee:	83 c4 0c             	add    $0xc,%esp
  801cf1:	ff 75 10             	pushl  0x10(%ebp)
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	56                   	push   %esi
  801cf8:	e8 5f f7 ff ff       	call   80145c <fd2data>
  801cfd:	01 f8                	add    %edi,%eax
  801cff:	89 04 24             	mov    %eax,(%esp)
  801d02:	e8 05 ee ff ff       	call   800b0c <memmove>
        cprintf("write done\n");
  801d07:	c7 04 24 83 30 80 00 	movl   $0x803083,(%esp)
  801d0e:	e8 79 e6 ff ff       	call   80038c <cprintf>
	return n;
  801d13:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801d16:	89 c8                	mov    %ecx,%eax
  801d18:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801d1b:	5b                   	pop    %ebx
  801d1c:	5e                   	pop    %esi
  801d1d:	5f                   	pop    %edi
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	56                   	push   %esi
  801d24:	53                   	push   %ebx
  801d25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d28:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801d2b:	83 ec 08             	sub    $0x8,%esp
  801d2e:	8d 43 10             	lea    0x10(%ebx),%eax
  801d31:	50                   	push   %eax
  801d32:	56                   	push   %esi
  801d33:	e8 58 ec ff ff       	call   800990 <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801d38:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801d3e:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801d44:	83 c4 10             	add    $0x10,%esp
  801d47:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801d4e:	0f 94 c0             	sete   %al
  801d51:	0f b6 c0             	movzbl %al,%eax
  801d54:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5f:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801d62:	5b                   	pop    %ebx
  801d63:	5e                   	pop    %esi
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	57                   	push   %edi
  801d6a:	56                   	push   %esi
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 0c             	sub    $0xc,%esp
  801d6f:	8b 75 08             	mov    0x8(%ebp),%esi
  801d72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  801d75:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801d7a:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  801d80:	7f 5f                	jg     801de1 <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  801d82:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  801d88:	83 ec 08             	sub    $0x8,%esp
  801d8b:	53                   	push   %ebx
  801d8c:	ff 76 0c             	pushl  0xc(%esi)
  801d8f:	e8 3a 02 00 00       	call   801fce <fsipc_set_size>
  801d94:	83 c4 10             	add    $0x10,%esp
		return r;
  801d97:	89 c2                	mov    %eax,%edx
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	78 44                	js     801de1 <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  801d9d:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  801da3:	74 19                	je     801dbe <file_trunc+0x58>
  801da5:	68 b0 30 80 00       	push   $0x8030b0
  801daa:	68 8f 30 80 00       	push   $0x80308f
  801daf:	68 dc 00 00 00       	push   $0xdc
  801db4:	68 a4 30 80 00       	push   $0x8030a4
  801db9:	e8 de e4 ff ff       	call   80029c <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  801dbe:	83 ec 04             	sub    $0x4,%esp
  801dc1:	53                   	push   %ebx
  801dc2:	57                   	push   %edi
  801dc3:	56                   	push   %esi
  801dc4:	e8 22 00 00 00       	call   801deb <fmap>
  801dc9:	83 c4 10             	add    $0x10,%esp
		return r;
  801dcc:	89 c2                	mov    %eax,%edx
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 0f                	js     801de1 <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  801dd2:	6a 00                	push   $0x0
  801dd4:	53                   	push   %ebx
  801dd5:	57                   	push   %edi
  801dd6:	56                   	push   %esi
  801dd7:	e8 85 00 00 00       	call   801e61 <funmap>

	return 0;
  801ddc:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801de1:	89 d0                	mov    %edx,%eax
  801de3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5e                   	pop    %esi
  801de8:	5f                   	pop    %edi
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <fmap>:

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
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	57                   	push   %edi
  801def:	56                   	push   %esi
  801df0:	53                   	push   %ebx
  801df1:	83 ec 0c             	sub    $0xc,%esp
  801df4:	8b 7d 08             	mov    0x8(%ebp),%edi
  801df7:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  801dfa:	39 75 0c             	cmp    %esi,0xc(%ebp)
  801dfd:	7d 55                	jge    801e54 <fmap+0x69>
          fma = fd2data(fd);
  801dff:	83 ec 0c             	sub    $0xc,%esp
  801e02:	57                   	push   %edi
  801e03:	e8 54 f6 ff ff       	call   80145c <fd2data>
  801e08:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e11:	05 ff 0f 00 00       	add    $0xfff,%eax
  801e16:	89 c3                	mov    %eax,%ebx
  801e18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801e1e:	39 f3                	cmp    %esi,%ebx
  801e20:	7d 32                	jge    801e54 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  801e22:	83 ec 04             	sub    $0x4,%esp
  801e25:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801e28:	01 d8                	add    %ebx,%eax
  801e2a:	50                   	push   %eax
  801e2b:	53                   	push   %ebx
  801e2c:	ff 77 0c             	pushl  0xc(%edi)
  801e2f:	e8 6f 01 00 00       	call   801fa3 <fsipc_map>
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	85 c0                	test   %eax,%eax
  801e39:	79 0f                	jns    801e4a <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	ff 75 0c             	pushl  0xc(%ebp)
  801e40:	53                   	push   %ebx
  801e41:	57                   	push   %edi
  801e42:	e8 1a 00 00 00       	call   801e61 <funmap>
  801e47:	83 c4 10             	add    $0x10,%esp
  801e4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e50:	39 f3                	cmp    %esi,%ebx
  801e52:	7c ce                	jl     801e22 <fmap+0x37>
            }
          }
        }

        return 0;
}
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
  801e59:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801e5c:	5b                   	pop    %ebx
  801e5d:	5e                   	pop    %esi
  801e5e:	5f                   	pop    %edi
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <funmap>:

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
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	57                   	push   %edi
  801e65:	56                   	push   %esi
  801e66:	53                   	push   %ebx
  801e67:	83 ec 0c             	sub    $0xc,%esp
  801e6a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  801e70:	39 f3                	cmp    %esi,%ebx
  801e72:	0f 8d 80 00 00 00    	jge    801ef8 <funmap+0x97>
          fma = fd2data(fd);
  801e78:	83 ec 0c             	sub    $0xc,%esp
  801e7b:	ff 75 08             	pushl  0x8(%ebp)
  801e7e:	e8 d9 f5 ff ff       	call   80145c <fd2data>
  801e83:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  801e85:	83 c4 10             	add    $0x10,%esp
  801e88:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  801e8e:	89 c3                	mov    %eax,%ebx
  801e90:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801e96:	39 f3                	cmp    %esi,%ebx
  801e98:	7d 5e                	jge    801ef8 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  801e9a:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801e9d:	89 c2                	mov    %eax,%edx
  801e9f:	c1 ea 0c             	shr    $0xc,%edx
  801ea2:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801ea9:	a8 01                	test   $0x1,%al
  801eab:	74 41                	je     801eee <funmap+0x8d>
              if (dirty) {
  801ead:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  801eb1:	74 21                	je     801ed4 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  801eb3:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  801eba:	a8 40                	test   $0x40,%al
  801ebc:	74 16                	je     801ed4 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  801ebe:	83 ec 08             	sub    $0x8,%esp
  801ec1:	53                   	push   %ebx
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	ff 70 0c             	pushl  0xc(%eax)
  801ec8:	e8 49 01 00 00       	call   802016 <fsipc_dirty>
  801ecd:	83 c4 10             	add    $0x10,%esp
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	78 29                	js     801efd <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  801ed4:	83 ec 08             	sub    $0x8,%esp
  801ed7:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801eda:	50                   	push   %eax
  801edb:	83 ec 04             	sub    $0x4,%esp
  801ede:	e8 41 ee ff ff       	call   800d24 <sys_getenvid>
  801ee3:	89 04 24             	mov    %eax,(%esp)
  801ee6:	e8 fc ee ff ff       	call   800de7 <sys_page_unmap>
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ef4:	39 f3                	cmp    %esi,%ebx
  801ef6:	7c a2                	jl     801e9a <funmap+0x39>
            }
          }
        }

        return 0;
  801ef8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efd:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801f00:	5b                   	pop    %ebx
  801f01:	5e                   	pop    %esi
  801f02:	5f                   	pop    %edi
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <remove>:

// Delete a file
int
remove(const char *path)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
  801f08:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  801f0b:	ff 75 08             	pushl  0x8(%ebp)
  801f0e:	e8 2b 01 00 00       	call   80203e <fsipc_remove>
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  801f1b:	e8 64 01 00 00       	call   802084 <fsipc_sync>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    
	...

00801f24 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
  801f27:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  801f2a:	6a 07                	push   $0x7
  801f2c:	ff 75 0c             	pushl  0xc(%ebp)
  801f2f:	ff 75 08             	pushl  0x8(%ebp)
  801f32:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  801f37:	50                   	push   %eax
  801f38:	e8 7a 07 00 00       	call   8026b7 <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  801f3d:	83 c4 0c             	add    $0xc,%esp
  801f40:	ff 75 14             	pushl  0x14(%ebp)
  801f43:	ff 75 10             	pushl  0x10(%ebp)
  801f46:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801f49:	50                   	push   %eax
  801f4a:	e8 05 07 00 00       	call   802654 <ipc_recv>
}
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	56                   	push   %esi
  801f55:	53                   	push   %ebx
  801f56:	83 ec 1c             	sub    $0x1c,%esp
  801f59:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  801f5c:	bb 00 40 80 00       	mov    $0x804000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  801f61:	56                   	push   %esi
  801f62:	e8 ed e9 ff ff       	call   800954 <strlen>
  801f67:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  801f6a:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  801f6f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f74:	7f 24                	jg     801f9a <fsipc_open+0x49>
	strcpy(req->req_path, path);
  801f76:	83 ec 08             	sub    $0x8,%esp
  801f79:	56                   	push   %esi
  801f7a:	53                   	push   %ebx
  801f7b:	e8 10 ea ff ff       	call   800990 <strcpy>
	req->req_omode = omode;
  801f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f83:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  801f89:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801f8c:	50                   	push   %eax
  801f8d:	ff 75 10             	pushl  0x10(%ebp)
  801f90:	53                   	push   %ebx
  801f91:	6a 01                	push   $0x1
  801f93:	e8 8c ff ff ff       	call   801f24 <fsipc>
  801f98:	89 c2                	mov    %eax,%edx
}
  801f9a:	89 d0                	mov    %edx,%eax
  801f9c:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801f9f:	5b                   	pop    %ebx
  801fa0:	5e                   	pop    %esi
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  801fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb4:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  801fb9:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801fbc:	50                   	push   %eax
  801fbd:	ff 75 10             	pushl  0x10(%ebp)
  801fc0:	68 00 40 80 00       	push   $0x804000
  801fc5:	6a 02                	push   $0x2
  801fc7:	e8 58 ff ff ff       	call   801f24 <fsipc>

	//return -E_UNSPECIFIED;
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  801fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd7:	a3 00 40 80 00       	mov    %eax,0x804000
	req->req_size = size;
  801fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fdf:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	68 00 40 80 00       	push   $0x804000
  801fed:	6a 03                	push   $0x3
  801fef:	e8 30 ff ff ff       	call   801f24 <fsipc>
}
  801ff4:	c9                   	leave  
  801ff5:	c3                   	ret    

00801ff6 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	68 00 40 80 00       	push   $0x804000
  80200d:	6a 04                	push   $0x4
  80200f:	e8 10 ff ff ff       	call   801f24 <fsipc>
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  802024:	8b 45 0c             	mov    0xc(%ebp),%eax
  802027:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	68 00 40 80 00       	push   $0x804000
  802035:	6a 05                	push   $0x5
  802037:	e8 e8 fe ff ff       	call   801f24 <fsipc>
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	56                   	push   %esi
  802042:	53                   	push   %ebx
  802043:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  802046:	be 00 40 80 00       	mov    $0x804000,%esi
	if (strlen(path) >= MAXPATHLEN)
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	53                   	push   %ebx
  80204f:	e8 00 e9 ff ff       	call   800954 <strlen>
  802054:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  802057:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  80205c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802061:	7f 18                	jg     80207b <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  802063:	83 ec 08             	sub    $0x8,%esp
  802066:	53                   	push   %ebx
  802067:	56                   	push   %esi
  802068:	e8 23 e9 ff ff       	call   800990 <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	56                   	push   %esi
  802072:	6a 06                	push   $0x6
  802074:	e8 ab fe ff ff       	call   801f24 <fsipc>
  802079:	89 c2                	mov    %eax,%edx
}
  80207b:	89 d0                	mov    %edx,%eax
  80207d:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802080:	5b                   	pop    %ebx
  802081:	5e                   	pop    %esi
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	68 00 40 80 00       	push   $0x804000
  802093:	6a 07                	push   $0x7
  802095:	e8 8a fe ff ff       	call   801f24 <fsipc>
}
  80209a:	c9                   	leave  
  80209b:	c3                   	ret    

0080209c <pipe>:
};

int
pipe(int pfd[2])
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	57                   	push   %edi
  8020a0:	56                   	push   %esi
  8020a1:	53                   	push   %ebx
  8020a2:	83 ec 18             	sub    $0x18,%esp
  8020a5:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020a8:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8020ab:	50                   	push   %eax
  8020ac:	e8 d3 f3 ff ff       	call   801484 <fd_alloc>
  8020b1:	89 c3                	mov    %eax,%ebx
  8020b3:	83 c4 10             	add    $0x10,%esp
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	0f 88 25 01 00 00    	js     8021e3 <pipe+0x147>
  8020be:	83 ec 04             	sub    $0x4,%esp
  8020c1:	68 07 04 00 00       	push   $0x407
  8020c6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8020c9:	6a 00                	push   $0x0
  8020cb:	e8 92 ec ff ff       	call   800d62 <sys_page_alloc>
  8020d0:	89 c3                	mov    %eax,%ebx
  8020d2:	83 c4 10             	add    $0x10,%esp
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	0f 88 06 01 00 00    	js     8021e3 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8020dd:	83 ec 0c             	sub    $0xc,%esp
  8020e0:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  8020e3:	50                   	push   %eax
  8020e4:	e8 9b f3 ff ff       	call   801484 <fd_alloc>
  8020e9:	89 c3                	mov    %eax,%ebx
  8020eb:	83 c4 10             	add    $0x10,%esp
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	0f 88 dd 00 00 00    	js     8021d3 <pipe+0x137>
  8020f6:	83 ec 04             	sub    $0x4,%esp
  8020f9:	68 07 04 00 00       	push   $0x407
  8020fe:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802101:	6a 00                	push   $0x0
  802103:	e8 5a ec ff ff       	call   800d62 <sys_page_alloc>
  802108:	89 c3                	mov    %eax,%ebx
  80210a:	83 c4 10             	add    $0x10,%esp
  80210d:	85 c0                	test   %eax,%eax
  80210f:	0f 88 be 00 00 00    	js     8021d3 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802115:	83 ec 0c             	sub    $0xc,%esp
  802118:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80211b:	e8 3c f3 ff ff       	call   80145c <fd2data>
  802120:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802122:	83 c4 0c             	add    $0xc,%esp
  802125:	68 07 04 00 00       	push   $0x407
  80212a:	50                   	push   %eax
  80212b:	6a 00                	push   $0x0
  80212d:	e8 30 ec ff ff       	call   800d62 <sys_page_alloc>
  802132:	89 c3                	mov    %eax,%ebx
  802134:	83 c4 10             	add    $0x10,%esp
  802137:	85 c0                	test   %eax,%eax
  802139:	0f 88 84 00 00 00    	js     8021c3 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80213f:	83 ec 0c             	sub    $0xc,%esp
  802142:	68 07 04 00 00       	push   $0x407
  802147:	83 ec 0c             	sub    $0xc,%esp
  80214a:	ff 75 ec             	pushl  0xffffffec(%ebp)
  80214d:	e8 0a f3 ff ff       	call   80145c <fd2data>
  802152:	83 c4 10             	add    $0x10,%esp
  802155:	50                   	push   %eax
  802156:	6a 00                	push   $0x0
  802158:	56                   	push   %esi
  802159:	6a 00                	push   $0x0
  80215b:	e8 45 ec ff ff       	call   800da5 <sys_page_map>
  802160:	89 c3                	mov    %eax,%ebx
  802162:	83 c4 20             	add    $0x20,%esp
  802165:	85 c0                	test   %eax,%eax
  802167:	78 4c                	js     8021b5 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802169:	8b 15 40 70 80 00    	mov    0x807040,%edx
  80216f:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802172:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802174:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802177:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80217e:	8b 15 40 70 80 00    	mov    0x807040,%edx
  802184:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802187:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802189:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  80218c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802193:	83 ec 0c             	sub    $0xc,%esp
  802196:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802199:	e8 d6 f2 ff ff       	call   801474 <fd2num>
  80219e:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8021a0:	83 c4 04             	add    $0x4,%esp
  8021a3:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8021a6:	e8 c9 f2 ff ff       	call   801474 <fd2num>
  8021ab:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b3:	eb 30                	jmp    8021e5 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  8021b5:	83 ec 08             	sub    $0x8,%esp
  8021b8:	56                   	push   %esi
  8021b9:	6a 00                	push   $0x0
  8021bb:	e8 27 ec ff ff       	call   800de7 <sys_page_unmap>
  8021c0:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  8021c3:	83 ec 08             	sub    $0x8,%esp
  8021c6:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8021c9:	6a 00                	push   $0x0
  8021cb:	e8 17 ec ff ff       	call   800de7 <sys_page_unmap>
  8021d0:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  8021d3:	83 ec 08             	sub    $0x8,%esp
  8021d6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8021d9:	6a 00                	push   $0x0
  8021db:	e8 07 ec ff ff       	call   800de7 <sys_page_unmap>
  8021e0:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  8021e3:	89 d8                	mov    %ebx,%eax
}
  8021e5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8021e8:	5b                   	pop    %ebx
  8021e9:	5e                   	pop    %esi
  8021ea:	5f                   	pop    %edi
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	57                   	push   %edi
  8021f1:	56                   	push   %esi
  8021f2:	53                   	push   %ebx
  8021f3:	83 ec 0c             	sub    $0xc,%esp
  8021f6:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8021f9:	a1 80 70 80 00       	mov    0x807080,%eax
  8021fe:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  802201:	83 ec 0c             	sub    $0xc,%esp
  802204:	ff 75 08             	pushl  0x8(%ebp)
  802207:	e8 04 05 00 00       	call   802710 <pageref>
  80220c:	89 c3                	mov    %eax,%ebx
  80220e:	89 3c 24             	mov    %edi,(%esp)
  802211:	e8 fa 04 00 00       	call   802710 <pageref>
  802216:	83 c4 10             	add    $0x10,%esp
  802219:	39 c3                	cmp    %eax,%ebx
  80221b:	0f 94 c0             	sete   %al
  80221e:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  802221:	8b 0d 80 70 80 00    	mov    0x807080,%ecx
  802227:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  80222a:	39 c6                	cmp    %eax,%esi
  80222c:	74 1b                	je     802249 <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  80222e:	83 fa 01             	cmp    $0x1,%edx
  802231:	75 c6                	jne    8021f9 <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802233:	6a 01                	push   $0x1
  802235:	8b 41 58             	mov    0x58(%ecx),%eax
  802238:	50                   	push   %eax
  802239:	56                   	push   %esi
  80223a:	68 d3 30 80 00       	push   $0x8030d3
  80223f:	e8 48 e1 ff ff       	call   80038c <cprintf>
  802244:	83 c4 10             	add    $0x10,%esp
  802247:	eb b0                	jmp    8021f9 <_pipeisclosed+0xc>
	}
}
  802249:	89 d0                	mov    %edx,%eax
  80224b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80224e:	5b                   	pop    %ebx
  80224f:	5e                   	pop    %esi
  802250:	5f                   	pop    %edi
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802259:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80225c:	50                   	push   %eax
  80225d:	ff 75 08             	pushl  0x8(%ebp)
  802260:	e8 79 f2 ff ff       	call   8014de <fd_lookup>
  802265:	83 c4 10             	add    $0x10,%esp
		return r;
  802268:	89 c2                	mov    %eax,%edx
  80226a:	85 c0                	test   %eax,%eax
  80226c:	78 19                	js     802287 <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  80226e:	83 ec 0c             	sub    $0xc,%esp
  802271:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802274:	e8 e3 f1 ff ff       	call   80145c <fd2data>
	return _pipeisclosed(fd, p);
  802279:	83 c4 08             	add    $0x8,%esp
  80227c:	50                   	push   %eax
  80227d:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802280:	e8 68 ff ff ff       	call   8021ed <_pipeisclosed>
  802285:	89 c2                	mov    %eax,%edx
}
  802287:	89 d0                	mov    %edx,%eax
  802289:	c9                   	leave  
  80228a:	c3                   	ret    

0080228b <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	57                   	push   %edi
  80228f:	56                   	push   %esi
  802290:	53                   	push   %ebx
  802291:	83 ec 18             	sub    $0x18,%esp
  802294:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  802297:	57                   	push   %edi
  802298:	e8 bf f1 ff ff       	call   80145c <fd2data>
  80229d:	89 c3                	mov    %eax,%ebx
	if (debug)
  80229f:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  8022a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a5:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  8022a8:	be 00 00 00 00       	mov    $0x0,%esi
  8022ad:	3b 75 10             	cmp    0x10(%ebp),%esi
  8022b0:	73 55                	jae    802307 <piperead+0x7c>
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
  8022b2:	8b 03                	mov    (%ebx),%eax
  8022b4:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022b7:	75 2c                	jne    8022e5 <piperead+0x5a>
  8022b9:	85 f6                	test   %esi,%esi
  8022bb:	74 04                	je     8022c1 <piperead+0x36>
  8022bd:	89 f0                	mov    %esi,%eax
  8022bf:	eb 48                	jmp    802309 <piperead+0x7e>
  8022c1:	83 ec 08             	sub    $0x8,%esp
  8022c4:	53                   	push   %ebx
  8022c5:	57                   	push   %edi
  8022c6:	e8 22 ff ff ff       	call   8021ed <_pipeisclosed>
  8022cb:	83 c4 10             	add    $0x10,%esp
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	74 07                	je     8022d9 <piperead+0x4e>
  8022d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d7:	eb 30                	jmp    802309 <piperead+0x7e>
  8022d9:	e8 65 ea ff ff       	call   800d43 <sys_yield>
  8022de:	8b 03                	mov    (%ebx),%eax
  8022e0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022e3:	74 d4                	je     8022b9 <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022e5:	8b 13                	mov    (%ebx),%edx
  8022e7:	89 d0                	mov    %edx,%eax
  8022e9:	85 d2                	test   %edx,%edx
  8022eb:	79 03                	jns    8022f0 <piperead+0x65>
  8022ed:	8d 42 1f             	lea    0x1f(%edx),%eax
  8022f0:	83 e0 e0             	and    $0xffffffe0,%eax
  8022f3:	29 c2                	sub    %eax,%edx
  8022f5:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  8022f9:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8022fc:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8022ff:	ff 03                	incl   (%ebx)
  802301:	46                   	inc    %esi
  802302:	3b 75 10             	cmp    0x10(%ebp),%esi
  802305:	72 ab                	jb     8022b2 <piperead+0x27>
	}
	return i;
  802307:	89 f0                	mov    %esi,%eax
}
  802309:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80230c:	5b                   	pop    %ebx
  80230d:	5e                   	pop    %esi
  80230e:	5f                   	pop    %edi
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	57                   	push   %edi
  802315:	56                   	push   %esi
  802316:	53                   	push   %ebx
  802317:	83 ec 18             	sub    $0x18,%esp
  80231a:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  80231d:	57                   	push   %edi
  80231e:	e8 39 f1 ff ff       	call   80145c <fd2data>
  802323:	89 c3                	mov    %eax,%ebx
	if (debug)
  802325:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232b:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  80232e:	be 00 00 00 00       	mov    $0x0,%esi
  802333:	3b 75 10             	cmp    0x10(%ebp),%esi
  802336:	73 55                	jae    80238d <pipewrite+0x7c>
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
  802338:	8b 03                	mov    (%ebx),%eax
  80233a:	83 c0 20             	add    $0x20,%eax
  80233d:	39 43 04             	cmp    %eax,0x4(%ebx)
  802340:	72 27                	jb     802369 <pipewrite+0x58>
  802342:	83 ec 08             	sub    $0x8,%esp
  802345:	53                   	push   %ebx
  802346:	57                   	push   %edi
  802347:	e8 a1 fe ff ff       	call   8021ed <_pipeisclosed>
  80234c:	83 c4 10             	add    $0x10,%esp
  80234f:	85 c0                	test   %eax,%eax
  802351:	74 07                	je     80235a <pipewrite+0x49>
  802353:	b8 00 00 00 00       	mov    $0x0,%eax
  802358:	eb 35                	jmp    80238f <pipewrite+0x7e>
  80235a:	e8 e4 e9 ff ff       	call   800d43 <sys_yield>
  80235f:	8b 03                	mov    (%ebx),%eax
  802361:	83 c0 20             	add    $0x20,%eax
  802364:	39 43 04             	cmp    %eax,0x4(%ebx)
  802367:	73 d9                	jae    802342 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802369:	8b 53 04             	mov    0x4(%ebx),%edx
  80236c:	89 d0                	mov    %edx,%eax
  80236e:	85 d2                	test   %edx,%edx
  802370:	79 03                	jns    802375 <pipewrite+0x64>
  802372:	8d 42 1f             	lea    0x1f(%edx),%eax
  802375:	83 e0 e0             	and    $0xffffffe0,%eax
  802378:	29 c2                	sub    %eax,%edx
  80237a:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  80237d:	8a 04 31             	mov    (%ecx,%esi,1),%al
  802380:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802384:	ff 43 04             	incl   0x4(%ebx)
  802387:	46                   	inc    %esi
  802388:	3b 75 10             	cmp    0x10(%ebp),%esi
  80238b:	72 ab                	jb     802338 <pipewrite+0x27>
	}
	
	return i;
  80238d:	89 f0                	mov    %esi,%eax
}
  80238f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802392:	5b                   	pop    %ebx
  802393:	5e                   	pop    %esi
  802394:	5f                   	pop    %edi
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
  80239a:	56                   	push   %esi
  80239b:	53                   	push   %ebx
  80239c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80239f:	83 ec 0c             	sub    $0xc,%esp
  8023a2:	ff 75 08             	pushl  0x8(%ebp)
  8023a5:	e8 b2 f0 ff ff       	call   80145c <fd2data>
  8023aa:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023ac:	83 c4 08             	add    $0x8,%esp
  8023af:	68 e6 30 80 00       	push   $0x8030e6
  8023b4:	53                   	push   %ebx
  8023b5:	e8 d6 e5 ff ff       	call   800990 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023ba:	8b 46 04             	mov    0x4(%esi),%eax
  8023bd:	2b 06                	sub    (%esi),%eax
  8023bf:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023c5:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023cc:	00 00 00 
	stat->st_dev = &devpipe;
  8023cf:	c7 83 88 00 00 00 40 	movl   $0x807040,0x88(%ebx)
  8023d6:	70 80 00 
	return 0;
}
  8023d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023de:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	53                   	push   %ebx
  8023e9:	83 ec 0c             	sub    $0xc,%esp
  8023ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023ef:	53                   	push   %ebx
  8023f0:	6a 00                	push   $0x0
  8023f2:	e8 f0 e9 ff ff       	call   800de7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023f7:	89 1c 24             	mov    %ebx,(%esp)
  8023fa:	e8 5d f0 ff ff       	call   80145c <fd2data>
  8023ff:	83 c4 08             	add    $0x8,%esp
  802402:	50                   	push   %eax
  802403:	6a 00                	push   $0x0
  802405:	e8 dd e9 ff ff       	call   800de7 <sys_page_unmap>
}
  80240a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80240d:	c9                   	leave  
  80240e:	c3                   	ret    
	...

00802410 <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  802416:	8b 45 08             	mov    0x8(%ebp),%eax
  802419:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80241c:	6a 01                	push   $0x1
  80241e:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802421:	50                   	push   %eax
  802422:	e8 79 e8 ff ff       	call   800ca0 <sys_cputs>
}
  802427:	c9                   	leave  
  802428:	c3                   	ret    

00802429 <getchar>:

int
getchar(void)
{
  802429:	55                   	push   %ebp
  80242a:	89 e5                	mov    %esp,%ebp
  80242c:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80242f:	6a 01                	push   $0x1
  802431:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  802434:	50                   	push   %eax
  802435:	6a 00                	push   $0x0
  802437:	e8 35 f3 ff ff       	call   801771 <read>
	if (r < 0)
  80243c:	83 c4 10             	add    $0x10,%esp
		return r;
  80243f:	89 c2                	mov    %eax,%edx
  802441:	85 c0                	test   %eax,%eax
  802443:	78 0d                	js     802452 <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  802445:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  80244a:	85 c0                	test   %eax,%eax
  80244c:	7e 04                	jle    802452 <getchar+0x29>
	return c;
  80244e:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  802452:	89 d0                	mov    %edx,%eax
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <iscons>:


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
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
  802459:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80245c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80245f:	50                   	push   %eax
  802460:	ff 75 08             	pushl  0x8(%ebp)
  802463:	e8 76 f0 ff ff       	call   8014de <fd_lookup>
  802468:	83 c4 10             	add    $0x10,%esp
		return r;
  80246b:	89 c2                	mov    %eax,%edx
  80246d:	85 c0                	test   %eax,%eax
  80246f:	78 11                	js     802482 <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  802471:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  802474:	8b 00                	mov    (%eax),%eax
  802476:	3b 05 60 70 80 00    	cmp    0x807060,%eax
  80247c:	0f 94 c0             	sete   %al
  80247f:	0f b6 d0             	movzbl %al,%edx
}
  802482:	89 d0                	mov    %edx,%eax
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <opencons>:

int
opencons(void)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80248c:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80248f:	50                   	push   %eax
  802490:	e8 ef ef ff ff       	call   801484 <fd_alloc>
  802495:	83 c4 10             	add    $0x10,%esp
		return r;
  802498:	89 c2                	mov    %eax,%edx
  80249a:	85 c0                	test   %eax,%eax
  80249c:	78 3c                	js     8024da <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80249e:	83 ec 04             	sub    $0x4,%esp
  8024a1:	68 07 04 00 00       	push   $0x407
  8024a6:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8024a9:	6a 00                	push   $0x0
  8024ab:	e8 b2 e8 ff ff       	call   800d62 <sys_page_alloc>
  8024b0:	83 c4 10             	add    $0x10,%esp
		return r;
  8024b3:	89 c2                	mov    %eax,%edx
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	78 21                	js     8024da <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8024b9:	a1 60 70 80 00       	mov    0x807060,%eax
  8024be:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  8024c1:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  8024c3:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8024c6:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024cd:	83 ec 0c             	sub    $0xc,%esp
  8024d0:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8024d3:	e8 9c ef ff ff       	call   801474 <fd2num>
  8024d8:	89 c2                	mov    %eax,%edx
}
  8024da:	89 d0                	mov    %edx,%eax
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024ed:	74 2a                	je     802519 <cons_read+0x3b>
  8024ef:	eb 05                	jmp    8024f6 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8024f1:	e8 4d e8 ff ff       	call   800d43 <sys_yield>
  8024f6:	e8 c9 e7 ff ff       	call   800cc4 <sys_cgetc>
  8024fb:	89 c2                	mov    %eax,%edx
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	74 f0                	je     8024f1 <cons_read+0x13>
	if (c < 0)
  802501:	85 d2                	test   %edx,%edx
  802503:	78 14                	js     802519 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802505:	b8 00 00 00 00       	mov    $0x0,%eax
  80250a:	83 fa 04             	cmp    $0x4,%edx
  80250d:	74 0a                	je     802519 <cons_read+0x3b>
	*(char*)vbuf = c;
  80250f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802512:	88 10                	mov    %dl,(%eax)
	return 1;
  802514:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	57                   	push   %edi
  80251f:	56                   	push   %esi
  802520:	53                   	push   %ebx
  802521:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  802527:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80252a:	be 00 00 00 00       	mov    $0x0,%esi
  80252f:	39 fe                	cmp    %edi,%esi
  802531:	73 3d                	jae    802570 <cons_write+0x55>
		m = n - tot;
  802533:	89 fb                	mov    %edi,%ebx
  802535:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  802537:	83 fb 7f             	cmp    $0x7f,%ebx
  80253a:	76 05                	jbe    802541 <cons_write+0x26>
			m = sizeof(buf) - 1;
  80253c:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802541:	83 ec 04             	sub    $0x4,%esp
  802544:	53                   	push   %ebx
  802545:	8b 45 0c             	mov    0xc(%ebp),%eax
  802548:	01 f0                	add    %esi,%eax
  80254a:	50                   	push   %eax
  80254b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802551:	50                   	push   %eax
  802552:	e8 b5 e5 ff ff       	call   800b0c <memmove>
		sys_cputs(buf, m);
  802557:	83 c4 08             	add    $0x8,%esp
  80255a:	53                   	push   %ebx
  80255b:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  802561:	50                   	push   %eax
  802562:	e8 39 e7 ff ff       	call   800ca0 <sys_cputs>
  802567:	83 c4 10             	add    $0x10,%esp
  80256a:	01 de                	add    %ebx,%esi
  80256c:	39 fe                	cmp    %edi,%esi
  80256e:	72 c3                	jb     802533 <cons_write+0x18>
	}
	return tot;
}
  802570:	89 f0                	mov    %esi,%eax
  802572:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802575:	5b                   	pop    %ebx
  802576:	5e                   	pop    %esi
  802577:	5f                   	pop    %edi
  802578:	c9                   	leave  
  802579:	c3                   	ret    

0080257a <cons_close>:

int
cons_close(struct Fd *fd)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80257d:	b8 00 00 00 00       	mov    $0x0,%eax
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80258a:	68 f2 30 80 00       	push   $0x8030f2
  80258f:	ff 75 0c             	pushl  0xc(%ebp)
  802592:	e8 f9 e3 ff ff       	call   800990 <strcpy>
	return 0;
}
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
  80259c:	c9                   	leave  
  80259d:	c3                   	ret    
	...

008025a0 <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8025a0:	55                   	push   %ebp
  8025a1:	89 e5                	mov    %esp,%ebp
  8025a3:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8025a6:	83 3d 88 70 80 00 00 	cmpl   $0x0,0x807088
  8025ad:	75 68                	jne    802617 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  8025af:	83 ec 04             	sub    $0x4,%esp
  8025b2:	6a 07                	push   $0x7
  8025b4:	68 00 f0 bf ee       	push   $0xeebff000
  8025b9:	83 ec 04             	sub    $0x4,%esp
  8025bc:	e8 63 e7 ff ff       	call   800d24 <sys_getenvid>
  8025c1:	89 04 24             	mov    %eax,(%esp)
  8025c4:	e8 99 e7 ff ff       	call   800d62 <sys_page_alloc>
  8025c9:	83 c4 10             	add    $0x10,%esp
  8025cc:	85 c0                	test   %eax,%eax
  8025ce:	79 14                	jns    8025e4 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  8025d0:	83 ec 04             	sub    $0x4,%esp
  8025d3:	68 fc 30 80 00       	push   $0x8030fc
  8025d8:	6a 21                	push   $0x21
  8025da:	68 5d 31 80 00       	push   $0x80315d
  8025df:	e8 b8 dc ff ff       	call   80029c <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  8025e4:	83 ec 08             	sub    $0x8,%esp
  8025e7:	68 24 26 80 00       	push   $0x802624
  8025ec:	83 ec 04             	sub    $0x4,%esp
  8025ef:	e8 30 e7 ff ff       	call   800d24 <sys_getenvid>
  8025f4:	89 04 24             	mov    %eax,(%esp)
  8025f7:	e8 b1 e8 ff ff       	call   800ead <sys_env_set_pgfault_upcall>
  8025fc:	83 c4 10             	add    $0x10,%esp
  8025ff:	85 c0                	test   %eax,%eax
  802601:	79 14                	jns    802617 <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  802603:	83 ec 04             	sub    $0x4,%esp
  802606:	68 2c 31 80 00       	push   $0x80312c
  80260b:	6a 24                	push   $0x24
  80260d:	68 5d 31 80 00       	push   $0x80315d
  802612:	e8 85 dc ff ff       	call   80029c <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802617:	8b 45 08             	mov    0x8(%ebp),%eax
  80261a:	a3 88 70 80 00       	mov    %eax,0x807088
}
  80261f:	c9                   	leave  
  802620:	c3                   	ret    
  802621:	00 00                	add    %al,(%eax)
	...

00802624 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802624:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802625:	a1 88 70 80 00       	mov    0x807088,%eax
	call *%eax
  80262a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80262c:	83 c4 04             	add    $0x4,%esp
	
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
  80262f:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  802633:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  802637:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  80263a:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  80263d:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  802640:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  802644:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  802647:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  80264b:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  80264c:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  80264f:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  802650:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  802651:	c3                   	ret    
	...

00802654 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802654:	55                   	push   %ebp
  802655:	89 e5                	mov    %esp,%ebp
  802657:	56                   	push   %esi
  802658:	53                   	push   %ebx
  802659:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80265c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265f:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  802662:	85 c0                	test   %eax,%eax
  802664:	75 12                	jne    802678 <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  802666:	83 ec 0c             	sub    $0xc,%esp
  802669:	68 00 00 c0 ee       	push   $0xeec00000
  80266e:	e8 9f e8 ff ff       	call   800f12 <sys_ipc_recv>
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	eb 0c                	jmp    802684 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802678:	83 ec 0c             	sub    $0xc,%esp
  80267b:	50                   	push   %eax
  80267c:	e8 91 e8 ff ff       	call   800f12 <sys_ipc_recv>
  802681:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802684:	89 c2                	mov    %eax,%edx
  802686:	85 c0                	test   %eax,%eax
  802688:	78 24                	js     8026ae <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  80268a:	85 db                	test   %ebx,%ebx
  80268c:	74 0a                	je     802698 <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  80268e:	a1 80 70 80 00       	mov    0x807080,%eax
  802693:	8b 40 74             	mov    0x74(%eax),%eax
  802696:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802698:	85 f6                	test   %esi,%esi
  80269a:	74 0a                	je     8026a6 <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  80269c:	a1 80 70 80 00       	mov    0x807080,%eax
  8026a1:	8b 40 78             	mov    0x78(%eax),%eax
  8026a4:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  8026a6:	a1 80 70 80 00       	mov    0x807080,%eax
  8026ab:	8b 50 70             	mov    0x70(%eax),%edx

}
  8026ae:	89 d0                	mov    %edx,%eax
  8026b0:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  8026b3:	5b                   	pop    %ebx
  8026b4:	5e                   	pop    %esi
  8026b5:	c9                   	leave  
  8026b6:	c3                   	ret    

008026b7 <ipc_send>:

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
  8026b7:	55                   	push   %ebp
  8026b8:	89 e5                	mov    %esp,%ebp
  8026ba:	57                   	push   %edi
  8026bb:	56                   	push   %esi
  8026bc:	53                   	push   %ebx
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8026c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026c6:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  8026c9:	85 db                	test   %ebx,%ebx
  8026cb:	75 0a                	jne    8026d7 <ipc_send+0x20>
    pg = (void *) UTOP;
  8026cd:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  8026d2:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  8026d7:	56                   	push   %esi
  8026d8:	53                   	push   %ebx
  8026d9:	57                   	push   %edi
  8026da:	ff 75 08             	pushl  0x8(%ebp)
  8026dd:	e8 0d e8 ff ff       	call   800eef <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  8026e2:	83 c4 10             	add    $0x10,%esp
  8026e5:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026e8:	75 07                	jne    8026f1 <ipc_send+0x3a>
      sys_yield();
  8026ea:	e8 54 e6 ff ff       	call   800d43 <sys_yield>
  8026ef:	eb e6                	jmp    8026d7 <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	79 12                	jns    802707 <ipc_send+0x50>
  8026f5:	50                   	push   %eax
  8026f6:	68 6b 31 80 00       	push   $0x80316b
  8026fb:	6a 49                	push   $0x49
  8026fd:	68 88 31 80 00       	push   $0x803188
  802702:	e8 95 db ff ff       	call   80029c <_panic>
    else break;
  }
}
  802707:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80270a:	5b                   	pop    %ebx
  80270b:	5e                   	pop    %esi
  80270c:	5f                   	pop    %edi
  80270d:	c9                   	leave  
  80270e:	c3                   	ret    
	...

00802710 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802716:	89 c8                	mov    %ecx,%eax
  802718:	c1 e8 16             	shr    $0x16,%eax
  80271b:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  802722:	ba 00 00 00 00       	mov    $0x0,%edx
  802727:	a8 01                	test   $0x1,%al
  802729:	74 28                	je     802753 <pageref+0x43>
	pte = vpt[VPN(v)];
  80272b:	89 c8                	mov    %ecx,%eax
  80272d:	c1 e8 0c             	shr    $0xc,%eax
  802730:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  802737:	ba 00 00 00 00       	mov    $0x0,%edx
  80273c:	a8 01                	test   $0x1,%al
  80273e:	74 13                	je     802753 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  802740:	c1 e8 0c             	shr    $0xc,%eax
  802743:	8d 04 40             	lea    (%eax,%eax,2),%eax
  802746:	c1 e0 02             	shl    $0x2,%eax
  802749:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802750:	0f b7 d0             	movzwl %ax,%edx
}
  802753:	89 d0                	mov    %edx,%eax
  802755:	c9                   	leave  
  802756:	c3                   	ret    
	...

00802758 <__udivdi3>:
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
  80275b:	57                   	push   %edi
  80275c:	56                   	push   %esi
  80275d:	83 ec 14             	sub    $0x14,%esp
  802760:	8b 55 14             	mov    0x14(%ebp),%edx
  802763:	8b 75 08             	mov    0x8(%ebp),%esi
  802766:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802769:	8b 45 10             	mov    0x10(%ebp),%eax
  80276c:	85 d2                	test   %edx,%edx
  80276e:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802771:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802774:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802777:	89 fe                	mov    %edi,%esi
  802779:	75 11                	jne    80278c <__udivdi3+0x34>
  80277b:	39 f8                	cmp    %edi,%eax
  80277d:	76 4d                	jbe    8027cc <__udivdi3+0x74>
  80277f:	89 fa                	mov    %edi,%edx
  802781:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802784:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802787:	89 c7                	mov    %eax,%edi
  802789:	eb 09                	jmp    802794 <__udivdi3+0x3c>
  80278b:	90                   	nop    
  80278c:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  80278f:	76 17                	jbe    8027a8 <__udivdi3+0x50>
  802791:	31 ff                	xor    %edi,%edi
  802793:	90                   	nop    
  802794:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  80279b:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  80279e:	83 c4 14             	add    $0x14,%esp
  8027a1:	5e                   	pop    %esi
  8027a2:	89 f8                	mov    %edi,%eax
  8027a4:	5f                   	pop    %edi
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    
  8027a7:	90                   	nop    
  8027a8:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  8027ac:	89 c7                	mov    %eax,%edi
  8027ae:	83 f7 1f             	xor    $0x1f,%edi
  8027b1:	75 4d                	jne    802800 <__udivdi3+0xa8>
  8027b3:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8027b6:	77 0a                	ja     8027c2 <__udivdi3+0x6a>
  8027b8:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8027bb:	31 ff                	xor    %edi,%edi
  8027bd:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  8027c0:	72 d2                	jb     802794 <__udivdi3+0x3c>
  8027c2:	bf 01 00 00 00       	mov    $0x1,%edi
  8027c7:	eb cb                	jmp    802794 <__udivdi3+0x3c>
  8027c9:	8d 76 00             	lea    0x0(%esi),%esi
  8027cc:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	75 0e                	jne    8027e1 <__udivdi3+0x89>
  8027d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8027d8:	31 c9                	xor    %ecx,%ecx
  8027da:	31 d2                	xor    %edx,%edx
  8027dc:	f7 f1                	div    %ecx
  8027de:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  8027e1:	89 f0                	mov    %esi,%eax
  8027e3:	31 d2                	xor    %edx,%edx
  8027e5:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8027e8:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  8027eb:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8027ee:	f7 75 e4             	divl   0xffffffe4(%ebp)
  8027f1:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  8027f4:	83 c4 14             	add    $0x14,%esp
  8027f7:	89 c7                	mov    %eax,%edi
  8027f9:	5e                   	pop    %esi
  8027fa:	89 f8                	mov    %edi,%eax
  8027fc:	5f                   	pop    %edi
  8027fd:	c9                   	leave  
  8027fe:	c3                   	ret    
  8027ff:	90                   	nop    
  802800:	b8 20 00 00 00       	mov    $0x20,%eax
  802805:	29 f8                	sub    %edi,%eax
  802807:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  80280a:	89 f9                	mov    %edi,%ecx
  80280c:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  80280f:	d3 e2                	shl    %cl,%edx
  802811:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802814:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802817:	d3 e8                	shr    %cl,%eax
  802819:	09 c2                	or     %eax,%edx
  80281b:	89 f9                	mov    %edi,%ecx
  80281d:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  802820:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802823:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802826:	89 f2                	mov    %esi,%edx
  802828:	d3 ea                	shr    %cl,%edx
  80282a:	89 f9                	mov    %edi,%ecx
  80282c:	d3 e6                	shl    %cl,%esi
  80282e:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802831:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802834:	d3 e8                	shr    %cl,%eax
  802836:	09 c6                	or     %eax,%esi
  802838:	89 f9                	mov    %edi,%ecx
  80283a:	89 f0                	mov    %esi,%eax
  80283c:	f7 75 f4             	divl   0xfffffff4(%ebp)
  80283f:	89 d6                	mov    %edx,%esi
  802841:	89 c7                	mov    %eax,%edi
  802843:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  802846:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802849:	f7 e7                	mul    %edi
  80284b:	39 f2                	cmp    %esi,%edx
  80284d:	77 0f                	ja     80285e <__udivdi3+0x106>
  80284f:	0f 85 3f ff ff ff    	jne    802794 <__udivdi3+0x3c>
  802855:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802858:	0f 86 36 ff ff ff    	jbe    802794 <__udivdi3+0x3c>
  80285e:	4f                   	dec    %edi
  80285f:	e9 30 ff ff ff       	jmp    802794 <__udivdi3+0x3c>

00802864 <__umoddi3>:
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
  802867:	57                   	push   %edi
  802868:	56                   	push   %esi
  802869:	83 ec 30             	sub    $0x30,%esp
  80286c:	8b 55 14             	mov    0x14(%ebp),%edx
  80286f:	8b 45 10             	mov    0x10(%ebp),%eax
  802872:	89 d7                	mov    %edx,%edi
  802874:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  802877:	89 c6                	mov    %eax,%esi
  802879:	8b 55 0c             	mov    0xc(%ebp),%edx
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	85 ff                	test   %edi,%edi
  802881:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802888:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  80288f:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  802892:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802895:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802898:	75 3e                	jne    8028d8 <__umoddi3+0x74>
  80289a:	39 d6                	cmp    %edx,%esi
  80289c:	0f 86 a2 00 00 00    	jbe    802944 <__umoddi3+0xe0>
  8028a2:	f7 f6                	div    %esi
  8028a4:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  8028a7:	85 c9                	test   %ecx,%ecx
  8028a9:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  8028ac:	74 1b                	je     8028c9 <__umoddi3+0x65>
  8028ae:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8028b1:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  8028b4:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  8028bb:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8028be:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  8028c1:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  8028c4:	89 10                	mov    %edx,(%eax)
  8028c6:	89 48 04             	mov    %ecx,0x4(%eax)
  8028c9:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8028cc:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  8028cf:	83 c4 30             	add    $0x30,%esp
  8028d2:	5e                   	pop    %esi
  8028d3:	5f                   	pop    %edi
  8028d4:	c9                   	leave  
  8028d5:	c3                   	ret    
  8028d6:	89 f6                	mov    %esi,%esi
  8028d8:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  8028db:	76 1f                	jbe    8028fc <__umoddi3+0x98>
  8028dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e0:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8028e3:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  8028e6:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  8028e9:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  8028ec:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  8028ef:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  8028f2:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  8028f5:	83 c4 30             	add    $0x30,%esp
  8028f8:	5e                   	pop    %esi
  8028f9:	5f                   	pop    %edi
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    
  8028fc:	0f bd c7             	bsr    %edi,%eax
  8028ff:	83 f0 1f             	xor    $0x1f,%eax
  802902:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  802905:	75 61                	jne    802968 <__umoddi3+0x104>
  802907:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  80290a:	77 05                	ja     802911 <__umoddi3+0xad>
  80290c:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  80290f:	72 10                	jb     802921 <__umoddi3+0xbd>
  802911:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  802914:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802917:	29 f0                	sub    %esi,%eax
  802919:	19 fa                	sbb    %edi,%edx
  80291b:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  80291e:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802921:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802924:	85 d2                	test   %edx,%edx
  802926:	74 a1                	je     8028c9 <__umoddi3+0x65>
  802928:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80292b:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80292e:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802931:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  802934:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802937:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80293a:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  80293d:	89 01                	mov    %eax,(%ecx)
  80293f:	89 51 04             	mov    %edx,0x4(%ecx)
  802942:	eb 85                	jmp    8028c9 <__umoddi3+0x65>
  802944:	85 f6                	test   %esi,%esi
  802946:	75 0b                	jne    802953 <__umoddi3+0xef>
  802948:	b8 01 00 00 00       	mov    $0x1,%eax
  80294d:	31 d2                	xor    %edx,%edx
  80294f:	f7 f6                	div    %esi
  802951:	89 c6                	mov    %eax,%esi
  802953:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802956:	89 fa                	mov    %edi,%edx
  802958:	f7 f6                	div    %esi
  80295a:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80295d:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802960:	f7 f6                	div    %esi
  802962:	e9 3d ff ff ff       	jmp    8028a4 <__umoddi3+0x40>
  802967:	90                   	nop    
  802968:	b8 20 00 00 00       	mov    $0x20,%eax
  80296d:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  802970:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  802973:	89 fa                	mov    %edi,%edx
  802975:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802978:	d3 e2                	shl    %cl,%edx
  80297a:	89 f0                	mov    %esi,%eax
  80297c:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80297f:	d3 e8                	shr    %cl,%eax
  802981:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802984:	d3 e6                	shl    %cl,%esi
  802986:	89 d7                	mov    %edx,%edi
  802988:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80298b:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  80298e:	09 c7                	or     %eax,%edi
  802990:	d3 ea                	shr    %cl,%edx
  802992:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802995:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  802998:	d3 e0                	shl    %cl,%eax
  80299a:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  80299d:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8029a0:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8029a3:	d3 e8                	shr    %cl,%eax
  8029a5:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  8029a8:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8029ab:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8029ae:	f7 f7                	div    %edi
  8029b0:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8029b3:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  8029b6:	f7 e6                	mul    %esi
  8029b8:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  8029bb:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  8029be:	77 0a                	ja     8029ca <__umoddi3+0x166>
  8029c0:	75 12                	jne    8029d4 <__umoddi3+0x170>
  8029c2:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8029c5:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  8029c8:	76 0a                	jbe    8029d4 <__umoddi3+0x170>
  8029ca:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  8029cd:	29 f1                	sub    %esi,%ecx
  8029cf:	19 fa                	sbb    %edi,%edx
  8029d1:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  8029d4:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	0f 84 ea fe ff ff    	je     8028c9 <__umoddi3+0x65>
  8029df:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8029e2:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8029e5:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  8029e8:	19 d1                	sbb    %edx,%ecx
  8029ea:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  8029ed:	89 ca                	mov    %ecx,%edx
  8029ef:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8029f2:	d3 e2                	shl    %cl,%edx
  8029f4:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8029f7:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8029fa:	d3 e8                	shr    %cl,%eax
  8029fc:	09 c2                	or     %eax,%edx
  8029fe:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  802a01:	d3 e8                	shr    %cl,%eax
  802a03:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802a06:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802a09:	e9 ad fe ff ff       	jmp    8028bb <__umoddi3+0x57>
