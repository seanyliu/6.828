
obj/user/testshell:     file format elf32-i386

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
  80002c:	e8 9b 04 00 00       	call   8004cc <libmain>
1:      jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
void wrong(int, int, int);

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 18             	sub    $0x18,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;

	close(0);
  80003d:	6a 00                	push   $0x0
  80003f:	e8 46 18 00 00       	call   80188a <close>
	close(1);
  800044:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80004b:	e8 3a 18 00 00       	call   80188a <close>
	opencons();
  800050:	e8 5d 03 00 00       	call   8003b2 <opencons>
	opencons();
  800055:	e8 58 03 00 00       	call   8003b2 <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80005a:	83 c4 08             	add    $0x8,%esp
  80005d:	6a 00                	push   $0x0
  80005f:	68 20 31 80 00       	push   $0x803120
  800064:	e8 2f 1c 00 00       	call   801c98 <open>
  800069:	89 c7                	mov    %eax,%edi
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 12                	jns    800084 <umain+0x50>
		panic("open testshell.sh: %e", rfd);
  800072:	50                   	push   %eax
  800073:	68 2d 31 80 00       	push   $0x80312d
  800078:	6a 12                	push   $0x12
  80007a:	68 43 31 80 00       	push   $0x803143
  80007f:	e8 a4 04 00 00       	call   800528 <_panic>
	if ((wfd = open("testshell.out", O_WRONLY)) < 0)
  800084:	83 ec 08             	sub    $0x8,%esp
  800087:	6a 01                	push   $0x1
  800089:	68 54 31 80 00       	push   $0x803154
  80008e:	e8 05 1c 00 00       	call   801c98 <open>
  800093:	89 c6                	mov    %eax,%esi
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	85 c0                	test   %eax,%eax
  80009a:	79 12                	jns    8000ae <umain+0x7a>
		panic("open testshell.out: %e", wfd);
  80009c:	50                   	push   %eax
  80009d:	68 62 31 80 00       	push   $0x803162
  8000a2:	6a 14                	push   $0x14
  8000a4:	68 43 31 80 00       	push   $0x803143
  8000a9:	e8 7a 04 00 00       	call   800528 <_panic>

	cprintf("running sh -x < testshell.sh > testshell.out\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 08 32 80 00       	push   $0x803208
  8000b6:	e8 5d 05 00 00       	call   800618 <cprintf>
	if ((r = fork()) < 0)
  8000bb:	e8 9e 14 00 00       	call   80155e <fork>
  8000c0:	89 c3                	mov    %eax,%ebx
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	85 c0                	test   %eax,%eax
  8000c7:	79 12                	jns    8000db <umain+0xa7>
		panic("fork: %e", r);
  8000c9:	50                   	push   %eax
  8000ca:	68 79 31 80 00       	push   $0x803179
  8000cf:	6a 18                	push   $0x18
  8000d1:	68 43 31 80 00       	push   $0x803143
  8000d6:	e8 4d 04 00 00       	call   800528 <_panic>
	if (r == 0) {
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	75 7d                	jne    80015c <umain+0x128>
		dup(rfd, 0);
  8000df:	83 ec 08             	sub    $0x8,%esp
  8000e2:	6a 00                	push   $0x0
  8000e4:	57                   	push   %edi
  8000e5:	e8 f1 17 00 00       	call   8018db <dup>
		dup(wfd, 1);
  8000ea:	83 c4 08             	add    $0x8,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	56                   	push   %esi
  8000f0:	e8 e6 17 00 00       	call   8018db <dup>
		close(rfd);
  8000f5:	89 3c 24             	mov    %edi,(%esp)
  8000f8:	e8 8d 17 00 00       	call   80188a <close>
		close(wfd);
  8000fd:	89 34 24             	mov    %esi,(%esp)
  800100:	e8 85 17 00 00       	call   80188a <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  800105:	6a 00                	push   $0x0
  800107:	68 82 31 80 00       	push   $0x803182
  80010c:	68 2a 31 80 00       	push   $0x80312a
  800111:	68 85 31 80 00       	push   $0x803185
  800116:	e8 25 24 00 00       	call   802540 <spawnl>
  80011b:	89 c3                	mov    %eax,%ebx
  80011d:	83 c4 20             	add    $0x20,%esp
  800120:	85 c0                	test   %eax,%eax
  800122:	79 12                	jns    800136 <umain+0x102>
			panic("spawn: %e", r);
  800124:	50                   	push   %eax
  800125:	68 89 31 80 00       	push   $0x803189
  80012a:	6a 1f                	push   $0x1f
  80012c:	68 43 31 80 00       	push   $0x803143
  800131:	e8 f2 03 00 00       	call   800528 <_panic>
		close(0);
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	6a 00                	push   $0x0
  80013b:	e8 4a 17 00 00       	call   80188a <close>
		close(1);
  800140:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800147:	e8 3e 17 00 00       	call   80188a <close>
		wait(r);
  80014c:	89 1c 24             	mov    %ebx,(%esp)
  80014f:	e8 f0 2a 00 00       	call   802c44 <wait>
		exit();
  800154:	e8 b7 03 00 00       	call   800510 <exit>
  800159:	83 c4 10             	add    $0x10,%esp
	}
	close(rfd);
  80015c:	83 ec 0c             	sub    $0xc,%esp
  80015f:	57                   	push   %edi
  800160:	e8 25 17 00 00       	call   80188a <close>
	close(wfd);
  800165:	89 34 24             	mov    %esi,(%esp)
  800168:	e8 1d 17 00 00       	call   80188a <close>
	wait(r);
  80016d:	89 1c 24             	mov    %ebx,(%esp)
  800170:	e8 cf 2a 00 00       	call   802c44 <wait>

	if ((rfd = open("testshell.out", O_RDONLY)) < 0)
  800175:	83 c4 08             	add    $0x8,%esp
  800178:	6a 00                	push   $0x0
  80017a:	68 54 31 80 00       	push   $0x803154
  80017f:	e8 14 1b 00 00       	call   801c98 <open>
  800184:	89 c7                	mov    %eax,%edi
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	85 c0                	test   %eax,%eax
  80018b:	79 12                	jns    80019f <umain+0x16b>
		panic("open testshell.out for reading: %e", rfd);
  80018d:	50                   	push   %eax
  80018e:	68 38 32 80 00       	push   $0x803238
  800193:	6a 2a                	push   $0x2a
  800195:	68 43 31 80 00       	push   $0x803143
  80019a:	e8 89 03 00 00       	call   800528 <_panic>
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	6a 00                	push   $0x0
  8001a4:	68 93 31 80 00       	push   $0x803193
  8001a9:	e8 ea 1a 00 00       	call   801c98 <open>
  8001ae:	89 c6                	mov    %eax,%esi
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	79 12                	jns    8001c9 <umain+0x195>
		panic("open testshell.key for reading: %e", kfd);
  8001b7:	50                   	push   %eax
  8001b8:	68 5c 32 80 00       	push   $0x80325c
  8001bd:	6a 2c                	push   $0x2c
  8001bf:	68 43 31 80 00       	push   $0x803143
  8001c4:	e8 5f 03 00 00       	call   800528 <_panic>

	nloff = 0;
  8001c9:	c7 45 e8 00 00 00 00 	movl   $0x0,0xffffffe8(%ebp)
	for (off=0;; off++) {
  8001d0:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
		n1 = read(rfd, &c1, 1);
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	6a 01                	push   $0x1
  8001dc:	8d 45 f3             	lea    0xfffffff3(%ebp),%eax
  8001df:	50                   	push   %eax
  8001e0:	57                   	push   %edi
  8001e1:	e8 17 18 00 00       	call   8019fd <read>
  8001e6:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8001e8:	83 c4 0c             	add    $0xc,%esp
  8001eb:	6a 01                	push   $0x1
  8001ed:	8d 45 f2             	lea    0xfffffff2(%ebp),%eax
  8001f0:	50                   	push   %eax
  8001f1:	56                   	push   %esi
  8001f2:	e8 06 18 00 00       	call   8019fd <read>
		if (n1 < 0)
  8001f7:	83 c4 10             	add    $0x10,%esp
  8001fa:	85 db                	test   %ebx,%ebx
  8001fc:	79 12                	jns    800210 <umain+0x1dc>
			panic("reading testshell.out: %e", n1);
  8001fe:	53                   	push   %ebx
  8001ff:	68 a1 31 80 00       	push   $0x8031a1
  800204:	6a 33                	push   $0x33
  800206:	68 43 31 80 00       	push   $0x803143
  80020b:	e8 18 03 00 00       	call   800528 <_panic>
		if (n2 < 0)
  800210:	85 c0                	test   %eax,%eax
  800212:	79 12                	jns    800226 <umain+0x1f2>
			panic("reading testshell.key: %e", n2);
  800214:	50                   	push   %eax
  800215:	68 bb 31 80 00       	push   $0x8031bb
  80021a:	6a 35                	push   $0x35
  80021c:	68 43 31 80 00       	push   $0x803143
  800221:	e8 02 03 00 00       	call   800528 <_panic>
		if (n1 == 0 && n2 == 0)
  800226:	85 db                	test   %ebx,%ebx
  800228:	75 04                	jne    80022e <umain+0x1fa>
  80022a:	85 c0                	test   %eax,%eax
  80022c:	74 37                	je     800265 <umain+0x231>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  80022e:	83 fb 01             	cmp    $0x1,%ebx
  800231:	75 0d                	jne    800240 <umain+0x20c>
  800233:	83 f8 01             	cmp    $0x1,%eax
  800236:	75 08                	jne    800240 <umain+0x20c>
  800238:	8a 45 f3             	mov    0xfffffff3(%ebp),%al
  80023b:	3a 45 f2             	cmp    0xfffffff2(%ebp),%al
  80023e:	74 10                	je     800250 <umain+0x21c>
			wrong(rfd, kfd, nloff);
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  800246:	56                   	push   %esi
  800247:	57                   	push   %edi
  800248:	e8 31 00 00 00       	call   80027e <wrong>
  80024d:	83 c4 10             	add    $0x10,%esp
		if (c1 == '\n')
  800250:	80 7d f3 0a          	cmpb   $0xa,0xfffffff3(%ebp)
  800254:	75 07                	jne    80025d <umain+0x229>
			nloff = off+1;
  800256:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  800259:	40                   	inc    %eax
  80025a:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  80025d:	ff 45 ec             	incl   0xffffffec(%ebp)
  800260:	e9 72 ff ff ff       	jmp    8001d7 <umain+0x1a3>
	}
	cprintf("shell ran correctly\n");			
  800265:	83 ec 0c             	sub    $0xc,%esp
  800268:	68 d5 31 80 00       	push   $0x8031d5
  80026d:	e8 a6 03 00 00       	call   800618 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
  800272:	83 c4 10             	add    $0x10,%esp
	__asm __volatile("int3");
  800275:	cc                   	int3   

	breakpoint();
}
  800276:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800279:	5b                   	pop    %ebx
  80027a:	5e                   	pop    %esi
  80027b:	5f                   	pop    %edi
  80027c:	c9                   	leave  
  80027d:	c3                   	ret    

0080027e <wrong>:

void
wrong(int rfd, int kfd, int off)
{
  80027e:	55                   	push   %ebp
  80027f:	89 e5                	mov    %esp,%ebp
  800281:	57                   	push   %edi
  800282:	56                   	push   %esi
  800283:	53                   	push   %ebx
  800284:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80028a:	8b 7d 08             	mov    0x8(%ebp),%edi
  80028d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800290:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800293:	53                   	push   %ebx
  800294:	57                   	push   %edi
  800295:	e8 c5 18 00 00       	call   801b5f <seek>
	seek(kfd, off);
  80029a:	83 c4 08             	add    $0x8,%esp
  80029d:	53                   	push   %ebx
  80029e:	56                   	push   %esi
  80029f:	e8 bb 18 00 00       	call   801b5f <seek>

	cprintf("shell produced incorrect output.\n");
  8002a4:	c7 04 24 80 32 80 00 	movl   $0x803280,(%esp)
  8002ab:	e8 68 03 00 00       	call   800618 <cprintf>
	cprintf("expected:\n===\n");
  8002b0:	c7 04 24 ea 31 80 00 	movl   $0x8031ea,(%esp)
  8002b7:	e8 5c 03 00 00       	call   800618 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  8002bc:	83 c4 10             	add    $0x10,%esp
  8002bf:	8d 9d 78 ff ff ff    	lea    0xffffff78(%ebp),%ebx
  8002c5:	eb 0d                	jmp    8002d4 <wrong+0x56>
		sys_cputs(buf, n);
  8002c7:	83 ec 08             	sub    $0x8,%esp
  8002ca:	50                   	push   %eax
  8002cb:	53                   	push   %ebx
  8002cc:	e8 5b 0c 00 00       	call   800f2c <sys_cputs>
  8002d1:	83 c4 10             	add    $0x10,%esp
  8002d4:	83 ec 04             	sub    $0x4,%esp
  8002d7:	6a 63                	push   $0x63
  8002d9:	53                   	push   %ebx
  8002da:	56                   	push   %esi
  8002db:	e8 1d 17 00 00       	call   8019fd <read>
  8002e0:	83 c4 10             	add    $0x10,%esp
  8002e3:	85 c0                	test   %eax,%eax
  8002e5:	7f e0                	jg     8002c7 <wrong+0x49>
	cprintf("===\ngot:\n===\n");
  8002e7:	83 ec 0c             	sub    $0xc,%esp
  8002ea:	68 f9 31 80 00       	push   $0x8031f9
  8002ef:	e8 24 03 00 00       	call   800618 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	8d 9d 78 ff ff ff    	lea    0xffffff78(%ebp),%ebx
  8002fd:	eb 0d                	jmp    80030c <wrong+0x8e>
		sys_cputs(buf, n);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	50                   	push   %eax
  800303:	53                   	push   %ebx
  800304:	e8 23 0c 00 00       	call   800f2c <sys_cputs>
  800309:	83 c4 10             	add    $0x10,%esp
  80030c:	83 ec 04             	sub    $0x4,%esp
  80030f:	6a 63                	push   $0x63
  800311:	53                   	push   %ebx
  800312:	57                   	push   %edi
  800313:	e8 e5 16 00 00       	call   8019fd <read>
  800318:	83 c4 10             	add    $0x10,%esp
  80031b:	85 c0                	test   %eax,%eax
  80031d:	7f e0                	jg     8002ff <wrong+0x81>
	cprintf("===\n");
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	68 f4 31 80 00       	push   $0x8031f4
  800327:	e8 ec 02 00 00       	call   800618 <cprintf>
	exit();
  80032c:	e8 df 01 00 00       	call   800510 <exit>
}
  800331:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800334:	5b                   	pop    %ebx
  800335:	5e                   	pop    %esi
  800336:	5f                   	pop    %edi
  800337:	c9                   	leave  
  800338:	c3                   	ret    
  800339:	00 00                	add    %al,(%eax)
	...

0080033c <cputchar>:
#include <inc/lib.h>

void
cputchar(int ch)
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	83 ec 10             	sub    $0x10,%esp
	char c = ch;
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	88 45 ff             	mov    %al,0xffffffff(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800348:	6a 01                	push   $0x1
  80034a:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  80034d:	50                   	push   %eax
  80034e:	e8 d9 0b 00 00       	call   800f2c <sys_cputs>
}
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <getchar>:

int
getchar(void)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	83 ec 0c             	sub    $0xc,%esp
	unsigned char c;
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80035b:	6a 01                	push   $0x1
  80035d:	8d 45 ff             	lea    0xffffffff(%ebp),%eax
  800360:	50                   	push   %eax
  800361:	6a 00                	push   $0x0
  800363:	e8 95 16 00 00       	call   8019fd <read>
	if (r < 0)
  800368:	83 c4 10             	add    $0x10,%esp
		return r;
  80036b:	89 c2                	mov    %eax,%edx
  80036d:	85 c0                	test   %eax,%eax
  80036f:	78 0d                	js     80037e <getchar+0x29>
	if (r < 1)
		return -E_EOF;
  800371:	ba f8 ff ff ff       	mov    $0xfffffff8,%edx
  800376:	85 c0                	test   %eax,%eax
  800378:	7e 04                	jle    80037e <getchar+0x29>
	return c;
  80037a:	0f b6 55 ff          	movzbl 0xffffffff(%ebp),%edx
}
  80037e:	89 d0                	mov    %edx,%eax
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <iscons>:


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
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800388:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  80038b:	50                   	push   %eax
  80038c:	ff 75 08             	pushl  0x8(%ebp)
  80038f:	e8 d6 13 00 00       	call   80176a <fd_lookup>
  800394:	83 c4 10             	add    $0x10,%esp
		return r;
  800397:	89 c2                	mov    %eax,%edx
  800399:	85 c0                	test   %eax,%eax
  80039b:	78 11                	js     8003ae <iscons+0x2c>
	return fd->fd_dev_id == devcons.dev_id;
  80039d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8003a0:	8b 00                	mov    (%eax),%eax
  8003a2:	3b 05 00 70 80 00    	cmp    0x807000,%eax
  8003a8:	0f 94 c0             	sete   %al
  8003ab:	0f b6 d0             	movzbl %al,%edx
}
  8003ae:	89 d0                	mov    %edx,%eax
  8003b0:	c9                   	leave  
  8003b1:	c3                   	ret    

008003b2 <opencons>:

int
opencons(void)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	83 ec 14             	sub    $0x14,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003b8:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8003bb:	50                   	push   %eax
  8003bc:	e8 4f 13 00 00       	call   801710 <fd_alloc>
  8003c1:	83 c4 10             	add    $0x10,%esp
		return r;
  8003c4:	89 c2                	mov    %eax,%edx
  8003c6:	85 c0                	test   %eax,%eax
  8003c8:	78 3c                	js     800406 <opencons+0x54>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	68 07 04 00 00       	push   $0x407
  8003d2:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8003d5:	6a 00                	push   $0x0
  8003d7:	e8 12 0c 00 00       	call   800fee <sys_page_alloc>
  8003dc:	83 c4 10             	add    $0x10,%esp
		return r;
  8003df:	89 c2                	mov    %eax,%edx
  8003e1:	85 c0                	test   %eax,%eax
  8003e3:	78 21                	js     800406 <opencons+0x54>
	fd->fd_dev_id = devcons.dev_id;
  8003e5:	a1 00 70 80 00       	mov    0x807000,%eax
  8003ea:	8b 55 fc             	mov    0xfffffffc(%ebp),%edx
  8003ed:	89 02                	mov    %eax,(%edx)
	fd->fd_omode = O_RDWR;
  8003ef:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  8003f2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8003f9:	83 ec 0c             	sub    $0xc,%esp
  8003fc:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8003ff:	e8 fc 12 00 00       	call   801700 <fd2num>
  800404:	89 c2                	mov    %eax,%edx
}
  800406:	89 d0                	mov    %edx,%eax
  800408:	c9                   	leave  
  800409:	c3                   	ret    

0080040a <cons_read>:

ssize_t
cons_read(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
  80040d:	83 ec 08             	sub    $0x8,%esp
	int c;

	USED(offset);

	if (n == 0)
		return 0;
  800410:	b8 00 00 00 00       	mov    $0x0,%eax
  800415:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800419:	74 2a                	je     800445 <cons_read+0x3b>
  80041b:	eb 05                	jmp    800422 <cons_read+0x18>

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80041d:	e8 ad 0b 00 00       	call   800fcf <sys_yield>
  800422:	e8 29 0b 00 00       	call   800f50 <sys_cgetc>
  800427:	89 c2                	mov    %eax,%edx
  800429:	85 c0                	test   %eax,%eax
  80042b:	74 f0                	je     80041d <cons_read+0x13>
	if (c < 0)
  80042d:	85 d2                	test   %edx,%edx
  80042f:	78 14                	js     800445 <cons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  800431:	b8 00 00 00 00       	mov    $0x0,%eax
  800436:	83 fa 04             	cmp    $0x4,%edx
  800439:	74 0a                	je     800445 <cons_read+0x3b>
	*(char*)vbuf = c;
  80043b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043e:	88 10                	mov    %dl,(%eax)
	return 1;
  800440:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800445:	c9                   	leave  
  800446:	c3                   	ret    

00800447 <cons_write>:

ssize_t
cons_write(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	57                   	push   %edi
  80044b:	56                   	push   %esi
  80044c:	53                   	push   %ebx
  80044d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  800453:	8b 7d 10             	mov    0x10(%ebp),%edi
	int tot, m;
	char buf[128];

	USED(offset);

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800456:	be 00 00 00 00       	mov    $0x0,%esi
  80045b:	39 fe                	cmp    %edi,%esi
  80045d:	73 3d                	jae    80049c <cons_write+0x55>
		m = n - tot;
  80045f:	89 fb                	mov    %edi,%ebx
  800461:	29 f3                	sub    %esi,%ebx
		if (m > sizeof(buf) - 1)
  800463:	83 fb 7f             	cmp    $0x7f,%ebx
  800466:	76 05                	jbe    80046d <cons_write+0x26>
			m = sizeof(buf) - 1;
  800468:	bb 7f 00 00 00       	mov    $0x7f,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80046d:	83 ec 04             	sub    $0x4,%esp
  800470:	53                   	push   %ebx
  800471:	8b 45 0c             	mov    0xc(%ebp),%eax
  800474:	01 f0                	add    %esi,%eax
  800476:	50                   	push   %eax
  800477:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  80047d:	50                   	push   %eax
  80047e:	e8 15 09 00 00       	call   800d98 <memmove>
		sys_cputs(buf, m);
  800483:	83 c4 08             	add    $0x8,%esp
  800486:	53                   	push   %ebx
  800487:	8d 85 68 ff ff ff    	lea    0xffffff68(%ebp),%eax
  80048d:	50                   	push   %eax
  80048e:	e8 99 0a 00 00       	call   800f2c <sys_cputs>
  800493:	83 c4 10             	add    $0x10,%esp
  800496:	01 de                	add    %ebx,%esi
  800498:	39 fe                	cmp    %edi,%esi
  80049a:	72 c3                	jb     80045f <cons_write+0x18>
	}
	return tot;
}
  80049c:	89 f0                	mov    %esi,%eax
  80049e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8004a1:	5b                   	pop    %ebx
  8004a2:	5e                   	pop    %esi
  8004a3:	5f                   	pop    %edi
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <cons_close>:

int
cons_close(struct Fd *fd)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8004a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ae:	c9                   	leave  
  8004af:	c3                   	ret    

008004b0 <cons_stat>:

int
cons_stat(struct Fd *fd, struct Stat *stat)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8004b6:	68 a7 32 80 00       	push   $0x8032a7
  8004bb:	ff 75 0c             	pushl  0xc(%ebp)
  8004be:	e8 59 07 00 00       	call   800c1c <strcpy>
	return 0;
}
  8004c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c8:	c9                   	leave  
  8004c9:	c3                   	ret    
	...

008004cc <libmain>:
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8004cc:	55                   	push   %ebp
  8004cd:	89 e5                	mov    %esp,%ebp
  8004cf:	56                   	push   %esi
  8004d0:	53                   	push   %ebx
  8004d1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
        // seanyliu
	//env = 0;
        env = &envs[ENVX(sys_getenvid())];
  8004d7:	e8 d4 0a 00 00       	call   800fb0 <sys_getenvid>
  8004dc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004e1:	c1 e0 07             	shl    $0x7,%eax
  8004e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004e9:	a3 80 70 80 00       	mov    %eax,0x807080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004ee:	85 f6                	test   %esi,%esi
  8004f0:	7e 07                	jle    8004f9 <libmain+0x2d>
		binaryname = argv[0];
  8004f2:	8b 03                	mov    (%ebx),%eax
  8004f4:	a3 20 70 80 00       	mov    %eax,0x807020

	// call user main routine
	umain(argc, argv);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	53                   	push   %ebx
  8004fd:	56                   	push   %esi
  8004fe:	e8 31 fb ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800503:	e8 08 00 00 00       	call   800510 <exit>
}
  800508:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80050b:	5b                   	pop    %ebx
  80050c:	5e                   	pop    %esi
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    
	...

00800510 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
  800513:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800516:	e8 9d 13 00 00       	call   8018b8 <close_all>
	sys_env_destroy(0);
  80051b:	83 ec 0c             	sub    $0xc,%esp
  80051e:	6a 00                	push   $0x0
  800520:	e8 4a 0a 00 00       	call   800f6f <sys_env_destroy>
}
  800525:	c9                   	leave  
  800526:	c3                   	ret    
	...

00800528 <_panic>:
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800528:	55                   	push   %ebp
  800529:	89 e5                	mov    %esp,%ebp
  80052b:	53                   	push   %ebx
  80052c:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	va_start(ap, fmt);
  80052f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	if (argv0)
  800532:	83 3d 84 70 80 00 00 	cmpl   $0x0,0x807084
  800539:	74 16                	je     800551 <_panic+0x29>
		cprintf("%s: ", argv0);
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 35 84 70 80 00    	pushl  0x807084
  800544:	68 c5 32 80 00       	push   $0x8032c5
  800549:	e8 ca 00 00 00       	call   800618 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800551:	ff 75 0c             	pushl  0xc(%ebp)
  800554:	ff 75 08             	pushl  0x8(%ebp)
  800557:	ff 35 20 70 80 00    	pushl  0x807020
  80055d:	68 ca 32 80 00       	push   $0x8032ca
  800562:	e8 b1 00 00 00       	call   800618 <cprintf>
	vcprintf(fmt, ap);
  800567:	83 c4 08             	add    $0x8,%esp
  80056a:	53                   	push   %ebx
  80056b:	ff 75 10             	pushl  0x10(%ebp)
  80056e:	e8 54 00 00 00       	call   8005c7 <vcprintf>
	cprintf("\n");
  800573:	c7 04 24 f7 31 80 00 	movl   $0x8031f7,(%esp)
  80057a:	e8 99 00 00 00       	call   800618 <cprintf>

	// Cause a breakpoint exception
	while (1)
  80057f:	83 c4 10             	add    $0x10,%esp
		asm volatile("int3");
  800582:	cc                   	int3   
  800583:	eb fd                	jmp    800582 <_panic+0x5a>
  800585:	00 00                	add    %al,(%eax)
	...

00800588 <putch>:


static void
putch(int ch, struct printbuf *b)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	53                   	push   %ebx
  80058c:	83 ec 04             	sub    $0x4,%esp
  80058f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800592:	8b 03                	mov    (%ebx),%eax
  800594:	8b 55 08             	mov    0x8(%ebp),%edx
  800597:	88 54 18 08          	mov    %dl,0x8(%eax,%ebx,1)
  80059b:	40                   	inc    %eax
  80059c:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80059e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a3:	75 1a                	jne    8005bf <putch+0x37>
		sys_cputs(b->buf, b->idx);
  8005a5:	83 ec 08             	sub    $0x8,%esp
  8005a8:	68 ff 00 00 00       	push   $0xff
  8005ad:	8d 43 08             	lea    0x8(%ebx),%eax
  8005b0:	50                   	push   %eax
  8005b1:	e8 76 09 00 00       	call   800f2c <sys_cputs>
		b->idx = 0;
  8005b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005bc:	83 c4 10             	add    $0x10,%esp
	}
	b->cnt++;
  8005bf:	ff 43 04             	incl   0x4(%ebx)
}
  8005c2:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d0:	c7 85 e8 fe ff ff 00 	movl   $0x0,0xfffffee8(%ebp)
  8005d7:	00 00 00 
	b.cnt = 0;
  8005da:	c7 85 ec fe ff ff 00 	movl   $0x0,0xfffffeec(%ebp)
  8005e1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	8d 85 e8 fe ff ff    	lea    0xfffffee8(%ebp),%eax
  8005f0:	50                   	push   %eax
  8005f1:	68 88 05 80 00       	push   $0x800588
  8005f6:	e8 4f 01 00 00       	call   80074a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005fb:	83 c4 08             	add    $0x8,%esp
  8005fe:	ff b5 e8 fe ff ff    	pushl  0xfffffee8(%ebp)
  800604:	8d 85 f0 fe ff ff    	lea    0xfffffef0(%ebp),%eax
  80060a:	50                   	push   %eax
  80060b:	e8 1c 09 00 00       	call   800f2c <sys_cputs>

	return b.cnt;
  800610:	8b 85 ec fe ff ff    	mov    0xfffffeec(%ebp),%eax
}
  800616:	c9                   	leave  
  800617:	c3                   	ret    

00800618 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80061e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800621:	50                   	push   %eax
  800622:	ff 75 08             	pushl  0x8(%ebp)
  800625:	e8 9d ff ff ff       	call   8005c7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80062a:	c9                   	leave  
  80062b:	c3                   	ret    

0080062c <printnum>:
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80062c:	55                   	push   %ebp
  80062d:	89 e5                	mov    %esp,%ebp
  80062f:	57                   	push   %edi
  800630:	56                   	push   %esi
  800631:	53                   	push   %ebx
  800632:	83 ec 0c             	sub    $0xc,%esp
  800635:	8b 75 10             	mov    0x10(%ebp),%esi
  800638:	8b 7d 14             	mov    0x14(%ebp),%edi
  80063b:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80063e:	8b 45 18             	mov    0x18(%ebp),%eax
  800641:	ba 00 00 00 00       	mov    $0x0,%edx
  800646:	39 fa                	cmp    %edi,%edx
  800648:	77 39                	ja     800683 <printnum+0x57>
  80064a:	72 04                	jb     800650 <printnum+0x24>
  80064c:	39 f0                	cmp    %esi,%eax
  80064e:	77 33                	ja     800683 <printnum+0x57>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800650:	83 ec 04             	sub    $0x4,%esp
  800653:	ff 75 20             	pushl  0x20(%ebp)
  800656:	8d 43 ff             	lea    0xffffffff(%ebx),%eax
  800659:	50                   	push   %eax
  80065a:	ff 75 18             	pushl  0x18(%ebp)
  80065d:	8b 45 18             	mov    0x18(%ebp),%eax
  800660:	ba 00 00 00 00       	mov    $0x0,%edx
  800665:	52                   	push   %edx
  800666:	50                   	push   %eax
  800667:	57                   	push   %edi
  800668:	56                   	push   %esi
  800669:	e8 ee 27 00 00       	call   802e5c <__udivdi3>
  80066e:	83 c4 10             	add    $0x10,%esp
  800671:	52                   	push   %edx
  800672:	50                   	push   %eax
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	ff 75 08             	pushl  0x8(%ebp)
  800679:	e8 ae ff ff ff       	call   80062c <printnum>
  80067e:	83 c4 20             	add    $0x20,%esp
  800681:	eb 19                	jmp    80069c <printnum+0x70>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800683:	4b                   	dec    %ebx
  800684:	85 db                	test   %ebx,%ebx
  800686:	7e 14                	jle    80069c <printnum+0x70>
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 20             	pushl  0x20(%ebp)
  800691:	ff 55 08             	call   *0x8(%ebp)
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	4b                   	dec    %ebx
  800698:	85 db                	test   %ebx,%ebx
  80069a:	7f ec                	jg     800688 <printnum+0x5c>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	83 ec 04             	sub    $0x4,%esp
  8006ad:	52                   	push   %edx
  8006ae:	50                   	push   %eax
  8006af:	57                   	push   %edi
  8006b0:	56                   	push   %esi
  8006b1:	e8 b2 28 00 00       	call   802f68 <__umoddi3>
  8006b6:	83 c4 14             	add    $0x14,%esp
  8006b9:	0f be 80 e0 33 80 00 	movsbl 0x8033e0(%eax),%eax
  8006c0:	50                   	push   %eax
  8006c1:	ff 55 08             	call   *0x8(%ebp)
}
  8006c4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8006c7:	5b                   	pop    %ebx
  8006c8:	5e                   	pop    %esi
  8006c9:	5f                   	pop    %edi
  8006ca:	c9                   	leave  
  8006cb:	c3                   	ret    

008006cc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006cc:	55                   	push   %ebp
  8006cd:	89 e5                	mov    %esp,%ebp
  8006cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  8006d5:	83 f8 01             	cmp    $0x1,%eax
  8006d8:	7e 0f                	jle    8006e9 <getuint+0x1d>
		return va_arg(*ap, unsigned long long);
  8006da:	8b 01                	mov    (%ecx),%eax
  8006dc:	83 c0 08             	add    $0x8,%eax
  8006df:	89 01                	mov    %eax,(%ecx)
  8006e1:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  8006e4:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  8006e7:	eb 24                	jmp    80070d <getuint+0x41>
	else if (lflag)
  8006e9:	85 c0                	test   %eax,%eax
  8006eb:	74 11                	je     8006fe <getuint+0x32>
		return va_arg(*ap, unsigned long);
  8006ed:	8b 01                	mov    (%ecx),%eax
  8006ef:	83 c0 04             	add    $0x4,%eax
  8006f2:	89 01                	mov    %eax,(%ecx)
  8006f4:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  8006f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fc:	eb 0f                	jmp    80070d <getuint+0x41>
	else
		return va_arg(*ap, unsigned int);
  8006fe:	8b 01                	mov    (%ecx),%eax
  800700:	83 c0 04             	add    $0x4,%eax
  800703:	89 01                	mov    %eax,(%ecx)
  800705:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800708:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80070d:	c9                   	leave  
  80070e:	c3                   	ret    

0080070f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
  800712:	8b 55 08             	mov    0x8(%ebp),%edx
  800715:	8b 45 0c             	mov    0xc(%ebp),%eax
	if (lflag >= 2)
  800718:	83 f8 01             	cmp    $0x1,%eax
  80071b:	7e 0f                	jle    80072c <getint+0x1d>
		return va_arg(*ap, long long);
  80071d:	8b 02                	mov    (%edx),%eax
  80071f:	83 c0 08             	add    $0x8,%eax
  800722:	89 02                	mov    %eax,(%edx)
  800724:	8b 50 fc             	mov    0xfffffffc(%eax),%edx
  800727:	8b 40 f8             	mov    0xfffffff8(%eax),%eax
  80072a:	eb 1c                	jmp    800748 <getint+0x39>
	else if (lflag)
  80072c:	85 c0                	test   %eax,%eax
  80072e:	74 0d                	je     80073d <getint+0x2e>
		return va_arg(*ap, long);
  800730:	8b 02                	mov    (%edx),%eax
  800732:	83 c0 04             	add    $0x4,%eax
  800735:	89 02                	mov    %eax,(%edx)
  800737:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  80073a:	99                   	cltd   
  80073b:	eb 0b                	jmp    800748 <getint+0x39>
	else
		return va_arg(*ap, int);
  80073d:	8b 02                	mov    (%edx),%eax
  80073f:	83 c0 04             	add    $0x4,%eax
  800742:	89 02                	mov    %eax,(%edx)
  800744:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
  800747:	99                   	cltd   
}
  800748:	c9                   	leave  
  800749:	c3                   	ret    

0080074a <vprintfmt>:


// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	57                   	push   %edi
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	83 ec 1c             	sub    $0x1c,%esp
  800753:	8b 5d 10             	mov    0x10(%ebp),%ebx
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
  800756:	0f b6 13             	movzbl (%ebx),%edx
  800759:	43                   	inc    %ebx
  80075a:	83 fa 25             	cmp    $0x25,%edx
  80075d:	74 1e                	je     80077d <vprintfmt+0x33>
  80075f:	85 d2                	test   %edx,%edx
  800761:	0f 84 d7 02 00 00    	je     800a3e <vprintfmt+0x2f4>
  800767:	83 ec 08             	sub    $0x8,%esp
  80076a:	ff 75 0c             	pushl  0xc(%ebp)
  80076d:	52                   	push   %edx
  80076e:	ff 55 08             	call   *0x8(%ebp)
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	0f b6 13             	movzbl (%ebx),%edx
  800777:	43                   	inc    %ebx
  800778:	83 fa 25             	cmp    $0x25,%edx
  80077b:	75 e2                	jne    80075f <vprintfmt+0x15>
		}

		// Process a %-escape sequence
		padc = ' ';
  80077d:	c6 45 eb 20          	movb   $0x20,0xffffffeb(%ebp)
		width = -1;
  800781:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,0xfffffff0(%ebp)
		precision = -1;
  800788:	be ff ff ff ff       	mov    $0xffffffff,%esi
		lflag = 0;
  80078d:	b9 00 00 00 00       	mov    $0x0,%ecx
		altflag = 0;
  800792:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800799:	0f b6 13             	movzbl (%ebx),%edx
  80079c:	8d 42 dd             	lea    0xffffffdd(%edx),%eax
  80079f:	43                   	inc    %ebx
  8007a0:	83 f8 55             	cmp    $0x55,%eax
  8007a3:	0f 87 70 02 00 00    	ja     800a19 <vprintfmt+0x2cf>
  8007a9:	ff 24 85 7c 34 80 00 	jmp    *0x80347c(,%eax,4)

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b0:	c6 45 eb 2d          	movb   $0x2d,0xffffffeb(%ebp)
			goto reswitch;
  8007b4:	eb e3                	jmp    800799 <vprintfmt+0x4f>
			
		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b6:	c6 45 eb 30          	movb   $0x30,0xffffffeb(%ebp)
			goto reswitch;
  8007ba:	eb dd                	jmp    800799 <vprintfmt+0x4f>

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
  8007bc:	be 00 00 00 00       	mov    $0x0,%esi
				precision = precision * 10 + ch - '0';
  8007c1:	8d 04 b6             	lea    (%esi,%esi,4),%eax
  8007c4:	8d 74 42 d0          	lea    0xffffffd0(%edx,%eax,2),%esi
				ch = *fmt;
  8007c8:	0f be 13             	movsbl (%ebx),%edx
				if (ch < '0' || ch > '9')
  8007cb:	8d 42 d0             	lea    0xffffffd0(%edx),%eax
  8007ce:	83 f8 09             	cmp    $0x9,%eax
  8007d1:	77 27                	ja     8007fa <vprintfmt+0xb0>
  8007d3:	43                   	inc    %ebx
  8007d4:	eb eb                	jmp    8007c1 <vprintfmt+0x77>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d6:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8007da:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dd:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
			goto process_precision;
  8007e0:	eb 18                	jmp    8007fa <vprintfmt+0xb0>

		case '.':
			if (width < 0)
  8007e2:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8007e6:	79 b1                	jns    800799 <vprintfmt+0x4f>
				width = 0;
  8007e8:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
			goto reswitch;
  8007ef:	eb a8                	jmp    800799 <vprintfmt+0x4f>

		case '#':
			altflag = 1;
  8007f1:	c7 45 ec 01 00 00 00 	movl   $0x1,0xffffffec(%ebp)
			goto reswitch;
  8007f8:	eb 9f                	jmp    800799 <vprintfmt+0x4f>

		process_precision:
			if (width < 0)
  8007fa:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8007fe:	79 99                	jns    800799 <vprintfmt+0x4f>
				width = precision, precision = -1;
  800800:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  800803:	be ff ff ff ff       	mov    $0xffffffff,%esi
			goto reswitch;
  800808:	eb 8f                	jmp    800799 <vprintfmt+0x4f>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080a:	41                   	inc    %ecx
			goto reswitch;
  80080b:	eb 8c                	jmp    800799 <vprintfmt+0x4f>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	ff 70 fc             	pushl  0xfffffffc(%eax)
  80081d:	ff 55 08             	call   *0x8(%ebp)
			break;
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	e9 2e ff ff ff       	jmp    800756 <vprintfmt+0xc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800828:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8b 40 fc             	mov    0xfffffffc(%eax),%eax
			if (err < 0)
  800832:	85 c0                	test   %eax,%eax
  800834:	79 02                	jns    800838 <vprintfmt+0xee>
				err = -err;
  800836:	f7 d8                	neg    %eax
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800838:	83 f8 0e             	cmp    $0xe,%eax
  80083b:	7f 0b                	jg     800848 <vprintfmt+0xfe>
  80083d:	8b 3c 85 40 34 80 00 	mov    0x803440(,%eax,4),%edi
  800844:	85 ff                	test   %edi,%edi
  800846:	75 19                	jne    800861 <vprintfmt+0x117>
				printfmt(putch, putdat, "error %d", err);
  800848:	50                   	push   %eax
  800849:	68 f1 33 80 00       	push   $0x8033f1
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 08             	pushl  0x8(%ebp)
  800854:	e8 ed 01 00 00       	call   800a46 <printfmt>
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	e9 f5 fe ff ff       	jmp    800756 <vprintfmt+0xc>
			else
				printfmt(putch, putdat, "%s", p);
  800861:	57                   	push   %edi
  800862:	68 81 38 80 00       	push   $0x803881
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 d4 01 00 00       	call   800a46 <printfmt>
  800872:	83 c4 10             	add    $0x10,%esp
			break;
  800875:	e9 dc fe ff ff       	jmp    800756 <vprintfmt+0xc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80087a:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	8b 78 fc             	mov    0xfffffffc(%eax),%edi
  800884:	85 ff                	test   %edi,%edi
  800886:	75 05                	jne    80088d <vprintfmt+0x143>
				p = "(null)";
  800888:	bf fa 33 80 00       	mov    $0x8033fa,%edi
			if (width > 0 && padc != '-')
  80088d:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800891:	7e 3b                	jle    8008ce <vprintfmt+0x184>
  800893:	80 7d eb 2d          	cmpb   $0x2d,0xffffffeb(%ebp)
  800897:	74 35                	je     8008ce <vprintfmt+0x184>
				for (width -= strnlen(p, precision); width > 0; width--)
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	56                   	push   %esi
  80089d:	57                   	push   %edi
  80089e:	e8 56 03 00 00       	call   800bf9 <strnlen>
  8008a3:	29 45 f0             	sub    %eax,0xfffffff0(%ebp)
  8008a6:	83 c4 10             	add    $0x10,%esp
  8008a9:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8008ad:	7e 1f                	jle    8008ce <vprintfmt+0x184>
  8008af:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8008b3:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
					putch(padc, putdat);
  8008b6:	83 ec 08             	sub    $0x8,%esp
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 e4             	pushl  0xffffffe4(%ebp)
  8008bf:	ff 55 08             	call   *0x8(%ebp)
  8008c2:	83 c4 10             	add    $0x10,%esp
  8008c5:	ff 4d f0             	decl   0xfffffff0(%ebp)
  8008c8:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8008cc:	7f e8                	jg     8008b6 <vprintfmt+0x16c>
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ce:	0f be 17             	movsbl (%edi),%edx
  8008d1:	47                   	inc    %edi
  8008d2:	85 d2                	test   %edx,%edx
  8008d4:	74 44                	je     80091a <vprintfmt+0x1d0>
  8008d6:	85 f6                	test   %esi,%esi
  8008d8:	78 03                	js     8008dd <vprintfmt+0x193>
  8008da:	4e                   	dec    %esi
  8008db:	78 3d                	js     80091a <vprintfmt+0x1d0>
				if (altflag && (ch < ' ' || ch > '~'))
  8008dd:	83 7d ec 00          	cmpl   $0x0,0xffffffec(%ebp)
  8008e1:	74 18                	je     8008fb <vprintfmt+0x1b1>
  8008e3:	8d 42 e0             	lea    0xffffffe0(%edx),%eax
  8008e6:	83 f8 5e             	cmp    $0x5e,%eax
  8008e9:	76 10                	jbe    8008fb <vprintfmt+0x1b1>
					putch('?', putdat);
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	ff 75 0c             	pushl  0xc(%ebp)
  8008f1:	6a 3f                	push   $0x3f
  8008f3:	ff 55 08             	call   *0x8(%ebp)
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	eb 0d                	jmp    800908 <vprintfmt+0x1be>
				else
					putch(ch, putdat);
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	52                   	push   %edx
  800902:	ff 55 08             	call   *0x8(%ebp)
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	ff 4d f0             	decl   0xfffffff0(%ebp)
  80090b:	0f be 17             	movsbl (%edi),%edx
  80090e:	47                   	inc    %edi
  80090f:	85 d2                	test   %edx,%edx
  800911:	74 07                	je     80091a <vprintfmt+0x1d0>
  800913:	85 f6                	test   %esi,%esi
  800915:	78 c6                	js     8008dd <vprintfmt+0x193>
  800917:	4e                   	dec    %esi
  800918:	79 c3                	jns    8008dd <vprintfmt+0x193>
			for (; width > 0; width--)
  80091a:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  80091e:	0f 8e 32 fe ff ff    	jle    800756 <vprintfmt+0xc>
				putch(' ', putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	6a 20                	push   $0x20
  80092c:	ff 55 08             	call   *0x8(%ebp)
  80092f:	83 c4 10             	add    $0x10,%esp
  800932:	ff 4d f0             	decl   0xfffffff0(%ebp)
  800935:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  800939:	7f e9                	jg     800924 <vprintfmt+0x1da>
			break;
  80093b:	e9 16 fe ff ff       	jmp    800756 <vprintfmt+0xc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800940:	51                   	push   %ecx
  800941:	8d 45 14             	lea    0x14(%ebp),%eax
  800944:	50                   	push   %eax
  800945:	e8 c5 fd ff ff       	call   80070f <getint>
  80094a:	89 c6                	mov    %eax,%esi
  80094c:	89 d7                	mov    %edx,%edi
			if ((long long) num < 0) {
  80094e:	83 c4 08             	add    $0x8,%esp
  800951:	85 d2                	test   %edx,%edx
  800953:	79 15                	jns    80096a <vprintfmt+0x220>
				putch('-', putdat);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	6a 2d                	push   $0x2d
  80095d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800960:	f7 de                	neg    %esi
  800962:	83 d7 00             	adc    $0x0,%edi
  800965:	f7 df                	neg    %edi
  800967:	83 c4 10             	add    $0x10,%esp
			}
			base = 10;
  80096a:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  80096f:	eb 75                	jmp    8009e6 <vprintfmt+0x29c>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800971:	51                   	push   %ecx
  800972:	8d 45 14             	lea    0x14(%ebp),%eax
  800975:	50                   	push   %eax
  800976:	e8 51 fd ff ff       	call   8006cc <getuint>
  80097b:	89 c6                	mov    %eax,%esi
  80097d:	89 d7                	mov    %edx,%edi
			base = 10;
  80097f:	ba 0a 00 00 00       	mov    $0xa,%edx
			goto number;
  800984:	83 c4 08             	add    $0x8,%esp
  800987:	eb 5d                	jmp    8009e6 <vprintfmt+0x29c>

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
  800989:	51                   	push   %ecx
  80098a:	8d 45 14             	lea    0x14(%ebp),%eax
  80098d:	50                   	push   %eax
  80098e:	e8 39 fd ff ff       	call   8006cc <getuint>
  800993:	89 c6                	mov    %eax,%esi
  800995:	89 d7                	mov    %edx,%edi
			base = 8;
  800997:	ba 08 00 00 00       	mov    $0x8,%edx
			goto number;
  80099c:	83 c4 08             	add    $0x8,%esp
  80099f:	eb 45                	jmp    8009e6 <vprintfmt+0x29c>

		// pointer
		case 'p':
			putch('0', putdat);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	6a 30                	push   $0x30
  8009a9:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8009ac:	83 c4 08             	add    $0x8,%esp
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	6a 78                	push   $0x78
  8009b4:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
  8009b7:	83 45 14 04          	addl   $0x4,0x14(%ebp)
  8009bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009be:	8b 70 fc             	mov    0xfffffffc(%eax),%esi
  8009c1:	bf 00 00 00 00       	mov    $0x0,%edi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8009c6:	ba 10 00 00 00       	mov    $0x10,%edx
			goto number;
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	eb 16                	jmp    8009e6 <vprintfmt+0x29c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009d0:	51                   	push   %ecx
  8009d1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d4:	50                   	push   %eax
  8009d5:	e8 f2 fc ff ff       	call   8006cc <getuint>
  8009da:	89 c6                	mov    %eax,%esi
  8009dc:	89 d7                	mov    %edx,%edi
			base = 16;
  8009de:	ba 10 00 00 00       	mov    $0x10,%edx
  8009e3:	83 c4 08             	add    $0x8,%esp
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009e6:	83 ec 04             	sub    $0x4,%esp
  8009e9:	0f be 45 eb          	movsbl 0xffffffeb(%ebp),%eax
  8009ed:	50                   	push   %eax
  8009ee:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8009f1:	52                   	push   %edx
  8009f2:	57                   	push   %edi
  8009f3:	56                   	push   %esi
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	ff 75 08             	pushl  0x8(%ebp)
  8009fa:	e8 2d fc ff ff       	call   80062c <printnum>
			break;
  8009ff:	83 c4 20             	add    $0x20,%esp
  800a02:	e9 4f fd ff ff       	jmp    800756 <vprintfmt+0xc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a07:	83 ec 08             	sub    $0x8,%esp
  800a0a:	ff 75 0c             	pushl  0xc(%ebp)
  800a0d:	52                   	push   %edx
  800a0e:	ff 55 08             	call   *0x8(%ebp)
			break;
  800a11:	83 c4 10             	add    $0x10,%esp
  800a14:	e9 3d fd ff ff       	jmp    800756 <vprintfmt+0xc>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 0c             	pushl  0xc(%ebp)
  800a1f:	6a 25                	push   $0x25
  800a21:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a24:	4b                   	dec    %ebx
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800a2c:	0f 84 24 fd ff ff    	je     800756 <vprintfmt+0xc>
  800a32:	4b                   	dec    %ebx
  800a33:	80 7b ff 25          	cmpb   $0x25,0xffffffff(%ebx)
  800a37:	75 f9                	jne    800a32 <vprintfmt+0x2e8>
				/* do nothing */;
			break;
  800a39:	e9 18 fd ff ff       	jmp    800756 <vprintfmt+0xc>
		}
	}
}
  800a3e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800a41:	5b                   	pop    %ebx
  800a42:	5e                   	pop    %esi
  800a43:	5f                   	pop    %edi
  800a44:	c9                   	leave  
  800a45:	c3                   	ret    

00800a46 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
  800a4c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800a4f:	50                   	push   %eax
  800a50:	ff 75 10             	pushl  0x10(%ebp)
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	ff 75 08             	pushl  0x8(%ebp)
  800a59:	e8 ec fc ff ff       	call   80074a <vprintfmt>
	va_end(ap);
}
  800a5e:	c9                   	leave  
  800a5f:	c3                   	ret    

00800a60 <sprintputch>:

struct sprintbuf {
	char *buf;
	char *ebuf;
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
	b->cnt++;
  800a66:	ff 42 08             	incl   0x8(%edx)
	if (b->buf < b->ebuf)
  800a69:	8b 0a                	mov    (%edx),%ecx
  800a6b:	3b 4a 04             	cmp    0x4(%edx),%ecx
  800a6e:	73 07                	jae    800a77 <sprintputch+0x17>
		*b->buf++ = ch;
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	88 01                	mov    %al,(%ecx)
  800a75:	ff 02                	incl   (%edx)
}
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    

00800a79 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	83 ec 18             	sub    $0x18,%esp
  800a7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800a82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a85:	89 55 e8             	mov    %edx,0xffffffe8(%ebp)
  800a88:	8d 44 0a ff          	lea    0xffffffff(%edx,%ecx,1),%eax
  800a8c:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  800a8f:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)

	if (buf == NULL || n < 1)
  800a96:	85 d2                	test   %edx,%edx
  800a98:	74 04                	je     800a9e <vsnprintf+0x25>
  800a9a:	85 c9                	test   %ecx,%ecx
  800a9c:	7f 07                	jg     800aa5 <vsnprintf+0x2c>
		return -E_INVAL;
  800a9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aa3:	eb 1d                	jmp    800ac2 <vsnprintf+0x49>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa5:	ff 75 14             	pushl  0x14(%ebp)
  800aa8:	ff 75 10             	pushl  0x10(%ebp)
  800aab:	8d 45 e8             	lea    0xffffffe8(%ebp),%eax
  800aae:	50                   	push   %eax
  800aaf:	68 60 0a 80 00       	push   $0x800a60
  800ab4:	e8 91 fc ff ff       	call   80074a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ab9:	8b 45 e8             	mov    0xffffffe8(%ebp),%eax
  800abc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800abf:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
}
  800ac2:	c9                   	leave  
  800ac3:	c3                   	ret    

00800ac4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800aca:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800acd:	50                   	push   %eax
  800ace:	ff 75 10             	pushl  0x10(%ebp)
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	ff 75 08             	pushl  0x8(%ebp)
  800ad7:	e8 9d ff ff ff       	call   800a79 <vsnprintf>
	va_end(ap);

	return rc;
}
  800adc:	c9                   	leave  
  800add:	c3                   	ret    
	...

00800ae0 <strtoint>:
// Takes in a string in the format 0x????.
// Assumes all letters are lower case.
// If invalid formatting, then returns -1
int
strtoint(char *string) {
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	56                   	push   %esi
  800ae4:	53                   	push   %ebx
  800ae5:	8b 75 08             	mov    0x8(%ebp),%esi
  int cidx = 0;
  int end = strlen(string)-1;
  800ae8:	83 ec 0c             	sub    $0xc,%esp
  800aeb:	56                   	push   %esi
  800aec:	e8 ef 00 00 00       	call   800be0 <strlen>
  char letter;
  int hexnum = 0;
  800af1:	bb 00 00 00 00       	mov    $0x0,%ebx
  int multiplier = 1;
  800af6:	b9 01 00 00 00       	mov    $0x1,%ecx

  // pluck off characters from the end and
  // multiply by the right hex value.
  for (cidx = end; cidx > -1; cidx--) {
  800afb:	83 c4 10             	add    $0x10,%esp
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	4a                   	dec    %edx
  800b01:	0f 88 d0 00 00 00    	js     800bd7 <strtoint+0xf7>
    letter = string[cidx];
  800b07:	8a 04 16             	mov    (%esi,%edx,1),%al
    if (cidx == 0) {
  800b0a:	85 d2                	test   %edx,%edx
  800b0c:	75 12                	jne    800b20 <strtoint+0x40>
      if (letter != '0') {
  800b0e:	3c 30                	cmp    $0x30,%al
  800b10:	0f 84 ba 00 00 00    	je     800bd0 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800b1b:	e9 b9 00 00 00       	jmp    800bd9 <strtoint+0xf9>
      }
    } else if (cidx == 1) {
  800b20:	83 fa 01             	cmp    $0x1,%edx
  800b23:	75 12                	jne    800b37 <strtoint+0x57>
      if (letter != 'x') {
  800b25:	3c 78                	cmp    $0x78,%al
  800b27:	0f 84 a3 00 00 00    	je     800bd0 <strtoint+0xf0>
        //cprintf("Error: not a hex address.\n");
        return -1;
  800b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800b32:	e9 a2 00 00 00       	jmp    800bd9 <strtoint+0xf9>
      }
    } else {
      switch (letter) {
  800b37:	0f be c0             	movsbl %al,%eax
  800b3a:	83 e8 30             	sub    $0x30,%eax
  800b3d:	83 f8 36             	cmp    $0x36,%eax
  800b40:	0f 87 80 00 00 00    	ja     800bc6 <strtoint+0xe6>
  800b46:	ff 24 85 d4 35 80 00 	jmp    *0x8035d4(,%eax,4)
        case '0':
          hexnum += 0 * multiplier;
          break;
        case '1':
          hexnum += 1 * multiplier;
  800b4d:	01 cb                	add    %ecx,%ebx
          break;
  800b4f:	eb 7c                	jmp    800bcd <strtoint+0xed>
        case '2':
          hexnum += 2 * multiplier;
  800b51:	8d 1c 4b             	lea    (%ebx,%ecx,2),%ebx
          break;
  800b54:	eb 77                	jmp    800bcd <strtoint+0xed>
        case '3':
          hexnum += 3 * multiplier;
  800b56:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800b59:	01 c3                	add    %eax,%ebx
          break;
  800b5b:	eb 70                	jmp    800bcd <strtoint+0xed>
        case '4':
          hexnum += 4 * multiplier;
  800b5d:	8d 1c 8b             	lea    (%ebx,%ecx,4),%ebx
          break;
  800b60:	eb 6b                	jmp    800bcd <strtoint+0xed>
        case '5':
          hexnum += 5 * multiplier;
  800b62:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800b65:	01 c3                	add    %eax,%ebx
          break;
  800b67:	eb 64                	jmp    800bcd <strtoint+0xed>
        case '6':
          hexnum += 6 * multiplier;
  800b69:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800b6c:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800b6f:	eb 5c                	jmp    800bcd <strtoint+0xed>
        case '7':
          hexnum += 7 * multiplier;
  800b71:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800b78:	29 c8                	sub    %ecx,%eax
  800b7a:	01 c3                	add    %eax,%ebx
          break;
  800b7c:	eb 4f                	jmp    800bcd <strtoint+0xed>
        case '8':
          hexnum += 8 * multiplier;
  800b7e:	8d 1c cb             	lea    (%ebx,%ecx,8),%ebx
          break;
  800b81:	eb 4a                	jmp    800bcd <strtoint+0xed>
        case '9':
          hexnum += 9 * multiplier;
  800b83:	8d 04 c9             	lea    (%ecx,%ecx,8),%eax
  800b86:	01 c3                	add    %eax,%ebx
          break;
  800b88:	eb 43                	jmp    800bcd <strtoint+0xed>
        case 'a':
          hexnum += 10 * multiplier;
  800b8a:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800b8d:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800b90:	eb 3b                	jmp    800bcd <strtoint+0xed>
        case 'b':
          hexnum += 11 * multiplier;
  800b92:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
  800b95:	8d 04 41             	lea    (%ecx,%eax,2),%eax
  800b98:	01 c3                	add    %eax,%ebx
          break;
  800b9a:	eb 31                	jmp    800bcd <strtoint+0xed>
        case 'c':
          hexnum += 12 * multiplier;
  800b9c:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800b9f:	8d 1c 83             	lea    (%ebx,%eax,4),%ebx
          break;
  800ba2:	eb 29                	jmp    800bcd <strtoint+0xed>
        case 'd':
          hexnum += 13 * multiplier;
  800ba4:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800ba7:	8d 04 81             	lea    (%ecx,%eax,4),%eax
  800baa:	01 c3                	add    %eax,%ebx
          break;
  800bac:	eb 1f                	jmp    800bcd <strtoint+0xed>
        case 'e':
          hexnum += 14 * multiplier;
  800bae:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
  800bb5:	29 c8                	sub    %ecx,%eax
  800bb7:	8d 1c 43             	lea    (%ebx,%eax,2),%ebx
          break;
  800bba:	eb 11                	jmp    800bcd <strtoint+0xed>
        case 'f':
          hexnum += 15 * multiplier;
  800bbc:	8d 04 49             	lea    (%ecx,%ecx,2),%eax
  800bbf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800bc2:	01 c3                	add    %eax,%ebx
          break;
  800bc4:	eb 07                	jmp    800bcd <strtoint+0xed>
        default:
          //cprintf("Error: not a hex address.\n");
          return -1;
  800bc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800bcb:	eb 0c                	jmp    800bd9 <strtoint+0xf9>
          break;
      }
      multiplier = multiplier * 16;
  800bcd:	c1 e1 04             	shl    $0x4,%ecx
  800bd0:	4a                   	dec    %edx
  800bd1:	0f 89 30 ff ff ff    	jns    800b07 <strtoint+0x27>
    }
  }

  return hexnum;
  800bd7:	89 d8                	mov    %ebx,%eax
}
  800bd9:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  800bdc:	5b                   	pop    %ebx
  800bdd:	5e                   	pop    %esi
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strlen>:





int
strlen(const char *s)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800be6:	b8 00 00 00 00       	mov    $0x0,%eax
  800beb:	80 3a 00             	cmpb   $0x0,(%edx)
  800bee:	74 07                	je     800bf7 <strlen+0x17>
		n++;
  800bf0:	40                   	inc    %eax
  800bf1:	42                   	inc    %edx
  800bf2:	80 3a 00             	cmpb   $0x0,(%edx)
  800bf5:	75 f9                	jne    800bf0 <strlen+0x10>
	return n;
}
  800bf7:	c9                   	leave  
  800bf8:	c3                   	ret    

00800bf9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bff:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c02:	b8 00 00 00 00       	mov    $0x0,%eax
  800c07:	85 d2                	test   %edx,%edx
  800c09:	74 0f                	je     800c1a <strnlen+0x21>
  800c0b:	80 39 00             	cmpb   $0x0,(%ecx)
  800c0e:	74 0a                	je     800c1a <strnlen+0x21>
		n++;
  800c10:	40                   	inc    %eax
  800c11:	41                   	inc    %ecx
  800c12:	4a                   	dec    %edx
  800c13:	74 05                	je     800c1a <strnlen+0x21>
  800c15:	80 39 00             	cmpb   $0x0,(%ecx)
  800c18:	75 f6                	jne    800c10 <strnlen+0x17>
	return n;
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	53                   	push   %ebx
  800c20:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c23:	8b 55 0c             	mov    0xc(%ebp),%edx
	char *ret;

	ret = dst;
  800c26:	89 cb                	mov    %ecx,%ebx
	while ((*dst++ = *src++) != '\0')
  800c28:	8a 02                	mov    (%edx),%al
  800c2a:	42                   	inc    %edx
  800c2b:	88 01                	mov    %al,(%ecx)
  800c2d:	41                   	inc    %ecx
  800c2e:	84 c0                	test   %al,%al
  800c30:	75 f6                	jne    800c28 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c32:	89 d8                	mov    %ebx,%eax
  800c34:	5b                   	pop    %ebx
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c43:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
  800c46:	89 cf                	mov    %ecx,%edi
	for (i = 0; i < size; i++) {
  800c48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4d:	39 f3                	cmp    %esi,%ebx
  800c4f:	73 10                	jae    800c61 <strncpy+0x2a>
		*dst++ = *src;
  800c51:	8a 02                	mov    (%edx),%al
  800c53:	88 01                	mov    %al,(%ecx)
  800c55:	41                   	inc    %ecx
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c56:	80 3a 01             	cmpb   $0x1,(%edx)
  800c59:	83 da ff             	sbb    $0xffffffff,%edx
  800c5c:	43                   	inc    %ebx
  800c5d:	39 f3                	cmp    %esi,%ebx
  800c5f:	72 f0                	jb     800c51 <strncpy+0x1a>
	}
	return ret;
}
  800c61:	89 f8                	mov    %edi,%eax
  800c63:	5b                   	pop    %ebx
  800c64:	5e                   	pop    %esi
  800c65:	5f                   	pop    %edi
  800c66:	c9                   	leave  
  800c67:	c3                   	ret    

00800c68 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
  800c6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800c70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c73:	8b 55 10             	mov    0x10(%ebp),%edx
	char *dst_in;

	dst_in = dst;
  800c76:	89 de                	mov    %ebx,%esi
	if (size > 0) {
  800c78:	85 d2                	test   %edx,%edx
  800c7a:	74 19                	je     800c95 <strlcpy+0x2d>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c7c:	4a                   	dec    %edx
  800c7d:	74 13                	je     800c92 <strlcpy+0x2a>
  800c7f:	80 39 00             	cmpb   $0x0,(%ecx)
  800c82:	74 0e                	je     800c92 <strlcpy+0x2a>
  800c84:	8a 01                	mov    (%ecx),%al
  800c86:	41                   	inc    %ecx
  800c87:	88 03                	mov    %al,(%ebx)
  800c89:	43                   	inc    %ebx
  800c8a:	4a                   	dec    %edx
  800c8b:	74 05                	je     800c92 <strlcpy+0x2a>
  800c8d:	80 39 00             	cmpb   $0x0,(%ecx)
  800c90:	75 f2                	jne    800c84 <strlcpy+0x1c>
		*dst = '\0';
  800c92:	c6 03 00             	movb   $0x0,(%ebx)
	}
	return dst - dst_in;
  800c95:	89 d8                	mov    %ebx,%eax
  800c97:	29 f0                	sub    %esi,%eax
}
  800c99:	5b                   	pop    %ebx
  800c9a:	5e                   	pop    %esi
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	while (*p && *p == *q)
		p++, q++;
  800ca6:	80 3a 00             	cmpb   $0x0,(%edx)
  800ca9:	74 13                	je     800cbe <strcmp+0x21>
  800cab:	8a 02                	mov    (%edx),%al
  800cad:	3a 01                	cmp    (%ecx),%al
  800caf:	75 0d                	jne    800cbe <strcmp+0x21>
  800cb1:	42                   	inc    %edx
  800cb2:	41                   	inc    %ecx
  800cb3:	80 3a 00             	cmpb   $0x0,(%edx)
  800cb6:	74 06                	je     800cbe <strcmp+0x21>
  800cb8:	8a 02                	mov    (%edx),%al
  800cba:	3a 01                	cmp    (%ecx),%al
  800cbc:	74 f3                	je     800cb1 <strcmp+0x14>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbe:	0f b6 02             	movzbl (%edx),%eax
  800cc1:	0f b6 11             	movzbl (%ecx),%edx
  800cc4:	29 d0                	sub    %edx,%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	53                   	push   %ebx
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cd2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
  800cd5:	85 c9                	test   %ecx,%ecx
  800cd7:	74 1f                	je     800cf8 <strncmp+0x30>
  800cd9:	80 3a 00             	cmpb   $0x0,(%edx)
  800cdc:	74 16                	je     800cf4 <strncmp+0x2c>
  800cde:	8a 02                	mov    (%edx),%al
  800ce0:	3a 03                	cmp    (%ebx),%al
  800ce2:	75 10                	jne    800cf4 <strncmp+0x2c>
  800ce4:	42                   	inc    %edx
  800ce5:	43                   	inc    %ebx
  800ce6:	49                   	dec    %ecx
  800ce7:	74 0f                	je     800cf8 <strncmp+0x30>
  800ce9:	80 3a 00             	cmpb   $0x0,(%edx)
  800cec:	74 06                	je     800cf4 <strncmp+0x2c>
  800cee:	8a 02                	mov    (%edx),%al
  800cf0:	3a 03                	cmp    (%ebx),%al
  800cf2:	74 f0                	je     800ce4 <strncmp+0x1c>
	if (n == 0)
  800cf4:	85 c9                	test   %ecx,%ecx
  800cf6:	75 07                	jne    800cff <strncmp+0x37>
		return 0;
  800cf8:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfd:	eb 0a                	jmp    800d09 <strncmp+0x41>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cff:	0f b6 12             	movzbl (%edx),%edx
  800d02:	0f b6 03             	movzbl (%ebx),%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
}
  800d09:	5b                   	pop    %ebx
  800d0a:	c9                   	leave  
  800d0b:	c3                   	ret    

00800d0c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800d15:	80 38 00             	cmpb   $0x0,(%eax)
  800d18:	74 0a                	je     800d24 <strchr+0x18>
		if (*s == c)
  800d1a:	38 10                	cmp    %dl,(%eax)
  800d1c:	74 0b                	je     800d29 <strchr+0x1d>
  800d1e:	40                   	inc    %eax
  800d1f:	80 38 00             	cmpb   $0x0,(%eax)
  800d22:	75 f6                	jne    800d1a <strchr+0xe>
			return (char *) s;
	return 0;
  800d24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 55 0c             	mov    0xc(%ebp),%dl
	for (; *s; s++)
  800d34:	80 38 00             	cmpb   $0x0,(%eax)
  800d37:	74 0a                	je     800d43 <strfind+0x18>
		if (*s == c)
  800d39:	38 10                	cmp    %dl,(%eax)
  800d3b:	74 06                	je     800d43 <strfind+0x18>
  800d3d:	40                   	inc    %eax
  800d3e:	80 38 00             	cmpb   $0x0,(%eax)
  800d41:	75 f6                	jne    800d39 <strfind+0xe>
			break;
	return (char *) s;
}
  800d43:	c9                   	leave  
  800d44:	c3                   	ret    

00800d45 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	57                   	push   %edi
  800d49:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d4c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
		return v;
  800d4f:	89 f8                	mov    %edi,%eax
  800d51:	85 c9                	test   %ecx,%ecx
  800d53:	74 40                	je     800d95 <memset+0x50>
	if ((int)v%4 == 0 && n%4 == 0) {
  800d55:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d5b:	75 30                	jne    800d8d <memset+0x48>
  800d5d:	f6 c1 03             	test   $0x3,%cl
  800d60:	75 2b                	jne    800d8d <memset+0x48>
		c &= 0xFF;
  800d62:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	c1 e0 18             	shl    $0x18,%eax
  800d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d72:	c1 e2 10             	shl    $0x10,%edx
  800d75:	09 d0                	or     %edx,%eax
  800d77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7a:	c1 e2 08             	shl    $0x8,%edx
  800d7d:	09 d0                	or     %edx,%eax
  800d7f:	09 45 0c             	or     %eax,0xc(%ebp)
		asm volatile("cld; rep stosl\n"
  800d82:	c1 e9 02             	shr    $0x2,%ecx
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	fc                   	cld    
  800d89:	f3 ab                	repz stos %eax,%es:(%edi)
  800d8b:	eb 06                	jmp    800d93 <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	fc                   	cld    
  800d91:	f3 aa                	repz stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
  800d93:	89 f8                	mov    %edi,%eax
}
  800d95:	5f                   	pop    %edi
  800d96:	c9                   	leave  
  800d97:	c3                   	ret    

00800d98 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d98:	55                   	push   %ebp
  800d99:	89 e5                	mov    %esp,%ebp
  800d9b:	57                   	push   %edi
  800d9c:	56                   	push   %esi
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800da3:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800da6:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800da8:	39 c6                	cmp    %eax,%esi
  800daa:	73 33                	jae    800ddf <memmove+0x47>
  800dac:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800daf:	39 c2                	cmp    %eax,%edx
  800db1:	76 2c                	jbe    800ddf <memmove+0x47>
		s += n;
  800db3:	89 d6                	mov    %edx,%esi
		d += n;
  800db5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800db8:	f6 c2 03             	test   $0x3,%dl
  800dbb:	75 1b                	jne    800dd8 <memmove+0x40>
  800dbd:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dc3:	75 13                	jne    800dd8 <memmove+0x40>
  800dc5:	f6 c1 03             	test   $0x3,%cl
  800dc8:	75 0e                	jne    800dd8 <memmove+0x40>
			asm volatile("std; rep movsl\n"
  800dca:	83 ef 04             	sub    $0x4,%edi
  800dcd:	83 ee 04             	sub    $0x4,%esi
  800dd0:	c1 e9 02             	shr    $0x2,%ecx
  800dd3:	fd                   	std    
  800dd4:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800dd6:	eb 27                	jmp    800dff <memmove+0x67>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800dd8:	4f                   	dec    %edi
  800dd9:	4e                   	dec    %esi
  800dda:	fd                   	std    
  800ddb:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
  800ddd:	eb 20                	jmp    800dff <memmove+0x67>
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ddf:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800de5:	75 15                	jne    800dfc <memmove+0x64>
  800de7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ded:	75 0d                	jne    800dfc <memmove+0x64>
  800def:	f6 c1 03             	test   $0x3,%cl
  800df2:	75 08                	jne    800dfc <memmove+0x64>
			asm volatile("cld; rep movsl\n"
  800df4:	c1 e9 02             	shr    $0x2,%ecx
  800df7:	fc                   	cld    
  800df8:	f3 a5                	repz movsl %ds:(%esi),%es:(%edi)
  800dfa:	eb 03                	jmp    800dff <memmove+0x67>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800dfc:	fc                   	cld    
  800dfd:	f3 a4                	repz movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    

00800e03 <memcpy>:

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
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800e06:	ff 75 10             	pushl  0x10(%ebp)
  800e09:	ff 75 0c             	pushl  0xc(%ebp)
  800e0c:	ff 75 08             	pushl  0x8(%ebp)
  800e0f:	e8 84 ff ff ff       	call   800d98 <memmove>
}
  800e14:	c9                   	leave  
  800e15:	c3                   	ret    

00800e16 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	53                   	push   %ebx
	const uint8_t *s1 = (const uint8_t *) v1;
  800e1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	const uint8_t *s2 = (const uint8_t *) v2;
  800e1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	while (n-- > 0) {
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e20:	8b 55 10             	mov    0x10(%ebp),%edx
  800e23:	4a                   	dec    %edx
  800e24:	83 fa ff             	cmp    $0xffffffff,%edx
  800e27:	74 1a                	je     800e43 <memcmp+0x2d>
  800e29:	8a 01                	mov    (%ecx),%al
  800e2b:	3a 03                	cmp    (%ebx),%al
  800e2d:	74 0c                	je     800e3b <memcmp+0x25>
  800e2f:	0f b6 d0             	movzbl %al,%edx
  800e32:	0f b6 03             	movzbl (%ebx),%eax
  800e35:	29 c2                	sub    %eax,%edx
  800e37:	89 d0                	mov    %edx,%eax
  800e39:	eb 0d                	jmp    800e48 <memcmp+0x32>
  800e3b:	41                   	inc    %ecx
  800e3c:	43                   	inc    %ebx
  800e3d:	4a                   	dec    %edx
  800e3e:	83 fa ff             	cmp    $0xffffffff,%edx
  800e41:	75 e6                	jne    800e29 <memcmp+0x13>
	}

	return 0;
  800e43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e48:	5b                   	pop    %ebx
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e54:	89 c2                	mov    %eax,%edx
  800e56:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e59:	39 d0                	cmp    %edx,%eax
  800e5b:	73 09                	jae    800e66 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e5d:	38 08                	cmp    %cl,(%eax)
  800e5f:	74 05                	je     800e66 <memfind+0x1b>
  800e61:	40                   	inc    %eax
  800e62:	39 d0                	cmp    %edx,%eax
  800e64:	72 f7                	jb     800e5d <memfind+0x12>
			break;
	return (void *) s;
}
  800e66:	c9                   	leave  
  800e67:	c3                   	ret    

00800e68 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	57                   	push   %edi
  800e6c:	56                   	push   %esi
  800e6d:	53                   	push   %ebx
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e74:	8b 4d 10             	mov    0x10(%ebp),%ecx
	int neg = 0;
  800e77:	bf 00 00 00 00       	mov    $0x0,%edi
	long val = 0;
  800e7c:	bb 00 00 00 00       	mov    $0x0,%ebx

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
		s++;
  800e81:	80 3a 20             	cmpb   $0x20,(%edx)
  800e84:	74 05                	je     800e8b <strtol+0x23>
  800e86:	80 3a 09             	cmpb   $0x9,(%edx)
  800e89:	75 0b                	jne    800e96 <strtol+0x2e>
  800e8b:	42                   	inc    %edx
  800e8c:	80 3a 20             	cmpb   $0x20,(%edx)
  800e8f:	74 fa                	je     800e8b <strtol+0x23>
  800e91:	80 3a 09             	cmpb   $0x9,(%edx)
  800e94:	74 f5                	je     800e8b <strtol+0x23>

	// plus/minus sign
	if (*s == '+')
  800e96:	80 3a 2b             	cmpb   $0x2b,(%edx)
  800e99:	75 03                	jne    800e9e <strtol+0x36>
		s++;
  800e9b:	42                   	inc    %edx
  800e9c:	eb 0b                	jmp    800ea9 <strtol+0x41>
	else if (*s == '-')
  800e9e:	80 3a 2d             	cmpb   $0x2d,(%edx)
  800ea1:	75 06                	jne    800ea9 <strtol+0x41>
		s++, neg = 1;
  800ea3:	42                   	inc    %edx
  800ea4:	bf 01 00 00 00       	mov    $0x1,%edi

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea9:	85 c9                	test   %ecx,%ecx
  800eab:	74 05                	je     800eb2 <strtol+0x4a>
  800ead:	83 f9 10             	cmp    $0x10,%ecx
  800eb0:	75 15                	jne    800ec7 <strtol+0x5f>
  800eb2:	80 3a 30             	cmpb   $0x30,(%edx)
  800eb5:	75 10                	jne    800ec7 <strtol+0x5f>
  800eb7:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ebb:	75 0a                	jne    800ec7 <strtol+0x5f>
		s += 2, base = 16;
  800ebd:	83 c2 02             	add    $0x2,%edx
  800ec0:	b9 10 00 00 00       	mov    $0x10,%ecx
  800ec5:	eb 14                	jmp    800edb <strtol+0x73>
	else if (base == 0 && s[0] == '0')
  800ec7:	85 c9                	test   %ecx,%ecx
  800ec9:	75 10                	jne    800edb <strtol+0x73>
  800ecb:	80 3a 30             	cmpb   $0x30,(%edx)
  800ece:	75 05                	jne    800ed5 <strtol+0x6d>
		s++, base = 8;
  800ed0:	42                   	inc    %edx
  800ed1:	b1 08                	mov    $0x8,%cl
  800ed3:	eb 06                	jmp    800edb <strtol+0x73>
	else if (base == 0)
  800ed5:	85 c9                	test   %ecx,%ecx
  800ed7:	75 02                	jne    800edb <strtol+0x73>
		base = 10;
  800ed9:	b1 0a                	mov    $0xa,%cl

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800edb:	8a 02                	mov    (%edx),%al
  800edd:	83 e8 30             	sub    $0x30,%eax
  800ee0:	3c 09                	cmp    $0x9,%al
  800ee2:	77 08                	ja     800eec <strtol+0x84>
			dig = *s - '0';
  800ee4:	0f be 02             	movsbl (%edx),%eax
  800ee7:	83 e8 30             	sub    $0x30,%eax
  800eea:	eb 20                	jmp    800f0c <strtol+0xa4>
		else if (*s >= 'a' && *s <= 'z')
  800eec:	8a 02                	mov    (%edx),%al
  800eee:	83 e8 61             	sub    $0x61,%eax
  800ef1:	3c 19                	cmp    $0x19,%al
  800ef3:	77 08                	ja     800efd <strtol+0x95>
			dig = *s - 'a' + 10;
  800ef5:	0f be 02             	movsbl (%edx),%eax
  800ef8:	83 e8 57             	sub    $0x57,%eax
  800efb:	eb 0f                	jmp    800f0c <strtol+0xa4>
		else if (*s >= 'A' && *s <= 'Z')
  800efd:	8a 02                	mov    (%edx),%al
  800eff:	83 e8 41             	sub    $0x41,%eax
  800f02:	3c 19                	cmp    $0x19,%al
  800f04:	77 12                	ja     800f18 <strtol+0xb0>
			dig = *s - 'A' + 10;
  800f06:	0f be 02             	movsbl (%edx),%eax
  800f09:	83 e8 37             	sub    $0x37,%eax
		else
			break;
		if (dig >= base)
  800f0c:	39 c8                	cmp    %ecx,%eax
  800f0e:	7d 08                	jge    800f18 <strtol+0xb0>
			break;
		s++, val = (val * base) + dig;
  800f10:	42                   	inc    %edx
  800f11:	0f af d9             	imul   %ecx,%ebx
  800f14:	01 c3                	add    %eax,%ebx
  800f16:	eb c3                	jmp    800edb <strtol+0x73>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f18:	85 f6                	test   %esi,%esi
  800f1a:	74 02                	je     800f1e <strtol+0xb6>
		*endptr = (char *) s;
  800f1c:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800f1e:	89 d8                	mov    %ebx,%eax
  800f20:	85 ff                	test   %edi,%edi
  800f22:	74 02                	je     800f26 <strtol+0xbe>
  800f24:	f7 d8                	neg    %eax
}
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    
	...

00800f2c <sys_cputs>:
}

void
sys_cputs(const char *s, size_t len)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	57                   	push   %edi
  800f30:	56                   	push   %esi
  800f31:	53                   	push   %ebx
  800f32:	83 ec 04             	sub    $0x4,%esp
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3b:	bf 00 00 00 00       	mov    $0x0,%edi
  800f40:	89 f8                	mov    %edi,%eax
  800f42:	89 fb                	mov    %edi,%ebx
  800f44:	89 fe                	mov    %edi,%esi
  800f46:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f48:	83 c4 04             	add    $0x4,%esp
  800f4b:	5b                   	pop    %ebx
  800f4c:	5e                   	pop    %esi
  800f4d:	5f                   	pop    %edi
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	57                   	push   %edi
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
  800f56:	b8 01 00 00 00       	mov    $0x1,%eax
  800f5b:	bf 00 00 00 00       	mov    $0x0,%edi
  800f60:	89 fa                	mov    %edi,%edx
  800f62:	89 f9                	mov    %edi,%ecx
  800f64:	89 fb                	mov    %edi,%ebx
  800f66:	89 fe                	mov    %edi,%esi
  800f68:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
  800f75:	83 ec 0c             	sub    $0xc,%esp
  800f78:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800f80:	bf 00 00 00 00       	mov    $0x0,%edi
  800f85:	89 f9                	mov    %edi,%ecx
  800f87:	89 fb                	mov    %edi,%ebx
  800f89:	89 fe                	mov    %edi,%esi
  800f8b:	cd 30                	int    $0x30
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	7e 17                	jle    800fa8 <sys_env_destroy+0x39>
  800f91:	83 ec 0c             	sub    $0xc,%esp
  800f94:	50                   	push   %eax
  800f95:	6a 03                	push   $0x3
  800f97:	68 b0 36 80 00       	push   $0x8036b0
  800f9c:	6a 23                	push   $0x23
  800f9e:	68 cd 36 80 00       	push   $0x8036cd
  800fa3:	e8 80 f5 ff ff       	call   800528 <_panic>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800fa8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	c9                   	leave  
  800faf:	c3                   	ret    

00800fb0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
  800fb6:	b8 02 00 00 00       	mov    $0x2,%eax
  800fbb:	bf 00 00 00 00       	mov    $0x0,%edi
  800fc0:	89 fa                	mov    %edi,%edx
  800fc2:	89 f9                	mov    %edi,%ecx
  800fc4:	89 fb                	mov    %edi,%ebx
  800fc6:	89 fe                	mov    %edi,%esi
  800fc8:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fca:	5b                   	pop    %ebx
  800fcb:	5e                   	pop    %esi
  800fcc:	5f                   	pop    %edi
  800fcd:	c9                   	leave  
  800fce:	c3                   	ret    

00800fcf <sys_yield>:

void
sys_yield(void)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	57                   	push   %edi
  800fd3:	56                   	push   %esi
  800fd4:	53                   	push   %ebx
  800fd5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fda:	bf 00 00 00 00       	mov    $0x0,%edi
  800fdf:	89 fa                	mov    %edi,%edx
  800fe1:	89 f9                	mov    %edi,%ecx
  800fe3:	89 fb                	mov    %edi,%ebx
  800fe5:	89 fe                	mov    %edi,%esi
  800fe7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fe9:	5b                   	pop    %ebx
  800fea:	5e                   	pop    %esi
  800feb:	5f                   	pop    %edi
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	57                   	push   %edi
  800ff2:	56                   	push   %esi
  800ff3:	53                   	push   %ebx
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801000:	b8 04 00 00 00       	mov    $0x4,%eax
  801005:	bf 00 00 00 00       	mov    $0x0,%edi
  80100a:	89 fe                	mov    %edi,%esi
  80100c:	cd 30                	int    $0x30
  80100e:	85 c0                	test   %eax,%eax
  801010:	7e 17                	jle    801029 <sys_page_alloc+0x3b>
  801012:	83 ec 0c             	sub    $0xc,%esp
  801015:	50                   	push   %eax
  801016:	6a 04                	push   $0x4
  801018:	68 b0 36 80 00       	push   $0x8036b0
  80101d:	6a 23                	push   $0x23
  80101f:	68 cd 36 80 00       	push   $0x8036cd
  801024:	e8 ff f4 ff ff       	call   800528 <_panic>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801029:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	57                   	push   %edi
  801035:	56                   	push   %esi
  801036:	53                   	push   %ebx
  801037:	83 ec 0c             	sub    $0xc,%esp
  80103a:	8b 55 08             	mov    0x8(%ebp),%edx
  80103d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801040:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801043:	8b 7d 14             	mov    0x14(%ebp),%edi
  801046:	8b 75 18             	mov    0x18(%ebp),%esi
  801049:	b8 05 00 00 00       	mov    $0x5,%eax
  80104e:	cd 30                	int    $0x30
  801050:	85 c0                	test   %eax,%eax
  801052:	7e 17                	jle    80106b <sys_page_map+0x3a>
  801054:	83 ec 0c             	sub    $0xc,%esp
  801057:	50                   	push   %eax
  801058:	6a 05                	push   $0x5
  80105a:	68 b0 36 80 00       	push   $0x8036b0
  80105f:	6a 23                	push   $0x23
  801061:	68 cd 36 80 00       	push   $0x8036cd
  801066:	e8 bd f4 ff ff       	call   800528 <_panic>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80106b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80106e:	5b                   	pop    %ebx
  80106f:	5e                   	pop    %esi
  801070:	5f                   	pop    %edi
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	57                   	push   %edi
  801077:	56                   	push   %esi
  801078:	53                   	push   %ebx
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	8b 55 08             	mov    0x8(%ebp),%edx
  80107f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801082:	b8 06 00 00 00       	mov    $0x6,%eax
  801087:	bf 00 00 00 00       	mov    $0x0,%edi
  80108c:	89 fb                	mov    %edi,%ebx
  80108e:	89 fe                	mov    %edi,%esi
  801090:	cd 30                	int    $0x30
  801092:	85 c0                	test   %eax,%eax
  801094:	7e 17                	jle    8010ad <sys_page_unmap+0x3a>
  801096:	83 ec 0c             	sub    $0xc,%esp
  801099:	50                   	push   %eax
  80109a:	6a 06                	push   $0x6
  80109c:	68 b0 36 80 00       	push   $0x8036b0
  8010a1:	6a 23                	push   $0x23
  8010a3:	68 cd 36 80 00       	push   $0x8036cd
  8010a8:	e8 7b f4 ff ff       	call   800528 <_panic>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010ad:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	c9                   	leave  
  8010b4:	c3                   	ret    

008010b5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	57                   	push   %edi
  8010b9:	56                   	push   %esi
  8010ba:	53                   	push   %ebx
  8010bb:	83 ec 0c             	sub    $0xc,%esp
  8010be:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c4:	b8 08 00 00 00       	mov    $0x8,%eax
  8010c9:	bf 00 00 00 00       	mov    $0x0,%edi
  8010ce:	89 fb                	mov    %edi,%ebx
  8010d0:	89 fe                	mov    %edi,%esi
  8010d2:	cd 30                	int    $0x30
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	7e 17                	jle    8010ef <sys_env_set_status+0x3a>
  8010d8:	83 ec 0c             	sub    $0xc,%esp
  8010db:	50                   	push   %eax
  8010dc:	6a 08                	push   $0x8
  8010de:	68 b0 36 80 00       	push   $0x8036b0
  8010e3:	6a 23                	push   $0x23
  8010e5:	68 cd 36 80 00       	push   $0x8036cd
  8010ea:	e8 39 f4 ff ff       	call   800528 <_panic>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010ef:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8010f2:	5b                   	pop    %ebx
  8010f3:	5e                   	pop    %esi
  8010f4:	5f                   	pop    %edi
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	57                   	push   %edi
  8010fb:	56                   	push   %esi
  8010fc:	53                   	push   %ebx
  8010fd:	83 ec 0c             	sub    $0xc,%esp
  801100:	8b 55 08             	mov    0x8(%ebp),%edx
  801103:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801106:	b8 09 00 00 00       	mov    $0x9,%eax
  80110b:	bf 00 00 00 00       	mov    $0x0,%edi
  801110:	89 fb                	mov    %edi,%ebx
  801112:	89 fe                	mov    %edi,%esi
  801114:	cd 30                	int    $0x30
  801116:	85 c0                	test   %eax,%eax
  801118:	7e 17                	jle    801131 <sys_env_set_trapframe+0x3a>
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	50                   	push   %eax
  80111e:	6a 09                	push   $0x9
  801120:	68 b0 36 80 00       	push   $0x8036b0
  801125:	6a 23                	push   $0x23
  801127:	68 cd 36 80 00       	push   $0x8036cd
  80112c:	e8 f7 f3 ff ff       	call   800528 <_panic>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801131:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801134:	5b                   	pop    %ebx
  801135:	5e                   	pop    %esi
  801136:	5f                   	pop    %edi
  801137:	c9                   	leave  
  801138:	c3                   	ret    

00801139 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	57                   	push   %edi
  80113d:	56                   	push   %esi
  80113e:	53                   	push   %ebx
  80113f:	83 ec 0c             	sub    $0xc,%esp
  801142:	8b 55 08             	mov    0x8(%ebp),%edx
  801145:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801148:	b8 0a 00 00 00       	mov    $0xa,%eax
  80114d:	bf 00 00 00 00       	mov    $0x0,%edi
  801152:	89 fb                	mov    %edi,%ebx
  801154:	89 fe                	mov    %edi,%esi
  801156:	cd 30                	int    $0x30
  801158:	85 c0                	test   %eax,%eax
  80115a:	7e 17                	jle    801173 <sys_env_set_pgfault_upcall+0x3a>
  80115c:	83 ec 0c             	sub    $0xc,%esp
  80115f:	50                   	push   %eax
  801160:	6a 0a                	push   $0xa
  801162:	68 b0 36 80 00       	push   $0x8036b0
  801167:	6a 23                	push   $0x23
  801169:	68 cd 36 80 00       	push   $0x8036cd
  80116e:	e8 b5 f3 ff ff       	call   800528 <_panic>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801173:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5f                   	pop    %edi
  801179:	c9                   	leave  
  80117a:	c3                   	ret    

0080117b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	57                   	push   %edi
  80117f:	56                   	push   %esi
  801180:	53                   	push   %ebx
  801181:	8b 55 08             	mov    0x8(%ebp),%edx
  801184:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801187:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80118a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80118d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801192:	be 00 00 00 00       	mov    $0x0,%esi
  801197:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801199:	5b                   	pop    %ebx
  80119a:	5e                   	pop    %esi
  80119b:	5f                   	pop    %edi
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	57                   	push   %edi
  8011a2:	56                   	push   %esi
  8011a3:	53                   	push   %ebx
  8011a4:	83 ec 0c             	sub    $0xc,%esp
  8011a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8011aa:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011af:	bf 00 00 00 00       	mov    $0x0,%edi
  8011b4:	89 f9                	mov    %edi,%ecx
  8011b6:	89 fb                	mov    %edi,%ebx
  8011b8:	89 fe                	mov    %edi,%esi
  8011ba:	cd 30                	int    $0x30
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	7e 17                	jle    8011d7 <sys_ipc_recv+0x39>
  8011c0:	83 ec 0c             	sub    $0xc,%esp
  8011c3:	50                   	push   %eax
  8011c4:	6a 0d                	push   $0xd
  8011c6:	68 b0 36 80 00       	push   $0x8036b0
  8011cb:	6a 23                	push   $0x23
  8011cd:	68 cd 36 80 00       	push   $0x8036cd
  8011d2:	e8 51 f3 ff ff       	call   800528 <_panic>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011d7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8011da:	5b                   	pop    %ebx
  8011db:	5e                   	pop    %esi
  8011dc:	5f                   	pop    %edi
  8011dd:	c9                   	leave  
  8011de:	c3                   	ret    

008011df <sys_transmit_packet>:

int
sys_transmit_packet(char* packet, int pktsize)
{
  8011df:	55                   	push   %ebp
  8011e0:	89 e5                	mov    %esp,%ebp
  8011e2:	57                   	push   %edi
  8011e3:	56                   	push   %esi
  8011e4:	53                   	push   %ebx
  8011e5:	83 ec 0c             	sub    $0xc,%esp
  8011e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ee:	b8 10 00 00 00       	mov    $0x10,%eax
  8011f3:	bf 00 00 00 00       	mov    $0x0,%edi
  8011f8:	89 fb                	mov    %edi,%ebx
  8011fa:	89 fe                	mov    %edi,%esi
  8011fc:	cd 30                	int    $0x30
  8011fe:	85 c0                	test   %eax,%eax
  801200:	7e 17                	jle    801219 <sys_transmit_packet+0x3a>
  801202:	83 ec 0c             	sub    $0xc,%esp
  801205:	50                   	push   %eax
  801206:	6a 10                	push   $0x10
  801208:	68 b0 36 80 00       	push   $0x8036b0
  80120d:	6a 23                	push   $0x23
  80120f:	68 cd 36 80 00       	push   $0x8036cd
  801214:	e8 0f f3 ff ff       	call   800528 <_panic>
	return syscall(SYS_transmit_packet, 1, (uint32_t) packet, pktsize, 0, 0, 0);
}
  801219:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80121c:	5b                   	pop    %ebx
  80121d:	5e                   	pop    %esi
  80121e:	5f                   	pop    %edi
  80121f:	c9                   	leave  
  801220:	c3                   	ret    

00801221 <sys_receive_packet>:

int
sys_receive_packet(char* packet, int* size)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	57                   	push   %edi
  801225:	56                   	push   %esi
  801226:	53                   	push   %ebx
  801227:	83 ec 0c             	sub    $0xc,%esp
  80122a:	8b 55 08             	mov    0x8(%ebp),%edx
  80122d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801230:	b8 11 00 00 00       	mov    $0x11,%eax
  801235:	bf 00 00 00 00       	mov    $0x0,%edi
  80123a:	89 fb                	mov    %edi,%ebx
  80123c:	89 fe                	mov    %edi,%esi
  80123e:	cd 30                	int    $0x30
  801240:	85 c0                	test   %eax,%eax
  801242:	7e 17                	jle    80125b <sys_receive_packet+0x3a>
  801244:	83 ec 0c             	sub    $0xc,%esp
  801247:	50                   	push   %eax
  801248:	6a 11                	push   $0x11
  80124a:	68 b0 36 80 00       	push   $0x8036b0
  80124f:	6a 23                	push   $0x23
  801251:	68 cd 36 80 00       	push   $0x8036cd
  801256:	e8 cd f2 ff ff       	call   800528 <_panic>
	return syscall(SYS_receive_packet, 1, (uint32_t) packet, (uint32_t) size, 0, 0, 0);
}
  80125b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80125e:	5b                   	pop    %ebx
  80125f:	5e                   	pop    %esi
  801260:	5f                   	pop    %edi
  801261:	c9                   	leave  
  801262:	c3                   	ret    

00801263 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	57                   	push   %edi
  801267:	56                   	push   %esi
  801268:	53                   	push   %ebx
  801269:	b8 0f 00 00 00       	mov    $0xf,%eax
  80126e:	bf 00 00 00 00       	mov    $0x0,%edi
  801273:	89 fa                	mov    %edi,%edx
  801275:	89 f9                	mov    %edi,%ecx
  801277:	89 fb                	mov    %edi,%ebx
  801279:	89 fe                	mov    %edi,%esi
  80127b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80127d:	5b                   	pop    %ebx
  80127e:	5e                   	pop    %esi
  80127f:	5f                   	pop    %edi
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <sys_map_receive_buffers>:

// Lab 6: Challenge
int
sys_map_receive_buffers(char* first_buffer)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	57                   	push   %edi
  801286:	56                   	push   %esi
  801287:	53                   	push   %ebx
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	8b 55 08             	mov    0x8(%ebp),%edx
  80128e:	b8 0e 00 00 00       	mov    $0xe,%eax
  801293:	bf 00 00 00 00       	mov    $0x0,%edi
  801298:	89 f9                	mov    %edi,%ecx
  80129a:	89 fb                	mov    %edi,%ebx
  80129c:	89 fe                	mov    %edi,%esi
  80129e:	cd 30                	int    $0x30
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	7e 17                	jle    8012bb <sys_map_receive_buffers+0x39>
  8012a4:	83 ec 0c             	sub    $0xc,%esp
  8012a7:	50                   	push   %eax
  8012a8:	6a 0e                	push   $0xe
  8012aa:	68 b0 36 80 00       	push   $0x8036b0
  8012af:	6a 23                	push   $0x23
  8012b1:	68 cd 36 80 00       	push   $0x8036cd
  8012b6:	e8 6d f2 ff ff       	call   800528 <_panic>
	return syscall(SYS_map_receive_buffers, 1, (uint32_t) first_buffer, 0, 0, 0, 0);
}
  8012bb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8012be:	5b                   	pop    %ebx
  8012bf:	5e                   	pop    %esi
  8012c0:	5f                   	pop    %edi
  8012c1:	c9                   	leave  
  8012c2:	c3                   	ret    

008012c3 <sys_receive_packet_zerocopy>:
int
sys_receive_packet_zerocopy(int* packetidx)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
  8012c6:	57                   	push   %edi
  8012c7:	56                   	push   %esi
  8012c8:	53                   	push   %ebx
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cf:	b8 12 00 00 00       	mov    $0x12,%eax
  8012d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8012d9:	89 f9                	mov    %edi,%ecx
  8012db:	89 fb                	mov    %edi,%ebx
  8012dd:	89 fe                	mov    %edi,%esi
  8012df:	cd 30                	int    $0x30
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	7e 17                	jle    8012fc <sys_receive_packet_zerocopy+0x39>
  8012e5:	83 ec 0c             	sub    $0xc,%esp
  8012e8:	50                   	push   %eax
  8012e9:	6a 12                	push   $0x12
  8012eb:	68 b0 36 80 00       	push   $0x8036b0
  8012f0:	6a 23                	push   $0x23
  8012f2:	68 cd 36 80 00       	push   $0x8036cd
  8012f7:	e8 2c f2 ff ff       	call   800528 <_panic>
	return syscall(SYS_receive_packet_zerocopy, 1, (uint32_t) packetidx, 0, 0, 0, 0);
}
  8012fc:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8012ff:	5b                   	pop    %ebx
  801300:	5e                   	pop    %esi
  801301:	5f                   	pop    %edi
  801302:	c9                   	leave  
  801303:	c3                   	ret    

00801304 <sys_env_set_priority>:

// Lab 4: Challenge
int
sys_env_set_priority(envid_t envid, int priority)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	57                   	push   %edi
  801308:	56                   	push   %esi
  801309:	53                   	push   %ebx
  80130a:	83 ec 0c             	sub    $0xc,%esp
  80130d:	8b 55 08             	mov    0x8(%ebp),%edx
  801310:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801313:	b8 13 00 00 00       	mov    $0x13,%eax
  801318:	bf 00 00 00 00       	mov    $0x0,%edi
  80131d:	89 fb                	mov    %edi,%ebx
  80131f:	89 fe                	mov    %edi,%esi
  801321:	cd 30                	int    $0x30
  801323:	85 c0                	test   %eax,%eax
  801325:	7e 17                	jle    80133e <sys_env_set_priority+0x3a>
  801327:	83 ec 0c             	sub    $0xc,%esp
  80132a:	50                   	push   %eax
  80132b:	6a 13                	push   $0x13
  80132d:	68 b0 36 80 00       	push   $0x8036b0
  801332:	6a 23                	push   $0x23
  801334:	68 cd 36 80 00       	push   $0x8036cd
  801339:	e8 ea f1 ff ff       	call   800528 <_panic>
	return syscall(SYS_env_set_priority, 1, envid, priority, 0, 0, 0);
}
  80133e:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801341:	5b                   	pop    %ebx
  801342:	5e                   	pop    %esi
  801343:	5f                   	pop    %edi
  801344:	c9                   	leave  
  801345:	c3                   	ret    
	...

00801348 <pgfault>:
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	53                   	push   %ebx
  80134c:	83 ec 04             	sub    $0x4,%esp
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801352:	8b 18                	mov    (%eax),%ebx
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
  801354:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801358:	74 11                	je     80136b <pgfault+0x23>
  80135a:	89 d8                	mov    %ebx,%eax
  80135c:	c1 e8 0c             	shr    $0xc,%eax
  80135f:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801366:	f6 c4 08             	test   $0x8,%ah
  801369:	75 14                	jne    80137f <pgfault+0x37>
          panic("pgfault, err != FEC_WR or not copy-on-write page");
  80136b:	83 ec 04             	sub    $0x4,%esp
  80136e:	68 dc 36 80 00       	push   $0x8036dc
  801373:	6a 1e                	push   $0x1e
  801375:	68 30 37 80 00       	push   $0x803730
  80137a:	e8 a9 f1 ff ff       	call   800528 <_panic>
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
  80137f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	// Allocate a new page, map it at a temporary location (PFTEMP),
        if ((r = sys_page_alloc(sys_getenvid(), (void *)PFTEMP, PTE_U | PTE_W | PTE_P)) < 0) {
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	6a 07                	push   $0x7
  80138a:	68 00 f0 7f 00       	push   $0x7ff000
  80138f:	83 ec 04             	sub    $0x4,%esp
  801392:	e8 19 fc ff ff       	call   800fb0 <sys_getenvid>
  801397:	89 04 24             	mov    %eax,(%esp)
  80139a:	e8 4f fc ff ff       	call   800fee <sys_page_alloc>
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	79 12                	jns    8013b8 <pgfault+0x70>
          panic("pgfault: sys_page_alloc %d", r);
  8013a6:	50                   	push   %eax
  8013a7:	68 3b 37 80 00       	push   $0x80373b
  8013ac:	6a 2d                	push   $0x2d
  8013ae:	68 30 37 80 00       	push   $0x803730
  8013b3:	e8 70 f1 ff ff       	call   800528 <_panic>
        }
	// copy the data from the old page to the new page
        memmove(PFTEMP, addr, PGSIZE);
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	68 00 10 00 00       	push   $0x1000
  8013c0:	53                   	push   %ebx
  8013c1:	68 00 f0 7f 00       	push   $0x7ff000
  8013c6:	e8 cd f9 ff ff       	call   800d98 <memmove>
	// move the new page to the old page's address.
        if ((r = sys_page_map(sys_getenvid(), PFTEMP, sys_getenvid(), addr, PTE_U | PTE_W | PTE_P)) < 0) {
  8013cb:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8013d2:	53                   	push   %ebx
  8013d3:	83 ec 0c             	sub    $0xc,%esp
  8013d6:	e8 d5 fb ff ff       	call   800fb0 <sys_getenvid>
  8013db:	83 c4 0c             	add    $0xc,%esp
  8013de:	50                   	push   %eax
  8013df:	68 00 f0 7f 00       	push   $0x7ff000
  8013e4:	83 ec 04             	sub    $0x4,%esp
  8013e7:	e8 c4 fb ff ff       	call   800fb0 <sys_getenvid>
  8013ec:	89 04 24             	mov    %eax,(%esp)
  8013ef:	e8 3d fc ff ff       	call   801031 <sys_page_map>
  8013f4:	83 c4 20             	add    $0x20,%esp
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	79 12                	jns    80140d <pgfault+0xc5>
          panic("pgfault: sys_page_map %d", r);
  8013fb:	50                   	push   %eax
  8013fc:	68 56 37 80 00       	push   $0x803756
  801401:	6a 33                	push   $0x33
  801403:	68 30 37 80 00       	push   $0x803730
  801408:	e8 1b f1 ff ff       	call   800528 <_panic>
        }
        if ((r = sys_page_unmap(sys_getenvid(), PFTEMP)) < 0) {
  80140d:	83 ec 08             	sub    $0x8,%esp
  801410:	68 00 f0 7f 00       	push   $0x7ff000
  801415:	83 ec 04             	sub    $0x4,%esp
  801418:	e8 93 fb ff ff       	call   800fb0 <sys_getenvid>
  80141d:	89 04 24             	mov    %eax,(%esp)
  801420:	e8 4e fc ff ff       	call   801073 <sys_page_unmap>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	85 c0                	test   %eax,%eax
  80142a:	79 12                	jns    80143e <pgfault+0xf6>
          panic("pgfault: sys_page_unmap %d", r);
  80142c:	50                   	push   %eax
  80142d:	68 6f 37 80 00       	push   $0x80376f
  801432:	6a 36                	push   $0x36
  801434:	68 30 37 80 00       	push   $0x803730
  801439:	e8 ea f0 ff ff       	call   800528 <_panic>
        }

	//panic("pgfault not implemented");
}
  80143e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <duppage>:

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
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	53                   	push   %ebx
  801447:	83 ec 04             	sub    $0x4,%esp
  80144a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80144d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	// LAB 4: Your code here.
        // seanyliu

        // LAB 7: add in a new if check
        if (vpt[pn] & PTE_SHARE) {
  801450:	ba 00 00 40 ef       	mov    $0xef400000,%edx
  801455:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801458:	f6 c4 04             	test   $0x4,%ah
  80145b:	74 36                	je     801493 <duppage+0x50>
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn * PGSIZE), envid, (void *)(pn * PGSIZE), vpt[pn] & PTE_USER)) < 0) {
  80145d:	83 ec 0c             	sub    $0xc,%esp
  801460:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  801463:	25 07 0e 00 00       	and    $0xe07,%eax
  801468:	50                   	push   %eax
  801469:	89 d8                	mov    %ebx,%eax
  80146b:	c1 e0 0c             	shl    $0xc,%eax
  80146e:	50                   	push   %eax
  80146f:	51                   	push   %ecx
  801470:	50                   	push   %eax
  801471:	83 ec 04             	sub    $0x4,%esp
  801474:	e8 37 fb ff ff       	call   800fb0 <sys_getenvid>
  801479:	89 04 24             	mov    %eax,(%esp)
  80147c:	e8 b0 fb ff ff       	call   801031 <sys_page_map>
  801481:	83 c4 20             	add    $0x20,%esp
            return r;
  801484:	89 c2                	mov    %eax,%edx
  801486:	85 c0                	test   %eax,%eax
  801488:	0f 88 c9 00 00 00    	js     801557 <duppage+0x114>
  80148e:	e9 bf 00 00 00       	jmp    801552 <duppage+0x10f>
          }
        } else if (vpt[pn] & (PTE_W | PTE_COW)) {
  801493:	8b 04 9d 00 00 40 ef 	mov    0xef400000(,%ebx,4),%eax
  80149a:	a9 02 08 00 00       	test   $0x802,%eax
  80149f:	74 7b                	je     80151c <duppage+0xd9>
          // If the page is writable or copy-on-write, the new mapping must be created copy-on-write
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  8014a1:	83 ec 0c             	sub    $0xc,%esp
  8014a4:	68 05 08 00 00       	push   $0x805
  8014a9:	89 d8                	mov    %ebx,%eax
  8014ab:	c1 e0 0c             	shl    $0xc,%eax
  8014ae:	50                   	push   %eax
  8014af:	51                   	push   %ecx
  8014b0:	50                   	push   %eax
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	e8 f7 fa ff ff       	call   800fb0 <sys_getenvid>
  8014b9:	89 04 24             	mov    %eax,(%esp)
  8014bc:	e8 70 fb ff ff       	call   801031 <sys_page_map>
  8014c1:	83 c4 20             	add    $0x20,%esp
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	79 12                	jns    8014da <duppage+0x97>
            panic("duppage: sys_page_map %d", r);
  8014c8:	50                   	push   %eax
  8014c9:	68 8a 37 80 00       	push   $0x80378a
  8014ce:	6a 56                	push   $0x56
  8014d0:	68 30 37 80 00       	push   $0x803730
  8014d5:	e8 4e f0 ff ff       	call   800528 <_panic>
          }
          // and then our mapping must be marked copy-on-write as well
          //vpt[pn] = vpt[pn] | PTE_COW;
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), sys_getenvid(), (void *)(pn*PGSIZE), PTE_U | PTE_COW | PTE_P)) < 0) {
  8014da:	83 ec 0c             	sub    $0xc,%esp
  8014dd:	68 05 08 00 00       	push   $0x805
  8014e2:	c1 e3 0c             	shl    $0xc,%ebx
  8014e5:	53                   	push   %ebx
  8014e6:	83 ec 0c             	sub    $0xc,%esp
  8014e9:	e8 c2 fa ff ff       	call   800fb0 <sys_getenvid>
  8014ee:	83 c4 0c             	add    $0xc,%esp
  8014f1:	50                   	push   %eax
  8014f2:	53                   	push   %ebx
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	e8 b5 fa ff ff       	call   800fb0 <sys_getenvid>
  8014fb:	89 04 24             	mov    %eax,(%esp)
  8014fe:	e8 2e fb ff ff       	call   801031 <sys_page_map>
  801503:	83 c4 20             	add    $0x20,%esp
  801506:	85 c0                	test   %eax,%eax
  801508:	79 48                	jns    801552 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  80150a:	50                   	push   %eax
  80150b:	68 8a 37 80 00       	push   $0x80378a
  801510:	6a 5b                	push   $0x5b
  801512:	68 30 37 80 00       	push   $0x803730
  801517:	e8 0c f0 ff ff       	call   800528 <_panic>
          }
        } else {
          if ((r = sys_page_map(sys_getenvid(), (void *)(pn*PGSIZE), envid, (void *)(pn*PGSIZE), PTE_U | PTE_P)) < 0) {
  80151c:	83 ec 0c             	sub    $0xc,%esp
  80151f:	6a 05                	push   $0x5
  801521:	89 d8                	mov    %ebx,%eax
  801523:	c1 e0 0c             	shl    $0xc,%eax
  801526:	50                   	push   %eax
  801527:	51                   	push   %ecx
  801528:	50                   	push   %eax
  801529:	83 ec 04             	sub    $0x4,%esp
  80152c:	e8 7f fa ff ff       	call   800fb0 <sys_getenvid>
  801531:	89 04 24             	mov    %eax,(%esp)
  801534:	e8 f8 fa ff ff       	call   801031 <sys_page_map>
  801539:	83 c4 20             	add    $0x20,%esp
  80153c:	85 c0                	test   %eax,%eax
  80153e:	79 12                	jns    801552 <duppage+0x10f>
            panic("duppage: sys_page_map %d", r);
  801540:	50                   	push   %eax
  801541:	68 8a 37 80 00       	push   $0x80378a
  801546:	6a 5f                	push   $0x5f
  801548:	68 30 37 80 00       	push   $0x803730
  80154d:	e8 d6 ef ff ff       	call   800528 <_panic>
          }
        }
	//panic("duppage not implemented");
	return 0;
  801552:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801557:	89 d0                	mov    %edx,%eax
  801559:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <fork>:

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
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	57                   	push   %edi
  801562:	56                   	push   %esi
  801563:	53                   	push   %ebx
  801564:	83 ec 18             	sub    $0x18,%esp
	// LAB 4: Your code here.
        // seanyliu
        int r;
        int pdidx = 0;
        int peidx = 0;
        envid_t childid;
        set_pgfault_handler(pgfault);
  801567:	68 48 13 80 00       	push   $0x801348
  80156c:	e8 33 17 00 00       	call   802ca4 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
  801571:	83 c4 10             	add    $0x10,%esp
	envid_t ret;
	__asm __volatile("int %2"
  801574:	ba 07 00 00 00       	mov    $0x7,%edx
  801579:	89 d0                	mov    %edx,%eax
  80157b:	cd 30                	int    $0x30
  80157d:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)

        // create child environment
        childid = sys_exofork();
        if (childid < 0) {
  801580:	85 c0                	test   %eax,%eax
  801582:	79 15                	jns    801599 <fork+0x3b>
          panic("fork: failed to create child %d", childid);
  801584:	50                   	push   %eax
  801585:	68 10 37 80 00       	push   $0x803710
  80158a:	68 85 00 00 00       	push   $0x85
  80158f:	68 30 37 80 00       	push   $0x803730
  801594:	e8 8f ef ff ff       	call   800528 <_panic>
        }
        if (childid == 0) {
          env = &envs[ENVX(sys_getenvid())];
          return 0;
        }

        // loop through pg dir, avoid user exception stack (which is immediately below UTOP
        for (pdidx = 0; pdidx < PDX(UTOP); pdidx++) {
  801599:	bf 00 00 00 00       	mov    $0x0,%edi
  80159e:	83 7d f0 00          	cmpl   $0x0,0xfffffff0(%ebp)
  8015a2:	75 21                	jne    8015c5 <fork+0x67>
  8015a4:	e8 07 fa ff ff       	call   800fb0 <sys_getenvid>
  8015a9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015ae:	c1 e0 07             	shl    $0x7,%eax
  8015b1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015b6:	a3 80 70 80 00       	mov    %eax,0x807080
  8015bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c0:	e9 fd 00 00 00       	jmp    8016c2 <fork+0x164>
          // check if the pg is present
          if (!(vpd[pdidx] & PTE_P)) continue;
  8015c5:	8b 04 bd 00 d0 7b ef 	mov    0xef7bd000(,%edi,4),%eax
  8015cc:	a8 01                	test   $0x1,%al
  8015ce:	74 5f                	je     80162f <fork+0xd1>

          // loop through pg table entries
          for (peidx = 0; (peidx < NPTENTRIES) && (pdidx*NPDENTRIES+peidx < (UXSTACKTOP - PGSIZE)/PGSIZE); peidx++) {
  8015d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d5:	89 f8                	mov    %edi,%eax
  8015d7:	c1 e0 0a             	shl    $0xa,%eax
  8015da:	89 c2                	mov    %eax,%edx
  8015dc:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  8015e1:	77 4c                	ja     80162f <fork+0xd1>
  8015e3:	89 c6                	mov    %eax,%esi
            if (vpt[pdidx * NPTENTRIES + peidx] & PTE_P) {
  8015e5:	01 da                	add    %ebx,%edx
  8015e7:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  8015ee:	a8 01                	test   $0x1,%al
  8015f0:	74 28                	je     80161a <fork+0xbc>
              if ((r = duppage(childid, pdidx * NPTENTRIES + peidx)) < 0) {
  8015f2:	83 ec 08             	sub    $0x8,%esp
  8015f5:	52                   	push   %edx
  8015f6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8015f9:	e8 45 fe ff ff       	call   801443 <duppage>
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	85 c0                	test   %eax,%eax
  801603:	79 15                	jns    80161a <fork+0xbc>
                panic("fork: duppage failed: %d", r);
  801605:	50                   	push   %eax
  801606:	68 a3 37 80 00       	push   $0x8037a3
  80160b:	68 95 00 00 00       	push   $0x95
  801610:	68 30 37 80 00       	push   $0x803730
  801615:	e8 0e ef ff ff       	call   800528 <_panic>
  80161a:	43                   	inc    %ebx
  80161b:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  801621:	7f 0c                	jg     80162f <fork+0xd1>
  801623:	89 f2                	mov    %esi,%edx
  801625:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801628:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  80162d:	76 b6                	jbe    8015e5 <fork+0x87>
  80162f:	47                   	inc    %edi
  801630:	81 ff ba 03 00 00    	cmp    $0x3ba,%edi
  801636:	76 8d                	jbe    8015c5 <fork+0x67>
              }
            }
          }
        }

        // allocate fresh page in the child for exception stack.
        if ((r = sys_page_alloc(childid, (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801638:	83 ec 04             	sub    $0x4,%esp
  80163b:	6a 07                	push   $0x7
  80163d:	68 00 f0 bf ee       	push   $0xeebff000
  801642:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801645:	e8 a4 f9 ff ff       	call   800fee <sys_page_alloc>
  80164a:	83 c4 10             	add    $0x10,%esp
  80164d:	85 c0                	test   %eax,%eax
  80164f:	79 15                	jns    801666 <fork+0x108>
          panic("fork: %d", r);
  801651:	50                   	push   %eax
  801652:	68 bc 37 80 00       	push   $0x8037bc
  801657:	68 9d 00 00 00       	push   $0x9d
  80165c:	68 30 37 80 00       	push   $0x803730
  801661:	e8 c2 ee ff ff       	call   800528 <_panic>
        }

        // parent sets the user page fault entrypoint for the child to look like its own.
        if ((r = sys_env_set_pgfault_upcall(childid, env->env_pgfault_upcall)) < 0) {
  801666:	83 ec 08             	sub    $0x8,%esp
  801669:	a1 80 70 80 00       	mov    0x807080,%eax
  80166e:	8b 40 64             	mov    0x64(%eax),%eax
  801671:	50                   	push   %eax
  801672:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  801675:	e8 bf fa ff ff       	call   801139 <sys_env_set_pgfault_upcall>
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	85 c0                	test   %eax,%eax
  80167f:	79 15                	jns    801696 <fork+0x138>
          panic("fork: %d", r);
  801681:	50                   	push   %eax
  801682:	68 bc 37 80 00       	push   $0x8037bc
  801687:	68 a2 00 00 00       	push   $0xa2
  80168c:	68 30 37 80 00       	push   $0x803730
  801691:	e8 92 ee ff ff       	call   800528 <_panic>
        }

        // parent marks child runnable
        if ((r = sys_env_set_status(childid, ENV_RUNNABLE)) < 0) {
  801696:	83 ec 08             	sub    $0x8,%esp
  801699:	6a 01                	push   $0x1
  80169b:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80169e:	e8 12 fa ff ff       	call   8010b5 <sys_env_set_status>
  8016a3:	83 c4 10             	add    $0x10,%esp
          panic("fork: %d", r);
        }

        return childid;       
  8016a6:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	79 15                	jns    8016c2 <fork+0x164>
  8016ad:	50                   	push   %eax
  8016ae:	68 bc 37 80 00       	push   $0x8037bc
  8016b3:	68 a7 00 00 00       	push   $0xa7
  8016b8:	68 30 37 80 00       	push   $0x803730
  8016bd:	e8 66 ee ff ff       	call   800528 <_panic>
 
	//panic("fork not implemented");
}
  8016c2:	89 d0                	mov    %edx,%eax
  8016c4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8016c7:	5b                   	pop    %ebx
  8016c8:	5e                   	pop    %esi
  8016c9:	5f                   	pop    %edi
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <sfork>:



// Challenge!
int
sfork(void)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8016d2:	68 c5 37 80 00       	push   $0x8037c5
  8016d7:	68 b5 00 00 00       	push   $0xb5
  8016dc:	68 30 37 80 00       	push   $0x803730
  8016e1:	e8 42 ee ff ff       	call   800528 <_panic>
	...

008016e8 <fd2data>:
 ********************************/

char*
fd2data(struct Fd *fd)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 14             	sub    $0x14,%esp
	return INDEX2DATA(fd2num(fd));
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 0a 00 00 00       	call   801700 <fd2num>
  8016f6:	c1 e0 16             	shl    $0x16,%eax
  8016f9:	2d 00 00 00 30       	sub    $0x30000000,%eax
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <fd2num>:

int
fd2num(struct Fd *fd)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	05 00 00 40 30       	add    $0x30400000,%eax
  80170b:	c1 e8 0c             	shr    $0xc,%eax
}
  80170e:	c9                   	leave  
  80170f:	c3                   	ret    

00801710 <fd_alloc>:

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
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	57                   	push   %edi
  801714:	56                   	push   %esi
  801715:	53                   	push   %ebx
  801716:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801719:	b9 00 00 00 00       	mov    $0x0,%ecx
  80171e:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
  801723:	bb 00 00 40 ef       	mov    $0xef400000,%ebx
		fd = INDEX2FD(i);
  801728:	89 c8                	mov    %ecx,%eax
  80172a:	c1 e0 0c             	shl    $0xc,%eax
  80172d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801733:	89 d0                	mov    %edx,%eax
  801735:	c1 e8 16             	shr    $0x16,%eax
  801738:	8b 04 86             	mov    (%esi,%eax,4),%eax
  80173b:	a8 01                	test   $0x1,%al
  80173d:	74 0c                	je     80174b <fd_alloc+0x3b>
  80173f:	89 d0                	mov    %edx,%eax
  801741:	c1 e8 0c             	shr    $0xc,%eax
  801744:	8b 04 83             	mov    (%ebx,%eax,4),%eax
  801747:	a8 01                	test   $0x1,%al
  801749:	75 09                	jne    801754 <fd_alloc+0x44>
			*fd_store = fd;
  80174b:	89 17                	mov    %edx,(%edi)
			return 0;
  80174d:	b8 00 00 00 00       	mov    $0x0,%eax
  801752:	eb 11                	jmp    801765 <fd_alloc+0x55>
  801754:	41                   	inc    %ecx
  801755:	83 f9 1f             	cmp    $0x1f,%ecx
  801758:	7e ce                	jle    801728 <fd_alloc+0x18>
		}
	}
	*fd_store = 0;
  80175a:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
	return -E_MAX_OPEN;
  801760:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801765:	5b                   	pop    %ebx
  801766:	5e                   	pop    %esi
  801767:	5f                   	pop    %edi
  801768:	c9                   	leave  
  801769:	c3                   	ret    

0080176a <fd_lookup>:

// Check that fdnum is in range and mapped.
// If it is, set *fd_store to the fd page virtual address.
//
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
  801770:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801775:	83 f8 1f             	cmp    $0x1f,%eax
  801778:	77 3a                	ja     8017b4 <fd_lookup+0x4a>
	}
	fd = INDEX2FD(fdnum);
  80177a:	c1 e0 0c             	shl    $0xc,%eax
  80177d:	8d 90 00 00 c0 cf    	lea    0xcfc00000(%eax),%edx
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801783:	89 d0                	mov    %edx,%eax
  801785:	c1 e8 16             	shr    $0x16,%eax
  801788:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  80178f:	a8 01                	test   $0x1,%al
  801791:	74 10                	je     8017a3 <fd_lookup+0x39>
  801793:	89 d0                	mov    %edx,%eax
  801795:	c1 e8 0c             	shr    $0xc,%eax
  801798:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80179f:	a8 01                	test   $0x1,%al
  8017a1:	75 07                	jne    8017aa <fd_lookup+0x40>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
  8017a3:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  8017a8:	eb 0a                	jmp    8017b4 <fd_lookup+0x4a>
	}
	*fd_store = fd;
  8017aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ad:	89 10                	mov    %edx,(%eax)
	return 0;
  8017af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8017b4:	89 d0                	mov    %edx,%eax
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <fd_close>:

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
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	56                   	push   %esi
  8017bc:	53                   	push   %ebx
  8017bd:	83 ec 10             	sub    $0x10,%esp
  8017c0:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017c3:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  8017c6:	50                   	push   %eax
  8017c7:	56                   	push   %esi
  8017c8:	e8 33 ff ff ff       	call   801700 <fd2num>
  8017cd:	89 04 24             	mov    %eax,(%esp)
  8017d0:	e8 95 ff ff ff       	call   80176a <fd_lookup>
  8017d5:	89 c3                	mov    %eax,%ebx
  8017d7:	83 c4 08             	add    $0x8,%esp
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	78 05                	js     8017e3 <fd_close+0x2b>
  8017de:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  8017e1:	74 0f                	je     8017f2 <fd_close+0x3a>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8017e3:	89 d8                	mov    %ebx,%eax
  8017e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017e9:	75 3a                	jne    801825 <fd_close+0x6d>
  8017eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f0:	eb 33                	jmp    801825 <fd_close+0x6d>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0)
  8017f2:	83 ec 08             	sub    $0x8,%esp
  8017f5:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8017f8:	50                   	push   %eax
  8017f9:	ff 36                	pushl  (%esi)
  8017fb:	e8 2c 00 00 00       	call   80182c <dev_lookup>
  801800:	89 c3                	mov    %eax,%ebx
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	85 c0                	test   %eax,%eax
  801807:	78 0f                	js     801818 <fd_close+0x60>
		r = (*dev->dev_close)(fd);
  801809:	83 ec 0c             	sub    $0xc,%esp
  80180c:	56                   	push   %esi
  80180d:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  801810:	ff 50 10             	call   *0x10(%eax)
  801813:	89 c3                	mov    %eax,%ebx
  801815:	83 c4 10             	add    $0x10,%esp
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801818:	83 ec 08             	sub    $0x8,%esp
  80181b:	56                   	push   %esi
  80181c:	6a 00                	push   $0x0
  80181e:	e8 50 f8 ff ff       	call   801073 <sys_page_unmap>
	return r;
  801823:	89 d8                	mov    %ebx,%eax
}
  801825:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801828:	5b                   	pop    %ebx
  801829:	5e                   	pop    %esi
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <dev_lookup>:


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
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	56                   	push   %esi
  801830:	53                   	push   %ebx
  801831:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801834:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i;
	for (i = 0; devtab[i]; i++)
  801837:	ba 00 00 00 00       	mov    $0x0,%edx
  80183c:	83 3d 24 70 80 00 00 	cmpl   $0x0,0x807024
  801843:	74 1c                	je     801861 <dev_lookup+0x35>
  801845:	b9 24 70 80 00       	mov    $0x807024,%ecx
		if (devtab[i]->dev_id == dev_id) {
  80184a:	8b 04 91             	mov    (%ecx,%edx,4),%eax
  80184d:	39 18                	cmp    %ebx,(%eax)
  80184f:	75 09                	jne    80185a <dev_lookup+0x2e>
			*dev = devtab[i];
  801851:	89 06                	mov    %eax,(%esi)
			return 0;
  801853:	b8 00 00 00 00       	mov    $0x0,%eax
  801858:	eb 29                	jmp    801883 <dev_lookup+0x57>
  80185a:	42                   	inc    %edx
  80185b:	83 3c 91 00          	cmpl   $0x0,(%ecx,%edx,4)
  80185f:	75 e9                	jne    80184a <dev_lookup+0x1e>
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801861:	83 ec 04             	sub    $0x4,%esp
  801864:	53                   	push   %ebx
  801865:	a1 80 70 80 00       	mov    0x807080,%eax
  80186a:	8b 40 4c             	mov    0x4c(%eax),%eax
  80186d:	50                   	push   %eax
  80186e:	68 dc 37 80 00       	push   $0x8037dc
  801873:	e8 a0 ed ff ff       	call   800618 <cprintf>
	*dev = 0;
  801878:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	return -E_INVAL;
  80187e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801883:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801886:	5b                   	pop    %ebx
  801887:	5e                   	pop    %esi
  801888:	c9                   	leave  
  801889:	c3                   	ret    

0080188a <close>:

int
close(int fdnum)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	83 ec 08             	sub    $0x8,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801890:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801893:	50                   	push   %eax
  801894:	ff 75 08             	pushl  0x8(%ebp)
  801897:	e8 ce fe ff ff       	call   80176a <fd_lookup>
  80189c:	83 c4 08             	add    $0x8,%esp
		return r;
  80189f:	89 c2                	mov    %eax,%edx
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	78 0f                	js     8018b4 <close+0x2a>
	else
		return fd_close(fd, 1);
  8018a5:	83 ec 08             	sub    $0x8,%esp
  8018a8:	6a 01                	push   $0x1
  8018aa:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  8018ad:	e8 06 ff ff ff       	call   8017b8 <fd_close>
  8018b2:	89 c2                	mov    %eax,%edx
}
  8018b4:	89 d0                	mov    %edx,%eax
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <close_all>:

void
close_all(void)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8018bf:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8018c4:	83 ec 0c             	sub    $0xc,%esp
  8018c7:	53                   	push   %ebx
  8018c8:	e8 bd ff ff ff       	call   80188a <close>
  8018cd:	83 c4 10             	add    $0x10,%esp
  8018d0:	43                   	inc    %ebx
  8018d1:	83 fb 1f             	cmp    $0x1f,%ebx
  8018d4:	7e ee                	jle    8018c4 <close_all+0xc>
}
  8018d6:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <dup>:

// Make file descriptor 'newfdnum' a duplicate of file descriptor 'oldfdnum'.
// For instance, writing onto either file descriptor will affect the
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	57                   	push   %edi
  8018df:	56                   	push   %esi
  8018e0:	53                   	push   %ebx
  8018e1:	83 ec 0c             	sub    $0xc,%esp
	int i, r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8018e4:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8018e7:	50                   	push   %eax
  8018e8:	ff 75 08             	pushl  0x8(%ebp)
  8018eb:	e8 7a fe ff ff       	call   80176a <fd_lookup>
  8018f0:	89 c6                	mov    %eax,%esi
  8018f2:	83 c4 08             	add    $0x8,%esp
  8018f5:	85 f6                	test   %esi,%esi
  8018f7:	0f 88 f8 00 00 00    	js     8019f5 <dup+0x11a>
		return r;
	close(newfdnum);
  8018fd:	83 ec 0c             	sub    $0xc,%esp
  801900:	ff 75 0c             	pushl  0xc(%ebp)
  801903:	e8 82 ff ff ff       	call   80188a <close>

	newfd = INDEX2FD(newfdnum);
  801908:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190b:	c1 e0 0c             	shl    $0xc,%eax
  80190e:	2d 00 00 40 30       	sub    $0x30400000,%eax
  801913:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
	ova = fd2data(oldfd);
  801916:	83 c4 04             	add    $0x4,%esp
  801919:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80191c:	e8 c7 fd ff ff       	call   8016e8 <fd2data>
  801921:	89 c7                	mov    %eax,%edi
	nva = fd2data(newfd);
  801923:	83 c4 04             	add    $0x4,%esp
  801926:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  801929:	e8 ba fd ff ff       	call   8016e8 <fd2data>
  80192e:	89 45 ec             	mov    %eax,0xffffffec(%ebp)

	if (vpd[PDX(ova)]) {
  801931:	89 f8                	mov    %edi,%eax
  801933:	c1 e8 16             	shr    $0x16,%eax
  801936:	83 c4 10             	add    $0x10,%esp
  801939:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801940:	85 c0                	test   %eax,%eax
  801942:	74 48                	je     80198c <dup+0xb1>
		for (i = 0; i < PTSIZE; i += PGSIZE) {
  801944:	bb 00 00 00 00       	mov    $0x0,%ebx
			pte = vpt[VPN(ova + i)];
  801949:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
  80194c:	89 d0                	mov    %edx,%eax
  80194e:	c1 e8 0c             	shr    $0xc,%eax
  801951:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
			if (pte&PTE_P) {
  801958:	a8 01                	test   $0x1,%al
  80195a:	74 22                	je     80197e <dup+0xa3>
				// should be no error here -- pd is already allocated
				if ((r = sys_page_map(0, ova + i, 0, nva + i, pte & PTE_USER)) < 0)
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	25 07 0e 00 00       	and    $0xe07,%eax
  801964:	50                   	push   %eax
  801965:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  801968:	01 d8                	add    %ebx,%eax
  80196a:	50                   	push   %eax
  80196b:	6a 00                	push   $0x0
  80196d:	52                   	push   %edx
  80196e:	6a 00                	push   $0x0
  801970:	e8 bc f6 ff ff       	call   801031 <sys_page_map>
  801975:	89 c6                	mov    %eax,%esi
  801977:	83 c4 20             	add    $0x20,%esp
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 3f                	js     8019bd <dup+0xe2>
  80197e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801984:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  80198a:	7e bd                	jle    801949 <dup+0x6e>
					goto err;
			}
		}
	}
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  80198c:	83 ec 0c             	sub    $0xc,%esp
  80198f:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  801992:	89 d0                	mov    %edx,%eax
  801994:	c1 e8 0c             	shr    $0xc,%eax
  801997:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  80199e:	25 07 0e 00 00       	and    $0xe07,%eax
  8019a3:	50                   	push   %eax
  8019a4:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8019a7:	6a 00                	push   $0x0
  8019a9:	52                   	push   %edx
  8019aa:	6a 00                	push   $0x0
  8019ac:	e8 80 f6 ff ff       	call   801031 <sys_page_map>
  8019b1:	89 c6                	mov    %eax,%esi
  8019b3:	83 c4 20             	add    $0x20,%esp
		goto err;

	return newfdnum;
  8019b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b9:	85 f6                	test   %esi,%esi
  8019bb:	79 38                	jns    8019f5 <dup+0x11a>

err:
	sys_page_unmap(0, newfd);
  8019bd:	83 ec 08             	sub    $0x8,%esp
  8019c0:	ff 75 e8             	pushl  0xffffffe8(%ebp)
  8019c3:	6a 00                	push   $0x0
  8019c5:	e8 a9 f6 ff ff       	call   801073 <sys_page_unmap>
	for (i = 0; i < PTSIZE; i += PGSIZE)
  8019ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019cf:	83 c4 10             	add    $0x10,%esp
		sys_page_unmap(0, nva + i);
  8019d2:	83 ec 08             	sub    $0x8,%esp
  8019d5:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8019d8:	01 d8                	add    %ebx,%eax
  8019da:	50                   	push   %eax
  8019db:	6a 00                	push   $0x0
  8019dd:	e8 91 f6 ff ff       	call   801073 <sys_page_unmap>
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8019eb:	81 fb ff ff 3f 00    	cmp    $0x3fffff,%ebx
  8019f1:	7e df                	jle    8019d2 <dup+0xf7>
	return r;
  8019f3:	89 f0                	mov    %esi,%eax
}
  8019f5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8019f8:	5b                   	pop    %ebx
  8019f9:	5e                   	pop    %esi
  8019fa:	5f                   	pop    %edi
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	53                   	push   %ebx
  801a01:	83 ec 14             	sub    $0x14,%esp
  801a04:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a07:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801a0a:	50                   	push   %eax
  801a0b:	53                   	push   %ebx
  801a0c:	e8 59 fd ff ff       	call   80176a <fd_lookup>
  801a11:	89 c2                	mov    %eax,%edx
  801a13:	83 c4 08             	add    $0x8,%esp
  801a16:	85 c0                	test   %eax,%eax
  801a18:	78 1a                	js     801a34 <read+0x37>
  801a1a:	83 ec 08             	sub    $0x8,%esp
  801a1d:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801a20:	50                   	push   %eax
  801a21:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801a24:	ff 30                	pushl  (%eax)
  801a26:	e8 01 fe ff ff       	call   80182c <dev_lookup>
  801a2b:	89 c2                	mov    %eax,%edx
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	85 c0                	test   %eax,%eax
  801a32:	79 04                	jns    801a38 <read+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801a34:	89 d0                	mov    %edx,%eax
  801a36:	eb 50                	jmp    801a88 <read+0x8b>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a38:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801a3b:	8b 40 08             	mov    0x8(%eax),%eax
  801a3e:	83 e0 03             	and    $0x3,%eax
  801a41:	83 f8 01             	cmp    $0x1,%eax
  801a44:	75 1e                	jne    801a64 <read+0x67>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801a46:	83 ec 04             	sub    $0x4,%esp
  801a49:	53                   	push   %ebx
  801a4a:	a1 80 70 80 00       	mov    0x807080,%eax
  801a4f:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a52:	50                   	push   %eax
  801a53:	68 1d 38 80 00       	push   $0x80381d
  801a58:	e8 bb eb ff ff       	call   800618 <cprintf>
		return -E_INVAL;
  801a5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a62:	eb 24                	jmp    801a88 <read+0x8b>
	}
	r = (*dev->dev_read)(fd, buf, n, fd->fd_offset);
  801a64:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801a67:	ff 70 04             	pushl  0x4(%eax)
  801a6a:	ff 75 10             	pushl  0x10(%ebp)
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	50                   	push   %eax
  801a71:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801a74:	ff 50 08             	call   *0x8(%eax)
  801a77:	89 c2                	mov    %eax,%edx
	if (r >= 0)
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	78 06                	js     801a86 <read+0x89>
		fd->fd_offset += r;
  801a80:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801a83:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801a86:	89 d0                	mov    %edx,%eax
}
  801a88:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	57                   	push   %edi
  801a91:	56                   	push   %esi
  801a92:	53                   	push   %ebx
  801a93:	83 ec 0c             	sub    $0xc,%esp
  801a96:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a99:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aa1:	39 f3                	cmp    %esi,%ebx
  801aa3:	73 25                	jae    801aca <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	89 f0                	mov    %esi,%eax
  801aaa:	29 d8                	sub    %ebx,%eax
  801aac:	50                   	push   %eax
  801aad:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  801ab0:	50                   	push   %eax
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	e8 44 ff ff ff       	call   8019fd <read>
		if (m < 0)
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 0c                	js     801acc <readn+0x3f>
			return m;
		if (m == 0)
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	74 06                	je     801aca <readn+0x3d>
  801ac4:	01 c3                	add    %eax,%ebx
  801ac6:	39 f3                	cmp    %esi,%ebx
  801ac8:	72 db                	jb     801aa5 <readn+0x18>
			break;
	}
	return tot;
  801aca:	89 d8                	mov    %ebx,%eax
}
  801acc:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801acf:	5b                   	pop    %ebx
  801ad0:	5e                   	pop    %esi
  801ad1:	5f                   	pop    %edi
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
  801ad7:	53                   	push   %ebx
  801ad8:	83 ec 14             	sub    $0x14,%esp
  801adb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ade:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801ae1:	50                   	push   %eax
  801ae2:	53                   	push   %ebx
  801ae3:	e8 82 fc ff ff       	call   80176a <fd_lookup>
  801ae8:	89 c2                	mov    %eax,%edx
  801aea:	83 c4 08             	add    $0x8,%esp
  801aed:	85 c0                	test   %eax,%eax
  801aef:	78 1a                	js     801b0b <write+0x37>
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801af7:	50                   	push   %eax
  801af8:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801afb:	ff 30                	pushl  (%eax)
  801afd:	e8 2a fd ff ff       	call   80182c <dev_lookup>
  801b02:	89 c2                	mov    %eax,%edx
  801b04:	83 c4 10             	add    $0x10,%esp
  801b07:	85 c0                	test   %eax,%eax
  801b09:	79 04                	jns    801b0f <write+0x3b>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
  801b0b:	89 d0                	mov    %edx,%eax
  801b0d:	eb 4b                	jmp    801b5a <write+0x86>
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b0f:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801b12:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b16:	75 1e                	jne    801b36 <write+0x62>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801b18:	83 ec 04             	sub    $0x4,%esp
  801b1b:	53                   	push   %ebx
  801b1c:	a1 80 70 80 00       	mov    0x807080,%eax
  801b21:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b24:	50                   	push   %eax
  801b25:	68 39 38 80 00       	push   $0x803839
  801b2a:	e8 e9 ea ff ff       	call   800618 <cprintf>
		return -E_INVAL;
  801b2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b34:	eb 24                	jmp    801b5a <write+0x86>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	r = (*dev->dev_write)(fd, buf, n, fd->fd_offset);
  801b36:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801b39:	ff 70 04             	pushl  0x4(%eax)
  801b3c:	ff 75 10             	pushl  0x10(%ebp)
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	50                   	push   %eax
  801b43:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801b46:	ff 50 0c             	call   *0xc(%eax)
  801b49:	89 c2                	mov    %eax,%edx
	if (r > 0)
  801b4b:	83 c4 10             	add    $0x10,%esp
  801b4e:	85 c0                	test   %eax,%eax
  801b50:	7e 06                	jle    801b58 <write+0x84>
		fd->fd_offset += r;
  801b52:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801b55:	01 50 04             	add    %edx,0x4(%eax)
	return r;
  801b58:	89 d0                	mov    %edx,%eax
}
  801b5a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <seek>:

int
seek(int fdnum, off_t offset)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 04             	sub    $0x4,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b65:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  801b68:	50                   	push   %eax
  801b69:	ff 75 08             	pushl  0x8(%ebp)
  801b6c:	e8 f9 fb ff ff       	call   80176a <fd_lookup>
  801b71:	83 c4 08             	add    $0x8,%esp
		return r;
  801b74:	89 c2                	mov    %eax,%edx
  801b76:	85 c0                	test   %eax,%eax
  801b78:	78 0e                	js     801b88 <seek+0x29>
	fd->fd_offset = offset;
  801b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7d:	8b 45 fc             	mov    0xfffffffc(%ebp),%eax
  801b80:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b83:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b88:	89 d0                	mov    %edx,%eax
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 14             	sub    $0x14,%esp
  801b93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b96:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801b99:	50                   	push   %eax
  801b9a:	53                   	push   %ebx
  801b9b:	e8 ca fb ff ff       	call   80176a <fd_lookup>
  801ba0:	83 c4 08             	add    $0x8,%esp
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	78 4e                	js     801bf5 <ftruncate+0x69>
  801ba7:	83 ec 08             	sub    $0x8,%esp
  801baa:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801bad:	50                   	push   %eax
  801bae:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801bb1:	ff 30                	pushl  (%eax)
  801bb3:	e8 74 fc ff ff       	call   80182c <dev_lookup>
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	85 c0                	test   %eax,%eax
  801bbd:	78 36                	js     801bf5 <ftruncate+0x69>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bbf:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801bc2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bc6:	75 1e                	jne    801be6 <ftruncate+0x5a>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bc8:	83 ec 04             	sub    $0x4,%esp
  801bcb:	53                   	push   %ebx
  801bcc:	a1 80 70 80 00       	mov    0x807080,%eax
  801bd1:	8b 40 4c             	mov    0x4c(%eax),%eax
  801bd4:	50                   	push   %eax
  801bd5:	68 fc 37 80 00       	push   $0x8037fc
  801bda:	e8 39 ea ff ff       	call   800618 <cprintf>
			env->env_id, fdnum); 
		return -E_INVAL;
  801bdf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801be4:	eb 0f                	jmp    801bf5 <ftruncate+0x69>
	}
	return (*dev->dev_trunc)(fd, newsize);
  801be6:	83 ec 08             	sub    $0x8,%esp
  801be9:	ff 75 0c             	pushl  0xc(%ebp)
  801bec:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801bef:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801bf2:	ff 50 1c             	call   *0x1c(%eax)
}
  801bf5:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 14             	sub    $0x14,%esp
  801c01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c04:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801c07:	50                   	push   %eax
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	e8 5a fb ff ff       	call   80176a <fd_lookup>
  801c10:	83 c4 08             	add    $0x8,%esp
  801c13:	85 c0                	test   %eax,%eax
  801c15:	78 42                	js     801c59 <fstat+0x5f>
  801c17:	83 ec 08             	sub    $0x8,%esp
  801c1a:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801c1d:	50                   	push   %eax
  801c1e:	8b 45 f8             	mov    0xfffffff8(%ebp),%eax
  801c21:	ff 30                	pushl  (%eax)
  801c23:	e8 04 fc ff ff       	call   80182c <dev_lookup>
  801c28:	83 c4 10             	add    $0x10,%esp
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	78 2a                	js     801c59 <fstat+0x5f>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	stat->st_name[0] = 0;
  801c2f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c32:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c39:	00 00 00 
	stat->st_isdir = 0;
  801c3c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c43:	00 00 00 
	stat->st_dev = dev;
  801c46:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801c49:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801c4f:	83 ec 08             	sub    $0x8,%esp
  801c52:	53                   	push   %ebx
  801c53:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801c56:	ff 50 14             	call   *0x14(%eax)
}
  801c59:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	56                   	push   %esi
  801c62:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c63:	83 ec 08             	sub    $0x8,%esp
  801c66:	6a 00                	push   $0x0
  801c68:	ff 75 08             	pushl  0x8(%ebp)
  801c6b:	e8 28 00 00 00       	call   801c98 <open>
  801c70:	89 c6                	mov    %eax,%esi
  801c72:	83 c4 10             	add    $0x10,%esp
  801c75:	85 f6                	test   %esi,%esi
  801c77:	78 18                	js     801c91 <stat+0x33>
		return fd;
	r = fstat(fd, stat);
  801c79:	83 ec 08             	sub    $0x8,%esp
  801c7c:	ff 75 0c             	pushl  0xc(%ebp)
  801c7f:	56                   	push   %esi
  801c80:	e8 75 ff ff ff       	call   801bfa <fstat>
  801c85:	89 c3                	mov    %eax,%ebx
	close(fd);
  801c87:	89 34 24             	mov    %esi,(%esp)
  801c8a:	e8 fb fb ff ff       	call   80188a <close>
	return r;
  801c8f:	89 d8                	mov    %ebx,%eax
}
  801c91:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801c94:	5b                   	pop    %ebx
  801c95:	5e                   	pop    %esi
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <open>:
// Open a file (or directory),
// returning the file descriptor index on success, < 0 on failure.
int
open(const char *path, int mode)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	53                   	push   %ebx
  801c9c:	83 ec 10             	sub    $0x10,%esp
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
  801c9f:	8d 45 f8             	lea    0xfffffff8(%ebp),%eax
  801ca2:	50                   	push   %eax
  801ca3:	e8 68 fa ff ff       	call   801710 <fd_alloc>
  801ca8:	89 c3                	mov    %eax,%ebx
  801caa:	83 c4 10             	add    $0x10,%esp
  801cad:	85 db                	test   %ebx,%ebx
  801caf:	78 36                	js     801ce7 <open+0x4f>
          return r;
        }
	// Do you need to allocate a page?  Look
        if ((r = fsipc_open(path, mode, fd_store)) < 0) {
  801cb1:	83 ec 04             	sub    $0x4,%esp
  801cb4:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	ff 75 08             	pushl  0x8(%ebp)
  801cbd:	e8 1b 05 00 00       	call   8021dd <fsipc_open>
  801cc2:	89 c3                	mov    %eax,%ebx
  801cc4:	83 c4 10             	add    $0x10,%esp
  801cc7:	85 c0                	test   %eax,%eax
  801cc9:	79 11                	jns    801cdc <open+0x44>
          fd_close(fd_store, 0);
  801ccb:	83 ec 08             	sub    $0x8,%esp
  801cce:	6a 00                	push   $0x0
  801cd0:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801cd3:	e8 e0 fa ff ff       	call   8017b8 <fd_close>
          return r;
  801cd8:	89 d8                	mov    %ebx,%eax
  801cda:	eb 0b                	jmp    801ce7 <open+0x4f>
        }
        // Challenge 5:
        /*
        if ((r = fmap(fd_store, 0, fd_store->fd_file.file.f_size)) < 0) {
          fd_close(fd_store, 0);
          return r;
        }
        */
        return fd2num(fd_store);
  801cdc:	83 ec 0c             	sub    $0xc,%esp
  801cdf:	ff 75 f8             	pushl  0xfffffff8(%ebp)
  801ce2:	e8 19 fa ff ff       	call   801700 <fd2num>
}
  801ce7:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <file_close>:

// Clean up a file-server file descriptor.
// This function is called by fd_close.
static int
file_close(struct Fd *fd)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	53                   	push   %ebx
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Unmap any data mapped for the file,
	// then tell the file server that we have closed the file
	// (to free up its resources).

	// LAB 5: Your code here.
	//panic("close() unimplemented!");
        int r;
        // should we set bool dirty to be 0 or 1?
        if ((r = funmap(fd, fd->fd_file.file.f_size, 0, 1)) < 0) {
  801cf6:	6a 01                	push   $0x1
  801cf8:	6a 00                	push   $0x0
  801cfa:	ff b3 90 00 00 00    	pushl  0x90(%ebx)
  801d00:	53                   	push   %ebx
  801d01:	e8 e7 03 00 00       	call   8020ed <funmap>
  801d06:	83 c4 10             	add    $0x10,%esp
          return r;
  801d09:	89 c2                	mov    %eax,%edx
  801d0b:	85 c0                	test   %eax,%eax
  801d0d:	78 19                	js     801d28 <file_close+0x3c>
        }
        if ((r = fsipc_close(fd->fd_file.id)) < 0) {
  801d0f:	83 ec 0c             	sub    $0xc,%esp
  801d12:	ff 73 0c             	pushl  0xc(%ebx)
  801d15:	e8 68 05 00 00       	call   802282 <fsipc_close>
  801d1a:	83 c4 10             	add    $0x10,%esp
          return r;
  801d1d:	89 c2                	mov    %eax,%edx
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	78 05                	js     801d28 <file_close+0x3c>
        }
        return 0;
  801d23:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801d28:	89 d0                	mov    %edx,%eax
  801d2a:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  801d2d:	c9                   	leave  
  801d2e:	c3                   	ret    

00801d2f <file_read>:

// Read 'n' bytes from 'fd' at the current seek position into 'buf'.
// Since files are memory-mapped, this amounts to a memmove()
// surrounded by a little red tape to handle the file size and seek pointer.
static ssize_t
file_read(struct Fd *fd, void *buf, size_t n, off_t offset)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	57                   	push   %edi
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	83 ec 0c             	sub    $0xc,%esp
  801d38:	8b 75 10             	mov    0x10(%ebp),%esi
  801d3b:	8b 7d 14             	mov    0x14(%ebp),%edi
	size_t size;

        // Challenge 5:
        int r;
        void* paddr;

	// avoid reading past the end of file
	size = fd->fd_file.file.f_size;
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
	if (offset > size)
		return 0;
  801d47:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d4c:	39 d7                	cmp    %edx,%edi
  801d4e:	0f 87 95 00 00 00    	ja     801de9 <file_read+0xba>
	if (offset + n > size)
  801d54:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801d57:	39 d0                	cmp    %edx,%eax
  801d59:	76 04                	jbe    801d5f <file_read+0x30>
		n = size - offset;
  801d5b:	89 d6                	mov    %edx,%esi
  801d5d:	29 fe                	sub    %edi,%esi

        // Challenge 5
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801d5f:	83 ec 0c             	sub    $0xc,%esp
  801d62:	ff 75 08             	pushl  0x8(%ebp)
  801d65:	e8 7e f9 ff ff       	call   8016e8 <fd2data>
  801d6a:	89 c3                	mov    %eax,%ebx
  801d6c:	01 fb                	add    %edi,%ebx
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	eb 41                	jmp    801db4 <file_read+0x85>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801d73:	89 d8                	mov    %ebx,%eax
  801d75:	c1 e8 16             	shr    $0x16,%eax
  801d78:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801d7f:	a8 01                	test   $0x1,%al
  801d81:	74 10                	je     801d93 <file_read+0x64>
  801d83:	89 d8                	mov    %ebx,%eax
  801d85:	c1 e8 0c             	shr    $0xc,%eax
  801d88:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801d8f:	a8 01                	test   $0x1,%al
  801d91:	75 1b                	jne    801dae <file_read+0x7f>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801d93:	83 ec 04             	sub    $0x4,%esp
  801d96:	8d 04 37             	lea    (%edi,%esi,1),%eax
  801d99:	50                   	push   %eax
  801d9a:	57                   	push   %edi
  801d9b:	ff 75 08             	pushl  0x8(%ebp)
  801d9e:	e8 d4 02 00 00       	call   802077 <fmap>
  801da3:	83 c4 10             	add    $0x10,%esp
              return r;
  801da6:	89 c1                	mov    %eax,%ecx
  801da8:	85 c0                	test   %eax,%eax
  801daa:	78 3d                	js     801de9 <file_read+0xba>
  801dac:	eb 1c                	jmp    801dca <file_read+0x9b>
  801dae:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801db4:	83 ec 0c             	sub    $0xc,%esp
  801db7:	ff 75 08             	pushl  0x8(%ebp)
  801dba:	e8 29 f9 ff ff       	call   8016e8 <fd2data>
  801dbf:	01 f8                	add    %edi,%eax
  801dc1:	01 f0                	add    %esi,%eax
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	39 d8                	cmp    %ebx,%eax
  801dc8:	77 a9                	ja     801d73 <file_read+0x44>
            }
            break;
          }
        }

	// read the data by copying from the file mapping
	memmove(buf, fd2data(fd) + offset, n);
  801dca:	83 ec 04             	sub    $0x4,%esp
  801dcd:	56                   	push   %esi
  801dce:	83 ec 04             	sub    $0x4,%esp
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	e8 0f f9 ff ff       	call   8016e8 <fd2data>
  801dd9:	83 c4 08             	add    $0x8,%esp
  801ddc:	01 f8                	add    %edi,%eax
  801dde:	50                   	push   %eax
  801ddf:	ff 75 0c             	pushl  0xc(%ebp)
  801de2:	e8 b1 ef ff ff       	call   800d98 <memmove>
	return n;
  801de7:	89 f1                	mov    %esi,%ecx
}
  801de9:	89 c8                	mov    %ecx,%eax
  801deb:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801dee:	5b                   	pop    %ebx
  801def:	5e                   	pop    %esi
  801df0:	5f                   	pop    %edi
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <read_map>:

// Find the page that maps the file block starting at 'offset',
// and store its address in '*blk'.
int
read_map(int fdnum, off_t offset, void **blk)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	56                   	push   %esi
  801df7:	53                   	push   %ebx
  801df8:	83 ec 18             	sub    $0x18,%esp
  801dfb:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r;
	char *va;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801dfe:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  801e01:	50                   	push   %eax
  801e02:	ff 75 08             	pushl  0x8(%ebp)
  801e05:	e8 60 f9 ff ff       	call   80176a <fd_lookup>
  801e0a:	83 c4 10             	add    $0x10,%esp
		return r;
  801e0d:	89 c2                	mov    %eax,%edx
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	0f 88 9f 00 00 00    	js     801eb6 <read_map+0xc3>
	if (fd->fd_dev_id != devfile.dev_id)
  801e17:	8b 45 f4             	mov    0xfffffff4(%ebp),%eax
  801e1a:	8b 00                	mov    (%eax),%eax
		return -E_INVAL;
  801e1c:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  801e21:	3b 05 40 70 80 00    	cmp    0x807040,%eax
  801e27:	0f 85 89 00 00 00    	jne    801eb6 <read_map+0xc3>
	va = fd2data(fd) + offset;
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801e33:	e8 b0 f8 ff ff       	call   8016e8 <fd2data>
  801e38:	89 c3                	mov    %eax,%ebx
  801e3a:	01 f3                	add    %esi,%ebx

	if (offset >= MAXFILESIZE)
  801e3c:	83 c4 10             	add    $0x10,%esp
		return -E_NO_DISK;
  801e3f:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801e44:	81 fe ff ff 3f 00    	cmp    $0x3fffff,%esi
  801e4a:	7f 6a                	jg     801eb6 <read_map+0xc3>

        // Challenge 5
	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P)) {
  801e4c:	89 d8                	mov    %ebx,%eax
  801e4e:	c1 e8 16             	shr    $0x16,%eax
  801e51:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801e58:	a8 01                	test   $0x1,%al
  801e5a:	74 10                	je     801e6c <read_map+0x79>
  801e5c:	89 d8                	mov    %ebx,%eax
  801e5e:	c1 e8 0c             	shr    $0xc,%eax
  801e61:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801e68:	a8 01                	test   $0x1,%al
  801e6a:	75 19                	jne    801e85 <read_map+0x92>
          // page is not mapped, so map it!
          if ((r = fmap(fd, offset, offset + 1)) < 0) {
  801e6c:	83 ec 04             	sub    $0x4,%esp
  801e6f:	8d 46 01             	lea    0x1(%esi),%eax
  801e72:	50                   	push   %eax
  801e73:	56                   	push   %esi
  801e74:	ff 75 f4             	pushl  0xfffffff4(%ebp)
  801e77:	e8 fb 01 00 00       	call   802077 <fmap>
  801e7c:	83 c4 10             	add    $0x10,%esp
            return r;
  801e7f:	89 c2                	mov    %eax,%edx
  801e81:	85 c0                	test   %eax,%eax
  801e83:	78 31                	js     801eb6 <read_map+0xc3>
          }
        }

	if (!(vpd[PDX(va)] & PTE_P) || !(vpt[VPN(va)] & PTE_P))
  801e85:	89 d8                	mov    %ebx,%eax
  801e87:	c1 e8 16             	shr    $0x16,%eax
  801e8a:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801e91:	a8 01                	test   $0x1,%al
  801e93:	74 10                	je     801ea5 <read_map+0xb2>
  801e95:	89 d8                	mov    %ebx,%eax
  801e97:	c1 e8 0c             	shr    $0xc,%eax
  801e9a:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801ea1:	a8 01                	test   $0x1,%al
  801ea3:	75 07                	jne    801eac <read_map+0xb9>
		return -E_NO_DISK;
  801ea5:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  801eaa:	eb 0a                	jmp    801eb6 <read_map+0xc3>

	*blk = (void*) va;
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	89 18                	mov    %ebx,(%eax)
	return 0;
  801eb1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801eb6:	89 d0                	mov    %edx,%eax
  801eb8:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801ebb:	5b                   	pop    %ebx
  801ebc:	5e                   	pop    %esi
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <file_write>:

// Write 'n' bytes from 'buf' to 'fd' at the current seek position.
static ssize_t
file_write(struct Fd *fd, const void *buf, size_t n, off_t offset)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	57                   	push   %edi
  801ec3:	56                   	push   %esi
  801ec4:	53                   	push   %ebx
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	8b 75 08             	mov    0x8(%ebp),%esi
  801ecb:	8b 7d 14             	mov    0x14(%ebp),%edi
	int r;
	size_t tot;

        // Challenge 5:
        void* paddr;

	// don't write past the maximum file size
	tot = offset + n;
  801ece:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed1:	8d 14 07             	lea    (%edi,%eax,1),%edx
	if (tot > MAXFILESIZE)
		return -E_NO_DISK;
  801ed4:	b9 f7 ff ff ff       	mov    $0xfffffff7,%ecx
  801ed9:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  801edf:	0f 87 bd 00 00 00    	ja     801fa2 <file_write+0xe3>

	// increase the file's size if necessary
	if (tot > fd->fd_file.file.f_size) {
  801ee5:	39 96 90 00 00 00    	cmp    %edx,0x90(%esi)
  801eeb:	73 17                	jae    801f04 <file_write+0x45>
		if ((r = file_trunc(fd, tot)) < 0)
  801eed:	83 ec 08             	sub    $0x8,%esp
  801ef0:	52                   	push   %edx
  801ef1:	56                   	push   %esi
  801ef2:	e8 fb 00 00 00       	call   801ff2 <file_trunc>
  801ef7:	83 c4 10             	add    $0x10,%esp
			return r;
  801efa:	89 c1                	mov    %eax,%ecx
  801efc:	85 c0                	test   %eax,%eax
  801efe:	0f 88 9e 00 00 00    	js     801fa2 <file_write+0xe3>
	}

        // Challenge 5:
        // Check if the page is mapped yet
        for (paddr = fd2data(fd) + offset; paddr < (void*)(fd2data(fd) + offset + n); paddr += PGSIZE) {
  801f04:	83 ec 0c             	sub    $0xc,%esp
  801f07:	56                   	push   %esi
  801f08:	e8 db f7 ff ff       	call   8016e8 <fd2data>
  801f0d:	89 c3                	mov    %eax,%ebx
  801f0f:	01 fb                	add    %edi,%ebx
  801f11:	83 c4 10             	add    $0x10,%esp
  801f14:	eb 42                	jmp    801f58 <file_write+0x99>
	  if (!(vpd[PDX(paddr)] & PTE_P) || !(vpt[VPN(paddr)] & PTE_P)) {
  801f16:	89 d8                	mov    %ebx,%eax
  801f18:	c1 e8 16             	shr    $0x16,%eax
  801f1b:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
  801f22:	a8 01                	test   $0x1,%al
  801f24:	74 10                	je     801f36 <file_write+0x77>
  801f26:	89 d8                	mov    %ebx,%eax
  801f28:	c1 e8 0c             	shr    $0xc,%eax
  801f2b:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
  801f32:	a8 01                	test   $0x1,%al
  801f34:	75 1c                	jne    801f52 <file_write+0x93>
            // page is not mapped, so map it!
            if ((r = fmap(fd, offset, offset + n)) < 0) {
  801f36:	83 ec 04             	sub    $0x4,%esp
  801f39:	8b 55 10             	mov    0x10(%ebp),%edx
  801f3c:	8d 04 17             	lea    (%edi,%edx,1),%eax
  801f3f:	50                   	push   %eax
  801f40:	57                   	push   %edi
  801f41:	56                   	push   %esi
  801f42:	e8 30 01 00 00       	call   802077 <fmap>
  801f47:	83 c4 10             	add    $0x10,%esp
              return r;
  801f4a:	89 c1                	mov    %eax,%ecx
  801f4c:	85 c0                	test   %eax,%eax
  801f4e:	78 52                	js     801fa2 <file_write+0xe3>
  801f50:	eb 1b                	jmp    801f6d <file_write+0xae>
  801f52:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f58:	83 ec 0c             	sub    $0xc,%esp
  801f5b:	56                   	push   %esi
  801f5c:	e8 87 f7 ff ff       	call   8016e8 <fd2data>
  801f61:	01 f8                	add    %edi,%eax
  801f63:	03 45 10             	add    0x10(%ebp),%eax
  801f66:	83 c4 10             	add    $0x10,%esp
  801f69:	39 d8                	cmp    %ebx,%eax
  801f6b:	77 a9                	ja     801f16 <file_write+0x57>
            }
            break;
          }
        }

	// write the data
        cprintf("write write\n");
  801f6d:	83 ec 0c             	sub    $0xc,%esp
  801f70:	68 56 38 80 00       	push   $0x803856
  801f75:	e8 9e e6 ff ff       	call   800618 <cprintf>
	memmove(fd2data(fd) + offset, buf, n);
  801f7a:	83 c4 0c             	add    $0xc,%esp
  801f7d:	ff 75 10             	pushl  0x10(%ebp)
  801f80:	ff 75 0c             	pushl  0xc(%ebp)
  801f83:	56                   	push   %esi
  801f84:	e8 5f f7 ff ff       	call   8016e8 <fd2data>
  801f89:	01 f8                	add    %edi,%eax
  801f8b:	89 04 24             	mov    %eax,(%esp)
  801f8e:	e8 05 ee ff ff       	call   800d98 <memmove>
        cprintf("write done\n");
  801f93:	c7 04 24 63 38 80 00 	movl   $0x803863,(%esp)
  801f9a:	e8 79 e6 ff ff       	call   800618 <cprintf>
	return n;
  801f9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
}
  801fa2:	89 c8                	mov    %ecx,%eax
  801fa4:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5f                   	pop    %edi
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <file_stat>:

static int
file_stat(struct Fd *fd, struct Stat *st)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	56                   	push   %esi
  801fb0:	53                   	push   %ebx
  801fb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801fb4:	8b 75 0c             	mov    0xc(%ebp),%esi
	strcpy(st->st_name, fd->fd_file.file.f_name);
  801fb7:	83 ec 08             	sub    $0x8,%esp
  801fba:	8d 43 10             	lea    0x10(%ebx),%eax
  801fbd:	50                   	push   %eax
  801fbe:	56                   	push   %esi
  801fbf:	e8 58 ec ff ff       	call   800c1c <strcpy>
	st->st_size = fd->fd_file.file.f_size;
  801fc4:	8b 83 90 00 00 00    	mov    0x90(%ebx),%eax
  801fca:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	st->st_isdir = (fd->fd_file.file.f_type == FTYPE_DIR);
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	83 bb 94 00 00 00 01 	cmpl   $0x1,0x94(%ebx)
  801fda:	0f 94 c0             	sete   %al
  801fdd:	0f b6 c0             	movzbl %al,%eax
  801fe0:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
	return 0;
}
  801fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  801feb:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  801fee:	5b                   	pop    %ebx
  801fef:	5e                   	pop    %esi
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <file_trunc>:

// Truncate or extend an open file to 'size' bytes
static int
file_trunc(struct Fd *fd, off_t newsize)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	57                   	push   %edi
  801ff6:	56                   	push   %esi
  801ff7:	53                   	push   %ebx
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	8b 75 08             	mov    0x8(%ebp),%esi
  801ffe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	off_t oldsize;
	uint32_t fileid;

	if (newsize > MAXFILESIZE)
		return -E_NO_DISK;
  802001:	ba f7 ff ff ff       	mov    $0xfffffff7,%edx
  802006:	81 fb 00 00 40 00    	cmp    $0x400000,%ebx
  80200c:	7f 5f                	jg     80206d <file_trunc+0x7b>

	fileid = fd->fd_file.id;
	oldsize = fd->fd_file.file.f_size;
  80200e:	8b be 90 00 00 00    	mov    0x90(%esi),%edi
	if ((r = fsipc_set_size(fileid, newsize)) < 0)
  802014:	83 ec 08             	sub    $0x8,%esp
  802017:	53                   	push   %ebx
  802018:	ff 76 0c             	pushl  0xc(%esi)
  80201b:	e8 3a 02 00 00       	call   80225a <fsipc_set_size>
  802020:	83 c4 10             	add    $0x10,%esp
		return r;
  802023:	89 c2                	mov    %eax,%edx
  802025:	85 c0                	test   %eax,%eax
  802027:	78 44                	js     80206d <file_trunc+0x7b>
	assert(fd->fd_file.file.f_size == newsize);
  802029:	39 9e 90 00 00 00    	cmp    %ebx,0x90(%esi)
  80202f:	74 19                	je     80204a <file_trunc+0x58>
  802031:	68 90 38 80 00       	push   $0x803890
  802036:	68 6f 38 80 00       	push   $0x80386f
  80203b:	68 dc 00 00 00       	push   $0xdc
  802040:	68 84 38 80 00       	push   $0x803884
  802045:	e8 de e4 ff ff       	call   800528 <_panic>

	if ((r = fmap(fd, oldsize, newsize)) < 0)
  80204a:	83 ec 04             	sub    $0x4,%esp
  80204d:	53                   	push   %ebx
  80204e:	57                   	push   %edi
  80204f:	56                   	push   %esi
  802050:	e8 22 00 00 00       	call   802077 <fmap>
  802055:	83 c4 10             	add    $0x10,%esp
		return r;
  802058:	89 c2                	mov    %eax,%edx
  80205a:	85 c0                	test   %eax,%eax
  80205c:	78 0f                	js     80206d <file_trunc+0x7b>
	funmap(fd, oldsize, newsize, 0);
  80205e:	6a 00                	push   $0x0
  802060:	53                   	push   %ebx
  802061:	57                   	push   %edi
  802062:	56                   	push   %esi
  802063:	e8 85 00 00 00       	call   8020ed <funmap>

	return 0;
  802068:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80206d:	89 d0                	mov    %edx,%eax
  80206f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802072:	5b                   	pop    %ebx
  802073:	5e                   	pop    %esi
  802074:	5f                   	pop    %edi
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <fmap>:

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
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	57                   	push   %edi
  80207b:	56                   	push   %esi
  80207c:	53                   	push   %ebx
  80207d:	83 ec 0c             	sub    $0xc,%esp
  802080:	8b 7d 08             	mov    0x8(%ebp),%edi
  802083:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 5: Your code here.
	//panic("fmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (oldsize < newsize) {
  802086:	39 75 0c             	cmp    %esi,0xc(%ebp)
  802089:	7d 55                	jge    8020e0 <fmap+0x69>
          fma = fd2data(fd);
  80208b:	83 ec 0c             	sub    $0xc,%esp
  80208e:	57                   	push   %edi
  80208f:	e8 54 f6 ff ff       	call   8016e8 <fd2data>
  802094:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
          for (pidx = ROUNDUP(oldsize, PGSIZE); pidx < newsize; pidx += PGSIZE) {
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209d:	05 ff 0f 00 00       	add    $0xfff,%eax
  8020a2:	89 c3                	mov    %eax,%ebx
  8020a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8020aa:	39 f3                	cmp    %esi,%ebx
  8020ac:	7d 32                	jge    8020e0 <fmap+0x69>
            if ((r = fsipc_map(fd->fd_file.id, pidx, fma + pidx)) < 0) {
  8020ae:	83 ec 04             	sub    $0x4,%esp
  8020b1:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8020b4:	01 d8                	add    %ebx,%eax
  8020b6:	50                   	push   %eax
  8020b7:	53                   	push   %ebx
  8020b8:	ff 77 0c             	pushl  0xc(%edi)
  8020bb:	e8 6f 01 00 00       	call   80222f <fsipc_map>
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	79 0f                	jns    8020d6 <fmap+0x5f>
              // unmap because of error
              funmap(fd, pidx, oldsize, 0);
  8020c7:	6a 00                	push   $0x0
  8020c9:	ff 75 0c             	pushl  0xc(%ebp)
  8020cc:	53                   	push   %ebx
  8020cd:	57                   	push   %edi
  8020ce:	e8 1a 00 00 00       	call   8020ed <funmap>
  8020d3:	83 c4 10             	add    $0x10,%esp
  8020d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8020dc:	39 f3                	cmp    %esi,%ebx
  8020de:	7c ce                	jl     8020ae <fmap+0x37>
            }
          }
        }

        return 0;
}
  8020e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e5:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8020e8:	5b                   	pop    %ebx
  8020e9:	5e                   	pop    %esi
  8020ea:	5f                   	pop    %edi
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <funmap>:

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
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	57                   	push   %edi
  8020f1:	56                   	push   %esi
  8020f2:	53                   	push   %ebx
  8020f3:	83 ec 0c             	sub    $0xc,%esp
  8020f6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	//panic("funmap not implemented");
	//return -E_UNSPECIFIED;

	char *fma; // file mapping area
        int pidx;
        int r;
        if (newsize < oldsize) {
  8020fc:	39 f3                	cmp    %esi,%ebx
  8020fe:	0f 8d 80 00 00 00    	jge    802184 <funmap+0x97>
          fma = fd2data(fd);
  802104:	83 ec 0c             	sub    $0xc,%esp
  802107:	ff 75 08             	pushl  0x8(%ebp)
  80210a:	e8 d9 f5 ff ff       	call   8016e8 <fd2data>
  80210f:	89 c7                	mov    %eax,%edi
          for (pidx = ROUNDUP(newsize, PGSIZE); pidx < oldsize; pidx += PGSIZE) {
  802111:	83 c4 10             	add    $0x10,%esp
  802114:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  80211a:	89 c3                	mov    %eax,%ebx
  80211c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  802122:	39 f3                	cmp    %esi,%ebx
  802124:	7d 5e                	jge    802184 <funmap+0x97>
            if (vpt[VPN(fma + pidx)] & PTE_P) { // present
  802126:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  802129:	89 c2                	mov    %eax,%edx
  80212b:	c1 ea 0c             	shr    $0xc,%edx
  80212e:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  802135:	a8 01                	test   $0x1,%al
  802137:	74 41                	je     80217a <funmap+0x8d>
              if (dirty) {
  802139:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
  80213d:	74 21                	je     802160 <funmap+0x73>
                if (vpt[VPN(fma + pidx)] & PTE_D) {
  80213f:	8b 04 95 00 00 40 ef 	mov    0xef400000(,%edx,4),%eax
  802146:	a8 40                	test   $0x40,%al
  802148:	74 16                	je     802160 <funmap+0x73>
                  if ((r = fsipc_dirty(fd->fd_file.id, pidx)) < 0) {
  80214a:	83 ec 08             	sub    $0x8,%esp
  80214d:	53                   	push   %ebx
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	ff 70 0c             	pushl  0xc(%eax)
  802154:	e8 49 01 00 00       	call   8022a2 <fsipc_dirty>
  802159:	83 c4 10             	add    $0x10,%esp
  80215c:	85 c0                	test   %eax,%eax
  80215e:	78 29                	js     802189 <funmap+0x9c>
                    return r;
                  }
                }
              }
              sys_page_unmap(sys_getenvid(), fma + pidx);
  802160:	83 ec 08             	sub    $0x8,%esp
  802163:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  802166:	50                   	push   %eax
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	e8 41 ee ff ff       	call   800fb0 <sys_getenvid>
  80216f:	89 04 24             	mov    %eax,(%esp)
  802172:	e8 fc ee ff ff       	call   801073 <sys_page_unmap>
  802177:	83 c4 10             	add    $0x10,%esp
  80217a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802180:	39 f3                	cmp    %esi,%ebx
  802182:	7c a2                	jl     802126 <funmap+0x39>
            }
          }
        }

        return 0;
  802184:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802189:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80218c:	5b                   	pop    %ebx
  80218d:	5e                   	pop    %esi
  80218e:	5f                   	pop    %edi
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <remove>:

// Delete a file
int
remove(const char *path)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	83 ec 14             	sub    $0x14,%esp
	return fsipc_remove(path);
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	e8 2b 01 00 00       	call   8022ca <fsipc_remove>
}
  80219f:	c9                   	leave  
  8021a0:	c3                   	ret    

008021a1 <sync>:

// Synchronize disk with buffer cache
int
sync(void)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 08             	sub    $0x8,%esp
	return fsipc_sync();
  8021a7:	e8 64 01 00 00       	call   802310 <fsipc_sync>
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    
	...

008021b0 <fsipc>:
// *perm: permissions of received page.
// Returns 0 if successful, < 0 on failure.
static int
fsipc(unsigned type, void *fsreq, void *dstva, int *perm)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 08             	sub    $0x8,%esp
	envid_t whom;

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, fsipcbuf);

	ipc_send(envs[1].env_id, type, fsreq, PTE_P | PTE_W | PTE_U);
  8021b6:	6a 07                	push   $0x7
  8021b8:	ff 75 0c             	pushl  0xc(%ebp)
  8021bb:	ff 75 08             	pushl  0x8(%ebp)
  8021be:	a1 cc 00 c0 ee       	mov    0xeec000cc,%eax
  8021c3:	50                   	push   %eax
  8021c4:	e8 f2 0b 00 00       	call   802dbb <ipc_send>
	return ipc_recv(&whom, dstva, perm);
  8021c9:	83 c4 0c             	add    $0xc,%esp
  8021cc:	ff 75 14             	pushl  0x14(%ebp)
  8021cf:	ff 75 10             	pushl  0x10(%ebp)
  8021d2:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  8021d5:	50                   	push   %eax
  8021d6:	e8 7d 0b 00 00       	call   802d58 <ipc_recv>
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <fsipc_open>:

// Send file-open request to the file server.
// Includes 'path' and 'omode' in request,
// and on reply maps the returned file descriptor page
// at the address indicated by the caller in 'fd'.
// Returns 0 on success, < 0 on failure.
int
fsipc_open(const char *path, int omode, struct Fd *fd)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	56                   	push   %esi
  8021e1:	53                   	push   %ebx
  8021e2:	83 ec 1c             	sub    $0x1c,%esp
  8021e5:	8b 75 08             	mov    0x8(%ebp),%esi
	int perm;
	struct Fsreq_open *req;

	req = (struct Fsreq_open*)fsipcbuf;
  8021e8:	bb 00 40 80 00       	mov    $0x804000,%ebx
	if (strlen(path) >= MAXPATHLEN)
  8021ed:	56                   	push   %esi
  8021ee:	e8 ed e9 ff ff       	call   800be0 <strlen>
  8021f3:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  8021f6:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8021fb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802200:	7f 24                	jg     802226 <fsipc_open+0x49>
	strcpy(req->req_path, path);
  802202:	83 ec 08             	sub    $0x8,%esp
  802205:	56                   	push   %esi
  802206:	53                   	push   %ebx
  802207:	e8 10 ea ff ff       	call   800c1c <strcpy>
	req->req_omode = omode;
  80220c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220f:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)

	return fsipc(FSREQ_OPEN, req, fd, &perm);
  802215:	8d 45 f4             	lea    0xfffffff4(%ebp),%eax
  802218:	50                   	push   %eax
  802219:	ff 75 10             	pushl  0x10(%ebp)
  80221c:	53                   	push   %ebx
  80221d:	6a 01                	push   $0x1
  80221f:	e8 8c ff ff ff       	call   8021b0 <fsipc>
  802224:	89 c2                	mov    %eax,%edx
}
  802226:	89 d0                	mov    %edx,%eax
  802228:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5e                   	pop    %esi
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <fsipc_map>:

// Make a map-block request to the file server.
// We send the fileid and the (byte) offset of the desired block in the file,
// and the server sends us back a mapping for a page containing that block.
// Returns 0 on success, < 0 on failure.
int
fsipc_map(int fileid, off_t offset, void *dstva)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
  802232:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_map not implemented");

	int perm;
	struct Fsreq_map *req;
	req = (struct Fsreq_map*)fsipcbuf;
        req->req_fileid = fileid;
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  80223d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802240:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_MAP, req, dstva, &perm);
  802245:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802248:	50                   	push   %eax
  802249:	ff 75 10             	pushl  0x10(%ebp)
  80224c:	68 00 40 80 00       	push   $0x804000
  802251:	6a 02                	push   $0x2
  802253:	e8 58 ff ff ff       	call   8021b0 <fsipc>

	//return -E_UNSPECIFIED;
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <fsipc_set_size>:

// Make a set-file-size request to the file server.
int
fsipc_set_size(int fileid, off_t size)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_set_size *req;

	req = (struct Fsreq_set_size*) fsipcbuf;
	req->req_fileid = fileid;
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	a3 00 40 80 00       	mov    %eax,0x804000
	req->req_size = size;
  802268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226b:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, req, 0, 0);
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	68 00 40 80 00       	push   $0x804000
  802279:	6a 03                	push   $0x3
  80227b:	e8 30 ff ff ff       	call   8021b0 <fsipc>
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <fsipc_close>:

// Make a file-close request to the file server.
// After this the fileid is invalid.
int
fsipc_close(int fileid)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 08             	sub    $0x8,%esp
	struct Fsreq_close *req;

	req = (struct Fsreq_close*) fsipcbuf;
	req->req_fileid = fileid;
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_CLOSE, req, 0, 0);
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	68 00 40 80 00       	push   $0x804000
  802299:	6a 04                	push   $0x4
  80229b:	e8 10 ff ff ff       	call   8021b0 <fsipc>
}
  8022a0:	c9                   	leave  
  8022a1:	c3                   	ret    

008022a2 <fsipc_dirty>:

// Ask the file server to mark a particular file block dirty.
int
fsipc_dirty(int fileid, off_t offset)
{
  8022a2:	55                   	push   %ebp
  8022a3:	89 e5                	mov    %esp,%ebp
  8022a5:	83 ec 08             	sub    $0x8,%esp
	// LAB 5: Your code here.
	//panic("fsipc_dirty not implemented");
	//return -E_UNSPECIFIED;

	int perm;
	struct Fsreq_dirty *req;
	req = (struct Fsreq_dirty*)fsipcbuf;
        req->req_fileid = fileid;
  8022a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ab:	a3 00 40 80 00       	mov    %eax,0x804000
        req->req_offset = offset;
  8022b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b3:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_DIRTY, req, 0, 0);
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	68 00 40 80 00       	push   $0x804000
  8022c1:	6a 05                	push   $0x5
  8022c3:	e8 e8 fe ff ff       	call   8021b0 <fsipc>
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <fsipc_remove>:

// Ask the file server to delete a file, given its pathname.
int
fsipc_remove(const char *path)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	56                   	push   %esi
  8022ce:	53                   	push   %ebx
  8022cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct Fsreq_remove *req;

	req = (struct Fsreq_remove*) fsipcbuf;
  8022d2:	be 00 40 80 00       	mov    $0x804000,%esi
	if (strlen(path) >= MAXPATHLEN)
  8022d7:	83 ec 0c             	sub    $0xc,%esp
  8022da:	53                   	push   %ebx
  8022db:	e8 00 e9 ff ff       	call   800be0 <strlen>
  8022e0:	83 c4 10             	add    $0x10,%esp
		return -E_BAD_PATH;
  8022e3:	ba f4 ff ff ff       	mov    $0xfffffff4,%edx
  8022e8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8022ed:	7f 18                	jg     802307 <fsipc_remove+0x3d>
	strcpy(req->req_path, path);
  8022ef:	83 ec 08             	sub    $0x8,%esp
  8022f2:	53                   	push   %ebx
  8022f3:	56                   	push   %esi
  8022f4:	e8 23 e9 ff ff       	call   800c1c <strcpy>
	return fsipc(FSREQ_REMOVE, req, 0, 0);
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	56                   	push   %esi
  8022fe:	6a 06                	push   $0x6
  802300:	e8 ab fe ff ff       	call   8021b0 <fsipc>
  802305:	89 c2                	mov    %eax,%edx
}
  802307:	89 d0                	mov    %edx,%eax
  802309:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  80230c:	5b                   	pop    %ebx
  80230d:	5e                   	pop    %esi
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <fsipc_sync>:

// Ask the file server to update the disk
// by writing any dirty blocks in the buffer cache.
int
fsipc_sync(void)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 08             	sub    $0x8,%esp
	return fsipc(FSREQ_SYNC, fsipcbuf, 0, 0);
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	68 00 40 80 00       	push   $0x804000
  80231f:	6a 07                	push   $0x7
  802321:	e8 8a fe ff ff       	call   8021b0 <fsipc>
}
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <spawn>:
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	57                   	push   %edi
  80232c:	56                   	push   %esi
  80232d:	53                   	push   %ebx
  80232e:	81 ec 74 02 00 00    	sub    $0x274,%esp
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
  802334:	6a 00                	push   $0x0
  802336:	ff 75 08             	pushl  0x8(%ebp)
  802339:	e8 5a f9 ff ff       	call   801c98 <open>
  80233e:	89 c3                	mov    %eax,%ebx
  802340:	83 c4 10             	add    $0x10,%esp
  802343:	85 db                	test   %ebx,%ebx
  802345:	0f 88 ed 01 00 00    	js     802538 <spawn+0x210>
		return r;
	fd = r;
  80234b:	89 9d 90 fd ff ff    	mov    %ebx,0xfffffd90(%ebp)

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	68 00 02 00 00       	push   $0x200
  802359:	8d 85 e8 fd ff ff    	lea    0xfffffde8(%ebp),%eax
  80235f:	50                   	push   %eax
  802360:	53                   	push   %ebx
  802361:	e8 97 f6 ff ff       	call   8019fd <read>
  802366:	83 c4 10             	add    $0x10,%esp
  802369:	3d 00 02 00 00       	cmp    $0x200,%eax
  80236e:	75 0c                	jne    80237c <spawn+0x54>
  802370:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,0xfffffde8(%ebp)
  802377:	45 4c 46 
  80237a:	74 30                	je     8023ac <spawn+0x84>
	    || elf->e_magic != ELF_MAGIC) {
		close(fd);
  80237c:	83 ec 0c             	sub    $0xc,%esp
  80237f:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  802385:	e8 00 f5 ff ff       	call   80188a <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80238a:	83 c4 0c             	add    $0xc,%esp
  80238d:	68 7f 45 4c 46       	push   $0x464c457f
  802392:	ff b5 e8 fd ff ff    	pushl  0xfffffde8(%ebp)
  802398:	68 b3 38 80 00       	push   $0x8038b3
  80239d:	e8 76 e2 ff ff       	call   800618 <cprintf>
		return -E_NOT_EXEC;
  8023a2:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8023a7:	e9 8c 01 00 00       	jmp    802538 <spawn+0x210>
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8023ac:	ba 07 00 00 00       	mov    $0x7,%edx
  8023b1:	89 d0                	mov    %edx,%eax
  8023b3:	cd 30                	int    $0x30
  8023b5:	89 c3                	mov    %eax,%ebx
  8023b7:	85 db                	test   %ebx,%ebx
  8023b9:	0f 88 79 01 00 00    	js     802538 <spawn+0x210>
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
	child = r;
  8023bf:	89 9d 94 fd ff ff    	mov    %ebx,0xfffffd94(%ebp)

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8023c5:	89 d8                	mov    %ebx,%eax
  8023c7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8023cc:	c1 e0 07             	shl    $0x7,%eax
  8023cf:	8d 95 98 fd ff ff    	lea    0xfffffd98(%ebp),%edx
  8023d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8023da:	83 ec 04             	sub    $0x4,%esp
  8023dd:	6a 44                	push   $0x44
  8023df:	50                   	push   %eax
  8023e0:	52                   	push   %edx
  8023e1:	e8 1d ea ff ff       	call   800e03 <memcpy>
	child_tf.tf_eip = elf->e_entry;
  8023e6:	8b 85 00 fe ff ff    	mov    0xfffffe00(%ebp),%eax
  8023ec:	89 85 c8 fd ff ff    	mov    %eax,0xfffffdc8(%ebp)

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
  8023f2:	83 c4 0c             	add    $0xc,%esp
  8023f5:	8d 85 d4 fd ff ff    	lea    0xfffffdd4(%ebp),%eax
  8023fb:	50                   	push   %eax
  8023fc:	ff 75 0c             	pushl  0xc(%ebp)
  8023ff:	53                   	push   %ebx
  802400:	e8 4f 01 00 00       	call   802554 <init_stack>
  802405:	89 c3                	mov    %eax,%ebx
  802407:	83 c4 10             	add    $0x10,%esp
  80240a:	85 db                	test   %ebx,%ebx
  80240c:	0f 88 26 01 00 00    	js     802538 <spawn+0x210>
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802412:	8b 85 04 fe ff ff    	mov    0xfffffe04(%ebp),%eax
  802418:	8d b4 05 e8 fd ff ff 	lea    0xfffffde8(%ebp,%eax,1),%esi
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80241f:	bf 00 00 00 00       	mov    $0x0,%edi
  802424:	66 83 bd 14 fe ff ff 	cmpw   $0x0,0xfffffe14(%ebp)
  80242b:	00 
  80242c:	74 4f                	je     80247d <spawn+0x155>
		if (ph->p_type != ELF_PROG_LOAD)
  80242e:	83 3e 01             	cmpl   $0x1,(%esi)
  802431:	75 3b                	jne    80246e <spawn+0x146>
			continue;
		perm = PTE_P | PTE_U;
  802433:	b8 05 00 00 00       	mov    $0x5,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802438:	f6 46 18 02          	testb  $0x2,0x18(%esi)
  80243c:	74 02                	je     802440 <spawn+0x118>
			perm |= PTE_W;
  80243e:	b0 07                	mov    $0x7,%al
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  802440:	83 ec 04             	sub    $0x4,%esp
  802443:	50                   	push   %eax
  802444:	ff 76 04             	pushl  0x4(%esi)
  802447:	ff 76 10             	pushl  0x10(%esi)
  80244a:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  802450:	ff 76 14             	pushl  0x14(%esi)
  802453:	ff 76 08             	pushl  0x8(%esi)
  802456:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  80245c:	e8 5f 02 00 00       	call   8026c0 <map_segment>
  802461:	89 c3                	mov    %eax,%ebx
  802463:	83 c4 20             	add    $0x20,%esp
  802466:	85 c0                	test   %eax,%eax
  802468:	0f 88 ac 00 00 00    	js     80251a <spawn+0x1f2>
  80246e:	47                   	inc    %edi
  80246f:	83 c6 20             	add    $0x20,%esi
  802472:	0f b7 85 14 fe ff ff 	movzwl 0xfffffe14(%ebp),%eax
  802479:	39 f8                	cmp    %edi,%eax
  80247b:	7f b1                	jg     80242e <spawn+0x106>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80247d:	83 ec 0c             	sub    $0xc,%esp
  802480:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  802486:	e8 ff f3 ff ff       	call   80188a <close>
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
  80248b:	83 c4 04             	add    $0x4,%esp
  80248e:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802494:	e8 9f 03 00 00       	call   802838 <copy_shared_pages>
  802499:	83 c4 10             	add    $0x10,%esp
  80249c:	85 c0                	test   %eax,%eax
  80249e:	79 15                	jns    8024b5 <spawn+0x18d>
		panic("copy_shared_pages: %e", r);
  8024a0:	50                   	push   %eax
  8024a1:	68 cd 38 80 00       	push   $0x8038cd
  8024a6:	68 82 00 00 00       	push   $0x82
  8024ab:	68 e3 38 80 00       	push   $0x8038e3
  8024b0:	e8 73 e0 ff ff       	call   800528 <_panic>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8024b5:	83 ec 08             	sub    $0x8,%esp
  8024b8:	8d 85 98 fd ff ff    	lea    0xfffffd98(%ebp),%eax
  8024be:	50                   	push   %eax
  8024bf:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  8024c5:	e8 2d ec ff ff       	call   8010f7 <sys_env_set_trapframe>
  8024ca:	83 c4 10             	add    $0x10,%esp
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	79 15                	jns    8024e6 <spawn+0x1be>
		panic("sys_env_set_trapframe: %e", r);
  8024d1:	50                   	push   %eax
  8024d2:	68 ef 38 80 00       	push   $0x8038ef
  8024d7:	68 85 00 00 00       	push   $0x85
  8024dc:	68 e3 38 80 00       	push   $0x8038e3
  8024e1:	e8 42 e0 ff ff       	call   800528 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8024e6:	83 ec 08             	sub    $0x8,%esp
  8024e9:	6a 01                	push   $0x1
  8024eb:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  8024f1:	e8 bf eb ff ff       	call   8010b5 <sys_env_set_status>
  8024f6:	89 c3                	mov    %eax,%ebx
  8024f8:	83 c4 10             	add    $0x10,%esp
		panic("sys_env_set_status: %e", r);

	return child;
  8024fb:	8b 85 94 fd ff ff    	mov    0xfffffd94(%ebp),%eax
  802501:	85 db                	test   %ebx,%ebx
  802503:	79 33                	jns    802538 <spawn+0x210>
  802505:	53                   	push   %ebx
  802506:	68 09 39 80 00       	push   $0x803909
  80250b:	68 88 00 00 00       	push   $0x88
  802510:	68 e3 38 80 00       	push   $0x8038e3
  802515:	e8 0e e0 ff ff       	call   800528 <_panic>

error:
	sys_env_destroy(child);
  80251a:	83 ec 0c             	sub    $0xc,%esp
  80251d:	ff b5 94 fd ff ff    	pushl  0xfffffd94(%ebp)
  802523:	e8 47 ea ff ff       	call   800f6f <sys_env_destroy>
	close(fd);
  802528:	83 c4 04             	add    $0x4,%esp
  80252b:	ff b5 90 fd ff ff    	pushl  0xfffffd90(%ebp)
  802531:	e8 54 f3 ff ff       	call   80188a <close>
	return r;
  802536:	89 d8                	mov    %ebx,%eax
}
  802538:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  80253b:	5b                   	pop    %ebx
  80253c:	5e                   	pop    %esi
  80253d:	5f                   	pop    %edi
  80253e:	c9                   	leave  
  80253f:	c3                   	ret    

00802540 <spawnl>:

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
  802543:	83 ec 10             	sub    $0x10,%esp
	return spawn(prog, &arg0);
  802546:	8d 45 0c             	lea    0xc(%ebp),%eax
  802549:	50                   	push   %eax
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	e8 d6 fd ff ff       	call   802328 <spawn>
}
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <init_stack>:


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
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	57                   	push   %edi
  802558:	56                   	push   %esi
  802559:	53                   	push   %ebx
  80255a:	83 ec 0c             	sub    $0xc,%esp
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80255d:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  802562:	c7 45 f0 00 00 00 00 	movl   $0x0,0xfffffff0(%ebp)
  802569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256c:	83 38 00             	cmpl   $0x0,(%eax)
  80256f:	74 27                	je     802598 <init_stack+0x44>
		string_size += strlen(argv[argc]) + 1;
  802571:	83 ec 0c             	sub    $0xc,%esp
  802574:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802577:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257a:	ff 34 90             	pushl  (%eax,%edx,4)
  80257d:	e8 5e e6 ff ff       	call   800be0 <strlen>
  802582:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
  802586:	83 c4 10             	add    $0x10,%esp
  802589:	ff 45 f0             	incl   0xfffffff0(%ebp)
  80258c:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  80258f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802592:	83 3c 90 00          	cmpl   $0x0,(%eax,%edx,4)
  802596:	75 d9                	jne    802571 <init_stack+0x1d>

	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802598:	b8 00 10 40 00       	mov    $0x401000,%eax
  80259d:	89 c7                	mov    %eax,%edi
  80259f:	29 df                	sub    %ebx,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8025a1:	89 fa                	mov    %edi,%edx
  8025a3:	83 e2 fc             	and    $0xfffffffc,%edx
  8025a6:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8025a9:	c1 e0 02             	shl    $0x2,%eax
  8025ac:	89 d6                	mov    %edx,%esi
  8025ae:	29 c6                	sub    %eax,%esi
  8025b0:	83 ee 04             	sub    $0x4,%esi
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8025b3:	8d 46 f8             	lea    0xfffffff8(%esi),%eax
		return -E_NO_MEM;
  8025b6:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
  8025bb:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8025c0:	0f 86 f0 00 00 00    	jbe    8026b6 <init_stack+0x162>

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8025c6:	83 ec 04             	sub    $0x4,%esp
  8025c9:	6a 07                	push   $0x7
  8025cb:	68 00 00 40 00       	push   $0x400000
  8025d0:	6a 00                	push   $0x0
  8025d2:	e8 17 ea ff ff       	call   800fee <sys_page_alloc>
  8025d7:	83 c4 10             	add    $0x10,%esp
		return r;
  8025da:	89 c2                	mov    %eax,%edx
  8025dc:	85 c0                	test   %eax,%eax
  8025de:	0f 88 d2 00 00 00    	js     8026b6 <init_stack+0x162>


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
  8025e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8025e9:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
  8025ec:	7d 33                	jge    802621 <init_stack+0xcd>
		argv_store[i] = UTEMP2USTACK(string_store);
  8025ee:	8d 87 00 d0 7f ee    	lea    0xee7fd000(%edi),%eax
  8025f4:	89 04 9e             	mov    %eax,(%esi,%ebx,4)
		strcpy(string_store, argv[i]);
  8025f7:	83 ec 08             	sub    $0x8,%esp
  8025fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025fd:	ff 34 9a             	pushl  (%edx,%ebx,4)
  802600:	57                   	push   %edi
  802601:	e8 16 e6 ff ff       	call   800c1c <strcpy>
		string_store += strlen(argv[i]) + 1;
  802606:	83 c4 04             	add    $0x4,%esp
  802609:	8b 45 0c             	mov    0xc(%ebp),%eax
  80260c:	ff 34 98             	pushl  (%eax,%ebx,4)
  80260f:	e8 cc e5 ff ff       	call   800be0 <strlen>
  802614:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
  802618:	83 c4 10             	add    $0x10,%esp
  80261b:	43                   	inc    %ebx
  80261c:	3b 5d f0             	cmp    0xfffffff0(%ebp),%ebx
  80261f:	7c cd                	jl     8025ee <init_stack+0x9a>
	}
	argv_store[argc] = 0;
  802621:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802624:	c7 04 96 00 00 00 00 	movl   $0x0,(%esi,%edx,4)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80262b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802631:	74 19                	je     80264c <init_stack+0xf8>
  802633:	68 5c 39 80 00       	push   $0x80395c
  802638:	68 6f 38 80 00       	push   $0x80386f
  80263d:	68 d9 00 00 00       	push   $0xd9
  802642:	68 e3 38 80 00       	push   $0x8038e3
  802647:	e8 dc de ff ff       	call   800528 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80264c:	8d 86 00 d0 7f ee    	lea    0xee7fd000(%esi),%eax
  802652:	89 46 fc             	mov    %eax,0xfffffffc(%esi)
	argv_store[-2] = argc;
  802655:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802658:	89 46 f8             	mov    %eax,0xfffffff8(%esi)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80265b:	8d 96 f8 cf 7f ee    	lea    0xee7fcff8(%esi),%edx
  802661:	8b 45 10             	mov    0x10(%ebp),%eax
  802664:	89 10                	mov    %edx,(%eax)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802666:	83 ec 0c             	sub    $0xc,%esp
  802669:	6a 07                	push   $0x7
  80266b:	68 00 d0 bf ee       	push   $0xeebfd000
  802670:	ff 75 08             	pushl  0x8(%ebp)
  802673:	68 00 00 40 00       	push   $0x400000
  802678:	6a 00                	push   $0x0
  80267a:	e8 b2 e9 ff ff       	call   801031 <sys_page_map>
  80267f:	89 c3                	mov    %eax,%ebx
  802681:	83 c4 20             	add    $0x20,%esp
  802684:	85 c0                	test   %eax,%eax
  802686:	78 1d                	js     8026a5 <init_stack+0x151>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802688:	83 ec 08             	sub    $0x8,%esp
  80268b:	68 00 00 40 00       	push   $0x400000
  802690:	6a 00                	push   $0x0
  802692:	e8 dc e9 ff ff       	call   801073 <sys_page_unmap>
  802697:	89 c3                	mov    %eax,%ebx
  802699:	83 c4 10             	add    $0x10,%esp
		goto error;

	return 0;
  80269c:	ba 00 00 00 00       	mov    $0x0,%edx
  8026a1:	85 c0                	test   %eax,%eax
  8026a3:	79 11                	jns    8026b6 <init_stack+0x162>

error:
	sys_page_unmap(0, UTEMP);
  8026a5:	83 ec 08             	sub    $0x8,%esp
  8026a8:	68 00 00 40 00       	push   $0x400000
  8026ad:	6a 00                	push   $0x0
  8026af:	e8 bf e9 ff ff       	call   801073 <sys_page_unmap>
	return r;
  8026b4:	89 da                	mov    %ebx,%edx
}
  8026b6:	89 d0                	mov    %edx,%eax
  8026b8:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8026bb:	5b                   	pop    %ebx
  8026bc:	5e                   	pop    %esi
  8026bd:	5f                   	pop    %edi
  8026be:	c9                   	leave  
  8026bf:	c3                   	ret    

008026c0 <map_segment>:

static int
map_segment(envid_t child, uintptr_t va, size_t memsz, 
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	57                   	push   %edi
  8026c4:	56                   	push   %esi
  8026c5:	53                   	push   %ebx
  8026c6:	83 ec 0c             	sub    $0xc,%esp
  8026c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026cc:	8b 7d 18             	mov    0x18(%ebp),%edi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8026cf:	89 f3                	mov    %esi,%ebx
  8026d1:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  8026d7:	74 0a                	je     8026e3 <map_segment+0x23>
		va -= i;
  8026d9:	29 de                	sub    %ebx,%esi
		memsz += i;
  8026db:	01 5d 10             	add    %ebx,0x10(%ebp)
		filesz += i;
  8026de:	01 df                	add    %ebx,%edi
		fileoffset -= i;
  8026e0:	29 5d 1c             	sub    %ebx,0x1c(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8026e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026e8:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8026eb:	0f 83 3a 01 00 00    	jae    80282b <map_segment+0x16b>
		if (i >= filesz) {
  8026f1:	39 fb                	cmp    %edi,%ebx
  8026f3:	72 22                	jb     802717 <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8026f5:	83 ec 04             	sub    $0x4,%esp
  8026f8:	ff 75 20             	pushl  0x20(%ebp)
  8026fb:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8026fe:	50                   	push   %eax
  8026ff:	ff 75 08             	pushl  0x8(%ebp)
  802702:	e8 e7 e8 ff ff       	call   800fee <sys_page_alloc>
  802707:	83 c4 10             	add    $0x10,%esp
  80270a:	85 c0                	test   %eax,%eax
  80270c:	0f 89 0a 01 00 00    	jns    80281c <map_segment+0x15c>
				return r;
  802712:	e9 19 01 00 00       	jmp    802830 <map_segment+0x170>
		} else {
			// from file
			if (perm & PTE_W) {
  802717:	f6 45 20 02          	testb  $0x2,0x20(%ebp)
  80271b:	0f 84 ac 00 00 00    	je     8027cd <map_segment+0x10d>
				// must make a copy so it can be writable
				if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802721:	83 ec 04             	sub    $0x4,%esp
  802724:	6a 07                	push   $0x7
  802726:	68 00 00 40 00       	push   $0x400000
  80272b:	6a 00                	push   $0x0
  80272d:	e8 bc e8 ff ff       	call   800fee <sys_page_alloc>
  802732:	83 c4 10             	add    $0x10,%esp
  802735:	85 c0                	test   %eax,%eax
  802737:	0f 88 f3 00 00 00    	js     802830 <map_segment+0x170>
					return r;
				if ((r = seek(fd, fileoffset + i)) < 0)
  80273d:	83 ec 08             	sub    $0x8,%esp
  802740:	8b 45 1c             	mov    0x1c(%ebp),%eax
  802743:	01 d8                	add    %ebx,%eax
  802745:	50                   	push   %eax
  802746:	ff 75 14             	pushl  0x14(%ebp)
  802749:	e8 11 f4 ff ff       	call   801b5f <seek>
  80274e:	83 c4 10             	add    $0x10,%esp
  802751:	85 c0                	test   %eax,%eax
  802753:	0f 88 d7 00 00 00    	js     802830 <map_segment+0x170>
					return r;
				if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802759:	89 fa                	mov    %edi,%edx
  80275b:	29 da                	sub    %ebx,%edx
  80275d:	b8 00 10 00 00       	mov    $0x1000,%eax
  802762:	39 d0                	cmp    %edx,%eax
  802764:	76 02                	jbe    802768 <map_segment+0xa8>
  802766:	89 d0                	mov    %edx,%eax
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	50                   	push   %eax
  80276c:	68 00 00 40 00       	push   $0x400000
  802771:	ff 75 14             	pushl  0x14(%ebp)
  802774:	e8 84 f2 ff ff       	call   8019fd <read>
  802779:	83 c4 10             	add    $0x10,%esp
  80277c:	85 c0                	test   %eax,%eax
  80277e:	0f 88 ac 00 00 00    	js     802830 <map_segment+0x170>
					return r;
				if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802784:	83 ec 0c             	sub    $0xc,%esp
  802787:	ff 75 20             	pushl  0x20(%ebp)
  80278a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80278d:	50                   	push   %eax
  80278e:	ff 75 08             	pushl  0x8(%ebp)
  802791:	68 00 00 40 00       	push   $0x400000
  802796:	6a 00                	push   $0x0
  802798:	e8 94 e8 ff ff       	call   801031 <sys_page_map>
  80279d:	83 c4 20             	add    $0x20,%esp
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	79 15                	jns    8027b9 <map_segment+0xf9>
					panic("spawn: sys_page_map data: %e", r);
  8027a4:	50                   	push   %eax
  8027a5:	68 20 39 80 00       	push   $0x803920
  8027aa:	68 0e 01 00 00       	push   $0x10e
  8027af:	68 e3 38 80 00       	push   $0x8038e3
  8027b4:	e8 6f dd ff ff       	call   800528 <_panic>
				sys_page_unmap(0, UTEMP);
  8027b9:	83 ec 08             	sub    $0x8,%esp
  8027bc:	68 00 00 40 00       	push   $0x400000
  8027c1:	6a 00                	push   $0x0
  8027c3:	e8 ab e8 ff ff       	call   801073 <sys_page_unmap>
  8027c8:	83 c4 10             	add    $0x10,%esp
  8027cb:	eb 4f                	jmp    80281c <map_segment+0x15c>
			} else {
				// can map buffer cache read only
				if ((r = read_map(fd, fileoffset + i, &blk)) < 0)
  8027cd:	83 ec 04             	sub    $0x4,%esp
  8027d0:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8027d3:	50                   	push   %eax
  8027d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8027d7:	01 d8                	add    %ebx,%eax
  8027d9:	50                   	push   %eax
  8027da:	ff 75 14             	pushl  0x14(%ebp)
  8027dd:	e8 11 f6 ff ff       	call   801df3 <read_map>
  8027e2:	83 c4 10             	add    $0x10,%esp
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	78 47                	js     802830 <map_segment+0x170>
					return r;
				if ((r = sys_page_map(0, blk, child, (void*) (va + i), perm)) < 0)
  8027e9:	83 ec 0c             	sub    $0xc,%esp
  8027ec:	ff 75 20             	pushl  0x20(%ebp)
  8027ef:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8027f2:	50                   	push   %eax
  8027f3:	ff 75 08             	pushl  0x8(%ebp)
  8027f6:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8027f9:	6a 00                	push   $0x0
  8027fb:	e8 31 e8 ff ff       	call   801031 <sys_page_map>
  802800:	83 c4 20             	add    $0x20,%esp
  802803:	85 c0                	test   %eax,%eax
  802805:	79 15                	jns    80281c <map_segment+0x15c>
					panic("spawn: sys_page_map text: %e", r);
  802807:	50                   	push   %eax
  802808:	68 3d 39 80 00       	push   $0x80393d
  80280d:	68 15 01 00 00       	push   $0x115
  802812:	68 e3 38 80 00       	push   $0x8038e3
  802817:	e8 0c dd ff ff       	call   800528 <_panic>
  80281c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802822:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802825:	0f 82 c6 fe ff ff    	jb     8026f1 <map_segment+0x31>
			}
		}
	}
	return 0;
  80282b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802830:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802833:	5b                   	pop    %ebx
  802834:	5e                   	pop    %esi
  802835:	5f                   	pop    %edi
  802836:	c9                   	leave  
  802837:	c3                   	ret    

00802838 <copy_shared_pages>:

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child) {
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
  80283b:	57                   	push   %edi
  80283c:	56                   	push   %esi
  80283d:	53                   	push   %ebx
  80283e:	83 ec 0c             	sub    $0xc,%esp
  // LAB 7: Your code here.

  int i,j, r;
  void* va;

  for (i=0; i < VPD(UTOP); i++) {
  802841:	be 00 00 00 00       	mov    $0x0,%esi
    if (vpd[i] & PTE_P) {
  802846:	8b 04 b5 00 d0 7b ef 	mov    0xef7bd000(,%esi,4),%eax
  80284d:	a8 01                	test   $0x1,%al
  80284f:	74 68                	je     8028b9 <copy_shared_pages+0x81>
      for (j=0; j<NPTENTRIES && i*NPDENTRIES+j < (UXSTACKTOP-PGSIZE)/PGSIZE; j++) { // make sure not to remap exception stack this way
  802851:	bb 00 00 00 00       	mov    $0x0,%ebx
  802856:	89 f0                	mov    %esi,%eax
  802858:	c1 e0 0a             	shl    $0xa,%eax
  80285b:	89 c2                	mov    %eax,%edx
  80285d:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  802862:	77 55                	ja     8028b9 <copy_shared_pages+0x81>
  802864:	89 c7                	mov    %eax,%edi
        if ((vpt[i*NPDENTRIES+j] & (PTE_P | PTE_SHARE)) == (PTE_P | PTE_SHARE)) {
  802866:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
  802869:	8b 04 8d 00 00 40 ef 	mov    0xef400000(,%ecx,4),%eax
  802870:	25 01 04 00 00       	and    $0x401,%eax
  802875:	3d 01 04 00 00       	cmp    $0x401,%eax
  80287a:	75 28                	jne    8028a4 <copy_shared_pages+0x6c>
          va = (void *)((i*NPDENTRIES+j) << PGSHIFT);
  80287c:	89 ca                	mov    %ecx,%edx
  80287e:	c1 e2 0c             	shl    $0xc,%edx
          if ((r = sys_page_map(0, va, child, va, vpt[i*NPDENTRIES+j] & PTE_USER)) < 0) {
  802881:	83 ec 0c             	sub    $0xc,%esp
  802884:	8b 04 8d 00 00 40 ef 	mov    0xef400000(,%ecx,4),%eax
  80288b:	25 07 0e 00 00       	and    $0xe07,%eax
  802890:	50                   	push   %eax
  802891:	52                   	push   %edx
  802892:	ff 75 08             	pushl  0x8(%ebp)
  802895:	52                   	push   %edx
  802896:	6a 00                	push   $0x0
  802898:	e8 94 e7 ff ff       	call   801031 <sys_page_map>
  80289d:	83 c4 20             	add    $0x20,%esp
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	78 23                	js     8028c7 <copy_shared_pages+0x8f>
  8028a4:	43                   	inc    %ebx
  8028a5:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
  8028ab:	7f 0c                	jg     8028b9 <copy_shared_pages+0x81>
  8028ad:	89 fa                	mov    %edi,%edx
  8028af:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
  8028b2:	3d fe eb 0e 00       	cmp    $0xeebfe,%eax
  8028b7:	76 ad                	jbe    802866 <copy_shared_pages+0x2e>
  8028b9:	46                   	inc    %esi
  8028ba:	81 fe ba 03 00 00    	cmp    $0x3ba,%esi
  8028c0:	76 84                	jbe    802846 <copy_shared_pages+0xe>
            return r;
          }
        }
      }
    }
  }

  return 0;
  8028c2:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8028c7:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  8028ca:	5b                   	pop    %ebx
  8028cb:	5e                   	pop    %esi
  8028cc:	5f                   	pop    %edi
  8028cd:	c9                   	leave  
  8028ce:	c3                   	ret    
	...

008028d0 <pipe>:
};

int
pipe(int pfd[2])
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
  8028d3:	57                   	push   %edi
  8028d4:	56                   	push   %esi
  8028d5:	53                   	push   %ebx
  8028d6:	83 ec 18             	sub    $0x18,%esp
  8028d9:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8028dc:	8d 45 f0             	lea    0xfffffff0(%ebp),%eax
  8028df:	50                   	push   %eax
  8028e0:	e8 2b ee ff ff       	call   801710 <fd_alloc>
  8028e5:	89 c3                	mov    %eax,%ebx
  8028e7:	83 c4 10             	add    $0x10,%esp
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	0f 88 25 01 00 00    	js     802a17 <pipe+0x147>
  8028f2:	83 ec 04             	sub    $0x4,%esp
  8028f5:	68 07 04 00 00       	push   $0x407
  8028fa:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8028fd:	6a 00                	push   $0x0
  8028ff:	e8 ea e6 ff ff       	call   800fee <sys_page_alloc>
  802904:	89 c3                	mov    %eax,%ebx
  802906:	83 c4 10             	add    $0x10,%esp
  802909:	85 c0                	test   %eax,%eax
  80290b:	0f 88 06 01 00 00    	js     802a17 <pipe+0x147>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802911:	83 ec 0c             	sub    $0xc,%esp
  802914:	8d 45 ec             	lea    0xffffffec(%ebp),%eax
  802917:	50                   	push   %eax
  802918:	e8 f3 ed ff ff       	call   801710 <fd_alloc>
  80291d:	89 c3                	mov    %eax,%ebx
  80291f:	83 c4 10             	add    $0x10,%esp
  802922:	85 c0                	test   %eax,%eax
  802924:	0f 88 dd 00 00 00    	js     802a07 <pipe+0x137>
  80292a:	83 ec 04             	sub    $0x4,%esp
  80292d:	68 07 04 00 00       	push   $0x407
  802932:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802935:	6a 00                	push   $0x0
  802937:	e8 b2 e6 ff ff       	call   800fee <sys_page_alloc>
  80293c:	89 c3                	mov    %eax,%ebx
  80293e:	83 c4 10             	add    $0x10,%esp
  802941:	85 c0                	test   %eax,%eax
  802943:	0f 88 be 00 00 00    	js     802a07 <pipe+0x137>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802949:	83 ec 0c             	sub    $0xc,%esp
  80294c:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  80294f:	e8 94 ed ff ff       	call   8016e8 <fd2data>
  802954:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802956:	83 c4 0c             	add    $0xc,%esp
  802959:	68 07 04 00 00       	push   $0x407
  80295e:	50                   	push   %eax
  80295f:	6a 00                	push   $0x0
  802961:	e8 88 e6 ff ff       	call   800fee <sys_page_alloc>
  802966:	89 c3                	mov    %eax,%ebx
  802968:	83 c4 10             	add    $0x10,%esp
  80296b:	85 c0                	test   %eax,%eax
  80296d:	0f 88 84 00 00 00    	js     8029f7 <pipe+0x127>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802973:	83 ec 0c             	sub    $0xc,%esp
  802976:	68 07 04 00 00       	push   $0x407
  80297b:	83 ec 0c             	sub    $0xc,%esp
  80297e:	ff 75 ec             	pushl  0xffffffec(%ebp)
  802981:	e8 62 ed ff ff       	call   8016e8 <fd2data>
  802986:	83 c4 10             	add    $0x10,%esp
  802989:	50                   	push   %eax
  80298a:	6a 00                	push   $0x0
  80298c:	56                   	push   %esi
  80298d:	6a 00                	push   $0x0
  80298f:	e8 9d e6 ff ff       	call   801031 <sys_page_map>
  802994:	89 c3                	mov    %eax,%ebx
  802996:	83 c4 20             	add    $0x20,%esp
  802999:	85 c0                	test   %eax,%eax
  80299b:	78 4c                	js     8029e9 <pipe+0x119>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  80299d:	8b 15 60 70 80 00    	mov    0x807060,%edx
  8029a3:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8029a6:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8029a8:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  8029ab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8029b2:	8b 15 60 70 80 00    	mov    0x807060,%edx
  8029b8:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8029bb:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8029bd:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8029c0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8029c7:	83 ec 0c             	sub    $0xc,%esp
  8029ca:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  8029cd:	e8 2e ed ff ff       	call   801700 <fd2num>
  8029d2:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8029d4:	83 c4 04             	add    $0x4,%esp
  8029d7:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8029da:	e8 21 ed ff ff       	call   801700 <fd2num>
  8029df:	89 47 04             	mov    %eax,0x4(%edi)
	return 0;
  8029e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e7:	eb 30                	jmp    802a19 <pipe+0x149>

    err3:
	sys_page_unmap(0, va);
  8029e9:	83 ec 08             	sub    $0x8,%esp
  8029ec:	56                   	push   %esi
  8029ed:	6a 00                	push   $0x0
  8029ef:	e8 7f e6 ff ff       	call   801073 <sys_page_unmap>
  8029f4:	83 c4 10             	add    $0x10,%esp
    err2:
	sys_page_unmap(0, fd1);
  8029f7:	83 ec 08             	sub    $0x8,%esp
  8029fa:	ff 75 ec             	pushl  0xffffffec(%ebp)
  8029fd:	6a 00                	push   $0x0
  8029ff:	e8 6f e6 ff ff       	call   801073 <sys_page_unmap>
  802a04:	83 c4 10             	add    $0x10,%esp
    err1:
	sys_page_unmap(0, fd0);
  802a07:	83 ec 08             	sub    $0x8,%esp
  802a0a:	ff 75 f0             	pushl  0xfffffff0(%ebp)
  802a0d:	6a 00                	push   $0x0
  802a0f:	e8 5f e6 ff ff       	call   801073 <sys_page_unmap>
  802a14:	83 c4 10             	add    $0x10,%esp
    err:
	return r;
  802a17:	89 d8                	mov    %ebx,%eax
}
  802a19:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802a1c:	5b                   	pop    %ebx
  802a1d:	5e                   	pop    %esi
  802a1e:	5f                   	pop    %edi
  802a1f:	c9                   	leave  
  802a20:	c3                   	ret    

00802a21 <_pipeisclosed>:

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802a21:	55                   	push   %ebp
  802a22:	89 e5                	mov    %esp,%ebp
  802a24:	57                   	push   %edi
  802a25:	56                   	push   %esi
  802a26:	53                   	push   %ebx
  802a27:	83 ec 0c             	sub    $0xc,%esp
  802a2a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802a2d:	a1 80 70 80 00       	mov    0x807080,%eax
  802a32:	8b 70 58             	mov    0x58(%eax),%esi
		ret = pageref(fd) == pageref(p);
  802a35:	83 ec 0c             	sub    $0xc,%esp
  802a38:	ff 75 08             	pushl  0x8(%ebp)
  802a3b:	e8 d4 03 00 00       	call   802e14 <pageref>
  802a40:	89 c3                	mov    %eax,%ebx
  802a42:	89 3c 24             	mov    %edi,(%esp)
  802a45:	e8 ca 03 00 00       	call   802e14 <pageref>
  802a4a:	83 c4 10             	add    $0x10,%esp
  802a4d:	39 c3                	cmp    %eax,%ebx
  802a4f:	0f 94 c0             	sete   %al
  802a52:	0f b6 d0             	movzbl %al,%edx
		nn = env->env_runs;
  802a55:	8b 0d 80 70 80 00    	mov    0x807080,%ecx
  802a5b:	8b 41 58             	mov    0x58(%ecx),%eax
		if (n == nn)
  802a5e:	39 c6                	cmp    %eax,%esi
  802a60:	74 1b                	je     802a7d <_pipeisclosed+0x5c>
			return ret;
		if (n != nn && ret == 1)
  802a62:	83 fa 01             	cmp    $0x1,%edx
  802a65:	75 c6                	jne    802a2d <_pipeisclosed+0xc>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802a67:	6a 01                	push   $0x1
  802a69:	8b 41 58             	mov    0x58(%ecx),%eax
  802a6c:	50                   	push   %eax
  802a6d:	56                   	push   %esi
  802a6e:	68 87 39 80 00       	push   $0x803987
  802a73:	e8 a0 db ff ff       	call   800618 <cprintf>
  802a78:	83 c4 10             	add    $0x10,%esp
  802a7b:	eb b0                	jmp    802a2d <_pipeisclosed+0xc>
	}
}
  802a7d:	89 d0                	mov    %edx,%eax
  802a7f:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802a82:	5b                   	pop    %ebx
  802a83:	5e                   	pop    %esi
  802a84:	5f                   	pop    %edi
  802a85:	c9                   	leave  
  802a86:	c3                   	ret    

00802a87 <pipeisclosed>:

int
pipeisclosed(int fdnum)
{
  802a87:	55                   	push   %ebp
  802a88:	89 e5                	mov    %esp,%ebp
  802a8a:	83 ec 10             	sub    $0x10,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a8d:	8d 45 fc             	lea    0xfffffffc(%ebp),%eax
  802a90:	50                   	push   %eax
  802a91:	ff 75 08             	pushl  0x8(%ebp)
  802a94:	e8 d1 ec ff ff       	call   80176a <fd_lookup>
  802a99:	83 c4 10             	add    $0x10,%esp
		return r;
  802a9c:	89 c2                	mov    %eax,%edx
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	78 19                	js     802abb <pipeisclosed+0x34>
	p = (struct Pipe*) fd2data(fd);
  802aa2:	83 ec 0c             	sub    $0xc,%esp
  802aa5:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802aa8:	e8 3b ec ff ff       	call   8016e8 <fd2data>
	return _pipeisclosed(fd, p);
  802aad:	83 c4 08             	add    $0x8,%esp
  802ab0:	50                   	push   %eax
  802ab1:	ff 75 fc             	pushl  0xfffffffc(%ebp)
  802ab4:	e8 68 ff ff ff       	call   802a21 <_pipeisclosed>
  802ab9:	89 c2                	mov    %eax,%edx
}
  802abb:	89 d0                	mov    %edx,%eax
  802abd:	c9                   	leave  
  802abe:	c3                   	ret    

00802abf <piperead>:

static ssize_t
piperead(struct Fd *fd, void *vbuf, size_t n, off_t offset)
{
  802abf:	55                   	push   %ebp
  802ac0:	89 e5                	mov    %esp,%ebp
  802ac2:	57                   	push   %edi
  802ac3:	56                   	push   %esi
  802ac4:	53                   	push   %ebx
  802ac5:	83 ec 18             	sub    $0x18,%esp
  802ac8:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*)fd2data(fd);
  802acb:	57                   	push   %edi
  802acc:	e8 17 ec ff ff       	call   8016e8 <fd2data>
  802ad1:	89 c3                	mov    %eax,%ebx
	if (debug)
  802ad3:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] piperead %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad9:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802adc:	be 00 00 00 00       	mov    $0x0,%esi
  802ae1:	3b 75 10             	cmp    0x10(%ebp),%esi
  802ae4:	73 55                	jae    802b3b <piperead+0x7c>
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
  802ae6:	8b 03                	mov    (%ebx),%eax
  802ae8:	3b 43 04             	cmp    0x4(%ebx),%eax
  802aeb:	75 2c                	jne    802b19 <piperead+0x5a>
  802aed:	85 f6                	test   %esi,%esi
  802aef:	74 04                	je     802af5 <piperead+0x36>
  802af1:	89 f0                	mov    %esi,%eax
  802af3:	eb 48                	jmp    802b3d <piperead+0x7e>
  802af5:	83 ec 08             	sub    $0x8,%esp
  802af8:	53                   	push   %ebx
  802af9:	57                   	push   %edi
  802afa:	e8 22 ff ff ff       	call   802a21 <_pipeisclosed>
  802aff:	83 c4 10             	add    $0x10,%esp
  802b02:	85 c0                	test   %eax,%eax
  802b04:	74 07                	je     802b0d <piperead+0x4e>
  802b06:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0b:	eb 30                	jmp    802b3d <piperead+0x7e>
  802b0d:	e8 bd e4 ff ff       	call   800fcf <sys_yield>
  802b12:	8b 03                	mov    (%ebx),%eax
  802b14:	3b 43 04             	cmp    0x4(%ebx),%eax
  802b17:	74 d4                	je     802aed <piperead+0x2e>
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802b19:	8b 13                	mov    (%ebx),%edx
  802b1b:	89 d0                	mov    %edx,%eax
  802b1d:	85 d2                	test   %edx,%edx
  802b1f:	79 03                	jns    802b24 <piperead+0x65>
  802b21:	8d 42 1f             	lea    0x1f(%edx),%eax
  802b24:	83 e0 e0             	and    $0xffffffe0,%eax
  802b27:	29 c2                	sub    %eax,%edx
  802b29:	8a 44 13 08          	mov    0x8(%ebx,%edx,1),%al
  802b2d:	8b 55 f0             	mov    0xfffffff0(%ebp),%edx
  802b30:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802b33:	ff 03                	incl   (%ebx)
  802b35:	46                   	inc    %esi
  802b36:	3b 75 10             	cmp    0x10(%ebp),%esi
  802b39:	72 ab                	jb     802ae6 <piperead+0x27>
	}
	return i;
  802b3b:	89 f0                	mov    %esi,%eax
}
  802b3d:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802b40:	5b                   	pop    %ebx
  802b41:	5e                   	pop    %esi
  802b42:	5f                   	pop    %edi
  802b43:	c9                   	leave  
  802b44:	c3                   	ret    

00802b45 <pipewrite>:

static ssize_t
pipewrite(struct Fd *fd, const void *vbuf, size_t n, off_t offset)
{
  802b45:	55                   	push   %ebp
  802b46:	89 e5                	mov    %esp,%ebp
  802b48:	57                   	push   %edi
  802b49:	56                   	push   %esi
  802b4a:	53                   	push   %ebx
  802b4b:	83 ec 18             	sub    $0x18,%esp
  802b4e:	8b 7d 08             	mov    0x8(%ebp),%edi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	(void) offset;	// shut up compiler

	p = (struct Pipe*) fd2data(fd);
  802b51:	57                   	push   %edi
  802b52:	e8 91 eb ff ff       	call   8016e8 <fd2data>
  802b57:	89 c3                	mov    %eax,%ebx
	if (debug)
  802b59:	83 c4 10             	add    $0x10,%esp
		cprintf("[%08x] pipewrite %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
  802b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b5f:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
	for (i = 0; i < n; i++) {
  802b62:	be 00 00 00 00       	mov    $0x0,%esi
  802b67:	3b 75 10             	cmp    0x10(%ebp),%esi
  802b6a:	73 55                	jae    802bc1 <pipewrite+0x7c>
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
  802b6c:	8b 03                	mov    (%ebx),%eax
  802b6e:	83 c0 20             	add    $0x20,%eax
  802b71:	39 43 04             	cmp    %eax,0x4(%ebx)
  802b74:	72 27                	jb     802b9d <pipewrite+0x58>
  802b76:	83 ec 08             	sub    $0x8,%esp
  802b79:	53                   	push   %ebx
  802b7a:	57                   	push   %edi
  802b7b:	e8 a1 fe ff ff       	call   802a21 <_pipeisclosed>
  802b80:	83 c4 10             	add    $0x10,%esp
  802b83:	85 c0                	test   %eax,%eax
  802b85:	74 07                	je     802b8e <pipewrite+0x49>
  802b87:	b8 00 00 00 00       	mov    $0x0,%eax
  802b8c:	eb 35                	jmp    802bc3 <pipewrite+0x7e>
  802b8e:	e8 3c e4 ff ff       	call   800fcf <sys_yield>
  802b93:	8b 03                	mov    (%ebx),%eax
  802b95:	83 c0 20             	add    $0x20,%eax
  802b98:	39 43 04             	cmp    %eax,0x4(%ebx)
  802b9b:	73 d9                	jae    802b76 <pipewrite+0x31>
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802b9d:	8b 53 04             	mov    0x4(%ebx),%edx
  802ba0:	89 d0                	mov    %edx,%eax
  802ba2:	85 d2                	test   %edx,%edx
  802ba4:	79 03                	jns    802ba9 <pipewrite+0x64>
  802ba6:	8d 42 1f             	lea    0x1f(%edx),%eax
  802ba9:	83 e0 e0             	and    $0xffffffe0,%eax
  802bac:	29 c2                	sub    %eax,%edx
  802bae:	8b 4d f0             	mov    0xfffffff0(%ebp),%ecx
  802bb1:	8a 04 31             	mov    (%ecx,%esi,1),%al
  802bb4:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802bb8:	ff 43 04             	incl   0x4(%ebx)
  802bbb:	46                   	inc    %esi
  802bbc:	3b 75 10             	cmp    0x10(%ebp),%esi
  802bbf:	72 ab                	jb     802b6c <pipewrite+0x27>
	}
	
	return i;
  802bc1:	89 f0                	mov    %esi,%eax
}
  802bc3:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802bc6:	5b                   	pop    %ebx
  802bc7:	5e                   	pop    %esi
  802bc8:	5f                   	pop    %edi
  802bc9:	c9                   	leave  
  802bca:	c3                   	ret    

00802bcb <pipestat>:

static int
pipestat(struct Fd *fd, struct Stat *stat)
{
  802bcb:	55                   	push   %ebp
  802bcc:	89 e5                	mov    %esp,%ebp
  802bce:	56                   	push   %esi
  802bcf:	53                   	push   %ebx
  802bd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802bd3:	83 ec 0c             	sub    $0xc,%esp
  802bd6:	ff 75 08             	pushl  0x8(%ebp)
  802bd9:	e8 0a eb ff ff       	call   8016e8 <fd2data>
  802bde:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802be0:	83 c4 08             	add    $0x8,%esp
  802be3:	68 9a 39 80 00       	push   $0x80399a
  802be8:	53                   	push   %ebx
  802be9:	e8 2e e0 ff ff       	call   800c1c <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802bee:	8b 46 04             	mov    0x4(%esi),%eax
  802bf1:	2b 06                	sub    (%esi),%eax
  802bf3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802bf9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c00:	00 00 00 
	stat->st_dev = &devpipe;
  802c03:	c7 83 88 00 00 00 60 	movl   $0x807060,0x88(%ebx)
  802c0a:	70 80 00 
	return 0;
}
  802c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c12:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802c15:	5b                   	pop    %ebx
  802c16:	5e                   	pop    %esi
  802c17:	c9                   	leave  
  802c18:	c3                   	ret    

00802c19 <pipeclose>:

static int
pipeclose(struct Fd *fd)
{
  802c19:	55                   	push   %ebp
  802c1a:	89 e5                	mov    %esp,%ebp
  802c1c:	53                   	push   %ebx
  802c1d:	83 ec 0c             	sub    $0xc,%esp
  802c20:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802c23:	53                   	push   %ebx
  802c24:	6a 00                	push   $0x0
  802c26:	e8 48 e4 ff ff       	call   801073 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c2b:	89 1c 24             	mov    %ebx,(%esp)
  802c2e:	e8 b5 ea ff ff       	call   8016e8 <fd2data>
  802c33:	83 c4 08             	add    $0x8,%esp
  802c36:	50                   	push   %eax
  802c37:	6a 00                	push   $0x0
  802c39:	e8 35 e4 ff ff       	call   801073 <sys_page_unmap>
}
  802c3e:	8b 5d fc             	mov    0xfffffffc(%ebp),%ebx
  802c41:	c9                   	leave  
  802c42:	c3                   	ret    
	...

00802c44 <wait>:

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802c44:	55                   	push   %ebp
  802c45:	89 e5                	mov    %esp,%ebp
  802c47:	56                   	push   %esi
  802c48:	53                   	push   %ebx
  802c49:	8b 75 08             	mov    0x8(%ebp),%esi
	volatile struct Env *e;

	assert(envid != 0);
  802c4c:	85 f6                	test   %esi,%esi
  802c4e:	75 16                	jne    802c66 <wait+0x22>
  802c50:	68 a1 39 80 00       	push   $0x8039a1
  802c55:	68 6f 38 80 00       	push   $0x80386f
  802c5a:	6a 09                	push   $0x9
  802c5c:	68 ac 39 80 00       	push   $0x8039ac
  802c61:	e8 c2 d8 ff ff       	call   800528 <_panic>
	e = &envs[ENVX(envid)];
  802c66:	89 f3                	mov    %esi,%ebx
  802c68:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802c6e:	89 d8                	mov    %ebx,%eax
  802c70:	c1 e0 07             	shl    $0x7,%eax
  802c73:	8d 98 00 00 c0 ee    	lea    0xeec00000(%eax),%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
		sys_yield();
  802c79:	8b 43 4c             	mov    0x4c(%ebx),%eax
  802c7c:	39 f0                	cmp    %esi,%eax
  802c7e:	75 1a                	jne    802c9a <wait+0x56>
  802c80:	8b 43 54             	mov    0x54(%ebx),%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	74 13                	je     802c9a <wait+0x56>
  802c87:	e8 43 e3 ff ff       	call   800fcf <sys_yield>
  802c8c:	8b 43 4c             	mov    0x4c(%ebx),%eax
  802c8f:	39 f0                	cmp    %esi,%eax
  802c91:	75 07                	jne    802c9a <wait+0x56>
  802c93:	8b 43 54             	mov    0x54(%ebx),%eax
  802c96:	85 c0                	test   %eax,%eax
  802c98:	75 ed                	jne    802c87 <wait+0x43>
}
  802c9a:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802c9d:	5b                   	pop    %ebx
  802c9e:	5e                   	pop    %esi
  802c9f:	c9                   	leave  
  802ca0:	c3                   	ret    
  802ca1:	00 00                	add    %al,(%eax)
	...

00802ca4 <set_pgfault_handler>:
//

void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802ca4:	55                   	push   %ebp
  802ca5:	89 e5                	mov    %esp,%ebp
  802ca7:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802caa:	83 3d 88 70 80 00 00 	cmpl   $0x0,0x807088
  802cb1:	75 68                	jne    802d1b <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
                // seanyliu
                if ((r = sys_page_alloc(sys_getenvid(), (void *)(UXSTACKTOP - PGSIZE), PTE_U | PTE_W | PTE_P)) < 0) {
  802cb3:	83 ec 04             	sub    $0x4,%esp
  802cb6:	6a 07                	push   $0x7
  802cb8:	68 00 f0 bf ee       	push   $0xeebff000
  802cbd:	83 ec 04             	sub    $0x4,%esp
  802cc0:	e8 eb e2 ff ff       	call   800fb0 <sys_getenvid>
  802cc5:	89 04 24             	mov    %eax,(%esp)
  802cc8:	e8 21 e3 ff ff       	call   800fee <sys_page_alloc>
  802ccd:	83 c4 10             	add    $0x10,%esp
  802cd0:	85 c0                	test   %eax,%eax
  802cd2:	79 14                	jns    802ce8 <set_pgfault_handler+0x44>
                  panic("set_pgfault_handler could not sys_page_alloc");
  802cd4:	83 ec 04             	sub    $0x4,%esp
  802cd7:	68 b8 39 80 00       	push   $0x8039b8
  802cdc:	6a 21                	push   $0x21
  802cde:	68 19 3a 80 00       	push   $0x803a19
  802ce3:	e8 40 d8 ff ff       	call   800528 <_panic>
                }
                if ((r = sys_env_set_pgfault_upcall(sys_getenvid(), &_pgfault_upcall)) < 0) {
  802ce8:	83 ec 08             	sub    $0x8,%esp
  802ceb:	68 28 2d 80 00       	push   $0x802d28
  802cf0:	83 ec 04             	sub    $0x4,%esp
  802cf3:	e8 b8 e2 ff ff       	call   800fb0 <sys_getenvid>
  802cf8:	89 04 24             	mov    %eax,(%esp)
  802cfb:	e8 39 e4 ff ff       	call   801139 <sys_env_set_pgfault_upcall>
  802d00:	83 c4 10             	add    $0x10,%esp
  802d03:	85 c0                	test   %eax,%eax
  802d05:	79 14                	jns    802d1b <set_pgfault_handler+0x77>
                  panic("set_pgfault_handler could not set pgfault upcall");
  802d07:	83 ec 04             	sub    $0x4,%esp
  802d0a:	68 e8 39 80 00       	push   $0x8039e8
  802d0f:	6a 24                	push   $0x24
  802d11:	68 19 3a 80 00       	push   $0x803a19
  802d16:	e8 0d d8 ff ff       	call   800528 <_panic>
                }
                
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	a3 88 70 80 00       	mov    %eax,0x807088
}
  802d23:	c9                   	leave  
  802d24:	c3                   	ret    
  802d25:	00 00                	add    %al,(%eax)
	...

00802d28 <_pgfault_upcall>:
.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802d28:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802d29:	a1 88 70 80 00       	mov    0x807088,%eax
	call *%eax
  802d2e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802d30:	83 c4 04             	add    $0x4,%esp
	
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
  802d33:	8b 44 24 30          	mov    0x30(%esp),%eax
        // obtain the trap-time %eip
        movl 10*4(%esp), %ebx // 10*4 because u read memory upward
  802d37:	8b 5c 24 28          	mov    0x28(%esp),%ebx
        // push on the value
        movl %ebx, -4(%eax) // move down esp and fill in the value (writes upward)
  802d3b:	89 58 fc             	mov    %ebx,0xfffffffc(%eax)

	// Restore the trap-time registers.
	// LAB 4: Your code here.
	addl $4, %esp // skip fault_va
  802d3e:	83 c4 04             	add    $0x4,%esp
	addl $4, %esp // skip tf_err (error code)
  802d41:	83 c4 04             	add    $0x4,%esp

        // pre-subtract 4 from the esp
        // not allowed to perform computations after eflags
        // because this changes eflags!
        // obtain the esp to be popped
        movl 10*4(%esp), %eax // 10*4 because u read memory upward
  802d44:	8b 44 24 28          	mov    0x28(%esp),%eax
          // PushRegs = 8, eip=1, eflags=1
        subl $4, %eax
  802d48:	83 e8 04             	sub    $0x4,%eax
        movl %eax, 10*4(%esp)
  802d4b:	89 44 24 28          	mov    %eax,0x28(%esp)

        popal // pop the PushRegs
  802d4f:	61                   	popa   

	// Restore eflags from the stack.
	// LAB 4: Your code here.
	addl $4, %esp // skip eip
  802d50:	83 c4 04             	add    $0x4,%esp

        // not allowed to perform computations after eflags
        // because this changes eflags!
        popfl // pop eflags
  802d53:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
        popl %esp
  802d54:	5c                   	pop    %esp
	// In the case of a recursive fault on the exception stack,
	// note that the word we're pushing now will fit in the
	// blank word that the kernel reserved for us.
        // canNOT perform this operation!!! no math after popfl!
        //subl $4, %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
        ret
  802d55:	c3                   	ret    
	...

00802d58 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d58:	55                   	push   %ebp
  802d59:	89 e5                	mov    %esp,%ebp
  802d5b:	56                   	push   %esi
  802d5c:	53                   	push   %ebx
  802d5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d63:	8b 75 10             	mov    0x10(%ebp),%esi
  // LAB 4: Your code here.
  //panic("ipc_recv not implemented");
  int r;
  if (pg == NULL) {
  802d66:	85 c0                	test   %eax,%eax
  802d68:	75 12                	jne    802d7c <ipc_recv+0x24>
    r = sys_ipc_recv((void *)UTOP);
  802d6a:	83 ec 0c             	sub    $0xc,%esp
  802d6d:	68 00 00 c0 ee       	push   $0xeec00000
  802d72:	e8 27 e4 ff ff       	call   80119e <sys_ipc_recv>
  802d77:	83 c4 10             	add    $0x10,%esp
  802d7a:	eb 0c                	jmp    802d88 <ipc_recv+0x30>
  } else {
    r = sys_ipc_recv(pg);
  802d7c:	83 ec 0c             	sub    $0xc,%esp
  802d7f:	50                   	push   %eax
  802d80:	e8 19 e4 ff ff       	call   80119e <sys_ipc_recv>
  802d85:	83 c4 10             	add    $0x10,%esp
  }

  if (r < 0) {
    from_env_store = 0;
    perm_store = 0;
    return r;
  802d88:	89 c2                	mov    %eax,%edx
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	78 24                	js     802db2 <ipc_recv+0x5a>
  }

  if (from_env_store != NULL) {
  802d8e:	85 db                	test   %ebx,%ebx
  802d90:	74 0a                	je     802d9c <ipc_recv+0x44>
    *from_env_store = env->env_ipc_from;
  802d92:	a1 80 70 80 00       	mov    0x807080,%eax
  802d97:	8b 40 74             	mov    0x74(%eax),%eax
  802d9a:	89 03                	mov    %eax,(%ebx)
  }
  if (perm_store != NULL) {
  802d9c:	85 f6                	test   %esi,%esi
  802d9e:	74 0a                	je     802daa <ipc_recv+0x52>
    *perm_store = env->env_ipc_perm;
  802da0:	a1 80 70 80 00       	mov    0x807080,%eax
  802da5:	8b 40 78             	mov    0x78(%eax),%eax
  802da8:	89 06                	mov    %eax,(%esi)
  }

  return env->env_ipc_value;
  802daa:	a1 80 70 80 00       	mov    0x807080,%eax
  802daf:	8b 50 70             	mov    0x70(%eax),%edx

}
  802db2:	89 d0                	mov    %edx,%eax
  802db4:	8d 65 f8             	lea    0xfffffff8(%ebp),%esp
  802db7:	5b                   	pop    %ebx
  802db8:	5e                   	pop    %esi
  802db9:	c9                   	leave  
  802dba:	c3                   	ret    

00802dbb <ipc_send>:

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
  802dbb:	55                   	push   %ebp
  802dbc:	89 e5                	mov    %esp,%ebp
  802dbe:	57                   	push   %edi
  802dbf:	56                   	push   %esi
  802dc0:	53                   	push   %ebx
  802dc1:	83 ec 0c             	sub    $0xc,%esp
  802dc4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802dc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802dca:	8b 75 14             	mov    0x14(%ebp),%esi
  // LAB 4: Your code here.
  // seanyliu
  //panic("ipc_send not implemented");
  int r;
  if (pg == NULL) {
  802dcd:	85 db                	test   %ebx,%ebx
  802dcf:	75 0a                	jne    802ddb <ipc_send+0x20>
    pg = (void *) UTOP;
  802dd1:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
    perm = 0;
  802dd6:	be 00 00 00 00       	mov    $0x0,%esi
  }
  while (1) {
    r = sys_ipc_try_send(to_env, val, pg, perm);
  802ddb:	56                   	push   %esi
  802ddc:	53                   	push   %ebx
  802ddd:	57                   	push   %edi
  802dde:	ff 75 08             	pushl  0x8(%ebp)
  802de1:	e8 95 e3 ff ff       	call   80117b <sys_ipc_try_send>
    if (r == -E_IPC_NOT_RECV) {
  802de6:	83 c4 10             	add    $0x10,%esp
  802de9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802dec:	75 07                	jne    802df5 <ipc_send+0x3a>
      sys_yield();
  802dee:	e8 dc e1 ff ff       	call   800fcf <sys_yield>
  802df3:	eb e6                	jmp    802ddb <ipc_send+0x20>
    }
    else if (r < 0) panic ("ipc_send: failed to send: %d", r);
  802df5:	85 c0                	test   %eax,%eax
  802df7:	79 12                	jns    802e0b <ipc_send+0x50>
  802df9:	50                   	push   %eax
  802dfa:	68 27 3a 80 00       	push   $0x803a27
  802dff:	6a 49                	push   $0x49
  802e01:	68 44 3a 80 00       	push   $0x803a44
  802e06:	e8 1d d7 ff ff       	call   800528 <_panic>
    else break;
  }
}
  802e0b:	8d 65 f4             	lea    0xfffffff4(%ebp),%esp
  802e0e:	5b                   	pop    %ebx
  802e0f:	5e                   	pop    %esi
  802e10:	5f                   	pop    %edi
  802e11:	c9                   	leave  
  802e12:	c3                   	ret    
	...

00802e14 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802e14:	55                   	push   %ebp
  802e15:	89 e5                	mov    %esp,%ebp
  802e17:	8b 4d 08             	mov    0x8(%ebp),%ecx
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802e1a:	89 c8                	mov    %ecx,%eax
  802e1c:	c1 e8 16             	shr    $0x16,%eax
  802e1f:	8b 04 85 00 d0 7b ef 	mov    0xef7bd000(,%eax,4),%eax
		return 0;
  802e26:	ba 00 00 00 00       	mov    $0x0,%edx
  802e2b:	a8 01                	test   $0x1,%al
  802e2d:	74 28                	je     802e57 <pageref+0x43>
	pte = vpt[VPN(v)];
  802e2f:	89 c8                	mov    %ecx,%eax
  802e31:	c1 e8 0c             	shr    $0xc,%eax
  802e34:	8b 04 85 00 00 40 ef 	mov    0xef400000(,%eax,4),%eax
	if (!(pte & PTE_P))
		return 0;
  802e3b:	ba 00 00 00 00       	mov    $0x0,%edx
  802e40:	a8 01                	test   $0x1,%al
  802e42:	74 13                	je     802e57 <pageref+0x43>
	return pages[PPN(pte)].pp_ref;
  802e44:	c1 e8 0c             	shr    $0xc,%eax
  802e47:	8d 04 40             	lea    (%eax,%eax,2),%eax
  802e4a:	c1 e0 02             	shl    $0x2,%eax
  802e4d:	66 8b 80 08 00 00 ef 	mov    0xef000008(%eax),%ax
  802e54:	0f b7 d0             	movzwl %ax,%edx
}
  802e57:	89 d0                	mov    %edx,%eax
  802e59:	c9                   	leave  
  802e5a:	c3                   	ret    
	...

00802e5c <__udivdi3>:
  802e5c:	55                   	push   %ebp
  802e5d:	89 e5                	mov    %esp,%ebp
  802e5f:	57                   	push   %edi
  802e60:	56                   	push   %esi
  802e61:	83 ec 14             	sub    $0x14,%esp
  802e64:	8b 55 14             	mov    0x14(%ebp),%edx
  802e67:	8b 75 08             	mov    0x8(%ebp),%esi
  802e6a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  802e70:	85 d2                	test   %edx,%edx
  802e72:	89 75 f0             	mov    %esi,0xfffffff0(%ebp)
  802e75:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802e78:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802e7b:	89 fe                	mov    %edi,%esi
  802e7d:	75 11                	jne    802e90 <__udivdi3+0x34>
  802e7f:	39 f8                	cmp    %edi,%eax
  802e81:	76 4d                	jbe    802ed0 <__udivdi3+0x74>
  802e83:	89 fa                	mov    %edi,%edx
  802e85:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802e88:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802e8b:	89 c7                	mov    %eax,%edi
  802e8d:	eb 09                	jmp    802e98 <__udivdi3+0x3c>
  802e8f:	90                   	nop    
  802e90:	39 7d f4             	cmp    %edi,0xfffffff4(%ebp)
  802e93:	76 17                	jbe    802eac <__udivdi3+0x50>
  802e95:	31 ff                	xor    %edi,%edi
  802e97:	90                   	nop    
  802e98:	c7 45 ec 00 00 00 00 	movl   $0x0,0xffffffec(%ebp)
  802e9f:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802ea2:	83 c4 14             	add    $0x14,%esp
  802ea5:	5e                   	pop    %esi
  802ea6:	89 f8                	mov    %edi,%eax
  802ea8:	5f                   	pop    %edi
  802ea9:	c9                   	leave  
  802eaa:	c3                   	ret    
  802eab:	90                   	nop    
  802eac:	0f bd 45 f4          	bsr    0xfffffff4(%ebp),%eax
  802eb0:	89 c7                	mov    %eax,%edi
  802eb2:	83 f7 1f             	xor    $0x1f,%edi
  802eb5:	75 4d                	jne    802f04 <__udivdi3+0xa8>
  802eb7:	3b 75 f4             	cmp    0xfffffff4(%ebp),%esi
  802eba:	77 0a                	ja     802ec6 <__udivdi3+0x6a>
  802ebc:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802ebf:	31 ff                	xor    %edi,%edi
  802ec1:	39 55 f0             	cmp    %edx,0xfffffff0(%ebp)
  802ec4:	72 d2                	jb     802e98 <__udivdi3+0x3c>
  802ec6:	bf 01 00 00 00       	mov    $0x1,%edi
  802ecb:	eb cb                	jmp    802e98 <__udivdi3+0x3c>
  802ecd:	8d 76 00             	lea    0x0(%esi),%esi
  802ed0:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	75 0e                	jne    802ee5 <__udivdi3+0x89>
  802ed7:	b8 01 00 00 00       	mov    $0x1,%eax
  802edc:	31 c9                	xor    %ecx,%ecx
  802ede:	31 d2                	xor    %edx,%edx
  802ee0:	f7 f1                	div    %ecx
  802ee2:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  802ee5:	89 f0                	mov    %esi,%eax
  802ee7:	31 d2                	xor    %edx,%edx
  802ee9:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802eec:	89 45 ec             	mov    %eax,0xffffffec(%ebp)
  802eef:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802ef2:	f7 75 e4             	divl   0xffffffe4(%ebp)
  802ef5:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  802ef8:	83 c4 14             	add    $0x14,%esp
  802efb:	89 c7                	mov    %eax,%edi
  802efd:	5e                   	pop    %esi
  802efe:	89 f8                	mov    %edi,%eax
  802f00:	5f                   	pop    %edi
  802f01:	c9                   	leave  
  802f02:	c3                   	ret    
  802f03:	90                   	nop    
  802f04:	b8 20 00 00 00       	mov    $0x20,%eax
  802f09:	29 f8                	sub    %edi,%eax
  802f0b:	89 45 e8             	mov    %eax,0xffffffe8(%ebp)
  802f0e:	89 f9                	mov    %edi,%ecx
  802f10:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802f13:	d3 e2                	shl    %cl,%edx
  802f15:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802f18:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802f1b:	d3 e8                	shr    %cl,%eax
  802f1d:	09 c2                	or     %eax,%edx
  802f1f:	89 f9                	mov    %edi,%ecx
  802f21:	d3 65 e4             	shll   %cl,0xffffffe4(%ebp)
  802f24:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802f27:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802f2a:	89 f2                	mov    %esi,%edx
  802f2c:	d3 ea                	shr    %cl,%edx
  802f2e:	89 f9                	mov    %edi,%ecx
  802f30:	d3 e6                	shl    %cl,%esi
  802f32:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802f35:	8a 4d e8             	mov    0xffffffe8(%ebp),%cl
  802f38:	d3 e8                	shr    %cl,%eax
  802f3a:	09 c6                	or     %eax,%esi
  802f3c:	89 f9                	mov    %edi,%ecx
  802f3e:	89 f0                	mov    %esi,%eax
  802f40:	f7 75 f4             	divl   0xfffffff4(%ebp)
  802f43:	89 d6                	mov    %edx,%esi
  802f45:	89 c7                	mov    %eax,%edi
  802f47:	d3 65 f0             	shll   %cl,0xfffffff0(%ebp)
  802f4a:	8b 45 e4             	mov    0xffffffe4(%ebp),%eax
  802f4d:	f7 e7                	mul    %edi
  802f4f:	39 f2                	cmp    %esi,%edx
  802f51:	77 0f                	ja     802f62 <__udivdi3+0x106>
  802f53:	0f 85 3f ff ff ff    	jne    802e98 <__udivdi3+0x3c>
  802f59:	3b 45 f0             	cmp    0xfffffff0(%ebp),%eax
  802f5c:	0f 86 36 ff ff ff    	jbe    802e98 <__udivdi3+0x3c>
  802f62:	4f                   	dec    %edi
  802f63:	e9 30 ff ff ff       	jmp    802e98 <__udivdi3+0x3c>

00802f68 <__umoddi3>:
  802f68:	55                   	push   %ebp
  802f69:	89 e5                	mov    %esp,%ebp
  802f6b:	57                   	push   %edi
  802f6c:	56                   	push   %esi
  802f6d:	83 ec 30             	sub    $0x30,%esp
  802f70:	8b 55 14             	mov    0x14(%ebp),%edx
  802f73:	8b 45 10             	mov    0x10(%ebp),%eax
  802f76:	89 d7                	mov    %edx,%edi
  802f78:	8d 4d f0             	lea    0xfffffff0(%ebp),%ecx
  802f7b:	89 c6                	mov    %eax,%esi
  802f7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	85 ff                	test   %edi,%edi
  802f85:	c7 45 e0 00 00 00 00 	movl   $0x0,0xffffffe0(%ebp)
  802f8c:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802f93:	89 4d ec             	mov    %ecx,0xffffffec(%ebp)
  802f96:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  802f99:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  802f9c:	75 3e                	jne    802fdc <__umoddi3+0x74>
  802f9e:	39 d6                	cmp    %edx,%esi
  802fa0:	0f 86 a2 00 00 00    	jbe    803048 <__umoddi3+0xe0>
  802fa6:	f7 f6                	div    %esi
  802fa8:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  802fab:	85 c9                	test   %ecx,%ecx
  802fad:	89 55 dc             	mov    %edx,0xffffffdc(%ebp)
  802fb0:	74 1b                	je     802fcd <__umoddi3+0x65>
  802fb2:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  802fb5:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  802fb8:	c7 45 e4 00 00 00 00 	movl   $0x0,0xffffffe4(%ebp)
  802fbf:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  802fc2:	8b 55 e0             	mov    0xffffffe0(%ebp),%edx
  802fc5:	8b 4d e4             	mov    0xffffffe4(%ebp),%ecx
  802fc8:	89 10                	mov    %edx,(%eax)
  802fca:	89 48 04             	mov    %ecx,0x4(%eax)
  802fcd:	8b 45 f0             	mov    0xfffffff0(%ebp),%eax
  802fd0:	8b 55 f4             	mov    0xfffffff4(%ebp),%edx
  802fd3:	83 c4 30             	add    $0x30,%esp
  802fd6:	5e                   	pop    %esi
  802fd7:	5f                   	pop    %edi
  802fd8:	c9                   	leave  
  802fd9:	c3                   	ret    
  802fda:	89 f6                	mov    %esi,%esi
  802fdc:	3b 7d cc             	cmp    0xffffffcc(%ebp),%edi
  802fdf:	76 1f                	jbe    803000 <__umoddi3+0x98>
  802fe1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe4:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  802fe7:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  802fea:	89 4d e4             	mov    %ecx,0xffffffe4(%ebp)
  802fed:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  802ff0:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  802ff3:	89 45 f0             	mov    %eax,0xfffffff0(%ebp)
  802ff6:	89 55 f4             	mov    %edx,0xfffffff4(%ebp)
  802ff9:	83 c4 30             	add    $0x30,%esp
  802ffc:	5e                   	pop    %esi
  802ffd:	5f                   	pop    %edi
  802ffe:	c9                   	leave  
  802fff:	c3                   	ret    
  803000:	0f bd c7             	bsr    %edi,%eax
  803003:	83 f0 1f             	xor    $0x1f,%eax
  803006:	89 45 d4             	mov    %eax,0xffffffd4(%ebp)
  803009:	75 61                	jne    80306c <__umoddi3+0x104>
  80300b:	39 7d cc             	cmp    %edi,0xffffffcc(%ebp)
  80300e:	77 05                	ja     803015 <__umoddi3+0xad>
  803010:	39 75 dc             	cmp    %esi,0xffffffdc(%ebp)
  803013:	72 10                	jb     803025 <__umoddi3+0xbd>
  803015:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  803018:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80301b:	29 f0                	sub    %esi,%eax
  80301d:	19 fa                	sbb    %edi,%edx
  80301f:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  803022:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  803025:	8b 55 ec             	mov    0xffffffec(%ebp),%edx
  803028:	85 d2                	test   %edx,%edx
  80302a:	74 a1                	je     802fcd <__umoddi3+0x65>
  80302c:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  80302f:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  803032:	89 45 e0             	mov    %eax,0xffffffe0(%ebp)
  803035:	89 55 e4             	mov    %edx,0xffffffe4(%ebp)
  803038:	8b 4d ec             	mov    0xffffffec(%ebp),%ecx
  80303b:	8b 45 e0             	mov    0xffffffe0(%ebp),%eax
  80303e:	8b 55 e4             	mov    0xffffffe4(%ebp),%edx
  803041:	89 01                	mov    %eax,(%ecx)
  803043:	89 51 04             	mov    %edx,0x4(%ecx)
  803046:	eb 85                	jmp    802fcd <__umoddi3+0x65>
  803048:	85 f6                	test   %esi,%esi
  80304a:	75 0b                	jne    803057 <__umoddi3+0xef>
  80304c:	b8 01 00 00 00       	mov    $0x1,%eax
  803051:	31 d2                	xor    %edx,%edx
  803053:	f7 f6                	div    %esi
  803055:	89 c6                	mov    %eax,%esi
  803057:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  80305a:	89 fa                	mov    %edi,%edx
  80305c:	f7 f6                	div    %esi
  80305e:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  803061:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  803064:	f7 f6                	div    %esi
  803066:	e9 3d ff ff ff       	jmp    802fa8 <__umoddi3+0x40>
  80306b:	90                   	nop    
  80306c:	b8 20 00 00 00       	mov    $0x20,%eax
  803071:	2b 45 d4             	sub    0xffffffd4(%ebp),%eax
  803074:	89 45 d8             	mov    %eax,0xffffffd8(%ebp)
  803077:	89 fa                	mov    %edi,%edx
  803079:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80307c:	d3 e2                	shl    %cl,%edx
  80307e:	89 f0                	mov    %esi,%eax
  803080:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  803083:	d3 e8                	shr    %cl,%eax
  803085:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  803088:	d3 e6                	shl    %cl,%esi
  80308a:	89 d7                	mov    %edx,%edi
  80308c:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  80308f:	8b 55 cc             	mov    0xffffffcc(%ebp),%edx
  803092:	09 c7                	or     %eax,%edi
  803094:	d3 ea                	shr    %cl,%edx
  803096:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  803099:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  80309c:	d3 e0                	shl    %cl,%eax
  80309e:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8030a1:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8030a4:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8030a7:	d3 e8                	shr    %cl,%eax
  8030a9:	0b 45 cc             	or     0xffffffcc(%ebp),%eax
  8030ac:	89 45 cc             	mov    %eax,0xffffffcc(%ebp)
  8030af:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8030b2:	f7 f7                	div    %edi
  8030b4:	89 55 cc             	mov    %edx,0xffffffcc(%ebp)
  8030b7:	d3 65 dc             	shll   %cl,0xffffffdc(%ebp)
  8030ba:	f7 e6                	mul    %esi
  8030bc:	3b 55 cc             	cmp    0xffffffcc(%ebp),%edx
  8030bf:	89 45 c8             	mov    %eax,0xffffffc8(%ebp)
  8030c2:	77 0a                	ja     8030ce <__umoddi3+0x166>
  8030c4:	75 12                	jne    8030d8 <__umoddi3+0x170>
  8030c6:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8030c9:	39 45 c8             	cmp    %eax,0xffffffc8(%ebp)
  8030cc:	76 0a                	jbe    8030d8 <__umoddi3+0x170>
  8030ce:	8b 4d c8             	mov    0xffffffc8(%ebp),%ecx
  8030d1:	29 f1                	sub    %esi,%ecx
  8030d3:	19 fa                	sbb    %edi,%edx
  8030d5:	89 4d c8             	mov    %ecx,0xffffffc8(%ebp)
  8030d8:	8b 45 ec             	mov    0xffffffec(%ebp),%eax
  8030db:	85 c0                	test   %eax,%eax
  8030dd:	0f 84 ea fe ff ff    	je     802fcd <__umoddi3+0x65>
  8030e3:	8b 4d cc             	mov    0xffffffcc(%ebp),%ecx
  8030e6:	8b 45 dc             	mov    0xffffffdc(%ebp),%eax
  8030e9:	2b 45 c8             	sub    0xffffffc8(%ebp),%eax
  8030ec:	19 d1                	sbb    %edx,%ecx
  8030ee:	89 4d cc             	mov    %ecx,0xffffffcc(%ebp)
  8030f1:	89 ca                	mov    %ecx,%edx
  8030f3:	8a 4d d8             	mov    0xffffffd8(%ebp),%cl
  8030f6:	d3 e2                	shl    %cl,%edx
  8030f8:	8a 4d d4             	mov    0xffffffd4(%ebp),%cl
  8030fb:	89 45 dc             	mov    %eax,0xffffffdc(%ebp)
  8030fe:	d3 e8                	shr    %cl,%eax
  803100:	09 c2                	or     %eax,%edx
  803102:	8b 45 cc             	mov    0xffffffcc(%ebp),%eax
  803105:	d3 e8                	shr    %cl,%eax
  803107:	89 55 e0             	mov    %edx,0xffffffe0(%ebp)
  80310a:	89 45 e4             	mov    %eax,0xffffffe4(%ebp)
  80310d:	e9 ad fe ff ff       	jmp    802fbf <__umoddi3+0x57>
